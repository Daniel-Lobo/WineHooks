#ifndef GL_HOOKS_H
#define GL_HOOKS_H

#include <windows.h>
#include "OpenGL/glcorearb.h"
#include "OpenGL/glext.h"
#include "OpenGL/wglext.h"
#include "collections.h"
#include <GL/gl.h>
#include "Dbug.h"

#ifdef _WIN64
#define GLNAME_TO_VOID(name) LPVOID Name = (LPVOID)((UINT64)0|name);
#else
#define GLNAME_TO_VOID(name) LPVOID Name = (LPVOID)name;
#endif

typedef struct _GLTEXTURE_ENTRY {
    GLuint pTexture;
    GLuint pReplace;
    DWORD  format;
    DWORD  channels;
    DWORD  iformat;
    DWORD  dwWidth;
    DWORD  dwHeight;
    DWORD  lPitch;
    DWORD  Align;
    DWORD  pad;
    void*  lpSurface;
}GLTEXTURE_ENTRY;
 GLTEXTURE_ENTRY * GlTexture;

typedef struct _GLHOOKS {
     // HD
    DWORD W, H, HD_W, HD_H, HD_X, ViewX;
    float scale, wide, aspec;
    GLint view_x, view_y, view_w, view_h;
    GLint scissors_x, scissors_y, scissors_w, scissors_h;
    BOOL (APIENTRY * SwapBuffers)(HDC);
    BOOL (APIENTRY * wglSwapBuffers)(HDC);
    BOOL (APIENTRY * wglSwapLayerBuffers)(HDC, UINT);
    void (APIENTRY * glViewport) (GLint,  GLint,  GLsizei,  GLsizei);
    void (APIENTRY * glScissor) (GLint,  GLint,  GLsizei,  GLsizei);
    void (APIENTRY * glBindFramebuffer)(GLenum, GLuint);
    void (APIENTRY * glBlitFramebuffer)(GLint, GLint, GLint, GLint, GLint, GLint, GLint,
                                        GLint, GLbitfield, GLenum);
    void (APIENTRY * glGetIntegerv)(GLint, GLint*);
    void (APIENTRY * glDeleteRenderbuffers)(GLsizei, const GLuint *);
    void (APIENTRY * glRenderbufferStorageMultisample)
    (GLenum, GLsizei, GLenum, GLsizei, GLsizei);
    void (APIENTRY * glRenderbufferStorage)(GLenum, GLenum, GLsizei, GLsizei);
    POINTER_DICTIONARY * RenderBuffers;
    void (APIENTRYP glTexImage2DMultisample)
    (GLenum,GLsizei,GLenum,GLsizei,GLsizei,GLboolean);
    POINTER_DICTIONARY * MultiSampledTextures;
    // Shader Compilation
    PFNGLSHADERSOURCEPROC      glShaderSource;
    PFNGLCOMPILESHADERPROC     glCompileShader;
    PFNGLGETSHADERIVPROC       glGetShaderiv;
    PFNGLGETSHADERINFOLOGPROC  glGetShaderInfoLog;
    PFNGLDELETESHADERPROC      glDeleteShader;
    PFNGLCREATESHADERPROC      glCreateShader;
    PFNGLCREATEPROGRAMPROC     glCreateProgram;
    PFNGLATTACHSHADERPROC      glAttachShader;
    PFNGLGETPROGRAMIVPROC      glGetProgramiv;
    PFNGLGETPROGRAMINFOLOGPROC glGetProgramInfoLog;
    PFNGLDELETEPROGRAMPROC     glDeleteProgram;
    PFNGLDETACHSHADERPROC      glDetachShader;
    PFNGLLINKPROGRAMPROC       glLinkProgram;
    // Draw
    PFNGLGENVERTEXARRAYSPROC          glGenVertexArrays;
    PFNGLBINDVERTEXARRAYPROC          glBindVertexArray;
    PFNGLDELETEVERTEXARRAYSPROC       glDeleteVertexArrays;
    PFNGLGENBUFFERSPROC               glGenBuffers;
    PFNGLBINDBUFFERPROC               glBindBuffer;
    PFNGLDELETEBUFFERSPROC            glDeleteBuffers;
    PFNGLBUFFERDATAPROC               glBufferData;
    PFNGLENABLEVERTEXATTRIBARRAYPROC  glEnableVertexAttribArray;
    PFNGLDRAWARRAYSPROC               glDrawArrays;
    PFNGLDISABLEVERTEXATTRIBARRAYPROC glDisableVertexAttribArray;
    PFNGLVERTEXATTRIBPOINTERPROC      glVertexAttribPointer;
    // Textswap
    void (APIENTRY *glDeleteTextures)(GLsizei, GLuint *);
    void (APIENTRY *glBindTexture)(GLuint, GLuint);
    void (APIENTRY *glTexParameterf)(GLuint, GLuint, GLfloat);
    void (APIENTRY *glTexImage2D)(GLenum,GLint,GLint,GLsizei,GLsizei,GLint, GLenum,GLenum,const GLvoid*);
    void (APIENTRY *glTexSubImage2D)(GLenum,GLint,GLint,GLint,GLsizei,GLsizei,GLenum,GLenum,const GLvoid*);
    void (APIENTRY *glCompressedTexImage2D)(GLenum,GLint,GLenum,GLsizei,GLsizei,GLint,GLsizei,const GLvoid*);
    void (APIENTRY *glGetTexImage) (GLenum, GLint, GLenum, GLenum, GLvoid *);
    void (APIENTRY *TextureFound)(const char*, GLTEXTURE_ENTRY*);
    void (APIENTRY *DumpTexture)(GLTEXTURE_ENTRY*);
    void (APIENTRY *UnpackBufferFound)(DWORD, void*);
    float  max_aniso;
    BOOL   search;
    BOOL   check_partial_updates;
    UINT   current_thumb;
    UINT   current_texture;
    GLuint current_unpackBuffer;
    DWORD  pad0;
    POINTER_DICTIONARY * glTextures;
    POINTER_DICTIONARY * unpackBuffer;    
    int                 Fltr;
    DWORD  pad1;
    void (APIENTRY *glSamplerParameteri) (GLuint, GLenum, GLint);
    void (APIENTRY *glTexParameteri) (GLenum, GLenum, GLint);
    BOOL (APIENTRY* SetPixelFormat)(HDC, int, const PIXELFORMATDESCRIPTOR*);    
} GLHOOKS ;
extern GLHOOKS * GlHooks;

class GlPixelFormat {
public:
    GlPixelFormat(GLenum frmt, GLenum type, GLint ifmt)  {
        m_fmt.clear();
        if (frmt == GL_RGB) {
           if      (type == GL_UNSIGNED_BYTE)               m_fmt.append("BGR");
           else if (type == GL_UNSIGNED_SHORT_1_5_5_5_REV)  m_fmt.append("X1RGB");
           else m_fmt.append("Unsupported format");
        } else if  (frmt == GL_BGR) {
            /*if     (type == GL_UNSIGNED_SHORT)          m_fmt.append("X16RGB");
            else*/ m_fmt.append("Unsupported format");
        } else if  (frmt == GL_RGBA) {
           if      (type == GL_UNSIGNED_BYTE)            m_fmt.append("A8BGR");
           else if (type == GL_UNSIGNED_INT_8_8_8_8_REV) m_fmt.append("A8BGR");
           else if (type == GL_UNSIGNED_SHORT_5_5_5_1)   m_fmt.append("A1RGB");
           else m_fmt.append("Unsupported format");
        } else if  (frmt == GL_BGRA) {
           if      (type == GL_UNSIGNED_INT_8_8_8_8_REV)   m_fmt.append("A8RGB");
           else if (type == GL_UNSIGNED_SHORT_1_5_5_5_REV) m_fmt.append("A1RGB");
           else m_fmt.append("Unsupported format");
        } else if  (frmt == 0 && type == 0) {
           if      (ifmt == GL_COMPRESSED_RGBA_S3TC_DXT1_EXT)       m_fmt.append("DXT1");
           else if (ifmt == GL_COMPRESSED_RGB_S3TC_DXT1_EXT )       m_fmt.append("DXT1");
           else if (ifmt == GL_COMPRESSED_SRGB_S3TC_DXT1_EXT)       m_fmt.append("DXT1");
           else if (ifmt == GL_COMPRESSED_RGBA_S3TC_DXT3_EXT)       m_fmt.append("DXT3");
           else if (ifmt == GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT3_EXT) m_fmt.append("DXT3");
           else if (ifmt == GL_COMPRESSED_RGBA_S3TC_DXT5_EXT)       m_fmt.append("DXT5");
           else if (ifmt == GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT) m_fmt.append("DXT5");
           else m_fmt.append("Unsupported format");
        } else m_fmt.append("Unsupported format");
    } std::string m_fmt;
};

class GlPitch {
public:
    GlPitch(DWORD ww, const char * pix) {
        if      ( *(DWORD*)pix == *(DWORD*)  "BGR") m_pitch = ww * 3;
        else if ( *(DWORD*)pix == *(DWORD*)"A8BGR") m_pitch = ww * 4;
        else if ( *(DWORD*)pix == *(DWORD*)"A8RGB") m_pitch = ww * 4;
        else if ( *(DWORD*)pix == *(DWORD*)"X1RGB") m_pitch = ww * 2;
        else if ( *(DWORD*)pix == *(DWORD*)"A1RGB") m_pitch = ww * 2;
        else {
            DBUG_WARN("NO PITCH");
            return;
        }
        GlHooks->glGetIntegerv(GL_UNPACK_ALIGNMENT, &m_aligment);
        m_BytesPerPixel = 8 * m_pitch/ww;
        DWORD remainder = m_pitch % m_aligment;
        if (remainder>0)  m_pitch += m_aligment - remainder;
    }
    DWORD    m_BytesPerPixel = 1;
    DWORD    m_pitch         = 0;
    GLint m_aligment         = 0;
};

class GlGLOBALS {
public:
    void Init(){
        lock = new SYNC::AtomicLock();
    }
    DWORD UpDateTextureParams(GLTEXTURE_ENTRY * t, GLsizei w, GLsizei h,
                              GLenum fmt, GLenum type, GLint ifmt, const void * pData)
    {
        GlPixelFormat pxlfmt(fmt, type, ifmt);
        GlPitch       pitch(w, pxlfmt.m_fmt.c_str());
        t->dwWidth   = w;
        t->dwHeight  = h;
        t->channels  = type;
        t->format    = fmt;
        t->lpSurface = (void*)pData;
        t->lPitch    = pitch.m_pitch;
        t->Align     = pitch.m_aligment;
        if (ifmt != 0) t->iformat = ifmt;
        if (*(DWORD*)pxlfmt.m_fmt.c_str() == *(DWORD*)"BGR")
        return *(DWORD*)"RGB"; /* dds files on' support 24 bit BGR so BGR textures are dumped as RGB */
        return *(DWORD*)pxlfmt.m_fmt.c_str();
    }
    SYNC::AtomicLock * lock                        = nullptr;
    PFNWGLCHOOSEPIXELFORMATARBPROC wglChoosePxlFmt = nullptr;
};

#endif // GL_HOOKS_H
