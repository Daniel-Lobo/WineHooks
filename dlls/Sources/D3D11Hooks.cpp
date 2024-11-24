#include <windows.h>
#include "collections.h"
#include "D3D12Hooks.h"
#include <d3d11.h>
#include <d3d10.h>
#include <d3d10_1.h>
#include <d3dcompiler.h>
#include "D3D12Utils.h"
#include "D3D11Hooks.h"
#include "Sync.h"
#include "FileSystem.h"
#include <memory>
#include "Dbug.h"
#include "sethooks.h"
#include "dllmain.h"
#include "MouseHooks.h"
#include <intrin.h>
extern "C"{
#include "DDSurface.h"
}

using std::string;
using std::to_string;
D3D11_HOOKS                              * D3D11_Hooks;
D3D11_GLOBALS                             D3D11Globals;

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D11CreateSamplerHook(ID3D11Device * dvc, const D3D11_SAMPLER_DESC* D, ID3D11SamplerState **pS)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (D)
    {
        D3D11_SAMPLER_DESC newdesc;
        memcpy(&newdesc, D, sizeof(D3D11_SAMPLER_DESC));
        newdesc.MipLODBias = log2f(g_d3d.mScl->Get()) * -1;        
        return g_d3d.D3D11CreateSampler(dvc, &newdesc, pS);
    }
    return g_d3d.D3D11CreateSampler(dvc, D, pS);
}

extern "C" __declspec(dllexport)
DWORD GetDirect3D11(HWND hWnd, ID3D11 * _D3D,  D3D_FEATURE_LEVEL * level)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (g_d3d.m_CreateDXGIFactory == nullptr || g_d3d.m_D3D11CreateDvcAndSChain == nullptr ||
        g_d3d.m_D3DReflect        == nullptr || g_d3d.m_D3DDisassemble          == nullptr) return 1;

    GUID IID_IDXGISwapChain1;
    GUID IID_IDXGIFactory2;

    HRESULT              hr;
    DXGI_SWAP_CHAIN_DESC sd;    
    IDXGIDevice          * pDXGIDevice  = NULL;
    IDXGIAdapter         * pDXGIAdapter = NULL;
    const D3D_FEATURE_LEVEL levels[7] =
    {
        D3D_FEATURE_LEVEL_12_1,
        D3D_FEATURE_LEVEL_12_0,
        D3D_FEATURE_LEVEL_11_1,
        D3D_FEATURE_LEVEL_11_0,
        D3D_FEATURE_LEVEL_10_1,
        D3D_FEATURE_LEVEL_10_0,
        D3D_FEATURE_LEVEL_9_3,
        //D3D_FEATURE_LEVEL_9_2,
        //D3D_FEATURE_LEVEL_9_1,
    };

    ZeroMemory( &sd, sizeof( sd ) );
    sd.BufferCount = 1;
    sd.BufferDesc.Width  = 640;
    sd.BufferDesc.Height = 480;
    sd.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    sd.BufferDesc.RefreshRate.Numerator = 60;
    sd.BufferDesc.RefreshRate.Denominator = 1;
    sd.BufferUsage  = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    sd.OutputWindow = hWnd;
    sd.SampleDesc.Count   = 1;
    sd.SampleDesc.Quality = 0;
    sd.Windowed           = TRUE;

    DWORD flags = 0;
#ifdef D3D10_AND11_USE_DBUG_LAYER
    flags |=  D3D11_CREATE_DEVICE_DEBUG;
#endif
    hr = g_d3d.m_D3D11CreateDvcAndSChain(NULL, D3D_DRIVER_TYPE_HARDWARE, NULL, flags, levels,
                                         7, D3D11_SDK_VERSION, &sd, &_D3D->pSwapChain, &_D3D->pDev,
                                         level, &_D3D->pContext);
    if (hr != 0) return 3;

    ID3D11DeviceContext1 * ctx1 = nullptr;
    if (_D3D->pContext->QueryInterface(__uuidof(ID3D11DeviceContext1), (void **)&ctx1) != 0)
    DBUG_WARN("FAILED TO GET ID3D11DeviceContext1* ptr");

    IIDFromString(L"{790a45f7-0d42-4876-983a-0a55cfe6f4aa}", &IID_IDXGISwapChain1);
    if (_D3D->pSwapChain->QueryInterface((const IID)IID_IDXGISwapChain1, (void**)&_D3D->pSwapChain1) != 0)
        return 4;

    if (_D3D->pDev->CreateDeferredContext(0, &_D3D->pDefferedContext) != 0)
        return 5;

    if (_D3D->pDev->QueryInterface(__uuidof(IDXGIDevice), (void **)&pDXGIDevice) != 0)
        return 6;

    if (pDXGIDevice->GetAdapter( &pDXGIAdapter ) != 0)
        return 7;

    if (pDXGIAdapter->GetParent(__uuidof(IDXGIFactory), (void **)&_D3D->pFactory) != 0)
        return 8;

    IIDFromString(L"{50c83a1c-e072-4c48-87b0-3630fa36a6d0}", &IID_IDXGIFactory2);
    if (_D3D->pFactory->QueryInterface((const IID)IID_IDXGIFactory2, (void**)&_D3D->pFactory2) != 0)
        return 9;

    ID3D11Texture2D* pBackBuffer = NULL;
    hr = _D3D->pSwapChain->GetBuffer( 0, __uuidof( ID3D11Texture2D ), ( LPVOID* )&pBackBuffer );
    if( FAILED( hr ) )
        return hr;

    ID3D11RenderTargetView* pRenderTargetView = NULL;
    hr = _D3D->pDev->CreateRenderTargetView( pBackBuffer, NULL, &pRenderTargetView );
    pBackBuffer->Release();
    if( FAILED( hr ) )
        return hr;

    _D3D->pContext->OMSetRenderTargets( 1, &pRenderTargetView, NULL );

    D3D11_VIEWPORT viewport;
    ZeroMemory(&viewport, sizeof(D3D11_VIEWPORT));
    viewport.TopLeftX = 0;
    viewport.TopLeftY = 0;
    viewport.Width = static_cast<float>(640);
    viewport.Height = static_cast<float>(480);
    viewport.MinDepth = 0.0f;
    viewport.MaxDepth = 1.0f;
    _D3D->pContext->RSSetViewports(1, &viewport);
    pRenderTargetView->Release();

    pDXGIDevice->Release();
    pDXGIAdapter->Release();

    if (g_d3d.AMDFSR)
    {
        LOGHOOK(ID3D11Device, CreateSamplerState, _D3D->pDev, &g_d3d.D3D11CreateSampler, D3D11CreateSamplerHook)
    }
    if (g_d3d.USEPROXIES)
    {
        LOGHOOK(ID3D11DeviceContext, OMSetRenderTargetsAndUnorderedAccessViews, _D3D->pContext, &D3D11Globals.m_OMSetRenderTargetsAndUAVs, 
                OMSetRenderTargetsAndUnorderedAccessViewsHook)
    }
    if (g_d3d.HDPROXIES)
    {
        LOGHOOK(ID3D11DeviceContext, DrawIndexed, _D3D->pContext, &D3D11Globals.m_DrawIndexed, D3D11DrawIndexedHook)
        LOGHOOK(ID3D11DeviceContext, Draw, _D3D->pContext, &D3D11Globals.m_Draw, D3D11DrawHook)
        LOGHOOK(ID3D11DeviceContext, DrawAuto, _D3D->pContext, &D3D11Globals.m_DrawAuto, D3D11DrawAutoHook)
        LOGHOOK(ID3D11DeviceContext, DrawInstanced, _D3D->pContext, &D3D11Globals.m_DrawInstanced, D3D11DrawInstancedHook)
        LOGHOOK(ID3D11DeviceContext, DrawInstancedIndirect, _D3D->pContext, &D3D11Globals.m_DrawInstancedIndirect, D3D11DrawInstancedIndirectHook)
        LOGHOOK(ID3D11DeviceContext, DrawIndexedInstanced, _D3D->pContext, &D3D11Globals.m_DrawIndexedInstanced, D3D11DrawIndexedInstancedHook)
        LOGHOOK(ID3D11DeviceContext, DrawIndexedInstancedIndirect, _D3D->pContext, &D3D11Globals.m_DrawIndexedInstancedIndirect, D3D11DrawIndexedInstancedIndirectHook)
        if (nullptr != ctx1)
        LOGHOOK(ID3D11DeviceContext1, ClearView, ctx1, &D3D11Globals.m_ClearView, D3D11ClearViewHook)
        //LOGHOOK(ID3D11DeviceContext, RSSetViewports, _D3D->pContext, &D3D11Globals.m_RSSetViewports, D3D11RSSetViewportsHook)
    } 
    return 0;
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D11CreateDeviceHook(IDXGIAdapter *pAdapter, D3D_DRIVER_TYPE type, HMODULE Software, UINT,
                      const D3D_FEATURE_LEVEL *lvls, UINT lvl, UINT version, ID3D11Device **Dvc,
                      D3D_FEATURE_LEVEL *plvl, ID3D11DeviceContext **Cntxt)
{
    HRESULT hr = D3D11Globals.m_D3D11CreateDevice(pAdapter, type, Software, D3D11_CREATE_DEVICE_DEBUG,
                                                  lvls, lvl, version, Dvc, plvl, Cntxt);
    if (hr) DBUG_WARN("FAILED")
    else    DBUG_WARN("=)");
    return hr;
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D10CreateDeviceHook(IDXGIAdapter *pAdapter,D3D10_DRIVER_TYPE type, HMODULE Soft, UINT Flags,
                      UINT Version, ID3D10Device **ppDevice)
{
    return D3D11Globals.m_D3D10CreateDevice(pAdapter, type, Soft, Flags|D3D10_CREATE_DEVICE_DEBUG,
                                            Version, ppDevice);
}

extern "C" __declspec(dllexport) void __stdcall D3D11SetupFinished(IDXGISwapChain*sc){
   #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
   g_d3d.ApplyCommonDXGIHooks(sc, g_d3d.UPSCALE);
   D3D11_Hooks->IDXGISChainGetDesc  = (HRESULT (__stdcall *)(IDXGISwapChain*,DXGI_SWAP_CHAIN_DESC *))g_d3d.m_IDXGISwapChainGetDesc;
   D3D11_Hooks->IDXGISChainGetDesc1 = (HRESULT (__stdcall *)(LPVOID,DXGI_SWAP_CHAIN_DESC_1 *))g_d3d.m_IDXGISwapChainGetDesc1;
   D3D11Globals.lock->unlock();
}

extern "C" __declspec(dllexport) LPVOID __stdcall InitD3D11Hooks(D3D11_HOOKS * pD3D11Hooks, char * winedir, char * dxvkdir, char * gamedir, UINT flags)
{
#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)   
    g_d3d.Init();    
    D3D11Globals.Init();
    D3D11LoadWine(winedir, dxvkdir, gamedir, flags);  
#ifdef D3D10_AND11_USE_DBUG_LAYER
    HOOK(&D3D11Globals.m_D3D11CreateDevice, D3D11CreateDeviceHook);
    HOOK(&D3D11Globals.m_D3D10CreateDevice, D3D10CreateDeviceHook);
#endif
    g_d3d.SetReslimit(pD3D11Hooks->W, pD3D11Hooks->H);
    D3D11Globals.max_height = pD3D11Hooks->H;
    D3D11Globals.max_width  = pD3D11Hooks->W;
    DBUG_LOG((std::string("Highest mode: ")+
              std::to_string(D3D11Globals.max_width)+"x"+std::to_string(D3D11Globals.max_height)).c_str());

    D3D11_Hooks = pD3D11Hooks;
    D3D11Globals.lock->lock();
    if (g_d3d.UPSCALE) g_d3d.ApplyCommonHooks(0xf);    
    return 0;
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11PSSetSamplersHook(ID3D11DeviceContext * c, UINT Start,
                                      UINT n, ID3D11SamplerState *const *smplrs)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D11_Hooks->PSSetSamplers(c, Start, n, smplrs);
    return;
    ID3D11SamplerState ** proxy_samplers = new ID3D11SamplerState *[n];
    D3D11_SAMPLER_DESC    Desc;
    for (UINT i=Start; i<Start+n; i++)
    {
        proxy_samplers[i] = nullptr;
        if (smplrs[i])
        {
            smplrs[i]->GetDesc(&Desc);
            Desc.Filter = D3D11_FILTER_MIN_MAG_MIP_POINT;
            if ( D3D11GetDevice(c)->CreateSamplerState(&Desc, &proxy_samplers[i]) )
                DBUG_WARN("FAILED TO CREATE SAMPLER");
        }
    }
    D3D11_Hooks->PSSetSamplers(c, Start, n, proxy_samplers);
    for (UINT i=Start; i<Start+n; i++)
    {
        if (proxy_samplers[i]) proxy_samplers[i]->Release();
    }
    delete [] proxy_samplers;
}

LPVOID * D3D11TextureID(ID3D11Texture2D * r)
{
    IUnknown * ID = 0;
    r->QueryInterface(__uuidof(IUnknown), (void **)&ID);
    if (ID) D3D11_Hooks->ReleaseTexture2D((ID3D11Texture2D *)r);
    return (LPVOID*)ID;
}

LPVOID * D3D11TextureID(ID3D11Resource * r)
{
    ID3D11Texture2D * tx = 0;
    if (r->QueryInterface(__uuidof(ID3D11Texture2D), (void **)&tx))
    return 0;
    D3D11_Hooks->ReleaseTexture2D((ID3D11Texture2D *)tx);
    return D3D11TextureID(tx);
}

HRESULT __stdcall D3D11TextureFound(ID3D11Resource * rs, char* file)
{
    ID3D11Texture2D * Tex = D3D11LoadTexture(D3D11DeviceFromChild(rs).Dvc(), file);
    if ( Tex )
    {
        D3D11TexUnWrapp r( (IUnknown*) rs);
        ID3D11ProxyTexture * proxy = new ID3D11ProxyTexture(Tex);
        //ID3D11Weak         * weak  = new ID3D11Weak(r.m_tx2d);

        if (r.m_tx2d->SetPrivateDataInterface((GUID &)g_.D3D11ProxyTexture, (IUnknown*)proxy) != 0)
            DBUG_WARN("SetPrivateDataInterface FAILED");

        //if (Tex->SetPrivateDataInterface((GUID &)g_.D3D11Weak, (IUnknown*)weak) != 0)
            //DBUG_WARN("SetPrivateDataInterface FAILED");
    }    
    return 0;
}

void D3D11FindTexture2D(ID3D11_MAPPED * m, ID3D11Resource * ID, DWORD)
{
    DWORD fmt = GetDXGISurfacePxFormat(m->d.Format);
    D3D11Globals.lock->lock();
    std::string * rep
              = g_.FindTexture(m->d.Width, m->d.Height, m->m.RowPitch, (char*)&fmt, (BYTE*)m->m.pData);
    D3D11Globals.lock->unlock();
    if (rep)
        D3D11TextureFound(ID, (char*)rep->c_str());
}

extern "C" __declspec(dllexport) 
HRESULT __stdcall D3D11CreateTexture2DHook(ID3D11Device * d,
                                           const D3D11_TEXTURE2D_DESC * dsc,
                                           const D3D11_SUBRESOURCE_DATA * dat,
                                           ID3D11Texture2D ** pt)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)  
    HRESULT err = D3D11_Hooks->CreateTexture2D(d, dsc, dat, pt);
    // D3D11HelperDvc::InitResources crashes without the D3D11_BIND_UNORDERED_ACCESS check
    if (err == S_OK && !(dsc->BindFlags & D3D11_BIND_UNORDERED_ACCESS)
                   /*&& !(dsc->Usage & D3D11_USAGE_DYNAMIC)*/) // Excluding dynamic textures breaks unity games
    {
        if ( (dsc->BindFlags & D3D11_BIND_SHADER_RESOURCE) || (dsc->Usage & D3D11_USAGE_STAGING))
        {
            C_D3D11_TEXTURE2D_DESC * desc = new C_D3D11_TEXTURE2D_DESC();
            memcpy(desc, dsc, sizeof(D3D11_TEXTURE2D_DESC));

            D3D11Globals.lock->lock();
            D3D11_Hooks->textures->insert(D3D11TextureID(*pt), desc);
            D3D11Globals.lock->unlock();
        }
        if (dat && D3D11_Hooks->replacements)
        {
            ID3D11_MAPPED m;
            m.m.pData    = (void*)dat[0].pSysMem;
            m.m.RowPitch = dat[0].SysMemPitch;
            memcpy(&m.d, dsc, sizeof(D3D11_TEXTURE2D_DESC));
            if      ( (dsc->Format >= 70) && (dsc->Format <= 72) ) m.compressed = 1;
            else if ( (dsc->Format >= 73) && (dsc->Format <= 84) ) m.compressed = 2;
            else                                                   m.compressed = 0;
            D3D11FindTexture2D(&m, *pt, FALSE);
        }
    }
    return err;
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11UpdateSubresourceHook(ID3D11DeviceContext* ctx, ID3D11Resource *pDstResource,
                                          UINT DstSubresource, const D3D11_BOX *pDstBox,
                                          const void *pSrcData, UINT SrcRowPitch,
                                          UINT SrcDepthPitch)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)  
    D3D11_Hooks->UpdateSubresource(ctx, pDstResource, DstSubresource, pDstBox,
                                   pSrcData, SrcRowPitch, SrcDepthPitch);

    if (pSrcData == nullptr) return;
    D3D11TexUnWrapp tx(pDstResource);
    if (tx.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D) return;

    D3D11_TEXTURE2D_DESC * D = tx.Desc();
    ID3D11_MAPPED * m = new ID3D11_MAPPED();

    memcpy(&m->d, D, sizeof(D3D11_TEXTURE2D_DESC));
    m->m.RowPitch = SrcRowPitch;
    m->m.pData    = (void*)pSrcData;
    D3D11FindTexture2D(m, pDstResource, 0);
    delete m;
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11ResolveSubresourceHook(ID3D11DeviceContext* dvc, ID3D11Resource *pDst,
                                           UINT DstSub, ID3D11Resource *pSrc,
                                           UINT SrcSub, DXGI_FORMAT Format)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if (!g_d3d.USEPROXIES)
    {
        D3D11_Hooks->ResolveSubresource(dvc, pDst, DstSub, pSrc, SrcSub, Format);
    }
    
    ID3D11ProxyTexture * dest_proxy = nullptr;
    ID3D11ProxyTexture * src_proxy  = D3D11GetProxy( pSrc );
    if (src_proxy)
    {
        if (src_proxy->m_Istarget)
        {
            ID3D11ProxyTexture * dest_proxy = D3D11GetProxy(pDst, __FUNCTION__);
            if (!dest_proxy)
            {
                DBUG_WARN("NO PROXY");
                return;
            }
            D3D11_Hooks->ResolveSubresource(dvc, dest_proxy->m_proxy, DstSub,
                                                 src_proxy->m_proxy, SrcSub, Format);
            return;
        }
    } else if ( (dest_proxy=D3D11GetProxy(pDst)) )
    {
        if (dest_proxy->m_Istarget) DBUG_WARN("COPY TO RENDER TARGET");
    }
}

extern "C" __declspec(dllexport) void __stdcall D3D11CopyResourceHook(ID3D11DeviceContext* dvc, ID3D11Resource *pDst,  ID3D11Resource *pSrc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if (!g_d3d.USEPROXIES)
    {
        D3D11_Hooks->CopyResource(dvc, pDst, pSrc);
    }

    ID3D11ProxyTexture * dest_proxy = nullptr;
    ID3D11ProxyTexture * src_proxy  = D3D11GetProxy( pSrc );
    if (src_proxy)
    {
        if (src_proxy->m_Istarget)
        {
            ID3D11ProxyTexture * dest_proxy = D3D11GetProxy(pDst, __FUNCTION__);
            if (!dest_proxy)
            {
                DBUG_WARN("NO PROXY");
                return;
            }
            D3D11_Hooks->CopyResource(dvc, dest_proxy->m_proxy, src_proxy->m_proxy);
            return;
        }
    } else if ( (dest_proxy=D3D11GetProxy(pDst)) )
    {
        if (dest_proxy->m_Istarget) DBUG_WARN("COPY TO RENDER TARGET");
    }
    D3D11_Hooks->CopyResource(dvc, pDst, pSrc);
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11CopySubresourceRegionHook(ID3D11DeviceContext* ctx, ID3D11Resource *pDstResource,  UINT DstSubresource, UINT DstX, UINT DstY,
                                                UINT DstZ, ID3D11Resource *pSrcResource, UINT SrcSubresource, D3D11_BOX *pSrcBox)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)   
    if (g_d3d.USEPROXIES)
    {
        ID3D11ProxyTexture * dest_proxy = nullptr;
        ID3D11ProxyTexture * src_proxy  = D3D11GetProxy( pSrcResource );
        if (src_proxy)
        {
            if (src_proxy->m_Istarget)
            {
                ID3D11ProxyTexture * dest_proxy = D3D11GetProxy(pDstResource, __FUNCTION__);
                /* This texture might not be a render target, and may even be sysmem, but we tag it as render target 
                 * because we must copy the contents of the proxy back to the original, if it is mapped latter */
                dest_proxy->m_Istarget = TRUE;
                if (!dest_proxy)
                {
                    DBUG_WARN("NO PROXY");
                    return;
                }   
                float scale = g_d3d.HDPROXIES == 0 ? 1.f : g_d3d.mScl->Get() * g_d3d.SSAA;
                if (pSrcBox != nullptr && g_d3d.HDPROXIES != 0)
                {
                    D3D11_BOX new_box = {};                    
                    new_box.left   = pSrcBox->left * scale;
                    new_box.top    = pSrcBox->top * scale;
                    new_box.front  = pSrcBox->front * scale;
                    new_box.right  = pSrcBox->right * scale;
                    new_box.bottom = pSrcBox->bottom * scale;
                    new_box.back   = pSrcBox->back * scale;
                    D3D11_Hooks->CopySubresourceRegion(ctx, dest_proxy->m_proxy, DstSubresource, DstX * scale, DstY * scale, DstZ * scale,
                                                       src_proxy->m_proxy, SrcSubresource, &new_box);
                }
                else D3D11_Hooks->CopySubresourceRegion(ctx, dest_proxy->m_proxy, DstSubresource, DstX * scale, DstY * scale, DstZ * scale,
                                                        src_proxy->m_proxy, SrcSubresource, pSrcBox);
                
                return;
            }
        } else if ( (dest_proxy=D3D11GetProxy(pDstResource)) )
        {
            if (dest_proxy->m_Istarget) DBUG_WARN("COPY TO RENDER TARGET");
        }
    }

    D3D11_Hooks->CopySubresourceRegion(ctx, pDstResource, DstSubresource, DstX, DstY, DstZ, pSrcResource, SrcSubresource, pSrcBox);
    return;

    if (DstSubresource == 0)
        pDstResource->SetPrivateData((GUID &)g_.D3D11ProxyTexture, 0, nullptr);
    if (pSrcBox || SrcSubresource > 0 || DstSubresource > 0)
        return;

    IUnknown * proxy = nullptr;
    UINT       size  = sizeof(IUnknown*);
    if ( pSrcResource->GetPrivateData((GUID &)g_.D3D11ProxyTexture, &size, &proxy) == 0)
    {
        proxy->Release();
        pDstResource->SetPrivateDataInterface((GUID &)g_.D3D11ProxyTexture, proxy);
    }
}

extern "C" __declspec(dllexport) 
HRESULT __stdcall D3D11MapHook(ID3D11DeviceContext* ctx, ID3D11Resource* r, UINT sub,
                               D3D11_MAP type, UINT flags, D3D11_MAPPED_SUBRESOURCE* map)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    ID3D11ProxyTexture* proxy = D3D11GetProxy(r);
    if (proxy != nullptr)
    {
        /* signalis photos and save thumbnails */
        if (proxy->m_Istarget) 
        {
            //DBUG_WARN((string("RENDER TARGET MAP ") + to_string(sub)).c_str());
            g_d3d.D3D11DvcNT.DwnScaleBlit(proxy->m_proxy, r);
        }
        else
        {
            if (sub == 0) r->SetPrivateData((GUID&)g_.D3D11ProxyTexture, 0, nullptr);
        }
    }

    HRESULT err  = D3D11_Hooks->Map(ctx, r, sub, type, flags, map);
    LPVOID * ID  = D3D11TextureID(r);        

    if (err == S_OK && sub == 0)
    {
        D3D11Globals.lock->lock();
        D3D11_TEXTURE2D_DESC * d = (D3D11_TEXTURE2D_DESC *)D3D11_Hooks->textures->Value(ID);
        D3D11Globals.lock->unlock();
        if (map && d)
        {
            ID3D11_MAPPED * _m = (ID3D11_MAPPED *)
                    VirtualAlloc(NULL,sizeof(ID3D11_MAPPED),0x00001000|0x00002000,
                                 PAGE_READWRITE);
            if (nullptr != _m)
            {
                memcpy(&_m->m, map, sizeof(D3D11_MAPPED_SUBRESOURCE));
                memcpy(&_m->d, d, sizeof(D3D11_TEXTURE2D_DESC));
                D3D11Globals.lock->lock();
                D3D11Globals.MappedTextures->insert(ID, _m);
                D3D11Globals.lock->unlock();
            }
        }
    }
    return err;
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11UnmapHook(ID3D11DeviceContext* ctx, ID3D11Resource* r, UINT sub)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID * ID       = D3D11TextureID(r);
    ID3D11_MAPPED * m = (ID3D11_MAPPED *)D3D11Globals.MappedTextures->Value(ID);
    if ( m )
    {
        D3D11FindTexture2D(m, r, 0);
    }
    D3D11Globals.lock->lock();
    D3D11Globals.MappedTextures->remove(ID);
    D3D11Globals.lock->unlock();
    D3D11_Hooks->Unmap(ctx, r, sub);    
}

ID3D11PixelShader * IsD3D11Px(IUnknown * i)
{
    ID3D11PixelShader * px = nullptr;
    if (i->QueryInterface(__uuidof(ID3D11PixelShader), (void**)&px) == 0)
    D3D11_Hooks->PxShaderRelease(px);
    return px;
}

extern "C" __declspec(dllexport) HRESULT __stdcall D3D11Texture2DReleaseHook(ID3D11Texture2D * v)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID *ID  = D3D11TextureID(v);
    HRESULT err = D3D11_Hooks->ReleaseTexture2D(v);
    if (err == S_OK)
    {
        D3D11Globals.lock->lock();
        C_D3D11_TEXTURE2D_DESC * d =
                (C_D3D11_TEXTURE2D_DESC *)D3D11_Hooks->textures->Value(ID);
        D3D11_Hooks->textures->discard(ID);
        D3D11Globals.lock->unlock();
        if (d) delete d;        
    }
    return err;
}

extern "C" __declspec(dllexport) 
HRESULT __stdcall D3D11CreateShaderResourceViewHook(ID3D11Device * d, ID3D11Resource * r,
                                          D3D11_SHADER_RESOURCE_VIEW_DESC * dc,
                                          ID3D11ShaderResourceView ** v)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return D3D11_Hooks->CreateShaderResourceView(d, r, dc, v);
}

extern "C" __declspec(dllexport) HRESULT __stdcall D3D11ResourceViewReleaseHook(ID3D11ShaderResourceView * v)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;   
    err = D3D11_Hooks->ReleaseShaderResourceView(v);
    return err;
}

LPVOID D3D11TextureIDFromView(ID3D11View * v)
{
    ID3D11Resource * r = nullptr;
    if (v == nullptr) return v;

    v->GetResource(&r);
    if (r)
    {
        r->Release();
        return D3D11TextureID(r);
    }
    return r;
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11PSSetShaderResourcesHook(ID3D11DeviceContext* d, UINT a, UINT b, ID3D11ShaderResourceView * const * r)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    ID3D11ShaderResourceView   ** proxy_views  = new ID3D11ShaderResourceView*[b];
    ID3D11ShaderResourceView    * proxy_view   = nullptr;
    ID3D11ProxyTexture          * tx_proxy     = nullptr;
    ID3D11Resource                 *   res     = nullptr;
    DWORD  i;
    for (i=0; i<b; i++)
    {
        proxy_views[i] = r[i];
        if (r[i] == nullptr) continue;

        res     = D3D11GetResource(r[i]);
        if(res == nullptr)
        {
            D3D11LOG("RESOUCE NOT FOUND");
            continue;
        } else if ( COMObjectID(res) == COMObjectID(D3D11_Hooks->current_view) )
        {
            proxy_views[i] = D3D11Globals.m_CheckBoardPattern;
            D3D11Globals.m_CheckBoardPattern->AddRef();
            continue;
        }

        tx_proxy = D3D11GetProxy(res);
        if ( tx_proxy )
        {
            proxy_view = tx_proxy->SRV(d, r[i], res);
            if ( proxy_view )
            {
                proxy_views[i] = proxy_view;
            }
            else DBUG_WARN("NO PROXY VIEW");
        } else proxy_views[i]->AddRef();
    }
    D3D11_Hooks->ImPSSetShaderResources(d, a, b, proxy_views);
    for (i=0; i<b; i++)
    {
        if (proxy_views[i]) proxy_views[i]->Release();
    }
    delete [] proxy_views;    
    if ((a+b) < 64)
    {
        D3D11_Hooks->ImPSSetShaderResources(d, a+64, b, r);
    }
}

ID3D11DeviceContext * D3D11Cntxt(ID3D11Device * d)
{
    ID3D11DeviceContext * ctx = NULL;
    d->GetImmediateContext(&ctx);
    if (ctx == NULL)
    {
        DBUG_WARN("No context")
        return 0;
    }
    ctx->Release();    
    return ctx;
}

extern "C" __declspec(dllexport) ID3D11Device * GetD3D11DvcFromDXGIDvc(IUnknown * i)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    ID3D11Device * dvc = nullptr;
    if (i->QueryInterface(__uuidof(ID3D11Device), (void**)&dvc) == 0)
    dvc->Release();
    return dvc;
}

extern "C" __declspec(dllexport) BOOL IsD3D11Device(IUnknown * i)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IUnknown * d3d;
    if (i->QueryInterface(__uuidof(ID3D10Device1), (void**)&d3d) != 0)
    return true;
    d3d->Release();
    return false;
}

void D3D11Present(IDXGISwapChain * Iface, UINT sync, UINT flags)
{
    IUnknown * bb = (IUnknown *)D3D11Globals.BackBuffrerID->Get();
    if (bb)
    {        
        D3D11TexUnWrapp Backbuff(bb, TRUE);
        if (Backbuff.m_tx2d)
        {
            if (g_d3d.USEINTEROP)
            {
                ID3D11ProxyTexture * proxybb = D3D11GetProxy(Backbuff.m_tx2d);  
                if (proxybb == nullptr)  /* will be null if g_d3d.USEPROXIES == FALSE */
                {                   
                    ID3D11Texture2D * BB             = nullptr;
                    ID3D11Texture2D * RealBackBuffer = nullptr;
                    Backbuff.m_tx2d->QueryInterface(__uuidof(ID3D11Texture2D), (void**)&BB);
                    D3D11_Hooks->GetBuffer(Iface, 0, __uuidof( ID3D11Texture2D ), ( LPVOID* )&RealBackBuffer );
                    if( RealBackBuffer && BB)
                    {
                        if (g_d3d.AMDFSR) g_d3d.D3D11DvcNT.FSR(BB, RealBackBuffer);
                        else              g_d3d.D3D11DvcNT.CSBlit(BB, RealBackBuffer);

                        if (g_d3d.GAMMAFIX) D3D11Blit(Iface, g_d3d.D3D11DvcNT.m_Pass1Output, nullptr, &D3D11Globals.BackBufferRect, nullptr);
                        else                g_d3d.D3D11DvcNT.Copy2Screen(g_d3d.D3D11DvcNT.m_Pass1Output, RealBackBuffer);
                        
                        RealBackBuffer->Release();
                        BB->Release();
                    } else DBUG_WARN("NO BACKBUFFER");
                } else {
                    ID3D11Texture2D * RealBackBuffer = nullptr;
                    D3D11_Hooks->GetBuffer(Iface, 0, __uuidof( ID3D11Texture2D ), ( LPVOID* )&RealBackBuffer );
                    if (RealBackBuffer && proxybb->m_proxy)
                    {
                        if (g_d3d.HDPROXIES) {
                            if (g_d3d.SSAA > 1)
                            {
                                g_d3d.D3D11DvcNT.SSAABlit((ID3D11Texture2D*)proxybb->m_proxy, g_d3d.D3D11DvcNT.m_Pass1Output);
                                g_d3d.D3D11DvcNT.Copy2Screen(g_d3d.D3D11DvcNT.m_Pass1Output, RealBackBuffer);
                            }
                            else {
                                if (g_d3d.GAMMAFIX) D3D11Blit(Iface, (ID3D11Texture2D*)proxybb->m_proxy, nullptr, &D3D11Globals.BackBufferRect, nullptr);
                                else                g_d3d.D3D11DvcNT.Copy2Screen((ID3D11Texture2D*)proxybb->m_proxy, RealBackBuffer);
                            }
                        } else {
                            if (g_d3d.AMDFSR) g_d3d.D3D11DvcNT.FSR((ID3D11Texture2D*)proxybb->m_proxy, RealBackBuffer);
                            else              g_d3d.D3D11DvcNT.CSBlit((ID3D11Texture2D*)proxybb->m_proxy, RealBackBuffer);
                            g_d3d.D3D11DvcNT.Copy2Screen(g_d3d.D3D11DvcNT.m_Pass1Output, RealBackBuffer);
                        }                        
                        RealBackBuffer->Release();
                    } else DBUG_WARN("NO BACKBUFFER");
                }
            } else {
                ID3D11ProxyTexture * proxybb = D3D11GetProxy(Backbuff.m_tx2d);
                /* will be null if g_d3d.USEPROXIES == FALSE */
                if (proxybb == nullptr)  D3D11Blit(Iface, Backbuff.m_tx2d, nullptr, &D3D11Globals.BackBufferRect, nullptr);                
                else                     D3D11Blit(Iface, proxybb->m_proxy, nullptr, &D3D11Globals.BackBufferRect, nullptr);                
            }
        }
    }
    
    ID3D11Device * pDvc = D3D11DvcFromSChain(Iface);
    if (pDvc == nullptr)
    {
        DBUG_WARN("D3D11DvcFromSChain FAILED");
        return;
    }
    ID3D11DeviceContext * ctx = D3D11Cntxt(pDvc);
    if (ctx == nullptr)
    {
        DBUG_WARN("D3D11Cntxt FAILED");
        return;
    }

    D3D11Bytecode  * c;
    D3D11Globals.lock->lock();
    DWORD p = D3D11_Hooks->IDXGISwapChain_Present_Callback(Iface, sync, flags);
    D3D11Globals.PixelShader->Set(D3D11_Hooks->CurrentPxShader);
    D3D11Globals.TextID->Set(D3D11_Hooks->current_view);
    D3D11Globals.lock->unlock();

    if (D3D11_Hooks->PxBlob)
    {
        ID3D11PixelShader * px = nullptr;
        if (D3D11_Hooks->CreatePixelShader(pDvc, D3D11_Hooks->PxBlob->GetBufferPointer(), D3D11_Hooks->PxBlob->GetBufferSize(), nullptr, &px) == 0)
        {
            D3D11Globals.lock->lock();
            c = (D3D11Bytecode *)D3D11_Hooks->Shaders->Value(D3D11_Hooks->CurrentPxShader);
            D3D11Globals.lock->unlock();
            if (c) c->set(px);
            else D3D11_Hooks->PxShaderRelease(px);
        }
        D3D11_Hooks->PxBlob->Release();
        D3D11_Hooks->PxBlob = nullptr;
    }

    if      (p == 1) D3D11DumpTexture((IUnknown*)D3D11_Hooks->current_view,  D3D11_Hooks->dump, 0);
    else if (p == 2) D3D11DumpShader();

    if ( D3D11_Hooks->Searching )
    {
        std::wstring text(D3D11_Hooks->Text);
        if (D3D11_Hooks->Searching == 2)
        {
            c = (D3D11Bytecode *)D3D11_Hooks->Shaders->Value(D3D11_Hooks->CurrentPxShader);
            if ( c )
            {
                text.append(L"\nDumped: ");
                text.append(c->m_name.c_str());
#ifdef _WIN64                
                text.append((std::wstring(L"\n") + std::to_wstring((UINT64)c->m_replace)));
#else  
                text.append((std::wstring(L"\n") + std::to_wstring((UINT)c->m_replace)));
#endif                                 
                if (c->IsVPostShader()) text.append(L"\nSV_POSITION");
                if (c->m_IsLoadShader)  text.append(L"\nTEXTURE::LOAD");
                if (c->m_ResInfo)       text.append(L"\nTEXTURE::GETDIMENSIONS");
            } else text.append(L"\nNOT DUMPED");
        }
        text += L"\nproxys: " + to_wstring(D3D11Globals.ProxyCount->Get());
        text += L"\nVideo memory used: " + to_wstring((double)D3D12GetMemoryUsage(D3D11DvcFromSChain(Iface), 0)) + L" MB";
        text += L"\nShared used: " + to_wstring((double)D3D12GetMemoryUsage(D3D11DvcFromSChain(Iface), 1)) + L" MB";
        text += L"\nSystem memory used: " + to_wstring(GetMemoryUsage()) + L"%";
        D3D11RenderText(Iface, text.c_str(), &D3D11_Hooks->text_rect);

        if (D3D11_Hooks->Searching == 1)
        {
            if (D3D11_Hooks->current_view)
            {
                D3D11Texture2DView view(D3D11_Hooks->current_view);
                if (view.m_VW)
                    D3D11Blit(Iface, view.m_VW, nullptr, &D3D11_Hooks->image_rect, nullptr);
            }
        }
    }
}

extern "C" __declspec(dllexport) HRESULT __stdcall IDXGISwapChainPresentHook(IDXGISwapChain * Iface, UINT sync, UINT flags)
{
#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (g_d3d.VSYNC) sync = 1;
#ifdef _WIN64
    D3D11Present(Iface, sync, flags);
#else
    IDXGIDevice * DXGIDvc = nullptr;
    if (Iface->GetDevice(__uuidof(IDXGIDevice), (void**)&DXGIDvc) != S_OK)
    {
        D3D11LOG("NO DEVICE");
        return D3D11_Hooks->IDXGISwapChain_Present(Iface, sync, flags);
    }
    DXGIDvc->Release();
    if (IsD3D11Device(DXGIDvc)) D3D11Present(Iface, sync, flags);
    else                        D3D10Present(Iface, sync, flags);
#endif
    return D3D11_Hooks->IDXGISwapChain_Present(Iface, sync, flags);
}

extern "C" __declspec(dllexport) DWORD D3D11InsetPxDump(const void *DumpBytecode, SIZE_T DumpLength, wchar_t * name, const void *RBytecode, SIZE_T RLength)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)      
    D3D11Globals.PxDumps->insert_disposable(new D3D11Bytecode(RLength,    (BYTE*)RBytecode),
                                            new D3D11Bytecode(DumpLength, (BYTE*)DumpBytecode, name));
    return D3D11Globals.PxDumps->Count();
}

extern "C" __declspec(dllexport) HRESULT __stdcall CreatePixelShader11Hook(ID3D11Device * d, const void *Bytecode,
                                          SIZE_T Length, ID3D11ClassLinkage *cl,
                                          ID3D11PixelShader **ppPxShader)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D11_Hooks->CreatePixelShader(d, Bytecode, Length, cl, ppPxShader);
    if (hr != 0) return hr;

    ID3D11PixelShader * PxR = nullptr;
    D3D11Bytecode     * c   = new D3D11Bytecode(Length, (BYTE*)Bytecode);
    
    for (UINT i=0; i<D3D11Globals.PxDumps->Count(); i++)
    {
        D3D11Bytecode * dump = (D3D11Bytecode *) D3D11Globals.PxDumps->ValueAt(i);
        if (dump)
        {
            if (*dump == c)
            {
                D3D11Bytecode * BCR = (D3D11Bytecode *) D3D11Globals.PxDumps->KeyAt(i);
                if (D3D11_Hooks->CreatePixelShader(d, BCR->m_Bytecode, BCR->m_sz, cl, &PxR) == 0)
                {
                    c->Replace((ID3D11PixelShader*)*ppPxShader, (ID3D11PixelShader*)PxR);                   
                    c->m_name.clear();
                    c->m_name.append(dump->m_name.c_str());
                }
                else
                {
                    c->m_name.clear();                    
                    c->m_name.append( L"Compilation failed" );
                }
            }
        }
    }
    if (g_d3d.HDPROXIES && (nullptr != *ppPxShader)/*&& (nullptr ==  c->m_replace)*/)
    c->Fix(d, *ppPxShader);

    D3D11Globals.lock->lock();
    D3D11_Hooks->Shaders->insert_disposable((void*)*ppPxShader, (void*)c);
    D3D11Globals.lock->unlock();
    return hr;
}

extern "C" __declspec(dllexport) HRESULT __stdcall ReleasePixelShader11Hook(ID3D11PixelShader *pPxShader)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D11_Hooks->PxShaderRelease(pPxShader);
    if (hr == 0)
    {
        D3D11Globals.lock->lock();
        D3D11Bytecode * c = (D3D11Bytecode *)D3D11_Hooks->Shaders->Value(pPxShader);
        D3D11_Hooks->Shaders->discard(pPxShader);
        D3D11Globals.lock->unlock();
        if (c) delete c;
    }
    return hr;
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11PsSetShaderHook(ID3D11DeviceContext * ctxt, ID3D11PixelShader * px,
                                    ID3D11ClassInstance * const *ppC, UINT n)
{   
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D11_Hooks->PSSetShader(ctxt, px, ppC, n);
    if (px == nullptr) return;
    ID3D11PixelShader * target = (ID3D11PixelShader *)D3D11Globals.PixelShader->Get();
    if (target == px)
    {
        D3D11_Hooks->PSSetShader(ctxt, D3D11Globals.m_PxBlt, ppC, n);             
        return;
    }
    ID3D11PixelShader * replacement;
    UINT sz = sizeof(ID3D11PixelShader*);
    if (px->GetPrivateData((GUID&)g_.D3D11ProxyShader, &sz, &replacement) == S_OK)
    {
        replacement->Release();
        return D3D11_Hooks->PSSetShader(ctxt, replacement, ppC, n);
    }
    return;
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11OMGetRenderTargetsHook(ID3D11DeviceContext *d, UINT n,
                                           ID3D11RenderTargetView ** rv,
                                           ID3D11DepthStencilView ** zv)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D11_Hooks->OMGetRenderTargets(d, n, rv, zv);    
    if (!g_d3d.USEPROXIES)
    return;

    if (n > 8)
    {
        DBUG_WARN("CANT RANDLE MORE THEN 8 TARGETS");
        return D3D11_Hooks->OMGetRenderTargets(d, n, rv, zv);
    }
    //D3D11_Hooks->OMGetRenderTargets(d, n, rv, zv);

    ID3D11RenderTargetView * proxy_view  = nullptr;
    ID3D11Weak             *       view  = nullptr;
    ID3D11DepthStencilView * proxy_dview = nullptr;
    ID3D11Weak             *       dview = nullptr;
    UINT                           size  = sizeof(IUnknown*);
    if (rv && n > 0)
    {
        for (UINT i=0; i<n; i++)
        {
            if (d->GetPrivateData((GUID&)g_.D3D11Rendertargets[i], &size, &view) != 0)
            {
                DBUG_WARN("PROXY NOT FOUND");
            }
            else
            {
                *rv = (ID3D11RenderTargetView*)view;
            }
            rv += 1;            
        }
    }
    if (zv)
    {
        if (d->GetPrivateData((GUID&)g_.D3D11DepthStencil, &size, &dview) != 0)
        {
            DBUG_WARN("Z PROXY NOT FOUND");
        }
        else
        {
            *zv = (ID3D11DepthStencilView*)dview;
        }         
    }
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11OMSetRenderTargetsHook(ID3D11DeviceContext *d, UINT NumViews,
                                           ID3D11RenderTargetView *const *Views,
                                           ID3D11DepthStencilView *zView)
{    
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if (!g_d3d.USEPROXIES)
    {
        D3D11_Hooks->OMSetRenderTargets(d, NumViews, Views, zView);
        return;
    }

    for (int i = 0; i < 8; i++)
    {
        if (d->SetPrivateDataInterface((GUID&)g_.D3D11Rendertargets[i], nullptr) != 0)
        DBUG_WARN("FAILED TO CLEAR RENDER TARGETS");
    }
    if (d->SetPrivateDataInterface((GUID&)g_.D3D11DepthStencil, nullptr) != 0)
    DBUG_WARN("FAILED TO CLEAR Z BUFFER");

    for (int i = 0; i < NumViews; i++)
    {
        if (d->SetPrivateDataInterface((GUID&)g_.D3D11Rendertargets[i], Views[i]) != 0)
        DBUG_WARN("FAILED TO RECORD RENDER TARGETS");
    }
    if (d->SetPrivateDataInterface((GUID&)g_.D3D11DepthStencil, zView) != 0)
    DBUG_WARN("FAILED TO CLEAR Z BUFFER");

    if (NumViews > 8)
    {
        DBUG_WARN("CANT RANDLE MORE THEN 8 TARGETS");
        return D3D11_Hooks->OMSetRenderTargets(d, NumViews, Views, zView);;
    }

    ID3D11RenderTargetView  ** proxy_views = new ID3D11RenderTargetView*[NumViews];
    ID3D11DepthStencilView   * zproxy      = nullptr;
    ID3D11Resource           * res         = nullptr;
    ID3D11ProxyTexture       * proxy       = nullptr;

    for (UINT i=0; i<NumViews; i++)
    {
        proxy_views[i] = nullptr;
        if (Views[i] == nullptr)
        {
            proxy_views[i] = nullptr;
            continue;
        }
        res = D3D11GetResource(Views[i]);
        if (res == nullptr)
        {
            DBUG_WARN("NO RESOURCE");
            return;
        }

        proxy = D3D11GetProxy(res, __FUNCTION__);
        if (!proxy)
        {
            DBUG_WARN("NO PROXY");
            return;
        }

        proxy_views[i] = proxy->RTV(d, Views[i], res);
        if (!proxy_views[i])
        {
            DBUG_WARN("NO RTV");
            return;
        }
    }

    if (zView)
    {
        res = D3D11GetResource(zView);
        if (res == nullptr)
        {
            DBUG_WARN("NO Z RESOURCE");
            return;
        }

        proxy = D3D11GetProxy(res, __FUNCTION__);
        if (!proxy)
        {
            DBUG_WARN("NO PROXY");
            return;
        }

        zproxy = proxy->DSV(d, zView, res);
        if (!zproxy)
        {
            DBUG_WARN("NO DSV");
            return;
        }
    }

    D3D11_Hooks->OMSetRenderTargets(d, NumViews, proxy_views, zproxy);
    for (UINT i=0; i<NumViews; i++)
    {        
        if (proxy_views[i]) proxy_views[i]->Release();
    }
    if (zproxy)zproxy->Release();
    delete [] proxy_views;
}

extern "C" __declspec(dllexport) 
void __stdcall OMSetRenderTargetsAndUnorderedAccessViewsHook(ID3D11DeviceContext* ctx, UINT NumRTVs, ID3D11RenderTargetView* const* ppRenderTargetViews,
                                                             ID3D11DepthStencilView* pDepthStencilView, UINT UAVStartSlot, UINT NumUAVs, 
                                                             ID3D11UnorderedAccessView* const* UAVS, const UINT* pUAVInitialCounts)
{
    if (NumRTVs != D3D11_KEEP_RENDER_TARGETS_AND_DEPTH_STENCIL) {
        D3D11OMSetRenderTargetsHook(ctx, NumRTVs, ppRenderTargetViews, pDepthStencilView);
    }    
    ID3D11Resource     * res   = nullptr;
    ID3D11ProxyTexture * proxy = nullptr;
    if (NumUAVs == D3D11_KEEP_UNORDERED_ACCESS_VIEWS) return;
    if (NumUAVs > 0)
    {
        ID3D11UnorderedAccessView** proxy_views = new ID3D11UnorderedAccessView * [NumUAVs];
        for (UINT i = 0; i < NumUAVs; i++)
        {
            proxy_views[i] = nullptr;
            if (UAVS[i] == nullptr) continue;

            res = D3D11GetResource(UAVS[i]);
            if (res == nullptr)
            {
                DBUG_WARN("NO RESOURCE");
                return;
            }

            proxy = D3D11GetProxy(res, __FUNCTION__);
            if (!proxy)
            {
                DBUG_WARN("NO PROXY");
                return;
            }

            proxy_views[i] = proxy->UAV(ctx, UAVS[i], res);
            if (!proxy_views[i])
            {
                DBUG_WARN("NO UAV");
                return;
            }
        }
        D3D11Globals.m_OMSetRenderTargetsAndUAVs(ctx, D3D11_KEEP_RENDER_TARGETS_AND_DEPTH_STENCIL, nullptr, nullptr, UAVStartSlot, NumUAVs, proxy_views, pUAVInitialCounts);
        for (UINT i = 0; i < NumUAVs; i++)
        {
            if (proxy_views[i]) proxy_views[i]->Release();
        }
        delete[]proxy_views;
        return;
    }
    D3D11Globals.m_OMSetRenderTargetsAndUAVs(ctx, D3D11_KEEP_RENDER_TARGETS_AND_DEPTH_STENCIL, nullptr, nullptr, UAVStartSlot, NumUAVs, UAVS, pUAVInitialCounts);
    return;
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11DiscardViewHook(ID3D11DeviceContext *d, ID3D11View *vw)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IUnknown * _vw    = nullptr;
    DWORD type        = D3D11ViewType(vw, &_vw);
    if (type == 0)
    {
        DBUG_WARN("D3D11ViewType Failed");
        D3D11_Hooks->DiscardView(d, vw);
        return;
    }

    ID3D11Resource * res = D3D11GetResource(vw);
    if (res == nullptr)
    {
        DBUG_WARN("NO RESOURCE");
        D3D11_Hooks->DiscardView(d, vw);
        _vw->Release();
        return;
    }

    ID3D11ProxyTexture * proxy = D3D11GetProxy(res, __FUNCTION__);
    if (!proxy)
    {
        D3D11LOG("NO PROXY");
        D3D11_Hooks->DiscardView(d, vw);
        _vw->Release();
        return;
    }
    ID3D11View  * proxy_view = nullptr;
    if      (type == 1) proxy_view = (ID3D11View *) proxy->RTV(d, (ID3D11RenderTargetView*) _vw, res);
    else if (type == 2) proxy_view = (ID3D11View *) proxy->DSV(d, (ID3D11DepthStencilView*) _vw, res);
    else if (type == 3) proxy_view = (ID3D11View *) proxy->SRV(d, (ID3D11ShaderResourceView*) _vw, res);
    if (!proxy_view)
    {
        DBUG_WARN("NO View");
        _vw->Release();
        D3D11_Hooks->DiscardView(d, vw);
        return;
    }
    _vw->Release();
    D3D11_Hooks->DiscardView(d, proxy_view);
    proxy_view->Release();
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11ClearRenderTargetViewHook(ID3D11DeviceContext * cxt,
                                              ID3D11RenderTargetView *view,
                                              const FLOAT ColorRGBA[4])
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (!g_d3d.USEPROXIES)
    {
        D3D11_Hooks->ClearRenderTargetView(cxt, view, ColorRGBA);
        return;
    }

    ID3D11RenderTargetView  *  vw_proxy = nullptr;
    if (view)
    {
        ID3D11Resource * res = D3D11GetResource(view);
        if (res == nullptr)
        {
            DBUG_WARN("NO Z RESOURCE");
            return;
        }

        ID3D11ProxyTexture * proxy = D3D11GetProxy(res);
        if (!proxy)
        {
            DBUG_WARN("NO PROXY");
            return;
        }

        vw_proxy = proxy->RTV(cxt, view, res);
        if (!vw_proxy)
        {
            DBUG_WARN("NO RTV");
            return;
        }
    }
    D3D11_Hooks->ClearRenderTargetView(cxt, vw_proxy, ColorRGBA);
    if (vw_proxy) vw_proxy->Release();
}

extern "C" __declspec(dllexport) 
void __stdcall D3D11ClearDepthStencilViewHook(ID3D11DeviceContext * dvc,
                                              ID3D11DepthStencilView *pZView,
                                              UINT flags, FLOAT Depth, UINT8 Stencil)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (!g_d3d.USEPROXIES)
    {
        D3D11_Hooks->ClearDepthStencilView(dvc, pZView, flags, Depth, Stencil);
        return;
    }

    ID3D11DepthStencilView  *  zproxy = nullptr;
    if (pZView)
    {
        ID3D11Resource * res = D3D11GetResource(pZView);
        if (res == nullptr)
        {
            DBUG_WARN("NO Z RESOURCE");
            return;
        }

        ID3D11ProxyTexture * proxy = D3D11GetProxy(res);
        if (!proxy)
        {
            DBUG_WARN("NO PROXY");
            return;
        }

        zproxy = proxy->DSV(dvc, pZView, res);
        if (!zproxy)
        {
            DBUG_WARN("NO DSV");
            return;
        }
    }
    
    D3D11_Hooks->ClearDepthStencilView(dvc, zproxy, flags, Depth, Stencil);
    if (zproxy != nullptr) zproxy->Release();
    return;
}

void __stdcall D3D11ClearViewHook(ID3D11DeviceContext1* ctx, ID3D11View *pView, const FLOAT Color[4], const D3D11_RECT *pRect, UINT NumRects)
{
    if (!g_d3d.USEPROXIES)
    {
        D3D11Globals.m_ClearView(ctx, pView, Color, pRect, NumRects);
        return;
    }
    ID3D11View * proxy = nullptr;
    if (pView)
    {
        ID3D11Resource * res = D3D11GetResource(pView);
        if (res == nullptr)
        {
            DBUG_WARN("NO RESOURCE");
            return;
        }

        ID3D11ProxyTexture * proxy = D3D11GetProxy(res);
        if (!proxy)
        {
            DBUG_WARN("NO PROXY");
            return;
        }

        ID3D11Device * pDvc = nullptr;
        ctx->GetDevice(&pDvc);
        if (nullptr == pDvc)
        {
            DBUG_WARN("NO DVC");
            return;
        }

        auto view = proxy->View(pDvc);
        if (!view)
        {
            DBUG_WARN("NO VIEW");
            return;
        }
        D3D11Globals.m_ClearView(ctx, view, Color, pRect, NumRects);
        view->Release();
    }
}

class D3D11ViewPortScaler
{
    ID3D11DeviceContext * m_ctx = nullptr;
    std::vector<D3D11_VIEWPORT> views;
    std::vector<D3D11_VIEWPORT> hd_views;
    std::vector<RECT>  scissor;
    std::vector<RECT>  hd_scissor;
    UINT ViewportCount                 = 0;
    UINT ScissorCount                  = 0;    
public:
    D3D11ViewPortScaler(ID3D11DeviceContext* ctx)
    {        
        m_ctx = ctx;
        ctx->RSGetViewports(&ViewportCount, nullptr);
        if (ViewportCount == 0)
        {
            DBUG_WARN("::RSGetViewports(&ViewportCount, nullptr) FAILED");
            return;
        }
        views.resize(ViewportCount);
        hd_views.resize(ViewportCount);
        ctx->RSGetViewports(&ViewportCount, &views[0]);
        ctx->RSGetViewports(&ViewportCount, &hd_views[0]);
        float scale = g_d3d.mScl->Get() * g_d3d.SSAA;
        for (auto& v : hd_views) 
        {
            v.TopLeftX *= scale;
            v.TopLeftY *= scale;
            v.Width    *= scale;
            v.Height   *= scale;           
        }
        ctx->RSSetViewports(ViewportCount, &hd_views[0]);
        
        ctx->RSGetScissorRects(&ScissorCount, nullptr);
        if (ScissorCount > 0)
        {
            scissor.resize(ScissorCount);
            hd_scissor.resize(ScissorCount);
            ctx->RSGetScissorRects(&ScissorCount, &scissor[0]);
            ctx->RSGetScissorRects(&ScissorCount, &hd_scissor[0]);
            for (auto& s : hd_scissor)
            {
                s.top    *= scale;
                s.bottom *= scale;
                s.left   *= scale;
                s.right  *= scale;
            }
            ctx->RSSetScissorRects(ScissorCount, &hd_scissor[0]);
        }
    }
    ~D3D11ViewPortScaler()
    {
        if (ViewportCount)
        {
            m_ctx->RSSetViewports(ViewportCount, &views[0]);            
        }
        if (ScissorCount)
        {
            m_ctx->RSSetScissorRects(ScissorCount, &scissor[0]);
        }
    }   
};

void __stdcall D3D11DrawAutoHook(ID3D11DeviceContext* c)
{
    auto scaler = D3D11ViewPortScaler(c);
    return D3D11Globals.m_DrawAuto(c);
}    
void __stdcall D3D11DrawIndexedHook(ID3D11DeviceContext* c, UINT count, UINT Start, INT Base)
{
    auto scaler = D3D11ViewPortScaler(c);
    D3D11Globals.m_DrawIndexed(c, count, Start, Base);
    return;
}
void __stdcall D3D11DrawHook(ID3D11DeviceContext* c, UINT VertexCount, UINT StartVertexLocation)
{
    auto scaler = D3D11ViewPortScaler(c);
    D3D11Globals.m_Draw(c, VertexCount, StartVertexLocation);
    return;
}
void __stdcall D3D11DrawInstancedHook(ID3D11DeviceContext* c, UINT p1, UINT p2, UINT p3, UINT p4)
{
    auto scaler = D3D11ViewPortScaler(c);
    D3D11Globals.m_DrawInstanced(c, p1, p2, p3, p4);
    return;
}
void  __stdcall D3D11DrawInstancedIndirectHook(ID3D11DeviceContext* c, ID3D11Buffer* b, UINT f)
{
    auto scaler = D3D11ViewPortScaler(c);
    return D3D11Globals.m_DrawInstancedIndirect(c, b, f);
}
void __stdcall D3D11DrawIndexedInstancedHook(ID3D11DeviceContext* c, UINT p1, UINT p2, UINT p3, INT p4, UINT p5)
{
    auto scaler = D3D11ViewPortScaler(c);
    return D3D11Globals.m_DrawIndexedInstanced(c, p1, p2, p3, p4, p5);
}
void __stdcall D3D11DrawIndexedInstancedIndirectHook(ID3D11DeviceContext* c, ID3D11Buffer* b, UINT f)
{
    auto scaler = D3D11ViewPortScaler(c);
    return D3D11Globals.m_DrawIndexedInstancedIndirect(c, b, f);
}

extern "C" __declspec(dllexport) 
HRESULT __stdcall DXGIGetBufferHook(IDXGISwapChain * Sc, UINT Indx, REFIID riid, void **ppSurface)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DBUG_LOG(std::to_string(Indx).c_str());
    HRESULT hr = D3D11_Hooks->GetBuffer(Sc, Indx, riid, ppSurface);
    if (0 != hr) return hr;
    
    IDXGISurface * DXGIBackBuffer = nullptr;
    IDXGIDevice  * DXGIDvc        = nullptr;
    IDXGISurface * DXGISrfc       = nullptr;
    IUnknown     * pSurface       = nullptr;
    IUnknown     * ID             = nullptr;

    DXGI_SURFACE_DESC DXGISurfaceDesc;

    if (D3D11_Hooks->GetBuffer(Sc, Indx, __uuidof(IDXGISurface), (void**)&DXGIBackBuffer) != 0)
    {
        DBUG_WARN("FAILED TO GET THE DXGI BACKBUFFER");
        goto DXGIGetBufferHookCleanUp;
    }

    if (DXGIBackBuffer->GetDesc(&DXGISurfaceDesc) != 0)
    {
        DBUG_WARN("FAILED TO GET THE DXGI BACKBUFFER DESCRIPTION");
        goto DXGIGetBufferHookCleanUp;
    }

    if ( Sc->GetDevice(__uuidof(IDXGIDevice), (void**)&DXGIDvc) != 0)
    {
        DBUG_WARN("FAILED TO GET THE DXGI DEVICE");
        goto DXGIGetBufferHookCleanUp;
    }

    DXGISurfaceDesc.Width  = D3D11_Hooks->W;
    DXGISurfaceDesc.Height = D3D11_Hooks->H;    
    if (DXGIDvc->CreateSurface(&DXGISurfaceDesc, 1,
                               DXGI_USAGE_SHADER_INPUT|DXGI_USAGE_RENDER_TARGET_OUTPUT,
                               nullptr, &DXGISrfc) != 0)
    {
        DBUG_WARN("FAILED TO CREATE THE IDXGISurface BACKBUFFER PROXY");
        goto DXGIGetBufferHookCleanUp;
    }

    pSurface = (IUnknown *)* ppSurface;    
    if (DXGISrfc->SetPrivateDataInterface((GUID &)g_.DXGISwapChainImp, Sc) != 0)
    DBUG_WARN("SetPrivateDataInterface FAILED");
    pSurface->Release();

    if (DXGISrfc->QueryInterface(riid, ppSurface) != 0)
    {
        DBUG_WARN("FAILED TO GET REQUESTED INTERFACE");
        hr = D3D11_Hooks->GetBuffer(Sc, Indx, riid, ppSurface);
        goto DXGIGetBufferHookCleanUp;
    }

    if (DXGISrfc->QueryInterface(__uuidof(IUnknown), (void**)&ID) != 0)
    {
        DBUG_WARN("FAILED TO GET BACKBUFER ID");
        hr = D3D11_Hooks->GetBuffer(Sc, Indx, riid, ppSurface);
        goto DXGIGetBufferHookCleanUp;
    }

    if (g_d3d.USEINTEROP) g_d3d.D3D11DvcNT.Reset(Sc, DXGIDvc);

    D3D11Globals.BackBuffrerID->Set(ID);
    D3D11Globals.BackBufferRect.left    = D3D11_Hooks->ViewX;
    D3D11Globals.BackBufferRect.top     = 0;
    D3D11Globals.BackBufferRect.right   = D3D11_Hooks->HD_W-D3D11_Hooks->ViewX;
    D3D11Globals.BackBufferRect.bottom  = D3D11_Hooks->HD_H;

    DXGIGetBufferHookCleanUp:
    /*  // crash with wine
    DEVMODEW DvmdW;
    DvmdW.dmSize = sizeof(DEVMODEW);
    g_d3d.m_EnumDisplaySettingsExW(NULL, ENUM_CURRENT_SETTINGS, &DvmdW, 0);

    DXGI_SWAP_CHAIN_DESC SCDesc;
    D3D11_Hooks->IDXGISChainGetDesc(Sc, &SCDesc);

    std::string log("======================");
    log += "\nIndex " + std::to_string(Indx);
    log += "\nDisplay mode " +
    std::to_string(DvmdW.dmPelsWidth)+"x"+std::to_string(DvmdW.dmPelsHeight);
    log += "\nSwap chain   " +
    std::to_string(SCDesc.BufferDesc.Width)+"x"+std::to_string(SCDesc.BufferDesc.Height);
    log += "\nReqested     " +
    std::to_string(D3D11_Hooks->W)+"x"+std::to_string(D3D11_Hooks->H);
    log += "\nReal         " +
    std::to_string(D3D11_Hooks->HD_W)+"x"+std::to_string(D3D11_Hooks->HD_H);
    log += "\nOffset       " +
    std::to_string(g_d3d.HD_X->Get());
    DBUG_LOG(log.c_str());
    */

    if (DXGIBackBuffer) DXGIBackBuffer->Release();
    if (DXGIDvc)               DXGIDvc->Release();
    if (DXGISrfc)             DXGISrfc->Release();
    if (ID)                         ID->Release();
    return hr;
}

void ResetShaders()
{
    for (int i = 0; i < D3D11_Hooks->Shaders->Count(); i++)
    {
        D3D11Globals.lock->lock();
        auto * b = (D3D11Bytecode *)     D3D11_Hooks->Shaders->ValueAt(i);
        auto * p = (ID3D11PixelShader *) D3D11_Hooks->Shaders->KeyAt(i);
        p->AddRef();
        D3D11Globals.lock->unlock();
        b->Reset(p);
        p->Release();
    }
}

extern "C" __declspec(dllexport) void D3D11HDSetUP(DWORD w, DWORD h, char * Caller)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d.Setup(w, h, Caller);
    D3D11_Hooks->W        = g_d3d.m_WW->Get();
    D3D11_Hooks->H        = g_d3d.m_HH->Get();
    D3D11_Hooks->HD_W     = g_d3d.HD_W;
    D3D11_Hooks->HD_H     = g_d3d.HD_H;
    D3D11_Hooks->scale    = g_d3d.mScl->Get();
    D3D11_Hooks->ViewX    = g_d3d.HD_X->Get();
}

extern "C" __declspec(dllexport) 
const DXGI_SWAP_CHAIN_DESC_1 * D3D11SetUPSwapChain1(const DXGI_SWAP_CHAIN_DESC_1 * Desc, DXGI_SWAP_CHAIN_DESC_1 * NewDesc,
                                                    char * Caller, HWND)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if (!g_d3d.UPSCALE || (Desc == nullptr)) return Desc;

    memcpy(NewDesc, Desc, sizeof(DXGI_SWAP_CHAIN_DESC_1));

    if (NewDesc->Width && NewDesc->Height) D3D11HDSetUP(NewDesc->Width, NewDesc->Height, Caller);
    else DBUG_WARN("NO BACKBUFFER SIZE");
    if (0 != g_d3d.FORCE_DOUBLE_BUFFERING) NewDesc->BufferCount = 3;
    NewDesc->Width   = D3D11_Hooks->HD_W;
    NewDesc->Height  = D3D11_Hooks->HD_H;    
    //NewDesc->Flags |= DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;
    ResetShaders();
    return NewDesc;
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D11CreateSwapChainForHwnd(LPVOID Factory2/* IDXGIFactory2* */, IUnknown * Dvc, HWND hWin, const DXGI_SWAP_CHAIN_DESC_1* Desc,
                            DXGI_SWAP_CHAIN_FULLSCREEN_DESC * F/* DXGI_SWAP_CHAIN_FULLSCREEN_DESC* */, IDXGIOutput*Out,
                            IDXGISwapChain** pChain/* IDXGISwapChain1** */)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    //OutputDebugStringW(DllFromAdress(__builtin_return_address(0)).m_name.c_str());
    if (FALSE == COMMONIsGameModule(__builtin_return_address(0), g_.modules))
    return D3D11_Hooks->CreateSwapChainForHwnd(Factory2, Dvc, hWin, Desc, F, Out, pChain);
    D3D11Globals.lock->lock(); D3D11Globals.lock->unlock();

    DXGI_SWAP_CHAIN_DESC_1 NewDesc;
    DXGI_SWAP_CHAIN_FULLSCREEN_DESC f = {0, 0, DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED, DXGI_MODE_SCALING_UNSPECIFIED, 0};
    const DXGI_SWAP_CHAIN_DESC_1  * d = D3D11SetUPSwapChain1(Desc, &NewDesc, (char*)__FUNCTION__, hWin);
    
    LogWinSize winsz(hWin, (char*)__FUNCTION__);
    g_d3d.D3DWINDOW = hWin;
    HRESULT h = D3D11_Hooks->CreateSwapChainForHwnd(Factory2, Dvc, hWin, d, &f, Out, pChain);
    //if (F != nullptr && g_d3d.GAMMAFIX) F->Windowed = FALSE;
    //HRESULT h = D3D11_Hooks->CreateSwapChainForHwnd(Factory2, Dvc, hWin, d, F, Out, pChain); // Fixes solar ash, needs testing
    if (h == 0)
    {
        if (g_d3d.m_SetWindowPos(hWin, HWND_TOPMOST, 0, 0, NewDesc.Width, NewDesc.Height, SWP_NOZORDER) == 0)
        DBUG_WARN("SetWindowPos FAILED");
        D3D11_Hooks->AHKSetup((ID3D11Device *) Dvc, NewDesc.Width, NewDesc.Height);
        D3D11CreateShaders(*pChain);        
        SendMessage(hWin, WM_SIZE, 0,  Desc->Width|(Desc->Height<<16));        
    } else  
    {
        DBUG_WARN("D3D11CreateSwapChainForHwnd FAILED, Trying ogiginal settings"); // MGS2
        h = D3D11_Hooks->CreateSwapChainForHwnd(Factory2, Dvc, hWin, Desc, F, Out, pChain);
        if (h)  DBUG_WARN("D3D11CreateSwapChainForHwnd FAILED"); 
    }
    return h;
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D11CreateSwapChain(IDXGIFactory * Factory, IUnknown*Dvc, DXGI_SWAP_CHAIN_DESC*pDesc, IDXGISwapChain**pChain)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D11Globals.lock->lock(); D3D11Globals.lock->unlock();
    DXGI_SWAP_CHAIN_DESC                   NewDesc             = {};
    if (0 != g_d3d.FORCE_DOUBLE_BUFFERING) NewDesc.BufferCount = 3;
    if (pDesc)
    {
        memcpy(&NewDesc, pDesc, sizeof(DXGI_SWAP_CHAIN_DESC));
        if (g_d3d.UPSCALE)
        {
            NewDesc.BufferDesc.Width  = D3D11_Hooks->HD_W;
            NewDesc.BufferDesc.Height = D3D11_Hooks->HD_H;
        }
    }
    if (NewDesc.BufferDesc.Width && NewDesc.BufferDesc.Height)
        D3D11HDSetUP(pDesc->BufferDesc.Width, pDesc->BufferDesc.Height, (char*)__FUNCTION__);
    LogWinSize winsz(NewDesc.OutputWindow, (char*)__FUNCTION__);

    HRESULT h = D3D11_Hooks->CreateSwapChain(Factory, Dvc, &NewDesc, pChain);
    if (h == 0 && pDesc != nullptr) /* If CreateSwapChain succeeded, pDesc is not null, but that doesn't keeps the compiler from nagging */
    {
        g_d3d.D3DWINDOW = NewDesc.OutputWindow;
        /* breaks Death's door
        if (g_d3d.m_SetWindowPos(NewDesc.OutputWindow, HWND_TOPMOST, 0, 0,
                                 NewDesc.BufferDesc.Width, NewDesc.BufferDesc.Height, SWP_NOZORDER) == 0)
        DBUG_WARN("SetWindowPos FAILED");
        */
        D3D11_Hooks->AHKSetup((ID3D11Device*)Dvc, NewDesc.BufferDesc.Width, NewDesc.BufferDesc.Height);
        D3D11CreateShaders(*pChain);
        //SendMessage(NewDesc.OutputWindow, WM_SIZE, 0, pDesc->BufferDesc.Width | (pDesc->BufferDesc.Height << 16)); // Freezes blade of darkness
        //D3D11Globals.SendVMSize(NewDesc.OutputWindow, pDesc->BufferDesc.Width, pDesc->BufferDesc.Height);
    } else 
    {
        DBUG_WARN("D3D11CreateSwapChain FAILED, Trying ogiginal settings"); // MGS2
        h = D3D11_Hooks->CreateSwapChain(Factory, Dvc, pDesc, pChain);
        if (h)  DBUG_WARN("D3D11CreateSwapChain FAILED"); 
    }
    return h;
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D11ResizeBuffersHook(IDXGISwapChain* Sc, UINT BufferCount, UINT Width, UINT Height, DXGI_FORMAT Format, UINT Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DBUG_WARN((to_string(Width)+"x"+to_string(Height)).c_str());

    if (Width && Height) D3D11HDSetUP(Width, Height, (char*)__FUNCTION__);

    RECT                              r = {0};
    DXGI_SWAP_CHAIN_DESC              d = {0};
    D3D11_Hooks->IDXGISChainGetDesc(Sc,   &d);
    g_d3d.m_GetClientRect(d.OutputWindow, &r);

    /*
    if (r.left != 0 || r.top != 0 || r.right != g_d3d.HD_W || r.bottom != g_d3d.HD_H)
    {
        d.BufferDesc.Width  = g_d3d.HD_W;
        d.BufferDesc.Height = g_d3d.HD_H;
        D3D11_Hooks->ResizeTarget(Sc, &d.BufferDesc);
        g_d3d.m_GetClientRect(d.OutputWindow, &r);
        DBUG_WARN((to_string(r.left)+" "+to_string(r.top)+" "+to_string(r.right)+" "+to_string(r.bottom)).c_str());
    }
    */
    if (0 != g_d3d.FORCE_DOUBLE_BUFFERING) BufferCount = 3;
    LogWinSize winsz(GetSwapChainWindowHandle(Sc), (char*)__FUNCTION__);
    return D3D11_Hooks->ResizeBuffers(Sc, 3, g_d3d.HD_W, g_d3d.HD_H, Format, Flags); // RIME
    return D3D11_Hooks->ResizeBuffers(Sc, BufferCount, g_d3d.HD_W, g_d3d.HD_H, Format, Flags); // RIME
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D11ResizeTargetHook(IDXGISwapChain* Sc, DXGI_MODE_DESC * d)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)

    if (d == nullptr) return DXGI_ERROR_INVALID_CALL;
    DBUG_WARN((to_string(d->Width)+"x"+to_string(d->Height)).c_str())

    if (d->Width && d->Height) D3D11HDSetUP(d->Width, d->Height, (char*)__FUNCTION__);
    DXGI_MODE_DESC newdesc;
    memcpy(&newdesc, d, sizeof(DXGI_MODE_DESC));
    newdesc.Width  = g_d3d.HD_W;
    newdesc.Height = g_d3d.HD_H;

    LogWinSize winsz(GetSwapChainWindowHandle(Sc), (char*)__FUNCTION__);
    RECT                                            r = {0};
    g_d3d.m_GetClientRect(GetSwapChainWindowHandle(Sc), &r);
    // ResizeTarget can shrink death's door window, so we only call it if necessary
    HRESULT hr = (r.left != 0 || r.top != 0 || r.right != g_d3d.HD_W || r.bottom != g_d3d.HD_H) ?
    D3D11_Hooks->ResizeTarget(Sc, &newdesc) : 0;
    if (0 == hr) SendMessageA(GetSwapChainWindowHandle(Sc), WM_SIZE, 0, g_d3d.m_WW->Get()|(g_d3d.m_HH->Get()<<16));
    return hr;
}

char * D3D11HookWineFunction(char * dll, char * function, char * base_wine_path)
{
    static string err = "S_OK";
    string winedirw  = base_wine_path;
    string winedll   = winedirw + "\\" + dll + ".dll";
    string sysdll    = dll + string(".dll");
    HMODULE h_sysdll = LoadLibraryA(sysdll.c_str());
    if (h_sysdll == nullptr)
    {
        err  = (string("Failed to load: ") + sysdll);
        return (char*) err.c_str();
    } 
    PROC p_SysFunc = GetProcAddress(h_sysdll, function);
    if (p_SysFunc == nullptr)
    {
        err  = (string("GetProcAddress failed: ") + dll + "::" + function);        
        return (char*) err.c_str();
    }
    HMODULE h_winedll = LoadLibraryA(winedll.c_str());
    if (h_winedll == nullptr)
    {
        err  = (string("Failed to load wine dll: ") + winedll);
        return (char*) err.c_str();
    } 
    PROC p_WineFunc = GetProcAddress(h_winedll, function);
    if (p_WineFunc == nullptr)
    {
        err  = (string("GetProcAddress failed: ") + dll + "::" + function);         
        return (char*) err.c_str();
    }      
    if (sethook((void**)&p_SysFunc, (void*)p_WineFunc) != 0)
    {
        err  = (string("sethook Failed ") + function);        
        return (char*) err.c_str();
    }
    return (char*) err.c_str();
}

HRESULT WINAPI D3D11CoreRegisterLayersHook()
{
    DBUG_WARN("----");
    void * DXGID3D10CreateDevice                       = nullptr;     
    void * WineDXGID3D10CreateDevice                   = nullptr;  
    void * WineDXGID3D10RegisterLayers                 = nullptr;    
    HRESULT (WINAPI * WineD3D11CoreRegisterLayers)()   = nullptr;   
    void * DXGID3D10CreateDeviceCopy                   = nullptr;    
    D3D11Globals.GetWineFixPtrs(&WineDXGID3D10CreateDevice, &WineDXGID3D10RegisterLayers, (void**)&WineD3D11CoreRegisterLayers, (void**)&DXGID3D10CreateDevice); 
    DXGID3D10CreateDeviceCopy = DXGID3D10CreateDevice; 
    if (unhook(&DXGID3D10CreateDeviceCopy, nullptr))
    {
        DBUG_WARN("Unhook failed");
        DBUG_WARN(to_string((UINT64)DXGID3D10CreateDeviceCopy).c_str());
    }
    DXGID3D10CreateDeviceCopy = DXGID3D10CreateDevice; 
    if (sethook(&DXGID3D10CreateDeviceCopy, WineDXGID3D10RegisterLayers))
    {
        DBUG_WARN("sethook(WineDXGID3D10RegisterLayers) failed");
    }   
    DBUG_WARN("about to call"); 
    DBUG_WARN(to_string(WineD3D11CoreRegisterLayers()).c_str());
    DBUG_WARN("survived"); 
       
    DXGID3D10CreateDeviceCopy = DXGID3D10CreateDevice; 
    if (unhook(&DXGID3D10CreateDeviceCopy, nullptr))
    {
        DBUG_WARN("Unhook failed");
        DBUG_WARN(to_string((UINT64)DXGID3D10CreateDeviceCopy).c_str());
    }
    DXGID3D10CreateDeviceCopy = DXGID3D10CreateDevice; 
    if (sethook(&DXGID3D10CreateDeviceCopy, WineDXGID3D10CreateDevice))
    {
        DBUG_WARN("sethook(WineDXGID3D10RegisterLayers) failed");
    }
    return 0;
}

HRESULT WINAPI DXVKInjector_CreateDXGIFactory1Hook(REFIID id, void ** ppFactory) 
{   
    if (FALSE == COMMONIsGameModule(__builtin_return_address(0), g_.modules))
    return D3D11Globals.m_SystemCreateDXGIFactory1(id, ppFactory);
    HRESULT hr = D3D11Globals.m_DXVkCreateDXGIFactory1(id, ppFactory);    
    return hr;
}

HRESULT WINAPI DXVKInjector_D3D11CreateDeviceAndSwapChainHook(IDXGIAdapter *pAdapter, D3D_DRIVER_TYPE DriverType, 
    HMODULE Software, UINT Flags, const D3D_FEATURE_LEVEL *pFeatureLevels, UINT FeatureLevels, UINT SDKVersion, 
    const DXGI_SWAP_CHAIN_DESC *pSwapChainDesc, IDXGISwapChain **ppSwapChain, ID3D11Device **ppDevice, 
    D3D_FEATURE_LEVEL *pFeatureLevel, ID3D11DeviceContext **ppImmediateContext)
{   
    HRESULT hr = D3D11Globals.m_DXVkD3D11CreateDeviceAndSwapChain(
        pAdapter, DriverType, Software, Flags, pFeatureLevels, FeatureLevels, SDKVersion, pSwapChainDesc, ppSwapChain,
        ppDevice, pFeatureLevel, ppImmediateContext);   
    return hr;
}

char * __stdcall D3D11LoadDXVK(char * dxvkdir, char * game_dir, UINT flags)
{
    static string error     = "S_OK";
    string dxvkdirw         = dxvkdir;   
    HMODULE hdxvk_dxgi      = LoadLibraryA((string(dxvkdirw) + "\\dxgi.dll").c_str());
    HMODULE hdxvk_d3d11     = LoadLibraryA((string(dxvkdirw) + "\\d3d11.dll").c_str());
    HMODULE hdxvk_d3d10core = LoadLibraryA((string(dxvkdirw) + "\\d3d10core.dll").c_str());
    HMODULE hsys_dxgi       = GetModuleHandleA("dxgi.dll");
    HMODULE hsys_d3d11      = GetModuleHandleA("d3d11.dll");
    HMODULE hsys_d3d10core  = GetModuleHandleA("d3d10core.dll");
    if (hdxvk_dxgi == nullptr || hdxvk_d3d11 == nullptr || hdxvk_d3d10core == nullptr ||
        hsys_dxgi  == nullptr || hsys_d3d11  == nullptr || hsys_d3d10core  == nullptr)
    {
        error = (string(dxvkdirw) + "\\dxgi.dll").c_str();
        return (char*) error.c_str();    
    }   
    D3D11Globals.m_DXVkCreateDXGIFactory1             = (decltype(D3D11Globals.m_DXVkCreateDXGIFactory1)) GetProcAddress(hdxvk_dxgi, "CreateDXGIFactory1");
    D3D11Globals.m_DXVkD3D11CreateDeviceAndSwapChain  = (decltype(D3D11Globals.m_DXVkD3D11CreateDeviceAndSwapChain)) GetProcAddress(hdxvk_d3d11, "D3D11CreateDeviceAndSwapChain");
    D3D11Globals.m_SystemCreateDXGIFactory1           = (decltype(D3D11Globals.m_SystemCreateDXGIFactory1)) GetProcAddress(hsys_dxgi, "CreateDXGIFactory1");
    PROC h_sys_dxgiCreateDXGIFactory                  = (PROC) GetProcAddress(hsys_dxgi, "CreateDXGIFactory");
    PROC h_dxvk_dxgiCreateDXGIFactory                 = (PROC) GetProcAddress(hdxvk_dxgi, "CreateDXGIFactory");
    PROC h_sys_dxgiCreateDXGIFactory2                 = (PROC) GetProcAddress(hsys_dxgi, "CreateDXGIFactory2");
    PROC h_dxvk_dxgiCreateDXGIFactory2                = (PROC) GetProcAddress(hdxvk_dxgi, "CreateDXGIFactory2");
    PROC h_D3D11CreateDeviceAndSwapChain              = (PROC) GetProcAddress(hsys_d3d11, "D3D11CreateDeviceAndSwapChain");  
    PROC p_SYS_D3D10CoreCreateDevice                  = (PROC) GetProcAddress(hsys_d3d10core, "D3D10CoreCreateDevice");
    PROC p_DXVK_D3D10CoreCreateDevice                 = (PROC) GetProcAddress(hdxvk_d3d10core, "D3D10CoreCreateDevice"); 
    if (D3D11Globals.m_DXVkCreateDXGIFactory1   == nullptr || D3D11Globals.m_DXVkD3D11CreateDeviceAndSwapChain == nullptr ||
        D3D11Globals.m_SystemCreateDXGIFactory1 == nullptr || h_D3D11CreateDeviceAndSwapChain                  == nullptr ||
        p_DXVK_D3D10CoreCreateDevice            == nullptr || p_SYS_D3D10CoreCreateDevice                      == nullptr)
    {
        error = "GetProcAddress Failed";
        return (char*) error.c_str();
    }
    if (sethook((void**)& D3D11Globals.m_SystemCreateDXGIFactory1, (void*)DXVKInjector_CreateDXGIFactory1Hook))
    {
        error = "sethook(DXVKInjector_CreateDXGIFactory1Hook) failed";
        return (char*) error.c_str();
    }
    if (sethook((void**)&h_D3D11CreateDeviceAndSwapChain, (void*)DXVKInjector_D3D11CreateDeviceAndSwapChainHook))
    {
        error = "sethook(DXVKInjector_D3D11CreateDeviceAndSwapChainHook) failed";
        return (char*) error.c_str();
    }
    if (sethook((void**)&p_SYS_D3D10CoreCreateDevice, (void*)p_DXVK_D3D10CoreCreateDevice))
    {
        error = "sethook(p_DXVK_D3D10CoreCreateDevice) failed";
        return (char*) error.c_str();
    }
    if (sethook((void**)&h_sys_dxgiCreateDXGIFactory, (void*)h_dxvk_dxgiCreateDXGIFactory))
    {
        error = "sethook(h_dxvk_dxgiCreateDXGIFactory) failed";
        return (char*) error.c_str();
    }
    if (sethook((void**)&h_sys_dxgiCreateDXGIFactory2, (void*)h_dxvk_dxgiCreateDXGIFactory2))
    {
        error = "sethook(h_dxvk_dxgiCreateDXGIFactory2) failed";
        return (char*) error.c_str();
    }
    return (char*) error.c_str();
}

char * __stdcall D3D11LoadWine(char * winedir, char * dxvkdir, char * game_dir, UINT flags)
{    
    static string error = "S_OK";
    //return (char*) error.c_str();
    if (nullptr != LoadLibraryA("wined3d.dll"))
    {
        DBUG_WARN(error.c_str())
        return (char*) error.c_str();
    }
    if (flags && 0xd /*xvk*.*/)
    {
        error  = D3D11LoadDXVK(dxvkdir, game_dir, flags);
        DBUG_WARN(error.c_str())
        return (char*) error.c_str();
    }
    string winedirw  = winedir;
    string dxvkdirw  = dxvkdir;       

#ifdef _WIN64 
    HMODULE h_dxgi                       = nullptr;      
    HMODULE h_d3d11                      = nullptr; 
    HMODULE h_winedxgi                   = nullptr;  
    HMODULE h_wined3d11                  = nullptr; 
    FARPROC D3D11CoreRegisterLayers      = nullptr;       
    FARPROC WineD3D11CoreRegisterLayers  = nullptr;       
    FARPROC WineDXGID3D10CreateDevice    = nullptr;
    FARPROC WineDXGID3D10RegisterLayers  = nullptr;
    if (LoadLibraryA((string(winedir) + "\\wined3d.dll").c_str()) == 0)
    {
        error = "LoadLibraryA(wined3d) Failed";
        DBUG_WARN(error.c_str());
        return (char*) error.c_str();
    }
    h_dxgi      = LoadLibraryA("dxgi.dll");
    h_d3d11     = LoadLibraryA("d3d11.dll");
    h_winedxgi  = LoadLibraryA((string(winedirw) + "\\dxgi.dll").c_str());
    h_wined3d11 = LoadLibraryA((string(winedirw) + "\\d3d11.dll").c_str());
    if (h_dxgi == nullptr || h_d3d11 == nullptr || h_winedxgi == nullptr || h_wined3d11 == nullptr){
        error = "LoadLibraryA(dxgi, d3d11, winedxgi, wined3d11) Failed";
        DBUG_WARN(error.c_str());
        return (char*) error.c_str();
    }
    D3D11CoreRegisterLayers     = (FARPROC) GetProcAddress(h_d3d11, "D3D11CoreRegisterLayers");
    WineD3D11CoreRegisterLayers = (FARPROC) GetProcAddress(h_wined3d11, "D3D11CoreRegisterLayers");
    WineDXGID3D10CreateDevice   = (FARPROC) GetProcAddress(h_winedxgi, "DXGID3D10CreateDevice");
    WineDXGID3D10RegisterLayers = (FARPROC) GetProcAddress(h_winedxgi, "DXGID3D10RegisterLayers");
    if (D3D11CoreRegisterLayers   == nullptr || WineD3D11CoreRegisterLayers == nullptr || 
        WineDXGID3D10CreateDevice == nullptr || WineDXGID3D10RegisterLayers == nullptr){
        error = "GetProcAddress(D3D11CoreRegisterLayers) Failed";
        DBUG_WARN(error.c_str());
        return (char*) error.c_str();   
    }
    D3D11Globals.SetWineFixPtrs(WineDXGID3D10CreateDevice, WineDXGID3D10RegisterLayers, WineD3D11CoreRegisterLayers);  
    if (sethook((void**)&D3D11CoreRegisterLayers, D3D11CoreRegisterLayersHook))
    {
        error = "sethook(D3D11CoreRegisterLayers) Failed";
        DBUG_WARN(error.c_str());
        return (char*) error.c_str();
    }
    
    char * funcs[17][2] = {
    {"dxgi", "CreateDXGIFactory"}, 
    {"dxgi", "CreateDXGIFactory1"},
    {"dxgi", "CreateDXGIFactory2"},
    {"dxgi", "DXGID3D10CreateDevice"},    
    {"dxgi", "DXGIGetDebugInterface1"},
    {"d3d10core", "D3D10CoreCreateDevice"},    
    {"d3d10", "D3D10CreateDevice"},
    {"d3d10", "D3D10CreateDeviceAndSwapChain"},
    {"d3d10", "D3D10RegisterLayers"},
    {"d3d10_1", "D3D10CreateDevice1"},
    {"d3d10_1", "D3D10CreateDeviceAndSwapChain1"},
    {"d3d10_1", "D3D10RegisterLayers"},
    {"d3d11", "D3D11CoreCreateDevice"},
    {"d3d11", "D3D11CoreCreateLayeredDevice"},
    {"d3d11", "D3D11CoreGetLayeredDeviceSize"},    
    {"d3d11", "D3D11CreateDevice"},
    {"d3d11", "D3D11CreateDeviceAndSwapChain"}
    };

    for (int i=0; i<17; i++)
    {         
        error = D3D11HookWineFunction(funcs[i][0], funcs[i][1], (char*)winedirw.c_str());
        /*if (error != "S_OK")*/ DBUG_WARN(error.c_str());         
    }
#else
if (LoadLibraryA((string(winedir) + "\\wined3d.dll").c_str()) == 0)
    {
        error = "LoadLibraryA(wined3d) Failed";
        DBUG_WARN(error.c_str());
        return (char*) error.c_str();
    }
char * funcs[19][2] = {
    {"dxgi", "CreateDXGIFactory"}, 
    {"dxgi", "CreateDXGIFactory1"},
    {"dxgi", "CreateDXGIFactory2"},
    {"dxgi", "DXGID3D10CreateDevice"},   
    {"dxgi", "DXGID3D10RegisterLayers"},  
    {"dxgi", "DXGIGetDebugInterface1"},
    {"d3d10core", "D3D10CoreCreateDevice"},    
    {"d3d10", "D3D10CreateDevice"},
    {"d3d10", "D3D10CreateDeviceAndSwapChain"},
    {"d3d10", "D3D10RegisterLayers"},
    {"d3d10_1", "D3D10CreateDevice1"},
    {"d3d10_1", "D3D10CreateDeviceAndSwapChain1"},
    {"d3d10_1", "D3D10RegisterLayers"},
    {"d3d11", "D3D11CoreCreateDevice"},
    {"d3d11", "D3D11CoreRegisterLayers"},
    {"d3d11", "D3D11CoreCreateLayeredDevice"},
    {"d3d11", "D3D11CoreGetLayeredDeviceSize"},    
    {"d3d11", "D3D11CreateDevice"},
    {"d3d11", "D3D11CreateDeviceAndSwapChain"}
    };

    for (int i=0; i<19; i++)
    {         
        error = D3D11HookWineFunction(funcs[i][0], funcs[i][1], (char*)winedirw.c_str());
        /*if (error != "S_OK")*/ DBUG_WARN(error.c_str());         
    }
#endif    
    DBUG_WARN(error.c_str());
    return (char*) error.c_str();    
}
