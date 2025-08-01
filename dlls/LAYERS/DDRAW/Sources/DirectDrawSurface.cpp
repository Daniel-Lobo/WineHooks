#include <ddraw.h>
#include "DirectDraw.h"
#include <dllmain.h>

#include "D3D12Hooks.h"

#include <string>
#include "EZString.h"
#include <typeinfo>
#include "Direct3D.h"
#include "D3DHooks.h"
#include "D3DUtils.h"
using std::string;
using std::to_string;

unique_ptr<DDSCAPS2>GetDDSurfaceCaps(IUnknown * srfc) {
    auto desc = unique_ptr<DDSCAPS2>(new DDSCAPS2());
    auto s4   = (IDirectDrawSurface4*)EZInterface(IID_IDirectDrawSurface4, srfc).I();
    if (s4 == nullptr)
    {
        DBUG_WARN("EZInterface(IID_IDirectDrawSurface4...) FAILED");
        return desc;
    }    
    s4->GetCaps(desc.get());
    return desc;
}

void FreetSurfacePrivateData(IUnknown* srfc,  DIRECTDRAW_ID id, char* caller)
{
    auto s4 = (IDirectDrawSurface4*)EZInterface(IID_IDirectDrawSurface4, srfc).I();
    if (s4 == nullptr)
    {
        DBUG_WARN((string("[") + caller + "]: EZInterface(IID_IDirectDrawSurface4...) FAILED").c_str())
        return;
    }
    HRESULT hr = DDERR_GENERIC;
    if      (id == DIRECTDRAW_ID::DDRAW)     hr = s4->FreePrivateData((GUID&)g_.DirectDrawPassTrough);
    else if (id == DIRECTDRAW_ID::PALETTE)   hr = s4->FreePrivateData((GUID&)g_.DDrawPalettePassTrough);
    else if (id == DIRECTDRAW_ID::CLIPPER)   hr = s4->FreePrivateData((GUID&)g_.DDrawClipperPassTrough);
    else if (id == DIRECTDRAW_ID::D3DDEVICE) hr = s4->FreePrivateData((GUID&)g_.D3DDevicePassTrough);
    if (hr != S_OK)
    {
        DBUG_WARN((string("[") + caller + "]: FreePrivateData FAILED").c_str())       
    }   
}

void SetSurfacePrivateData(IUnknown* srfc, PrivateDataObjectParent* parent, DIRECTDRAW_ID id, char * caller)
{
    auto s4 = (IDirectDrawSurface4*)EZInterface(IID_IDirectDrawSurface4, srfc).I();       
    if (s4 == nullptr)
    {
        DBUG_WARN((string("[ ") + caller + "]: EZInterface(IID_IDirectDrawSurface4...) FAILED").c_str())
        return;
    }   
    HRESULT hr = DDERR_GENERIC;
    if      (id == DIRECTDRAW_ID::DDRAW)     hr = s4->SetPrivateData((GUID&)g_.DirectDrawPassTrough,   parent, sizeof(IUnknown*), DDSPD_IUNKNOWNPOINTER);
    else if (id == DIRECTDRAW_ID::PALETTE)   hr = s4->SetPrivateData((GUID&)g_.DDrawPalettePassTrough, parent, sizeof(IUnknown*), DDSPD_IUNKNOWNPOINTER);
    else if (id == DIRECTDRAW_ID::CLIPPER)   hr = s4->SetPrivateData((GUID&)g_.DDrawClipperPassTrough, parent, sizeof(IUnknown*), DDSPD_IUNKNOWNPOINTER);
    else if (id == DIRECTDRAW_ID::D3DDEVICE) hr = s4->SetPrivateData((GUID&)g_.D3DDevicePassTrough,    parent, sizeof(IUnknown*), DDSPD_IUNKNOWNPOINTER);
    if (hr != S_OK)
    {
        DBUG_WARN("IDirectDrawSurface4::SetPrivateData() FAILED");
    }
    //else parent->PrivateAddRef();
}

static void SetSurfacePrivateData(IUnknown* srfc, PrivateDataObject* wrapper, char* caller)
{
    IDirectDrawSurface4* s4 = (IDirectDrawSurface4*)EZInterface(IID_IDirectDrawSurface4, srfc).I();
    if (s4 == nullptr)
    {
        DBUG_WARN((string("[ ") + caller + "]: EZInterface(IID_IDirectDrawSurface4...) FAILED").c_str());
        return;
    }
    if (s4->SetPrivateData((GUID&)g_.DDrawSurfacePassTrough, wrapper, sizeof(IUnknown*), DDSPD_IUNKNOWNPOINTER) != S_OK)
    {
        DBUG_WARN("IDirectDrawSurface4::SetPrivateData() FAILED");
    } 
    //else wrapper->PrivateAddRef();
}

PrivateDataObjectParent* FindSurfaceObject(IUnknown* srfc, DIRECTDRAW_ID id, char* object_type)
{
    auto s4 = (IDirectDrawSurface4*)EZInterface(IID_IDirectDrawSurface4, srfc).I();
    if (s4 == nullptr)
    {
       DBUG_WARN((string("[ ") + object_type + "]: EZInterface(IID_IDirectDrawSurface4...) FAILED").c_str());
       return nullptr;
    }
    PrivateDataObjectParent* objct = nullptr;
    DWORD size                     = sizeof(IUnknown*);
    HRESULT hr                     = DDERR_GENERIC;
    if      (id == DIRECTDRAW_ID::DDRAW)     hr = s4->GetPrivateData((GUID&)g_.DirectDrawPassTrough,   (void**)&objct, &size);
    else if (id == DIRECTDRAW_ID::PALETTE)   hr = s4->GetPrivateData((GUID&)g_.DDrawPalettePassTrough, (void**)&objct, &size);
    else if (id == DIRECTDRAW_ID::CLIPPER)   hr = s4->GetPrivateData((GUID&)g_.DDrawClipperPassTrough, (void**)&objct, &size);
    else if (id == DIRECTDRAW_ID::D3DDEVICE) hr = s4->GetPrivateData((GUID&)g_.D3DDevicePassTrough,    (void**)&objct, &size);
    if (DD_OK != hr)
    {
        DBUG_WARN((string(object_type) + " Not found").c_str());
        return nullptr;
    }
    //objct->PrivateRelease();
    return objct;
}

DirectDraw* GetSurfaceDDObjectWrapper(IUnknown* srfc)
{
    PrivateDataObjectParent* object = FindSurfaceObject(srfc, DIRECTDRAW_ID::DDRAW, "DirectDraw");
    if (object == nullptr)  return nullptr;  auto dd = dynamic_cast<DirectDraw*>(object);
    if (dd     == nullptr)  DBUG_WARN("BAD CAST");    
    return dd;
}

DirectDrawSurface* FindSurfaceWrapper(IUnknown* srfc, DirectDraw* dd, char* caller)
{    
    IDirectDrawSurface4* s4 = (IDirectDrawSurface4*)EZInterface(IID_IDirectDrawSurface4, srfc).I();
    if (s4 == nullptr)
    {
        DBUG_WARN((string("[") + caller + "]: EZInterface(IID_IDirectDrawSurface4...) FAILED, surface=[" + to_string((ULONG)srfc) + "]").c_str());
        return nullptr;
    }
    PrivateDataObject* objct = nullptr;
    DWORD size               = sizeof(IUnknown*);
    HRESULT hr               = s4->GetPrivateData((GUID&)g_.DDrawSurfacePassTrough, (void**)&objct, &size);
    if (DD_OK != hr)
    {
        if (dd == nullptr)
        {
            DBUG_WARN("Surface not found and no directdraw object supplied");
            return nullptr;
        }
        auto caps    = GetDDSurfaceCaps(srfc);
        auto flags   = caps.get()->dwCaps & DDSCAPS_MIPMAP ? (DWORD)*(DWORD*)"MIPSUBLVL" : 0;
        auto dd_srfc = new DirectDrawSurface(dd, srfc, flags);
        DBUG_WARN( (string(caller) + ": Created surface [" + to_string((long)dd_srfc) + "]").c_str() );
        return dd_srfc;
    }
    else {
        DirectDrawSurface* dd_srfc = dynamic_cast<DirectDrawSurface*>(objct);
        //objct->PrivateRelease();   /* Refcount was increased with ::GetPrivateData */
        if (srfc == nullptr) DBUG_WARN((string(caller) + "BAD CAST").c_str())
        else                 DBUG_WARN((string(caller) + ": Surface Found=[" + to_string((long)srfc) + "]").c_str());
        dd_srfc->GetImp()->AddRef();
        srfc->Release();
        return dd_srfc;
    }
}

DirectDrawSurface* GetDirectDrawSurface(COMPtr* ptr)
{
    if     (ptr == nullptr)     return nullptr;
    return (DirectDrawSurface*) ptr->COMObjct;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirectDrawSurface
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDrawSurface
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP DirectDrawSurface_QueryInterface(COMPtr* ptr, REFIID riid, void** ppvObj)
{
    LAYER_LOG_CALL
    GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    //DBUG_LOG(ASCii((wchar_t*)DllFromAdress(__builtin_return_address(0)).m_name.c_str()).ASCii_string.c_str())

    if (riid == IID_IUnknown || riid == IID_IDirectDrawSurface) {
       DBUG_LOG("IID_IDirectDrawSurface") *ppvObj = _this->GetDirectDrawSurface1(); _this->m_IUnknown->AddRef(); return 0;
    } else if (riid == IID_IDirectDrawSurface2) {
       DBUG_LOG("IID_IDirectDrawSurface2")*ppvObj = _this->GetDirectDrawSurface2(); _this->m_IUnknown->AddRef(); return 0;
    } else if (riid == IID_IDirectDrawSurface3) {
       DBUG_LOG("IID_IDirectDrawSurface3")*ppvObj = _this->GetDirectDrawSurface3(); _this->m_IUnknown->AddRef(); return 0;
    } else if (riid == IID_IDirectDrawSurface4) {
       DBUG_LOG("IID_IDirectDrawSurface4")*ppvObj = _this->GetDirectDrawSurface4(); _this->m_IUnknown->AddRef(); return 0;
    } else if (riid == IID_IDirectDrawSurface7) {
       DBUG_LOG("IID_IDirectDrawSurface7")*ppvObj = _this->GetDirectDrawSurface7(); _this->m_IUnknown->AddRef(); return 0;
    } else if (riid == IID_IDirect3DTexture) {
       DBUG_LOG("IID_IDirect3DTexture")   *ppvObj = _this->GetDirect3DTexture();    _this->m_IUnknown->AddRef(); return 0;
    } else if (riid == IID_IDirect3DTexture2) {
       DBUG_LOG("IID_IDirect3DTexture2")  *ppvObj = _this->GetDirect3DTexture2();   _this->m_IUnknown->AddRef(); return 0;
    } else if (riid == IID_IDirect3DHALDevice || riid == IID_IDirect3DRGBDevice || riid == IID_IDirect3DRampDevice || riid == IID_IDirect3DMMXDevice) {
        HRESULT r = _this->GetImp()->QueryInterface(riid, ppvObj);
        if (FAILED(r))
        {
            DBUG_WARN("FAILED TO CREATE DEVICE");
            return r;
        }      
        IUnknown* dvc = (IUnknown * )*ppvObj;  dvc->Release();
        *ppvObj       = _this->GetDevice();   _this->m_IUnknown->AddRef();
        DBUG_WARN("IID_IDirect3DDevice");
        if      (riid == IID_IDirect3DRampDevice) _this->SetType(D3DDEVICETYPE::RAMP);
        else if (riid == IID_IDirect3DRGBDevice)  _this->SetType(D3DDEVICETYPE::RGB);
        else if (riid == IID_IDirect3DHALDevice)  _this->SetType(D3DDEVICETYPE::HAL);
        else if (riid == IID_IDirect3DMMXDevice)  _this->SetType(D3DDEVICETYPE::MMX);
        return r;
    }

    HRESULT hr = _this->GetImp()->QueryInterface(riid, ppvObj);
    DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str() + " Implementation hr=" + to_string(hr)).c_str());
    return hr;
}

HRESULT WINAPI BuildSurfacesList(LPDIRECTDRAWSURFACE4 lpDDSurface, LPDDSURFACEDESC2 lpDDSurfaceDesc, LPVOID lpContext) 
{
    DirectDrawSurface* s = FindSurfaceWrapper(lpDDSurface, nullptr, (char*)__FUNCTION__);
    if (nullptr == s)
    {
        if (nullptr != lpDDSurface)
        {
            lpDDSurface->Release();
        }
        return DDENUMRET_OK;
    }  

    std::vector<DirectDrawSurface*> * S = (std::vector<DirectDrawSurface*> *)lpContext;
    S->push_back(s);
    return DDENUMRET_OK;
}

std::unique_ptr<std::vector<DirectDrawSurface*>> ListSurfaceAttachements(IUnknown * srfc)
{
    auto surfaces     = new std::vector<DirectDrawSurface*>();
    auto surfaces_ptr = unique_ptr<std::vector<DirectDrawSurface*>>(surfaces);
    auto s4 = (IDirectDrawSurface4*)EZInterface(IID_IDirectDrawSurface4, srfc).I();
    if (s4 == nullptr)
    {
        DBUG_WARN((string("[ ") + __FUNCTION__ + "]: EZInterface(IID_IDirectDrawSurface4...) FAILED").c_str())
        return surfaces_ptr;
    }
    s4->EnumAttachedSurfaces(surfaces_ptr.get(), BuildSurfacesList);
    return surfaces_ptr;
}

DWORD GetSurfaceCaps(DirectDrawSurface* srfc, char* caller)
{
    auto s1 = (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, srfc->GetImp()).I();
    if (s1 == nullptr)
    {
        DBUG_WARN((string("[") + caller + "]: EZInterface(IID_IDirectDrawSurface1...) FAILED").c_str())
        return 0 ;
    }
    DDSCAPS caps = { 0 };
    s1->GetCaps(&caps);
    return caps.dwCaps;
}

ULONG __stdcall DirectDrawSurface_Release(COMPtr* ptr) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC) 
    if (g_d3d.DELAY_TEXTURE_RELEASES)
    {
        ULONG ref;        
        if (ptr != _this->GetDirect3DTexture())
        {
            ref = _this->m_IUnknown->Release(); DBUG_WARN(to_string(ref).c_str());
            return ref;
        }
       
        _this->m_IUnknown->AddRef();        
        D3DGlobals.Delayed_Release_Textures.push_back(_this->m_IUnknown);        
        return _this->m_IUnknown->Release()-1;
    }

    ULONG ref = _this->m_IUnknown->Release(); DBUG_LOG(to_string(ref).c_str()); 
    return ref;    
}

ULONG __stdcall DirectDrawSurface_AddRef(COMPtr* ptr) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    ULONG ref = _this->m_IUnknown->AddRef();  DBUG_LOG(to_string(ref).c_str()); return ref;
}

STDMETHODIMP DirectDrawSurface_AddAttachedSurface(COMPtr* ptr, LPDIRECTDRAWSURFACE lpDDSAttachedSurface) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    if (lpDDSAttachedSurface == nullptr) LAYER_COM_CALL(AddAttachedSurface, lpDDSAttachedSurface);
    auto _that     = GetDirectDrawSurface((COMPtr*)lpDDSAttachedSurface);
    auto _that_imp = _that == nullptr ? nullptr : (IDirectDrawSurface*)EZInterface(LAYER_GUID, _that->GetImp()).I();
    LAYER_COM_CALL(AddAttachedSurface, _that_imp);
}

STDMETHODIMP DirectDrawSurface_AddOverlayDirtyRect(COMPtr* ptr, LPRECT lpRect) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(AddOverlayDirtyRect, lpRect);
}

#undef LAYER_PARSE_ERROR
#define LAYER_PARSE_ERROR(hr) DDD_ParseError(hr).get()->c_str()
STDMETHODIMP DirectDrawSurface_Blt(COMPtr* ptr, LPRECT lpDestRect, LPDIRECTDRAWSURFACE lpDDSrcSurface, LPRECT lpSrcRect, DWORD f, LPDDBLTFX fx) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    _this->GetImp(DD_FOR::BLITING_TO);
    auto _that     = lpDDSrcSurface == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpDDSrcSurface);
    auto _that_imp = _that          == nullptr ? nullptr : (IDirectDrawSurface*)EZInterface(LAYER_GUID, _that->GetImp()).I();
    DBUG_LOG((STR("_that=[") + to_string((long)_that) + "]").c_str())
    //LAYER_COM_CALL(Blt, lpDestRect, _that_imp, lpSrcRect, f, fx);
    IDirectDrawSurface* _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->Blt(lpDestRect, _that_imp, lpSrcRect, f, fx);
    if (FAILED(hr))
    {
        DBUG_WARN("::Blt Failed");
        return hr;
    }
    if (g_d3d.TEXTURE_SWAP_ENABLED && _that != nullptr && _that->GetReplacement() != nullptr)
    {
        auto src_desc = _that->GetDesc();
        auto dst_desc = _this->GetDesc();
        if (RectCoversEntireSurface(lpDestRect, dst_desc.get()->dwWidth, dst_desc.get()->dwHeight) && 
            RectCoversEntireSurface(lpSrcRect,  src_desc.get()->dwWidth, src_desc.get()->dwHeight))
        {
            _this->SetReplacement(_that->GetReplacement());
        }
           
    }
#ifdef LAYER_VERBOSE_LOGS
    DBUG_WARN("DD_OK")
#endif
    return hr;
}

#undef LAYER_PARSE_ERROR
#define LAYER_PARSE_ERROR(hr) (std::string("FAILED: ")+std::to_string((UINT)hr)).c_str()

STDMETHODIMP DirectDrawSurface_BltBatch(COMPtr* ptr, LPDDBLTBATCH lpDDBltBatch, DWORD dwCount, DWORD dwFlags) {
    LAYER_LOG_CALL; return E_NOTIMPL;
}

STDMETHODIMP DirectDrawSurface_BltFast(COMPtr* ptr, DWORD dwX, DWORD dwY, LPDIRECTDRAWSURFACE lpDDSrcSurface, LPRECT lpSrcRect, DWORD dwTrans) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    auto _that     = GetDirectDrawSurface((COMPtr*)lpDDSrcSurface);
    DBUG_WARN((STR("_that=[") + to_string((long)_that) + "]").c_str())
    auto _that_imp = _that == nullptr ? nullptr : (IDirectDrawSurface*)EZInterface(LAYER_GUID, _that->GetImp()).I();
    LAYER_COM_CALL(BltFast, dwX, dwY, _that_imp, lpSrcRect, dwTrans);
}

STDMETHODIMP DirectDrawSurface_DeleteAttachedSurface(COMPtr* ptr, DWORD dwFlags, LPDIRECTDRAWSURFACE lpDDSAttachedSurface) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    if (lpDDSAttachedSurface == nullptr) LAYER_COM_CALL(DeleteAttachedSurface, dwFlags, lpDDSAttachedSurface);
    auto _that     = GetDirectDrawSurface((COMPtr*)lpDDSAttachedSurface);
    auto _that_imp = _that == nullptr ? nullptr : (IDirectDrawSurface*)EZInterface(LAYER_GUID, _that->GetImp()).I();
    LAYER_COM_CALL(DeleteAttachedSurface, dwFlags, _that_imp);
}

HRESULT WINAPI EnumSurfacesCallback(LPDIRECTDRAWSURFACE lpDDSurface, LPDDSURFACEDESC lpDDSurfaceDesc, LPVOID lpContext)
{
    DDSURFACE_ENUM_CNTXT * ctx = (DDSURFACE_ENUM_CNTXT*)lpContext;
    DirectDrawSurface    * s   = FindSurfaceWrapper(lpDDSurface, ctx->dd, "DirectDrawSurface_EnumAttachedSurfaces[lambda]");
    if (s == nullptr)
        return ctx->lpCallback(nullptr, lpDDSurfaceDesc, ctx->Context);
    return ctx->lpCallback((LPDIRECTDRAWSURFACE)s->GetDirectDrawSurface1(), lpDDSurfaceDesc, ctx->Context);
};

STDMETHODIMP DirectDrawSurface_EnumAttachedSurfaces(COMPtr* ptr, LPVOID lpContext, LPDDENUMSURFACESCALLBACK lpEnumSurfacesCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    if (lpEnumSurfacesCallback == nullptr) 
        return DDERR_INVALIDPARAMS;    
    IDirectDrawSurface* _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    DDSURFACE_ENUM_CNTXT Ctx = {GetSurfaceDDObjectWrapper(_this_imp), lpContext, lpEnumSurfacesCallback};
    LAYER_COM_CALL(EnumAttachedSurfaces, (void**)&Ctx, EnumSurfacesCallback);
}

STDMETHODIMP DirectDrawSurface_EnumOverlayZOrders(COMPtr* ptr, DWORD dwFlags, LPVOID lpContext, LPDDENUMSURFACESCALLBACK lpfnCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    if (lpfnCallback == nullptr)
        return DDERR_INVALIDPARAMS;
    IDirectDrawSurface* _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    DDSURFACE_ENUM_CNTXT Ctx      = {GetSurfaceDDObjectWrapper(_this_imp), lpContext, lpfnCallback};
    LAYER_COM_CALL(EnumOverlayZOrders, dwFlags, (void**)&Ctx, EnumSurfacesCallback);
}

STDMETHODIMP DirectDrawSurface_Flip(COMPtr* ptr, LPDIRECTDRAWSURFACE lpDDSurfaceTargetOverride, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)    
    auto _that     = lpDDSurfaceTargetOverride == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpDDSurfaceTargetOverride);
    auto _that_ez  =                     _that == nullptr ? EZInterface(LAYER_GUID, nullptr) : EZInterface(LAYER_GUID, _that->GetImp());
    LAYER_COM_CALL(Flip, (IDirectDrawSurface*)_that_ez.I(), dwFlags);
}

STDMETHODIMP DirectDrawSurface_GetAttachedSurface(COMPtr* ptr, LPDDSCAPS lpDDSCaps, LPDIRECTDRAWSURFACE FAR* lplpDDAttachedSurface) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    IDirectDrawSurface * _this_imp = (IDirectDrawSurface *)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->GetAttachedSurface(lpDDSCaps, lplpDDAttachedSurface);
    if (FAILED(hr))
    {
        DBUG_WARN("FAILED")
        return hr;
    }
    DirectDrawSurface* srfc = FindSurfaceWrapper((IUnknown*)*lplpDDAttachedSurface, GetSurfaceDDObjectWrapper(_this_imp), __FUNCTION__);
    if (srfc == nullptr)
    {        
        DBUG_WARN("FindSurfaceWrapper FAILED")
        return DDERR_GENERIC;        
    }        
    *lplpDDAttachedSurface = (IDirectDrawSurface*)srfc->GetDirectDrawSurface1();
    return hr;
}

STDMETHODIMP DirectDrawSurface_GetBltStatus(COMPtr* ptr, DWORD dwFlags){
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetBltStatus, dwFlags);
}

STDMETHODIMP DirectDrawSurface_GetCaps(COMPtr* ptr, LPDDSCAPS lpDDSCaps) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetCaps, lpDDSCaps);
}

STDMETHODIMP DirectDrawSurface_GetClipper(COMPtr* ptr, LPDIRECTDRAWCLIPPER FAR* lplpDDClipper) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    IDirectDrawSurface* _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    auto object = FindSurfaceObject(_this_imp, DIRECTDRAW_ID::CLIPPER, "CLIPPER");
    if (object == nullptr)
    {
        DBUG_WARN("FindSurfaceObject FAILED");
        return DDERR_GENERIC;
    }
    auto clipper = dynamic_cast<DirectDrawClipper*>(object);
    if (clipper == nullptr)
    {
        DBUG_WARN("BAD CAST");
        return DDERR_GENERIC;
    }
    *lplpDDClipper = (IDirectDrawClipper*)clipper->GetClipper();
    return 0;
}

STDMETHODIMP DirectDrawSurface_GetColorKey(COMPtr* ptr, DWORD dwFlags, LPDDCOLORKEY lpDDColorKey) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetColorKey, dwFlags, lpDDColorKey);
}

STDMETHODIMP DirectDrawSurface_GetDC(COMPtr* ptr, HDC FAR* lphDC) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetDC, lphDC);
}

STDMETHODIMP DirectDrawSurface_GetFlipStatus(COMPtr* ptr, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetFlipStatus, dwFlags);
}

STDMETHODIMP DirectDrawSurface_GetOverlayPosition(COMPtr* ptr, LPLONG lplX, LPLONG lplY) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetOverlayPosition, lplX, lplY);
}

STDMETHODIMP DirectDrawSurface_GetPalette(COMPtr* ptr, LPDIRECTDRAWPALETTE FAR* lplpDDPalette) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    IDirectDrawSurface* _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    auto object = FindSurfaceObject(_this_imp, DIRECTDRAW_ID::PALETTE, "CLIPPER");
    if (object == nullptr)
    {
        DBUG_WARN("FindSurfaceObject FAILED");
        return DDERR_GENERIC;
    }
    auto clipper = dynamic_cast<DirectDrawPalette*>(object);
    if (clipper == nullptr)
    {
        DBUG_WARN("BAD CAST");
        return DDERR_GENERIC;
    }
    *lplpDDPalette = (IDirectDrawPalette*)clipper->GetPalette();
    return 0;
}

STDMETHODIMP DirectDrawSurface_GetPixelFormat(COMPtr* ptr, LPDDPIXELFORMAT lpDDPixelFormat) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetPixelFormat, lpDDPixelFormat);
}

STDMETHODIMP DirectDrawSurface_GetSurfaceDesc(COMPtr* ptr, LPDDSURFACEDESC lpDDSurfaceDesc) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetSurfaceDesc, lpDDSurfaceDesc);
}

STDMETHODIMP DirectDrawSurface_Initialize(COMPtr* ptr, LPDIRECTDRAW lpDD, LPDDSURFACEDESC lpDDSurfaceDesc) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    auto _that     = lpDD  == nullptr ? nullptr : GetDirectDraw((COMPtr*)lpDD);
    auto _that_imp = _that == nullptr ? nullptr : (IDirectDraw*)EZInterface(IID_IDirectDraw, _that->GetImp()).I();
    LAYER_COM_CALL(Initialize, _that_imp, lpDDSurfaceDesc);
}

STDMETHODIMP DirectDrawSurface_IsLost(COMPtr* ptr) {   
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(IsLost);
}

#define LAYER_PARSE_ERROR(hr) (std::string("FAILED: ")+*DDD_ParseError(hr).get()).c_str()
STDMETHODIMP DirectDrawSurface_Lock(COMPtr* ptr, LPRECT lpDestRect, LPDDSURFACEDESC lpDDSurfaceDesc, DWORD dwFlags, HANDLE hEvent) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); 
    //DBUG_LOG((STR("this_imp = [") + to_string((ULONG)EZInterface(LAYER_GUID, _this->GetImp()).I()) + "]").c_str())
    /*LAYER_COM_CALL(Lock, lpDestRect, lpDDSurfaceDesc, dwFlags, hEvent);*/
    IDirectDrawSurface* _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp(DD_FOR::LOCKING)).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->Lock(lpDestRect, lpDDSurfaceDesc, dwFlags, hEvent);
    if (FAILED(hr))
    {
        DBUG_WARN("::Lock Failed");
        return hr;
    }
    if (!(lpDDSurfaceDesc->ddsCaps.dwCaps & DDSCAPS_SYSTEMMEMORY)) return hr;
    if (g_d3d.TEXTURE_SWAP_ENABLED)
    {
        if (RectCoversEntireSurface(lpDestRect, lpDDSurfaceDesc->dwWidth, lpDDSurfaceDesc->dwHeight) == FALSE) 
            _this->SetLastLock(nullptr, 0);
        else 
            _this->SetLastLock(lpDDSurfaceDesc->lpSurface, (UINT)lpDDSurfaceDesc->lPitch);
    }
#ifdef LAYER_VERBOSE_LOGS
    DBUG_WARN("DD_OK")
#endif
    return hr;
}
#define LAYER_PARSE_ERROR(hr) (std::string("FAILED: ")+std::to_string((UINT)hr)).c_str()

STDMETHODIMP DirectDrawSurface_ReleaseDC(COMPtr* ptr, HDC hDC) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(ReleaseDC, hDC);
}

STDMETHODIMP DirectDrawSurface_Restore(COMPtr* ptr) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(Restore);
}

STDMETHODIMP DirectDrawSurface_SetClipper(COMPtr* ptr, LPDIRECTDRAWCLIPPER lpDDClipper) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    auto _that     = lpDDClipper == nullptr ? nullptr : GetDirectDrawClipper((COMPtr*)lpDDClipper);
    auto _that_imp = _that       == nullptr ? nullptr : (IDirectDrawClipper*)EZInterface(IID_IDirectDrawClipper, _that->GetImp()).I();
    auto _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->SetClipper(_that_imp);
    if (S_OK == hr) 
         SetSurfacePrivateData(_this_imp, dynamic_cast<PrivateDataObjectParent*>(_that), DIRECTDRAW_ID::CLIPPER, "DirectDrawSurface::SetClipper");
    return hr;    
}

STDMETHODIMP DirectDrawSurface_SetColorKey(COMPtr* ptr, DWORD dwFlags, LPDDCOLORKEY lpDDColorKey) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(SetColorKey, dwFlags, lpDDColorKey);
}

STDMETHODIMP DirectDrawSurface_SetOverlayPosition(COMPtr* ptr, LONG lX, LONG lY) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(SetOverlayPosition, lX, lY);
}

STDMETHODIMP DirectDrawSurface_SetPalette(COMPtr* ptr, LPDIRECTDRAWPALETTE lpDDPalette) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    auto _that     = lpDDPalette == nullptr ? nullptr : GetDirectDrawPalette((COMPtr*)lpDDPalette);
    auto _that_imp = _that       == nullptr ? nullptr : (IDirectDrawPalette*)EZInterface(IID_IDirectDrawPalette, _that->GetImp()).I();
    auto _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->SetPalette(_that_imp);
    if (S_OK == hr) SetSurfacePrivateData(_this_imp, dynamic_cast<PrivateDataObjectParent*>(_that), DIRECTDRAW_ID::PALETTE, "DirectDrawSurface::SetPalette");
    else DBUG_WARN("SetPalette Failed");
    return hr;
}

#define LAYER_PARSE_ERROR(hr) (std::string("FAILED: ")+*DDD_ParseError(hr).get()).c_str()
STDMETHODIMP DirectDrawSurface_Unlock(COMPtr* ptr, LPVOID lpSurfaceData) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); 
    //DBUG_LOG((STR("this_imp = [") + to_string((ULONG)EZInterface(LAYER_GUID, _this->GetImp()).I()) + "]").c_str())
    //LAYER_COM_CALL(Unlock, lpSurfaceData);
    IDirectDrawSurface* _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp(DD_FOR::UNLOCKING)).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    if (g_d3d.TEXTURE_SWAP_ENABLED)
    {
        auto lock = _this->GetlastLock();
        if (lock != nullptr)
        {
            auto desc = _this->GetDesc();
            auto rep = g_.FindTexture(desc.get()->dwWidth, desc.get()->dwHeight, lock.get()->lPitch,
                (char*)DescribeDDSrfcPixelFormatA(&desc.get()->ddpfPixelFormat).get()->c_str(), (BYTE*)lock.get()->lpSurface);
            if (rep != nullptr)
            {
                IUnknown* new_srfc = nullptr;
                DBUG_LOG(DDrawLoadSurface(_this, &new_srfc, (char*)rep->c_str()).get()->c_str())
                _this->SetReplacement(new_srfc);
            }
            else if (g_d3d.TEXTURE_SWAP_AUTODUMP)
                DumpLockedDirectDrawSurface(_this, lock.get()->lpSurface, lock.get()->lPitch);

        }
    }
    HRESULT hr = _this_imp->Unlock(lpSurfaceData);  
    _this->UpdateVidMem();
    if (FAILED(hr))
    {
        DBUG_WARN("::UNLock Failed");
        return hr;
    }    
#ifdef LAYER_VERBOSE_LOGS
    DBUG_WARN("DD_OK")
#endif
    return hr;
}
#define LAYER_PARSE_ERROR(hr) (std::string("FAILED: ")+std::to_string((UINT)hr)).c_str()

STDMETHODIMP DirectDrawSurface_UpdateOverlay(COMPtr* ptr, LPRECT sRect, LPDIRECTDRAWSURFACE DstSurface, LPRECT dRect, DWORD f, LPDDOVERLAYFX fx) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    auto _that     = DstSurface == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)DstSurface);
    auto _that_imp = _that      == nullptr ? nullptr : (IDirectDrawSurface*)EZInterface(LAYER_GUID, _that->GetImp()).I();
    LAYER_COM_CALL(UpdateOverlay, sRect, DstSurface, dRect, f, fx);
}

STDMETHODIMP DirectDrawSurface_UpdateOverlayDisplay(COMPtr* ptr, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(UpdateOverlayDisplay, dwFlags);
}

STDMETHODIMP DirectDrawSurface_UpdateOverlayZOrder(COMPtr* ptr, DWORD dwFlags, LPDIRECTDRAWSURFACE lpDDSReference) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    auto _that     = lpDDSReference == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpDDSReference);
    auto _that_imp = _that          == nullptr ? nullptr : (IDirectDrawSurface*)EZInterface(LAYER_GUID, _that->GetImp()).I();
    LAYER_COM_CALL(UpdateOverlayZOrder, dwFlags, _that_imp);
}

STDMETHODIMP DirectDrawSurface_AddViewport(COMPtr* ptr, LPDIRECT3DVIEWPORT viewport) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    auto _that     = viewport == nullptr ? nullptr : GetDirect3DViewport((COMPtr*)viewport);    
    auto _that_imp = _that    == nullptr ? nullptr : (IDirect3DViewport*) EZInterface(IID_IDirect3DViewport, _that->GetImp()).I();
    auto _this_imp = (IDirect3DDevice*)EZInterface(_this->GetDeviceGUID(), _this->GetImp()).I();
    DBUG_WARN((STR("that=[") + to_string((long)_that) + "]").c_str())
    HRESULT hr     = _this_imp->AddViewport(_that_imp);
    if (FAILED(hr))
    {
        DBUG_WARN(LAYER_PARSE_ERROR(hr));
        return hr;
    }
    _this->__PrivateAddViewPort(_that_imp, _that);
    DBUG_WARN(to_string((UINT)hr).c_str());
    return hr;
}
STDMETHODIMP DirectDrawSurface_DeleteViewport(COMPtr* ptr, LPDIRECT3DVIEWPORT viewport) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    auto _that     = viewport == nullptr ? nullptr : GetDirect3DViewport((COMPtr*)viewport);
    auto _that_imp = _that    == nullptr ? nullptr : (IDirect3DViewport*)EZInterface(IID_IDirect3DViewport, _that->GetImp()).I();
    auto _this_imp = (IDirect3DDevice*)EZInterface(_this->GetDeviceGUID(), _this->GetImp()).I();
    if (_that_imp == nullptr)
    {
        DBUG_WARN("_that_imp == nullptr");
        return DDERR_INVALIDPARAMS;
    }
    if (FALSE == _this->HasViewport(_that_imp))
    {
        DBUG_WARN("_this->HasViewPort(_that_imp) == FALSE");
        return DDERR_INVALIDPARAMS;
    }
    _that_imp->AddRef(); HRESULT hr = _this_imp->DeleteViewport(_that_imp); _that_imp->Release();
    _this->__PrivateDeleteViewPort(_that_imp);
    DBUG_WARN(LAYER_PARSE_ERROR(hr));
    return hr;
}
STDMETHODIMP DirectDrawSurface_NextViewport(COMPtr* ptr, LPDIRECT3DVIEWPORT lpDirect3DViewport, LPDIRECT3DVIEWPORT* lplpAnotherViewport,  DWORD dwFlags) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    auto _that     = lpDirect3DViewport == nullptr ? nullptr : GetDirect3DViewport((COMPtr*)lpDirect3DViewport);
    auto _that_imp = _that              == nullptr ? nullptr : (IDirect3DViewport*)EZInterface(IID_IDirect3DViewport, _that->GetImp()).I();
    auto _this_imp = (IDirect3DDevice*)EZInterface(_this->GetDeviceGUID(), _this->GetImp()).I();
    HRESULT hr     = _this_imp->NextViewport(_that_imp, lplpAnotherViewport, dwFlags);
    if (FAILED(hr))
    {
        DBUG_WARN(LAYER_PARSE_ERROR(hr));
        return hr;
    }
    if (FALSE == _this->HasViewport(_that_imp))
    {
        DBUG_WARN("_this->HasLight(_that_imp) == FALSE");
        return DDERR_INVALIDPARAMS;
    }
    *lplpAnotherViewport = (IDirect3DViewport*)_this->GetViewPort(*lplpAnotherViewport)->GetDirect3DViewport1();
    return hr;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirectDrawSurface2
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDrawSurface2
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP DirectDrawSurface2_GetDDInterface(COMPtr* ptr, LPVOID FAR* lplpDD)
{
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    IDirectDrawSurface* _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    auto dd = GetSurfaceDDObjectWrapper(_this_imp);
    if (dd == nullptr)
    {
        DBUG_WARN("GetSurfaceDDObjectWrapper FAILED");
        return DDERR_GENERIC;
    }
    dd->PublicAddRef();
    *lplpDD = (IDirectDraw*)dd->GetDirectDraw1();
    DBUG_WARN((STR("GOT ") + to_string((ULONG)dd)).c_str());
    return 0;
}
STDMETHODIMP DirectDrawSurface2_PageLock(COMPtr* ptr, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(PageLock, dwFlags);
}
STDMETHODIMP DirectDrawSurface2_PageUnlock(COMPtr* ptr, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(PageUnlock, dwFlags);
}

#undef  LAYER_THIS
#define LAYER_THIS IDirectDrawSurface3
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDrawSurface3
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP DirectDrawSurface3_SetSurfaceDesc(COMPtr* ptr, LPDDSURFACEDESC desc, DWORD flags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(SetSurfaceDesc, desc, flags);
}

#undef  LAYER_THIS
#define LAYER_THIS IDirectDrawSurface4
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDrawSurface4
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP DirectDrawSurface4_SetSurfaceDesc(COMPtr* ptr, LPDDSURFACEDESC2 desc, DWORD flags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(SetSurfaceDesc, desc, flags);
}

HRESULT WINAPI EnumSurfacesCallback2(LPDIRECTDRAWSURFACE4 lpDDSurface, LPDDSURFACEDESC2 lpDDSurfaceDesc, LPVOID lpContext)
{
    DDSURFACE_ENUM_CNTXT* ctx = (DDSURFACE_ENUM_CNTXT*)lpContext;
    DirectDrawSurface* s = FindSurfaceWrapper(lpDDSurface, ctx->dd, "DirectDrawSurface_EnumAttachedSurfaces[lambda]");
    if (s == nullptr)
        return ctx->lpCallback2(nullptr, lpDDSurfaceDesc, ctx->Context);    
    return ctx->lpCallback2((LPDIRECTDRAWSURFACE4)s->GetDirectDrawSurface4(), lpDDSurfaceDesc, ctx->Context);
};

STDMETHODIMP DirectDrawSurface4_EnumAttachedSurfaces(COMPtr* ptr, LPVOID lpContext, LPDDENUMSURFACESCALLBACK2 lpEnumSurfacesCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    if (lpEnumSurfacesCallback == nullptr)
        return DDERR_INVALIDPARAMS;
    IDirectDrawSurface4* _this_imp = (IDirectDrawSurface4*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    DDSURFACE_ENUM_CNTXT Ctx       = {GetSurfaceDDObjectWrapper(_this_imp), lpContext};
    Ctx.lpCallback2                = lpEnumSurfacesCallback;
    LAYER_COM_CALL(EnumAttachedSurfaces, (void**)&Ctx, EnumSurfacesCallback2);
}

STDMETHODIMP DirectDrawSurface4_EnumOverlayZOrders(COMPtr* ptr, DWORD dwFlags, LPVOID lpContext, LPDDENUMSURFACESCALLBACK2 lpfnCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    if (lpfnCallback == nullptr)
        return DDERR_INVALIDPARAMS;
    IDirectDrawSurface4* _this_imp = (IDirectDrawSurface4*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    DDSURFACE_ENUM_CNTXT Ctx       = {GetSurfaceDDObjectWrapper(_this_imp), lpContext};
    Ctx.lpCallback2                = lpfnCallback;
    LAYER_COM_CALL(EnumOverlayZOrders, dwFlags, (void**)&Ctx, EnumSurfacesCallback2);
}

STDMETHODIMP DirectDrawSurface4_GetAttachedSurface(COMPtr* ptr, LPDDSCAPS2 lpDDSCaps, LPDIRECTDRAWSURFACE4 FAR* lplpDDAttachedSurface) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    IDirectDrawSurface4* _this_imp = (IDirectDrawSurface4*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    /* access violoation on wine when when called from IDirectDrawSurface4_EnumAttachedSurfaces (ahk)
    caller handles it, but is a workarround */
    HRESULT hr = _this_imp->GetAttachedSurface(lpDDSCaps, lplpDDAttachedSurface); 
    if (FAILED(hr))
    {
        DBUG_WARN("FAILED")
        return hr;
    }
    DirectDrawSurface* srfc = FindSurfaceWrapper((IUnknown*)*lplpDDAttachedSurface, GetSurfaceDDObjectWrapper(_this_imp), __FUNCTION__);
    if (srfc == nullptr)
    {
        DBUG_WARN("FindSurfaceWrapper FAILED")
        return DDERR_GENERIC;
    }   
    *lplpDDAttachedSurface = (IDirectDrawSurface4*)srfc->GetDirectDrawSurface4();
    return hr;
}
STDMETHODIMP DirectDrawSurface4_GetCaps(COMPtr* ptr, LPDDSCAPS2 lpDDSCaps) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetCaps, lpDDSCaps);
}

STDMETHODIMP DirectDrawSurface4_GetSurfaceDesc(COMPtr* ptr, LPDDSURFACEDESC2 lpDDSurfaceDesc) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); //LAYER_COM_CALL(GetSurfaceDesc, lpDDSurfaceDesc);
    auto _this_imp = (IDirectDrawSurface4*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->GetSurfaceDesc(lpDDSurfaceDesc);
    if (FAILED(hr))
    {
        DBUG_WARN("FAILED")
        return hr;
    }
    return hr;
}

STDMETHODIMP DirectDrawSurface4_Initialize(COMPtr* ptr, LPDIRECTDRAW lpDD, LPDDSURFACEDESC2 lpDDSurfaceDesc) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    auto _that     = lpDD  == nullptr ? nullptr : GetDirectDraw((COMPtr*)lpDD);
    auto _that_imp = _that == nullptr ? nullptr : (IDirectDraw*)EZInterface(IID_IDirectDraw, _that->GetImp()).I();
    LAYER_COM_CALL(Initialize, _that_imp, lpDDSurfaceDesc);
}

STDMETHODIMP DirectDrawSurface4_Lock(COMPtr* ptr, LPRECT lpDestRect, LPDDSURFACEDESC2 lpDDSurfaceDesc, DWORD dwFlags, HANDLE hEvent) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(Lock, lpDestRect, lpDDSurfaceDesc, dwFlags, hEvent);
}

STDMETHODIMP DirectDrawSurface4_Unlock(COMPtr* ptr, LPRECT pRect) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); 
    //DBUG_LOG((STR("this_imp = [") + to_string((ULONG)EZInterface(LAYER_GUID, _this->GetImp()).I()) + "]").c_str())
    //LAYER_COM_CALL(Unlock, pRect);
    IDirectDrawSurface* _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp(DD_FOR::UNLOCKING)).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    if (g_d3d.TEXTURE_SWAP_ENABLED)
    {
        auto lock = _this->GetlastLock();
        if (lock != nullptr)
        {
            auto desc = _this->GetDesc();
            auto rep  = g_.FindTexture(desc.get()->dwWidth, desc.get()->dwHeight, lock.get()->lPitch,
                (char*)DescribeDDSrfcPixelFormatA(&desc.get()->ddpfPixelFormat).get()->c_str(), (BYTE*)lock.get()->lpSurface);            
            if (rep != nullptr)
            {
                IUnknown* new_srfc = nullptr;
                DBUG_LOG(DDrawLoadSurface(_this, &new_srfc, (char*)rep->c_str()).get()->c_str())
                _this->SetReplacement(new_srfc);
            }
            else if (g_d3d.TEXTURE_SWAP_AUTODUMP)
                DumpLockedDirectDrawSurface(_this, lock.get()->lpSurface, lock.get()->lPitch);
        }
    }
    HRESULT hr = _this_imp->Unlock(pRect);    
    _this->UpdateVidMem();
    if (FAILED(hr))
    {
        DBUG_WARN("::UnLock Failed");
        return hr;
    }
#ifdef LAYER_VERBOSE_LOGS
    DBUG_WARN("DD_OK")
#endif
    return hr;
}

STDMETHODIMP DirectDrawSurface4_SetPrivateData(COMPtr* ptr, REFGUID guidTag, LPVOID lpData, DWORD cbSize, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); 
    //DBUG_LOG(ASCii((wchar_t*)DllFromAdress(__builtin_return_address(0)).m_name.c_str()).ASCii_string.c_str())
    LAYER_COM_CALL(SetPrivateData, guidTag, lpData, cbSize, dwFlags);
}

STDMETHODIMP DirectDrawSurface4_GetPrivateData(COMPtr* ptr, REFGUID guidTag, LPVOID lpBuffer, LPDWORD lpcbBufferSize) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetPrivateData, guidTag, lpBuffer, lpcbBufferSize);
}

STDMETHODIMP DirectDrawSurface4_FreePrivateData(COMPtr* ptr, REFGUID guidTag) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(FreePrivateData, guidTag);
}

STDMETHODIMP DirectDrawSurface4_GetUniquenessValue(COMPtr* ptr, LPDWORD lpValue) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetUniquenessValue, lpValue);
}

STDMETHODIMP DirectDrawSurface4_ChangeUniquenessValue(COMPtr* ptr) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(ChangeUniquenessValue);
}

STDMETHODIMP DirectDrawSurface4_AddAttachedSurface(COMPtr* ptr, LPDIRECTDRAWSURFACE4 lpDDSAttachedSurface) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    if (lpDDSAttachedSurface == nullptr) LAYER_COM_CALL(AddAttachedSurface, lpDDSAttachedSurface);
    auto _that     = GetDirectDrawSurface((COMPtr*)lpDDSAttachedSurface);
    auto _that_imp = _that == nullptr ? nullptr : (IDirectDrawSurface4*)EZInterface(LAYER_GUID, _that->GetImp()).I();
    LAYER_COM_CALL(AddAttachedSurface, _that_imp);
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DTexture
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DTexture
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP Direct3DTexture_Initialize(COMPtr* ptr, LPDIRECT3DDEVICE lpD3DDevice, LPDIRECTDRAWSURFACE lpDDSurface) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); return DDERR_ALREADYINITIALIZED;
}

STDMETHODIMP Direct3DTexture_GetHandle(COMPtr* ptr, D3DPtr* lpDirect3DDevice, LPD3DTEXTUREHANDLE lpHandle) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); 
    auto _that     = GetDevice(lpDirect3DDevice);
    auto _that_imp = _that == nullptr ? nullptr : (IDirect3DDevice*)_that.get()->I();
    //LAYER_COM_CALL(GetHandle, _that_imp, lpHandle);
    IDirect3DTexture* _this_imp = (IDirect3DTexture*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->GetHandle(_that_imp, lpHandle);
    if (FAILED(hr))
    {
        DBUG_WARN("::GetHandle Failed");
        return hr;
    }
    if (g_d3d.TEXTURE_SWAP_ENABLED)
    {
        _this->Sethandle((D3DTEXTUREHANDLE)*lpHandle);
    }
#ifdef LAYER_VERBOSE_LOGS
    DBUG_WARN("DD_OK")
#endif
        return hr;
}

STDMETHODIMP Direct3DTexture_PaletteChanged(COMPtr* ptr, DWORD dwStart, DWORD dwCount) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(PaletteChanged, dwStart, dwCount);
}

STDMETHODIMP Direct3DTexture_Load(COMPtr* ptr, LPDIRECT3DTEXTURE lpD3DTexture) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    auto _that    = lpD3DTexture == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpD3DTexture)->GetImp();
    auto _that_ez = EZInterface(IID_IDirect3DTexture, _that);
    //DBUG_LOG(to_string((long)_that).c_str());
    //DBUG_LOG(to_string((long)_that_ez.I()).c_str());
    //LAYER_COM_CALL(Load, (IDirect3DTexture*)_that_ez.I());
    IDirect3DTexture* _this_imp = (IDirect3DTexture*)EZInterface(LAYER_GUID, _this->GetImp(DD_FOR::BLITING_TO)).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->Load((IDirect3DTexture*)_that_ez.I());
    if (FAILED(hr))
    {
        DBUG_WARN("::Load Failed");
        return hr;
    }
    auto that = lpD3DTexture == nullptr ? nullptr : (DirectDrawSurface*)GetDirectDrawSurface((COMPtr*)lpD3DTexture);
    if (g_d3d.TEXTURE_SWAP_ENABLED && that != nullptr && that->GetReplacement() != nullptr)
    {
        DBUG_LOG((string("_that=[") + to_string((UINT)GetDirectDrawSurface((COMPtr*)lpD3DTexture)) + string("]")).c_str())
        _this->SetReplacement(that->GetReplacement());
    }
#ifdef LAYER_VERBOSE_LOGS
    DBUG_WARN("DD_OK")
#endif
        return hr;
}

STDMETHODIMP Direct3DTexture_Unload(COMPtr* ptr) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(Unload);
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DTexture2
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DTexture2
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"  

STDMETHODIMP Direct3DTexture2_GetHandle(COMPtr* ptr, D3DPtr* lpDirect3DDevice, LPD3DTEXTUREHANDLE lpHandle) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    auto _that     = GetDevice2(lpDirect3DDevice);
    auto _that_imp = _that == nullptr ? nullptr : (IDirect3DDevice2*)_that.get()->I();
    //LAYER_COM_CALL(GetHandle, _that_imp, lpHandle);
    IDirect3DTexture2* _this_imp = (IDirect3DTexture2*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->GetHandle(_that_imp, lpHandle);
    if (FAILED(hr))
    {
        DBUG_WARN("::GetHandle Failed");
        return hr;
    }
    if (g_d3d.TEXTURE_SWAP_ENABLED)
    {
        _this->Sethandle((D3DTEXTUREHANDLE) *lpHandle);
    }
#ifdef LAYER_VERBOSE_LOGS
    DBUG_WARN("DD_OK")
#endif
    return hr;
}

STDMETHODIMP Direct3DTexture2_PaletteChanged(COMPtr* ptr, DWORD dwStart, DWORD dwCount) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(PaletteChanged, dwStart, dwCount);
}

STDMETHODIMP Direct3DTexture2_Load(COMPtr* ptr, LPDIRECT3DTEXTURE2 lpD3DTexture) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    auto _that    = lpD3DTexture == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpD3DTexture)->GetImp();
    auto _that_ez = EZInterface(IID_IDirect3DTexture2, _that);   
    //LAYER_COM_CALL(Load, (IDirect3DTexture2*)_that_ez.I());
    IDirect3DTexture2* _this_imp = (IDirect3DTexture2*)EZInterface(LAYER_GUID, _this->GetImp(DD_FOR::BLITING_TO)).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->Load((IDirect3DTexture2*)_that_ez.I());
    if (FAILED(hr))
    {
        DBUG_WARN("::Load Failed");
        return hr;
    }
    auto that = lpD3DTexture == nullptr ? nullptr : (DirectDrawSurface*) GetDirectDrawSurface((COMPtr*)lpD3DTexture);    
    if (g_d3d.TEXTURE_SWAP_ENABLED && that != nullptr && that->GetReplacement() != nullptr)
    {        
        DBUG_LOG((string("_that=[") + to_string((UINT)GetDirectDrawSurface((COMPtr*)lpD3DTexture)) + string("]")).c_str())
         _this->SetReplacement(that->GetReplacement());
    }
#ifdef LAYER_VERBOSE_LOGS
    DBUG_WARN("DD_OK")
#endif
    return hr;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirectDrawSurface7
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDrawSurface7
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"  

STDMETHODIMP DirectDrawSurface7_GetDDInterface(COMPtr* ptr, LPVOID FAR* lplpDD)
{
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC);
    IDirectDrawSurface* _this_imp = (IDirectDrawSurface*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    auto dd = GetSurfaceDDObjectWrapper(_this_imp);
    if (dd == nullptr)
    {
        DBUG_WARN("GetSurfaceDDObjectWrapper FAILED");
        return DDERR_GENERIC;
    }
    dd->PublicAddRef();
    *lplpDD = (IDirectDraw*)dd->GetDirectDraw7();
    return 0;
}

HRESULT WINAPI EnumSurfacesCallback7(LPDIRECTDRAWSURFACE7 lpDDSurface, LPDDSURFACEDESC2 lpDDSurfaceDesc, LPVOID lpContext)
{
    DDSURFACE_ENUM_CNTXT* ctx = (DDSURFACE_ENUM_CNTXT*)lpContext;
    DirectDrawSurface* s      = FindSurfaceWrapper(lpDDSurface, ctx->dd, "EnumSurfacesCallback7[lambda]");
    if (s == nullptr)
        return ctx->lpCallback7(nullptr, lpDDSurfaceDesc, ctx->Context);
    return ctx->lpCallback7((LPDIRECTDRAWSURFACE7)s->GetDirectDrawSurface7(), lpDDSurfaceDesc, ctx->Context);
};

STDMETHODIMP DirectDrawSurface7_EnumAttachedSurfaces(COMPtr* ptr, LPVOID lpContext, LPDDENUMSURFACESCALLBACK7 lpEnumSurfacesCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    if (lpEnumSurfacesCallback == nullptr)
        return DDERR_INVALIDPARAMS;
    IDirectDrawSurface7* _this_imp = (IDirectDrawSurface7*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    DDSURFACE_ENUM_CNTXT Ctx       = {GetSurfaceDDObjectWrapper(_this_imp), lpContext};
    Ctx.lpCallback7                = lpEnumSurfacesCallback;
    LAYER_COM_CALL(EnumAttachedSurfaces, (void**)&Ctx, EnumSurfacesCallback7);
}

STDMETHODIMP DirectDrawSurface7_EnumOverlayZOrders(COMPtr* ptr, DWORD dwFlags, LPVOID lpContext, LPDDENUMSURFACESCALLBACK7 lpfnCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    if (lpfnCallback == nullptr)
        return DDERR_INVALIDPARAMS;
    IDirectDrawSurface7* _this_imp = (IDirectDrawSurface7*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    DDSURFACE_ENUM_CNTXT Ctx       = {GetSurfaceDDObjectWrapper(_this_imp), lpContext};
    Ctx.lpCallback7                = lpfnCallback;
    LAYER_COM_CALL(EnumOverlayZOrders, dwFlags, (void**)&Ctx, EnumSurfacesCallback7);
}

STDMETHODIMP DirectDrawSurface7_GetAttachedSurface(COMPtr* ptr, LPDDSCAPS2 lpDDSCaps, LPDIRECTDRAWSURFACE7 FAR* lplpDDAttachedSurface) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    IDirectDrawSurface7* _this_imp = (IDirectDrawSurface7*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->GetAttachedSurface(lpDDSCaps, lplpDDAttachedSurface);
    if (FAILED(hr))
    {
        DBUG_WARN("FAILED")
        return hr;
    }
    DirectDrawSurface* srfc = FindSurfaceWrapper((IUnknown*)*lplpDDAttachedSurface, GetSurfaceDDObjectWrapper(_this_imp), __FUNCTION__);
    if (srfc == nullptr)
    {
        DBUG_WARN("FindSurfaceWrapper FAILED")
        return DDERR_GENERIC;
    }
    *lplpDDAttachedSurface = (IDirectDrawSurface7*)srfc->GetDirectDrawSurface7();
    return hr;
}

STDMETHODIMP DirectDrawSurface7_AddAttachedSurface(COMPtr* ptr, LPDIRECTDRAWSURFACE7 lpDDSAttachedSurface) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC)
    if (lpDDSAttachedSurface == nullptr) LAYER_COM_CALL(AddAttachedSurface, lpDDSAttachedSurface);
    auto _that     = GetDirectDrawSurface((COMPtr*)lpDDSAttachedSurface);
    auto _that_imp = _that == nullptr ? nullptr : (IDirectDrawSurface7*)EZInterface(LAYER_GUID, _that->GetImp()).I();
    LAYER_COM_CALL(AddAttachedSurface, _that_imp);
}

STDMETHODIMP DirectDrawSurface7_SetPriority(COMPtr* ptr, DWORD dwPriority) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(SetPriority, dwPriority);
}
STDMETHODIMP DirectDrawSurface7_GetPriority(COMPtr* ptr, LPDWORD lpdwPriority) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetPriority, lpdwPriority);
}
STDMETHODIMP DirectDrawSurface7_SetLOD(COMPtr* ptr, DWORD dwMaxLOD) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(SetLOD, dwMaxLOD);
}
STDMETHODIMP DirectDrawSurface7_GetLOD(COMPtr* ptr, LPDWORD lpdwMaxLOD) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawSurface, DDERR_GENERIC); LAYER_COM_CALL(GetLOD, lpdwMaxLOD);
}

struct IDIRECTDRAWSURFACE_VTABLE {
    decltype(DirectDrawSurface_QueryInterface)        * QueryInterface        = DirectDrawSurface_QueryInterface;
    decltype(DirectDrawSurface_AddRef)                * AddRef                = DirectDrawSurface_AddRef;
    decltype(DirectDrawSurface_Release)               * Release               = DirectDrawSurface_Release;
    decltype(DirectDrawSurface_AddAttachedSurface)    * AddAttachedSurface    = DirectDrawSurface_AddAttachedSurface;
    decltype(DirectDrawSurface_AddOverlayDirtyRect)   * AddOverlayDirtyRect   = DirectDrawSurface_AddOverlayDirtyRect;
    decltype(DirectDrawSurface_Blt)                   * Blt                   = DirectDrawSurface_Blt;
    decltype(DirectDrawSurface_BltBatch)              * BltBatch              = DirectDrawSurface_BltBatch;
    decltype(DirectDrawSurface_BltFast)               * BltFast               = DirectDrawSurface_BltFast;
    decltype(DirectDrawSurface_DeleteAttachedSurface) * DeleteAttachedSurface = DirectDrawSurface_DeleteAttachedSurface;
    decltype(DirectDrawSurface_EnumAttachedSurfaces)  * EnumAttachedSurfaces  = DirectDrawSurface_EnumAttachedSurfaces;
    decltype(DirectDrawSurface_EnumOverlayZOrders)    * EnumOverlayZOrders    = DirectDrawSurface_EnumOverlayZOrders;
    decltype(DirectDrawSurface_Flip)                  * Flip                  = DirectDrawSurface_Flip;
    decltype(DirectDrawSurface_GetAttachedSurface)    * GetAttachedSurface    = DirectDrawSurface_GetAttachedSurface;
    decltype(DirectDrawSurface_GetBltStatus)          * GetBltStatus          = DirectDrawSurface_GetBltStatus;
    decltype(DirectDrawSurface_GetCaps)               * GetCaps               = DirectDrawSurface_GetCaps;
    decltype(DirectDrawSurface_GetClipper)            * GetClipper            = DirectDrawSurface_GetClipper;
    decltype(DirectDrawSurface_GetColorKey)           * GetColorKey           = DirectDrawSurface_GetColorKey;
    decltype(DirectDrawSurface_GetDC)                 * GetDC                 = DirectDrawSurface_GetDC;    
    decltype(DirectDrawSurface_GetFlipStatus)         * GetFlipStatus         = DirectDrawSurface_GetFlipStatus;
    decltype(DirectDrawSurface_GetOverlayPosition)    * GetOverlayPosition    = DirectDrawSurface_GetOverlayPosition;
    decltype(DirectDrawSurface_GetPalette)            * GetPalette            = DirectDrawSurface_GetPalette;   
    decltype(DirectDrawSurface_GetPixelFormat)        * GetPixelFormat        = DirectDrawSurface_GetPixelFormat;
    decltype(DirectDrawSurface_GetSurfaceDesc)        * GetSurfaceDesc        = DirectDrawSurface_GetSurfaceDesc;
    decltype(DirectDrawSurface_Initialize)            * Initialize            = DirectDrawSurface_Initialize;
    decltype(DirectDrawSurface_IsLost)                * IsLost                = DirectDrawSurface_IsLost;
    decltype(DirectDrawSurface_Lock)                  * Lock                  = DirectDrawSurface_Lock;
    decltype(DirectDrawSurface_ReleaseDC)             * ReleaseDC             = DirectDrawSurface_ReleaseDC;
    decltype(DirectDrawSurface_Restore)               * Restore               = DirectDrawSurface_Restore;
    decltype(DirectDrawSurface_SetClipper)            * SetClipper            = DirectDrawSurface_SetClipper;
    decltype(DirectDrawSurface_SetColorKey)           * SetColorKey           = DirectDrawSurface_SetColorKey;
    decltype(DirectDrawSurface_SetOverlayPosition)    * SetOverlayPosition    = DirectDrawSurface_SetOverlayPosition;
    decltype(DirectDrawSurface_SetPalette)            * SetPalette            = DirectDrawSurface_SetPalette;
    decltype(DirectDrawSurface_Unlock)                * Unlock                = DirectDrawSurface_Unlock;
    decltype(DirectDrawSurface_UpdateOverlay)         * UpdateOverlay         = DirectDrawSurface_UpdateOverlay;
    decltype(DirectDrawSurface_UpdateOverlayDisplay)  * UpdateOverlayDisplay  = DirectDrawSurface_UpdateOverlayDisplay;
    decltype(DirectDrawSurface_UpdateOverlayZOrder)   * UpdateOverlayZOrder   = DirectDrawSurface_UpdateOverlayZOrder;
};
IDIRECTDRAWSURFACE_VTABLE IDirectDrawSurfaceVtable;

struct IDIRECTDRAWSURFACE2_VTABLE {
    IDIRECTDRAWSURFACE_VTABLE Vtable1;
    decltype(DirectDrawSurface2_GetDDInterface) * GetDDInterface = DirectDrawSurface2_GetDDInterface;
    decltype(DirectDrawSurface2_PageLock)       * PageLock       = DirectDrawSurface2_PageLock;
    decltype(DirectDrawSurface2_PageUnlock)     * PageUnlock     = DirectDrawSurface2_PageUnlock;    
};
IDIRECTDRAWSURFACE2_VTABLE IDirectDrawSurface2Vtable;

struct IDIRECTDRAWSURFACE3_VTABLE {
    IDIRECTDRAWSURFACE2_VTABLE Vtable2;
    decltype(DirectDrawSurface3_SetSurfaceDesc)* SetSurfaceDesc = DirectDrawSurface3_SetSurfaceDesc;    
};
IDIRECTDRAWSURFACE3_VTABLE IDirectDrawSurface3Vtable;

struct IDIRECTDRAWSURFACE4_VTABLE {
    /* Reimplementations:
        GetAttachedSurface
        GetCaps
        GetSurfaceDesc
        Unlock
        EnumAttachedSurfaces - even though the MS runtime doesn't reimplement it
    */
    decltype(DirectDrawSurface_QueryInterface)        * QueryInterface        = DirectDrawSurface_QueryInterface;
    decltype(DirectDrawSurface_AddRef)                * AddRef                = DirectDrawSurface_AddRef;
    decltype(DirectDrawSurface_Release)               * Release               = DirectDrawSurface_Release;
    decltype(DirectDrawSurface_AddAttachedSurface)    * AddAttachedSurface    = DirectDrawSurface_AddAttachedSurface;
    decltype(DirectDrawSurface_AddOverlayDirtyRect)   * AddOverlayDirtyRect   = DirectDrawSurface_AddOverlayDirtyRect;
    decltype(DirectDrawSurface_Blt)                   * Blt                   = DirectDrawSurface_Blt;
    decltype(DirectDrawSurface_BltBatch)              * BltBatch              = DirectDrawSurface_BltBatch;
    decltype(DirectDrawSurface_BltFast)               * BltFast               = DirectDrawSurface_BltFast;
    decltype(DirectDrawSurface_DeleteAttachedSurface) * DeleteAttachedSurface = DirectDrawSurface_DeleteAttachedSurface;
    decltype(DirectDrawSurface4_EnumAttachedSurfaces) * EnumAttachedSurfaces  = DirectDrawSurface4_EnumAttachedSurfaces;
    decltype(DirectDrawSurface4_EnumOverlayZOrders)   * EnumOverlayZOrders    = DirectDrawSurface4_EnumOverlayZOrders;
    decltype(DirectDrawSurface_Flip)                  * Flip                  = DirectDrawSurface_Flip;
    decltype(DirectDrawSurface4_GetAttachedSurface)   * GetAttachedSurface    = DirectDrawSurface4_GetAttachedSurface;
    decltype(DirectDrawSurface_GetBltStatus)          * GetBltStatus          = DirectDrawSurface_GetBltStatus;
    decltype(DirectDrawSurface4_GetCaps)              * GetCaps               = DirectDrawSurface4_GetCaps;
    decltype(DirectDrawSurface_GetClipper)            * GetClipper            = DirectDrawSurface_GetClipper;
    decltype(DirectDrawSurface_GetColorKey)           * GetColorKey           = DirectDrawSurface_GetColorKey;
    decltype(DirectDrawSurface_GetDC)                 * GetDC                 = DirectDrawSurface_GetDC;    
    decltype(DirectDrawSurface_GetFlipStatus)         * GetFlipStatus         = DirectDrawSurface_GetFlipStatus;
    decltype(DirectDrawSurface_GetOverlayPosition)    * GetOverlayPosition    = DirectDrawSurface_GetOverlayPosition;
    decltype(DirectDrawSurface_GetPalette)            * GetPalette            = DirectDrawSurface_GetPalette;   
    decltype(DirectDrawSurface_GetPixelFormat)        * GetPixelFormat        = DirectDrawSurface_GetPixelFormat;
    decltype(DirectDrawSurface4_GetSurfaceDesc)       * GetSurfaceDesc        = DirectDrawSurface4_GetSurfaceDesc;
    decltype(DirectDrawSurface_Initialize)            * Initialize            = DirectDrawSurface_Initialize;
    decltype(DirectDrawSurface_IsLost)                * IsLost                = DirectDrawSurface_IsLost;
    decltype(DirectDrawSurface_Lock)                  * Lock                  = DirectDrawSurface_Lock;
    decltype(DirectDrawSurface_ReleaseDC)             * ReleaseDC             = DirectDrawSurface_ReleaseDC;
    decltype(DirectDrawSurface_Restore)               * Restore               = DirectDrawSurface_Restore;
    decltype(DirectDrawSurface_SetClipper)            * SetClipper            = DirectDrawSurface_SetClipper;
    decltype(DirectDrawSurface_SetColorKey)           * SetColorKey           = DirectDrawSurface_SetColorKey;
    decltype(DirectDrawSurface_SetOverlayPosition)    * SetOverlayPosition    = DirectDrawSurface_SetOverlayPosition;
    decltype(DirectDrawSurface_SetPalette)            * SetPalette            = DirectDrawSurface_SetPalette;
    decltype(DirectDrawSurface4_Unlock)               * Unlock                = DirectDrawSurface4_Unlock;
    decltype(DirectDrawSurface_UpdateOverlay)         * UpdateOverlay         = DirectDrawSurface_UpdateOverlay;
    decltype(DirectDrawSurface_UpdateOverlayDisplay)  * UpdateOverlayDisplay  = DirectDrawSurface_UpdateOverlayDisplay;
    decltype(DirectDrawSurface_UpdateOverlayZOrder)   * UpdateOverlayZOrder   = DirectDrawSurface_UpdateOverlayZOrder;
    decltype(DirectDrawSurface2_GetDDInterface)       * GetDDInterface        = DirectDrawSurface2_GetDDInterface;
    decltype(DirectDrawSurface2_PageLock)             * PageLock              = DirectDrawSurface2_PageLock;
    decltype(DirectDrawSurface2_PageUnlock)           * PageUnlock            = DirectDrawSurface2_PageUnlock;  
    decltype(DirectDrawSurface4_SetSurfaceDesc)       * SetSurfaceDesc        = DirectDrawSurface4_SetSurfaceDesc;
    decltype(DirectDrawSurface4_SetPrivateData)       * SetPrivateData        = DirectDrawSurface4_SetPrivateData;
    decltype(DirectDrawSurface4_GetPrivateData)       * GetPrivateData        = DirectDrawSurface4_GetPrivateData;
    decltype(DirectDrawSurface4_FreePrivateData)      * FreePrivateData       = DirectDrawSurface4_FreePrivateData;
    decltype(DirectDrawSurface4_GetUniquenessValue)   * GetUniquenessValue    = DirectDrawSurface4_GetUniquenessValue;
    decltype(DirectDrawSurface4_ChangeUniquenessValue)* ChangeUniquenessValue = DirectDrawSurface4_ChangeUniquenessValue;
} IDirectDrawSurface4Vtable;

struct IDIRECT3DTECTURE_VTABLE {
    decltype(DirectDrawSurface_QueryInterface)        * QueryInterface        = DirectDrawSurface_QueryInterface;
    decltype(DirectDrawSurface_AddRef)                * AddRef                = DirectDrawSurface_AddRef;
    decltype(DirectDrawSurface_Release)               * Release               = DirectDrawSurface_Release;
    decltype(Direct3DTexture_Initialize)              * Initialize            = Direct3DTexture_Initialize;
    decltype(Direct3DTexture_GetHandle)               * GetHandle             = Direct3DTexture_GetHandle;
    decltype(Direct3DTexture_PaletteChanged)          * PaletteChanged        = Direct3DTexture_PaletteChanged;    
    decltype(Direct3DTexture_Load)                    * Load                  = Direct3DTexture_Load;
    decltype(Direct3DTexture_Unload)                  * Unload                = Direct3DTexture_Unload;
}IDirect3DTextureVtable;

struct IDIRECT3DTECTURE2_VTABLE {
    decltype(DirectDrawSurface_QueryInterface)        * QueryInterface        = DirectDrawSurface_QueryInterface;
    decltype(DirectDrawSurface_AddRef)                * AddRef                = DirectDrawSurface_AddRef;
    decltype(DirectDrawSurface_Release)               * Release               = DirectDrawSurface_Release;
    decltype(Direct3DTexture2_GetHandle)              * GetHandle             = Direct3DTexture2_GetHandle;
    decltype(Direct3DTexture2_PaletteChanged)         * PaletteChanged        = Direct3DTexture2_PaletteChanged;
    decltype(Direct3DTexture2_Load)                   * Load                  = Direct3DTexture2_Load;    
}IDirect3DTexture2Vtable;

struct IDIRECTDRAWSURFACE7_VTABLE {
    decltype(DirectDrawSurface_QueryInterface)        * QueryInterface        = DirectDrawSurface_QueryInterface;
    decltype(DirectDrawSurface_AddRef)                * AddRef                = DirectDrawSurface_AddRef;
    decltype(DirectDrawSurface_Release)               * Release               = DirectDrawSurface_Release;
    decltype(DirectDrawSurface7_AddAttachedSurface)   * AddAttachedSurface    = DirectDrawSurface7_AddAttachedSurface;
    decltype(DirectDrawSurface_AddOverlayDirtyRect)   * AddOverlayDirtyRect   = DirectDrawSurface_AddOverlayDirtyRect;
    decltype(DirectDrawSurface_Blt)                   * Blt                   = DirectDrawSurface_Blt;
    decltype(DirectDrawSurface_BltBatch)              * BltBatch              = DirectDrawSurface_BltBatch;
    decltype(DirectDrawSurface_BltFast)               * BltFast               = DirectDrawSurface_BltFast;
    decltype(DirectDrawSurface_DeleteAttachedSurface) * DeleteAttachedSurface = DirectDrawSurface_DeleteAttachedSurface;
    decltype(DirectDrawSurface7_EnumAttachedSurfaces) * EnumAttachedSurfaces  = DirectDrawSurface7_EnumAttachedSurfaces;
    decltype(DirectDrawSurface7_EnumOverlayZOrders)   * EnumOverlayZOrders    = DirectDrawSurface7_EnumOverlayZOrders;
    decltype(DirectDrawSurface_Flip)                  * Flip                  = DirectDrawSurface_Flip;
    decltype(DirectDrawSurface7_GetAttachedSurface)   * GetAttachedSurface    = DirectDrawSurface7_GetAttachedSurface;
    decltype(DirectDrawSurface_GetBltStatus)          * GetBltStatus          = DirectDrawSurface_GetBltStatus;
    decltype(DirectDrawSurface4_GetCaps)              * GetCaps               = DirectDrawSurface4_GetCaps;
    decltype(DirectDrawSurface_GetClipper)            * GetClipper            = DirectDrawSurface_GetClipper;
    decltype(DirectDrawSurface_GetColorKey)           * GetColorKey           = DirectDrawSurface_GetColorKey;
    decltype(DirectDrawSurface_GetDC)                 * GetDC                 = DirectDrawSurface_GetDC;    
    decltype(DirectDrawSurface_GetFlipStatus)         * GetFlipStatus         = DirectDrawSurface_GetFlipStatus;
    decltype(DirectDrawSurface_GetOverlayPosition)    * GetOverlayPosition    = DirectDrawSurface_GetOverlayPosition;
    decltype(DirectDrawSurface_GetPalette)            * GetPalette            = DirectDrawSurface_GetPalette;   
    decltype(DirectDrawSurface_GetPixelFormat)        * GetPixelFormat        = DirectDrawSurface_GetPixelFormat;
    decltype(DirectDrawSurface4_GetSurfaceDesc)       * GetSurfaceDesc        = DirectDrawSurface4_GetSurfaceDesc;
    decltype(DirectDrawSurface_Initialize)            * Initialize            = DirectDrawSurface_Initialize;
    decltype(DirectDrawSurface_IsLost)                * IsLost                = DirectDrawSurface_IsLost;
    decltype(DirectDrawSurface_Lock)                  * Lock                  = DirectDrawSurface_Lock;
    decltype(DirectDrawSurface_ReleaseDC)             * ReleaseDC             = DirectDrawSurface_ReleaseDC;
    decltype(DirectDrawSurface_Restore)               * Restore               = DirectDrawSurface_Restore;
    decltype(DirectDrawSurface_SetClipper)            * SetClipper            = DirectDrawSurface_SetClipper;
    decltype(DirectDrawSurface_SetColorKey)           * SetColorKey           = DirectDrawSurface_SetColorKey;
    decltype(DirectDrawSurface_SetOverlayPosition)    * SetOverlayPosition    = DirectDrawSurface_SetOverlayPosition;
    decltype(DirectDrawSurface_SetPalette)            * SetPalette            = DirectDrawSurface_SetPalette;
    decltype(DirectDrawSurface4_Unlock)               * Unlock                = DirectDrawSurface4_Unlock;
    decltype(DirectDrawSurface_UpdateOverlay)         * UpdateOverlay         = DirectDrawSurface_UpdateOverlay;
    decltype(DirectDrawSurface_UpdateOverlayDisplay)  * UpdateOverlayDisplay  = DirectDrawSurface_UpdateOverlayDisplay;
    decltype(DirectDrawSurface_UpdateOverlayZOrder)   * UpdateOverlayZOrder   = DirectDrawSurface_UpdateOverlayZOrder;
    decltype(DirectDrawSurface7_GetDDInterface)       * GetDDInterface        = DirectDrawSurface7_GetDDInterface;
    decltype(DirectDrawSurface2_PageLock)             * PageLock              = DirectDrawSurface2_PageLock;
    decltype(DirectDrawSurface2_PageUnlock)           * PageUnlock            = DirectDrawSurface2_PageUnlock;  
    decltype(DirectDrawSurface4_SetSurfaceDesc)       * SetSurfaceDesc        = DirectDrawSurface4_SetSurfaceDesc;
    decltype(DirectDrawSurface4_SetPrivateData)       * SetPrivateData        = DirectDrawSurface4_SetPrivateData;
    decltype(DirectDrawSurface4_GetPrivateData)       * GetPrivateData        = DirectDrawSurface4_GetPrivateData;
    decltype(DirectDrawSurface4_FreePrivateData)      * FreePrivateData       = DirectDrawSurface4_FreePrivateData;
    decltype(DirectDrawSurface4_GetUniquenessValue)   * GetUniquenessValue    = DirectDrawSurface4_GetUniquenessValue;
    decltype(DirectDrawSurface4_ChangeUniquenessValue)* ChangeUniquenessValue = DirectDrawSurface4_ChangeUniquenessValue;
    decltype(DirectDrawSurface7_SetPriority)          * SetPriority           = DirectDrawSurface7_SetPriority;
    decltype(DirectDrawSurface7_GetPriority)          * GetPriorit            = DirectDrawSurface7_GetPriority;
    decltype(DirectDrawSurface7_SetLOD)               * SetLOD                = DirectDrawSurface7_SetLOD;
    decltype(DirectDrawSurface7_GetLOD)               * GetLOD                = DirectDrawSurface7_GetLOD;
}IDirectDrawSurface7Vtable;

DirectDrawSurface::DirectDrawSurface(DirectDraw* dd, IUnknown* surface, DWORD creation_flags) : PrivateDataObject(surface)
{
    m_ddsrfc  = {(LPVOID)&IDirectDrawSurfaceVtable,  (LPVOID)this};
    m_ddsrfc2 = {(LPVOID)&IDirectDrawSurface2Vtable, (LPVOID)this};
    m_ddsrfc3 = {(LPVOID)&IDirectDrawSurface3Vtable, (LPVOID)this};
    m_ddsrfc4 = {(LPVOID)&IDirectDrawSurface4Vtable, (LPVOID)this};
    m_ddsrfc7 = {(LPVOID)&IDirectDrawSurface7Vtable, (LPVOID)this};
    m_tex     = {(LPVOID)&IDirect3DTextureVtable,    (LPVOID)this};
    m_tex2    = {(LPVOID)&IDirect3DTexture2Vtable,   (LPVOID)this};
    m_dvc     = {(LPVOID)GetD3DDeviceVtable(),       (LPVOID)this, surface, TRUE} ;
    m_Imp     = surface;
    m_lock    = new SYNC::AtomicLock();
    if (!(creation_flags == (DWORD)* (DWORD*)"MIPSUBLVL")) D3DGlobals.InsertSurface(this);
    SetSurfacePrivateData(surface, dynamic_cast<PrivateDataObject*>(this),  __FUNCTION__);
    SetSurfacePrivateData(surface, dynamic_cast<PrivateDataObjectParent*>(dd), DIRECTDRAW_ID::DDRAW, __FUNCTION__);
    auto desc = this->GetDesc();
    m_IsA8    = desc.get()->ddpfPixelFormat.dwRGBBitCount == 8 && desc.get()->ddpfPixelFormat.dwFlags & DDPF_ALPHA;   
}
DirectDrawSurface::~DirectDrawSurface(){
    D3DGlobals.RemoveSurface(this); 
    if (m_this_handle != 0)
        D3DGlobals.RemoveHandle(m_this_handle);
    DiscardReplacmenet();
    DiscardSysMem();
};
unique_ptr<wstring>DirectDrawSurface::Describe()
{
    auto desc_string = unique_ptr<wstring>(new wstring());
    auto  desc       = this->GetDesc();
    if      (desc.get()->ddsCaps.dwCaps  & DDSCAPS_TEXTURE)        { desc_string.get()->append(L"TEXTURE ");        }
    else if (desc.get()->ddsCaps.dwCaps  & DDSCAPS_ZBUFFER)        { desc_string.get()->append(L"ZBUFFER ");        }
    else if (desc.get()->ddsCaps.dwCaps  & DDSCAPS_PRIMARYSURFACE) { desc_string.get()->append(L"PRIMARY ");        }
    if      (desc.get()->ddsCaps.dwCaps  & DDSCAPS_3DDEVICE)       { desc_string.get()->append(L"RENDER TARGET ");  }
    if      (desc.get()->ddsCaps.dwCaps2 & DDSCAPS2_TEXTUREMANAGE) { desc_string.get()->append(L"MANAGED ");        }
    else if (desc.get()->ddsCaps.dwCaps  & DDSCAPS_VIDEOMEMORY)    { desc_string.get()->append(L"VIDEO ");          }
    else if (desc.get()->ddsCaps.dwCaps  & DDSCAPS_SYSTEMMEMORY)   { desc_string.get()->append(L"SYSTEM ");         }
    if      (desc.get()->ddsCaps.dwCaps2 & DDSCAPS2_HINTDYNAMIC)   { desc_string.get()->append(L"DYNAMIC "); }
    *desc_string.get() += L"\n";
    *desc_string.get() += DescribeDDSrfcPixelFormat(&desc.get()->ddpfPixelFormat).get()->c_str();
    *desc_string.get() += L" ";
    *desc_string.get() += to_wstring(desc.get()->dwWidth) + L"x" + to_wstring(desc.get()->dwHeight);
    *desc_string.get() += L"\n";
    return desc_string;
}

void DirectDrawSurface::Sethandle(D3DTEXTUREHANDLE h) {
    m_this_handle = h;
    D3DGlobals.InsertHandle(m_this_handle, this);
}

D3DTEXTUREHANDLE DirectDrawSurface::Gethandle(IDirect3DDevice2* d) {
    if (this->GetReplacement() == nullptr) return this->m_this_handle;
    if (m_rep_handle == 0) {
        auto tx2 = (IDirect3DTexture2*) EZInterface(IID_IDirect3DTexture2, m_Replacement).I();
        if (tx2 == nullptr) {
            DBUG_WARN("::QueryInterface FAILED");
            return m_this_handle;
        };
        if (tx2->GetHandle(d, &m_rep_handle) != S_OK) {
            DBUG_WARN("::GetHandle FAILED");
            return m_this_handle;
        } else DBUG_LOG("::GetHandle OK");
        return m_rep_handle;
    }
    return m_rep_handle;
}

D3DTEXTUREHANDLE DirectDrawSurface::Gethandle(IDirect3DDevice* d) {
    if (this->GetReplacement() == nullptr) return this->m_this_handle;
    if (m_rep_handle == 0) {
        auto tx2 = (IDirect3DTexture*)EZInterface(IID_IDirect3DTexture, m_Replacement).I();
        if (tx2 == nullptr) {
            DBUG_WARN("::QueryInterface FAILED");
            return m_this_handle;
        };
        if (tx2->GetHandle(d, &m_rep_handle) != S_OK) {
            DBUG_WARN("::GetHandle FAILED");
            return m_this_handle;
        }
        else DBUG_LOG("::GetHandle OK");
        return m_rep_handle;
    }
    return m_rep_handle;
}

IUnknown* DirectDrawSurface::GetImp(DD_FOR For) {
    if (For == DD_FOR::LOCKING)
    {
        this->DiscardReplacmenet();
        if (!g_d3d.TEXTURE_SWAP_MANAGE) return m_Imp;
        //return m_SysMem == nullptr ? m_Imp : m_SysMem; // Crash slave zero
        if (this->GetCaps().get()->dwCaps & (DDSCAPS_VIDEOMEMORY))
        {
            if (m_SysMem == nullptr) {
                DDrawCreateSurfacefromSurface(this, &m_SysMem, DDSCAPS_SYSTEMMEMORY|DDSCAPS_TEXTURE, "SAME");
                if (m_SysMem == nullptr) DBUG_WARN("DDrawCreateSurfacefromSurface FAILED")
                else                     UpdateSysMem();
            }            
        }
        return m_SysMem == nullptr ? m_Imp : m_SysMem;
    }
    else if (For == DD_FOR::UNLOCKING) {
        return m_SysMem == nullptr ? m_Imp : m_SysMem;
    }
    else if (For == DD_FOR::BLITING_TO) {this->DiscardReplacmenet(); this->DiscardSysMem();}
    else if (For == DD_FOR::BIND_AS_TEXTURE) {
        if (m_Replacement != nullptr) return m_Replacement;
        if (m_IsA8 && g_d3d.TEXTURE_SWAP_A8FIX) {
            DDrawCreateSurfacefromSurface(this, &m_Replacement, DDSCAPS_VIDEOMEMORY|DDSCAPS_TEXTURE, "A8RGB");
            if (m_Replacement == nullptr) return m_Imp;
            auto A8Ez    = (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, m_Imp).I();
            auto A8RGBEz = (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, m_Replacement).I();

            DDSURFACEDESC  A8Desc    = { sizeof(DDSURFACEDESC) };
            DDSURFACEDESC  A8RGBDesc = { sizeof(DDSURFACEDESC) };           
            if (A8Ez->Lock(nullptr, &A8Desc, DDLOCK_WRITEONLY, nullptr) != S_OK)
            {
                DBUG_WARN("::Lock() FAIED");
                return m_Imp;
            }
            if (A8RGBEz->Lock(nullptr, &A8RGBDesc, DDLOCK_WRITEONLY, nullptr) != S_OK)
            {
                A8Ez->Unlock(nullptr);
                DBUG_WARN("::Lock() FAIED");
                return m_Imp;
            }
            UINT pixel, line;
            DWORD * rgba;
            BYTE  * alpha;
            for (line = 0; line < A8Desc.dwWidth; line++)
            {
                for (pixel = 0; pixel < A8Desc.dwHeight; pixel++)
                {
                    rgba   = (DWORD*)(DWORD)((DWORD)A8RGBDesc.lpSurface + (DWORD)A8RGBDesc.lPitch * line);
                    rgba  += pixel;
                    alpha  = (BYTE*)(DWORD)((DWORD)A8Desc.lpSurface + (DWORD)A8Desc.lPitch * line);
                    alpha += pixel;
                    *rgba  = 0x00ffffff | (*alpha << 24);
                }
            }
            A8RGBEz->Unlock(nullptr);
            A8Ez->Unlock(nullptr);
            return m_Replacement == nullptr ? m_Imp : m_Replacement;
        }
    }
    return m_Imp;
}

extern "C" __declspec(dllexport) STDMETHODIMP __stdcall DDrawsSurfaceLayerTest() {
    g_d3d.Init();
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirectDraw  * dd  = nullptr;
    IDirectDraw  * DD  = nullptr;
    IDirectDraw4 * dd4 = nullptr;
    IDirectDraw2 * dd2 = nullptr;
    if (g_d3d.m_DirectDrawCreate(NULL, &dd, NULL) != S_OK)
    {
        DBUG_WARN("DirectDrawCreate FAILED");
        return 1;
    }
    DirectDraw* d = new DirectDraw((IUnknown*)dd, 1);
    DD = (IDirectDraw*)d->GetDirectDraw1();
        
    if (DD->SetCooperativeLevel(0, DDSCL_NORMAL) != S_OK)
    {
        DBUG_WARN("SetCooperativeLevel FAILED");
        return 2;
    }     
    IDirectDrawSurface4 * dds4 = nullptr;
    IDirectDrawSurface  * dds  = nullptr;
    DDSURFACEDESC srfc_desc    = {sizeof(DDSURFACEDESC)};           
    srfc_desc.dwFlags          = DDSD_CAPS;
    srfc_desc.ddsCaps.dwCaps   = DDSCAPS_PRIMARYSURFACE;
    if (DD->CreateSurface(&srfc_desc, &dds, nullptr) != S_OK)
    {
        DBUG_WARN("CreateSurface FAILED");
        return 2;
    }
    if (dds->QueryInterface(IID_IDirectDrawSurface4, (void**)&dds4) != S_OK)
    {
        DBUG_WARN("QueryInterface FAILED");
        return 3;
    }
    dds->IsLost();
    DBUG_WARN((STR("Surface release ") + to_string(dds->Release())).c_str());
    DBUG_WARN((STR("Surface release ") + to_string(dds4->Release())).c_str());
    return DD->Release();;
}

extern "C" __declspec(dllexport) STDMETHODIMP __stdcall DD3D1DeviceLayerTest() {
    g_d3d.Init();
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirectDraw* dd = nullptr;
    IDirectDraw* DD = nullptr;    
    if (g_d3d.m_DirectDrawCreate(NULL, &dd, NULL) != S_OK)
    {
        DBUG_WARN("DirectDrawCreate FAILED");
        return 1;
    }
    auto* d = (new DirectDraw((IUnknown*)dd, 1))->GetDirectDraw1();
    DD = (IDirectDraw*)d;
    //DD = dd;
    if (DD->SetCooperativeLevel(0, DDSCL_NORMAL) != S_OK)
    {
        DBUG_WARN("SetCooperativeLevel FAILED");
        return 2;
    }    
    IDirectDrawSurface* dds  = nullptr;
    DDSURFACEDESC srfc_desc  = { sizeof(DDSURFACEDESC) };
    srfc_desc.dwFlags        = DDSD_CAPS;
    srfc_desc.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE| DDSCAPS_3DDEVICE;    
    if (DD->CreateSurface(&srfc_desc, &dds, nullptr) != S_OK)
    {
        DBUG_WARN("CreateSurface FAILED");
        return 2;
    }
    dds->IsLost();      
    srfc_desc  = { sizeof(DDSURFACEDESC) };
    srfc_desc.dwFlags        = DDSD_CAPS|DDSD_PIXELFORMAT|DDSD_WIDTH|DDSD_HEIGHT;
    srfc_desc.ddsCaps.dwCaps = DDSCAPS_3DDEVICE| DDSCAPS_VIDEOMEMORY;
    srfc_desc.dwWidth        = 640;
    srfc_desc.dwHeight       = 480;
    DWORD RG6B[4]                           = { 0x00FF0000, 0x0000FF00, 0x000000FF, 0 };
    srfc_desc.ddpfPixelFormat.dwFlags       = DDPF_RGB;
    srfc_desc.ddpfPixelFormat.dwRGBBitCount = 32;
    memcpy(&srfc_desc.ddpfPixelFormat.dwRBitMask, RG6B, sizeof(DWORD) * 4);
    IDirectDrawSurface* dds2 = nullptr;
    if (DD->CreateSurface(&srfc_desc, &dds2, nullptr) != S_OK)
    {
        DBUG_WARN("CreateSurface FAILED");
        return 22;
    }
    IDirectDraw* dd2 = nullptr;
    if (dd->QueryInterface(IID_IDirectDraw2, (void**)&dd2) != S_OK)
    {
        DBUG_WARN("Create IID_IDirectDraw2 FAILED");
        return 4;
    }    
    IDirect3D2* d3d2 = nullptr;
    if (dd2->QueryInterface(IID_IDirect3D2, (void**)&d3d2) != S_OK)
    {
        DBUG_WARN("Create d3d FAILED");
        return 5;
    }  
    IDirect3DDevice2* dvc2 = nullptr;
    if (d3d2->CreateDevice(IID_IDirect3DRGBDevice, dds, &dvc2) != S_OK)
    {
        DBUG_WARN("Create device FAILED");
        return 3;
    }
    IDirect3D* d3d = nullptr;
    if (dd2->QueryInterface(IID_IDirect3D, (void**)&d3d) != S_OK)
    {
        DBUG_WARN("Create d3d FAILED");
        return 5;
    }
    IDirect3DDevice* dvc = nullptr;
    if (dds->QueryInterface(IID_IDirect3DHALDevice, (void**)&dvc) != S_OK)
    {
        DBUG_WARN("Create device FAILED");
        return 33;
    }   
    D3DEXECUTEBUFFERDESC ebuff_desc;
    ZeroMemory(&ebuff_desc, sizeof(D3DEXECUTEBUFFERDESC));
    ebuff_desc.dwSize       = sizeof(D3DEXECUTEBUFFERDESC);
    ebuff_desc.dwFlags      = D3DDEB_BUFSIZE;
    ebuff_desc.dwBufferSize = 16;
    ebuff_desc.lpData       = malloc(16);
    IDirect3DExecuteBuffer* ibuff  = nullptr;
    HRESULT hr = dvc->CreateExecuteBuffer(&ebuff_desc, &ibuff, nullptr);
    if (hr == DDERR_INVALIDPARAMS)
    {
        DBUG_WARN("CreateExecuteBuffer FAILED (DDERR_INVALIDPARAMS )");
        return 6;
    }
    else if (hr == DDERR_INVALIDOBJECT)
    {
        DBUG_WARN("CreateExecuteBuffer FAILED (DDERR_INVALIDOBJECT )");
        return 7;
    }
    d3d->EnumDevices(nullptr, nullptr);

    IDirect3DExecuteBuffer* ibuff2 = nullptr;
    if (ibuff->QueryInterface(IID_IDirect3DExecuteBuffer, (void**)&ibuff2) != S_OK)
    {
        DBUG_WARN("IDirect3DExecuteBuffer::QueryInterface FAILED");
        return 8;
    }

    DBUG_WARN(to_string((long)d3d->Release()).c_str());
    DBUG_WARN(to_string((long)Direct3DDevice_Initialize(nullptr, nullptr, nullptr, nullptr)).c_str());
    DBUG_WARN(to_string((long)dvc->Initialize(nullptr, nullptr, nullptr)     ).c_str());
    DBUG_WARN(to_string((long)dvc->BeginScene() ).c_str());

    return DD->Release();
 }