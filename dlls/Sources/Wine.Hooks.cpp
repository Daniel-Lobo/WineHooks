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
#include <tuple>
using std::string;
using std::to_string;
using std::tuple;
using std::unique_ptr;


WINEHOOKS WineHooks;

#define WINE_HOOKS_GL_CALL(call) call; if (glGetError() != GL_NO_ERROR) \
{DBUG_WARN(#call " FAILED")}

tuple<string, GLuint>WineHooks_CreatexBRzProgram(const char * vertex_shader, const char * fragment_shader){
    auto context             = wglGetCurrentContext();
    if (nullptr == context)
    {
        DBUG_WARN("wglGetCurrentContext() FAILED");
        return {"wglGetCurrentContext() FAILED", 0};
    }

    auto glCreateShader      = (PFNGLCREATESHADERPROC)wglGetProcAddress("glCreateShader");
    auto glShaderSource      = (PFNGLSHADERSOURCEPROC)wglGetProcAddress("glShaderSource");
    auto glCompileShader     = (PFNGLCOMPILESHADERPROC)wglGetProcAddress("glCompileShader");
    auto glGetShaderiv       = (PFNGLGETSHADERIVPROC)wglGetProcAddress("glGetShaderiv");
    auto glGetShaderInfoLog  = (PFNGLGETSHADERINFOLOGPROC)wglGetProcAddress("glGetShaderInfoLog");
    auto glCreateProgram     = (PFNGLCREATEPROGRAMPROC)wglGetProcAddress("glCreateProgram");
    auto glAttachShader      = (PFNGLATTACHSHADERPROC)wglGetProcAddress("glAttachShader");
    auto glLinkProgram       = (PFNGLLINKPROGRAMPROC)wglGetProcAddress("glLinkProgram");
    auto glGetProgramiv      = (PFNGLGETPROGRAMIVPROC)wglGetProcAddress("glGetProgramiv");
    auto glGetProgramInfoLog = (PFNGLGETPROGRAMINFOLOGPROC)wglGetProcAddress("glGetProgramInfoLog");

    if (!glCreateShader  || !glShaderSource || !glCompileShader || !glGetShaderiv  || !glGetShaderInfoLog ||
        !glCreateProgram || !glAttachShader || !glLinkProgram   || !glGetProgramiv || !glGetProgramInfoLog)
    {
        DBUG_WARN("wglGetProcAddress() FAILED");
        return {"wglGetProcAddress() FAILED", 0};
    }

    GLuint vertex_shader_id   = glCreateShader(GL_VERTEX_SHADER);
    GLuint fragment_shader_id = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(vertex_shader_id, 1, &vertex_shader, nullptr);
    glCompileShader(vertex_shader_id);
    GLint compile_status = 0;
    glGetShaderiv(vertex_shader_id, GL_COMPILE_STATUS, &compile_status);
    if (compile_status == GL_FALSE)
    {
        GLint log_length = 0;
        glGetShaderiv(vertex_shader_id, GL_INFO_LOG_LENGTH, &log_length);
        unique_ptr<char[]> log(new char[log_length]);
        glGetShaderInfoLog(vertex_shader_id, log_length, nullptr, log.get());
        DBUG_WARN((string("glCompileShader() FAILED: ") + log.get()).c_str());
        return {string("glCompileShader() FAILED: ") + log.get(), 0};
    }
    glShaderSource(fragment_shader_id, 1, &fragment_shader, nullptr);
    glCompileShader(fragment_shader_id);
    glGetShaderiv(fragment_shader_id, GL_COMPILE_STATUS, &compile_status);
    if (compile_status == GL_FALSE)
    {
        GLint log_length = 0;
        glGetShaderiv(fragment_shader_id, GL_INFO_LOG_LENGTH, &log_length);
        unique_ptr<char[]> log(new char[log_length]);
        glGetShaderInfoLog(fragment_shader_id, log_length, nullptr, log.get());
        DBUG_WARN((string("glCompileShader() FAILED: ") + log.get()).c_str());
        return {string("glCompileShader() FAILED: ") + log.get(), 0};
    }
    GLuint program_id = glCreateProgram();
    glAttachShader(program_id, vertex_shader_id);
    glAttachShader(program_id, fragment_shader_id);
    glLinkProgram(program_id);
    GLint link_status = 0;
    glGetProgramiv(program_id, GL_LINK_STATUS, &link_status);
    if (link_status == GL_FALSE)
    {
        GLint log_length = 0;
        glGetProgramiv(program_id, GL_INFO_LOG_LENGTH, &log_length);
        unique_ptr<char[]> log(new char[log_length]);
        glGetProgramInfoLog(program_id, log_length, nullptr, log.get());
        DBUG_WARN((string("glLinkProgram() FAILED: ") + log.get()).c_str());
        return {string("glLinkProgram() FAILED: ") + log.get(), 0};
    }
    return {string("S_OK"), program_id};
}

string WineHooks_ReadxBRzShaderFile(){
    std::string src(g_.Path());
    src.append("\\Shaders\\xBRz.glsl");    ;
    FILE* fp = std::fopen(src.c_str(), "r");  
    if (fp == nullptr)
    {
        string err = "Could not open:" + src;
        DBUG_WARN(err.c_str());
        return err;
    }    
    string source;
    char a;
    
    while ((a = std::fgetc(fp)) != EOF)
        source.append(1, (char)a);
    std::fclose(fp);
    //DBUG_WARN((string("xBRz Shader: ") + source).c_str());

    return source;
}

void glDrawArraysHook(GLenum mode, GLint first,	GLsizei count){
    if (WineHooks.UsexBRz == 0) return WineHooks.glDrawArrays(mode, first, count); // No xBRZ
    auto context = wglGetCurrentContext();
    if (WineHooks.Contexts.find(context) == WineHooks.Contexts.end())
    {
        auto frag_src = WineHooks_ReadxBRzShaderFile();        
        auto [err, program] = WineHooks_CreatexBRzProgram(WineHooks.vertex_src, frag_src.c_str());

        WineHooks.Contexts.insert({context, program});
        DBUG_WARN((string("Created Program for context: ") + to_string((uintptr_t)context) + " " + err).c_str());                
    } else {
        auto program = WineHooks.Contexts[context];
        if (program != 0)
        {
            auto h_gl                 = GetModuleHandleA("Opengl32.dll");
            auto glGetUniformLocation = (PFNGLGETUNIFORMLOCATIONPROC)wglGetProcAddress("glGetUniformLocation");
            auto glUniform2f          = (PFNGLUNIFORM2FPROC)wglGetProcAddress("glUniform2f");
            auto glGetIntegerv        = (PFNGLGETINTEGERVPROC)GetProcAddress(h_gl,"glGetIntegerv");
            auto glGetFloatv          = (PFNGLGETFLOATVPROC)GetProcAddress(h_gl, "glGetFloatv");
            auto glGetTexLvlParameiv  = (PFNGLGETTEXLEVELPARAMETERIVPROC)GetProcAddress(h_gl, "glGetTexLevelParameteriv");
            auto glUseProgram         = (PFNGLUSEPROGRAMPROC)wglGetProcAddress("glUseProgram");            
            if (glGetUniformLocation   == nullptr || glUniform2f == nullptr || glGetIntegerv == nullptr || glUseProgram == nullptr 
                || glGetTexLvlParameiv == nullptr)
            {
                DBUG_WARN("wglGetProcAddress() FAILED");                
                WineHooks.UsexBRz = 0;                
                return WineHooks.glDrawArrays(mode, first, count);
            }
            GLfloat viewport[4] = {0.f, 0.f, 0.f, 0.f};
            glGetFloatv(GL_VIEWPORT, viewport);
            GLuint curr_text = 0, text_width = 0, texture_height = 0;
            glGetIntegerv(GL_TEXTURE_BINDING_2D, (GLint *)&curr_text);
            glGetTexLvlParameiv( GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, (GLint *)&text_width);
            glGetTexLvlParameiv( GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, (GLint *)&texture_height);
            DBUG_WARN((string("glDrawArraysHook: curr_text: ") + to_string(curr_text) + " text_width: " + to_string(text_width) + " texture_height: " + to_string(texture_height)).c_str());

            auto OutputSize  = glGetUniformLocation(program, "OutputSize"); 
            auto InputSize   = glGetUniformLocation(program, "InputSize");
            auto TextureSize = glGetUniformLocation(program, "TextureSize");            
            glUseProgram(program);           
            float hd_w = (float)viewport[2];;
            float hd_h = (float)viewport[3]; 
            float w    = (float)text_width;
            float h    = (float)texture_height;           

            if (OutputSize  != -1) WINE_HOOKS_GL_CALL(glUniform2f(OutputSize, hd_w, hd_h));            
            if (TextureSize != -1) WINE_HOOKS_GL_CALL(glUniform2f(TextureSize,w, h));            
        }
    }  
    WineHooks.UsexBRz = 0;
    return WineHooks.glDrawArrays(mode, first, count); 
}

extern "C" __declspec(dllexport) HRESULT SetWineD3DUsexBRz()
{
    WineHooks.UsexBRz = 1;
    return WineHooks.UsexBRz;
}

extern "C"  __declspec(dllexport) HRESULT SetWineD3DFilterBlits()
{
    WineHooks.wined3d_filter_blits.Set(1);
    return 1;
}

extern "C" __declspec(dllexport) HRESULT SetWineSwapIntervalHRF()
{
    WineHooks.SwapInterval = 2;
    return WineHooks.SwapInterval;
}

HRESULT __cdecl  wined3d_swapchain_present_hook(LPVOID swap_chain, const RECT * src, const RECT * dest, HWND win, unsigned int swap_interval, uint32_t flags)  {
    return WineHooks.wined3d_swapchain_present(swap_chain, src, dest, win, swap_interval, flags);
}

HRESULT __cdecl wined3d_device_context_blt_hook(LPVOID dcv_ctxt, LPVOID dst_srfc, UINT dst_srfc_index, LPVOID dst_rect, 
LPVOID src_srfc, UINT src_srfc_index, LPVOID src_rect, UINT flags, LPVOID fx, UINT){
    wined3d_texture_filter_type filter = WineHooks.wined3d_filter_blits.Get() == 1 ? WINED3D_TEXF_LINEAR : WINED3D_TEXF_NONE; 
    auto err = WineHooks.wined3d_device_context_blt(dcv_ctxt, dst_srfc, dst_srfc_index, dst_rect, src_srfc, src_srfc_index, src_rect, flags, fx, filter);
    if (filter == WINED3D_TEXF_LINEAR)
    WineHooks.wined3d_filter_blits.Set(0);
    return err;
}

void __cdecl wined3d_stateblock_set_sampler_state_hook(LPVOID p_stablock, UINT index, wined3d_sampler_state state, wined3d_texture_filter_type value){
    WineHooks.wined3d_stateblock_set_sampler_state(p_stablock, index, state, value);
    WineHooks.wined3d_stateblock_set_sampler_state(p_stablock, index, WINED3D_SAMP_MAG_FILTER, WINED3D_TEXF_POINT);
    WineHooks.wined3d_stateblock_set_sampler_state(p_stablock, index, WINED3D_SAMP_MIN_FILTER, WINED3D_TEXF_ANISOTROPIC);
    WineHooks.wined3d_stateblock_set_sampler_state(p_stablock, index, WINED3D_SAMP_MIP_FILTER, WINED3D_TEXF_LINEAR);
    WineHooks.wined3d_stateblock_set_sampler_state(p_stablock, index, WINED3D_SAMP_MAX_ANISOTROPY, static_cast<wined3d_texture_filter_type>(16.f));
}

extern "C"  __declspec(dllexport) wchar_t * __stdcall InitDDrawWineHoooks(wchar_t * flags){
    static string err = "S_OK";
    HMODULE h_wined3d = GetModuleHandleA("wined3d.dll");
    if (h_wined3d == nullptr)
    {
        err = "GetModuleHandleA(wined3d.dll) FAILED";
        return (wchar_t *)err.c_str(); 
    }
    WineHooks.wined3d_device_context_blt = (decltype(WineHooks.wined3d_device_context_blt))GetProcAddress(h_wined3d, "wined3d_device_context_blt");
    if (WineHooks.wined3d_device_context_blt == nullptr)
    {
        err = "GetProcAddress(wined3d_device_context_blt) FAILED";
        return  (wchar_t *)err.c_str();
    }   
    int hook = sethook((void**)&WineHooks.wined3d_device_context_blt, (void*)wined3d_device_context_blt_hook);
    if (hook != 0)
    {
        err = "FAILED to HOOK wined3d_device_context_blt ";
        err += to_string(hook);
        return (wchar_t *)err.c_str();
    } 
    WineHooks.wined3d_stateblock_set_sampler_state = (decltype(WineHooks.wined3d_stateblock_set_sampler_state))GetProcAddress(h_wined3d, "wined3d_stateblock_set_sampler_state");
    if (WineHooks.wined3d_stateblock_set_sampler_state == nullptr)
    {
        err = "GetProcAddress(wined3d_stateblock_set_sampler_state) FAILED";
        return  (wchar_t *)err.c_str();
    }   
    hook = sethook((void**)&WineHooks.wined3d_stateblock_set_sampler_state, (void*)wined3d_stateblock_set_sampler_state_hook);
    if (hook != 0)
    {
        err = "FAILED to HOOK wined3d_stateblock_set_sampler_state ";
        err += to_string(hook);
        return (wchar_t *)err.c_str();
    } 
    //return  (wchar_t *) err.c_str();  

    auto h_gl              = GetModuleHandleA("opengl32.dll");
    WineHooks.glDrawArrays = (decltype(WineHooks.glDrawArrays))GetProcAddress(h_gl, "glDrawArrays");
    if (WineHooks.glDrawArrays == nullptr)
    {
        err = "GetProcAddress(glDrawArrays) FAILED";
        return  (wchar_t *)err.c_str();
    }   
    hook = sethook((void**)&WineHooks.glDrawArrays, (void*)glDrawArraysHook);
    if (hook != 0)
    {
        err = "FAILED to HOOK glDrawArrays ";
        err += to_string(hook);
        return (wchar_t *)err.c_str();
    }
    return  (wchar_t *) err.c_str();    
}

extern "C" __declspec(dllexport) wchar_t * __stdcall InitWineHoooks(wchar_t * flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    static string err = "S_OK";    
    return (wchar_t *)err.c_str();     
}
// cs. wined3d_cs_exec_blt_sub_resource
// surface.c texture2d_blt
// glsl_shader.c glsl_blitter_blit
// context.gl.c wined3d_context_gl_draw_shaded_quad