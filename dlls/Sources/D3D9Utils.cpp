#include <windows.h>
#include "dllmain.h"
#include "string.h"
#include "D3D9Hooks.h"

#include "D3D12Hooks.h"
#include "collections.h"
#include "Sync.h"
#include "Dbug.h"
#include "GDI_Hooks.h"
extern "C"{
#include "DDSurface.h"
}

//#define D3D9_USE_TEX_COLLECTION
#ifdef D3D9_USE_TEX_COLLECTION
LPVOID D3D9GetTexture(LPVOID proxy)
{
    //SYNC::EasyLock lock(D3D9lock);
    return D3D9_Hooks->Replacements->Key(proxy);
}

LPVOID D3D9GetProxy(LPVOID tx)
{
    //SYNC::EasyLock lock(D3D9lock);
    return D3D9_Hooks->Replacements->Value(tx);
}

LPVOID D3D9SetProxy(LPVOID tx, LPVOID proxy)
{
    //SYNC::EasyLock lock(D3D9lock);
    LPVOID old = D3D9_Hooks->Replacements->Value(tx);
    D3D9_Hooks->Replacements->insert_disposable(tx, proxy);
    return old;
}

void * D3D9DiscardProxy(void * tx)
{
    //SYNC::EasyLock lock(D3D9lock);
    LPVOID proxy = D3D9_Hooks->Replacements->Value(tx);
    D3D9_Hooks->Replacements->discard(tx);
    return proxy;
}

LPVOID _D3D9DiscardProxy(void * tx){
    return nullptr;
}
#else
LPVOID D3D9GetTexture(LPVOID proxy)
{
    if (proxy == nullptr) return nullptr;
    IDirect3DResource9 * s_proxy = (IDirect3DResource9 *) proxy;
    LPVOID               texture = nullptr;
    DWORD size = sizeof(LPVOID);
    if (s_proxy->GetPrivateData((GUID&)D3D9Globals.TexTexID, &texture, &size) != S_OK)
        DBUG_WARN("GetPrivateData FAILED");
    return texture;
}

LPVOID D3D9GetProxy(LPVOID tx)
{
    if (tx == nullptr) return nullptr;
    IDirect3DResource9 * s_tx  = (IDirect3DResource9 *) tx;
    IDirect3DResource9 * proxy = nullptr;
    DWORD size = sizeof(LPVOID);
    if (s_tx->GetPrivateData((GUID&)D3D9Globals.TexProxyID, &proxy, &size) == 0)
        proxy->Release();
    return proxy; //OUTPUT_FUNC_DBG_STRING("GetPrivateData FAILED");
    return proxy;
}

LPVOID D3D9SetProxy(LPVOID tx, LPVOID proxy)
{
    if (tx    == nullptr) return nullptr;
    if (proxy == nullptr) return nullptr;

    IDirect3DResource9 * s_tx    = (IDirect3DResource9 *) tx;
    IDirect3DResource9 * s_proxy = (IDirect3DResource9 *) proxy;

    if (s_proxy->SetPrivateData((GUID&)D3D9Globals.TexTexID, &tx, sizeof(LPVOID), 0) != S_OK)
        DBUG_WARN( "SetPrivateData FAILED" );
    if (s_tx->SetPrivateData((GUID&)D3D9Globals.TexProxyID, proxy, sizeof(LPVOID), D3DSPD_IUNKNOWN) != S_OK)
        DBUG_WARN( "SetPrivateData FAILED" );
    s_proxy->Release();
    return nullptr;
}

LPVOID D3D9DiscardProxy(void *)
{
    return 0;
}

LPVOID _D3D9DiscardProxy(void * tx)
{
    return 0;
    if (tx == nullptr) return 0;
    IUnknown           * i = (IUnknown *) tx;
    IDirect3DResource9 * r = nullptr;
    IDirect3DResource9 * proxy = nullptr;
    DWORD size = sizeof(LPVOID);
    if (i->QueryInterface(__uuidof(IDirect3DResource9), (void**)&r) == 0)
    {
        if (r->GetPrivateData((GUID&)D3D9Globals.TexProxyID, &proxy, &size) == 0)
        {
            if (r->FreePrivateData((GUID&)D3D9Globals.TexProxyID) != S_OK) DBUG_WARN( "FreePrivateData FAILED" );
            proxy->Release();
        };
    } else DBUG_WARN( "QueryInterface FAILED" );
    if (r) r->Release();
    return 0;
}
#endif

//#define D3D9_USE_SRFC_COLLECTION
#ifdef D3D9_USE_SRFC_COLLECTION
LPVOID D3D9GetRenderSurface(LPVOID proxy)
{
    SYNC::EasyLock lock(D3D9Globals.lock);
    return D3D9_Hooks->RenderSurfaces->Key(proxy);
}

LPVOID D3D9GetRenderSurfaceProxy(LPVOID tx)
{
    SYNC::EasyLock lock(D3D9Globals.lock);
    return D3D9_Hooks->RenderSurfaces->Value(tx);
}

LPVOID D3D9SetRenderSurfaceProxy(LPVOID tx, LPVOID proxy)
{
    SYNC::EasyLock lock(D3D9Globals.lock);
    LPVOID old = D3D9_Hooks->RenderSurfaces->Value(tx);
    D3D9_Hooks->RenderSurfaces->insert_disposable(tx, proxy);
    return old;
}

LPVOID D3D9DiscardRenderSurfaceProxy(void * tx)
{
    SYNC::EasyLock lock(D3D9Globals.lock);
    LPVOID proxy = D3D9_Hooks->RenderSurfaces->Value(tx);
    D3D9_Hooks->RenderSurfaces->discard(tx);
    return proxy;
}
#else
LPVOID D3D9GetRenderSurface(LPVOID proxy)
{
    using namespace std;
    if (proxy == nullptr) return nullptr;
    IDirect3DResource9 * s_proxy = (IDirect3DResource9 *) proxy;
    LPVOID               texture = nullptr;
    DWORD size                   = sizeof(LPVOID);
    HRESULT hr =  s_proxy->GetPrivateData((GUID&)D3D9Globals.SrfcSrfcID, &texture, &size);

    if      (hr == D3DERR_NOTFOUND)    DBUG_WARN(( string("D3DERR_NOTFOUND ")+to_string((LONG)s_proxy) ).c_str() )
    else if (hr == D3DERR_MOREDATA)    DBUG_WARN(( string("D3DERR_MOREDATA ")+to_string((LONG)s_proxy) ).c_str() )
    else if (hr == D3DERR_INVALIDCALL) DBUG_WARN(( string("D3DERR_INVALIDCALL ")+to_string((LONG)s_proxy) ).c_str() );
    return texture;
}

LPVOID D3D9GetRenderSurfaceProxy(LPVOID tx)
{
    // Fails on guardian of light causing a shadow bug
    using namespace std;
    if (tx == nullptr) return nullptr;

    IDirect3DResource9 * s_tx  = (IDirect3DResource9 *) tx;
    IDirect3DResource9 * proxy = nullptr;
    DWORD size                 = sizeof(void*);
    HRESULT hr = s_tx->GetPrivateData((GUID&)D3D9Globals.SrfcProxyID, &proxy, &size);

    if      (hr == 0) proxy->Release();
    else if (hr == D3DERR_NOTFOUND)    DBUG_WARN(( string("D3DERR_NOTFOUND ")+to_string((LONG)tx) ).c_str() )
    else if (hr == D3DERR_MOREDATA)    DBUG_WARN(( string("D3DERR_MOREDATA ")+to_string((LONG)tx) ).c_str() )
    else if (hr == D3DERR_INVALIDCALL) DBUG_WARN(( string("D3DERR_INVALIDCALL ")+to_string((LONG)tx) ).c_str() );
    return proxy;
}

LPVOID D3D9SetRenderSurfaceProxy(LPVOID tx, LPVOID proxy)
{
    using namespace std;
    if (tx    == nullptr) return nullptr;
    if (proxy == nullptr) return nullptr;

    IDirect3DResource9 * s_tx    = (IDirect3DResource9 *) tx;
    IDirect3DResource9 * s_proxy = (IDirect3DResource9 *) proxy;

    DBUG_WARN( (string("INSERTED ")+to_string((LONG)proxy)+" to "+to_string((LONG)tx)).c_str() );

    if (s_proxy->SetPrivateData((GUID&)D3D9Globals.SrfcSrfcID, &tx, sizeof(LPVOID), 0) != S_OK)
            DBUG_WARN( "SetPrivateData FAILED" );
    if (s_tx->SetPrivateData((GUID&)D3D9Globals.SrfcProxyID, proxy, sizeof(LPVOID), D3DSPD_IUNKNOWN) != S_OK)
            DBUG_WARN( "SetPrivateData FAILED" );
    s_proxy->Release();
    return nullptr;
}

LPVOID D3D9DiscardRenderSurfaceProxy(void * tx)
{
    using namespace std;
    //DBUG_WARN( (string("released ")+to_string((LONG)tx)).c_str()  );
    return 0;
}
#endif

PixelShader9::PixelShader9(IDirect3DPixelShader9 * px)
{
    if (px == nullptr) OutputDebugStringA("NULL POINTER");
    else
    {
        UINT size = 0;
        this->px  = px;
        px->AddRef();

        if (px->GetFunction(NULL, &size) != S_OK)
        {
            DBUG_WARN("GET SHADER SIZE FAILED");
        }

        //if ( D3DXCreateBuffer(size, &this->bytes) )
        if (g_d3d.m_D3DXCreateBuffer(size, &this->bytes) != S_OK)
        {
            DBUG_WARN("CREATE ID3DXBuffer FAILED");
        }

        else if (px->GetFunction(this->bytes->GetBufferPointer(), &size) != S_OK)
        {
            DBUG_WARN("GET SHADER DATA FAILED");
        }
    }
}

void PixelShader9::Dissasemble()
{
    if (this->px && this->bytes)
    {
        g_d3d.m_D3DXDisassembleShader((DWORD*)this->bytes->GetBufferPointer(), 0, nullptr,
                                      &this->text);
    }
}

PixelShader9::~PixelShader9()
{
    if (this->px)    this->px->Release();
    if (this->bytes) this->bytes->Release();
    if (this->text)  this->text->Release();
}

extern "C" __declspec(dllexport)
HRESULT D3D9_DrawRect(IDirect3DDevice9 * d, D3D9_RECT * r, float src[4])
{
   DWORD                blend   = 0, atest = 0, z = 0, cull = 0;
   DWORD                tindex  = 0, ttff  = 0, fog = 0;
   IDirect3DVertexShader9      * vx  = nullptr;
   IDirect3DPixelShader9       * px  = nullptr;
   IDirect3DBaseTexture9       * tx  = nullptr;
   IDirect3DVertexBuffer9      * vb  = nullptr;
   IDirect3DVertexDeclaration9 * dcl = nullptr;
   DWORD                  FVF   = 0;   
   UINT              stride, offset;

   d->GetStreamSource(0, &vb, &stride, &offset);
   d->GetVertexShader(&vx);
   d->GetPixelShader(&px);
   d->GetTexture(0, &tx);
   d->GetFVF(&FVF);
   d->GetVertexDeclaration(&dcl);
   d->GetRenderState(D3DRS_ALPHABLENDENABLE, &blend);
   d->GetRenderState(D3DRS_ALPHATESTENABLE, &atest);
   d->GetRenderState(D3DRS_ZENABLE, &z);
   d->GetRenderState(D3DRS_FOGENABLE, &fog);
   d->GetRenderState(D3DRS_CULLMODE, &cull);
   d->GetTextureStageState(0, D3DTSS_TEXCOORDINDEX, &tindex);
   d->GetTextureStageState(0, D3DTSS_TEXTURETRANSFORMFLAGS, &ttff);

   d->SetVertexShader(0);
   d->SetFVF(D3DFVF_XYZRHW | D3DFVF_TEX1);
   d->SetPixelShader(r->PixelShader);
   d->SetRenderState(D3DRS_ALPHABLENDENABLE, 0);
   d->SetRenderState(D3DRS_ALPHATESTENABLE, 0);
   d->SetRenderState(D3DRS_ZENABLE, 0);
   d->SetRenderState(D3DRS_FOGENABLE, 0);
   d->SetRenderState(D3DRS_CULLMODE, 1);
   d->SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
   d->SetTextureStageState(0, D3DTSS_TEXTURETRANSFORMFLAGS, 0);
   r->pIDirect3DDevice9_SetTexture(d, 0, r->Texture);

   float vertex[4][6] = {
       (float)r->rect.left-0.5f,  (float)r->rect.top-0.5f,    0., 1., 0., 0.,
       (float)r->rect.right-0.5f, (float)r->rect.top-0.5f,    0., 1., 1., 0.,
       (float)r->rect.right-0.5f, (float)r->rect.bottom-0.5f, 0., 1., 1., 1.,
       (float)r->rect.left-0.5f,  (float)r->rect.bottom-0.5f, 0., 1., 0., 1.,
   };

   if (src != nullptr)
   {
       vertex[0][4] = src[0];
       vertex[0][5] = src[1];
       vertex[1][4] = src[2];
       vertex[1][5] = src[1];
       vertex[2][4] = src[2];
       vertex[2][5] = src[3];
       vertex[3][4] = src[0];
       vertex[3][5] = src[3];
   }

   d->DrawPrimitiveUP(D3DPT_TRIANGLEFAN, 2, &vertex, 24);

   if (FVF) d->SetFVF(FVF);
   if (vx)  d->SetVertexShader(vx);
   if (dcl) d->SetVertexDeclaration(dcl);
   /*if (px)*/  d->SetPixelShader(px); /* Check Breaks POPSdl */
   d->SetRenderState(D3DRS_ALPHABLENDENABLE, blend);   
   d->SetRenderState(D3DRS_ALPHATESTENABLE, atest);
   d->SetRenderState(D3DRS_FOGENABLE, fog);
   d->SetRenderState(D3DRS_ZENABLE, z);
   d->SetRenderState(D3DRS_CULLMODE, cull);
   d->SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, tindex);
   d->SetTextureStageState(0, D3DTSS_TEXTURETRANSFORMFLAGS, ttff);
   r->pIDirect3DDevice9_SetTexture(d, 0, tx);

   if (vb)
   {
       d->SetStreamSource(0, vb, stride, offset);
       vb->Release();
   }
   if (vx)  vx->Release();
   if (px)  px->Release();
   if (tx)  tx->Release();
   if (dcl) dcl->Release();
   return 0;
}

void D3D9Write(IDirect3DDevice9 * dvc, RECT * r, wchar_t * text)
{
    IDirect3DTexture9 * tx  =  nullptr;
    IDirect3DTexture9 * sys =  nullptr;
    D3DLOCKED_RECT               lrect;
    DWORD   Width = r->right - r->left;
    DWORD  Height = r->bottom - r->top;

    if (dvc->CreateTexture(Width, Height, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_DEFAULT, &tx, nullptr) != S_OK)
    return DBUG_WARN("IDirect3DDevice9::CreateTexture FAILED");

    if (dvc->CreateTexture(Width, Height, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_SYSTEMMEM, &sys, nullptr) != S_OK)
    return DBUG_WARN("IDirect3DDevice9::CreateTexture (D3DPOOL_SYSTEMMEM) FAILED");

    if (sys->LockRect(0, &lrect, NULL, 0) != S_OK)
    return DBUG_WARN("IDirect3DTexture9::LockRect FAILED");

    GDIText gdi(r, lrect.pBits, text, __FUNCTION__);
    sys->UnlockRect(0);
    dvc->UpdateTexture(sys, tx);
    float uv[4] = {0.,1.,1.,1-((float)gdi.m_height/Height)};

    D3D9RECT R(gdi.AlignTop(), tx, &D3D9_Hooks->rct);
    D3D9_DrawRect(dvc, &R.m_r9, uv);
    tx->Release();
    sys->Release();
}

void D3D9DumpTexture(IDirect3DTexture9 * pTex, LPCWSTR file)
{
    D3DSURFACE_DESC desc;
    D3DLOCKED_RECT  rect;
    static char * fmt;
    if (pTex->GetLevelDesc(0, &desc))
        return OutputDebugString(L"Failed to get level desc");

    if      (desc.Format == D3DFMT_A8R8G8B8) fmt = "A8RGB";
    else if (desc.Format == D3DFMT_X8R8G8B8) fmt = "X8RGB";
    else if (desc.Format == D3DFMT_X1R5G5B5) fmt = "X1RGB";
    else if (desc.Format == D3DFMT_A1R5G5B5) fmt = "A1RGB";
    else if (desc.Format == D3DFMT_A4R4G4B4) fmt = "A4RGB";
    else if (desc.Format == D3DFMT_R5G6B5)   fmt = "RG6B";
    else if (desc.Format == *(DWORD*)"DXT1") fmt = "DXT1";
    else if (desc.Format == *(DWORD*)"DXT2") fmt = "DXT2";
    else if (desc.Format == *(DWORD*)"DXT3") fmt = "DXT3";
    else if (desc.Format == *(DWORD*)"DXT4") fmt = "DXT4";
    else if (desc.Format == *(DWORD*)"DXT5") fmt = "DXT5";
    else return DBUG_WARN("Unknown or unsupported format");

    if ( (desc.Pool == D3DPOOL_SYSTEMMEM) || (desc.Pool == D3DPOOL_SCRATCH) ||
         (desc.Pool == D3DPOOL_MANAGED))
    {
        if (!D3D9_Hooks->autodump)
            return DBUG_WARN("No point in dumping a system memory texture");
        if (D3D9_Hooks->pIDirect3DTexture9_LockRect(pTex, 0, &rect, NULL, 0))
            return DBUG_WARN("Could not lock texture");
        DumpDDS((wchar_t*)file, fmt, desc.Width, desc.Height, rect.pBits, rect.Pitch);
        D3D9_Hooks->pIDirect3DTexture9_UnlockRect(pTex, 0);
        return ;
    }
    else if (desc.Pool == D3DPOOL_DEFAULT)
    {
        if (desc.Usage & D3DUSAGE_DYNAMIC)
        {
              if (pTex->LockRect(0, &rect, NULL, 0))
              return DBUG_WARN("Could not lock texture");
              DumpDDS((wchar_t*)file, fmt, desc.Width, desc.Height, rect.pBits, rect.Pitch);
              pTex->UnlockRect(0);
              return;
        }
        else return DBUG_WARN("Vid mem textures must be dynamic");
    }
    return ;
}

void D3D9DumpShader(IDirect3DDevice9 *, IDirect3DPixelShader9 * pShader)
{
    PixelShader9 * px = new PixelShader9(pShader);
    px->Dissasemble();
    if (px->text == nullptr)
    {
        DBUG_WARN("PixelShader9 CLASS ERROR");
        delete px;
        return;
    }

    HANDLE hFile = 0;
    hFile = CreateFileW(D3D9_Hooks->ShaderDumpPath,
                        GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
                        CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE)
    {
        DBUG_WARN("CREATE BIN FILE FAILED");
        delete px;
        return;
    }

    DWORD writen  = 0;
    DWORD success = 0;
    success = WriteFile(hFile, px->bytes->GetBufferPointer(), px->bytes->GetBufferSize(),
                        &writen, NULL);
    CloseHandle(hFile);
    if ( !success  )
    {
        DBUG_WARN("WRITE TO BIN FILE FAILED");
        delete px;
        return ;
    }

    hFile = INVALID_HANDLE_VALUE;
    hFile = CreateFileW(D3D9_Hooks->ShadertxtDumpPath,
                        GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
                        CREATE_NEW, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (hFile == INVALID_HANDLE_VALUE)
    {
        DBUG_WARN("CREATE TXT FILE FAILED");
        delete px;
        return ;
    }

    writen  = 0;
    success = 0;
    success = WriteFile(hFile, px->text->GetBufferPointer(),
                        px->text->GetBufferSize(), &writen, nullptr);
    CloseHandle(hFile);
    delete px;
    if ( !success  )  DBUG_WARN("WRITE TO TXT FILE FAILED");
}

D3DSURFACE_DESC * FindSurfaceSize(IDirect3DSurface9 * s)
{
    static D3DSURFACE_DESC D;
    char buff[100];
    DWORD w, h;

    ZeroMemory(&D, sizeof(D3DSURFACE_DESC));
    s->GetDesc(&D);

    w         = D.Width;
    h         = D.Height;
    D.Height *= D3D9_Hooks->scale;
    D.Width  *= D3D9_Hooks->scale;

    snprintf(buff, sizeof(buff), "%s%u%s%u%s%u%s%u%s%u",
             "Surface size", w      , "x", h,
             "..."         , D.Width, "x", D.Height, "  ", s);
    OutputDebugStringA(buff);
    return &D;
}

IDirect3DResource9 * GetContainer9(IDirect3DSurface9 * s, REFIID id)
{
   IDirect3DResource9 * container = 0;
   if ( s->GetContainer(id, (void **)&container) == 0)
   {
       container->Release();
       return container;
   }
   return 0;
}

int GetSurface9Index(IDirect3DSurface9 * s)
{
    IDirect3DSurface9 * lvl = 0;
    IDirect3DTexture9 * t   =
            (IDirect3DTexture9 *) GetContainer9(s, IID_IDirect3DTexture9);
    if (!t)
    {
        OutputDebugStringA("UNABLE TO FIND 2D CONTAINER WHEN SEARCHING SURFACE INDEX");
        return -1;
    }
    for (DWORD i=0; i<t->GetLevelCount(); i++)
    {
        if ( (t->GetSurfaceLevel(i, &lvl)) == 0 ) lvl->Release();
        if (lvl == s) return i;
        lvl = 0;
    }
    return -1;
}

UINT GetFaceAndLevel9(IDirect3DSurface9 * s, UINT* face, UINT* lvl)
{
    IDirect3DCubeTexture9 * t   =
            (IDirect3DCubeTexture9 *) GetContainer9(s, IID_IDirect3DCubeTexture9);
    if (!t)
    {
        OutputDebugStringA("UNABLE TO FIND CUBE CONTAINER WHEN SEARCHING SURFACE");
        return -1;
    }
    IDirect3DSurface9 * srfc = 0;    
    for (UINT i=0; i<8; i++)
    {
        for (DWORD ii=0; ii<t->GetLevelCount(); ii++)
        {
            if ( (t->GetCubeMapSurface((D3DCUBEMAP_FACES)i, ii, &srfc)) == 0 )
            srfc->Release();
            if (srfc == s)
            {
                *face = i;
                *lvl  = ii;
                return (UINT) s;
            }
        }
    }
    return 0;
}

BOOL ProxyCheck9(UINT w, UINT h, D3DFORMAT, UINT)
{
    if (D3D9_Hooks->POW2Fix)
    {
        if ( !(w & (w-1)) && !(h & (h-1)) )
            return 0;
    }
    return 1;

    /* Betrayer needs this check if we only wan't
     * to alow surfaces with the backbufffer size
     */
    UINT ww = D3D9_Hooks->W;
    UINT hh = D3D9_Hooks->H;
    while(ww % 8) ww +=1;
    while(hh % 8) hh +=1;
    while(w  % 8)  w +=1;
    while(h  % 8)  h +=1;
    if   (w == ww && h == hh)  return 1;
    return 0;
}

DWORD GetD3D9SurfacePxFormat(DWORD fmt)
{
    if      (fmt == D3DFMT_A8R8G8B8) return *(DWORD*) "A8RGB";
    else if (fmt == D3DFMT_X8R8G8B8) return *(DWORD*) "X8RGB";
    else if (fmt == D3DFMT_X1R5G5B5) return *(DWORD*) "X1RGB";
    else if (fmt == D3DFMT_A1R5G5B5) return *(DWORD*) "A1RGB";
    else if (fmt == D3DFMT_A4R4G4B4) return *(DWORD*) "A4RGB";
    else if (fmt == D3DFMT_R5G6B5)   return *(DWORD*) "RG6B";
    else if (fmt == *(DWORD*)"DXT1") return *(DWORD*) "DXT1";
    else if (fmt == *(DWORD*)"DXT2") return *(DWORD*) "DXT2";
    else if (fmt == *(DWORD*)"DXT3") return *(DWORD*) "DXT3";
    else if (fmt == *(DWORD*)"DXT4") return *(DWORD*) "DXT4";
    else if (fmt == *(DWORD*)"DXT5") return *(DWORD*) "DXT5";
    return *(DWORD*) "?????";
}

void D3D9LoadManagedTexture(const char* file, LPVOID Original)
{
    char              fmt[20];
    HANDLE            hFile;
    DWORD             magic, read, w, h, levels;
    BOOL              b;
    DDS_HEADER        DDS_Header;
    D3DFORMAT         Fmt;
    DWORD             bytes_per_pixel;
    IDirect3DTexture9 * pTex;
    IDirect3DTexture9 * pSys = 0;
    D3DLOCKED_RECT    rct;
    LPVOID            old;

    hFile = CreateFileA(file, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
                        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE)
    {
        hFile = CreateFileA(g_.m_FallBackTextureReplacement.c_str(), GENERIC_READ,
                            FILE_SHARE_READ | FILE_SHARE_WRITE,
                            NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
        if (hFile == INVALID_HANDLE_VALUE) return DBUG_WARN("Can't open file");
    }

    b = ReadFile(hFile, &magic, 4, &read, NULL);
    if ( (!b) || (magic != 0x20534444) )
    {
        CloseHandle(hFile);
        return DBUG_WARN("BadFile");
    }

    b = ReadFile(hFile, &DDS_Header, sizeof(DDS_HEADER), &read, NULL);
    GetDDSFileFormat(&DDS_Header, fmt);
    DBUG_WARN(fmt);
    if      ( *(DWORD*)fmt == *(DWORD*)"A8RGB" ) Fmt = D3DFMT_A8R8G8B8;
    else if ( *(DWORD*)fmt == *(DWORD*)"X8RGB" ) Fmt = D3DFMT_X8R8G8B8;
    else if ( *(DWORD*)fmt == *(DWORD*)"X1RGB" ) Fmt = D3DFMT_X1R5G5B5;
    else if ( *(DWORD*)fmt == *(DWORD*)"A1RGB" ) Fmt = D3DFMT_A1R5G5B5;
    else if ( *(DWORD*)fmt == *(DWORD*)"A4RGB" ) Fmt = D3DFMT_A4R4G4B4;
    else if ( *(DWORD*)fmt == *(DWORD*)"RG6B"  ) Fmt = D3DFMT_R5G6B5;
    else if (*(DWORD*)fmt == *(DWORD*)"DXT1") Fmt = (D3DFORMAT)MAKEFOURCC('D','X','T','1');
    else if (*(DWORD*)fmt == *(DWORD*)"DXT2") Fmt = (D3DFORMAT)MAKEFOURCC('D','X','T','2');
    else if (*(DWORD*)fmt == *(DWORD*)"DXT3") Fmt = (D3DFORMAT)MAKEFOURCC('D','X','T','3');
    else if (*(DWORD*)fmt == *(DWORD*)"DXT4") Fmt = (D3DFORMAT)MAKEFOURCC('D','X','T','4');
    else if (*(DWORD*)fmt == *(DWORD*)"DXT5") Fmt = (D3DFORMAT)MAKEFOURCC('D','X','T','5');
    else
    {
         CloseHandle(hFile);
         return OutputDebugStringA("Unknown or unsupported format");
    }

    levels = (DDS_Header.dwMipMapCount) ? DDS_Header.dwMipMapCount : 1;
    if (D3D9_Hooks->pIDirect3DDevice9_CreateTexture(
                D3D9_Hooks->Dev9, DDS_Header.dwWidth, DDS_Header.dwHeight,
                levels, 0, Fmt, D3DPOOL_MANAGED, (LPVOID*)&pTex, NULL))
    {
        if (D3D9_Hooks->pIDirect3DDevice9_CreateTexture(
                    D3D9_Hooks->Dev9, DDS_Header.dwWidth, DDS_Header.dwHeight,
                    levels, 0, Fmt, D3DPOOL_DEFAULT, (LPVOID*)&pTex, NULL))
        {
            CloseHandle(hFile);
            return DBUG_WARN("Failed to create texture");
        }
        if (D3D9_Hooks->pIDirect3DDevice9_CreateTexture(
                    D3D9_Hooks->Dev9, DDS_Header.dwWidth, DDS_Header.dwHeight,
                    levels, 0, Fmt, D3DPOOL_SYSTEMMEM, (LPVOID*)&pSys, NULL))
        {
            CloseHandle(hFile);
            D3D9_Hooks->pIDirect3DTexture9_Release(pTex);
            return DBUG_WARN("Failed to create sysmem texture");
        }
    }

    w = DDS_Header.dwWidth;
    if ( *(BYTE*)fmt == *(BYTE*)"D" )
    {
        bytes_per_pixel = *(DWORD*)fmt == *(DWORD*)"DXT1" ? 2 : 4;
        h = (DDS_Header.dwHeight + 3) / 4;
    } else {
        bytes_per_pixel = DDS_Header.ddspf.dwRGBBitCount/8;
        h = DDS_Header.dwHeight;
    }

    if (!pSys)
    {
        for (DWORD i = 0; i<levels; i++)
        {
            if (D3D9_Hooks->pIDirect3DTexture9_LockRect(pTex, i, &rct, NULL, 0))
            {
                D3D9_Hooks->pIDirect3DTexture9_Release(pTex);
                CloseHandle(hFile);
                return DBUG_WARN("Failed to lock texture");
            }
            LoadData2Surface(rct.pBits, (DWORD)hFile, rct.Pitch, w, h, bytes_per_pixel);
            D3D9_Hooks->pIDirect3DTexture9_UnlockRect(pTex, i);
            w /= 2;
            h /= 2;
        }
    }
    else
    {
        for (DWORD i = 0; i<levels; i++)
        {
            if (D3D9_Hooks->pIDirect3DTexture9_LockRect(pSys, i, &rct, NULL, 0))
            {
                D3D9_Hooks->pIDirect3DTexture9_Release(pSys);
                CloseHandle(hFile);
                return DBUG_WARN("Failed to lock texture");
            }
            LoadData2Surface(rct.pBits, (DWORD)hFile, rct.Pitch, w, h, bytes_per_pixel);
            D3D9_Hooks->pIDirect3DTexture9_UnlockRect(pSys, i);
            w /= 2;
            h /= 2;
        }
        IDirect3DDevice9 * parent;
        if (pSys->GetDevice(&parent)) OutputDebugStringA("No parent device");
        else  D3D9_Hooks->pIDirect3DDevice9_UpdateTexture(parent, pSys ,pTex);
        D3D9_Hooks->pIDirect3DTexture9_Release(pSys);
    }

    old = D3D9SetProxy(Original, pTex);
    if (old) D3D9_Hooks->pIDirect3DTexture9_Release(old);
    CloseHandle(hFile);
    return;
}


extern "C" __declspec(dllexport) LPVOID CreateD3D9Interfaces(HWND h_win, ID3DBlob * pBlob) {    
    static struct {
        const char             *    err;
        IDirect3D9             *   d3d9;
        IDirect3D9Ex           * d3d9ex;
        IDirect3DDevice9       *   dvc9;
        IDirect3DDevice9Ex     * dvcex9;
        IDirect3DSwapChain9    *    sc9;
        IDirect3DSurface9      *  surf9;
        IDirect3DTexture9      *   tex9;
        IDirect3DSurface9      * csurf9;
        IDirect3DCubeTexture9  *  ctex9;
        IDirect3DVertexBuffer9 *    vb9;
        IDirect3DPixelShader9  *    ps9;
        IDirect3DStateBlock9   *    sb9;
    } d3d9   = {0};
    d3d9.err = "S_OK";

    auto h_d3d9         = LoadLibraryA("d3d9.dll");   
    auto p_D3D9ExCreate = (HRESULT(__stdcall *)(UINT, IDirect3D9Ex**))GetProcAddress(h_d3d9, "Direct3DCreate9Ex");

    if (FAILED(p_D3D9ExCreate(D3D_SDK_VERSION, &d3d9.d3d9ex))) {
        d3d9.err = "Direct3DCreate9Ex FAILED";
        return &d3d9;
    }

    if (FAILED(d3d9.d3d9ex->QueryInterface(IID_IDirect3D9, (void**)&d3d9.d3d9))) {
        d3d9.err = "QueryInterface IID_IDirect3D9 FAILED";
        return &d3d9;
    }

    D3DPRESENT_PARAMETERS pp;
    pp.BackBufferWidth            = 630;
    pp.BackBufferHeight           = 480;
    pp.BackBufferFormat           = D3DFMT_UNKNOWN;
    pp.BackBufferCount            = 1;
    pp.MultiSampleType            = D3DMULTISAMPLE_NONE;
    pp.MultiSampleQuality         = 0;
    pp.SwapEffect                 = D3DSWAPEFFECT_COPY;;
    pp.hDeviceWindow              = h_win;
    pp.Windowed                   = TRUE;
    pp.EnableAutoDepthStencil     = FALSE;
    pp.AutoDepthStencilFormat     = D3DFMT_D16;
    pp.Flags                      = 0;
    pp.FullScreen_RefreshRateInHz = 0;
    pp.PresentationInterval       = 0;
    if (FAILED(d3d9.d3d9ex->CreateDeviceEx(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, h_win,
        D3DCREATE_HARDWARE_VERTEXPROCESSING, &pp, nullptr, &d3d9.dvcex9))) {
        d3d9.err = "CreateDeviceEx FAILED";
        return &d3d9;
    }           

    if (FAILED(d3d9.dvcex9->QueryInterface(IID_IDirect3DDevice9, (void**)&d3d9.dvc9))) {
        d3d9.err = "QueryInterface IID_IDirect3DDevice9 FAILED";
        return &d3d9;
    }

    if (FAILED(d3d9.dvc9->CreateVertexBuffer(1024, 0, 0, D3DPOOL_DEFAULT, &d3d9.vb9, nullptr))) {
        d3d9.err = "CreateVertexBuffer FAILED";
        return &d3d9;
    }

    if (FAILED(d3d9.dvc9->CreatePixelShader(static_cast<const DWORD*>(pBlob->GetBufferPointer()), &d3d9.ps9))) {
        d3d9.err = "CreatePixelShader FAILED";
        return &d3d9;
    }

    if (FAILED(d3d9.dvc9->CreateStateBlock(D3DSBT_ALL, &d3d9.sb9))) {
        d3d9.err = "CreateStateBlock FAILED";
        return &d3d9;
    }

    if (FAILED(d3d9.dvc9->CreateTexture(256, 256, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_DEFAULT, &d3d9.tex9, nullptr))) {
        d3d9.err = "CreateTexture FAILED";
        return &d3d9;
    }

    if (FAILED(d3d9.tex9->GetSurfaceLevel(0, &d3d9.surf9))) {
        d3d9.err = "GetSurfaceLevel FAILED";
        return &d3d9;
    }

    if (FAILED(d3d9.dvc9->CreateCubeTexture(256, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_DEFAULT, &d3d9.ctex9, nullptr))) {
        d3d9.err = "CreateCubeTexture FAILED";
        return &d3d9;
    }

    if (FAILED(d3d9.ctex9->GetCubeMapSurface(D3DCUBEMAP_FACE_POSITIVE_X, 0, &d3d9.csurf9))) {
        d3d9.err = "GetCubeMapSurface FAILED";
        return &d3d9;
    }
    
    if (FAILED(d3d9.dvc9->GetSwapChain(0, &d3d9.sc9))) {
        d3d9.err = "CreateSwapChain FAILED";
        return &d3d9;
    }
  
    return &d3d9;
}