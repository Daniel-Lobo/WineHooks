#include <windows.h>
#include "OpenGL/glcorearb.h"
#include "OpenGL/glext.h"
#include "OpenGL/wglext.h"
#include <GL/gl.h>
#include "sethooks.h"
#include "vulkan/vulkan.h"

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