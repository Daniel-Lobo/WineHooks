#define _X86_
#include <dinput.h>
#include <xinput.h>
#include "DInputHooks.h"
#include <math.h>
#include <string>
#include <stdlib.h>
#include "Dbug.h"
#include "Sync.h"
#include "dllmain.h"
#include <intrin.h>
#include <string>
#include <memory>
#define _USE_MATH_DEFINES
#include <math.h>
#include <sstream>
#include <vector>
#include <memory>
#include "DirectInput.h"
#include "sethooks.h"

using std::string;
using std::to_string;
using std::unique_ptr;
using std::stringstream;
using std::vector;
using std::unique_ptr;

DINPT_HOOKS * DInput_Hooks;
DinputGlobals g_Dinput;

#define DIFFDEBUGPARAMS            \
p->periodic.dwMagnitude = 10000;   \
p->periodic.dwPeriod    = 500000;  \
p->periodic.lOffset     = 0;       \
p->params.dwDuration    = 6000000; \
Sleep(2000);   
#define DIFFDEBUGPARAMS 

void SetEffectName(DIEFFECTINFOW* fx, wchar_t* name)
{
    DWORD size = sizeof(wchar_t) * (wcslen(name) + 1);
    memcpy(fx->tszName, name, size);
}

void SetEffectName(DIEFFECTINFOA * fx, char* name)
{
    DWORD size = sizeof(char) * (strlen(name) + 1);
    memcpy(fx->tszName, name, size);
}

HRESULT STDMETHODCALLTYPE DiGetEffectInfoA(IUnknown *, LPDIEFFECTINFOA fx, REFGUID rguid)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if (fx == nullptr) return DIERR_INVALIDPARAM;
    fx->dwStaticParams = DIEP_ENVELOPE | DIEP_GAIN | DIEP_STARTDELAY | DIEP_TYPESPECIFICPARAMS;
    if      (rguid == GUID_ConstantForce) {fx->dwEffType = DIEFT_CONSTANTFORCE; SetEffectName(fx, "Constant force");}
    else if (rguid == GUID_RampForce)     {fx->dwEffType = DIEFT_RAMPFORCE;     SetEffectName(fx, "Ramp force");    }
    else if (rguid == GUID_Square)        {fx->dwEffType = DIEFT_PERIODIC;      SetEffectName(fx, "Square");        }
    else if (rguid == GUID_Sine)          {fx->dwEffType = DIEFT_PERIODIC;      SetEffectName(fx, "Sine");          }
    else if (rguid == GUID_Triangle)      {fx->dwEffType = DIEFT_PERIODIC;      SetEffectName(fx, "Triangle");      } 
    else if (rguid == GUID_SawtoothUp)    {fx->dwEffType = DIEFT_PERIODIC;      SetEffectName(fx, "SawtoothUp");    }
    else if (rguid == GUID_SawtoothDown)  {fx->dwEffType = DIEFT_PERIODIC;      SetEffectName(fx, "SawtoothDown");  }
    else return DIERR_INVALIDPARAM;
    return DI_OK;
}

HRESULT STDMETHODCALLTYPE DiGetEffectInfoW(IUnknown *, LPDIEFFECTINFOW fx, REFGUID rguid)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (fx == nullptr) return DIERR_INVALIDPARAM;
    fx->dwStaticParams = DIEP_ENVELOPE | DIEP_GAIN | DIEP_STARTDELAY | DIEP_TYPESPECIFICPARAMS;
    if      (rguid == GUID_ConstantForce) { fx->dwEffType = DIEFT_CONSTANTFORCE; SetEffectName(fx, L"Constant force"); }
    else if (rguid == GUID_RampForce)     { fx->dwEffType = DIEFT_RAMPFORCE;     SetEffectName(fx, L"Ramp force");     }
    else if (rguid == GUID_Square)        { fx->dwEffType = DIEFT_PERIODIC;      SetEffectName(fx, L"Square");         }
    else if (rguid == GUID_Sine)          { fx->dwEffType = DIEFT_PERIODIC;      SetEffectName(fx, L"Sine");           }
    else if (rguid == GUID_Triangle)      { fx->dwEffType = DIEFT_PERIODIC;      SetEffectName(fx, L"Triangle");       }
    else if (rguid == GUID_SawtoothUp)    { fx->dwEffType = DIEFT_PERIODIC;      SetEffectName(fx, L"SawtoothUp");     }
    else if (rguid == GUID_SawtoothDown)  { fx->dwEffType = DIEFT_PERIODIC;      SetEffectName(fx, L"SawtoothDown");   }
    else return DIERR_INVALIDPARAM;
    return DI_OK;
}

extern "C" __declspec(dllexport) void DIEnumEffectsA(LPDIENUMEFFECTSCALLBACKA lpCallback, LPVOID pvRef, DWORD dwEffType)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DIEFFECTINFOA fx = {sizeof(DIEFFECTINFO)};    
    if (dwEffType & DIEFT_CONSTANTFORCE || dwEffType == DIEFT_ALL)
    {
        fx.guid            = GUID_ConstantForce;
        fx.dwEffType       = DIEFT_CONSTANTFORCE;
        fx.dwStaticParams  = DIEP_ENVELOPE | DIEP_GAIN | DIEP_STARTDELAY | DIEP_TYPESPECIFICPARAMS;  
        SetEffectName(&fx, "Constant force");
        lpCallback(&fx, pvRef);
    }
    if (dwEffType & DIEFT_CUSTOMFORCE || dwEffType == DIEFT_ALL)
    {
        fx.guid           = GUID_CustomForce;
        fx.dwEffType      = DIEFT_CUSTOMFORCE;
        fx.dwStaticParams = DIEP_ENVELOPE | DIEP_GAIN | DIEP_STARTDELAY | DIEP_TYPESPECIFICPARAMS;
        SetEffectName(&fx, "Custom force");
        lpCallback(&fx, pvRef);
    }
    if (dwEffType & DIEFT_RAMPFORCE || dwEffType == DIEFT_ALL)
    {
        fx.guid           = GUID_RampForce;
        fx.dwEffType      = DIEFT_RAMPFORCE;
        fx.dwStaticParams = DIEP_ENVELOPE | DIEP_GAIN | DIEP_STARTDELAY | DIEP_TYPESPECIFICPARAMS;
        SetEffectName(&fx, "Ramp force");
        lpCallback(&fx, pvRef);
    }
    if (dwEffType & DIEFT_PERIODIC || dwEffType == DIEFT_ALL)
    {
        fx.dwEffType      = DIEFT_PERIODIC;
        fx.dwStaticParams = DIEP_ENVELOPE | DIEP_GAIN | DIEP_STARTDELAY | DIEP_TYPESPECIFICPARAMS;        
        fx.guid = GUID_Square;        SetEffectName(&fx, "Square");        lpCallback(&fx, pvRef);
        fx.guid = GUID_Sine;          SetEffectName(&fx, "Sine");          lpCallback(&fx, pvRef);
        fx.guid = GUID_Triangle;      SetEffectName(&fx, "Triangle");      lpCallback(&fx, pvRef);
        fx.guid = GUID_SawtoothUp;    SetEffectName(&fx, "Sawtooth up");   lpCallback(&fx, pvRef);
        fx.guid = GUID_SawtoothDown;  SetEffectName(&fx, "Sawtooth down"); lpCallback(&fx, pvRef);
    }
}

extern "C" __declspec(dllexport) void DIEnumEffectsW(LPDIENUMEFFECTSCALLBACKW lpCallback, LPVOID pvRef, DWORD dwEffType)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DIEFFECTINFOW fx = { sizeof(DIEFFECTINFO) };   
    //OutputDebugStringW(__FUNCTIONW__);      
    if (dwEffType & DIEFT_CONSTANTFORCE || dwEffType == DIEFT_ALL)
    {
        fx.guid           = GUID_ConstantForce;
        fx.dwEffType      = DIEFT_CONSTANTFORCE;
        fx.dwStaticParams = DIEP_ENVELOPE | DIEP_GAIN | DIEP_STARTDELAY | DIEP_TYPESPECIFICPARAMS;
        SetEffectName(&fx, L"Constant Force");        
        lpCallback(&fx, pvRef);          
    }
    if (dwEffType & DIEFT_CUSTOMFORCE || dwEffType == DIEFT_ALL)
    {
        fx.guid           = GUID_CustomForce;
        fx.dwEffType      = DIEFT_CUSTOMFORCE;
        fx.dwStaticParams = DIEP_ENVELOPE | DIEP_GAIN | DIEP_STARTDELAY | DIEP_TYPESPECIFICPARAMS;
        SetEffectName(&fx, L"Custom Force");        
        lpCallback(&fx, pvRef);        
    }
    if (dwEffType & DIEFT_RAMPFORCE || dwEffType == DIEFT_ALL)
    {
        fx.guid           = GUID_RampForce;
        fx.dwEffType      = DIEFT_RAMPFORCE;
        fx.dwStaticParams = DIEP_ENVELOPE | DIEP_GAIN | DIEP_STARTDELAY | DIEP_TYPESPECIFICPARAMS;        
        SetEffectName(&fx, L"Ramp Force");
        lpCallback(&fx, pvRef);        
    }
    if (dwEffType & DIEFT_PERIODIC || dwEffType == DIEFT_ALL)
    {
        fx.dwEffType      = DIEFT_PERIODIC;
        fx.dwStaticParams = DIEP_ENVELOPE | DIEP_GAIN | DIEP_STARTDELAY | DIEP_TYPESPECIFICPARAMS;
        fx.guid = GUID_Square;        SetEffectName(&fx, L"Square");       lpCallback(&fx, pvRef);
        fx.guid = GUID_Sine;          SetEffectName(&fx, L"Sine");         lpCallback(&fx, pvRef);
        fx.guid = GUID_Triangle;      SetEffectName(&fx, L"Triangle");     lpCallback(&fx, pvRef);
        fx.guid = GUID_SawtoothUp;    SetEffectName(&fx, L"SawtoothUp");   lpCallback(&fx, pvRef);
        fx.guid = GUID_SawtoothDown;  SetEffectName(&fx, L"SawtoothDown"); lpCallback(&fx, pvRef);       
    }   
    //OutputDebugStringW(__FUNCTIONW__ " End");
}

UINT __stdcall DiGetInterface(IUnknown* i, IUnknown ** pDinput)
{
    auto DI8  = EZInterface(IID_IDirectInputDeviceW, i);
    *pDinput  = DI8.I();
    if (*pDinput != nullptr) return 1;    
    auto DI8W = EZInterface(IID_IDirectInputDevice8W, i);
    *pDinput  = DI8W.I();
    if (*pDinput != nullptr) return 2;
    return 0;
}

extern "C" __declspec(dllexport)
HRESULT DIGetRange(IUnknown * u, DWORD offset,  LONG* min, LONG* max, LONG* center)
{
    HRESULT err    = S_OK;
    DIPROPRANGE rg = {sizeof(DIPROPRANGE), sizeof(DIPROPHEADER), offset, DIPH_BYOFFSET};
    IUnknown* i    = nullptr;
    UINT iid       = DiGetInterface(u, &i);
    if (iid == 0)
    {
        DBUG_WARN("NO INTERFACE");
        return 0;
    }        
    else if (iid == 1)
    {
        IDirectInputDeviceW* dvc = (IDirectInputDeviceW*)i;
        dvc->GetProperty(DIPROP_RANGE, (DIPROPHEADER*)&rg);
    }
    else if (iid == 2)
    {
        IDirectInputDevice8W* dvc = (IDirectInputDevice8W*)i;
        dvc->GetProperty(DIPROP_RANGE, (DIPROPHEADER*)&rg);
    }   
    if (rg.lMin == DIPROPRANGE_NOMIN) rg.lMin = 0;          // untested
    if (rg.lMax == DIPROPRANGE_NOMAX) rg.lMax = 0xffffffff; // untested
    *min    = rg.lMin;
    *max    = rg.lMax;
    *center = rg.lMin + ceil((rg.lMax-rg.lMin)/2.f); // Breaks lba2
    *center = rg.lMin + (rg.lMax-rg.lMin)/2.f;
    return err;
}

DWORD DiDvcGetBufferSize(IUnknown* u)
{
    DIPROPDWORD mode = { sizeof(DIPROPDWORD), sizeof(DIPROPHEADER), 0,  DIPH_DEVICE };
    auto DI          = EZInterface(IID_IDirectInputDeviceA, u);
    IUnknown* i      = nullptr;
    UINT iid         = DiGetInterface(u, &i);
    if (iid == 0)
    {
        DBUG_WARN("NO INTERFACE");
        return 0;
    }
    else if (iid == 1)
    {
        IDirectInputDeviceW* dvc = (IDirectInputDeviceW*)i;
        dvc->GetProperty(DIPROP_BUFFERSIZE, (DIPROPHEADER*)&mode);
    }
    else if (iid == 2)
    {
        IDirectInputDevice8W* dvc = (IDirectInputDevice8W*)i;
        dvc->GetProperty(DIPROP_BUFFERSIZE, (DIPROPHEADER*)&mode);
    }
    return mode.dwData;
}

DWORD IsGamePad(IUnknown* u)
{
    DIDEVCAPS cps = {sizeof(DIDEVCAPS)};
    IUnknown* i   = nullptr;
    UINT iid      = DiGetInterface(u, &i);
    if (u == nullptr)
    {
        return 0;
    }
    if (iid == 0)
    {
        DBUG_WARN("NO INTERFACE");
        return 0;
    }
    else if (iid == 1)
    {
        IDirectInputDeviceW* dvc = (IDirectInputDeviceW*)i;
        dvc->GetCapabilities(&cps);
    }
    else if (iid == 2)
    {
        IDirectInputDevice8W* dvc = (IDirectInputDevice8W*)i;
        dvc->GetCapabilities(&cps);
    }    
    //DBUG_WARN(to_string(GET_DIDEVICE_TYPE(cps.dwDevType)).c_str());
    return GET_DIDEVICE_TYPE(cps.dwDevType) & DI8DEVCLASS_GAMECTRL ? 1 : 0;
}

DWORD GetAxesMode(IUnknown * u)
{
    DIPROPDWORD mode    = {sizeof(DIPROPDWORD), sizeof(DIPROPHEADER), 0,  DIPH_DEVICE};
    auto DI             = EZInterface(IID_IDirectInputDeviceA, u);
    IUnknown* i         = nullptr;
    UINT iid            = DiGetInterface(u, &i);    
    if(iid == 0)
    {
        DBUG_WARN("NO INTERFACE");
        return 0;
    }
    else if (iid == 1)
    {
        IDirectInputDeviceW* dvc = (IDirectInputDeviceW*)i;
        dvc->GetProperty(DIPROP_AXISMODE, (DIPROPHEADER*)&mode);
    }
    else if (iid == 2)
    {
        IDirectInputDevice8W* dvc = (IDirectInputDevice8W*)i;
        dvc->GetProperty(DIPROP_AXISMODE, (DIPROPHEADER*)&mode);
    }   
    return mode.dwData;   
}
   
void __stdcall DiSetAxes(IUnknown * /* This must be checked for null if its ever used, as it can be when the game uses joygetpos */, 
                         DIJOYSTATE_DX3* DIState, XINPUT_STATE * XState,
                         XINPUT_STATE * Prev, LONG min, LONG max, LONG center)
{
    DIState->lX   = center;
    DIState->lY   = center;
    DIState->lZ   = center;
    DIState->lRx  = center;
    DIState->lRy  = center;
    DIState->lRz  = center;
    
    BOOL lstick_enabled  = 3 == (DInput_Hooks->flags & 0xf);
    BOOL rstick_mode     =  DInput_Hooks->flags & 0xf00; /* 0=enabled, 0x100=swapped, 0x200=mouse */
    /* if rstick_mode == 0x100(swapped), the left stick is also swapped */
    
    float LX     = (XState->Gamepad.sThumbLX + 32768)/65535.f;
    float LY     = (XState->Gamepad.sThumbLY + 32768)/65535.f;
    float RX     = (XState->Gamepad.sThumbRX + 32768)/65535.f;
    float RY     = (XState->Gamepad.sThumbRY + 32768)/65535.f;    
    LONG range   = max - min;  
    LY = 1 - LY;
    RY = 1 - RY;

    if (lstick_enabled)
    {
        if (XState->Gamepad.sThumbLX > DInput_Hooks->DeadZone || XState->Gamepad.sThumbLX < DInput_Hooks->NegativeDeadZone)
        {
            if  (rstick_mode == 0x100) DIState->lRx = LX * range + min;
            else                       DIState->lX  = LX * range + min;
        }
        if (XState->Gamepad.sThumbLY > DInput_Hooks->DeadZone || XState->Gamepad.sThumbLY < DInput_Hooks->NegativeDeadZone)
        {
            if  (rstick_mode == 0x100) DIState->lRy = LY * range + min;
            else                       DIState->lY  = LY * range + min;
        }
    }
    if (XState->Gamepad.sThumbRX > DInput_Hooks->DeadZone || XState->Gamepad.sThumbRX < DInput_Hooks->NegativeDeadZone)
    {
        if      (rstick_mode == 0x100) DIState->lX  = RX * range + min;
        else if (rstick_mode == 0x000) DIState->lRx = RX * range + min;
    }
    if (XState->Gamepad.sThumbRY > DInput_Hooks->DeadZone || XState->Gamepad.sThumbRY < DInput_Hooks->NegativeDeadZone)
    {
        if      (rstick_mode == 0x100) DIState->lY  = RY * range + min;
        else if (rstick_mode == 0x000) DIState->lRy = RY * range + min;
    }
   
}

void __stdcall DiSetButtons(BYTE * Buttons, XINPUT_STATE * XState)
{
    WORD butts = XState->Gamepad.wButtons;

    if (DInput_Hooks->Buttons[0] && (butts & XINPUT_GAMEPAD_A))
    Buttons[ DInput_Hooks->Buttons[0]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[1] && (butts & XINPUT_GAMEPAD_B))
    Buttons[ DInput_Hooks->Buttons[1]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[2] && (butts & XINPUT_GAMEPAD_X))
    Buttons[ DInput_Hooks->Buttons[2]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[3] && (butts & XINPUT_GAMEPAD_Y))
    Buttons[ DInput_Hooks->Buttons[3]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[4] && (butts & XINPUT_GAMEPAD_LEFT_SHOULDER))
    Buttons[ DInput_Hooks->Buttons[4]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[5] && (butts & XINPUT_GAMEPAD_RIGHT_SHOULDER))
    Buttons[ DInput_Hooks->Buttons[5]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[6] && (XState->Gamepad.bLeftTrigger))
    Buttons[ DInput_Hooks->Buttons[6]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[7] && (XState->Gamepad.bRightTrigger))
    Buttons[ DInput_Hooks->Buttons[7]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[8] && (butts & XINPUT_GAMEPAD_BACK))
    Buttons[ DInput_Hooks->Buttons[8]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[9] && (butts & XINPUT_GAMEPAD_START))
    Buttons[ DInput_Hooks->Buttons[9]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[10] && (butts & XINPUT_GAMEPAD_LEFT_THUMB))
    Buttons[ DInput_Hooks->Buttons[10]-1 ] = (BYTE)128;

    if (DInput_Hooks->Buttons[11] && (butts & XINPUT_GAMEPAD_RIGHT_THUMB))
    Buttons[ DInput_Hooks->Buttons[11]-1 ] = (BYTE)128;

    return;
}

void __stdcall DiSetPOV(DWORD *pov, XINPUT_STATE * XState, LONG min, LONG max, LONG center)
{
    * pov = (DWORD)-1;
    if ((DInput_Hooks->flags & 0xf0) == 0x30)
    {
        BYTE up    = XState->Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_UP;
        BYTE down  = XState->Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_DOWN;
        BYTE right = XState->Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_RIGHT;
        BYTE left  = XState->Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_LEFT;

        /*
        if      (left)   DIState->lX = min;
        else if (right)  DIState->lX = max;

        if      (up)   DIState->lY =  min;
        else if (down) DIState->lY =  max;
        */

        if (up)             * pov =     0;
        if (up && right)    * pov =  4500;
        if (right)          * pov =  9000;
        if (right && down)  * pov = 13500;
        if (down)           * pov = 18000;
        if (down && left)   * pov = 22500;
        if (left)           * pov = 27000;
        if (left && up)     * pov = 31500;
        //else               * pov = (DWORD)-1;
    }
}

void __stdcall DiSetSatates(IUnknown* d, DIJOYSTATE_DX3* DIState, BYTE* Buttons, DWORD* pov)
{
    static XINPUT_STATE Prev;
    DWORD         offset = 0;
    LONG    min, max, center;
    XINPUT_STATE      XState;
    if (d == nullptr)  
    {
        /* Called from the joygetpos hook, values assumed by those  
         * used by the MS driver. Can be checked with joygetcaps
         */
        min    = 0; 
        max    = 65535;
        center = 32768;
    }
    else DIGetRange(d, offset, &min, &max, &center);
    //DBUG_WARN((to_string(min) + " " + to_string(max)).c_str())
    XInputGetState(0, &XState);

    DiSetAxes(d, DIState, &XState, &Prev, min, max, center);
    DiSetButtons(Buttons, &XState);
    DiSetPOV(pov, &XState, min, max, center);

    memcpy(&Prev, &XState, sizeof(XINPUT_STATE));
}

MMRESULT WINAPI joyGetDevCapsAHook(UINT uJoyID, LPJOYCAPSA pjc, UINT cbjc)
{
    MMRESULT mr = g_Dinput.m_joyGetDevCapsA(uJoyID, pjc, cbjc);
    if (mr != S_OK) return mr;
    pjc->wXmin    = 0;
    pjc->wYmin    = 0;
    pjc->wXmax    = 65535;
    pjc->wYmax    = 65535;
    pjc->wZmin    = 0;
    pjc->wRmin    = 0;
    pjc->wZmax    = 65535;
    pjc->wRmax    = 65535;
    pjc->wCaps    = JOYCAPS_HASPOV | JOYCAPS_POV4DIR | JOYCAPS_HASZ | JOYCAPS_HASR;
    pjc->wMaxAxes = 4;
    pjc->wNumAxes = 4;
    pjc->wMaxButtons = 12;
    return mr;
}

MMRESULT WINAPI joyGetDevCapsWHook(UINT uJoyID, LPJOYCAPSW pjc, UINT cbjc)
{
    MMRESULT mr = g_Dinput.m_joyGetDevCapsW(uJoyID, pjc, cbjc);
    if (mr != S_OK) return mr;
    pjc->wXmin = 0;
    pjc->wYmin = 0;
    pjc->wXmax = 65535;
    pjc->wYmax = 65535;
    pjc->wZmin = 0;
    pjc->wRmin = 0;
    pjc->wZmax = 65535;
    pjc->wRmax = 65535;
    pjc->wCaps = JOYCAPS_HASPOV | JOYCAPS_POV4DIR | JOYCAPS_HASZ | JOYCAPS_HASR;
    pjc->wMaxAxes = 4;
    pjc->wNumAxes = 4;
    pjc->wMaxButtons = 12;
    return mr;
}

MMRESULT WINAPI joyGetPosHook(UINT uJoyID, LPJOYINFO pji)
{
    //DBUG_WARN("---")
    if (pji == nullptr) return MMSYSERR_INVALPARAM;
    DIJOYSTATE_DX3 state = {};
    DiSetSatates(nullptr, &state, (BYTE*)&state.rgbButtons, &state.rgdwPOV);
    pji->wXpos    = state.lX;
    pji->wYpos    = state.lY;
    pji->wZpos    = state.lRx;
    pji->wButtons = 0;
    /* The documentation states this function only supports up to 4 button, but Alone in the dark 4 recognizes 8 */
    if (state.rgbButtons[0] > 0) pji->wButtons |= JOY_BUTTON1;
    if (state.rgbButtons[1] > 0) pji->wButtons |= JOY_BUTTON2;
    if (state.rgbButtons[2] > 0) pji->wButtons |= JOY_BUTTON3;
    if (state.rgbButtons[3] > 0) pji->wButtons |= JOY_BUTTON4;
    if (state.rgbButtons[4] > 0) pji->wButtons |= JOY_BUTTON5;
    if (state.rgbButtons[5] > 0) pji->wButtons |= JOY_BUTTON6;
    if (state.rgbButtons[6] > 0) pji->wButtons |= JOY_BUTTON7;
    if (state.rgbButtons[7] > 0) pji->wButtons |= JOY_BUTTON8;
    if (state.rgbButtons[8] > 0) pji->wButtons |= JOY_BUTTON9;
    if (state.rgbButtons[9] > 0) pji->wButtons |= JOY_BUTTON10;
    if (state.rgbButtons[10] > 0) pji->wButtons |= JOY_BUTTON11;
    if (state.rgbButtons[11] > 0) pji->wButtons |= JOY_BUTTON12;
    return 0;
}

MMRESULT WINAPI joyGetPosExHook(UINT uJoyID, LPJOYINFOEX pji)
{
    //DBUG_WARN("---")
    if (pji == nullptr) return MMSYSERR_INVALPARAM;
    DIJOYSTATE_DX3 state = {};
    DiSetSatates(nullptr, &state, (BYTE*)&state.rgbButtons, &state.rgdwPOV);
    pji->dwXpos    = state.lX;
    pji->dwYpos    = state.lY;
    pji->dwZpos    = state.lRx;
    pji->dwRpos    = state.lRy;    
    pji->dwButtons = 0;
    pji->dwButtonNumber = 0;
    if (state.rgbButtons[0] > 0) { pji->dwButtons |= JOY_BUTTON1; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[1] > 0) { pji->dwButtons |= JOY_BUTTON2; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[2] > 0) { pji->dwButtons |= JOY_BUTTON3; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[3] > 0) { pji->dwButtons |= JOY_BUTTON4; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[4] > 0) { pji->dwButtons |= JOY_BUTTON5; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[5] > 0) { pji->dwButtons |= JOY_BUTTON6; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[6] > 0) { pji->dwButtons |= JOY_BUTTON7; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[7] > 0) { pji->dwButtons |= JOY_BUTTON8; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[8] > 0) { pji->dwButtons |= JOY_BUTTON9; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[9] > 0) { pji->dwButtons |= JOY_BUTTON10; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[10] > 0) { pji->dwButtons |= JOY_BUTTON11; pji->dwButtonNumber += 1; }
    if (state.rgbButtons[11] > 0) { pji->dwButtons |= JOY_BUTTON12; pji->dwButtonNumber += 1; }

    XINPUT_STATE XState = {};
    XInputGetState(0, &XState);
    pji->dwPOV = JOY_POVCENTERED;
    if      (XState.Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_UP)    pji->dwPOV = JOY_POVFORWARD;
    else if (XState.Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_DOWN)  pji->dwPOV = JOY_POVBACKWARD;
    else if (XState.Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_RIGHT) pji->dwPOV = JOY_POVRIGHT;
    else if (XState.Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_LEFT)  pji->dwPOV = JOY_POVLEFT;
    return 0;
}

void __stdcall InitDInputHooks(DINPT_HOOKS* p)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DInput_Hooks = p;
    g_Dinput.Init();    
    HOOK(&g_Dinput.m_joyGetDevCapsA, joyGetDevCapsAHook)
    HOOK(&g_Dinput.m_joyGetDevCapsW, joyGetDevCapsWHook)
    HOOK(&g_Dinput.m_joyGetPos, joyGetPosHook)
    HOOK(&g_Dinput.m_joyGetPosEx, joyGetPosExHook)
}

HRESULT STDMETHODCALLTYPE DiDcvSetDataFormat(IDirectInputDevice8W* dvc, LPCDIDATAFORMAT lpdf)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    IUnknown* i = nullptr;
    UINT iid    = DiGetInterface(dvc, &i);     
    if (iid == 0)
    {
        DBUG_WARN("NO INTERFACE");
        return 0;
    }
    //DBUG_WARN(to_string(IsGamePad(i)).c_str());
    if (IsGamePad(i) == 0)
    {
        if      (iid == 1) return DInput_Hooks->SetDataFormatW((IDirectInputDeviceW*)i, lpdf);
        else if (iid == 2) return DInput_Hooks->SetDataFormat8W((IDirectInputDevice8W*)i, lpdf);
    }
    if (DiSetDataFormat(dvc, lpdf) == 0)
    {
        /* Set the data format, so IDirectInputDevice::Acquire won't fail */
        if      (iid == 1) return DInput_Hooks->SetDataFormatW((IDirectInputDeviceW*)i, &c_dfDIJoystick);
        else if (iid == 2) return DInput_Hooks->SetDataFormat8W((IDirectInputDevice8W*)i, &c_dfDIJoystick);
        return DI_OK;
    }
    else 
    {
        DBUG_WARN("DiSetDataFormat FAILED");
        if      (iid == 1) return DInput_Hooks->SetDataFormatW((IDirectInputDeviceW*)i, lpdf);
        else if (iid == 2) return DInput_Hooks->SetDataFormat8W((IDirectInputDevice8W*)i, lpdf);
    }
    
}

DWORD __stdcall DinputSetStates(IUnknown * dev, DWORD size, void * state)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)      
    if (size == 60)
    {
        ZeroMemory(state, size);        
        DIJOYSTATE_DX3 * DState = (DIJOYSTATE_DX3*) state;     
        DiSetSatates(dev, (DIJOYSTATE_DX3*)state, (BYTE*)&DState->rgbButtons, &DState->rgdwPOV);
    } else if  (size == 80)
    {
        ZeroMemory(state, size);
        DIJOYSTATE * DState = (DIJOYSTATE*) state;
        DiSetSatates(dev, (DIJOYSTATE_DX3*)state, (BYTE*)&DState->rgbButtons, &DState->rgdwPOV[0]);
    } else if  (size == 272)
    {
        ZeroMemory(state, size);
        DIJOYSTATE2* DState = (DIJOYSTATE2*)state;
        DiSetSatates(dev, (DIJOYSTATE_DX3*)state, (BYTE*)&DState->rgbButtons, &DState->rgdwPOV[0]);
    }   
    else if (size == DiGetDataSz(dev))
    {
        ZeroMemory(state, size);
        DIJOYSTATE_DX3 DiJoyState = {};
        DiSetSatates(dev, (DIJOYSTATE_DX3*)&DiJoyState, (BYTE*)&DiJoyState.rgbButtons, &DiJoyState.rgdwPOV);
        const vector<DI_DATA_ELEMENT>* fmt = DiGetDataFormat(dev);
        if (fmt == nullptr)
        {
            DBUG_WARN("NULL DATAFORMAT");
            return DIERR_BADDRIVERVER;
        }
        DWORD* axes   = nullptr;
        BYTE * button = nullptr;
        for (auto const& e : *fmt) 
        {                    
            if (e.ID == XINPUTID_POV)
            {
                axes = (DWORD*)state;
                axes += e.offset / 4;
                *axes = DiJoyState.rgdwPOV;               
            }
            else if (e.ID == XINPUTID_LX)
            {
                axes = (DWORD*)state;
                axes += e.offset / 4;
                *axes = DiJoyState.lX;
            }
            else if (e.ID == XINPUTID_LY)
            {
                axes = (DWORD*)state;
                axes += e.offset / 4;
                *axes = DiJoyState.lY;
            }
            else if (e.ID == XINPUTID_RX)
            {
                axes = (DWORD*)state;
                axes += e.offset / 4;
                *axes = DiJoyState.lRx;
            }
            else if (e.ID == XINPUTID_RY)
            {
                axes = (DWORD*)state;
                axes += e.offset / 4;
                *axes = DiJoyState.lRy;
            }
            else
            {
                for (int idx = 0; idx < 12; idx++)
                {
                    if (e.ID == (idx + 1 << 4))
                    {
                        button = (BYTE*)state;
                        button += e.offset;
                        *button = DiJoyState.rgbButtons[idx];
                    }
                }
            }
        }
    }
    return 0;
}

HRESULT DiDeviceGetState(HRESULT hr, IUnknown * dvc, DWORD size, LPVOID state)
{
    if (hr == 0) 
    {
        return DinputSetStates(dvc, size, state);        
    }
    else if (hr == DIERR_INVALIDPARAM && size == DiGetDataSz(dvc))
    {
        return DinputSetStates(dvc, size, state);       
    }
    return hr;
}

HRESULT STDMETHODCALLTYPE DinputDeviceGetState(IDirectInputDeviceA* dvc, DWORD size, LPVOID state)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = DInput_Hooks->GetDeviceState(dvc, size, state);
    return DiDeviceGetState(hr, dvc, size, state);
}

HRESULT STDMETHODCALLTYPE DinputDevice8GetState(IDirectInputDevice8A* dvc, DWORD size, LPVOID state)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = DInput_Hooks->GetDeviceState8(dvc, size, state);
    return DiDeviceGetState(hr, dvc, size, state);
}

HRESULT STDMETHODCALLTYPE DinputDeviceGetStateW(IDirectInputDeviceW* dvc, DWORD size, LPVOID state)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = DInput_Hooks->GetDeviceStateW(dvc, size, state);
    return DiDeviceGetState(hr, dvc, size, state);
}

HRESULT STDMETHODCALLTYPE DinputDevice8GetStateW(IDirectInputDevice8W* dvc, DWORD size, LPVOID state)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)   
    HRESULT hr = DInput_Hooks->GetDeviceState8W(dvc, size, state);
    return DiDeviceGetState(hr, dvc, size, state);
}

#define DI_RECORD_EVENT(id, field)                 \
else if (e.ID == id)                               \
{                                                  \
    if (state.field != prev_state.field)           \
    {                                              \
        if (data.size() <= size)                   \
        {                                          \
            if (seq == 0xffffffff) seq = 0;        \
            seq += 1;                              \
            evnt.dwData      = (DWORD)state.field; \
            evnt.dwOfs       = e.offset;           \
            evnt.dwSequence  = seq;                \
            evnt.dwTimeStamp = PerfCounter().MS(); \
            data.push_back(evnt);                  \
        }                                          \
    }                                              \
}                                               
    
HRESULT STDMETHODCALLTYPE DinputDeviceGetData(IUnknown* dvc, DWORD sz, LPDIDEVICEOBJECTDATA rgdod, LPDWORD count, DWORD dwFlags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    /* Not thread safe : access to static members must be protected to be safe */
   
    static DWORD                       seq = 0;
    DIJOYSTATE_DX3 state                   = {};
    static DIJOYSTATE_DX3 prev_state       = {};    
    static vector<DIDEVICEOBJECTDATA> data = {};
    //DBUG_WARN(to_string(IsGamePad(dvc)).c_str())
    if (IsGamePad(dvc) == 0)
    {
        IUnknown* i = nullptr;
        UINT iid    = DiGetInterface(dvc, &i);        
        if (iid == 0)
        {
            DBUG_WARN("NO INTERFACE");
            return 0;
        }         
        else if (iid == 1) return DInput_Hooks->GetDataW((IDirectInputDeviceW*)i, sz, rgdod, count, dwFlags);
        else if (iid == 2) return DInput_Hooks->GetData8W((IDirectInputDevice8W*)i, sz, rgdod, count, dwFlags);
        return DI_OK;        
    }   
    DWORD                      overflow = 0;
    DWORD                  button_index = 0;
    DIDEVICEOBJECTDATA            evnt  = {};
    int size                            = DiDvcGetBufferSize(dvc)-1;
    const vector<DI_DATA_ELEMENT> * fmt = DiGetDataFormat(dvc);
    DinputSetStates(dvc, 60, &state);   
    if (size <= 0)
    {
        DBUG_WARN("ZERO SIZE");
        return DIERR_NOTINITIALIZED;
    }
    for (auto const& e : *fmt)
    {        
        if (e.ID == XINPUTID_POV)
        {
            if (state.rgdwPOV != prev_state.rgdwPOV)
            {
                if (data.size() < size)
                {
                    if (seq == 0xffffffff) seq = 0;
                    seq             += 1;
                    evnt.dwData      = (DWORD)state.rgdwPOV;
                    evnt.dwOfs       = e.offset;
                    evnt.dwSequence  = seq;
                    evnt.dwTimeStamp = PerfCounter().MS();
                    data.push_back(evnt);
                }
            }
        }
        DI_RECORD_EVENT(XINPUTID_LX, lX)
        DI_RECORD_EVENT(XINPUTID_LY, lY)
        DI_RECORD_EVENT(XINPUTID_RX, lRx)
        DI_RECORD_EVENT(XINPUTID_RY, lRy)
        else if (e.ID & 0xf0)
        {
            button_index = (e.ID - 1) >> 4;            
            if (state.rgbButtons[button_index] != prev_state.rgbButtons[button_index])
            {
                if (data.size() < size)
                {                    
                    if (seq == 0xffffffff) seq = 0;
                    seq += 1;
                    evnt.dwData        &= 0xffffff00;
                    evnt.dwData        |= (BYTE)state.rgbButtons[button_index];
                    evnt.dwOfs         = e.offset;
                    evnt.dwSequence    = seq;
                    evnt.dwTimeStamp   = PerfCounter().MS();
                    data.push_back(evnt);
                }
            }
        }
        if (data.size() > size)
        {
            data.pop_back();
            overflow = 1;
            break;
        }
    }
   
    memcpy(&prev_state, &state, sizeof(DIJOYSTATE_DX3));
    DIDEVICEOBJECTDATA* retdata   = rgdod;    
    DWORD to_copy                 = *count;
    DWORD copyed                  = 0;
    //if (data.size() > 0) DBUG_WARN((to_string(data.size()) + " " + "events").c_str());
    if (to_copy == 0) return DI_OK;    
    ;while (to_copy > 0)
    {
        if (data.size() == 0)
        {
            break;
        }
        if (rgdod != nullptr && &data[0] != nullptr)
        {
            memcpy(retdata, &data[0], sizeof(DIDEVICEOBJECTDATA));
            //DBUG_WARN((to_string(retdata->dwOfs)+ " "+to_string(retdata->dwData)+" "+ to_string(retdata->dwSequence)+ " "+ to_string(retdata->dwTimeStamp)).c_str());
            retdata++;
        }
        if ((dwFlags & DIGDD_PEEK) == 0)
        {
            data.erase(data.begin());
        }
        to_copy -= 1;
        copyed  += 1;
        if ((dwFlags & DIGDD_PEEK) && (copyed == data.size()))
        {
            break;
        }
        // Only one event per call improves responsiveness on Drakan,
        // Soul Reaver 2 and Blood Omen
        break; 
    }    
    
    //if (copyed > 0) DBUG_WARN((to_string(copyed) + " " + "copyed").c_str());
    *count = copyed;
    //return DI_OK;
    return overflow ? DI_BUFFEROVERFLOW : DI_OK;
}

HRESULT STDMETHODCALLTYPE DinputDeviceSetProperty(IDirectInputDeviceA* dvc, DWORD rguidProp, DIPROPDWORD * pdiph)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = DInput_Hooks->SetProperty(dvc, rguidProp, pdiph);
    if (hr == 0)
    {
        if (rguidProp == 5)
        {
            OutputDebugStringA(std::to_string(pdiph->diph.dwSize).c_str());
            OutputDebugStringA(std::to_string(pdiph->diph.dwHeaderSize).c_str());
            OutputDebugStringA(std::to_string(pdiph->dwData).c_str());
            float dzone = (float)pdiph->dwData/10000.;
            DInput_Hooks->DeadZone         = dzone*32768 ;
            DInput_Hooks->NegativeDeadZone = DInput_Hooks->DeadZone*-1;
        }
    }
    /* 9 = DIPROP_AUTOCENTER, DInput documentation recomends set this DIPROPAUTOCENTER_OFF
     * when using force fedback, but this returns and error on Xinput gamepads
     */
    else if (rguidProp == 9 && DInput_Hooks->CreateEffect) return 0;
    return hr;
}

HRESULT STDMETHODCALLTYPE DinputDevice8SetProperty(IDirectInputDevice8A* dvc, DWORD rguidProp, DIPROPDWORD* pdiph)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    HRESULT hr = DInput_Hooks->SetProperty8(dvc, rguidProp, pdiph);
    if (hr == 0)
    {
        if (rguidProp == 5)
        {
            DBUG_WARN(std::to_string(pdiph->diph.dwSize).c_str());
            DBUG_WARN(std::to_string(pdiph->diph.dwHeaderSize).c_str());
            DBUG_WARN(std::to_string(pdiph->dwData).c_str());
            float dzone = (float)pdiph->dwData / 10000.;
            DInput_Hooks->DeadZone = dzone * 32768;
            DInput_Hooks->NegativeDeadZone = DInput_Hooks->DeadZone * -1;
            return DI_OK;
        }
    }
    /* 9 = DIPROP_AUTOCENTER, DInput documentation recomends set this DIPROPAUTOCENTER_OFF
     * when using force fedback, but this returns and error on Xinput gamepads
     */
    else if (rguidProp == 9 && DInput_Hooks->CreateEffect) return 0;
    return hr;
}

HRESULT STDMETHODCALLTYPE DinputDeviceSetPropertyW(IDirectInputDeviceW* dvc, DWORD rguidProp, DIPROPDWORD* pdiph)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = DInput_Hooks->SetPropertyW(dvc, rguidProp, pdiph);
    if (hr == 0)
    {
        if (rguidProp == 5)
        {
            OutputDebugStringA(std::to_string(pdiph->diph.dwSize).c_str());
            OutputDebugStringA(std::to_string(pdiph->diph.dwHeaderSize).c_str());
            OutputDebugStringA(std::to_string(pdiph->dwData).c_str());
            float dzone = (float)pdiph->dwData / 10000.;
            DInput_Hooks->DeadZone = dzone * 32768;
            DInput_Hooks->NegativeDeadZone = DInput_Hooks->DeadZone * -1;
        }
    }
    /* 9 = DIPROP_AUTOCENTER, DInput documentation recomends set this DIPROPAUTOCENTER_OFF
     * when using force fedback, but this returns and error on Xinput gamepads
     */
    else if (rguidProp == 9 && DInput_Hooks->CreateEffect) return 0;
    return hr;
}

HRESULT STDMETHODCALLTYPE DinputDevice8SetPropertyW(IDirectInputDevice8W* dvc, DWORD rguidProp, DIPROPDWORD* pdiph)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = DInput_Hooks->SetProperty8W(dvc, rguidProp, pdiph);
    if (hr == 0)
    {
        if (rguidProp == 5)
        {
            OutputDebugStringA(std::to_string(pdiph->diph.dwSize).c_str());
            OutputDebugStringA(std::to_string(pdiph->diph.dwHeaderSize).c_str());
            OutputDebugStringA(std::to_string(pdiph->dwData).c_str());
            float dzone = (float)pdiph->dwData / 10000.;
            DInput_Hooks->DeadZone = dzone * 32768;
            DInput_Hooks->NegativeDeadZone = DInput_Hooks->DeadZone * -1;
        }
    }
    /* 9 = DIPROP_AUTOCENTER, DInput documentation recomends set this DIPROPAUTOCENTER_OFF
     * when using force fedback, but this returns and error on Xinput gamepads
     */
    else if (rguidProp == 9 && DInput_Hooks->CreateEffect) return 0;
    return hr;
}

HRESULT WINAPI DiGetDvcCaps(IDirectInputDeviceA* dvc, LPDIDEVCAPS caps)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)   
    LPVOID ret = _ReturnAddress();
    HRESULT hr = DInput_Hooks->GetCapabilities(dvc, caps);
    if (hr != S_OK) return hr;

    if ( CommonIsGameModule(ret, nullptr) )
    {       
        DBUG_WARN(std::to_string(GET_DIDEVICE_TYPE(caps->dwDevType)).c_str())
        if ((GET_DIDEVICE_TYPE(caps->dwDevType) & DI8DEVCLASS_GAMECTRL))
        {
            caps->dwAxes    = 4;
            caps->dwButtons = 12;
            if (DInput_Hooks->CreateEffect)
            caps->dwFlags  |=  DIDC_FFATTACK | DIDC_FFFADE | DIDC_FORCEFEEDBACK ;
        }
    }
    return hr;
}

HRESULT WINAPI Di8GetDvcCaps(IDirectInputDevice8A* dvc, LPDIDEVCAPS caps)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)   
    LPVOID ret = _ReturnAddress();
    HRESULT hr = DInput_Hooks->GetCapabilities8(dvc, caps);
    if (hr != S_OK) return hr;

    if (CommonIsGameModule(ret, nullptr))
    {
        DBUG_WARN(std::to_string(GET_DIDEVICE_TYPE(caps->dwDevType)).c_str())
        if ((GET_DIDEVICE_TYPE(caps->dwDevType) & DI8DEVCLASS_GAMECTRL))
        {
            caps->dwAxes    = 4;
            caps->dwButtons = 12;
            if (DInput_Hooks->CreateEffect)  caps->dwFlags |= DIDC_FFATTACK | DIDC_FFFADE | DIDC_FORCEFEEDBACK;
        }
    }
    return hr;
}

HRESULT WINAPI DiGetDvcCapsW(IDirectInputDeviceW* dvc, LPDIDEVCAPS caps)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    LPVOID ret = _ReturnAddress();
    HRESULT hr = DInput_Hooks->GetCapabilitiesW(dvc, caps);
    if (hr != S_OK) return hr;

    if (CommonIsGameModule(ret, nullptr))
    {
        DBUG_WARN(std::to_string(GET_DIDEVICE_TYPE(caps->dwDevType)).c_str())
        if ((GET_DIDEVICE_TYPE(caps->dwDevType) & DI8DEVCLASS_GAMECTRL))
        {
            caps->dwAxes    = 4;
            caps->dwButtons = 12;
            if (DInput_Hooks->CreateEffect) caps->dwFlags |= DIDC_FFATTACK | DIDC_FFFADE | DIDC_FORCEFEEDBACK;
        }
    }
    return hr;
}

HRESULT WINAPI Di8GetDvcCapsW(IDirectInputDevice8W* dvc, LPDIDEVCAPS caps)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    LPVOID ret = _ReturnAddress();
    HRESULT hr = DInput_Hooks->GetCapabilities8W(dvc, caps);
    if (hr != S_OK) return hr;

    if (CommonIsGameModule(ret, nullptr))
    {
        DBUG_WARN(std::to_string(GET_DIDEVICE_TYPE(caps->dwDevType)).c_str())
        if ((GET_DIDEVICE_TYPE(caps->dwDevType) & DI8DEVCLASS_GAMECTRL))
        {
            caps->dwAxes    = 4;
            caps->dwButtons = 12;
            if (DInput_Hooks->CreateEffect) caps->dwFlags |= DIDC_FFATTACK | DIDC_FFFADE | DIDC_FORCEFEEDBACK;
        }
    }
    return hr;
}

void EnumFFObject(char* caller, LPDIENUMDEVICEOBJECTSCALLBACKA callback, LPVOID pvRef, DWORD flags)
{
    if ((flags == DIDFT_ALL) || (flags & DIDFT_FFACTUATOR))
    {
        DIDEVICEOBJECTINSTANCEA i = {0};
        i.dwSize              = sizeof(DIDEVICEOBJECTINSTANCEA);
        i.guidType            = GUID_Unknown;
        i.dwOfs               = 0;
        i.dwFlags             = DIDOI_FFACTUATOR;
        i.dwType              = DIDFT_FFACTUATOR;        
        i.dwFFMaxForce        = 1;     // 1 Newton, completelly arbritary
        i.dwFFForceResolution = 65535; // Motor states for Xinput devices are 16 bit
        char* name = "Peixoto's Emulated DirectInput Force Feedback Actuator";
        memcpy(i.tszName, name, strlen(name) * sizeof(char));
        callback(&i, pvRef);
    }
}

void EnumFFObjectW(char* caller, LPDIENUMDEVICEOBJECTSCALLBACKW callback, LPVOID pvRef, DWORD flags)
{
    if ((flags == DIDFT_ALL) || (flags & DIDFT_FFACTUATOR))
    {
        DIDEVICEOBJECTINSTANCEW i = { 0 };
        i.dwSize              = sizeof(DIDEVICEOBJECTINSTANCEW);
        i.guidType            = GUID_Unknown;
        i.dwOfs               = 0;
        i.dwFlags             = DIDOI_FFACTUATOR;
        i.dwType              = DIDFT_FFACTUATOR;        
        i.dwFFMaxForce        = 1;     // 1 Newton, completelly arbritary
        i.dwFFForceResolution = 65535; // Motor states for Xinput devices are 16 bit
        wchar_t* name = L"Peixoto.Emulated.DInput.FFActuator";
        memcpy(i.tszName, name, wcslen(name) * sizeof(wchar_t));
        callback(&i, pvRef);
    }
}

HRESULT EnumObjectsA(LPDIENUMDEVICEOBJECTSCALLBACKA callback, LPVOID pvRef, DWORD flags)
{
    if (callback == nullptr) return DIERR_INVALIDPARAM;
    DIDEVICEOBJECTINSTANCEA obj = { sizeof(DIDEVICEOBJECTINSTANCEA) };
    DBUG_WARN("ENUMERATION STARTED")
    if (flags == DIDFT_ALL || flags & DIDFT_ABSAXIS || flags & DIDFT_AXIS || flags & DIDFT_RELAXIS)
    {
        char* names[4]  = { "Left Stick X", "Left Stick Y", "Right Stick X", "Right Stick Y" };
        GUID   guids[4] = { GUID_XAxis, GUID_YAxis, GUID_RxAxis, GUID_RyAxis };
        DWORD   offs[4] = { 0, 4, 12, 16 };
        for (int i = 0; i < 4; i++)
        {
            obj.guidType = guids[i];
            obj.dwType   = DIDFT_ABSAXIS;
            obj.dwFlags  = DIDOI_POLLED | DIDOI_ASPECTPOSITION;
            obj.dwOfs    = offs[i];
            memcpy(obj.tszName, names[i], (strlen(names[i]) + 1) * sizeof(char));            
            callback(&obj, pvRef);
        }
    }
    if (flags == DIDFT_ALL || flags & DIDFT_POV)
    {
        obj.guidType = GUID_POV;
        obj.dwType   = DIDFT_POV;
        obj.dwFlags  = DIDOI_POLLED;
        obj.dwOfs    = g_Dinput.m_version < 0x0500 ? 24 : 32;
        memcpy(obj.tszName, "Dpad", (strlen("Dpad") + 1) * sizeof(char));        
        callback(&obj, pvRef);
    }
    if (flags == DIDFT_ALL || flags & DIDFT_BUTTON || flags & DIDFT_PSHBUTTON)
    {
        string button_name;
        for (int i = 0; i < 12; i++)
        {
            obj.guidType = GUID_Button;
            obj.dwType   = DIDFT_PSHBUTTON;
            obj.dwFlags  = DIDOI_POLLED;
            button_name  = "button " + to_string(i+1);
            obj.dwOfs    = g_Dinput.m_version < 0x0500 ? 28 + i : 48 + i;
            memcpy(obj.tszName, button_name.c_str(), (strlen(button_name.c_str()) + 1) * sizeof(char));            
            callback(&obj, pvRef);
        }
    }
    DBUG_WARN("ENUMERATION ENDED")
    EnumFFObject(__FUNCTION__, callback, pvRef, flags);
    return DI_OK;
}

HRESULT EnumObjectsW(LPDIENUMDEVICEOBJECTSCALLBACKW callback, LPVOID pvRef, DWORD flags)
{
    if (callback == nullptr) return DIERR_INVALIDPARAM;
    DIDEVICEOBJECTINSTANCEW obj = { sizeof(DIDEVICEOBJECTINSTANCEW) };
    if (flags == DIDFT_ALL || flags & DIDFT_ABSAXIS || flags & DIDFT_AXIS || flags & DIDFT_RELAXIS)
    {
        wchar_t* names[4] = { L"Left Stick X", L"Left Stick Y", L"Right Stick X", L"Right Stick Y" };
        GUID     guids[4] = { GUID_XAxis, GUID_YAxis, GUID_RxAxis, GUID_RyAxis };
        DWORD   offs[4] = { 0, 4, 12, 16 };
        for (int i = 0; i < 4; i++)
        {
            obj.guidType = guids[i];
            obj.dwType   = DIDFT_ABSAXIS;
            obj.dwFlags  = DIDOI_POLLED;
            obj.dwOfs    = offs[i];
            memcpy(obj.tszName, names[i], (wcslen(names[i]) + 1) * sizeof(wchar_t));
            callback(&obj, pvRef);
        }
    }
    if (flags == DIDFT_ALL || flags & DIDFT_POV)
    {
        obj.guidType = GUID_POV;
        obj.dwType   = DIDFT_POV;
        obj.dwFlags  = DIDOI_POLLED;
        obj.dwOfs    = g_Dinput.m_version < 0x0500 ? 24 : 32;
        memcpy(obj.tszName, L"Dpad", (wcslen(L"Dpad")+1) * sizeof(wchar_t));        
        callback(&obj, pvRef);
    }
    if (flags == DIDFT_ALL || flags & DIDFT_BUTTON || flags & DIDFT_PSHBUTTON)
    {
        wstring button_name;
        for (int i = 0; i < 12; i++)
        {
            obj.guidType = GUID_Button;
            obj.dwType   = DIDFT_PSHBUTTON;
            obj.dwFlags  = DIDOI_POLLED;
            button_name  = L"Button " + to_wstring(i+1);
            obj.dwOfs    = g_Dinput.m_version < 0x0500 ? 28 + i : 48 + i;
            memcpy(obj.tszName, button_name.c_str(), (wcslen(button_name.c_str()) + 1) * sizeof(wchar_t));              
            callback(&obj, pvRef);
        }
    }    
    EnumFFObjectW(__FUNCTION__, callback, pvRef, flags);
    return DI_OK;
}

HRESULT WINAPI DiEnumObjectsHook(IDirectInputDeviceA* dvc, LPDIENUMDEVICEOBJECTSCALLBACKA callback, LPVOID pvRef, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (IsGamePad(dvc)) return EnumObjectsA(callback, pvRef, flags);
    HRESULT hr = DInput_Hooks->EnumObjects(dvc, callback, pvRef, flags);
    if (hr != S_OK) return hr;
    //EnumFFObject(__FUNCTION__, callback,  pvRef, flags);
    return S_OK;
}

HRESULT WINAPI DiEnumObjects8Hook(IDirectInputDevice8A* dvc, LPDIENUMDEVICEOBJECTSCALLBACKA callback, LPVOID pvRef, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if (IsGamePad(dvc)) return EnumObjectsA(callback, pvRef, flags);
    HRESULT hr = DInput_Hooks->EnumObjects8(dvc, callback, pvRef, flags);
    if (hr != S_OK) return hr;
    //EnumFFObject(__FUNCTION__, callback, pvRef, flags);
    return S_OK;
}

HRESULT WINAPI DiEnumObjectsWHook(IDirectInputDeviceW* dvc, LPDIENUMDEVICEOBJECTSCALLBACKW callback, LPVOID pvRef, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (IsGamePad(dvc)) return EnumObjectsW(callback, pvRef, flags);
    HRESULT hr = DInput_Hooks->EnumObjectsW(dvc, callback, pvRef, flags);
    if (hr != S_OK) return hr;
    //EnumFFObjectW(__FUNCTION__, callback, pvRef, flags);
    return S_OK;
}

HRESULT WINAPI DiEnumObjects8WHook(IDirectInputDevice8W* dvc, LPDIENUMDEVICEOBJECTSCALLBACKW callback, LPVOID pvRef, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (IsGamePad(dvc)) return EnumObjectsW(callback, pvRef, flags);
    HRESULT hr = DInput_Hooks->EnumObjects8W(dvc, callback, pvRef, flags);
    if (hr != S_OK) return hr;
    //EnumFFObjectW(__FUNCTION__, callback, pvRef, flags);
    return S_OK;
}    

HRESULT WINAPI DinputEnumEffectsHook(LPDIENUMEFFECTSCALLBACKW lpCallback, LPVOID pRef, DWORD dwEffType)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    DIEFFECTINFOW  CForce;
    CForce.guid      = GUID_ConstantForce;
    CForce.dwEffType = DIEFT_CONSTANTFORCE;
    lpCallback(&CForce, pRef);
    return DI_OK;
}

HRESULT WINAPI DinputCreateEffectHook(IUnknown * dvc, REFGUID rguid, LPCDIEFFECT lpeff,
                                      LPDIRECTINPUTEFFECT * ppdeff, LPUNKNOWN punkOuter)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if ( (!dvc) || (rguid == GUID_NULL) || (!lpeff) || (!ppdeff))  return DIERR_INVALIDPARAM;

    if (rguid == GUID_ConstantForce)
    {
        DBUG_LOG("CREATING CONSTANT FORCE");
        *ppdeff = (LPDIRECTINPUTEFFECT) new ConstantForce((DIEFFECT*)lpeff, "CONSTANT FORCE", rguid);
        return DI_OK;
    } else if (rguid == GUID_CustomForce)
    {
        DBUG_WARN("GUID_CustomForce NOT IMPLEMENTED");
        return E_NOTIMPL;
    }
    else if (rguid == GUID_RampForce)
    {
        DBUG_LOG("CREATING RampForce");
        *ppdeff = (LPDIRECTINPUTEFFECT) new RampForce((DIEFFECT*)lpeff, "RampForce", rguid);
        return DI_OK;
    }
    else if (rguid == GUID_SawtoothUp)
    {
        DBUG_LOG("CREATING SawtoothUp");
        *ppdeff = (LPDIRECTINPUTEFFECT) new SawtoothUp((DIEFFECT*)lpeff, "SawtoothUp", rguid);
        return DI_OK;
    }
    else if (rguid == GUID_SawtoothDown)
    {
        DBUG_LOG("CREATING SawtoothDown");
        *ppdeff = (LPDIRECTINPUTEFFECT) new SawtoothDown((DIEFFECT*)lpeff, "SawtoothDown", rguid);
        return DI_OK;
    }
    else if (rguid == GUID_Sine)
    {
        DBUG_LOG("CREATING SINE");
        *ppdeff = (LPDIRECTINPUTEFFECT) new Sine((DIEFFECT*)lpeff, "SINE", rguid);
        return DI_OK;
    }
    else if (rguid == GUID_Square)
    {
        DBUG_LOG("CREATING Square");
        *ppdeff = (LPDIRECTINPUTEFFECT) new Square((DIEFFECT*)lpeff, "Square", rguid);
        return DI_OK;
    }   
    else if (rguid == GUID_Triangle)
    {
        DBUG_LOG("CREATING TRIANGLE");
        *ppdeff = (LPDIRECTINPUTEFFECT) new Triangle((DIEFFECT*)lpeff, "TRIANGLE", rguid);
        return DI_OK;
    }
    // start wars SOTE needs conditional effects or orther effects wont work
    else if (rguid == GUID_Inertia)
    {
        DBUG_LOG("CREATING Inertia");
        *ppdeff = (LPDIRECTINPUTEFFECT) new DIFxConditional((DIEFFECT*)lpeff, "Inertia", rguid);
        return DI_OK;
    }
    else if (rguid == GUID_Friction)
    {
        DBUG_LOG("CREATING Friction");
        *ppdeff = (LPDIRECTINPUTEFFECT) new DIFxConditional((DIEFFECT*)lpeff, "Friction", rguid);
        return DI_OK;
    }
    else if (rguid == GUID_Spring)
    {
        DBUG_LOG("CREATING SPRING");
        *ppdeff = (LPDIRECTINPUTEFFECT) new DIFxConditional((DIEFFECT*)lpeff, "SPRING", rguid);
        return DI_OK;
    }
    else if (rguid == GUID_Damper)
    {
        DBUG_LOG("CREATING Damper");
        *ppdeff = (LPDIRECTINPUTEFFECT) new DIFxConditional((DIEFFECT*)lpeff, "Damper", rguid);
        return DI_OK;
    }
    else
    {
        LPWSTR pwsz;
        if (StringFromIID(rguid, &pwsz) != S_OK)
        //g_Dinput.m_loger.dolog(__FUNCTIONW__,(std::wstring(L"StringFromIID FAILED FOR UNKNOWN GUID: ") + pwsz).c_str());
        //g_Dinput.m_loger.dolog(__FUNCTIONW__,(std::wstring(L"Unknown GUID: ")+pwsz).c_str()  );
        return E_NOTIMPL;
    }
    return E_NOTIMPL;
}

ConstantForce::ConstantForce(DIEFFECT * params, char * type, REFGUID rguid)
{
    m_type.clear();
    m_type.append(type);
    m_type.append(": ");
   
    m_ref_count = 1;
    m_LastEvent = new SYNC::WinEvent(&g_Dinput.m_loger);
    memcpy(&m_guid, (const void*)&rguid, sizeof(GUID)); 

    m_params.rgdwAxes              = m_axes;
    m_params.rglDirection          = m_directions;
    if (params) SetParameters(params, 0x000001FF);
}

HRESULT STDMETHODCALLTYPE ConstantForce::QueryInterface(THIS_ REFIID riid, LPVOID * ppvObj){
    LogCall(__FUNCTION__);
    return LogNotImplemented(__FUNCTION__);
}
ULONG STDMETHODCALLTYPE ConstantForce::AddRef(THIS){
    LogCall(__FUNCTION__);
    m_ref_count += 1;
    return m_ref_count;
}
ULONG STDMETHODCALLTYPE ConstantForce::Release(THIS){
    LogCall(__FUNCTION__);
    m_ref_count -= 1;
    DWORD ret    =  m_ref_count;
    if (ret == 0)
    {
        //DBUG_WARN( (std::string("ABOUT TO DELETE ")+m_type).c_str() );
        Reset()->Close();
        delete this;      
        //DBUG_WARN((std::string("DELETED ")).c_str());
    }
    return ret;
}
HRESULT STDMETHODCALLTYPE ConstantForce::Initialize(THIS_ HINSTANCE,DWORD,REFGUID){
    return LogNotImplemented(__FUNCTION__);
}
HRESULT STDMETHODCALLTYPE ConstantForce::GetEffectGuid(THIS_ LPGUID pguid){
    LogCall(__FUNCTION__);
    if (pguid == nullptr) return DIERR_INVALIDPARAM;
    memcpy(&pguid, &m_guid, sizeof(GUID));
    return DI_OK;
}
HRESULT STDMETHODCALLTYPE ConstantForce::GetParameters(THIS_ LPDIEFFECT p,DWORD f){
    LogCall(__FUNCTION__);
    if (!p) return DIERR_INVALIDPARAM;
    if (f & DIEP_DURATION)              p->dwDuration      = m_params.dwDuration;
    if (f & DIEP_GAIN)                  p->dwGain          = m_params.dwGain;
    if (f & DIEP_SAMPLEPERIOD)          p->dwSamplePeriod  = m_params.dwSamplePeriod;
    if (f & DIEP_STARTDELAY)            p->dwStartDelay    = m_params.dwStartDelay;
    if (f & DIEP_TRIGGERBUTTON)         p->dwTriggerButton = m_params.dwTriggerButton;
    if (f & DIEP_TRIGGERREPEATINTERVAL) p->dwTriggerButton = m_params.dwTriggerRepeatInterval;
    if (f & DIEP_ENVELOPE)
    {
        if (p->lpEnvelope) memcpy(p->lpEnvelope, &m_envelope, sizeof(DIENVELOPE));
    }
    if (f & DIEP_AXES)
    {
        if (p->cAxes) memcpy(p->rgdwAxes, m_axes, sizeof(DWORD)*p->cAxes);
    }
    if (f & DIEP_DIRECTION)
    {
        if (p->cAxes && (p->dwFlags & (DIEFF_CARTESIAN|DIEFF_POLAR|DIEFF_POLAR)))
        memcpy(p->rglDirection, m_directions, sizeof(LONG)*p->cAxes);
    }
    if (f & DIEP_TYPESPECIFICPARAMS)
    {
        if        (*(DWORD*)m_type.c_str() == *(DWORD*)"CONSTANT")  memcpy(p->lpvTypeSpecificParams, &m_constant_force, p->cbTypeSpecificParams);
        else if   (*(DWORD*)m_type.c_str() == *(DWORD*)"RampForce") memcpy(p->lpvTypeSpecificParams, &m_ramp, p->cbTypeSpecificParams);
        else if ( (*(DWORD*)m_type.c_str() == *(DWORD*)"SINE")          ||
                  (*(DWORD*)m_type.c_str() == *(DWORD*)"Square")        ||
                  (*(DWORD*)m_type.c_str() == *(DWORD*)"TRIANGLE")      ||
                  (*(DWORD*)m_type.c_str() == *(DWORD*)"SawtoothUp")    ||
                  (*(DWORD*)m_type.c_str() == *(DWORD*)"SawtoothDown")  )
        {
            memcpy(p->lpvTypeSpecificParams, &m_periodic, p->cbTypeSpecificParams);
        }
    }
    return DI_OK;
}
HRESULT STDMETHODCALLTYPE ConstantForce::SetParameters(LPCDIEFFECT params, DWORD flags)
{
    std::string calllog(__FUNCTION__);
    if (flags & DIEP_START)                    calllog.append(" DIEP_START");
    else                                       calllog.append(" NO_START");
    if (m_LastEvent->Wait(0) != WAIT_OBJECT_0) calllog.append(" PLAYING");
    DBUG_WARN( (char*) calllog.c_str() );
    if (params == nullptr) return DIERR_INVALIDPARAM;
        
    if (flags & DIEP_DURATION)              m_params.dwDuration       = params->dwDuration;
    if (flags & DIEP_GAIN)                  m_params.dwGain           = params->dwGain;
    if (flags & DIEP_SAMPLEPERIOD)          {m_params.dwSamplePeriod  = params->dwSamplePeriod;          DBUG_WARN("DIEP_SAMPLEPERIOD NOT SUPPORTED");}
    if (flags & DIEP_STARTDELAY)            {m_params.dwStartDelay    = params->dwStartDelay;            DBUG_WARN("DIEP_STARTDELAY NOT IMPLEMENTED");}
    if (flags & DIEP_TRIGGERBUTTON)         {m_params.dwTriggerButton = params->dwTriggerButton;         DBUG_WARN("DIEP_TRIGGERBUTTON NOT IMPLEMENTED");}
    if (flags & DIEP_TRIGGERREPEATINTERVAL) {m_params.dwTriggerButton = params->dwTriggerRepeatInterval; DBUG_WARN("DIEP_TRIGGERREPEATINTERVAL NOT IMPLEMENTED");}
    if (flags & DIEP_ENVELOPE)
    {
        DBUG_WARN("DIEP_ENVELOPE NOT SUPPORTED");
        if (params->lpEnvelope != nullptr) memcpy(&m_envelope, params->lpEnvelope, sizeof(DIENVELOPE));
        DBUG_WARN((string("ATTACK: ")+to_string(m_envelope.dwAttackLevel) + " DURATION: " + to_string(m_envelope.dwAttackTime) + " Fade:" +
                   to_string(m_envelope.dwFadeLevel)  +" DURATION: " + to_string(m_envelope.dwFadeTime)).c_str())
    }
    if (flags & DIEP_AXES)
    {
        DBUG_WARN("DIEP_AXES NOT SUPPORTED");
        if (m_params.cAxes) memcpy(m_axes, params->rgdwAxes, sizeof(DWORD)*m_params.cAxes);
    }
    if (flags & DIEP_DIRECTION)
    {
         DBUG_WARN("DIEP_DIRECTION NOT SUPPORTED");
         if (m_params.cAxes && (params->dwFlags & (DIEFF_CARTESIAN|DIEFF_POLAR|DIEFF_POLAR)))
         memcpy(m_directions, params->rglDirection, sizeof(LONG)*m_params.cAxes);
    }
    if (flags & DIEP_TYPESPECIFICPARAMS)
    {
        if      (*(DWORD*)m_type.c_str() == *(DWORD*)"CONSTANT")  memcpy(&m_constant_force, params->lpvTypeSpecificParams, params->cbTypeSpecificParams);
        else if (*(DWORD*)m_type.c_str() == *(DWORD*)"RampForce") memcpy(&m_ramp, params->lpvTypeSpecificParams, params->cbTypeSpecificParams);
        else if ((*(DWORD*)m_type.c_str() == *(DWORD*)"SINE")  ||
            (*(DWORD*)m_type.c_str() == *(DWORD*)"Square")     ||
            (*(DWORD*)m_type.c_str() == *(DWORD*)"TRIANGLE")   ||
            (*(DWORD*)m_type.c_str() == *(DWORD*)"SawtoothUp") ||
            (*(DWORD*)m_type.c_str() == *(DWORD*)"SawtoothDown"))
        {
            memcpy(&m_periodic, params->lpvTypeSpecificParams, params->cbTypeSpecificParams);
        }
    }
    Reset();
    if (flags & DIEP_START)
    {
         Play(0, 1);
    }
    return DI_OK;    
}

HRESULT STDMETHODCALLTYPE ConstantForce::Stop(THIS){
    LogCall(__FUNCTION__);  
    Reset();
    return DI_OK;    
}
HRESULT STDMETHODCALLTYPE ConstantForce::GetEffectStatus(THIS_ LPDWORD f){
    LogCall(__FUNCTION__);
    if (f == nullptr) return DIERR_INVALIDPARAM;
    //else *f = m_LastEvent->Wait(0) == WAIT_OBJECT_0 ? 0 : DIEGES_PLAYING; // brakes star wars racer
    else *f = m_LastEvent->IsSignaled() ? DIEGES_PLAYING : 0;
    //DBUG_WARN(*f == 0 ? "STOPED" : "PLAYING");
    return DI_OK;
}
HRESULT STDMETHODCALLTYPE ConstantForce::Download(THIS){
    return LogNotImplemented(__FUNCTION__);
}
HRESULT STDMETHODCALLTYPE ConstantForce::Unload(THIS){
    Stop();
    return LogNotImplemented(__FUNCTION__);
}
HRESULT STDMETHODCALLTYPE ConstantForce::Escape(THIS_ LPDIEFFESCAPE){
    return LogNotImplemented(__FUNCTION__);
}

void ConstantForce::LogParams(DWORD type, DWORD n_times){
    std::string fflog(m_type + std::to_string(n_times) + " times: ");
    fflog.append(" Gain: "         + std::to_string(m_params.dwGain));
    fflog.append(" Duration: "     + std::to_string(m_params.dwDuration));
    fflog.append(" SamplePeriod: " + std::to_string(m_params.dwSamplePeriod));
    if (type == 0)
    {
        fflog.append(" Magnitude: " + std::to_string(m_constant_force.lMagnitude));
        fflog.append(" Magnitude %: " +
                     std::to_string( (float)(abs(m_constant_force.lMagnitude)*m_params.dwGain)/100000000.f) );
    }
    if (type == 2)
    {
        fflog.append(" Magnitude: " + std::to_string(m_periodic.dwMagnitude));
        fflog.append(" Offset: "    + std::to_string(m_periodic.lOffset));
        fflog.append(" Phase: "     + std::to_string(m_periodic.dwPhase));
        fflog.append(" Period: "  + std::to_string(m_periodic.dwPeriod));
    }
    if (type == 3)
    {
        fflog.append(" Start: " + std::to_string(m_ramp.lStart));
        fflog.append(" End: "   + std::to_string(m_ramp.lEnd));        
    }
    DBUG_LOG(fflog.c_str());
}

HRESULT STDMETHODCALLTYPE ConstantForce::Start(DWORD n_times, DWORD flags)
{
    LogCall(__FUNCTION__);
    m_repeats = n_times;
    Play(n_times, flags);
    return DI_OK;
}

/*
void DiSetForce(UINT right, UINT left)
{
    DINPUT_WARN((string("====================================================")+to_string(right) + " " +to_string(left)).c_str())
    XINPUT_VIBRATION force = {(WORD)right , (WORD)left};
    XInputSetState(0, &force);
}
*/

#define DiSetForce(l, r) f.Set(l, r); //\
DINPUT_WARN((string("====================================================")+to_string(l) + " " +to_string(r)).c_str());}

DWORD WINAPI PlayConstantForce(LPVOID * params)
{
    DiEffectparams* p = (DiEffectparams*)params;
    DFIForce f;
    
    float           max    = 10000. * 10000.;
    float           val    = (float)p->constant.lMagnitude * (float)p->params.dwGain;
    float        fraction  = abs(val / max);
    UINT force             = (WORD)(65535.f * fraction);        
    //OUTPUT_FUNC_DBG_STRING(std::to_string(duration).c_str());
    DiSetForce(force, force);
        
    auto loop = new EffectLoop(p->params.dwDuration, p->play_count, p->signal);  // stack allocation breaks animusha 
    while (loop->Step()) continue;    
    DiSetForce(0, 0);
    delete p;
    delete loop;
    return 0;
}

void ConstantForce::Play(DWORD n_times, DWORD flags)
{
    LogParams(0, n_times);    
    DiEffectparams* params = new DiEffectparams(Reset()->Get(),  &m_params, n_times, &m_constant_force, nullptr);
    CreateThread(nullptr, 0, (LPTHREAD_START_ROUTINE)PlayConstantForce, (void*)params, 0, nullptr);
}

DWORD WINAPI PlaySawtoothUp(LPVOID* params)
{
    DFIForce f;
    DiEffectparams* p = (DiEffectparams*)params;
    DIFFDEBUGPARAMS
        
    auto loop        = EffectLoop(p->params.dwDuration, p->play_count, p->signal);
    auto P           = DiPeriodicEffect(p, loop, (float)p->periodic.dwMagnitude);
   
    float curr_force = P.start;    
    float force      = P.gain * curr_force;
    if      (force > 0.)  DiSetForce((UINT)(65535.f * force), 0)
    else if (force < 0.)  DiSetForce(0, (UINT)(65535.f * force));
        
    UINT what = loop.Step();
    while (what)
    {
        curr_force = curr_force == P.end ? P.start : curr_force + P.delta;
        force      = P.gain*curr_force;
        //OUTPUT_FUNC_DBG_STRING(to_string(force).c_str());
        if      (force > 0.)  DiSetForce((UINT)(65535.f * force), 0)
        else if (force < 0.)  DiSetForce(0, (UINT)(65535.f * force));
        
        what = loop.Step();
    }   
    DiSetForce(0, 0);
    delete p;
    return 0;
}

void SawtoothUp::Play(DWORD n_times, DWORD flags)
{
    LogParams(2, n_times);
    DiEffectparams* params = new DiEffectparams(Reset()->Get(), &m_params, n_times, nullptr, &m_periodic);
    CreateThread(nullptr, 0, (LPTHREAD_START_ROUTINE)PlaySawtoothUp, (void*)params, 0, nullptr);
}

DWORD WINAPI PlaySawtoothDn(LPVOID* params)
{
    DFIForce f;
    DiEffectparams* p = (DiEffectparams*)params;
    DIFFDEBUGPARAMS
      
    auto loop        = EffectLoop(p->params.dwDuration, p->play_count, p->signal);
    auto P           = DiPeriodicEffect(p, loop, (float)p->periodic.dwMagnitude * -1.f);

    float curr_force = P.start;
    float force      = P.gain * curr_force;
    if      (force > 0.)  DiSetForce((UINT)(65535.f * force), 0)
    else if (force < 0.) DiSetForce(0, (UINT)(65535.f * force));

    UINT what = loop.Step();
    while (what)
    {
        curr_force = curr_force == P.end ? P.start : curr_force - P.delta;
        force      = P.gain * curr_force;
        //OUTPUT_FUNC_DBG_STRING(to_string(force).c_str());
        if (force > 0.)       DiSetForce((UINT)(65535.f * force), 0)
        else if (force < 0.)  DiSetForce(0, (UINT)(65535.f * force));

        what = loop.Step();
    }    
    DiSetForce(0, 0);
    delete p;
    return 0;
}

void SawtoothDown::Play(DWORD n_times, DWORD flags)
{
    LogParams(2, n_times);
    DiEffectparams* params = new DiEffectparams(Reset()->Get(), &m_params, n_times, nullptr, &m_periodic);
    CreateThread(nullptr, 0, (LPTHREAD_START_ROUTINE)PlaySawtoothDn, (void*)params, 0, nullptr);
}

DWORD WINAPI PlayTriangle(LPVOID* params)
{
    DFIForce f;
    DiEffectparams* p = (DiEffectparams*)params;
    DIFFDEBUGPARAMS

    auto loop       = EffectLoop(p->params.dwDuration, p->play_count, p->signal);
    auto P          = DiPeriodicEffect(p, loop, (float)p->periodic.dwMagnitude);

    float curr_force = P.start;
    float force      = P.gain * curr_force;
    if      (force > 0.) DiSetForce((UINT)(65535.f * force), 0)
    else if (force < 0.) DiSetForce(0, (UINT)(65535.f * abs(force)));

    UINT what  = loop.Step();
    UINT phase = 0;
    while (what)
    {
        curr_force += P.delta;
        if (curr_force > P.end || curr_force < P.start)
        {
            P.delta    *= -1.f;
            curr_force += P.delta;
        }                      
        force = P.gain * curr_force;
        //OUTPUT_FUNC_DBG_STRING(to_string(force).c_str());
        if     (force > 0.)   DiSetForce((UINT)(65535.f * force), 0)
        else if (force < 0.)  DiSetForce(0, (UINT)(65535.f * abs(force)));

        what = loop.Step();
    }        
    DiSetForce(0, 0);
    delete p;
    return 0;
}

void Triangle::Play(DWORD n_times, DWORD flags)
{
    LogParams(2, n_times);
    DiEffectparams* params = new DiEffectparams(Reset()->Get(), &m_params, n_times, nullptr, &m_periodic);
    CreateThread(nullptr, 0, (LPTHREAD_START_ROUTINE)PlayTriangle, (void*)params, 0, nullptr);
}

DWORD WINAPI PlaySquare(LPVOID* params)
{
    DFIForce f;
    DiEffectparams* p = (DiEffectparams*)params;
    DIFFDEBUGPARAMS
       
    auto loop       = EffectLoop(p->params.dwDuration, p->play_count, p->signal);
    auto P          = DiPeriodicEffect(p, loop, (float)p->periodic.dwMagnitude);

    float curr_force = P.start;
    float force      = P.gain * curr_force;
    if      (force > 0.) DiSetForce((UINT)(65535.f * force), 0)
    else if (force < 0.) DiSetForce(0, (UINT)(65535.f * abs(force)));

    UINT what  = loop.Step();
    UINT phase = 0;
    while (what)
    {
        if (phase == 0)
        {
            if  (curr_force == P.end)   phase = 1;
            else curr_force += P.delta;
        }
        else if (phase == 1)
        {
            if  (curr_force == P.start) phase = 0;
            else curr_force -= P.delta;
        }
        force = phase == 0 ? P.gain * P.start : P.gain * P.end;
        //OUTPUT_FUNC_DBG_STRING(to_string(force).c_str());
        if      (force > 0.)  DiSetForce((UINT)(65535.f * force), 0)
        else if (force < 0.)  DiSetForce(0, (UINT)(65535.f * abs(force)));

        what = loop.Step();
    }    
    DiSetForce(0, 0);
    delete p;
    return 0;
}

void Square::Play(DWORD n_times, DWORD flags)
{
    LogParams(2, n_times);
    DiEffectparams* params = new DiEffectparams(Reset()->Get(), &m_params, n_times, nullptr, &m_periodic);    
    CreateThread(nullptr, 0, (LPTHREAD_START_ROUTINE)PlaySquare, (void*)params, 0, nullptr);
}

DWORD WINAPI PlaySine(LPVOID* params)
{
    DFIForce f;
    DiEffectparams* p = (DiEffectparams*)params;
    DIFFDEBUGPARAMS

    auto loop       = EffectLoop(p->params.dwDuration, p->play_count, p->signal);     
    auto P          = DiPeriodicEffect(p, loop, (float)p->periodic.dwMagnitude);
    double delta    = (double)M_PI / (double)loop.StepCount();
    double twopi    = 2. * M_PI;
    double X        = 0.0;
    float sine      = 0.0;
    delta          *= P.repeats;

    float curr_force = P.start;
    float force      = P.gain * curr_force;
    if      (force > 0.) DiSetForce((UINT)(65535.f * force), 0)
    else if (force < 0.) DiSetForce(0, (UINT)(65535.f * abs(force)));

    UINT what = loop.Step();
    while (what)
    {
        X += delta;
        if (X > twopi) X = 0.0;
        sine = sin(X);       
        sine += 1.;      // 0 - 2 range;
        sine /= 2.;      // 0 - 1 range;
        
        sine  = (sine * P.range) + P.start;
        force = sine * P.gain;
        //DBUG_WARN(to_string(force).c_str());        
        if      (force > 0.)  DiSetForce((UINT)(65535.f * force), 0)
        else if (force < 0.)  DiSetForce(0, (UINT)(65535.f * abs(force)));

        what = loop.Step();
    }    
    DiSetForce(0, 0);
    delete p;    
    return 0;
}

void Sine::Play(DWORD n_times, DWORD flags)
{
    LogParams(2, n_times);
    DiEffectparams* params = new DiEffectparams(Reset()->Get(), &m_params, n_times, nullptr, &m_periodic);    
    CreateThread(nullptr, 0, (LPTHREAD_START_ROUTINE)PlaySine, (void*)params, 0, nullptr);
}

DWORD WINAPI PlayRamp(LPVOID* params)
{
    DFIForce f;
    DiEffectparams* p = (DiEffectparams*)params;
    //p->ramp.lStart = -10000;
    //p->ramp.lEnd   = 10000;
    //p->params.dwDuration *= 5LL;

    auto loop         = EffectLoop(p->params.dwDuration, p->play_count, p->signal);
    float max         = (float)p->ramp.lEnd;
    float min         = (float)p->ramp.lStart;
    float range       = abs(max - min);
    float delta       = range / (float)loop.StepCount();
    float gain        = (float)p->params.dwGain / (10000.f * 10000.f);
    float curr_force  = min;
    float force       = curr_force * gain;

    if      (force > 0.) DiSetForce((UINT)(65535.f * force), 0)
    else if (force < 0.) DiSetForce(0, (UINT)(65535.f * abs(force)));

    UINT what = loop.Step();
    while (what)
    {
        curr_force = curr_force == max ? min : curr_force + delta;
        force      = curr_force * gain;
        //OUTPUT_FUNC_DBG_STRING(to_string(force).c_str());
        if (force > 0.)       DiSetForce((UINT)(65535.f * force), 0)
        else if (force < 0.)  DiSetForce(0, (UINT)(65535.f * abs(force)));

        what = loop.Step();
    }    
    DiSetForce(0, 0);
    delete p;
    return 0;  
}

void RampForce::Play(DWORD n_times, DWORD flags)
{
    LogParams(3, n_times);
    DiEffectparams* params = new DiEffectparams(Reset()->Get(), &m_params, n_times, nullptr, nullptr, nullptr, &m_ramp);
    CreateThread(nullptr, 0, (LPTHREAD_START_ROUTINE)PlayRamp, (void*)params, 0, nullptr);
}

