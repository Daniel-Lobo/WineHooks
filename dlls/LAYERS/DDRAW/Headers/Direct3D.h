#ifndef DIRECT3D_H
#define DIRECT3D_H
#include "LayersCommon.h"
#define  DIRECTDRAW_VERSION 0x0700
#define  DIRECT3D_VERSION 0x0700
#define  DIRECTDRAW_VERSION 0x0700

#include <ddraw.h>
#include <d3d.h>
#include <dllmain.h>
#include "Sync.h"
#include <map>
#include "DirectDraw.h"

enum class D3DDEVICETYPE {NONE, RGB, RAMP, HAL, MMX};

typedef struct D3DPtr {
	LPVOID   Vtable;
	LPVOID COMObjct;
	IUnknown  * imp;
	BOOL      d3d_1;
};

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DLight
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DLight
#undef  LAYER_OK 
#define LAYER_OK "DD_OK" 

class Direct3DLight : public IDirect3DLight {
public:
	virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppvObj) {
		LAYER_LOG_CALL
	    if (this   == nullptr) return DDERR_INVALIDOBJECT;
		if (ppvObj == nullptr) return E_POINTER;

		if (riid == IID_IUnknown || riid == IID_IDirect3DLight)  {
			*ppvObj = this;	AddRef(); return 0;
		}	
		
		DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str()).c_str());
		return E_NOINTERFACE;
	}
	virtual ULONG STDMETHODCALLTYPE AddRef() {
		return m_Imp->AddRef();
	}
	virtual ULONG STDMETHODCALLTYPE Release() { 
		UINT ref = m_Imp->Release(); if (ref == 0) delete this;
		return ref; 
	}
	STDMETHOD(Initialize)(THIS_ LPDIRECT3D) { LAYER_LOG_CALL return DDERR_ALREADYINITIALIZED; }
	//COM_FOWARD(SetLight, LPD3DLIGHT);
	STDMETHOD(SetLight)(THIS_ LPD3DLIGHT l) { 
		LAYER_LOG_CALL; 
		D3DPtr * ptr = (D3DPtr *)this; 
		GET_COM_PTR(Direct3DLight, DDERR_GENERIC);
		LAYER_HR_CALL(m_Imp->SetLight(l))  ;
	}
	COM_FOWARD(GetLight, LPD3DLIGHT);
	virtual IDirect3DLight* GetImp() {
		return m_Imp;
	}
	virtual ~Direct3DLight() {};
	Direct3DLight(IDirect3DLight * imp) {
		m_Imp      = imp;		
	}
private:	
	IDirect3DLight * m_Imp      = nullptr;
};

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DExecuteBuffer
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DExecuteBuffer
#undef  LAYER_OK 
#define LAYER_OK "DD_OK" 

class Direct3DExecuteBuffer : /*virtual*/ public IDirect3DExecuteBuffer {
public:
	virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppvObj) {
		LAYER_LOG_CALL
		if (this   == nullptr) return DDERR_INVALIDOBJECT;
		if (ppvObj == nullptr) return E_POINTER;

		if (riid == IID_IUnknown || riid == IID_IDirect3DExecuteBuffer) {
			* ppvObj = this;	AddRef(); DBUG_WARN("IID_IDirect3DExecuteBuffer") return 0;
		}

		DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str()).c_str());
		return E_NOINTERFACE;
	}
	virtual ULONG STDMETHODCALLTYPE AddRef() {
		m_refcount->Increment(); return m_Imp->AddRef();
	}
	virtual ULONG STDMETHODCALLTYPE Release() {
		LAYER_MEMBER_LOG_CALL
		UINT ref = m_Imp->Release(); 		
		if (m_refcount->Decrement() == 0) delete this;
		DBUG_WARN(to_string((long)ref).c_str())
		return ref;
	}
	STDMETHOD(Initialize)(THIS_ LPDIRECT3DDEVICE, LPD3DEXECUTEBUFFERDESC) { return DDERR_ALREADYINITIALIZED; };
	COM_FOWARD(Lock, LPD3DEXECUTEBUFFERDESC);
	COM_FOWARD(Unlock);
	COM_FOWARD(SetExecuteData, LPD3DEXECUTEDATA);
	COM_FOWARD(GetExecuteData, LPD3DEXECUTEDATA);
	COM_FOWARD(Validate, LPDWORD, LPD3DVALIDATECALLBACK, LPVOID, DWORD);
	COM_FOWARD(Optimize, DWORD);
	virtual IDirect3DExecuteBuffer* GetImp() {
		return m_Imp;
	}
	virtual ~Direct3DExecuteBuffer() { delete m_refcount; };
	Direct3DExecuteBuffer(IDirect3DExecuteBuffer * imp) {
		m_Imp      = imp;
		m_refcount = new SYNC::Atomic();
		m_refcount->Set(1);
	}
private:
	SYNC::Atomic           * m_refcount = nullptr;
	IDirect3DExecuteBuffer * m_Imp      = nullptr;	
};

class Direct3DMaterial {
public:
	virtual ~Direct3DMaterial() {};	
	Direct3DMaterial(IUnknown*);
	IUnknown* GetImp()             { return m_Imp;   }
	COMPtr* GetDirect3DMaterial1() { return &m_mat;  }
	COMPtr* GetDirect3DMaterial2() { return &m_mat2; }
	COMPtr* GetDirect3DMaterial3() { return &m_mat3; }

	SYNC::Atomic* m_refcount = nullptr;
	IUnknown* m_Imp = nullptr;
	COMPtr    m_mat = {}, m_mat2 = {}, m_mat3 = {};
};

class Direct3DViewPort {
public:
	virtual ~Direct3DViewPort() {};
	Direct3DViewPort(IUnknown*);
	IUnknown* GetImp()             { return m_Imp;    }
	COMPtr* GetDirect3DViewport1() { return &m_view;  }
	COMPtr* GetDirect3DViewport2() { return &m_view2; }
	COMPtr* GetDirect3DViewport3() { return &m_view3; }

	BOOL HasLight(IDirect3DLight* light) {
		auto ezLock = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
		return m_lights.find(light) == m_lights.end() ? FALSE : TRUE;
	}	
	void __PrivateDeleteLight(IDirect3DLight* ilight) {
		if (HasLight(ilight) == FALSE) {
			DBUG_WARN("Light is not on viewport lights list")
			return;
		}
		auto ezLock = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
		m_lights.erase(ilight);
	}
	void __PrivateAddLight(IDirect3DLight* ilight, Direct3DLight* light) {
		if (HasLight(ilight) == TRUE)  {
			DBUG_WARN("LIght is already on the viewport lights list")
			return;
		}
		auto ezLock      = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
		m_lights[ilight] = light;
	}
	Direct3DLight* GetLight(IDirect3DLight* ilight) {
		auto ezLock = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
		auto light  = m_lights[ilight];
		return light;
	};
	std::map<IDirect3DLight*, Direct3DLight*> m_lights;	
	IUnknown*          m_Imp = nullptr;
	SYNC::AtomicLock* m_lock = nullptr;
	COMPtr  m_view = {}, m_view2 = {}, m_view3 = {};
};

class Direct3DDevice : public PrivateDataObjectParent {
public:
	virtual ~Direct3DDevice() {};
	Direct3DDevice(IUnknown*, IDirectDrawSurface*);
	D3DPtr* GetDirect3DDevicec1() { return &m_dvc;  }
	D3DPtr* GetDirect3DDevicec2() { return &m_dvc2; }
	D3DPtr* GetDirect3DDevicec3() { return &m_dvc3; }

	BOOL HasViewport(IUnknown* view) {
		auto view_id = EZInterface(IID_IUnknown, view).I();
		auto ezLock = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
		return m_views.find(view_id) == m_views.end() ? FALSE : TRUE;
	}
	void __PrivateDeleteViewPort(IUnknown* view) {
		if (HasViewport(view) == FALSE) {
			DBUG_WARN("LIght is not on viewport lights list")
				return;
		}
		auto view_id = EZInterface(IID_IUnknown, view).I();
		auto ezLock = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
		m_views.erase(view_id);
	}
	void __PrivateAddViewPort(IUnknown* iview, Direct3DViewPort* view) {
		if (HasViewport(iview) == TRUE) {
			DBUG_WARN("LIght is already on the viewport lights list")
				return;
		}
		auto view_id = EZInterface(IID_IUnknown, iview).I();
		auto ezLock = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
		m_views[view_id] = view;
	}
	Direct3DViewPort* GetViewPort(IUnknown* iview) {
		auto ezLock = unique_ptr<SYNC::EasyLock>(new SYNC::EasyLock(m_lock));
		auto view = m_views[iview];
		return view;
	};

	std::map<IUnknown*, Direct3DViewPort*> m_views;
	SYNC::AtomicLock* m_lock = nullptr;
	IUnknown* m_Imp          = nullptr;	
	D3DPtr  m_dvc = {}, m_dvc2 = {}, m_dvc3 = {};
};

class Direct3DVertexBuffer {
public:
	virtual ~Direct3DVertexBuffer() {};
	Direct3DVertexBuffer(IUnknown*);
	IUnknown* GetImp()                 { return m_Imp; }
	COMPtr* GetDirect3DVertexBuffer()  { return &m_vb; }
	COMPtr* GetDirect3DVertexBuffer7() { return &m_vb7;}
	IUnknown* m_Imp = nullptr; 	
	COMPtr m_vb = {}, m_vb7 = {};
};

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DVertexBuffer7
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DVertexBuffer7
#undef  LAYER_OK 
#define LAYER_OK "DD_OK" 

class Direct3DVertexBuffer7: public IDirect3DVertexBuffer7 {
public:
	virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppvObj);
	virtual ULONG __stdcall AddRef();
	virtual ULONG __stdcall Release();	
	COM_FOWARD(Lock, DWORD, LPVOID*, LPDWORD);
	COM_FOWARD(Unlock);
	STDMETHOD(ProcessVertices)(THIS_ DWORD, DWORD, DWORD, LPDIRECT3DVERTEXBUFFER7, DWORD, LPDIRECT3DDEVICE7, DWORD);
	COM_FOWARD(GetVertexBufferDesc, LPD3DVERTEXBUFFERDESC);
	STDMETHOD(Optimize)(THIS_ LPDIRECT3DDEVICE7, DWORD);
	STDMETHOD(ProcessVerticesStrided)(THIS_ DWORD, DWORD, DWORD, LPD3DDRAWPRIMITIVESTRIDEDDATA, DWORD, LPDIRECT3DDEVICE7, DWORD);
	virtual IDirect3DVertexBuffer7* GetVertexBuffer() {return m_Imp;}
	virtual ~Direct3DVertexBuffer7() {};
	Direct3DVertexBuffer7(IDirect3DVertexBuffer7* imp);
private:
	IDirect3DVertexBuffer7 * m_Imp      = nullptr;
	SYNC::Atomic           * m_refcount = nullptr;
};

#undef  LAYER_THIS
#define LAYER_THIS IDirect3DDevice7
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirect3DDevice7
#undef  LAYER_OK 
#define LAYER_OK "DD_OK" 

class Direct3DDevice7 : public PrivateDataObjectParent, public IDirect3DDevice7{
public:
	virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppvObj);
	virtual ULONG __stdcall AddRef();
	virtual ULONG __stdcall Release();
	COM_FOWARD(GetCaps, LPD3DDEVICEDESC7);
	COM_FOWARD(EnumTextureFormats, LPD3DENUMPIXELFORMATSCALLBACK, LPVOID);
	COM_FOWARD(BeginScene);
	COM_FOWARD(EndScene);
	STDMETHOD(GetDirect3D)(THIS_ LPDIRECT3D7*) ;
	STDMETHOD(SetRenderTarget)(THIS_ LPDIRECTDRAWSURFACE7, DWORD) ;
	STDMETHOD(GetRenderTarget)(THIS_ LPDIRECTDRAWSURFACE7*) ;
	STDMETHOD(Clear)(THIS_ DWORD, LPD3DRECT, DWORD, D3DCOLOR, D3DVALUE, DWORD) ;
	COM_FOWARD(SetTransform, D3DTRANSFORMSTATETYPE, LPD3DMATRIX);
	COM_FOWARD(GetTransform, D3DTRANSFORMSTATETYPE, LPD3DMATRIX);
	COM_FOWARD(SetViewport, LPD3DVIEWPORT7);
	COM_FOWARD(MultiplyTransform, D3DTRANSFORMSTATETYPE, LPD3DMATRIX);
	COM_FOWARD(GetViewport, LPD3DVIEWPORT7);
	COM_FOWARD(SetMaterial, LPD3DMATERIAL7) ;
	COM_FOWARD(GetMaterial, LPD3DMATERIAL7) ;
	COM_FOWARD(SetLight, DWORD, LPD3DLIGHT7) ;
	COM_FOWARD(GetLight, DWORD, LPD3DLIGHT7) ;
	COM_FOWARD(SetRenderState, D3DRENDERSTATETYPE, DWORD);
	COM_FOWARD(GetRenderState, D3DRENDERSTATETYPE, LPDWORD);
	COM_FOWARD(BeginStateBlock) ;
	COM_FOWARD(EndStateBlock, LPDWORD);
	STDMETHOD(PreLoad)(THIS_ LPDIRECTDRAWSURFACE7) ;
	COM_FOWARD(DrawPrimitive, D3DPRIMITIVETYPE, DWORD, LPVOID, DWORD, DWORD);
	STDMETHOD(DrawIndexedPrimitive)(THIS_ D3DPRIMITIVETYPE, DWORD, LPVOID, DWORD, LPWORD, DWORD, DWORD) ;
	COM_FOWARD(SetClipStatus, LPD3DCLIPSTATUS);
	COM_FOWARD(GetClipStatus, LPD3DCLIPSTATUS);
	COM_FOWARD(DrawPrimitiveStrided, D3DPRIMITIVETYPE, DWORD, LPD3DDRAWPRIMITIVESTRIDEDDATA, DWORD, DWORD);
	STDMETHOD(DrawIndexedPrimitiveStrided)(THIS_ D3DPRIMITIVETYPE, DWORD, LPD3DDRAWPRIMITIVESTRIDEDDATA, DWORD, LPWORD, DWORD, DWORD) ;
	STDMETHOD(DrawPrimitiveVB)(THIS_ D3DPRIMITIVETYPE, LPDIRECT3DVERTEXBUFFER7, DWORD, DWORD, DWORD) ;
	STDMETHOD(DrawIndexedPrimitiveVB)(THIS_ D3DPRIMITIVETYPE, LPDIRECT3DVERTEXBUFFER7, DWORD, DWORD, LPWORD, DWORD, DWORD) ;
	COM_FOWARD(ComputeSphereVisibility, LPD3DVECTOR, LPD3DVALUE, DWORD, DWORD, LPDWORD);
	STDMETHOD(GetTexture)(THIS_ DWORD, LPDIRECTDRAWSURFACE7*);
	STDMETHOD(SetTexture)(THIS_ DWORD, LPDIRECTDRAWSURFACE7);
	COM_FOWARD(GetTextureStageState, DWORD, D3DTEXTURESTAGESTATETYPE, LPDWORD);
	//COM_FOWARD(SetTextureStageState, DWORD, D3DTEXTURESTAGESTATETYPE, DWORD);
	STDMETHOD(SetTextureStageState)(THIS_ DWORD, D3DTEXTURESTAGESTATETYPE, DWORD);
	COM_FOWARD(ValidateDevice, LPDWORD);
	COM_FOWARD(ApplyStateBlock, DWORD);
	COM_FOWARD(CaptureStateBlock, DWORD);
	COM_FOWARD(DeleteStateBlock, DWORD);
	COM_FOWARD(CreateStateBlock, D3DSTATEBLOCKTYPE, LPDWORD);
	STDMETHOD(Load)(THIS_ LPDIRECTDRAWSURFACE7, LPPOINT, LPDIRECTDRAWSURFACE7, LPRECT, DWORD) ;
	COM_FOWARD(LightEnable, DWORD, BOOL);
	COM_FOWARD(GetLightEnable, DWORD, BOOL*);
	COM_FOWARD(SetClipPlane, DWORD, D3DVALUE*);
	COM_FOWARD(GetClipPlane, DWORD, D3DVALUE*);
	COM_FOWARD(GetInfo, DWORD, LPVOID, DWORD);
	virtual IDirect3DDevice7* GetDevice() {return m_Imp;}
	virtual ~Direct3DDevice7() {};
	Direct3DDevice7(IDirect3DDevice7* imp, IDirectDrawSurface* RT);	
private:
	IDirect3DDevice7 * m_Imp = nullptr;
};

extern Direct3DViewPort* GetDirect3DViewport(COMPtr*);
extern Direct3DVertexBuffer* GetDirect3DVertexBuffer(COMPtr*);
extern void * GetD3DDeviceVtable(void);
extern std::unique_ptr<EZInterface> GetDevice(D3DPtr*);
extern std::unique_ptr<EZInterface> GetDevice2(D3DPtr*);
extern std::unique_ptr<EZInterface> GetDevice3(D3DPtr*);
extern STDMETHODIMP Direct3DDevice_Initialize(D3DPtr*, LPDIRECT3D, LPGUID, LPD3DDEVICEDESC);
extern IDirect3DDevice7* GetDevice7(Direct3DDevice7*);
extern IDirect3DVertexBuffer7* GetVertexBuffer7(Direct3DVertexBuffer7*);
#endif //DIRECT3D_H