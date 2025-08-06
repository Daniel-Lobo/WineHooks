#include <windows.h>
#include "collections.h"
#include "D3D12Hooks.h"
#include "D3D12Utils.h"
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
#include "GDI_Hooks.h"
extern "C"{
#include "DDSurface.h"
}
#include "Input.h"

extern "C" __declspec(dllexport) 
ID3D10Device * D3D10DvcFromSChain(IDXGISwapChain * s)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDXGIDevice  * DXGIDvc  = NULL;
    ID3D10Device * D3D10Dvc = NULL;
    if (s->GetDevice(__uuidof(IDXGIDevice), (void**)&DXGIDvc) == 0)
    {
        DXGIDvc->Release();
        if (DXGIDvc->QueryInterface(__uuidof(ID3D10Device), (void**)&D3D10Dvc) == 0)
        {
            D3D10Dvc->Release();
            return D3D10Dvc;
        }
    } return 0;
}

LPVOID * D3D10TextureID(ID3D10Texture2D * r)
{
    IUnknown * ID = 0;
    r->QueryInterface(__uuidof(IUnknown), (void **)&ID);
    if (ID) ID->Release();
    return (LPVOID*)ID;
}

LPVOID * D3D10TextureID(ID3D10Resource * r)
{
    ID3D10Texture2D * tx = 0;
    if (r->QueryInterface(__uuidof(ID3D10Texture2D), (void **)&tx))
    return 0;
    tx->Release();
    return D3D10TextureID(tx);
}

LPVOID D3D10GetViewResourceID(ID3D10ShaderResourceView * vw)
{
    ID3D10Resource * r = NULL;
    vw->GetResource(&r);
    if (r)
    {
        r->Release();
        return D3D10TextureID(r);
    }
    return 0;
}

LPVOID D3D10TextureIDFromView(ID3D10View * v)
{
    ID3D10Resource * r = nullptr;
    if (v == nullptr) return v;

    v->GetResource(&r);
    if (r)
    {
        r->Release();
        return D3D10TextureID(r);
    }
    return r;
}

HRESULT __stdcall D3D10DumpTexture(ID3D10Device * d, IUnknown * u, LPCWSTR path, DWORD autodump)
{
    HRESULT                  err = 0;
    D3D10_TEXTURE2D_DESC     dsc;
    DWORD                    fmt;
    ID3D10Texture2D         *t = nullptr, * Sys = nullptr;
    D3D10_MAPPED_TEXTURE2D   map;

    if (u == nullptr)
    {
        err = 11;
        DBUG_WARN("nullptr");
        goto D3D10DumpTexture_CleanUp;
    }
    u->QueryInterface(__uuidof(ID3D10Texture2D), (void **)&t);
    if (!t)
    {
        err = 1;
        DBUG_WARN("INTERFACE IS NOT A ID3D10Texture2D");
        goto D3D10DumpTexture_CleanUp;
    }

    t->GetDesc(&dsc);
    if (dsc.Usage == D3D10_USAGE_STAGING)
    {
        if (!autodump)
        {
            err = 2;
            DBUG_WARN("SYSTEM MEMORY TEXTURE");
            goto D3D10DumpTexture_CleanUp;
        }
    }

    dsc.Usage          = D3D10_USAGE_STAGING;
    dsc.BindFlags      = 0;
    dsc.CPUAccessFlags = D3D10_CPU_ACCESS_READ;
    if (D3D11_Hooks->D3D10CreateTexture2D(d, &dsc, 0, &Sys))
    {
        err = 3;
        DBUG_WARN("CreateTexture2D FAILED");
        goto D3D10DumpTexture_CleanUp;
    }
    d->CopySubresourceRegion(Sys, 0, 0, 0, 0, t, 0, 0);
    fmt = GetDXGISurfacePxFormat(dsc.Format);
    if (fmt == *(DWORD*) "?????")
    {
        err = 4;
        DBUG_WARN((string("UNSUPPORTED FORMAT =( ")+to_string(dsc.Format)).c_str());
        goto D3D10DumpTexture_CleanUp;
    }

    if (D3D11_Hooks->D3D10Map(Sys, 0, D3D10_MAP_READ, 0, &map))
    {
        err = 5;
        DBUG_WARN("ID3D10Texture2D::Map FAILED");
        goto D3D10DumpTexture_CleanUp;
    }
    DumpDDS((wchar_t*)path, (char*)&fmt, dsc.Width, dsc.Height, map.pData, map.RowPitch);
    D3D11_Hooks->D3D10Unmap(Sys, 0);

    D3D10DumpTexture_CleanUp:
    if (Sys) D3D11_Hooks->D3D10ReleaseTexture2D(Sys);
    if (t) D3D11_Hooks->D3D10ReleaseTexture2D(t);
    return err;
}

extern "C" __declspec(dllexport) void D3D10CreateShaders(IDXGISwapChain * sc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD          err = 0;
    ID3D10Device * dvc = D3D10DvcFromSChain(sc);
    if (dvc == nullptr)
    {
        DBUG_WARN("D3D10DvcFromSwain() FAILED");
        return;
    }
    if (D3D11Globals.m_D3D10CheckBoardPattern)
    {
        D3D11Globals.m_D3D10CheckBoardPattern->Release();
        D3D11Globals.m_D3D10CheckBoardPattern = nullptr;
    }
    if (D3D11Globals.m_D3D10VxBlt)
    {
        D3D11Globals.m_D3D10VxBlt->Release();
        D3D11Globals.m_D3D10VxBlt = nullptr;
    }
    if (D3D11Globals.m_D3D10PxBlt)
    {
        D3D11_Hooks->D3D10PxShaderRelease(D3D11Globals.m_D3D10PxBlt);
        D3D11Globals.m_D3D10PxBlt = nullptr;
    }
    if (D3D11Globals.m_D3D10VMirrorPxBlt)
    {
        D3D11_Hooks->D3D10PxShaderRelease(D3D11Globals.m_D3D10VMirrorPxBlt);
        D3D11Globals.m_D3D10VMirrorPxBlt = nullptr;
    }
    if (D3D11Globals.m_SSAA)
    {
        D3D11Globals.m_SSAA->Release();
        D3D11Globals.m_SSAA = nullptr;
    }
    if (D3D11Globals.m_SSAAHQ)
    {
        D3D11Globals.m_SSAAHQ->Release();
        D3D11Globals.m_SSAAHQ = nullptr;
    }
    if (dvc->CreateVertexShader(g_d3d.m_VSBlt->GetBufferPointer(), g_d3d.m_VSBlt->GetBufferSize(), &D3D11Globals.m_D3D10VxBlt))
    {
        DBUG_WARN("CreateVertexShader(m_D3D10VxBlt) FAILED");
        err += 1;
    }
    if (D3D11_Hooks->D3D10CreatePixelShader(dvc, g_d3d.m_PSBlt->GetBufferPointer(), g_d3d.m_PSBlt->GetBufferSize(),
                                            &D3D11Globals.m_D3D10PxBlt))
    {
        DBUG_WARN("CreatePixelShader(m_D3D10PxBlt) FAILED");
        err += 1;
    }
    if (D3D11_Hooks->D3D10CreatePixelShader(dvc, g_d3d.m_PSVMirrorBlt->GetBufferPointer(), g_d3d.m_PSVMirrorBlt->GetBufferSize(),
                                            &D3D11Globals.m_D3D10VMirrorPxBlt))
    {
        DBUG_WARN("CreatePixelShader(m_D3D10VMirrorPxBlt) FAILED");
        err += 1;
    }
    if (D3D11_Hooks->D3D10CreatePixelShader(dvc, g_d3d.m_PS_SSAA->GetBufferPointer(), g_d3d.m_PS_SSAA->GetBufferSize(), &D3D11Globals.m_SSAA))
    {
        DBUG_WARN("CreatePixelShader(m_SSAA) FAILED");
        err += 1;
    }
    if (D3D11_Hooks->D3D10CreatePixelShader(dvc, g_d3d.m_PS_SSAAHQ->GetBufferPointer(), g_d3d.m_PS_SSAAHQ->GetBufferSize(), &D3D11Globals.m_SSAAHQ))
    {
        DBUG_WARN("CreatePixelShader(m_SSAAHQ) FAILED");
        err += 1;
    }
    ID3D10ShaderResourceView * vw = D3D10CreateTexture2D(dvc, 256, 256, (DXGI_FORMAT)0);
    ID3D10Resource           * rs = D3D10GetResource(vw);
    if (rs == 0)
    {
        DBUG_WARN("D3D10GetResource() FAILED");
        err += 1;
    }
    else
    {
        D3D11_Hooks->D3D10UpdateSubresource(dvc, rs, 0, nullptr, CheckerBoard().m_pattern, sizeof(UINT)*256, 0);
        D3D11Globals.m_D3D10CheckBoardPattern = vw;
    }
    if (err == 0) DBUG_LOG("OK =)")
}

ID3D10Resource * D3D10GetResource(ID3D10View * v)
{
    ID3D10Resource * r = nullptr;
    if (v == nullptr)   return r;

    v->GetResource(&r);
    if (r)r->Release();

    return r;
}

extern "C" __declspec(dllexport) ID3D10Texture2D * D3D10GetTexture2D(ID3D10View * v)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    ID3D10Resource * r   = D3D10GetResource(v);
    if (r == nullptr)           return nullptr;
    ID3D10Texture2D * tx = (ID3D10Texture2D *)
                            EZInterface(__uuidof(ID3D10Texture2D), r).I();
    if (tx)
    {
        tx->AddRef();
        return tx;
    }
    return nullptr;
}

ID3D11ProxyTexture * D3D10GetProxy(ID3D10DeviceChild * r)
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

ID3D10Device * D3D10GetDevice(ID3D10DeviceChild * Child)
{
    ID3D10Device * dvc      = nullptr;
    if (Child == nullptr)  return dvc;

    Child->GetDevice(&dvc);
    if (dvc)dvc->Release();

    return dvc;
}

ID3D11ProxyTexture * D3D10GetProxy(ID3D10DeviceChild * r, const char * caller)
{
    std::string err(caller);
    ID3D10Texture2D    * proxy_tx = nullptr;
    ID3D11ProxyTexture * proxy    = D3D10GetProxy(r);
    if (!proxy)
    {
        D3D11TexUnWrapp proxy_res(r, TRUE);
        if (proxy_res.Type10() != D3D10_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN((err + " NOT A 2D TEXTURE").c_str());
            return nullptr;
        }
        D3D10_TEXTURE2D_DESC * D = proxy_res.Desc10();        
        if (g_d3d.HDPROXIES)
        {
            float scale = g_d3d.mScl->Get() * g_d3d.SSAA;
            D->Width  *= scale;
            D->Height *= scale;           
        }
        if (D3D11_Hooks->D3D10CreateTexture2D(D3D10GetDevice(r), D, nullptr, &proxy_tx) )
        {
            DBUG_WARN((err + " FAILED TO CREATE PROXY 2D TEXTURE").c_str());
            return nullptr;
        }
        DBUG_LOG((err + " CREATED PROXY").c_str());
        proxy = new ID3D11ProxyTexture(proxy_tx);
        r->SetPrivateDataInterface((GUID &)g_.D3D11ProxyTexture, (IUnknown*)proxy);
    }
    return proxy;
}

ID3D10Resource * D3D10ShrinkTexture2D(ID3D10Resource * big)
{
    D3D10_RESOURCE_DIMENSION type = D3D10_RESOURCE_DIMENSION_UNKNOWN;   
    big->GetType(&type);
    if (type != D3D10_RESOURCE_DIMENSION_TEXTURE2D)
    {
        DBUG_WARN("NOT A 2D TEXTURE");
        return nullptr;
    }
    float scale = g_d3d.mScl->Get() * g_d3d.SSAA;
    ID3D10Texture2D * Big         = dynamic_cast<ID3D10Texture2D*>(big);
    ID3D10Texture2D * Small       = nullptr;
    D3D10_TEXTURE2D_DESC desc     = {};
    D3D10_TEXTURE2D_DESC new_desc = {};
    Big->GetDesc(&desc);
    Big->GetDesc(&new_desc);
    new_desc.Width         /= scale;
    new_desc.Height        /= scale;
    new_desc.CPUAccessFlags = D3D10_CPU_ACCESS_WRITE;
    new_desc.MipLevels      = 1;    
    if (D3D11_Hooks->D3D10CreateTexture2D(D3D10GetDevice(big), &new_desc, nullptr, &Small) != S_OK)
    {
        DBUG_WARN("FAILED TO CREATE 2D TEXTURE");
        return nullptr;
    }
    D3D10_MAPPED_TEXTURE2D b_mapped = {};
    D3D10_MAPPED_TEXTURE2D s_mapped = {};
    if (D3D11_Hooks->D3D10Map(Big, 0, D3D10_MAP_READ, 0, &b_mapped) != S_OK)
    {
        DBUG_WARN("FAILED TO MAP HD TEXTURE");
        Small->Release();
        return nullptr;
    }
    if (D3D11_Hooks->D3D10Map(Small, 0, D3D10_MAP_WRITE, 0, &s_mapped) != S_OK)
    {
        DBUG_WARN("FAILED TO MAP SD TEXTURE");
        D3D11_Hooks->D3D10Unmap(Big, 0);
        Small->Release();
        return nullptr;
    }    
    byte * b = (byte*)b_mapped.pData;  // assuming 32bits per pixel
    byte * s = (byte*)s_mapped.pData;  // assuming 32bits per pixel
    float Y  = 0.0f;
    float X  = 0.0f;
    for (int y = 0; y < new_desc.Height; y++)
    {   
        Y  = y * scale;  
        s  = (byte*) s_mapped.pData;
        s +=  y * s_mapped.RowPitch;
        for (int x = 0; x < new_desc.Width; x++)
        {           
            X  = x * scale;            
            b  = (byte*)b_mapped.pData;
            b += (int)X* sizeof(DWORD32)  + (int)Y * b_mapped.RowPitch;
            *(DWORD*)s = *(DWORD*)b;
            s += sizeof(DWORD32);            
        }
    }
    D3D11_Hooks->D3D10Unmap(Small, 0);
    D3D11_Hooks->D3D10Unmap(Big, 0);       
    return Small; // Caller must release small
}

void D3D10Blit(IDXGISwapChain * sc, ID3D10Resource * src, ID3D10PixelShader * px, ID3D10RenderTargetView * dst, RECT * r_dst, RECT* r_src)
{
    D3D10Bliter(D3D10GetDevice(src), sc).Blt(px, D3D11Globals.m_D3D10VxBlt, src, dst, r_dst, r_src);
}

void D3D10Blit(IDXGISwapChain * sc, ID3D10ShaderResourceView * src, ID3D10RenderTargetView * dst, RECT * r_dst, RECT* r_src)
{   
    D3D10Bliter(D3D10GetDevice(src), sc).Blt(D3D11Globals.m_D3D10PxBlt, D3D11Globals.m_D3D10VxBlt, src, dst, r_dst, r_src);
}

void D3D10VMirrorBlit(IDXGISwapChain * sc, ID3D10ShaderResourceView * src, ID3D10RenderTargetView * dst, RECT * r_dst, RECT* r_src)
{
    D3D10Bliter(D3D10GetDevice(src), sc).Blt(D3D11Globals.m_D3D10VMirrorPxBlt, D3D11Globals.m_D3D10VxBlt, src, dst, r_dst, r_src);
}

void D3D10RenderText(IDXGISwapChain * sc, const wchar_t * text, RECT * r)
{
    DWORD   Width                 = r->right-r->left;
    DWORD  Height                 = r->bottom-r->top;
    UINT * p_data                 = new UINT[Width*Height];
    ID3D10Device * dvc   = D3D10DvcFromSChain(sc);
    if (dvc == nullptr)
    {
        DBUG_WARN("D3D10DvcFromSwain FAILED");
        delete [] p_data;
        return;
    }
    GDIText gdi(r, p_data, text, __FUNCTION__);
    ID3D10ShaderResourceView * vw = D3D10CreateTexture2D(dvc, Width, gdi.m_height, (DXGI_FORMAT)0);
    ID3D10Resource * rs           = D3D10GetResource(vw);
    if (rs == nullptr)
    {
        DBUG_WARN("D3D10GetResource FAILED");
        delete [] p_data;
        return;
    }
    /* D3D11_Hooks->D3D1UpdateSubresource Fails. why ? CAUTION on autodump implementation */
    dvc->UpdateSubresource(rs, 0, nullptr, p_data+((Height-gdi.m_height)*Width), Width*sizeof(UINT), 0);
    D3D10VMirrorBlit(sc, vw, nullptr, (RECT*)gdi.AlignTop(), nullptr);
    vw->Release();
    delete [] p_data;
}

extern "C" __declspec(dllexport) ID3D10Texture2D * D3D10CreateSysTexture(ID3D10Device * d, UINT w, UINT h)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    ID3D10Texture2D          * tx = NULL;
    D3D10_TEXTURE2D_DESC            desc;

    desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    desc.Width              = w;
    desc.Height             = h;
    desc.MipLevels          = 1;
    desc.ArraySize          = 1;
    desc.SampleDesc.Count   = 1;
    desc.SampleDesc.Quality = 0;
    desc.Usage              = D3D10_USAGE_STAGING;
    desc.BindFlags          = 0;
    desc.CPUAccessFlags     = D3D10_CPU_ACCESS_WRITE|D3D10_CPU_ACCESS_WRITE;
    desc.MiscFlags          = 0;

    D3D11_Hooks->D3D10CreateTexture2D(d, &desc, NULL, &tx);
    return tx;
}

extern "C" __declspec(dllexport) ID3D10ShaderResourceView * D3D10CreateTexture2D(ID3D10Device * d, DWORD w, DWORD h, DXGI_FORMAT fmt)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D10_TEXTURE2D_DESC                  desc;
    D3D10_SHADER_RESOURCE_VIEW_DESC       view;
    HRESULT                                 hr;
    ID3D10Texture2D            * Tex = nullptr;
    ID3D10ShaderResourceView  * View = nullptr;

    if (!fmt)
    fmt                     = DXGI_FORMAT_R8G8B8A8_UNORM;
    desc.Format             = fmt;
    desc.Width              = w;
    desc.Height             = h;
    desc.MipLevels          = 1;
    desc.ArraySize          = 1;
    desc.SampleDesc.Count   = 1;
    desc.SampleDesc.Quality = 0;
    desc.Usage              = D3D10_USAGE_DEFAULT;
    desc.BindFlags          = D3D10_BIND_SHADER_RESOURCE;
    desc.CPUAccessFlags     = 0;
    desc.MiscFlags          = 0;

    hr = D3D11_Hooks->D3D10CreateTexture2D(d, &desc, nullptr, &Tex);
    if ( hr )
    {
        DBUG_WARN("CreateTexture2D FAILED");
        return 0;
    }

    view.Format                    = desc.Format;
    view.ViewDimension             = D3D11_SRV_DIMENSION_TEXTURE2D;
    view.Texture2D.MostDetailedMip = 0;
    view.Texture2D.MipLevels       = 1;

    hr = D3D11_Hooks->D3D10CreateShaderResourceView(d, Tex, &view, &View);
    if ( hr )
    {
        DBUG_WARN("CreateShaderResourceView FAILED");
        return 0;
    }
    Tex->Release();
    return View;
}

extern "C" __declspec(dllexport) ID3D10Texture2D * D3D10LoadTexture(ID3D10Device * d, char * file)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    char                           fmt[20];
    HANDLE                           hFile;
    DWORD                      magic, read;
    BOOL                                 b;
    DDS_HEADER                  DDS_Header;
    D3D10_TEXTURE2D_DESC              desc;   
    HRESULT                              r;
    DWORD               bypp, w, h, lvls=1;    
    ID3D10Texture2D       * Tex  = nullptr;

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
            return 0;
        }
    }

    b = ReadFile(hFile, &magic, 4, &read, NULL);
    if ( (!b) || (magic != 0x20534444) )
    {
        CloseHandle(hFile);
        DBUG_WARN("FILE IS NOT A DDS SURFACE");
        return 0;
    }

    b = ReadFile(hFile, &DDS_Header, sizeof(DDS_HEADER), &read, NULL);
    if (DDS_Header.dwWidth == NULL)
    {
        DBUG_WARN("INVALID DDS SURFACE SIZE");
        return 0;
    }

    GetDDSFileFormat(&DDS_Header, fmt);
    DBUG_LOG(fmt);
    if (SetDXGISurfacePxFormat(&desc.Format, *(DWORD*)fmt) == 0)
    {
        CloseHandle(hFile);
        DBUG_WARN("UNSUPORTED FORMAT");
        return 0;
    }

    if (DDS_Header.dwFlags & 0x20000) lvls = DDS_Header.dwMipMapCount;
    else                              lvls = 1;

    w = DDS_Header.dwWidth;
    if ( *(BYTE*)fmt == *(BYTE*)"D" )
    {
        bypp = *(DWORD*)fmt == *(DWORD*)"DXT1" ? 2 : 4;
        h    = (DDS_Header.dwHeight + 3) / 4;
    } else {
        bypp = DDS_Header.ddspf.dwRGBBitCount/8;
        h    = DDS_Header.dwHeight;
    }

    desc.Width              = DDS_Header.dwWidth;
    desc.Height             = DDS_Header.dwHeight;
    desc.MipLevels          = lvls;
    desc.ArraySize          = 1;
    desc.SampleDesc.Count   = 1;
    desc.SampleDesc.Quality = 0;
    desc.Usage              = D3D10_USAGE_DEFAULT;
    desc.BindFlags          = D3D10_BIND_SHADER_RESOURCE;
    desc.CPUAccessFlags     = 0;
    desc.MiscFlags          = 0;

    r = D3D11_Hooks->D3D10CreateTexture2D(d, &desc, nullptr, &Tex);
    if (r)
    {
        DBUG_WARN("CreateTexture2D FAILED");
        return 0;
    }

    desc.Usage               = D3D10_USAGE_STAGING;
    desc.BindFlags           = 0;
    desc.CPUAccessFlags      = D3D10_CPU_ACCESS_WRITE;
    ID3D10Texture2D  *SysMem = nullptr;

    r = D3D11_Hooks->D3D10CreateTexture2D(d, &desc, nullptr, &SysMem);
    if (r)
    {
        DBUG_WARN("CreateTexture2D FAILED FOR SYSMEM TEXTURE");
        return 0;
    }

    D3D10_MAPPED_TEXTURE2D m;
    for (UINT i=0; i<lvls; i++)
    {
        D3D11_Hooks->D3D10Map(SysMem, i, D3D10_MAP_WRITE, 0, &m);
        LoadData2Surface(m.pData, hFile, m.RowPitch, w, h, bypp);
        w /= 2;
        h /= 2;
        D3D11_Hooks->D3D10Unmap(SysMem, i);
    }
    CloseHandle(hFile);

    D3D11_Hooks->D3D10CopyResource(D3D10GetDevice(SysMem), Tex, SysMem);
    SysMem->Release();
    return Tex;
}

extern "C" __declspec(dllexport) ID3D10Device * D3D10DeviceFromChain(IDXGISwapChain * Sc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)

    IDXGIDevice * DXGIDvc = nullptr;
    if ( Sc->GetDevice(__uuidof(IDXGIDevice), (void**)&DXGIDvc) )
    {
        DBUG_LOG("FAILED TO GET THE DXGI DEVICE");
        return 0;
    }
    DXGIDvc->Release();

    ID3D10Device * Dvc = nullptr;
    if ( DXGIDvc->QueryInterface(__uuidof(ID3D10Device), (void**)&Dvc) )
    {
        DBUG_LOG("FAILED TO GET THE D3D10 DEVICE");
        return 0;
    }
    Dvc->Release();
    return Dvc;
}

D3D10Texture2DView::D3D10Texture2DView(ID3D10Resource * rr)
{
    D3D11TexUnWrapp tex((IUnknown*) rr, TRUE);
    if ( tex.Type10() != D3D10_RESOURCE_DIMENSION_TEXTURE2D)
    {
        DBUG_WARN("NOT A 2D TEXTURE");
    }

    D3D10_SHADER_RESOURCE_VIEW_DESC                rsc_desc;
    rsc_desc.Format                    = tex.Desc10()->Format;
    rsc_desc.ViewDimension             = D3D10_SRV_DIMENSION_TEXTURE2D;
    rsc_desc.Texture2D.MostDetailedMip = 0;
    rsc_desc.Texture2D.MipLevels       = 1;
    if (D3D11_Hooks->D3D10CreateShaderResourceView(D3D10GetDevice(tex.m_tx2d10), tex.m_tx2d10, &rsc_desc, &m_VW))
    DBUG_WARN("CreateShaderResourceView FAILED");
}

D3D10Bliter::D3D10Bliter(IUnknown * i, IDXGISwapChain * sc)
{
    m_sc  = sc;
    m_Dvc = GetD3D10Device(i);
    m_sc->AddRef();
    m_Dvc->AddRef();
    m_Dvc->OMGetBlendState(&m_bld, m_blndfactor, &m_Blndmask);
    m_Dvc->PSGetSamplers(0, 1, &m_smplr);    
    m_Dvc->PSGetShaderResources(0, 1, &m_srv);
    D3D11_Hooks->D3D10OMGetRenderTargets(m_Dvc, 8, m_rtv, &m_dsv);

    m_Dvc->VSGetConstantBuffers(0, 1, &m_CB0);
    m_Dvc->IAGetInputLayout(&m_il);
    m_Dvc->IAGetPrimitiveTopology(&m_pt);
    m_Dvc->VSGetShader(&m_vx);
    m_Dvc->PSGetShader(&m_px);

    UINT n = 8;
    D3D11_Hooks->D3D10RSGetViewports(m_Dvc, &n, m_vws);
    D3D11_Hooks->D3D10RSGetScissorRects(m_Dvc, &n, m_scr);

    D3D10_BUFFER_DESC dsc;
    ZeroMemory(&dsc, sizeof(D3D10_BUFFER_DESC));
    dsc.ByteWidth            = sizeof(float)*8;
    dsc.Usage                = D3D10_USAGE_DEFAULT;
    dsc.BindFlags            = D3D10_BIND_CONSTANT_BUFFER;
    if (m_Dvc->CreateBuffer(&dsc, NULL, &m_prms))
    DBUG_WARN("CreateBuffer FAILED");
}

void D3D10Bliter::SetStates()
{
    ID3D10SamplerState      * ss = nullptr;
    D3D10_SAMPLER_DESC     sdesc =      {};

    if (!m_bld)
    {
        DBUG_LOG("NO BLEND STATE");
    } else  {
       float blendfactor[4] = {1., 1., 1., 1.};
       m_Dvc->OMSetBlendState(nullptr, blendfactor, 0xffffffff);
    }

    sdesc.Filter         = D3D10_FILTER_MIN_MAG_MIP_POINT;
    sdesc.AddressU       = D3D10_TEXTURE_ADDRESS_WRAP;
    sdesc.AddressV       = D3D10_TEXTURE_ADDRESS_WRAP;
    sdesc.AddressW       = D3D10_TEXTURE_ADDRESS_WRAP;
    sdesc.MipLODBias     = 0.0;
    sdesc.MinLOD         = 0.0;
    sdesc.MaxLOD         = D3D10_FLOAT32_MAX;
    sdesc.MaxAnisotropy  = 16;
    sdesc.ComparisonFunc = D3D10_COMPARISON_NEVER;
    ZeroMemory(&sdesc.BorderColor, sizeof(float)*4);

    if (m_Dvc->CreateSamplerState(&sdesc, &ss))
    {
        DBUG_WARN("CreateSamplerState FAILED");
    }
    else
    {
        m_Dvc->PSSetSamplers(0, 1, &ss);
        ss->Release();
    }
}

ID3D10RenderTargetView * D3D10Bliter::GetRTV()
{
    ID3D10Texture2D        * bb   = 0;
    ID3D10RenderTargetView * bbvw = 0;
    D3D10_RENDER_TARGET_VIEW_DESC vw_desc;
    D3D10_TEXTURE2D_DESC  bb_desc;

    D3D11_Hooks->GetBuffer(m_sc, 0, __uuidof( ID3D10Texture2D ), ( LPVOID* )&bb );
    if( bb )
    {
        bb->GetDesc(&bb_desc);
        vw_desc.Format             = bb_desc.Format;
        vw_desc.ViewDimension      = D3D10_RTV_DIMENSION_TEXTURE2D;
        vw_desc.Texture2D.MipSlice = 0;
        m_Dvc->CreateRenderTargetView(bb, &vw_desc, &bbvw);
        bb->Release();
        return bbvw;
    }
    return 0;
}

void D3D10Bliter::UpdateRects(RECT * dst, RECT *, ID3D10RenderTargetView * vw)
{
    float                    d[8];
    D3D10_TEXTURE2D_DESC     desc;
    D3D10_RESOURCE_DIMENSION type = (D3D10_RESOURCE_DIMENSION)NULL;
    ID3D10Texture2D  * vw_rsrc = nullptr;

    vw->GetResource((ID3D10Resource**)&vw_rsrc);
    if (vw_rsrc == nullptr)
    {
        DBUG_WARN("ID3D11RenderTargetView::GetResource FAILED");
        return;
    }

    vw_rsrc->GetType(&type);
    if (type != D3D10_RESOURCE_DIMENSION_TEXTURE2D)
    {
        DBUG_WARN("ID3D10Resource IS NOT A ID3D10texture2D");
        return ;
    }

    vw_rsrc->GetDesc(&desc);
    vw_rsrc->Release();
    float w = desc.Width /2.f;
    float y = desc.Height/2.f;
    d[0] = (dst->left   /w)-1;
    d[1] = (dst->top    /y)-1;
    d[2] = (dst->right  /w)-1;
    d[3] = (dst->bottom /y)-1;

    RECT scissor;
    scissor.top    = 0;
    scissor.left   = 0;
    scissor.bottom = desc.Height;
    scissor.right  = desc.Width;

    D3D10_VIEWPORT view;
    view.Width    = desc.Width;
    view.Height   = desc.Height;
    view.TopLeftX = 0;
    view.TopLeftY = 0;
    view.MaxDepth = 1;
    view.MinDepth = 0;

    D3D11_Hooks->D3D10RSSetViewports(m_Dvc, 1, &view);
    D3D11_Hooks->D3D10RSSetScissorRects(m_Dvc, 1, &scissor);
    m_Dvc->UpdateSubresource(m_prms, 0, nullptr, d, 0, 0);
}

HRESULT D3D10Bliter::Blt(ID3D10PixelShader*px, ID3D10VertexShader*vx,
                         ID3D10ShaderResourceView*tx, ID3D10RenderTargetView*vw,
                         RECT * dst, RECT* src)
{
    if (vw == NULL)  vw = GetRTV();
    if (vw == NULL)
    {
        DBUG_WARN("NO BACKBUFFER");
        return 1;
    }

    UpdateRects(dst, src, vw);
    SetStates();

    D3D11_Hooks->D3D10OMSetRenderTargets(m_Dvc, 1, &vw, NULL);
    m_Dvc->VSSetConstantBuffers(0, 1, &m_prms);
    D3D10PSSetShaderResourcesRef(m_Dvc, 0, 1, &tx);
    m_Dvc->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
    m_Dvc->IASetInputLayout(NULL);
    m_Dvc->PSSetShader(px);
    m_Dvc->VSSetShader(vx);
    m_Dvc->GSSetShader(0);
    //m_Dvc->Draw(6, 0);
    D3D11Globals.m_D3D10Draw(m_Dvc, 6, 0);
    if (vw) vw->Release();
    return 0;
}

HRESULT D3D10Bliter::Blt(ID3D10PixelShader*px, ID3D10VertexShader*vx,
                         ID3D10Resource*rs, ID3D10RenderTargetView*vw,
                         RECT * dst, RECT* src)
{
    ID3D10Texture2D          * tx = nullptr;
    ID3D10ShaderResourceView * tw = nullptr;
    if (rs->QueryInterface(__uuidof(ID3D10Texture2D), (void**)&tx))
    {
        DBUG_WARN("NOT A 2D TEXTURE");
        return 0;
    }

    D3D10_SHADER_RESOURCE_VIEW_DESC vw_desc;
    D3D10_TEXTURE2D_DESC            tx_desc;
    tx->GetDesc(&tx_desc);

    vw_desc.Format                    = tx_desc.Format;
    vw_desc.ViewDimension             = D3D10_SRV_DIMENSION_TEXTURE2D;
    vw_desc.Texture2D.MipLevels       = tx_desc.MipLevels;
    vw_desc.Texture2D.MostDetailedMip = 0;

    if (m_Dvc->CreateShaderResourceView(tx, &vw_desc, &tw))
    {
        DBUG_WARN("CreateShaderResourceView FAILED");
        return 0;
    }
    Blt(px, vx, tw, vw, dst, src);
    tw->Release();
    tx->Release();
    return 0;
}

D3D10Bliter::~D3D10Bliter()
{
    if (m_Dvc)
    {
        D3D11_Hooks->D3D10PSSetShaderResources(m_Dvc, 0, 1, &m_srv);
        if (m_srv) m_srv->Release();

        D3D11_Hooks->D3D10OMSetRenderTargets(m_Dvc, 8, m_rtv, m_dsv);
        if (m_dsv)
        {
            m_dsv->Release();
            m_dsv = nullptr;
        }
        for (UINT i=0; i<8; i++)
        {
            if (m_rtv[i])
            {
                m_rtv[i]->Release();
                m_rtv[i] = nullptr;
            }
        }

        m_Dvc->VSSetConstantBuffers(0, 1, &m_CB0);
        m_Dvc->IASetPrimitiveTopology(m_pt);
        m_Dvc->IASetInputLayout(m_il);
        m_Dvc->PSSetShader(m_px);
        m_Dvc->VSSetShader(m_vx);

        if (m_il)   m_il->Release();
        if (m_px)   m_px->Release();
        if (m_vx)   m_vx->Release();
        if (m_CB0)  m_CB0->Release();

        D3D11_Hooks->D3D10RSSetViewports(m_Dvc, 8, m_vws);
        D3D11_Hooks->D3D10RSSetScissorRects(m_Dvc, 8, m_scr);

        if(m_smplr)
        {
           m_Dvc->PSSetSamplers(0, 1, &m_smplr);
           m_smplr->Release();
        }

        if(m_bld)
        {
           m_Dvc->OMSetBlendState(m_bld, m_blndfactor, m_Blndmask);
           m_bld->Release();
        }

        if (m_dsv) m_dsv->Release();
        m_Dvc->Release();
    }
    if (m_sc)  m_sc->Release();
}

unique_ptr<DXGI_SWAP_CHAIN_DESC> D3D10GetSwapChainDsc(IDXGISwapChain * s)
{
    auto d = unique_ptr<DXGI_SWAP_CHAIN_DESC>(new DXGI_SWAP_CHAIN_DESC());
    D3D11_Hooks->IDXGISChainGetDesc(s, d.get());
    DBUG_LOG((to_string(d.get()->BufferDesc.Width) + "x" + to_string(d.get()->BufferDesc.Height)).c_str());
    return d;
}


unique_ptr<DXGI_SWAP_CHAIN_DESC> D3D10SetUPSwapChain(DXGI_SWAP_CHAIN_DESC * desc, const char * c) {
    auto d = unique_ptr<DXGI_SWAP_CHAIN_DESC>(new DXGI_SWAP_CHAIN_DESC());
    if (nullptr == desc) memcpy(d.get(), desc, sizeof(DXGI_SWAP_CHAIN_DESC));

    if (g_d3d.UPSCALE && nullptr != desc)
    {
       BOOL pos_set = SetWindowPos((HWND)desc->OutputWindow, 0, 0, 0, D3D11_Hooks->HD_W, D3D11_Hooks->HD_H, 0x0454);
       DBUG_LOG((string(c) + " SetWindowPos: " + to_string(pos_set) + " HWIN: " + to_string((UINT64)desc->OutputWindow)).c_str());

       D3D12Config("HWND", (void*)desc->OutputWindow);      
       desc                    = d.get();
       desc->BufferDesc.Width  = D3D11_Hooks->HD_W;
	   desc->BufferDesc.Height = D3D11_Hooks->HD_H;	
    }
    return d;
}

string D3D10BrowseResource(IDXGISwapChain * sc, UINT vsync, UINT flags)
{    
    if (g_d3d.TEXTURE_SWAP_ENABLED)
    {
        if (GetEvent(g_d3d.TEXTURE_SWAP_TOGGLE_SEARCH)) D3D11Globals.m_Search = D3D11Globals.m_Search == *(DWORD*) "TEXTURES"  ? *(DWORD*) "NONE" : *(DWORD*) "TEXTURES";
        if (GetEvent(g_d3d.PIXEL_SHADER_SWAP_TOGGLE))   D3D11Globals.m_Search = D3D11Globals.m_Search == *(DWORD*) "PXSHADERS" ? *(DWORD*) "NONE" : *(DWORD*) "PXSHADERS";
    }

    D3D11_Hooks->current_view    = nullptr; 
    D3D11_Hooks->CurrentPxShader = nullptr;

    if (D3D11Globals.m_Search == *(DWORD*) "TEXTURES") 
    {
        if (GetKeyState(g_d3d.TEXTURE_SWAP_QUICK) & 0x8000)
        {
            if      (GetKeyState(g_d3d.TEXTURE_SWAP_NEXT) & 0x8000) D3D11Globals.m_TextIndex += 1;            
            else if (GetKeyState(g_d3d.TEXTURE_SWAP_PREV) & 0x8000) D3D11Globals.m_TextIndex -= 1;            
        } else {
            if      (GetEvent(g_d3d.TEXTURE_SWAP_NEXT)) D3D11Globals.m_TextIndex += 1;           
            else if (GetEvent(g_d3d.TEXTURE_SWAP_PREV)) D3D11Globals.m_TextIndex -= 1;           
        }

        if      (D3D11Globals.m_TextIndex < 0)                               D3D11Globals.m_TextIndex = 0;
        else if (D3D11Globals.m_TextIndex >= D3D11_Hooks->textures->Count()) D3D11Globals.m_TextIndex = D3D11_Hooks->textures->Count() - 1;

        D3D11_Hooks->current_view10 = (ID3D10Texture2D*) D3D11_Hooks->textures->KeyAt(D3D11Globals.m_TextIndex);  
        DWORD index  = 0;
        wstring file = g_.m_BaseTexturePath + L"\\dump0.dds";
        if (GetEvent(g_d3d.TEXTURE_SWAP_DUMP))
        {
            while (INVALID_FILE_ATTRIBUTES == GetFileAttributesW(file.c_str()) && GetLastError() == ERROR_FILE_NOT_FOUND)
            {
                index += 1;
                file  = g_.m_BaseTexturePath + L"dump" + std::to_wstring(index) + L".dds";
            }              
            D3D10DumpTexture(D3D10DvcFromSChain(sc), (IUnknown *)D3D11_Hooks->current_view10, file.c_str(), 0);         
        }          
        return string("TEXTURES");    
    }
    return string("NONE");
}