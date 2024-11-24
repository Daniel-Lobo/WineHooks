#include <windows.h>
#include <dinput.h>
#include "DirectInput.h"
#include <dllmain.h>
#include "Sync.h"
#include <string>
#include "sethooks.h"
#include "EZString.h"
#include <unknwn.h>

class DInputClassFactory : virtual public IClassFactory
{
public:
    virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppvObj)
    {
        if (riid == GUID_NULL || ppvObj == nullptr || this == nullptr) return DIERR_INVALIDPARAM;
        else if (riid == IID_IUnknown)        *ppvObj = (IUnknown*)this;
        else if (riid == IID_IClassFactory)   *ppvObj = (IUnknown*)this;
        else
        {
            DINPUT_WARN("E_NOINTERFACE");
            return E_NOINTERFACE;
        }
        AddRef();
        return 0;
    }
    virtual ULONG STDMETHODCALLTYPE AddRef()  { m_ref->Increment(); return m_Imp->AddRef(); }
    virtual ULONG STDMETHODCALLTYPE Release() { UINT ref = m_Imp->Release(); if (m_ref->Decrement() == 0) delete this; return ref; }
    virtual HRESULT STDMETHODCALLTYPE LockServer(BOOL fLock) { LAYER_LOG_CALL return m_Imp->LockServer(fLock); }
    virtual HRESULT STDMETHODCALLTYPE CreateInstance(IUnknown* pUnkOuter, REFIID riid, void** ppvObject)
    {
        LAYER_LOG_CALL
        HRESULT hr = m_Imp->CreateInstance(pUnkOuter, riid, ppvObject);
        if (hr != 0) return hr;
        if      (riid == IID_IDirectInput8A) *ppvObject = dynamic_cast<IDirectInput8A*>(new DirectInput8((IUnknown*)*ppvObject));
        else if (riid == IID_IDirectInput8W) *ppvObject = dynamic_cast<IDirectInput8W*>(new DirectInput8((IUnknown*)*ppvObject));
        else DBUG_WARN("UNKNOWN REFIID")
        return hr;
    }
    DInputClassFactory(IUnknown* imp)
    {
        m_Imp = (IClassFactory*)imp;
        m_ref = new SYNC::Atomic();
        m_ref->Set(1);
    }
    IClassFactory* m_Imp = nullptr;
    SYNC::Atomic * m_ref = nullptr;
};

HRESULT WINAPI DInput8GetClassObjectHook(REFCLSID rclsid, REFIID riid, LPVOID* ppv)
{
    LAYER_LOG_CALL
    HRESULT hr        = g_Dinput.m_DllGetClassObject8(rclsid, riid, ppv);
    LPVOID ret        = __builtin_return_address(0);
    BOOL IsGameModule = g_.IsGameModule(ret) || DllFromAdress(ret).m_name.find(L"autohotkey.dll") != std::string::npos;
    OutputDebugStringW((wstring(L"DInput8GetClassObjectHook") + L"================" + DllFromAdress(ret).m_name).c_str());
    if (hr != 0 /* || IsGameModule == 0*/) return hr;
    if (rclsid == CLSID_DirectInput8)
    {
        if      (riid == IID_IDirectInput8A) *ppv = dynamic_cast<IDirectInput8A*>(new DirectInput8((IUnknown*)*ppv));
        else if (riid == IID_IDirectInput8W) *ppv = dynamic_cast<IDirectInput8W*>(new DirectInput8((IUnknown*)*ppv));
        else if (riid == IID_IClassFactory) *ppv = dynamic_cast<IClassFactory*>(new DInputClassFactory((IUnknown*)*ppv));
        else DBUG_WARN("UNKNOWN REFIID")
    } else DBUG_WARN("UNKNOWN REFCLSID");
    return S_OK;
}

HRESULT WINAPI DirectInputCreateA_Hook(HINSTANCE hinst, DWORD dwVersion, LPDIRECTINPUTA* pDinput, LPUNKNOWN pIunknonw)
{
    LAYER_LOG_CALL
    HRESULT hr        = g_Dinput.m_DirectInputCreateA(hinst, dwVersion, pDinput, pIunknonw);
    LPVOID ret        = __builtin_return_address(0);
    BOOL IsGameModule = g_.IsGameModule(ret) || DllFromAdress(ret).m_name.find(L"autohotkey.dll") != std::string::npos;
    if (hr != 0 || IsGameModule == 0) return hr;
    *pDinput = dynamic_cast<IDirectInputA*>(new DirectInput(*pDinput));  
    g_Dinput.m_version = dwVersion;
    return hr;
}

HRESULT WINAPI DirectInputCreateW_Hook(HINSTANCE hinst, DWORD dwVersion, LPDIRECTINPUTW* pDinput, LPUNKNOWN pIunknonw)
{
    LAYER_LOG_CALL
    HRESULT hr        = g_Dinput.m_DirectInputCreateW(hinst, dwVersion, pDinput, pIunknonw);
    LPVOID ret        = __builtin_return_address(0);
    BOOL IsGameModule = g_.IsGameModule(ret) || DllFromAdress(ret).m_name.find(L"autohotkey.dll") != std::string::npos;
    if (hr != 0 || IsGameModule == 0) return hr;
    *pDinput = dynamic_cast<IDirectInputW*>(new DirectInput(*pDinput));     
    g_Dinput.m_version = dwVersion;
    return hr;
}

HRESULT WINAPI DirectInputCreateEx_Hook(HINSTANCE hinst, DWORD dwVersion, REFIID riidltf, LPVOID* ppvOut, LPUNKNOWN punkOuter)
{
    LAYER_LOG_CALL
    HRESULT hr        = g_Dinput.m_DirectInputCreateEx(hinst, dwVersion, riidltf, ppvOut, punkOuter);    
    LPVOID ret        = __builtin_return_address(0);
    BOOL IsGameModule = g_.IsGameModule(ret) || DllFromAdress(ret).m_name.find(L"autohotkey.dll") != std::string::npos;
    if (hr != 0 || IsGameModule == 0) return hr;
    else if (riidltf == IID_IDirectInputA)  *ppvOut = (IDirectInputA*)new DirectInput((IUnknown*)*ppvOut);
    else if (riidltf == IID_IDirectInputW)  *ppvOut = dynamic_cast<IDirectInputW*>(new DirectInput((IUnknown*)*ppvOut));
    else if (riidltf == IID_IDirectInput7A) *ppvOut = dynamic_cast<IDirectInput7A*>(new DirectInput((IUnknown*)*ppvOut));
    else if (riidltf == IID_IDirectInput7W) *ppvOut = dynamic_cast<IDirectInput7W*>(new DirectInput((IUnknown*)*ppvOut));    
    else
    {
        DINPUT_WARN("UNKNON GUID");        
    }   
    DINPUT_WARN("CREATED PROXY");
    g_Dinput.m_version = dwVersion;
    return hr;
}

HRESULT WINAPI DirectInput8Create_Hook(HINSTANCE hinst, DWORD dwVersion, REFIID riidltf, LPVOID* ppvOut, LPUNKNOWN punkOuter)
{
    LAYER_LOG_CALL
    HRESULT hr = g_Dinput.m_DirectInput8Create(hinst, dwVersion, riidltf, ppvOut, punkOuter);
    LPVOID ret = __builtin_return_address(0);
    BOOL IsGameModule = g_.IsGameModule(ret) || DllFromAdress(ret).m_name.find(L"autohotkey.dll") != std::string::npos;
    if (hr != 0 || IsGameModule == 0) return hr;
    else if (riidltf == IID_IDirectInput8A) *ppvOut = (IDirectInput8A*)new DirectInput8((IUnknown*)*ppvOut);
    else if (riidltf == IID_IDirectInput8W) *ppvOut = dynamic_cast<IDirectInput8W*>(new DirectInput8((IUnknown*)*ppvOut));
    else
    {
        DINPUT_WARN("UNKNON GUID");
    }
    DINPUT_WARN("CREATED PROXY");
    g_Dinput.m_version = dwVersion;
    return hr;
}

extern "C" __declspec(dllexport) void __stdcall InitDInputLayer()
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HOOK(&g_Dinput.m_DirectInputCreateA, DirectInputCreateA_Hook);
    HOOK(&g_Dinput.m_DirectInputCreateW, DirectInputCreateW_Hook);
    HOOK(&g_Dinput.m_DirectInputCreateEx, DirectInputCreateEx_Hook);
    HOOK(&g_Dinput.m_DirectInput8Create, DirectInput8Create_Hook);
    HOOK(&g_Dinput.m_DllGetClassObject8, DInput8GetClassObjectHook);
}

DirectInput::DirectInput(IUnknown* di) {
    m_Imp = di;
    m_ref = new SYNC::Atomic();
    m_ref->Set(1);
}

/*
ULONG STDMETHODCALLTYPE DirectInput::AddRef() {
    return m_Imp->AddRef();
}

ULONG STDMETHODCALLTYPE DirectInput::Release() {
    ULONG ref = m_Imp->Release();
    if (ref == 0) delete this;
    return ref;
}
*/

HRESULT STDMETHODCALLTYPE DirectInput::QueryInterface(REFIID riid, void** ppvObj)
{
    LAYER_LOG_CALL
    wchar_t* szGUID[64] = { 0 };
    if (StringFromGUID2(riid, (LPOLESTR)szGUID, 64))
    {
        //OutputDebugStringW((const wchar_t*)szGUID);
        //OutputDebugStringW((const wchar_t*)DllFromAdress(__builtin_return_address(0)).m_name.c_str());
    }

    if (riid == GUID_NULL || ppvObj == nullptr || this == nullptr) return DIERR_INVALIDPARAM;
    else if (riid == IID_IUnknown)        *ppvObj = (IDirectInputA*)this;
    else if (riid == IID_IDirectInputA)   *ppvObj = (IDirectInputA*)this;
    else if (riid == IID_IDirectInputW)   *ppvObj = dynamic_cast<IDirectInputW*>(this);
    else if (riid == IID_IDirectInput2A)  *ppvObj = dynamic_cast<IDirectInput2A*>(this);
    else if (riid == IID_IDirectInput2W)  *ppvObj = dynamic_cast<IDirectInput2W*>(this);
    else if (riid == IID_IDirectInput7A)  *ppvObj = dynamic_cast<IDirectInput7A*>(this);
    else if (riid == IID_IDirectInput7W)  *ppvObj = dynamic_cast<IDirectInput7W*>(this);
    else
    {
        DINPUT_WARN("E_NOINTERFACE");
        return E_NOINTERFACE;
    }
    AddRef();
    return 0;
}

HRESULT STDMETHODCALLTYPE DirectInput::CreateDevice(REFGUID riid, LPDIRECTINPUTDEVICEA* pDvc, LPUNKNOWN pUnknown)
{
    LAYER_LOG_CALL
    IDirectInputA* dinpt = (IDirectInputA*)EZInterface(IID_IDirectInputA, m_Imp).I();
    if (dinpt == nullptr)
    {
        DBUG_WARN("EZInterface::I() FAILED");
        return DIERR_GENERIC;
    }
    HRESULT hr = dinpt->CreateDevice(riid, pDvc, pUnknown);
    if (hr == 0) *pDvc = (IDirectInputDeviceA*)new DirectInputDevice(*pDvc);
    else DBUG_WARN("CreateDeviceA FAILED");
    return hr;
}

HRESULT STDMETHODCALLTYPE DirectInput::CreateDevice(REFGUID riid, LPDIRECTINPUTDEVICEW* pDvc, LPUNKNOWN pUnknown)
{
    LAYER_LOG_CALL
    IDirectInputW* dinpt = (IDirectInputW*)EZInterface(IID_IDirectInputW, m_Imp).I();
    if (dinpt == nullptr)
    {
        DBUG_WARN("EZInterface::I() FAILED");
        return DIERR_GENERIC;
    }
    HRESULT hr = dinpt->CreateDevice(riid, pDvc, pUnknown);
    if (hr == 0) *pDvc = dynamic_cast<IDirectInputDeviceW*>(new DirectInputDevice(*pDvc));
    else DBUG_WARN("CreateDeviceA FAILED");
    return hr;
}

HRESULT STDMETHODCALLTYPE DirectInput::CreateDeviceEx(REFGUID dvcID, REFIID iID, LPVOID* pDvc, LPUNKNOWN pUnknown)
{
    LAYER_LOG_CALL
    if (iID == GUID_NULL || pDvc == nullptr || this == nullptr) return DIERR_INVALIDPARAM;

    if (iID == IID_IDirectInputDeviceA || iID == IID_IDirectInputDevice2A || iID == IID_IDirectInputDevice7A)
    {
        IDirectInput7A* dinpt = (IDirectInput7A*)EZInterface(IID_IDirectInput7A, m_Imp).I();
        if (dinpt == nullptr)
        {
            DBUG_WARN("EZInterface::I() FAILED");
            return DIERR_GENERIC;
        }
        HRESULT hr = dinpt->CreateDeviceEx(dvcID, iID, pDvc, pUnknown);
        if (hr == 0) *pDvc = dynamic_cast<IDirectInputDevice7A*>(new DirectInputDevice((IUnknown*)*pDvc));
        else DBUG_WARN("CreateDeviceEx FAILED");
        return hr;
    }
    else if (iID == IID_IDirectInputDevice || iID == IID_IDirectInputDevice2W || iID == IID_IDirectInputDevice7W)
    {
        IDirectInput7W* dinpt = (IDirectInput7W*)EZInterface(IID_IDirectInput7W, m_Imp).I();
        if (dinpt == nullptr)
        {
            DBUG_WARN("EZInterface::I() FAILED");
            return DIERR_GENERIC;
        }
        HRESULT hr = dinpt->CreateDeviceEx(dvcID, iID, pDvc, pUnknown);
        if (hr == 0) *pDvc = dynamic_cast<IDirectInputDevice7W*>(new DirectInputDevice((IUnknown*)*pDvc));
        else DBUG_WARN("CreateDeviceEx FAILED");
        return hr;
    }
}

DirectInput8::DirectInput8(IUnknown* di) {
    m_Imp = di;
    m_ref = new SYNC::Atomic();
    m_ref->Set(1);
}

/*
ULONG DirectInput8::AddRef() {
    return m_Imp->AddRef();
}

ULONG STDMETHODCALLTYPE DirectInput8::Release() {
    ULONG ref = m_Imp->Release();
    if (ref == 0) delete this;
    return ref;
}
*/

HRESULT DirectInput8::QueryInterface(REFIID riid, void** ppvObj)
{
    LAYER_LOG_CALL
    wchar_t* szGUID[64] = { 0 };
    if (StringFromGUID2(riid, (LPOLESTR)szGUID, 64))
    {
        //OutputDebugStringW((const wchar_t*)szGUID);
        //OutputDebugStringW((const wchar_t*)DllFromAdress(__builtin_return_address(0)).m_name.c_str());
    }

    if (riid == GUID_NULL || ppvObj == nullptr || this == nullptr) return DIERR_INVALIDPARAM;    
    else if (riid == IID_IDirectInput8A)  *ppvObj =(IDirectInput8A*) this;
    else if (riid == IID_IDirectInput8W)  *ppvObj = dynamic_cast<IDirectInput8W*>(this);
    else
    {
        DINPUT_WARN("E_NOINTERFACE");
        return E_NOINTERFACE;
    }
    AddRef();
    return 0;
}

DirectInputDevice::DirectInputDevice(IUnknown* di) {
    m_Imp = di;
    m_ref = new SYNC::Atomic();
    m_ref->Set(1);
}

/*
ULONG STDMETHODCALLTYPE DirectInputDevice::AddRef() {
    return m_Imp->AddRef();
}

ULONG STDMETHODCALLTYPE DirectInputDevice::Release() {
    ULONG ref = m_Imp->Release();
    if (ref == 0) delete this;
    return ref;
}
*/

HRESULT STDMETHODCALLTYPE DirectInputDevice::QueryInterface(REFIID riid, void** ppvObj)
{
    LAYER_LOG_CALL
    wchar_t* szGUID[64] = { 0 };
    if (StringFromGUID2(riid, (LPOLESTR)szGUID, 64))
    {
        //OutputDebugStringW((const wchar_t*)szGUID);
        //OutputDebugStringW((const wchar_t*)DllFromAdress(__builtin_return_address(0)).m_name.c_str());
    }

    if (riid == GUID_NULL || ppvObj == nullptr || this == nullptr) return DIERR_INVALIDPARAM;
    else if (riid == IID_IUnknown)             *ppvObj = (IDirectInputDeviceA*) this;
    else if (riid == IID_IDirectInputDeviceA)  *ppvObj = (IDirectInputDeviceA*) this;
    else if (riid == IID_IDirectInputDeviceW)  *ppvObj = dynamic_cast<IDirectInputDeviceW*>(this);
    else if (riid == IID_IDirectInputDevice2A) *ppvObj = dynamic_cast<IDirectInputDevice2A*>(this);
    else if (riid == IID_IDirectInputDevice2W) *ppvObj = dynamic_cast<IDirectInputDevice2W*>(this);
    else if (riid == IID_IDirectInputDevice7A) *ppvObj = dynamic_cast<IDirectInputDevice7A*>(this);
    else if (riid == IID_IDirectInputDevice7W) *ppvObj = dynamic_cast<IDirectInputDevice7W*>(this);
    /* Return something that inherits from IUnknown because EZinterface will call IUnkown::Release() on it
     * The caller latter has to call dynamic_cast<DInputbase*> */
    else if (riid == (GUID&)g_.DInputbase)     *ppvObj = (IDirectInputDeviceA*)this;
    else
    {
        DINPUT_WARN("E_NOINTERFACE");
        return E_NOINTERFACE;
    }
    AddRef();
    return 0;
}


DirectInputDevice8::DirectInputDevice8(IUnknown* di) {
    m_Imp = di;
    m_ref = new SYNC::Atomic();
    m_ref->Set(1);
}

/*
ULONG DirectInputDevice8::AddRef() {
    return m_Imp->AddRef();
}


ULONG STDMETHODCALLTYPE DirectInputDevice8::Release() {
    ULONG ref = m_Imp->Release();
    if (ref == 0) delete this;
    return ref;
}
*/

HRESULT DirectInputDevice8::QueryInterface(REFIID riid, void** ppvObj)
{
    LAYER_LOG_CALL
    wchar_t* szGUID[64] = { 0 };
    if (StringFromGUID2(riid, (LPOLESTR)szGUID, 64))
    {
        //OutputDebugStringW((const wchar_t*)szGUID);
        //OutputDebugStringW((const wchar_t*)DllFromAdress(__builtin_return_address(0)).m_name.c_str());
    }

    if (riid == GUID_NULL || ppvObj == nullptr || this == nullptr) return DIERR_INVALIDPARAM;
    else if (riid == IID_IUnknown)              *ppvObj = (IDirectInputDevice8A*)this;
    else if (riid == IID_IDirectInputDevice8A)  *ppvObj = dynamic_cast<IDirectInputDevice8A*>(this);
    else if (riid == IID_IDirectInputDevice8W)  *ppvObj = dynamic_cast<IDirectInputDevice8W*>(this);
    /* Return something that inherits from IUnknown because EZinterface will call IUnkown::Release() on it
     * The caller latter has to call dynamic_cast<DInputbase*> */
    else if (riid == (GUID&)g_.DInputbase)      *ppvObj = (IDirectInputDevice8A*)this;
    else
    {
        DINPUT_WARN("E_NOINTERFACE");
        return E_NOINTERFACE;
    }
    AddRef();
    return 0;
}

HRESULT STDMETHODCALLTYPE DirectInput8::CreateDevice(REFGUID riid, LPDIRECTINPUTDEVICE8A* pDvc, LPUNKNOWN pUnknown)
{
    LAYER_LOG_CALL
    IDirectInput8A* dinpt = (IDirectInput8A*)EZInterface(IID_IDirectInput8A, m_Imp).I();
    if (dinpt == nullptr)
    {
        DBUG_WARN("EZInterface::I() FAILED");
        return DIERR_GENERIC;
    }
    HRESULT hr = dinpt->CreateDevice(riid, pDvc, pUnknown);
    if (hr == 0) *pDvc = (IDirectInputDevice8A*) new DirectInputDevice8(*pDvc);
    else DBUG_WARN("CreateDeviceA FAILED");
    return hr;
}

HRESULT STDMETHODCALLTYPE DirectInput8::CreateDevice(REFGUID riid, LPDIRECTINPUTDEVICE8W* pDvc, LPUNKNOWN pUnknown)
{
    LAYER_LOG_CALL
    IDirectInput8W* dinpt = (IDirectInput8W*)EZInterface(IID_IDirectInput8W, m_Imp).I();
    if (dinpt == nullptr)
    {
        DBUG_WARN("EZInterface::I() FAILED");
        return DIERR_GENERIC;
    }
    HRESULT hr = dinpt->CreateDevice(riid, pDvc, pUnknown);
    if (hr == 0)
    {
        *pDvc = dynamic_cast<IDirectInputDevice8W*>(new DirectInputDevice8(*pDvc));
        DBUG_WARN("DI_OK");
    }
    else DBUG_WARN("CreateDeviceW FAILED");
    return hr;
}

DInputBase* GetDiBase(IUnknown* i)
{
    IUnknown* U = EZInterface((GUID&)g_.DInputbase, i).I();
    if (U == nullptr) return nullptr;        
    DInputBase* b = dynamic_cast<DInputBase*>(U);    
    return b;    
}

DWORD DiGetDataSz(IUnknown* i)
{
    DInputBase* di = GetDiBase(i);
    if (di == nullptr)
    {
        DBUG_WARN("NOT A DInputBase Object");
        return 0;
    }
    return di->Get();
}

const vector<DI_DATA_ELEMENT>* DiGetDataFormat(IUnknown* i)
{
    DInputBase* di = GetDiBase(i);
    if (di == nullptr)
    {
        DBUG_WARN("NOT A DInputBase Object");
        return nullptr;
    }
    return di->Fmt();   
}

DWORD DiSetDataFormat(IUnknown * i, LPCDIDATAFORMAT lpdf)
{
    if (lpdf == nullptr || i == nullptr)               return 1;
    if (lpdf->dwSize != sizeof(DIDATAFORMAT))          return 2;
    if (lpdf->dwObjSize != sizeof(DIOBJECTDATAFORMAT)) return 3;

    /* No checking if this is a mouse of keyboard. That's the caller's responsability */
            
    DInputBase* di = GetDiBase(i);
    if (di == nullptr)
    {
        DBUG_WARN("NOT A DInputBase Object");
        return 5;
    }    
    vector<DI_DATA_ELEMENT>* fmt = di->Fmt();
    di->Set(lpdf->dwDataSize);
    fmt->clear();

    struct Assigments {
        UINT lx = 0, ly = 0, rx = 0, ry = 0;
        UINT pv = 0;
        UINT btns[12] = {};
    } Ass;
    UINT found_button = 0;

    wchar_t  szGUID[64] = { 0 };
    wstring  sGUID;
    if (lpdf->dwFlags & DIDF_RELAXIS) DBUG_WARN("==============DIDF_RELAXIS===============");
    DIOBJECTDATAFORMAT* Obj = nullptr;

    // These GUIDs will be use with pre defined constants, by the 1st 4 bytes changes
    wstring LX = L"0000-0000-03FF-FF8000010000}";
    wstring LY = L"0004-0000-03FF-FF8000010000}";
    wstring LZ = L"0008-0000-03FF-FF8000010000}";
    wstring RX = L"000C-0000-03FF-FF8000010000}";
    wstring RY = L"0010-0000-03FF-FF8000010000}";
    wstring RZ = L"0014-0000-03FF-FF8000010000}";    
       
    for (int i = 0; i < lpdf->dwNumObjs; i++)
    {             
        Obj = &lpdf->rgodf[i];      
        if (StringFromGUID2((const GUID&)Obj->pguid, (LPOLESTR)szGUID, 64) == 0)
        {
            DBUG_WARN("StringFromGUID2 FAILED");
        }
        else 
        {
            sGUID = szGUID;
        }
        if (Obj->dwType & DIDFT_ABSAXIS || Obj->dwType & DIDFT_AXIS)
        {
            if (IsEqualGUID((const GUID&)Obj->pguid, GUID_NULL) || IsEqualGUID((const GUID&)Obj->pguid, GUID_Unknown))
            {
                if (Ass.lx == 0)
                {
                    fmt->push_back(DI_DATA_ELEMENT(Obj, XINPUTID_LX, Obj->dwOfs));
                    Ass.lx = 1;
                }
                else if (Ass.ly == 0)
                {
                    fmt->push_back(DI_DATA_ELEMENT(Obj, XINPUTID_LY, Obj->dwOfs));
                    Ass.ly = 1;
                }
                else if (Ass.rx == 0)
                {
                    fmt->push_back(DI_DATA_ELEMENT(Obj, XINPUTID_RX, Obj->dwOfs));
                    Ass.rx = 1;
                }
                else if (Ass.ry == 0)
                {
                    fmt->push_back(DI_DATA_ELEMENT(Obj, XINPUTID_RY, Obj->dwOfs));
                    Ass.ry = 1;
                }
                else DBUG_WARN("NO AXES LEFT");
            }
            else if (IsEqualGUID((const GUID&)Obj->pguid, GUID_XAxis) || sGUID.find(LX) != std::string::npos)
            {
                if (Ass.lx == 0)
                {
                    fmt->push_back(DI_DATA_ELEMENT(Obj, XINPUTID_LX, Obj->dwOfs));
                    Ass.lx = 1;
                }
                else DBUG_WARN("LX ALREADY ASSINGED");
            }
            else if (IsEqualGUID((const GUID&)Obj->pguid, GUID_YAxis) || sGUID.find(LY) != std::string::npos)
            {
                if (Ass.ly == 0) 
                {
                    fmt->push_back(DI_DATA_ELEMENT(Obj, XINPUTID_LY, Obj->dwOfs));
                    Ass.ly = 1;
                }
                else DBUG_WARN("LY ALREADY ASSINGED");
            }
            else if (IsEqualGUID((const GUID&)Obj->pguid, GUID_RxAxis) || sGUID.find(RX) != std::string::npos)
            {
                if (Ass.rx == 0) 
                {
                    fmt->push_back(DI_DATA_ELEMENT(Obj, XINPUTID_RX, Obj->dwOfs));
                    Ass.rx = 1;
                }
                else DBUG_WARN("LX ALREADY ASSINGED");
            }
            else if (IsEqualGUID((const GUID&)Obj->pguid, GUID_RyAxis) || sGUID.find(RY) != std::string::npos)
            {
                if (Ass.ry == 0) 
                {
                    fmt->push_back(DI_DATA_ELEMENT(Obj, XINPUTID_RY, Obj->dwOfs));
                    Ass.ry = 1;
                }
                else DBUG_WARN("LY ALREADY ASSINGED");
            }
            else
            {
                DBUG_WARN("UNSUPPORTED AXES GUID");    
                OutputDebugStringW(szGUID);
            }
        }
        else if (Obj->dwType & DIDFT_POV)
        {
            if (Ass.pv == 0)
            {
                fmt->push_back(DI_DATA_ELEMENT(Obj, XINPUTID_POV, Obj->dwOfs));
                Ass.pv = 1;
            }
            else DBUG_WARN("POV ALREADY ASSINGED");
        }
        else if (Obj->dwType & DIDFT_BUTTON || Obj->dwType & DIDFT_PSHBUTTON)
        {
            found_button = 0;
            for (int idx = 0; idx < 12; idx++)
            {
                if (Ass.btns[idx] == 0)
                {
                    fmt->push_back(DI_DATA_ELEMENT(Obj, idx+1 << 4, Obj->dwOfs));
                    Ass.btns[idx] = 1;
                    found_button  = 1;
                    DBUG_WARN((string("Added buton: ") + to_string(idx) + " offset: " + to_string(Obj->dwOfs)).c_str());
                    break;
                }
            }
            if (found_button == 0 ) DBUG_WARN("NO BUTTONS LEFT");
        }
    }
    return 0;
}