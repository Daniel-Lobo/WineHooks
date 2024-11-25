#include lib\DirectX\Headers\_dinput.h.ahk

global IDirectInputA :=0, IDirectInputW :=0, IDirectInputDeviceA :=0, IDirectInputDeviceW :=0, IDirectInputDevice2W:=0,IDirectInputDevice2A:=0
global IDirectInput8W:=0, IDirectInput8A:=0, IDirectInputDevice8W:=0, IDirectInputDevice8A:=0
global IDirectInput7W:=0, IDirectInput7A:=0, IDirectInputDevice7A:=0, IDirectInputDevice7W:=0
global g_XinputDevicesDinputGUIDS := []

GetDirectInput7(w = false)
{		
	p := dllcall("GetProcAddress", ptr, dllcall("LoadLibrary", str, "dinput.dll", ptr), astr, "DirectInputCreateEx")
	if (!p)
		return "GetProcAddress or LoadLibrary failed"	
		
	GUID_FromString(iid, w ? dinput.IID_IDirectInput7W : dinput.IID_IDirectInput7W)	
	r := dllcall(p, uint, A_ModuleHandle, uint, 0x0700, ptr, &iid, "uint*", pDI:=0, uint, 0, uint)
	if (r)
		return "DirectInputCreateEx Failed"
					
	if not (w)
	{	
		IDirectInput7A := new ComInterfaceWrapper(dinput.IDirectInput7A, pDI, True)		
		GUID_FromString(GUID, dinput.GUID_SysKeyboard)
		r := dllcall(IDirectInput7A.CreateDevice, uint, IDirectInput7A.p, uint, &GUID, "uint*", pDvc:=0, uint, 0, uint)
		if (r != 0)
			return "Failed to create the IDirectInputDevice7A interface " r " - " dinput.err[r . ""] ErrorLevel " " pDI 
		IDirectInputDevice7A := new ComInterfaceWrapper(dinput.IDirectInputDevice7A, pDvc, True)		
	}
	else
	{
		IDirectInput7W  := new ComInterfaceWrapper(dinput.IDirectInput7W, pDI, True)	
		GUID_FromString(GUID, dinput.GUID_SysKeyboard)
		r := dllcall(IDirectInput7W.CreateDevice, uint, IDirectInput7W.p, uint, &GUID, "uint*", pDvc:=0, uint, 0, uint)
		if (r != 0)
			return "Failed to create the IDirectInputDevice7W interface " r " - " dinput.err[r . ""]		
		IDirectInputDevice7W := new ComInterfaceWrapper(dinput.IDirectInputDevice7W, pDvc, True)			
	}
	return "Succeeded to create the DirectInput7 Interfaces"	
}	

DirectInputCreate(w = False)
{	
	p := dllcall("GetProcAddress", ptr, dllcall("LoadLibrary", str, "dinput.dll", ptr), astr, w ? "DirectInputCreateW" : "DirectInputCreateA")
	if (!p)
		return "GetProcAddress or LoadLibrary failed"	
	
	r := dllcall(p, uint, A_ModuleHandle, uint, 0x0500, "uint*", pDI:=0, uint, 0, uint)
	if (r)
		return "DirectInputCreate Failed"
		
	if (w)
		IDirectInputW  := new ComInterfaceWrapper(dinput.IDirectInputW, pDI, True)	
	else IDirectInputA := new ComInterfaceWrapper(dinput.IDirectInputA, pDI, True)		
}	

GetDirectInput(w = false)
{		
	r := DirectInputCreate(w)
	if (r)
		return "Failed to create the IDirectInput interface " r " - " dinput.err[r . ""]
	
	if (!w)
	{
		g_XinputDevicesDinputGUIDS := []
		print("Enumerating Controlers:`n")		
		r := dllcall(IDirectInputA.EnumDevices, uint, IDirectInputA.p, uint, DIDEVTYPE_JOYSTICK
				                              , uint, RegisterCallback("DIEnumDevicesCallback")
				                              , uint, 0, uint, DIEDFL_ATTACHEDONLY, uint)		
						
		GUID_FromString(iid, dinput.GUID_SysKeyboard)
		r := dllcall(IDirectInputA.CreateDevice, uint, IDirectInputA.p, uint, &iid, "uint*", pDvc:=0, uint, 0, uint)
		if (r != 0)
			return "Failed to create the IDirectInputDevice interface " r " - " dinput.err[r . ""]		
		IDirectInputDeviceA := new ComInterfaceWrapper(dinput.IDirectInputDeviceA, pDvc, True)
		
		GUID_FromString(iid, dinput.IID_IDirectInputDevice2A)
		r := dllcall(IDirectInputDeviceA.QueryInterface, uint, IDirectInputDeviceA.p, uint, &iid, "uint*", pDvc:=0)
		if (r != 0)
			return "Failed to create the IDirectInputDevice2 interface " r " - " dinput.err[r . ""]	
		IDirectInputDevice2A := new ComInterfaceWrapper(dinput.IDirectInputDevice2A, pDvc, True)		
	}
	else
	{
		GUID_FromString(iid, dinput.GUID_SysKeyboard)
		r := dllcall(IDirectInputW.CreateDevice, uint, IDirectInputW.p, uint, &iid, "uint*", pDvc:=0, uint, 0, uint)
		if (r != 0)
			return "Failed to create the IDirectInputDevice interface " r " - " dinput.err[r . ""]		
		IDirectInputDeviceW := new ComInterfaceWrapper(dinput.IDirectInputDeviceW, pDvc, True)
		
		GUID_FromString(iid, dinput.IID_IDirectInputDevice2W)
		r := dllcall(IDirectInputDeviceW.QueryInterface, uint, IDirectInputDeviceW.p, uint, &iid, "uint*", pDvc:=0)
		if (r != 0)
			return "Failed to create the IDirectInputDevice2 interface " r " - " dinput.err[r . ""]	
		IDirectInputDevice2W := new ComInterfaceWrapper(dinput.IDirectInputDevice2W, pDvc, True)				
	}
	return "Succeeded to create the DirectInput Interfaces"	
}	

DIEnumDevicesCallback(lpddi, pvRef)
{
	hpx      := dllcall("GetModuleHandle", str, "peixoto.dll", uint)
	IsXinput := dllcall("GetProcAddress", uint, hpx, astr, "IsXInputDevice", uint)
		
	DIDEVICEINSTANCE_DX3A[] := lpddi
	add_ := DIDEVICEINSTANCE_DX3A[] + DIDEVICEINSTANCE_DX3A.offset("tszInstanceName")
	
	if (pvRef = 0)
		name  := strget(add_+0, "CP0")
	else name := strget(add_+0, "UTF-16")

	guidProduct := DIDEVICEINSTANCE_DX3A[] + DIDEVICEINSTANCE_DX3A.offset("guidProduct")	
	guidInstace := DIDEVICEINSTANCE_DX3A[] + DIDEVICEINSTANCE_DX3A.offset("guidInstance")	
		
	xinput      := dllcall(IsXinput, uint, guidProduct, int) ? "Yes" : "No" 
	guid_string := StringFromIID(guidInstace)
	if (xinput)
		g_XinputDevicesDinputGUIDS.insert([name, guid_string])
	
	printl("Controler: " name " " guid_string " Xinput: " xinput)
	printl(guid_string)
	return True
}

GetDirectInput8(w=True)
{
	dllcall("LoadLibraryW", str, "dinput8.dll")
	GUID_FromString(dinputGUID, w ? dinput.IID_IDirectInput8W : dinput.IID_IDirectInput8A)	
	r := dllcall("dinput8.dll\DirectInput8Create", uint, A_ModuleHandle, uint, 0x0800, uint, &dinputGUID, "uint*", pDI:=0, uint, 0, uint)
	if (r)
		return "Failed to create the IDirectInput8 interface" r " " dinput.err[r . ""] 

	if (w) 
	{
		IDirectInput8W := new ComInterfaceWrapper(dinput.IDirectInput8W,  pDI, True)	
		GUID_FromString(GUID, dinput.GUID_SysKeyboard)
		r := dllcall(IDirectInput8W.CreateDevice, uint, IDirectInput8W.p, uint, &GUID, "uint*", pDvc:=0, uint, 0, uint)
		if (r)
			return "Failed to create the IDirectInputDevice8 interface" r " " dinput.err[r . ""]
		IDirectInputDevice8W :=  new ComInterfaceWrapper(dinput.IDirectInputDevice8W, pDvc, True)	
		return "Succeeded to create the DirectInput8 Interfaces"	
	} else {
		IDirectInput8A := new ComInterfaceWrapper(dinput.IDirectInput8A,  pDI, True)			
		GUID_FromString(GUID, dinput.GUID_SysKeyboard)
		r := dllcall(IDirectInput8A.CreateDevice, uint, IDirectInput8A.p, uint, &GUID, "uint*", pDvc:=0, uint, 0, uint)
		if (r)
			return "Failed to create the IDirectInputDevice8 interface" r " " dinput.err[r . ""] 
		IDirectInputDevice8A :=  new ComInterfaceWrapper(dinput.IDirectInputDevice8A, pDvc, True)	
		return "Succeeded to create the DirectInput8 Interfaces"	
	}
}