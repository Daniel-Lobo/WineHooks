#include <windows.h>
#include "collections.h"
#include "D3D12Hooks.h"
#include <d3d11.h>
#include <d3d10.h>
#include <d3d10_1.h>
#include <d3dcompiler.h>
#include "D3D11Hooks.h"
#include "dllmain.h"
#include "Sync.h"
#include <memory>
#include "FileSystem.h"
#include "Dbug.h"
extern "C"{
#include "DDSurface.h"
}
#include "sethooks.h"

using std::string;
using std::to_string;

DWORD GetDirect3D10(HWND hWnd, ID3D10_1 * _D3D)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (g_d3d.m_CreateDXGIFactory == nullptr || g_d3d.m_D3D10CreateDevice == nullptr ||
        g_d3d.m_D3DReflect        == nullptr || g_d3d.m_D3DDisassemble    == nullptr) return 1;

    GUID                 IID_IDXGIFactory2;
    GUID                 IID_IDXGISwapChain1;

    DXGI_SWAP_CHAIN_DESC sd;
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

    HRESULT hr = g_d3d.m_D3D10CreateDevice(NULL, D3D10_DRIVER_TYPE_HARDWARE, NULL, 0,
                           D3D10_SDK_VERSION,
                           &_D3D->pDvc);

    if (hr) return 3;

    if (g_d3d.m_CreateDXGIFactory(__uuidof(IDXGIFactory), (void**)&_D3D->pFactory))
    return 33;

    if (_D3D->pFactory->CreateSwapChain((IUnknown*)_D3D->pDvc, &sd, &_D3D->SwapChain))
    return 34;

    IIDFromString(L"{790a45f7-0d42-4876-983a-0a55cfe6f4aa}", &IID_IDXGISwapChain1);
    if (_D3D->SwapChain->QueryInterface((const IID)IID_IDXGISwapChain1, (void**)&_D3D->pSwapChain1))
    return 35;

    IIDFromString(L"{50c83a1c-e072-4c48-87b0-3630fa36a6d0}", &IID_IDXGIFactory2);
    if (_D3D->pFactory->QueryInterface((const IID)IID_IDXGIFactory2, (void**)&_D3D->pFactory2))
    return 9;

    if (g_d3d.HDPROXIES)
    {
        LOGHOOK(ID3D10Device, DrawIndexed, _D3D->pDvc, &D3D11Globals.m_D3D10DrawIndexed, D3D10DrawIndexedHook)
        LOGHOOK(ID3D10Device, Draw, _D3D->pDvc, &D3D11Globals.m_D3D10Draw, D3D10DrawHook)
        LOGHOOK(ID3D10Device, DrawAuto, _D3D->pDvc, &D3D11Globals.m_D3D10DrawAuto, D3D10DrawAutoHook)
        LOGHOOK(ID3D10Device, DrawInstanced, _D3D->pDvc, &D3D11Globals.m_D3D10DrawInstanced, D3D10DrawInstancedHook)   
        LOGHOOK(ID3D10Device, DrawIndexedInstanced, _D3D->pDvc, &D3D11Globals.m_D3D10DrawIndexedInstanced, D3D10DrawIndexedInstancedHook)       
    } else {
        LOGHOOK(ID3D10Device, Draw, _D3D->pDvc, &D3D11Globals.m_D3D10Draw, D3D10DrawHook)
    }

    return 0;
}

DWORD GetDirect3D10_1(HWND hWnd, ID3D10_1 * _D3D)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d.Init();
    if (g_d3d.m_CreateDXGIFactory == nullptr || g_d3d.m_D3D10CreateDvc1AndSChain == nullptr ||
        g_d3d.m_D3DReflect        == nullptr || g_d3d.m_D3DDisassemble           == nullptr) return 1;

    GUID                 IID_IDXGIFactory2;
    IDXGIDevice          * pDXGIDevice  = NULL;
    IDXGIAdapter         * pDXGIAdapter = NULL;

    DXGI_SWAP_CHAIN_DESC sd;
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

    HRESULT hr = g_d3d.m_D3D10CreateDvc1AndSChain(NULL, D3D10_DRIVER_TYPE_HARDWARE, NULL, 0,
                                   D3D10_FEATURE_LEVEL_10_1, D3D10_1_SDK_VERSION,
                                   &sd, &_D3D->SwapChain, &_D3D->pDvc1);
    if (hr) return 3;

    if (_D3D->pDvc1->QueryInterface(__uuidof(ID3D10Device), (void**)&_D3D->pDvc))
    return 4;

    if (_D3D->pDvc1->QueryInterface(__uuidof(IDXGIDevice), (void **)&pDXGIDevice))
    return 5;

    if (pDXGIDevice->GetAdapter( &pDXGIAdapter ))
    return 7;

    if (pDXGIAdapter->GetParent(__uuidof(IDXGIFactory), (void **)&_D3D->pFactory))
    return 8;

    IIDFromString(L"{50c83a1c-e072-4c48-87b0-3630fa36a6d0}", &IID_IDXGIFactory2);
    if (_D3D->pFactory->QueryInterface((const IID)IID_IDXGIFactory2, (void**)&_D3D->pFactory2))
    return 9;

    return 0;
}


void __stdcall D3D10PSSetSamplersHook(ID3D10Device * d, UINT Start,
                                      UINT n, ID3D10SamplerState *const *smplrs)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D11_Hooks->D3D10PSSetSamplers(d, Start, n, smplrs);
}

void __stdcall D3D10PSSetShaderResourcesRef(ID3D10Device* d, UINT a, UINT b,
                                            ID3D10ShaderResourceView * const * r)
{
    D3D11_Hooks->D3D10PSSetShaderResources(d, a, b, r);
}

void __stdcall D3D10PSSetShaderResourcesHook(ID3D10Device* d, UINT a, UINT b,
                                             ID3D10ShaderResourceView * const * r)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    ID3D10ShaderResourceView   ** proxy_views  = new ID3D10ShaderResourceView*[b];
    ID3D10ShaderResourceView    * proxy_view   = nullptr;
    ID3D11ProxyTexture          * tx_proxy     = nullptr;
    ID3D10Resource                 *   res     = nullptr;
    DWORD  i;
    for (i=0; i<b; i++)
    {
        proxy_views[i] = r[i];
        if (r[i] == nullptr) continue;

        res     = D3D10GetResource(r[i]);
        if(res == nullptr)
        {
            DBUG_WARN("RESOUCE NOT FOUND");
            continue;
        } else if ( COMObjectID(res) == COMObjectID(D3D11_Hooks->current_view10) )
        {
            proxy_views[i] = D3D11Globals.m_D3D10CheckBoardPattern;
            continue;
        }

        tx_proxy = D3D10GetProxy(res);
        if ( tx_proxy )
        {
            proxy_view = tx_proxy->SRV10(d, r[i], res);
            if ( proxy_view )
            {
                proxy_views[i] = proxy_view;
            }
            else DBUG_WARN("NO PROXY VIEW");
        }
    }
    D3D11_Hooks->D3D10PSSetShaderResources(d, a, b, proxy_views);
    delete [] proxy_views;
}

HRESULT __stdcall D3D10CreateTexture2DHook(ID3D10Device * d,
                                           const D3D10_TEXTURE2D_DESC * dsc,
                                           const D3D10_SUBRESOURCE_DATA * dat,
                                           ID3D10Texture2D ** pt)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err = D3D11_Hooks->D3D10CreateTexture2D(d, dsc, dat, pt);
    if (!err)
    {
        if ( (dsc->BindFlags & D3D10_BIND_SHADER_RESOURCE) || (dsc->Usage & D3D10_USAGE_STAGING))
        {
            C_D3D11_TEXTURE2D_DESC * desc = new C_D3D11_TEXTURE2D_DESC();
            memcpy(desc, dsc, sizeof(D3D10_TEXTURE2D_DESC));
            D3D11_Hooks->textures->insert(D3D10TextureID(*pt), desc);
        }
        if (dat && D3D11_Hooks->replacements)
        {
            ID3D10_MAPPED m;
            m.m.pData    = (void*)dat[0].pSysMem;
            m.m.RowPitch = dat[0].SysMemPitch;
            memcpy(&m.d, dsc, sizeof(D3D10_TEXTURE2D_DESC));
            D3D10FindTexture2D(&m, *pt, FALSE);
        }
    }
    return err;
}

HRESULT __stdcall D3D10Texture2DReleaseHook(ID3D10Texture2D * v)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID*ID = D3D10TextureID(v);
    HRESULT err = D3D11_Hooks->D3D10ReleaseTexture2D(v);
    if (!err)
    {
        C_D3D10_TEXTURE2D_DESC * d =
                (C_D3D10_TEXTURE2D_DESC *)D3D11_Hooks->textures->Value(ID);
        if (d) delete d;
        D3D11_Hooks->textures->discard(ID);
    }
    return err;
}

HRESULT __stdcall D3D10CreateShaderResourceViewHook(ID3D10Device * d, ID3D10Resource * r,
                                                    D3D10_SHADER_RESOURCE_VIEW_DESC * dc,
                                                    ID3D10ShaderResourceView ** v)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return D3D11_Hooks->D3D10CreateShaderResourceView(d, r, dc, v);
}

HRESULT __stdcall D3D10ResourceViewReleaseHook(ID3D10ShaderResourceView * v)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return D3D11_Hooks->D3D10ReleaseShaderResourceView(v);
}

HRESULT __stdcall D3D10TextureFound(ID3D10Resource* rs, char * file)
{
    ID3D10Texture2D * Tex = D3D10LoadTexture(D3D10GetDevice(rs), file);
    if (Tex)
    {
        D3D11TexUnWrapp r( (IUnknown*) rs, TRUE);
        ID3D11ProxyTexture * proxy = new ID3D11ProxyTexture(Tex);
        ID3D11Weak         * weak  = new ID3D11Weak(r.m_tx2d10);

        if (r.m_tx2d10->SetPrivateDataInterface((GUID &)g_.D3D11ProxyTexture, (IUnknown*)proxy))
            DBUG_WARN("SetPrivateDataInterface FAILED");

        if (Tex->SetPrivateDataInterface((GUID &)g_.D3D11Weak, (IUnknown*)weak))
            DBUG_WARN("SetPrivateDataInterface FAILED");
    }
    return 0;
}

void D3D10FindTexture2D(ID3D10_MAPPED * m, ID3D10Resource * ID, BOOL)
{
    DWORD fmt = GetDXGISurfacePxFormat(m->d.Format);
    D3D11Globals.lock->lock();
    std::string * rep
              = g_.FindTexture(m->d.Width, m->d.Height, m->m.RowPitch, (char*)&fmt, (BYTE*)m->m.pData);
    D3D11Globals.lock->unlock();
    if (rep)
        D3D10TextureFound(ID, (char*)rep->c_str());    
}

void __stdcall D3D10ResolveSubresourceHook(ID3D10Device* dvc, ID3D10Resource *pDst,
                                           UINT DstSub, ID3D10Resource *pSrc,
                                           UINT SrcSub, DXGI_FORMAT Format)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if (!g_d3d.USEPROXIES)
    {
        D3D11_Hooks->D3D10ResolveSubresource(dvc, pDst, DstSub, pSrc, SrcSub, Format);
    }

    ID3D11ProxyTexture * dest_proxy = nullptr;
    ID3D11ProxyTexture * src_proxy  = D3D10GetProxy( pSrc );
    if (src_proxy)
    {
        if (src_proxy->m_Istarget)
        {
            ID3D11ProxyTexture * dest_proxy = D3D10GetProxy(pDst, __FUNCTION__);
            if (!dest_proxy)
            {
                DBUG_WARN("NO PROXY");
                return;
            }
            D3D11_Hooks->D3D10ResolveSubresource(dvc, dest_proxy->m_proxy10, DstSub,
                                                 src_proxy->m_proxy10, SrcSub, Format);
            return;
        }        
    } else if ( (dest_proxy=D3D10GetProxy(pDst)) )
    {
        if (dest_proxy->m_Istarget) DBUG_WARN("COPY TO RENDER TARGET");
    }
}

void __stdcall D3D10CopyResourceHook(ID3D10Device* dvc, ID3D10Resource *pDst,
                                     ID3D10Resource *pSrc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if (!g_d3d.USEPROXIES)
    {
        D3D11_Hooks->D3D10CopyResource(dvc, pDst, pSrc);
    }

    ID3D11ProxyTexture * dest_proxy = nullptr;
    ID3D11ProxyTexture * src_proxy  = D3D10GetProxy( pSrc );
    if (src_proxy)
    {
        if (src_proxy->m_Istarget)
        {
            ID3D11ProxyTexture * dest_proxy = D3D10GetProxy(pDst, __FUNCTION__);
            if (!dest_proxy)
            {
                DBUG_WARN("NO PROXY");
                return;
            }
            D3D11_Hooks->D3D10CopyResource(dvc, dest_proxy->m_proxy10, src_proxy->m_proxy10);
            return;
        }
    } else if ( (dest_proxy=D3D10GetProxy(pDst)) )
    {
        if (dest_proxy->m_Istarget) DBUG_WARN("COPY TO RENDER TARGET");
    }
}

void __stdcall D3D10CopySubresourceRegionHook(ID3D10Device* dvc, ID3D10Resource  *pDstResource,
                                              UINT DstSubresource,UINT DstX, UINT DstY,
                                              UINT DstZ, ID3D10Resource *pSrcResource,
                                              UINT SrcSubresource, const D3D10_BOX *pSrcBox)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)

    if (g_d3d.USEPROXIES)
    {
        ID3D11ProxyTexture * dest_proxy = nullptr;
        ID3D11ProxyTexture * src_proxy  = D3D10GetProxy( pSrcResource );
        if (src_proxy)
        {
            if (src_proxy->m_Istarget)
            {
                ID3D11ProxyTexture * dest_proxy = D3D10GetProxy(pDstResource, __FUNCTION__);
                if (!dest_proxy)
                {
                    DBUG_WARN("NO PROXY");
                    return;
                }
                D3D11_Hooks->D3D10CopySubresourceRegion(dvc, dest_proxy->m_proxy10, DstSubresource, DstX, DstY, DstZ,
                                                        src_proxy->m_proxy10, SrcSubresource, pSrcBox);
                return;
            }
        } else if ( (dest_proxy=D3D10GetProxy(pDstResource)) )
        {
            if (dest_proxy->m_Istarget) DBUG_WARN("COPY TO RENDER TARGET");
        }
    }
    D3D11_Hooks->D3D10CopySubresourceRegion(dvc, pDstResource, DstSubresource, DstX, DstY, DstZ,
                                            pSrcResource, SrcSubresource, pSrcBox);
}

void __stdcall D3D10UpdateSubresourceHook(ID3D10Device* Dvc, ID3D10Resource *pDstResource,
                                          UINT DstSubresource, const D3D10_BOX *pDstBox,
                                          const void *pSrcData, UINT SrcRowPitch,
                                          UINT SrcDepthPitch)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    /* Mind the call from D3D10RenderText */
    D3D11_Hooks->D3D10UpdateSubresource(Dvc, pDstResource, DstSubresource, pDstBox,
                                        pSrcData, SrcRowPitch, SrcDepthPitch);
    D3D10_RESOURCE_DIMENSION d;
    pDstResource->GetType(&d);
    if (d != D3D10_RESOURCE_DIMENSION_TEXTURE2D) return;
    if (DstSubresource > 0)                      return;

    D3D10_TEXTURE2D_DESC D;
    ID3D10Texture2D * tx = (ID3D10Texture2D*) pDstResource;
    tx->GetDesc(&D);

    ID3D10_MAPPED * m = (ID3D10_MAPPED *)
            VirtualAlloc(NULL,sizeof(ID3D10_MAPPED),0x00001000|0x00002000,
                         PAGE_READWRITE);

    memcpy(&m->d, &D, sizeof(D3D10_TEXTURE2D_DESC));
    m->m.RowPitch = SrcRowPitch;
    m->m.pData    = (void*)pSrcData;
    D3D10FindTexture2D(m, pDstResource, FALSE);
    VirtualFree(m, 0, 0);
}

HRESULT __stdcall D3D10MapHook(ID3D10Texture2D* tx, UINT sub, D3D10_MAP type, UINT flags,
                               D3D10_MAPPED_TEXTURE2D * map)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err = D3D11_Hooks->D3D10Map(tx, sub, type, flags, map);
    LPVOID * ID = D3D10TextureID(tx);

    D3D10_TEXTURE2D_DESC * d = (D3D10_TEXTURE2D_DESC *)D3D11_Hooks->textures->Value(ID);
    if (!err && sub==0 && map && d)
    {
        ID3D10_MAPPED * _m = (ID3D10_MAPPED *)
                VirtualAlloc(NULL,sizeof(ID3D10_MAPPED),0x00001000|0x00002000,
                             PAGE_READWRITE);
        memcpy(&_m->m, map, sizeof(D3D10_MAPPED_TEXTURE2D));
        memcpy(&_m->d, d, sizeof(D3D10_TEXTURE2D_DESC));
        D3D11Globals.MappedTextures->insert(ID, _m);
    }
    return err;
}

void __stdcall D3D10UnmapHook(ID3D10Texture2D* tx, UINT sub)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID * ID = D3D10TextureID(tx);
    ID3D10_MAPPED * m = (ID3D10_MAPPED *)D3D11Globals.MappedTextures->Value(ID);
    if ( m )
    {
        D3D10FindTexture2D(m, tx, FALSE);
    }
    D3D11Globals.MappedTextures->remove(ID);
    D3D11_Hooks->D3D10Unmap(tx, sub);    
}

ID3D10Device * GetD3D10Device(IUnknown * i)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    ID3D10Device * D3D10;
    if (i->QueryInterface(__uuidof(ID3D10Device), (void**)&D3D10))
    return 0;
    D3D10->Release();
    return D3D10;
}

void D3D10Present(IDXGISwapChain * Iface, UINT sync, UINT flags)
{
    IUnknown * bb = (IUnknown *)D3D11Globals.BackBuffrerID->Get();
    if (bb)
    {
        D3D11TexUnWrapp Backbuff(bb, TRUE);
        if (Backbuff.m_tx2d)
        {
            ID3D11ProxyTexture * proxybb = D3D10GetProxy(Backbuff.m_tx2d10);
            /* will be null if g_d3d.USEPROXIES == FALSE */
            if (proxybb == nullptr) 
            {                
                D3D10Blit(Iface, Backbuff.m_tx2d10, D3D11Globals.m_D3D10PxBlt, nullptr, &D3D11Globals.BackBufferRect, nullptr);           
            }
            else 
            {
                ID3D10PixelShader * px = g_d3d.SSAA == 3 ? D3D11Globals.m_SSAAHQ :  g_d3d.SSAA == 2 ? D3D11Globals.m_SSAA : D3D11Globals.m_D3D10PxBlt;
                D3D10Blit(Iface, proxybb->m_proxy10, px, nullptr, &D3D11Globals.BackBufferRect, nullptr);
            }
        } else DBUG_WARN("NO PROXY BACKBUFFER")
    }  else DBUG_WARN("NO PROXY BACKBUFFER")

    D3D11Bytecode  * c;
    D3D11Globals.lock->lock();
    DWORD p = D3D11_Hooks->IDXGISwapChain_Present_Callback(Iface, sync, flags);
    D3D11Globals.PixelShader->Set(D3D11_Hooks->CurrentPxShader);
    D3D11Globals.TextID->Set(D3D11_Hooks->current_view10);
    D3D11Globals.lock->unlock();

    ID3D10Device * Dvc = D3D10DvcFromSChain(Iface);
    if      (p == 1) D3D10DumpTexture(Dvc, (IUnknown *)D3D11_Hooks->current_view10,
                                      D3D11_Hooks->dump, 0);
    else if (p == 2) D3D11DumpShader();

    if (D3D11_Hooks->PxBlob)
    {
        ID3D10PixelShader * px = nullptr;
        if (D3D11_Hooks->D3D10CreatePixelShader(Dvc, D3D11_Hooks->PxBlob->GetBufferPointer(),
                                                D3D11_Hooks->PxBlob->GetBufferSize(), &px) == 0)
        {
            DBUG_WARN("CREATED PIXEL SHADER");
            D3D11Globals.lock->lock();
            c = (D3D11Bytecode *)D3D11_Hooks->Shaders->Value(D3D11_Hooks->CurrentPxShader);
            D3D11Globals.lock->unlock();
            if (c) c->set(px);
            else D3D11_Hooks->D3D10PxShaderRelease(px);
        }
        D3D11_Hooks->PxBlob->Release();
        D3D11_Hooks->PxBlob = 0;
    }

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
            } else text.append(L"\nNOT DUMPED");
        }        
        D3D10RenderText(Iface, text.c_str(), &D3D11_Hooks->text_rect);
        if (D3D11_Hooks->Searching == 1)
        {
            if (D3D11_Hooks->current_view10)
            {
                D3D10Texture2DView view(D3D11_Hooks->current_view10);
                if (view.m_VW)
                D3D10Blit(Iface, view.m_VW, nullptr, &D3D11_Hooks->image_rect, nullptr);
            }
        }
    }
}

HRESULT __stdcall CreatePixelShader10Hook(ID3D10Device * d, const void *Bytecode,
                                          SIZE_T Length, ID3D10PixelShader **ppPxShader)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D11_Hooks->D3D10CreatePixelShader(d, Bytecode, Length, ppPxShader);
    if (hr != 0) return hr;

    ID3D10PixelShader * PxR = nullptr;
    D3D11Bytecode     * c   = new D3D11Bytecode(Length, (BYTE*)Bytecode);

    for (UINT i=0; i<D3D11Globals.PxDumps->Count(); i++)
    {
        D3D11Bytecode * dump = (D3D11Bytecode *) D3D11Globals.PxDumps->ValueAt(i);
        if (dump)
        {
            if (*dump == c)
            {
                D3D11Bytecode * BCR = (D3D11Bytecode *) D3D11Globals.PxDumps->KeyAt(i);
                if (D3D11_Hooks->D3D10CreatePixelShader(d, BCR->m_Bytecode, BCR->m_sz, &PxR) == 0)
                {
                    c->Replace10((ID3D10PixelShader*)*ppPxShader, (ID3D10PixelShader*)PxR);                     
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

    D3D11Globals.lock->lock();
    D3D11_Hooks->Shaders->insert_disposable((void*)*ppPxShader, (void*)c);
    D3D11Globals.lock->unlock();
    return hr;
}

HRESULT __stdcall ReleasePixelShader10Hook(ID3D10PixelShader *pPxShader)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D11_Hooks->D3D10PxShaderRelease(pPxShader);
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

void __stdcall D3D10PsSetShaderHook(ID3D10Device * dvc, ID3D10PixelShader * px)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D11_Hooks->D3D10PSSetShader(dvc, px);
    if (px == nullptr) return;
    ID3D10PixelShader * target = (ID3D10PixelShader *)D3D11Globals.PixelShader->Get();
    if (target == px)
    {
        D3D11_Hooks->D3D10PSSetShader(dvc, D3D11Globals.m_D3D10PxBlt);              
        return;
    }
    ID3D10PixelShader * replacement;
    UINT sz = sizeof(ID3D11PixelShader*);
    if (px->GetPrivateData((GUID&)g_.D3D11ProxyShader, &sz, &replacement) == S_OK)
    {
        replacement->Release();
        return D3D11_Hooks->D3D10PSSetShader(dvc, replacement);
    }
    return;


    D3D11Globals.lock->lock();
    D3D11Bytecode * c = (D3D11Bytecode *)D3D11_Hooks->Shaders->Value(px);
    if (c)
    {
        ID3D10PixelShader * target = (ID3D10PixelShader *)D3D11Globals.PixelShader->Get();
        if (target == px)
        {
            D3D11_Hooks->D3D10PSSetShader(dvc, D3D11Globals.m_D3D10PxBlt);
            D3D11Globals.lock->unlock();
            return;
        }
        D3D11Globals.lock->unlock();
        if (c->m_replace)
        return D3D11_Hooks->D3D10PSSetShader(dvc, (ID3D10PixelShader*)c->m_replace);
        return ;
    }
    D3D11Globals.lock->unlock();
    return;    
}

void __stdcall D3D10OMGetRenderTargetsHook(ID3D10Device *d, UINT n,
                                           ID3D10RenderTargetView ** rv,
                                           ID3D10DepthStencilView ** zv)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D11_Hooks->D3D10OMGetRenderTargets(d, n, rv, zv);    
    if (!g_d3d.USEPROXIES)
    return;

    UINT size                  = sizeof(IUnknown *);
    ID3D11Weak        *  proxy = nullptr;
    IUnknown                *u = nullptr;

    for (UINT i=0; i<n; i++)
    {
        if (rv[i] == nullptr) continue;

        if (rv[i]->GetPrivateData((GUID&)g_.D3D11Weak, &size, &u) == 0)
        {
            proxy = dynamic_cast<ID3D11Weak*>(u);
            rv[i]->Release();
            rv[i] = (ID3D10RenderTargetView*)proxy->m_weak;
            proxy->m_weak->AddRef();

        } else {
            DBUG_WARN("NO PROXY");
        }
    }

    if (zv    == nullptr) return;
    if (zv[0] == nullptr) return;

    if (zv[0]->GetPrivateData((GUID&)g_.D3D11Weak, &size, &u) == 0)
    {
        proxy = dynamic_cast<ID3D11Weak*>(u);
        zv[0]->Release();
        zv[0] = (ID3D10DepthStencilView*)proxy->m_weak;
        proxy->m_weak->AddRef();

    } else {
        DBUG_WARN("NO Z PROXY");
    }
}

void __stdcall D3D10OMSetRenderTargetsHook(ID3D10Device *d, UINT NumViews, ID3D10RenderTargetView *const *Views,
                                           ID3D10DepthStencilView *zView)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if (!g_d3d.USEPROXIES)
    {
        D3D11_Hooks->D3D10OMSetRenderTargets(d, NumViews, Views, zView);
        return;
    }

    ID3D10RenderTargetView  ** proxy_views = new ID3D10RenderTargetView*[NumViews];
    ID3D10DepthStencilView   * zproxy      = nullptr;
    ID3D10Resource           * res         = nullptr;    
    ID3D11ProxyTexture       * proxy       = nullptr;

    for (UINT i=0; i<NumViews; i++)
    {
        if (Views[i] == nullptr)
        {
            proxy_views[i] = nullptr;
            continue;
        } 

        res = D3D10GetResource(Views[i]);
        if (res == nullptr)
        {
            DBUG_WARN("NO RESOURCE");
            return;
        }

        proxy = D3D10GetProxy(res, __FUNCTION__);
        if (!proxy)
        {
            DBUG_WARN("NO PROXY");
            return;
        }

        proxy_views[i] = proxy->RTV10(d, Views[i], res);
        if (!proxy_views[i])
        {
            DBUG_WARN("NO RTV");
            return;
        }
    }

    if (zView)
    {
        res = D3D10GetResource(zView);
        if (res == nullptr)
        {
            DBUG_WARN("NO Z RESOURCE");
            return;
        }

        proxy = D3D10GetProxy(res, __FUNCTION__);
        if (!proxy)
        {
            DBUG_WARN("NO PROXY");
            return;
        }

        zproxy = proxy->DSV10(d, zView, res);
        if (!zproxy)
        {
            DBUG_WARN("NO DSV");
            return;
        }
    }
    D3D11_Hooks->D3D10OMSetRenderTargets(d, NumViews, proxy_views, zproxy);
    delete [] proxy_views;
}

void __stdcall D3D10ClearRenderTargetViewHook(ID3D10Device * dvc,
                                    ID3D10RenderTargetView *view,
                                    const FLOAT ColorRGBA)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (!g_d3d.USEPROXIES)
    {
        D3D11_Hooks->D3D10ClearRenderTargetView(dvc, view, ColorRGBA);
        return;
    }

    ID3D10RenderTargetView  *  vw_proxy = nullptr;
    if (view)
    {
        ID3D10Resource * res = D3D10GetResource(view);
        if (res == nullptr)
        {
            DBUG_WARN("NO Z RESOURCE");
            return;
        }

        ID3D11ProxyTexture * proxy = D3D10GetProxy(res, __FUNCTION__);
        if (!proxy)
        {
            DBUG_WARN("NO PROXY");
            return;
        }

        vw_proxy = proxy->RTV10(dvc, view, res);
        if (!vw_proxy)
        {
            DBUG_WARN("NO RTV");
            return;
        }
    }
    D3D11_Hooks->D3D10ClearRenderTargetView(dvc, vw_proxy, ColorRGBA);
}

void __stdcall D3D10ClearDepthStencilViewHook(ID3D10Device * dvc,
                                              ID3D10DepthStencilView *pZView,
                                              UINT flags, FLOAT Depth, UINT8 Stencil)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (!g_d3d.USEPROXIES)
    {
        D3D11_Hooks->D3D10ClearDepthStencilView(dvc, pZView, flags, Depth, Stencil);
        return;
    }

    ID3D10DepthStencilView  *  zproxy = nullptr;
    if (pZView)
    {
        ID3D10Resource * res = D3D10GetResource(pZView);
        if (res == nullptr)
        {
            DBUG_WARN("NO Z RESOURCE");
            return;
        }

        ID3D11ProxyTexture * proxy = D3D10GetProxy(res);
        if (!proxy)
        {
            DBUG_WARN("NO PROXY");
            return;
        }

        zproxy = proxy->DSV10(dvc, pZView, res);
        if (!zproxy)
        {
            DBUG_WARN("NO DSV");
            return;
        }
    }

    D3D11_Hooks->D3D10ClearDepthStencilView(dvc, zproxy, flags, Depth, Stencil);
    return;
}

class D3D10ViewPortScaler
{
    ID3D10Device * m_dvc = nullptr;
    std::vector<D3D10_VIEWPORT> views;
    std::vector<D3D10_VIEWPORT> hd_views;
    std::vector<RECT>  scissor;
    std::vector<RECT>  hd_scissor;
    UINT ViewportCount                 = 0;
    UINT ScissorCount                  = 0;    
public:
    D3D10ViewPortScaler(ID3D10Device* dvc)
    {        
        m_dvc = dvc;
        m_dvc->RSGetViewports(&ViewportCount, nullptr);
        if (ViewportCount == 0)
        {
            DBUG_WARN("::RSGetViewports(&ViewportCount, nullptr) FAILED");
            return;
        }
        views.resize(ViewportCount);
        hd_views.resize(ViewportCount);
        m_dvc->RSGetViewports(&ViewportCount, &views[0]);
        m_dvc->RSGetViewports(&ViewportCount, &hd_views[0]);
        float scale = g_d3d.mScl->Get() * g_d3d.SSAA;
        for (auto& v : hd_views) 
        {
            v.TopLeftX *= scale;
            v.TopLeftY *= scale;
            v.Width    *= scale;
            v.Height   *= scale;           
        }
        m_dvc->RSSetViewports(ViewportCount, &hd_views[0]);
        
        m_dvc->RSGetScissorRects(&ScissorCount, nullptr);
        if (ScissorCount > 0)
        {
            scissor.resize(ScissorCount);
            hd_scissor.resize(ScissorCount);
            m_dvc->RSGetScissorRects(&ScissorCount, &scissor[0]);
            m_dvc->RSGetScissorRects(&ScissorCount, &hd_scissor[0]);
            for (auto& s : hd_scissor)
            {
                s.top    *= scale;
                s.bottom *= scale;
                s.left   *= scale;
                s.right  *= scale;
            }
            m_dvc->RSSetScissorRects(ScissorCount, &hd_scissor[0]);
        }
    }
    ~D3D10ViewPortScaler()
    {
        if (ViewportCount)
        {
            m_dvc->RSSetViewports(ViewportCount, &views[0]);            
        }
        if (ScissorCount)
        {
            m_dvc->RSSetScissorRects(ScissorCount, &scissor[0]);
        }
    }   
};


void __stdcall D3D10DrawAutoHook(ID3D10Device* c)
{
    auto scaler = D3D10ViewPortScaler(c);
    return D3D11Globals.m_D3D10DrawAuto(c);
}    
void __stdcall D3D10DrawIndexedHook(ID3D10Device* c, UINT count, UINT Start, INT Base)
{
    auto scaler = D3D10ViewPortScaler(c);
    D3D11Globals.m_D3D10DrawIndexed(c, count, Start, Base);
    return;
}
void __stdcall D3D10DrawHook(ID3D10Device* c, UINT VertexCount, UINT StartVertexLocation)
{    
    auto scaler = D3D10ViewPortScaler(c);
    D3D11Globals.m_D3D10Draw(c, VertexCount, StartVertexLocation);
    return;
}
void __stdcall D3D10DrawInstancedHook(ID3D10Device* c, UINT p1, UINT p2, UINT p3, UINT p4)
{
    auto scaler = D3D10ViewPortScaler(c);
    D3D11Globals.m_D3D10DrawInstanced(c, p1, p2, p3, p4);
    return;
}
void __stdcall D3D10DrawIndexedInstancedHook(ID3D10Device* c, UINT p1, UINT p2, UINT p3, INT p4, UINT p5)
{
    auto scaler = D3D10ViewPortScaler(c);
    return D3D11Globals.m_D3D10DrawIndexedInstanced(c, p1, p2, p3, p4, p5);
}
