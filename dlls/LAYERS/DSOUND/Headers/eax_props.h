#ifndef EAX_PROPS_H
#define EAX_PROPS_H

#include <windows.h>
#include <dsound.h>
#include <DSoundHooks.h>
#include <dllmain.h>
#include "Sync.h"
#include "LayersCommon.h"
#include <vector>
#include <memory>

using std::to_string;
using std::to_wstring;
using std::unique_ptr;

#define EAX3_VALIDADEPROPERTY(Prop, ConstantName)                                                                \
if (new_props->Prop < EAXLISTENER_MIN##ConstantName || new_props->Prop > EAXLISTENER_MAX##ConstantName)          \
{                                                                                                                \
    DSND_WARN("DSPROPERTY_EAX30LISTENER_ALLPARAMETERS" #Prop);                                                   \
    return DSERR_INVALIDPARAM;                                                                                   \
}  
 

#define EAX3_VALIDADEAND_SET(Prop, ConstantName, type)                   \
else if (ulId == DSPROPERTY_EAXLISTENER_##ConstantName)                  \
{                                                                        \
    if ((type)*(type*)pPropertyData > EAXLISTENER_MAX##ConstantName ||   \
        (type)*(type*)pPropertyData < EAXLISTENER_MIN##ConstantName)     \
    {                                                                    \
        DSND_WARN("INVALID DSPROPERTY_EAX30LISTENER_" #ConstantName);    \
        return DSERR_INVALIDPARAM;                                       \
    }                                                                    \
    memcpy(&eax3props.get()->Prop, pPropertyData, ulDataLength);       \
}

#define EAX3_GET(Prop, ConstantName, type)               \
if (id == DSPROPERTY_EAXLISTENER_##ConstantName)         \
{                                                        \
    memcpy(Data, &eax3props.get()->Prop, sizeof(type));  \
    * ByteCount = sizeof(type);                          \
    return DS_OK;                                        \
}

#define EAXBUFF3_VALIDADE(Prop, ConstantName)                  \
if (new_Buffprops3->Prop < EAXBUFFER_MIN##ConstantName ||      \
    new_Buffprops3->Prop > EAXBUFFER_MAX##ConstantName)        \
{                                                              \
    DSND_WARN("DSPROPERTY_EAX30BUFFER_ALLPARAMETERS" #Prop);   \
    return DSERR_INVALIDPARAM;                                 \
} 

#define EAX3BUFF_VALIDADEAND_SET(Prop, ConstantName, type)               \
if (ulId == DSPROPERTY_EAXBUFFER_##ConstantName)                         \
{                                                                        \
    if ((type)*(type*)pPropertyData > EAXBUFFER_MAX##ConstantName ||     \
        (type)*(type*)pPropertyData < EAXBUFFER_MIN##ConstantName)       \
    {                                                                    \
        DSND_WARN("INVALID DSPROPERTY_EAX20LISTENER_" #ConstantName);    \
        return DSERR_INVALIDPARAM;                                       \
    }                                                                    \
    memcpy(&buffprops3.get()->Prop, pPropertyData, ulDataLength);      \
}

#define EAX3BUFF_GET(Prop, ConstantName, type)            \
if (id == DSPROPERTY_EAXBUFFER_##ConstantName)            \
{                                                         \
    memcpy(Data, &eax3buffer.get()->Prop, sizeof(type));  \
    * ByteCount = sizeof(type);                           \
    return DS_OK;                                         \
}

#define EAX2_VALIDADEPROPERTY(Prop, ConstantName)                                                                \
if (new_props->Prop < EAX20LISTENER_MIN##ConstantName || new_props->Prop > EAX20LISTENER_MAX##ConstantName)      \
{                                                                                                                \
    DSND_WARN("DSPROPERTY_EAX20LISTENER_ALLPARAMETERS" #Prop);                                                   \
    return DSERR_INVALIDPARAM;                                                                                   \
}   

#define EAX2_VALIDADEAND_SET(Prop, ConstantName, type)                   \
else if (ulId == DSPROPERTY_EAX20LISTENER_##ConstantName)                \
{                                                                        \
    if ((type)*(type*)pPropertyData > EAX20LISTENER_MAX##ConstantName || \
        (type)*(type*)pPropertyData < EAX20LISTENER_MIN##ConstantName)   \
    {                                                                    \
        DSND_WARN("INVALID DSPROPERTY_EAX20LISTENER_" #ConstantName);    \
        return DSERR_INVALIDPARAM;                                       \
    }                                                                    \
    memcpy(&eax2props.get()->Prop, pPropertyData, ulDataLength);         \
}

#define EAXBUFF2_VALIDADE(Prop, ConstantName)                    \
if (new_Buffprops2->Prop < EAX20BUFFER_MIN##ConstantName ||      \
    new_Buffprops2->Prop > EAX20BUFFER_MAX##ConstantName)        \
{                                                                \
    DSND_WARN("DSPROPERTY_EAX20BUFFER_ALLPARAMETERS" #Prop);     \
    return DSERR_INVALIDPARAM;                                   \
}   
 
#define EAX2BUFF_VALIDADEAND_SET(Prop, ConstantName, type)               \
if (ulId == DSPROPERTY_EAX20BUFFER_##ConstantName)                       \
{                                                                        \
    if ((type)*(type*)pPropertyData > EAX20BUFFER_MAX##ConstantName ||   \
        (type)*(type*)pPropertyData < EAX20BUFFER_MIN##ConstantName)     \
    {                                                                    \
        DSND_WARN("INVALID DSPROPERTY_EAX20LISTENER_" #ConstantName);    \
        return DSERR_INVALIDPARAM;                                       \
    }                                                                    \
    memcpy(&buffprops2.get()->Prop, pPropertyData, ulDataLength);        \
}

#define EAX2_GET(Prop, ConstantName, type)              \
if (id == DSPROPERTY_EAX20LISTENER_##ConstantName)      \
{                                                       \
    memcpy(Data, &eax2props.get()->Prop, sizeof(type)); \
    * ByteCount = sizeof(type);                         \
    return DS_OK;                                       \
}

#define EAX2BUFF_GET(Prop, ConstantName, type)           \
if (id == DSPROPERTY_EAX20BUFFER_##ConstantName)         \
{                                                        \
    memcpy(Data, &eax2buffer.get()->Prop, sizeof(type)); \
    * ByteCount = sizeof(type);                          \
    return DS_OK;                                        \
}

class EaxListener {
public:
    void Init() { m_lock = new SYNC::AtomicLock(); }
    void GetEAX10Props(EAX_REVERBPROPERTIES* props)
    {
        if (props == nullptr)
        {
            DSND_WARN("nullptr");
            return;
        }
        m_lock->lock();
        memcpy(props, &m_eaxprops, sizeof(EAX_REVERBPROPERTIES));
        m_lock->unlock();
    }
    unique_ptr <EAX_REVERBPROPERTIES> GetEAX10Props()
    {
        auto p = unique_ptr<EAX_REVERBPROPERTIES>(new EAX_REVERBPROPERTIES);
        GetEAX10Props(p.get());
        return p;
    }
    void SetEAX10Props(EAX_REVERBPROPERTIES* props)
    {
        if (props == nullptr)
        {
            DSND_WARN("nullptr");
            return;
        }
        m_lock->lock();
        memcpy(&m_eaxprops, props, sizeof(EAX_REVERBPROPERTIES));
        m_lock->unlock();
    }
    unique_ptr <EAX20LISTENERPROPERTIES> GetEAX20Props()
    {
        auto p = unique_ptr<EAX20LISTENERPROPERTIES>(new EAX20LISTENERPROPERTIES);
        m_lock->cpy(p.get(), &m_eax2props, sizeof(EAX20LISTENERPROPERTIES));
        return p;
    }
    void SetEAX20Props(EAX20LISTENERPROPERTIES* props, BOOL deffered)
    {
        if (props == nullptr)
        {
            DSND_WARN("nullptr");
            return;
        }
        m_lock->lock();
        memcpy(deffered ? &m_eax2props_d : &m_eax2props, props, sizeof(EAX20LISTENERPROPERTIES));
        m_lock->unlock();
    }
    unique_ptr <EAX30LISTENERPROPERTIES> GetEAX30Props()
    {
        auto p = unique_ptr<EAX30LISTENERPROPERTIES>(new EAX30LISTENERPROPERTIES);
        m_lock->cpy(p.get(), &m_eax3props, sizeof(EAX30LISTENERPROPERTIES));
        return p;
    }
    void SetEAX30Props(EAX30LISTENERPROPERTIES* props, BOOL deffered)
    {
        if (props == nullptr)
        {
            DSND_WARN("nullptr");
            return;
        }
        m_lock->lock();
        memcpy(deffered ? &m_eax3props_d : &m_eax3props, props, sizeof(EAX30LISTENERPROPERTIES));
        m_lock->unlock();
    }
    HRESULT Set3(ULONG ulId, LPVOID pInstanceData, ULONG ulInstanceLength, LPVOID pPropertyData, ULONG ulDataLength)
    {
        if (pInstanceData != nullptr || ulInstanceLength != 0 || pPropertyData == nullptr || ulId > DSPROPERTY_EAXLISTENER_FLAGS) {
            DSND_WARN("BAD PARAMS");  return DSERR_INVALIDPARAM;
        }   
        BOOL deffered  = ulId & DSPROPERTY_EAXLISTENER_DEFERRED;
        ulId          &= ~DSPROPERTY_EAXLISTENER_DEFERRED;
        auto eax3props = GetEAX30Props();
        if (ulId == DSPROPERTY_EAXLISTENER_COMMITDEFERREDSETTINGS)
        {
            m_lock->cpy(&m_eax3props, &m_eax3props_d, sizeof(EAX30LISTENERPROPERTIES));
            return S_OK;
        }
        else if (ulId == DSPROPERTY_EAXLISTENER_ALLPARAMETERS)
        {
            if (ulDataLength != sizeof(EAX30LISTENERPROPERTIES))
            {
                DSND_WARN((std::string("DSPROPERTY_EAX30LISTENER_ALLPARAMETERS BAD BUFF SIZE: ") + std::to_string(ulDataLength)).c_str());
                return DSERR_INVALIDPARAM;
            }
            EAX30LISTENERPROPERTIES* new_props = (EAX30LISTENERPROPERTIES*)pPropertyData;
            EAX3_VALIDADEPROPERTY(ulEnvironment, ENVIRONMENT)
            EAX3_VALIDADEPROPERTY(flEnvironmentSize, ENVIRONMENTSIZE)
            EAX3_VALIDADEPROPERTY(flEnvironmentDiffusion, ENVIRONMENTDIFFUSION)
            EAX3_VALIDADEPROPERTY(lRoom, ROOM)
            EAX3_VALIDADEPROPERTY(lRoomHF, ROOMHF)
            EAX3_VALIDADEPROPERTY(lRoomLF, ROOMLF)            
            EAX3_VALIDADEPROPERTY(flDecayTime, DECAYTIME)
            EAX3_VALIDADEPROPERTY(flDecayHFRatio, DECAYHFRATIO)
            EAX3_VALIDADEPROPERTY(flDecayLFRatio, DECAYLFRATIO)
            EAX3_VALIDADEPROPERTY(lReflections, REFLECTIONS)
            EAX3_VALIDADEPROPERTY(flReflectionsDelay, REFLECTIONSDELAY)
            EAX3_VALIDADEPROPERTY(lReverb, REVERB)
            EAX3_VALIDADEPROPERTY(flReverbDelay, REVERBDELAY) 
            EAX3_VALIDADEPROPERTY(flEchoTime, ECHOTIME)
            EAX3_VALIDADEPROPERTY(flEchoDepth, ECHODEPTH)
            EAX3_VALIDADEPROPERTY(flModulationTime, MODULATIONTIME)
            EAX3_VALIDADEPROPERTY(flModulationDepth, MODULATIONDEPTH)
            EAX3_VALIDADEPROPERTY(flAirAbsorptionHF, AIRABSORPTIONHF)           
            EAX3_VALIDADEPROPERTY(flHFReference, HFREFERENCE)
            EAX3_VALIDADEPROPERTY(flLFReference, LFREFERENCE)
            EAX3_VALIDADEPROPERTY(flRoomRolloffFactor, ROOMROLLOFFFACTOR)
            memcpy(eax3props.get(), pPropertyData, sizeof(EAX30LISTENERPROPERTIES));
        }
        else
        {
            if (ulDataLength != sizeof(float)) /* all are long or float */
            {
                DSND_WARN((std::string("BAD BUFF SIZE: ") + std::to_string(ulDataLength) + " " + std::to_string(ulId)).c_str());
                return DSERR_INVALIDPARAM;
            }
            if (ulId == DSPROPERTY_EAXLISTENER_ENVIRONMENT)
            {
                if ((ULONG) * (ULONG*)pPropertyData > EAX_ENVIRONMENT_PSYCHOTIC)
                {
                    DSND_WARN("INVALID DSPROPERTY_EAX30LISTENER_ENVIRONMENT");
                    return DSERR_INVALIDPARAM;
                }
                memcpy(eax3props.get(), &EAX30EnviromentPresets[(UINT) * (UINT*)pPropertyData], sizeof(EAX30LISTENERPROPERTIES));
            }
            else if (ulId == DSPROPERTY_EAXLISTENER_ENVIRONMENTSIZE)
            {
                if ((float)*(float*)pPropertyData > EAXLISTENER_MAXENVIRONMENTSIZE ||
                    (float)*(float*)pPropertyData < EAXLISTENER_MINENVIRONMENTSIZE)
                {
                    DSND_WARN("INVALID DSPROPERTY_EAX30LISTENER_ENVIRONMENTSIZE");
                    return DSERR_INVALIDPARAM;
                }
                float envsize_delta = (float)*(float*)pPropertyData - eax3props.get()->flEnvironmentSize;
                float norm_envsize_delta = (envsize_delta - EAXLISTENER_MINENVIRONMENTSIZE) / (EAXLISTENER_MAXENVIRONMENTSIZE - EAXLISTENER_MINENVIRONMENTSIZE);
                memcpy(&eax3props.get()->flEnvironmentSize, pPropertyData, ulDataLength);
                if (eax3props.get()->ulFlags & EAXLISTENERFLAGS_DECAYTIMESCALE)
                {
                    float decay_time_change = norm_envsize_delta * (EAXLISTENER_MAXDECAYTIME - EAXLISTENER_MINDECAYTIME) + EAXLISTENER_MINDECAYTIME;
                    eax3props.get()->flDecayTime = CLAMP(eax3props.get()->flDecayTime + decay_time_change, EAXLISTENER_MINDECAYTIME, EAXLISTENER_MAXDECAYTIME);
                }
                if (eax3props.get()->ulFlags & EAXLISTENERFLAGS_REVERBDELAYSCALE)
                {
                    float rvb_dly_delta =
                        norm_envsize_delta * (EAXLISTENER_MAXREVERBDELAY - EAXLISTENER_MINREVERBDELAY) + EAXLISTENER_MINREVERBDELAY;
                    eax3props.get()->flReflectionsDelay =
                        CLAMP(eax3props.get()->flReverbDelay + rvb_dly_delta, EAXLISTENER_MINREVERBDELAY, EAXLISTENER_MAXREVERBDELAY);
                }
                if (eax3props.get()->ulFlags & EAXLISTENERFLAGS_REFLECTIONSDELAYSCALE)
                {
                    float rf_dly_delta =
                        norm_envsize_delta * (EAXLISTENER_MAXREFLECTIONSDELAY - EAXLISTENER_MINREFLECTIONSDELAY) + EAXLISTENER_MINREFLECTIONSDELAY;
                    eax3props.get()->flReflectionsDelay =
                        CLAMP(eax3props.get()->flReflectionsDelay + rf_dly_delta, EAXLISTENER_MINREFLECTIONSDELAY, EAXLISTENER_MAXREFLECTIONSDELAY);
                    if (eax3props.get()->ulFlags & EAXLISTENERFLAGS_REFLECTIONSSCALE)
                    {
                        float reflections = CLAMP(cdb_to_linear(eax3props.get()->lReflections) + norm_envsize_delta, 0.f, 1.f);
                        eax3props.get()->lReflections = linear_2_cdb(reflections);
                    }
                }
                if (eax3props.get()->ulFlags & EAXLISTENERFLAGS_REVERBSCALE)
                {
                    float reverb = CLAMP(cdb_to_linear(eax3props.get()->lReverb) + norm_envsize_delta, 0.f, 1.f);
                    eax3props.get()->lReverb = linear_2_cdb(reverb);
                }
                if (eax3props.get()->ulFlags & EAXLISTENERFLAGS_ECHOTIMESCALE)
                {
                    float echotime = CLAMP(cdb_to_linear(eax3props.get()->flEchoTime) + norm_envsize_delta, 0.f, 1.f);
                    eax3props.get()->flEchoTime = linear_2_cdb(echotime);
                }
                if (eax3props.get()->ulFlags & EAXLISTENERFLAGS_MODULATIONTIMESCALE)
                {
                    float modtime = CLAMP(cdb_to_linear(eax3props.get()->flModulationTime) + norm_envsize_delta, 0.f, 1.f);
                    eax3props.get()->flEchoTime = linear_2_cdb(modtime);
                }
            }
            EAX3_VALIDADEAND_SET(flEnvironmentDiffusion, ENVIRONMENTDIFFUSION, float)
            EAX3_VALIDADEAND_SET(lRoom, ROOM, LONG)
            EAX3_VALIDADEAND_SET(lRoomHF, ROOMHF, LONG)
            EAX3_VALIDADEAND_SET(lRoomLF, ROOMLF, LONG)
            EAX3_VALIDADEAND_SET(flDecayTime, DECAYTIME, float)
            EAX3_VALIDADEAND_SET(flDecayHFRatio, DECAYHFRATIO, float)
            EAX3_VALIDADEAND_SET(flDecayLFRatio, DECAYLFRATIO, float)
            EAX3_VALIDADEAND_SET(lReflections, REFLECTIONS, LONG)
            EAX3_VALIDADEAND_SET(flReflectionsDelay, REFLECTIONSDELAY, float)
            EAX3_VALIDADEAND_SET(lReverb, REVERB, LONG)
            EAX3_VALIDADEAND_SET(flReverbDelay, REVERBDELAY, float) 
            EAX3_VALIDADEAND_SET(flEchoTime, ECHOTIME, float)
            EAX3_VALIDADEAND_SET(flEchoDepth, ECHODEPTH, float)
            EAX3_VALIDADEAND_SET(flModulationTime, MODULATIONTIME, float)
            EAX3_VALIDADEAND_SET(flModulationDepth, MODULATIONDEPTH, float)
            EAX3_VALIDADEAND_SET(flAirAbsorptionHF, AIRABSORPTIONHF, float)
            EAX3_VALIDADEAND_SET(flHFReference, HFREFERENCE, float)
            EAX3_VALIDADEAND_SET(flLFReference, LFREFERENCE, float)
            EAX3_VALIDADEAND_SET(flRoomRolloffFactor, ROOMROLLOFFFACTOR, float)
            else if (ulId == DSPROPERTY_EAXLISTENER_FLAGS) memcpy(&eax3props.get()->ulFlags, pPropertyData, ulDataLength);
        }
        SetEAX30Props(eax3props.get(), deffered);
        return S_OK;    
    }
    HRESULT Set2(ULONG ulId, LPVOID pInstanceData, ULONG ulInstanceLength, LPVOID pPropertyData, ULONG ulDataLength)
    {
        if (pInstanceData != nullptr || ulInstanceLength != 0 || pPropertyData == nullptr || ulId > DSPROPERTY_EAX20LISTENER_FLAGS) {
            DSND_WARN("BAD PARAMS");  return DSERR_INVALIDPARAM;
        }
        BOOL deffered  = ulId & DSPROPERTY_EAX20LISTENER_DEFERRED;
        ulId          &= ~DSPROPERTY_EAX20LISTENER_DEFERRED;
        auto eax2props = GetEAX20Props();
        if (ulId == DSPROPERTY_EAX20LISTENER_COMMITDEFERREDSETTINGS)
        {
            m_lock->cpy(&m_eax2props, &m_eax2props_d, sizeof(EAX20LISTENERPROPERTIES));
            return S_OK;
        }
        if (ulId == DSPROPERTY_EAX20LISTENER_ALLPARAMETERS)
        {
            if (ulDataLength != sizeof(EAX20LISTENERPROPERTIES))
            {
                DSND_WARN((std::string("DSPROPERTY_EAX20LISTENER_ALLPARAMETERS BAD BUFF SIZE: ") + std::to_string(ulDataLength)).c_str());
                return DSERR_INVALIDPARAM;
            }
            EAX20LISTENERPROPERTIES* new_props = (EAX20LISTENERPROPERTIES*)pPropertyData;
            EAX2_VALIDADEPROPERTY(lRoom, ROOM)
            EAX2_VALIDADEPROPERTY(lRoomHF, ROOMHF)
            EAX2_VALIDADEPROPERTY(flRoomRolloffFactor, ROOMROLLOFFFACTOR)
            EAX2_VALIDADEPROPERTY(flDecayTime, DECAYTIME)
            EAX2_VALIDADEPROPERTY(flDecayHFRatio, DECAYHFRATIO)
            EAX2_VALIDADEPROPERTY(lReflections, REFLECTIONS)
            EAX2_VALIDADEPROPERTY(flReflectionsDelay, REFLECTIONSDELAY)
            EAX2_VALIDADEPROPERTY(lReverb, REVERB)
            EAX2_VALIDADEPROPERTY(flReverbDelay, REVERBDELAY)
            EAX2_VALIDADEPROPERTY(dwEnvironment, ENVIRONMENT)
            EAX2_VALIDADEPROPERTY(flEnvironmentSize, ENVIRONMENTSIZE)
            EAX2_VALIDADEPROPERTY(flEnvironmentDiffusion, ENVIRONMENTDIFFUSION)
            EAX2_VALIDADEPROPERTY(flAirAbsorptionHF, AIRABSORPTIONHF)
            memcpy(eax2props.get(), pPropertyData, sizeof(EAX20LISTENERPROPERTIES));            
        }
        else
        {
            if (ulDataLength != sizeof(float)) /* all are long or float */
            {
                DSND_WARN((std::string("BAD BUFF SIZE: ") + std::to_string(ulDataLength) + " " + std::to_string(ulId)).c_str());
                return DSERR_INVALIDPARAM;
            }
            if (ulId == DSPROPERTY_EAX20LISTENER_ENVIRONMENT)
            {
                if ((ULONG) * (ULONG*)pPropertyData > EAX20_ENVIRONMENT_PSYCHOTIC)
                {
                    DSND_WARN("INVALID DSPROPERTY_EAX20LISTENER_ENVIRONMENT");
                    return DSERR_INVALIDPARAM;
                }
                memcpy(eax2props.get(), &EAX20EnviromentPresets[(UINT) * (UINT*)pPropertyData], sizeof(EAX20LISTENERPROPERTIES));
            }
            else if (ulId == DSPROPERTY_EAX20LISTENER_ENVIRONMENTSIZE)
            {
                if ((float)*(float*)pPropertyData > EAX20LISTENER_MAXENVIRONMENTSIZE ||
                    (float)*(float*)pPropertyData < EAX20LISTENER_MINENVIRONMENTSIZE)
                {
                    DSND_WARN("INVALID DSPROPERTY_EAX20LISTENER_ENVIRONMENTSIZE");
                    return DSERR_INVALIDPARAM;
                }
                float envsize_delta = (float)*(float*)pPropertyData - eax2props.get()->flEnvironmentSize;
                float norm_envsize_delta = (envsize_delta - EAX20LISTENER_MINENVIRONMENTSIZE) / (EAX20LISTENER_MAXENVIRONMENTSIZE - EAX20LISTENER_MINENVIRONMENTSIZE);
                memcpy(&eax2props.get()->flEnvironmentSize, pPropertyData, ulDataLength);
                if (eax2props.get()->dwFlags & EAX20LISTENERFLAGS_DECAYTIMESCALE)
                {
                    float decay_time_change = norm_envsize_delta * (EAX20LISTENER_MAXDECAYTIME - EAX20LISTENER_MINDECAYTIME) + EAX20LISTENER_MINDECAYTIME;
                    eax2props.get()->flDecayTime = CLAMP(eax2props.get()->flDecayTime + decay_time_change, EAX20LISTENER_MINDECAYTIME, EAX20LISTENER_MAXDECAYTIME);
                }
                if (eax2props.get()->dwFlags & EAX20LISTENERFLAGS_REVERBDELAYSCALE)
                {
                    float rvb_dly_delta =
                        norm_envsize_delta * (EAX20LISTENER_MAXREVERBDELAY - EAX20LISTENER_MINREVERBDELAY) + EAX20LISTENER_MINREVERBDELAY;
                    eax2props.get()->flReflectionsDelay =
                        CLAMP(eax2props.get()->flReverbDelay + rvb_dly_delta, EAX20LISTENER_MINREVERBDELAY, EAX20LISTENER_MAXREVERBDELAY);
                }
                if (eax2props.get()->dwFlags & EAX20LISTENERFLAGS_REFLECTIONSDELAYSCALE)
                {
                    float rf_dly_delta =
                        norm_envsize_delta * (EAX20LISTENER_MAXREFLECTIONSDELAY - EAX20LISTENER_MINREFLECTIONSDELAY) + EAX20LISTENER_MINREFLECTIONSDELAY;
                    eax2props.get()->flReflectionsDelay =
                        CLAMP(eax2props.get()->flReflectionsDelay + rf_dly_delta, EAX20LISTENER_MINREFLECTIONSDELAY, EAX20LISTENER_MAXREFLECTIONSDELAY);
                    if (eax2props.get()->dwFlags & EAX20LISTENERFLAGS_REFLECTIONSSCALE)
                    {
                        float reflections = CLAMP(cdb_to_linear(eax2props.get()->lReflections) + norm_envsize_delta, 0.f, 1.f);
                        eax2props.get()->lReflections = linear_2_cdb(reflections);
                    }
                }
                if (eax2props.get()->dwFlags & EAX20LISTENERFLAGS_REVERBSCALE)
                {
                    float reverb = CLAMP(cdb_to_linear(eax2props.get()->lReverb) + norm_envsize_delta, 0.f, 1.f);
                    eax2props.get()->lReverb = linear_2_cdb(reverb);
                }
            }
            EAX2_VALIDADEAND_SET(lRoom, ROOM, LONG)
            EAX2_VALIDADEAND_SET(lRoomHF, ROOMHF, LONG)
            EAX2_VALIDADEAND_SET(flRoomRolloffFactor, ROOMROLLOFFFACTOR, float)
            EAX2_VALIDADEAND_SET(flDecayTime, DECAYTIME, float)
            EAX2_VALIDADEAND_SET(flDecayHFRatio, DECAYHFRATIO, float)
            EAX2_VALIDADEAND_SET(lReflections, REFLECTIONS, LONG)
            EAX2_VALIDADEAND_SET(flReflectionsDelay, REFLECTIONSDELAY, float)
            EAX2_VALIDADEAND_SET(lReverb, REVERB, LONG)
            EAX2_VALIDADEAND_SET(flReverbDelay, REVERBDELAY, float)
            EAX2_VALIDADEAND_SET(flEnvironmentDiffusion, ENVIRONMENTDIFFUSION, float)
            EAX2_VALIDADEAND_SET(flAirAbsorptionHF, AIRABSORPTIONHF, float)
            else if (ulId == DSPROPERTY_EAX20LISTENER_FLAGS) memcpy(&eax2props.get()->dwFlags, pPropertyData, ulDataLength);
        }
        SetEAX20Props(eax2props.get(), deffered);
        return S_OK;
    }
    HRESULT Set(ULONG ulId, LPVOID pInstanceData, ULONG ulInstanceLength, LPVOID pPropertyData, ULONG ulDataLength)
    {
        if (pInstanceData != nullptr || ulInstanceLength != 0 || pPropertyData == nullptr || ulId > DSPROPERTY_EAX_DAMPING) {
            DSND_WARN("BAD PARAMS"); return DSERR_INVALIDPARAM;
        }

        EAX_REVERBPROPERTIES props;
        GetEAX10Props(&props);

        if (ulId == DSPROPERTY_EAX_ALL)
        {
            if (ulDataLength != sizeof(EAX_REVERBPROPERTIES))
            {
                DSND_WARN((std::string("DSPROPERTY_EAX_ALL BAD BUFF SIZE: ") + std::to_string(ulDataLength)).c_str());
                return DSERR_INVALIDPARAM;
            }
            EAX_REVERBPROPERTIES* newprops = (EAX_REVERBPROPERTIES*)pPropertyData;
            if (newprops->environment > EAX_ENVIRONMENT_PSYCHOTIC)
            {
                DSND_WARN("INVALID DSPROPERTY_EAX_ALL EAX_REVERBPROPERTIES environment");
                return DSERR_INVALIDPARAM;
            }
            if (newprops->fVolume > 1.0f || newprops->fVolume < 0.f)
            {
                DSND_WARN("INVALID DSPROPERTY_EAX_ALL EAX_REVERBPROPERTIES fVolume");
                return DSERR_INVALIDPARAM;
            }
            if (newprops->fDecayTime_sec > 100.f || newprops->fDecayTime_sec < 0.1f)
            {
                DSND_WARN((std::string("INVALID DSPROPERTY_EAX_ALL EAX_REVERBPROPERTIES fDecayTime_sec=") +
                    std::to_string(newprops->fDecayTime_sec)).c_str());
                return DSERR_INVALIDPARAM;
            }
            if (newprops->fDamping > 1.0f || newprops->fDamping < 0.f)
            {
                DSND_WARN("INVALID DSPROPERTY_EAX_ALL EAX_REVERBPROPERTIES fDamping");
                return DSERR_INVALIDPARAM;
            }
            memcpy(&props, newprops, sizeof(EAX_REVERBPROPERTIES));
        }
        else
        {
            if (ulDataLength != sizeof(float)) /* EAX_REVERBPROPERTIES::environment is ULONG, but same size anyway on 32 bit */
            {
                DSND_WARN((std::string("BAD BUFF SIZE: ") + std::to_string(ulDataLength) + " " + std::to_string(ulId)).c_str());
                return DSERR_INVALIDPARAM;
            }
            if (ulId == DSPROPERTY_EAX_ENVIRONMENT)
            {
                if ((ULONG) * (ULONG*)pPropertyData > EAX_ENVIRONMENT_PSYCHOTIC)
                {
                    DSND_WARN("INVALID DSPROPERTY_EAX_ENVIRONMENT");
                    return DSERR_INVALIDPARAM;
                }
                props.environment = (ULONG) * (ULONG*)pPropertyData;
                memcpy(&props.fVolume, &EAX10EnviromentPresets[props.environment], sizeof(float) * 3);
            }
            else if (ulId == DSPROPERTY_EAX_VOLUME)
            {
                if ((float)*(float*)pPropertyData > 1.0f || (float)*(float*)pPropertyData < 0.f)
                {
                    DSND_WARN("INVALID DSPROPERTY_EAX_VOLUME fVolume");
                    return DSERR_INVALIDPARAM;
                }
                props.fVolume = (float)*(float*)pPropertyData;
            }
            else if (ulId == DSPROPERTY_EAX_DECAYTIME)
            {
                if ((float)*(float*)pPropertyData > 100.f || (float)*(float*)pPropertyData < 0.1f)
                {
                    DSND_WARN((string("INVALID DSPROPERTY_EAX_DECAYTIME fDecayTime_sec ") + to_string((float)*(float*)pPropertyData)).c_str());
                    return DSERR_INVALIDPARAM;
                }
                props.fDecayTime_sec = (float)*(float*)pPropertyData;
            }
            else if (ulId == DSPROPERTY_EAX_DAMPING)
            {
                if ((float)*(float*)pPropertyData > 2.0f || (float)*(float*)pPropertyData < 0.f)
                {
                    DSND_WARN("INVALID DSPROPERTY_EAX_DAMPING");
                    return DSERR_INVALIDPARAM;
                }
                props.fDamping = (float)*(float*)pPropertyData;
            }
        }
        SetEAX10Props(&props);
        return S_OK;
    }
    HRESULT Get3(ULONG id, LPVOID iData, ULONG iDataLength, LPVOID Data, ULONG DataLength, PULONG ByteCount)
    {
        if (iData != nullptr || iDataLength != 0 || Data == nullptr || id > DSPROPERTY_EAXLISTENER_FLAGS) {
            DSND_WARN("BAD PARAMS"); return DSERR_INVALIDPARAM;
        }
        auto eax3props = GetEAX30Props();
        if (id == DSPROPERTY_EAXLISTENER_ALLPARAMETERS)
        {
            if (DataLength < sizeof(EAX30LISTENERPROPERTIES))
            {
                DSND_WARN((std::string("DSPROPERTY_EAX30LISTENER_ALLPARAMETERS BAD BUFF SIZE: ") + std::to_string(DataLength)).c_str());
                return DSERR_INVALIDPARAM;
            }
            memcpy(Data, eax3props.get(), sizeof(EAX30LISTENERPROPERTIES));
            *ByteCount = sizeof(EAX30LISTENERPROPERTIES);
            return DS_OK;
        }
        if (DataLength < sizeof(float)) /* long or float, same size */
        {
            DSND_WARN((std::string("DSPROPERTY_EAX30LISTENER BAD BUFF SIZE: ") + std::to_string(DataLength) + " " + std::to_string(id)).c_str());
            return DSERR_INVALIDPARAM;
        }       
        EAX3_GET(ulEnvironment, ENVIRONMENT, LONG)
        EAX3_GET(flEnvironmentSize, ENVIRONMENTSIZE, float)
        EAX3_GET(flEnvironmentDiffusion, ENVIRONMENTDIFFUSION, float)
        EAX3_GET(lRoom, ROOM, LONG)
        EAX3_GET(lRoomHF, ROOMHF, LONG)
        EAX3_GET(lRoomLF, ROOMLF, LONG)
        EAX3_GET(flDecayTime, DECAYTIME, float)
        EAX3_GET(flDecayHFRatio, DECAYHFRATIO, float)
        EAX3_GET(flDecayLFRatio, DECAYLFRATIO, float)
        EAX3_GET(lReflections, REFLECTIONS, LONG)
        EAX3_GET(flReflectionsDelay, REFLECTIONSDELAY, float)
        EAX3_GET(lReverb, REVERB, LONG)
        EAX3_GET(flReverbDelay, REVERBDELAY, float)
        EAX3_GET(flEchoTime, ECHOTIME, float)
        EAX3_GET(flEchoDepth, ECHODEPTH, float)
        EAX3_GET(flModulationTime, MODULATIONTIME, float)
        EAX3_GET(flModulationDepth, MODULATIONDEPTH, float)
        EAX3_GET(flAirAbsorptionHF, AIRABSORPTIONHF, float)
        EAX3_GET(flHFReference, HFREFERENCE, float)
        EAX3_GET(flLFReference, LFREFERENCE, float)
        EAX3_GET(flRoomRolloffFactor, ROOMROLLOFFFACTOR, float)
        EAX3_GET(ulFlags, FLAGS, ULONG)
    }
    HRESULT Get2(ULONG id, LPVOID iData, ULONG iDataLength, LPVOID Data, ULONG DataLength, PULONG ByteCount)
    {
        if (iData != nullptr || iDataLength != 0 || Data == nullptr || id > DSPROPERTY_EAX20LISTENER_FLAGS)  {
            DSND_WARN("BAD PARAMS"); return DSERR_INVALIDPARAM;
        }
        auto eax2props = GetEAX20Props();
        if (id == DSPROPERTY_EAX20LISTENER_ALLPARAMETERS)
        {
            if (DataLength < sizeof(EAX20LISTENERPROPERTIES))
            {
                DSND_WARN((std::string("DSPROPERTY_EAX20LISTENER_ALLPARAMETERS BAD BUFF SIZE: ") + std::to_string(DataLength)).c_str());
                return DSERR_INVALIDPARAM;
            }
            memcpy(Data, eax2props.get(), sizeof(EAX20LISTENERPROPERTIES));
            *ByteCount = sizeof(EAX20LISTENERPROPERTIES);
            return DS_OK;
        }
        if (DataLength < sizeof(float)) /* long or float, same size */
        {
            DSND_WARN((std::string("DSPROPERTY_EAX20LISTENER BAD BUFF SIZE: ") + std::to_string(DataLength) + " " + std::to_string(id)).c_str());
            return DSERR_INVALIDPARAM;
        }
        EAX2_GET(lRoom, ROOM, LONG)
        EAX2_GET(lRoomHF, ROOMHF, LONG)
        EAX2_GET(flRoomRolloffFactor, ROOMROLLOFFFACTOR, float)
        EAX2_GET(flDecayTime, DECAYTIME, float)
        EAX2_GET(flDecayHFRatio, DECAYHFRATIO, float)
        EAX2_GET(lReflections, REFLECTIONS, LONG)
        EAX2_GET(flReflectionsDelay, REFLECTIONSDELAY, float)
        EAX2_GET(lReverb, REVERB, LONG)
        EAX2_GET(flReverbDelay, REVERBDELAY, float)
        EAX2_GET(dwEnvironment, ENVIRONMENT, ULONG)
        EAX2_GET(flEnvironmentSize, ENVIRONMENTSIZE, float)
        EAX2_GET(flEnvironmentDiffusion, ENVIRONMENTDIFFUSION, float)
        EAX2_GET(flAirAbsorptionHF, AIRABSORPTIONHF, float)
        EAX2_GET(dwFlags, FLAGS, ULONG)
    }   
    HRESULT Get(ULONG id, LPVOID iData, ULONG iDataLength, LPVOID Data, ULONG DataLength, PULONG ByteCount)
    {
        if (iData != nullptr || iDataLength != 0 || Data == nullptr || id > DSPROPERTY_EAX_DAMPING)    {
            DSND_WARN("BAD PARAMS");  return DSERR_INVALIDPARAM;
        }

        EAX_REVERBPROPERTIES props;
        GetEAX10Props(&props);

        if (id == DSPROPERTY_EAX_ALL)
        {
            if (DataLength < sizeof(EAX_REVERBPROPERTIES))
            {
                DSND_WARN((std::string("DSPROPERTY_EAX_ALL BAD BUFF SIZE: ") + std::to_string(DataLength)).c_str());
                return DSERR_INVALIDPARAM;
            }
            memcpy(Data, &props, sizeof(EAX_REVERBPROPERTIES));
            *ByteCount = sizeof(EAX_REVERBPROPERTIES);
            return DS_OK;
        }
        if (DataLength < sizeof(float)) /* EAX_REVERBPROPERTIES::environment is ULONG, but same size anyway on 32 bit */
        {
            DSND_WARN((std::string("BAD BUFF SIZE: ") + std::to_string(DataLength) + " " + std::to_string(id)).c_str());
            return DSERR_INVALIDPARAM;
        }
        if (id == DSPROPERTY_EAX_ENVIRONMENT)
        {            
            memcpy(Data, &props.environment, sizeof(float));
            *ByteCount = sizeof(LONG);
            return DS_OK;
        }        
        else if (id == DSPROPERTY_EAX_DECAYTIME)
        {            
            memcpy(Data, &props.fDecayTime_sec, sizeof(float));
            *ByteCount = sizeof(float);
            return DS_OK;
        }
        else if (id == DSPROPERTY_EAX_VOLUME)
        {           
            memcpy(Data, &props.fVolume, sizeof(float));
            *ByteCount = sizeof(float);
            return DS_OK;
        }         
    }
private:
    SYNC::AtomicLock *      m_lock        = nullptr;
    EAX_REVERBPROPERTIES    m_eaxprops    = {0, 0.5F, 1.493F, 0.5F};
    EAX20LISTENERPROPERTIES m_eax2props   = EAX2REVERB_PRESET_GENERIC;
    EAX30LISTENERPROPERTIES m_eax3props   = EAX3REVERB_PRESET_GENERIC;
    EAX20LISTENERPROPERTIES m_eax2props_d = EAX2REVERB_PRESET_GENERIC;
    EAX30LISTENERPROPERTIES m_eax3props_d = EAX3REVERB_PRESET_GENERIC;
};

class EAXVoice {
public:
    void Init() { m_lock = new SYNC::AtomicLock(); }

    unique_ptr<EAXBUFFERPROPERTIES> GetEAX3Props()
    {
        auto props = unique_ptr<EAXBUFFERPROPERTIES>(new EAXBUFFERPROPERTIES);
        m_lock->cpy(props.get(), &m_eax2buffprops, sizeof(EAXBUFFERPROPERTIES));
        return props;
    }

    void SetEAX3Props(EAXBUFFERPROPERTIES* p, BOOL deffered)
    {
        if (p == nullptr)
        {
            DSND_WARN("nullptr")
                return;
        }
        m_lock->cpy(deffered ? &m_eax3buffprops_d : &m_eax3buffprops, p, sizeof(EAXBUFFERPROPERTIES));
    }

    unique_ptr<EAX20BUFFERPROPERTIES> GetEAX2Props()
    {
        auto props = unique_ptr<EAX20BUFFERPROPERTIES>(new EAX20BUFFERPROPERTIES);
        m_lock->cpy(props.get(), &m_eax2buffprops, sizeof(EAX20BUFFERPROPERTIES));
        return props;
    }

    void SetEAX2Props(EAX20BUFFERPROPERTIES* p, BOOL deffered)
    {
        if (p == nullptr)
        {
            DSND_WARN("nullptr")
            return;
        }
        m_lock->cpy(deffered ? &m_eax2buffprops_d : &m_eax2buffprops, p, sizeof(EAX20BUFFERPROPERTIES));
    }

    HRESULT Get3(ULONG id, LPVOID iData, ULONG iDataLength, LPVOID Data, ULONG DataLength, PULONG ByteCount)
    {
        if (iData != nullptr || iDataLength != 0 || Data == nullptr || id > DSPROPERTY_EAXBUFFER_FLAGS) {
            DSND_WARN("BAD PARAMS");   return DSERR_INVALIDPARAM;
        }
        auto eax3buffer = GetEAX3Props();
        if (id == DSPROPERTY_EAXBUFFER_ALLPARAMETERS)
        {
            if (DataLength == sizeof(EAXBUFFERPROPERTIES))
            {
                memcpy(Data, eax3buffer.get(), sizeof(EAXBUFFERPROPERTIES));
                *ByteCount = sizeof(EAXBUFFERPROPERTIES);
                return DS_OK;
            }            
        }
        else if (id == DSPROPERTY_EAXBUFFER_OBSTRUCTION)
        {
            if (DataLength == sizeof(EAXOBSTRUCTIONPROPERTIES))
            {
                memcpy(Data, &eax3buffer.get()->lObstruction, sizeof(EAXOBSTRUCTIONPROPERTIES));
                *ByteCount = sizeof(EAXOBSTRUCTIONPROPERTIES);
                return DS_OK;
            }            
        }
        else if (id == DSPROPERTY_EAXBUFFER_OCCLUSION)
        {
            if (DataLength == sizeof(EAXOCCLUSIONPROPERTIES))
            {
                memcpy(Data, &eax3buffer.get()->lOcclusion, sizeof(EAXOCCLUSIONPROPERTIES));
                *ByteCount = sizeof(EAXOCCLUSIONPROPERTIES);
                return DS_OK;
            }            
        }
        else if (id == DSPROPERTY_EAXBUFFER_EXCLUSION)
        {
            if (DataLength == sizeof(EAXOCCLUSIONPROPERTIES))
            {
                memcpy(Data, &eax3buffer.get()->lExclusion, sizeof(EAXOCCLUSIONPROPERTIES));
                *ByteCount = sizeof(EAXOCCLUSIONPROPERTIES);
                return DS_OK;
            }           
        }
        if (DataLength < sizeof(float)) /* long or float, same size */
        {
            DSND_WARN((std::string("DSPROPERTY_EAX30BUFFER BAD BUFF SIZE: ") + std::to_string(DataLength) + " " + std::to_string(id)).c_str());
            return DSERR_INVALIDPARAM;
        }
        EAX3BUFF_GET(lDirect, DIRECT, long)
        EAX3BUFF_GET(lDirectHF, DIRECTHF, long)
        EAX3BUFF_GET(lRoom, ROOM, long)
        EAX3BUFF_GET(lRoomHF, ROOMHF, long)
        EAX3BUFF_GET(lObstruction, OBSTRUCTION, long)
        EAX3BUFF_GET(flObstructionLFRatio, OBSTRUCTIONLFRATIO, float)
        EAX3BUFF_GET(lOcclusion, OCCLUSION, long)
        EAX3BUFF_GET(flOcclusionLFRatio, OCCLUSIONLFRATIO, float)
        EAX3BUFF_GET(flOcclusionRoomRatio, OCCLUSIONROOMRATIO, float)
        EAX3BUFF_GET(flOcclusionDirectRatio, OCCLUSIONDIRECTRATIO, float)
        EAX3BUFF_GET(lExclusion, EXCLUSION, long)
        EAX3BUFF_GET(flExclusionLFRatio, EXCLUSIONLFRATIO, float)
        EAX3BUFF_GET(lOutsideVolumeHF, OUTSIDEVOLUMEHF, long)
        EAX3BUFF_GET(flDopplerFactor, DOPPLERFACTOR, float)
        EAX3BUFF_GET(flRolloffFactor, ROLLOFFFACTOR, float)
        EAX3BUFF_GET(flRoomRolloffFactor, ROOMROLLOFFFACTOR, float)
        EAX3BUFF_GET(flAirAbsorptionFactor, AIRABSORPTIONFACTOR, float)
        EAX3BUFF_GET(ulFlags, FLAGS, float)            
    }

    HRESULT Get2(ULONG id, LPVOID iData, ULONG iDataLength, LPVOID Data, ULONG DataLength, PULONG ByteCount)
    {
        if (iData != nullptr || iDataLength != 0 || Data == nullptr || id > DSPROPERTY_EAX20BUFFER_FLAGS)  {
            DSND_WARN("BAD PARAMS");   return DSERR_INVALIDPARAM;
        }
        auto eax2buffer = GetEAX2Props();
        if (id == DSPROPERTY_EAX20BUFFER_ALLPARAMETERS)
        {
            if (DataLength < sizeof(EAX20BUFFERPROPERTIES))
            {
                DSND_WARN((std::string("DSPROPERTY_EAX20BUFFER_ALLPARAMETERS BAD BUFF SIZE: ") + std::to_string(DataLength)).c_str());
                return DSERR_INVALIDPARAM;
            }
            memcpy(Data, eax2buffer.get(), sizeof(EAX20BUFFERPROPERTIES));
            *ByteCount = sizeof(EAX20BUFFERPROPERTIES);
            return DS_OK;
        }
        if (DataLength < sizeof(float)) /* long or float, same size */
        {
            DSND_WARN((std::string("DSPROPERTY_EAX20BUFFER BAD BUFF SIZE: ") + std::to_string(DataLength) + " " + std::to_string(id)).c_str());
            return DSERR_INVALIDPARAM;
        }
        EAX2BUFF_GET(lDirect, DIRECT, LONG)
        EAX2BUFF_GET(lDirectHF, DIRECTHF, LONG)
        EAX2BUFF_GET(lRoom, ROOM, LONG)
        EAX2BUFF_GET(lRoomHF, ROOMHF, LONG)
        EAX2BUFF_GET(flRoomRolloffFactor, ROOMROLLOFFFACTOR, float)
        EAX2BUFF_GET(lObstruction, OBSTRUCTION, LONG)
        EAX2BUFF_GET(flObstructionLFRatio, OBSTRUCTIONLFRATIO, float)
        EAX2BUFF_GET(lOcclusion, OCCLUSION, LONG)
        EAX2BUFF_GET(flOcclusionLFRatio, OCCLUSIONLFRATIO, float)
        EAX2BUFF_GET(flOcclusionRoomRatio, OCCLUSIONROOMRATIO, float)
        EAX2BUFF_GET(lOutsideVolumeHF, OUTSIDEVOLUMEHF, LONG)
        EAX2BUFF_GET(flAirAbsorptionFactor, AIRABSORPTIONFACTOR, float)
        EAX2BUFF_GET(dwFlags, FLAGS, ULONG)    
    }

    HRESULT Get(ULONG id, LPVOID iData, ULONG iDataLength, LPVOID Data, ULONG DataLength, PULONG ByteCount)
    {
        if (iData != nullptr || iDataLength != 0 || Data == nullptr || id > DSPROPERTY_EAXBUFFER_REVERBMIX || DataLength < sizeof(float))
        {
            DSND_WARN("BAD PARAMS");
            return DSERR_INVALIDPARAM;
        }
        m_lock->lock(); memcpy(Data, &m_eaxbuffprops.fMix, sizeof(float)); m_lock->unlock();
        *ByteCount = sizeof(float);
        return S_OK;
    }

    HRESULT Set3(ULONG ulId, LPVOID pInstanceData, ULONG ulInstanceLength, LPVOID pPropertyData, ULONG ulDataLength)
    {
        if (pInstanceData != nullptr || ulInstanceLength != 0 || pPropertyData == nullptr || ulId > DSPROPERTY_EAXBUFFER_FLAGS) {
            DSND_WARN("BAD PARAMS"); return DSERR_INVALIDPARAM;
        }

        BOOL deffered   = ulId & DSPROPERTY_EAXBUFFER_DEFERRED;
        ulId            &= ~DSPROPERTY_EAXBUFFER_DEFERRED;              
        auto buffprops3 = GetEAX3Props();
        if (ulId == DSPROPERTY_EAXBUFFER_COMMITDEFERREDSETTINGS)
        {
            m_lock->cpy(&m_eax3buffprops_d, &m_eax3buffprops_d, sizeof(EAXBUFFERPROPERTIES));
            return S_OK;
        }
        EAXBUFFERPROPERTIES* new_Buffprops3 = (EAXBUFFERPROPERTIES*)pPropertyData;

        if (ulId == DSPROPERTY_EAXBUFFER_ALLPARAMETERS)
        {
            if (ulDataLength != sizeof(EAXBUFFERPROPERTIES))
            {
                DSND_WARN((std::string("DSPROPERTY_EAX30BUFFER_ALLPARAMETERS Bad ulDataLength ") + to_string(ulDataLength) + " " + to_string(sizeof(EAXBUFFERPROPERTIES))).c_str())
                return DSERR_INVALIDPARAM;
            }
            EAXBUFF3_VALIDADE(lDirect, DIRECT)
            EAXBUFF3_VALIDADE(lDirectHF, DIRECTHF)
            EAXBUFF3_VALIDADE(lRoom, ROOM)
            EAXBUFF3_VALIDADE(lRoomHF, ROOMHF)            
            EAXBUFF3_VALIDADE(lObstruction, OBSTRUCTION)
            EAXBUFF3_VALIDADE(flObstructionLFRatio, OBSTRUCTIONLFRATIO)
            EAXBUFF3_VALIDADE(lOcclusion, OCCLUSION)
            EAXBUFF3_VALIDADE(flOcclusionLFRatio, OCCLUSIONLFRATIO)
            EAXBUFF3_VALIDADE(flOcclusionRoomRatio, OCCLUSIONROOMRATIO)
            EAXBUFF3_VALIDADE(flOcclusionDirectRatio, OCCLUSIONDIRECTRATIO)
            EAXBUFF3_VALIDADE(lExclusion, EXCLUSION)
            EAXBUFF3_VALIDADE(flExclusionLFRatio, EXCLUSIONLFRATIO)             
            EAXBUFF3_VALIDADE(lOutsideVolumeHF, OUTSIDEVOLUMEHF)
            EAXBUFF3_VALIDADE(flDopplerFactor, DOPPLERFACTOR)
            EAXBUFF3_VALIDADE(flRolloffFactor, ROLLOFFFACTOR)
            EAXBUFF3_VALIDADE(flRoomRolloffFactor, ROOMROLLOFFFACTOR)
            EAXBUFF3_VALIDADE(flAirAbsorptionFactor, AIRABSORPTIONFACTOR)
            memcpy(buffprops3.get(), pPropertyData, ulDataLength);
        }
        else if (ulId == DSPROPERTY_EAXBUFFER_OBSTRUCTION)
        {
            if (ulDataLength == sizeof(EAXOBSTRUCTIONPROPERTIES))
            {
                EAX3BUFF_VALIDADEAND_SET(lObstruction, OBSTRUCTION, long)
                else EAX3BUFF_VALIDADEAND_SET(flObstructionLFRatio, OBSTRUCTIONLFRATIO, float)
            }                    
        }
        else if (ulId == DSPROPERTY_EAXBUFFER_OCCLUSION)
        {
            if (ulDataLength == sizeof(EAXOCCLUSIONPROPERTIES))
            {
                EAX3BUFF_VALIDADEAND_SET(lOcclusion, OCCLUSION, long)
                else EAX3BUFF_VALIDADEAND_SET(flOcclusionLFRatio, OCCLUSIONLFRATIO, float)
                else EAX3BUFF_VALIDADEAND_SET(flOcclusionRoomRatio, OCCLUSIONROOMRATIO, float)
                else EAX3BUFF_VALIDADEAND_SET(flOcclusionDirectRatio, OCCLUSIONDIRECTRATIO, float)
            }                       
        }
        else if (ulId == DSPROPERTY_EAXBUFFER_EXCLUSION)
        {
            if (ulDataLength != sizeof(EAXOCCLUSIONPROPERTIES))
            {
                EAX3BUFF_VALIDADEAND_SET(lExclusion, EXCLUSION, long)
                else EAX3BUFF_VALIDADEAND_SET(flExclusionLFRatio, EXCLUSIONLFRATIO, float)
            }            
        }
        else
        {
            if (ulDataLength != sizeof(float)) /* all are long or float */
            {
                DSND_WARN((std::string("BAD BUFF SIZE: ") + std::to_string(ulDataLength) + " " + std::to_string(ulId)).c_str());
                return DSERR_INVALIDPARAM;
            }
            EAX3BUFF_VALIDADEAND_SET(lDirect, DIRECT, long)
            else EAX3BUFF_VALIDADEAND_SET(lDirectHF, DIRECTHF, long)
            else EAX3BUFF_VALIDADEAND_SET(lRoom, ROOM, long)
            else EAX3BUFF_VALIDADEAND_SET(lRoomHF, ROOMHF, long)
            else EAX3BUFF_VALIDADEAND_SET(lObstruction, OBSTRUCTION, long)
            else EAX3BUFF_VALIDADEAND_SET(flObstructionLFRatio, OBSTRUCTIONLFRATIO, float)
            else EAX3BUFF_VALIDADEAND_SET(lOcclusion, OCCLUSION, long)
            else EAX3BUFF_VALIDADEAND_SET(flOcclusionLFRatio, OCCLUSIONLFRATIO, float)
            else EAX3BUFF_VALIDADEAND_SET(flOcclusionRoomRatio, OCCLUSIONROOMRATIO, float)
            else EAX3BUFF_VALIDADEAND_SET(flOcclusionDirectRatio, OCCLUSIONDIRECTRATIO, float)
            else EAX3BUFF_VALIDADEAND_SET(lExclusion, EXCLUSION, long)
            else EAX3BUFF_VALIDADEAND_SET(flExclusionLFRatio, EXCLUSIONLFRATIO, float)
            else EAX3BUFF_VALIDADEAND_SET(lOutsideVolumeHF, OUTSIDEVOLUMEHF, long)
            else EAX3BUFF_VALIDADEAND_SET(flDopplerFactor, DOPPLERFACTOR, float)
            else EAX3BUFF_VALIDADEAND_SET(flRolloffFactor, ROLLOFFFACTOR, float)
            else EAX3BUFF_VALIDADEAND_SET(flRoomRolloffFactor, ROOMROLLOFFFACTOR, float)
            else EAX3BUFF_VALIDADEAND_SET(flAirAbsorptionFactor, AIRABSORPTIONFACTOR, float)
            else if (ulId == DSPROPERTY_EAXBUFFER_FLAGS) memcpy(&buffprops3.get()->ulFlags, pPropertyData, ulDataLength);
        }
        SetEAX3Props(buffprops3.get(), deffered);
        return S_OK;
    }

    HRESULT Set2(ULONG ulId, LPVOID pInstanceData, ULONG ulInstanceLength, LPVOID pPropertyData, ULONG ulDataLength)
    {

        if (pInstanceData != nullptr || ulInstanceLength != 0 || pPropertyData == nullptr || ulId > DSPROPERTY_EAX20BUFFER_FLAGS)  {
            DSND_WARN("BAD PARAMS"); return DSERR_INVALIDPARAM;
        }
        BOOL deffered  = ulId & DSPROPERTY_EAX20BUFFER_DEFERRED;
        ulId           &= ~DSPROPERTY_EAX20BUFFER_DEFERRED;
        auto buffprops2 = GetEAX2Props();
        if (ulId == DSPROPERTY_EAX20BUFFER_COMMITDEFERREDSETTINGS)
        {
            m_lock->cpy(&m_eax2buffprops_d, &m_eax2buffprops_d, sizeof(EAX20BUFFERPROPERTIES));
            return S_OK;
        }        
        EAX20BUFFERPROPERTIES* new_Buffprops2 = (EAX20BUFFERPROPERTIES*)pPropertyData;

        if (ulId == DSPROPERTY_EAX20BUFFER_ALLPARAMETERS)
        {
            if (ulDataLength != sizeof(EAX20BUFFERPROPERTIES))
            {
                DSND_WARN("DSPROPERTY_EAX20BUFFER_ALLPARAMETERS Bad ulDataLength")
                return DSERR_INVALIDPARAM;
            }
            EAXBUFF2_VALIDADE(lDirect, DIRECT)
            EAXBUFF2_VALIDADE(lDirectHF, DIRECTHF)
            EAXBUFF2_VALIDADE(lRoom, ROOM)
            EAXBUFF2_VALIDADE(lRoomHF, ROOMHF)
            EAXBUFF2_VALIDADE(flRoomRolloffFactor, ROOMROLLOFFFACTOR)
            EAXBUFF2_VALIDADE(lObstruction, OBSTRUCTION)
            EAXBUFF2_VALIDADE(flObstructionLFRatio, OBSTRUCTIONLFRATIO)
            EAXBUFF2_VALIDADE(lOcclusion, OCCLUSION)
            EAXBUFF2_VALIDADE(flOcclusionLFRatio, OCCLUSIONLFRATIO)
            EAXBUFF2_VALIDADE(flOcclusionRoomRatio, OCCLUSIONROOMRATIO)
            EAXBUFF2_VALIDADE(lOutsideVolumeHF, OUTSIDEVOLUMEHF)
            EAXBUFF2_VALIDADE(flAirAbsorptionFactor, AIRABSORPTIONFACTOR)
            memcpy(buffprops2.get(), pPropertyData, ulDataLength);
        }
        else
        {
            if (ulDataLength != sizeof(float)) /* all are long or float */
            {
                DSND_WARN((std::string("BAD BUFF SIZE: ") + std::to_string(ulDataLength) + " " + std::to_string(ulId)).c_str());
                return DSERR_INVALIDPARAM;
            }
            EAX2BUFF_VALIDADEAND_SET(lDirect, DIRECT, long)
            else EAX2BUFF_VALIDADEAND_SET(lDirectHF, DIRECTHF, long)
            else EAX2BUFF_VALIDADEAND_SET(lRoom, ROOM, long)
            else EAX2BUFF_VALIDADEAND_SET(lRoomHF, ROOMHF, long)
            else EAX2BUFF_VALIDADEAND_SET(lDirectHF, DIRECTHF, long)
            else EAX2BUFF_VALIDADEAND_SET(flRoomRolloffFactor, ROOMROLLOFFFACTOR, float)
            else EAX2BUFF_VALIDADEAND_SET(lObstruction, OBSTRUCTION, long)
            else EAX2BUFF_VALIDADEAND_SET(flObstructionLFRatio, OBSTRUCTIONLFRATIO, float)
            else EAX2BUFF_VALIDADEAND_SET(lOcclusion, OCCLUSION, long)
            else EAX2BUFF_VALIDADEAND_SET(flOcclusionLFRatio, OCCLUSIONLFRATIO, float)
            else EAX2BUFF_VALIDADEAND_SET(flOcclusionRoomRatio, OCCLUSIONROOMRATIO, float)
            else EAX2BUFF_VALIDADEAND_SET(lOutsideVolumeHF, OUTSIDEVOLUMEHF, long)
            else EAX2BUFF_VALIDADEAND_SET(flAirAbsorptionFactor, AIRABSORPTIONFACTOR, float)
            else if (ulId == DSPROPERTY_EAX20BUFFER_FLAGS) memcpy(&buffprops2.get()->dwFlags, pPropertyData, ulDataLength);
        }
        SetEAX2Props(buffprops2.get(), deffered);        
        return S_OK;
    }

    HRESULT Set(ULONG ulId, LPVOID pInstanceData, ULONG ulInstanceLength, LPVOID pPropertyData, ULONG ulDataLength)
    {
        if (pInstanceData != nullptr || ulInstanceLength != 0 || pPropertyData == nullptr || ulId > DSPROPERTY_EAXBUFFER_REVERBMIX || ulDataLength != sizeof(float))
        {
            DSND_WARN("BAD PARAMS");
            return DSERR_INVALIDPARAM;
        }
        m_lock->lock();
        memcpy(&m_eaxbuffprops.fMix, pPropertyData, ulDataLength);
        m_lock->unlock();        
        return S_OK;
    }

    unique_ptr<DSFXI3DL2Reverb> I3DL2(EAX_REVERBPROPERTIES * listener)
    {
        auto rvrb = unique_ptr<DSFXI3DL2Reverb>(new DSFXI3DL2Reverb);  
        memcpy(rvrb.get(), &DSOUND_I3DL2_PRESETS[listener->environment], sizeof(DSFXI3DL2Reverb));
        rvrb.get()->flDecayTime    = listener->fDecayTime_sec;
        rvrb.get()->flDecayHFRatio = listener->fDamping;
        rvrb.get()->lRoom          = 0;
        rvrb.get()->lRoomHF        = 0;
        rvrb.get()->lReflections   = 1000;
        rvrb.get()->lReverb        = 2000;
        return rvrb;
    }

    unique_ptr<DSFXI3DL2Reverb> I3DL2(EAX20LISTENERPROPERTIES* listener)
    {
        auto buffprops = GetEAX2Props();
        auto rvrb      = unique_ptr<DSFXI3DL2Reverb>(new DSFXI3DL2Reverb);
        memcpy(rvrb.get(), &DSOUND_I3DL2_PRESETS[listener->dwEnvironment], sizeof(DSFXI3DL2Reverb));
        rvrb.get()->lRoom              = DSFX_I3DL2REVERB_ROOM_MAX;
        rvrb.get()->lRoom              = listener->lRoom + buffprops.get()->lRoom;
        rvrb.get()->lRoomHF            = listener->lRoomHF + buffprops.get()->lRoomHF;
        rvrb.get()->flDecayTime        = listener->flDecayTime;
        rvrb.get()->flDecayHFRatio     = listener->flDecayHFRatio;
        rvrb.get()->lReflections       = listener->lReflections;
        rvrb.get()->flReflectionsDelay = listener->flReflectionsDelay;
        rvrb.get()->lReverb            = listener->lReverb;
        rvrb.get()->flReverbDelay      = listener->flReverbDelay;
        rvrb.get()->flDiffusion        = listener->flEnvironmentDiffusion;

        rvrb.get()->lRoom        = 0;
        rvrb.get()->lRoomHF      = 0;
        rvrb.get()->lReflections = 1000;
        rvrb.get()->lReverb      = 2000;

        if (buffprops.get()->lObstruction < 0)
        {
            float ObstructionHF    = cdb_to_linear((float)buffprops.get()->lObstruction);
            float ObstructionLF    = ObstructionHF / buffprops.get()->flObstructionLFRatio;
            float ObstructionLFdb  = linear_2_cdb(ObstructionLF);
            rvrb.get()->lRoom     += ObstructionLFdb;
            rvrb.get()->lRoomHF   += linear_2_cdb(ObstructionHF) - ObstructionLFdb;
        }
        if (buffprops.get()->lOcclusion < 0)
        {
            float OcclusionHF   = cdb_to_linear((float)buffprops.get()->lOcclusion);
            float OcclusionLF   = OcclusionHF / buffprops.get()->flOcclusionLFRatio;
            float OcclusionR    = OcclusionHF / buffprops.get()->flOcclusionRoomRatio;
            float OcclusionLFdb = linear_2_cdb(OcclusionLF);
            rvrb.get()->lRoom   += OcclusionLFdb;
            rvrb.get()->lRoomHF += linear_2_cdb(OcclusionHF) - OcclusionLFdb;
            rvrb.get()->lReverb += linear_2_cdb(CLAMP(OcclusionR, 0.f, 1.f));
        }
        return rvrb;
    }

    unique_ptr<DSFXI3DL2Reverb> I3DL2(EAX30LISTENERPROPERTIES* listener)
    {
        auto buffprops = GetEAX3Props();
        auto rvrb      = unique_ptr<DSFXI3DL2Reverb>(new DSFXI3DL2Reverb);
        memcpy(rvrb.get(), &DSOUND_I3DL2_PRESETS[listener->ulEnvironment], sizeof(DSFXI3DL2Reverb));
        rvrb.get()->lRoom              = DSFX_I3DL2REVERB_ROOM_MAX;
        rvrb.get()->lRoom              = listener->lRoom + buffprops.get()->lRoom;
        rvrb.get()->lRoomHF            = listener->lRoomHF + buffprops.get()->lRoomHF;
        rvrb.get()->flDecayTime        = listener->flDecayTime;
        rvrb.get()->flDecayHFRatio     = listener->flDecayHFRatio;
        rvrb.get()->lReflections       = listener->lReflections;
        rvrb.get()->flReflectionsDelay = listener->flReflectionsDelay;
        rvrb.get()->lReverb            = listener->lReverb;
        rvrb.get()->flReverbDelay      = listener->flReverbDelay;
        rvrb.get()->flDiffusion        = listener->flEnvironmentDiffusion;
        rvrb.get()->flHFReference      = listener->flHFReference;

        rvrb.get()->lRoom        = 0;
        rvrb.get()->lRoomHF      = 0;
        rvrb.get()->lReflections = 1000;
        rvrb.get()->lReverb      = 2000;

        if (buffprops.get()->lObstruction < 0)
        {
            float ObstructionHF    = cdb_to_linear((float)buffprops.get()->lObstruction);
            float ObstructionLF    = ObstructionHF / buffprops.get()->flObstructionLFRatio;
            float ObstructionLFdb  = linear_2_cdb(ObstructionLF);
            rvrb.get()->lRoom     += ObstructionLFdb;
            rvrb.get()->lRoomHF   += linear_2_cdb(ObstructionHF) - ObstructionLFdb;
        }
        if (buffprops.get()->lOcclusion < 0)
        {
            float OcclusionHF    = cdb_to_linear((float)buffprops.get()->lOcclusion);
            float OcclusionLF    = OcclusionHF / buffprops.get()->flOcclusionLFRatio;
            float OcclusionR     = OcclusionHF / buffprops.get()->flOcclusionRoomRatio;
            float OcclusionLFdb  = linear_2_cdb(OcclusionLF);
            rvrb.get()->lRoom   += OcclusionLFdb;
            rvrb.get()->lRoomHF += linear_2_cdb(OcclusionHF) - OcclusionLFdb;
            rvrb.get()->lReverb += linear_2_cdb(CLAMP(OcclusionR, 0.f, 1.f));
        }
        if (buffprops.get()->lExclusion < 0)
        {                   
            rvrb.get()->lReflections += buffprops.get()->lExclusion;
        }
        return rvrb;
    }

    unique_ptr<DSFXEcho> Echo(EAX30LISTENERPROPERTIES* listener)
    {
        auto echo = unique_ptr<DSFXEcho>(new DSFXEcho);
        echo.get()->fWetDryMix  = listener->flEchoDepth * 100.0f;
        echo.get()->fLeftDelay  = listener->flDecayTime * 1000.f;
        echo.get()->fRightDelay = echo.get()->fLeftDelay;
        echo.get()->lPanDelay   = 0;
        echo.get()->fFeedback   = 100.f * (1 - listener->flEnvironmentDiffusion);  // Linear ?... no documentation
        return echo;
    }

    float fMix() {
        m_lock->lock(); float f = m_eaxbuffprops.fMix; m_lock->unlock();
        return f;
    }
private:
    SYNC::AtomicLock* m_lock                   = nullptr;
    EAXBUFFER_REVERBPROPERTIES m_eaxbuffprops  = { -1 };
    EAX20BUFFERPROPERTIES      m_eax2buffprops = {EAX20BUFFER_DEFAULTDIRECT, 
                                                  EAX20BUFFER_DEFAULTDIRECTHF, 
                                                  EAX20BUFFER_DEFAULTROOM, 
                                                  EAX20BUFFER_DEFAULTROOMHF,
                                                  EAX20BUFFER_DEFAULTROOMROLLOFFFACTOR, 
                                                  EAX20BUFFER_DEFAULTOBSTRUCTION,EAX20BUFFER_DEFAULTOBSTRUCTIONLFRATIO,
                                                  EAX20BUFFER_DEFAULTOCCLUSION, EAX20BUFFER_DEFAULTOCCLUSIONLFRATIO, EAX20BUFFER_DEFAULTOCCLUSIONROOMRATIO,
                                                  EAX20BUFFER_DEFAULTOUTSIDEVOLUMEHF, 
                                                  EAX20BUFFER_DEFAULTAIRABSORPTIONFACTOR,
                                                  EAX20BUFFERFLAGS_DIRECTHFAUTO | EAX20BUFFERFLAGS_ROOMAUTO | EAX20BUFFERFLAGS_ROOMHFAUTO};
    EAXBUFFERPROPERTIES        m_eax3buffprops = {EAXBUFFER_DEFAULTDIRECT, 
                                                  EAXBUFFER_DEFAULTDIRECTHF, 
                                                  EAXBUFFER_DEFAULTROOM, 
                                                  EAXBUFFER_DEFAULTROOMHF,
                                                  EAXBUFFER_DEFAULTOBSTRUCTION, EAXBUFFER_DEFAULTOBSTRUCTIONLFRATIO, 
                                                  EAXBUFFER_DEFAULTOCCLUSION, EAXBUFFER_DEFAULTOCCLUSIONLFRATIO,  EAXBUFFER_DEFAULTOCCLUSIONROOMRATIO, EAXBUFFER_DEFAULTOCCLUSIONDIRECTRATIO, 
                                                  EAXBUFFER_DEFAULTEXCLUSION, EAXBUFFER_DEFAULTEXCLUSIONLFRATIO, 
                                                  EAXBUFFER_DEFAULTOUTSIDEVOLUMEHF, EAXBUFFER_DEFAULTDOPPLERFACTOR, 
                                                  EAXBUFFER_DEFAULTROLLOFFFACTOR, 
                                                  EAXBUFFER_DEFAULTROOMROLLOFFFACTOR,  
                                                  EAXBUFFER_DEFAULTAIRABSORPTIONFACTOR, 
                                                  EAXBUFFER_DEFAULTFLAGS};    
    EAX20BUFFERPROPERTIES      m_eax2buffprops_d  = {EAX20BUFFER_DEFAULTDIRECT,
                                                  EAX20BUFFER_DEFAULTDIRECTHF,
                                                  EAX20BUFFER_DEFAULTROOM,
                                                  EAX20BUFFER_DEFAULTROOMHF,
                                                  EAX20BUFFER_DEFAULTROOMROLLOFFFACTOR,
                                                  EAX20BUFFER_DEFAULTOBSTRUCTION,EAX20BUFFER_DEFAULTOBSTRUCTIONLFRATIO,
                                                  EAX20BUFFER_DEFAULTOCCLUSION, EAX20BUFFER_DEFAULTOCCLUSIONLFRATIO, EAX20BUFFER_DEFAULTOCCLUSIONROOMRATIO,
                                                  EAX20BUFFER_DEFAULTOUTSIDEVOLUMEHF,
                                                  EAX20BUFFER_DEFAULTAIRABSORPTIONFACTOR,
                                                  EAX20BUFFERFLAGS_DIRECTHFAUTO | EAX20BUFFERFLAGS_ROOMAUTO | EAX20BUFFERFLAGS_ROOMHFAUTO };
    EAXBUFFERPROPERTIES        m_eax3buffprops_d  = {EAXBUFFER_DEFAULTDIRECT,
                                                  EAXBUFFER_DEFAULTDIRECTHF,
                                                  EAXBUFFER_DEFAULTROOM,
                                                  EAXBUFFER_DEFAULTROOMHF,
                                                  EAXBUFFER_DEFAULTOBSTRUCTION, EAXBUFFER_DEFAULTOBSTRUCTIONLFRATIO,
                                                  EAXBUFFER_DEFAULTOCCLUSION, EAXBUFFER_DEFAULTOCCLUSIONLFRATIO,  EAXBUFFER_DEFAULTOCCLUSIONROOMRATIO, EAXBUFFER_DEFAULTOCCLUSIONDIRECTRATIO,
                                                  EAXBUFFER_DEFAULTEXCLUSION, EAXBUFFER_DEFAULTEXCLUSIONLFRATIO,
                                                  EAXBUFFER_DEFAULTOUTSIDEVOLUMEHF, EAXBUFFER_DEFAULTDOPPLERFACTOR,
                                                  EAXBUFFER_DEFAULTROLLOFFFACTOR,
                                                  EAXBUFFER_DEFAULTROOMROLLOFFFACTOR,
                                                  EAXBUFFER_DEFAULTAIRABSORPTIONFACTOR,
                                                  EAXBUFFER_DEFAULTFLAGS };
};

#endif // EAX_PROPS_H
