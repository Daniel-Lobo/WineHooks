#include "DirectDraw.h"
#include "LayersCommon.h"
#define  DIRECTDRAW_VERSION 0x0700
#define  DIRECT3D_VERSION 0x0700
#define  DIRECTDRAW_VERSION 0x0700

#include <ddraw.h>
#include <d3d.h>
#include <dllmain.h>
#include <string>
#include "Direct3D.h"

#include "D3D12Hooks.h"
#include "D3DHooks.h"

std::unique_ptr<EZInterface> GetDevice(D3DPtr* pDvc)
{
	if (pDvc        == nullptr) return nullptr;
	if (pDvc->d3d_1 == TRUE)    
	{
		DirectDrawSurface* srfc = (DirectDrawSurface*)pDvc->COMObjct;
		if (srfc == nullptr) return nullptr;
		if (srfc->GetType()      == D3DDEVICETYPE::HAL)  return unique_ptr<EZInterface>(new EZInterface(IID_IDirect3DHALDevice, pDvc->imp));
		else if (srfc->GetType() == D3DDEVICETYPE::RGB)  return unique_ptr<EZInterface>(new EZInterface(IID_IDirect3DRGBDevice, pDvc->imp));
		else if (srfc->GetType() == D3DDEVICETYPE::RAMP) return unique_ptr<EZInterface>(new EZInterface(IID_IDirect3DRampDevice, pDvc->imp));
		else if (srfc->GetType() == D3DDEVICETYPE::MMX)  return unique_ptr<EZInterface>(new EZInterface(IID_IDirect3DMMXDevice, pDvc->imp));		
	}
	else {
		Direct3DDevice* dvc = (Direct3DDevice*)pDvc->COMObjct;		
		return dvc == nullptr ? nullptr : unique_ptr<EZInterface>(new EZInterface(IID_IDirect3DDevice, pDvc->imp));
	}
	DBUG_WARN("BAD TYPE");
	return nullptr;
}

std::unique_ptr<EZInterface> GetDevice2(D3DPtr* pDvc) {
	if (pDvc == nullptr) return nullptr;
	Direct3DDevice* dvc = (Direct3DDevice*)pDvc->COMObjct;
	return dvc == nullptr ? nullptr : unique_ptr<EZInterface>(new EZInterface(IID_IDirect3DDevice2, pDvc->imp));	
}

std::unique_ptr<EZInterface> GetDevice3(D3DPtr* pDvc) {
	if (pDvc == nullptr) return nullptr;
	Direct3DDevice* dvc = (Direct3DDevice*)pDvc->COMObjct;
	return dvc == nullptr ? nullptr : unique_ptr<EZInterface>(new EZInterface(IID_IDirect3DDevice3, pDvc->imp));
}

#define GET_D3DEVICE3 LAYER_LOG_CALL auto ez = GetDevice3(pDvc); IDirect3DDevice3* _this = (IDirect3DDevice3*)ez.get()->I(); \
if (_this == nullptr) {DBUG_WARN("GetDevice FAILED"); return DDERR_GENERIC;} DBUG_LOG((STR("_this=[")+to_string((long)pDvc->COMObjct)+"]").c_str()) 

#define GET_D3DEVICE2 LAYER_LOG_CALL auto ez = GetDevice2(pDvc); IDirect3DDevice2* _this = (IDirect3DDevice2*)ez.get()->I(); \
if (_this == nullptr) {DBUG_WARN("GetDevice FAILED"); return DDERR_GENERIC;} DBUG_LOG((STR("_this=[")+to_string((long)pDvc->COMObjct)+"]").c_str()) 

#define GET_D3DEVICE LAYER_LOG_CALL auto ez = GetDevice(pDvc); IDirect3DDevice* _this = (IDirect3DDevice*)ez.get()->I(); \
if (_this == nullptr) {DBUG_WARN("GetDevice FAILED"); return DDERR_GENERIC;} DBUG_LOG((STR("_this=[")+to_string((long)pDvc->COMObjct)+"]").c_str()) 

STDMETHODIMP Direct3DDevice_Initialize(D3DPtr* pDvc, LPDIRECT3D lpd3d, LPGUID lpGUID, LPD3DDEVICEDESC lpd3ddvdesc) {
	return E_NOTIMPL;
}
STDMETHODIMP Direct3DDevice_GetCaps(D3DPtr* pDvc, LPD3DDEVICEDESC lpD3DHWDevDesc, LPD3DDEVICEDESC lpD3DHELDevDesc) {
	GET_D3DEVICE LAYER_HR_CALL(_this->GetCaps(lpD3DHWDevDesc, lpD3DHELDevDesc));
}
STDMETHODIMP Direct3DDevice_SwapTextureHandles(D3DPtr* pDvc, LPDIRECT3DTEXTURE lpD3DTex1, LPDIRECT3DTEXTURE lpD3DTex2) {
	GET_D3DEVICE 
	auto tex_1    = lpD3DTex1 == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpD3DTex1)->GetImp();
	auto tex_2    = lpD3DTex2 == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpD3DTex2)->GetImp();
	auto tex_1_ez = EZInterface(IID_IDirect3DTexture, tex_1);
	auto tex_2_ez = EZInterface(IID_IDirect3DTexture, tex_2);
	LAYER_HR_CALL(_this->SwapTextureHandles((IDirect3DTexture*)tex_1_ez.I(), (IDirect3DTexture*)tex_2_ez.I()));
}
STDMETHODIMP Direct3DDevice_CreateExecuteBuffer(D3DPtr* pDvc, LPD3DEXECUTEBUFFERDESC lpDesc, LPDIRECT3DEXECUTEBUFFER* lplpDirect3DExecuteBuffer, IUnknown* pUnkOuter) {
	GET_D3DEVICE
	HRESULT hr = _this->CreateExecuteBuffer(lpDesc, lplpDirect3DExecuteBuffer, pUnkOuter);
	if (FAILED(hr))
	{
		DBUG_WARN("FAILED");
		return hr;
	}
	auto buff = new Direct3DExecuteBuffer(*lplpDirect3DExecuteBuffer);
	*lplpDirect3DExecuteBuffer = dynamic_cast<IDirect3DExecuteBuffer*>(buff);
	DBUG_LOG((STR("Created buffer=[") + to_string((long)buff) + "]").c_str());
	return hr;
}
STDMETHODIMP Direct3DDevice_GetStats(D3DPtr* pDvc, LPD3DSTATS lpD3DStats) {
	GET_D3DEVICE LAYER_HR_CALL(_this->GetStats(lpD3DStats));
}
STDMETHODIMP Direct3DDevice_Execute(D3DPtr* pDvc, IDirect3DExecuteBuffer* lpDirect3DExecuteBuffer, LPDIRECT3DVIEWPORT lpDirect3DViewport, DWORD dwFlags) {
	GET_D3DEVICE
	DBUG_LOG(to_string((long)lpDirect3DExecuteBuffer).c_str());
	auto buff_imp = lpDirect3DExecuteBuffer == nullptr ? nullptr : dynamic_cast<Direct3DExecuteBuffer*>(lpDirect3DExecuteBuffer)->GetImp();
	auto view     = lpDirect3DViewport      == nullptr ? nullptr : GetDirect3DViewport((COMPtr*)lpDirect3DViewport);
	auto view_imp = view                    == nullptr ? nullptr : (IDirect3DViewport*)EZInterface(IID_IDirect3DViewport, view->GetImp()).I();
	if (g_d3d.TEXTURE_SWAP_ENABLED && buff_imp != nullptr)
	{
		IDirect3DExecuteBuffer * eBuff = (IDirect3DExecuteBuffer*)buff_imp;
		D3DINSTRUCTION         * pInstruction;
		D3DEXECUTEDATA           eData = { sizeof(D3DEXECUTEDATA) };
		D3DEXECUTEBUFFERDESC eBuffDesc = { sizeof(D3DEXECUTEBUFFERDESC) };
		struct d3dstate { DWORD State, Value; };
		d3dstate* s = nullptr;		

		eBuff->GetExecuteData(&eData);
		if (eBuff->Lock(&eBuffDesc) == S_OK) 
		{
			pInstruction = (D3DINSTRUCTION*)((DWORD)eBuffDesc.lpData + eData.dwInstructionOffset);
			while (pInstruction != nullptr && pInstruction->bOpcode != D3DOP_EXIT)
			{
				if (pInstruction->bOpcode == 8)
				{
					s = (d3dstate*)((DWORD)pInstruction + 4);
					for (DWORD i = 1; i <= pInstruction->wCount; i++)
					{
						if ((s->State == 1) && s->Value)
						{	
							DirectDrawSurface* tx = D3DGlobals.GetSurfaceFromHandle(s->Value);							
							if      (tx == (LPVOID) D3DHooksData->current_texture) s->Value = 0;
							else if (tx != nullptr)                                s->Value = tx->Gethandle(_this);
						}
						s = (d3dstate*)((DWORD)s + pInstruction->bSize);
					}
				}
				pInstruction = (D3DINSTRUCTION*)((DWORD)pInstruction + pInstruction->bSize * pInstruction->wCount);
				pInstruction = (D3DINSTRUCTION*)((DWORD)pInstruction + 4);
			}
			eBuff->Unlock();
		}
	}
	LAYER_HR_CALL(_this->Execute(buff_imp, view_imp, dwFlags));
}
STDMETHODIMP Direct3DDevice_Pick(D3DPtr* pDvc, IDirect3DExecuteBuffer* lpDirect3DExecuteBuffer, LPDIRECT3DVIEWPORT lpDirect3DViewport, DWORD dwFlags, LPD3DRECT lpRect) {
	GET_D3DEVICE
	auto buff_imp = lpDirect3DExecuteBuffer == nullptr ? nullptr : dynamic_cast<Direct3DExecuteBuffer*>(lpDirect3DExecuteBuffer)->GetImp();
	auto view     = lpDirect3DViewport      == nullptr ? nullptr : GetDirect3DViewport((COMPtr*)lpDirect3DViewport);
	auto view_imp = view                    == nullptr ? nullptr : (IDirect3DViewport*)EZInterface(IID_IDirect3DViewport, view->GetImp()).I();
	LAYER_HR_CALL(_this->Pick(buff_imp, view_imp, dwFlags, lpRect));
}
STDMETHODIMP Direct3DDevice_GetPickRecords(D3DPtr* pDvc, LPDWORD lpCount, LPD3DPICKRECORD lpD3DPickRec) {
	GET_D3DEVICE LAYER_HR_CALL(_this->GetPickRecords(lpCount, lpD3DPickRec));
}
STDMETHODIMP Direct3DDevice_EnumTextureFormats(D3DPtr* pDvc, LPD3DENUMTEXTUREFORMATSCALLBACK lpd3dEnumTextureProc, LPVOID lpArg) {
	GET_D3DEVICE LAYER_HR_CALL(_this->EnumTextureFormats(lpd3dEnumTextureProc, lpArg));
}
STDMETHODIMP Direct3DDevice_CreateMatrix(D3DPtr* pDvc, LPD3DMATRIXHANDLE lpD3DMatHandle) {
	GET_D3DEVICE LAYER_HR_CALL(_this->CreateMatrix(lpD3DMatHandle));
}
STDMETHODIMP Direct3DDevice_SetMatrix(D3DPtr* pDvc, D3DMATRIXHANDLE d3dMatHandle, LPD3DMATRIX lpD3DMatrix) {
	GET_D3DEVICE LAYER_HR_CALL(_this->SetMatrix(d3dMatHandle, lpD3DMatrix));
}
STDMETHODIMP Direct3DDevice_GetMatrix(D3DPtr* pDvc, D3DMATRIXHANDLE lpD3DMatHandle, LPD3DMATRIX lpD3DMatrix) {
	GET_D3DEVICE LAYER_HR_CALL(_this->GetMatrix(lpD3DMatHandle, lpD3DMatrix));
}
STDMETHODIMP Direct3DDevice_DeleteMatrix(D3DPtr* pDvc, D3DMATRIXHANDLE d3dMatHandle) {
	GET_D3DEVICE LAYER_HR_CALL(_this->DeleteMatrix(d3dMatHandle));
}
STDMETHODIMP Direct3DDevice_BeginScene(D3DPtr* pDvc) {
	GET_D3DEVICE LAYER_HR_CALL(_this->BeginScene());
}
STDMETHODIMP Direct3DDevice_EndScene(D3DPtr* pDvc) {
	GET_D3DEVICE 
    if (g_d3d.DELAY_TEXTURE_RELEASES)
	{
		HRESULT hrr =_this->EndScene();		
		if (D3DGlobals.Delayed_Release_Textures.size() > 0)
		{
			for (int ii = 0; ii < D3DGlobals.Delayed_Release_Textures.size(); ii++)
			{
				D3DGlobals.Delayed_Release_Textures.at(ii)->Release();
			}
			D3DGlobals.Delayed_Release_Textures.clear();
		}
		LAYER_HR_CALL(hrr);
	}
    LAYER_HR_CALL(_this->EndScene());
}
STDMETHODIMP Direct3DDevice_GetDirect3D(D3DPtr* pDvc, LPDIRECT3D* pd3d) {
	GET_D3DEVICE
	HRESULT hr = _this->GetDirect3D(pd3d);
	if FAILED(hr) {
		LAYER_PARSE_ERROR(hr); return hr;
	}
	if (pDvc->d3d_1 == TRUE) {
		auto dd = FindSurfaceObject(_this, DIRECTDRAW_ID::DDRAW, __FUNCTION__);
		if (dd == nullptr)	{
			*pd3d = nullptr; return DDERR_GENERIC;
		}
		*pd3d = (IDirect3D*)dynamic_cast<DirectDraw*>(dd)->GetDirect3D1();
		return hr;
	} else {
		auto dvc2 = EZInterface(IID_IDirect3DDevice2, _this);
		if (dvc2.I() == nullptr) {
			DBUG_WARN("NO DEVICE"); return DDERR_GENERIC;
		}
		IDirectDrawSurface * isrfc = nullptr;
		if (FAILED( ((IDirect3DDevice2*)dvc2.I())->GetRenderTarget(&isrfc) )) {
			DBUG_WARN("NO RENDERTARGET"); return DDERR_GENERIC;
		}		
		auto * dd = FindSurfaceObject(isrfc, DIRECTDRAW_ID::D3DDEVICE, __FUNCTION__);
		isrfc->Release();
		if (dd == nullptr) {
			DBUG_WARN("NO DIRECT DRAW"); return DDERR_GENERIC;
		}		
		*pd3d = (IDirect3D*)dynamic_cast<DirectDraw*>(dd)->GetDirect3D1();
		DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
	}	
}

struct D3DDEVICE_VTABLE{   
	decltype(DirectDrawSurface_QueryInterface)   * QueryInterface      = DirectDrawSurface_QueryInterface;
    decltype(DirectDrawSurface_AddRef)           * AddRef              = DirectDrawSurface_AddRef;
    decltype(DirectDrawSurface_Release)          * Release             = DirectDrawSurface_Release;
	decltype(Direct3DDevice_Initialize)          * Initialize          = Direct3DDevice_Initialize;
	decltype(Direct3DDevice_GetCaps)             * GetCaps             = Direct3DDevice_GetCaps;
	decltype(Direct3DDevice_SwapTextureHandles)  * SwapTextureHandles  = Direct3DDevice_SwapTextureHandles;
	decltype(Direct3DDevice_CreateExecuteBuffer) * CreateExecuteBuffer = Direct3DDevice_CreateExecuteBuffer;
	decltype(Direct3DDevice_GetStats)            * GetStats            = Direct3DDevice_GetStats;
	decltype(Direct3DDevice_Execute)             * Execute             = Direct3DDevice_Execute;
	decltype(DirectDrawSurface_AddViewport)      * AddViewport         = DirectDrawSurface_AddViewport;
	decltype(DirectDrawSurface_DeleteViewport)   * DeleteViewport      = DirectDrawSurface_DeleteViewport;
	decltype(DirectDrawSurface_NextViewport)     * NextViewport        = DirectDrawSurface_NextViewport;
	decltype(Direct3DDevice_Pick)                * Pick                = Direct3DDevice_Pick;
	decltype(Direct3DDevice_GetPickRecords)      * GetPickRecords      = Direct3DDevice_GetPickRecords;
	decltype(Direct3DDevice_EnumTextureFormats)  * EnumTextureFormats  = Direct3DDevice_EnumTextureFormats;
	decltype(Direct3DDevice_CreateMatrix)        * CreateMatrix        = Direct3DDevice_CreateMatrix;
	decltype(Direct3DDevice_SetMatrix)           * SetMatrix           = Direct3DDevice_SetMatrix;
	decltype(Direct3DDevice_GetMatrix)           * GetMatrix           = Direct3DDevice_GetMatrix;
	decltype(Direct3DDevice_DeleteMatrix)        * DeleteMatrix        = Direct3DDevice_DeleteMatrix;
	decltype(Direct3DDevice_BeginScene)          * BeginScene          = Direct3DDevice_BeginScene;
	decltype(Direct3DDevice_EndScene)            * EndScene            = Direct3DDevice_EndScene;
	decltype(Direct3DDevice_GetDirect3D)         * GetDirect3D         = Direct3DDevice_GetDirect3D;
};
D3DDEVICE_VTABLE D3DDeviceVtable;

void* GetD3DDeviceVtable() {
	return &D3DDeviceVtable;
}

STDMETHODIMP Direct3DDevice2_QueryInterface(D3DPtr* pDvc, REFIID riid, void** ppvObj){
	GET_D3DEVICE2 Direct3DDevice * dvc = (Direct3DDevice*)pDvc->COMObjct;
	if (riid == IID_IUnknown || riid == IID_IDirect3DDevice) {
		*ppvObj = dvc->GetDirect3DDevicec1(); dvc->PublicAddRef(); DBUG_LOG("Direct3DDevice1")  return 0;
	}
	else if (riid == IID_IDirect3DDevice2) {
		*ppvObj = dvc->GetDirect3DDevicec2(); dvc->PublicAddRef(); DBUG_LOG("Direct3DDevice2")  return 0;
	}
	else if (riid == IID_IDirect3DDevice3) {
		*ppvObj = dvc->GetDirect3DDevicec3(); dvc->PublicAddRef(); DBUG_LOG("Direct3DDevice3")  return 0;
	}

	HRESULT hr = _this->QueryInterface(riid, ppvObj);
	DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str() + " Implementation hr=" + to_string(hr)).c_str());
	return hr;
}

ULONG __stdcall Direct3DDevice2_Release(D3DPtr* pDvc) {
	LAYER_LOG_CALL
	auto _this = (Direct3DDevice*)pDvc->COMObjct;
	ULONG ref = _this->PublicRelease();	DBUG_LOG(to_string(ref).c_str()); return ref;
}

ULONG __stdcall Direct3DDevice2_AddRef(D3DPtr* pDvc) {
	LAYER_LOG_CALL
	auto _this = (Direct3DDevice*)pDvc->COMObjct;
	ULONG ref = _this->PublicAddRef();  DBUG_LOG(to_string(ref).c_str()); return ref;
}

STDMETHODIMP Direct3DDevice2_GetCaps(D3DPtr* pDvc, LPD3DDEVICEDESC lpD3DHWDevDesc, LPD3DDEVICEDESC lpD3DHELDevDesc) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->GetCaps(lpD3DHWDevDesc, lpD3DHELDevDesc));
};

STDMETHODIMP Direct3DDevice2_SwapTextureHandles(D3DPtr* pDvc, LPDIRECT3DTEXTURE2 lpD3DTex1, LPDIRECT3DTEXTURE2 lpD3DTex2) {
	GET_D3DEVICE2
	auto tex_1    = lpD3DTex1 == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpD3DTex1)->GetImp();
	auto tex_2    = lpD3DTex2 == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpD3DTex2)->GetImp();
	auto tex_1_ez = EZInterface(IID_IDirect3DTexture2, tex_1);
	auto tex_2_ez = EZInterface(IID_IDirect3DTexture2, tex_2);
	LAYER_HR_CALL(_this->SwapTextureHandles((IDirect3DTexture2*)tex_1_ez.I(), (IDirect3DTexture2*)tex_2_ez.I()));
}

STDMETHODIMP Direct3DDevice2_AddViewport(D3DPtr* pDvc, LPDIRECT3DVIEWPORT2 viewport) {
	GET_D3DEVICE2
	auto _that     = viewport == nullptr ? nullptr : GetDirect3DViewport((COMPtr*)viewport);
	auto _that_imp = _that    == nullptr ? nullptr : (IDirect3DViewport2*)EZInterface(IID_IDirect3DViewport2, _that->GetImp()).I();	
	DBUG_LOG((STR("that=[") + to_string((long)_that) + "]").c_str())
	HRESULT hr = _this->AddViewport(_that_imp);
	if (FAILED(hr))
	{
		DBUG_WARN(LAYER_PARSE_ERROR(hr));
		return hr;
	}
	((Direct3DDevice*)pDvc->COMObjct)->__PrivateAddViewPort(_that_imp, _that);
	DBUG_LOG(LAYER_OK);
	return hr;
}
STDMETHODIMP Direct3DDevice2_DeleteViewport(D3DPtr* pDvc, LPDIRECT3DVIEWPORT viewport) {
	GET_D3DEVICE2
	auto _that     = viewport == nullptr ? nullptr : GetDirect3DViewport((COMPtr*)viewport);
	auto _that_imp = _that    == nullptr ? nullptr : (IDirect3DViewport2*)EZInterface(IID_IDirect3DViewport2, _that->GetImp()).I();	
	if (FALSE == ((Direct3DDevice*)pDvc->COMObjct)->HasViewport(_that_imp))
	{
		DBUG_WARN("_this->HasViewPort(_that_imp) == FALSE");
		return DDERR_INVALIDPARAMS;
	}
	_that_imp->AddRef(); HRESULT hr = _this->DeleteViewport(_that_imp); _that_imp->Release();
	((Direct3DDevice*)pDvc->COMObjct)->__PrivateDeleteViewPort(_that_imp);
	DBUG_LOG(LAYER_PARSE_ERROR(hr));
	return hr;
}
STDMETHODIMP Direct3DDevice2_NextViewport(D3DPtr* pDvc, LPDIRECT3DVIEWPORT2 lpDirect3DViewport, LPDIRECT3DVIEWPORT2* lplpAnotherViewport, DWORD dwFlags) {
	GET_D3DEVICE2
	auto _that     = lpDirect3DViewport == nullptr ? nullptr : GetDirect3DViewport((COMPtr*)lpDirect3DViewport);
	auto _that_imp = _that              == nullptr ? nullptr : (IDirect3DViewport2*)EZInterface(IID_IDirect3DViewport, _that->GetImp()).I();	
	HRESULT hr     = _this->NextViewport(_that_imp, lplpAnotherViewport, dwFlags);
	if (FAILED(hr))
	{
		DBUG_WARN(LAYER_PARSE_ERROR(hr));
		return hr;
	}
	if (FALSE == ((Direct3DDevice*)pDvc->COMObjct)->HasViewport(_that_imp))
	{
		DBUG_WARN("_this->HasLight(_that_imp) == FALSE");
		return DDERR_INVALIDPARAMS;
	}
	*lplpAnotherViewport = (IDirect3DViewport2*)((Direct3DDevice*)pDvc->COMObjct)->GetViewPort(*lplpAnotherViewport)->GetDirect3DViewport1();
	DBUG_LOG(LAYER_PARSE_ERROR(hr));
	return hr;
}
STDMETHODIMP Direct3DDevice2_EndScene(D3DPtr* pDvc) {
	GET_D3DEVICE2 return Direct3DDevice_EndScene(pDvc);
}
STDMETHODIMP Direct3DDevice2_BeginScene(D3DPtr* pDvc) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->BeginScene());
}
STDMETHODIMP Direct3DDevice2_GetDirect3D(D3DPtr* pDvc, LPDIRECT3D2* pd3d) {
	GET_D3DEVICE2
	HRESULT hr = _this->GetDirect3D(pd3d);
	if FAILED(hr) {
		LAYER_PARSE_ERROR(hr); return hr;
	}
	auto _this_ez = EZInterface(IID_IDirect3DDevice2, _this);
	if (_this_ez.I() == nullptr) {
		DBUG_WARN("NO DEVICE"); return DDERR_GENERIC;
	}
	IDirectDrawSurface* isrfc = nullptr;
	if (FAILED(((IDirect3DDevice2*)_this_ez.I())->GetRenderTarget(&isrfc))) {
		DBUG_WARN("NO RENDERTARGET"); return DDERR_GENERIC;
	}
	auto* dd = FindSurfaceObject(isrfc, DIRECTDRAW_ID::D3DDEVICE, __FUNCTION__);
	isrfc->Release();
	if (dd == nullptr) {
		DBUG_WARN("NO DIRECT DRAW"); return DDERR_GENERIC;
	}
	*pd3d = (IDirect3D2*)dynamic_cast<DirectDraw*>(dd)->GetDirect3D2();
	DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}
STDMETHODIMP Direct3DDevice2_SetCurrentViewport(D3DPtr* pDvc, LPDIRECT3DVIEWPORT2 lpd3dViewport2) {
	GET_D3DEVICE2
	auto _that    = lpd3dViewport2 == nullptr ? nullptr : GetDirect3DViewport((COMPtr*)lpd3dViewport2)->GetImp();
	auto _that_ez = EZInterface(IID_IDirect3DViewport2, _that);
	LAYER_HR_CALL(_this->SetCurrentViewport((IDirect3DViewport2*)_that_ez.I()));
}
STDMETHODIMP Direct3DDevice2_GetCurrentViewport(D3DPtr* pDvc, LPDIRECT3DVIEWPORT2* lplpd3dViewport2) {
	GET_D3DEVICE2
	HRESULT hr = _this->GetCurrentViewport(lplpd3dViewport2);
	if (FAILED(hr))	{
		LAYER_PARSE_ERROR(hr); return hr;
	}
	Direct3DViewPort* view = ((Direct3DDevice*)pDvc->COMObjct)->HasViewport(*lplpd3dViewport2) ?
		((Direct3DDevice*)pDvc->COMObjct)->GetViewPort(*lplpd3dViewport2) : nullptr;
	if (view == nullptr)	{
		DBUG_WARN("NOT FOUND") *lplpd3dViewport2 = nullptr; return DDERR_GENERIC;
	}
	*lplpd3dViewport2 = (IDirect3DViewport2*)view->GetDirect3DViewport2();
	DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}
STDMETHODIMP Direct3DDevice2_GetRenderTarget(D3DPtr* pDvc, LPDIRECTDRAWSURFACE* lplpRenderTarget) {
	GET_D3DEVICE2
	HRESULT hr = _this->GetRenderTarget(lplpRenderTarget);
	if (FAILED(hr)) {
		LAYER_PARSE_ERROR(hr); return hr;
	}
	DirectDrawSurface* sfrc = FindSurfaceWrapper(*lplpRenderTarget, nullptr, __FUNCTION__);	
	if (sfrc == nullptr) {
		DBUG_WARN("NOT FOUND")* lplpRenderTarget = nullptr; return DDERR_GENERIC;
	}
	*lplpRenderTarget = (IDirectDrawSurface*)sfrc->GetDirectDrawSurface1();
	DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}
STDMETHODIMP Direct3DDevice2_SetRenderTarget(D3DPtr* pDvc, LPDIRECTDRAWSURFACE lpNewRenderTarget, DWORD dwFlags) {
	GET_D3DEVICE2
	if (lpNewRenderTarget == nullptr) {
		DBUG_WARN("nullptr"); return DDERR_INVALIDPARAMS;
	}
	IDirectDrawSurface* old = nullptr;
	if (FAILED(_this->GetRenderTarget(&old))) {
		DBUG_WARN("GetRenderTarget FAILED"); return DDERR_INVALIDPARAMS;
	}
	DirectDrawSurface* newRT = GetDirectDrawSurface((COMPtr*)lpNewRenderTarget);
	DirectDrawSurface* oldRT = FindSurfaceWrapper(old, nullptr, __FUNCTION__);
	if (oldRT == nullptr) {
		old->Release();	DBUG_WARN("FindSurfaceWrapper FAILED"); return DDERR_GENERIC;
	}
	HRESULT hr = _this->SetRenderTarget((IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, newRT->GetImp()).I(), dwFlags);
	if (FAILED(hr))	{
		old->Release();	DBUG_WARN("SetRenderTarget FAILED"); return hr;
	}		
	SetSurfacePrivateData((IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, newRT->GetImp()).I(),
		dynamic_cast<PrivateDataObjectParent*>((Direct3DDevice*)pDvc->COMObjct), DIRECTDRAW_ID::D3DDEVICE, __FUNCTION__);
	FreetSurfacePrivateData(old, DIRECTDRAW_ID::D3DDEVICE, __FUNCTION__);
	old->Release();
	DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}
STDMETHODIMP Direct3DDevice2_Begin(D3DPtr* pDvc, D3DPRIMITIVETYPE d3dpt, D3DVERTEXTYPE d3dvt, DWORD dwFlags) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->Begin(d3dpt, d3dvt, dwFlags));
}
STDMETHODIMP Direct3DDevice2_BeginIndexed(D3DPtr* pDvc, D3DPRIMITIVETYPE PrimType, D3DVERTEXTYPE VxType, LPVOID pVx, DWORD VxCount, DWORD dwFlags) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->BeginIndexed(PrimType, VxType, pVx, VxCount, dwFlags));
}
STDMETHODIMP Direct3DDevice2_Vertex(D3DPtr* pDvc, LPVOID lpVertexType) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->Vertex(lpVertexType));
}
STDMETHODIMP Direct3DDevice2_Index(D3DPtr* pDvc, WORD wVertexIndex){
	GET_D3DEVICE2 LAYER_HR_CALL(_this->Index(wVertexIndex));
}
STDMETHODIMP Direct3DDevice2_End(D3DPtr* pDvc, DWORD dwFlags) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->End(dwFlags));
}
STDMETHODIMP Direct3DDevice2_GetRenderState(D3DPtr* pDvc, D3DRENDERSTATETYPE dwRenderStateType, LPDWORD lpdwRenderState) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->GetRenderState(dwRenderStateType, lpdwRenderState));
}
STDMETHODIMP Direct3DDevice2_SetRenderState(D3DPtr* pDvc, D3DRENDERSTATETYPE dwRenderStateType, DWORD dwRenderState) {
	GET_D3DEVICE2 
	if ((dwRenderStateType == D3DRENDERSTATE_TEXTUREMAG || dwRenderStateType == D3DRENDERSTATE_TEXTUREMIN) &&  g_d3d.TEXTURE_FILTER == *(DWORD*)"TRUE")  
	return 0;
	if (dwRenderStateType == D3DRENDERSTATE_TEXTUREHANDLE && g_d3d.TEXTURE_SWAP_ENABLED) {
		if (g_d3d.TEXTURE_SWAP_ENABLED) {
			DirectDrawSurface* tx = D3DGlobals.GetSurfaceFromHandle(dwRenderState);
			if ((LPVOID)tx == (LPVOID)D3DHooksData->current_texture) dwRenderState = 0;
			else if    (tx != nullptr)                               dwRenderState = tx->Gethandle(_this);
		}		
	};
	LAYER_HR_CALL(_this->SetRenderState(dwRenderStateType, dwRenderState));
}
STDMETHODIMP Direct3DDevice2_GetLightState(D3DPtr* pDvc, D3DLIGHTSTATETYPE dwLightStateType, LPDWORD lpdwLightState) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->GetLightState(dwLightStateType, lpdwLightState));
}
STDMETHODIMP Direct3DDevice2_SetLightState(D3DPtr* pDvc, D3DLIGHTSTATETYPE dwLightStateType, DWORD dwLightState) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->SetLightState(dwLightStateType, dwLightState));
}
STDMETHODIMP Direct3DDevice2_SetTransform(D3DPtr* pDvc, D3DTRANSFORMSTATETYPE dtstTransformStateType, LPD3DMATRIX lpD3DMatrix) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->SetTransform(dtstTransformStateType, lpD3DMatrix));
}
STDMETHODIMP Direct3DDevice2_GetTransform(D3DPtr* pDvc, D3DTRANSFORMSTATETYPE dtstTransformStateType, LPD3DMATRIX lpD3DMatrix) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->GetTransform(dtstTransformStateType, lpD3DMatrix));
}
STDMETHODIMP Direct3DDevice2_MultiplyTransform(D3DPtr* pDvc, D3DTRANSFORMSTATETYPE dtstTransformStateType, LPD3DMATRIX lpD3DMatrix) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->MultiplyTransform(dtstTransformStateType, lpD3DMatrix));
}
STDMETHODIMP Direct3DDevice2_DrawPrimitive(D3DPtr* pDvc, D3DPRIMITIVETYPE PrimType, D3DVERTEXTYPE VxType, LPVOID pVx, DWORD VxCount, DWORD dwFlags) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->DrawPrimitive(PrimType, VxType, pVx, VxCount, dwFlags));
}
STDMETHODIMP Direct3DDevice2_DrawIndexedPrimitive(D3DPtr* pDvc,	D3DPRIMITIVETYPE PrimType, D3DVERTEXTYPE VxType, LPVOID pVx, DWORD VxCount,
												  LPWORD Idx, DWORD IdxCount, DWORD dwFlags){
	GET_D3DEVICE2 LAYER_HR_CALL(_this->DrawIndexedPrimitive(PrimType, VxType, pVx, VxCount, Idx, IdxCount, dwFlags));
}
STDMETHODIMP Direct3DDevice2_GetClipStatus(D3DPtr* pDvc, LPD3DCLIPSTATUS lpD3DClipStatus) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->GetClipStatus(lpD3DClipStatus));
}
STDMETHODIMP Direct3DDevice2_SetClipStatus(D3DPtr* pDvc, LPD3DCLIPSTATUS lpD3DClipStatus) {
	GET_D3DEVICE2 LAYER_HR_CALL(_this->SetClipStatus(lpD3DClipStatus));
}

STDMETHODIMP Direct3DDevice3_EndScene(D3DPtr* pDvc) {
	GET_D3DEVICE3 LAYER_HR_CALL(_this->EndScene());
}
STDMETHODIMP Direct3DDevice3_BeginScene(D3DPtr* pDvc) {
	GET_D3DEVICE3 LAYER_HR_CALL(_this->BeginScene());
}
STDMETHODIMP Direct3DDevice3_GetDirect3D(D3DPtr* pDvc, LPDIRECT3D3* pd3d) {
	GET_D3DEVICE3
	HRESULT hr = _this->GetDirect3D(pd3d);
	if FAILED(hr) {
		LAYER_PARSE_ERROR(hr); return hr;
	}
	auto _this_ez = EZInterface(IID_IDirect3DDevice3, _this);
	if (_this_ez.I() == nullptr) {
		DBUG_WARN("NO DEVICE"); return DDERR_GENERIC;
	}
	IDirectDrawSurface* isrfc = nullptr;
	if (FAILED(((IDirect3DDevice2*)_this_ez.I())->GetRenderTarget(&isrfc))) {
		DBUG_WARN("NO RENDERTARGET"); return DDERR_GENERIC;
	}
	auto* dd = FindSurfaceObject(isrfc, DIRECTDRAW_ID::D3DDEVICE, __FUNCTION__);
	isrfc->Release();
	if (dd == nullptr) {
		DBUG_WARN("NO DIRECT DRAW"); return DDERR_GENERIC;
	}
	*pd3d = (IDirect3D3*)dynamic_cast<DirectDraw*>(dd)->GetDirect3D3();
	DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}
STDMETHODIMP Direct3DDevice3_GetRenderTarget(D3DPtr* pDvc, LPDIRECTDRAWSURFACE4* lplpRenderTarget) {
	GET_D3DEVICE3
	HRESULT hr = _this->GetRenderTarget(lplpRenderTarget);
	if (FAILED(hr)) {
		LAYER_PARSE_ERROR(hr); return hr;
	}
	DirectDrawSurface* sfrc = FindSurfaceWrapper(*lplpRenderTarget, nullptr, __FUNCTION__);
	if (sfrc == nullptr) {
		DBUG_WARN("NOT FOUND")* lplpRenderTarget = nullptr; return DDERR_GENERIC;
	}
	*lplpRenderTarget = (IDirectDrawSurface4*)sfrc->GetDirectDrawSurface4();
	DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}
STDMETHODIMP Direct3DDevice3_DrawPrimitive(D3DPtr* pDvc, D3DPRIMITIVETYPE PrimType, D3DVERTEXTYPE VxType, LPVOID pVx, DWORD VxCount, DWORD dwFlags) {
	GET_D3DEVICE3 LAYER_HR_CALL(_this->DrawPrimitive(PrimType, VxType, pVx, VxCount, dwFlags));
}
STDMETHODIMP Direct3DDevice3_DrawIndexedPrimitive(D3DPtr* pDvc, D3DPRIMITIVETYPE PrimType, D3DVERTEXTYPE VxType, LPVOID pVx, DWORD VxCount,
	LPWORD Idx, DWORD IdxCount, DWORD dwFlags) {
	GET_D3DEVICE3 LAYER_HR_CALL(_this->DrawIndexedPrimitive(PrimType, VxType, pVx, VxCount, Idx, IdxCount, dwFlags));
}
STDMETHODIMP Direct3DDevice3_DrawIndexedPrimitiveVB(D3DPtr* pDvc, D3DPRIMITIVETYPE PrmtvType, LPDIRECT3DVERTEXBUFFER VxBff, LPWORD idx, DWORD idxcount, DWORD dwFlags) {
	GET_D3DEVICE3
	auto _that    = VxBff == nullptr ? nullptr : GetDirect3DVertexBuffer((COMPtr*)VxBff)->GetImp();
	auto _that_ez = EZInterface(IID_IDirect3DVertexBuffer, _that);
	LAYER_HR_CALL(_this->DrawIndexedPrimitiveVB(PrmtvType, (IDirect3DVertexBuffer*)_that_ez.I(), idx, idxcount, dwFlags));
}
STDMETHODIMP Direct3DDevice3_DrawPrimitiveVB(D3DPtr* pDvc, D3DPRIMITIVETYPE PrmtvType, LPDIRECT3DVERTEXBUFFER VxBff, DWORD dwStartVertex, DWORD dwNumVertices, DWORD f) {
	GET_D3DEVICE3
	auto _that    = VxBff == nullptr ? nullptr : GetDirect3DVertexBuffer((COMPtr*)VxBff)->GetImp();
	auto _that_ez = EZInterface(IID_IDirect3DVertexBuffer, _that);
	LAYER_HR_CALL(_this->DrawPrimitiveVB(PrmtvType, (IDirect3DVertexBuffer*)_that_ez.I(), dwStartVertex, dwNumVertices, f));
};
STDMETHODIMP Direct3DDevice3_ComputeSphereVisibility(D3DPtr* pDvc, LPD3DVECTOR pCenters, LPD3DVALUE pRadii, DWORD NumSpheres, DWORD Flags, LPDWORD pReturnValues) {
	GET_D3DEVICE3
	LAYER_HR_CALL(_this->ComputeSphereVisibility(pCenters, pRadii, NumSpheres, Flags, pReturnValues));
}
STDMETHODIMP Direct3DDevice3_GetTexture(D3DPtr* pDvc, DWORD dwStage, LPDIRECT3DTEXTURE2* lplpTexture) {
	GET_D3DEVICE3
	HRESULT hr = _this->GetTexture(dwStage, lplpTexture);
	if (FAILED(hr)) {
		DBUG_WARN(LAYER_PARSE_ERROR(hr)); return hr;
	}
	DirectDrawSurface* srfc = FindSurfaceWrapper(*lplpTexture, nullptr, __FUNCTION__);
	if (srfc == nullptr) return DDERR_GENERIC; //FindSurfaceWrapper will log error
	*lplpTexture = (LPDIRECT3DTEXTURE2)srfc->GetDirect3DTexture2();
	DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}
STDMETHODIMP Direct3DDevice3_SetTexture(D3DPtr* pDvc, DWORD dwStage, LPDIRECT3DTEXTURE2 lpTexture) {
	GET_D3DEVICE3
	auto that_ez = EZInterface(IID_IDirect3DTexture2, lpTexture == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpTexture)->GetImp(DD_FOR::BIND_AS_TEXTURE));
	if (g_d3d.TEXTURE_SWAP_ENABLED && D3DHooksData->search_enabled) {
		if ((LPVOID)GetDirectDrawSurface((COMPtr*)lpTexture) == (LPVOID)D3DHooksData->current_texture) {
			return _this->SetTexture(dwStage, nullptr);
		}
	}
	LAYER_HR_CALL(_this->SetTexture(dwStage, (LPDIRECT3DTEXTURE2)that_ez.I()))
}
STDMETHODIMP Direct3DDevice3_GetTextureStageState(D3DPtr* pDvc, DWORD dwStage, D3DTEXTURESTAGESTATETYPE dwState, LPDWORD lpdwValue) {
	GET_D3DEVICE3			
	LAYER_HR_CALL(_this->GetTextureStageState(dwStage, dwState, lpdwValue));
}
STDMETHODIMP Direct3DDevice3_SetTextureStageState(D3DPtr* pDvc, DWORD dwStage, D3DTEXTURESTAGESTATETYPE dwState, DWORD dwValue) {
	GET_D3DEVICE3
	if ((dwState == D3DTSS_MINFILTER || dwState == D3DTSS_MAGFILTER || dwState == D3DTSS_MAXANISOTROPY) && g_d3d.TEXTURE_FILTER == *(DWORD*)"TRUE") 
	return 0;
	LAYER_HR_CALL(_this->SetTextureStageState(dwStage, dwState, dwValue));
}
STDMETHODIMP Direct3DDevice3_ValidateDevice(D3DPtr* pDvc, LPDWORD lpdwPasses) {
	GET_D3DEVICE3
	LAYER_HR_CALL(_this->ValidateDevice(lpdwPasses));
}
STDMETHODIMP Direct3DDevice3_DrawPrimitiveStrided(D3DPtr* pDvc, D3DPRIMITIVETYPE PrmtvType, DWORD VxTypeDsc, D3DDRAWPRIMITIVESTRIDEDDATA* VxArray, DWORD VxCount, DWORD f) {
	GET_D3DEVICE3
	LAYER_HR_CALL(_this->DrawPrimitiveStrided(PrmtvType, VxTypeDsc, VxArray, VxCount, f));
}
STDMETHODIMP Direct3DDevice3_DrawIndexedPrimitiveStrided(D3DPtr* pDvc,D3DPRIMITIVETYPE PrmtvType, DWORD VxTypeDsc, LPD3DDRAWPRIMITIVESTRIDEDDATA VxArray,
														 DWORD dwVertexCount, LPWORD lpwIndices, DWORD dwIndexCount, DWORD dwFlags){
	GET_D3DEVICE3
	LAYER_HR_CALL(_this->DrawIndexedPrimitiveStrided(PrmtvType, VxTypeDsc, VxArray, dwVertexCount, lpwIndices, dwIndexCount, dwFlags));
}
STDMETHODIMP Direct3DDevice3_EnumTextureFormats(D3DPtr* pDvc, LPD3DENUMPIXELFORMATSCALLBACK lpd3dEnumTextureProc, LPVOID lpArg) {
	GET_D3DEVICE3 LAYER_HR_CALL(_this->EnumTextureFormats(lpd3dEnumTextureProc, lpArg));
}

struct D3DDEVICE2_VTABLE{   
	decltype(Direct3DDevice2_QueryInterface)      * QueryInterface        = Direct3DDevice2_QueryInterface;
    decltype(Direct3DDevice2_AddRef)              * AddRef                = Direct3DDevice2_AddRef;
    decltype(Direct3DDevice2_Release)             * Release               = Direct3DDevice2_Release;
	decltype(Direct3DDevice2_GetCaps)             * GetCaps               = Direct3DDevice2_GetCaps;
	decltype(Direct3DDevice2_SwapTextureHandles)  * SwapTextureHandles    = Direct3DDevice2_SwapTextureHandles;
	decltype(Direct3DDevice_GetStats)             * GetStats              = Direct3DDevice_GetStats;
	decltype(Direct3DDevice2_AddViewport)         * AddViewport           = Direct3DDevice2_AddViewport;
	decltype(Direct3DDevice2_DeleteViewport)      * DeleteViewport        = Direct3DDevice2_DeleteViewport;
	decltype(Direct3DDevice2_NextViewport)        * NextViewport          = Direct3DDevice2_NextViewport;
	decltype(Direct3DDevice_EnumTextureFormats)   * EnumTextureFormats    = Direct3DDevice_EnumTextureFormats;
	decltype(Direct3DDevice2_BeginScene)          * BeginScene            = Direct3DDevice2_BeginScene;
	decltype(Direct3DDevice2_EndScene)            * EndScene              = Direct3DDevice2_EndScene;
	decltype(Direct3DDevice2_GetDirect3D)         * GetDirect3D           = Direct3DDevice2_GetDirect3D;
	decltype(Direct3DDevice2_SetCurrentViewport)  * SetCurrentViewport    = Direct3DDevice2_SetCurrentViewport;
	decltype(Direct3DDevice2_GetCurrentViewport)  * GetCurrentViewport    = Direct3DDevice2_GetCurrentViewport;
	decltype(Direct3DDevice2_SetRenderTarget)     * SetRenderTarget       = Direct3DDevice2_SetRenderTarget;
	decltype(Direct3DDevice2_GetRenderTarget)     * GetRenderTarget       = Direct3DDevice2_GetRenderTarget;
	decltype(Direct3DDevice2_Begin)               * Begin                 = Direct3DDevice2_Begin;
	decltype(Direct3DDevice2_BeginIndexed)        * BeginIndexed          = Direct3DDevice2_BeginIndexed;
	decltype(Direct3DDevice2_Vertex)              * Vertex                = Direct3DDevice2_Vertex;
	decltype(Direct3DDevice2_Index)               * Index                 = Direct3DDevice2_Index;
	decltype(Direct3DDevice2_End)                 * End                   = Direct3DDevice2_End;
	decltype(Direct3DDevice2_GetRenderState)      * GetRenderState        = Direct3DDevice2_GetRenderState;
	decltype(Direct3DDevice2_SetRenderState)      * SetRenderState        = Direct3DDevice2_SetRenderState;
	decltype(Direct3DDevice2_GetLightState)       * GetLightState         = Direct3DDevice2_GetLightState;
	decltype(Direct3DDevice2_SetLightState)       * SetLightState         = Direct3DDevice2_SetLightState;
	decltype(Direct3DDevice2_SetTransform)        * SetTransform          = Direct3DDevice2_SetTransform;
	decltype(Direct3DDevice2_GetTransform)        * GetTransform          = Direct3DDevice2_GetTransform;
	decltype(Direct3DDevice2_MultiplyTransform)   * MultiplyTransform     = Direct3DDevice2_MultiplyTransform;
	decltype(Direct3DDevice2_DrawPrimitive)       * DrawPrimitive         = Direct3DDevice2_DrawPrimitive;
	decltype(Direct3DDevice2_DrawIndexedPrimitive)* DrawIndexedPrimitive  = Direct3DDevice2_DrawIndexedPrimitive;
	decltype(Direct3DDevice2_SetClipStatus)               * SetClipStatus			    = Direct3DDevice2_SetClipStatus;
	decltype(Direct3DDevice2_GetClipStatus)               * GetClipStatus               = Direct3DDevice2_GetClipStatus;
}  D3DDevice2Vtable;

struct D3DDEVICE3_VTABLE{   
	decltype(Direct3DDevice2_QueryInterface)			  * QueryInterface              = Direct3DDevice2_QueryInterface;
    decltype(Direct3DDevice2_AddRef)					  * AddRef                      = Direct3DDevice2_AddRef;
    decltype(Direct3DDevice2_Release)					  * Release                     = Direct3DDevice2_Release;
	decltype(Direct3DDevice2_GetCaps)					  * GetCaps                     = Direct3DDevice2_GetCaps;	
	decltype(Direct3DDevice_GetStats)					  * GetStats                    = Direct3DDevice_GetStats;
	decltype(Direct3DDevice2_AddViewport)			 	  * AddViewport                 = Direct3DDevice2_AddViewport;
	decltype(Direct3DDevice2_DeleteViewport)			  * DeleteViewport              = Direct3DDevice2_DeleteViewport;
	decltype(Direct3DDevice2_NextViewport)				  * NextViewport                = Direct3DDevice2_NextViewport;
	decltype(Direct3DDevice3_EnumTextureFormats)	      * EnumTextureFormats          = Direct3DDevice3_EnumTextureFormats;	
	decltype(Direct3DDevice3_BeginScene)				  * BeginScene                  = Direct3DDevice3_BeginScene;
	decltype(Direct3DDevice3_EndScene)					  * EndScene	                = Direct3DDevice3_EndScene;
	decltype(Direct3DDevice3_GetDirect3D)				  * GetDirect3D				    = Direct3DDevice3_GetDirect3D;
	decltype(Direct3DDevice2_SetCurrentViewport)		  * SetCurrentViewport			= Direct3DDevice2_SetCurrentViewport;
	decltype(Direct3DDevice2_GetCurrentViewport)		  * GetCurrentViewport			= Direct3DDevice2_GetCurrentViewport;
	decltype(Direct3DDevice2_SetRenderTarget)			  * SetRenderTarget				= Direct3DDevice2_SetRenderTarget;
	decltype(Direct3DDevice3_GetRenderTarget)			  * GetRenderTarget			    = Direct3DDevice3_GetRenderTarget;
	decltype(Direct3DDevice2_Begin)						  * Begin						= Direct3DDevice2_Begin;
	decltype(Direct3DDevice2_BeginIndexed)				  * BeginIndexed				= Direct3DDevice2_BeginIndexed;
	decltype(Direct3DDevice2_Vertex)					  * Vertex						= Direct3DDevice2_Vertex;
	decltype(Direct3DDevice2_Index)						  * Index					    = Direct3DDevice2_Index;
	decltype(Direct3DDevice2_End)						  * End							= Direct3DDevice2_End;
	decltype(Direct3DDevice2_GetRenderState)			  * GetRenderState				= Direct3DDevice2_GetRenderState;
	decltype(Direct3DDevice2_SetRenderState)			  * SetRenderState				= Direct3DDevice2_SetRenderState;
	decltype(Direct3DDevice2_GetLightState)				  * GetLightState				= Direct3DDevice2_GetLightState;
	decltype(Direct3DDevice2_SetLightState)				  * SetLightState				= Direct3DDevice2_SetLightState;
	decltype(Direct3DDevice2_SetTransform)				  * SetTransform				= Direct3DDevice2_SetTransform;
	decltype(Direct3DDevice2_GetTransform)				  * GetTransform				= Direct3DDevice2_GetTransform;
	decltype(Direct3DDevice2_MultiplyTransform)			  * MultiplyTransform			= Direct3DDevice2_MultiplyTransform;
	decltype(Direct3DDevice3_DrawPrimitive)				  * DrawPrimitive				= Direct3DDevice3_DrawPrimitive;
	decltype(Direct3DDevice3_DrawIndexedPrimitive)        * DrawIndexedPrimitive		= Direct3DDevice3_DrawIndexedPrimitive;
	decltype(Direct3DDevice2_SetClipStatus)               * SetClipStatus			    = Direct3DDevice2_SetClipStatus;
	decltype(Direct3DDevice2_GetClipStatus)               * GetClipStatus               = Direct3DDevice2_GetClipStatus;	
	decltype(Direct3DDevice3_DrawPrimitiveStrided)        * DrawPrimitiveStrided        = Direct3DDevice3_DrawPrimitiveStrided;
	decltype(Direct3DDevice3_DrawIndexedPrimitiveStrided) * DrawIndexedPrimitiveStrided = Direct3DDevice3_DrawIndexedPrimitiveStrided;
	decltype(Direct3DDevice3_DrawPrimitiveVB)             * DrawPrimitiveVB             = Direct3DDevice3_DrawPrimitiveVB;
	decltype(Direct3DDevice3_DrawIndexedPrimitiveVB)      * DrawIndexedPrimitiveVB      = Direct3DDevice3_DrawIndexedPrimitiveVB;
	decltype(Direct3DDevice3_ComputeSphereVisibility)     * ComputeSphereVisibility     = Direct3DDevice3_ComputeSphereVisibility;
	decltype(Direct3DDevice3_GetTexture)                  * GetTexture                  = Direct3DDevice3_GetTexture;
	decltype(Direct3DDevice3_SetTexture)                  * SetTexture                  = Direct3DDevice3_SetTexture;
	decltype(Direct3DDevice3_GetTextureStageState)        * GetTextureStageState        = Direct3DDevice3_GetTextureStageState;
	decltype(Direct3DDevice3_SetTextureStageState)        * SetTextureStageState        = Direct3DDevice3_SetTextureStageState;
	decltype(Direct3DDevice3_ValidateDevice)              * ValidateDevice              = Direct3DDevice3_ValidateDevice;
} D3DDevice3Vtable;

struct D3DDEVICE1_VTABLE {
	decltype(Direct3DDevice2_QueryInterface)     * QueryInterface      = Direct3DDevice2_QueryInterface;
    decltype(Direct3DDevice2_AddRef)             * AddRef              = Direct3DDevice2_AddRef;
    decltype(Direct3DDevice2_Release)            * Release             = Direct3DDevice2_Release;
	decltype(Direct3DDevice_Initialize)          * Initialize          = Direct3DDevice_Initialize;
	decltype(Direct3DDevice_GetCaps)             * GetCaps             = Direct3DDevice_GetCaps;
	decltype(Direct3DDevice_SwapTextureHandles)  * SwapTextureHandles  = Direct3DDevice_SwapTextureHandles;
	decltype(Direct3DDevice_CreateExecuteBuffer) * CreateExecuteBuffer = Direct3DDevice_CreateExecuteBuffer;
	decltype(Direct3DDevice_GetStats)            * GetStats            = Direct3DDevice_GetStats;
	decltype(Direct3DDevice_Execute)             * Execute             = Direct3DDevice_Execute;
	decltype(Direct3DDevice2_AddViewport)        * AddViewport         = Direct3DDevice2_AddViewport;
	decltype(Direct3DDevice2_DeleteViewport)     * DeleteViewport      = Direct3DDevice2_DeleteViewport;
	decltype(Direct3DDevice2_NextViewport)       * NextViewport        = Direct3DDevice2_NextViewport;
	decltype(Direct3DDevice_Pick)                * Pick                = Direct3DDevice_Pick;
	decltype(Direct3DDevice_GetPickRecords)      * GetPickRecords      = Direct3DDevice_GetPickRecords;
	decltype(Direct3DDevice_EnumTextureFormats)  * EnumTextureFormats  = Direct3DDevice_EnumTextureFormats;
	decltype(Direct3DDevice_CreateMatrix)        * CreateMatrix        = Direct3DDevice_CreateMatrix;
	decltype(Direct3DDevice_SetMatrix)           * SetMatrix           = Direct3DDevice_SetMatrix;
	decltype(Direct3DDevice_GetMatrix)           * GetMatrix           = Direct3DDevice_GetMatrix;
	decltype(Direct3DDevice_DeleteMatrix)        * DeleteMatrix        = Direct3DDevice_DeleteMatrix;
	decltype(Direct3DDevice_BeginScene)          * BeginScene          = Direct3DDevice_BeginScene;
	decltype(Direct3DDevice_EndScene)            * EndScene            = Direct3DDevice_EndScene;
	decltype(Direct3DDevice_GetDirect3D)         * GetDirect3D         = Direct3DDevice_GetDirect3D;
}  D3DDevice1Vtable;

Direct3DDevice::Direct3DDevice(IUnknown* imp, IDirectDrawSurface* RT) : PrivateDataObjectParent(imp) {
	m_Imp  = imp;
	m_dvc  = {(LPVOID)&D3DDevice1Vtable, (LPVOID)this, imp, FALSE};
	m_dvc2 = {(LPVOID)&D3DDevice2Vtable, (LPVOID)this, imp, FALSE};
	m_dvc3 = {(LPVOID)&D3DDevice3Vtable, (LPVOID)this, imp, FALSE};
	SetSurfacePrivateData(RT, dynamic_cast<PrivateDataObjectParent*>(this), DIRECTDRAW_ID::D3DDEVICE, __FUNCTION__);
	m_lock = new SYNC::AtomicLock();
}

IDirect3DDevice7* GetDevice7(Direct3DDevice7* dvc) {
	return dvc == nullptr ? nullptr : dvc->GetDevice();
}

HRESULT STDMETHODCALLTYPE Direct3DDevice7::QueryInterface(REFIID riid, void** ppvObj) {
	LAYER_LOG_CALL
	if (ppvObj == nullptr) return E_POINTER;
	if (riid == IID_IUnknown || riid == IID_IDirect3DDevice7) {
		*ppvObj = this; DBUG_WARN("Direct3DDevice7")  
		this->AddRef();
		return 0;
	}
	HRESULT hr = m_Imp->QueryInterface(riid, ppvObj);
	DBUG_LOG((string("Unhandled GUID:") + GUID2String(riid).str().get()->str() + " Implementation hr=" + to_string(hr)).c_str());
	return hr;
}
ULONG __stdcall Direct3DDevice7::AddRef() {
	LAYER_LOG_CALL
	ULONG ref = PublicAddRef(); DBUG_LOG(to_string(ref).c_str()); return ref;
}
ULONG __stdcall Direct3DDevice7::Release() {
	LAYER_LOG_CALL
	ULONG ref = PublicRelease(); DBUG_LOG(to_string(ref).c_str());
	if (ref == 0) delete this;  return ref;
}
HRESULT __stdcall Direct3DDevice7::SetRenderTarget(LPDIRECTDRAWSURFACE7 lpNewRenderTarget, DWORD dwFlags) {
	LAYER_LOG_CALL
	if (lpNewRenderTarget == nullptr) {
		DBUG_WARN("nullptr"); return DDERR_INVALIDPARAMS;
	}
	IDirectDrawSurface7* old = nullptr;
	if (FAILED(m_Imp->GetRenderTarget(&old))) {
		DBUG_WARN("GetRenderTarget FAILED"); return DDERR_INVALIDPARAMS;
	}
	DirectDrawSurface* newRT = GetDirectDrawSurface((COMPtr*)lpNewRenderTarget);
	DirectDrawSurface* oldRT = FindSurfaceWrapper(old, nullptr, __FUNCTION__);
	if (oldRT == nullptr) {
		old->Release();	DBUG_WARN("FindSurfaceWrapper FAILED"); return DDERR_GENERIC;
	}
	HRESULT hr = m_Imp->SetRenderTarget((IDirectDrawSurface7*)EZInterface(IID_IDirectDrawSurface7, newRT->GetImp()).I(), dwFlags);
	if (FAILED(hr))	{
		old->Release();	DBUG_WARN("SetRenderTarget FAILED"); return hr;
	}	
	SetSurfacePrivateData((IDirectDrawSurface7*)EZInterface(IID_IDirectDrawSurface7, newRT->GetImp()).I(), 
		dynamic_cast<PrivateDataObjectParent*>(this), DIRECTDRAW_ID::D3DDEVICE, __FUNCTION__); /* Slows blits down */	
	FreetSurfacePrivateData(old, DIRECTDRAW_ID::D3DDEVICE, __FUNCTION__);
	old->Release();
	DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}
HRESULT __stdcall Direct3DDevice7::GetRenderTarget(LPDIRECTDRAWSURFACE7* lplpRenderTarget) {
	LAYER_LOG_CALL
	HRESULT hr = m_Imp->GetRenderTarget(lplpRenderTarget);
	if (FAILED(hr)) {
		DBUG_WARN(LAYER_PARSE_ERROR(hr)); return hr;
	}
	DirectDrawSurface* sfrc = FindSurfaceWrapper(*lplpRenderTarget, nullptr, __FUNCTION__);
	if (sfrc == nullptr) {
		DBUG_WARN("NOT FOUND")* lplpRenderTarget = nullptr; return DDERR_GENERIC;
	}
	*lplpRenderTarget = (IDirectDrawSurface7*)sfrc->GetDirectDrawSurface7();
	DBUG_LOG(LAYER_PARSE_ERROR(hr)); return hr;
}
HRESULT __stdcall Direct3DDevice7::PreLoad(LPDIRECTDRAWSURFACE7 lpddsTexture) {
	LAYER_LOG_CALL
	auto _that_ez = EZInterface(IID_IDirectDrawSurface7, lpddsTexture == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpddsTexture)->GetImp());
	LAYER_HR_CALL(m_Imp->PreLoad((LPDIRECTDRAWSURFACE7)_that_ez.I()))
}
HRESULT __stdcall Direct3DDevice7::DrawIndexedPrimitive(D3DPRIMITIVETYPE d3dptPrimitiveType, DWORD dwVertexTypeDesc, LPVOID lpvVertices, DWORD dwVertexCount,
	                                                            LPWORD lpwIndices, DWORD dwIndexCount, DWORD dwFlags){
	LAYER_LOG_CALL
	LAYER_HR_CALL(m_Imp->DrawIndexedPrimitive(d3dptPrimitiveType, dwVertexTypeDesc, lpvVertices, dwVertexCount, lpwIndices, dwIndexCount, dwFlags))
}
HRESULT __stdcall Direct3DDevice7::DrawIndexedPrimitiveStrided(D3DPRIMITIVETYPE d3dptPrimitiveType,	DWORD dwVertexTypeDesc,
                                                                   	   LPD3DDRAWPRIMITIVESTRIDEDDATA lpVertexArray,	DWORD dwVertexCount, LPWORD lpwIndices,
                                                                  	   DWORD dwIndexCount, DWORD dwFlags){
	LAYER_LOG_CALL
	LAYER_HR_CALL(m_Imp->DrawIndexedPrimitiveStrided(d3dptPrimitiveType, dwVertexTypeDesc, lpVertexArray, dwVertexCount, lpwIndices, dwIndexCount, dwFlags))
}
HRESULT __stdcall Direct3DDevice7::DrawPrimitiveVB(D3DPRIMITIVETYPE PrmtvType, LPDIRECT3DVERTEXBUFFER7 VrtxBffr, DWORD StrtVrtx, DWORD NmVrtcs, DWORD Flags) {
	LAYER_LOG_CALL
	LAYER_HR_CALL(m_Imp->DrawPrimitiveVB(PrmtvType, GetVertexBuffer7((Direct3DVertexBuffer7*)VrtxBffr), StrtVrtx, NmVrtcs, Flags))
}
HRESULT __stdcall Direct3DDevice7::DrawIndexedPrimitiveVB(D3DPRIMITIVETYPE PrmtvType, LPDIRECT3DVERTEXBUFFER7 VrtxBffr, DWORD StrtVrtx,
	                                                              DWORD  NmVrtcs, LPWORD idx, DWORD  NmIdx,	DWORD  Flags){
	LAYER_LOG_CALL
	LAYER_HR_CALL(m_Imp->DrawIndexedPrimitiveVB(PrmtvType, GetVertexBuffer7((Direct3DVertexBuffer7*)VrtxBffr), StrtVrtx, NmVrtcs, idx, NmIdx, Flags))
}
HRESULT __stdcall Direct3DDevice7::GetTexture(DWORD dwStage, LPDIRECTDRAWSURFACE7* lplpTexture) {
	LAYER_LOG_CALL
	HRESULT hr = m_Imp->GetTexture(dwStage, lplpTexture);
	if (S_OK    == hr)           return hr;
	if (nullptr == *lplpTexture) return hr;
	auto tex = FindSurfaceWrapper(*lplpTexture, nullptr, __FUNCTION__);
	if (tex == nullptr)	{
		DBUG_WARN("FindSurfaceWrapper Returned nullptr"); return DDERR_GENERIC;
	}	
	*lplpTexture = (LPDIRECTDRAWSURFACE7) tex->GetDirectDrawSurface7();
	DBUG_LOG(LAYER_PARSE_ERROR(hr))
	return hr;
}
HRESULT __stdcall Direct3DDevice7::SetTexture(DWORD dwStage, LPDIRECTDRAWSURFACE7 lpTexture) {
	LAYER_LOG_CALL
	auto that_imp = lpTexture == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpTexture)->GetImp(DD_FOR::BIND_AS_TEXTURE);
	DBUG_LOG((STR("_that=[") + to_string((ULONG)that_imp) + "]").c_str())
	auto that_ez  = EZInterface(IID_IDirectDrawSurface7, that_imp);
	if ((LPVOID)GetDirectDrawSurface((COMPtr*)lpTexture) == (LPVOID)D3DHooksData->current_texture) {
		return m_Imp->SetTexture(dwStage, nullptr);
	}
	LAYER_HR_CALL(m_Imp->SetTexture(dwStage, (IDirectDrawSurface7*)that_ez.I()))
}

HRESULT __stdcall Direct3DDevice7::SetTextureStageState(DWORD dwStage, D3DTEXTURESTAGESTATETYPE dwState, DWORD value){
	LAYER_LOG_CALL
	if ((dwState == D3DTSS_MINFILTER || dwState == D3DTSS_MAGFILTER || dwState == D3DTSS_MAXANISOTROPY) && g_d3d.TEXTURE_FILTER == *(DWORD*)"TRUE") 
	return 0;
	LAYER_HR_CALL(m_Imp->SetTextureStageState(dwStage, dwState, value))
}

HRESULT __stdcall Direct3DDevice7::Load(LPDIRECTDRAWSURFACE7 lpDestTex, LPPOINT lpDestPoint, LPDIRECTDRAWSURFACE7 lpSrcTex, LPRECT lprcSrcRect, DWORD dwFlags) {
	LAYER_LOG_CALL
	auto dest_imp = lpDestTex == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpDestTex)->GetImp();
	auto dest_ez  = EZInterface(IID_IDirectDrawSurface7, dest_imp);
	auto src_imp  = lpSrcTex  == nullptr ? nullptr : GetDirectDrawSurface((COMPtr*)lpSrcTex)->GetImp();
	auto src_ez   = EZInterface(IID_IDirectDrawSurface7, src_imp);
	LAYER_HR_CALL(m_Imp->Load((IDirectDrawSurface7*)dest_ez.I(), lpDestPoint, (IDirectDrawSurface7*)src_ez.I(), lprcSrcRect, dwFlags))
}

HRESULT __stdcall Direct3DDevice7::GetDirect3D(LPDIRECT3D7* lplpD3D) {
	LAYER_LOG_CALL
	if (lplpD3D == nullptr)	{
		DBUG_WARN("nullptr");
		return DDERR_GENERIC;
	}
	IDirectDrawSurface7* isrfc = nullptr;
	if (FAILED(m_Imp->GetRenderTarget(&isrfc))) {
		DBUG_WARN("NO RENDERTARGET"); return DDERR_GENERIC;
	}
	auto* DD = FindSurfaceObject(isrfc, DIRECTDRAW_ID::DDRAW, __FUNCTION__);
	isrfc->Release();
	if (DD == nullptr) {
		DBUG_WARN("NO DIRECT DRAW"); return DDERR_GENERIC;
	}	
	auto dd = dynamic_cast<DirectDraw*>(DD);
	DBUG_LOG((STR("Found PrivateDataObjectParent=[") + to_string((ULONG)DD) + "]").c_str())
	DBUG_LOG((STR("Found DirectDraw Object=[") + to_string((ULONG)dd) + "]").c_str())
	*lplpD3D = (IDirect3D7*)dd->GetDirect3D7();
	((IDirect3D7*)*lplpD3D)->AddRef();	
	DBUG_LOG("D3D_OK"); return 0;
}

HRESULT __stdcall Direct3DDevice7::Clear(DWORD dwCount, LPD3DRECT lpRects, DWORD dwFlags, DWORD dwColor, D3DVALUE dvZ, DWORD dwStencil) {
	LAYER_LOG_CALL
	LAYER_HR_CALL(m_Imp->Clear(dwCount, lpRects, dwFlags, dwColor, dvZ, dwStencil))
}

Direct3DDevice7::Direct3DDevice7(IDirect3DDevice7* imp, IDirectDrawSurface* RT) : PrivateDataObjectParent(imp) {
	m_Imp = imp;	
	SetSurfacePrivateData(RT, dynamic_cast<PrivateDataObjectParent*>(this), DIRECTDRAW_ID::D3DDEVICE, __FUNCTION__);	
}