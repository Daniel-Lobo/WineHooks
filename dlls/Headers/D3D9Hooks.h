#ifndef D3D9HOOKS
#define D3D9HOOKS
#include <windows.h>
#include "collections.h"
#include "Sync.h"

#include <d3d9.h>
#include "Dbug.h"
#include <d3dcommon.h>

struct D3D9_GLOBALS {
    D3DVIEWPORT9  SDViewPort9, HDViewPort9;
    RECT          SDScissor,     HDScissor;
    SYNC::Atomic                   * HDSet;
    SYNC::AtomicLock                * lock;
    IID                         *TexProxyID;
    IID                           *TexTexID;
    IID                        *SrfcProxyID;
    IID                         *SrfcSrfcID;
    IID                      *LockedSurface;
    POINTER_DICTIONARY              *Blocks;
    POINTER_DICTIONARY         *GameModules;

    SYNC::Atomic    * SearchingTextures;
    SYNC::Atomic    * ScreenSpace;
    SYNC::AtomicPtr * CurrentTexture;
    SYNC::AtomicPtr * VertexShader;    
    volatile LPDIRECT3DSURFACE9 g_last_zbuffer;
    HRESULT(__stdcall *ProcessVertices)(IDirect3DDevice9*,UINT,UINT,UINT,IDirect3DVertexBuffer9*,IDirect3DVertexDeclaration9*,DWORD);
};

typedef struct _TEXTSWAP9_ENTRY {
    LPVOID pTexture;
    DWORD  ww;
    DWORD  hh;
    DWORD  type;
    DWORD  Format;
    LPVOID pData;
    DWORD  pitch;
    DWORD  bypp;
    BOOL   DXTn;
    LPVOID level0;
    BOOL   warning;
    HANDLE SharedHandle;
}TEXTSWAP9_ENTRY;

typedef struct _TEXTSWAP9_SURFACE {
    LPVOID pSurface;
    LPVOID ParentTexture;
    DWORD  ww;
    DWORD  hh;
    DWORD  type;
    DWORD  Format;
    LPVOID pData;
    DWORD  pitch;
    DWORD  bypp;
    BOOL   DXTn;
    LPVOID level0;
}TEXTSWAP9_SURFACE;

typedef struct _D3D9_RECT{
    IDirect3DTexture9     * Texture;
    IDirect3DPixelShader9 * PixelShader;
    RECT                    rect;
    HRESULT (__stdcall    *pIDirect3DDevice9_SetTexture)(LPVOID, DWORD, LPVOID);
    HRESULT (__stdcall    *pShaderRelease)(LPVOID);
} D3D9_RECT;

class D3D9RECT {
public:
    D3D9RECT(const RECT * r, IDirect3DTexture9 * tx, D3D9_RECT * r9){
        memcpy(&m_r9, r9, sizeof(D3D9_RECT));
        memcpy(&m_r9.rect, r, sizeof(RECT));
        m_r9.Texture = tx;
    }
    D3D9_RECT m_r9;
};

typedef struct _SHADEROVERRIDE9_DATA {
    HRESULT (__stdcall *CreatePixelShader)(LPDIRECT3DDEVICE9, const DWORD, LPDIRECT3DPIXELSHADER9*);
    HRESULT (__stdcall *SetPixelShader)(LPDIRECT3DDEVICE9, LPDIRECT3DPIXELSHADER9);
    HRESULT (__stdcall *GetFunction)(LPDIRECT3DPIXELSHADER9, void *, UINT *);
    HRESULT (__stdcall *Release)(LPDIRECT3DPIXELSHADER9);
    VOID (__stdcall *pShaderFound)(DWORD, LPVOID, DWORD, DWORD);
    LPDIRECT3DPIXELSHADER9 Override;
    BOOL    ignore_shader_release;
    BOOL    searching_shader;
    BOOL    enabled;
    LPVOID  IsSelected;
    LPVOID  CurrentSelectedShader;
    LPVOID  Current;
    POINTER_DICTIONARY *Shaders;
    POINTER_DICTIONARY *Overrides;
    DWORD  ShaderDumpsSize;
    LPVOID ShaderDumps;
}SHADEROVERRIDE9_DATA;

typedef struct _TARGETS9 {
    LPDIRECT3DSURFACE9 current_zbuffer, current_render_target;
    LPDIRECT3DSURFACE9 proxy_zbuffer, proxy_render_target;
    D3DVIEWPORT9 current_vw, new_vw;
}TARGETS9;

typedef struct _D3D9_HOOKS {
    IDirect3DDevice9 * ahkdevice;
    DWORD sdk_version;
    DWORD BLNK;
    DWORD AdjustTexelSize;
    DWORD W, H, HD_W, HD_H, HD_X;
    RECT HDRect;
    float scale;
    HRESULT (__stdcall * GetDisplayMode)(IDirect3DDevice9*, UINT iSwapChain, D3DDISPLAYMODE *pMode);
    BOOL (__stdcall * GetMonitorInfoA) (HMONITOR, LPMONITORINFO);
    int  (__stdcall * GetSystemMetrics)(int);
    IDirect3DPixelShader9 * XBR;
    HRESULT (__stdcall * SetFVF)(IDirect3DDevice9*, DWORD);
    HRESULT (__stdcall * SetVertexShader)(IDirect3DDevice9*, IDirect3DVertexShader9 *pShader);
    HRESULT (__stdcall * SetVertexDeclaration)(IDirect3DDevice9*, IDirect3DVertexDeclaration9 *);
    HRESULT (__stdcall * SetStreamSource)(IDirect3DDevice9*, UINT, IDirect3DVertexBuffer9 *,UINT,UINT Stride);
    HRESULT (__stdcall * EndStateBlock)(IDirect3DDevice9*, IDirect3DStateBlock9**);
    HRESULT (__stdcall * ApplyStateBlock)(IDirect3DStateBlock9*);
    HRESULT (__stdcall * ReleaseStateBlock)(IDirect3DStateBlock9*);
    HRESULT (__stdcall * CreateVertexBuffer)(IDirect3DDevice9*,UINT,DWORD,DWORD,D3DPOOL,
                                             IDirect3DVertexBuffer9**, HANDLE *);
    HRESULT (__stdcall * CreateIndexBuffer)(IDirect3DDevice9*, UINT, DWORD, D3DFORMAT, D3DPOOL,
                                            IDirect3DIndexBuffer9 **, HANDLE *);
    HRESULT (__stdcall * CreateTexture)(IDirect3DDevice9*, UINT, UINT, UINT, DWORD,
                                        D3DFORMAT, D3DPOOL, IDirect3DTexture9**, HANDLE*);
    HRESULT (__stdcall * CreateCubeTexture)(IDirect3DDevice9*, UINT, UINT, DWORD, D3DFORMAT,
                                            D3DPOOL, IDirect3DCubeTexture9 **, HANDLE *);
    HRESULT (__stdcall * CreateRenderTarget)(IDirect3DDevice9*, UINT, UINT, D3DFORMAT,
                         D3DMULTISAMPLE_TYPE, DWORD, BOOL, IDirect3DSurface9 **, HANDLE *);
    HRESULT (__stdcall * CreateDepthStencilSurface)(IDirect3DDevice9*, UINT, UINT, D3DFORMAT,
                         D3DMULTISAMPLE_TYPE, DWORD, BOOL, IDirect3DSurface9 **, HANDLE *);
    HRESULT (__stdcall * DrawPrimitive)(IDirect3DDevice9*, D3DPRIMITIVETYPE, UINT, UINT);
    HRESULT (__stdcall * DrawIndexedPrimitive)(IDirect3DDevice9*, D3DPRIMITIVETYPE,
      INT, UINT, UINT, UINT, UINT);
    HRESULT (__stdcall * DrawPrimitiveUP)(IDirect3DDevice9*, D3DPRIMITIVETYPE, UINT,
                                          const void *, UINT);
    HRESULT (__stdcall * DrawIndexedPrimitiveUP)(IDirect3DDevice9*, D3DPRIMITIVETYPE, UINT, UINT,
                                                 UINT, const void*, D3DFORMAT, const void*, UINT);
    HRESULT (__stdcall * ColorFill)(IDirect3DDevice9*, IDirect3DSurface9*, const RECT*, D3DCOLOR);
    HRESULT (__stdcall * Clear)(IDirect3DDevice9*, DWORD,const D3DRECT*,
                                DWORD, D3DCOLOR, float, DWORD);    
    HRESULT (__stdcall * StretchRect)(IDirect3DDevice9*, IDirect3DSurface9*, const RECT*,
        IDirect3DSurface9*, const RECT*, D3DTEXTUREFILTERTYPE);
    HRESULT (__stdcall * Present)(IDirect3DDevice9*, const RECT*, const RECT*, HWND,
                                  const RGNDATA*);
    HRESULT (__stdcall * SetView)(IDirect3DDevice9*, D3DVIEWPORT9 *);
    HRESULT (__stdcall * GetView)(IDirect3DDevice9*, D3DVIEWPORT9 *);
    HRESULT (__stdcall * SetScissorRect)(IDirect3DDevice9*, RECT *);
    HRESULT (__stdcall * GetScissorRect)(IDirect3DDevice9*, RECT *);
    HRESULT (__stdcall * GetRTData)(IDirect3DDevice9*, IDirect3DSurface9*, IDirect3DSurface9*);
    HRESULT (__stdcall * GetSurfaceDesc)(IDirect3DSurface9 *, D3DSURFACE_DESC *);
    HRESULT (__stdcall * GetRenderTargetDesc)(IDirect3DSurface9 *, D3DSURFACE_DESC *);
    HRESULT (__stdcall * GetBackBuffer)(IDirect3DDevice9*, UINT,UINT,D3DBACKBUFFER_TYPE,
                                        IDirect3DSurface9**);
    HRESULT (__stdcall * GetDepthStencilSurface)(IDirect3DDevice9*, IDirect3DSurface9 **);
    HRESULT (__stdcall * SetDepthStencilSurface)(IDirect3DDevice9*, IDirect3DSurface9 *);
    HRESULT (__stdcall * GetRenderTarget)(IDirect3DDevice9*, UINT, IDirect3DSurface9 **);
    HRESULT (__stdcall * SetRenderTarget)(IDirect3DDevice9*, UINT, IDirect3DSurface9 *);
    HRESULT (__stdcall * RenderTargetLock)(LPVOID, LPVOID, LPVOID, DWORD);
    HRESULT (__stdcall * RenderTargetUnLock)(LPVOID);
    HRESULT (__stdcall * UpdateHDSurface)(IDirect3DDevice9*,IDirect3DSurface9*,const RECT*,IDirect3DSurface9*,const POINT*);
    HRESULT (__stdcall * UpdateTexture)(IDirect3DDevice9*,IDirect3DBaseTexture9*,IDirect3DBaseTexture9*);
    IDirect3DSurface9  * HDSurface, *HDZSurface, *SDSurface, *SDZSurface, *HlfSurface;
    POINTER_DICTIONARY * RenderSurfaces;
    LPVOID vertices;
    BOOL POW2Fix;
    BOOL FixvPos;
    //ID3DXBuffer * (__stdcall *vPosFix)(char *);
    ID3DBlob * (__stdcall *vPosFix)(char *);
    DWORD textfilter;
    HRESULT (__stdcall *SetSamplerState)(IDirect3DDevice9*,DWORD,D3DSAMPLERSTATETYPE,DWORD);
    HRESULT (__stdcall *p_EndScene)(IDirect3DDevice9 *);
    HRESULT (__stdcall *p_EndSceneCalback)(IDirect3DDevice9 *);    
    LPVOID     font;
    RECT       frct;
    LPCWSTR    text;
    DWORD      clr;
    D3D9_RECT  rct;
    LPCWSTR    dump;
    HRESULT (__stdcall *pIDirect3DDevice9_CreateTexture)(LPVOID,UINT,UINT,UINT,DWORD,DWORD,DWORD,
                                                         LPVOID*,HANDLE*);
    HRESULT (__stdcall *pIDirect3DDevice9_UpdateTexture)(LPVOID, LPVOID, LPVOID);
    HRESULT (__stdcall *UpdateSurface)(IDirect3DDevice9 *,
                                       IDirect3DSurface9*, const RECT*,
                                       IDirect3DSurface9*, const POINT*);
    HRESULT (__stdcall *pIDirect3DDevice9_StretchRect)(LPVOID, LPVOID,LPVOID,UINT,LPVOID,UINT);
    HRESULT (__stdcall *pIDirect3DDevice9_SetTexture)(LPVOID, DWORD, LPVOID);
    HRESULT (__stdcall *pIDirect3DTexture9_GetSurfaceLevel)(LPVOID, UINT, LPVOID*);
    HRESULT (__stdcall *pIDirect3DTexture9_LockRect)(LPVOID, UINT, D3DLOCKED_RECT*, CONST RECT*, DWORD);
    HRESULT (__stdcall *pIDirect3DTexture9_UnlockRect)(LPVOID, UINT);
    HRESULT (__stdcall *pIDirect3DTexture9_QueryInterface)(LPVOID, REFIID, LPVOID*);
    HRESULT (__stdcall *pIDirect3DTexture9_Release)(LPVOID);
    HRESULT (__stdcall *pIDirect3DSurface9_LockRect)(LPVOID, LPVOID, LPVOID, DWORD);
    HRESULT (__stdcall *pIDirect3DSurface9_UnlockRect)(LPVOID);
    HRESULT (__stdcall *pIDirect3DSurface9_Release)(LPVOID);
    HRESULT (__stdcall *__RenderTargetRelease)(LPVOID);
    HRESULT (__stdcall *CubeTextureRelease)(IDirect3DCubeTexture9*);
    HRESULT (__stdcall *CubeSurfaceRelease)(IDirect3DSurface9*);
    HRESULT (__stdcall *pTextureFound)(DWORD, LPVOID);
    DWORD   autodump;
    BOOL    force_dynamic;
    BOOL    threadsafe;
    BOOL    ignore_release;
    BOOL    searching;
    LPVOID  CurrentTexture;
    POINTER_DICTIONARY *Textures;
    POINTER_DICTIONARY *Surfaces;
    POINTER_DICTIONARY *Replacements;    
    POINTER_DICTIONARY *Paths;
    IDirect3DDevice9   *Dev9;
    HRESULT (__stdcall *CreatePixelShader)(LPDIRECT3DDEVICE9, const DWORD*, LPDIRECT3DPIXELSHADER9*);
    HRESULT (__stdcall *SetPixelShader)(LPDIRECT3DDEVICE9, LPDIRECT3DPIXELSHADER9);
    HRESULT (__stdcall *GetFunction)(LPDIRECT3DPIXELSHADER9, void *, UINT *);
    HRESULT (__stdcall *Release)(LPDIRECT3DPIXELSHADER9);
    VOID (__stdcall *pShaderFound)(DWORD, LPVOID, DWORD, DWORD);
    LPDIRECT3DPIXELSHADER9 Override;
    BOOL    ignore_shader_release;
    BOOL    searching_shader;
    BOOL    enabled;
    LPVOID  IsSelected;
    LPVOID  CurrentSelectedShader;
    LPVOID  Current;
    POINTER_DICTIONARY *Shaders;
    POINTER_DICTIONARY *Overrides;
    POINTER_DICTIONARY *Blobs;
    DWORD  ShaderDumpsSize;
    LPVOID ShaderDumps;
    LPCTSTR ShaderDumpPath;
    LPCTSTR ShadertxtDumpPath;
}D3D9_HOOKS;
extern D3D9_HOOKS * D3D9_Hooks;

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE CreateTexture9Hook(LPVOID, UINT, UINT, UINT, DWORD, DWORD, DWORD, LPVOID*, HANDLE *);
extern IDirect3DResource9 * GetContainer9(IDirect3DSurface9 * s, REFIID id);
extern void D3D9DumpTexture(IDirect3DTexture9 * pTex, LPCWSTR file);

extern void * D3D9GetProxy(void * tx);
extern void * D3D9SetProxy(void * tx, void * proxy);
extern void * _D3D9DiscardProxy(void * tx);
extern void * D3D9DiscardProxy(void * tx);
extern LPVOID D3D9GetTexture(LPVOID proxy);
extern LPVOID D3D9GetRenderSurface(LPVOID proxy);
extern LPVOID D3D9GetRenderSurfaceProxy(LPVOID tx);
extern LPVOID D3D9SetRenderSurfaceProxy(LPVOID tx, LPVOID proxy);
extern LPVOID D3D9DiscardRenderSurfaceProxy(void * tx);
extern IDirect3DResource9 * GetContainer9(IDirect3DSurface9 * s, REFIID id);
extern "C" HRESULT D3D9_DrawRect(IDirect3DDevice9 *, D3D9_RECT *, float src[4]);
extern void D3D9DumpTexture(IDirect3DTexture9 *, LPCWSTR);
extern void D3D9DumpShader(IDirect3DDevice9 *, IDirect3DPixelShader9 *);
extern BOOL ProxyCheck9(UINT, UINT, D3DFORMAT, UINT);
extern int GetSurface9Index(IDirect3DSurface9 *);
extern UINT GetFaceAndLevel9(IDirect3DSurface9 *, UINT*, UINT*);
extern void D3D9LoadManagedTexture(const char*, LPVOID);
extern DWORD GetD3D9SurfacePxFormat(DWORD);
extern void D3D9Write(IDirect3DDevice9 *, RECT *, wchar_t *);
extern D3D9_GLOBALS D3D9Globals;
extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE ProcessVertices9Hook(IDirect3DDevice9*, UINT, UINT, UINT, IDirect3DVertexBuffer9*, IDirect3DVertexDeclaration9*, DWORD);


class PixelShader9 {
    public:
    PixelShader9(IDirect3DPixelShader9 * px);
    ~PixelShader9();
    void Dissasemble();

    ID3DBlob * bytes        = nullptr;
    ID3DBlob * text         = nullptr;
    IDirect3DPixelShader9 * px = nullptr;
};

class ID3D9LockedSurface : public virtual IUnknown {
public:
    virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID, void**)
    {
        return E_NOINTERFACE;
    }
    virtual ULONG STDMETHODCALLTYPE AddRef()
    {
        m_ref += 1;
        return m_ref;
    }
    virtual ULONG STDMETHODCALLTYPE Release()
    {
        m_ref    -= 1;
        ULONG ref = m_ref;
        if (m_ref == 0) delete this;
        return ref;
    }
    virtual ~ID3D9LockedSurface(){delete m_s;}
    ID3D9LockedSurface(IDirect3DSurface9 * s, D3DLOCKED_RECT * r)
    {
        m_s = new TEXTSWAP9_SURFACE();
        IDirect3DTexture9 * parent = (IDirect3DTexture9 *)GetContainer9(s, __uuidof(IDirect3DTexture9*));
        if (parent == nullptr)
        {
            OUTPUT_FUNC_DBG_STRING("NOT A 2D TEXTURE");
            return;
        }
        D3DSURFACE_DESC desc;
        parent->GetLevelDesc(0, &desc);
        m_s->ParentTexture = parent;
        m_s->hh            = desc.Height;
        m_s->ww            = desc.Width;
        m_s->Format        = desc.Format;
        m_s->pitch         = r->Pitch;
        m_s->pData         = r->pBits;
        if ( (m_s->Format & 0x00FFFFFF) == (*(DWORD*)"DXT?" & 0x00FFFFFF))
        {
            if (m_s->Format == *(DWORD*)"DXT1") m_s->DXTn = 1;
            else                                m_s->DXTn = 2;
        }
    }
    DWORD             m_ref = 0;
    TEXTSWAP9_SURFACE * m_s = nullptr;
};

#endif // D3D9HOOK

