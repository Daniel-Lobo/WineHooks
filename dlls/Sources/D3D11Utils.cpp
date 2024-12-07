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
#include "FileSystem.h"
#include <memory>
#include "Dbug.h"
#include "sethooks.h"
#include <vector>
#include "GDI_Hooks.h"
#include "EZString.h"
extern "C"{
#include "DDSurface.h"
}

#include <string.h>
#include <memory.h>
using std::string;
using std::wstring;
using std::to_string;
using std::to_wstring;
using std::unique_ptr;
using std::vector;
#include <3DMigoto-Assembler.h>

void D3D11Blit(IDXGISwapChain * sc, ID3D11Resource * src, ID3D11RenderTargetView * dst, RECT * r_dst, RECT* r_src)
{
    D3D11Bliter(D3D11DeviceFromSwapShain(sc).m_D3D11Device, sc).Blt(D3D11Globals.m_PxBlt, D3D11Globals.m_VxBlt, src, dst, r_dst, r_src);
}

void D3D11Blit(IDXGISwapChain * sc, ID3D11ShaderResourceView * src, ID3D11RenderTargetView * dst, RECT * r_dst, RECT* r_src)
{
    D3D11Bliter(D3D11DeviceFromSwapShain(sc).m_D3D11Device, sc).Blt(D3D11Globals.m_PxBlt, D3D11Globals.m_VxBlt, src, dst, r_dst, r_src);
}

void D3D11VMirrorBlit(IDXGISwapChain * sc, ID3D11ShaderResourceView * src, ID3D11RenderTargetView * dst, RECT * r_dst, RECT* r_src)
{
    D3D11Bliter(D3D11DeviceFromSwapShain(sc).m_D3D11Device, sc).Blt(D3D11Globals.m_VMirrorPxBlt, D3D11Globals.m_VxBlt, src, dst, r_dst, r_src);
}

void D3D11RenderText(IDXGISwapChain * sc, const wchar_t * text, RECT * r)
{
    DWORD   Width                 = r->right-r->left;
    DWORD  Height                 = r->bottom-r->top;
    UINT * p_data                 = new UINT[(size_t)Width*Height];
    ID3D11Device * dvc   = D3D11DvcFromSChain(sc);
    if (dvc == nullptr)
    {
        DBUG_WARN("D3D10DvcFromSwain FAILED");
        delete [] p_data;
        return;
    }
    GDIText gdi(r, p_data, text, __FUNCTION__);
    ID3D11ShaderResourceView * vw = D3D11CreateTexture2D(dvc, Width, gdi.m_height, (DXGI_FORMAT)0);
    ID3D11Resource * rs           = D3D11GetResource(vw);
    if (rs == nullptr)
    {
        DBUG_WARN("D3D10GetResource FAILED");
        delete [] p_data;
        return;
    }
    /* D3D11_Hooks->D3D1UpdateSubresource Fails. why ? CAUTION on autodump implementation */
    D3D11Cntxt(dvc)->UpdateSubresource(rs, 0, nullptr, p_data+((Height-gdi.m_height)*Width), Width*sizeof(UINT), 0);
    D3D11VMirrorBlit(sc, vw, nullptr, (RECT*)gdi.AlignTop(), nullptr);
    vw->Release();
    delete [] p_data;
}

extern "C" __declspec(dllexport) void D3D11CreateShaders(IDXGISwapChain * sc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD          err = 0;
    ID3D11Device * dvc = D3D11DvcFromSChain(sc);
    if (dvc == nullptr)
    {
        DBUG_WARN("D3D11DvcFromSwain() FAILED");
        return;
    }
    if (D3D11Globals.m_CheckBoardPattern)
    {
        D3D11Globals.m_CheckBoardPattern->Release();
        D3D11Globals.m_CheckBoardPattern = nullptr;
    }
    if (D3D11Globals.m_VxBlt)
    {
        D3D11Globals.m_VxBlt->Release();
        D3D11Globals.m_VxBlt = nullptr;
    }
    if (D3D11Globals.m_PxBlt)
    {
        D3D11_Hooks->PxShaderRelease(D3D11Globals.m_PxBlt);
        D3D11Globals.m_PxBlt = nullptr;
    }
    if (D3D11Globals.m_VMirrorPxBlt)
    {
        D3D11_Hooks->PxShaderRelease(D3D11Globals.m_VMirrorPxBlt);
        D3D11Globals.m_VMirrorPxBlt = nullptr;
    }
    if (dvc->CreateVertexShader(g_d3d.m_VSBlt->GetBufferPointer(), g_d3d.m_VSBlt->GetBufferSize(), nullptr,
                                &D3D11Globals.m_VxBlt) != 0)
    {
        DBUG_WARN("CreateVertexShader(m_D3D10VxBlt) FAILED");
        err += 1;
    }
    if (D3D11_Hooks->CreatePixelShader(dvc, g_d3d.m_PSBlt->GetBufferPointer(), g_d3d.m_PSBlt->GetBufferSize(),
                                       nullptr, &D3D11Globals.m_PxBlt) != 0)
    {
        DBUG_WARN("CreateVertexShader(m_D3D10PxBlt) FAILED");
        err += 1;
    }
    if (D3D11_Hooks->CreatePixelShader(dvc, g_d3d.m_PSVMirrorBlt->GetBufferPointer(), g_d3d.m_PSVMirrorBlt->GetBufferSize(),
                                       nullptr, &D3D11Globals.m_VMirrorPxBlt) != 0)
    {
        DBUG_WARN("CreateVertexShader(m_D3D10VMirrorPxBlt) FAILED");
        err += 1;
    }
    ID3D11ShaderResourceView * vw = D3D11CreateTexture2D(dvc, 256, 256, (DXGI_FORMAT)0);
    ID3D11Resource           * rs = D3D11GetResource(vw);
    if (rs == 0)
    {
        DBUG_WARN("D3D10GetResource() FAILED");
        err += 1;
    }
    else
    {
        D3D11_Hooks->UpdateSubresource(D3D11Cntxt(dvc), rs, 0, nullptr, CheckerBoard().m_pattern, sizeof(UINT)*256, 0);
        D3D11Globals.m_CheckBoardPattern = vw;
    }
    if (err == 0) DBUG_LOG("OK =)")
}


ID3D11Device * D3D11DvcFromSChain(IDXGISwapChain * s)
{
    if (s == nullptr)  return nullptr;
    IDXGIDevice  * DXGIDvc  = nullptr;
    ID3D11Device * D3D11Dvc = nullptr;
    if (s->GetDevice(__uuidof(IDXGIDevice), (void**)&DXGIDvc) == 0)
    {
        DXGIDvc->Release();
        if (DXGIDvc->QueryInterface(__uuidof(ID3D11Device), (void**)&D3D11Dvc) == 0)
        {
            D3D11Dvc->Release();
            return D3D11Dvc;
        }
    } return nullptr;
}

ID3D11Resource * D3D11GetResource(ID3D11View * v)
{
    ID3D11Resource * r = nullptr;
    if (v == nullptr)   return r;

    v->GetResource(&r);
    if (r)r->Release();

    return r;
}

extern "C" __declspec(dllexport) ID3D11Texture2D * D3D11GetTexture2D(ID3D11View * v)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    ID3D11Resource * r   = D3D11GetResource(v);
    if (r == nullptr)           return nullptr;
    ID3D11Texture2D * tx = (ID3D11Texture2D *)
                            EZInterface(__uuidof(ID3D11Texture2D), r).I();
    if (tx)
    {
        tx->AddRef();
        return tx;
    }
    return nullptr;
}

ID3D11ProxyTexture * D3D11GetProxy(ID3D11DeviceChild * r)
{
    UINT size       = sizeof(IUnknown *);
    ID3D11ProxyTexture * proxy = nullptr;
    IUnknown           * i     = nullptr;
    r->GetPrivateData((GUID &)g_.D3D11ProxyTexture, &size, (void**)&i);
    if (i)
    {
        proxy = dynamic_cast<ID3D11ProxyTexture*>(i);
        proxy->Release();
    }
    return proxy;
}

ID3D11ProxyTexture * D3D11GetProxy(ID3D11DeviceChild * r, const char * caller)
{
    std::string err(caller);
    ID3D11Texture2D    * proxy_tx = nullptr;
    ID3D11ProxyTexture * proxy    = D3D11GetProxy(r);
    if (!proxy)
    {
        D3D11TexUnWrapp proxy_res(r);
        if (proxy_res.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN((err + " NOT A 2D TEXTURE: " + to_string(proxy_res.Type())).c_str());
            return nullptr;
        }
        D3D11_TEXTURE2D_DESC * D = proxy_res.Desc();
        DWORD w = D->Width;
        DWORD h = D->Height;   
        if (g_d3d.HDPROXIES)
        {
            D->Width  *= g_d3d.mScl->Get() * g_d3d.SSAA;
            D->Height *= g_d3d.mScl->Get() * g_d3d.SSAA;
        }
        if ( D3D11_Hooks->CreateTexture2D(D3D11GetDevice(r), D, nullptr, &proxy_tx) != 0 )
        {
            DBUG_WARN((err + " FAILED TO CREATE PROXY 2D TEXTURE").c_str());
            return nullptr;
        }
        DBUG_WARN((err + " CREATED PROXY " + to_string(w) + "x" + to_string(h) + " " + to_string(D->Width) + "x" + to_string(D->Height)).c_str());
        proxy = new ID3D11ProxyTexture(proxy_tx);
        r->SetPrivateDataInterface((GUID &)g_.D3D11ProxyTexture, (IUnknown*)proxy);
    }
    return proxy;
}

ID3D11Device * D3D11GetDevice(ID3D11DeviceChild *ch)
{
    ID3D11Device * dvc = nullptr;
    ch->GetDevice(&dvc);
    if (dvc) dvc->Release();
    return dvc;
}

D3D11TexUnWrapp::D3D11TexUnWrapp(IUnknown * v)
{
    if      (v == nullptr)                     DBUG_WARN("NULL INTERFACE")
    else if (v->QueryInterface(__uuidof(ID3D11Resource), (void**)&m_tx2d) != 0)
        DBUG_WARN("NOT A D3D11Texture2D");
}

D3D11TexUnWrapp::D3D11TexUnWrapp(IUnknown * v, BOOL)
{
    if      (v == nullptr)                     DBUG_WARN("NULL INTERFACE")
    else if (v->QueryInterface(__uuidof(ID3D10Resource), (void**)&m_tx2d) != 0)
        OUTPUT_FUNC_DBG_STRING("NOT A D3D11Texture2D");
}

D3D11TexUnWrapp::D3D11TexUnWrapp(ID3D11View * v)
{
    if  (v == nullptr) DBUG_WARN("NULL VIEW")
    else v->GetResource((ID3D11Resource**)&m_tx2d);
}

D3D11TexUnWrapp::D3D11TexUnWrapp(ID3D10View * v)
{
    if  (v == nullptr) DBUG_WARN("NULL VIEW")
    else v->GetResource((ID3D10Resource**)&m_tx2d);
}

D3D11_RESOURCE_DIMENSION D3D11TexUnWrapp::Type()
{
    D3D11_RESOURCE_DIMENSION t = (D3D11_RESOURCE_DIMENSION) 0;
    if  (m_tx2d == nullptr) DBUG_WARN("NULL RESOURCE")
    else m_tx2d->GetType(&t);
    return t;
}

D3D10_RESOURCE_DIMENSION D3D11TexUnWrapp::Type10()
{
    D3D10_RESOURCE_DIMENSION t = (D3D10_RESOURCE_DIMENSION) 0;
    if  (m_tx2d10 == nullptr) DBUG_WARN("NULL RESOURCE")
    else m_tx2d10->GetType(&t);
    return t;
}

D3D11_TEXTURE2D_DESC * D3D11TexUnWrapp::Desc()
{
    if      (m_tx2d == nullptr) DBUG_WARN("NULL RESOURCE")
    else if (Type() == D3D11_RESOURCE_DIMENSION_TEXTURE2D) m_tx2d->GetDesc(&m_desc2d);
    return &m_desc2d;
}

D3D10_TEXTURE2D_DESC * D3D11TexUnWrapp::Desc10()
{
    if      (m_tx2d10 == nullptr) DBUG_WARN("NULL RESOURCE")
    else if (Type10() == D3D10_RESOURCE_DIMENSION_TEXTURE2D) m_tx2d10->GetDesc(&m_desc2d10);
    return &m_desc2d10;
}

D3D11Texture2DView::D3D11Texture2DView(ID3D11Resource * rr)
{
    D3D11TexUnWrapp tex((IUnknown*) rr);
    if ( tex.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
    {
        DBUG_WARN("NOT A 2D TEXTURE");
    }

    D3D11_SHADER_RESOURCE_VIEW_DESC    rsc_desc;
    rsc_desc.Format                    = tex.Desc()->Format;
    rsc_desc.ViewDimension             = D3D11_SRV_DIMENSION_TEXTURE2D;
    rsc_desc.Texture2D.MostDetailedMip = 0;
    rsc_desc.Texture2D.MipLevels       = 1;
    if       (rsc_desc.Format == DXGI_FORMAT_R8G8B8A8_TYPELESS)
              rsc_desc.Format =  DXGI_FORMAT_R8G8B8A8_UNORM;
    else if  (rsc_desc.Format == DXGI_FORMAT_B8G8R8A8_TYPELESS)
              rsc_desc.Format =  DXGI_FORMAT_B8G8R8A8_UNORM;
    //if (rsc_desc.Format == DXGI_FORMAT_R8G8B8A8_UNORM_SRGB) rsc_desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;    
    //if (rsc_desc.Format == DXGI_FORMAT_B8G8R8X8_UNORM_SRGB) rsc_desc.Format = DXGI_FORMAT_B8G8R8X8_UNORM;
    //if (rsc_desc.Format == DXGI_FORMAT_B8G8R8A8_UNORM_SRGB) rsc_desc.Format = DXGI_FORMAT_B8G8R8A8_UNORM;
    if (D3D11_Hooks->CreateShaderResourceView(D3D11GetDevice(tex.m_tx2d), tex.m_tx2d, &rsc_desc, &m_VW) != 0)
    DBUG_WARN("CreateShaderResourceView FAILED");
}

D3D11Texture2DRTView::D3D11Texture2DRTView(ID3D11Resource * rr)
{
    D3D11TexUnWrapp tex((IUnknown*) rr);
    if ( tex.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
    {
        DBUG_WARN("NOT A 2D TEXTURE");
    }

    D3D11_RENDER_TARGET_VIEW_DESC      rsc_desc;
    rsc_desc.Format                    = tex.Desc()->Format;
    rsc_desc.ViewDimension             = D3D11_RTV_DIMENSION_TEXTURE2D;
    rsc_desc.Texture2D.MipSlice        = 0;
    if( D3D11GetDevice(tex.m_tx2d)->CreateRenderTargetView(tex.m_tx2d, &rsc_desc, &m_VW) != 0)
    DBUG_WARN("CreateRenderTargetView FAILED");
}

D3D11Bliter::D3D11Bliter(ID3D11Device * dcv, IDXGISwapChain * sc)
{
    m_sc  = sc;
    m_Dvc = dcv;
    m_sc->AddRef();
    m_Dvc->AddRef();

    ID3D11DeviceContext * ctx = D3D11Cntxt(m_Dvc);
    if (ctx)
    {
        ctx->RSGetState(&m_rstr);
        ctx->VSGetConstantBuffers(0, 1, &m_CB0);
        ctx->IAGetInputLayout(&m_il);
        ctx->IAGetPrimitiveTopology(&m_pt);
        D3D11_Hooks->OMGetRenderTargets(ctx, 8, m_rtv, &m_dsv);
        ctx->PSGetShaderResources(0, 1, &m_srv);
        ctx->VSGetShader(&m_vx, 0, 0);
        ctx->PSGetShader(&m_px, 0, 0);
        ctx->OMGetBlendState(&m_bld, m_blndfactor, &m_Blndmask);
        ctx->PSGetSamplers(0, 1, &m_smplr);

        UINT n = 8;
        D3D11_Hooks->RSGetViewports(ctx, &n, m_vws);
        D3D11_Hooks->RSGetScissorRects(ctx, &n, m_scr);
    } else DBUG_WARN("NO CONTEXT")

    D3D11_BUFFER_DESC dsc;
    ZeroMemory(&dsc, sizeof(D3D11_BUFFER_DESC));
    dsc.ByteWidth            = sizeof(float)*8;
    dsc.Usage                = D3D11_USAGE_DEFAULT;
    dsc.BindFlags            = D3D11_BIND_CONSTANT_BUFFER;
    dsc.StructureByteStride  = dsc.ByteWidth;
    if (dcv->CreateBuffer(&dsc, NULL, &m_prms) != 0)
    DBUG_WARN("CreateBuffer FAILED");
}

ID3D11RenderTargetView * D3D11Bliter::GetRTV()
{
    ID3D11Texture2D        * bb   = nullptr;
    ID3D11RenderTargetView * bbvw = nullptr;
    D3D11_RENDER_TARGET_VIEW_DESC vw_desc;
    D3D11_TEXTURE2D_DESC  bb_desc;

    D3D11_Hooks->GetBuffer(m_sc, 0, __uuidof( ID3D11Texture2D ), ( LPVOID* )&bb );
    if( bb )
    {
        std::string err("BACK BUFFER SIZE ");
        bb->GetDesc(&bb_desc);        
        vw_desc.Format             = bb_desc.Format;
        //if (vw_desc.Format == DXGI_FORMAT_R8G8B8A8_UNORM_SRGB) vw_desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
        //if (vw_desc.Format == DXGI_FORMAT_B8G8R8X8_UNORM_SRGB) vw_desc.Format = DXGI_FORMAT_B8G8R8X8_UNORM;
        //if (vw_desc.Format == DXGI_FORMAT_B8G8R8A8_UNORM_SRGB) vw_desc.Format = DXGI_FORMAT_B8G8R8A8_UNORM;
        vw_desc.ViewDimension      = D3D11_RTV_DIMENSION_TEXTURE2D;
        vw_desc.Texture2D.MipSlice = 0;
        m_Dvc->CreateRenderTargetView(bb, &vw_desc, &bbvw);
        bb->Release();
        return bbvw;
    } else DBUG_WARN("NO TARGET");
    return 0;
}

void D3D11Bliter::UpdateRects(RECT * dst, RECT *, ID3D11RenderTargetView * vw)
{
    float                    d[8];
    D3D11_TEXTURE2D_DESC     desc;
    D3D11_RESOURCE_DIMENSION type = (D3D11_RESOURCE_DIMENSION)NULL;
    ID3D11Texture2D  * vw_rsrc = nullptr;

    vw->GetResource((ID3D11Resource**)&vw_rsrc);
    if (vw_rsrc == nullptr)
    {
        OutputDebugStringA("ID3D11RenderTargetView::GetResource FAILED");
        return;
    }

    vw_rsrc->GetType(&type);
    if (type != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
    {
        OutputDebugStringA("ID3D11Resource IS NOT A ID3D11Texture2D");
        return ;
    }

    vw_rsrc->GetDesc(&desc);
    vw_rsrc->Release();
    float w = desc.Width/(float)2.f;
    float y = desc.Height/(float)2.f;
    d[0] = (dst->left  /w)-1;
    d[1] = (dst->top   /y)-1;
    d[2] = (dst->right /w)-1;
    d[3] = (dst->bottom/y)-1;

    RECT scissor;
    scissor.top    = 0;
    scissor.left   = 0;
    scissor.bottom = desc.Height;
    scissor.right  = desc.Width;

    D3D11_VIEWPORT view;
    view.Width    = (float)desc.Width;
    view.Height   = (float)desc.Height;
    view.TopLeftX = 0;
    view.TopLeftY = 0;
    view.MaxDepth = 1;
    view.MinDepth = 0;

    ID3D11DeviceContext *ctx = D3D11Cntxt(m_Dvc);
    D3D11Cntxt(m_Dvc)->UpdateSubresource(m_prms, 0, nullptr, d, 0, 0);
    D3D11_Hooks->RSSetViewports(ctx, 1, &view);
    D3D11_Hooks->RSSetScissorRects(ctx, 1, &scissor);
}

void D3D11Bliter::SetStates()
{
    ID3D11SamplerState      * ss = nullptr;
    D3D11_SAMPLER_DESC               sdesc;

    if (!m_bld)
    {
        OUTPUT_FUNC_DBG_STRING("NO BLEND STATE");
    } else  {
       float blendfactor[4] = {1., 1., 1., 1.};
       D3D11Cntxt(m_Dvc)->OMSetBlendState(nullptr, blendfactor, 0xffffffff);
    }

    sdesc.Filter         = D3D11_FILTER_MIN_MAG_MIP_POINT;
    sdesc.AddressU       = D3D11_TEXTURE_ADDRESS_WRAP;
    sdesc.AddressV       = D3D11_TEXTURE_ADDRESS_WRAP;
    sdesc.AddressW       = D3D11_TEXTURE_ADDRESS_WRAP;
    sdesc.MipLODBias     = 0.0;
    sdesc.MinLOD         = 0.0;
    sdesc.MaxLOD         = 0.0;
    sdesc.MaxAnisotropy  = 16;
    sdesc.ComparisonFunc = D3D11_COMPARISON_NEVER;
    ZeroMemory(&sdesc.BorderColor, sizeof(float)*4);

    if (m_Dvc->CreateSamplerState(&sdesc, &ss) != 0)
    {
        DBUG_WARN("CreateSamplerState FAILED");
    }
    else
    {
        ID3D11SamplerState * sss[1] = {ss};
        D3D11Cntxt(m_Dvc)->PSSetSamplers(0, 1, sss);
        ss->Release();
     }
}

HRESULT D3D11Bliter::Blt(ID3D11PixelShader*px, ID3D11VertexShader*vx,
                         ID3D11ShaderResourceView*tx, ID3D11RenderTargetView*vw,
                         RECT * dst, RECT* src)
{
    if (vw == NULL)  vw = GetRTV();
    if (vw == NULL)  return 1;
    UpdateRects(dst, src, vw);
    SetStates();

    ID3D11DeviceContext * ctx = D3D11Cntxt(m_Dvc);
    D3D11_Hooks->OMSetRenderTargets(ctx, 1, &vw, NULL);
    D3D11_Hooks->ImPSSetShaderResources(ctx, 0, 1, &tx);
    //ctx->PSSetSamplers(0, 1, &m_smplr);
    //ctx->PSSetShaderResources(0, 1, &tx);
    ctx->VSSetConstantBuffers(0, 1, &m_prms);
    ctx->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
    ctx->IASetInputLayout(NULL);
    ctx->PSSetShader(px, 0, 0);
    ctx->VSSetShader(vx, 0, 0);
    ctx->GSSetShader(0, 0, 0);
    ctx->RSSetState(nullptr);
    if (g_d3d.HDPROXIES) D3D11Globals.m_Draw(ctx, 6, 0);
    else ctx->Draw(6, 0);

    if (vw) vw->Release();
    return 1;
}

HRESULT D3D11Bliter::Blt(ID3D11PixelShader*px, ID3D11VertexShader*vx,
                         ID3D11Resource*rs, ID3D11RenderTargetView*vw,
                         RECT * dst, RECT* src)
{
    D3D11Texture2DView view(rs);
    Blt(px, vx, view.m_VW, vw, dst, src);
    return 0;
}

D3D11Bliter::~D3D11Bliter()
{
    ID3D11DeviceContext * ctx = D3D11Cntxt(m_Dvc);
    D3D11_Hooks->ImPSSetShaderResources(ctx, 0, 1, &m_srv);
    D3D11_Hooks->OMSetRenderTargets(ctx, 8, m_rtv, m_dsv);
    D3D11_Hooks->RSSetViewports(ctx, 8, m_vws);
    D3D11_Hooks->RSSetScissorRects(ctx, 8, m_scr);
    ctx->VSSetConstantBuffers(0, 1, &m_CB0);
    ctx->IASetPrimitiveTopology(m_pt);
    ctx->IASetInputLayout(m_il);
    ctx->PSSetShader(m_px, 0, 0);
    ctx->VSSetShader(m_vx, 0, 0);

    if(m_bld)
    {
       ctx->OMSetBlendState(m_bld, m_blndfactor, m_Blndmask);
       m_bld->Release();
    }
    if(m_rstr)
    {
       ctx->RSSetState(m_rstr);
       m_rstr->Release();
    }
    //return;
    for (UINT i=0; i<8; i++)
    if (m_rtv[i]) m_rtv[i]->Release();
    if (m_sc)     m_sc->Release();
    if (m_Dvc)    m_Dvc->Release();
    if (m_il)     m_il->Release();
    if (m_dsv)    m_dsv->Release();
    if (m_srv)    m_srv->Release();
    if (m_px)     m_px->Release();
    if (m_vx)     m_vx->Release();
    if (m_CB0)    m_CB0->Release();
    if (m_prms)   m_prms->Release();
}

HRESULT D3D11WriteOnSurface(ID3D11Device * d, ID3D11Texture2D * t, wchar_t * text, DWORD clr)
{
    D3D11_TEXTURE2D_DESC desc;
    if (IsD3D11Device(d))
    {
        t->GetDesc(&desc);
    } else {
        D3D10_TEXTURE2D_DESC * d = (D3D10_TEXTURE2D_DESC*) &desc;
        ID3D10Texture2D * tx = (ID3D10Texture2D*) t;
        tx->GetDesc(d);
    }

    RECT rect;
    rect.left = 0; rect.top = 0; rect.right = desc.Width; rect.bottom = desc.Height;
    DWORD    * pData = (DWORD*)malloc(desc.Width*desc.Height*4);
    DWORD    * read  = pData;

    HDC hDC      = CreateCompatibleDC(NULL);
    HBITMAP hBmp = CreateCompatibleBitmap(hDC, desc.Width, desc.Height);
    SelectObject( hDC, hBmp );
    SetBkMode(hDC, 1);
    SetTextColor(hDC, 0x00ffffff);
    DPtoLP(hDC, (LPPOINT)&rect, 2);
    DrawTextW(hDC, text, -1, &rect, DT_NOCLIP);

    BITMAPINFO BMInfo = {0};
    BMInfo.bmiHeader.biSize = sizeof(BMInfo.bmiHeader);
    GetDIBits(hDC, hBmp, 0, 0, NULL, &BMInfo, DIB_RGB_COLORS);

    BMInfo.bmiHeader.biSize        = sizeof(BMInfo.bmiHeader);
    BMInfo.bmiHeader.biBitCount    = 32;
    BMInfo.bmiHeader.biCompression = BI_RGB;

    GetDIBits(hDC, hBmp, 0, BMInfo.bmiHeader.biHeight, (LPVOID)read, &BMInfo, DIB_RGB_COLORS);

    *pData = clr;
#ifdef _WIN64
    D3D11Cntxt(d)->UpdateSubresource(t, 0, 0, pData, desc.Width*4, 0);
#else
    if (IsD3D11Device(d))
        D3D11Cntxt(d)->UpdateSubresource(t, 0, 0, pData, desc.Width*4, 0);
    else
    {
        ID3D10Device * Dvc = GetD3D10Device((IUnknown*)d);
        Dvc->UpdateSubresource((ID3D10Texture2D *) t, 0, NULL, pData, desc.Width*4, 0);
    }
#endif

    free(pData);
    DeleteObject(hDC);
    DeleteObject(hBmp);

    return 0;
}

DWORD D3D11DumpShader()
{
    D3D11Bytecode * c = (D3D11Bytecode *) D3D11_Hooks->Shaders->Value(D3D11_Hooks->CurrentPxShader);

    if (!c)
    {
        DBUG_WARN("SHADER NOT FOUND");
        return 1;
    }

    if (c->Disassemble() != 0)
    {
        DBUG_WARN("FAILED TO DISSASEMBLY");
        return 2;
    }

    std::wstring binpath(D3D11_Hooks->dump);
    std::wstring txtpath(D3D11_Hooks->dump);

    txtpath.append(L".txt");
    binpath.append(L".bin");

    std::unique_ptr<WinFile> bin(new WinFile(binpath.c_str()));
    std::unique_ptr<WinFile> txt(new WinFile(txtpath.c_str()));

    bin->write(c->m_Bytecode, c->m_sz);
    txt->write(c->m_blob->GetBufferPointer(), c->m_blob->GetBufferSize());
    return 0;
}

ID3D11ShaderResourceView * D3D11CreateTexture2D(ID3D11Device * d, DWORD w, DWORD h, DXGI_FORMAT fmt)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D11_TEXTURE2D_DESC               desc;
    D3D11_SHADER_RESOURCE_VIEW_DESC    view;
    HRESULT                              hr;
    ID3D11Texture2D         * Tex = nullptr;
    ID3D11ShaderResourceView * Vw = nullptr;

    if (!fmt)
    fmt                     = DXGI_FORMAT_R8G8B8A8_UNORM;
    desc.Format             = fmt;
    desc.Width              = w;
    desc.Height             = h;
    desc.MipLevels          = 1;
    desc.ArraySize          = 1;
    desc.SampleDesc.Count   = 1;
    desc.SampleDesc.Quality = 0;
    desc.Usage              = D3D11_USAGE_DEFAULT;
    desc.BindFlags          = D3D11_BIND_SHADER_RESOURCE;
    desc.CPUAccessFlags     = 0;
    desc.MiscFlags          = 0;

    hr = D3D11_Hooks->CreateTexture2D(d, &desc, nullptr, &Tex);
    if ( hr )
    {
        DBUG_WARN("CreateTexture2D FAILED");
        return 0;
    }

    view.Format                    = desc.Format;
    view.ViewDimension             = D3D11_SRV_DIMENSION_TEXTURE2D;
    view.Texture2D.MostDetailedMip = 0;
    view.Texture2D.MipLevels       = 1;

    hr = D3D11_Hooks->CreateShaderResourceView(d, Tex, &view, &Vw);
    if ( hr )
    {
        DBUG_WARN("CreateShaderResourceView FAILED");
        return 0;
    }
    Tex->Release();
    return Vw;
}

ID3D11Texture2D * D3D11LoadTexture(ID3D11Device * d, char * file)
{
    if (d == nullptr)
    {
        DBUG_WARN("null");
        return nullptr;
    }
    char                         fmt[20];
    HANDLE                         hFile;
    DWORD                    magic, read;
    BOOL                               b;
    DDS_HEADER                DDS_Header;    
    D3D11_TEXTURE2D_DESC            desc;    
    HRESULT                            r;
    DWORD               bypp, w, h, lvls;
    ID3D11Texture2D      * Tex = nullptr;

    hFile = CreateFileA(file, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
                        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

    if (hFile == INVALID_HANDLE_VALUE)
    {
        hFile = CreateFileA(g_.m_FallBackTextureReplacement.c_str(), GENERIC_READ,
                            FILE_SHARE_READ | FILE_SHARE_WRITE,
                            NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
        if (hFile == INVALID_HANDLE_VALUE)
        {
            DBUG_WARN(g_.m_FallBackTextureReplacement.c_str());
            return nullptr;
        }
    }

    b = ReadFile(hFile, &magic, 4, &read, NULL);
    if ( (!b) || (magic != 0x20534444) )
    {
        CloseHandle(hFile);
        DBUG_WARN("FILE IS NOT A DDS SURFACE");
        return nullptr;
    }

    b = ReadFile(hFile, &DDS_Header, sizeof(DDS_HEADER), &read, NULL);
    if (DDS_Header.dwWidth == NULL)
    {
        DBUG_WARN("INVALID DDS SURFACE SIZE");
        return nullptr;
    }

    GetDDSFileFormat(&DDS_Header, fmt);
    DBUG_LOG(fmt);
    if (SetDXGISurfacePxFormat(&desc.Format, *(DWORD*)fmt) == 0)
    {
        CloseHandle(hFile);
        DBUG_WARN("UNSUPORTED FORMAT");
        return nullptr;
    }

    if (DDS_Header.dwFlags & 0x20000) lvls = DDS_Header.dwMipMapCount;
    else                              lvls = 1;

    w = DDS_Header.dwWidth;
    h = DDS_Header.dwHeight;
    if ( *(BYTE*)fmt == *(BYTE*)"D" )
    {
        bypp = *(DWORD*)fmt == *(DWORD*)"DXT1" ? 2 : 4;
    } else {
        bypp = DDS_Header.ddspf.dwRGBBitCount/8;        
    }

    desc.Width              = DDS_Header.dwWidth;
    desc.Height             = DDS_Header.dwHeight;
    desc.MipLevels          = lvls;
    desc.ArraySize          = 1;
    desc.SampleDesc.Count   = 1;
    desc.SampleDesc.Quality = 0;
    desc.Usage              = D3D11_USAGE_DEFAULT;
    desc.BindFlags          = D3D11_BIND_SHADER_RESOURCE;
    desc.CPUAccessFlags     = 0;
    desc.MiscFlags          = 0;

    r = D3D11_Hooks->CreateTexture2D(d, &desc, nullptr, &Tex);
    if (r)
    {
        DBUG_WARN("CreateTexture2D FAILED");
        return nullptr;
    }

    desc.Usage               = D3D11_USAGE_STAGING;
    desc.BindFlags           = 0;
    desc.CPUAccessFlags      = D3D11_CPU_ACCESS_WRITE;
    ID3D11Texture2D  *SysMem = nullptr;

    r = D3D11_Hooks->CreateTexture2D(d, &desc, nullptr, &SysMem);
    if (r)
    {
        DBUG_WARN("CreateTexture2D FAILED FOR SYSMEM TEXTURE");
        return nullptr;
    }

    D3D11_MAPPED_SUBRESOURCE m;
    for (UINT i=0; i<lvls; i++)
    {
        if (D3D11_Hooks->Map(D3D11Cntxt(d), SysMem, i, D3D11_MAP_WRITE, 0, &m)==0)
        {
            LoadData2Surface(m.pData, hFile, m.RowPitch, w, h, bypp);
            D3D11_Hooks->Unmap(D3D11Cntxt(d), SysMem, i);
        } else DBUG_WARN("MAP FAILED");
        w /= 2;
        h /= 2;
    }
    CloseHandle(hFile);

    D3D11_Hooks->CopyResource(D3D11Cntxt(d), Tex, SysMem);
    SysMem->Release();    
    return Tex;
}

HRESULT __stdcall D3D11DumpTexture(IUnknown * u, LPCWSTR path, DWORD autodmp)
{
    ID3D11Device            * d3  = nullptr;
    ID3D11DeviceContext     * ctx = nullptr;
    HRESULT                  err = 0;
    D3D11_TEXTURE2D_DESC     dsc;
    DWORD                    fmt;
    ID3D11Texture2D        * t = 0, * Sys = 0;
    D3D11_MAPPED_SUBRESOURCE map;

    u->QueryInterface(__uuidof(ID3D11Texture2D), (void **)&t);
    if (!t)
    {
        err = 1;
        DBUG_WARN("INTERFACE OS NOT A ID3D11Texture2D");
        goto D3D11DumpTexture_CleanUp;
    }
    t->GetDevice(&d3);
    if (d3 == nullptr)
    {
        err = 6;
        DBUG_WARN("ID3D11DeviceChild::GetDevice() FAILED");
        goto D3D11DumpTexture_CleanUp;
    }
    ctx = D3D11Cntxt(d3);
    if (ctx == nullptr)
    {
        err = 7;
        DBUG_WARN("D3D11Device::GetImmediateContext() FAILED");
        goto D3D11DumpTexture_CleanUp;
    }

    t->GetDesc(&dsc);
    if (dsc.Usage == D3D11_USAGE_STAGING)
    {
        if (!autodmp)
        {
            err = 2;
            DBUG_WARN("SYSTEM MEMORY TEXTURE");
            goto D3D11DumpTexture_CleanUp;
        }
    }

    dsc.Usage          = D3D11_USAGE_STAGING;
    dsc.BindFlags      = 0;
    dsc.CPUAccessFlags = D3D11_CPU_ACCESS_READ;
    if (D3D11_Hooks->CreateTexture2D(d3, &dsc, 0, &Sys) != 0)
    {
        err = 3;
        DBUG_WARN("CreateTexture2D FAILED");
        goto D3D11DumpTexture_CleanUp;
    }
    ctx->CopySubresourceRegion(Sys, 0, 0, 0, 0, t, 0, 0);
    fmt = GetDXGISurfacePxFormat(dsc.Format);
    if (fmt == *(DWORD*) "?????")
    {
        err = 4;
        DBUG_WARN((string("UNSUPPORTED FORMAT =( ")+to_string(dsc.Format)).c_str());
        goto D3D11DumpTexture_CleanUp;
    }

    if (D3D11_Hooks->Map(ctx, Sys, 0, D3D11_MAP_READ, 0, &map) != 0)
    {
        err = 5;
        DBUG_WARN("ID3D11DeviceContect::Map FAILED");
        goto D3D11DumpTexture_CleanUp;
    }
    DumpDDS((wchar_t*)path, (char*)&fmt, dsc.Width, dsc.Height, map.pData, map.RowPitch);
    D3D11_Hooks->Unmap(ctx, Sys, 0);

    D3D11DumpTexture_CleanUp:
    if (Sys) D3D11_Hooks->ReleaseTexture2D(Sys);
    if (t)   D3D11_Hooks->ReleaseTexture2D(t);
    if (ctx) ctx->Release();
    if (d3)  d3->Release();
    return err;
}

extern "C" __declspec(dllexport) HRESULT  D3D11Resize(IDXGISwapChain* sc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DXGI_MODE_DESC mode;
    ZeroMemory(&mode, sizeof(DXGI_MODE_DESC));
    mode.Format = DXGI_FORMAT_UNKNOWN;
    mode.Height = D3D11_Hooks->HD_H;
    mode.Width  = D3D11_Hooks->HD_W;

    if (D3D11_Hooks->ResizeTarget(sc, &mode) != 0)
    {
        DBUG_WARN("IDXGISwapChain::ResizeTarget Failed");
        return 1;
    }

    if (D3D11_Hooks->ResizeBuffers(sc, 1920, 1080, 3, DXGI_FORMAT_UNKNOWN
                                   , DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH) != 0)
    {
        DBUG_WARN("IDXGISwapChain::ResizeBuffers Failed");
        return 2;
    }
    return 0 ;
}

UINT D3D11ViewType(ID3D11View * vw, IUnknown** view)
{
    if (vw == nullptr) return 0;

    if (vw->QueryInterface(__uuidof(ID3D11RenderTargetView), (void**)view) == 0)
    return 1;
    if (vw->QueryInterface(__uuidof(ID3D11DepthStencilView), (void**)view) == 0)
    return 2;
    if (vw->QueryInterface(__uuidof(ID3D11ShaderResourceView), (void**)view) == 0)
    return 3;
    return 0;
}

extern "C" __declspec(dllexport) IDXGIOutput * __stdcall D3D11GetDeviceOutput(ID3D11Device * dvc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDXGIAdapter * adapter = nullptr;
    IDXGIOutput  * out     = nullptr;
    IDXGIDevice  * DXGIDvc = nullptr;
    if (dvc->QueryInterface(__uuidof(IDXGIDevice), (void**)&DXGIDvc) != 0)
    {
        DBUG_WARN("QueryInterface Failed");
        return 0;
    }
    if (DXGIDvc->GetAdapter(&adapter) != 0)
    {
        DBUG_WARN("GetAdapter Failed");
        DXGIDvc->Release();
        return 0;
    }
    if (adapter->EnumOutputs(0, &out) > 0)
    {
        DBUG_WARN("EnumOutputs Failed");
    }
    DXGIDvc->Release();
    adapter->Release();
    return out;
}

unique_ptr<vector<string>> GetSVPosRegister(char * line)
{
    auto SVPosRegister = new vector<string>();
    string l           = line;
    SVPosRegister->push_back("");
    SVPosRegister->push_back("");
    if (0 != l.find("dcl_input_ps_siv"))
    {
        return unique_ptr<vector<string>>(SVPosRegister);
    }
    auto split = SplitrString(line, ", ");
    if (split.get()->size() < 2 || split.get()->at(1).find("position") == string::npos)
    {
        return unique_ptr<vector<string>>(SVPosRegister);
    }
    split = SplitrString(line, ".");
    if (split.get()->size() < 2)
    {
        return unique_ptr<vector<string>>(SVPosRegister);        
    }
    auto reg_split       = SplitrString((char*)split.get()->at(0).c_str(), " ");
    SVPosRegister->at(0) = reg_split.get()->at(reg_split.get()->size()-1);
    auto swizle_split    = SplitrString((char*)split.get()->at(1).c_str(), ",");
    SVPosRegister->at(1) = swizle_split.get()->at(0);
    return unique_ptr<vector<string>>(SVPosRegister);
}

UINT GetTempCount(char * line)
{   
    string l  = line;
    if (0 != l.find("dcl_temps"))
    {
        return 0;
    }
    auto split = SplitrString(line, " ");
    if (split.get()->size() < 2)
    {
        return 0;        
    }    
    if (string::npos != split.get()->at(1).find_first_not_of("0123456789"), 0)
    {
        return 0;
    }
    return stoi(split.get()->at(1));
}

unique_ptr<string> InsertTextureDecl(string * orig_inst)
{
    string * fixed = new string(orig_inst->c_str());
    if (orig_inst->find("dcl_resource_texture") != 0)
    {
        return unique_ptr<string>(fixed);
    }
    auto split  = SplitrString((char*)orig_inst->c_str(), " t");
    auto index  = split.get()->back();
    if (string::npos != index.find_first_not_of("0123456789"), 0)
    {
        return unique_ptr<string>(fixed);
    } 
    if (stoi(index) > 63)
    {
        return unique_ptr<string>(fixed);
    }
    auto new_treg  = " t" + to_string(stoi(index) + 64);   
    auto new_decl  = *ReplaceAll((char*)fixed->c_str(), (char*)(string(" t") + index).c_str(), (char*)new_treg.c_str()).get();
    *fixed        += "\n" + new_decl;
    return unique_ptr<string>(fixed);
}

unique_ptr<string> FixResinfoIntruction(string * innst)
{
    string * fixed = new string(innst->c_str());   
    if (innst->find("resinfo") != 0) 
    {
        return unique_ptr<string>(fixed);
    }
    auto split = SplitrString((char*)innst->c_str(), ", t");
    if (split.get()->size() < 2) 
    {
        return unique_ptr<string>(fixed);
    }
    auto treg_split = SplitrString((char*)split.get()->at(1).c_str(), ".");
    if (treg_split.get()->size() < 2)
    {
        return unique_ptr<string>(fixed);
    }
    if (string::npos != treg_split.get()->at(0).find_first_not_of("0123456789"), 0)
    {
        return unique_ptr<string>(fixed);
    }
    auto index = stoi(treg_split.get()->at(0));
    if (index > 63)
    {
        return unique_ptr<string>(fixed);
    }
    auto new_treg = " t" + to_string(stoi(treg_split.get()->at(0)) + 64);
    auto old_treg = " t" + to_string(stoi(treg_split.get()->at(0)));
    *fixed        = ReplaceAll((char*)innst->c_str(), (char*)old_treg.c_str(), (char*)new_treg.c_str()).get()->c_str();
    //*fixed        = innst->c_str();
    return unique_ptr<string>(fixed);;
}

unique_ptr<string> FixLoadInstruction(string * orig_inst, UINT temp_index, float f_scale)
{
    string * fixed = new string(orig_inst->c_str());
    *fixed = fixed->erase(0, fixed->find_first_not_of(" ")); 
    //return unique_ptr<string>(fixed);
    if (fixed->find("ld") != 0)    {    
        
        * fixed = orig_inst->c_str();
        return unique_ptr<string>(fixed);
    }
    auto split = SplitrString((char*)orig_inst->c_str(), ", ");
    if (split.get()->size() < 3)
    {        
        * fixed = orig_inst->c_str();
        return unique_ptr<string>(fixed);
    }
    auto coords       = split.get()->at(1);
    auto coords_split = SplitrString((char*)coords.c_str(), ".");
    if (coords_split.get()->size() < 2)
    {   
        * fixed = orig_inst->c_str();     
        return unique_ptr<string>(fixed);
    }
    auto coords_register = coords_split.get()->at(0);
    auto coords_swizle   = coords_split.get()->at(1);
    string scale  = "l(";
    for (int c = 0; c < coords_swizle.size(); c++)
    {
        char swizle_element = coords_swizle.at(c);
        if (swizle_element == 'x' || swizle_element == 'y') scale += to_string(f_scale);                    
        else scale += "1.0";
        if (c == coords_swizle.size() - 1)
        {
            scale += ")";
        }
        else 
        {
            scale += ", ";
        }
    }      
    auto text_split = SplitrString((char*)split.get()->at(2).c_str(), ".");
    if (text_split.get()->size() < 2)
    {
        * fixed = orig_inst->c_str();
        return unique_ptr<string>(fixed);
    }
    string text_index = text_split.get()->at(0).substr(1, text_split.get()->at(0).size() - 1);
    if (string::npos != text_index.find_first_not_of("0123456789"), 0)
    {
        * fixed = orig_inst->c_str();
        return unique_ptr<string>(fixed);
    }

    string temp0  = "r" + to_string(temp_index)   + "." + coords_swizle;
    string temp1 = "r" + to_string(temp_index+1) + "." + coords_swizle;
    string temp2  = "r" + to_string(temp_index+2) + "." + coords_swizle;

    *fixed  = "resinfo r" + to_string(temp_index)   + ".xyzw, l(0), " + "t" + text_index + ".xyzw\n"; 
    *fixed += "resinfo r" + to_string(temp_index+1) + ".xyzw, l(0), " + "t" + to_string(stoi(text_index)+64) + ".xyzw\n"; 
    *fixed += "mov r" + to_string(temp_index)   + ".zw, l(1.0, 1.0)\n";
    *fixed += "mov r" + to_string(temp_index+1) + ".zw, l(1.0, 1.0)\n";
    *fixed += "div r" + to_string(temp_index+2) + ".xyzw, r" + to_string(temp_index) + ".xyzw, r" + to_string(temp_index+1) + ".xyzw\n";

    scale   = "l(" + to_string(f_scale) + ", " + to_string(f_scale) + ", 1., 1.)";
    //*fixed += "mov r" + to_string(temp_index+2) + ".xyzw, " + scale + "\n";

    *fixed += "itof " + temp0 + ", " + coords + "\n";
    *fixed += "mul " + temp1 + ", " + temp0 + ", " + "r" + to_string(temp_index+2) + ".xyzw\n";
    *fixed += "ftoi " + temp0 + ", " + temp1 + "\n";
    *fixed += ReplaceAll((char*)orig_inst->c_str(), (char*)(string(", ") + coords).c_str(), (char*)(string(", ") + temp0).c_str()).get()->c_str();   
    return unique_ptr<string>(fixed);
 }

unique_ptr<vector<string>> __stdcall D3D11FixDXBCShader(char * shader, float f_scale)
{       
    auto fixed           = new vector<string>();
    auto split           = SplitrString((char*)shader, "\n");
    auto sv_pos          = unique_ptr<vector<string>>(new vector<string>());
    string orig          = (char*)shader;
    BOOL hasloadinstruct = string(shader).find("\nld") != string::npos;
    // Handle indentation on loops
    hasloadinstruct      = orig.find("\nld") != string::npos ||  orig.find("\n  ld") != string::npos || orig.find("\n    ld") != string::npos;
    BOOL resinfointruct  = string(shader).find("\nresinfo") != string::npos;
    UINT svpos_temp      = 0;
    UINT load_temp       = 0;
    int i                = 0;
    for (i=0; i<split.get()->size(); i++) 
    {       
        auto element = split.get()->at(i);
        UINT count   = GetTempCount((char*)element.c_str());
        if (count > 0)
        {
            svpos_temp = count;  
            load_temp  = count+1;          
            if (sv_pos.get()->size() == 2)
            {
                if (hasloadinstruct) fixed->push_back(string("dcl_temps ") + to_string(count+4) + " //" + to_string(count) + "+4 temporary registers\n");
                else                 fixed->push_back(string("dcl_temps ") + to_string(count+1) + " //" + to_string(count) + "+1 temporary registers\n");
                string swizle = sv_pos.get()->at(1);
                string scale  = "l(";
                for (int c = 0; c < swizle.size(); c++)
                {
                    char swizle_element = swizle.at(c);
                    if (swizle_element == 'x' || swizle_element == 'y') scale += to_string(1.f/f_scale);                    
                    else                         scale += "1.0";
                    if (c == swizle.size() - 1)
                    {
                        scale += ")";
                    }
                    else 
                    {
                        scale += ", ";
                    }
                }                
                //string inst = "mul r" + to_string(svpos_temp) + "." + swizle + ", " + sv_pos.get()->at(0) + "." + swizle + ", " + scale + "\n";
                string inst = "mov r" + to_string(svpos_temp) + "." + swizle + ", " + sv_pos.get()->at(0) + "." + swizle + "\n";
                scale = "l(" + to_string(1.f/f_scale) + ", " + to_string(1.f/f_scale) + ")";
                inst += "mul r" + to_string(svpos_temp) + ".xy, " + sv_pos.get()->at(0) + ".xy" + ", " + scale + "\n";
                fixed->push_back(inst); 
            }
            else 
            {
                load_temp = count;   
                if (hasloadinstruct) fixed->push_back(string("dcl_temps ") + to_string(count+3) + " //" + to_string(count) + "+4 temporary registers\n");
                else                 fixed->push_back(element + " //" + to_string(count) + " temporary registers\n");
            }
            i++;
            break;
        }
        else
        {
            auto svpos = GetSVPosRegister((char*)element.c_str());
            if (svpos.get()->at(0) != "") 
            {
                string line = element;
                line += " // " + svpos.get()->at(0) + "." + svpos.get()->at(1) + "\n";
                fixed->push_back(line);
                sv_pos.get()->push_back(string(svpos.get()->at(0)));
                sv_pos.get()->push_back(string(svpos.get()->at(1)));
            } else {
                if (hasloadinstruct || resinfointruct)
                {
                    fixed->push_back(*InsertTextureDecl(&element).get() + "\n");
                }
                else fixed->push_back(element + "\n");
            }
        }
    }
    if (sv_pos.get()->size() == 2)
    {
        string replace_me = " "  + sv_pos.get()->at(0) + ".";
        string with_me    = " r" + to_string(svpos_temp) + ".";
        for (i; i<split.get()->size(); i++) 
        {                  
            auto resfixed     = FixResinfoIntruction(&split.get()->at(i));     
            string vpos_fixed = *ReplaceAll((char*)resfixed.get()->c_str(), (char*)replace_me.c_str(), (char*)with_me.c_str()).get();
            auto   load_fixed = FixLoadInstruction(&vpos_fixed, load_temp, f_scale);
            fixed->push_back(*load_fixed.get() + "\n");                 
        }
    } else 
    {    
        for (i; i<split.get()->size(); i++) 
        {           
            auto resfixed = FixResinfoIntruction(&split.get()->at(i));     
            auto new_line = FixLoadInstruction(resfixed.get(), load_temp, f_scale);
            fixed->push_back(*new_line.get() + "\n");
        }
    }
    return unique_ptr<vector<string>>(fixed);  
}

ID3D11PixelShader * D3D11FixAndCompileDXBCShader(BYTE * bytecode, UINT bytecode_size, string * asm_code, float f_scale, ID3D11Device * pDvc)
{    
    vector<AssemblerParseError> parse_errors;
    vector<BYTE> migoto_bytecode(bytecode, bytecode + bytecode_size);
    migoto_bytecode.reserve(bytecode_size);
    auto fixed = D3D11FixDXBCShader((char*)asm_code->c_str(), f_scale);
    string s_fixed;    
    for (auto & element : *fixed.get()) 
    {
       s_fixed += element;
    }   
        
    std::vector<char> migoto_asm(s_fixed.begin(), s_fixed.end());     
    auto newbcode = assembler(&migoto_asm, migoto_bytecode, &parse_errors);    
    if (parse_errors.size() > 0)
    {
        for (auto & error : parse_errors)
        {
            DBUG_WARN(error.what());
        }
        return nullptr;
    }
    
    if (!pDvc) return nullptr;
    ID3D11PixelShader * shader = nullptr;
    if (S_OK != D3D11_Hooks->CreatePixelShader(pDvc, newbcode.data(), newbcode.size(), nullptr, &shader))
    {
        DBUG_WARN("CreatePixelShader FAILED");
        return nullptr;
    }
    return shader;
}

ID3D10PixelShader * D3D10FixAndCompileDXBCShader(BYTE * bytecode, UINT bytecode_size, string * asm_code, float f_scale, ID3D10Device * pDvc)
{
    vector<AssemblerParseError> parse_errors;
    vector<BYTE> migoto_bytecode(bytecode, bytecode + bytecode_size);
    migoto_bytecode.reserve(bytecode_size);
    auto fixed = D3D11FixDXBCShader((char*)asm_code->c_str(), f_scale);
    string s_fixed;    
    for (auto & element : *fixed.get()) 
    {
       s_fixed += element;
    }   
        
    std::vector<char> migoto_asm(s_fixed.begin(), s_fixed.end());     
    auto newbcode = assembler(&migoto_asm, migoto_bytecode, &parse_errors);    
    if (parse_errors.size() > 0)
    {
        for (auto & error : parse_errors)
        {
            DBUG_WARN(error.what());
        }
        return nullptr;
    }

    if (!pDvc) return nullptr;
    ID3D10PixelShader * shader = nullptr;
    if (S_OK != D3D11_Hooks->D3D10CreatePixelShader(pDvc, newbcode.data(), newbcode.size(), &shader))
    {
        DBUG_WARN("CreatePixelShader FAILED");
        return nullptr;
    }
    return shader;
}

extern "C" __declspec(dllexport) char * __stdcall D3D11FixDXBCShaderTest(char * shader, BYTE * bytecode, UINT bytecode_size, float scale)
{   
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    string code = (char*)shader;
    D3D11FixAndCompileDXBCShader(bytecode, bytecode_size, &code, scale, nullptr);

    static string err = "S_OK";    
    auto fixed        = D3D11FixDXBCShader(shader, scale);
    for (auto & element : *fixed.get()) 
    {
       err += element;
    }
    
    return (char*)err.c_str();    
}
