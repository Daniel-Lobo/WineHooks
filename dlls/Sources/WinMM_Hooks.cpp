#include <windows.h>
#include <dsound.h>
#include "WinMM_Hooks.h"
#include "Dbug.h"
#include <string>
#include "sethooks.h"
#include "Sync.h"
#pragma comment(lib, "Winmm")

mixerGetLineInfoAType             mixerGetLineInfoATrampoline;
mixerGetLineControlsAType     mixerGetLineControlsATrampoline;
mixerSetControlDetailsAType mixerSetControlDetailsATrampoline;
mixerGetControlDetailsAType mixerGetControlDetailsATrampoline;
HWND                                          g_injector_hwin;
SYNC::Atomic                           *CDLineID, *CDVolumeID;

const char * GetMixerLineString(DWORD l)
{
    static std::string line;
    line.clear();

    if      (l == MIXERLINE_COMPONENTTYPE_DST_DIGITAL)     line.append("MIXERLINE_COMPONENTTYPE_DST_DIGITAL");
    else if (l == MIXERLINE_COMPONENTTYPE_DST_HEADPHONES)  line.append("MIXERLINE_COMPONENTTYPE_DST_HEADPHONES");
    else if (l == MIXERLINE_COMPONENTTYPE_DST_LINE)        line.append("MIXERLINE_COMPONENTTYPE_DST_LINE");
    else if (l == MIXERLINE_COMPONENTTYPE_DST_MONITOR)     line.append("MIXERLINE_COMPONENTTYPE_DST_MONITOR");
    else if (l == MIXERLINE_COMPONENTTYPE_DST_SPEAKERS)    line.append("MIXERLINE_COMPONENTTYPE_DST_SPEAKERS");
    else if (l == MIXERLINE_COMPONENTTYPE_DST_TELEPHONE)   line.append("MIXERLINE_COMPONENTTYPE_DST_TELEPHONE");
    else if (l == MIXERLINE_COMPONENTTYPE_DST_UNDEFINED)   line.append("MIXERLINE_COMPONENTTYPE_DST_UNDEFINED");
    else if (l == MIXERLINE_COMPONENTTYPE_DST_VOICEIN)     line.append("MIXERLINE_COMPONENTTYPE_DST_VOICEIN");
    else if (l == MIXERLINE_COMPONENTTYPE_SRC_ANALOG)      line.append("MIXERLINE_COMPONENTTYPE_SRC_ANALOG");
    else if (l == MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY)   line.append("MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY");
    else if (l == MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC) line.append("MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC");
    else if (l == MIXERLINE_COMPONENTTYPE_SRC_DIGITAL)     line.append("MIXERLINE_COMPONENTTYPE_SRC_DIGITAL");
    else if (l == MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE)  line.append("MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE");
    else if (l == MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER)   line.append("MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER");
    else if (l == MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER) line.append("MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER");
    else if (l == MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE)   line.append("MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE");
    else if (l == MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED)   line.append("MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED");
    else if (l == MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT)     line.append("MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT");
    return line.c_str();
}

const char * GetMixerCntrlString(DWORD l)
{
    static std::string cntrl;
    cntrl.clear();

    if      (l == MIXER_GETLINECONTROLSF_ALL)       cntrl.append("MIXER_GETLINECONTROLSF_ALL");
    else if (l == MIXER_GETLINECONTROLSF_ONEBYID)   cntrl.append("MIXER_GETLINECONTROLSF_ONEBYID");
    else if (l == MIXER_GETLINECONTROLSF_ONEBYTYPE) cntrl.append("MIXER_GETLINECONTROLSF_ONEBYTYPE");
    if      (l == MIXER_OBJECTF_AUX)                cntrl.append(" MIXER_OBJECTF_AUX");
    else if (l == MIXER_OBJECTF_HMIDIIN)            cntrl.append(" MIXER_OBJECTF_HMIDIIN");
    else if (l == MIXER_OBJECTF_HMIDIOUT)           cntrl.append(" MIXER_OBJECTF_HMIDIOUT");
    else if (l == MIXER_OBJECTF_HMIXER)             cntrl.append(" MIXER_OBJECTF_HMIXER");
    else if (l == MIXER_OBJECTF_HWAVEIN)            cntrl.append(" MIXER_OBJECTF_HWAVEIN");
    else if (l == MIXER_OBJECTF_HWAVEOUT)           cntrl.append(" MIXER_OBJECTF_HWAVEOUT");
    else if (l == MIXER_OBJECTF_MIDIIN)             cntrl.append(" MIXER_OBJECTF_MIDIIN");
    else if (l == MIXER_OBJECTF_MIDIOUT)            cntrl.append(" MIXER_OBJECTF_MIDIOUT");
    else if (l == MIXER_OBJECTF_MIXER)              cntrl.append(" MIXER_OBJECTF_MIXER");
    else if (l == MIXER_OBJECTF_WAVEIN)             cntrl.append(" MIXER_OBJECTF_WAVEIN");
    else if (l == MIXER_OBJECTF_WAVEOUT)            cntrl.append(" MIXER_OBJECTF_WAVEOUT");
    return cntrl.c_str();
}


extern "C" __declspec(dllexport) MMRESULT __stdcall mixerGetLineInfoAHook(HMIXEROBJ mixer, LPMIXERLINE line, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)

    MMRESULT m = mixerGetLineInfoATrampoline(mixer, line, flags);
    if (line == nullptr)
    {
        return m;
    }

    if (line->dwComponentType == MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC)
    {
        CDLineID->Set(line->dwLineID);
    }
    return m;
    OUTPUT_FUNC_DBG_STRING( ( std::string(GetMixerLineString(line->dwComponentType))
                              + " " + std::to_string(m) + " ID: " + std::to_string(line->dwLineID) ).c_str() );
    return m;
}

extern "C" __declspec(dllexport) MMRESULT __stdcall mixerGetLineControlsAHook(HMIXEROBJ mixer, LPMIXERLINECONTROLSA cntrls, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    MMRESULT m = mixerGetLineControlsATrampoline(mixer, cntrls, flags);
    if (cntrls == nullptr)
    {
        return m;
    }
    if ( (cntrls->dwLineID == CDLineID->Get()) && (flags & MIXER_GETLINECONTROLSF_ONEBYTYPE) )
    {
        if (cntrls->dwControlType == MIXERCONTROL_CONTROLTYPE_VOLUME)
        CDVolumeID->Set( cntrls->pamxctrl->dwControlID );
        //else
        //OUTPUT_FUNC_DBG_STRING("=============================================================");
    }
    return m;
    OUTPUT_FUNC_DBG_STRING( ( std::string(GetMixerCntrlString(flags))
                             + " " + std::to_string(m) + " LineId: " + std::to_string(cntrls->dwLineID)
                             + " Type: " + std::to_string(cntrls->dwControlID)
                             + " Returned ID: " + std::to_string(cntrls->pamxctrl->dwControlID) ).c_str() );

    return m;
}

extern "C" __declspec(dllexport) MMRESULT __stdcall mixerSetControlDetailsAHook(HMIXEROBJ mixer, LPMIXERCONTROLDETAILS details, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    MMRESULT m = mixerSetControlDetailsATrampoline(mixer, details, flags);
    if (details == nullptr)
    {
        return m;
    }
    MIXERCONTROLDETAILS_UNSIGNED * val = (MIXERCONTROLDETAILS_UNSIGNED*) details->paDetails;
    if ( details->dwControlID == CDVolumeID->Get() )
    {
        //OUTPUT_FUNC_DBG_STRING( ( std::string("Change volume to ") + std::to_string(val->dwValue) ).c_str() );
        SendNotifyMessageA(g_injector_hwin, RegisterWindowMessageA("Peixoto.MCI"), 1000, val->dwValue);
    }
    return m;
    OUTPUT_FUNC_DBG_STRING( (std::string("Controld ID: ") + std::to_string(details->dwControlID)
                             + " Value " +  std::to_string(val->dwValue) ).c_str() );
    return m;
}

extern "C" __declspec(dllexport) MMRESULT __stdcall mixerGetControlDetailsAHook(HMIXEROBJ mixer, LPMIXERCONTROLDETAILS details, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    MMRESULT m = mixerGetControlDetailsATrampoline(mixer, details, flags);
    if (details == nullptr)
    {
        return m;
    }
    MIXERCONTROLDETAILS_UNSIGNED * val = (MIXERCONTROLDETAILS_UNSIGNED*) details->paDetails;
    if ( details->dwControlID == CDVolumeID->Get() )
    {
        //OUTPUT_FUNC_DBG_STRING("=======================================================");
        val->dwValue = SendMessageA(g_injector_hwin, RegisterWindowMessageA("Peixoto.MCI"), 2000, val->dwValue);
    }
    return m;
    OUTPUT_FUNC_DBG_STRING( (std::string("Controld ID: ") + std::to_string(details->dwControlID)
                             + " Value " +  std::to_string(val->dwValue) ).c_str() );
    return m;
}

extern "C" __declspec(dllexport) void __stdcall InitWinMMHooks(HWND hwin, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_injector_hwin = hwin;

    CDLineID   = new SYNC::Atomic();
    CDVolumeID = new SYNC::Atomic();

    mixerGetLineInfoATrampoline = (mixerGetLineInfoAType) mixerGetLineInfoA;
    sethook((void**)&mixerGetLineInfoATrampoline, mixerGetLineInfoAHook);

    mixerGetLineControlsATrampoline = (mixerGetLineControlsAType) mixerGetLineControlsA;
    sethook((void**)&mixerGetLineControlsATrampoline, mixerGetLineControlsAHook);

    mixerSetControlDetailsATrampoline = (mixerSetControlDetailsAType) mixerSetControlDetails;
    sethook((void**)&mixerSetControlDetailsATrampoline, mixerSetControlDetailsAHook);

    mixerGetControlDetailsATrampoline = (mixerGetControlDetailsAType) mixerGetControlDetails;
    sethook((void**)&mixerGetControlDetailsATrampoline, mixerGetControlDetailsAHook);
}

extern "C" __declspec(dllexport) DWORD WINAPI MCINofify(LPVOID lpParameter)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    MCINOTIFICATION * ntf = (MCINOTIFICATION *)lpParameter;
    ntf->SB->AddRef();

    DWORD state = DSBSTATUS_PLAYING;
    while (state & DSBSTATUS_PLAYING)
    {
        WaitForSingleObject(ntf->hEvent, 1);
        ntf->SB->GetStatus(&state);
    }
    ntf->SB->Release();

    if (SetEvent(ntf->hEvent) == 0) OutputDebugStringA("Failed to singnal event");

    if (ntf->Aborted)
    {
        if ( (ntf->hWin) && (ntf->hWinA) )
        {
            PostMessageA(ntf->hWin,  MM_MCINOTIFY,(WPARAM)MCI_NOTIFY_SUPERSEDED,(LPARAM)1);
            PostMessageA(ntf->hWinA, MM_MCINOTIFY,(WPARAM)MCI_NOTIFY_SUCCESSFUL,(LPARAM)1);
        }
        else if (ntf->hWin)
        {
            PostMessageA(ntf->hWin,  MM_MCINOTIFY,(WPARAM)MCI_NOTIFY_ABORTED,(LPARAM)1);
        }
        else if (ntf->hWinA)
        {
            PostMessageA(ntf->hWinA, MM_MCINOTIFY,(WPARAM)MCI_NOTIFY_SUCCESSFUL,(LPARAM)1);
        }
    }
    else if (ntf->hWin)
    {
        PostMessageA(ntf->hWin, MM_MCINOTIFY,(WPARAM)MCI_NOTIFY_SUCCESSFUL,(LPARAM)1);
    }
    return 1;
}
