XinputSetState(index = 1, left_ = 0, right_ = 0)
{
	static XINPUT_STATE=0, XINPUT_SETSTATE=0, XINPUT_VIBRATION=0
	if ! XINPUT_VIBRATION
		VarSetCapacity(XINPUT_VIBRATION, 4)
		
	if ! XINPUT_SETSTATATE
	{
		XINPUT_HANDLE := dllcall("LoadLibrary", "wstr", "Xinput1_3.dll")
		if not XINPUT_HANDLE
			XINPUT_HANDLE := dllcall("GetModuleHandle", "wstr", "Xinput1_3.dll")
		XINPUT_SETSTATE := dllcall("GetProcAddress", "Int", XINPUT_HANDLE, "astr", "XInputSetState")
	}
		
	index -= 1
	numput(left_ * 65535, XINPUT_VIBRATION, "Short")
	numput(right_ * 65535, XINPUT_VIBRATION, 2, "Short")
	
	return dllcall(XINPUT_SETSTATE, int, index, ptr, &XINPUT_VIBRATION)
}	

global XINPUT_GAMEPAD :=
(
"
  WORD  wButtons;
  BYTE  bLeftTrigger;
  BYTE  bRightTrigger;
  SHORT sThumbLX;
  SHORT sThumbLY;
  SHORT sThumbRX;
  SHORT sThumbRY;
"
)
global  XINPUT_GAMEPAD_DPAD_UP        := 0	
global  XINPUT_GAMEPAD_DPAD_DOWN      := 0	
global	XINPUT_GAMEPAD_DPAD_LEFT      := 0	
global	XINPUT_GAMEPAD_DPAD_RIGHT     := 0	
global	XINPUT_GAMEPAD_START          := 0	
global	XINPUT_GAMEPAD_BACK           := 0	
global	XINPUT_GAMEPAD_LEFT_THUMB     := 0	
global	XINPUT_GAMEPAD_RIGHT_THUMB	  := 0	 
global	XINPUT_GAMEPAD_LEFT_SHOULDER  := 0	  
global	XINPUT_GAMEPAD_RIGHT_SHOULDER := 0		
global	XINPUT_GAMEPAD_A              := 0		
global	XINPUT_GAMEPAD_B              := 0		
global	XINPUT_GAMEPAD_X              := 0		
global	XINPUT_GAMEPAD_Y              := 0		
 
global  XINPUT_GAMEPAD_DPAD_UP_PREV	        := 0	
global  XINPUT_GAMEPAD_DPAD_DOWN_PREV	    := 0	 
global	XINPUT_GAMEPAD_DPAD_LEFT_PREV	    := 0	
global	XINPUT_GAMEPAD_DPAD_RIGHT_PREV	    := 0	
global	XINPUT_GAMEPAD_START_PREV	        := 0	
global	XINPUT_GAMEPAD_BACK_PREV	        := 0	
global	XINPUT_GAMEPAD_LEFT_THUMB_PREV	    := 0	
global	XINPUT_GAMEPAD_RIGHT_THUMB_PREV	    := 0		
global	XINPUT_GAMEPAD_LEFT_SHOULDER_PREV   := 0	  	
global	XINPUT_GAMEPAD_RIGHT_SHOULDER_PREV	:= 0		
global	XINPUT_GAMEPAD_A_PREV		        := 0	
global	XINPUT_GAMEPAD_B_PREV               := 0			
global	XINPUT_GAMEPAD_X_PREV		        := 0	 
global	XINPUT_GAMEPAD_Y_PREV	            := 0	
global  XINPUT_GAMEPAD_bLeftTrigger_prev    := 0	
global  XINPUT_GAMEPAD_bRightTrigger_prev   := 0	
global  XINPUT_GAMEPAD_sThumbLX_prev        := 0	 
global  XINPUT_GAMEPAD_sThumbLY_prev        := 0	

XINPUT_GAMEPAD := Struct("DWORD dwPacketNumber;`n" XINPUT_GAMEPAD)

XinputGetState(index = 1)
{
	static XINPUT_STATE=0
	static XINPUT_GETSTATE_ADRESS=0
	index -= 1
	
	if ! XINPUT_GETSTATE_ADRESS
	{
		XINPUT_HANDLE := dllcall("LoadLibrary", "wstr", "Xinput1_3.dll")
		if not XINPUT_HANDLE
			XINPUT_HANDLE := dllcall("GetModuleHandle", "wstr", "Xinput1_3.dll")
		if not XINPUT_HANDLE
			return -1
		XINPUT_GETSTATE_ADRESS := dllcall("GetProcAddress", "Int", XINPUT_HANDLE, "astr", "XInputGetState")
	}
	
	XINPUT_GAMEPAD_bLeftTrigger_prev  := XINPUT_GAMEPAD.bLeftTrigger
	XINPUT_GAMEPAD_bRightTrigger_prev := XINPUT_GAMEPAD.bRightTrigger
	XINPUT_GAMEPAD_sThumbLX_prev      := XINPUT_GAMEPAD.sThumbLX 
    XINPUT_GAMEPAD_sThumbLY_prev      := XINPUT_GAMEPAD.sThumbLY
			
	XINPUT_GAMEPAD_DPAD_UP_PREV	:= XINPUT_GAMEPAD_DPAD_UP
	XINPUT_GAMEPAD_DPAD_DOWN_PREV := XINPUT_GAMEPAD_DPAD_DOWN 
	XINPUT_GAMEPAD_DPAD_LEFT_PREV :=  XINPUT_GAMEPAD_DPAD_LEFT
	XINPUT_GAMEPAD_DPAD_RIGHT_PREV := XINPUT_GAMEPAD_DPAD_RIGHT 
	XINPUT_GAMEPAD_START_PREV :=  XINPUT_GAMEPAD_START
	XINPUT_GAMEPAD_BACK_PREV :=  XINPUT_GAMEPAD_BACK 
	XINPUT_GAMEPAD_LEFT_THUMB_PREV := XINPUT_GAMEPAD_LEFT_THUMB 
	XINPUT_GAMEPAD_RIGHT_THUMB_PREV := XINPUT_GAMEPAD_RIGHT_THUMB	
	XINPUT_GAMEPAD_LEFT_SHOULDER_PREV := XINPUT_GAMEPAD_LEFT_SHOULDER
	XINPUT_GAMEPAD_RIGHT_SHOULDER_PREV := XINPUT_GAMEPAD_RIGHT_SHOULDER	
	XINPUT_GAMEPAD_A_PREV := XINPUT_GAMEPAD_A	
	XINPUT_GAMEPAD_B_PREV := XINPUT_GAMEPAD_B	
	XINPUT_GAMEPAD_X_PREV := XINPUT_GAMEPAD_X	
	XINPUT_GAMEPAD_Y_PREV := XINPUT_GAMEPAD_Y	
		
	r := dllcall(XINPUT_GETSTATE_ADRESS, "int", index, "ptr", XINPUT_GAMEPAD[])	
	
	XINPUT_GAMEPAD_DPAD_UP	:= XINPUT_GAMEPAD.wButtons & 0x0001
	XINPUT_GAMEPAD_DPAD_DOWN := XINPUT_GAMEPAD.wButtons & 	0x0002
	XINPUT_GAMEPAD_DPAD_LEFT := XINPUT_GAMEPAD.wButtons & 	0x0004
	XINPUT_GAMEPAD_DPAD_RIGHT := XINPUT_GAMEPAD.wButtons & 	0x0008
	XINPUT_GAMEPAD_START := XINPUT_GAMEPAD.wButtons & 	0x0010
	XINPUT_GAMEPAD_BACK  := XINPUT_GAMEPAD.wButtons & 0x0020
	XINPUT_GAMEPAD_LEFT_THUMB	:= XINPUT_GAMEPAD.wButtons & 0x0040
	XINPUT_GAMEPAD_RIGHT_THUMB	:= XINPUT_GAMEPAD.wButtons & 	0x0080
	XINPUT_GAMEPAD_LEFT_SHOULDER := XINPUT_GAMEPAD.wButtons & 	0x0100
	XINPUT_GAMEPAD_RIGHT_SHOULDER	:= XINPUT_GAMEPAD.wButtons & 	0x0200
	XINPUT_GAMEPAD_A	:= XINPUT_GAMEPAD.wButtons & 	0x1000
	XINPUT_GAMEPAD_B	:= XINPUT_GAMEPAD.wButtons & 	0x2000
	XINPUT_GAMEPAD_X	:= XINPUT_GAMEPAD.wButtons & 	0x4000
	XINPUT_GAMEPAD_Y	:= XINPUT_GAMEPAD.wButtons & 	0x8000	
	
	return r
}

XinputGetLeftStickAngle()
{
	x := XINPUT_GAMEPAD.sThumbLX/32767
	y := XINPUT_GAMEPAD.sThumbLY/32767
	if ( (x > 0) and (y > 0) )
		return ATan(x/y) * 57.29578
	else if ( (x > 0) and (y < 0) )
		return 180 - (ATan(x/abs(y)) * 57.29578) 
	else if ( (x < 0) and (y < 0) )
		return 180 + (ATan(abs(x)/abs(y)) * 57.29578) 
	else if ( (x < 0) and (y > 0) )
		return 360 - (ATan(abs(x)/y) * 57.29578) 
}

XinputGetEvent(index=1, deadzone=0.25, double_tap=100)
{
	if XinputGetState(index)
		return ""
		
	dead        := deadzone*32767 
	dead_neg    := dead * (-1)
	static freq := 0, prev_event := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	events := []
	states := [
	, [XINPUT_GAMEPAD_DPAD_UP_PREV, XINPUT_GAMEPAD_DPAD_UP]
	, [XINPUT_GAMEPAD_DPAD_DOWN_PREV, XINPUT_GAMEPAD_DPAD_DOWN] 
	, [XINPUT_GAMEPAD_DPAD_LEFT_PREV,  XINPUT_GAMEPAD_DPAD_LEFT]
	, [XINPUT_GAMEPAD_DPAD_RIGHT_PREV, XINPUT_GAMEPAD_DPAD_RIGHT] 
	, [XINPUT_GAMEPAD_A_PREV, XINPUT_GAMEPAD_A]	
	, [XINPUT_GAMEPAD_B_PREV, XINPUT_GAMEPAD_B]	
	, [XINPUT_GAMEPAD_X_PREV, XINPUT_GAMEPAD_X]	
	, [XINPUT_GAMEPAD_Y_PREV, XINPUT_GAMEPAD_Y]
	, [XINPUT_GAMEPAD_LEFT_SHOULDER_PREV, XINPUT_GAMEPAD_LEFT_SHOULDER]
	, [XINPUT_GAMEPAD_RIGHT_SHOULDER_PREV, XINPUT_GAMEPAD_RIGHT_SHOULDER]	
	, [XINPUT_GAMEPAD_bLeftTrigger_prev, XINPUT_GAMEPAD.bLeftTrigger]
	, [XINPUT_GAMEPAD_bRightTrigger_prev, XINPUT_GAMEPAD.bRightTrigger]
	, [XINPUT_GAMEPAD_BACK_PREV, XINPUT_GAMEPAD_BACK]
	, [XINPUT_GAMEPAD_START_PREV, XINPUT_GAMEPAD_START]
	, [XINPUT_GAMEPAD_LEFT_THUMB_PREV, XINPUT_GAMEPAD_LEFT_THUMB] 
	, [XINPUT_GAMEPAD_RIGHT_THUMB_PREV, XINPUT_GAMEPAD_RIGHT_THUMB]
	, [(XINPUT_GAMEPAD_sThumbLY_prev>dead), (XINPUT_GAMEPAD.sThumbLY>dead)] 
	, [(XINPUT_GAMEPAD_sThumbLY_prev<dead_neg), (XINPUT_GAMEPAD.sThumbLY<dead_neg)] 
	, [(XINPUT_GAMEPAD_sThumbLX_prev<dead_neg), (XINPUT_GAMEPAD.sThumbLX<dead_neg)] 
	, [(XINPUT_GAMEPAD_sThumbLX_prev>dead), (XINPUT_GAMEPAD.sThumbLX>dead)] ]
	
	now  := 0
	freq ?:	DllCall("QueryPerformanceFrequency", "Int64*", freq)			
	DllCall("QueryPerformanceCounter", "Int64*", now)
	
	for k, v in states {
		v[1] and not v[2] ? events.insert(-1) : v[2] and not v[1] ? events.insert(1) : events.insert(0)
		;if (events[k] = 1) {
			;(now - prev_event[k] < double_tap) ? events[k] := 2
			;prev_event[k] := now
		;}
	} return events
}	

XinputAltSetMousePos(deadzone=0.2, sensitivity=1.)
{	 	
	dead           := deadzone*32767 	
	dy := (abs(XINPUT_GAMEPAD.sThumbRY) < dead) ? 0 : (XINPUT_GAMEPAD.sThumbRY/32767) * -A_ScreenHeight*0.1*sensitivity
	dx := (abs(XINPUT_GAMEPAD.sThumbRX) < dead) ? 0 : (XINPUT_GAMEPAD.sThumbRX/32767) * A_ScreenWidth*0.1*sensitivity
	MOUSEEVENTF_MOVE := 0x0001
	dllcall("User32.dll\mouse_event", uint, MOUSEEVENTF_MOVE, uint, dx, uint, dy, uint, 0, uint, 0)
}

XinputSetMousePos(deadzone=0.2, sensitivity=1.)
{
	/* Doesn't retrives controller state, so must be called after XinputGetState or 
	 * XinputGetEvent
	 */
    if (J2K.rs_alt) {
	    return XinputAltSetMousePos(deadzone, sensitivity) 
    }
	static MOUSEINPUT 
	MOUSEINPUT ?: MOUSEINPUT := struct("DWORD type; LONG dx; LONG dy; DWORD mouseData; DWORD dwFlags; DWORD time; ULONG_PTR dwExtraInfo;")
	, MOUSEINPUT.dwFlags := 0x0001, MOUSEINPUT.type := 0
	
	;print(A_ScreenHeight " " A_ScreenWidth "`n")
	dead          := deadzone*32767 	
	MOUSEINPUT.dy := (abs(XINPUT_GAMEPAD.sThumbRY) < dead) ? 0 : (XINPUT_GAMEPAD.sThumbRY/32767) * -A_ScreenHeight*0.1*sensitivity
	MOUSEINPUT.dx := (abs(XINPUT_GAMEPAD.sThumbRX) < dead) ? 0 : (XINPUT_GAMEPAD.sThumbRX/32767) * A_ScreenWidth*0.1*sensitivity
	
	dllcall("User32.dll\SendInput", uint, 1, uint, MOUSEINPUT[], uint, MOUSEINPUT.size())	
}

/*
#include <_Struct>

struct(def) {
return new _Struct(def)
}


Loop
{
	XinputGetEvent()
	XinputSetMousePos()
	sleep, 15
	;XinputGetState()
	text := XinputGetLeftStickAngle()
	;if getkeystate("a")
	tooltip, %text%
	if getkeystate("esc")
		ExitApp
}
*/