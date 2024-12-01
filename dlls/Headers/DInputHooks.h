#ifndef DINPUTHOOKS_H
#define DINPUTHOOKS_H
#include <windows.h>
#include "ms_dinput.h"
#include "Sync.h"
#include <string>
#include "dllmain.h"
#include "Dbug.h"

#define DINPUT_LOG(string) g_Dinput.m_loger.log(__FUNCTION__, string);
#define DINPUT_WARN(string)  g_Dinput.m_loger.dolog(__FUNCTION__, string);
#define DINPUT_WARN DINPUT_LOG
#define DINPUT_HR(call, ...) if ( FAILED(call) ) {DINPUT_WARN(#call " FAILED") __VA_ARGS__}
#undef DBUG_WARN
#define DBUG_WARN DINPUT_WARN

using std::string;
using std::to_string;

class DinputGlobals {
public:
    void Init() {
        m_loger.Init("\\Input.log");        
        GETSYSDLLPROCADDRESS(m_DirectInputCreateA, "DirectInputCreateA", "dinput.dll");
        GETSYSDLLPROCADDRESS(m_DirectInputCreateW, "DirectInputCreateW", "dinput.dll");
        GETSYSDLLPROCADDRESS(m_DirectInputCreateEx, "DirectInputCreateEx", "dinput.dll");
        GETSYSDLLPROCADDRESS(m_DllGetClassObject, "DllGetClassObject", "dinput.dll");
        GETSYSDLLPROCADDRESS(m_DirectInput8Create, "DirectInput8Create", "dinput8.dll");
        GETSYSDLLPROCADDRESS(m_DllGetClassObject8, "DllGetClassObject", "dinput8.dll");
        GETSYSDLLPROCADDRESS(m_joyGetDevCapsA, "joyGetDevCapsA", "winmm.dll");
        GETSYSDLLPROCADDRESS(m_joyGetDevCapsW, "joyGetDevCapsW", "winmm.dll");
        GETSYSDLLPROCADDRESS(m_joyGetPos, "joyGetPos", "winmm.dll");
        GETSYSDLLPROCADDRESS(m_joyGetPosEx, "joyGetPosEx", "winmm.dll");
        m_Left  = new SYNC::AtomicFloat(0.f);
        m_Right = new SYNC::AtomicFloat(0.f);
    }
    WLoger             m_loger;
    UINT      m_version    = 0;
    SYNC::AtomicFloat * m_Left  = nullptr;
    SYNC::AtomicFloat * m_Right = nullptr;
    HRESULT  (WINAPI *m_DirectInputCreateA)  (HINSTANCE, DWORD, LPDIRECTINPUTA*, LPUNKNOWN) = nullptr;
    HRESULT  (WINAPI *m_DirectInputCreateW)  (HINSTANCE, DWORD, LPDIRECTINPUTW*, LPUNKNOWN) = nullptr;
    HRESULT  (WINAPI *m_DirectInputCreateEx) (HINSTANCE, DWORD, REFIID, LPVOID*, LPUNKNOWN) = nullptr;
    HRESULT  (WINAPI *m_DirectInput8Create)  (HINSTANCE, DWORD, REFIID, LPVOID* ,LPUNKNOWN) = nullptr;   
    HRESULT  (WINAPI *m_DllGetClassObject)   (REFCLSID rclsid, REFIID, LPVOID*) = nullptr;    
    HRESULT  (WINAPI *m_DllGetClassObject8)  (REFCLSID rclsid, REFIID, LPVOID*) = nullptr;
    MMRESULT (WINAPI* m_joyGetDevCapsA)      (UINT, LPJOYCAPSA, UINT);
    MMRESULT (WINAPI* m_joyGetDevCapsW)      (UINT, LPJOYCAPSW, UINT);
    MMRESULT (WINAPI* m_joyGetPos)           (UINT, LPJOYINFO);
    MMRESULT (WINAPI* m_joyGetPosEx)         (UINT, LPJOYINFOEX);
    void SetForce(int right, int left)
    {
        LONG Left  = m_Left->Get();
        LONG Right = m_Right->Get();
        Left  += left;
        Right += right;
        m_Left->Set(Left);
        m_Right->Set(Right);
        if (Left  > 65535.f) Left  = 65535.f;
        if (Right > 65535.f) Right = 65535.f;
        XINPUT_VIBRATION force = {(WORD)right , (WORD)left};
        XInputSetState(0, &force);
    }
};
extern DinputGlobals g_Dinput;

typedef struct DIJOYSTATE_DX3 {
    LONG    lX;                     /* x-axis position              */
    LONG    lY;                     /* y-axis position              */
    LONG    lZ;                     /* z-axis position              */
    LONG    lRx;                    /* x-axis rotation              */
    LONG    lRy;                    /* y-axis rotation              */
    LONG    lRz;                    /* z-axis rotation              */
    DWORD   rgdwPOV;                /* POV directions               */
    BYTE    rgbButtons[32];         /* 32 buttons                   */
} DIJOYSTATE_DX3;

/* NOTE: Every interface reimplements every method, because the COM_FOWARD macro in used in all methodsin the Dinrectinput.h file */
typedef struct DINPT_HOOKS {
    int          DeadZone;
    int  NegativeDeadZone;
    DWORD           flags;
    DWORD     Buttons[12];
    DWORD     Triggers[2];
    HRESULT (__stdcall * GetDeviceState)    (IDirectInputDeviceA*, DWORD, LPVOID);
    HRESULT (__stdcall * GetDeviceState8)   (IDirectInputDevice8A*, DWORD, LPVOID);
    HRESULT (__stdcall * GetDeviceStateW)   (IDirectInputDeviceW*, DWORD, LPVOID);
    HRESULT (__stdcall * GetDeviceState8W)  (IDirectInputDevice8W*, DWORD, LPVOID);
    HRESULT (__stdcall * SetProperty)       (IDirectInputDeviceA*, DWORD, DIPROPDWORD *);
    HRESULT (__stdcall * SetProperty8)      (IDirectInputDevice8A*, DWORD, DIPROPDWORD*);
    HRESULT (__stdcall * SetPropertyW)      (IDirectInputDeviceW*, DWORD, DIPROPDWORD*);
    HRESULT (__stdcall * SetProperty8W)     (IDirectInputDevice8W*, DWORD, DIPROPDWORD*);
    HRESULT (__stdcall * CreateEffect)      (IDirectInputDeviceA*,REFGUID,LPCDIEFFECT,LPDIRECTINPUTEFFECT*,LPUNKNOWN);
    HRESULT (__stdcall * CreateEffect8)     (IDirectInputDevice8A*, REFGUID, LPCDIEFFECT, LPDIRECTINPUTEFFECT*, LPUNKNOWN);
    HRESULT (__stdcall * CreateEffectW)     (IDirectInputDeviceW*, REFGUID, LPCDIEFFECT, LPDIRECTINPUTEFFECT*, LPUNKNOWN);
    HRESULT (__stdcall * CreateEffect8W)    (IDirectInputDevice8W*, REFGUID, LPCDIEFFECT, LPDIRECTINPUTEFFECT*, LPUNKNOWN);
    HRESULT (__stdcall * GetCapabilities)   (IDirectInputDeviceA*, LPDIDEVCAPS);
    HRESULT (__stdcall * GetCapabilities8)  (IDirectInputDevice8A*, LPDIDEVCAPS);
    HRESULT (__stdcall * GetCapabilitiesW)  (IDirectInputDeviceW*, LPDIDEVCAPS);
    HRESULT (__stdcall * GetCapabilities8W) (IDirectInputDevice8W*, LPDIDEVCAPS);
    HRESULT (__stdcall * EnumObjects)       (IDirectInputDeviceA*, LPDIENUMDEVICEOBJECTSCALLBACKA, LPVOID, DWORD);
    HRESULT (__stdcall * EnumObjects8)      (IDirectInputDevice8A*, LPDIENUMDEVICEOBJECTSCALLBACKA, LPVOID, DWORD);
    HRESULT (__stdcall * EnumObjectsW)      (IDirectInputDeviceW*, LPDIENUMDEVICEOBJECTSCALLBACKW, LPVOID, DWORD);
    HRESULT (__stdcall * EnumObjects8W)     (IDirectInputDevice8W*, LPDIENUMDEVICEOBJECTSCALLBACKW, LPVOID, DWORD);
    HRESULT (__stdcall * SetDataFormat)     (IDirectInputDeviceA*, LPCDIDATAFORMAT);
    HRESULT (__stdcall * SetDataFormat8)    (IDirectInputDevice8A*, LPCDIDATAFORMAT);
    HRESULT (__stdcall * SetDataFormatW)    (IDirectInputDeviceW*, LPCDIDATAFORMAT);
    HRESULT (__stdcall * SetDataFormat8W)   (IDirectInputDevice8W*, LPCDIDATAFORMAT);
    HRESULT (__stdcall * GetData)           (IDirectInputDeviceA*, DWORD, LPDIDEVICEOBJECTDATA, LPDWORD, DWORD);
    HRESULT (__stdcall * GetData8)          (IDirectInputDevice8A*, DWORD, LPDIDEVICEOBJECTDATA, LPDWORD, DWORD);
    HRESULT (__stdcall * GetDataW)          (IDirectInputDeviceW*, DWORD, LPDIDEVICEOBJECTDATA, LPDWORD, DWORD);
    HRESULT (__stdcall * GetData8W)         (IDirectInputDevice8W*, DWORD, LPDIDEVICEOBJECTDATA, LPDWORD, DWORD);
}DINPT_HOOKS;

class ConstantForce : IDirectInputEffect
{
public:
    ConstantForce(DIEFFECT *, char *, REFGUID);

    /*** IUnknown methods ***/
    virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, LPVOID * ppvObj);
    virtual ULONG STDMETHODCALLTYPE AddRef();
    virtual ULONG STDMETHODCALLTYPE Release();

    /*** IDirectInputEffect methods ***/
    virtual HRESULT STDMETHODCALLTYPE Initialize(HINSTANCE,DWORD,REFGUID);
    virtual HRESULT STDMETHODCALLTYPE GetEffectGuid(LPGUID);
    virtual HRESULT STDMETHODCALLTYPE GetParameters(LPDIEFFECT,DWORD);
    virtual HRESULT STDMETHODCALLTYPE SetParameters(LPCDIEFFECT,DWORD);
    virtual HRESULT STDMETHODCALLTYPE Start(DWORD,DWORD);
    virtual HRESULT STDMETHODCALLTYPE Stop();
    virtual HRESULT STDMETHODCALLTYPE GetEffectStatus(LPDWORD);
    virtual HRESULT STDMETHODCALLTYPE Download();
    virtual HRESULT STDMETHODCALLTYPE Unload();
    virtual HRESULT STDMETHODCALLTYPE Escape(LPDIEFFESCAPE);

    virtual ~ConstantForce() = default;
    virtual void Play(DWORD, DWORD);
    virtual void LogParams(DWORD, DWORD);
    virtual void LogParam(char * param){
        DBUG_LOG( (m_type + param + " set").c_str() );
    }
    void LogCall(char * func){
        DBUG_LOG( (m_type + func).c_str() );
    }
    HRESULT LogNotImplemented(char * func){
        DBUG_WARN( (m_type + func + " NOT IMPLEMENTED").c_str() );
        return E_NOTIMPL;
    }       
    SYNC::WinEvent * Reset()
    {
       m_LastEvent->Signal(TRUE);
       m_LastEvent->Close();
       m_LastEvent = new SYNC::WinEvent(&g_Dinput.m_loger);
       return m_LastEvent;
    }     

//private:  
    std::string                     m_type;    
    DWORD                      m_ref_count = 1;
    DIEFFECT                      m_params = {};
    DIENVELOPE                  m_envelope = {};
    DICONSTANTFORCE       m_constant_force = {};
    DIRAMPFORCE                     m_ramp = {};
    DIPERIODIC                  m_periodic = {};    
    DWORD                       m_axes[32] = {};
    LONG                  m_directions[32] = {};   
    XINPUT_VIBRATION               m_force = {};
    DWORD                        m_repeats = 0;
    GUID                            m_guid;
    SYNC::WinEvent * m_LastEvent = nullptr;
};

class Sine : public virtual ConstantForce
{
    public:    
    void Play(DWORD,DWORD);
    Sine(DIEFFECT * params, char * type, REFGUID rguid):ConstantForce(params, type, rguid){}
};

class Square : public virtual ConstantForce
{
    public:
    virtual void Play(DWORD, DWORD);
    Square(DIEFFECT * params, char * type, REFGUID rguid):ConstantForce(params, type, rguid){}
};

class Triangle : public virtual ConstantForce
{
    public:
    virtual void Play(DWORD, DWORD);
    Triangle(DIEFFECT * params, char * type, REFGUID rguid):ConstantForce(params, type, rguid){}
};

class SawtoothUp : public virtual ConstantForce
{
    public:    
    virtual void Play(DWORD,DWORD);
    SawtoothUp(DIEFFECT * params, char * type, REFGUID rguid):ConstantForce(params, type, rguid){}
};

class SawtoothDown : public virtual ConstantForce
{
    public:
    virtual void Play(DWORD, DWORD);
    SawtoothDown(DIEFFECT * params, char * type, REFGUID rguid):ConstantForce(params, type, rguid){}
};

class RampForce : public virtual ConstantForce
{
    public:
    virtual void Play(DWORD, DWORD);
    RampForce(DIEFFECT* params, char* type, REFGUID rguid) :ConstantForce(params, type, rguid) {}
};

class DIFxConditional : public virtual ConstantForce
{
    public:
    virtual void Play(DWORD, DWORD) { };
    virtual HRESULT STDMETHODCALLTYPE Start(DWORD,DWORD){return DI_OK;}    
    DIFxConditional(DIEFFECT * params, char * type, REFGUID rguid):ConstantForce(params, type, rguid){}
};

class EffectLoop
{
public:
    EffectLoop(UINT64 dur, UINT run_count, SYNC::WinEvent* manual_event)
    {
        double duration_ms = dur / 1000.;
        m_run_count        = run_count == 0 ? 1 : run_count;
        m_step_count       = (UINT)duration_ms / 10.;
        m_manual_event     = manual_event;
    }
    UINT StepCount() { return m_step_count; }
    UINT Step()
    {
        DWORD r = m_manual_event->Wait(10);
        if (r == WAIT_OBJECT_0)
        {
            m_manual_event->Close();
            return 0;
        }
        else
        {
            m_steps_taken++;
            if (m_steps_taken > m_step_count)
            {
                m_run_count -= 1;
                m_steps_taken = 0;
                if (m_run_count == 0)
                {
                    m_manual_event->Signal(0);
                    m_manual_event->Close();
                    return 0;
                }
            }
            return 1;
        }
    }
    int m_steps_taken = 0;
    UINT m_step_count = 1; 
    UINT m_run_count  = 0;
    SYNC::WinEvent* m_manual_event = nullptr;    
};

struct DiEffectparams {
    DiEffectparams(SYNC::WinEvent* s, DIEFFECT* fx, DWORD count, 
                   DICONSTANTFORCE* c, DIPERIODIC* p, DICUSTOMFORCE *cc=nullptr, DIRAMPFORCE *r=nullptr)
    {
        play_count = count;
        signal     = s;
        memcpy(&params, fx, sizeof(DIEFFECT));
        if (c)  memcpy(&constant, c, sizeof(DICONSTANTFORCE));
        if (p)  memcpy(&periodic, p, sizeof(DIPERIODIC));
        if (cc) memcpy(&custom,  cc, sizeof(DICUSTOMFORCE));
        if (r)  memcpy(&ramp,     r, sizeof(DIRAMPFORCE));
    }
    DWORD         play_count = 0;
    SYNC::WinEvent *  signal = nullptr;
    DIEFFECT          params = { };
    DICONSTANTFORCE constant = { };
    DIPERIODIC      periodic = { };
    DICUSTOMFORCE   custom   = { };
    DIRAMPFORCE     ramp     = { };
};

struct DiPeriodicEffect {
    float start, end, range, repeats, delta, gain;
    DiPeriodicEffect(DiEffectparams *p, EffectLoop &l, float m)
    {
        start           = (float)p->periodic.lOffset - m;
        end             = (float)p->periodic.lOffset + m;
        range           = abs(end - start);         
        repeats         = (float)p->params.dwDuration / (float)p->periodic.dwPeriod;
        delta           = range / (float)l.StepCount();
        gain            = (float)p->params.dwGain / (10000.f * 10000.f);

        /* dwDuration can be smaller then dwPeriod in which case the full effect cicle doesn't complete in one round of the effect */
        delta *= repeats;

        string log = "Start: " + to_string(start) + " End: " + to_string(end) + " Range: " + to_string(range) + " Delta: " + to_string(delta);
        log += " Steps: " + to_string(l.StepCount()) + " Repeats: " + to_string(repeats) + " Gain: " + to_string(gain);
        //DBUG_LOG(log.c_str());
    }
};

class DFIForce {
public:
    void Set(UINT l, UINT r)
    {
        left  = l - left;
        right = r - right;
        g_Dinput.SetForce(l, r);
    }
private:
    UINT left  = 0;
    UINT right = 0;
};

#endif // DINPUTHOOKS_H
