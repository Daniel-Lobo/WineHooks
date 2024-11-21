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

using std::string;
using std::to_string;;


WINEHOOKS WineHooks;

void glShaderSourceHook(GLuint shader_name, GLsizei count, 	const GLchar **shader_strings, 	const GLint *length)
{    
    BOOL IsVposShader = FALSE;
    if ((count == 1) && (length == nullptr))
    {
        string shader = shader_strings[0];
        size_t pos    = shader.find("vpos = floor(gl_FragCoord);");
        if (pos != string::npos)
        {
            IsVposShader = TRUE;
            shader.replace(pos, strlen("vpos = floor(gl_FragCoord);"), "vpos = floor(gl_FragCoord)/winehooks_hd_scale;");
        } else {
            size_t pos = shader.find("vpos = gl_FragCoord;");
            if (pos != string::npos)
            {
                IsVposShader = TRUE;
                shader.replace(pos, strlen("vpos = gl_FragCoord;"), "vpos = gl_FragCoord/winehooks_hd_scale;");
            }
        }  
        if (IsVposShader)
        {
            pos = shader.find("void main()");
            if (pos != string::npos)
            {
                shader.replace(pos, strlen("void main()"), "uniform vec4 winehooks_hd_scale = vec4(1.0, 1.0, 1.0, 1.0);\nvoid main()") ;
                const GLchar * s[1] = {shader.c_str()};
                return WineHooks.glShaderSource(shader_name, 1, s, nullptr);
            }
        }      
    }
    return WineHooks.glShaderSource(shader_name, count, shader_strings, length);
}

void glUseProgramHook(GLuint program)
{
    WineHooks.glUseProgram(program);
    int location = WineHooks.glGetUniformLocation(program, "winehooks_hd_scale");
    if (location == -1) return;
    float scale  = g_d3d.mScl->Get();
    float vec[4] = {scale, scale, 1.0, 1.0};    
    WineHooks.glUniform4fv(location, 1, vec);
    return;
}

PROC WINAPI wglGetProcAddressHook(LPCSTR proc)
{
    DBUG_WARN(proc);
    if (proc == nullptr) return  WineHooks.wglGetProcAddress(proc);
    string p = proc;
    if (p.find("glShaderSource") == 0)
    {
        WineHooks.glShaderSource       = (decltype(WineHooks.glShaderSource))WineHooks.wglGetProcAddress(proc);
        WineHooks.glGetUniformLocation = (decltype(WineHooks.glGetUniformLocation))WineHooks.wglGetProcAddress("glGetUniformLocation");
        WineHooks.glUniform4fv         = (decltype(WineHooks.glUniform4fv))WineHooks.wglGetProcAddress("glUniform4fv");
        return (PROC)glShaderSourceHook;
    }
    if (p.find("glUseProgram") == 0)
    {
        WineHooks.glUseProgram         = (decltype(WineHooks.glUseProgram))WineHooks.wglGetProcAddress(proc);
        WineHooks.glGetUniformLocation = (decltype(WineHooks.glGetUniformLocation))WineHooks.wglGetProcAddress("glGetUniformLocation");
        WineHooks.glUniform4fv         = (decltype(WineHooks.glUniform4fv))WineHooks.wglGetProcAddress("glUniform4fv");
        return (PROC)glUseProgramHook;
    }
    return WineHooks.wglGetProcAddress(proc);
}

VkResult __stdcall  vkGetDeviceProcAddrHook(VkDevice device, const char* pName)
{
    DBUG_WARN(pName)   
    return WineHooks.vkGetDeviceProcAddr(device, pName);
}      

wchar_t * __stdcall InitWineHoooks(wchar_t * flags)
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
    if (WineHooks.wglGetProcAddress == nullptr)
    {
        err = "GetProcAddress(wglGetProcAddress) FAILED";
        return  (wchar_t *)err.c_str();
    }    
    int hook = sethook((void**)&WineHooks.wglGetProcAddress, wglGetProcAddressHook);
    if (hook != 0)
    {
        err = "FAILED to HOOK wglGetProcAddress ";
        err += to_string(hook);
        return (wchar_t *)err.c_str();
    }      
    HMODULE h_vk = nullptr; //LoadLibraryW(L"vulkan-1.dll");
    if (h_vk != nullptr)
    {
        WineHooks.vkGetDeviceProcAddr = (decltype(WineHooks.vkGetDeviceProcAddr))GetProcAddress(h_vk, "vkGetDeviceProcAddr");
        hook = sethook((void**)&WineHooks.vkGetDeviceProcAddr, vkGetDeviceProcAddrHook);
        if (hook != 0)
        {
            err = "FAILED to HOOK vkGetDeviceProcAddr";
            err += to_string(hook);
            return (wchar_t *)err.c_str();
        } 
        DBUG_WARN("Hooked vkGetDeviceProcAddr")
    }     
    return  (wchar_t *)err.c_str();  
}

