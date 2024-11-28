#ifndef DIRECTDRAW_H
#define DIRECTDRAW_H
#define __uuidof(IDirectDraw) IID_IDirectDraw
#define __uuidof(DirectDraw2) IID_IDirectDraw2
#define __uuidof(DirectDraw4) IID_IDirectDraw4
#include "LayersCommon.h"
#define  DIRECTDRAW_VERSION 0x0700
#define  DIRECT3D_VERSION 0x0700
#define  DIRECTDRAW_VERSION 0x0700
#undef _D3DCOLORVALUE
#undef D3DCOLORVALUE
#include <ddraw.h>
#include <d3d.h>
#include <dllmain.h>
#include <string>
#include <map>
#include "Direct3D.h"
#include <memory>
#include "Wine.Hooks.h"
using std::string;
using std::to_string;

#undef  LAYER_THIS
#define LAYER_THIS IDirectDrawPalette
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDrawPalette

enum class DIRECTDRAW_ID {DDRAW, CLIPPER, PALETTE, D3DDEVICE, SURFACE};
enum class DD_FOR        {WHATEVER, LOCKING, UNLOCKING, BLITING_TO, BIND_AS_TEXTURE};
enum class DD_SRFC_TYPE  {GENERIC, MIPMAP_SUBLVL};

#define DDRAW_SEPARATE_REF_COUNTS
//#define DDRAW_MINIMAL_LAYER

class DirectDrawPalette : public PrivateDataObjectParent
{
public:
    virtual ~DirectDrawPalette() {};    
    DirectDrawPalette(IDirectDrawPalette* pPalette);
    IDirectDrawPalette* GetImp() {
        return m_Imp;
    }
    COMPtr* GetPalette() {
        return &m_palette;
    }
private:
    IDirectDrawPalette    * m_Imp = nullptr;
    COMPtr              m_palette = {};
};

#undef  LAYER_THIS
#define LAYER_THIS IDirectDrawClipper
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDrawClipper

class DirectDrawClipper : public PrivateDataObjectParent
{
public:
    virtual ~DirectDrawClipper() {};    
    DirectDrawClipper(IDirectDrawClipper* pClipper);
    IDirectDrawClipper* GetImp() {
        return m_Imp;
    }
    COMPtr* GetClipper(){
        return &m_cliper;
    }
private:
    IDirectDrawClipper * m_Imp = nullptr;
    COMPtr            m_cliper = {};
};

class DirectDraw: public PrivateDataObjectParent
{
public:
    virtual ~DirectDraw() {};
    DirectDraw(IUnknown*, DWORD);
    IUnknown     * GetImp()    { return m_Imp;     }
    IDirectDraw2 * GetImp2()   { return m_Imp2;    }    
    COMPtr  * GetDirectDraw1() { return &m_dd;     }
    COMPtr  * GetDirectDraw2() { return &m_dd2;    }   
    COMPtr  * GetDirectDraw4() { return &m_dd4;    }
    COMPtr  * GetDirectDraw7() { return &m_dd7;    }
    COMPtr  * GetDirect3D1()   { return &m_d3d;    }
    COMPtr  * GetDirect3D2()   { return &m_d3d2;   }
    COMPtr  * GetDirect3D3()   { return &m_d3d3;   }
    COMPtr  * GetDirect3D7()   { return &m_d3d7;   }
    LONG SetRef(LONG ref)      { m_ref = ref; CheckREf(); return ref;}
    LONG SetRef2(LONG ref)     {
        m_ref2 = ref;   
        if (ref == 0) { m_Imp2 = nullptr; }
        CheckREf();
        return ref;
    }
    void CheckREf() {
       if (m_ref2 == 0 && m_ref == 0) delete this;
    }
    COMPtr* SetDD2(IDirectDraw2* dd2) { m_Imp2 = dd2; return &m_dd2; }   
private:
    DWORD                 version = 1;
    IUnknown             * m_Imp  = nullptr;
    IDirectDraw2         * m_Imp2 = nullptr;
    LONG                   m_ref  = 0; 
    LONG                   m_ref2 = 0;    
    COMPtr  m_dd = {}, m_dd2 = {}, m_dd4 = {}, m_dd7 = {}, m_d3d = {}, m_d3d2 = {}, m_d3d3 = {}, m_d3d7 = {};;
};

typedef struct DDrawLock {
    LPVOID lpSurface;
    UINT   lPitch;
};

class DirectDrawSurface : public PrivateDataObject
{
public:
    virtual ~DirectDrawSurface();
    void SetPrivateDataInterface(IUnknown*);
    DirectDrawSurface(DirectDraw* dd, IUnknown*, DWORD);
    void DiscardReplacmenet() {
        if (m_Replacement == nullptr) return;
        m_Replacement->Release();
        m_Replacement = nullptr;
        m_rep_handle  = 0;
    }
    void DiscardSysMem() {
        if (m_SysMem == nullptr) return;
        m_SysMem->Release();
        m_SysMem = nullptr;        
    }
    D3DTEXTUREHANDLE Gethandle(IDirect3DDevice2*);
    D3DTEXTUREHANDLE Gethandle(IDirect3DDevice*);
    void Sethandle(D3DTEXTUREHANDLE h);
    void SetReplacement(IUnknown*rep)  {if (rep == nullptr) return; m_Replacement = rep; m_Replacement->AddRef();};
    IUnknown* GetReplacement()         {return m_Replacement;};
    IUnknown* GetImp(DD_FOR For = DD_FOR::WHATEVER);
    COMPtr* GetDirectDrawSurface1() { return &m_ddsrfc;  }
    COMPtr* GetDirectDrawSurface2() { return &m_ddsrfc2; }
    COMPtr* GetDirectDrawSurface3() { return &m_ddsrfc3; }
    COMPtr* GetDirectDrawSurface4() { return &m_ddsrfc4; }
    COMPtr* GetDirectDrawSurface7() { return &m_ddsrfc7; }
    COMPtr* GetDirect3DTexture()    { return &m_tex;     }
    COMPtr* GetDirect3DTexture2()   { return &m_tex2;    }
    D3DPtr* GetDevice()             { return &m_dvc;     }

    void SetType(D3DDEVICETYPE type) {m_type = type;}
    D3DDEVICETYPE GetType()          {return m_type;}
    const GUID&   GetDeviceGUID(){
        if      (m_type == D3DDEVICETYPE::HAL)  return IID_IDirect3DHALDevice;
        else if (m_type == D3DDEVICETYPE::RGB)  return IID_IDirect3DRGBDevice;
        else if (m_type == D3DDEVICETYPE::MMX)  return IID_IDirect3DMMXDevice;
        else if (m_type == D3DDEVICETYPE::RAMP) return IID_IDirect3DRampDevice;
    }    
    BOOL HasViewport(IUnknown* view) {
        auto view_id = EZInterface(IID_IUnknown, view).I();
        auto ezLock  = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
        return m_views.find(view_id) == m_views.end() ? FALSE : TRUE;
    }
    void __PrivateDeleteViewPort(IUnknown* view) {
        if (HasViewport(view) == FALSE) {
            DBUG_WARN("Light is not on viewport lights list")
            return;
        }
        auto view_id = EZInterface(IID_IUnknown, view).I();
        auto ezLock  = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
        m_views.erase(view_id);
    }
    void __PrivateAddViewPort(IUnknown* iview, Direct3DViewPort* view) {
        if (HasViewport(iview) == TRUE) {
            DBUG_WARN("Light is already on the viewport lights list")
            return;
        }
        auto view_id = EZInterface(IID_IUnknown, iview).I();
        auto ezLock  = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
        m_views[view_id] = view;
    }
    Direct3DViewPort* GetViewPort(IUnknown* iview) {
        auto ezLock = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
        auto view   = m_views[iview];
        return view;
    };
    unique_ptr<DDSCAPS2>GetCaps() {
        auto caps = unique_ptr<DDSCAPS2>(new DDSCAPS2());        
        auto srfc = (IDirectDrawSurface7*)EZInterface(IID_IDirectDrawSurface7, m_Imp).I();
        if (srfc == nullptr) return caps;
        srfc->GetCaps(caps.get());
        return caps;
    }
    unique_ptr<DDSURFACEDESC2>GetDesc() {
        auto desc          = unique_ptr<DDSURFACEDESC2>(new DDSURFACEDESC2());
        desc.get()->dwSize = sizeof(DDSURFACEDESC2);
        auto srfc          = (IDirectDrawSurface7*)EZInterface(IID_IDirectDrawSurface7, GetImp()).I();
        if (srfc == nullptr) return desc;
        srfc->GetSurfaceDesc(desc.get());
        return desc;
    }
    unique_ptr<wstring>Describe();
    void SetLastLock(LPVOID pSurfaceData, UINT lPitch) { 
        if (this->GetCaps().get()->dwCaps & DDSCAPS_VIDEOMEMORY) return;
        m_last_lock = pSurfaceData; m_last_pitch = lPitch;
    };
    unique_ptr<DDrawLock> GetlastLock() {
        if (m_last_lock == nullptr) return nullptr;
        auto lockdata       = new DDrawLock();
        lockdata->lpSurface = m_last_lock;
        lockdata->lPitch    = m_last_pitch;
        this->SetLastLock(nullptr, 0);
        return unique_ptr<DDrawLock>(lockdata);
    }   
    void UpdateVidMem() {
        if (m_SysMem == nullptr) {
            return;
        }
        DDBLTFX fx  = {sizeof(DDBLTFX)};
        auto src_ez = EZInterface(IID_IDirectDrawSurface, m_SysMem);
        auto dst_ez = EZInterface(IID_IDirectDrawSurface, m_Imp);
        ((IDirectDrawSurface*)dst_ez.I())->Blt(nullptr, (IDirectDrawSurface*)src_ez.I(), nullptr, DDBLT_WAIT, &fx);
    }
    void UpdateSysMem() {
        if (m_SysMem == nullptr) {
            return;
        }
        DDBLTFX fx  = {sizeof(DDBLTFX)};
        auto src_ez = EZInterface(IID_IDirectDrawSurface, m_Imp);
        auto dst_ez = EZInterface(IID_IDirectDrawSurface, m_SysMem);
        ((IDirectDrawSurface*)dst_ez.I())->Blt(nullptr, (IDirectDrawSurface*)src_ez.I(), nullptr, DDBLT_WAIT, &fx);
    }
//private:
    std::map<IUnknown*, Direct3DViewPort*> m_views;
    SYNC::AtomicLock * m_lock      = nullptr; 
    BOOL m_IsA8                    = 0;
    D3DPtr  m_dvc                  = {};
    DWORD   version                = 1;
    IUnknown* m_Imp                = nullptr; 
    IUnknown* m_Replacement        = nullptr;
    IUnknown* m_SysMem             = nullptr;
    COMPtr  m_ddsrfc               = {}, m_ddsrfc2 = {}, m_ddsrfc3 = {}, m_ddsrfc4 = {}, m_ddsrfc7 = {}, m_d3ddvc = {}, m_tex = {}, m_tex2 = {};
    D3DDEVICETYPE m_type           = D3DDEVICETYPE::NONE;
    LPVOID        m_last_lock      = nullptr;
    UINT          m_last_pitch     = 0;
    D3DTEXTUREHANDLE m_this_handle = 0;
    D3DTEXTUREHANDLE m_rep_handle  = 0;
};

struct DDSURFACE_ENUM_CNTXT {   
    DirectDraw  * dd;
    LPVOID   Context;
    union {
        HRESULT(WINAPI* lpCallback)  (LPDIRECTDRAWSURFACE  lpDDSurface, LPDDSURFACEDESC  lpDDSurfaceDesc, LPVOID lpContext);
        HRESULT(WINAPI* lpCallback2) (LPDIRECTDRAWSURFACE4 lpDDSurface, LPDDSURFACEDESC2 lpDDSurfaceDesc, LPVOID lpContext);
        HRESULT(WINAPI* lpCallback7) (LPDIRECTDRAWSURFACE7 lpDDSurface, LPDDSURFACEDESC2 lpDDSurfaceDesc, LPVOID lpContext);
    };
};

extern STDMETHODIMP DirectDrawSurface_AddViewport(COMPtr*, LPDIRECT3DVIEWPORT);
extern STDMETHODIMP DirectDrawSurface_DeleteViewport(COMPtr* ptr, LPDIRECT3DVIEWPORT viewport);
extern STDMETHODIMP DirectDrawSurface_NextViewport(COMPtr* ptr, LPDIRECT3DVIEWPORT lpDirect3DViewport, LPDIRECT3DVIEWPORT* lplpAnotherViewport, DWORD dwFlags);
STDMETHODIMP DirectDrawSurface_QueryInterface(COMPtr*, REFIID, void**);
ULONG __stdcall DirectDrawSurface_Release(COMPtr*);
ULONG __stdcall DirectDrawSurface_AddRef(COMPtr*);
extern PrivateDataObjectParent* FindSurfaceObject(IUnknown*, DIRECTDRAW_ID, char*);
unique_ptr<string> DDD_ParseError(HRESULT err);

void checkddobject(COMPtr*);

extern unique_ptr<string> DDD_ParseError(HRESULT);
extern HRESULT WINAPI EnumSurfacesCallback(LPDIRECTDRAWSURFACE, LPDDSURFACEDESC, LPVOID);
extern HRESULT WINAPI EnumSurfacesCallback2(LPDIRECTDRAWSURFACE4, LPDDSURFACEDESC2, LPVOID);
extern HRESULT WINAPI EnumSurfacesCallback7(LPDIRECTDRAWSURFACE7, LPDDSURFACEDESC2, LPVOID);
extern DirectDrawSurface* FindSurfaceWrapper(IUnknown*, DirectDraw*, char*);
extern DirectDraw* GetDirectDraw(COMPtr* ptr);
extern DirectDrawClipper* GetDirectDrawClipper(COMPtr* ptr);
extern DirectDrawPalette* GetDirectDrawPalette(COMPtr* ptr);
extern DirectDrawSurface* GetDirectDrawSurface(COMPtr* ptr);
extern void SetSurfacePrivateData(IUnknown* srfc, PrivateDataObjectParent* parent, DIRECTDRAW_ID, char* caller);
extern void FreetSurfacePrivateData(IUnknown*, DIRECTDRAW_ID, char*);

#endif // DIRECTDRAW_H
