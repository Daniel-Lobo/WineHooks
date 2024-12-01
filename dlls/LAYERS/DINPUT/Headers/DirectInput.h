#ifndef DIRECTINPUT_H
#define DIRECTINPUT_H
#define __uuidof(IDirectInputA) IID_IDirectInputA
#define __uuidof(IDirectInputW) IID_IDirectInputW
#define __uuidof(IDirectInput2A) IID_IDirectInput2A
#define __uuidof(IDirectInput2W) IID_IDirectInput2W
#define __uuidof(IDirectInput7A) IID_IDirectInput7A
#define __uuidof(IDirectInput7W) IID_IDirectInput7W
#define __uuidof(IDirectInput8A) IID_IDirectInput8A
#define __uuidof(IDirectInput8W) IID_IDirectInput8W
#include <windows.h>
#include "ms_dinput.h"
#include <dllmain.h>
#include "Sync.h"
#include "LayersCommon.h"
#include <xinput.h>
#include "DInputHooks.h"
#include <vector>

using std::vector;

/* NOTE: because I was stupid enough to use the COM_FOWARD macro in all methods, every interface reimplements every method. 
 * If this is ever to be fixed, the DinputHooks.h, DinputHooks.cpp and DinputEmu.ahk files must be updated
 */

enum XInputIds {XINPUTID_LX, XINPUTID_LY, XINPUTID_RX, XINPUTID_RY, XINPUTID_POV};
DWORD DiGetDataSz(IUnknown*);
DWORD DiSetDataFormat(IUnknown*, LPCDIDATAFORMAT);
struct DI_DATA_ELEMENT {
    DI_DATA_ELEMENT(DIOBJECTDATAFORMAT * d, UINT id, UINT off)
    {
        memcpy(&data, d, sizeof(DIOBJECTDATAFORMAT));
        ID     = id;
        offset = off;
    }
    DWORD            offset = 0;
    DWORD                ID = 0;
    DIOBJECTDATAFORMAT data = {};
};
const vector<DI_DATA_ELEMENT>* DiGetDataFormat(IUnknown*);

class DInputBase
{
    vector<DI_DATA_ELEMENT> m_data_format;
    UINT          m_custom_format_set = 0;    
public:
    virtual vector<DI_DATA_ELEMENT>* Fmt() {
        return &m_data_format;
    };
    virtual void Set(UINT val) {
        m_custom_format_set = val;
    }
    virtual const UINT Get() {
        return m_custom_format_set;
    }   
};

#undef DBUG_WARN
#define DBUG_WARN DINPUT_WARN

class DirectInput :	virtual public IDirectInput7A, virtual public IDirectInput7W	
{
public:
    /*** IUnknown methods ***/
    UNREFDOBJECTIUNKNOWN
    //virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID, LPVOID*);
    //virtual ULONG STDMETHODCALLTYPE AddRef();
    //virtual ULONG STDMETHODCALLTYPE Release();
#undef  LAYER_THIS
#define LAYER_THIS IDirectInputA
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInputA
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"    
    /*** IDirectInputA methods ***/
    //COM_FOWARD(CreateDevice, REFGUID, LPDIRECTINPUTDEVICEA*, LPUNKNOWN);
    virtual HRESULT STDMETHODCALLTYPE CreateDevice(REFGUID, LPDIRECTINPUTDEVICEA*, LPUNKNOWN);
    COM_FOWARD(EnumDevices, DWORD, LPDIENUMDEVICESCALLBACKA, LPVOID, DWORD);
    COM_FOWARD(GetDeviceStatus, REFGUID);
    COM_FOWARD(RunControlPanel, HWND, DWORD);
    COM_FOWARD(Initialize, HINSTANCE, DWORD);
    /*** IDirectInputW methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInputW
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInputW
    //COM_FOWARD(CreateDevice, REFGUID, LPDIRECTINPUTDEVICEW*, LPUNKNOWN);
    virtual HRESULT STDMETHODCALLTYPE CreateDevice(REFGUID, LPDIRECTINPUTDEVICEW*, LPUNKNOWN);
    COM_FOWARD(EnumDevices, DWORD, LPDIENUMDEVICESCALLBACKW, LPVOID, DWORD);
    /*** IDirectInput2A methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInput2A
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInput2A
    COM_FOWARD(FindDevice, REFGUID, LPCSTR, LPGUID);
    /*** IDirectInput2W methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInput2W
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInput2W
    COM_FOWARD(FindDevice, REFGUID, LPCWSTR, LPGUID);
    /*** IDirectInput7A methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInput7A
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInput7A
    //COM_FOWARD(CreateDeviceEx, REFGUID, REFIID, LPVOID *, LPUNKNOWN); 
    virtual HRESULT STDMETHODCALLTYPE CreateDeviceEx(REFGUID, REFIID, LPVOID*, LPUNKNOWN);
    DirectInput(IUnknown*);
    UNREFDOBJECTDEL(DirectInput);
private:    
    IUnknown     * m_Imp      = nullptr;
    SYNC::Atomic * m_ref      = nullptr;
};


class DirectInput8 : virtual public IDirectInput8A, virtual public IDirectInput8W
{
public:
    /*** IUnknown methods ***/
    UNREFDOBJECTIUNKNOWN
    //virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID, LPVOID*);
    //virtual ULONG STDMETHODCALLTYPE AddRef();
    //virtual ULONG STDMETHODCALLTYPE Release();
#undef  LAYER_THIS
#define LAYER_THIS IDirectInput8A
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInput8A
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"    
    /*** IDirectInput8A methods ***/
    //COM_FOWARD(CreateDevice, REFGUID, LPDIRECTINPUTDEVICE8A*, LPUNKNOWN);
    virtual HRESULT STDMETHODCALLTYPE CreateDevice(REFGUID, LPDIRECTINPUTDEVICE8A*, LPUNKNOWN);
    COM_FOWARD(EnumDevices, DWORD, LPDIENUMDEVICESCALLBACKA, LPVOID, DWORD);
    COM_FOWARD(GetDeviceStatus, REFGUID);
    COM_FOWARD(RunControlPanel, HWND, DWORD);
    COM_FOWARD(Initialize, HINSTANCE, DWORD);
    COM_FOWARD(FindDevice, REFGUID, LPCSTR, LPGUID);
    COM_FOWARD(EnumDevicesBySemantics, LPCSTR, LPDIACTIONFORMATA, LPDIENUMDEVICESBYSEMANTICSCBA, LPVOID, DWORD);
    COM_FOWARD(ConfigureDevices, LPDICONFIGUREDEVICESCALLBACK, LPDICONFIGUREDEVICESPARAMSA, DWORD, LPVOID);
#undef  LAYER_THIS
#define LAYER_THIS IDirectInput8W
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInput8W
    /*** IDirectInput8W methods ***/
    //COM_FOWARD(CreateDevice, REFGUID, LPDIRECTINPUTDEVICE8W*, LPUNKNOWN);
    virtual HRESULT STDMETHODCALLTYPE CreateDevice(REFGUID, LPDIRECTINPUTDEVICE8W*, LPUNKNOWN);
    COM_FOWARD(EnumDevices, DWORD, LPDIENUMDEVICESCALLBACKW, LPVOID, DWORD);
    COM_FOWARD(FindDevice, REFGUID, LPCWSTR, LPGUID);
    COM_FOWARD(EnumDevicesBySemantics, LPCWSTR, LPDIACTIONFORMATW, LPDIENUMDEVICESBYSEMANTICSCBW, LPVOID, DWORD);
    COM_FOWARD(ConfigureDevices, LPDICONFIGUREDEVICESCALLBACK, LPDICONFIGUREDEVICESPARAMSW, DWORD, LPVOID);
    DirectInput8(IUnknown*);
    UNREFDOBJECTDEL(DirectInput8);
private:
    IUnknown     * m_Imp      = nullptr;
    SYNC::Atomic * m_ref      = nullptr;
};

class DirectInputDevice : virtual public IDirectInputDevice7A, virtual public IDirectInputDevice7W, virtual public DInputBase
{
public:
    /*** IUnknown methods ***/
    UNREFDOBJECTIUNKNOWN
    //virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID, LPVOID*);
    //virtual ULONG STDMETHODCALLTYPE AddRef();
    //virtual ULONG STDMETHODCALLTYPE Release();
#undef  LAYER_THIS
#define LAYER_THIS IDirectInputDeviceA
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInputDeviceA
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"   
    /*** IDirectInputDeviceA methods ***/
    COM_FOWARD(GetCapabilities, LPDIDEVCAPS);
    COM_FOWARD(EnumObjects, LPDIENUMDEVICEOBJECTSCALLBACKA, LPVOID, DWORD);
    COM_FOWARD(GetProperty, REFGUID, LPDIPROPHEADER);
    COM_FOWARD(SetProperty, REFGUID, LPCDIPROPHEADER);
    COM_FOWARD(Acquire);
    COM_FOWARD(Unacquire);
    COM_FOWARD(GetDeviceState, DWORD, LPVOID);
    COM_FOWARD(GetDeviceData, DWORD, LPDIDEVICEOBJECTDATA, LPDWORD, DWORD);
    COM_FOWARD(SetDataFormat, LPCDIDATAFORMAT);
    COM_FOWARD(SetEventNotification, HANDLE);
    COM_FOWARD(SetCooperativeLevel, HWND, DWORD);
    COM_FOWARD(GetObjectInfo, LPDIDEVICEOBJECTINSTANCEA, DWORD, DWORD);
    COM_FOWARD(GetDeviceInfo, LPDIDEVICEINSTANCEA);
    COM_FOWARD(RunControlPanel, HWND, DWORD);
    COM_FOWARD(Initialize, HINSTANCE, DWORD, REFGUID);
    /*** IDirectInputDeviceW methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInputDeviceW
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInputDeviceW
    COM_FOWARD(EnumObjects, LPDIENUMDEVICEOBJECTSCALLBACKW, LPVOID, DWORD);
    COM_FOWARD(GetObjectInfo, LPDIDEVICEOBJECTINSTANCEW, DWORD, DWORD);
    COM_FOWARD(GetDeviceInfo, LPDIDEVICEINSTANCEW);
    /*** IDirectInputDevice2A methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInputDevice2A
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInputDevice2A
    COM_FOWARD(CreateEffect, REFGUID, LPCDIEFFECT, LPDIRECTINPUTEFFECT*, LPUNKNOWN);
    COM_FOWARD(EnumEffects, LPDIENUMEFFECTSCALLBACKA, LPVOID, DWORD);
    COM_FOWARD(GetEffectInfo, LPDIEFFECTINFOA, REFGUID);
    COM_FOWARD(GetForceFeedbackState, LPDWORD);
    COM_FOWARD(SendForceFeedbackCommand, DWORD);
    COM_FOWARD(EnumCreatedEffectObjects, LPDIENUMCREATEDEFFECTOBJECTSCALLBACK, LPVOID, DWORD);
    COM_FOWARD(Escape, LPDIEFFESCAPE);
    COM_FOWARD(Poll);
    COM_FOWARD(SendDeviceData, DWORD, LPCDIDEVICEOBJECTDATA, LPDWORD, DWORD);
    /*** IDirectInputDevice2W methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInputDevice2W
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInputDevice2W
    COM_FOWARD(EnumEffects, LPDIENUMEFFECTSCALLBACKW, LPVOID, DWORD);
    COM_FOWARD(GetEffectInfo, LPDIEFFECTINFOW, REFGUID);
    /*** IDirectInputDevice7A methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInputDevice7A
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInputDevice7A
    COM_FOWARD(EnumEffectsInFile, LPCSTR, LPDIENUMEFFECTSINFILECALLBACK, LPVOID, DWORD);
    COM_FOWARD(WriteEffectToFile, LPCSTR, DWORD, LPDIFILEEFFECT, DWORD);
    /*** IDirectInputDevice7W methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInputDevice7W
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInputDevice7W
    COM_FOWARD(EnumEffectsInFile, LPCWSTR, LPDIENUMEFFECTSINFILECALLBACK, LPVOID, DWORD);
    COM_FOWARD(WriteEffectToFile, LPCWSTR, DWORD, LPDIFILEEFFECT, DWORD);
    DirectInputDevice(IUnknown*);
    UNREFDOBJECTDEL(DirectInputDevice);
private:
    IUnknown     * m_Imp     = nullptr;
    SYNC::Atomic * m_ref     = nullptr;
};

class DirectInputDevice8 : virtual public IDirectInputDevice8A, virtual public IDirectInputDevice8W, virtual public DInputBase
{
public:
    /*** IUnknown methods ***/
    UNREFDOBJECTIUNKNOWN
    //virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID, LPVOID*);
    //virtual ULONG STDMETHODCALLTYPE AddRef();
    //virtual ULONG STDMETHODCALLTYPE Release();
    /*** IDirectInputDevice8A methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInputDevice8A
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInputDevice8A
#undef  LAYER_OK 
#define LAYER_OK "DD_OK"    
    COM_FOWARD(GetCapabilities, LPDIDEVCAPS);
    COM_FOWARD(EnumObjects, LPDIENUMDEVICEOBJECTSCALLBACKA, LPVOID, DWORD);
    COM_FOWARD(GetProperty, REFGUID, LPDIPROPHEADER);
    COM_FOWARD(SetProperty, REFGUID, LPCDIPROPHEADER);
    COM_FOWARD(Acquire);
    COM_FOWARD(Unacquire);
    COM_FOWARD(GetDeviceState, DWORD, LPVOID);
    COM_FOWARD(GetDeviceData, DWORD, LPDIDEVICEOBJECTDATA, LPDWORD, DWORD);
    COM_FOWARD(SetDataFormat, LPCDIDATAFORMAT);
    COM_FOWARD(SetEventNotification, HANDLE);
    COM_FOWARD(SetCooperativeLevel, HWND, DWORD);
    COM_FOWARD(GetObjectInfo, LPDIDEVICEOBJECTINSTANCEA, DWORD, DWORD);
    COM_FOWARD(GetDeviceInfo, LPDIDEVICEINSTANCEA);
    COM_FOWARD(RunControlPanel, HWND, DWORD);
    COM_FOWARD(Initialize, HINSTANCE, DWORD, REFGUID);
    COM_FOWARD(CreateEffect, REFGUID, LPCDIEFFECT, LPDIRECTINPUTEFFECT*, LPUNKNOWN);
    COM_FOWARD(EnumEffects, LPDIENUMEFFECTSCALLBACKA, LPVOID, DWORD);
    COM_FOWARD(GetEffectInfo, LPDIEFFECTINFOA, REFGUID);
    COM_FOWARD(GetForceFeedbackState, LPDWORD);
    COM_FOWARD(SendForceFeedbackCommand, DWORD);
    COM_FOWARD(EnumCreatedEffectObjects, LPDIENUMCREATEDEFFECTOBJECTSCALLBACK, LPVOID, DWORD);
    COM_FOWARD(Escape, LPDIEFFESCAPE);
    COM_FOWARD(Poll);
    COM_FOWARD(SendDeviceData, DWORD, LPCDIDEVICEOBJECTDATA, LPDWORD, DWORD);
    COM_FOWARD(EnumEffectsInFile, LPCSTR, LPDIENUMEFFECTSINFILECALLBACK, LPVOID, DWORD);
    COM_FOWARD(WriteEffectToFile, LPCSTR, DWORD, LPDIFILEEFFECT, DWORD);
    COM_FOWARD(BuildActionMap, LPDIACTIONFORMATA, LPCSTR, DWORD);
    COM_FOWARD(SetActionMap, LPDIACTIONFORMATA, LPCSTR, DWORD);
    COM_FOWARD(GetImageInfo, LPDIDEVICEIMAGEINFOHEADERA);
    /*** IDirectInputDevice8W methods ***/
#undef  LAYER_THIS
#define LAYER_THIS IDirectInputDevice8W
#undef  LAYER_GUID
#define LAYER_GUID IID_IDirectInputDevice8W
#undef  LAYER_OK 
#define LAYER_OK "DD_OK" 
    COM_FOWARD(EnumObjects, LPDIENUMDEVICEOBJECTSCALLBACKW, LPVOID, DWORD);
    COM_FOWARD(GetObjectInfo, LPDIDEVICEOBJECTINSTANCEW, DWORD, DWORD);
    COM_FOWARD(GetDeviceInfo, LPDIDEVICEINSTANCEW);
    COM_FOWARD(EnumEffects, LPDIENUMEFFECTSCALLBACKW, LPVOID, DWORD);
    COM_FOWARD(GetEffectInfo, LPDIEFFECTINFOW, REFGUID);
    COM_FOWARD(EnumEffectsInFile, LPCWSTR, LPDIENUMEFFECTSINFILECALLBACK, LPVOID, DWORD);
    COM_FOWARD(WriteEffectToFile, LPCWSTR, DWORD, LPDIFILEEFFECT, DWORD);
    COM_FOWARD(BuildActionMap, LPDIACTIONFORMATW, LPCWSTR, DWORD);
    COM_FOWARD(SetActionMap, LPDIACTIONFORMATW, LPCWSTR, DWORD);
    COM_FOWARD(GetImageInfo, LPDIDEVICEIMAGEINFOHEADERW);
    DirectInputDevice8(IUnknown*);
    UNREFDOBJECTDEL(DirectInputDevice8);
private:
    IUnknown     * m_Imp = nullptr;
    SYNC::Atomic * m_ref = nullptr;
};

#endif // DIRECTINPUT_H
