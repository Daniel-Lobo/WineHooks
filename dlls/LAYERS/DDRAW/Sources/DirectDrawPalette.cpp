#include <ddraw.h>
#include "DirectDraw.h"
#include <dllmain.h>

#include "D3D12Hooks.h"

#include <string>
#include "EZString.h"
#include <typeinfo>
using std::string;
using std::to_string;

DirectDrawPalette* GetDirectDrawPalette(COMPtr* ptr)
{
    if (ptr == nullptr)         return nullptr;
    return (DirectDrawPalette*)ptr->COMObjct;
}

#undef  LAYER_THIS
#define LAYER_THIS IDirectDrawPalette
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectDrawPalette
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

ULONG __stdcall DirectDrawPalette_QueryInterface(COMPtr* ptr, REFIID riid, void** ppvObj)
{
    LAYER_LOG_CALL   GET_COM_PTR(DirectDrawPalette, DDERR_GENERIC) if (ppvObj == nullptr) return E_POINTER;

    if (riid   == IID_IUnknown || riid == IID_IDirectDrawPalette) {
         *ppvObj = _this->GetPalette(); _this->PublicAddRef(); return 0;
    }

    HRESULT hr = _this->GetImp()->QueryInterface(riid, ppvObj);
    DBUG_WARN((string("Unhandled GUID:") + GUID2String(riid).str().get()->str() + " Implementation hr=" + to_string(hr)).c_str());
    return hr;
}

ULONG __stdcall DirectDrawPalette_Release(COMPtr* ptr) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawPalette, DDERR_GENERIC)
    ULONG ref = _this->PublicRelease();	DBUG_LOG(to_string(ref).c_str()); return ref;
}

ULONG __stdcall DirectDrawPalette_AddRef(COMPtr* ptr) {
    LAYER_LOG_CALL GET_COM_PTR(DirectDrawPalette, DDERR_GENERIC)
    ULONG ref = _this->PublicAddRef();  DBUG_LOG(to_string(ref).c_str()); return ref;
}

STDMETHODIMP DirectDrawPalette_GetCaps(COMPtr* ptr, LPDWORD lpdwCaps) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawPalette, DDERR_GENERIC); LAYER_COM_CALL(GetCaps, lpdwCaps)
}

STDMETHODIMP DirectDrawPalette_GetEntries(COMPtr* ptr, DWORD dwFlags, DWORD dwBase, DWORD dwNumEntries, LPPALETTEENTRY lpEntries) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawPalette, DDERR_GENERIC); LAYER_COM_CALL(GetEntries, dwFlags, dwBase, dwNumEntries, lpEntries)
}

STDMETHODIMP DirectDrawPalette_Initialize(COMPtr* ptr, LPDIRECTDRAW lpDD, DWORD dwFlags, LPPALETTEENTRY lpDDColorTable) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawPalette, DDERR_GENERIC);
    auto _that     =  lpDD == nullptr ? nullptr : GetDirectDraw((COMPtr*)lpDD);
    auto _that_imp = _that == nullptr ? nullptr : _that->GetImp();
    LAYER_COM_CALL(Initialize, (IDirectDraw*)EZInterface(IID_IDirectDraw, _that_imp).I(), dwFlags, lpDDColorTable)
}

STDMETHODIMP DirectDrawPalette_SetEntries(COMPtr* ptr, DWORD dwFlags, DWORD dwStartingEntry, DWORD dwCount, LPPALETTEENTRY lpEntries) {
    LAYER_LOG_CALL; GET_COM_PTR(DirectDrawPalette, DDERR_GENERIC); LAYER_COM_CALL(SetEntries, dwFlags, dwStartingEntry, dwCount, lpEntries)
}

struct IDIRECTDRAWPALETTE_VTABLE {
    decltype(DirectDrawPalette_QueryInterface) * QueryInterface = DirectDrawPalette_QueryInterface;
    decltype(DirectDrawPalette_AddRef)         * AddRef         = DirectDrawPalette_AddRef;
    decltype(DirectDrawPalette_Release)        * Release        = DirectDrawPalette_Release;    
    decltype(DirectDrawPalette_GetCaps)        * GetCaps        = DirectDrawPalette_GetCaps;
    decltype(DirectDrawPalette_GetEntries)     * GetEntries     = DirectDrawPalette_GetEntries;
    decltype(DirectDrawPalette_Initialize)     * Initialize     = DirectDrawPalette_Initialize;
    decltype(DirectDrawPalette_SetEntries)     * SetEntries     = DirectDrawPalette_SetEntries;
};
IDIRECTDRAWPALETTE_VTABLE IDirectDrawPaletteVtable;

DirectDrawPalette::DirectDrawPalette(IDirectDrawPalette* pPalette) : PrivateDataObjectParent(pPalette)
{
    m_Imp     = pPalette;
    m_palette = {(LPVOID)&IDirectDrawPaletteVtable, (LPVOID)this};
}