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
using std::string;
using std::unique_ptr;

typedef struct WINEHOOKS
{
    PROC     (WINAPI   * wglGetProcAddress)(LPCSTR)                                                                                        = nullptr;
    void     (APIENTRY * glShaderSource) (GLuint, GLsizei, const GLchar *const*, const GLint *)                                            = nullptr;    
    void     (APIENTRY * glUseProgram)(GLuint)                                                                                             = nullptr;   
    GLint    (APIENTRY * glGetUniformLocation)(GLuint, const GLchar *)                                                                     = nullptr;  
    void     (APIENTRY * glUniform4fv)(GLint, GLsizei, const GLfloat *)                                                                    = nullptr;  
    VkResult (APIENTRY * vkCreateShaderModule)(VkDevice,  const VkShaderModuleCreateInfo*, const VkAllocationCallbacks*, VkShaderModule*)  = nullptr;  
    VkResult (APIENTRY * vkGetDeviceProcAddr)(VkDevice device, const char* pName)                                                          = nullptr;       
    BOOL fix_glFragCoord                                                                                                                   = FALSE;
}_WINEHOOKS;

class OpenGlObjects
{
public:   
private:      
    GLuint  m_program       = 0;  
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