#ifndef WINEHOOKS_H
#define WINEHOOKS_H
#include <windows.h>
#include "OpenGL/glcorearb.h"
#include "OpenGL/glext.h"
#include "OpenGL/wglext.h"
#include <GL/gl.h>
#include "sethooks.h"
#include "vulkan/vulkan.h"
#include "Dbug.h"
#include "dllmain.h"
#include <string.h>
#include <memory.h>
#include <vector>
#include "Sync.h"
using std::string;
using std::unique_ptr;

class WINEHOOKS
{
public:  
    WINEHOOKS(){
        m_Context.Set(0);
    }
    PROC    (WINAPI   * wglGetProcAddress)(LPCSTR)   = nullptr; 
    BOOL    (APIENTRY * wglDeleteContext)(HGLRC)     = nullptr;    
    BOOL    (APIENTRY * wglMakeCurrent)(HDC, HGLRC)  = nullptr;  
    PFNGLCREATESHADERPROC       glCreateShader       = nullptr;
    PFNGLSHADERSOURCEPROC       glShaderSource       = nullptr;
    PFNGLCOMPILESHADERPROC      glCompileShader      = nullptr;
    PFNGLCREATEPROGRAMPROC      glCreateProgram      = nullptr;
    PFNGLATTACHSHADERPROC       glAttachShader       = nullptr;
    PFNGLDELETESHADERPROC       glDeleteShader       = nullptr;
    PFNGLDELETEPROGRAMPROC      glDeleteProgram      = nullptr;
    PFNGLLINKPROGRAMPROC        glLinkProgram        = nullptr;
    PFNGLUSEPROGRAMPROC         glUseProgram         = nullptr;
    PFNGLGETUNIFORMLOCATIONPROC glGetUniformLocation = nullptr;
    PFNGLUNIFORM4FVPROC         glUniform4f          = nullptr;
    PFNGLGETPROGRAMIVPROC       glGetProgramiv       = nullptr;
    PFNGLGETPROGRAMINFOLOGPROC  glGetProgramInfoLog  = nullptr;
    PFNGLGETSHADERIVPROC        glGetShaderiv        = nullptr;
    PFNGLGETSHADERINFOLOGPROC   glGetShaderInfoLog   = nullptr;
    SYNC::AtomicPtr             m_Context;
    unique_ptr<string>InitObjects(HGLRC context) {
        if      (context ==  nullptr)        return unique_ptr<string>(new string("null context"));
        else if (context == m_Context.Get()) return unique_ptr<string>(new string("S_OK"));

        auto err = unique_ptr<string>(new string("S_OK"));
        if (!InitPfn((void**)&glCreateShader,       "glCreateShader"))       {*err.get() = "FAILED to get the glCreateShader funtion pointer";}       return err;
        if (!InitPfn((void**)&glShaderSource,       "glShaderSource"))       {*err.get() = "FAILED to get the glShaderSource funtion pointer";}       return err;
        if (!InitPfn((void**)&glCompileShader,      "glCompileShader"))      {*err.get() = "FAILED to get the glCompileShader funtion pointer";}      return err;
        if (!InitPfn((void**)&glCreateProgram,      "glCreateProgram"))      {*err.get() = "FAILED to get the glCreateProgram funtion pointer";}      return err;
        if (!InitPfn((void**)&glAttachShader,       "glAttachShader"))       {*err.get() = "FAILED to get the glAttachShader funtion pointer";}       return err;
        if (!InitPfn((void**)&glDeleteShader,       "glDeleteShader"))       {*err.get() = "FAILED to get the glDeleteShader funtion pointer";}       return err;
        if (!InitPfn((void**)&glDeleteProgram,      "glDeleteProgram"))      {*err.get() = "FAILED to get the glDeleteProgram funtion pointer";}      return err;
        if (!InitPfn((void**)&glLinkProgram,        "glLinkProgram"))        {*err.get() = "FAILED to get the glLinkProgram funtion pointer";}        return err;
        if (!InitPfn((void**)&glUseProgram,         "glUseProgram"))         {*err.get() = "FAILED to get the glUseProgram funtion pointer";}         return err;
        if (!InitPfn((void**)&glGetUniformLocation, "glGetUniformLocation")) {*err.get() = "FAILED to get the glGetUniformLocation funtion pointer";} return err;
        if (!InitPfn((void**)&glUniform4f,          "glUniform4f"))          {*err.get() = "FAILED to get the glUniform4f funtion pointer";}          return err;
        if (!InitPfn((void**)&glGetProgramiv,       "glGetProgramiv"))       {*err.get() = "FAILED to get the glGetProgramiv funtion pointer";}       return err;
        if (!InitPfn((void**)&glGetProgramInfoLog,  "glGetProgramInfoLog"))  {*err.get() = "FAILED to get the glGetProgramInfoLog funtion pointer";}  return err;
        if (!InitPfn((void**)&glGetShaderiv,        "glGetShaderiv"))        {*err.get() = "FAILED to get the glGetShaderiv funtion pointer";}        return err;
        if (!InitPfn((void**)&glGetShaderInfoLog,   "glGetShaderInfoLog"))   {*err.get() = "FAILED to get the glGetShaderInfoLog funtion pointer";}   return err;

        if (m_program != 0)
        {
            this->glDeleteProgram(m_program);
            m_program = 0;
        }
        err = this->CreateProgram();
        if (*err.get() == "S_OK")
        {
            m_Context.Set(context);            
        }
        return err;
    }
    unique_ptr<string>CompileShader(GLuint * shader, GLenum type, const char * src)
    {
        auto err = unique_ptr<string>(new string("S_OK"));        
        *shader  = glCreateShader(type);
        this->glShaderSource(*shader, 1, &src, nullptr);
        this->glCompileShader(*shader);
        GLint status;
        this->glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
        if (status != GL_TRUE) 
        {
            *shader = 0;  // doesn't hurt to  be sure;
            GLint length;
            this->glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &length);
            err.get()->resize(length);
            this->glGetShaderInfoLog(*shader, length, &length, (char*)err.get()->c_str());
        }
        return err;            
    }
    unique_ptr<string>CreateProgram()
    {        
        GLuint vert = 0, frag = 0;
        auto err    = this->CompileShader(&vert, GL_VERTEX_SHADER, vertex_src);
        if (*err.get() == "S_OK") return err;
        err         = this->CompileShader(&frag, GL_FRAGMENT_SHADER, frag_src);
        if (*err.get() == "S_OK") return err;
        m_program   = glCreateProgram();
        this->glAttachShader(m_program, vert);
        this->glAttachShader(m_program, frag);
        this->glLinkProgram(m_program);
        GLint status;
        this->glGetProgramiv(m_program, GL_LINK_STATUS, &status);
        if (status != GL_TRUE) 
        {
            m_program = 0;
            GLint length;
            this->glGetProgramiv(m_program, GL_INFO_LOG_LENGTH, &length);
            err.get()->resize(length);
            this->glGetProgramInfoLog(m_program, length, &length, (char*)err.get()->c_str());
            return err;
        }
        *err.get() = "S_OK";
        this->glDeleteShader(vert);
        this->glDeleteShader(frag);
        return err;        
    }
    BOOL InitPfn(void** pfn, const char * name)
    {        
        *pfn = (void*)this->wglGetProcAddress(name);
        if (*pfn == nullptr) return FALSE;
        return TRUE;
    }
private:      
    GLuint  m_program       = 0;  
    const char * frag_src   = "#version 130 \
in vec2 crds;                               \
texture sampler2D tex;                      \
void main()                                 \
{                                           \
    gl_FragColor = texture(tex, crds);      \
}";
    const char * vertex_src = "#version 130 \
attribute vec2 position;                    \
attribute vec3 texCoord;                    \
out vec2 crds;                              \
void main()                                 \
{                                           \
    gl_Position.xy = position               \
    gl_Position.zw = vec2(0.0, 1.0);        \
    crds           = texCoord.xy;           \
}";                      
};
#endif // WINEHOOKS_H