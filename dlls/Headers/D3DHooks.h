#ifndef D3DHOOKS
#define D3DHOOKS

#ifdef __cplusplus
#include "collections.h"
#include "dllmain.h"
#include "Dbug.h"
#include "LayersCommon.h"
#include "DirectDraw.h"
#include <vector>
#include <map>
extern "C" POINTER_DICTIONARY *locks;
extern "C" DWORD lastcore;
DWORD GetDDSrfacePxFormat(IUnknown*);
#define DDLOCK() if (D3DHooksData->ThreadSafe) SetThreadAffinityMask(GetCurrentThread(), lastcore);

class DDrawSurfaceData : public virtual IUnknown
{
public:
    HRESULT STDMETHODCALLTYPE QueryInterface(REFIID, void**)
    {
        return E_NOINTERFACE;
    }
    ULONG STDMETHODCALLTYPE AddRef()
    {
        m_ref += 1;
        return m_ref;
    }
    ULONG STDMETHODCALLTYPE Release()
    {
        m_ref    -= 1;
        ULONG ref = m_ref;
        if (m_ref == 0)
        {
            delete this;
        }
        return ref;
    }
    DDrawSurfaceData(IUnknown*s){m_Surface=s;}
    int          m_ref =       0;
    IUnknown * m_Surface = nullptr;
};
#endif // __cplusplus

typedef struct _TLVERTEX {
    float x;
    float y;
    float z;
    float rhw;
    int color;
    int specular;
    float u;
    float v;
}TLVERTEX;

typedef struct _XYZRHW {
    float x;
    float y;
    float z;
    float rhw;
}XYZRHW;

typedef struct _VIEWPORT7{
    DWORD       dwX;
    DWORD       dwY;
    DWORD       dwWidth;
    DWORD       dwHeight;
    float    dvMinZ;
    float    dvMaxZ;
} VIEWPORT7;

typedef struct _VIEWPORT3 {
    DWORD       dwSize;
    DWORD       dwX;
    DWORD       dwY;
    DWORD       dwWidth;
    DWORD       dwHeight;
    float       dvClipX;
    float       dvClipY;
    float       dvClipWidth;
    float       dvClipHeight;
    float       dvMinZ;
    float       dvMaxZ;
}VIEWPORT3 ;

typedef struct _D3DHOOKS_DATA {
    // Config, used to change flags used to create surfaces
    BOOL HD;
    BOOL _32Bit;
    BOOL NEFS;
    DWORD W;
    DWORD H;
    DWORD Requested_Depth;
    BOOL  ThreadSafe;
    DWORD zmask;
    // D3D hooks and data used to scale vertices
    // DDraw hooks and data used to emulate blts
    // and locks on Flip,RT and primary surfaces
    LPVOID D3D7DrawPrimtive;
    HRESULT (STDMETHODCALLTYPE * Execute)
        (LPVOID, DWORD, DWORD, LPVOID);
    HRESULT (STDMETHODCALLTYPE * D3D3DrawPrimitive)
            (LPVOID, DWORD, DWORD, LPVOID, DWORD, DWORD);
    HRESULT (STDMETHODCALLTYPE * D3D3DrawIndexedPrimitive)
    (LPVOID, DWORD, DWORD, LPVOID, DWORD, LPWORD, DWORD, DWORD);
    union  {
    HRESULT (STDMETHODCALLTYPE * pIDirect3DDevice2_DrawPrimitive)
            (LPVOID, DWORD, DWORD, LPVOID, DWORD, DWORD);
    HRESULT (STDMETHODCALLTYPE * IDirect3DDevice3_DrawPrimitive)
            (LPVOID, DWORD, DWORD, LPVOID, DWORD, DWORD);
    HRESULT (STDMETHODCALLTYPE * pIDirect3DDevice7_DrawPrimitive)
            (LPVOID,DWORD, DWORD, LPVOID, DWORD, DWORD);
    };
    union  {
        HRESULT (STDMETHODCALLTYPE *  pIDirect3DDevice3_DrawPrimitiveVB)
                (LPVOID, DWORD, LPVOID, DWORD, DWORD, DWORD);        
        HRESULT (STDMETHODCALLTYPE *  pIDirect3DDevice7_DrawPrimitiveVB)
                (LPVOID, LPVOID, LPVOID, DWORD, DWORD, DWORD);
    };
    union  {
        HRESULT (STDMETHODCALLTYPE * pIDirect3DDevice3_DrawIndexedPrimitive)
                (LPVOID, DWORD, DWORD, LPVOID, DWORD, LPWORD, DWORD, DWORD);
    };
    union  {
        HRESULT (STDMETHODCALLTYPE * pIDirect3DDevice3_DrawIndexedPrimitiveVB)
        (LPVOID, DWORD, LPVOID, LPWORD, DWORD, DWORD);
        HRESULT (STDMETHODCALLTYPE * pIDirect3DDevice7_DrawIndexedPrimitiveVB)
        (LPVOID, DWORD, LPVOID, DWORD, DWORD, LPWORD, DWORD, DWORD);
    };
    union  {
        HRESULT (STDMETHODCALLTYPE * pIDirect3DVertexBuffer_GetDesc)
                (LPVOID, LPVOID);
        HRESULT (STDMETHODCALLTYPE * pIDirect3DVertexBuffer7_GetVertexBufferDesc)
                (LPVOID, LPVOID);
    };
    union  {
        HRESULT (STDMETHODCALLTYPE * pIDirect3DVertexBuffer_Lock)
                (LPVOID, DWORD, LPVOID*, LPDWORD);
        HRESULT (STDMETHODCALLTYPE * pIDirect3DVertexBuffer7_Lock)
                (LPVOID, DWORD, LPVOID, LPDWORD);
    };
    union  {
        HRESULT (STDMETHODCALLTYPE * pIDirect3DVertexBuffer_UnLock)(LPVOID);
        HRESULT (STDMETHODCALLTYPE * pIDirect3DVertexBuffer7_UnLock)(LPVOID);
    };
    union  {
    HRESULT (STDMETHODCALLTYPE * pIDirect3DViewport3_TransformVertices)
    (LPVOID, LPVOID, LPVOID, LPVOID, LPVOID);
    };
    HRESULT (WINAPI *GetView)(void *, VIEWPORT3*);
    HRESULT (WINAPI *SetView)(void *, VIEWPORT3*);
    HRESULT (__stdcall *QueryPrimary)(LPVOID, REFIID, LPVOID*);
    HRESULT (__stdcall *QuerySurface)(LPVOID, REFIID, LPVOID*);
    HRESULT (__stdcall *QueryTexture)(LPVOID, REFIID, LPVOID*);
    HRESULT (__stdcall *QueryDevice)(LPVOID, REFIID, LPVOID*);
    HRESULT (STDMETHODCALLTYPE * Flip)(LPVOID, LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * LockPrimary)(LPVOID, LPVOID, LPVOID, LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * UnLockPrimary)(LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * UnLockPrimary4)(LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * LockSurface)(LPVOID, LPVOID, LPVOID, LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * UnLockSurface)(LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * UnLockSurface4)(LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * BltPrimary)(LPVOID, LPVOID, LPVOID, LPVOID, LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * BltSurface)(LPVOID, LPVOID, LPVOID, LPVOID, LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * BltFastPrimary)(LPVOID, LPVOID, LPVOID, LPVOID, LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * BltFastSurface)(LPVOID, LPVOID, LPVOID, LPVOID, LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * GetDCPrimary)(LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * GetDCSurface)(LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * ReleaseDCPrimary)(LPVOID, LPVOID);
    HRESULT (STDMETHODCALLTYPE * ReleaseDCSurface)(LPVOID, LPVOID);
    LPVOID vextex_data;
    DWORD DelayRTUpdates;
    HRESULT (__stdcall * UPdateRT)();
    //BOOL  scale;
    float scale_delta;
    BOOL  displace;
    float displacement;
    BOOL  vert_displace;
    float vert_displacement;
    BOOL callback;
    union  {
        int (__stdcall * vertexTransformCallback2)
            (LPVOID, DWORD, LPVOID);
        int (__stdcall * vertexTransformCallback3)
            (LPVOID, DWORD, DWORD, LPVOID);
    };
    BOOL fix_screencoords;
    DWORD    Rqstd_w;
    DWORD    Rqstd_h;
    RECT   * LockedRect;
    RECT   * _LockedRect;
    VIEWPORT3 * VW3;
    // NEFS
    HRESULT (__stdcall *IDDSrfcGetAttachedSrfc)(LPVOID, DWORD, DWORD);
    HRESULT (__stdcall *AHK_IDDSrfcGetAttachedSrfc)(LPVOID, DWORD, DWORD);
    HRESULT (__stdcall *IDDSrfc4GetAttachedSrfc)(LPVOID, DWORD, DWORD);
    HRESULT (__stdcall *AHK_IDDSrfc4GetAttachedSrfc)(LPVOID, DWORD, DWORD);
    // Texture swap
    HRESULT (__stdcall *pIDirect3DDevice2_SetRenderState)(LPVOID, DWORD, DWORD);
    DWORD   (__stdcall *ID3DDevice2_SetRenderState_Callback)(LPVOID, DWORD);
    HRESULT (__stdcall *pIDirect3DDevice3_SetTexture)(LPVOID, DWORD, DWORD);
    DWORD   (__stdcall *ID3DDevice3_SetTexture_Callback)(DWORD);    
    HRESULT (__stdcall * Direct3DDevice7_SetTexture)(LPVOID, DWORD, DWORD);
    DWORD   (__stdcall * ID3DDevice7_SetTexture_Callback)(DWORD);
    HRESULT (__stdcall * IDirectDrawSurace_Lock)(LPVOID, LPRECT, LPVOID, DWORD, HANDLE);
    HRESULT (__stdcall * IDirectDrawSurace_UnLock)(LPVOID, LPRECT);
    HRESULT (__stdcall * IDirectDrawSurace4_UnLock)(LPVOID, LPRECT);
    HRESULT (__stdcall * Surface_Found)(LPVOID ,DWORD);
    HRESULT (__stdcall * SwapBack)(DWORD);
#ifdef __cplusplus
    POINTER_DICTIONARY *textures;
    POINTER_DICTIONARY *found;
    POINTER_DICTIONARY *replacements;
    POINTER_DICTIONARY *hTex;
#else
    LPVOID textures;
    LPVOID found;
    LPVOID replacements;
    LPVOID hTex;
#endif
    BOOL                search_enabled;
    DWORD               current_texture;
    BOOL                ignore_release;
    DWORD               check_vid_mem_locks;
    HRESULT (__stdcall *pIDirectDrawSurface_QueryInterface)(LPVOID, GUID*, LPVOID*);
    union {
    HRESULT (__stdcall *pIDirect3DTexture_QueryInterface)(LPVOID, GUID*, LPVOID*);
    HRESULT (__stdcall *pDirect3DTexture_QueryInterface)(LPVOID, REFIID, LPVOID*);
    };
    union {
    HRESULT (__stdcall *pIDirect3DTexture2_QueryInterface)(LPVOID, GUID*, LPVOID*);
    HRESULT (__stdcall *pDirect3DTexture2_QueryInterface)(LPVOID, REFIID, LPVOID*);
    };
    HRESULT (__stdcall * GetDDSCaps)(LPVOID, LPVOID);
    HRESULT (__stdcall * IDirectDrawSurface_GetDesc)(LPVOID, LPVOID);
    HRESULT (__stdcall * TswapExecute)(LPVOID, DWORD, DWORD, LPVOID);
    BOOL Check;
    HRESULT (__stdcall * IDirectDraw_GetCaps)(LPVOID, LPVOID, LPVOID);    
    UINT    (__stdcall * DumpAndAppend)(IUnknown*, IUnknown*);
    // Manage IDirectDrawSurface4 locks
    HRESULT (__stdcall * Manager_Lock)(LPVOID, LPRECT, LPVOID, DWORD, HANDLE);
    HRESULT (__stdcall * D_Lock)(LPVOID, LPRECT, LPVOID, DWORD, HANDLE);
    HRESULT (__stdcall * Manager_UnLock)(LPVOID, LPRECT);
    HRESULT (__stdcall * D_UnLock)(LPVOID, LPRECT);
    HRESULT (__stdcall * Manager_Blt)(LPVOID, DWORD, LPVOID, DWORD, DWORD, DWORD);
#ifdef __cplusplus
    POINTER_DICTIONARY * Manager_sysmem_surfaces;
#else
    LPVOID Manager_sysmem_surfaces;
#endif
    void (__stdcall* LooseSurface)(LPVOID) ;
}D3DHOOKS_DATA ;
#ifdef __cplusplus
    extern "C" D3DHOOKS_DATA * D3DHooksData;
#else
    extern D3DHOOKS_DATA * D3DHooksData;
#endif

#ifdef __cplusplus
class D3DGLOBALS {
public:
    std::vector<IUnknown*> Delayed_Release_Textures;
    UINT GetCount()  {return Surfaces.size();};
    UINT GetIndex()  {return this->index;    };
    void InsertSurface(DirectDrawSurface*);
    void RemoveSurface(DirectDrawSurface*);
    void InsertHandle(D3DTEXTUREHANDLE, DirectDrawSurface*);
    void RemoveHandle(D3DTEXTUREHANDLE);
    DirectDrawSurface* GetSurfaceFromHandle(D3DTEXTUREHANDLE h) {
        if (this->Handles.count(h) == 1) return this->Handles[h];
        return nullptr;
    }
    DirectDrawSurface* GetCurrentSurface() {
        return this->index < this->GetCount() ? this->Surfaces[this->index] : nullptr;
    }
    void Next() {this->index += 1; this->AdjustIndex();};
    void Prev() {this->index -= 1; this->AdjustIndex();};
private:
    UINT                                            index = 0;
    std::vector<DirectDrawSurface*>                  Surfaces;  
    std::map<D3DTEXTUREHANDLE, DirectDrawSurface*>    Handles;
    void AdjustIndex() {
        if      (((int)this->index) < 0)                  {this->index = this->GetCount() - 1;}
        else if (this->index        > this->GetCount()-1) {this->index = 0;}
    }
};
extern D3DGLOBALS D3DGlobals;
#endif

typedef struct _DEVICE3_STATES {
  DWORD  coordindex;
  DWORD  zbuff;
  DWORD  zwrite;
  DWORD  ablend;
  DWORD  clr_op;
  DWORD  clr_op1;
  DWORD  clr_arg;
  DWORD  alpha_op;
  DWORD  alpha_op1;
  DWORD  alpha_arg;
  DWORD  fogenabled;
  DWORD  cullmode;
  DWORD  clrkey;
  DWORD  magfilter;
  DWORD  minfilter;
  LPVOID Texture;
}DEVICE3_STATES;

typedef struct _DEVICE7_RECT {
    void *   Device7;
    void *   RenderTarget;
    HRESULT (WINAPI *BeginScene)(void *);
    HRESULT (WINAPI *EndScene)(void *);
    LPVOID dummy;
    LPVOID dummyb;
    HRESULT (WINAPI *GetView)(void *, VIEWPORT7 *);
    HRESULT (WINAPI *SetView)(void *, VIEWPORT7 *);
    LPVOID dummyc;
    HRESULT (WINAPI *DrawPrimitive) (void *, DWORD, DWORD, LPVOID, DWORD, DWORD);
    HRESULT (WINAPI *SetRenderState) (void *, DWORD, DWORD);
    HRESULT (WINAPI *GetRenderState) (void *, DWORD, DWORD *);
    HRESULT (WINAPI *SetTexture)(void *, DWORD, LPVOID);
    HRESULT (WINAPI *GetTexture)(void *, DWORD, LPVOID*);
    HRESULT (WINAPI *SetTextureStageState)(void *, DWORD, DWORD, DWORD);
    HRESULT (WINAPI *GetTextureStageState)(void *, DWORD, DWORD, DWORD*);
    HRESULT (WINAPI *ReleaseTexture)(void *);
    LPVOID Texture;
} DEVICE7_RECT;

typedef struct _DEVICE3_RECT {
  void *   Device3;
  void *   RenderTarget;
  HRESULT (WINAPI *BeginScene)(void *);
  HRESULT (WINAPI *EndScene)(void *);
  HRESULT (WINAPI *GetCurrentViewport)(void *, void **);
  HRESULT (WINAPI *ReleaseViewport)(void *);
  HRESULT (WINAPI *GetView)(void *, VIEWPORT3*);
  HRESULT (WINAPI *SetView)(void *, VIEWPORT3*);
  HRESULT (WINAPI *ClearView)(void *, DWORD, RECT*, DWORD, DWORD, float, float);
  HRESULT (WINAPI *DrawPrimitive) (void *, DWORD, DWORD, LPVOID, DWORD, DWORD);
  HRESULT (WINAPI *SetRenderState) (void *, DWORD, DWORD);
  HRESULT (WINAPI *GetRenderState) (void *, DWORD, DWORD *);
  HRESULT (WINAPI *SetTexture)(void *, DWORD, LPVOID);
  HRESULT (WINAPI *GetTexture)(void *, DWORD, LPVOID*);
  HRESULT (WINAPI *SetTextureStageState)(void *, DWORD, DWORD, DWORD);
  HRESULT (WINAPI *GetTextureStageState)(void *, DWORD, DWORD, DWORD*);
  HRESULT (WINAPI *ReleaseTexture)(void *);
  LPVOID Texture;
} DEVICE3_RECT;

typedef struct _DEVICE2_RECT {
   void *   Device2;
   HRESULT (WINAPI *BeginScene)(void *);
   HRESULT (WINAPI *EndScene)(void *);
   HRESULT (WINAPI *DrawPrimitive) (void *, DWORD, DWORD, LPVOID, DWORD, DWORD);
   HRESULT (WINAPI *SetRenderState) (void *, DWORD, DWORD);
   HRESULT (WINAPI *GetRenderState) (void *, DWORD, DWORD*);
   DWORD Texture;
 } DEVICE2_RECT;

#define  DIRECTDRAW_VERSION 0x0700
#define  DIRECT3D_VERSION 0x0700
#include "d3d.h"

#ifdef __cplusplus
class D3DViewportScaler {
public:
    D3DViewportScaler(IDirect3DViewport* viewport) {        
        if (viewport == nullptr) return;                
        m_iview = viewport;
        m_iview->AddRef();
        if (viewport->GetViewport(&m_oldview) != S_OK) {
            DBUG_WARN("GetViewport FAILED") return;
        }
        D3DVIEWPORT new_view ; 
        memcpy((void*)&new_view, (void*)&m_oldview, sizeof(D3DVIEWPORT));
        new_view.dwY      *= D3DHooksData->scale_delta;
        new_view.dwX      *= D3DHooksData->scale_delta;
        new_view.dwX      += D3DHooksData->displacement;
        new_view.dwWidth  *= D3DHooksData->scale_delta;
        new_view.dwHeight *= D3DHooksData->scale_delta;
        new_view.dvScaleX *= D3DHooksData->scale_delta;
        new_view.dvScaleY *= D3DHooksData->scale_delta;
        new_view.dvMaxX   *= D3DHooksData->scale_delta;
        new_view.dvMaxY   *= D3DHooksData->scale_delta;
        m_failed = m_iview->SetViewport(&new_view);
    };
    ~D3DViewportScaler() {
        if (m_failed == 0) {
            m_iview->SetViewport(&m_oldview);
        }        
        if (m_iview != nullptr) m_iview->Release();
    }
private:       
    IDirect3DViewport  * m_iview  = nullptr;
    D3DVIEWPORT         m_oldview = {sizeof(D3DVIEWPORT)};
    HRESULT m_failed  = 1;
};

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE DDFromTexture(IUnknown*);
extern "C" __declspec(dllexport) BOOL SetDDSurfacePixelFormat(DDPIXELFORMAT*, char*);
unique_ptr<wstring> DescribeDDSrfcPixelFormat(DDS_PIXELFORMAT*);

#endif // __cplusplus

#endif // D3DHOOKS

