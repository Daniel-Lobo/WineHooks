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

Direct3DVertexBuffer* GetDirect3DVertexBuffer(COMPtr* ptr)
{
	if     (ptr == nullptr)          return nullptr;
	return (Direct3DVertexBuffer*)   ptr->COMObjct;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DVertexBuffer
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DVertexBuffer
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

ULONG __stdcall Direct3DVertexBuffer_AddRef(COMPtr* ptr) {
	LAYER_LOG_CALL	GET_COM_PTR(Direct3DVertexBuffer, DDERR_GENERIC)
	UINT ref = _this->m_Imp->AddRef();
	return ref;
}

HRESULT STDMETHODCALLTYPE Direct3DVertexBuffer_QueryInterface(COMPtr* ptr, REFIID riid, void** ppvObj) {
	LAYER_LOG_CALL	GET_COM_PTR(Direct3DVertexBuffer, DDERR_GENERIC) if (ppvObj == nullptr) return E_POINTER;

	if (riid == IID_IUnknown || riid == IID_IDirect3DViewport) {
		*ppvObj = _this->GetDirect3DVertexBuffer(); Direct3DVertexBuffer_AddRef(ptr); return 0;
	}	
	DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str()).c_str());
	return E_NOINTERFACE;
}

ULONG __stdcall Direct3DVertexBuffer_Release(COMPtr* ptr) {
	LAYER_LOG_CALL	GET_COM_PTR(Direct3DVertexBuffer, DDERR_GENERIC)
	UINT ref = _this->m_Imp->Release(); if (ref == 0) delete _this;
	return ref;
}
HRESULT STDMETHODCALLTYPE Direct3DVertexBuffer_Lock(COMPtr* ptr, DWORD dwFlags, LPVOID* lplpData, LPDWORD lpdwSize) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DVertexBuffer, DDERR_GENERIC)
	LAYER_COM_CALL(Lock, dwFlags, lplpData, lpdwSize);
}
HRESULT STDMETHODCALLTYPE Direct3DVertexBuffer_Unlock(COMPtr* ptr) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DVertexBuffer, DDERR_GENERIC)
	LAYER_COM_CALL(Unlock);
}
HRESULT STDMETHODCALLTYPE Direct3DVertexBuffer_ProcessVertices(COMPtr* ptr,	DWORD dwVertexOp, DWORD dwDestIndex, DWORD dwCount,	LPDIRECT3DVERTEXBUFFER lpSrcBuffer,
															   DWORD dwSrcIndex, LPDIRECT3DDEVICE3 lpD3DDevice,	DWORD dwFlags){
	LAYER_LOG_CALL GET_COM_PTR(Direct3DVertexBuffer, DDERR_GENERIC)
	auto _that    = lpSrcBuffer == nullptr ? nullptr : GetDirect3DVertexBuffer((COMPtr*)lpSrcBuffer)->GetImp();
	auto _that_ez = EZInterface(IID_IDirect3DVertexBuffer, _that);
	auto _dev_imp = lpD3DDevice == nullptr ? nullptr : ((D3DPtr*)lpD3DDevice)->imp;
	auto _dev_ez  = EZInterface(IID_IDirect3DDevice3, (IUnknown*)_dev_imp);
	LAYER_COM_CALL(ProcessVertices, dwVertexOp, dwDestIndex, dwCount, (IDirect3DVertexBuffer*)_that_ez.I(), dwSrcIndex, (IDirect3DDevice3*)_dev_ez.I(), dwFlags);
}
HRESULT STDMETHODCALLTYPE Direct3DVertexBuffer_GetVertexBufferDesc(COMPtr* ptr, LPD3DVERTEXBUFFERDESC lpVBDesc) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DVertexBuffer, DDERR_GENERIC) LAYER_COM_CALL(GetVertexBufferDesc, lpVBDesc);
}
HRESULT STDMETHODCALLTYPE Direct3DVertexBuffer_Optimize(COMPtr* ptr, LPDIRECT3DDEVICE3 lpD3DDevice, DWORD dwFlags) {
	LAYER_LOG_CALL GET_COM_PTR(Direct3DVertexBuffer, DDERR_GENERIC)
	auto _dev_imp = lpD3DDevice == nullptr ? nullptr : ((D3DPtr*)lpD3DDevice)->imp;
	auto _dev_ez  = EZInterface(IID_IDirect3DDevice3, (IUnknown*)_dev_imp);
	LAYER_COM_CALL(Optimize, (IDirect3DDevice3*)_dev_ez.I(), dwFlags);
}

struct IDIRECT3DVTERTEXBUFFER_VTABLE {
	decltype(Direct3DVertexBuffer_QueryInterface)      * QueryInterface      = Direct3DVertexBuffer_QueryInterface;
	decltype(Direct3DVertexBuffer_AddRef)              * AddRef              = Direct3DVertexBuffer_AddRef;
	decltype(Direct3DVertexBuffer_Release)             * Release             = Direct3DVertexBuffer_Release;
	decltype(Direct3DVertexBuffer_Lock)                * Lock                = Direct3DVertexBuffer_Lock;
	decltype(Direct3DVertexBuffer_Unlock)              * Unlock              = Direct3DVertexBuffer_Unlock;
	decltype(Direct3DVertexBuffer_ProcessVertices)     * ProcessVertices     = Direct3DVertexBuffer_ProcessVertices;
	decltype(Direct3DVertexBuffer_GetVertexBufferDesc) * GetVertexBufferDesc = Direct3DVertexBuffer_GetVertexBufferDesc;
	decltype(Direct3DVertexBuffer_Optimize)            * Optimize            = Direct3DVertexBuffer_Optimize;
}IDirect3DVertexBufferVtable;

Direct3DVertexBuffer::Direct3DVertexBuffer(IUnknown* vb)
{
	m_Imp = vb;
	m_vb  = {(LPVOID)&IDirect3DVertexBufferVtable, (LPVOID)this};
}

IDirect3DVertexBuffer7* GetVertexBuffer7(Direct3DVertexBuffer7* vb) {
	return vb == nullptr ? nullptr : vb->GetVertexBuffer();
}

HRESULT STDMETHODCALLTYPE Direct3DVertexBuffer7::QueryInterface(REFIID riid, void** ppvObj) {
	LAYER_LOG_CALL
	if (ppvObj == nullptr) return E_POINTER;
	if (riid == IID_IUnknown || riid == IID_IDirect3DVertexBuffer7) {
		*ppvObj = this; DBUG_LOG("Direct3DDevice7") this->AddRef(); return 0;
	}
	HRESULT hr = m_Imp->QueryInterface(riid, ppvObj);
	DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str() + " Implementation hr=" + to_string(hr)).c_str());
	return hr;
}
ULONG STDMETHODCALLTYPE Direct3DVertexBuffer7::AddRef() {
	LAYER_LOG_CALL
	ULONG ref = m_refcount->Increment(); DBUG_LOG(to_string(ref).c_str()); return ref;
}
ULONG STDMETHODCALLTYPE Direct3DVertexBuffer7::Release() {
	LAYER_LOG_CALL
	ULONG ref = m_refcount->Decrement(); DBUG_LOG(to_string(ref).c_str());
	if (ref == 0) delete this;  return ref;
}
HRESULT STDMETHODCALLTYPE Direct3DVertexBuffer7::Optimize(LPDIRECT3DDEVICE7 lpD3DDevice, DWORD dwFlags) {
	LAYER_LOG_CALL if (this == nullptr) return DDERR_INVALIDOBJECT;
	LAYER_HR_CALL(this->m_Imp->Optimize(GetDevice7((Direct3DDevice7*)lpD3DDevice), dwFlags));
}
HRESULT STDMETHODCALLTYPE Direct3DVertexBuffer7::ProcessVertices(DWORD VertexOp, DWORD DestIndex, DWORD Count, LPDIRECT3DVERTEXBUFFER7 SrcBuffer,
	                                                             DWORD SrcIndex, LPDIRECT3DDEVICE7 lpD3DDevice,	DWORD dwFlags){
	LAYER_LOG_CALL if (this == nullptr) return DDERR_INVALIDOBJECT;
	LAYER_HR_CALL(this->m_Imp->ProcessVertices(VertexOp, DestIndex, Count, GetVertexBuffer7((Direct3DVertexBuffer7*)SrcBuffer), 
		                                       SrcIndex, GetDevice7((Direct3DDevice7*)lpD3DDevice), dwFlags));
}
HRESULT STDMETHODCALLTYPE Direct3DVertexBuffer7::ProcessVerticesStrided(DWORD VertexOp,	DWORD DestIndex, DWORD Count, LPD3DDRAWPRIMITIVESTRIDEDDATA VertexArray,
	                                                                    DWORD SrcIndex, LPDIRECT3DDEVICE7 D3DDevice, DWORD Flags){
	LAYER_LOG_CALL if (this == nullptr) return DDERR_INVALIDOBJECT;
	LAYER_HR_CALL(this->m_Imp->ProcessVerticesStrided(VertexOp, DestIndex, Count, VertexArray, SrcIndex, GetDevice7((Direct3DDevice7*)D3DDevice), Flags));
}

Direct3DVertexBuffer7::Direct3DVertexBuffer7(IDirect3DVertexBuffer7* imp) {
	m_Imp      = imp;
	m_refcount = new SYNC::Atomic();
	m_refcount->Set(1);
}