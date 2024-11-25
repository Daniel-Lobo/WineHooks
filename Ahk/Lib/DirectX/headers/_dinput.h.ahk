#include lib\DirectX\Headers\dinput.h.ahk

dinput.err["" . 0] := "DI_OK"
dinput.err[2147942487 . ""] := "DIERR_INVALIDPARAMS"

global DIDEVICEINSTANCE_DX3A := Struct("DWORD dwSize, GUID guidInstance, GUID guidProduct, DWORD dwDevType,"
                                       . "CHAR tszInstanceName[260], CHAR tszProductName[260]")
  

global DIDEVCAPS_DX3 :=
(
"
    DWORD   dwSize;
    DWORD   dwFlags;
    DWORD   dwDevType;
    DWORD   dwAxes;
    DWORD   dwButtons;
    DWORD   dwPOVs;
"
)
DIDEVCAPS_DX3 := Struct(DIDEVCAPS_DX3)
global DIDEVCAPS :=
(
"
    DWORD dwSize; 
    DWORD dwFlags; 
    DWORD dwDevType; 
    DWORD dwAxes; 
    DWORD dwButtons; 
    DWORD dwPOVs; 
    DWORD dwFFSamplePeriod; 
    DWORD dwFFMinTimeResolution; 
    DWORD dwFirmwareRevision; 
    DWORD dwHardwareRevision; 
    DWORD dwDriverVersion;
"
)
DIDEVCAPS := Struct(DIDEVCAPS)
                                       
global DIJOYSTATE :=
(
"
	LONG lX;
    LONG lY;
    LONG lZ;
    LONG lRx;
    LONG lRy;
    LONG lRz;
    LONG rglSlider[2];
    DWORD rgdwPOV[4];
    BYTE rgbButtons[32];
"
)
DIJOYSTATE := Struct(DIJOYSTATE) 									   
global DIJOYSTATE_DX3 :=	
(
"	
	LONG lX;
    LONG lY;
    LONG lZ;
    LONG lRx;
    LONG lRy;
    LONG lRz;
    Byte rgdwPOV[4];
    Byte rgbButtons[32];
"
)
DIJOYSTATE_DX3 := Struct(DIJOYSTATE_DX3)
global DIJOYSTATE2 :=
(
"
    LONG    lX;
    LONG    lY;
    LONG    lZ;
    LONG    lRx;
    LONG    lRy;
    LONG    lRz;
    LONG    rglSlider[2];
    DWORD   rgdwPOV[4];
    BYTE    rgbButtons[128];
    LONG    lVX;
    LONG    lVY;
    LONG    lVZ;
    LONG    lVRx;
    LONG    lVRy;
    LONG    lVRz;
    LONG    rglVSlider[2];
    LONG    lAX;
    LONG    lAY;
    LONG    lAZ;
    LONG    lARx;
    LONG    lARy;
    LONG    lARz;
    LONG    rglASlider[2];
    LONG    lFX;
    LONG    lFY;
    LONG    lFZ;
    LONG    lFRx;
    LONG    lFRy;
    LONG    lFRz;
    LONG    rglFSlider[2];
"
)
DIJOYSTATE2 := Struct(DIJOYSTATE2)
global DIEffectInfo :=
(
"
    DWORD dwSize;
    GUID guid;
    DWORD dwEffType;
    DWORD dwStaticParams;
    DWORD dwDynamicParams;
    TCHAR tszName[MAX_PATH];
"
)
DIEffectInfo := struct(DIEffectInfo)
