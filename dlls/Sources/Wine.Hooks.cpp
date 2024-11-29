#include <windows.h>
#include "OpenGL/glcorearb.h"
#include "OpenGL/glext.h"
#include "OpenGL/wglext.h"
#include <GL/gl.h>
#include "sethooks.h"
#include "Wine.Hooks.h"
#include "dllmain.h"
#include "Dbug.h"
#include <string.h>
#include "D3D12Hooks.h"
#include "DirectDraw.h"
using std::string;
using std::to_string;;


WINEHOOKS WineHooks;

#define WINE_HOOKS_GL_CALL(call) call; if (glGetError() != GL_NO_ERROR) \
{DBUG_WARN(#call " FAILED"); return WineHooks.glBlitFramebuffer(srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, GL_NEAREST);}

void glBlitFramebufferHook(GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0,	GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask,	GLenum filter)
{
    if (WineHooks.FxFlag == WINEHOOKS_POSTFX_FLAGS::XBRZ)
    {
        WineHooks.FxFlag              = WINEHOOKS_POSTFX_FLAGS::NONE;
        GLuint curr_draw_frame_buffer = 0xf;
        WINE_HOOKS_GL_CALL( glGetIntegerv(GL_DRAW_FRAMEBUFFER_BINDING, (GLint*)&curr_draw_frame_buffer) )
        if (curr_draw_frame_buffer == 0)
        {
            GLuint curr_program           = 0;
            GLuint curr_read_frame_buffer = 0;
            GLuint curr_2d_textture       = 0;
            GLuint temp_texture_2d        = 0;
            GLuint curr_vertex_array      = 0;
            GLuint curr_vertex_buffer     = 0;
            GLuint temp_vertex_array      = 0;
            GLuint temp_vertex_buffer     = 0;
            GLint Cullstate               = 0;
            GLint Zstate                  = 0;
            GLint Astate                  = 0;
            GLint Atest                   = 0;
            GLint Fstate                  = 0;   
            GLint viweport[4]     = {0,0,0,0};  
            GLint scisor[4]       = {0,0,0,0};       

            DWORD w = dstX1-dstX0;
            DWORD h = dstY1-dstY0;    
            float W = (float)w;
            float H = (float)h;       

            WINE_HOOKS_GL_CALL( glGetIntegerv(GL_VIEWPORT, viweport)  )
            WINE_HOOKS_GL_CALL( glGetIntegerv(GL_SCISSOR_BOX, scisor) )

            WINE_HOOKS_GL_CALL(Cullstate = glIsEnabled(GL_CULL_FACE)  )
            WINE_HOOKS_GL_CALL(Zstate    = glIsEnabled(GL_DEPTH_TEST) )
            WINE_HOOKS_GL_CALL(Astate    = glIsEnabled(GL_BLEND)      )
            WINE_HOOKS_GL_CALL( Atest    = glIsEnabled(GL_ALPHA_TEST) )
            WINE_HOOKS_GL_CALL(Fstate    = glIsEnabled(GL_FOG)        )

            WINE_HOOKS_GL_CALL( glGetIntegerv(GL_VERTEX_ARRAY_BINDING, (GLint*)&curr_vertex_array)          )
            WINE_HOOKS_GL_CALL( glGetIntegerv(GL_ARRAY_BUFFER_BINDING, (GLint*)&curr_vertex_buffer)         )
            WINE_HOOKS_GL_CALL( glGetIntegerv(GL_READ_FRAMEBUFFER_BINDING, (GLint*)&curr_read_frame_buffer) )
            WINE_HOOKS_GL_CALL( glGetIntegerv(GL_DRAW_FRAMEBUFFER_BINDING, (GLint*)&curr_draw_frame_buffer) )
            WINE_HOOKS_GL_CALL( glGetIntegerv(GL_TEXTURE_2D, (GLint*)&curr_2d_textture)                     )  
            WINE_HOOKS_GL_CALL( glGetIntegerv(GL_PROGRAM, (GLint*)&curr_program)                            )      

            WINE_HOOKS_GL_CALL( glGenTextures(1, &temp_texture_2d) )
            WINE_HOOKS_GL_CALL( glBindTexture(GL_TEXTURE_2D, temp_texture_2d) )
            WINE_HOOKS_GL_CALL( glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, nullptr) )    

            WINE_HOOKS_GL_CALL( WineHooks.glGenVertexArrays(1, &temp_vertex_array) )
            WINE_HOOKS_GL_CALL( WineHooks.glBindVertexArray(temp_vertex_array) )

            WINE_HOOKS_GL_CALL( WineHooks.glGenBuffers(1, &temp_vertex_buffer) )
            WINE_HOOKS_GL_CALL( WineHooks.glBindBuffer(GL_ARRAY_BUFFER, temp_vertex_buffer) )     

            struct blit_vertex
            {
                float x, y, u, v ,w;                
            } quad[4];                       

            quad[0].x = 0 * 2.0f / W - 1.0f;
            quad[0].y = 0 * 2.0f / H - 1.0f;
            quad[0].u = 0.f;
            quad[0].v = 0.f;
            quad[0].w = 1.f;     
          
            quad[1].x = w * 2.0f / W - 1.0f;
            quad[1].y = 0 * 2.0f / H - 1.0f;
            quad[1].u = 1.f;
            quad[1].v = 0.f;
            quad[1].w = 1.f;            

            quad[2].x = 0 * 2.0f / W - 1.0f;
            quad[2].y = h * 2.0f / H - 1.0f;
            quad[2].u = 0.f;
            quad[2].v = 1.f;
            quad[2].w = 1.f;            

            quad[3].x = w * 2.0f / w - 1.0f;
            quad[3].y = h * 2.0f / h - 1.0f;
            quad[3].u = 1.f;
            quad[3].v = 1.f;
            quad[3].w = 1.f;  

            WINE_HOOKS_GL_CALL( WineHooks.glEnableVertexAttribArray(0) )
            WINE_HOOKS_GL_CALL( WineHooks.glEnableVertexAttribArray(1) )

            WINE_HOOKS_GL_CALL( WineHooks.glVertexAttribPointer(0, GL_FLOAT, sizeof(float)*2, FALSE, sizeof(quad), 0) )
            WINE_HOOKS_GL_CALL( WineHooks.glVertexAttribPointer(0, GL_FLOAT, sizeof(float)*3, FALSE, sizeof(quad), sizeof(float)*2) )
            WINE_HOOKS_GL_CALL( WineHooks.glBufferData(GL_ARRAY_BUFFER, sizeof(quad), &quad, GL_STATIC_DRAW) )

            WINE_HOOKS_GL_CALL( glDrawArrays(GL_TRIANGLE_STRIP, 0, 4) )
        }
    }
    return WineHooks.glBlitFramebuffer(srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, GL_NEAREST);
}

void glShaderSourceHook(GLuint shader_name, GLsizei count, 	const GLchar **shader_strings, 	const GLint *length)
{       
    return WineHooks.glShaderSource(shader_name, count, shader_strings, length);
}

void glUseProgramHook(GLuint program)
{    
    //return WineHooks.glUseProgram(WineHooks.m_program);
    return WineHooks.glUseProgram(program);   
}

BOOL APIENTRY wglMakeCurrentHook(HDC dc, HGLRC context)
{
    BOOL success = WineHooks.wglMakeCurrent(dc, context);
    if (success == TRUE)
    {
        auto err   = WineHooks.InitObjects(context);
        *err.get() = "dc = " + to_string((ULONG)dc) + ", context = " + to_string((ULONG)context) + ", InitObjects: " + *err.get();
        DBUG_WARN((char*)err.get()->c_str());
    }
    return success;
}

PROC WINAPI wglGetProcAddressHook(LPCSTR proc)
{
    //OutputDebugStringA((char*)(string(proc) + ": "+ std::to_string((LONG) WineHooks.wglGetProcAddress(proc)) + "->" + to_string(string(proc).find("glUseProgram"))).c_str());
    if (proc == nullptr) return  WineHooks.wglGetProcAddress(proc);
    /*
    if (string(proc).find("glUseProgram") == 0)
    {
        WineHooks.glUseProgram = (decltype(WineHooks.glUseProgram))WineHooks.wglGetProcAddress(proc);
        OutputDebugStringA("Hooked");
        return (PROC) &glUseProgramHook;        
    } 
    */
    if (string(proc).find("glBlitFramebuffer") == 0)
    {
        WineHooks.glBlitFramebuffer = (decltype(WineHooks.glBlitFramebuffer))WineHooks.wglGetProcAddress(proc);
        OutputDebugStringA("glBlitFramebuffer");
        return (PROC) glBlitFramebufferHook;        
    } 
    return WineHooks.wglGetProcAddress(proc);       
} 

extern "C" __declspec(dllexport) wchar_t * __stdcall InitWineHoooks(wchar_t * flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    static string err = "S_OK";
    HMODULE h_gl      = LoadLibraryW(L"opengl32.dll");
    if (h_gl == nullptr)
    {
        err = "LoadLibraryW(opengl32.dll) FAILED";
        return (wchar_t *)err.c_str(); 
    }
    WineHooks.wglGetProcAddress = (decltype(WineHooks.wglGetProcAddress))GetProcAddress(h_gl, "wglGetProcAddress");
    WineHooks.wglMakeCurrent    = (decltype(WineHooks.wglMakeCurrent))GetProcAddress(h_gl, "wglMakeCurrent");
    if (WineHooks.wglGetProcAddress == nullptr)
    {
        err = "GetProcAddress(wglGetProcAddress) FAILED";
        return  (wchar_t *)err.c_str();
    }   
    if (WineHooks.wglMakeCurrent == nullptr)
    {
        err = "GetProcAddress(wglMakeCurrent) FAILED";
        return  (wchar_t *)err.c_str();
    } 
    int hook = sethook((void**)&WineHooks.wglGetProcAddress, (void*)wglGetProcAddressHook);
    if (hook != 0)
    {
        err = "FAILED to HOOK wglGetProcAddress ";
        err += to_string(hook);
        return (wchar_t *)err.c_str();
    } 
    hook = sethook((void**)&WineHooks.wglMakeCurrent, (void*)wglMakeCurrentHook);
    if (hook != 0)
    {
        err = "FAILED to HOOK wglMakeCurrent ";
        err += to_string(hook);
        return (wchar_t *)err.c_str();
    }
    return (wchar_t *)err.c_str();     
}
// cs. wined3d_cs_exec_blt_sub_resource
// surface.c texture2d_blt
// glsl_shader.c glsl_blitter_blit
// context.gl.c wined3d_context_gl_draw_shaded_quad