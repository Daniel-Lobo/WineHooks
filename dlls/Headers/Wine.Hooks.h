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
#include <map>
#include "Sync.h"
using std::string;
using std::unique_ptr;

enum WINEHOOKS_POSTFX_FLAGS
{
    NONE = 0,
    XBRZ = 1
};

enum wined3d_texture_filter_type
{
    WINED3D_TEXF_NONE                       = 0,
    WINED3D_TEXF_POINT                      = 1,
    WINED3D_TEXF_LINEAR                     = 2,
    WINED3D_TEXF_ANISOTROPIC                = 3,
    WINED3D_TEXF_FLAT_CUBIC                 = 4,
    WINED3D_TEXF_GAUSSIAN_CUBIC             = 5,
    WINED3D_TEXF_PYRAMIDAL_QUAD             = 6,
    WINED3D_TEXF_GAUSSIAN_QUAD              = 7,
};

enum wined3d_sampler_state
{
    WINED3D_SAMP_ADDRESS_U                  = 1,
    WINED3D_SAMP_ADDRESS_V                  = 2,
    WINED3D_SAMP_ADDRESS_W                  = 3,
    WINED3D_SAMP_BORDER_COLOR               = 4,
    WINED3D_SAMP_MAG_FILTER                 = 5,
    WINED3D_SAMP_MIN_FILTER                 = 6,
    WINED3D_SAMP_MIP_FILTER                 = 7,
    WINED3D_SAMP_MIPMAP_LOD_BIAS            = 8,
    WINED3D_SAMP_MAX_MIP_LEVEL              = 9,
    WINED3D_SAMP_MAX_ANISOTROPY             = 10,
    WINED3D_SAMP_SRGB_TEXTURE               = 11,
    WINED3D_SAMP_ELEMENT_INDEX              = 12,
    WINED3D_SAMP_DMAP_OFFSET                = 13,
};

class WINEHOOKS
{
public:     
    SYNC::Atomic wined3d_filter_blits;
    HRESULT (__cdecl  * wined3d_device_context_blt) (LPVOID, LPVOID, UINT, LPVOID, LPVOID, UINT, LPVOID, UINT, LPVOID, UINT)    = nullptr;
    void    (__cdecl  * wined3d_stateblock_set_sampler_state)(LPVOID, UINT, wined3d_sampler_state, wined3d_texture_filter_type) = nullptr;
    HRESULT (__cdecl  * wined3d_swapchain_present)(LPVOID, const RECT *, const RECT *, HWND, unsigned int, uint32_t)            = nullptr;    
    void    (__stdcall * glDrawArrays)(GLenum,GLint, GLsizei)                                                                   = nullptr;
    unsigned int SwapInterval             = 1;
    unsigned int UsexBRz                  = 0;
    WINEHOOKS_POSTFX_FLAGS      FxFlag    = WINEHOOKS_POSTFX_FLAGS::NONE;    
    std::map<HGLRC, GLuint>    Contexts;
    unique_ptr<string>InitObjects(HGLRC context) {       
        auto err = unique_ptr<string>(new string("S_OK"));       
        return err;
    }       
    const char * frag_src   = "#version 130\n \
in vec2 crds;                                 \
uniform sampler2D tex;                        \
void main()                                   \
{                                             \
    gl_FragColor = texture(tex, vec2(1.,1.)-crds);      \
}";
    const char * vertex_src = "#version 130\n \
in vec2 position;                    \
in vec3 texCoord;                    \
out vec2 crds;                              \
void main()                                 \
{                                           \
    gl_Position.xy = position;              \
    gl_Position.zw = vec2(0.0, 1.0);        \
    crds           = texCoord.xy;           \
}";                      
};
#endif // WINEHOOKS_H