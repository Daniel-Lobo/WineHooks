#include <windows.h>
#include <dsound.h>
#include "DirectSound.h"
#include <dllmain.h>
#include "Sync.h"
#include <string>
#include "sethooks.h"
#include "EZString.h"
#include <unknwn.h>
#include <memory.h>
#include "eax.h"
#include <math.h>

HRESULT STDMETHODCALLTYPE DirectSound8::QueryInterface(REFIID riid, void** ppvObj)
{
    LAYER_LOG_CALL
    wchar_t* szGUID[64] = { 0 };
    if (StringFromGUID2(riid, (LPOLESTR)szGUID, 64))
    {
        DSoundGlobals.m_loger.log(L"DirectSound8::QueryInterface", (wchar_t*)szGUID);
    }

    if      (riid == GUID_NULL    || ppvObj == nullptr || this == nullptr) return DSERR_INVALIDPARAM;
    else if (riid == IID_IUnknown || riid == IID_IDirectSound)            *ppvObj = dynamic_cast<IDirectSound8*>(this);
    else if (riid == IID_IDirectSound8)
    {
        // Handle DSound1 interfaces 
        *ppvObj = dynamic_cast<IDirectSound8*>(this);;
    }
    else
    {
        DSND_WARN("E_NOINTERFACE");
        return E_NOINTERFACE;
    }
    AddRef();
    return 0;
}

HRESULT STDMETHODCALLTYPE DirectSound8::GetCaps(LPDSCAPS caps)
{
    LAYER_LOG_CALL
    IDirectSound8* dsnd = (IDirectSound8*)EZInterface(IID_IDirectSound, m_Imp).I();
    if (dsnd == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return DSERR_GENERIC;
    }    
    HRESULT hr = dsnd->GetCaps(caps);
    if (hr == 0)
    {
        std::wstring cps = L"Flags: "              + HEXString(caps->dwFlags).s.str() + L"\n";
        cps += L"dwMaxHwMixingAllBuffers: "        + HEXString(caps->dwMaxHwMixingAllBuffers).s.str() + L"\n";
        cps += L"dwMaxHwMixingStaticBuffers: "     + HEXString(caps->dwMaxHwMixingStaticBuffers).s.str() + L"\n";
        cps += L"dwMaxHwMixingStreamingBuffers: "  + HEXString(caps->dwMaxHwMixingStreamingBuffers).s.str() + L"\n";
        cps += L"dwFreeHwMixingAllBuffers: "       + HEXString(caps->dwFreeHwMixingAllBuffers).s.str() + L"\n";
        cps += L"dwFreeHwMixingStaticBuffers: "    + HEXString(caps->dwFreeHwMixingStaticBuffers).s.str() + L"\n";
        cps += L"dwFreeHwMixingStreamingBuffers: " + HEXString(caps->dwFreeHwMixingStreamingBuffers).s.str() + L"\n";
        cps += L"dwMaxHw3DAllBuffers: "            + HEXString(caps->dwMaxHw3DAllBuffers).s.str() + L"\n";
        cps += L"dwMaxHw3DStaticBuffers: "         + HEXString(caps->dwMaxHw3DStaticBuffers).s.str() + L"\n";
        cps += L"dwMaxHw3DStreamingBuffers: "      + HEXString(caps->dwMaxHw3DStreamingBuffers).s.str() + L"\n";
        cps += L"dwFreeHw3DAllBuffers: "           + HEXString(caps->dwFreeHw3DAllBuffers).s.str() + L"\n";
        cps += L"dwFreeHw3DStaticBuffers: "        + HEXString(caps->dwFreeHw3DStaticBuffers).s.str() + L"\n";
        cps += L"dwFreeHw3DStreamingBuffers: "     + HEXString(caps->dwFreeHw3DStreamingBuffers).s.str() + L"\n";
        cps += L"dwTotalHwMemBytes: "              + HEXString(caps->dwTotalHwMemBytes).s.str() + L"\n";
        cps += L"dwFreeHwMemBytes: "               + HEXString(caps->dwFreeHwMemBytes).s.str() + L"\n";
        //DSoundGlobals.m_loger.log(__FUNCTIONW__, cps.c_str());

        {
            UINT buffcount = 0;
            m_lock->lock();
            buffcount = m_HWBuffsCount;
            m_lock->unlock();            
            caps->dwMaxHwMixingAllBuffers        = DirectSound8::m_MaxHWBuffers;
            caps->dwMaxHwMixingStaticBuffers     = DirectSound8::m_MaxHWBuffers;
            caps->dwMaxHwMixingStreamingBuffers  = DirectSound8::m_MaxHWBuffers;
            caps->dwFreeHwMixingAllBuffers       = DirectSound8::m_MaxHWBuffers - buffcount;
            caps->dwFreeHwMixingStaticBuffers    = DirectSound8::m_MaxHWBuffers - buffcount;
            caps->dwFreeHwMixingStreamingBuffers = DirectSound8::m_MaxHWBuffers - buffcount;
            caps->dwMaxHw3DAllBuffers            = DirectSound8::m_MaxHWBuffers;
            caps->dwMaxHw3DStaticBuffers         = DirectSound8::m_MaxHWBuffers;
            caps->dwMaxHw3DStreamingBuffers      = DirectSound8::m_MaxHWBuffers;
            caps->dwFreeHw3DAllBuffers           = DirectSound8::m_MaxHWBuffers - buffcount;
            caps->dwFreeHw3DStaticBuffers        = DirectSound8::m_MaxHWBuffers - buffcount;
            caps->dwFreeHw3DStreamingBuffers     = DirectSound8::m_MaxHWBuffers - buffcount;
            caps->dwFreeHwMemBytes          = 128000000;
            caps->dwTotalHwMemBytes         = 128000000;
            caps->dwMaxContigFreeHwMemBytes = 128000000;
        }
    } 
    return hr;
}

HRESULT STDMETHODCALLTYPE DirectSound8::CreateSoundBuffer(LPCDSBUFFERDESC pcDSBufferDesc, LPDIRECTSOUNDBUFFER* ppDSBuffer, LPUNKNOWN pUnkOuter)
{
    LAYER_LOG_CALL
    IDirectSound* dsnd = (IDirectSound*)EZInterface(IID_IDirectSound, m_Imp).I();    

    if (dsnd == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return DSERR_GENERIC;
    }
    if (pcDSBufferDesc == nullptr)    
    {     
        return DSERR_INVALIDPARAM;
    }
    if (pcDSBufferDesc->lpwfxFormat == nullptr && ((pcDSBufferDesc->dwFlags & DSBCAPS_PRIMARYBUFFER) == 0))
    {
        return DSERR_INVALIDPARAM;
    }    
    
    HRESULT hr  = DSERR_GENERIC;
    DWORD flags = pcDSBufferDesc->dwFlags;    
    {
        DSBUFFERDESC newdesc = {};
        WAVEFORMATEX wave    = {};
        memcpy(&newdesc, pcDSBufferDesc, pcDSBufferDesc->dwSize);
        newdesc.dwSize = sizeof(DSBUFFERDESC);
        if (pcDSBufferDesc->lpwfxFormat != nullptr)
        {
            memcpy(&wave, pcDSBufferDesc->lpwfxFormat, sizeof(WAVEFORMATEX));
            newdesc.lpwfxFormat = &wave;
        }       
        if (0 == (flags & DSBCAPS_PRIMARYBUFFER)) /* Non primary buffers, 3D or not */
        {
            newdesc.dwFlags &= ~DSBCAPS_LOCHARDWARE;
            newdesc.dwFlags &= ~DSBCAPS_LOCDEFER;
            newdesc.dwFlags |= DSBCAPS_LOCSOFTWARE;
        }
        if (flags & DSBCAPS_CTRL3D)
        {
            if (flags & DSBCAPS_CTRLPAN)
            {
                DSND_WARN("NO PAN");
                newdesc.dwFlags &= ~DSBCAPS_CTRLPAN;
            }
            if (0 == (flags & DSBCAPS_PRIMARYBUFFER))
            {    
                newdesc.guid3DAlgorithm = DS3DALG_NO_VIRTUALIZATION;                  
                if (pcDSBufferDesc->lpwfxFormat->wBitsPerSample > 16)
                {
                    DSND_WARN("BAD SAMPLE SIZE: 3D BUFFER CREATION WILL FAIL");
                }
                if (DSBufferDescMillisecods(&newdesc) < 150.f)
                {                    
                    DSND_LOG((std::string("BUFFER TOO SHORT FOREFFECTS: ")+std::to_string(DSBufferDescMillisecods(&newdesc))).c_str())
                } 
                else 
                {
                    newdesc.dwFlags |= DSBCAPS_CTRLFX;
                    if (flags & DSBCAPS_STATIC)
                    {
                        DSND_LOG("NO STATIC");
                        newdesc.dwFlags &= ~DSBCAPS_STATIC;
                    }
                    if (flags & DSBCAPS_CTRLFREQUENCY)
                    {
                        DSND_LOG("NO CTRLFREQUENCY");
                        // Documentations says DSBCAPS_CTRLFREQUENCY can be used with DSBCAPS_CTRLFX, but it can
                        // newdesc.dwFlags &= ~DSBCAPS_CTRLFREQUENCY;
                    }
                }                
                if (pcDSBufferDesc->lpwfxFormat->nChannels == 2)
                {
                    if ((flags & DSBCAPS_PRIMARYBUFFER) == 0) /* The primary is not lockable for games using 3D audio */
                    {
                        DSND_WARN("STEREO 3D BUFF ")
                        newdesc.lpwfxFormat->nSamplesPerSec *= 2;
                        newdesc.lpwfxFormat->nBlockAlign    /= 2;
                    }
                    newdesc.lpwfxFormat->nChannels = 1;
                    if (newdesc.lpwfxFormat->nSamplesPerSec > 44100)
                    {
                        DSND_WARN("TOO HIGH SAMPLE RATE: 3D BUFFER CREATION WILL FAIL");
                    }
                }
            }           
        }  
        hr = dsnd->CreateSoundBuffer(&newdesc, ppDSBuffer, pUnkOuter);
        if (S_OK != hr)
        {
            DSND_WARN((string("3D BUFFER CREATION FAILED: ") + DSndGetErrString(hr, 0) + "Flags: " +
                       HEXStringA(newdesc.dwFlags).s.str().c_str() + " " + HEXStringA(flags).s.str().c_str() + " " +
                       std::to_string(DSBufferDescMillisecods(&newdesc)) + " " + std::to_string(DSBSIZE_FX_MIN)).c_str());
            hr = dsnd->CreateSoundBuffer(pcDSBufferDesc, ppDSBuffer, pUnkOuter);            
        }
    }   

    if (S_OK != hr) 
    {
        DSND_WARN((string("BUFFER CREATION FAILED: ") + DSndGetErrString(hr, 0) + HEXStringA(flags).s.str().c_str()).c_str());        
        return hr;
    }

    DSND_WARN("DS_OK");
    auto Dsnd8  = new DirectSoundBuffer8(*ppDSBuffer, this, pcDSBufferDesc);
    *ppDSBuffer = dynamic_cast<IDirectSoundBuffer*>(Dsnd8); 
       
    if (flags & DSBCAPS_PRIMARYBUFFER)
    {
        m_lock->lock(); m_UsingEAX = 0; m_lock->unlock();
    }
    else if (flags & DSBCAPS_LOCHARDWARE | DSBCAPS_CTRL3D)
    {
        AppendBuffer((IUnknown*)dynamic_cast<IDirectSoundBuffer8*>(Dsnd8), L"DirectSound8::CreateSoundBuffer");
    } 
     DSND_WARN("__DS_OK");  
    return hr;
}

void DirectSound8::UpdateFX() 
{
    std::vector<DirectSoundBuffer8*> Buffs;
    DirectSoundBuffer8 * buff    = nullptr;
    auto eax                     = GetEAX10Props();
    auto eax2                    = GetEAX20Props();
    auto eax3                    = GetEAX30Props();
    UINT eaxflags                = 0;
    
    m_lock->lock();    
    eaxflags = m_UsingEAX;    
    if (m_HWBuffs.size() == 0 || eaxflags == 0)
    {
        m_lock->unlock();
        return;
    }
    for (UINT i = 0; i < m_HWBuffs.size(); i++)
    {
        buff = dynamic_cast<DirectSoundBuffer8*>(m_HWBuffs[i]);
        buff->AddRef();
        Buffs.push_back(buff);
    }
    m_lock->unlock();    
    {
        for (UINT i = 0; i < Buffs.size(); i++)
        {
            buff = Buffs[i];
            if      (eaxflags == 1) buff->ApplyEffects(eax.get());
            else if (eaxflags == 2) buff->ApplyEffects2(eax2.get());
            else if (eaxflags == 3) buff->ApplyEffects3(eax3.get());
            buff->Release();
        }
    }
}

HRESULT STDMETHODCALLTYPE DirectSound8::DuplicateSoundBuffer(LPDIRECTSOUNDBUFFER Original, LPDIRECTSOUNDBUFFER* Duplicate)
{
    LAYER_LOG_CALL
    if (Original == nullptr || Duplicate == nullptr) return DSERR_INVALIDPARAM;

    IDirectSound* dsnd = (IDirectSound*)EZInterface(IID_IDirectSound, m_Imp).I();
    if (dsnd == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return DSERR_GENERIC;
    }    
    auto buff = dynamic_cast<DirectSoundBuffer8*>(Original);
    return buff->Duplicate(dsnd, this, Duplicate);    
}

HRESULT DuplicateSndBufer(IDirectSound* dsnd, IDirectSoundBuffer* old, IDirectSoundBuffer** pNewbuff)
{
    DSBCAPS caps      = { sizeof(DSBCAPS)      };
    DSBUFFERDESC desc = { sizeof(DSBUFFERDESC) };
    WAVEFORMATEX fmt  = {};
    DWORD         sz  = 0;
    LPVOID                 Src   = nullptr;
    LPVOID                 Dst   = nullptr;
    IDirectSoundBuffer * newbuff = nullptr;
    if (S_OK != old->GetCaps(&caps))
    {
        DSND_WARN("GetCaps FAILED");
        return 1;
    }
    if (S_OK != old->GetFormat(&fmt, sizeof(WAVEFORMATEX), &sz))
    {
        DSND_WARN("GetFormat FAILED");
        return 2;
    }
    desc.dwBufferBytes = caps.dwBufferBytes;
    desc.dwFlags       = caps.dwFlags;
    desc.lpwfxFormat   = &fmt;
    if (S_OK != dsnd->CreateSoundBuffer(&desc, &newbuff, nullptr))
    {
        DSND_WARN("CreateSoundBuffer FAILED");
        return 3;
    }

    if (S_OK == old->Lock(0, 0, &Src, &sz, nullptr, nullptr, DSBLOCK_ENTIREBUFFER))
    {
        if (S_OK == newbuff->Lock(0, 0, &Dst, &sz, nullptr, nullptr, DSBLOCK_ENTIREBUFFER))
        {
            memcpy(Dst, Src, (size_t)sz);
        }
        else 
        {
            old->Unlock(Src, 0, nullptr, 0);
            newbuff->Release();
            DSND_WARN("newbuff->lock() FAILED");
            return 4;
        }
    }
    else 
    {        
        newbuff->Release();
        DSND_WARN("old->lock() FAILED");
        return 4;
    }
    old->Unlock(Src, 0, nullptr, 0);
    newbuff->Unlock(Dst, sz, nullptr, 0);
    *pNewbuff = newbuff;

    LONG volume    = DSBVOLUME_MAX;          /* volume isn't duplicated; */
    DWORD freq     = DSBFREQUENCY_ORIGINAL;
    DS3DBUFFER pms = {sizeof(DS3DBUFFER)};    
    old->GetFrequency(&freq); 
    newbuff->SetFrequency(freq);

    IDirectSound3DBuffer8* old3D = (IDirectSound3DBuffer8*)EZInterface(IID_IDirectSound3DBuffer8, old).I();
    if (old3D == nullptr)
    {
        DSND_WARN("EZInterface::I(old3D) FAILED");    
        return 0;
    }
    IDirectSound3DBuffer8* new3D = (IDirectSound3DBuffer8*)EZInterface(IID_IDirectSound3DBuffer8, newbuff).I();
    if (new3D == nullptr)
    {
        DSND_WARN("EZInterface::Inew3D) FAILED");
        return 0;
    }
    old3D->GetAllParameters(&pms);  
    new3D->SetAllParameters(&pms, DS3D_IMMEDIATE);
}

HRESULT DirectSoundBuffer8::Duplicate(IDirectSound* dsn, DirectSound8* Dsnd, IDirectSoundBuffer** duplicate)
{
    IDirectSoundBuffer* sndbuff = (IDirectSoundBuffer*)EZInterface(IID_IDirectSoundBuffer, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return DSERR_GENERIC;
    }
    DWORD sizewriten  = 0;
    DSBUFFERDESC desc = {};
    WAVEFORMATEX fmt  = {};
    desc.lpwfxFormat  = &fmt;
    HRESULT hr        = sndbuff->GetFormat(&fmt, sizeof(WAVEFORMATEX), &sizewriten);
    if (S_OK != hr)
    {
        DSND_WARN("GetFormat FAILED");
        return hr;
    }
    memcpy(&desc, &m_desc, sizeof(DSBUFFERDESC));   
    
    hr = dsn->DuplicateSoundBuffer(sndbuff, duplicate);
    if (S_OK != hr)
    {
        if (Caps().get()->dwFlags & DSBCAPS_CTRLFX)
        {
            if (S_OK != DuplicateSndBufer(dsn, sndbuff, duplicate))
            {
                m_Imp->AddRef();
                auto ibuff = new DirectSoundBuffer8(m_Imp, Dsnd, &desc);
                *duplicate = dynamic_cast<IDirectSoundBuffer*>(ibuff);
            }
            else
            {
                auto ibuff = new DirectSoundBuffer8(*duplicate, Dsnd, &desc);
                *duplicate = dynamic_cast<IDirectSoundBuffer*>(ibuff);
            }
        }
        else
        {
            DSND_WARN("DuplicateSoundBuffer FAILED");
            return hr;
        }
    }
    else
    {
        auto ibuff = new DirectSoundBuffer8(*duplicate, Dsnd, &desc);
        *duplicate = dynamic_cast<IDirectSoundBuffer*>(ibuff);
    }    
    return 0;
}

HRESULT STDMETHODCALLTYPE DirectSoundBuffer8::GetCaps(LPDSBCAPS caps)
{
    LAYER_LOG_CALL
    if (caps         == nullptr)          return DSERR_INVALIDPARAM;
    if (caps->dwSize != sizeof(DSBCAPS))  return DSERR_INVALIDPARAM;
    memcpy(caps, Caps().get(), caps->dwSize);
    caps->dwFlags = m_desc.dwFlags;
    if (!(m_desc.dwFlags & DSBCAPS_LOCSOFTWARE) && !(m_desc.dwFlags & DSBCAPS_LOCDEFER))
    {
        caps->dwFlags           = DSBCAPS_LOCHARDWARE;
        caps->dwPlayCpuOverhead = 0;
    }
    return 0;
}

HRESULT STDMETHODCALLTYPE DirectSoundBuffer8::Play(DWORD dwReserved1, DWORD dwPriority, DWORD dwFlags)
{
    LAYER_LOG_CALL
    IDirectSoundBuffer* sndbuff = (IDirectSoundBuffer*)EZInterface(IID_IDirectSoundBuffer, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return DSERR_GENERIC;
    }
    if (0 != (m_desc.dwFlags & DSBCAPS_PRIMARYBUFFER))
    {
        LAYER_HR_CALL(sndbuff->Play(dwReserved1, 0, dwFlags));
    }
    if (dwFlags & DSBPLAY_LOCHARDWARE)
    {
        dwFlags &= ~DSBPLAY_LOCHARDWARE;     
        /* dwFlags |= DSBPLAY_LOCSOFTWARE; */
        m_parent->AppendBuffer((IUnknown*)dynamic_cast<IDirectSoundBuffer8*>(this), L"DirectSoundBuffer8::Play");
    }
    else if (dwFlags & DSBPLAY_LOCSOFTWARE)
    {
        dwFlags &= ~DSBPLAY_LOCSOFTWARE;        
    }    
    dwFlags &= ~DSBPLAY_TERMINATEBY_TIME;
    dwFlags &= ~DSBPLAY_TERMINATEBY_DISTANCE;
    dwFlags &= ~DSBPLAY_TERMINATEBY_PRIORITY;
    if ((m_desc.dwFlags & DSBCAPS_CTRL3D) && (Caps().get()->dwFlags & DSBCAPS_CTRLFX))
    {
        UINT     eaxflag = m_parent->GetEaxVersion();
        if      (eaxflag == 1) ApplyEffects(m_parent->GetEAX10Props().get());    
        else if (eaxflag == 2) ApplyEffects2(m_parent->GetEAX20Props().get());       
        else if (eaxflag == 3) ApplyEffects3(m_parent->GetEAX30Props().get());
    }
   
    auto hr = sndbuff->Play(dwReserved1, 0, dwFlags);
    if (FAILED(hr))
    {
        DSND_WARN((std::string("FAILED ") + HEXStringA((DWORD)hr).s.str() + " " + DSndGetErrString(hr, 0) + " Flags: " + HEXStringA((DWORD)dwFlags).s.str()).c_str());
        hr = sndbuff->Play(dwReserved1, 0, 0);
        if (FAILED(hr))
            DSND_WARN((std::string("(dwFlags=0) FAILED ") + HEXStringA((DWORD)hr).s.str() + " " + DSndGetErrString(hr, 0)).c_str());
    }
    return hr;
}

HRESULT STDMETHODCALLTYPE DirectSoundBuffer8::QueryInterface(REFIID riid, void** ppvObj)
{
    LAYER_LOG_CALL
    wchar_t* szGUID[64] = { 0 };
    if (StringFromGUID2(riid, (LPOLESTR)szGUID, 64))
    {
        //DSoundGlobals.m_loger.log(__FUNCTIONW__, (wchar_t*)szGUID);
    }
    
    if      (riid == GUID_NULL    || ppvObj == nullptr              || this == nullptr)                  return DSERR_INVALIDPARAM;
    else if (riid == IID_IUnknown || riid == IID_IDirectSoundBuffer || riid == IID_IDirectSoundBuffer8) *ppvObj = dynamic_cast<IDirectSoundBuffer8*>(this);
    else if (riid == IID_IDirectSoundNotify)                                                            *ppvObj = dynamic_cast<IDirectSoundNotify*>(this);
    else if ((Caps().get()->dwFlags & DSBCAPS_CTRL3D) == 0)                                              return E_NOINTERFACE;
    else if (riid == IID_IDirectSound3DListener8)
    {
        DSND_WARN("IID_IDirectSound3DListener8");
        if (IsPrimaryBuffer() == FALSE)
        {
            DSND_WARN("NO IDirectSound3DListener for secondary buffers");
            return E_NOINTERFACE;
        }
        *ppvObj = dynamic_cast<DirectSound3DListener8*>(this);
    }
    else if (riid == IID_IDirectSound3DBuffer8)
    {
        DSND_WARN("IID_IDirectSound3DBuffer8");
        if (IsPrimaryBuffer() == TRUE)
        {
            DSND_WARN("NO IDirectSound3DBuffer8 for primary buffers");
            return E_NOINTERFACE;
        }
        *ppvObj = dynamic_cast<IDirectSound3DBuffer8*>(this);
    }
    else if (riid == IID_IKsPropertySet)
    {
        DSND_WARN("IID_IKsPropertySet");
        if (IsPrimaryBuffer() == TRUE)
        {
            DSND_WARN("NO IKsPropertySet for primary buffers");
            return E_NOINTERFACE;
        }
        *ppvObj = dynamic_cast<IKsPropertySet*>(this);
    }
    else
    {
        DSND_WARN("E_NOINTERFACE");
        return E_NOINTERFACE;
    }
    AddRef();
    DSND_WARN("OK");
    return 0;
}

std::unique_ptr<DSBCAPS> DirectSoundBuffer8::Caps()
{
    auto caps                   = std::unique_ptr<DSBCAPS>(new DSBCAPS);
    caps.get()->dwSize          = sizeof(DSBCAPS);
    IDirectSoundBuffer* sndbuff = (IDirectSoundBuffer*)EZInterface(IID_IDirectSoundBuffer, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
    }
    else
    {
        if (sndbuff->GetCaps(caps.get()) != DS_OK)
        {
            DSND_WARN("GetCaps FAILED");
        }
    }    
    return caps;
}

HRESULT STDMETHODCALLTYPE DirectSoundBuffer8::ListenerCommitDeferredSettings()
{
    LAYER_LOG_CALL
    IDirectSound3DListener8* sndbuff = (IDirectSound3DListener8*)EZInterface(IID_IDirectSound3DListener8, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
    }
    HRESULT hr = sndbuff->CommitDeferredSettings();
    if (S_OK == hr)
    {
        DS3DLISTENER listener = {sizeof(DS3DLISTENER)};        
        if (sndbuff->GetAllParameters(&listener) != DS_OK)
        {
            DSND_WARN("GetAllParameters FAILED")
        }
        else
        {
            m_parent->SetPosition((float*)&listener.vPosition);
            m_parent->SetRollOff(listener.flRolloffFactor);
            m_parent->UpdateFX();
        }
    } else DSND_WARN("FAILED");
    return hr;
}

HRESULT STDMETHODCALLTYPE DirectSoundBuffer8::ListenerSetPosition(D3DVALUE x, D3DVALUE y, D3DVALUE z, DWORD dwApply)
{
    LAYER_LOG_CALL
    IDirectSound3DListener8* sndbuff = (IDirectSound3DListener8*)EZInterface(IID_IDirectSound3DListener8, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
    }
    HRESULT hr = sndbuff->SetPosition(x, y, z, dwApply);
    if (S_OK != hr)
    {
        DSND_WARN("FAILED");
        return S_OK;
    }
    if (dwApply == DS3D_IMMEDIATE)
    {
        float pos[3] = {x, y, z};
        m_parent->SetPosition(pos);
        m_parent->UpdateFX();
    }
    //DSND_WARN("Complete")
    return hr;
}

HRESULT STDMETHODCALLTYPE DirectSoundBuffer8::Get(REFGUID PropSet, ULONG id, LPVOID iData, ULONG iDataLength, LPVOID Data, ULONG DataLength, PULONG ByteCount)
{
    LAYER_LOG_CALL
    HRESULT hr = DSERR_INVALIDPARAM;
    if (PropSet == DSoundGlobals.EAX_10_listenerID)
    {
        hr = m_parent->EAX()->Get(id, iData, iDataLength, Data, DataLength, ByteCount);
        if (hr != S_OK) DSND_WARN("ERROR GETTING EAX 1.0 LISTENER PROPPERY")
        return hr;
    }
    else if (PropSet == DSoundGlobals.EAX_10_voiceID)
    {
        hr = m_EAXVoice.Get(id, iData, iDataLength, Data, DataLength, ByteCount);
        if (hr != S_OK) DSND_WARN("ERROR GETTING EAX 1.0 VOICE PROPPERY")
        return hr;
    }
    else if (PropSet == DSoundGlobals.EAX_20_listenerID)
    {
        hr = m_parent->EAX()->Get2(id, iData, iDataLength, Data, DataLength, ByteCount);
        if (hr != S_OK) DSND_WARN("ERROR GETTING EAX 2.0 LISTENER PROPPERY")
        return hr;
    }
    else if (PropSet == DSoundGlobals.EAX_20_voiceID)
    {
        hr = m_EAXVoice.Get2(id, iData, iDataLength, Data, DataLength, ByteCount);
        if (hr != S_OK) DSND_WARN("ERROR GETTING EAX 2.0 VOICE PROPPERY")
        return hr;
    }
    else if (PropSet == DSoundGlobals.EAX_30_listenerID)
    {
        hr = m_parent->EAX()->Get3(id, iData, iDataLength, Data, DataLength, ByteCount);
        if (hr != S_OK) DSND_WARN("ERROR GETTING EAX 3.0 LISTENER PROPPERY")
        return hr;
    }
    else if (PropSet == DSoundGlobals.EAX_20_voiceID)
    {
        hr = m_EAXVoice.Get3(id, iData, iDataLength, Data, DataLength, ByteCount);
        if (hr != S_OK) DSND_WARN("ERROR GETTING EAX 3.0 VOICE PROPPERY")
        return hr;
    }
    *ByteCount = 0;
    DSND_WARN("BAD GUID")
    return DSERR_INVALIDPARAM;
}

HRESULT STDMETHODCALLTYPE DirectSoundBuffer8::Set(REFGUID propid, ULONG ulId, LPVOID pInstanceData, ULONG ulInstanceLength, LPVOID pPropertyData, ULONG ulDataLength)
{
    LAYER_LOG_CALL
    HRESULT hr = DSERR_INVALIDPARAM;
    if (propid == DSoundGlobals.EAX_10_listenerID)
    {        
        hr = m_parent->EAX()->Set(ulId, pInstanceData, ulInstanceLength, pPropertyData, ulDataLength);
        if (hr != S_OK) DSND_WARN("ERROR SETTING EAX 1.0 LISTENER PROPPERY")
        else
        {
            m_parent->SetEAXVersion(1);
            m_parent->UpdateFX();
        }
        return hr;
    }    
    else if (propid == DSoundGlobals.EAX_10_voiceID)
    {
        hr = m_EAXVoice.Set(ulId, pInstanceData, ulInstanceLength, pPropertyData, ulDataLength);
        if (hr != S_OK) DSND_WARN("ERROR SETTING EAX 1.0 VOICE PROPPERY")
        else ApplyEffects(m_parent->EAX()->GetEAX10Props().get());
        return hr;
    }
    else if (propid == DSoundGlobals.EAX_20_listenerID)
    {
        if (ulId == DSPROPERTY_EAX20LISTENER_COMMITDEFERREDSETTINGS &&
            pInstanceData == nullptr && pPropertyData == nullptr  && ulInstanceLength == 0 && ulDataLength == 0)
        {
            m_parent->SetEAXVersion(2);
            m_parent->UpdateFX();
            return 0;
        }
        hr = m_parent->EAX()->Set2(ulId, pInstanceData, ulInstanceLength, pPropertyData, ulDataLength);
        if (hr != S_OK) DSND_WARN((string("ERROR SETTING EAX 2.0 LISTENER PROPPERY: ")+std::to_string(ulId)).c_str())
        else
        {
            m_parent->SetEAXVersion(2);
            m_parent->UpdateFX();
        }
        return hr;
    }
    else if (propid == DSoundGlobals.EAX_20_voiceID)
    {
        hr = m_EAXVoice.Set2(ulId, pInstanceData, ulInstanceLength, pPropertyData, ulDataLength);
        if (hr != S_OK) DSND_WARN("ERROR SETTING EAX 2.0 VOICE PROPPERY")
        else ApplyEffects2(m_parent->EAX()->GetEAX20Props().get());
        return hr;
    }
    else if (propid == DSoundGlobals.EAX_30_listenerID)
    {
        hr = m_parent->EAX()->Set3(ulId, pInstanceData, ulInstanceLength, pPropertyData, ulDataLength);
        if (hr != S_OK) DSND_WARN("ERROR SETTING EAX 3.0 LISTENER PROPPERY")
        else
        {
            m_parent->SetEAXVersion(3);
            m_parent->UpdateFX();
        }
        return hr;
    }
    else if (propid == DSoundGlobals.EAX_30_voiceID)
    {
        hr = m_EAXVoice.Set3(ulId, pInstanceData, ulInstanceLength, pPropertyData, ulDataLength);
        if (hr != S_OK) DSND_WARN("ERROR SETTING EAX 3.0 VOICE PROPPERY")
        else ApplyEffects3(m_parent->EAX()->GetEAX30Props().get());
        return hr;
    }
    DSND_WARN("BAD GUID")
    wchar_t* szGUID[64] = { 0 };
    if (StringFromGUID2(propid, (LPOLESTR)szGUID, 64))
    {
        DSoundGlobals.m_loger.dolog(L"DirectSoundBuffer8::Set", (const wchar_t*)szGUID);
    }
    else DSoundGlobals.m_loger.dolog(L"DirectSoundBuffer8::Set", L"StringFromGUID2 FAILED");
    return DSERR_INVALIDPARAM;
}

HRESULT STDMETHODCALLTYPE DirectSoundBuffer8::QuerySupport(REFGUID propid, ULONG prop, PULONG presult)
{
    LAYER_LOG_CALL
    if (propid == DSoundGlobals.EAX_10_listenerID)
    {
        if (prop > EAX_NUM_STANDARD_PROPERTIES)
        {
            *presult = 0;
            return E_NOTIMPL;
        }
        *presult = KSPROPERTY_SUPPORT_GET|KSPROPERTY_SUPPORT_SET;
        return DS_OK;
    }
    else if (propid == DSoundGlobals.EAX_10_voiceID)
    {
        if (prop > DSPROPERTY_EAXBUFFER_REVERBMIX)
        {
            *presult = 0;
            return E_NOTIMPL;
        }
        *presult = KSPROPERTY_SUPPORT_GET|KSPROPERTY_SUPPORT_SET;
        return DS_OK;
    }
    else if (propid == DSoundGlobals.EAX_20_listenerID)
    {
        if (prop > DSPROPERTY_EAX20LISTENER_FLAGS)
        {
            *presult = 0;
            return E_NOTIMPL;
        }
        *presult = KSPROPERTY_SUPPORT_GET | KSPROPERTY_SUPPORT_SET;
        return DS_OK;
    }
    else if (propid == DSoundGlobals.EAX_20_voiceID)
    {
        if (prop > DSPROPERTY_EAX20BUFFER_FLAGS)
        {
            *presult = 0;
            return E_NOTIMPL;
        }
        *presult = KSPROPERTY_SUPPORT_GET | KSPROPERTY_SUPPORT_SET;
        return DS_OK;
    }
    else if (propid == DSoundGlobals.EAX_30_listenerID)
    {
        if (prop > DSPROPERTY_EAXLISTENER_FLAGS)
        {
            *presult = 0;
            return E_NOTIMPL;
        }
        *presult = KSPROPERTY_SUPPORT_GET | KSPROPERTY_SUPPORT_SET;
        return DS_OK;
    }
    else if (propid == DSoundGlobals.EAX_30_voiceID)
    {
        if (prop > DSPROPERTY_EAXBUFFER_FLAGS)
        {
            *presult = 0;
            return E_NOTIMPL;
        }
        *presult = KSPROPERTY_SUPPORT_GET | KSPROPERTY_SUPPORT_SET;
        return DS_OK;
    }
    return E_NOTIMPL;
}

float DirectSoundBuffer8::ComputeDistance()
{
    IDirectSound3DBuffer8* sndbuff = (IDirectSound3DBuffer8*)EZInterface(IID_IDirectSound3DBuffer8, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return 0.f;
    }
    D3DVECTOR pos = {};
    DWORD mode    = DS3DMODE_NORMAL;
    if (sndbuff->GetMode(&mode) != S_OK)
    {
        DSND_WARN("GetMode FAILED");
        return 0.f;
    }
    if (sndbuff->GetPosition(&pos) != S_OK)
    {
        DSND_WARN("GetPosition FAILED");
        return 0.f;
    }
    if (mode == DS3DMODE_HEADRELATIVE)
    {        
        return sqrt(pow(pos.x, 2) + pow(pos.y, 2) + pow(pos.z, 2));
    }
    else // if (mode == DS3DMODE_NORMAL)
    {
        auto listener_pos = m_parent->GetPosition();
        D3DVECTOR* p      = (D3DVECTOR*) listener_pos.get();
        return sqrt(pow(pos.x-p->x, 2) + pow(pos.y-p->y, 2) + pow(pos.z-p->x, 2));
    }
}

float DirectSoundBuffer8::ComputeReverbMix()
{
    IDirectSound3DBuffer8* sndbuff = (IDirectSound3DBuffer8*)EZInterface(IID_IDirectSound3DBuffer8, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return 0.f;
    }    
    
    float eax_mix = m_EAXVoice.fMix(); 
    if (eax_mix == -1.f)
    {
        /* default D3D rolloff halves the volume for each doubling of min distance (rolloff = 2)
         * rolloff set by the applicatis is a mutiplyer of this rolloff */
        float rollof   = 1.f / (m_parent->GetRollOff() * 2.f);
        float distance = ComputeDistance();        
        D3DVALUE min;
        
        if (distance == 0.f) return 0.0;
        if (sndbuff->GetMinDistance(&min) != S_OK)
        {
            DSND_WARN("GetMinDistance FAILED");
            return 0.f;
        }
        if (min == DS3D_DEFAULTMAXDISTANCE - 1.f) return 0.0;
        if (min == 0.f)                           return 0.0;  /* Never happens since directound returns DSERR_INVALIDVALUE for ::SetMinDistance(0.f) */        
        return 2000 * m_parent->GetRollOff() * log10(1.f-min/distance);
    }
    return 2000 * m_parent->GetRollOff() * log10(eax_mix); //* DSFX_WAVESREVERB_REVERBMIX_MIN;
}

DWORD DirectSoundBuffer8::UpdateEffects(EAX_REVERBPROPERTIES* props)
{
    IDirectSoundBuffer8* sndbuff = (IDirectSoundBuffer8*)EZInterface(IID_IDirectSoundBuffer8, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return 1;
    }

    IDirectSoundFXI3DL2Reverb8* irvrb = nullptr;
    if (DS_OK != sndbuff->GetObjectInPath(GUID_DSFX_STANDARD_I3DL2REVERB, 0, IID_IDirectSoundFXI3DL2Reverb8, (void**)&irvrb))
    {
        DSND_WARN("GetObjectInPath FAILED");
        return 2;
    }
    /*
    DSFXI3DL2Reverb rvrb = { I3DL2_ENVIRONMENT_PRESET_DEFAULT };
    memcpy(&rvrb, &DSOUND_I3DL2_PRESETS[props->environment], sizeof(DSFXI3DL2Reverb));

    rvrb.flDecayTime    = props->fDecayTime_sec;
    rvrb.flDecayHFRatio = props->fDamping;
    rvrb.lRoom          = 2000.f * log10(props->fVolume) + ComputeReverbMix();
    rvrb.lRoom          = 0;
    rvrb.lRoomHF        = 0;
    rvrb.lReflections   = 1000;
    rvrb.lReverb        = 2000;    
    
    irvrb->SetAllParameters(&rvrb);    
    */
    irvrb->SetAllParameters(m_EAXVoice.I3DL2(props).get());
    irvrb->SetQuality(DSFX_I3DL2REVERB_QUALITY_MAX);
    irvrb->Release();
    return 0;
    DSND_WARN("Appyed effect");
}

void DirectSoundBuffer8::ApplyEffects(EAX_REVERBPROPERTIES* props)
{
    if (!(Caps().get()->dwFlags & DSBCAPS_CTRLFX)) return;
    if (UpdateEffects(props) == 0)                 return;

    IDirectSoundBuffer8* sndbuff = (IDirectSoundBuffer8*)EZInterface(IID_IDirectSoundBuffer8, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return;
    }
    
    DSEFFECTDESC desc   = {sizeof(DSEFFECTDESC), DSFX_LOCSOFTWARE, GUID_DSFX_STANDARD_I3DL2REVERB};    
    DWORD        result = DSFXR_FAILED;
    HRESULT      hr     = sndbuff->SetFX(1, &desc, &result);
    if (DS_OK != hr)
    {
        DSND_WARN((std::string("SetFX FAILED ") + HEXStringA((DWORD)hr).s.str() + " " + DSndGetErrString(hr, 0)).c_str());
        return;
    }    
    UpdateEffects(props);
}

DWORD DirectSoundBuffer8::UpdateEffects2(EAX20LISTENERPROPERTIES* props)
{
    IDirectSoundBuffer8* sndbuff = (IDirectSoundBuffer8*)EZInterface(IID_IDirectSoundBuffer8, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return 1;
    }
   
    IDirectSoundFXI3DL2Reverb8* irvrb = nullptr;
    if (DS_OK != sndbuff->GetObjectInPath(GUID_DSFX_STANDARD_I3DL2REVERB, 0, IID_IDirectSoundFXI3DL2Reverb8, (void**)&irvrb))
    {
        DSND_WARN("GetObjectInPath FAILED");
        return 2;
    }
    /*
    auto buffprops       = GetEAX2Props();
    DSFXI3DL2Reverb rvrb = { I3DL2_ENVIRONMENT_PRESET_DEFAULT };
    memcpy(&rvrb, &DSOUND_I3DL2_PRESETS[props->dwEnvironment], sizeof(DSFXI3DL2Reverb));    

    rvrb.lRoom              = DSFX_I3DL2REVERB_ROOM_MAX;
    rvrb.lRoom              = props->lRoom   + buffprops.get()->lRoom;
    rvrb.lRoomHF            = props->lRoomHF + buffprops.get()->lRoomHF;
    rvrb.flDecayTime        = props->flDecayTime;
    rvrb.flDecayHFRatio     = props->flDecayHFRatio;
    rvrb.lReflections       = props->lReflections;
    rvrb.flReflectionsDelay = props->flReflectionsDelay;
    rvrb.lReverb            = props->lReverb;
    rvrb.flReverbDelay      = props->flReverbDelay;
    rvrb.flDiffusion        = props->flEnvironmentDiffusion;

    rvrb.lRoom        = 0;
    rvrb.lRoomHF      = 0;
    rvrb.lReflections = 1000;
    rvrb.lReverb      = 2000;
    
    if (buffprops.get()->lObstruction < 0)
    {
        float ObstructionHF   = cdb_to_linear((float)buffprops.get()->lObstruction);
        float ObstructionLF   = ObstructionHF / buffprops.get()->flObstructionLFRatio;
        float ObstructionLFdb = linear_2_cdb(ObstructionLF);
        rvrb.lRoom           += ObstructionLFdb;
        rvrb.lRoomHF         += linear_2_cdb(ObstructionHF) - ObstructionLFdb;
    }
    if (buffprops.get()->lOcclusion < 0)
    {
        float OcclusionHF   = cdb_to_linear((float)buffprops.get()->lOcclusion);
        float OcclusionLF   = OcclusionHF / buffprops.get()->flOcclusionLFRatio;
        float OcclusionR    = OcclusionHF / buffprops.get()->flOcclusionRoomRatio;
        float OcclusionLFdb = linear_2_cdb(OcclusionLF);
        rvrb.lRoom   += OcclusionLFdb;
        rvrb.lRoomHF += linear_2_cdb(OcclusionHF) - OcclusionLFdb;
        rvrb.lReverb += linear_2_cdb(CLAMP(OcclusionR, 0.f, 1.f));
    }

    irvrb->SetAllParameters(&rvrb);
    */
    irvrb->SetAllParameters(m_EAXVoice.I3DL2(props).get());
    irvrb->SetQuality(DSFX_I3DL2REVERB_QUALITY_MAX);
    irvrb->Release();
    return 0;
    DSND_WARN("Appyed effect");
}

void DirectSoundBuffer8::ApplyEffects2(EAX20LISTENERPROPERTIES* props)
{
    if (!(Caps().get()->dwFlags & DSBCAPS_CTRLFX)) return;
    if (UpdateEffects2(props) == 0)                return;

    IDirectSoundBuffer8* sndbuff = (IDirectSoundBuffer8*)EZInterface(IID_IDirectSoundBuffer8, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return;
    }

    DSEFFECTDESC desc   = {sizeof(DSEFFECTDESC), DSFX_LOCSOFTWARE, GUID_DSFX_STANDARD_I3DL2REVERB};
    DWORD        result = DSFXR_FAILED;
    HRESULT      hr     = sndbuff->SetFX(1, &desc, &result);
    if (DS_OK != hr)
    {
        DSND_WARN((std::string("SetFX FAILED ") + HEXStringA((DWORD)hr).s.str() + DSndGetErrString(hr, 0)).c_str());
        return;
    }
    UpdateEffects2(props);
}

DWORD DirectSoundBuffer8::UpdateEffects3(EAX30LISTENERPROPERTIES* props)
{
    IDirectSoundBuffer8* sndbuff = (IDirectSoundBuffer8*)EZInterface(IID_IDirectSoundBuffer8, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return 1;
    }

    IDirectSoundFXI3DL2Reverb8* irvrb = nullptr;
    if (DS_OK != sndbuff->GetObjectInPath(GUID_DSFX_STANDARD_I3DL2REVERB, 0, IID_IDirectSoundFXI3DL2Reverb8, (void**)&irvrb))
    {
        DSND_WARN("::GetObjectInPath(IID_IDirectSoundFXI3DL2Reverb8) FAILED");
        return 2;
    }

    IDirectSoundFXEcho8* iecho = nullptr;
    if (DS_OK != sndbuff->GetObjectInPath(GUID_DSFX_STANDARD_ECHO, 0, IID_IDirectSoundFXEcho8, (void**)&iecho))
    {
        irvrb->Release();
        DSND_WARN("GetObjectInPath(IID_IDirectSoundFXEcho8) FAILED");
        return 2;
    }
    
    irvrb->SetAllParameters(m_EAXVoice.I3DL2(props).get());
    irvrb->SetQuality(DSFX_I3DL2REVERB_QUALITY_MAX);
    irvrb->Release();
    iecho->SetAllParameters(m_EAXVoice.Echo(props).get());
    iecho->Release();
    return 0;
    DSND_WARN("Appyed effect");
}

void DirectSoundBuffer8::ApplyEffects3(EAX30LISTENERPROPERTIES* props)
{
    if (!(Caps().get()->dwFlags & DSBCAPS_CTRLFX)) return;
    if (UpdateEffects3(props) == 0)                return;

    IDirectSoundBuffer8* sndbuff = (IDirectSoundBuffer8*)EZInterface(IID_IDirectSoundBuffer8, m_Imp).I();
    if (sndbuff == nullptr)
    {
        DSND_WARN("EZInterface::I() FAILED");
        return;
    }

    DWORD        result  = DSFXR_FAILED;
    DSEFFECTDESC desc[2] = {};
    desc[0]              = {sizeof(DSEFFECTDESC), DSFX_LOCSOFTWARE, GUID_DSFX_STANDARD_I3DL2REVERB};
    desc[1]              = {sizeof(DSEFFECTDESC), DSFX_LOCSOFTWARE, GUID_DSFX_STANDARD_ECHO};
    HRESULT      hr = sndbuff->SetFX(2, desc, &result);
    if (DS_OK != hr)
    {
        DSND_WARN((std::string("SetFX FAILED ") + HEXStringA((DWORD)hr).s.str() + DSndGetErrString(hr, 0)).c_str());
        return;
    }
    UpdateEffects3(props);
}

extern "C" __declspec(dllexport) DirectSound8* LayerDsoundTest(IUnknown* i)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return new DirectSound8(i, 0);
}