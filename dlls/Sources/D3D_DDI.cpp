#include <windows.h>
#include "D3D_DDI.h"
#include "Sync.h"
#include "D3D9Hooks.h"
#include "Dbug.h"
#include <string>
#include "collections.h"

#include <d3d9types.h>
#include "d3dumddi.h"
#include "dllmain.h"
#include "sethooks.h"

struct G_D3DDDI_HOOKS {
    D3DDDI_DEVICEFUNCS                                            device;
    SYNC::Atomic                      * AreVerticesTransformed = nullptr;
    HANDLE                                      hCurrentDevice = nullptr;
    HANDLE                                      hOverride      = nullptr;
    HANDLE                                      hLastShader    = nullptr;
    DWORD                                             max_filter     = 0;
    DWORD                                             force_aniso    = 0;
    DWORD                                              force_wfog    = 0;
    DWORD                                             colorkey_fix   = 0;
    DWORD                                        monitor_vertex_decl = 0;
    DWORD                                             sync           = 0;
    BOOL                                              is_hooks_pass  = FALSE;
    BOOL                                         hooks_linear_filter = FALSE;
    HRESULT (APIENTRY * OpenAdapter)            (D3DDDIARG_OPENADAPTER*);
    HRESULT (APIENTRY * Createdevice)(HANDLE , D3DDDIARG_CREATEDEVICE *);   
};
G_D3DDDI_HOOKS g_d3d_ddi_hooks;

typedef struct SHADERDECL {
    HANDLE hShader              = nullptr;
    BOOL AreVerticesTransformed = 0;
};

BOOL AreVerticesTransFormed()
{
    if (g_d3d_ddi_hooks.AreVerticesTransformed == nullptr) return TRUE;
    return g_d3d_ddi_hooks.AreVerticesTransformed->Get();
}

void d3dddiSetOverride(HANDLE hOverride)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d_ddi_hooks.hOverride = hOverride;
    if (hOverride)g_d3d_ddi_hooks.device.pfnSetPixelShader(g_d3d_ddi_hooks.hCurrentDevice, hOverride);
}

HRESULT d3dddiSetpixelshaderconst(HANDLE, const D3DDDIARG_SETPIXELSHADERCONST *Param2, const FLOAT *Param3)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    return g_d3d_ddi_hooks.device.pfnSetPixelShaderConst(g_d3d_ddi_hooks.hCurrentDevice, Param2, Param3);
}

HANDLE d3dddiCreateVxShader(const UINT* Bytecode, UINT size)
{
    D3DDDIARG_CREATEVERTEXSHADERFUNC arg;
    arg.Size = size;
    if (g_d3d_ddi_hooks.device.pfnCreateVertexShaderFunc(g_d3d_ddi_hooks.hCurrentDevice, &arg, Bytecode) == 0)
    {
        DBUG_LOG("OK =)");
        return arg.ShaderHandle;
    }
    DBUG_WARN("FAILED");
    return 0;
}

void d3dddiDeleteVxShader(HANDLE hShader)
{
    if (g_d3d_ddi_hooks.device.pfnDeletePixelShader(g_d3d_ddi_hooks.hCurrentDevice, hShader) != S_OK)
    DBUG_WARN("FAILED")
    else DBUG_LOG("OK =)");
}

HANDLE d3dddiCreatePxShader(const UINT * Bytecode, UINT size)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3DDDIARG_CREATEPIXELSHADER arg;
    arg.CodeSize = size;
    if (g_d3d_ddi_hooks.device.pfnCreatePixelShader(g_d3d_ddi_hooks.hCurrentDevice,
                                                    &arg, Bytecode) == 0)
    {
        DBUG_LOG("OK =)");
        return arg.ShaderHandle;
    }
    DBUG_LOG("FAILED");
    return 0;
}

void d3dddiDeletePxShader(HANDLE hShader)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (g_d3d_ddi_hooks.device.pfnDeletePixelShader(g_d3d_ddi_hooks.hCurrentDevice, hShader) != S_OK)
    DBUG_LOG("FAILED")
    else DBUG_LOG("OK =)");
}

void d3dddiSetHooksPass(BOOL state) {
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d_ddi_hooks.is_hooks_pass = state;
}

void d3dddiSetMaxFilter(DWORD state) {
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d_ddi_hooks.hooks_linear_filter = state;
}

HRESULT APIENTRY d3ddiCreateVertexShaderDeclHook(HANDLE hDevice, D3DDDIARG_CREATEVERTEXSHADERDECL* p2, const D3DDDIVERTEXELEMENT* elements)
{   
    HRESULT hr = g_d3d_ddi_hooks.device.pfnCreateVertexShaderDecl(hDevice, p2, elements);
    if (hr != S_OK) return hr;
    SHADERDECL* hShaderDecl             = new SHADERDECL();
    hShaderDecl->AreVerticesTransformed = elements->Usage == D3DDECLUSAGE_POSITIONT ? TRUE : FALSE;
    hShaderDecl->hShader                = p2->ShaderHandle;
    p2->ShaderHandle                    = hShaderDecl;
    return 0;
}
HRESULT APIENTRY d3ddiSetVertexShaderDeclHook(HANDLE hDevice, HANDLE hShaderDecl)
{
    if (hShaderDecl != nullptr)
    {
        SHADERDECL* _hShaderDecl = (SHADERDECL*)hShaderDecl;
        hShaderDecl              = _hShaderDecl->hShader;
        g_d3d_ddi_hooks.AreVerticesTransformed->Set(_hShaderDecl->AreVerticesTransformed);
    }
#pragma warning (suppress : 6387) 
    return g_d3d_ddi_hooks.device.pfnSetVertexShaderDecl(hDevice, hShaderDecl);
}

HRESULT APIENTRY d3ddiDeleteVertexShaderDeclHook(HANDLE hDevice, HANDLE hShaderDecl)
{
    if (hShaderDecl != nullptr)
    {
        SHADERDECL* _hShaderDecl = (SHADERDECL*)hShaderDecl;
        hShaderDecl              = _hShaderDecl->hShader;
        g_d3d_ddi_hooks.AreVerticesTransformed->Set(_hShaderDecl->AreVerticesTransformed);
    }
#pragma warning (suppress : 6387) 
    return g_d3d_ddi_hooks.device.pfnDeleteVertexShaderDecl(hDevice, hShaderDecl);
}

HRESULT APIENTRY
d3dddiSetTextureStatgeStateHook(HANDLE hDevice, CONST D3DDDIARG_TEXTURESTAGESTATE* s)
{
    if (g_d3d_ddi_hooks.force_aniso)
    {
#pragma warning (suppress : 26812) 
        if (s->State == 17)
        {
            D3DDDIARG_TEXTURESTAGESTATE ss;
            ss.Stage = s->Stage;
            ss.State = s->State;
            ss.Value = 3;
            return g_d3d_ddi_hooks.device.pfnSetTextureStageState(hDevice, &ss);
        }
        else if (s->State == 21)
        {
            D3DDDIARG_TEXTURESTAGESTATE ss;
            ss.Stage = s->Stage;
            ss.State = s->State;
            ss.Value = 16;
            return g_d3d_ddi_hooks.device.pfnSetTextureStageState(hDevice, &ss);
        }
        else if (s->State == 18)
        {
            D3DDDIARG_TEXTURESTAGESTATE ss;
            ss.Stage = s->Stage;
            ss.State = s->State;
            ss.Value = 2;
            return g_d3d_ddi_hooks.device.pfnSetTextureStageState(hDevice, &ss);
        }
        else if (s->State == 18)
        {
            D3DDDIARG_TEXTURESTAGESTATE ss;
            if (g_d3d_ddi_hooks.is_hooks_pass) {
                ss.Stage = s->Stage;
                ss.State = s->State;
                ss.Value = g_d3d_ddi_hooks.hooks_linear_filter ? 2 : 1;
                return g_d3d_ddi_hooks.device.pfnSetTextureStageState(hDevice, &ss);
            }
            else if (g_d3d_ddi_hooks.max_filter) {
                D3DDDIARG_TEXTURESTAGESTATE ss;
                ss.Stage = s->Stage;
                ss.State = s->State;
                ss.Value = g_d3d_ddi_hooks.max_filter;
                return g_d3d_ddi_hooks.device.pfnSetTextureStageState(hDevice, &ss);
            }
        }
    }    
    return g_d3d_ddi_hooks.device.pfnSetTextureStageState(hDevice, s);
}

HRESULT APIENTRY d3dddiUpdateWInfoHook(HANDLE hDevice, const D3DDDIARG_WINFO *WNfo)
{
#pragma warning (suppress : 6387) 
    if (WNfo == nullptr) return g_d3d_ddi_hooks.device.pfnUpdateWInfo(hDevice, WNfo);
    D3DDDIARG_WINFO wnfo;
    memcpy(&wnfo, WNfo, sizeof(D3DDDIARG_WINFO));
    wnfo.WNear = 0;
    wnfo.WFar  = 1;
    return g_d3d_ddi_hooks.device.pfnUpdateWInfo(hDevice, &wnfo);
}

HRESULT APIENTRY d3dddiSetVertexShader(HANDLE hShader) {
    return g_d3d_ddi_hooks.device.pfnSetVertexShaderFunc(g_d3d_ddi_hooks.hCurrentDevice, hShader);
}

HRESULT APIENTRY d3dddiSetPixelShaderHook(HANDLE hDevice, HANDLE hShader)
{
    if (hShader == nullptr) hShader = g_d3d_ddi_hooks.hLastShader;
    g_d3d_ddi_hooks.hLastShader = hShader;
    if (g_d3d_ddi_hooks.hOverride) return g_d3d_ddi_hooks.device.pfnSetPixelShader(hDevice, g_d3d_ddi_hooks.hOverride);
    return g_d3d_ddi_hooks.device.pfnSetPixelShader(hDevice, hShader);
}

HRESULT APIENTRY d3dddiSetRenderState(HANDLE hDevice, const D3DDDIARG_RENDERSTATE *state)
{
#pragma warning (suppress : 6387) 
    if (state == nullptr) return g_d3d_ddi_hooks.device.pfnSetRenderState(hDevice, state);
#pragma warning (suppress : 26812) 
    if (state->State == D3DDDIRENDERSTATETYPE::D3DDDIRS_COLORKEYENABLE && g_d3d_ddi_hooks.colorkey_fix)
    {
        D3DDDIARG_RENDERSTATE S = {D3DDDIRS_COLORKEYENABLE, g_d3d_ddi_hooks.colorkey_fix-1};
        return g_d3d_ddi_hooks.device.pfnSetRenderState(hDevice, &S);
    }
    /*else if (state->State == D3DRS_DEPTHBIAS){
        D3DDDIARG_RENDERSTATE slope = {D3DDDIRS_SLOPESCALEDEPTHBIAS, 1.f};
        D3DDDIARG_RENDERSTATE bias  = {D3DDDIRS_DEPTHBIAS, (float)state->Value/16.f};
        g_d3d_ddi_hooks.device.pfnSetRenderState(hDevice, &slope);
        return g_d3d_ddi_hooks.device.pfnSetRenderState(hDevice, &bias);
    }*/
    return g_d3d_ddi_hooks.device.pfnSetRenderState(hDevice, state);
}

HRESULT APIENTRY d3dddiPresent(HANDLE hDevice, const D3DDDIARG_PRESENT* params)
{
    if (g_d3d_ddi_hooks.sync > 0 && params)
    {
        D3DDDIARG_PRESENT  Params;
        memcpy(&Params, params, sizeof(D3DDDIARG_PRESENT));
        Params.Flags.Value &= ~(1 << 4);
        Params.Flags.Value |= (1 << 5);
        Params.FlipInterval = g_d3d_ddi_hooks.sync == 2 ? D3DDDI_FLIPINTERVAL_TWO : D3DDDI_FLIPINTERVAL_ONE;
        return g_d3d_ddi_hooks.device.pfnPresent(hDevice, &Params);
    }
#pragma warning (suppress : 6387) 
    return g_d3d_ddi_hooks.device.pfnPresent(hDevice, params);
}

HRESULT APIENTRY d3dddiPresent1(HANDLE hDevice, const D3DDDIARG_PRESENT1* params)
{
    if (g_d3d_ddi_hooks.sync > 0 && params)
    {
        D3DDDIARG_PRESENT1  Params;
        memcpy(&Params, params, sizeof(D3DDDIARG_PRESENT1));
        Params.Flags.Value &= ~(1 << 4);
        Params.Flags.Value |= (1 << 5);
        Params.FlipInterval = g_d3d_ddi_hooks.sync == 2 ? D3DDDI_FLIPINTERVAL_TWO : D3DDDI_FLIPINTERVAL_ONE;
        return g_d3d_ddi_hooks.device.pfnPresent1(hDevice, &Params);
    }
#pragma warning (suppress : 6387) 
    return g_d3d_ddi_hooks.device.pfnPresent1(hDevice, params);
}

HRESULT APIENTRY d3dddiCreateDeviceHook(HANDLE hAdapter, D3DDDIARG_CREATEDEVICE *Param2)
{
    //DBUG_LOG("===============================")
    HRESULT hr = g_d3d_ddi_hooks.Createdevice(hAdapter, Param2);
    if (hr == 0)
    {
        g_d3d_ddi_hooks.hCurrentDevice                = Param2->hDevice;

        /* Pixel Shaders */
        g_d3d_ddi_hooks.device.pfnDeletePixelShader   = Param2->pDeviceFuncs->pfnDeletePixelShader;
        g_d3d_ddi_hooks.device.pfnCreatePixelShader   = Param2->pDeviceFuncs->pfnCreatePixelShader;
        g_d3d_ddi_hooks.device.pfnSetPixelShaderConst = Param2->pDeviceFuncs->pfnSetPixelShaderConst;
        g_d3d_ddi_hooks.device.pfnSetPixelShader      = Param2->pDeviceFuncs->pfnSetPixelShader;
        Param2->pDeviceFuncs->pfnSetPixelShader       = d3dddiSetPixelShaderHook;

        /* Color key SW Mysteries of the sith */
        if (g_d3d_ddi_hooks.colorkey_fix)
        {
            g_d3d_ddi_hooks.device.pfnSetRenderState      = Param2->pDeviceFuncs->pfnSetRenderState;
            Param2->pDeviceFuncs->pfnSetRenderState       = d3dddiSetRenderState;
        }

        /* V Sync */
        if (g_d3d_ddi_hooks.sync)
        {
            g_d3d_ddi_hooks.device.pfnPresent1 = Param2->pDeviceFuncs->pfnPresent1;
            //Param2->pDeviceFuncs->pfnPresent1  = d3dddiPresent1;
            if (Param2->pDeviceFuncs->pfnPresent != nullptr)
            {
                g_d3d_ddi_hooks.device.pfnPresent = Param2->pDeviceFuncs->pfnPresent;
                //Param2->pDeviceFuncs->pfnPresent = d3dddiPresent;
            }
        }

        /* Vertex decl */
        if (g_d3d_ddi_hooks.monitor_vertex_decl)
        {
            g_d3d_ddi_hooks.device.pfnCreateVertexShaderDecl = Param2->pDeviceFuncs->pfnCreateVertexShaderDecl;
            Param2->pDeviceFuncs->pfnCreateVertexShaderDecl  = d3ddiCreateVertexShaderDeclHook;

            g_d3d_ddi_hooks.device.pfnSetVertexShaderDecl = Param2->pDeviceFuncs->pfnSetVertexShaderDecl;
            Param2->pDeviceFuncs->pfnSetVertexShaderDecl  = d3ddiSetVertexShaderDeclHook;

            g_d3d_ddi_hooks.device.pfnDeleteVertexShaderDecl = Param2->pDeviceFuncs->pfnDeleteVertexShaderDecl;
            Param2->pDeviceFuncs->pfnDeleteVertexShaderDecl  = d3ddiDeleteVertexShaderDeclHook;
        }

        /* W Fog */
        if (g_d3d_ddi_hooks.force_wfog)
        {            
            g_d3d_ddi_hooks.device.pfnUpdateWInfo         = Param2->pDeviceFuncs->pfnUpdateWInfo;
            Param2->pDeviceFuncs->pfnUpdateWInfo          = d3dddiUpdateWInfoHook;
        }

        /* Text filter */
        if (g_d3d_ddi_hooks.force_aniso || g_d3d_ddi_hooks.max_filter)
        {
            g_d3d_ddi_hooks.device.pfnSetTextureStageState = Param2->pDeviceFuncs->pfnSetTextureStageState;
            Param2->pDeviceFuncs->pfnSetTextureStageState  = d3dddiSetTextureStatgeStateHook;
            D3DDDIARG_TEXTURESTAGESTATE ss;
            for (int i = 0; i<8; i++)
            {
                ss.Stage = i;
                if (g_d3d_ddi_hooks.force_aniso)
                {
                    ss.State = D3DDDITSS_MINFILTER;  d3dddiSetTextureStatgeStateHook(Param2->hDevice, &ss);
                    ss.State = D3DDDITSS_MIPFILTER;  d3dddiSetTextureStatgeStateHook(Param2->hDevice, &ss);
                    ss.State = D3DDDITSS_MAXANISOTROPY;  d3dddiSetTextureStatgeStateHook(Param2->hDevice, &ss);
                }
                if (g_d3d_ddi_hooks.max_filter)
                    ss.State = D3DDDITSS_MAGFILTER;  d3dddiSetTextureStatgeStateHook(Param2->hDevice, &ss);
            }
        }
    } return hr;
}

HRESULT APIENTRY d3dddiOpenAdapterHook(D3DDDIARG_OPENADAPTER * adapter)
{
    HRESULT hr = g_d3d_ddi_hooks.OpenAdapter(adapter);
    if (hr == 0)
    {
        g_d3d_ddi_hooks.Createdevice            = adapter->pAdapterFuncs->pfnCreateDevice;
        adapter->pAdapterFuncs->pfnCreateDevice = d3dddiCreateDeviceHook;
    } return hr;
}

void D3DDDI_Init(char * d3d_ddi_dll, DWORD Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (strcmp(d3d_ddi_dll, "COLORKEYFIX") == 0)
    {
        g_d3d_ddi_hooks.colorkey_fix = Flags;
        return;
    }
    g_d3d_ddi_hooks.AreVerticesTransformed = new SYNC::Atomic();
    g_d3d_ddi_hooks.AreVerticesTransformed->Set(0);
    g_d3d_ddi_hooks.sync                   = (Flags & 0xf0000) >> 16;
    g_d3d_ddi_hooks.max_filter             = (Flags & 0xf00)   >>  8;
    g_d3d_ddi_hooks.force_aniso            = Flags & 0xf0;
    g_d3d_ddi_hooks.force_wfog             = Flags & 0xf000;
    g_d3d_ddi_hooks.monitor_vertex_decl    = Flags & 0xf00000  >> 20;
    g_.loger.log(__FUNCTION__, (std::string("Filter ")+std::to_string(g_d3d_ddi_hooks.max_filter)).c_str());
    g_d3d_ddi_hooks.OpenAdapter = (decltype(g_d3d_ddi_hooks.OpenAdapter)) GetProcAdd("OpenAdapter", d3d_ddi_dll);
    if (g_d3d_ddi_hooks.OpenAdapter) g_.loger.log(__FUNCTION__, (std::string(d3d_ddi_dll) +" OpenAdapter: OK").c_str());
    else                             g_.loger.log(__FUNCTION__, (std::string(d3d_ddi_dll) +" OpenAdapter: FAILED").c_str());
    HOOK(&g_d3d_ddi_hooks.OpenAdapter, d3dddiOpenAdapterHook)
}
