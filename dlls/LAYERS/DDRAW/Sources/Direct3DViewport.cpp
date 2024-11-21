#include "DirectDraw.h"
#include "LayersCommon.h"
#define  DIRECTDRAW_VERSION 0x0700
#define  DIRECT3D_VERSION 0x0700
#define  DIRECTDRAW_VERSION 0x0700
#include <ddraw.h>
#include <d3d.h>
#include <dllmain.h>
#include "Direct3D.h"
#include "Sync.h"
#include <memory>
#include <string>
#include "DirectDraw.h" /* for the minimal layer include */

Direct3DViewPort* GetDirect3DViewport(COMPtr* ptr)
{
	if (ptr == nullptr)        return nullptr;
	return (Direct3DViewPort*) ptr->COMObjct;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DViewport
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DViewport
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

ULONG __stdcall Direct3DViewport_AddRef(COMPtr* ptr) {
	LAYER_LOG_CALL	GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)
	UINT ref = _this->m_Imp->AddRef();
	return ref;
}

HRESULT STDMETHODCALLTYPE Direct3DViewport_QueryInterface(COMPtr* ptr, REFIID riid, void** ppvObj) {
	LAYER_LOG_CALL	GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) if (ppvObj == nullptr) return E_POINTER;

	if (riid == IID_IUnknown || riid == IID_IDirect3DViewport) {
		*ppvObj = _this->GetDirect3DViewport1(); Direct3DViewport_AddRef(ptr); return 0;
	}
	else if (riid == IID_IDirect3DViewport2) {
		*ppvObj = _this->GetDirect3DViewport2(); Direct3DViewport_AddRef(ptr); return 0;
	}
	else if (riid == IID_IDirect3DViewport3) {
		*ppvObj = _this->GetDirect3DViewport3(); Direct3DViewport_AddRef(ptr); return 0;
	}

	DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str()).c_str());
	return E_NOINTERFACE;
}

ULONG __stdcall Direct3DViewport_Release(COMPtr* ptr) {
	LAYER_LOG_CALL	GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)
    UINT ref = _this->m_Imp->Release(); if (ref == 0) delete _this;
	return ref;
}

STDMETHODIMP Direct3DViewport_Initialize(COMPtr* ptr, LPDIRECT3D lpDirect3D) { return DDERR_ALREADYINITIALIZED; }
STDMETHODIMP Direct3DViewport_GetViewport(COMPtr* ptr, LPD3DVIEWPORT lpData) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) LAYER_COM_CALL(GetViewport, lpData)
}
STDMETHODIMP Direct3DViewport_SetViewport(COMPtr* ptr, LPD3DVIEWPORT lpData) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) LAYER_COM_CALL(SetViewport, lpData)
}
STDMETHODIMP Direct3DViewport_TransformVertices(COMPtr* ptr, DWORD dwVertexCount, LPD3DTRANSFORMDATA lpData, DWORD dwFlags, LPDWORD lpOffscreen) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) LAYER_COM_CALL(TransformVertices, dwVertexCount, lpData, dwFlags, lpOffscreen)
}
STDMETHODIMP Direct3DViewport_LightElements(COMPtr* ptr, DWORD dwElementCount, LPD3DLIGHTDATA lpData) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) LAYER_COM_CALL(LightElements, dwElementCount, lpData)
}
STDMETHODIMP Direct3DViewport_SetBackground(COMPtr* ptr, D3DMATERIALHANDLE hMat) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) LAYER_COM_CALL(SetBackground, hMat)
}
STDMETHODIMP Direct3DViewport_GetBackground(COMPtr* ptr, LPD3DMATERIALHANDLE hMat, LPBOOL lpValid) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) LAYER_COM_CALL(GetBackground, hMat, lpValid)
}
STDMETHODIMP Direct3DViewport_SetBackgroundDepth(COMPtr* ptr, LPDIRECTDRAWSURFACE lpDDSurface) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)
    auto _that     = lpDDSurface == nullptr ? nullptr : (DirectDrawSurface*) GetDirectDrawSurface((COMPtr*)lpDDSurface);
	auto _that_imp =       _that == nullptr ? nullptr : (IDirectDrawSurface*) EZInterface(IID_IDirectDrawSurface, _that->GetImp()).I();
	LAYER_COM_CALL(SetBackgroundDepth, _that_imp)
}
STDMETHODIMP Direct3DViewport_GetBackgroundDepth(COMPtr* ptr, LPDIRECTDRAWSURFACE* lplpDDSurface, LPBOOL lpValid) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)
	auto _this_imp = (IDirect3DViewport*) EZInterface(LAYER_GUID, _this->GetImp()).I();
	if (_this_imp == nullptr)
	{
		DBUG_WARN("QueryInterace Failed");
		return DDERR_GENERIC;
	}
	HRESULT hr = _this_imp->GetBackgroundDepth(lplpDDSurface, lpValid);
	if (FAILED(hr))
	{
		DBUG_WARN("GetBackgroundDepth Failed");
		return hr;
	}
	DirectDrawSurface* srfc = FindSurfaceWrapper((IUnknown*)*lplpDDSurface, nullptr, __FUNCTION__);
	if (srfc == nullptr)
	{
		DBUG_WARN("FindSurfaceWrapper FAILED")
		return DDERR_GENERIC;
	}
	*lplpDDSurface = (IDirectDrawSurface*)srfc->GetDirectDrawSurface1();
	return hr;
}
STDMETHODIMP Direct3DViewport_Clear(COMPtr* ptr, DWORD dwCount, LPD3DRECT lpRects, DWORD dwFlags) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)	
	LAYER_COM_CALL(Clear, dwCount, lpRects, dwFlags)
}
STDMETHODIMP MinimalDirect3DViewport_AddLight(COMPtr* ptr, Direct3DLight* lpDirect3DLight) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)	LAYER_COM_CALL(AddLight, lpDirect3DLight)
}
STDMETHODIMP MinimalDirect3DViewport_DeleteLight(COMPtr* ptr, Direct3DLight* lpDirect3DLight) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)	LAYER_COM_CALL(DeleteLight, lpDirect3DLight)
}
STDMETHODIMP MinimalDirect3DViewport_NextLight(COMPtr* ptr, Direct3DLight* lpDirect3DLight, LPDIRECT3DLIGHT* lplpDirect3DLight, DWORD dwFlags) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)	LAYER_COM_CALL(NextLight, lpDirect3DLight, lplpDirect3DLight, dwFlags)
}
STDMETHODIMP Direct3DViewport_AddLight(COMPtr* ptr, Direct3DLight * lpDirect3DLight) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)	
	auto _that_imp = lpDirect3DLight == nullptr ? nullptr : lpDirect3DLight->GetImp();
	auto _this_imp = (IDirect3DViewport*)EZInterface(IID_IDirect3DViewport, _this->GetImp()).I();
	HRESULT hr     = _this_imp->AddLight(_that_imp);
	if (FAILED(hr))
	{
		DBUG_WARN(LAYER_PARSE_ERROR(hr));
		return hr;
	}
	_this->__PrivateAddLight(_that_imp, (Direct3DLight *)(void*)lpDirect3DLight);
	DBUG_LOG("DD_OK");
	return hr;
}
STDMETHODIMP Direct3DViewport_DeleteLight(COMPtr* ptr, Direct3DLight* lpDirect3DLight) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)
	auto _that_imp = lpDirect3DLight == nullptr ? nullptr : lpDirect3DLight->GetImp();
	auto _this_imp = (IDirect3DViewport*)EZInterface(IID_IDirect3DViewport, _this->GetImp()).I();
	if (_that_imp == nullptr)
	{
		DBUG_WARN("_that_imp == nullptr");
		return DDERR_INVALIDPARAMS;
	}
	if (FALSE == _this->HasLight(_that_imp))
	{
		DBUG_WARN("_this->HasLight(_that_imp) == FALSE");
		return DDERR_INVALIDPARAMS;
	}
	_that_imp->AddRef(); HRESULT hr = _this_imp->DeleteLight(_that_imp); _that_imp->Release();
	_this->__PrivateDeleteLight(_that_imp);
	DBUG_LOG(LAYER_PARSE_ERROR(hr));
	return hr;	
}
STDMETHODIMP Direct3DViewport_NextLight(COMPtr* ptr, Direct3DLight* lpDirect3DLight, LPDIRECT3DLIGHT* lplpDirect3DLight, DWORD dwFlags) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)
	auto _that_imp = lpDirect3DLight == nullptr ? nullptr : lpDirect3DLight->GetImp();
	auto _this_imp = (IDirect3DViewport*)EZInterface(IID_IDirect3DViewport, _this->GetImp()).I();
	HRESULT hr     = _this_imp->NextLight(_that_imp, lplpDirect3DLight, dwFlags);
	if (FAILED(hr))
	{
		DBUG_WARN(LAYER_PARSE_ERROR(hr));
		return hr;
	}
	if (FALSE == _this->HasLight(_that_imp))
	{
		DBUG_WARN("_this->HasLight(_that_imp) == FALSE");
		return DDERR_INVALIDPARAMS;
	}
	*lplpDirect3DLight = _this->GetLight(*lplpDirect3DLight);
	return hr;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DViewport2
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DViewport2
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP Direct3DViewport_GetViewport2(COMPtr* ptr, LPD3DVIEWPORT2 lpData) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) LAYER_COM_CALL(GetViewport2, lpData)
}
STDMETHODIMP Direct3DViewport_SetViewport2(COMPtr* ptr, LPD3DVIEWPORT2 lpData) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) 	
    LAYER_COM_CALL(SetViewport2, lpData)
}

/* Reproduce the internal behaviour of the MS implementation on which the hooks relly: SetViewport calls Setviewport2
 */
STDMETHODIMP Direct3DViewport1_SetViewport(COMPtr* ptr, LPD3DVIEWPORT vw) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)
	if (vw == nullptr)                     return DDERR_INVALIDPARAMS;
	if (vw->dwSize != sizeof(D3DVIEWPORT)) return DDERR_INVALIDPARAMS;
	D3DVIEWPORT2 vw2 = {sizeof(D3DVIEWPORT2), vw->dwX, vw->dwY, vw->dwWidth, vw->dwHeight, 0, 0, vw->dwWidth, vw->dwHeight, vw->dvMinZ, vw->dvMaxZ};
	//LAYER_HR_CALL(Direct3DViewport_SetViewport2(ptr, &vw2))
	auto _this_imp = (IDirect3DViewport2*)EZInterface(LAYER_GUID, _this->GetImp()).I();
	if (_this_imp == nullptr)
	{
		DBUG_WARN("QueryInterace Failed");
		return DDERR_GENERIC;
	}
	HRESULT Hr = _this_imp->SetViewport(vw);
	if (FAILED(Hr))
	{
		DBUG_WARN("SetViewport Failed");
		return Hr;
	}
	Hr = _this_imp->GetViewport2(&vw2);
	if (FAILED(Hr))
	{
		DBUG_WARN("GetViewport2 Failed");
		return Hr;
	}
	LAYER_HR_CALL(Direct3DViewport_SetViewport2(ptr, &vw2))
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DViewport3
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DViewport3
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"  

STDMETHODIMP Direct3DViewport3_GetViewport2(COMPtr* ptr, LPD3DVIEWPORT2 lpData) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) LAYER_COM_CALL(GetViewport2, lpData)
}
STDMETHODIMP Direct3DViewport3_SetViewport2(COMPtr* ptr, LPD3DVIEWPORT2 lpData) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) LAYER_COM_CALL(SetViewport2, lpData)
}

STDMETHODIMP Direct3DViewport_SetBackgroundDepth2(COMPtr* ptr, LPDIRECTDRAWSURFACE4 lpDDSurface) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)
    auto _that     = lpDDSurface == nullptr ? nullptr : (DirectDrawSurface*)GetDirectDrawSurface ((COMPtr*)lpDDSurface);
	auto _that_imp =       _that == nullptr ? nullptr : (IDirectDrawSurface4*) EZInterface(IID_IDirectDrawSurface4, _that->GetImp()).I();
	LAYER_COM_CALL(SetBackgroundDepth2, _that_imp)
}
STDMETHODIMP Direct3DViewport_GetBackgroundDepth2(COMPtr* ptr, LPDIRECTDRAWSURFACE4* lplpDDSurface, LPBOOL lpValid) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC)
	auto _this_imp = (IDirect3DViewport3*) EZInterface(LAYER_GUID, _this->GetImp()).I();
	if (_this_imp == nullptr)
	{
		DBUG_WARN("QueryInterace Failed");
		return DDERR_GENERIC;
	}
	HRESULT hr = _this_imp->GetBackgroundDepth2(lplpDDSurface, lpValid);
	if (FAILED(hr))
	{
		DBUG_WARN("GetBackgroundDepth Failed");
		return hr;
	}
	DirectDrawSurface* srfc = FindSurfaceWrapper((IUnknown*)*lplpDDSurface, nullptr, __FUNCTION__);
	if (srfc == nullptr)
	{
		DBUG_WARN("FindSurfaceWrapper FAILED")
		return DDERR_GENERIC;
	}
	*lplpDDSurface = (IDirectDrawSurface4*)srfc->GetDirectDrawSurface4();
	return hr;
}

STDMETHODIMP Direct3DViewport_Clear2(COMPtr* ptr, DWORD dwCount, LPD3DRECT lpRects, DWORD dwFlags, DWORD dwColor, D3DVALUE dvZ, DWORD dwStencil) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DViewPort, DDERR_GENERIC) LAYER_COM_CALL(Clear2, dwCount, lpRects, dwFlags, dwColor, dvZ, dwStencil)
}

struct D3DVIEWPORT_VTABLE {
	decltype(Direct3DViewport_QueryInterface)     * QueryInterface     = Direct3DViewport_QueryInterface;
	decltype(Direct3DViewport_AddRef)             * AddRef             = Direct3DViewport_AddRef;
	decltype(Direct3DViewport_Release)            * Release            = Direct3DViewport_Release;
	decltype(Direct3DViewport_Initialize)         * Initialize         = Direct3DViewport_Initialize;
	decltype(Direct3DViewport_GetViewport)        * GetViewport        = Direct3DViewport_GetViewport;
	//decltype(Direct3DViewport_SetViewport)      * SetViewport = Direct3DViewport_SetViewport;
	decltype(Direct3DViewport1_SetViewport)       * SetViewport        = Direct3DViewport1_SetViewport;
	decltype(Direct3DViewport_TransformVertices)  * TransformVertices  = Direct3DViewport_TransformVertices;
	decltype(Direct3DViewport_LightElements)      * LightElements      = Direct3DViewport_LightElements;
	decltype(Direct3DViewport_SetBackground)      * SetBackground      = Direct3DViewport_SetBackground;
	decltype(Direct3DViewport_GetBackground)      * GetBackground      = Direct3DViewport_GetBackground;
	decltype(Direct3DViewport_SetBackgroundDepth) * SetBackgroundDepth = Direct3DViewport_SetBackgroundDepth;
	decltype(Direct3DViewport_GetBackgroundDepth) * GetBackgroundDepth = Direct3DViewport_GetBackgroundDepth;
	decltype(Direct3DViewport_Clear)              * Clear              = Direct3DViewport_Clear;
#ifdef DDRAW_MINIMAL_LAYER
	decltype(Direct3DViewport_AddLight)           * AddLight           = MinimalDirect3DViewport_AddLight;
	decltype(Direct3DViewport_DeleteLight)        * DeleteLight        = MinimalDirect3DViewport_DeleteLight;
	decltype(Direct3DViewport_NextLight)          * NextLight          = MinimalDirect3DViewport_NextLight;
#else
	decltype(Direct3DViewport_AddLight)           * AddLight           = Direct3DViewport_AddLight;
	decltype(Direct3DViewport_DeleteLight)        * DeleteLight        = Direct3DViewport_DeleteLight;
	decltype(Direct3DViewport_NextLight)          * NextLight          = Direct3DViewport_NextLight;
#endif // DDRAW_MINIMAL_LAYER
	
};
D3DVIEWPORT_VTABLE D3DViewportVtable;

struct D3DVIEWPORT2_VTABLE {
	D3DVIEWPORT_VTABLE Vtable1;
	decltype(Direct3DViewport_GetViewport2) * GetViewport2 = Direct3DViewport_GetViewport2;
	decltype(Direct3DViewport_SetViewport2) * SetViewport2 = Direct3DViewport_SetViewport2;
}; 
D3DVIEWPORT2_VTABLE D3DViewportVtable2;

struct D3DVIEWPORT3_VTABLE {
	D3DVIEWPORT_VTABLE Vtable1;
	//decltype(Direct3DViewport3_GetViewport2)       * GetViewport2 = Direct3DViewport_GetViewport2;
	//decltype(Direct3DViewport3_SetViewport2)       * SetViewport2 = Direct3DViewport_SetViewport2;
	decltype(Direct3DViewport_GetViewport2)        * GetViewport2 = Direct3DViewport_GetViewport2;
	decltype(Direct3DViewport_SetViewport2)        * SetViewport2 = Direct3DViewport_SetViewport2;
	decltype(Direct3DViewport_SetBackgroundDepth2) * SetBackgroundDepth2 = Direct3DViewport_SetBackgroundDepth2;
	decltype(Direct3DViewport_GetBackgroundDepth2) * GetBackgroundDepth2 = Direct3DViewport_GetBackgroundDepth2;
	decltype(Direct3DViewport_Clear2)              * Clear2              = Direct3DViewport_Clear2;
};
D3DVIEWPORT3_VTABLE D3DViewportVtable3;

Direct3DViewPort::Direct3DViewPort(IUnknown* view)
{
	m_Imp   = view;
	m_view  = {(LPVOID)&D3DViewportVtable,  (LPVOID)this};
	m_view2 = {(LPVOID)&D3DViewportVtable2, (LPVOID)this};
	m_view3 = {(LPVOID)&D3DViewportVtable3, (LPVOID)this};
	m_lock = new SYNC::AtomicLock();
};