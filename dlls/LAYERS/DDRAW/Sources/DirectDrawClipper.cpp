#include <ddraw.h>
#include "DirectDraw.h"
#include <dllmain.h>

#include "D3D12Hooks.h"

#include <string>
#include "EZString.h"
#include <typeinfo>
using std::string;
using std::to_string;

DirectDrawClipper* GetDirectDrawClipper(COMPtr* ptr)
{
	if (ptr == nullptr)         return nullptr;
	return (DirectDrawClipper*) ptr->COMObjct;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirectDrawClipper
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDrawClipper
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

STDMETHODIMP DirectDrawClipper_QueryInterface(COMPtr* ptr, REFIID riid, void** ppvObj)
{
    LAYER_LOG_CALL   GET_COM_PTR(DirectDrawClipper, DDERR_GENERIC) if (ppvObj == nullptr) return E_POINTER;
    
    if (riid   == IID_IUnknown || riid == IID_IDirectDrawClipper)   {
        *ppvObj = _this->GetClipper(); _this->PublicAddRef(); return 0;
    }

    HRESULT hr = _this->GetImp()->QueryInterface(riid, ppvObj);
    DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str() + " Implementation hr=" + to_string(hr)).c_str());
    return hr;
}    

ULONG __stdcall DirectDrawClipper_Release(COMPtr * ptr) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawClipper, DDERR_GENERIC)
	ULONG ref = _this->PublicRelease();	DBUG_LOG(to_string(ref).c_str()); return ref;
}

ULONG __stdcall DirectDrawClipper_AddRef(COMPtr* ptr) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawClipper, DDERR_GENERIC)
	ULONG ref = _this->PublicAddRef();  DBUG_LOG(to_string(ref).c_str()); return ref;
}

STDMETHODIMP DirectDrawClipper_GetClipList(COMPtr* ptr, LPRECT lpRect, LPRGNDATA lpClipList, LPDWORD lpdwSize) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawClipper, DDERR_GENERIC); LAYER_COM_CALL(GetClipList, lpRect, lpClipList, lpdwSize)
}

STDMETHODIMP DirectDrawClipper_GetHWnd(COMPtr* ptr, HWND FAR* lphWnd) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawClipper, DDERR_GENERIC); LAYER_COM_CALL(GetHWnd, lphWnd)
}

STDMETHODIMP DirectDrawClipper_Initialize(COMPtr* ptr, LPDIRECTDRAW lpDD, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawClipper, DDERR_GENERIC);
    auto _that     =  lpDD == nullptr ? nullptr : GetDirectDraw((COMPtr*)lpDD);
    auto _that_imp = _that == nullptr ? nullptr : _that->GetImp();
    LAYER_COM_CALL(Initialize, (IDirectDraw*)EZInterface(IID_IDirectDraw, _that_imp).I(), dwFlags)
}

STDMETHODIMP DirectDrawClipper_IsClipListChanged(COMPtr* ptr, BOOL FAR* lpbChanged) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawClipper, DDERR_GENERIC); LAYER_COM_CALL(IsClipListChanged, lpbChanged)
}

STDMETHODIMP DirectDrawClipper_SetClipList(COMPtr* ptr, LPRGNDATA lpClipList, DWORD dwFlags) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawClipper, DDERR_GENERIC); LAYER_COM_CALL(SetClipList, lpClipList, dwFlags)
}

STDMETHODIMP DirectDrawClipper_SetHWnd(COMPtr* ptr, DWORD dwFlags, HWND hWnd) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawClipper, DDERR_GENERIC); LAYER_COM_CALL(SetHWnd, dwFlags, hWnd)
}

struct IDIRECTDRAWCLIPPER_VTABLE {
    decltype(DirectDrawClipper_QueryInterface)    * QueryInterface    = DirectDrawClipper_QueryInterface;
    decltype(DirectDrawClipper_AddRef)            * AddRef            = DirectDrawClipper_AddRef;
    decltype(DirectDrawClipper_Release)           * Release           = DirectDrawClipper_Release;    
    decltype(DirectDrawClipper_GetClipList)       * GetClipList       = DirectDrawClipper_GetClipList;
    decltype(DirectDrawClipper_GetHWnd)           * GetHWnd           = DirectDrawClipper_GetHWnd;
    decltype(DirectDrawClipper_Initialize)        * Initialize        = DirectDrawClipper_Initialize;
    decltype(DirectDrawClipper_IsClipListChanged) * IsClipListChanged = DirectDrawClipper_IsClipListChanged;
    decltype(DirectDrawClipper_SetClipList)       * SetClipList       = DirectDrawClipper_SetClipList;
    decltype(DirectDrawClipper_SetHWnd)           * SetHWnd           = DirectDrawClipper_SetHWnd ;
};
const IDIRECTDRAWCLIPPER_VTABLE IDirectDrawClipperVtable;

DirectDrawClipper::DirectDrawClipper(IDirectDrawClipper* pClipper) : PrivateDataObjectParent(pClipper)
{
	m_Imp    = pClipper;
    m_cliper = {(LPVOID)&IDirectDrawClipperVtable, (LPVOID)this};
}