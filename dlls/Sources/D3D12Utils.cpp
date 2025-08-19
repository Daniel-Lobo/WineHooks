#include <windows.h>

#include "d3d11_4.h"
#include <d3d12.h>
#include <d3dx12.h>
#include <dxgi1_4.h>
#include "D3D12Utils.h"
#include "D3D12Hooks.h"
#include "Dbug.h"
#include "d3d11on12.h"
#include <string>
#include "dllmain.h"
#include "D3D11Hooks.h"

#define RECORD_D3D11_COMPUTE_STATE \
    ID3D11Buffer              * CBuffs[1]   = {nullptr}; \
    ID3D11DepthStencilView    * DSV         =   nullptr; \
    ID3D11RenderTargetView    * NULLRTVs[1] = {nullptr}; \
    ID3D11RenderTargetView    * RTV[1]      = {nullptr}; \
    ID3D11UnorderedAccessView * UAVs[1]     = {nullptr}; \
    ID3D11ShaderResourceView  * SRVs[1]     = {nullptr}; \
    ID3D11ComputeShader       * Shader      =   nullptr; \
    m_Ctxt->OMGetRenderTargets(1, RTV, &DSV);         \
    m_Ctxt->OMSetRenderTargets(1, NULLRTVs, nullptr); \
    m_Ctxt->CSGetConstantBuffers(0, 1, CBuffs);       \
    m_Ctxt->CSGetUnorderedAccessViews(0, 1, UAVs);    \
    m_Ctxt->CSGetShaderResources(0, 1, SRVs);         \
    m_Ctxt->CSGetShader(&Shader, nullptr, 0);          /* Class linkge not handled */

#define RESTORE_D3D11_COMPUTE_STATE \
    m_Ctxt->CSSetUnorderedAccessViews(0, 1, UAVs, 0); \
    m_Ctxt->CSSetShaderResources(0, 1, SRVs);         \
    m_Ctxt->CSSetShader(Shader, nullptr, 0);          \
    m_Ctxt->CSSetConstantBuffers(0, 1, CBuffs);       \
    m_Ctxt->OMSetRenderTargets(1, RTV, DSV);          \
    if (DSV) DSV->Release();                                        \
    if (RTV[0]) RTV[0]->Release();                                  \
    if (UAVs[0]) UAVs[0]->Release();                                \
    if (SRVs[0]) SRVs[0]->Release();                                \
    if (Shader) Shader->Release();

#define D3D11_COMPUTE_PASS(Cntxt, Cbuff, UAV, SRV, Shader, X, Y, Z) \
    Cntxt->CSSetConstantBuffers(0, 1, Cbuff);                       \
    Cntxt->CSSetUnorderedAccessViews(0, 1, UAV, 0);                 \
    Cntxt->CSSetShaderResources(0, 1, SRV);                         \
    Cntxt->CSSetShader(Shader, nullptr, 0);                         \
    Cntxt->Dispatch(X, Y, Z);

extern "C" __declspec(dllexport) HWND GetSwapChainWindowHandle(IDXGISwapChain * s)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDXGISwapChain1 * s1 = nullptr;
    HWND            hwin = nullptr;
    if (s->QueryInterface(__uuidof(IDXGISwapChain1), (void**)&s1) != 0) return 0;
    s1->GetHwnd(&hwin);
    s1->Release();
    return hwin;
}

DWORD SetDXGISurfacePxFormat(DXGI_FORMAT *f, DWORD fmt)
{
    if      ( fmt == *(DWORD*)"A8RGB" ) *f = DXGI_FORMAT_B8G8R8A8_UNORM;
    else if ( fmt == *(DWORD*)"A8BGR" ) *f = DXGI_FORMAT_R8G8B8A8_UNORM;
    else if ( fmt == *(DWORD*)"X8RGB" ) *f = DXGI_FORMAT_B8G8R8X8_UNORM;
    else if ( fmt == *(DWORD*)"A1RGB" ) *f = DXGI_FORMAT_B5G5R5A1_UNORM;
    else if ( fmt == *(DWORD*)"RG6B"  ) *f = DXGI_FORMAT_B5G6R5_UNORM ;
    else if ( fmt == *(DWORD*)"DXT5"  ) *f = DXGI_FORMAT_BC3_UNORM;
    else if ( fmt == *(DWORD*)"DXT1"  ) *f = DXGI_FORMAT_BC1_UNORM;
    else return 0; /* Unhandled format */
    return 1;
}

wstring GetDXGISurfacePxFormatString(DXGI_FORMAT fmt)
{
    switch (fmt)
    {
        case (DXGI_FORMAT_UNKNOWN)                   : return wstring(L"UNKNOWN");
        case (DXGI_FORMAT_R32G32B32A32_TYPELESS)     : return wstring(L"R32G32B32A32_TYPELESS");
        case (DXGI_FORMAT_R32G32B32A32_FLOAT)        : return wstring(L"R32G32B32A32_FLOAT");
        case (DXGI_FORMAT_R32G32B32A32_UINT)         : return wstring(L"R32G32B32A32_UINT");
        case (DXGI_FORMAT_R32G32B32A32_SINT)         : return wstring(L"R32G32B32A32_SINT");
        case (DXGI_FORMAT_R32G32B32_TYPELESS)        : return wstring(L"R32G32B32_TYPELESS");
        case (DXGI_FORMAT_R32G32B32_FLOAT)           : return wstring(L"R32G32B32_FLOAT");
        case (DXGI_FORMAT_R32G32B32_UINT)            : return wstring(L"R32G32B32_UINT");
        case (DXGI_FORMAT_R32G32B32_SINT)            : return wstring(L"R32G32B32_SINT");
        case (DXGI_FORMAT_R16G16B16A16_TYPELESS)     : return wstring(L"R16G16B16A16_TYPELESS");
        case (DXGI_FORMAT_R16G16B16A16_FLOAT)        : return wstring(L"R16G16B16A16_FLOAT");
        case (DXGI_FORMAT_R16G16B16A16_UNORM)        : return wstring(L"R16G16B16A16_UNORM");
        case (DXGI_FORMAT_R16G16B16A16_UINT)         : return wstring(L"R16G16B16A16_UINT");
        case (DXGI_FORMAT_R16G16B16A16_SNORM)        : return wstring(L"R16G16B16A16_SNORM");
        case (DXGI_FORMAT_R16G16B16A16_SINT)         : return wstring(L"R16G16B16A16_SINT");
        case (DXGI_FORMAT_R32G32_TYPELESS)           : return wstring(L"R32G32_TYPELESS");
        case (DXGI_FORMAT_R32G32_FLOAT)              : return wstring(L"R32G32_FLOAT");
        case (DXGI_FORMAT_R32G32_UINT)               : return wstring(L"R32G32_UINT");
        case (DXGI_FORMAT_R32G32_SINT)               : return wstring(L"R32G32_SINT");
        case (DXGI_FORMAT_R32G8X24_TYPELESS)         : return wstring(L"R32G8X24_TYPELESS");
        case (DXGI_FORMAT_D32_FLOAT_S8X24_UINT)      : return wstring(L"D32_FLOAT_S8X24_UINT");
        case (DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS)  : return wstring(L"R32_FLOAT_X8X24_TYPELESS");
        case (DXGI_FORMAT_X32_TYPELESS_G8X24_UINT)   : return wstring(L"X32_TYPELESS_G8X24_UINT");
        case (DXGI_FORMAT_R10G10B10A2_TYPELESS)      : return wstring(L"R10G10B10A2_TYPELESS");
        case (DXGI_FORMAT_R10G10B10A2_UNORM)         : return wstring(L"R10G10B10A2_UNORM");
        case (DXGI_FORMAT_R10G10B10A2_UINT)          : return wstring(L"R10G10B10A2_UINT");
        case (DXGI_FORMAT_R11G11B10_FLOAT)           : return wstring(L"R11G11B10_FLOAT");
        case (DXGI_FORMAT_R8G8B8A8_TYPELESS)         : return wstring(L"R8G8B8A8_TYPELESS");
        case (DXGI_FORMAT_R8G8B8A8_UNORM)            : return wstring(L"R8G8B8A8_UNORM");
        case (DXGI_FORMAT_R8G8B8A8_UNORM_SRGB)       : return wstring(L"R8G8B8A8_UNORM_SRGB");
        case (DXGI_FORMAT_R8G8B8A8_UINT)             : return wstring(L"R8G8B8A8_UINT");
        case (DXGI_FORMAT_R8G8B8A8_SNORM)            : return wstring(L"R8G8B8A8_SNORM");
        case (DXGI_FORMAT_R8G8B8A8_SINT)             : return wstring(L"R8G8B8A8_SINT");
        case (DXGI_FORMAT_R16G16_TYPELESS)           : return wstring(L"R16G16_TYPELESS");
        case (DXGI_FORMAT_R16G16_FLOAT)              : return wstring(L"R16G16_FLOAT");
        case (DXGI_FORMAT_R16G16_UNORM)              : return wstring(L"R16G16_UNORM");
        case (DXGI_FORMAT_R16G16_UINT)               : return wstring(L"R16G16_UINT");
        case (DXGI_FORMAT_R16G16_SNORM)              : return wstring(L"R16G16_SNORM");
        case (DXGI_FORMAT_R16G16_SINT)               : return wstring(L"R16G16_SINT");
        case (DXGI_FORMAT_R32_TYPELESS)              : return wstring(L"R32_TYPELESS");
        case (DXGI_FORMAT_D32_FLOAT)                 : return wstring(L"D32_FLOAT");
        case (DXGI_FORMAT_R32_FLOAT)                 : return wstring(L"R32_FLOAT");
        case (DXGI_FORMAT_R32_UINT)                  : return wstring(L"R32_UINT");
        case (DXGI_FORMAT_R32_SINT)                  : return wstring(L"R32_SINT");
        case (DXGI_FORMAT_R24G8_TYPELESS)            : return wstring(L"R24G8_TYPELESS");
        case (DXGI_FORMAT_D24_UNORM_S8_UINT)         : return wstring(L"D24_UNORM_S8_UINT");
        case (DXGI_FORMAT_R24_UNORM_X8_TYPELESS)     : return wstring(L"R24_UNORM_X8_TYPELESS");
        case (DXGI_FORMAT_X24_TYPELESS_G8_UINT)      : return wstring(L"X24_TYPELESS_G8_UINT");
        case (DXGI_FORMAT_R8G8_TYPELESS)             : return wstring(L"R8G8_TYPELESS");
        case (DXGI_FORMAT_R8G8_UNORM)                : return wstring(L"R8G8_UNORM");
        case (DXGI_FORMAT_R8G8_UINT)                 : return wstring(L"R8G8_UINT");
        case (DXGI_FORMAT_R8G8_SNORM)                : return wstring(L"R8G8_SNORM");
        case (DXGI_FORMAT_R8G8_SINT)                 : return wstring(L"R8G8_SINT");
        case (DXGI_FORMAT_R16_TYPELESS)              : return wstring(L"R16_TYPELESS");
        case (DXGI_FORMAT_R16_FLOAT)                 : return wstring(L"R16_FLOAT");
        case (DXGI_FORMAT_D16_UNORM)                 : return wstring(L"D16_UNORM");
        case (DXGI_FORMAT_R16_UNORM)                 : return wstring(L"R16_UNORM");
        case (DXGI_FORMAT_R16_UINT)                  : return wstring(L"R16_UINT");
        case (DXGI_FORMAT_R16_SNORM)                 : return wstring(L"R16_SNORM");
        case (DXGI_FORMAT_R16_SINT)                  : return wstring(L"R16_SINT");
        case (DXGI_FORMAT_R8_TYPELESS)               : return wstring(L"R8_TYPELESS");
        case (DXGI_FORMAT_R8_UNORM)                  : return wstring(L"R8_UNORM");
        case (DXGI_FORMAT_R8_UINT)                   : return wstring(L"R8_UINT");
        case (DXGI_FORMAT_R8_SNORM)                  : return wstring(L"R8_SNORM");
        case (DXGI_FORMAT_R8_SINT)                   : return wstring(L"R8_SINT");
        case (DXGI_FORMAT_A8_UNORM)                  : return wstring(L"A8_UNORM");
        case (DXGI_FORMAT_R1_UNORM)                  : return wstring(L"R1_UNORM");
        case (DXGI_FORMAT_R9G9B9E5_SHAREDEXP)        : return wstring(L"R9G9B9E5_SHAREDEXP");
        case (DXGI_FORMAT_R8G8_B8G8_UNORM)           : return wstring(L"R8G8_B8G8_UNORM");
        case (DXGI_FORMAT_G8R8_G8B8_UNORM)           : return wstring(L"G8R8_G8B8_UNORM");
        case (DXGI_FORMAT_BC1_TYPELESS)              : return wstring(L"BC1_TYPELESS");
        case (DXGI_FORMAT_BC1_UNORM)                 : return wstring(L"BC1_UNORM");
        case (DXGI_FORMAT_BC1_UNORM_SRGB)            : return wstring(L"BC1_UNORM_SRGB");
        case (DXGI_FORMAT_BC2_TYPELESS)              : return wstring(L"BC2_TYPELESS");
        case (DXGI_FORMAT_BC2_UNORM)                 : return wstring(L"BC2_UNORM");
        case (DXGI_FORMAT_BC2_UNORM_SRGB)            : return wstring(L"BC2_UNORM_SRGB");
        case (DXGI_FORMAT_BC3_TYPELESS)              : return wstring(L"BC3_TYPELESS");
        case (DXGI_FORMAT_BC3_UNORM)                 : return wstring(L"BC3_UNORM");
        case (DXGI_FORMAT_BC3_UNORM_SRGB)            : return wstring(L"BC3_UNORM_SRGB");
        case (DXGI_FORMAT_BC4_TYPELESS)              : return wstring(L"BC4_TYPELESS");
        case (DXGI_FORMAT_BC4_UNORM)                 : return wstring(L"BC4_UNORM");
        case (DXGI_FORMAT_BC4_SNORM)                 : return wstring(L"BC4_SNORM");
        case (DXGI_FORMAT_BC5_TYPELESS)              : return wstring(L"BC5_TYPELESS");
        case (DXGI_FORMAT_BC5_UNORM)                 : return wstring(L"BC5_UNORM");
        case (DXGI_FORMAT_BC5_SNORM)                 : return wstring(L"BC5_SNORM");
        case (DXGI_FORMAT_B5G6R5_UNORM)              : return wstring(L"B5G6R5_UNORM");
        case (DXGI_FORMAT_B5G5R5A1_UNORM)            : return wstring(L"B5G5R5A1_UNORM");
        case (DXGI_FORMAT_B8G8R8A8_UNORM)            : return wstring(L"B8G8R8A8_UNORM");
        case (DXGI_FORMAT_B8G8R8X8_UNORM)            : return wstring(L"B8G8R8X8_UNORM");
        case (DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM): return wstring(L"R10G10B10_XR_BIAS_A2_UNORM");
        case (DXGI_FORMAT_B8G8R8A8_TYPELESS)         : return wstring(L"B8G8R8A8_TYPELESS");
        case (DXGI_FORMAT_B8G8R8A8_UNORM_SRGB)       : return wstring(L"B8G8R8A8_UNORM_SRGB");
        case (DXGI_FORMAT_B8G8R8X8_TYPELESS)         : return wstring(L"B8G8R8X8_TYPELESS");
        case (DXGI_FORMAT_B8G8R8X8_UNORM_SRGB)       : return wstring(L"B8G8R8X8_UNORM_SRGB");
        case (DXGI_FORMAT_BC6H_TYPELESS)             : return wstring(L"BC6H_TYPELESS");
        case (DXGI_FORMAT_BC6H_UF16)                 : return wstring(L"BC6H_UF16");
        case (DXGI_FORMAT_BC6H_SF16)                 : return wstring(L"BC6H_SF16");
        case (DXGI_FORMAT_BC7_TYPELESS)              : return wstring(L"BC7_TYPELESS");
        case (DXGI_FORMAT_BC7_UNORM)                 : return wstring(L"BC7_UNORM");
        case (DXGI_FORMAT_BC7_UNORM_SRGB)            : return wstring(L"BC7_UNORM_SRGB");
        case (DXGI_FORMAT_AYUV)                      : return wstring(L"AYUV");
        case (DXGI_FORMAT_Y410)                      : return wstring(L"Y410");
        case (DXGI_FORMAT_Y416)                      : return wstring(L"Y416");
        case (DXGI_FORMAT_NV12)                      : return wstring(L"NV12");
        case (DXGI_FORMAT_P010)                      : return wstring(L"P010");
        case (DXGI_FORMAT_P016)                      : return wstring(L"P016");
        case (DXGI_FORMAT_420_OPAQUE)                : return wstring(L"420_OPAQUE");
        case (DXGI_FORMAT_YUY2)                      : return wstring(L"YUY2");
        case (DXGI_FORMAT_Y210)                      : return wstring(L"Y210");
        case (DXGI_FORMAT_Y216)                      : return wstring(L"Y216");
        case (DXGI_FORMAT_NV11)                      : return wstring(L"NV11");
        case (DXGI_FORMAT_AI44)                      : return wstring(L"AI44");
        case (DXGI_FORMAT_IA44)                      : return wstring(L"IA44");
        case (DXGI_FORMAT_P8)                        : return wstring(L"P8");
        case (DXGI_FORMAT_A8P8)                      : return wstring(L"A8P8");
        case (DXGI_FORMAT_B4G4R4A4_UNORM)            : return wstring(L"B4G4R4A4_UNORM");
        case (DXGI_FORMAT_P208)                      : return wstring(L"P208");
        case (DXGI_FORMAT_V208)                      : return wstring(L"V208");
        case (DXGI_FORMAT_V408)                      : return wstring(L"V408");
        default                                      : return wstring(L"Unknown");
    }
}

DWORD GetDXGISurfacePxFormat(DWORD fmt)
{
    if      (fmt == DXGI_FORMAT_R8G8B8A8_UNORM)      return *(DWORD*) "A8BGR";
    else if (fmt == DXGI_FORMAT_R8G8B8A8_UNORM_SRGB) return *(DWORD*) "A8BGR";
    else if (fmt == DXGI_FORMAT_R8G8B8A8_TYPELESS)   return *(DWORD*) "A8BGR";
    else if (fmt == DXGI_FORMAT_BC1_UNORM)           return *(DWORD*) "DXT1";
    else if (fmt == DXGI_FORMAT_BC1_UNORM_SRGB)      return *(DWORD*) "DXT1";
    else if (fmt == DXGI_FORMAT_BC1_TYPELESS)        return *(DWORD*) "DXT1";
    else if (fmt == DXGI_FORMAT_BC2_UNORM)           return *(DWORD*) "DXT3";
    else if (fmt == DXGI_FORMAT_BC2_UNORM_SRGB)      return *(DWORD*) "DXT3";
    else if (fmt == DXGI_FORMAT_BC2_TYPELESS)        return *(DWORD*) "DXT3";
    else if (fmt == DXGI_FORMAT_BC3_UNORM)           return *(DWORD*) "DXT5";
    else if (fmt == DXGI_FORMAT_BC3_UNORM_SRGB)      return *(DWORD*) "DXT5";
    else if (fmt == DXGI_FORMAT_BC3_TYPELESS)        return *(DWORD*) "DXT5";
    else if (fmt == DXGI_FORMAT_B8G8R8A8_UNORM)      return *(DWORD*) "A8RGB";
    else if (fmt == DXGI_FORMAT_B8G8R8A8_UNORM_SRGB) return *(DWORD*) "A8RGB";
    else if (fmt == DXGI_FORMAT_B8G8R8A8_TYPELESS)   return *(DWORD*) "A8RGB";
    /* Mind functions that check this value in case of changes:
     * D3D10DumpTexture
     */
    return *(DWORD*) "?????";
}

void __stdcall D3D11HelperDvc::Copy2Screen(ID3D11Texture2D* Src, ID3D11Texture2D* BackBuffer)
{
    /* CopySubresourceRegion can result in a lost device with the wrong parameters
     * and the XOffset can be incorrecttly calculated on windowed mode, this method
     * serves to check the Offsets and prevent lost device */
    UINT                       X, Y;
    D3D11_TEXTURE2D_DESC    SrcDesc;
    D3D11_TEXTURE2D_DESC TargetDesc;
    Src->GetDesc(&SrcDesc);
    BackBuffer->GetDesc(&TargetDesc);
    if (SrcDesc.Width>TargetDesc.Width)   {
        DBUG_WARN((std::string("BAD WIDTH ")+std::to_string(SrcDesc.Width)+" "+
                   std::to_string(TargetDesc.Width)).c_str());
        return;
    }
    else X=0.5*(TargetDesc.Width-SrcDesc.Width);
    if (SrcDesc.Height>TargetDesc.Height) {DBUG_WARN("BAD HEIGHT"); return;}
    else Y=0.5*(TargetDesc.Height-SrcDesc.Height);
    m_Ctxt->CopySubresourceRegion(BackBuffer, 0, X, Y, 0, Src, 0, nullptr);
}

HRESULT __stdcall D3D11HelperDvc::Init()
{
    D3D_FEATURE_LEVEL lvl;  D3D_FEATURE_LEVEL lvls[1] = {D3D_FEATURE_LEVEL_11_0};
    if (g_d3d.m_D3D11CreateDevice(nullptr, D3D_DRIVER_TYPE_HARDWARE, nullptr, D3D11_CREATE_DEVICE_DEBUG, lvls, 1, D3D11_SDK_VERSION, &m_Dvc, &lvl, &m_Ctxt) != 0)
    return 3;
    if (m_Dvc->CreateComputeShader(g_d3d.m_CSBlt->GetBufferPointer(), g_d3d.m_CSBlt->GetBufferSize(), nullptr, &m_Bliter) != 0)
    {
        D3D12LOG("ID3D11Device::CreateComputeShader() FAILED");
        return 3;
    }
    return 0;
}

void  __stdcall D3D11HelperDvc::FSR(ID3D11Texture2D* src, ID3D11Resource * dst)
{
    ID3D11ShaderResourceView  *srcview = nullptr;
    D3D11_SHADER_RESOURCE_VIEW_DESC vd = {};
    D3D11_TEXTURE2D_DESC            td = {};
    src->GetDesc(&td);
    vd.Format                    = vd.Format;
    vd.ViewDimension             = D3D11_SRV_DIMENSION_TEXTURE2D;
    vd.Texture2D.MipLevels       = 1;
    vd.Texture2D.MostDetailedMip = 0;

    if (m_Dvc->CreateShaderResourceView(src, &vd, &srcview) != 0)
    {
        D3D12LOG("ID3D11Device::CreateShaderResourceView() FAILED");
        return;
    }

    static const int threadGroupWorkRegionDim = 16;
    int dispatchX = (g_d3d.HD_W + (threadGroupWorkRegionDim - 1)) / threadGroupWorkRegionDim;
    int dispatchY = (g_d3d.HD_H + (threadGroupWorkRegionDim - 1)) / threadGroupWorkRegionDim;
    RECORD_D3D11_COMPUTE_STATE
    D3D11_COMPUTE_PASS(m_Ctxt, &m_CSConstants, &m_EASUOutPut, &srcview    , m_EASU, dispatchX, dispatchY, 1);
    m_Ctxt->CSSetSamplers(0, 1, &m_RCASSampler);
    D3D11_COMPUTE_PASS(m_Ctxt, &m_CSConstants, &m_RCASOutPut, &m_RCASInput, m_RCAS, dispatchX, dispatchY, 1);
    //m_Ctxt->CopySubresourceRegion(dst, 0, 0, 0, 0, m_Pass1Output, 0, nullptr);
    srcview->Release();
    RESTORE_D3D11_COMPUTE_STATE
}

void  __stdcall D3D11HelperDvc::CSBlit(ID3D11Texture2D* src, ID3D11Resource * dst)
{
    ID3D11ShaderResourceView  *srcview = nullptr;
    D3D11_SHADER_RESOURCE_VIEW_DESC vd = {};
    D3D11_TEXTURE2D_DESC            td = {};
    src->GetDesc(&td);
    vd.Format                    = vd.Format;
    vd.ViewDimension             = D3D11_SRV_DIMENSION_TEXTURE2D;
    vd.Texture2D.MipLevels       = 1;
    vd.Texture2D.MostDetailedMip = 0;

    if (m_Dvc->CreateShaderResourceView(src, &vd, &srcview) != 0)
    {
        D3D12LOG("ID3D11Device::CreateShaderResourceView() FAILED");
        return;
    }   

    RECORD_D3D11_COMPUTE_STATE
    D3D11_COMPUTE_PASS(m_Ctxt, &m_CSConstants, &m_RCASOutPut, &srcview, m_Bliter,
                       g_d3d.m_WW->Get()*g_d3d.mScl->Get()/16.f, g_d3d.HD_H/16.f, 1);
    //m_Ctxt->CopySubresourceRegion(dst, 0, 0, 0, 0, m_Pass1Output, 0, nullptr);
    srcview->Release();
    RESTORE_D3D11_COMPUTE_STATE
}

void  __stdcall D3D11HelperDvc::SSAABlit(ID3D11Texture2D* src, ID3D11Texture2D* dst)
{
    ID3D11ShaderResourceView* srcview  = nullptr;
    D3D11_SHADER_RESOURCE_VIEW_DESC vd = {};
    D3D11_TEXTURE2D_DESC            td = {};
    src->GetDesc(&td);
    vd.Format                    = vd.Format;
    vd.ViewDimension             = D3D11_SRV_DIMENSION_TEXTURE2D;
    vd.Texture2D.MipLevels       = 1;
    vd.Texture2D.MostDetailedMip = 0;

    if (m_Dvc->CreateShaderResourceView(src, &vd, &srcview) != 0)
    {
        D3D12LOG("ID3D11Device::CreateShaderResourceView() FAILED");
        return;
    }
    dst->GetDesc(&td);
    RECORD_D3D11_COMPUTE_STATE
    D3D11_COMPUTE_PASS(m_Ctxt, &m_CSConstants, &m_RCASOutPut, &srcview, g_d3d.TXAAFIX != 0 ? m_TXAAFix : g_d3d.SSAA == 3 ? m_SSAAHQ : m_SSAA, td.Width / 16.f, td.Height / 16.f, 1);
    srcview->Release();
    RESTORE_D3D11_COMPUTE_STATE
}

class D3D11TextureCopy
{
    ID3D11Resource      * m_original = nullptr;
    ID3D11Texture2D         * m_cpy  = nullptr;    
    ID3D11ShaderResourceView * m_vw  = nullptr;
    ID3D11UnorderedAccessView* m_uvw = nullptr;
public:
    D3D11_TEXTURE2D_DESC           m_desc = {};
    D3D11TextureCopy(ID3D11Device * dvc, ID3D11Resource* r)
    {
        m_original = r;
        ID3D11Texture2D           * txt = nullptr;
        D3D11_RESOURCE_DIMENSION r_type = D3D11_RESOURCE_DIMENSION_UNKNOWN;       
        r->GetType(&r_type);
        if (r_type != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("NOT A 2D TEXTURE");
            return;
        }
        txt = (ID3D11Texture2D*)r;
        txt->GetDesc(&m_desc);
        m_desc.CPUAccessFlags = 0;
        m_desc.BindFlags      = D3D11_BIND_UNORDERED_ACCESS | D3D11_BIND_SHADER_RESOURCE;
        m_desc.Usage          = D3D11_USAGE_DEFAULT;
        m_desc.MiscFlags      = 0;
        if (dvc->CreateTexture2D(&m_desc, nullptr, &m_cpy) != 0)
        {
            DBUG_WARN("CreateTexture2D FAILED");
            return;
        }
    }
    D3D11TextureCopy & Copy(ID3D11DeviceContext * ctx)
    {
        D3D11_Hooks->CopyResource(ctx, m_cpy, m_original);
        //ctx->CopyResource(m_cpy, m_original);
        return *this;
    }
    D3D11TextureCopy * Copyback(ID3D11DeviceContext* ctx)
    {
        D3D11_Hooks->CopyResource(ctx, m_original, m_cpy);
        //ctx->CopyResource(m_original, m_cpy);
        return this;
    }
    ID3D11ShaderResourceView* const* SRV(ID3D11Device* dvc)
    {
        D3D11_SHADER_RESOURCE_VIEW_DESC vd = {};
        vd.ViewDimension             = D3D11_SRV_DIMENSION_TEXTURE2D;
        vd.Format                    = m_desc.Format;
        vd.Texture2D.MipLevels       = 1;
        vd.Texture2D.MostDetailedMip = 0;
        if (dvc->CreateShaderResourceView(m_cpy, &vd, &m_vw) != 0)
        {
            DBUG_WARN((string("ID3D11Device::CreateShaderResourceView() FAILED ") + to_string(vd.Format)).c_str());            
        }
        return &m_vw;
    }
    ID3D11UnorderedAccessView* const* UAV(ID3D11Device* dvc)
    {
        D3D11_UNORDERED_ACCESS_VIEW_DESC ud = {};        
        ud.ViewDimension      = D3D11_UAV_DIMENSION_TEXTURE2D;
        ud.Format             = m_desc.Format;
        ud.Texture2D.MipSlice = 0;
        if (dvc->CreateUnorderedAccessView(m_cpy, &ud, &m_uvw) != 0)
        {
            DBUG_WARN("ID3D11Device::CreateUnorderedAccessView() FAILED");            
        }
        return &m_uvw;
    }
    ~D3D11TextureCopy()
    {
        if (m_cpy != nullptr)  m_cpy->Release();
        if (m_vw != nullptr)   m_vw->Release();
        if (m_uvw != nullptr)  m_uvw->Release();        
    }
};

void  __stdcall D3D11HelperDvc::DwnScaleBlit(ID3D11Resource* src, ID3D11Resource* dst)
{
    /* These resources can be sysmem, so we make video copies of them */
    auto src_cpy = D3D11TextureCopy(m_Dvc, src);
    auto dst_cpy = D3D11TextureCopy(m_Dvc, dst);
    src_cpy.Copy(m_Ctxt);
    
    RECORD_D3D11_COMPUTE_STATE
    D3D11_COMPUTE_PASS(m_Ctxt, &m_CSConstants, dst_cpy.UAV(m_Dvc), src_cpy.SRV(m_Dvc), m_DwnScl, dst_cpy.m_desc.Width/16.f, dst_cpy.m_desc.Height/16.f, 1);
    RESTORE_D3D11_COMPUTE_STATE
    dst_cpy.Copyback(m_Ctxt);
    
}

void __stdcall D3D11HelperDvc::InitResources(DXGI_FORMAT fmt)
{
    if (m_Dvc->CreateComputeShader(g_d3d.m_DwnScl->GetBufferPointer(), g_d3d.m_DwnScl->GetBufferSize(), nullptr, &m_DwnScl) != 0)
    {
        D3D12LOG("ID3D11Device::CreateComputeShader(Scaler) FAILED");
        return;
    }
    if (m_Dvc->CreateComputeShader(g_d3d.m_CSBlt->GetBufferPointer(), g_d3d.m_CSBlt->GetBufferSize(), nullptr, &m_Bliter) != 0)
    {
        D3D12LOG("ID3D11Device::CreateComputeShader(Bliter) FAILED");
        return;
    }
    if (m_Dvc->CreateComputeShader(g_d3d.m_EASU->GetBufferPointer(), g_d3d.m_EASU->GetBufferSize(), nullptr, &m_EASU) != 0)
    {
        D3D12LOG("ID3D11Device::CreateComputeShader(EASU) FAILED");
        return;
    }
    if (m_Dvc->CreateComputeShader(g_d3d.m_RCAS->GetBufferPointer(), g_d3d.m_RCAS->GetBufferSize(), nullptr, &m_RCAS) != 0)
    {
        D3D12LOG("ID3D11Device::CreateComputeShader(RCAS) FAILED");
        return;
    }
    if (m_Dvc->CreateComputeShader(g_d3d.m_SSAA->GetBufferPointer(), g_d3d.m_SSAA->GetBufferSize(), nullptr, &m_SSAA) != 0)
    {
        D3D12LOG("ID3D11Device::CreateComputeShader(SSAA) FAILED");
        return;
    }
    if (m_Dvc->CreateComputeShader(g_d3d.m_SSAAHQ->GetBufferPointer(), g_d3d.m_SSAAHQ->GetBufferSize(), nullptr, &m_SSAAHQ) != 0)
    {
        D3D12LOG("ID3D11Device::CreateComputeShader(SSAAHQ) FAILED");
        return;
    }
    if (m_Dvc->CreateComputeShader(g_d3d.m_TXAAFix->GetBufferPointer(), g_d3d.m_TXAAFix->GetBufferSize(), nullptr, &m_TXAAFix) != 0)
    {
        D3D12LOG("ID3D11Device::CreateComputeShader(TXAAFix) FAILED");
        return;
    }
    D3D11_TEXTURE2D_DESC D = {};
    D.ArraySize        = 1;
    D.MipLevels        = 1;
    D.SampleDesc.Count = 1;
    D.Height    = g_d3d.HD_H;
    D.Width     = g_d3d.HD_W - g_d3d.HD_X->Get()*2.0;
    D.BindFlags = D3D11_BIND_SHADER_RESOURCE|D3D11_BIND_UNORDERED_ACCESS;
    D.Format    = fmt;
    if (D.Format == DXGI_FORMAT_R8G8B8A8_UNORM_SRGB) D.Format = DXGI_FORMAT_R8G8B8A8_UNORM; /* Titanfall 2*/
    D.Usage     = D3D11_USAGE_DEFAULT;
    if (m_Dvc->CreateTexture2D(&D, nullptr, &m_Pass0Output) != 0)
    {
        D3D12LOG("ID3D11Device::CreateTexture2D() FAILED");
        return;
    }
    if (m_Dvc->CreateTexture2D(&D, nullptr, &m_Pass1Output) != 0)
    {
        D3D12LOG("ID3D11Device::CreateTexture2D() FAILED");
        return;
    }

    D3D11_SHADER_RESOURCE_VIEW_DESC vd = {};
    vd.Format                    = D.Format;
    vd.ViewDimension             = D3D11_SRV_DIMENSION_TEXTURE2D;
    vd.Texture2D.MipLevels       = 1;
    vd.Texture2D.MostDetailedMip = 0;
    if (m_Dvc->CreateShaderResourceView(m_Pass0Output, &vd, &m_RCASInput) != 0)
    {
        D3D12LOG("ID3D11Device::CreateShaderResourceView() FAILED");
        return;
    }

    D3D11_UNORDERED_ACCESS_VIEW_DESC ud = {};
    ud.ViewDimension      = D3D11_UAV_DIMENSION_TEXTURE2D;
    ud.Format             = D.Format;
    ud.Texture2D.MipSlice = 0;
    if (m_Dvc->CreateUnorderedAccessView(m_Pass0Output, &ud, &m_EASUOutPut) != 0)
    {
        D3D12LOG("ID3D11Device::CreateUnorderedAccessView() FAILED");
        return;
    }
    if (m_Dvc->CreateUnorderedAccessView(m_Pass1Output, &ud, &m_RCASOutPut) != 0)
    {
        D3D12LOG("ID3D11Device::CreateUnorderedAccessView() FAILED");
        return;
    }

    D3D11_SUBRESOURCE_DATA data       = {&g_d3d.m_ShaderConsts};
    D3D11_BUFFER_DESC bd              = {};
    bd.ByteWidth = sizeof(SHADERCONSTANTS);
    bd.Usage     = D3D11_USAGE_DEFAULT;
    bd.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
    DBUG_HR(m_Dvc->CreateBuffer(&bd, &data, &m_CSConstants), return;)

    D3D11_SAMPLER_DESC SDesc;
    SDesc.Filter        = D3D11_FILTER_MIN_MAG_MIP_POINT;
    SDesc.AddressU      = D3D11_TEXTURE_ADDRESS_CLAMP;
    SDesc.AddressV      = D3D11_TEXTURE_ADDRESS_CLAMP;
    SDesc.AddressW      = D3D11_TEXTURE_ADDRESS_CLAMP;
    SDesc.MipLODBias    = 0;
    SDesc.MaxAnisotropy = 1.0;
    SDesc.MaxLOD        = D3D11_FLOAT32_MAX;
    SDesc.MinLOD        = 0.0;
    if (m_Dvc->CreateSamplerState(&SDesc, &m_RCASSampler) != 0)
    {
        D3D12LOG("ID3D11Device::CreateSamplerState() FAILED");
        return;
    }
    D3D12LOG("SUCCESS");
}

void __stdcall D3D11HelperDvc::CleanUP()
{
    int i = 0;
    IUnknown ** I[8] = {(IUnknown**)&m_Pass0Output, (IUnknown**)&m_Pass1Output, (IUnknown**)&m_EASUInput,
                        (IUnknown**)&m_EASUOutPut , (IUnknown**)&m_RCASInput  , (IUnknown**)&m_RCASOutPut,
                        (IUnknown**)&m_CSConstants, (IUnknown**)m_RCASSampler};
    for (i=0; i<7; i++)
    {
        if (*I[i])
        {
            static_cast<IUnknown*>(*I[i])->Release();
            *I[i] = nullptr;
        }
    }
    if (m_Dvc)    {m_Dvc->Release();    m_Dvc    = nullptr;}
    if (m_Ctxt)   {m_Ctxt->Release();   m_Ctxt   = nullptr;}
    if (m_Bliter) {m_Bliter->Release(); m_Bliter = nullptr;}
    if (m_DwnScl) {m_DwnScl->Release(); m_DwnScl = nullptr;}
    if (m_EASU)   {m_EASU->Release();   m_EASU   = nullptr;}
    if (m_RCAS)   {m_RCAS->Release();   m_RCAS   = nullptr;}
    if (m_SSAA)   {m_SSAA->Release();   m_SSAA   = nullptr;}
    if (m_SSAAHQ) {m_SSAAHQ->Release(); m_SSAAHQ = nullptr;} 
}

void  __stdcall D3D11HelperDvc::ResetDevice(ID3D12Device*D, IDXGISwapChain* S, ID3D12CommandQueue * QQ)
{
    CleanUP();
    D3D12LOG( (std::string("Swap Schain ")+std::to_string((UINT64)S)).c_str() );
    UINT size = sizeof(IUnknown*);
    if (QQ == nullptr)
    {
        if (S->GetPrivateData((GUID &)g_.D3D12SwapChainQueue, &size, &QQ) != 0)
        {
            D3D12LOG((std::string("D3D12Queue NOT FOUND ON ")+std::to_string((UINT64)S)).c_str());
            return;
        }
    } else {        
        S->SetPrivateDataInterface((GUID &)g_.D3D12SwapChainQueue, QQ);
        QQ->AddRef();
    }

    IUnknown * q[1] = {QQ};
    if (g_d3d.m_D3D11On12CreateDevice(D, 0, NULL, 0, q, 1, 0, &m_Dvc, &m_Ctxt, nullptr) != 0)
    {
        D3D12LOG("m_D3D11On12CreateDevice FAILED");
        return;
    }
    QQ->Release();
    if (m_Dvc->QueryInterface(__uuidof(ID3D11On12Device), (void**)&m_11on12) != 0)
    {
        D3D12LOG("QueryInterface(__uuidof(ID3D11On12Device) FAILED");
        return;
    }    
    D3D12LOG("SUCCESS");
}

void __stdcall D3D11HelperDvc::Reset(IDXGISwapChain* S, IUnknown*U)
{
    ID3D12CommandQueue * QQ = nullptr;
    if (U)
    {
        if (U->QueryInterface(__uuidof(ID3D12CommandQueue), (void**)&QQ) != 0)
        {
            CleanUP();
            if (U->QueryInterface(__uuidof(ID3D11Device), (void**)&m_Dvc) != 0)
            {
                DBUG_WARN("Unsupported device");
                return;
            }
            m_Dvc->GetImmediateContext(&m_Ctxt);
            DXGI_SWAP_CHAIN_DESC D;
            g_d3d.m_IDXGISwapChainGetDesc(S, &D);
            InitResources(D.BufferDesc.Format);
            DBUG_WARN("SUCCESS");
            return;
        }
    }

    int i;
    ID3D12Resource * BB12  = nullptr;
    ID3D12Device   * D3D12 = nullptr;
    if (g_d3d.GetBuffer((IDXGISwapChain*)S, 0, __uuidof(ID3D12Resource), (void**)&BB12) != 0)
    {
        D3D12LOG("IDXGISwapChain::GetBuffer() FAILED");
        return;
    }
    if (BB12->GetDevice(__uuidof(ID3D12Device), (void**)&D3D12) != 0)
    {
        D3D12LOG("BackBufffer12::GetDevice() FAILED");
        D3D12->Release();
        return;
    }
    ResetDevice(D3D12, S, QQ);
    if (QQ) QQ->Release();
    auto DD = BB12->GetDesc();
    //DD.Format = DXGI_FORMAT_R8G8B8A8_UNORM_SRGB; /* Death's door 2*/
    ID3D12Resource * Proxy     = nullptr;
    ID3D12Resource * PreviousProxy = nullptr;
    for (i=0; i<3; i++)
    {
        auto heap  = CD3DX12_HEAP_PROPERTIES (D3D12_HEAP_TYPE_DEFAULT);
        auto desc  = CD3DX12_RESOURCE_DESC::Tex2D (DD.Format, g_d3d.m_WW->Get(), g_d3d.m_HH->Get(), 1, 1);
        desc.Flags = D3D12_RESOURCE_FLAG_ALLOW_RENDER_TARGET|D3D12_RESOURCE_FLAG_ALLOW_SIMULTANEOUS_ACCESS;

        if (D3D12->CreateCommittedResource(&heap, D3D12_HEAP_FLAG_SHARED, &desc, D3D12_RESOURCE_STATE_RENDER_TARGET,
                                           nullptr,__uuidof(ID3D12Resource),(void**)&Proxy) != 0)
        {
             D3D12LOG("CreateCommittedResource FAILED");
             return;
        }
        if (i==0)        S->SetPrivateDataInterface((GUID&)g_.D3D12ProxyBackbuffer,Proxy);
        else PreviousProxy->SetPrivateDataInterface((GUID&)g_.D3D12ProxyBackbuffer,Proxy);
        PreviousProxy=Proxy;
     }

     BB12->Release();
     D3D12->Release();
     InitResources(DD.Format);

     D3D12LOG("SUCCESS");
     //D3D12LOG((std::string("WAITABLE SWAP CHAIN ")+std::to_string(D3D12IsSwapChainWaitable(S))).c_str());
     DXGI_SWAP_CHAIN_DESC chain_desc;
     g_d3d.m_IDXGISwapChainGetDesc(S, &chain_desc);
     DXGI_MODE_DESC d = {g_d3d.HD_W, g_d3d.HD_H, chain_desc.BufferDesc.RefreshRate, chain_desc.BufferDesc.Format,
                         chain_desc.BufferDesc.ScanlineOrdering, chain_desc.BufferDesc.Scaling};
     S->ResizeTarget(&d);
     g_d3d.D3DWINDOW = GetSwapChainWindowHandle(S);
     SendMessageA(g_d3d.D3DWINDOW, WM_SIZE, 0, g_d3d.m_WW->Get()|(g_d3d.m_HH->Get()<<16)); /* RE Engine*/
     return ;
}

ID3D12Resource * __stdcall D3D11HelperDvc::GetBuffer(IDXGISwapChain* SChain, DWORD index)
{
    UINT            data_size = sizeof(IUnknown*);
    ID3D12Resource   * Src12  = nullptr;
    ID3D12Resource   * Prev12 = nullptr;
    if (SChain->GetPrivateData((GUID&)g_.D3D12ProxyBackbuffer, &data_size, &Src12) != 0)
    {
        D3D12LOG("IDXGISwapChain::GetPrivateData FAILED");
    }
    if (index > 0)
    {
        Prev12 = Src12;
        if (Prev12->GetPrivateData((GUID&)g_.D3D12ProxyBackbuffer, &data_size, &Src12) != 0)
        {
            D3D12LOG("ID3D12Resource::GetPrivateData FAILED");
        }
        Prev12->Release();
        if (index > 1)
        {
            Prev12 = Src12;
            if (Prev12->GetPrivateData((GUID&)g_.D3D12ProxyBackbuffer, &data_size, &Src12) != 0)
            {
                D3D12LOG("ID3D12Resource::GetPrivateData FAILED");
            }
            Prev12->Release();
        }
    }
    return Src12;
}

ID3D11Texture2D * __stdcall D3D11HelperDvc::AccquireTexture(ID3D12Resource*r, UINT bindflags)
{
    D3D11_RESOURCE_FLAGS f = {bindflags, 0, 0, 0};
    ID3D11Texture2D * text = nullptr;

    if (m_11on12->CreateWrappedResource(r, &f, D3D12_RESOURCE_STATE_PRESENT, D3D12_RESOURCE_STATE_PRESENT,
                                        __uuidof(ID3D11Texture2D), (void**)&text) != 0)
    {
        D3D12LOG("CreateWrappedResource FAILED");
        return 0;
    }

    ID3D11Resource * R[] = {text};
    m_11on12->AcquireWrappedResources(R, 1);
    return text;
}

void  __stdcall D3D11HelperDvc::UnAccquireTexture(ID3D11Texture2D* text)
{
    ID3D11Resource * R[] = {text};
    m_11on12->ReleaseWrappedResources(R, 1) ;
    text->Release();
    return;
}

HRESULT __stdcall D3D11HelperDvc::Present(IDXGISwapChain* SChain, UINT SyncInterval, UINT Flags)
{
    ID3D12Resource     * BackBufffer12  = nullptr;   
    IDXGISwapChain3    * Schain3        = nullptr;
    ID3D12Resource  * Src12             = nullptr;
    ID3D11Texture2D * Source            = nullptr;
    ID3D11Texture2D * BackBufffer11     = nullptr;
    DWORD index = 0;
    if (SChain->QueryInterface(__uuidof(IDXGISwapChain3), (void**)&Schain3) != 0)
    {
        D3D12LOG("QueryInterface(__uuidof(IDXGISwapChain3), FAILED");
        goto D3D12HelperDvcNT_blt_failed;
    }
    index = Schain3->GetCurrentBackBufferIndex();
    if (g_d3d.GetBuffer((IDXGISwapChain2*)SChain, index, __uuidof(ID3D12Resource), (void**)&BackBufffer12) != 0)
    {
        D3D12LOG("IDXGISwapChain::GetBuffer FAILED");
        goto D3D12HelperDvcNT_blt_failed;
    }
    Src12         = GetBuffer(SChain, index);
    Source        = AccquireTexture(Src12, D3D11_BIND_SHADER_RESOURCE);
    BackBufffer11 = AccquireTexture(BackBufffer12, D3D11_BIND_RENDER_TARGET);

    if (g_d3d.AMDFSR) FSR(Source, BackBufffer11);
    else              CSBlit(Source, BackBufffer11);
    Copy2Screen(m_Pass1Output, BackBufffer11);

    UnAccquireTexture(Source);
    UnAccquireTexture(BackBufffer11);
    m_Ctxt->Flush();

    if (g_d3d.Present((IDXGISwapChain2*)SChain, SyncInterval, Flags) != 0)
    D3D12LOG("Present FAILED");
    D3D12HelperDvcNT_blt_failed:

    if (BackBufffer12) BackBufffer12->Release();
    if (Schain3)       Schain3->Release();
    if (Src12)         Src12->Release();
    return 0;
}

extern "C" __declspec(dllexport) BOOL __stdcall D3D12ResizeGameWindow(HWND hwin)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    RECT r;
    g_d3d.m_GetClientRect(hwin, &r);
    if (r.left == 0 && r.top == 0 && r.right == g_d3d.HD_W && r.bottom == g_d3d.HD_H) return 0;
    MoveWindow(hwin, 0, 0, g_d3d.HD_W, g_d3d.HD_H, 0);
    SendMessageA(hwin, WM_SIZE, 0, g_d3d.m_WW->Get()|(g_d3d.m_HH->Get()<<16)) ;
    return 1;
}

double D3D12GetMemoryUsage(IUnknown* i, UINT shared=0)
{
    if (i == nullptr)
    {
        return 1.;
    }
    IDXGIDevice* dvc = (IDXGIDevice*) EZInterface(__uuidof(IDXGIDevice), i).I();
    if (dvc == nullptr)
    {
        return 2.;
    } 
    IDXGIAdapter * adp = nullptr;
    if (dvc->GetAdapter(&adp) != S_OK)
    {
        return 3.;
    } 
    IDXGIAdapter3 * adp3 = (IDXGIAdapter3*)EZInterface(__uuidof(IDXGIAdapter3), adp).I();    
    if (dvc == nullptr)
    {     
        adp->Release();
        return 4.;
    }
    DXGI_QUERY_VIDEO_MEMORY_INFO nfo = {};
    if (adp3->QueryVideoMemoryInfo(0, (DXGI_MEMORY_SEGMENT_GROUP)shared, &nfo) != S_OK)
    {
        adp->Release();
        return 5.;
    }
    adp->Release();
    return (double)nfo.CurrentUsage/1000000.;
}


