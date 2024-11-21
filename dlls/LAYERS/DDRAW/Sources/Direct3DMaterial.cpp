#include "DirectDraw.h"
#include "LayersCommon.h"
#define  DIRECTDRAW_VERSION 0x0700
#define  DIRECT3D_VERSION 0x0700
#define  DIRECTDRAW_VERSION 0x0700
#include <ddraw.h>
#include <d3d.h>
#include <dllmain.h>
#include "Direct3D.h"
#include <memory.h>
#include <string.h>

Direct3DMaterial* GetDirect3DMaterial(COMPtr* ptr)
{
    if (ptr == nullptr)        return nullptr;
    return (Direct3DMaterial*) ptr->COMObjct;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DMaterial
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DMaterial
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

ULONG __stdcall Direct3DMaterial_AddRef(COMPtr* ptr) {
	LAYER_LOG_CALL	GET_COM_PTR(Direct3DMaterial, DDERR_GENERIC)
	_this->m_refcount->Increment(); return _this->m_Imp->AddRef();
}

HRESULT STDMETHODCALLTYPE Direct3DMaterial_QueryInterface(COMPtr * ptr, REFIID riid, void** ppvObj) {
	LAYER_LOG_CALL	GET_COM_PTR(Direct3DMaterial, DDERR_GENERIC) if (ppvObj == nullptr) return E_POINTER;

	if (riid == IID_IUnknown || riid == IID_IDirect3DMaterial) {
		*ppvObj = _this->GetDirect3DMaterial1(); Direct3DMaterial_AddRef(ptr); return 0;
	}
	else if (riid == IID_IUnknown || riid == IID_IDirect3DMaterial2) {
		*ppvObj = _this->GetDirect3DMaterial2(); Direct3DMaterial_AddRef(ptr); return 0;
	}
	else if (riid == IID_IUnknown || riid == IID_IDirect3DMaterial3) {
		*ppvObj = _this->GetDirect3DMaterial3(); Direct3DMaterial_AddRef(ptr); return 0;
	}

	DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str()).c_str());
	return E_NOINTERFACE;
}

ULONG __stdcall Direct3DMaterial_Release(COMPtr* ptr) {
	LAYER_LOG_CALL	GET_COM_PTR(Direct3DMaterial, DDERR_GENERIC)
	UINT ref = _this->m_Imp->Release(); if (_this->m_refcount->Decrement() == 0) delete _this;
	return ref;
}

STDMETHODIMP Direct3DMaterial_Initialize(COMPtr*, LPDIRECT3D) {return DDERR_ALREADYINITIALIZED;}
STDMETHODIMP Direct3DMaterial_SetMaterial(COMPtr* ptr, LPD3DMATERIAL lpMat) {
	LAYER_LOG_CALL; GET_COM_PTR(Direct3DMaterial, DDERR_GENERIC); LAYER_COM_CALL(SetMaterial, lpMat)
}
STDMETHODIMP Direct3DMaterial_GetMaterial(COMPtr* ptr, LPD3DMATERIAL lpMat) {
	LAYER_LOG_CALL; GET_COM_PTR(Direct3DMaterial, DDERR_GENERIC); LAYER_COM_CALL(GetMaterial, lpMat)
}
STDMETHODIMP Direct3DMaterial_Reserve(COMPtr* ptr)   {LAYER_LOG_CALL; return E_NOTIMPL;}
STDMETHODIMP Direct3DMaterial_UnReserve(COMPtr* ptr) {LAYER_LOG_CALL; return E_NOTIMPL;}
STDMETHODIMP Direct3DMaterial_GetHandle(COMPtr* ptr, D3DPtr* lpDirect3DDevice, LPD3DMATERIALHANDLE lpHandle) {
	LAYER_LOG_CALL; GET_COM_PTR(Direct3DMaterial, DDERR_GENERIC);
	auto _that     = GetDevice(lpDirect3DDevice);
	auto _that_imp = _that == nullptr ? nullptr : (IDirect3DDevice*)_that.get()->I();
	LAYER_COM_CALL(GetHandle, _that_imp, lpHandle)
}
#undef  LAYER_THIS
#define LAYER_THIS IDirect3DMaterial2
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DMaterial2
STDMETHODIMP Direct3DMaterial2_GetHandle(COMPtr* ptr, D3DPtr* lpDirect3DDevice, LPD3DMATERIALHANDLE lpHandle) {
	LAYER_LOG_CALL; GET_COM_PTR(Direct3DMaterial, DDERR_GENERIC);
	auto _that     = GetDevice2(lpDirect3DDevice);
	auto _that_imp = _that == nullptr ? nullptr : (IDirect3DDevice2*)_that.get()->I();
	LAYER_COM_CALL(GetHandle, _that_imp, lpHandle)
}
#undef  LAYER_THIS
#define LAYER_THIS IDirect3DMaterial3
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DMaterial3
STDMETHODIMP Direct3DMaterial3_GetHandle(COMPtr* ptr, D3DPtr* lpDirect3DDevice, LPD3DMATERIALHANDLE lpHandle) {
	LAYER_LOG_CALL; GET_COM_PTR(Direct3DMaterial, DDERR_GENERIC);
	auto _that     = GetDevice3(lpDirect3DDevice);
	auto _that_imp = _that == nullptr ? nullptr : (IDirect3DDevice3*)_that.get()->I();
	LAYER_COM_CALL(GetHandle, _that_imp, lpHandle)
}

struct D3DMATERIAL_VTABLE{
	decltype(Direct3DMaterial_QueryInterface) * QueryInterface = Direct3DMaterial_QueryInterface;
	decltype(Direct3DMaterial_AddRef)         * AddRef         = Direct3DMaterial_AddRef;
	decltype(Direct3DMaterial_Release)        * Release        = Direct3DMaterial_Release;
	decltype(Direct3DMaterial_Initialize)     * Initialize     = Direct3DMaterial_Initialize;
	decltype(Direct3DMaterial_SetMaterial)    * SetMaterial    = Direct3DMaterial_SetMaterial;
	decltype(Direct3DMaterial_GetMaterial)    * GetMaterial    = Direct3DMaterial_GetMaterial;
	decltype(Direct3DMaterial_GetHandle)      * GetHandle      = Direct3DMaterial_GetHandle;
	decltype(Direct3DMaterial_Reserve)        * Reserve        = Direct3DMaterial_Reserve;
	decltype(Direct3DMaterial_UnReserve)      * UnReserve      = Direct3DMaterial_UnReserve;
};
D3DMATERIAL_VTABLE D3DMaterialVtable;

struct D3DMATERIAL2_VTABLE{
	decltype(Direct3DMaterial_QueryInterface) * QueryInterface = Direct3DMaterial_QueryInterface;
	decltype(Direct3DMaterial_AddRef)         * AddRef         = Direct3DMaterial_AddRef;
	decltype(Direct3DMaterial_Release)        * Release        = Direct3DMaterial_Release;	
	decltype(Direct3DMaterial_SetMaterial)    * SetMaterial    = Direct3DMaterial_SetMaterial;
	decltype(Direct3DMaterial_GetMaterial)    * GetMaterial    = Direct3DMaterial_GetMaterial;
	decltype(Direct3DMaterial2_GetHandle)     * GetHandle      = Direct3DMaterial2_GetHandle;	
};
D3DMATERIAL2_VTABLE D3DMaterial2Vtable;

struct D3DMATERIAL3_VTABLE{
	decltype(Direct3DMaterial_QueryInterface) * QueryInterface = Direct3DMaterial_QueryInterface;
	decltype(Direct3DMaterial_AddRef)         * AddRef         = Direct3DMaterial_AddRef;
	decltype(Direct3DMaterial_Release)        * Release        = Direct3DMaterial_Release;	
	decltype(Direct3DMaterial_SetMaterial)    * SetMaterial    = Direct3DMaterial_SetMaterial;
	decltype(Direct3DMaterial_GetMaterial)    * GetMaterial    = Direct3DMaterial_GetMaterial;
	decltype(Direct3DMaterial3_GetHandle)     * GetHandle      = Direct3DMaterial3_GetHandle;	
};
D3DMATERIAL3_VTABLE D3DMaterial3Vtable;

Direct3DMaterial::Direct3DMaterial(IUnknown* mat) 
{
    m_Imp      = mat;    
	m_refcount = new SYNC::Atomic();
	m_refcount->Set(1);
	m_mat  = { (LPVOID)&D3DMaterialVtable,  (LPVOID)this };
	m_mat2 = { (LPVOID)&D3DMaterial2Vtable, (LPVOID)this };
	m_mat3 = { (LPVOID)&D3DMaterial3Vtable, (LPVOID)this };
}