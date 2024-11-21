#include <windows.h>
#include <intrin.h>
#include <d3d9.h>
#include "dllmain.h"
#include "string.h"
#include "D3D9Hooks.h"
#include "collections.h"
#include "Sync.h"
#include "Dbug.h"
//#include "D3D_DDI.h"
#include <directxmath.h>

#include "D3D12Hooks.h"
#include "sethooks.h"
#include <math.h>
extern "C"{
#include "DDSurface.h"
}

D3D9_HOOKS               * D3D9_Hooks;
D3D9_GLOBALS              D3D9Globals;
using std::to_wstring;

DWORD InitHDHooks9(D3D9_HOOKS * hooksdata, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d.Init();
    if (flags & 0xf00) g_d3d.FIXWINSIZE = 1;
    if (flags & 0xf)
    {
       LOGHOOK(IDirect3DDevice9, ProcessVertices, hooksdata->ahkdevice, &D3D9Globals.ProcessVertices, ProcessVertices9Hook)
       g_d3d.Setup(hooksdata->W, hooksdata->H, "D3D9");
       g_d3d.ApplyCommonHooks(0);      
    }
    if (flags & 0xf0)
    {
       g_d3d.SetReslimit(hooksdata->W, hooksdata->H);
    }
    static char D3D9TexProxyID[17] = "PeixotoDx9Proxy";
    D3D9Globals.TexProxyID = (IID*) D3D9TexProxyID;

    static char D3D9TexTexID[17] = "Peixoto.Dx9.Tex";
    D3D9Globals.TexTexID = (IID*) D3D9TexTexID;

    static char D3D9SrfcProxyID[17] = "PeixotoDS9Proxy";
    D3D9Globals.SrfcProxyID = (IID*) D3D9SrfcProxyID;

    static char D3D9SrfcSrfcID[17] = "Peixoto.DS9.Tex";
    D3D9Globals.SrfcSrfcID = (IID*) D3D9SrfcSrfcID;

    static char D3D9LockedSurface[17] = "Dx9.Locked.Srfce";
    D3D9Globals.LockedSurface = (IID*) D3D9LockedSurface;

    D3D9_Hooks =  hooksdata;   

    D3D9Globals.VertexShader      = new SYNC::AtomicPtr();
    D3D9Globals.Blocks            = new POINTER_DICTIONARY();
    D3D9Globals.GameModules       = new POINTER_DICTIONARY();
    D3D9Globals.HDSet             = new SYNC::Atomic();
    D3D9Globals.lock              = new SYNC::AtomicLock();
    D3D9Globals.SearchingTextures = new SYNC::Atomic();
    D3D9Globals.CurrentTexture    = new SYNC::AtomicPtr();
    D3D9Globals.ScreenSpace       = new SYNC::Atomic();
    D3D9Globals.ScreenSpace->Set(0);   
    return 1;
}

void D3D9HDSetUP(DWORD w, DWORD h)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d.Setup(w, h, "D3D9");
}

HRESULT STDMETHODCALLTYPE D3D9_EndSceneHook(IDirect3DDevice9 * dev)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D9Globals.lock->lock();
    HRESULT r = D3D9_Hooks->p_EndSceneCalback(dev);
    D3D9Globals.lock->unlock();
    D3D9Globals.SearchingTextures->Set(D3D9_Hooks->searching);
    if (r == 0) return D3D9_Hooks->p_EndScene(dev);

    if (r<4)
    {
        D3D9Globals.CurrentTexture->Set( D3D9_Hooks->CurrentTexture );        
        D3D9Write(dev, &D3D9_Hooks->frct, (wchar_t*)D3D9_Hooks->text);
        if (r != 3)
        {
            D3D9_DrawRect(dev, &D3D9_Hooks->rct, nullptr);
            IDirect3DTexture9 * rep = (IDirect3DTexture9 *) D3D9GetProxy(D3D9_Hooks->rct.Texture);                    
            if (rep)
            {
                D3D9RECT rep_rect(&D3D9_Hooks->rct.rect, rep, &D3D9_Hooks->rct);
                rep_rect.m_r9.rect.left  += D3D9_Hooks->rct.rect.right;
                rep_rect.m_r9.rect.right += D3D9_Hooks->rct.rect.right;
                D3D9_DrawRect(dev, &rep_rect.m_r9, nullptr);
            }
        }
        if (r == 2)
        {
            D3D9DumpTexture(D3D9_Hooks->rct.Texture, D3D9_Hooks->dump);
        }        
    } else if (r>=4)
    {
        DWORD i;
        LPVOID shader;
        for(i=0; i<D3D9_Hooks->Shaders->count; i++)
        {
            shader = D3D9_Hooks->Shaders->ValueAt(i);
            if (shader == D3D9_Hooks->CurrentSelectedShader)
                break;
        }
        RECT shdr_rect;
        memcpy(&shdr_rect, &D3D9_Hooks->rct.rect, sizeof(RECT));

        std::wstring msg(L"Shader ");
        msg += (to_wstring(i) + L"/" + to_wstring(D3D9_Hooks->Shaders->count)
                              + L" " + to_wstring(D3D9_Hooks->Overrides->count) + L" overrides").c_str();
        D3D9Write(dev, &shdr_rect, (wchar_t*)msg.c_str());
        if (r == 5)
        D3D9DumpShader(dev, (IDirect3DPixelShader9 *)shader);
    }    
    return D3D9_Hooks->p_EndScene(dev);
}

HRESULT STDMETHODCALLTYPE
Present9Hook(IDirect3DDevice9 * dev, const RECT *, const RECT *, HWND hWin, const RGNDATA * r)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirect3DSurface9 * BackBuff = 0;
    D3D9_Hooks->GetBackBuffer(dev, 0, 0, D3DBACKBUFFER_TYPE_MONO, &BackBuff);
    if (D3D9_Hooks->HlfSurface)
    {
        D3D9_Hooks->StretchRect(dev, D3D9_Hooks->HDSurface, 0, D3D9_Hooks->HlfSurface, 0, D3DTEXF_LINEAR);
        D3D9_Hooks->StretchRect(dev, D3D9_Hooks->HlfSurface, 0, BackBuff, &D3D9_Hooks->HDRect, D3DTEXF_LINEAR);
    } else {
        D3D9_Hooks->StretchRect(dev, D3D9_Hooks->HDSurface, 0, BackBuff, &D3D9_Hooks->HDRect, D3DTEXF_LINEAR);
    }
    if (BackBuff != 0) D3D9_Hooks->pIDirect3DSurface9_Release(BackBuff);

    if (D3D9_Hooks->BLNK)
    {
        D3DRASTER_STATUS s;
        s.InVBlank = FALSE;
        while (!s.InVBlank) dev->GetRasterStatus(0, &s);
    }
    return D3D9_Hooks->Present(dev, 0, 0, hWin, nullptr);
}

HRESULT STDMETHODCALLTYPE
xBRPresent9Hook(IDirect3DDevice9 * dev, const RECT *, const RECT *, HWND hWin, const RGNDATA *)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirect3DSurface9 * BackBuff = nullptr;
    if (D3D9_Hooks->GetBackBuffer(dev, 0, 0, D3DBACKBUFFER_TYPE_MONO, &BackBuff) != S_OK)
    {
        DBUG_WARN("GetBackBuffer failed");
        return 0;
    }
    IDirect3DTexture9 *tx = nullptr;
    if (D3D9_Hooks->HDSurface->GetContainer(IID_IDirect3DTexture9, (void**)&tx) != S_OK)
    {
        DBUG_WARN("GetContainer failed");
        return 0;
    }
    D3D9_RECT r;
    float px_params[4];
    px_params[0] = 1.f/D3D9_Hooks->W;
    px_params[1] = 1.f/D3D9_Hooks->H;
    if (D3D9_Hooks->AdjustTexelSize)
    {
        if (D3D9_Hooks->AdjustTexelSize & 0xf0)
        {
            px_params[0] *= D3D9_Hooks->AdjustTexelSize & 0x0f;
            px_params[1] *= D3D9_Hooks->AdjustTexelSize & 0x0f;
        }
        else {
            px_params[0] *= ceil((float)D3D9_Hooks->H / (540.f / D3D9_Hooks->AdjustTexelSize));
            px_params[1] *= ceil((float)D3D9_Hooks->H / (540.f / D3D9_Hooks->AdjustTexelSize));
        }
        DBUG_WARN(std::to_string(D3D9_Hooks->AdjustTexelSize).c_str());
    }
    px_params[2] = (float)D3D9_Hooks->HD_W;
    px_params[3] = (float)D3D9_Hooks->HD_H;
    dev->SetPixelShaderConstantF(223, px_params, 1);

    IDirect3DSurface9 * render_targets[4] = {0};
    for (UINT i=0; i<4; i++)
        D3D9_Hooks->GetRenderTarget(dev, i, &render_targets[i]);
    
    IDirect3DSurface9* stencil = nullptr;
    D3D9_Hooks->GetDepthStencilSurface(dev, &stencil);
    D3D9_Hooks->SetDepthStencilSurface(dev, 0);

    memcpy(&r.rect, &D3D9_Hooks->HDRect, sizeof(RECT));
    r.Texture                      = tx;
    r.PixelShader                  = D3D9_Hooks->XBR;
    r.pIDirect3DDevice9_SetTexture = D3D9_Hooks->pIDirect3DDevice9_SetTexture;
    dev->SetRenderTarget(0, BackBuff);
    D3D9_DrawRect(dev, &r, nullptr);
    dev->SetRenderTarget(0, D3D9_Hooks->HDSurface);
    D3D9_Hooks->pIDirect3DSurface9_Release(BackBuff);
    tx->Release();

    for (UINT i=0; i<4; i++)
    {
        if (render_targets[i] != 0)
        {
            D3D9_Hooks->SetRenderTarget(dev, i, render_targets[i]);
            render_targets[i]->Release();
        }
    }
    if (stencil != nullptr)
    {
        D3D9_Hooks->SetDepthStencilSurface(dev, stencil);
        stencil->Release();
    }
        
    return D3D9_Hooks->Present(dev, 0, 0, hWin, 0);
}


HRESULT STDMETHODCALLTYPE
CreateCubeTexture9Hook(IDirect3DDevice9* d, UINT EdgeLength, UINT Levels, DWORD Usage,
                       D3DFORMAT Format, D3DPOOL Pool,
                       IDirect3DCubeTexture9 **ppCubeTexture, HANDLE *pSharedHandle)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->CreateCubeTexture(d, EdgeLength, Levels, Usage, Format,
                                               Pool, ppCubeTexture, pSharedHandle);
    if (hr) return hr;

    if ( (Usage & D3DUSAGE_RENDERTARGET) || (Usage & D3DUSAGE_DEPTHSTENCIL) )
    {
        IDirect3DCubeTexture9 * HD;
        HRESULT r = D3D9_Hooks->CreateCubeTexture(d, EdgeLength*D3D9_Hooks->scale, Levels,
                                                  Usage, Format, Pool, &HD, 0);
        if (r)
        {
            DBUG_WARN("FAILED TO CREATE A HD CUBE TEXTURE");
        } else {
            D3D9SetProxy(*ppCubeTexture, HD);
        }
    }
    return hr;
}


HRESULT STDMETHODCALLTYPE
CreateRenderTarget9Hook(IDirect3DDevice9* d, UINT w, UINT h, D3DFORMAT f,
                        D3DMULTISAMPLE_TYPE m, DWORD q, BOOL l,
                        IDirect3DSurface9 **ppS, HANDLE *pS)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->CreateRenderTarget(d,w,h,f,m,q,l,ppS,pS);
    if (hr) return hr;    
    if (!ProxyCheck9(w, h, f, 4)) return hr;

    IDirect3DSurface9 * HD;
    HRESULT r = D3D9_Hooks->CreateRenderTarget(d,w*D3D9_Hooks->scale,h*D3D9_Hooks->scale,
                                               f,m,q,l,&HD,0);
    if (r)
    {
        DBUG_WARN("FAILED TO CREATE A HD RENDER TARGET");
    } else {
        D3D9SetRenderSurfaceProxy(*ppS, HD);
    }
    return hr;
}

HRESULT STDMETHODCALLTYPE
CreateDepthStencilSurface9Hook(IDirect3DDevice9* D, UINT w, UINT h, D3DFORMAT f,
                               D3DMULTISAMPLE_TYPE m, DWORD q, BOOL d,
                               IDirect3DSurface9 **ppS, HANDLE *pS)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->CreateDepthStencilSurface(D,w,h,f,m,q,d,ppS,pS);
    if (hr) return hr;
    if (!ProxyCheck9(w, h, f, 5)) return hr;

    IDirect3DSurface9 * HD;
    HRESULT r = D3D9_Hooks->CreateDepthStencilSurface(D,w*D3D9_Hooks->scale,h*D3D9_Hooks->scale,
                                                      f,m,q,d,&HD,0);
    if (r)
    {
        DBUG_WARN("FAILED TO CREATE A HD Z BUFFER");
    } else {
        D3D9SetRenderSurfaceProxy(*ppS, HD);
    }
    return hr;
}

HRESULT STDMETHODCALLTYPE
CreateTx9HD(IDirect3DDevice9* d, UINT w, UINT h, UINT l, DWORD u, D3DFORMAT f,
            D3DPOOL p, IDirect3DTexture9** ppt,  HANDLE * sh)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->CreateTexture(d, w, h, l, u, f, p, ppt, sh);
    if (hr) return hr;

    if (u & 0xf)
    {
        if (!ProxyCheck9(w, h, f, u)) return hr;
        IDirect3DTexture9 * HD;
        HRESULT r = D3D9_Hooks->pIDirect3DDevice9_CreateTexture(
                    d, w*D3D9_Hooks->scale, h*D3D9_Hooks->scale, l, u, f, p, (void**)&HD, 0);
        if (r)
        {
            DBUG_WARN("FAILED TO CREATE A HD TARGET TEXTURE");
        } else {
            D3D9SetProxy(*ppt, HD);
        }
    } return 0;
}

IDirect3DSurface9 * FindSDSurface9(IDirect3DDevice9*, IDirect3DSurface9 * HDSurface)
{
    IDirect3DTexture9 * texture2D = 0, * texture2DHD = 0;
    IDirect3DSurface9 * SDSurface = 0;
    int index = -1;

    if      (HDSurface == 0)                      return 0;
    else if (HDSurface == D3D9_Hooks->HDSurface)  return D3D9_Hooks->SDSurface;
    else if (HDSurface == D3D9_Hooks->HDZSurface) return D3D9_Hooks->SDZSurface;
    else if ( (texture2D =
              (IDirect3DTexture9*)GetContainer9(HDSurface, IID_IDirect3DTexture9)) )
    {
        texture2DHD = (IDirect3DTexture9*) D3D9GetTexture(texture2D);                
        if (!texture2DHD)
        {
            DBUG_WARN("UNKNOWN HD TEXTURE");
            return HDSurface;
        }
        if ( (index = GetSurface9Index(HDSurface)) == -1)
        {
            DBUG_WARN("UNABLE TO FIND SURFACE INDEX");
            return HDSurface;
        }
        if ( texture2DHD->GetSurfaceLevel(0, &SDSurface) == 0)
        {
            SDSurface->Release();
            return SDSurface;
        } else {
            DBUG_WARN("UNABLE TO GET TEXTURE LEVEL");
            return HDSurface;
        }
    }
    else
    {
        SDSurface = (IDirect3DSurface9 *) D3D9GetRenderSurface(HDSurface);
        if (SDSurface)
            return SDSurface;
    }
    DBUG_WARN("UNKNOWN");
    return HDSurface;
}

IDirect3DSurface9 * FindHDSurface9(IDirect3DDevice9*, IDirect3DSurface9 * SDSurface, char* caller)
{
    IDirect3DCubeTexture9 * texture3D = 0, * texture3DHD = 0;
    IDirect3DTexture9 * texture2D = 0, * texture2DHD = 0;
    IDirect3DSurface9 * HDSurface = 0;
    int index = -1;

    if      (SDSurface == 0)                      return 0;
    else if (SDSurface == D3D9_Hooks->SDSurface)  return D3D9_Hooks->HDSurface;
    else if (SDSurface == D3D9_Hooks->SDZSurface) return D3D9_Hooks->HDZSurface;
    else if ( (texture2D =
              (IDirect3DTexture9*)GetContainer9(SDSurface, IID_IDirect3DTexture9)) )
    {
        texture2DHD = (IDirect3DTexture9 *) D3D9GetProxy(texture2D);               
        if (!texture2DHD)
        {
            DBUG_WARN((std::string(caller)+" UNKNOWN SD TEXTURE").c_str() );
            return SDSurface;
        }
        if ( (index = GetSurface9Index(SDSurface)) == -1)
        {
            DBUG_WARN((std::string(caller)+" UNABLE TO FIND SURFACE INDEX").c_str());
            return SDSurface;
        }
        if ( texture2DHD->GetSurfaceLevel(0, &HDSurface) == 0)
        {
            HDSurface->Release();
            return HDSurface;
        } else {
            DBUG_WARN((std::string(caller)+" UNABLE TO GET TEXTURE LEVEL").c_str());
            return SDSurface;
        }
    }
    else if ( (texture3D = (IDirect3DCubeTexture9*)
               GetContainer9(SDSurface, IID_IDirect3DCubeTexture9)) )
    {
        texture3DHD =  (IDirect3DCubeTexture9 *) D3D9GetProxy(texture2D);                
        if (!texture3DHD)
        {
            DBUG_WARN((std::string(caller)+" UNKNOWN SD 3D TEXTURE").c_str());
            return SDSurface;
        }
        UINT lvl, face;
        if ( ! (GetFaceAndLevel9(SDSurface, &face, &lvl)) )
        {
            DBUG_WARN((std::string(caller)+" UNABLE TO FIND SURFACE LEVEL AND FACE").c_str());
            return SDSurface;
        }
        if ( texture3DHD->GetCubeMapSurface((D3DCUBEMAP_FACES)face, lvl, &HDSurface) == 0)
        {
            HDSurface->Release();
            return HDSurface;
        } else {
            DBUG_WARN((std::string(caller)+" UNABLE TO GET TEXTURE LEVEL AND FACE").c_str());
            return SDSurface;
        }
    }
    else
    {
        HDSurface = (IDirect3DSurface9 *) D3D9GetRenderSurfaceProxy(SDSurface);
        if (HDSurface)
            return HDSurface;
    }
    DBUG_WARN((std::string(caller)+" UNKNOWN").c_str());
    return SDSurface;
}

BOOL HDSet9(IDirect3DDevice9* d)
{
    if (!D3D9_Hooks->POW2Fix) return TRUE;

    IDirect3DSurface9 * RT;
    IDirect3DSurface9 * SD;
    if (D3D9_Hooks->GetRenderTarget(d, 0, &RT) == 0)
    {
        RT->Release();
        SD = FindSDSurface9(d, RT);
        if (SD && (SD != RT)) return TRUE;
    }
    return FALSE;
}

HRESULT STDMETHODCALLTYPE
CreateIndexBuffer9Hook(IDirect3DDevice9* d, UINT l, DWORD u, D3DFORMAT f,
                       D3DPOOL p, IDirect3DIndexBuffer9 **ppI, HANDLE *ph)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    u &= ~ D3DUSAGE_WRITEONLY;
    return D3D9_Hooks->CreateIndexBuffer(d, l, u, f, p, ppI, ph);
}

HRESULT STDMETHODCALLTYPE
CreateVertexBuffer9Hook(IDirect3DDevice9* d, UINT l, DWORD u, DWORD FVF,
                        D3DPOOL p, IDirect3DVertexBuffer9 **ppV,HANDLE *ph)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (FVF & 0x04) u &= ~ D3DUSAGE_WRITEONLY;
    return D3D9_Hooks->CreateVertexBuffer(d, l, u, FVF, p, ppV, ph);
}

HRESULT STDMETHODCALLTYPE
SetFVF9Hook(IDirect3DDevice9* d, DWORD fvf)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->SetFVF(d, fvf);
    if (hr)  return hr;
    if (fvf & D3DFVF_XYZRHW) D3D9Globals.ScreenSpace->Set(1);
    else                     D3D9Globals.ScreenSpace->Set(0);
    return hr;
}

HRESULT STDMETHODCALLTYPE
SetVertexDeclaration9Hook(IDirect3DDevice9* d, IDirect3DVertexDeclaration9 * decl)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->SetVertexDeclaration(d, decl);
    if (hr)  return hr;
    D3D9Globals.ScreenSpace->Set(0);
    return 0;
}

HRESULT STDMETHODCALLTYPE
SetVertexShader9Hook(IDirect3DDevice9* d, IDirect3DVertexShader9 * vx)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->SetVertexShader(d, vx);
    if (hr)  return hr;
    D3D9Globals.VertexShader->Set(vx);
    return hr;
    if (vx) D3D9Globals.ScreenSpace->Set(0);
    else    D3D9Globals.ScreenSpace->Set(1);
    return hr;
}

HRESULT STDMETHODCALLTYPE
SetStreamSource9Hook(IDirect3DDevice9* d, UINT Number, IDirect3DVertexBuffer9 *buff,
                     UINT Offset, UINT Stride)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->SetStreamSource(d, Number, buff, Offset, Stride);
    if (hr || (!buff) )  return hr;

    D3DVERTEXBUFFER_DESC D;
    ZeroMemory(&D, sizeof(D3DVERTEXBUFFER_DESC));
    buff->GetDesc(&D);
    if (D.FVF & D3DFVF_XYZRHW) D3D9Globals.ScreenSpace->Set(1);
    else                       D3D9Globals.ScreenSpace->Set(0);
    return hr;
}

HRESULT STDMETHODCALLTYPE EndStateBlock9Hook(IDirect3DDevice9*d , IDirect3DStateBlock9**pB)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->EndStateBlock(d, pB);
    if (hr) return hr;

    IDirect3DStateBlock9   * b  =     *pB;
    IDirect3DVertexShader9 * vx = nullptr;
    d->GetVertexShader(&vx);
    if (vx == nullptr)
    {
        D3D9Globals.Blocks->discard(b);
        return 0;
    }
    D3D9Globals.Blocks->insert_disposable(b, vx);
    vx->Release();
    return 0;
}

HRESULT STDMETHODCALLTYPE ApplyStateBlock9Hook(IDirect3DStateBlock9* b)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->ApplyStateBlock(b);
    if (hr) return hr;

    IDirect3DVertexShader9 * vx = (IDirect3DVertexShader9 *)D3D9Globals.Blocks->Value(b);
    IDirect3DDevice9      * d   = nullptr;
    b->GetDevice(&d);
    d->Release();
    D3D9Globals.VertexShader->Set(vx);
    return 0;
}

HRESULT STDMETHODCALLTYPE ReleaseStateBlock9Hook(IDirect3DStateBlock9*b)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->ReleaseStateBlock(b);
    if (hr) return hr;
    D3D9Globals.Blocks->discard(b);
    return 0;
}

DWORD ScreenSpaceDraw9(IDirect3DDevice9* d)
{
    /*** The FVF declaration takes precedence in TR Legend even if the
    current vertex shader is non null, maybe because the hooks are not
    handling stateblocks ?? ***/

    //if (AreVerticesTransFormed() == FALSE) return 0;
    DWORD FVF = 0;
    if (d->GetFVF(&FVF) != S_OK) return 0;
    if (FVF & D3DFVF_XYZRHW) return g_d3d.m_D3DXGetFVFVertexSize(FVF);
    return 0;

    IDirect3DVertexDeclaration9 * vdcl = nullptr;
    IDirect3DVertexBuffer9      * vxb = nullptr;
    if (vxb)  vxb->Release();
    if (vdcl) vdcl->Release();
    if (vxb && vdcl) return 0;

    //DWORD FVF = 0;
    d->GetFVF(&FVF);
    if (FVF & D3DFVF_XYZRHW) return g_d3d.m_D3DXGetFVFVertexSize(FVF);
    return 0;
}

DWORD ScreenSpaceDraw9VB(IDirect3DDevice9* d)
{
    {
        //return ScreenSpaceDraw9(d);
        //if (AreVerticesTransFormed() == FALSE) return 0;

        IDirect3DVertexDeclaration9 * vdcl = nullptr;
        IDirect3DVertexBuffer9      * vxb  = nullptr;
        UINT Offset, Stride;

        d->GetStreamSource(0, &vxb, &Offset, &Stride);
        d->GetVertexDeclaration(&vdcl);
        if (vxb && vdcl)
        {
            D3DVERTEXBUFFER_DESC Dsc;
            ZeroMemory(&Dsc, sizeof(D3DVERTEXBUFFER_DESC));
            vxb->GetDesc(&Dsc);
            vxb->Release();
            vdcl->Release();
            if (Dsc.FVF & D3DFVF_XYZ)    return 0;          /* Second Sight */            
            if (Dsc.FVF & D3DFVF_XYZRHW) return g_d3d.m_D3DXGetFVFVertexSize(Dsc.FVF);
            return 0;
        } 
        else if (vxb)  vxb->Release();
        else if (vdcl) vdcl->Release();
    }
    //return 0;
    return ScreenSpaceDraw9(d); /* The void */

    /*** In POP_SOT a FVF vertex buffer uses the fixed function pipeline
    even with a valid vertex shader, but not in second sight, this check
    is likely just a workarround, the problem here is may be that the
    hooks don't handle state blocks, but on the other hand it persist
    even if we supress the D3DCREATE_PUREDEVICE flag ***/

    IDirect3DVertexShader9 * vs = nullptr;
    d->GetVertexShader(&vs);
    if (vs)
    {
        vs->Release();
        return 0;
    }
    return ScreenSpaceDraw9(d);
}


DWORD vertex_count9(DWORD type, DWORD primitive_count)
{
    if      (type >= 5) return 3 + (primitive_count-1);
    else if (type == 4) return primitive_count*3;
    else if (type == 1) return primitive_count;    
    else DBUG_WARN( (std::string("UNHANDLED PRMIMITIVE TYPE ") + std::to_string(type)).c_str() );
    return 0;
}

HRESULT STDMETHODCALLTYPE
DrawIndexedPrimitiveUP9Hook(IDirect3DDevice9* d, D3DPRIMITIVETYPE type, UINT Min,
                            UINT vcount, UINT pcount, const void *pIndx,
                            D3DFORMAT IdxFrmt, const void *pVertices, UINT Stride)
{
     #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
     DWORD vertex_size = ScreenSpaceDraw9(d);
     if (pVertices == nullptr) return D3DERR_INVALIDCALL;
     if (pIndx == nullptr)     return D3DERR_INVALIDCALL;
     if (vertex_size)
     {
         DWORD n_vert = vertex_count9(type, pcount);
         WORD index;
         DirectX::XMFLOAT4 * scaled_vertice;
         DirectX::XMFLOAT4 * vertice;
         if (IdxFrmt == D3DFMT_INDEX16)
         {
             std::string indexes("Indexes :\n");
             WORD * pIndex = (WORD *)pIndx;
             for (DWORD i=0; i<n_vert; ++i)
             {
                 index          = * pIndex;
                 vertice        = (DirectX::XMFLOAT4*) ( (DWORD)pVertices            + (Stride*index) );
                 scaled_vertice = (DirectX::XMFLOAT4*) ( (DWORD)D3D9_Hooks->vertices + (Stride*index) );
                 pIndex        += 1;

                 memcpy(scaled_vertice, vertice, Stride);
                 scaled_vertice->x *= D3D9_Hooks->scale;
                 scaled_vertice->y *= D3D9_Hooks->scale;
             }
             HRESULT hr = D3D9_Hooks->DrawIndexedPrimitiveUP(d, type, Min, vcount, pcount, pIndx,
                                                             IdxFrmt, D3D9_Hooks->vertices, Stride);
             return hr;
         }
         else if (IdxFrmt == D3DFMT_INDEX32)
         {
             std::string indexes("Indexes :\n");
             DWORD * pIndex = (DWORD *)pIndx;
             for (DWORD i=0; i<n_vert; ++i)
             {
                 index          = * (DWORD*) (DWORD)pIndex+i ;
                 vertice        = ( DirectX::XMFLOAT4*) ( (DWORD)pVertices            + (Stride*index) );
                 scaled_vertice = ( DirectX::XMFLOAT4*) ( (DWORD)D3D9_Hooks->vertices + (Stride*index) );

                 memcpy(scaled_vertice, vertice, Stride);
                 scaled_vertice->x *= D3D9_Hooks->scale;
                 scaled_vertice->y *= D3D9_Hooks->scale;
             }             
             HRESULT hr = D3D9_Hooks->DrawIndexedPrimitiveUP(d, type, Min, vcount, pcount, pIndx,
                                                             IdxFrmt, D3D9_Hooks->vertices, Stride);
             return hr;
         }
         return 0;
     }
     return D3D9_Hooks->DrawIndexedPrimitiveUP(d, type, Min, vcount, pcount, pIndx,
                                               IdxFrmt, pVertices, Stride);
}

HRESULT STDMETHODCALLTYPE DrawIndexedPrimitive9Hook(IDirect3DDevice9* d, D3DPRIMITIVETYPE type,
INT BaseVertex, UINT p4, UINT NumVertices, UINT StartIndex, UINT primitive_count)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD vertex_size = ScreenSpaceDraw9VB(d);
    if (vertex_size)
    {
        IDirect3DVertexBuffer9 * vb = 0;
        IDirect3DIndexBuffer9  * ib = 0;
        D3DINDEXBUFFER_DESC ID;
        UINT  vb_offset, vb_stride, idxsize, ib_lock_size;
        DWORD vertex_count = vertex_count9(type, primitive_count);
        void * index_data, *vertex_data;
        ZeroMemory(&ID, sizeof(D3DINDEXBUFFER_DESC));

        d->GetStreamSource(0, &vb, &vb_offset, &vb_stride);
        if (vb == 0)
        {
            DBUG_WARN("Failed to get the Vertex buffer");
            return D3DERR_INVALIDCALL;
        }
        d->GetIndices(&ib);
        if (ib == 0)
        {
            DBUG_WARN("Failed to get the Index buffer");
            vb->Release();
            return D3DERR_INVALIDCALL;
        }

        ib->GetDesc(&ID);
        idxsize      = ID.Format == D3DFMT_INDEX16 ? 2 : 4;
        ib_lock_size = idxsize*vertex_count;
        if (ib->Lock(StartIndex*idxsize, ib_lock_size, &index_data, D3DLOCK_READONLY))
        DBUG_WARN("No idx lock");

        if (idxsize == 2)
        {
             WORD index0 = *(WORD*) index_data;
             if (vb->Lock(0, NumVertices*vertex_size, &vertex_data, D3DLOCK_READONLY))
             DBUG_WARN("No lock");

             DirectX::XMFLOAT4 * vertice        = (DirectX::XMFLOAT4*)((DWORD)vertex_data);
             DirectX::XMFLOAT4 * scaled_vertice = (DirectX::XMFLOAT4*)D3D9_Hooks->vertices;

            for (DWORD i=0; i<vertex_count; i++)
            {
                index0  = (DWORD) *(WORD*) index_data;
                vertice = (DirectX::XMFLOAT4*)((DWORD)vertex_data + vertex_size*(index0+BaseVertex));

                memcpy(scaled_vertice, vertice, vertex_size);
                scaled_vertice->x *= D3D9_Hooks->scale;
                scaled_vertice->y *= D3D9_Hooks->scale;

                index_data    = (LPVOID) ((DWORD)index_data+2);
                scaled_vertice= ( DirectX::XMFLOAT4*) ((DWORD)scaled_vertice+vertex_size);
            }
        }
        else
        {
            DWORD index0 = *(DWORD*) index_data;
            if (vb->Lock(0,NumVertices*vertex_size, &vertex_data, D3DLOCK_READONLY))
            DBUG_WARN("No lock");

            LPVOID vertice;
            DirectX::XMFLOAT4 * scaled_vertice = ( DirectX::XMFLOAT4*) D3D9_Hooks->vertices;
            for (DWORD i=0; i<vertex_count; i++)
            {
                index0  = (DWORD) *(DWORD*) index_data;
                vertice = (LPVOID)((DWORD)vertex_data + vertex_size*(index0+BaseVertex));
                memcpy(scaled_vertice, vertice, vertex_size);
                scaled_vertice->x *= D3D9_Hooks->scale;
                scaled_vertice->y *= D3D9_Hooks->scale;

                index_data     = (LPVOID) ((DWORD)index_data+4);
                scaled_vertice =( DirectX::XMFLOAT4 *) ((DWORD)scaled_vertice+vertex_size);
            }
        }

        vb->Unlock();
        ib->Unlock();
        HRESULT err = D3D9_Hooks->DrawPrimitiveUP(d, type, primitive_count,
                                                  D3D9_Hooks->vertices, vertex_size);
        d->SetStreamSource(0, vb, vb_offset, vb_stride);
        vb->Release();
        ib->Release();
        return err;
    }
    HRESULT err = D3D9_Hooks->DrawIndexedPrimitive(d, type, BaseVertex, p4, NumVertices,
                                                   StartIndex, primitive_count);
    return err;
}

HRESULT STDMETHODCALLTYPE
DrawPrimitive9Hook(IDirect3DDevice9* d, D3DPRIMITIVETYPE type, UINT start, UINT count)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD vertex_size = ScreenSpaceDraw9VB(d);
    if (vertex_size)
    {
        DWORD vertex_count = vertex_count9(type, count);
        IDirect3DVertexBuffer9 * vb = 0;
        UINT offset, stride;
        if (d->GetStreamSource(0, &vb, &offset, &stride) || vb == 0)
        {
             DBUG_WARN("DrawPrimitive: FAILED TO GET THE VERTEX BUFFER");
             return D3D9_Hooks->DrawPrimitive(d, type, start, count);
        }

        void * pData;
        vb->Lock(start*vertex_size, vertex_count*vertex_size, &pData, D3DLOCK_READONLY);

        memcpy(D3D9_Hooks->vertices, pData, vertex_count*vertex_size);
        DirectX::XMFLOAT4 * vertice = ( DirectX::XMFLOAT4*) D3D9_Hooks->vertices;
        for(DWORD i=0; i<vertex_count; i++)
        {
            vertice->x *= D3D9_Hooks->scale;
            vertice->y *= D3D9_Hooks->scale;
            vertice = ( DirectX::XMFLOAT4 *) ((DWORD)vertice+stride);
        }
        vb->Unlock();
        HRESULT err =
                D3D9_Hooks->DrawPrimitiveUP(d, type, count, D3D9_Hooks->vertices, vertex_size);
        d->SetStreamSource(0, vb, offset, stride);
        vb->Release();
        return err;
    }
    HRESULT err = D3D9_Hooks->DrawPrimitive(d, type, start, count);
    return err;
}

HRESULT STDMETHODCALLTYPE
DrawPrimitiveUp9Hook(IDirect3DDevice9* d, D3DPRIMITIVETYPE type, UINT count,
                     const void * vertices, UINT stride)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD vertex_size = ScreenSpaceDraw9(d);
    if (vertex_size)
    {
        DirectX::XMFLOAT4 * vertice = ( DirectX::XMFLOAT4*) D3D9_Hooks->vertices;
        DWORD vertex_count = vertex_count9(type, count);
        memcpy(D3D9_Hooks->vertices, vertices, stride*vertex_count);

        for(DWORD i=0; i<vertex_count; i++)
        {
            vertice->x *= D3D9_Hooks->scale;
            vertice->y *= D3D9_Hooks->scale;
            vertice = ( DirectX::XMFLOAT4 *) ((DWORD)vertice+stride);
        }

        return D3D9_Hooks->DrawPrimitiveUP(d, type, count, D3D9_Hooks->vertices, stride);
    }
    HRESULT err = D3D9_Hooks->DrawPrimitiveUP(d, type, count, vertices, stride);
    return err;
}

HRESULT STDMETHODCALLTYPE ProcessVertices9Hook(IDirect3DDevice9* d, UINT SrcStartIndex, UINT DestIndex, UINT VertexCount,
    IDirect3DVertexBuffer9* pDestBuffer, IDirect3DVertexDeclaration9* pVertexDecl, DWORD Flags)
{
    D3DVIEWPORT9 hd_vw     = {};
    D3DVIEWPORT9 sd_vw     = {};
    RECT         hd_scisor = {};
    RECT         sd_scisor = {};
    D3D9_Hooks->GetView(d, &hd_vw);
    D3D9_Hooks->GetScissorRect(d, &hd_scisor);
    memcpy(&sd_vw, &hd_vw, sizeof(D3DVIEWPORT9));
    memcpy(&sd_scisor, &hd_scisor, sizeof(RECT));
    if (HDSet9(d))
    {
        sd_vw.X          /= D3D9_Hooks->scale;
        sd_vw.Y          /= D3D9_Hooks->scale;
        sd_vw.Width      /= D3D9_Hooks->scale;
        sd_vw.Height     /= D3D9_Hooks->scale;
        sd_scisor.top    /= D3D9_Hooks->scale;
        sd_scisor.left   /= D3D9_Hooks->scale;
        sd_scisor.right  /= D3D9_Hooks->scale;
        sd_scisor.bottom /= D3D9_Hooks->scale;
    }
    D3D9_Hooks->SetView(d, &sd_vw);
    D3D9_Hooks->SetScissorRect(d, &sd_scisor);
    HRESULT hr = D3D9Globals.ProcessVertices(d, SrcStartIndex, DestIndex, VertexCount, pDestBuffer, pVertexDecl, Flags);
    D3D9_Hooks->SetView(d, &hd_vw);
    D3D9_Hooks->SetScissorRect(d, &hd_scisor);
    return hr;
}

HRESULT STDMETHODCALLTYPE
GetViewPort9Hook(IDirect3DDevice9* d, D3DVIEWPORT9 * vw)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->GetView(d, vw);
    if (hr == 0 && HDSet9(d))
    {
       memcpy(vw, &D3D9Globals.SDViewPort9, sizeof(D3DVIEWPORT9));
       return hr;
    }
    return hr;
}

HRESULT STDMETHODCALLTYPE
SetViewPort9Hook(IDirect3DDevice9* d, D3DVIEWPORT9 * vw)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (vw == NULL) return D3DERR_INVALIDCALL;
    //memcpy(&SDViewPort9, vw, sizeof(D3DVIEWPORT9));
    memcpy(&D3D9Globals.HDViewPort9, vw, sizeof(D3DVIEWPORT9));

    if ( HDSet9(d) )
    {
        D3D9Globals.HDViewPort9.X *= D3D9_Hooks->scale;
        D3D9Globals.HDViewPort9.Y *= D3D9_Hooks->scale;
        D3D9Globals.HDViewPort9.Width  *= D3D9_Hooks->scale;
        D3D9Globals.HDViewPort9.Height *= D3D9_Hooks->scale;
    }  memcpy(&D3D9Globals.SDViewPort9, vw, sizeof(D3DVIEWPORT9)); //System shock 2 needs this
    return D3D9_Hooks->SetView(d, &D3D9Globals.HDViewPort9);
}

HRESULT STDMETHODCALLTYPE
GetScissorRect9Hook(IDirect3DDevice9* d, RECT * scsr)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->GetScissorRect(d, scsr);
    if (hr == 0)
    {
       memcpy(scsr, &D3D9Globals.SDScissor, sizeof(RECT));
       return hr;
    }
    return hr;
}

HRESULT STDMETHODCALLTYPE
SetScissorRect9Hook(IDirect3DDevice9* d, RECT * scsr)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (scsr == NULL) return D3DERR_INVALIDCALL;
    RECT HDscsr;
    memcpy(&HDscsr, scsr, sizeof(RECT));
    memcpy(&D3D9Globals.SDScissor, scsr, sizeof(RECT));

    if ( HDSet9(d) )
    {
        HDscsr.left   *= D3D9_Hooks->scale;
        HDscsr.right  *= D3D9_Hooks->scale;
        HDscsr.top    *= D3D9_Hooks->scale;
        HDscsr.bottom *= D3D9_Hooks->scale;
    }
    return D3D9_Hooks->SetScissorRect(d, &HDscsr);
}

HRESULT STDMETHODCALLTYPE
StretchRect9Hook(IDirect3DDevice9* dv, IDirect3DSurface9* src, const RECT* rsrc,
                 IDirect3DSurface9* dst, const RECT* rdst, D3DTEXTUREFILTERTYPE f)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirect3DSurface9 * hdsrc = FindHDSurface9(dv, src, "StretchRect9Hook SOURCE");
    IDirect3DSurface9 * hddst = FindHDSurface9(dv, dst, "StretchRect9Hook TARGET");
    RECT HDsrc, HDdst;
    RECT * psrc = 0, * pdst = 0;
    if (rsrc)
    {
        memcpy(&HDsrc, rsrc, sizeof(RECT));
        if (hdsrc != src)
        {
            HDsrc.left   *= D3D9_Hooks->scale;
            HDsrc.right  *= D3D9_Hooks->scale;
            HDsrc.top    *= D3D9_Hooks->scale;
            HDsrc.bottom *= D3D9_Hooks->scale;
        }
        psrc = &HDsrc;
    }
    if (rdst)
    {
        memcpy(&HDdst, rdst, sizeof(RECT));
        if (hddst != dst)
        {
            HDdst.left   *= D3D9_Hooks->scale;
            HDdst.right  *= D3D9_Hooks->scale;
            HDdst.top    *= D3D9_Hooks->scale;
            HDdst.bottom *= D3D9_Hooks->scale;
        }
        pdst = &HDdst;
    }
    return D3D9_Hooks->StretchRect(dv, hdsrc, psrc,
                                   hddst, pdst, f);
}

HRESULT STDMETHODCALLTYPE
SetRenderTarget9Hook(IDirect3DDevice9 * d, DWORD index, IDirect3DSurface9* RT)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr;
    IDirect3DSurface9 * HDRenderTarget = NULL;
    D3D9Globals.HDSet->Set(0);
    if (index == 0)
    {
        if (RT == 0) return D3DERR_INVALIDCALL;

        HDRenderTarget = FindHDSurface9(d, RT, (char*)__FUNCTION__);
        if ( (hr = D3D9_Hooks->SetRenderTarget(d, index, HDRenderTarget)) == 0 )
        {
            D3D9_Hooks->GetView(d, &D3D9Globals.SDViewPort9);
            if (HDRenderTarget != RT)
            {
                D3DSURFACE_DESC D;
                D3D9Globals.HDSet->Set(1);
                RT->GetDesc(&D);
                D3D9Globals.SDViewPort9.Height = D.Height;
                D3D9Globals.SDViewPort9.Width  = D.Width;
            } else {
                D3D9Globals.HDSet->Set(0);
            }
        }
    } else {
        HDRenderTarget = FindHDSurface9(d, RT, (char*)__FUNCTION__);
        hr = D3D9_Hooks->SetRenderTarget(d, index, HDRenderTarget);
    }
    if (hr) DBUG_WARN("FAILED");
    return hr;
}

HRESULT STDMETHODCALLTYPE
SetDepthStencilSurface9Hook(IDirect3DDevice9 * d, IDirect3DSurface9* ZBuff)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return D3D9_Hooks->SetDepthStencilSurface(d, FindHDSurface9(d, ZBuff, (char*)__FUNCTION__));
}

HRESULT STDMETHODCALLTYPE
GetRenderTarget9Hook(IDirect3DDevice9 * d, DWORD index, IDirect3DSurface9** RT)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->GetRenderTarget(d, index, RT);
    if (hr)  return hr;

    IDirect3DSurface9 * SD = FindSDSurface9(d, *RT);
    if (!SD) return hr;

    IDirect3DSurface9 * HD = *RT;
    HD->Release();
    SD->AddRef();
    *RT = SD;
    return 0;
}

HRESULT STDMETHODCALLTYPE
GetDepthStencilSurface9Hook(IDirect3DDevice9 * d, IDirect3DSurface9** pS)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->GetDepthStencilSurface(d, pS);
    if (hr)  return hr;

    IDirect3DSurface9 * SD = FindSDSurface9(d, *pS);
    if (!SD) return hr;

    IDirect3DSurface9 * HD = *pS;
    HD->Release();
    SD->AddRef();
    *pS = SD;
    return 0;
}

HRESULT STDMETHODCALLTYPE
GetBackBuffer9Hook(IDirect3DDevice9 *, UINT, UINT, D3DBACKBUFFER_TYPE,
                   IDirect3DSurface9** pS)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
     if (pS == NULL)  return D3DERR_INVALIDCALL;

     *pS = D3D9_Hooks->SDSurface;
     D3D9_Hooks->SDSurface->AddRef();
     return 0;
}

HRESULT STDMETHODCALLTYPE
GetDesc9Hook(IDirect3DSurface9 * d, D3DSURFACE_DESC* D)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT  hr;
    if (d == D3D9_Hooks->SDSurface)
    {
        hr = D3D9_Hooks->HDSurface->GetDesc(D);
        if (hr == 0)
        {
            D->Width  = D3D9_Hooks->W;
            D->Height = D3D9_Hooks->H;
        }
    } else if (d == D3D9_Hooks->SDZSurface)
    {
        hr = D3D9_Hooks->HDZSurface->GetDesc(D);
        if (hr == 0)
        {
            D->Width  = D3D9_Hooks->W;
            D->Height = D3D9_Hooks->H;
        }
    } else hr = D3D9_Hooks->GetSurfaceDesc(d, D);
    return hr;
}

HRESULT STDMETHODCALLTYPE
ColorFill9Hook(IDirect3DDevice9 * d, IDirect3DSurface9 *SD,const RECT *pRect, D3DCOLOR color)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirect3DSurface9 * HD = FindHDSurface9(d, SD, (char*)__FUNCTION__);
    if (HD != SD)
    {
        if (pRect)
        {
            RECT r;
            memcpy(&r, pRect, sizeof(RECT));
            r.left   *= D3D9_Hooks->scale;
            r.right  *= D3D9_Hooks->scale;
            r.top    *= D3D9_Hooks->scale;
            r.bottom *= D3D9_Hooks->scale;
            return D3D9_Hooks->ColorFill(d, HD, &r, color);
        } else return D3D9_Hooks->ColorFill(d, HD, 0, color);
    } return  D3D9_Hooks->ColorFill(d, SD, pRect, color);
}

HRESULT STDMETHODCALLTYPE
Clear9Hook(IDirect3DDevice9 * d, DWORD c, D3DRECT *R, DWORD f, D3DCOLOR C, float Z, DWORD S)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    RECT * r = 0;
    if ( c && R && HDSet9(d) )
    {
        void * mem = malloc(sizeof(RECT)*c);
        r = (RECT*)mem;
        memcpy(r, R, sizeof(RECT)*c);
        for(UINT i=0; i<c; i++)
        {
            r->left   *= D3D9_Hooks->scale;
            r->right  *= D3D9_Hooks->scale;
            r->top    *= D3D9_Hooks->scale;
            r->bottom *= D3D9_Hooks->scale;
            r ++;
        }
        HRESULT err = D3D9_Hooks->Clear(d, c, (D3DRECT*)mem, f, C, Z, S);
        free(mem);
        return err;
    }
    return D3D9_Hooks->Clear(d, c, R, f, C, Z, S);
}

HRESULT STDMETHODCALLTYPE
UpdateHDSurface9Hook(IDirect3DDevice9* dvc, IDirect3DSurface9 * src,
                     const RECT * rct, IDirect3DSurface9 * dst, const POINT * pnt)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    HRESULT hr = D3D9_Hooks->UpdateHDSurface(dvc, src, rct, dst, pnt);
    if (hr) return hr;
    IDirect3DSurface9 * HD = FindHDSurface9(dvc, dst, (char*)__FUNCTION__);
    if (HD != dst) D3D9_Hooks->StretchRect(dvc, dst, nullptr, HD, nullptr, D3DTEXF_POINT);
    return 0;

}

HRESULT STDMETHODCALLTYPE
GetRenderTargetData9Hook(IDirect3DDevice9 * d, IDirect3DSurface9 *SD, IDirect3DSurface9 *pSys)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (SD == D3D9_Hooks->SDSurface)
    {
        D3DSURFACE_DESC D;
        IDirect3DSurface9 * Proxy;
        D3D9_Hooks->HDSurface->GetDesc(&D);
        if (D3D9_Hooks->CreateRenderTarget(d, D3D9_Hooks->W, D3D9_Hooks->H, D.Format,
                                       D.MultiSampleType, D.MultiSampleQuality, 0,
                                       &Proxy, NULL) == 0)
        {
            D3D9_Hooks->StretchRect(d, D3D9_Hooks->HDSurface, NULL, SD, NULL, D3DTEXF_LINEAR);
            HRESULT hr =  D3D9_Hooks->GetRTData(d, Proxy, pSys);
            Proxy->Release();
            return hr;
        }
    }
    IDirect3DSurface9 * HD = FindHDSurface9(d, SD, (char*)__FUNCTION__);
    if (HD != SD)
    {
        D3D9_Hooks->StretchRect(d, HD, NULL, SD, NULL, D3DTEXF_LINEAR);
    }
    return D3D9_Hooks->GetRTData(d, SD, pSys);
}

void D3D9CreatePxProxy(IDirect3DDevice9* dvc, ID3DBlob* blob, IDirect3DPixelShader9* px, BOOL discard)
{
    if (blob == nullptr) return;

    IDirect3DPixelShader9 * rep = nullptr;
    if (D3D9_Hooks->CreatePixelShader(dvc, (DWORD*)blob->GetBufferPointer(), &rep) == 0)
    {
        D3D9Globals.lock->lock();
        IDirect3DPixelShader9 * old = (IDirect3DPixelShader9 *)D3D9_Hooks->Overrides->Value(px);
        D3D9_Hooks->Overrides->insert_disposable(px, rep);
        D3D9Globals.lock->unlock();
        if (discard) blob->Release();
        if (old)     D3D9_Hooks->Release(old);
    }
    else DBUG_WARN("FAILED TO CREATERE REPLACEMENT");
}

IDirect3DPixelShader9 * D3D9GetPxProxy(IDirect3DPixelShader9* px)
{
    D3D9Globals.lock->lock();
    LPVOID override = D3D9_Hooks->Overrides->Value(px);
    D3D9Globals.lock->unlock();
    if (override) return (IDirect3DPixelShader9 *)override;
    return px;
}

int __stdcall D3D9GetSystemMetricsHook(int nIndex)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID ret        = _ReturnAddress();
    BOOL IsGameModule =  CommonIsGameModule(ret, D3D9Globals.GameModules);
    if  (IsGameModule == 0)     return D3D9_Hooks->GetSystemMetrics(nIndex);
    if  (nIndex == SM_CXSCREEN) return D3D9_Hooks->W;
    if  (nIndex == SM_CYSCREEN) return D3D9_Hooks->H;
    return D3D9_Hooks->GetSystemMetrics(nIndex);
}

BOOL __stdcall D3D9GetMonitorInfoAHook(HMONITOR hMonitor, LPMONITORINFO lpmi)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID ret        = _ReturnAddress();
    BOOL IsGameModule =  CommonIsGameModule(ret, D3D9Globals.GameModules);
    BOOL r            = D3D9_Hooks->GetMonitorInfoA(hMonitor, (LPMONITORINFOEXA)lpmi);
    if (r == 0) return 0;
    if (IsGameModule && lpmi)
    {
        lpmi->rcMonitor.bottom =  D3D9_Hooks->H;
        lpmi->rcMonitor.right  =  D3D9_Hooks->W;
        lpmi->rcWork.bottom    =  D3D9_Hooks->H;
        lpmi->rcWork.right     =  D3D9_Hooks->W;
    }
    return r;
}

extern "C" __declspec(dllexport)
void vPosReset9(IDirect3DDevice9 * d)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    while ( D3D9Globals.Blocks->Count() ) D3D9Globals.Blocks->discard( D3D9Globals.Blocks->KeyAt(0) );

    IDirect3DSurface9 * BackBuff = 0;
    D3D9_Hooks->GetBackBuffer(d, 0, 0, D3DBACKBUFFER_TYPE_MONO, &BackBuff);
    if (BackBuff != 0)
    {
        D3D9_Hooks->ColorFill(d, BackBuff, 0, 0);
        D3D9_Hooks->Present(d, 0, 0, 0, 0);
        D3D9_Hooks->ColorFill(d, BackBuff, 0, 0);
    }

    if (!D3D9_Hooks->FixvPos) return;
    UINT i;
    PixelShader9          * Px = 0;
    IDirect3DPixelShader9 * px = 0;
    for(i=0; i<D3D9_Hooks->Shaders->Count(); i++)
    {
        px = (IDirect3DPixelShader9 *) D3D9_Hooks->Shaders->KeyAt(i);
        Px = new PixelShader9(px);
        Px->Dissasemble();
        if (Px->text)
        {
            D3D9Globals.lock->lock();
            ID3DBlob * blob = D3D9_Hooks->vPosFix((char*)Px->text->GetBufferPointer());
            D3D9Globals.lock->unlock();
            D3D9CreatePxProxy(d, blob, px, TRUE);
        }
        delete Px;
    }
}

HRESULT STDMETHODCALLTYPE
CreatePixelShader9Hook(LPDIRECT3DDEVICE9 dev, const DWORD* func, LPDIRECT3DPIXELSHADER9* ppShader)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    UINT                           i;
    UINT size                      = 0;
    LPVOID ShaderData              = nullptr;

    HRESULT err = D3D9_Hooks->CreatePixelShader(dev, func, ppShader);
    if (err) return err;

    D3D9Globals.lock->lock();
    D3D9_Hooks->Shaders->insert_disposable((LPVOID)*ppShader, (LPVOID)*ppShader);
    D3D9Globals.lock->unlock();

    if (D3D9_Hooks->ShaderDumps)
    {
        PixelShader9 * px = new PixelShader9(*ppShader);
        if (px->bytes)
        {
            size       = px->bytes->GetBufferSize();
            ShaderData = px->bytes->GetBufferPointer();

            LPVOID dump = *((LPVOID*)D3D9_Hooks->ShaderDumps);
            for (i=0; i<D3D9_Hooks->ShaderDumpsSize; i++)
            {
                if (*(DWORD*)dump == size)
                {
                    if (! memcmp((LPVOID*)((DWORD)dump+4), ShaderData, size) )
                    {
                        D3D9CreatePxProxy(dev, (ID3DBlob*)D3D9_Hooks->Blobs->Value((LPVOID)(i+1)),
                                          *ppShader, FALSE);
                        break;
                    }
                }
                dump = *((LPVOID*)((DWORD)D3D9_Hooks->ShaderDumps+4*(i+1)));
            }
        }
        if (D3D9_Hooks->FixvPos)
        {
            px->Dissasemble();
            if (px->text)
            {
                D3D9Globals.lock->lock();
                ID3DBlob * blob = D3D9_Hooks->vPosFix((char*)px->text->GetBufferPointer());
                D3D9Globals.lock->unlock();
                D3D9CreatePxProxy(dev, blob, *ppShader, TRUE);
            }
        }
        delete px;
    } else if (D3D9_Hooks->FixvPos)
    {
        PixelShader9 * px = new PixelShader9(*ppShader);
        if (px->bytes)
        {
            px->Dissasemble();
            if (px->text)
            {
                D3D9Globals.lock->lock();                
                ID3DBlob * blob = D3D9_Hooks->vPosFix((char*)px->text->GetBufferPointer());
                D3D9Globals.lock->unlock();
                D3D9CreatePxProxy(dev, blob, *ppShader, TRUE);
            }
        }
        delete px;
    }
    return err;
}

HRESULT STDMETHODCALLTYPE
ReleasePixelShader9Hook(LPDIRECT3DPIXELSHADER9 shader)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
     HRESULT err = D3D9_Hooks->Release(shader);
     if (err) return err;

     D3D9Globals.lock->lock();
     LPDIRECT3DPIXELSHADER9 override =
             (LPDIRECT3DPIXELSHADER9) D3D9_Hooks->Overrides->Value(shader);
     D3D9Globals.lock->unlock();
     if (override == 0) return err;

     D3D9_Hooks->Release(override);
     D3D9Globals.lock->lock();
     D3D9_Hooks->Shaders->discard((LPVOID)shader);
     D3D9_Hooks->Overrides->discard((LPVOID)shader);
     D3D9Globals.lock->unlock();
     return err;
}

HRESULT STDMETHODCALLTYPE
SetPixelShader9HookD(LPDIRECT3DDEVICE9 dev, LPDIRECT3DPIXELSHADER9 shader)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    D3D9Globals.lock->lock();
    LPVOID override = D3D9_Hooks->Overrides->Value(shader);
    LPVOID current  = D3D9_Hooks->CurrentSelectedShader;
    D3D9Globals.lock->unlock();

    D3D9_Hooks->IsSelected     = 0;
    D3D9_Hooks->Current        = shader;
    if (D3D9_Hooks->searching_shader && (shader == current))
    {
        D3D9_Hooks->IsSelected = shader;
        err = D3D9_Hooks->SetPixelShader(dev, 0);
    }
    else if (D3D9_Hooks->enabled && (override))
    err = D3D9_Hooks->SetPixelShader(dev, (LPDIRECT3DPIXELSHADER9)override);
    else
    err = D3D9_Hooks->SetPixelShader(dev, shader);

    return err;
}

HRESULT STDMETHODCALLTYPE
SetPixelShader9Hook(LPDIRECT3DDEVICE9 dev, LPDIRECT3DPIXELSHADER9 shader)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D9_Hooks->IsSelected = 0;
    if (D3D9_Hooks->searching_shader && (shader == D3D9_Hooks->CurrentSelectedShader))
    {
        D3D9_Hooks->IsSelected = shader;
        return D3D9_Hooks->SetPixelShader(dev, 0);
    }
    return D3D9_Hooks->SetPixelShader(dev, D3D9GetPxProxy(shader));
}

HRESULT STDMETHODCALLTYPE
SetSamplerState9Hook(LPDIRECT3DDEVICE9 d, DWORD sampler, D3DSAMPLERSTATETYPE Type, DWORD Value)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if( (Type == D3DSAMP_MAXANISOTROPY)  && (D3D9_Hooks->textfilter&0xf0) )
    Value = 16;
    else if( (Type == D3DSAMP_MINFILTER) && (D3D9_Hooks->textfilter&0xf0) )
    Value = D3DTEXF_ANISOTROPIC;
    else if( (Type == D3DSAMP_MIPFILTER) && (D3D9_Hooks->textfilter&0xf0) )
    Value = D3DTEXF_LINEAR;
    else if( (Type == D3DSAMP_MAGFILTER) && (D3D9_Hooks->textfilter&0x0f) )
    Value = D3D9_Hooks->textfilter & 0x0f;

    return D3D9_Hooks->SetSamplerState(d, sampler, Type, Value);
}

void D3D9InsertTexture(LPVOID tx, TEXTSWAP9_ENTRY * data)
{
    SYNC::EasyLock lock(D3D9Globals.lock);
    D3D9_Hooks->Textures->insert(tx, data);
}

void D3D9RemoveTexture(LPVOID tx)
{
    SYNC::EasyLock lock(D3D9Globals.lock);
    D3D9_Hooks->Textures->remove(tx);
}

TEXTSWAP9_ENTRY * D3D9GetTextureData(LPVOID tx)
{
    SYNC::EasyLock lock(D3D9Globals.lock);
    return (TEXTSWAP9_ENTRY *) D3D9_Hooks->Textures->Value(tx);
}

HRESULT STDMETHODCALLTYPE
CreateTexture9Hook(LPVOID device, UINT ww, UINT hh, UINT lvls, DWORD Usage,
                   DWORD Format, DWORD Pool, LPVOID* ppTexture, HANDLE *pSharedHandle)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD usage         = Usage;
    BOOL warning        = false;
    HANDLE SharedHandle = 0;
    HRESULT err         = D3DERR_INVALIDCALL;

    if  (   (Pool == D3DPOOL_DEFAULT)   &&! (
            (Usage & (DWORD)D3DUSAGE_DEPTHSTENCIL) ||
            (Usage & (DWORD)D3DUSAGE_RENDERTARGET) ||
            (Usage & (DWORD)D3DUSAGE_DYNAMIC)      ))
    {
        if (D3D9_Hooks->force_dynamic)
        {
            err = D3D9_Hooks->pIDirect3DDevice9_CreateTexture(device, ww, hh, lvls,
                                                          D3DUSAGE_DYNAMIC,
                                                          Format, Pool, ppTexture,
                                                          pSharedHandle);
        } else
        {
            DWORD seaching = D3D9Globals.SearchingTextures->Get();
            if (seaching) usage |= D3DUSAGE_DYNAMIC;
            else warning = true;

            err = D3D9_Hooks->pIDirect3DDevice9_CreateTexture(device, ww, hh, lvls, usage,
                                                              Format, Pool, ppTexture,
                                                              pSharedHandle);
        }
    }
    else err = D3D9_Hooks->pIDirect3DDevice9_CreateTexture(device, ww, hh, lvls, usage,
                                                           Format, Pool, ppTexture,
                                                           pSharedHandle);
    if (err)
    {
        return err;
    }

    if  (!( (Usage & (DWORD)D3DUSAGE_DEPTHSTENCIL) ||
            (Usage & (DWORD)D3DUSAGE_RENDERTARGET) ||
            (Usage & (DWORD)D3DUSAGE_DYNAMIC)      ))
    {
        TEXTSWAP9_ENTRY * T9Entry = (TEXTSWAP9_ENTRY *)
        VirtualAlloc(NULL,sizeof(TEXTSWAP9_ENTRY),0x00001000|0x00002000,PAGE_READWRITE);
        ZeroMemory(T9Entry, sizeof(TEXTSWAP9_ENTRY));
        T9Entry->pTexture = *ppTexture;
        T9Entry->ww       = ww;
        T9Entry->hh       = hh;
        T9Entry->Format   = Format;
        T9Entry->type     = Usage & (DWORD)D3DUSAGE_DYNAMIC ? 4 : Pool;
        T9Entry->pData = NULL;
        T9Entry->pitch = 0;
        if ( (Format & 0x00FFFFFF) == (*(DWORD*)"DXT?" & 0x00FFFFFF))
        {
            if (Format == *(DWORD*)"DXT1") T9Entry->DXTn = 1;
            else                           T9Entry->DXTn = 2;
        }
        T9Entry->warning      = warning;
        T9Entry->SharedHandle = SharedHandle;
        D3D9InsertTexture(T9Entry->pTexture, T9Entry);
    }
    return err;
}

HRESULT STDMETHODCALLTYPE
SetTexture9Hook(LPVOID device, DWORD stage, LPVOID texture)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD seaching = D3D9Globals.SearchingTextures->Get();
    LPVOID current = D3D9Globals.CurrentTexture->Get();
    LPVOID replace = D3D9GetProxy((IDirect3DResource9*)texture);
    HRESULT err    = 0;

    if (g_d3d.DBUG)
    {
        SHORT down = GetKeyState(VK_TAB) & 0x8000 ;
        if (down)
            return D3D9_Hooks->pIDirect3DDevice9_SetTexture(device, stage, texture);
    }

    if (seaching && (texture == current))
    {
        err = D3D9_Hooks->pIDirect3DDevice9_SetTexture(device, stage, 0);
    }
    else
    {
        if (replace)
        {
            err = D3D9_Hooks->pIDirect3DDevice9_SetTexture(device, stage, replace);
        }
        else
        {
            err = D3D9_Hooks->pIDirect3DDevice9_SetTexture(device, stage, texture);
        }
    }
    return err;
}

HRESULT STDMETHODCALLTYPE
UpdateTexture9Hook(LPVOID device, LPVOID src, LPVOID dest)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPDIRECT3DTEXTURE9 replacement;
    HRESULT err = D3D9_Hooks->pIDirect3DDevice9_UpdateTexture(device, src, dest);
    if (!err)
    {
        replacement = (LPDIRECT3DTEXTURE9) D3D9GetProxy(src);
        if (replacement)
        {
            D3D9SetProxy(dest, replacement);
            replacement->AddRef();
        }
    }
    return err;
}

void RemoveTexture9(LPVOID tx)
{
    D3D9RemoveTexture(tx);

    IDirect3DTexture9 * proxy = (IDirect3DTexture9*)D3D9DiscardProxy(tx);
    if (proxy)  D3D9_Hooks->pIDirect3DTexture9_Release(proxy);
}

HRESULT STDMETHODCALLTYPE
ReleaseTexture9Hook(LPVOID texture)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT ref = D3D9_Hooks->pIDirect3DTexture9_Release(texture);
    if (ref == 0)
    {
        RemoveTexture9(texture);
    }
    return ref;
}

HRESULT STDMETHODCALLTYPE
LockTexture9RectHook(LPVOID texture, UINT Level, D3DLOCKED_RECT* pLockedRect,
                     CONST RECT* pRect, DWORD Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    err = D3D9_Hooks->pIDirect3DTexture9_LockRect(texture,Level,pLockedRect,pRect,Flags);
    if ( (err == 0) && (Level == 0))
    {
        _D3D9DiscardProxy(texture);
        if ((pRect == NULL))
        {
            TEXTSWAP9_ENTRY* t9 = D3D9GetTextureData(texture);
            if (t9)
            {
                t9->pData = pLockedRect->pBits;
                t9->pitch = pLockedRect->Pitch;
            }
        }
    }
    return err;
}

HRESULT STDMETHODCALLTYPE
UnLockTexture9RectHook(LPVOID texture, DWORD level)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    if (level == 0)
    {
        TEXTSWAP9_ENTRY* t9 = D3D9GetTextureData(texture);
        if (t9)
        {
            if (!t9->pitch)
            {
                return D3D9_Hooks->pIDirect3DTexture9_UnlockRect(texture, level);
            }
            DWORD fmt = GetD3D9SurfacePxFormat(t9->Format);
            D3D9Globals.lock->lock();
            std::string * rep
                      = g_.FindTexture(t9->ww, t9->hh, t9->pitch, (char*)&fmt, (byte*)t9->pData);
            D3D9Globals.lock->unlock();
            t9->pData = NULL;
            t9->pitch = 0;
            if (rep) D3D9LoadManagedTexture(rep->c_str(), t9->pTexture);            
            else if (D3D9_Hooks->autodump)
            {
                err = D3D9_Hooks->pIDirect3DTexture9_UnlockRect(texture, level);                
                D3D9DumpTexture((IDirect3DTexture9*)t9->pTexture, g_.NextDmp());
                D3D9Globals.lock->lock();
                g_.m_Dumps->AppendDump((char*) g_.NextDmpA());
                D3D9Globals.lock->unlock();
                return err;
            }
        }
    }
    err = D3D9_Hooks->pIDirect3DTexture9_UnlockRect(texture, level);    
    return err;
}

HRESULT STDMETHODCALLTYPE
GetSurfaceLevel9Hook(LPVOID pTexture, UINT level, LPVOID* ppSurface)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return D3D9_Hooks->pIDirect3DTexture9_GetSurfaceLevel(pTexture,level,ppSurface);
}

HRESULT STDMETHODCALLTYPE
ReleaseCubeTexture9Hook(IDirect3DCubeTexture9 * t)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD href = D3D9_Hooks->CubeTextureRelease(t);
    if (href == 0)
    {
        IDirect3DCubeTexture9 * r = (IDirect3DCubeTexture9 *)D3D9DiscardProxy(t);
        if (r)  D3D9_Hooks->CubeTextureRelease(r);
    }
    return href;
}


HRESULT STDMETHODCALLTYPE
ReleaseSurface9Hook(LPVOID pSurface)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)

    IDirect3DCubeTexture9 * t =
            (IDirect3DCubeTexture9 *)GetContainer9((IDirect3DSurface9*)pSurface, IID_IDirect3DCubeTexture9);

    if (t)
    {
        t->AddRef();
        HRESULT r = D3D9_Hooks->pIDirect3DSurface9_Release(pSurface);       
        ReleaseCubeTexture9Hook(t);
        return r;
    }  

    IDirect3DResource9 * ParentTexture =
            GetContainer9((IDirect3DSurface9 *)pSurface, IID_IDirect3DTexture9);
    if (ParentTexture)
        ParentTexture->AddRef();
    HRESULT ref = D3D9_Hooks->pIDirect3DSurface9_Release(pSurface);
    if (ref == 0)
    {
        IDirect3DSurface9 * rep = (IDirect3DSurface9 *) D3D9DiscardRenderSurfaceProxy(pSurface);
        if (rep) D3D9_Hooks->pIDirect3DSurface9_Release(rep);
    }
    if (ParentTexture)
        ReleaseTexture9Hook(ParentTexture);
    return ref;

}

HRESULT STDMETHODCALLTYPE
ReleaseRTSurface9Hook(LPVOID pSurface)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT ref = D3D9_Hooks->pIDirect3DSurface9_Release(pSurface);
    if (ref == 0)
    {
        IDirect3DSurface9 * rep = (IDirect3DSurface9 *) D3D9DiscardRenderSurfaceProxy(pSurface);
        if (rep) D3D9_Hooks->pIDirect3DSurface9_Release(rep);
    }
    return ref;
}

HRESULT STDMETHODCALLTYPE
LockManagedSurface9RectHook(LPVOID surface, D3DLOCKED_RECT* pLockedRect,
                            CONST RECT* pRect, DWORD Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    if (pRect)
    {
        D3DSURFACE_DESC D;
        IDirect3DSurface9 * srfc = (IDirect3DSurface9 *)surface;
        srfc->GetDesc(&D);
        if ( (pRect->left == 0)        && (pRect->top == 0) &&
             (pRect->right == D.Width) && (pRect->bottom == D.Height) )
        {
             pRect = NULL;
        }
    }
    err = D3D9_Hooks->pIDirect3DSurface9_LockRect(surface,pLockedRect, (LPVOID)pRect,Flags);
    if ( err == 0 && GetSurface9Index((IDirect3DSurface9 *)surface) == 0)
    {
        _D3D9DiscardProxy(GetContainer9((IDirect3DSurface9 *)surface, __uuidof(IDirect3DTexture9)));
        if (pRect == NULL)
        {
            IDirect3DSurface9 * s = (IDirect3DSurface9 *) surface;
            s->SetPrivateData((GUID&)D3D9Globals.LockedSurface,
                              (IUnknown*) new ID3D9LockedSurface(s, pLockedRect), sizeof(LPVOID), D3DSPD_IUNKNOWN);
        }
    }
    return err;
}

HRESULT STDMETHODCALLTYPE
UnLockManagedSurface9RectHook(LPVOID surface)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT                err  = 0;
    ID3D9LockedSurface * locked = nullptr;
    IDirect3DSurface9       * s = (IDirect3DSurface9 *) surface;

    DWORD size   = sizeof(LPVOID);
    IUnknown * u = nullptr;
    s->GetPrivateData((GUID&)D3D9Globals.LockedSurface, &u, &size);
    if (u)
    {
        locked = dynamic_cast<ID3D9LockedSurface *>(u);
        u->Release();
    }
    TEXTSWAP9_SURFACE * s9 = locked == nullptr ? nullptr : locked->m_s;
    if (s9)
    {
        if (!s9->pitch)
        {
            s->FreePrivateData((GUID&)D3D9Globals.LockedSurface);
            return D3D9_Hooks->pIDirect3DSurface9_UnlockRect(surface);
        }
        DWORD fmt = GetD3D9SurfacePxFormat(s9->Format);
        D3D9Globals.lock->lock();
        std::string * rep
                  = g_.FindTexture(s9->ww, s9->hh, s9->pitch, (char*)&fmt, (byte*)s9->pData);
        D3D9Globals.lock->unlock();
        s9->pData = NULL;
        s9->pitch = 0;
        if (rep) D3D9LoadManagedTexture(rep->c_str(), s9->ParentTexture);
        else if (D3D9_Hooks->autodump)
        {
            s->FreePrivateData((GUID&)D3D9Globals.LockedSurface);
            err = D3D9_Hooks->pIDirect3DSurface9_UnlockRect(surface);
            D3D9DumpTexture((IDirect3DTexture9*)s9->ParentTexture, g_.NextDmp());
            D3D9Globals.lock->lock();
            g_.m_Dumps->AppendDump((char*)g_.NextDmpA());
            D3D9Globals.lock->unlock();
            return err;
        }
    }

    s->FreePrivateData((GUID&)D3D9Globals.LockedSurface);
    err = D3D9_Hooks->pIDirect3DSurface9_UnlockRect(surface);    
    return err;
}

HRESULT STDMETHODCALLTYPE
UpdateSurface9Hook(IDirect3DDevice9* d,
                   IDirect3DSurface9 *src,  const RECT  *pSourceRect,
                   IDirect3DSurface9 *dst,  const POINT *pDestinationPoint)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = D3D9_Hooks->UpdateSurface(d, src, pSourceRect, dst, pDestinationPoint);
    // Excludes the autosave thumbnail on Half life 2
    if (hr || pSourceRect || pDestinationPoint) return hr;

    IDirect3DTexture9 * t_src = (IDirect3DTexture9 *)GetContainer9(src, __uuidof(IDirect3DTexture9));
    IDirect3DTexture9 * t_dst = (IDirect3DTexture9 *)GetContainer9(dst, __uuidof(IDirect3DTexture9));

    IDirect3DTexture9 * proxy = (LPDIRECT3DTEXTURE9) D3D9GetProxy(t_src);
    if (proxy)
    {
        D3D9SetProxy(t_dst, proxy);
        proxy->AddRef();
    }
    return 0;
}

HRESULT STDMETHODCALLTYPE
ReleaseCubeSurface9Hook(IDirect3DSurface9 * s)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirect3DCubeTexture9 * t =
            (IDirect3DCubeTexture9 *)GetContainer9(s, IID_IDirect3DCubeTexture9);

    if (t)
        t->AddRef();
    HRESULT r = D3D9_Hooks->CubeSurfaceRelease(s);
    if (t)
        ReleaseCubeTexture9Hook(t);
    return r;
}
