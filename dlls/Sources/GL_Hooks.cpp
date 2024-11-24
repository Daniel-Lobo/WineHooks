#include <windows.h>
#include "collections.h"
#include "OpenGL/glcorearb.h"
#include "OpenGL/glext.h"
#include "OpenGL/wglext.h"
#include <string>
#include <vector>
#include <dllmain.h>
#include "GL_Hooks.h"
#include <tlhelp32.h>
#include "sethooks.h"
#include "Sync.h"
#include <GL/gl.h>
#include "Dbug.h"
#include "D3D12Hooks.h"
#include "GDI_Hooks.h"
#include <math.h>
extern "C"{
#include "DDSurface.h"
}

GLHOOKS   * GlHooks;
GlGLOBALS GlGlobals;

extern "C" __declspec(dllexport) void InitGlHooks(GLHOOKS * swapdata, DWORD Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    GlHooks = swapdata;    
    g_d3d.Init();
    if (Flags & 0xf)
    {
        g_d3d.Setup(GlHooks->W, GlHooks->H, "InitGlHooks()");
        g_d3d.ApplyCommonHooks(0);
        g_d3d.SetReslimit(GlHooks->W, GlHooks->H);
    }
    GlGlobals.Init();
    return;
}

extern "C" __declspec(dllexport) void GlDisplayModeChanged(DWORD w, DWORD h, char * caller)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d.Setup(w, h, caller);
}

extern "C" __declspec(dllexport) char * InitGl(HWND hWin)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    PIXELFORMATDESCRIPTOR pfd = {
        sizeof(PIXELFORMATDESCRIPTOR),   // size of this pfd
        1,                     // version number
        PFD_DRAW_TO_WINDOW |   // support window
        PFD_SUPPORT_OPENGL |   // support OpenGL
        PFD_DOUBLEBUFFER,      // double buffered
        PFD_TYPE_RGBA,         // RGBA type
        24,                    // 24-bit color depth
        0, 0, 0, 0, 0, 0,      // color bits ignored
        0,                     // no alpha buffer
        0,                     // shift bit ignored
        0,                     // no accumulation buffer
        0, 0, 0, 0,            // accum bits ignored
        32,                    // 32-bit z-buffer
        0,                     // no stencil buffer
        0,                     // no auxiliary buffer
        PFD_MAIN_PLANE,        // main layer
        0,                     // reserved
        0, 0, 0                // layer masks ignored
    };

    HDC dc           = GetDC(hWin) ;
    int nPixelFormat = ChoosePixelFormat(dc, &pfd);
    if (nPixelFormat == 0) return "1";

    BOOL bResult = SetPixelFormat(dc, nPixelFormat, &pfd);
    if (!bResult) return "2";

    HGLRC m_BaseContext = wglCreateContext(dc);
    wglMakeCurrent(dc, m_BaseContext);

    GlGlobals.wglChoosePxlFmt = (PFNWGLCHOOSEPIXELFORMATARBPROC)wglGetProcAddress("wglChoosePixelFormatARB");

    ReleaseDC(hWin, dc);
    std::string ext((char*)glGetString(GL_EXTENSIONS));
    for (int i=0; i<(int)ext.length(); i++)
    {
        if ((BYTE)ext[i] == (BYTE)32)
            ext.replace(i,1,"\n");
    }
    return (char*)glGetString(GL_VERSION);
    return 0;
}

extern "C" __declspec(dllexport) BOOL __stdcall SetPixelFormatHook(HDC hdc, int format, const PIXELFORMATDESCRIPTOR* ppfd)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    int pixelAttributes[] = {
        WGL_DRAW_TO_WINDOW_ARB, GL_TRUE,
        WGL_SUPPORT_OPENGL_ARB, GL_TRUE,
        WGL_DOUBLE_BUFFER_ARB, GL_TRUE,
        WGL_PIXEL_TYPE_ARB, WGL_TYPE_RGBA_ARB,
        WGL_COLOR_BITS_ARB, 32,
        WGL_DEPTH_BITS_ARB, 24,
        WGL_STENCIL_BITS_ARB, 8,
        WGL_SAMPLE_BUFFERS_ARB, 1,
        WGL_SAMPLES_ARB, 8, 0
    };
    //
    if (GlGlobals.wglChoosePxlFmt == nullptr)
    {
        DBUG_WARN("wglGetProcAddress(\"wglChoosePixelFormatARB\") FAILED");
        return GlHooks->SetPixelFormat(hdc, format, ppfd);        
        return 0;
    }
    
    UINT fmt_count;
    int     pxlfmt;
    PIXELFORMATDESCRIPTOR new_desc;
    GlGlobals.wglChoosePxlFmt(hdc, pixelAttributes, 0, 1, &pxlfmt, &fmt_count);
    DescribePixelFormat(hdc, pxlfmt, sizeof(PIXELFORMATDESCRIPTOR), &new_desc);
    DBUG_WARN("Created Multisampled default frambuffer")
    return GlHooks->SetPixelFormat(hdc, pxlfmt, &new_desc);
    return 0;
}

extern "C" __declspec(dllexport) RECT * GlWriteOnTexture(GLuint t, wchar_t * text, UINT offset)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    static RECT fixed;
    RECT rect;
    rect.left = 0; rect.top = 0;
    GlHooks->glBindTexture(GL_TEXTURE_2D, t);
    glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, (GLint*)&rect.right);
    glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT,(GLint*)&rect.bottom);

    UINT * pData = new UINT[rect.right*rect.bottom*4];
    GDIText gdi(&rect, pData, text, __FUNCTION__);
    memcpy(&fixed, gdi.AlignTop(), sizeof(RECT));
    fixed.bottom += offset;
    fixed.top    += offset;

    GLenum err = glGetError();
    GlHooks->glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, rect.right, gdi.m_height, 0,
                          GL_RGBA, GL_UNSIGNED_INT_8_8_8_8_REV, pData+((rect.bottom-gdi.m_height)*rect.right));
    err = glGetError();
    if (err != GL_NO_ERROR)
    DBUG_WARN((std::string("GL_ERROR")+std::to_string(err)).c_str());

    delete [] pData;
    return &fixed;
}

#define GlFAILED(msg) if (glGetError()) {DBUG_WARN(msg); }
extern "C" __declspec(dllexport) GLuint GlCompileShaders(const GLchar * px_src, const GLchar * vx_src, void ** err)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    static std::vector<char> ErrorMessage;

    GLuint VertexShaderID   = GlHooks->glCreateShader(GL_VERTEX_SHADER);
    GLuint FragmentShaderID = GlHooks->glCreateShader(GL_FRAGMENT_SHADER);
    GLint Result = GL_FALSE;
    int InfoLogLength;

    GlHooks->glShaderSource(VertexShaderID, 1, &vx_src, nullptr);
    GlHooks->glCompileShader(VertexShaderID);
    GlHooks->glGetShaderiv(VertexShaderID, GL_COMPILE_STATUS, &Result);
    GlHooks->glGetShaderiv(VertexShaderID, GL_INFO_LOG_LENGTH, &InfoLogLength);
    if ( ! Result )
    {
        ErrorMessage.resize(InfoLogLength+1);
        GlHooks->glGetShaderInfoLog(VertexShaderID, InfoLogLength, NULL, &ErrorMessage[0]);
        OutputDebugStringA(&ErrorMessage[0]);
        *err = (void*)&ErrorMessage[0];
    }

    GlHooks->glShaderSource(FragmentShaderID, 1, &px_src , NULL);
    GlHooks->glCompileShader(FragmentShaderID);    
    GlHooks->glGetShaderiv(FragmentShaderID, GL_COMPILE_STATUS, &Result);
    GlHooks->glGetShaderiv(FragmentShaderID, GL_INFO_LOG_LENGTH, &InfoLogLength);
    if ( ! Result )
    {
        ErrorMessage.resize(InfoLogLength+1);
        GlHooks->glGetShaderInfoLog(FragmentShaderID, InfoLogLength, NULL, &ErrorMessage[0]);
        OutputDebugStringA(&ErrorMessage[0]);
        *err = (void*)&ErrorMessage[0];
    }

    glGetError();
    GLuint ProgramID = GlHooks->glCreateProgram();
    GlHooks->glAttachShader(ProgramID, VertexShaderID);     //GlFAILED("Attach vertex Shader") ;
    GlHooks->glAttachShader(ProgramID, FragmentShaderID);   //GlFAILED("Attach fragment Shader") ;
    GlHooks->glLinkProgram(ProgramID);                      //GlFAILED("Link program") ;

    GlHooks->glDetachShader(ProgramID, VertexShaderID);
    GlHooks->glDetachShader(ProgramID, FragmentShaderID);

    GlHooks->glDeleteShader(VertexShaderID);
    GlHooks->glDeleteShader(FragmentShaderID);

    return ProgramID;
}

extern "C" __declspec(dllexport) HRESULT GlDrawRect(RECT * rect, GLuint)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    GLuint VArray        = 0, VBuff        = 0;
    GLuint CurrentVArray = 0, CurrentVbuff = 0;
    GLint Cullstate      = 0;
    GLint Zstate         = 0;
    GLint Astate         = 0;
    GLint Atest          = 0;
    GLint Fstate         = 0;
    float x = (float)rect->left;
    float y = (float)rect->top;
    float w = (float)rect->right;
    float h = (float)rect->bottom;

    GlHooks->glGetIntegerv(GL_VERTEX_ARRAY_BINDING, (GLint*)&CurrentVArray);
    GlHooks->glGetIntegerv(GL_ARRAY_BUFFER_BINDING, (GLint*)&CurrentVbuff);

    GlHooks->glGetIntegerv(GL_CULL_FACE, &Cullstate);
    if (Cullstate) glDisable(GL_CULL_FACE);

    GlHooks->glGetIntegerv(GL_DEPTH_TEST, &Zstate);
    if (Zstate) glDisable(GL_DEPTH_TEST);

    GlHooks->glGetIntegerv(GL_BLEND, &Astate);
    if (Astate) glDisable(GL_BLEND);

    GlHooks->glGetIntegerv(GL_FOG, &Fstate);
    if (Fstate) glDisable(GL_FOG);

    GlHooks->glGenVertexArrays(1, &VArray);
    GlHooks->glBindVertexArray(VArray);

    GlHooks->glGenBuffers(1, &VBuff);
    GlHooks->glBindBuffer(GL_ARRAY_BUFFER, VBuff);
    const GLfloat g_vertex_buffer_data[] = {
       x, h, 0.0f, 0.0f, 1.0f,
       w, h, 0.0f, 1.0f, 1.0f,
       x, y, 0.0f, 0.0f, 0.0f,
       x, y, 0.0f, 0.0f, 0.0f,
       w, y, 0.0f, 1.0f, 0.0f,
       w, h, 0.0f, 1.0f, 1.0f
    };    
    GlHooks->glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data),
                          g_vertex_buffer_data, GL_STATIC_DRAW);
    GlHooks->glEnableVertexAttribArray(0);
    GlHooks->glEnableVertexAttribArray(1);
    GlHooks->glBindBuffer(GL_ARRAY_BUFFER, VBuff);
    GlHooks->glVertexAttribPointer(
       0,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
       3,                  // size
       GL_FLOAT,           // type
       GL_FALSE,           // normalized?
       sizeof(float)*5,    // stride
       (void*)0            // array buffer offset
    );
    GlHooks->glVertexAttribPointer(
       1,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
       2,                  // size
       GL_FLOAT,           // type
       GL_FALSE,           // normalized?
       sizeof(float)*5,    // stride
       (void*)(sizeof(float)*3)
    );
    GlHooks->glDrawArrays(GL_TRIANGLES, 0, 6); // Starting from vertex 0; 3 vertices total -> 1 triangle
    GlHooks->glDisableVertexAttribArray(0);
    GlHooks->glDisableVertexAttribArray(1);

    GlHooks->glBindBuffer(GL_ARRAY_BUFFER, CurrentVbuff);
    GlHooks->glBindVertexArray(CurrentVArray);

    GlHooks->glDeleteVertexArrays(1, &VArray);
    GlHooks->glDeleteBuffers(1, &VBuff);

    if (Zstate)    glEnable(GL_CULL_FACE);
    if (Cullstate) glEnable(GL_DEPTH_TEST);
    if (Astate)    glEnable(GL_BLEND);
    if (Atest)     glEnable(GL_ALPHA_TEST);
    if (Fstate)    glEnable(GL_FOG);
    return 0;
}

extern "C" __declspec(dllexport) void __stdcall GlLock(){
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    GlGlobals.lock->lock();
}

extern "C" __declspec(dllexport) void __stdcall GlUnlock(){
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    GlGlobals.lock->unlock();
}

extern "C" __declspec(dllexport) void APIENTRY glViewport_Hook(GLint x,  GLint y,  GLsizei width,  GLsizei height)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    SYNC::EasyLock lock(GlGlobals.lock);
    GlHooks->glViewport(x, y, width, height);
}

extern "C" __declspec(dllexport) void APIENTRY glScissor_Hook(GLint x,  GLint y,  GLsizei width,  GLsizei height)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    SYNC::EasyLock lock(GlGlobals.lock);
    GlHooks->glScissor(x, y, width, height);
}

extern "C" __declspec(dllexport) void APIENTRY glBindFramebuffer_Hook(GLenum target, GLuint framebuffer)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    SYNC::EasyLock lock(GlGlobals.lock);
    GlHooks->glBindFramebuffer(target, framebuffer);    
}

extern "C" __declspec(dllexport) 
void glBlitFramebuffer_Hook(GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1,
                       GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1,
                       GLbitfield mask, GLenum filter)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    SYNC::EasyLock lock(GlGlobals.lock);
    GlHooks->glBlitFramebuffer(srcX0, srcY0, srcX1, srcY1,
                               dstX0, dstY0, dstX1, dstY1,
                               mask, filter);    
}

extern "C" __declspec(dllexport) void APIENTRY glBindTexture_Hook(unsigned int target, unsigned int name)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    GLNAME_TO_VOID(name) /* Avoid conversion to greater size warning */
    GlHooks->current_texture = name;
    if (g_d3d.DBUG) {
        SHORT down = GetKeyState(VK_SHIFT) & 0x8000 ;
        if (down) {
            return GlHooks->glBindTexture(target, name);
        }
    }
    GlTexture = (GLTEXTURE_ENTRY*)GlHooks->glTextures->Value((LPVOID)Name);
    if (GlTexture == 0)
    {
        GlTexture = (GLTEXTURE_ENTRY*)VirtualAlloc(NULL, sizeof(GLTEXTURE_ENTRY)
                                      ,0x00001000 | 0x00002000, 0x04);
        GlHooks->glTextures->insert((LPVOID)Name, (LPVOID)GlTexture);
        GlTexture->pTexture = name;
        GlTexture->pReplace = name;
    }
    if ( (GlHooks->search) && (name == GlHooks->current_thumb))
       return GlHooks->glBindTexture(target, 0);
    else
        GlHooks->glBindTexture(target, (unsigned int)GlTexture->pReplace);
}

extern "C" __declspec(dllexport) void APIENTRY GetGlPixelFormat(GLenum frmt, GLenum type, GLint ifrmt, char * frmtstr)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    GlPixelFormat fmt(frmt, type, ifrmt);
    DBUG_WARN(fmt.m_fmt.c_str());
    strcpy_s (frmtstr, sizeof(char)*(strlen(fmt.m_fmt.c_str())+1), fmt.m_fmt.c_str());
    return;
}

extern "C" __declspec(dllexport) 
void APIENTRY glTexSubImage2D_Hook(GLenum target, GLint level, GLint xoffset,
                                   GLint yoffset, GLsizei width, GLsizei height,
                                   GLenum format, GLenum type, const GLvoid * pixels)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    SYNC::EasyLock lock(GlGlobals.lock);
    GLNAME_TO_VOID(GlHooks->current_texture) /* Avoid conversion to greater size warning */
    GlTexture = (GLTEXTURE_ENTRY*) GlHooks->glTextures->Value(Name);
    if (GlTexture == nullptr)
        return GlHooks->glTexSubImage2D(target, level, xoffset, yoffset, width, height, format, type, pixels);

    if (GlTexture->pReplace != GlTexture->pTexture)
    {
        GlHooks->glBindTexture(target, GlTexture->pTexture);
        if (level == 0)
        {
            glDeleteTextures(1, (const GLuint*)&GlTexture->pReplace);
            GlTexture->pReplace = GlTexture->pTexture;
        }
    }
    GlHooks->glTexSubImage2D(target, level, xoffset, yoffset, width, height, format, type, pixels);

    if (level || GlHooks->current_unpackBuffer)
    return;

    if (yoffset == 0 && xoffset == 0)
    {
        DWORD fmt         = GlGlobals.UpDateTextureParams(GlTexture, width, height, format, type, 0, pixels);
        std::string * rep = g_.FindTexture(width, height, GlTexture->lPitch, (char*)&fmt, (BYTE*)pixels);
        if      (rep)                  GlHooks->TextureFound(rep->c_str(), GlTexture);
        else if (GlHooks->DumpTexture) GlHooks->DumpTexture(GlTexture);
    }
    else if (GlHooks->check_partial_updates)
    {
        DWORD fmt            = GlGlobals.UpDateTextureParams(GlTexture, GlTexture->dwWidth, GlTexture->dwHeight, format, type, 0, pixels);
        GLvoid * pData       = malloc(GlTexture->lPitch*GlTexture->dwHeight);
        GlTexture->lpSurface = (void*)pData;
        GlHooks->glGetTexImage(target, 0, format, type, pData);
        std::string * rep    = g_.FindTexture(GlTexture->dwWidth, GlTexture->dwHeight, GlTexture->lPitch, (char*)&fmt, (BYTE*)pData);
        if      (rep)                  GlHooks->TextureFound(rep->c_str(), GlTexture);
        else if (GlHooks->DumpTexture) GlHooks->DumpTexture(GlTexture);
        free(pData);
    }
}

extern "C" __declspec(dllexport) 
void APIENTRY glTexImage2D_Hook(GLenum target, GLint level, GLint internalFormat,
                                GLsizei width, GLsizei height, GLint border,
                                GLenum format, GLenum type, const GLvoid * data)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (internalFormat == GL_RGB5_A1_EXT)
    {
       if (format == GL_RGBA && type == GL_UNSIGNED_BYTE)
       internalFormat = GL_RGBA;
    }
    if (level == 0 && GlHooks->current_unpackBuffer == 0)
    {
        SYNC::EasyLock lock(GlGlobals.lock);
        GLNAME_TO_VOID(GlHooks->current_texture) /* Avoid conversion to greater size warning */
        GlTexture = (GLTEXTURE_ENTRY*) GlHooks->glTextures->Value((LPVOID)Name);
        if (GlTexture)
        {
            if (GlTexture->pReplace != GlTexture->pTexture)
            {
                GlHooks->glBindTexture(target, (DWORD)GlTexture->pTexture);
                glDeleteTextures(1, (const GLuint*)&GlTexture->pReplace);
                GlTexture->pReplace = GlTexture->pTexture;
            }
            DWORD fmt         = GlGlobals.UpDateTextureParams(GlTexture, width, height, format, type, internalFormat, data);
            if (data)
            {
                std::string * rep = g_.FindTexture(width, height, GlTexture->lPitch, (char*)&fmt, (BYTE*)data);
                if      (rep) GlHooks->TextureFound(rep->c_str(), GlTexture);
                else if (GlHooks->DumpTexture)
                {
                    GlHooks->glTexImage2D(target, level, internalFormat, width, height, border, format, type, data);
                    GlHooks->DumpTexture(GlTexture);
                    return;
                }
            }
        }
    }
    else if (level > 0) glTexParameterf(target, GL_TEXTURE_MAX_ANISOTROPY_EXT, 16.);
    GlHooks->glTexImage2D(target, level, internalFormat,width, height, border, format, type, data);
}

extern "C" __declspec(dllexport) 
void APIENTRY glCompressedTexImage2D_Hook(GLenum trgt, GLint lvl, GLenum frmt, GLsizei w, GLsizei h,
                                          GLint brdr, GLsizei sz, const void * data)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    GLNAME_TO_VOID(GlHooks->current_texture) /* Avoid conversion to greater size warning */
    GlTexture = (GLTEXTURE_ENTRY*) GlHooks->glTextures->Value((LPVOID)Name);
    if (lvl == 0 && GlHooks->current_unpackBuffer == 0 && GlTexture)
    {
        DWORD fmt         = GlGlobals.UpDateTextureParams(GlTexture, w, h, 0, 0, frmt, data);
        std::string * rep = g_.FindTexture(w, h, GlTexture->lPitch, (char*)&fmt, (BYTE*)data);
        if      (rep) GlHooks->TextureFound(rep->c_str(), GlTexture);
        else if (GlHooks->DumpTexture)
        {
            GlHooks->glCompressedTexImage2D(trgt, lvl, frmt, w, h, brdr, sz, data);
            GlHooks->DumpTexture(GlTexture);
            return;
        }
    }
    return GlHooks->glCompressedTexImage2D(trgt, lvl, frmt, w, h, brdr, sz, data);
}

extern "C" __declspec(dllexport) void APIENTRY glTexParameteri_Hook(unsigned int tex, unsigned int param, unsigned int value)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (param == GL_TEXTURE_MAG_FILTER) value = GlHooks->Fltr;
    GlHooks->glTexParameteri(tex, param, value);
}

extern "C" __declspec(dllexport) void APIENTRY glSamplerParameteri_Hook(GLuint sampler, GLenum pname, GLint param)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (pname == GL_TEXTURE_MAG_FILTER) param = GlHooks->Fltr;
    GlHooks->glSamplerParameteri(sampler, pname, param);
}

extern "C" __declspec(dllexport) void APIENTRY glGetIntegerv_Hook(GLenum pname, GLint * data)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (pname == GL_VIEWPORT)
    {
        memcpy(data, &GlHooks->view_x, sizeof(GLint)*4);
        return;
    }
    GlHooks->glGetIntegerv(pname, data);
}

extern "C" __declspec(dllexport) void APIENTRY glRenderbufferStorage_Hook(GLenum target, GLenum internalformat, GLsizei width, GLsizei height)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    GLint rb = 0;
    glGetIntegerv(GL_RENDERBUFFER_BINDING, &rb);
    GLNAME_TO_VOID(rb) /* Avoid conversion to greater size warning */
    GlHooks->RenderBuffers->remove((void*)Name);

    GLTEXTURE_ENTRY* GLRBuff = (GLTEXTURE_ENTRY*) VirtualAlloc(NULL,  sizeof(GLTEXTURE_ENTRY),
                                                               0x00001000 | 0x00002000, 0x04);
    GlHooks->RenderBuffers->insert((LPVOID)Name, (LPVOID)GLRBuff);
    GLRBuff->pTexture = rb;
    GLRBuff->dwWidth  = width;
    GLRBuff->dwHeight = height;
    GLRBuff->iformat  = internalformat;
    GLRBuff->channels = 0;

    GlHooks->glRenderbufferStorage(target, internalformat, width, height);
}

extern "C" __declspec(dllexport) void APIENTRY
glRenderbufferStorageMultisample_Hook(GLenum target, GLenum ifrmt, GLsizei samples,
                                      GLsizei width,  GLsizei height)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    GLint rb = 0;
    glGetIntegerv(GL_RENDERBUFFER_BINDING, &rb);
    GLNAME_TO_VOID(rb) /* Avoid conversion to greater size warning */
    GlHooks->RenderBuffers->remove(Name);

    GLTEXTURE_ENTRY* GLRBuff = (GLTEXTURE_ENTRY*) VirtualAlloc(NULL,  sizeof(GLTEXTURE_ENTRY),
                                                               0x00001000 | 0x00002000, 0x04);
    GlHooks->RenderBuffers->insert((LPVOID)Name, (LPVOID)GLRBuff);
    GLRBuff->pTexture = rb;
    GLRBuff->dwWidth  = width;
    GLRBuff->dwHeight = height;
    GLRBuff->iformat  = ifrmt;
    GLRBuff->channels = samples;

    GlHooks->glRenderbufferStorageMultisample(target, samples, ifrmt, width, height);
}

extern "C" __declspec(dllexport) void APIENTRY glDeleteRenderbuffers_Hook(GLsizei n, const GLuint * buffers)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    int i;
    for (i=0; i<n; i++)
    {
        GlHooks->RenderBuffers->remove((void*)buffers);
        buffers ++;
    }
    GlHooks->glDeleteRenderbuffers(n, buffers);
}

extern "C" __declspec(dllexport) 
void APIENTRY glTexImage2DMultisample_Hook(GLenum target, GLsizei samples, GLenum internalformat,
                                           GLsizei width, GLsizei height, GLboolean fixedsamplelocations)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    float w = (float)width  * GlHooks->scale;
    float h = (float)height * GlHooks->scale;
    GlHooks->glTexImage2DMultisample(target, samples, internalformat, lround(w), lround(h),  fixedsamplelocations);
    return;

    GLint tx = 0;
    GlHooks->glTexImage2DMultisample(target, samples, internalformat, width, height,
                                     fixedsamplelocations);
    glGetIntegerv(GL_TEXTURE_BINDING_2D_MULTISAMPLE, &tx);
    GLNAME_TO_VOID(tx) /* Avoid conversion to greater size warning */
    GLTEXTURE_ENTRY* MSText = (GLTEXTURE_ENTRY*) VirtualAlloc(NULL,  sizeof(GLTEXTURE_ENTRY),
                                                              0x00001000 | 0x00002000, 0x04);
    GlHooks->MultiSampledTextures->insert(Name, (LPVOID)MSText);
    MSText->pTexture = tx;
    MSText->dwWidth  = width;
    MSText->dwHeight = height;
    MSText->iformat  = internalformat;
    MSText->channels = samples;
}
