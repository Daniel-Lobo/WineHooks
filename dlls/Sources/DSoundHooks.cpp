#include <windows.h>
#include "ms_dsound.h"
#include "DSoundHooks.h"
#include "eax.h"
#include "Dbug.h"
#include <string>
#include "collections.h"
#include "DSOUND/Headers/DirectSound.h"
#include "sethooks.h"
#include <intrin.h>
#include <math.h>

DSOUND_HOOKS                *  DsndHooks;
DSOUNDGLOBALS              DSoundGlobals;

class DSoundClassFactory : virtual public IClassFactory
{
public:
    virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppvObj)
    {
        if (riid == GUID_NULL || ppvObj == nullptr || this == nullptr) return DSERR_INVALIDPARAM;
        else if (riid == IID_IUnknown)        *ppvObj = (IUnknown*)this;
        else if (riid == IID_IClassFactory)   *ppvObj = (IUnknown*)this;
        else
        {
            DSND_WARN("E_NOINTERFACE");
            return E_NOINTERFACE;
        }
        AddRef();
        return 0;
    }
    virtual ULONG STDMETHODCALLTYPE AddRef()                 { m_ref->Increment(); return m_Imp->AddRef(); }
    virtual ULONG STDMETHODCALLTYPE Release()                { UINT ref = m_Imp->Release(); if (m_ref->Decrement() == 0) delete this; return ref; }
    virtual HRESULT STDMETHODCALLTYPE LockServer(BOOL fLock) { LAYER_LOG_CALL return m_Imp->LockServer(fLock); }
    virtual HRESULT STDMETHODCALLTYPE CreateInstance(IUnknown* pUnkOuter, REFIID riid, void** ppvObject)
    {
        LAYER_LOG_CALL
        HRESULT hr = m_Imp->CreateInstance(pUnkOuter, riid, ppvObject);
        if (hr != 0) return hr;
        if (riid == IID_IDirectSound || riid == IID_IDirectSound8) *ppvObject =
            dynamic_cast<IDirectSound8*>(new DirectSound8((IUnknown*)*ppvObject, DsndHooks->Flags));
        else DBUG_WARN("UNKNOWN REFIID")
        return hr;
    }
    DSoundClassFactory(IUnknown* imp)
    {
        m_Imp = (IClassFactory*)imp;
        m_ref = new SYNC::Atomic();
        m_ref->Set(1);
    }
    ~DSoundClassFactory()
    {
        if (m_ref) delete m_ref;
    }
    IClassFactory * m_Imp = nullptr;
    SYNC::Atomic  * m_ref = nullptr;
};

HRESULT WINAPI DSoundGetClassObjectHook(REFCLSID rclsid, REFIID riid, LPVOID* ppv)
{
    LAYER_LOG_CALL
    HRESULT hr        = DSoundGlobals.m_DllGetClassObject(rclsid, riid, ppv);
    LPVOID ret        = __builtin_return_address(0);
    BOOL IsGameModule = g_.IsGameModule(ret);
    DSoundGlobals.m_loger.log(L"DSoundGetClassObjectHook", (const wchar_t*)DllFromAdress(ret).m_name.c_str());
    if (hr != 0 /*|| IsGameModule == 0*/) return hr;
    if (rclsid == CLSID_DirectSound || rclsid == CLSID_DirectSound8)
    {        
        if (rclsid == CLSID_DirectSound)
        {
            IUnknown* ds1 = (IUnknown*)*ppv;
            ds1->Release();
            hr = DSoundGlobals.m_DllGetClassObject(CLSID_DirectSound8, riid, ppv);
            if (S_OK != hr)
            {
                hr = DSoundGlobals.m_DllGetClassObject(rclsid, riid, ppv);
            }
        }       
        if      (riid == IID_IDirectSound)  *ppv = dynamic_cast<IDirectSound8*>(new DirectSound8((IUnknown*)*ppv, DsndHooks->Flags));
        else if (riid == IID_IDirectSound8) *ppv = dynamic_cast<IDirectSound8*>(new DirectSound8((IUnknown*)*ppv, DsndHooks->Flags));
        else if (riid == IID_IClassFactory) *ppv = dynamic_cast<IClassFactory*>(new DSoundClassFactory((IUnknown*)*ppv));
        else DBUG_WARN("UNKNOWN REFIID")
    }
    else DBUG_WARN("UNKNOWN REFCLSID");
    return S_OK;
}

extern "C" __declspec(dllexport) HRESULT WINAPI DSndCreateHook(LPGUID lpGuid, LPDIRECTSOUND* ppDS, LPUNKNOWN pUnkOuter)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DSoundGlobals.m_loger.log(L"DSndCreateHook", (const wchar_t*)DllFromAdress(__builtin_return_address(0)).m_name.c_str());
    if (g_.IsGameModule(__builtin_return_address(0))==0)  return DSoundGlobals.m_DirectSoundCreate(lpGuid, ppDS, pUnkOuter);
    if (CoInitialize(nullptr) == S_FALSE)      DSND_WARN("CoInitialize FAILED");
    HRESULT hr = DSoundGlobals.m_DirectSoundCreate8(lpGuid, (LPDIRECTSOUND8*)ppDS, pUnkOuter);
    if (S_OK != hr) return hr;

    auto Dsd = new DirectSound8(*ppDS, DsndHooks->Flags);
    *ppDS    = (IDirectSound*)dynamic_cast<IDirectSound8*>(Dsd);
    return hr;
}

extern "C" __declspec(dllexport) HRESULT WINAPI DSndCreate8Hook(LPGUID lpGuid, LPDIRECTSOUND* ppDS, LPUNKNOWN pUnkOuter)
{
   #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DSoundGlobals.m_loger.log(L"DSndCreate8Hook", (const wchar_t*)DllFromAdress(__builtin_return_address(0)).m_name.c_str());
    if (g_.IsGameModule(__builtin_return_address(0)) == 0)  return DSoundGlobals.m_DirectSoundCreate(lpGuid, ppDS, pUnkOuter);
    if (CoInitialize(nullptr) == S_FALSE)        DSND_WARN("CoInitialize FAILED");
    HRESULT hr = DSoundGlobals.m_DirectSoundCreate8(lpGuid, (LPDIRECTSOUND8*)ppDS, pUnkOuter);
    if (S_OK != hr) return hr;

    auto Dsd = new DirectSound8(*ppDS, DsndHooks->Flags);
    *ppDS = (IDirectSound*)dynamic_cast<IDirectSound8*>(Dsd);
    return hr;
}

void DSOUNDGLOBALS::Init()
{
    m_loger.Init("\\DSound.log");
    DSND_WARN("-----")
    if (S_OK != IIDFromString(L"{4a4e6fc1-c341-11d1-b73a-444553540000}", &EAX_10_listenerID))   DSND_WARN("IIDFromString(EAX_10_listenerID) FAILED");
    if (S_OK != IIDFromString(L"{4a4e6fc0-c341-11d1-b73a-444553540000}", &EAX_10_voiceID))      DSND_WARN("IIDFromString(EAX_10_voiceID) FAILED");
    if (S_OK != IIDFromString(L"{84624F82-25EC-11d1-A4D8-00C04FC28ACA}", &PROPID_DSoundDevice)) DSND_WARN("IIDFromString(PROPID_DSoundDevice) FAILED");
    if (S_OK != IIDFromString(L"{0306a6a8-b224-11d2-99e5-0000e8d8c722}", &EAX_20_listenerID))   DSND_WARN("IIDFromString(EAX_20_listenerID) FAILED");
    if (S_OK != IIDFromString(L"{0306a6a7-b224-11d2-99e5-0000e8d8c722}", &EAX_20_voiceID))      DSND_WARN("IIDFromString(EAX_20_voiceID) FAILED");   
    if (S_OK != IIDFromString(L"{a8fa6882-b476-11d3-bdb9-00c0f02ddf87}", &EAX_30_listenerID))   DSND_WARN("IIDFromString(EAX_30_listenerID) FAILED");
    if (S_OK != IIDFromString(L"{a8fa6881-b476-11d3-bdb9-00c0f02ddf87}", &EAX_30_voiceID))      DSND_WARN("IIDFromString(EAX_30_voiceID) FAILED");

    wchar_t* szGUID[64] = { 0 };
    if (StringFromGUID2(EAX_10_listenerID, (LPOLESTR)szGUID, 64)) DSoundGlobals.m_loger.dolog(L"DSOUNDGLOBALS::Init()", (const wchar_t*)szGUID);
    if (StringFromGUID2(EAX_10_voiceID, (LPOLESTR)szGUID, 64)) DSoundGlobals.m_loger.dolog(L"DSOUNDGLOBALS::Init()", (const wchar_t*)szGUID);
    if (StringFromGUID2(EAX_20_listenerID, (LPOLESTR)szGUID, 64)) DSoundGlobals.m_loger.dolog(L"DSOUNDGLOBALS::Init()", (const wchar_t*)szGUID);
    if (StringFromGUID2(EAX_20_voiceID, (LPOLESTR)szGUID, 64)) DSoundGlobals.m_loger.dolog(L"DSOUNDGLOBALS::Init()", (const wchar_t*)szGUID);    

    GETSYSDLLPROCADDRESS(m_DirectSoundCreate, "DirectSoundCreate", "dsound.dll");
    GETSYSDLLPROCADDRESS(m_DirectSoundCreate8, "DirectSoundCreate8", "dsound.dll");
    GETSYSDLLPROCADDRESS(m_DllGetClassObject, "DllGetClassObject", "dsound.dll");   

    if (DsndHooks->Flags & 0xf)  // Use DSOAL 
    {
        std::string alsoft = std::string(g_.Path()) + "/DSOAL v1.4/dsoal-aldrv.dll";
        std::string dsoal = std::string(g_.Path()) + "/DSOAL v1.4/dsound.dll";
        if (LoadLibraryA(alsoft.c_str()) == nullptr)
        {
            DSND_WARN("LoadLibraryA(\"dsoal - aldrv.dll\") FAILED");
            return;
        }
        HMODULE hDsoal = LoadLibraryA(dsoal.c_str());
        if (hDsoal == nullptr)
        {
            DSND_WARN("LoadLibraryA(\"dsound.dll(Dsoal)\") FAILED");
            return;
        }    
        HOOK(&m_DirectSoundCreate, GetProcAddress(hDsoal, "DirectSoundCreate"));
        HOOK(&m_DirectSoundCreate8, GetProcAddress(hDsoal, "DirectSoundCreate8"));
        HOOK(&m_DllGetClassObject, GetProcAddress(hDsoal, "DllGetClassObject"));
        return;
    }   
    HOOK(&m_DirectSoundCreate, DSndCreateHook);
    HOOK(&m_DirectSoundCreate8, DSndCreate8Hook);
    HOOK(&m_DllGetClassObject, DSoundGetClassObjectHook);    
}

extern "C" __declspec(dllexport) void InitDSoundHooks(DSOUND_HOOKS * DSHooks)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DsndHooks = DSHooks;
    DSoundGlobals.Init();       
}

float DSBufferDescMillisecods(DSBUFFERDESC* desc)
{
    if (desc == nullptr)              return 0.f;
    if (desc->lpwfxFormat == nullptr) return 0.f;
    return 1000.f * (float)desc->dwBufferBytes / (float)desc->lpwfxFormat->nAvgBytesPerSec;
}

const char * DSndGetFlagsString(DWORD flags)
{
    static std::string flags_string;
    flags_string.clear();
    if (flags & DSBCAPS_CTRL3D)              flags_string.append("DSBCAPS_CTRL3D ");
    if (flags & DSBCAPS_CTRLFREQUENCY)       flags_string.append("DSBCAPS_CTRLFREQUENCY ") ;
    if (flags & DSBCAPS_CTRLFX)              flags_string.append("DSBCAPS_CTRLFX ");
    if (flags & DSBCAPS_CTRLPAN)             flags_string.append("DSBCAPS_CTRLPAN ");
    if (flags & DSBCAPS_CTRLVOLUME)          flags_string.append("DSBCAPS_CTRLVOLUME ");

    if (flags & DSBCAPS_CTRLPOSITIONNOTIFY)  flags_string.append("DSBCAPS_CTRLPOSITIONNOTIFY ");
    if (flags & DSBCAPS_GETCURRENTPOSITION2) flags_string.append("DSBCAPS_GETCURRENTPOSITION2 ") ;
    if (flags & DSBCAPS_GLOBALFOCUS)         flags_string.append("DSBCAPS_GLOBALFOCUS ");
    if (flags & DSBCAPS_LOCDEFER)            flags_string.append("DSBCAPS_LOCDEFER ");
    if (flags & DSBCAPS_LOCHARDWARE)         flags_string.append("DSBCAPS_LOCHARDWARE ");
    if (flags & DSBCAPS_LOCSOFTWARE)         flags_string.append("DSBCAPS_LOCSOFTWARE ");

    if (flags & DSBCAPS_MUTE3DATMAXDISTANCE) flags_string.append("DSBCAPS_MUTE3DATMAXDISTANCE ");
    if (flags & DSBCAPS_PRIMARYBUFFER)       flags_string.append("DSBCAPS_PRIMARYBUFFER ") ;
    if (flags & DSBCAPS_STATIC)              flags_string.append("DSBCAPS_STATIC ");
    if (flags & DSBCAPS_STICKYFOCUS)         flags_string.append("DSBCAPS_STICKYFOCUS ");
    //if (flags & DSBCAPS_TRUEPLAYPOSITION)    flags_string.append("DSBCAPS_TRUEPLAYPOSITION ");
    return flags_string.c_str();
}

const char * DSndGetErrString(DWORD err, DWORD flags)
{
    static std::string err_string;
    err_string.clear();

    if      (err == DS_NO_VIRTUALIZATION)     err_string.append("DS_NO_VIRTUALIZATION");
    else if (err == DSERR_ALLOCATED)          err_string.append("DSERR_ALLOCATED");
    else if (err == DSERR_CONTROLUNAVAIL)     err_string.append("DSERR_CONTROLUNAVAIL");
    else if (err == DSERR_INVALIDPARAM)       err_string.append("DSERR_INVALIDPARAM");
    else if (err == DSERR_INVALIDCALL)        err_string.append("DSERR_INVALIDCALL");
    else if (err == DSERR_GENERIC)            err_string.append("DSERR_GENERIC");
    else if (err == DSERR_PRIOLEVELNEEDED)    err_string.append("DSERR_PRIOLEVELNEEDED");
    else if (err == DSERR_OUTOFMEMORY)        err_string.append("DSERR_OUTOFMEMORY");
    else if (err == DSERR_BADFORMAT)          err_string.append("DSERR_BADFORMAT");
    else if (err == DSERR_UNSUPPORTED)        err_string.append("DSERR_UNSUPPORTED");
    else if (err == DSERR_NODRIVER)           err_string.append("DSERR_NODRIVER");    
    else if (err == DSERR_ALREADYINITIALIZED) err_string.append("DSERR_ALREADYINITIALIZED");
    else if (err == DSERR_NOAGGREGATION)      err_string.append("DSERR_NOAGGREGATION");
    else if (err == DSERR_BUFFERLOST)         err_string.append("DSERR_BUFFERLOST");
    else if (err == DSERR_OTHERAPPHASPRIO)    err_string.append("DSERR_OTHERAPPHASPRIO");
    else if (err == DSERR_UNINITIALIZED)      err_string.append("DSERR_UNINITIALIZED");
    else if (err == DSERR_NOINTERFACE)        err_string.append("DSERR_NOINTERFACE");
    else if (err == DSERR_ACCESSDENIED)       err_string.append("DSERR_ACCESSDENIED");
    else if (err == DSERR_UNINITIALIZED)      err_string.append("DSERR_BUFFERTOOSMALL");
    else if (err == DSERR_DS8_REQUIRED)       err_string.append("DSERR_DS8_REQUIRED");
    else if (err == DSERR_SENDLOOP)           err_string.append("DSERR_SENDLOOP");
    else if (err == DSERR_BADSENDBUFFERGUID)  err_string.append("DSERR_BADSENDBUFFERGUID");
    else if (err == DSERR_OBJECTNOTFOUND)     err_string.append("DSERR_OBJECTNOTFOUND");
    else if (err == DSERR_FXUNAVAILABLE)      err_string.append("DSERR_FXUNAVAILABLE");
    else if (err == CO_E_NOTINITIALIZED)      err_string.append("CO_E_NOTINITIALIZED");
    else if (err == 0x08780020)               err_string.append("DS_INCOMPLETE");
    else if (err == 0x80040205)               err_string.append("DMO_E_TYPE_NOT_ACCEPTED");    
    else                                      err_string.append("=(");

    err_string.append(" ");
    err_string.append(DSndGetFlagsString(flags));
    return err_string.c_str();
}

float linear_2_cdb(float linear_gain) {
    return 2000.f *log10(linear_gain);
}

float cdb_to_linear(float cdb) {
    return pow(10, cdb/2000.f);
}