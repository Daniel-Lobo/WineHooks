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

void glShaderSourceHook(GLuint shader_name, GLsizei count, 	const GLchar **shader_strings, 	const GLint *length)
{       
    return WineHooks.glShaderSource(shader_name, count, shader_strings, length);
}

void glUseProgramHook(GLuint program)
{
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
    //OutputDebugStringA((char*)(string(proc) + ": "+ std::to_string((LONG) WineHooks.wglGetProcAddress(proc))).c_str());
    if (proc == nullptr) return  WineHooks.wglGetProcAddress(proc);
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