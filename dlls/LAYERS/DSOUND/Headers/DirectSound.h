#ifndef DIRECTSOUND_H
#define DIRECTSOUND_H
#define __uuidof(IDirectSound)        IID_IDirectSound
#define __uuidof(IDirectSound8)       IID_IDirectSound8
#define __uuidof(IDirectSoundDevice)  IID_IDirectSoundDevice
#define __uuidof(IDirectSoundDevice8) IID_IDirectSoundDevice8

#include <windows.h>
#include "ms_dsound.h"
#include <DSoundHooks.h>
#include <dllmain.h>
#include "Sync.h"
#include "LayersCommon.h"
#include <vector>
#include <memory>
#include "eax_presets.h"
#include "eax_props.h" 
#include <algorithm>

#ifndef IID_IDirectSound3DBuffer8
#define IID_IDirectSound3DBuffer8 IID_IDirectSound3DBuffer
#endif

#ifndef IID_IDirectSound3DListener8
#define IID_IDirectSound3DListener8 IID_IDirectSound3DListener
#endif

#undef DBUG_WARN
#define DBUG_WARN DSND_WARN

using std::to_string;
class __DirectSound8
{
    STDMETHOD(QueryInterface)        (THIS_ REFIID, LPVOID*) PURE;
    STDMETHOD_(ULONG, AddRef)        (THIS) PURE;
    STDMETHOD_(ULONG, Release)       (THIS) PURE;

    // IDirectSound methods
    STDMETHOD(CreateSoundBuffer)    (THIS_ LPCDSBUFFERDESC pcDSBufferDesc, LPDIRECTSOUNDBUFFER* ppDSBuffer, LPUNKNOWN pUnkOuter) PURE;
    STDMETHOD(GetCaps)              (THIS_ LPDSCAPS pDSCaps) PURE;
    STDMETHOD(DuplicateSoundBuffer) (THIS_ LPDIRECTSOUNDBUFFER pDSBufferOriginal, LPDIRECTSOUNDBUFFER* ppDSBufferDuplicate) PURE;
    STDMETHOD(SetCooperativeLevel)  (THIS_ HWND hwnd, DWORD dwLevel) PURE;
    STDMETHOD(Compact)              (THIS) PURE;
    STDMETHOD(GetSpeakerConfig)     (THIS_ LPDWORD pdwSpeakerConfig) PURE;
    STDMETHOD(SetSpeakerConfig)     (THIS_ DWORD dwSpeakerConfig) PURE;
    STDMETHOD(Initialize)           (THIS_ LPCGUID pcGuidDevice) PURE;
    // IDirectSound8 methods
    STDMETHOD(VerifyCertification)  (THIS_ LPDWORD pdwCertified) PURE;
};

class DirectSound8 : virtual public IDirectSound8 //__DirectSound8
{
public:
    // IUnknown methods    
    UNREFDOBJECTIUNKNOWN

#undef  LAYER_THIS
#define LAYER_THIS IDirectSound
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectSound
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

    // IDirectSound methods    
    STDMETHOD(CreateSoundBuffer)  (THIS_ LPCDSBUFFERDESC pcDSBufferDesc, LPDIRECTSOUNDBUFFER* ppDSBuffer, LPUNKNOWN pUnkOuter);
    STDMETHOD(GetCaps) (THIS_ LPDSCAPS);    
    STDMETHOD(DuplicateSoundBuffer) (THIS_ LPDIRECTSOUNDBUFFER, LPDIRECTSOUNDBUFFER*) ;
    COM_FOWARD(SetCooperativeLevel, HWND, DWORD);
    COM_FOWARD(Compact);
    COM_FOWARD(GetSpeakerConfig, LPDWORD);
    COM_FOWARD(SetSpeakerConfig, DWORD);    
    COM_FOWARD(Initialize, LPCGUID);

#undef  LAYER_THIS
#define LAYER_THIS IDirectSound8
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectSound8
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"  

    // IDirectSound8 methods
    COM_FOWARD(VerifyCertification, LPDWORD);
    DirectSound8(IUnknown* ds, DWORD flags) 
    {
        m_Imp  = ds;
        m_ref  = new SYNC::Atomic();
        m_lock = new SYNC::AtomicLock();
        m_ref->Set(1);
        m_EAXListener.Init();
        m_Flags = flags;
        m_Listener.flRolloffFactor = DS3D_DEFAULTROLLOFFFACTOR;
    }
    void BufferDeleted(IUnknown*i)
    {
        m_lock->lock();
        auto found = find(m_HWBuffs.begin(), m_HWBuffs.end(), i);
        if (found != m_HWBuffs.end()) m_HWBuffs.erase(found);
        m_HWBuffsCount = m_HWBuffs.size();
        if (m_HWBuffsCount > m_MaxHWBuffers) m_HWBuffsCount = m_MaxHWBuffers;
        m_lock->unlock();
        m_ref->Decrement();
    }
    void BufferCreated(IUnknown* i)
    {
        m_ref->Increment();
    }
    void AppendBuffer(IUnknown* i, wchar_t * caller)
    {
        m_lock->lock();
        auto found = find(m_HWBuffs.begin(), m_HWBuffs.end(), i);
        if (found != m_HWBuffs.end()) m_HWBuffs.erase(found);
        m_HWBuffs.push_back(i);
        m_HWBuffsCount = m_HWBuffs.size();
        if (m_HWBuffsCount > m_MaxHWBuffers) m_HWBuffsCount = m_MaxHWBuffers;
        m_lock->unlock();
    }
    void GetEAX10Props(EAX_REVERBPROPERTIES * props)
    {
        return m_EAXListener.GetEAX10Props(props);
    }
    unique_ptr <EAX_REVERBPROPERTIES> GetEAX10Props()
    {
        return m_EAXListener.GetEAX10Props();
    }    
    unique_ptr <EAX20LISTENERPROPERTIES> GetEAX20Props()
    {
        return m_EAXListener.GetEAX20Props();
    }
    unique_ptr <EAX30LISTENERPROPERTIES> GetEAX30Props()
    {
        return m_EAXListener.GetEAX30Props();
    }
    void SetEAXVersion(UINT ver) {
        m_lock->lock(); m_UsingEAX = ver; m_lock->unlock();
        DSND_WARN((string("USING EAX ") + std::to_string(ver)).c_str());
    }
    unique_ptr <float[]> GetPosition()
    {
        auto pos = unique_ptr<float[]>(new float[3]);
        m_lock->lock();
        memcpy(pos.get(), &m_Listener.vPosition, sizeof(float) * 3);
        m_lock->unlock();
        return pos;
    }
    void SetPosition(float pos[3])
    {
        if ((float*)pos == nullptr)
        {
            DSND_WARN("nullptr");
            return;
        }
        m_lock->lock();
        memcpy(&m_Listener.vPosition, pos, sizeof(float) * 3);
        m_lock->unlock();
    }
    float GetRollOff()
    {
        float rolloff;
        m_lock->cpy(&rolloff, &m_Listener.flRolloffFactor, sizeof(float));
        return rolloff;
    }
    void SetRollOff(float rolloff)
    {
        float r = rolloff;
        m_lock->cpy(&m_Listener.flRolloffFactor, &r, sizeof(float));
    }
    void UpdateFX();
    void lock()   { m_lock->lock();   }
    void unlock() { m_lock->unlock(); }    
    UINT GetEaxVersion()
    {
        m_lock->lock();
        UINT eax = m_UsingEAX;
        m_lock->unlock();
        return eax;
    }
    EaxListener* EAX() {return &m_EAXListener;}
private:   
    static const UINT  m_MaxHWBuffers = 128;
    IUnknown         * m_Imp          = nullptr;
    SYNC::Atomic     * m_ref          = nullptr;
    SYNC::AtomicLock * m_lock         = nullptr;
    UINT               m_HWBuffsCount = 0;
    DWORD              m_Flags        = 0;
    DWORD              m_UsingEAX     = 0;
    DS3DLISTENER       m_Listener     = {sizeof(DS3DLISTENER), {0.f,0.f,0.f}}; /* rolloff initiated on constructor */
    std::vector<IUnknown*>  m_HWBuffs;    
    EaxListener        m_EAXListener;
};

class DirectSound3DListener8
{
    public:

    // IUnknown methods
    STDMETHOD(QueryInterface)           (THIS_ REFIID, LPVOID*) PURE;
    STDMETHOD_(ULONG, AddRef)           (THIS) PURE;
    STDMETHOD_(ULONG, Release)          (THIS) PURE;

    // IDirectSound3DListener methods
    STDMETHOD(ListenerGetAllParameters)         (THIS_ LPDS3DLISTENER pListener) PURE;
    STDMETHOD(ListenerGetDistanceFactor)        (THIS_ D3DVALUE * pflDistanceFactor) PURE;
    STDMETHOD(ListenerGetDopplerFactor)         (THIS_ D3DVALUE * pflDopplerFactor) PURE;
    STDMETHOD(ListenerGetOrientation)           (THIS_ D3DVECTOR * pvOrientFront, D3DVECTOR * pvOrientTop) PURE;
    STDMETHOD(ListenerGetPosition)              (THIS_ D3DVECTOR * pvPosition) PURE;
    STDMETHOD(ListenerGetRolloffFactor)         (THIS_ D3DVALUE * pflRolloffFactor) PURE;
    STDMETHOD(ListenerGetVelocity)              (THIS_ D3DVECTOR * pvVelocity) PURE;
    STDMETHOD(ListenerSetAllParameters)         (THIS_ LPCDS3DLISTENER pcListener, DWORD dwApply) PURE;
    STDMETHOD(ListenerSetDistanceFactor)        (THIS_ D3DVALUE flDistanceFactor, DWORD dwApply) PURE;
    STDMETHOD(ListenerSetDopplerFactor)         (THIS_ D3DVALUE flDopplerFactor, DWORD dwApply) PURE;
    STDMETHOD(ListenerSetOrientation)           (THIS_ D3DVALUE, D3DVALUE, D3DVALUE, D3DVALUE, D3DVALUE, D3DVALUE, DWORD) PURE;
    STDMETHOD(ListenerSetPosition)              (THIS_ D3DVALUE x, D3DVALUE y, D3DVALUE z, DWORD dwApply) PURE;
    STDMETHOD(ListenerSetRolloffFactor)         (THIS_ D3DVALUE flRolloffFactor, DWORD dwApply) PURE;
    STDMETHOD(ListenerSetVelocity)              (THIS_ D3DVALUE x, D3DVALUE y, D3DVALUE z, DWORD dwApply) PURE;
    STDMETHOD(ListenerCommitDeferredSettings)   (THIS) PURE;
};

class DirectSoundBuffer8 : virtual public IDirectSoundBuffer8, virtual public IDirectSound3DBuffer8,
                           virtual public DirectSound3DListener8, virtual public IKsPropertySet, virtual public IDirectSoundNotify
{
public:
    // IUnknown methods    
    virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppvObj);             
    virtual ULONG STDMETHODCALLTYPE AddRef()  { m_ref->Increment(); return m_Imp->AddRef(); }
    virtual ULONG STDMETHODCALLTYPE Release() 
    { 
        m_parent->lock();
        UINT ref = m_Imp->Release(); 
        if (m_ref->Decrement() == 0)
        {
            m_parent->unlock();
            m_parent->BufferDeleted(dynamic_cast<IDirectSoundBuffer8*>(this));
            delete this;
        } else m_parent->unlock();       
        return ref;         
    }

#undef  LAYER_THIS
#define LAYER_THIS IDirectSoundBuffer
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectSoundBuffer
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   

    // IDirectSoundBuffer methods    
    STDMETHOD(GetCaps) (THIS_ LPDSBCAPS);
    COM_FOWARD(GetCurrentPosition, LPDWORD, LPDWORD);
    COM_FOWARD(GetFormat, LPWAVEFORMATEX, DWORD, LPDWORD);
    STDMETHOD(GetVolume) (THIS_ LPLONG pV) {
        LAYER_LOG_CALL
        if (pV == nullptr)
        {
            return DSERR_INVALIDPARAM;
        }
        m_lock->cpy(pV, &m_SetVolume, sizeof(LONG));
    }
    STDMETHOD(GetPan) (THIS_ LPLONG pPan) {
        LAYER_LOG_CALL
        if (pPan == nullptr)
        {
            return DSERR_INVALIDPARAM;
        }
        m_lock->cpy(pPan, &m_SetPan, sizeof(LONG));
    }
    COM_FOWARD(GetFrequency, LPDWORD);   
    COM_FOWARD(GetStatus, LPDWORD);
    COM_FOWARD(Initialize, LPDIRECTSOUND, LPCDSBUFFERDESC);
    STDMETHOD(Lock) (THIS_ DWORD dwOffset, DWORD dwBytes, LPVOID* ppvAudioPtr1, LPDWORD pdwAudioBytes1,
                                                          LPVOID* ppvAudioPtr2, LPDWORD pdwAudioBytes2, DWORD dwFlags) 
    {
        COM_FOWARD_CALL(Lock, dwOffset, dwBytes, ppvAudioPtr1, pdwAudioBytes1, ppvAudioPtr2, pdwAudioBytes2, dwFlags)
    }
    STDMETHOD(Play) (THIS_ DWORD, DWORD, DWORD);
    COM_FOWARD(SetCurrentPosition, DWORD);
    COM_FOWARD(SetFormat, LPCWAVEFORMATEX);    
    STDMETHOD(SetVolume) (THIS_ LONG v) {
        LAYER_LOG_CALL       
        LAYER_GETIMP(IDirectSoundBuffer, DSERR_GENERIC);
        HRESULT hr = imp->SetVolume(v);
        if (S_OK == hr)
        {
            LONG V = v;
            m_lock->cpy(&m_SetVolume, &V, sizeof(LONG));
        }
        return hr;
    }
    STDMETHOD(SetPan) (THIS_ LONG p) {
        LAYER_LOG_CALL
        LAYER_GETIMP(IDirectSoundBuffer, DSERR_GENERIC);
        HRESULT hr = imp->SetPan(p);
        if (S_OK == hr || (DSERR_CONTROLUNAVAIL == hr && m_desc.dwFlags & DSBCAPS_CTRLPAN && -10000 <= p && 10000 >= p))
        {          
            LONG P = p;
            m_lock->cpy(&m_SetPan, &P, sizeof(LONG));
            return 0;
        }
        return hr;
    }
    COM_FOWARD(SetFrequency, DWORD);    
    COM_FOWARD(Stop);
    COM_FOWARD(Unlock, LPVOID, DWORD, LPVOID, DWORD);
    COM_FOWARD(Restore)

#undef  LAYER_THIS
#define LAYER_THIS IDirectSoundBuffer8
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectSoundBuffer8

    // IDirectSoundBuffer8 methods
    COM_FOWARD(SetFX, DWORD, LPDSEFFECTDESC, LPDWORD);
    COM_FOWARD(AcquireResources, DWORD, DWORD, LPDWORD);
    COM_FOWARD(GetObjectInPath, REFGUID, DWORD, REFGUID, LPVOID*);

#undef  LAYER_THIS
#define LAYER_THIS IDirectSound3DBuffer8
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectSound3DBuffer8

    // IDirectSound3DBuffer methods
    COM_FOWARD(GetAllParameters, LPDS3DBUFFER);
    COM_FOWARD(GetConeAngles, LPDWORD, LPDWORD);
    COM_FOWARD(GetConeOrientation, D3DVECTOR*);
    COM_FOWARD(GetConeOutsideVolume, LPLONG);
    COM_FOWARD(GetMaxDistance, D3DVALUE*);
    COM_FOWARD(GetMinDistance, D3DVALUE*);
    COM_FOWARD(GetMode, LPDWORD);
    COM_FOWARD(GetPosition, D3DVECTOR*);
    COM_FOWARD(GetVelocity, D3DVECTOR*);
    COM_FOWARD(SetAllParameters, LPCDS3DBUFFER, DWORD);
    COM_FOWARD(SetConeAngles, DWORD, DWORD, DWORD);
    COM_FOWARD(SetConeOrientation, D3DVALUE, D3DVALUE, D3DVALUE, DWORD);
    COM_FOWARD(SetConeOutsideVolume, LONG, DWORD);    
    STDMETHOD(SetMaxDistance) (THIS_ D3DVALUE d, DWORD commit)
    {
        LAYER_LOG_CALL        
        LAYER_GETIMP(IDirectSound3DBuffer, DSERR_GENERIC); 
        if (d == 0.0) d = DS3D_DEFAULTMAXDISTANCE;
        LAYER_HR_CALL(imp->SetMaxDistance(d, commit))
    }    
    STDMETHOD(SetMinDistance) (THIS_ D3DVALUE d, DWORD commit)
    {
        LAYER_LOG_CALL
        LAYER_GETIMP(IDirectSound3DBuffer, DSERR_GENERIC);    
        if (d == 0.0) d = DS3D_DEFAULTMAXDISTANCE - 1.f;
        LAYER_HR_CALL(imp->SetMinDistance(d, commit))
    }
    COM_FOWARD(SetMode, DWORD, DWORD);
    STDMETHOD(SetPosition) (THIS_ D3DVALUE x, D3DVALUE y, D3DVALUE z, DWORD flags)
    {
        LAYER_LOG_CALL
        LAYER_GETIMP(IDirectSound3DBuffer, DSERR_GENERIC);        
        HRESULT hr = imp->SetPosition(x, y, z, flags);
        if (S_OK == hr)
        {
            DWORD eax = m_parent->GetEaxVersion();
            if      (eax == 1) ApplyEffects(m_parent->GetEAX10Props().get());
            else if (eax == 2) ApplyEffects2(m_parent->GetEAX20Props().get());            
            else if (eax == 3) ApplyEffects3(m_parent->GetEAX30Props().get());
        }
        return hr;
    }
    COM_FOWARD(SetVelocity, D3DVALUE, D3DVALUE, D3DVALUE, DWORD);

#undef  LAYER_THIS
#define LAYER_THIS DirectSound3DListener8
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectSound3DListener8

    COM_FOWARD(ListenerGetAllParameters, LPDS3DLISTENER);
    COM_FOWARD(ListenerGetDistanceFactor, D3DVALUE*);
    COM_FOWARD(ListenerGetDopplerFactor, D3DVALUE*);
    COM_FOWARD(ListenerGetOrientation, D3DVECTOR*, D3DVECTOR*);
    COM_FOWARD(ListenerGetPosition, D3DVECTOR*);
    COM_FOWARD(ListenerGetRolloffFactor, D3DVALUE*);
    COM_FOWARD(ListenerGetVelocity, D3DVECTOR*);
    COM_FOWARD(ListenerSetAllParameters, LPCDS3DLISTENER, DWORD);
    COM_FOWARD(ListenerSetDistanceFactor, D3DVALUE, DWORD);
    COM_FOWARD(ListenerSetDopplerFactor, D3DVALUE, DWORD);
    STDMETHOD(ListenerSetOrientation) (THIS_ D3DVALUE xFront, D3DVALUE yFront, D3DVALUE zFront,
                                       D3DVALUE xTop, D3DVALUE yTop, D3DVALUE zTop, DWORD dwApply)
    {
        COM_FOWARD_CALL(ListenerSetOrientation, xFront, yFront, zFront, zFront, yTop, zTop, dwApply)
    }
    STDMETHOD(ListenerSetPosition)(THIS_ D3DVALUE, D3DVALUE, D3DVALUE, DWORD);
    STDMETHOD(ListenerSetRolloffFactor)(THIS_ D3DVALUE r, DWORD flags)
    {
        LAYER_LOG_CALL;
        LAYER_GETIMP(IDirectSound3DListener, DSERR_GENERIC);        
        HRESULT hr = imp->SetRolloffFactor(r, flags);
        if (S_OK  == hr && flags == DS3D_IMMEDIATE) m_parent->SetRollOff(r);
        else DSND_WARN("FAILED");
        return hr;
    }
    COM_FOWARD(ListenerSetVelocity, D3DVALUE, D3DVALUE, D3DVALUE, DWORD);    
    STDMETHOD(ListenerCommitDeferredSettings)(THIS_);


#undef  LAYER_THIS
#define LAYER_THIS IDirectSoundNotify
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectSoundNotify
    //IDirectSoundNotify
    COM_FOWARD(SetNotificationPositions, DWORD, LPCDSBPOSITIONNOTIFY);

    // IKsPropertySet
    STDMETHOD(Get) (THIS_  REFGUID, ULONG, LPVOID, ULONG, LPVOID, ULONG, PULONG);
    STDMETHOD(Set) (THIS_  REFGUID, ULONG ,LPVOID, ULONG, LPVOID, ULONG);
    STDMETHOD(QuerySupport) (THIS_ REFGUID, ULONG, PULONG);

    std::unique_ptr<DSBCAPS> Caps();    
    BOOL IsPrimaryBuffer() {return Caps().get()->dwFlags & DSBCAPS_PRIMARYBUFFER ? TRUE : FALSE;}
    HRESULT Duplicate(IDirectSound*, DirectSound8*, IDirectSoundBuffer**);
    float ComputeDistance();
    float ComputeReverbMix();
    void ApplyEffects(EAX_REVERBPROPERTIES*);
    DWORD UpdateEffects(EAX_REVERBPROPERTIES*);
    void ApplyEffects2(EAX20LISTENERPROPERTIES*);
    DWORD UpdateEffects2(EAX20LISTENERPROPERTIES*);
    void ApplyEffects3(EAX30LISTENERPROPERTIES*);
    DWORD UpdateEffects3(EAX30LISTENERPROPERTIES*);
    DirectSoundBuffer8(IUnknown* ds, DirectSound8* parent, LPCDSBUFFERDESC desc)
    {
        m_Imp    = ds;
        m_ref    = new SYNC::Atomic();
        m_lock   = new SYNC::AtomicLock();
        m_parent = parent;
        m_ref->Set(1);
        m_EAXVoice.Init();
        memcpy((void*)&m_desc, desc, desc->dwSize);               
        m_parent->BufferCreated((IUnknown*)dynamic_cast<IDirectSoundBuffer8*>(this));
    }
    /*
    unique_ptr<EAX20BUFFERPROPERTIES> GetEAX2Props()
    {
        return m_EAXVoice.GetEAX2Props();
    }
    void SetEAX2Props(EAX20BUFFERPROPERTIES * p)
    {
        return m_EAXVoice.SetEAX2Props(p);
    }  
    */
    virtual ~DirectSoundBuffer8()
    {
        delete m_ref;     
        delete m_lock;
    }
private:
    DirectSound8        * m_parent     = nullptr;
    IUnknown            * m_Imp        = nullptr;
    SYNC::Atomic        * m_ref        = nullptr;
    SYNC::AtomicLock    * m_lock       = nullptr;    
    const DSBUFFERDESC  m_desc         = {};        
    LONG                m_SetPan       = DSBPAN_CENTER;
    LONG                m_SetVolume    = DSBVOLUME_MAX;                   
    DS3DBUFFER          m_DS3DBuffer   = {sizeof(DS3DBUFFER), {0., 0. ,0.}, {0., 0. ,0.}, DS3D_DEFAULTCONEANGLE, DS3D_DEFAULTCONEANGLE, {0., 360.f, 360.f}, 
                                          DS3D_DEFAULTCONEOUTSIDEVOLUME, DS3D_DEFAULTMINDISTANCE, DS3D_DEFAULTMAXDISTANCE, DS3DMODE_NORMAL};
    EAXVoice            m_EAXVoice;
};

#endif // DIRECTSOUND_H
