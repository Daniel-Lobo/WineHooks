#include <ddraw.h>
#include "DirectDraw.h"
#include <dllmain.h>
#include "D3D12Hooks.h"
#include <string>
#include "EZString.h"
#include "D3DHooks.h"
using std::string;
using std::to_string;

//#define DBUG_LOG(string) ;
//#define DBUG_WARN(string) ;

extern "C" __declspec(dllexport) STDMETHODIMP __stdcall DDrawLayerTest() {
    g_d3d.Init();
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirectDraw* dd = nullptr;
    IDirectDraw* DD = nullptr;
    if (g_d3d.m_DirectDrawCreate(NULL, &dd, NULL) != S_OK)
    {
        DBUG_WARN("DirectDrawCreate FAILED");
        return 1;
    }    
    DirectDraw * d = new DirectDraw((IUnknown*)dd, 1);
    DD = (IDirectDraw*)d->GetDirectDraw1();

    //DD = dd;
    DWORD freq = 0;
    DD->GetMonitorFrequency(&freq);
    DD->Compact();
    DBUG_WARN(std::to_string(DD->AddRef()).c_str());
    DBUG_WARN(std::to_string(DD->Release()).c_str());
    DBUG_WARN(std::to_string(freq).c_str());    
    DD->SetCooperativeLevel(0, DDSCL_NORMAL);

    IDirectDraw2* dd2 = nullptr;
    if (DD->QueryInterface(IID_IDirectDraw2, (void**)&dd2) != S_OK)
    {
        DBUG_WARN("QueryInterface");
        return 2;
    }
   
    IDirectDrawSurface* dds = nullptr;
    DDSURFACEDESC srfc_desc = { sizeof(DDSURFACEDESC) };
    srfc_desc.dwFlags = DDSD_CAPS;
    srfc_desc.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE | DDSCAPS_3DDEVICE;
    if (dd2->CreateSurface(&srfc_desc, &dds, nullptr) != S_OK)
    {
        DBUG_WARN("CreateSurface FAILED");
        return 2;
    }
    dds->IsLost();
    
    return DD->Release();;
}

unique_ptr<string> DDD_ParseError(HRESULT err)
{
    auto str = new string((to_string((ULONG)err) + ": ").c_str());
    if      (err == DDERR_EXPIRED)         str->append("DDERR_EXPIRED");
    else if (err == DDERR_INVALIDOBJECT)   str->append("DDERR_INVALIDOBJECT");
    else if (err == DDERR_INVALIDPARAMS)   str->append("DDERR_INVALIDPARAMS");
    else if (err == DDERR_MOREDATA)        str->append("DDERR_MOREDATA");
    else if (err == DDERR_NOTFOUND)        str->append("DDERR_NOTFOUND");
    else if (err == DDERR_OUTOFMEMORY)     str->append("DDERR_OUTOFMEMORY");    
    else if (err == DDERR_GENERIC)         str->append("DDERR_GENERIC");
    else if (err == DDERR_INVALIDCLIPLIST) str->append("DDERR_INVALIDCLIPLIST");
    else if (err == DDERR_INVALIDRECT)     str->append("DDERR_INVALIDRECT");
    else if (err == DDERR_NOALPHAHW)       str->append("DDERR_NOALPHAHW");
    else if (err == DDERR_NOBLTHW)         str->append("DDERR_NOBLTHW");   
    else if (err == DDERR_NOCLIPLIST)      str->append("DDERR_NOCLIPLIST");
    else if (err == DDERR_NODDROPSHW)      str->append("DDERR_NODDROPSHW");
    else if (err == DDERR_NOMIRRORHW)      str->append("DDERR_NOMIRRORHW");
    else if (err == DDERR_NORASTEROPHW)    str->append("DDERR_NORASTEROPHW");
    else if (err == DDERR_NOROTATIONHW)    str->append("DDERR_NOROTATIONHW");    
    else if (err == DDERR_NOSTRETCHHW)     str->append("DDERR_NOSTRETCHHW");
    else if (err == DDERR_NOZBUFFERHW)     str->append("DDERR_NOZBUFFERHW");
    else if (err == DDERR_SURFACELOST)     str->append("DDERR_SURFACELOST");
    else if (err == DDERR_UNSUPPORTED)     str->append("DDERR_UNSUPPORTED");
    else if (err == DDERR_WASSTILLDRAWING) str->append("DDERR_WASSTILLDRAWING");
    else if (err == DDERR_NOBLTHW)         str->append("DDERR_NOBLTHW");
    else if (err == DDERR_SURFACEBUSY)     str->append("DDERR_SURFACEBUSY");  
    else if (err == DDERR_NOTLOCKED)       str->append("DDERR_NOTLOCKED");
    else if (err == DDERR_SURFACELOST)     str->append("DDERR_SURFACELOST");
    return unique_ptr<string>(str);
}

extern "C" __declspec(dllexport) COMPtr* __stdcall WrappDDrawObject(IUnknown* dd) {
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return (new DirectDraw(dd, 0))->GetDirectDraw1();
}

extern "C" __declspec(dllexport) COMPtr* __stdcall WrappDDraw7Object(IUnknown* dd7) {
#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return (new DirectDraw(dd7, 0))->GetDirectDraw7();
}

DirectDraw* GetDirectDraw(COMPtr * ptr)
{
	if     (ptr == nullptr) return nullptr;
	return (DirectDraw* )   ptr->COMObjct;
}   

#undef  LAYER_THIS
#define LAYER_THIS IDirectDraw
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDraw
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP DirectDraw_QueryInterface(COMPtr* ptr, REFIID riid, void** ppvObj)
{
    LAYER_LOG_CALL  GET_COM_PTR(DirectDraw, DDERR_GENERIC) if (ppvObj == nullptr) return E_POINTER;

    if (riid == IID_IUnknown || riid == IID_IDirectDraw) {
        *ppvObj = _this->GetDirectDraw1(); _this->PublicAddRef(); DBUG_LOG("DirectDraw1")  return 0;
    }    
    else if (riid == IID_IDirectDraw4) {
        *ppvObj = _this->GetDirectDraw4(); _this->PublicAddRef(); DBUG_LOG("DirectDraw4")  return 0;
    }
    else if (riid == IID_IDirectDraw7) {
        *ppvObj = _this->GetDirectDraw7(); _this->PublicAddRef(); DBUG_LOG("DirectDraw7")  return 0;
    }
    else if (riid == IID_IDirect3D) {
        *ppvObj = _this->GetDirect3D1();   _this->PublicAddRef(); DBUG_LOG("IDirect3D")    return 0;
    }
    else if (riid == IID_IDirect3D2) {
        *ppvObj = _this->GetDirect3D2();   _this->PublicAddRef(); DBUG_LOG("IDirect3D2")   return 0;
    }
    else if (riid == IID_IDirect3D3) {
        *ppvObj = _this->GetDirect3D3();   _this->PublicAddRef(); DBUG_LOG("IDirect3D3")   return 0;
    }
    else if (riid == IID_IDirect3D7) {
        *ppvObj = _this->GetDirect3D7();   _this->PublicAddRef(); DBUG_WARN("IDirect3D37")  return 0;
    }
    else if (riid == IID_IDirectDraw2) {
#ifndef DDRAW_SEPARATE_REF_COUNTS
        *ppvObj = _this->GetDirectDraw2(); _this->PublicAddRef(); DBUG_LOG("DirectDraw2")  return 0;
#else
        if (_this->GetImp2() == nullptr)
        {
            HRESULT HR = _this->GetImp()->QueryInterface(riid, ppvObj);
            if (FAILED(HR))
            {
                DBUG_WARN("QueryInterface(IID_IDirectDraw2...) FAILED");
                return HR;
            }
            *ppvObj = _this->SetDD2((IDirectDraw2*)*ppvObj);
            _this->SetRef2(1);
            DBUG_LOG("DirectDraw2")
            return HR;
        } else {
            *ppvObj = _this->GetDirectDraw2(); _this->GetImp2()->AddRef();
            DBUG_LOG("DirectDraw2")
            return 0;
        }       
#endif
    }
    
    ULONG hr = _this->GetImp()->QueryInterface(riid, ppvObj);
    DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str() + " Implementation hr=" + to_string(hr)).c_str());
    return hr;
}

ULONG __stdcall DirectDraw_Release(COMPtr* ptr) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDraw, DDERR_GENERIC)
#ifndef DDRAW_SEPARATE_REF_COUNTS    
    ULONG ref = _this->PublicRelease();	DBUG_LOG(to_string(ref).c_str());
    if (ref == 0)
    {   
        delete _this;
        return 0;
    }
    return ref - 1;
#else
    LONG ref =  _this->SetRef(_this->PublicRelease());
    DBUG_LOG(to_string((ULONG)ref).c_str())
    return ref;
#endif
}

ULONG __stdcall DirectDraw_AddRef(COMPtr* ptr) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    ULONG ref = _this->PublicAddRef();  DBUG_LOG(to_string(ref).c_str()); return ref;
}

STDMETHODIMP DirectDraw_Compact(COMPtr* ptr) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(Compact);
}

STDMETHODIMP DirectDraw_CreateClipper(COMPtr* ptr, DWORD dwFlags, LPDIRECTDRAWCLIPPER FAR* lplpDDClipper, IUnknown FAR* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC);
    auto ez = EZInterface(IID_IDirectDraw, _this->GetImp());
    auto dd = (IDirectDraw *)ez.I();
    if (dd == nullptr)  {
        DBUG_WARN("QueryInterface FAILED"); return DDERR_GENERIC;
    }   
    HRESULT hr = dd->CreateClipper(dwFlags, lplpDDClipper, pUnkOuter);    
    if (FAILED(hr)) {
        DBUG_WARN("CreateClipper FAILED") return hr;
    }
    auto * cliper   = new DirectDrawClipper(*lplpDDClipper);
    *lplpDDClipper  = (IDirectDrawClipper*)cliper->GetClipper();
    DBUG_LOG((string("Created Cliper =[") + to_string((long)*lplpDDClipper)).c_str());
    return hr;
}

STDMETHODIMP DirectDraw_CreatePalette(COMPtr* ptr, DWORD dwFlags, LPPALETTEENTRY lpColorTable,  LPDIRECTDRAWPALETTE FAR* lplpDDPalette,  IUnknown FAR* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto ez = EZInterface(IID_IDirectDraw, _this->GetImp());
    auto dd = (IDirectDraw *)ez.I();
    if (dd == nullptr) {
        DBUG_WARN("QueryInterface FAILED"); return DDERR_GENERIC;
    }
    HRESULT hr = dd->CreatePalette(dwFlags, lpColorTable, lplpDDPalette, pUnkOuter);
    if (FAILED(hr)) {
        DBUG_WARN("CreateClipper FAILED") return hr;
    }
    auto* palette  = new DirectDrawPalette(*lplpDDPalette);
    DBUG_LOG((string("Created Palette =[") + to_string((long)palette) + "]").c_str());
    *lplpDDPalette = (IDirectDrawPalette*)palette->GetPalette();    
    return hr;
}

STDMETHODIMP DirectDraw_CreateSurface(COMPtr* ptr, LPDDSURFACEDESC lpDDSurfaceDesc, LPDIRECTDRAWSURFACE FAR* lplpDDSurface, IUnknown FAR* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)    
    auto _this_ez =  EZInterface(LAYER_GUID, _this->GetImp());
    if (_this_ez.I() == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }   
    HRESULT hr = ((IDirectDraw*)_this_ez.I())->CreateSurface(lpDDSurfaceDesc, lplpDDSurface, pUnkOuter);   
    if (S_OK != hr)
    {
        DBUG_WARN((STR("CreateSurface FAILED: ") + *DDD_ParseError(hr).get()).c_str());
        return DDERR_GENERIC;
    }
    DirectDrawSurface* srfc = new DirectDrawSurface(_this, (IUnknown*)*lplpDDSurface, 1);
    *lplpDDSurface          = (IDirectDrawSurface *) srfc->GetDirectDrawSurface1();    
    DBUG_LOG((string("Created Surface: ") + to_string((long)srfc)).c_str());
    return 0;
}

STDMETHODIMP DirectDraw_DuplicateSurface(COMPtr* ptr, LPDIRECTDRAWSURFACE lpDDSurface, LPDIRECTDRAWSURFACE FAR* lplpDupDDSurface) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    IDirectDraw* _this_imp = (IDirectDraw*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    auto             _that = lpDDSurface == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpDDSurface);
    auto         _that_imp = _that       == nullptr ? nullptr : (IDirectDrawSurface*) EZInterface(IID_IDirectDrawSurface, _that->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->DuplicateSurface(lpDDSurface, lplpDupDDSurface);
    if (S_OK != hr)
    {
        DBUG_WARN("CreateSurface");
        return DDERR_GENERIC;
    }
    DirectDrawSurface* srfc = new DirectDrawSurface(_this, (IUnknown*)*lplpDupDDSurface, 1);
    *lplpDupDDSurface       = (IDirectDrawSurface*)srfc->GetDirectDrawSurface1();
    DBUG_LOG((string("Duplicated Surface: ") + to_string((long)srfc)).c_str());
    return 0;
}

STDMETHODIMP DirectDraw_EnumDisplayModes(COMPtr* ptr, DWORD Flags, LPDDSURFACEDESC pDDSurfaceDesc, LPVOID pContext, LPDDENUMMODESCALLBACK pEnumModesCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(EnumDisplayModes, Flags, pDDSurfaceDesc, pContext, pEnumModesCallback);
}

STDMETHODIMP DirectDraw_EnumSurfaces(COMPtr* ptr, DWORD Flags, LPDDSURFACEDESC pDDSD, LPVOID pContext, LPDDENUMSURFACESCALLBACK pEnumSurfacesCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    if (pEnumSurfacesCallback == nullptr)
        return DDERR_INVALIDPARAMS;
    DDSURFACE_ENUM_CNTXT Ctx = {_this, pContext, pEnumSurfacesCallback};
    LAYER_COM_CALL(EnumSurfaces, Flags, pDDSD, (void**)&Ctx, EnumSurfacesCallback);
}

STDMETHODIMP DirectDraw_FlipToGDISurface(COMPtr* ptr) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(FlipToGDISurface);
}

STDMETHODIMP DirectDraw_GetCaps(COMPtr* ptr, LPDDCAPS lpDDDriverCaps, LPDDCAPS lpDDHELCaps) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetCaps, lpDDDriverCaps, lpDDHELCaps);
}

STDMETHODIMP DirectDraw_GetDisplayMode(COMPtr* ptr, LPDDSURFACEDESC lpDDSurfaceDesc) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetDisplayMode, lpDDSurfaceDesc);
}

STDMETHODIMP DirectDraw_GetFourCCCodes(COMPtr* ptr, LPDWORD lpNumCodes, LPDWORD lpCodes) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetFourCCCodes, lpNumCodes, lpCodes);
}

STDMETHODIMP DirectDraw_GetGDISurface(COMPtr* ptr, LPDIRECTDRAWSURFACE FAR* lplpGDIDDSSurface) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    IDirectDraw* _this_imp = (IDirectDraw*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->GetGDISurface(lplpGDIDDSSurface);
    if (S_OK != hr)
    {
        DBUG_WARN("CreateSurface");
        return DDERR_GENERIC;
    }
    auto srfc = FindSurfaceWrapper(*lplpGDIDDSSurface, _this, __FUNCTION__);
    if (srfc == nullptr)
    {
        DBUG_WARN("NOT Found");
        return DDERR_GENERIC;
    }
    *lplpGDIDDSSurface = (IDirectDrawSurface*)srfc->GetDirectDrawSurface1();
    return hr;
}

STDMETHODIMP DirectDraw_GetMonitorFrequency(COMPtr* ptr, LPDWORD lpdwFrequency) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetMonitorFrequency, lpdwFrequency);
}

STDMETHODIMP DirectDraw_GetScanLine(COMPtr* ptr, LPDWORD lpdwScanLine) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetScanLine, lpdwScanLine);
}

STDMETHODIMP DirectDraw_GetVerticalBlankStatus(COMPtr* ptr, LPBOOL lpbIsInVB) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetVerticalBlankStatus, lpbIsInVB);
}

STDMETHODIMP DirectDraw_Initialize(COMPtr* ptr, GUID FAR* lpGUID) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(Initialize, lpGUID);
}

STDMETHODIMP DirectDraw_RestoreDisplayMode(COMPtr* ptr) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(RestoreDisplayMode);
}

STDMETHODIMP DirectDraw_SetCooperativeLevel(COMPtr* ptr, HWND hWnd, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(SetCooperativeLevel, hWnd, dwFlags);
}

STDMETHODIMP DirectDraw_SetDisplayMode(COMPtr* ptr, DWORD w, DWORD h, DWORD bpp) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(SetDisplayMode, w, h, bpp);
}

STDMETHODIMP DirectDraw_WaitForVerticalBlank(COMPtr* ptr, DWORD dwFlags, HANDLE hEvent) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(WaitForVerticalBlank, dwFlags, hEvent);
}

#undef  LAYER_THIS
#define LAYER_THIS IDirectDraw2
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDraw2
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

ULONG __stdcall DirectDraw2_Release(COMPtr* ptr) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    return _this->SetRef2(_this->GetImp2()->Release());
}

ULONG __stdcall DirectDraw2_AddRef(COMPtr* ptr) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    ULONG ref = _this->GetImp2()->AddRef();  DBUG_LOG(to_string(ref).c_str()); return ref;
}

STDMETHODIMP DirectDraw2_CreateSurface(COMPtr* ptr, LPDDSURFACEDESC lpDDSurfaceDesc, LPDIRECTDRAWSURFACE FAR* lplpDDSurface, IUnknown FAR* pUnkOuter) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto ez                 = EZInterface(IID_IDirectDraw2, _this->GetImp());
    IDirectDraw2* _this_imp = (IDirectDraw2*)ez.I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }    
    HRESULT hr = _this_imp->CreateSurface(lpDDSurfaceDesc, lplpDDSurface, pUnkOuter);   
    if (S_OK != hr)
    {
        DBUG_WARN("CreateSurface");
        return DDERR_GENERIC;
    }
    DirectDrawSurface* srfc = new DirectDrawSurface(_this, (IUnknown*)*lplpDDSurface, 1);
    *lplpDDSurface          = (IDirectDrawSurface*)srfc->GetDirectDrawSurface1();    
    DBUG_LOG((string("Created Surface: ") + to_string((long)srfc)).c_str());
    return 0;
}

STDMETHODIMP DirectDraw2_SetCooperativeLevel(COMPtr* ptr, HWND hWnd, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(SetCooperativeLevel, hWnd, dwFlags);
}

STDMETHODIMP DirectDraw2_SetDisplayMode(COMPtr* ptr, WORD dwWidth, DWORD dwHeight, DWORD dwBPP, DWORD dwRefreshRate, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(SetDisplayMode, dwWidth, dwHeight, dwBPP, dwRefreshRate, dwFlags);
}

STDMETHODIMP DirectDraw2_GetAvailableVidMem(COMPtr* ptr, LPDDSCAPS lpDDSCaps, LPDWORD lpdwTotal, LPDWORD lpdwFree) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetAvailableVidMem, lpDDSCaps, lpdwTotal, lpdwFree);
}

#undef  LAYER_THIS
#define LAYER_THIS IDirectDraw4
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDraw4
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"  

STDMETHODIMP DirectDraw4_CreateSurface(COMPtr* ptr, LPDDSURFACEDESC2 lpDDSurfaceDesc, LPDIRECTDRAWSURFACE4 FAR* lplpDDSurface, IUnknown FAR* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto _this_ez= EZInterface(LAYER_GUID, _this->GetImp());
    if (_this_ez.I() == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }    
    HRESULT hr = ((IDirectDraw4*)_this_ez.I())->CreateSurface(lpDDSurfaceDesc, lplpDDSurface, pUnkOuter);
    if (S_OK != hr)
    {
        DBUG_WARN("CreateSurface");
        return DDERR_GENERIC;
    }
    //DBUG_LOG((STR("Flags=") + HEXStringA((DWORD)lpDDSurfaceDesc->dwFlags).s.str()).c_str())
    //DBUG_LOG((STR("Caps1=") + HEXStringA((DWORD)lpDDSurfaceDesc->ddsCaps.dwCaps).s.str()).c_str())
    //DBUG_LOG((STR("Caps2= ") + HEXStringA((DWORD)lpDDSurfaceDesc->ddsCaps.dwCaps2).s.str()).c_str())
    DirectDrawSurface* srfc = new DirectDrawSurface(_this, (IUnknown*)*lplpDDSurface, 1);
    *lplpDDSurface          = (IDirectDrawSurface4*)srfc->GetDirectDrawSurface4();    
    DBUG_LOG((string("Created Surface: ") + to_string((long)srfc)).c_str());
    return 0;
}

STDMETHODIMP DirectDraw4_DuplicateSurface(COMPtr* ptr, LPDIRECTDRAWSURFACE4 lpDDSurface, LPDIRECTDRAWSURFACE4 FAR* lplpDupDDSurface) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto _this_ez  = EZInterface(LAYER_GUID, _this->GetImp());
    auto     _that = lpDDSurface == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpDDSurface);
    auto _that_imp = _that == nullptr ? nullptr : (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, _that->GetImp()).I();
    if (_this_ez.I() == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = ((IDirectDraw4*)_this_ez.I())->DuplicateSurface(lpDDSurface, lplpDupDDSurface);
    if (S_OK != hr)
    {
        DBUG_WARN("CreateSurface FAILED");
        return DDERR_GENERIC;
    }
    DirectDrawSurface* srfc = new DirectDrawSurface(_this, (IUnknown*)*lplpDupDDSurface, 1);
    *lplpDupDDSurface       = (IDirectDrawSurface4*)srfc->GetDirectDrawSurface4();
    DBUG_LOG((string("Duplicated Surface: ") + to_string((long)srfc)).c_str());
    return 0;
}

STDMETHODIMP DirectDraw4_EnumSurfaces(COMPtr* ptr, DWORD Flags, LPDDSURFACEDESC2 pDDSD, LPVOID pContext, LPDDENUMSURFACESCALLBACK2 pEnumSurfacesCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    if (pEnumSurfacesCallback == nullptr)
        return DDERR_INVALIDPARAMS;
    DDSURFACE_ENUM_CNTXT Ctx = {_this, pContext};
    Ctx.lpCallback2          = EnumSurfacesCallback2;
    LAYER_COM_CALL(EnumSurfaces, Flags, pDDSD, (void**)&Ctx, EnumSurfacesCallback2);
}

STDMETHODIMP DirectDraw4_EnumDisplayModes(COMPtr* ptr, DWORD Flags, LPDDSURFACEDESC2 pDDSurfaceDesc, LPVOID pContext, LPDDENUMMODESCALLBACK2 pEnumModesCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(EnumDisplayModes, Flags, pDDSurfaceDesc, pContext, pEnumModesCallback);
}

STDMETHODIMP DirectDraw4_GetDisplayMode(COMPtr* ptr, LPDDSURFACEDESC2 lpDDSurfaceDesc) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetDisplayMode, lpDDSurfaceDesc);
}

STDMETHODIMP DirectDraw4_SetCooperativeLevel(COMPtr* ptr, HWND hWnd, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(SetCooperativeLevel, hWnd, dwFlags);
}

STDMETHODIMP DirectDraw4_SetDisplayMode(COMPtr* ptr, WORD dwWidth, DWORD dwHeight, DWORD dwBPP, DWORD dwRefreshRate, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(SetDisplayMode, dwWidth, dwHeight, dwBPP, dwRefreshRate, dwFlags);
}

STDMETHODIMP DirectDraw4_GetAvailableVidMem(COMPtr* ptr, LPDDSCAPS2 lpDDSCaps, LPDWORD lpdwTotal, LPDWORD lpdwFree) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetAvailableVidMem, lpDDSCaps, lpdwTotal, lpdwFree);
}

STDMETHODIMP DirectDraw4_GetSurfaceFromDC(COMPtr* ptr, HDC hdc, LPDIRECTDRAWSURFACE4* lpDDS4) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto _this_ez  = EZInterface(LAYER_GUID, _this->GetImp());   
    if (_this_ez.I() == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = ((IDirectDraw4*)_this_ez.I())->GetSurfaceFromDC(hdc, lpDDS4);
    if (S_OK != hr)
    {
        DBUG_WARN("CreateSurface FAILED");
        return DDERR_GENERIC;
    }
    auto srfc = FindSurfaceWrapper(*lpDDS4, _this, __FUNCTION__);
    if (srfc == nullptr)
    {
        DBUG_WARN("NOT Found");
        return DDERR_GENERIC;
    }
    *lpDDS4 = (IDirectDrawSurface4*)srfc->GetDirectDrawSurface4();
    return hr;
}

STDMETHODIMP DirectDraw4_RestoreAllSurfaces(COMPtr* ptr) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(RestoreAllSurfaces);
}

STDMETHODIMP DirectDraw4_TestCooperativeLevel(COMPtr* ptr) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(TestCooperativeLevel);
}

STDMETHODIMP DirectDraw4_GetDeviceIdentifier(COMPtr* ptr, LPDDDEVICEIDENTIFIER lpdddi, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetDeviceIdentifier, lpdddi, dwFlags);
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3D
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3D
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP Direct3D_Initialize(COMPtr* ptr, REFIID lpREFIID) {
    LAYER_LOG_CALL; return DDERR_ALREADYINITIALIZED;
}

STDMETHODIMP Direct3D_EnumDevices(COMPtr* ptr, LPD3DENUMDEVICESCALLBACK lpEnumDevicesCallback, LPVOID lpUserArg) {    
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(EnumDevices, lpEnumDevicesCallback, lpUserArg);
}

STDMETHODIMP Minimal_Direct3D_CreateLight(COMPtr* ptr, LPDIRECT3DLIGHT* lplpDirect3DLight, IUnknown* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(CreateLight, lplpDirect3DLight, pUnkOuter);
}

STDMETHODIMP Direct3D_CreateLight(COMPtr* ptr, LPDIRECT3DLIGHT* lplpDirect3DLight, IUnknown* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto this_imp = (IDirect3D*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (this_imp == nullptr)
    {
        DBUG_WARN("NO INTERFACE");
        return DDERR_GENERIC;
    }
    HRESULT hr = this_imp->CreateLight(lplpDirect3DLight, pUnkOuter);
    if (FAILED(hr))
    {
        DBUG_WARN("CreateLight FAILED");
        return DDERR_GENERIC;
    }
    *lplpDirect3DLight = new Direct3DLight(*lplpDirect3DLight);
    DBUG_LOG((STR("Created light=[") + to_string((long)*lplpDirect3DLight) + "]").c_str());
    return hr;
}

STDMETHODIMP Direct3D_CreateMaterial(COMPtr* ptr, LPDIRECT3DMATERIAL* lplpDirect3DMaterial, IUnknown* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto this_imp = (IDirect3D*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (this_imp == nullptr)
    {
        DBUG_WARN("NO INTERFACE");
        return DDERR_GENERIC;
    }
    HRESULT hr = this_imp->CreateMaterial(lplpDirect3DMaterial, pUnkOuter);
    if (FAILED(hr))
    {
        DBUG_WARN("CreateMaterial FAILED");
        return DDERR_GENERIC;
    }
    auto mat              = new Direct3DMaterial(*lplpDirect3DMaterial);
    *lplpDirect3DMaterial = (IDirect3DMaterial*) mat->GetDirect3DMaterial1();
    DBUG_LOG((STR("Created material=[") + to_string((long)mat) + "]").c_str());
    return hr;
}

STDMETHODIMP Direct3D_CreateViewport(COMPtr* ptr, LPDIRECT3DVIEWPORT* lplpD3DViewport, IUnknown* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto this_imp = (IDirect3D*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (this_imp == nullptr)
    {
        DBUG_WARN("NO INTERFACE");
        return DDERR_GENERIC;
    }
    HRESULT hr = this_imp->CreateViewport(lplpD3DViewport, pUnkOuter);
    if (FAILED(hr))
    {
        DBUG_WARN("CreateViewport FAILED");
        return DDERR_GENERIC;
    }
    auto view        = new Direct3DViewPort(*lplpD3DViewport);
    *lplpD3DViewport = (IDirect3DViewport*)view->GetDirect3DViewport1();
    DBUG_LOG((STR("Created ViewPort=[") + to_string((long)view) + "]").c_str());
    return hr;
}

STDMETHODIMP Direct3D_FindDevice(COMPtr* ptr, LPD3DFINDDEVICESEARCH lpD3DFDS, LPD3DFINDDEVICERESULT lpD3DFDR) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(FindDevice, lpD3DFDS, lpD3DFDR);
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3D2
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3D2
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP Direct3D2_CreateMaterial(COMPtr* ptr, LPDIRECT3DMATERIAL2* lplpDirect3DMaterial, IUnknown* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto this_imp = (IDirect3D2*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (this_imp == nullptr)
    {
        DBUG_WARN("NO INTERFACE");
        return DDERR_GENERIC;
    }
    HRESULT hr = this_imp->CreateMaterial(lplpDirect3DMaterial, pUnkOuter);
    if (FAILED(hr))
    {
        DBUG_WARN("CreateMaterial FAILED");
        return DDERR_GENERIC;
    }
    auto mat              = new Direct3DMaterial(*lplpDirect3DMaterial);
    *lplpDirect3DMaterial = (IDirect3DMaterial2*) mat->GetDirect3DMaterial2();
    DBUG_LOG((STR("Created material=[") + to_string((long)mat) + "]").c_str());
    return hr;
}

STDMETHODIMP Direct3D2_CreateViewport(COMPtr* ptr, LPDIRECT3DVIEWPORT2* lplpD3DViewport, IUnknown* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto this_imp = (IDirect3D2*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (this_imp == nullptr)
    {
        DBUG_WARN("NO INTERFACE");
        return DDERR_GENERIC;
    }
    HRESULT hr = this_imp->CreateViewport(lplpD3DViewport, pUnkOuter);
    if (FAILED(hr))
    {
        DBUG_WARN("CreateViewport FAILED");
        return DDERR_GENERIC;
    }
    auto view        = new Direct3DViewPort(*lplpD3DViewport);
    *lplpD3DViewport = (IDirect3DViewport2*)view->GetDirect3DViewport2();
    DBUG_LOG((STR("Created ViewPort=[") + to_string((long)view) + "]").c_str());
    return hr;
}

STDMETHODIMP Direct3D2_CreateDevice(COMPtr* ptr, REFCLSID rclsid, LPDIRECTDRAWSURFACE lpDDS, LPDIRECT3DDEVICE2* lplpD3DDevice2) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto this_imp  = (IDirect3D2*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    auto _that_imp = lpDDS == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpDDS)->GetImp();
    auto _that_ez  = EZInterface(IID_IDirectDrawSurface, _that_imp);
    if (_that_ez.I() == nullptr) {
        DBUG_WARN("NO INTERFACE");  return DDERR_GENERIC;
    }
    HRESULT hr = this_imp->CreateDevice(rclsid, (IDirectDrawSurface*)_that_ez.I(), lplpD3DDevice2);
    if (FAILED(hr)) {
        DBUG_WARN(LAYER_PARSE_ERROR(hr)); return hr;
    }
    if (g_d3d.TEXTURE_FILTER == *(DWORD*)"TRUE"){
        (*lplpD3DDevice2)->SetRenderState(D3DRENDERSTATE_TEXTUREMAG, D3DFILTER_NEAREST);
        (*lplpD3DDevice2)->SetRenderState(D3DRENDERSTATE_TEXTUREMIN, D3DFILTER_LINEARMIPLINEAR);
    }
    *lplpD3DDevice2 = (IDirect3DDevice2*)
        (new Direct3DDevice((IUnknown*)*lplpD3DDevice2, (IDirectDrawSurface*)_that_ez.I()))->GetDirect3DDevicec2();
    DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3D3
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3D3
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP Direct3D3_CreateMaterial(COMPtr* ptr, LPDIRECT3DMATERIAL3* lplpDirect3DMaterial, IUnknown* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto this_imp = (IDirect3D3*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (this_imp == nullptr)
    {
        DBUG_WARN("NO INTERFACE");
        return DDERR_GENERIC;
    }
    HRESULT hr = this_imp->CreateMaterial(lplpDirect3DMaterial, pUnkOuter);
    if (FAILED(hr))
    {
        DBUG_WARN("CreateMaterial FAILED");
        return DDERR_GENERIC;
    }
    auto mat              = new Direct3DMaterial(*lplpDirect3DMaterial);
    *lplpDirect3DMaterial = (IDirect3DMaterial3*) mat->GetDirect3DMaterial3();
    DBUG_LOG((STR("Created material=[") + to_string((long)mat) + "]").c_str());
    return hr;
}

STDMETHODIMP Direct3D3_CreateViewport(COMPtr* ptr, LPDIRECT3DVIEWPORT3* lplpD3DViewport, IUnknown* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto this_imp = (IDirect3D3*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (this_imp == nullptr)
    {
        DBUG_WARN("NO INTERFACE");
        return DDERR_GENERIC;
    }
    HRESULT hr = this_imp->CreateViewport(lplpD3DViewport, pUnkOuter);
    if (FAILED(hr))
    {
        DBUG_WARN("CreateViewport FAILED");
        return DDERR_GENERIC;
    }
    auto view        = new Direct3DViewPort(*lplpD3DViewport);
    *lplpD3DViewport = (IDirect3DViewport3*)view->GetDirect3DViewport3();
    DBUG_LOG((STR("Created ViewPort=[") + to_string((long)view) + "]").c_str());
    return hr;
}

STDMETHODIMP Direct3D3_CreateDevice(COMPtr* ptr, REFCLSID rclsid, LPDIRECTDRAWSURFACE4 lpDDS, LPDIRECT3DDEVICE3* lplpD3DDevice3, LPUNKNOWN pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto this_imp  = (IDirect3D3*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    auto _that_imp = lpDDS == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpDDS)->GetImp();
    auto _that_ez  = EZInterface(IID_IDirectDrawSurface4, _that_imp);
    if (_that_ez.I() == nullptr) {
        DBUG_WARN("NO INTERFACE");  return DDERR_GENERIC;
    }
    HRESULT hr = this_imp->CreateDevice(rclsid, (IDirectDrawSurface4*)_that_ez.I(), lplpD3DDevice3, pUnkOuter);
    if (FAILED(hr)) {
        DBUG_WARN(LAYER_OK); return hr;
    }
    /* TODO:
     * The Direct3DDevice contructor is declared expecting a IDirectDrawSurface*, but it only passes this pointer
     * to the SetSurfacePrivateData funtion which expects a IUnknown*, therefore this cast is safe. However, it
     * would be best to change the IDirect3DDevice::IDirect3DDevice funtion delcaration.
     * P.S: Writing this probably took longer then changing that declaration
     */    
    Direct3DDevice* dvc = new Direct3DDevice((IUnknown*)*lplpD3DDevice3, (IDirectDrawSurface*)_that_ez.I());
    if (g_d3d.TEXTURE_FILTER == *(DWORD*)"TRUE"){
        for (int i=0; i<8; i++){
            (IDirect3DDevice3*)(*lplpD3DDevice3)->SetTextureStageState(i, D3DTSS_MAGFILTER, D3DTFG_POINT);
            (IDirect3DDevice3*)(*lplpD3DDevice3)->SetTextureStageState(i, D3DTSS_MINFILTER, D3DTFN_ANISOTROPIC);
            (IDirect3DDevice3*)(*lplpD3DDevice3)->SetTextureStageState(i, D3DTSS_MAXANISOTROPY, 16);
        }        
    }
    *lplpD3DDevice3     = (IDirect3DDevice3*)dvc->GetDirect3DDevicec3();    
    DBUG_LOG((STR("Created device=[") + to_string((long)dvc) + "]").c_str())
    DBUG_LOG(LAYER_OK); return hr;
}

STDMETHODIMP Direct3D3_CreateVertexBuffer(COMPtr* ptr, LPD3DVERTEXBUFFERDESC lpVBDesc, LPDIRECT3DVERTEXBUFFER* lpD3DVertexBuffer, DWORD f, LPUNKNOWN pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto this_imp = (IDirect3D3*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    HRESULT hr = this_imp->CreateVertexBuffer(lpVBDesc, lpD3DVertexBuffer, f, pUnkOuter);
    if (FAILED(hr)) {
        DBUG_WARN(LAYER_PARSE_ERROR(hr)); return hr;
    }
    *lpD3DVertexBuffer = (IDirect3DVertexBuffer*)(new Direct3DVertexBuffer(*lpD3DVertexBuffer))->GetDirect3DVertexBuffer();
    DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}


STDMETHODIMP Direct3D3_EnumZBufferFormats(COMPtr* ptr, REFCLSID riidDevice, LPD3DENUMPIXELFORMATSCALLBACK lpEnumCallback, LPVOID lpContext) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(EnumZBufferFormats, riidDevice, lpEnumCallback, lpContext);
}
STDMETHODIMP Direct3D3_EvictManagedTextures(COMPtr* ptr) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(EvictManagedTextures);
}

#undef  LAYER_THIS
#define LAYER_THIS IDirectDraw7
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDraw7
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP DirectDraw7_GetDeviceIdentifier(COMPtr* ptr, LPDDDEVICEIDENTIFIER2 lpdddi, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(GetDeviceIdentifier, lpdddi, dwFlags);
}
STDMETHODIMP DirectDraw7_StartModeTest(COMPtr* ptr, LPSIZE lpModesToTest, DWORD dwNumEntries, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(StartModeTest, lpModesToTest, dwNumEntries, dwFlags);
}
STDMETHODIMP DirectDraw7_EvaluateMode(COMPtr* ptr, DWORD dwFlags, DWORD* pSecondsUntilTimeout) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(EvaluateMode, dwFlags, pSecondsUntilTimeout);
}
STDMETHODIMP DirectDraw7_CreateSurface(COMPtr* ptr, LPDDSURFACEDESC2 lpDDSurfaceDesc, LPDIRECTDRAWSURFACE7 FAR* lplpDDSurface, IUnknown FAR* pUnkOuter) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto _this_ez = EZInterface(LAYER_GUID, _this->GetImp());
    if (_this_ez.I() == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    //if (lpDDSurfaceDesc != nullptr) lpDDSurfaceDesc->ddsCaps.dwCaps2 &= ~DDSCAPS2_HINTDYNAMIC;
    HRESULT hr = ((IDirectDraw7*)_this_ez.I())->CreateSurface(lpDDSurfaceDesc, lplpDDSurface, pUnkOuter);
    if (S_OK != hr)
    {
        DBUG_WARN("CreateSurface");
        return DDERR_GENERIC;
    }
    DirectDrawSurface* srfc = new DirectDrawSurface(_this, (IUnknown*)*lplpDDSurface, 1);
    *lplpDDSurface          = (IDirectDrawSurface7*)srfc->GetDirectDrawSurface7();    
    DBUG_LOG((string("Created Surface: ") + to_string((long)srfc)).c_str());
    return 0;
}
STDMETHODIMP DirectDraw7_DuplicateSurface(COMPtr* ptr, LPDIRECTDRAWSURFACE7 lpDDSurface, LPDIRECTDRAWSURFACE7 FAR* lplpDupDDSurface) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto _this_ez  = EZInterface(LAYER_GUID, _this->GetImp());
    auto     _that = lpDDSurface == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpDDSurface);
    auto _that_imp = _that == nullptr ? nullptr : (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface7, _that->GetImp()).I();
    if (_this_ez.I() == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = ((IDirectDraw7*)_this_ez.I())->DuplicateSurface(lpDDSurface, lplpDupDDSurface);
    if (S_OK != hr)
    {
        DBUG_WARN("CreateSurface FAILED");
        return DDERR_GENERIC;
    }
    DirectDrawSurface* srfc = new DirectDrawSurface(_this, (IUnknown*)*lplpDupDDSurface, 1);
    *lplpDupDDSurface       = (IDirectDrawSurface7*)srfc->GetDirectDrawSurface7();
    DBUG_LOG((string("Duplicated Surface: ") + to_string((long)srfc)).c_str());
    return 0;
}
STDMETHODIMP DirectDraw7_EnumSurfaces(COMPtr* ptr, DWORD Flags, LPDDSURFACEDESC2 pDDSD, LPVOID pContext, LPDDENUMSURFACESCALLBACK7 pEnumSurfacesCallback) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    if (pEnumSurfacesCallback == nullptr)
        return DDERR_INVALIDPARAMS;
    DDSURFACE_ENUM_CNTXT Ctx = {_this, pContext};
    Ctx.lpCallback7          = pEnumSurfacesCallback;
    LAYER_COM_CALL(EnumSurfaces, Flags, pDDSD, (void**)&Ctx, EnumSurfacesCallback7);
}

STDMETHODIMP DirectDraw7_GetGDISurface(COMPtr* ptr, LPDIRECTDRAWSURFACE7 FAR* lplpGDIDDSSurface) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    IDirectDraw7* _this_imp = (IDirectDraw7*)EZInterface(LAYER_GUID, _this->GetImp()).I();
    if (_this_imp == nullptr)
    {
        DBUG_WARN("QueryInterace Failed");
        return DDERR_GENERIC;
    }
    HRESULT hr = _this_imp->GetGDISurface(lplpGDIDDSSurface);
    if (S_OK != hr)
    {
        DBUG_WARN("CreateSurface");
        return DDERR_GENERIC;
    }
    auto srfc = FindSurfaceWrapper(*lplpGDIDDSSurface, _this, __FUNCTION__);
    if (srfc == nullptr)
    {
        DBUG_WARN("NOT Found");
        return DDERR_GENERIC;
    }
    *lplpGDIDDSSurface = (IDirectDrawSurface7*)srfc->GetDirectDrawSurface7();
    return hr;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3D7
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3D7
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"  

STDMETHODIMP Direct3D7_CreateDevice(COMPtr* ptr, REFCLSID rclsid, LPDIRECTDRAWSURFACE7 lpDDS, LPDIRECT3DDEVICE7* lplpD3DDevice) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    if (lpDDS == nullptr)    {
        DBUG_WARN("nullptr"); return DDERR_INVALIDPARAMS;
    }
    auto _this_ez = EZInterface(LAYER_GUID, _this->GetImp());    
    auto _that_ez = EZInterface(IID_IDirectDrawSurface7, GetDirectDrawSurface((COMPtr*)lpDDS)->GetImp());   
    HRESULT hr = ((IDirect3D7*)_this_ez.I())->CreateDevice(rclsid, (LPDIRECTDRAWSURFACE7)_that_ez.I(), lplpD3DDevice);
    if (FAILED(hr))    {
        DBUG_WARN(LAYER_PARSE_ERROR(hr)); return hr;
    }
    if (g_d3d.TEXTURE_FILTER == *(DWORD*)"TRUE"){
        for (int i=0; i<8; i++){
            (Direct3DDevice7*)(*lplpD3DDevice)->SetTextureStageState(i, D3DTSS_MAGFILTER, D3DTFG_POINT);
            (Direct3DDevice7*)(*lplpD3DDevice)->SetTextureStageState(i, D3DTSS_MINFILTER, D3DTFN_ANISOTROPIC);
            (Direct3DDevice7*)(*lplpD3DDevice)->SetTextureStageState(i, D3DTSS_MAXANISOTROPY, 16);
        }        
    }
    *lplpD3DDevice = dynamic_cast<IDirect3DDevice7*>(new Direct3DDevice7(*lplpD3DDevice, (LPDIRECTDRAWSURFACE)_that_ez.I()));
    DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
 }

STDMETHODIMP Direct3D7_CreateVertexBuffer(COMPtr* ptr, LPD3DVERTEXBUFFERDESC lpVBDesc, LPDIRECT3DVERTEXBUFFER7* lplpD3DVertexBuffer, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC)
    auto _this_ez = EZInterface(LAYER_GUID, _this->GetImp());
    HRESULT hr = ((IDirect3D7*)_this_ez.I())->CreateVertexBuffer(lpVBDesc, lplpD3DVertexBuffer, dwFlags);
    if (FAILED(hr)) {
        DBUG_WARN(LAYER_PARSE_ERROR(hr)); return hr;
    }
    *lplpD3DVertexBuffer = dynamic_cast<IDirect3DVertexBuffer7*>(new Direct3DVertexBuffer7((LPDIRECT3DVERTEXBUFFER7)*lplpD3DVertexBuffer));
    DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}

STDMETHODIMP Direct3D7_EnumDevices(COMPtr* ptr, LPD3DENUMDEVICESCALLBACK7 lpEnumDevicesCallback, LPVOID lpUserArg) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(EnumDevices, lpEnumDevicesCallback, lpUserArg);
}

STDMETHODIMP Direct3D7_EnumZBufferFormats(COMPtr* ptr, REFCLSID riidDevice, LPD3DENUMPIXELFORMATSCALLBACK lpEnumCallback, LPVOID lpContext) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(EnumZBufferFormats, riidDevice, lpEnumCallback, lpContext)
}

STDMETHODIMP Direct3D7_EvictManagedTextures(COMPtr* ptr) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDraw, DDERR_GENERIC) LAYER_COM_CALL(EvictManagedTextures)
}

struct IDIRECTDRAW_VTABLE {
    decltype(DirectDraw_QueryInterface)         * QueryInterface         = DirectDraw_QueryInterface;
    decltype(DirectDraw_AddRef)                 * AddRef                 = DirectDraw_AddRef;
    decltype(DirectDraw_Release)                * Release                = DirectDraw_Release;    
    decltype(DirectDraw_Compact)                * Compact                = DirectDraw_Compact;
    decltype(DirectDraw_CreateClipper)          * CreateClipper          = DirectDraw_CreateClipper;
    decltype(DirectDraw_CreatePalette)          * CreatePalette          = DirectDraw_CreatePalette;
    decltype(DirectDraw_CreateSurface)          * CreateSurface          = DirectDraw_CreateSurface;
    decltype(DirectDraw_DuplicateSurface)       * DuplicateSurface       = DirectDraw_DuplicateSurface;
    decltype(DirectDraw_EnumDisplayModes)       * EnumDisplayModes       = DirectDraw_EnumDisplayModes;
    decltype(DirectDraw_EnumSurfaces)           * EnumSurfaces           = DirectDraw_EnumSurfaces;
    decltype(DirectDraw_FlipToGDISurface)       * FlipToGDISurface       = DirectDraw_FlipToGDISurface;
    decltype(DirectDraw_GetCaps)                * GetCaps                = DirectDraw_GetCaps;
    decltype(DirectDraw_GetDisplayMode)         * GetDisplayMode         = DirectDraw_GetDisplayMode;
    decltype(DirectDraw_GetFourCCCodes)         * GetFourCCCodes         = DirectDraw_GetFourCCCodes;
    decltype(DirectDraw_GetGDISurface)          * GetGDISurface          = DirectDraw_GetGDISurface;
    decltype(DirectDraw_GetMonitorFrequency)    * GetMonitorFrequency    = DirectDraw_GetMonitorFrequency;
    decltype(DirectDraw_GetScanLine)            * GetScanLine            = DirectDraw_GetScanLine;
    decltype(DirectDraw_GetVerticalBlankStatus) * GetVerticalBlankStatus = DirectDraw_GetVerticalBlankStatus;
    decltype(DirectDraw_Initialize)             * Initialize             = DirectDraw_Initialize;
    decltype(DirectDraw_RestoreDisplayMode)     * RestoreDisplayMode     = DirectDraw_RestoreDisplayMode;
    decltype(DirectDraw_SetCooperativeLevel)    * SetCooperativeLevel    = DirectDraw_SetCooperativeLevel;
    decltype(DirectDraw_SetDisplayMode)         * SetDisplayMode         = DirectDraw_SetDisplayMode;
    decltype(DirectDraw_WaitForVerticalBlank)   * WaitForVerticalBlank   = DirectDraw_WaitForVerticalBlank;
};
const IDIRECTDRAW_VTABLE IDirectDrawVtable;

struct IDIRECTDRAW2_VTABLE {
    const decltype(DirectDraw_QueryInterface)         * QueryInterface         = DirectDraw_QueryInterface;
#ifndef DDRAW_SEPARATE_REF_COUNTS
    const decltype(DirectDraw_AddRef)                 * AddRef                 = DirectDraw_AddRef;
    const decltype(DirectDraw_Release)                * Release                = DirectDraw_Release;
#else 
    const decltype(DirectDraw2_AddRef)                * AddRef                 = DirectDraw2_AddRef;
    const decltype(DirectDraw2_Release)               * Release                = DirectDraw2_Release;
#endif
    const decltype(DirectDraw_Compact)                * Compact                = DirectDraw_Compact;
    const decltype(DirectDraw_CreateClipper)          * CreateClipper          = DirectDraw_CreateClipper;
    const decltype(DirectDraw_CreatePalette)          * CreatePalette          = DirectDraw_CreatePalette;
    const decltype(DirectDraw2_CreateSurface)         * CreateSurface          = DirectDraw2_CreateSurface;
    const decltype(DirectDraw_DuplicateSurface)       * DuplicateSurface       = DirectDraw_DuplicateSurface;
    const decltype(DirectDraw_EnumDisplayModes)       * EnumDisplayModes       = DirectDraw_EnumDisplayModes;
    const decltype(DirectDraw_EnumSurfaces)           * EnumSurfaces           = DirectDraw_EnumSurfaces;
    const decltype(DirectDraw_FlipToGDISurface)       * FlipToGDISurface       = DirectDraw_FlipToGDISurface;
    const decltype(DirectDraw_GetCaps)                * GetCaps                = DirectDraw_GetCaps;
    const decltype(DirectDraw_GetDisplayMode)         * GetDisplayMode         = DirectDraw_GetDisplayMode;
    const decltype(DirectDraw_GetFourCCCodes)         * GetFourCCCodes         = DirectDraw_GetFourCCCodes;
    const decltype(DirectDraw_GetGDISurface)          * GetGDISurface          = DirectDraw_GetGDISurface;
    const decltype(DirectDraw_GetMonitorFrequency)    * GetMonitorFrequency    = DirectDraw_GetMonitorFrequency;
    const decltype(DirectDraw_GetScanLine)            * GetScanLine            = DirectDraw_GetScanLine;
    const decltype(DirectDraw_GetVerticalBlankStatus) * GetVerticalBlankStatus = DirectDraw_GetVerticalBlankStatus;
    const decltype(DirectDraw_Initialize)             * Initialize             = DirectDraw_Initialize;
    const decltype(DirectDraw_RestoreDisplayMode)     * RestoreDisplayMode     = DirectDraw_RestoreDisplayMode;
    const decltype(DirectDraw2_SetCooperativeLevel)   * SetCooperativeLevel    = DirectDraw2_SetCooperativeLevel;
    const decltype(DirectDraw2_SetDisplayMode)        * SetDisplayMode         = DirectDraw2_SetDisplayMode;
    const decltype(DirectDraw_WaitForVerticalBlank)   * WaitForVerticalBlank   = DirectDraw_WaitForVerticalBlank;
    const decltype(DirectDraw2_GetAvailableVidMem)    * GetAvailableVidMem     = DirectDraw2_GetAvailableVidMem;
};
const IDIRECTDRAW2_VTABLE IDirectDraw2Vtable;

struct IDIRECTDRAW4_VTABLE {
    /* DirectDraw4 reimplements everything, here i've only changed funtions with diferent 
     * signatures and others for whithc there were already different hooks
     */
    const decltype(DirectDraw_QueryInterface)         * QueryInterface         = DirectDraw_QueryInterface;
    const decltype(DirectDraw_AddRef)                 * AddRef                 = DirectDraw_AddRef;
    const decltype(DirectDraw_Release)                * Release                = DirectDraw_Release;
    const decltype(DirectDraw_Compact)                * Compact                = DirectDraw_Compact;
    const decltype(DirectDraw_CreateClipper)          * CreateClipper          = DirectDraw_CreateClipper;
    const decltype(DirectDraw_CreatePalette)          * CreatePalette          = DirectDraw_CreatePalette;
    const decltype(DirectDraw4_CreateSurface)         * CreateSurface          = DirectDraw4_CreateSurface;
    const decltype(DirectDraw4_DuplicateSurface)      * DuplicateSurface       = DirectDraw4_DuplicateSurface;
    //const decltype(DirectDraw4_EnumDisplayModes)      * EnumDisplayModes       = DirectDraw4_EnumDisplayModes;
    const decltype(DirectDraw_EnumDisplayModes)       * EnumDisplayModes       = DirectDraw_EnumDisplayModes;
    const decltype(DirectDraw4_EnumSurfaces)          * EnumSurfaces           = DirectDraw4_EnumSurfaces;
    const decltype(DirectDraw_FlipToGDISurface)       * FlipToGDISurface       = DirectDraw_FlipToGDISurface;
    const decltype(DirectDraw_GetCaps)                * GetCaps                = DirectDraw_GetCaps;
    const decltype(DirectDraw4_GetDisplayMode)        * GetDisplayMode         = DirectDraw4_GetDisplayMode;
    const decltype(DirectDraw_GetFourCCCodes)         * GetFourCCCodes         = DirectDraw_GetFourCCCodes;
    const decltype(DirectDraw_GetGDISurface)          * GetGDISurface          = DirectDraw_GetGDISurface;
    const decltype(DirectDraw_GetMonitorFrequency)    * GetMonitorFrequency    = DirectDraw_GetMonitorFrequency;
    const decltype(DirectDraw_GetScanLine)            * GetScanLine            = DirectDraw_GetScanLine;
    const decltype(DirectDraw_GetVerticalBlankStatus) * GetVerticalBlankStatus = DirectDraw_GetVerticalBlankStatus;
    const decltype(DirectDraw_Initialize)             * Initialize             = DirectDraw_Initialize;
    const decltype(DirectDraw_RestoreDisplayMode)     * RestoreDisplayMode     = DirectDraw_RestoreDisplayMode;
    const decltype(DirectDraw4_SetCooperativeLevel)   * SetCooperativeLevel    = DirectDraw4_SetCooperativeLevel;
    const decltype(DirectDraw4_SetDisplayMode)        * SetDisplayMode         = DirectDraw4_SetDisplayMode;
    const decltype(DirectDraw_WaitForVerticalBlank)   * WaitForVerticalBlank   = DirectDraw_WaitForVerticalBlank;
    const decltype(DirectDraw4_GetAvailableVidMem)    * GetAvailableVidMem     = DirectDraw4_GetAvailableVidMem;
    const decltype(DirectDraw4_GetSurfaceFromDC)      * GetSurfaceFromDC       = DirectDraw4_GetSurfaceFromDC;
    const decltype(DirectDraw4_RestoreAllSurfaces)    * RestoreAllSurfaces     = DirectDraw4_RestoreAllSurfaces;
    const decltype(DirectDraw4_TestCooperativeLevel)  * TestCooperativeLevel   = DirectDraw4_TestCooperativeLevel;
    const decltype(DirectDraw4_GetDeviceIdentifier)   * GetDeviceIdentifier    = DirectDraw4_GetDeviceIdentifier;
} IDirectDraw4Vtable;

typedef struct IDIRECT3D_VTABLE {
    decltype(DirectDraw_QueryInterface)   * QueryInterface = DirectDraw_QueryInterface;
    decltype(DirectDraw_AddRef)           * AddRef         = DirectDraw_AddRef;
    decltype(DirectDraw_Release)          * Release        = DirectDraw_Release;
    decltype(Direct3D_Initialize)         * Initialize     = Direct3D_Initialize;
    decltype(Direct3D_EnumDevices)        * EnumDevice     = Direct3D_EnumDevices;
#ifdef DDRAW_MINIMAL_LAYER
    decltype(Direct3D_CreateLight)* CreateLight = Minimal_Direct3D_CreateLight;
#else
    decltype(Direct3D_CreateLight)* CreateLight = Direct3D_CreateLight;
#endif // DDRAW_MINIMAL_LAYER
    decltype(Direct3D_CreateMaterial)     * CreateMaterial = Direct3D_CreateMaterial;
    decltype(Direct3D_CreateViewport)     * CreateViewport = Direct3D_CreateViewport;
    decltype(Direct3D_FindDevice)         * Finddevice     = Direct3D_FindDevice;   
 };
const IDIRECT3D_VTABLE IDirect3DVtable;

struct IDIRECT3D2_VTABLE {
    decltype(DirectDraw_QueryInterface)   * QueryInterface = DirectDraw_QueryInterface;
    decltype(DirectDraw_AddRef)           * AddRef         = DirectDraw_AddRef;
    decltype(DirectDraw_Release)          * Release        = DirectDraw_Release;   
    decltype(Direct3D_EnumDevices)        * EnumDevice     = Direct3D_EnumDevices;
#ifdef DDRAW_MINIMAL_LAYER
    decltype(Direct3D_CreateLight)        * CreateLight    = Minimal_Direct3D_CreateLight;
#else
    decltype(Direct3D_CreateLight)        * CreateLight    = Direct3D_CreateLight;
#endif // DDRAW_MINIMAL_LAYER
    decltype(Direct3D2_CreateMaterial)    * CreateMaterial = Direct3D2_CreateMaterial;
    decltype(Direct3D2_CreateViewport)    * CreateViewport = Direct3D2_CreateViewport;
    decltype(Direct3D_FindDevice)         * Finddevice     = Direct3D_FindDevice;   
    decltype(Direct3D2_CreateDevice)      * CreateDevice   = Direct3D2_CreateDevice;
 } IDirect3D2Vtable;

struct IDIRECT3D3_VTABLE {
    decltype(DirectDraw_QueryInterface)      * QueryInterface       = DirectDraw_QueryInterface;
    decltype(DirectDraw_AddRef)              * AddRef               = DirectDraw_AddRef;
    decltype(DirectDraw_Release)             * Release              = DirectDraw_Release;   
    decltype(Direct3D_EnumDevices)           * EnumDevice           = Direct3D_EnumDevices;
#ifdef DDRAW_MINIMAL_LAYER
    decltype(Direct3D_CreateLight)* CreateLight = Minimal_Direct3D_CreateLight;
#else
    decltype(Direct3D_CreateLight)* CreateLight = Direct3D_CreateLight;
#endif // DDRAW_MINIMAL_LAYER
    decltype(Direct3D3_CreateMaterial)       * CreateMaterial       = Direct3D3_CreateMaterial;
    decltype(Direct3D3_CreateViewport)       * CreateViewport       = Direct3D3_CreateViewport;
    decltype(Direct3D_FindDevice)            * Finddevice           = Direct3D_FindDevice;   
    decltype(Direct3D3_CreateDevice)         * CreateDevice         = Direct3D3_CreateDevice;
    decltype(Direct3D3_CreateVertexBuffer)   * CreateVertexBuffer   = Direct3D3_CreateVertexBuffer;
    decltype(Direct3D3_EnumZBufferFormats)   * EnumZBufferFormats   = Direct3D3_EnumZBufferFormats;
    decltype(Direct3D3_EvictManagedTextures) * EvictManagedTextures = Direct3D3_EvictManagedTextures;
 } IDirect3D3Vtable;

struct IDIRECTDRAW7_VTABLE {
    /* DirectDraw4 reimplements everything, here i've only changed funtions with diferent 
     * signatures and others for whithc there were already different hooks
     */
    const decltype(DirectDraw_QueryInterface)         * QueryInterface         = DirectDraw_QueryInterface;
    const decltype(DirectDraw_AddRef)                 * AddRef                 = DirectDraw_AddRef;
    const decltype(DirectDraw_Release)                * Release                = DirectDraw_Release;
    const decltype(DirectDraw_Compact)                * Compact                = DirectDraw_Compact;
    const decltype(DirectDraw_CreateClipper)          * CreateClipper          = DirectDraw_CreateClipper;
    const decltype(DirectDraw_CreatePalette)          * CreatePalette          = DirectDraw_CreatePalette;
    const decltype(DirectDraw7_CreateSurface)         * CreateSurface          = DirectDraw7_CreateSurface;
    const decltype(DirectDraw7_DuplicateSurface)      * DuplicateSurface       = DirectDraw7_DuplicateSurface;
    //const decltype(DirectDraw4_EnumDisplayModes)    * EnumDisplayModes       = DirectDraw4_EnumDisplayModes;
    const decltype(DirectDraw_EnumDisplayModes)       * EnumDisplayModes       = DirectDraw_EnumDisplayModes;
    const decltype(DirectDraw7_EnumSurfaces)          * EnumSurfaces           = DirectDraw7_EnumSurfaces;
    const decltype(DirectDraw_FlipToGDISurface)       * FlipToGDISurface       = DirectDraw_FlipToGDISurface;
    const decltype(DirectDraw_GetCaps)                * GetCaps                = DirectDraw_GetCaps;
    const decltype(DirectDraw4_GetDisplayMode)        * GetDisplayMode         = DirectDraw4_GetDisplayMode;
    const decltype(DirectDraw_GetFourCCCodes)         * GetFourCCCodes         = DirectDraw_GetFourCCCodes;
    const decltype(DirectDraw7_GetGDISurface)         * GetGDISurface          = DirectDraw7_GetGDISurface;
    const decltype(DirectDraw_GetMonitorFrequency)    * GetMonitorFrequency    = DirectDraw_GetMonitorFrequency;
    const decltype(DirectDraw_GetScanLine)            * GetScanLine            = DirectDraw_GetScanLine;
    const decltype(DirectDraw_GetVerticalBlankStatus) * GetVerticalBlankStatus = DirectDraw_GetVerticalBlankStatus;
    const decltype(DirectDraw_Initialize)             * Initialize             = DirectDraw_Initialize;
    const decltype(DirectDraw_RestoreDisplayMode)     * RestoreDisplayMode     = DirectDraw_RestoreDisplayMode;
    const decltype(DirectDraw4_SetCooperativeLevel)   * SetCooperativeLevel    = DirectDraw4_SetCooperativeLevel;
    const decltype(DirectDraw4_SetDisplayMode)        * SetDisplayMode         = DirectDraw4_SetDisplayMode;
    const decltype(DirectDraw_WaitForVerticalBlank)   * WaitForVerticalBlank   = DirectDraw_WaitForVerticalBlank;
    const decltype(DirectDraw4_GetAvailableVidMem)    * GetAvailableVidMem     = DirectDraw4_GetAvailableVidMem;
    const decltype(DirectDraw4_GetSurfaceFromDC)      * GetSurfaceFromDC       = DirectDraw4_GetSurfaceFromDC;
    const decltype(DirectDraw4_RestoreAllSurfaces)    * RestoreAllSurfaces     = DirectDraw4_RestoreAllSurfaces;
    const decltype(DirectDraw4_TestCooperativeLevel)  * TestCooperativeLevel   = DirectDraw4_TestCooperativeLevel;
    const decltype(DirectDraw7_GetDeviceIdentifier)   * GetDeviceIdentifier    = DirectDraw7_GetDeviceIdentifier;
    const decltype(DirectDraw7_StartModeTest)         * StartModeTest          = DirectDraw7_StartModeTest;
    const decltype(DirectDraw7_EvaluateMode)          * EvaluateMode           = DirectDraw7_EvaluateMode;      
} IDirectDraw7Vtable;

struct IDIRECT3D7_VTABLE {
    decltype(DirectDraw_QueryInterface)      * QueryInterface       = DirectDraw_QueryInterface;
    decltype(DirectDraw_AddRef)              * AddRef               = DirectDraw_AddRef;
    decltype(DirectDraw_Release)             * Release              = DirectDraw_Release;
    decltype(Direct3D7_EnumDevices)          * EnumDevices          = Direct3D7_EnumDevices;
    decltype(Direct3D7_CreateDevice)         * CreateDevice         = Direct3D7_CreateDevice;
    decltype(Direct3D7_CreateVertexBuffer)   * CreateVertexBuffer   = Direct3D7_CreateVertexBuffer;   
    decltype(Direct3D7_EnumZBufferFormats)   * EnumZBufferFormats   = Direct3D7_EnumZBufferFormats;
    decltype(Direct3D7_EvictManagedTextures) * EvictManagedTextures = Direct3D7_EvictManagedTextures;
} IDirect3D7Vtable;

DirectDraw::DirectDraw(IUnknown* IDirectDraw, DWORD version) : PrivateDataObjectParent(IDirectDraw)
{
    m_Imp  = IDirectDraw;   
    m_dd   = { (LPVOID)&IDirectDrawVtable,  (LPVOID)this };
    m_dd2  = { (LPVOID)&IDirectDraw2Vtable, (LPVOID)this };    
    m_dd4  = { (LPVOID)&IDirectDraw4Vtable, (LPVOID)this };
    m_dd7  = { (LPVOID)&IDirectDraw7Vtable, (LPVOID)this };
    m_d3d  = { (LPVOID)&IDirect3DVtable,    (LPVOID)this };
    m_d3d2 = { (LPVOID)&IDirect3D2Vtable,   (LPVOID)this };
    m_d3d3 = { (LPVOID)&IDirect3D3Vtable,   (LPVOID)this };
    m_d3d7 = { (LPVOID)&IDirect3D7Vtable,   (LPVOID)this };
    m_ref  = 1;
    DBUG_WARN((STR("Object created. m_refcount=[") + to_string((ULONG)m_refcount->Get()) + "]").c_str())
}

void checkddobject(COMPtr* ptr)
{
    DBUG_WARN( to_string((ULONG)&IDirectDraw2Vtable).c_str() )
    DBUG_WARN( to_string((ULONG)ptr->Vtable).c_str() )
    DBUG_WARN( to_string((ULONG)DirectDraw_QueryInterface).c_str() )
    DBUG_WARN( to_string((ULONG)IDirectDraw2Vtable.QueryInterface).c_str())
    DBUG_WARN( to_string((ULONG)IDirectDrawVtable.QueryInterface).c_str())
}
