; NOTE: Every interface reimplements every method, because the COM_FOWARD macro in used in all methodsin the Dinrectinput.h file 
global DINPT_HOOKS :=
(
"
int           DZone;
int         NgDZone;
DWORD          Flag;
DWORD      Buts[12];
DWORD      Trigs[2];
LPVOID        GtStt;
LPVOID       GtStt8;
LPVOID       GtSttW;
LPVOID      GtStt8W;
LPVOID        StPrp;
LPVOID       StPrp8;
LPVOID       StPrpW;
LPVOID      StPrp8W;
LPVOID        CrtFx;
LPVOID       CrtFx8;
LPVOID       CrtFxW;
LPVOID      CrtFx8W;
LPVOID        GtCps;
LPVOID       GtCps8;
LPVOID       GtCpsW;
LPVOID      GtCps8W;
LPVOID    EnumObjcs;
LPVOID   EnumObjcs8;
LPVOID   EnumObjcsW;
LPVOID  EnumObjcs8W;
LPVOID   SetDataFmt;
LPVOID  SetDataFmt8;
LPVOID  SetDataFmtW;
LPVOID SetDataFmt8W;
LPVOID      GetData;
LPVOID     GetData8;
LPVOID     GetDataW;
LPVOID    GetData8W;
"
)
DINPT_HOOKS := struct(DINPT_HOOKS)

global g_dnpt := {}
g_dnpt.controls := ["A","B","X","Y"
, "LEFT_THUMB", "RIGHT_THUMB", "LEFT_SHOULDER", "RIGHT_SHOULDER"
, "start", "back", "bRightTrigger", "bLeftTrigger"]

g_dnpt.pDIGetRange := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "DIGetRange")
g_dnpt.loger       := new Loger(g_.cfg.injector_dir "\Input.log")	  

InitDInputEmu(byref cfg, _unicode = true)
{	
	if (r:=XinPutGetState(1))
	{
		logerr("NO xinput gamepad " r)
		return
	}
	cfg       := parsecfg(cfg)
    cfg.layer := True
	dllcall("peixoto.dll\InitDInputHooks", ptr, DINPT_HOOKS[])	
	if (cfg.layer)
		dllcall("peixoto.dll\InitDInputLayer")	
    ;g_dnpt.loger.log(GetDirectInput(0))  ; 1st one fails in most games since version 1.10.9
	g_dnpt.loger.log(GetDirectInput(0))
	g_dnpt.loger.log(GetDirectInput(1))
	g_dnpt.loger.log(GetDirectInput7(0))
	g_dnpt.loger.log(GetDirectInput7(1))
	g_dnpt.loger.log(GetDirectInput8(0))
	g_dnpt.loger.log(GetDirectInput8(1))
	g_dnpt.loger.log(IDirectInputA.compare([IDirectInputW, IDirectInput7A, IDirectInput7W]))
	g_dnpt.loger.log(IDirectInputDeviceA.compare([IDirectInputDeviceW, IDirectInputDevice7A, IDirectInputDevice7W]))
	g_dnpt.loger.log(IDirectInput8A.compare([IDirectInput8W]))
	g_dnpt.loger.log(IDirectInputDevice8A.compare([IDirectInputDevice8W]))
	
	g_dnpt.loger.log(IDirectInputDevice8A.dllhook("GetDeviceState", "DinputDevice8GetState"))	
	g_dnpt.loger.log(IDirectInputDeviceA.dllhook("GetDeviceState", "DinputDeviceGetState"))
	g_dnpt.loger.log(IDirectInputDevice8A.dllhook("SetProperty", "DinputDevice8SetProperty"))	
	g_dnpt.loger.log(IDirectInputDeviceA.dllhook("SetProperty", "DinputDeviceSetProperty"))	
	g_dnpt.loger.log(IDirectInputDevice8A.dllhook("GetCapabilities", "Di8GetDvcCaps"))			
	g_dnpt.loger.log(IDirectInputDeviceA.dllhook("GetCapabilities", "DiGetDvcCaps"))
	g_dnpt.loger.log(IDirectInputDevice8A.dllhook("EnumObjects", "DiEnumObjects8Hook"))			
	g_dnpt.loger.log(IDirectInputDeviceA.dllhook("EnumObjects", "DiEnumObjectsHook"))
	g_dnpt.loger.log(IDirectInputDevice8A.dllhook("SetDataFormat", "DiDcvSetDataFormat"))			
	g_dnpt.loger.log(IDirectInputDeviceA.dllhook("SetDataFormat", "DiDcvSetDataFormat"))
	g_dnpt.loger.log(IDirectInputDevice8A.dllhook("GetDeviceData", "DinputDeviceGetData"))			
	g_dnpt.loger.log(IDirectInputDeviceA.dllhook("GetDeviceData", "DinputDeviceGetData"))
	DINPT_HOOKS.GtCps        := IDirectInputDeviceA.GetCapabilities	
	DINPT_HOOKS.GtCps8       := IDirectInputDevice8A.GetCapabilities	
	DINPT_HOOKS.GtStt        := IDirectInputDeviceA.GetDeviceState
	DINPT_HOOKS.GtStt8       := IDirectInputDevice8A.GetDeviceState
	DINPT_HOOKS.StPrp        := IDirectInputDeviceA.SetProperty
	DINPT_HOOKS.StPrp8       := IDirectInputDevice8A.SetProperty
	DINPT_HOOKS.EnumObjcs    := IDirectInputDeviceA.EnumObjects
	DINPT_HOOKS.EnumObjcs8   := IDirectInputDevice8A.EnumObjects
	DINPT_HOOKS.SetDataFmt   := IDirectInputDeviceA.SetDataFormat
	DINPT_HOOKS.SetDataFmt8  := IDirectInputDevice8A.SetDataFormat
	DINPT_HOOKS.GetData      := IDirectInputDeviceA.GetDeviceData
	DINPT_HOOKS.GetData8     := IDirectInputDevice8A.GetDeviceData

	if (cfg.layer)
	{
		g_dnpt.loger.log(IDirectInputDevice8W.dllhook("GetDeviceState", "DinputDevice8GetStateW"))	
		g_dnpt.loger.log(IDirectInputDeviceW.dllhook("GetDeviceState", "DinputDeviceGetStateW"))
		g_dnpt.loger.log(IDirectInputDevice8W.dllhook("SetProperty", "DinputDevice8SetPropertyW"))	
		g_dnpt.loger.log(IDirectInputDeviceW.dllhook("SetProperty", "DinputDeviceSetPropertyW"))	
		g_dnpt.loger.log(IDirectInputDevice8W.dllhook("GetCapabilities", "Di8GetDvcCapsW"))			
		g_dnpt.loger.log(IDirectInputDeviceW.dllhook("GetCapabilities", "DiGetDvcCapsW"))
		g_dnpt.loger.log(IDirectInputDevice8W.dllhook("EnumObjects", "DiEnumObjects8WHook"))			
	    g_dnpt.loger.log(IDirectInputDeviceW.dllhook("EnumObjects", "DiEnumObjectsWHook"))
		g_dnpt.loger.log(IDirectInputDevice8W.dllhook("SetDataFormat", "DiDcvSetDataFormat"))			
	    g_dnpt.loger.log(IDirectInputDeviceW.dllhook("SetDataFormat", "DiDcvSetDataFormat"))
		g_dnpt.loger.log(IDirectInputDevice8W.dllhook("GetDeviceData", "DinputDeviceGetData"))			
	    g_dnpt.loger.log(IDirectInputDeviceW.dllhook("GetDeviceData", "DinputDeviceGetData"))
		DINPT_HOOKS.GtCpsW       := IDirectInputDeviceW.GetCapabilities	
		DINPT_HOOKS.GtCps8W      := IDirectInputDevice8W.GetCapabilities	
		DINPT_HOOKS.GtSttW       := IDirectInputDeviceW.GetDeviceState
		DINPT_HOOKS.GtStt8W      := IDirectInputDevice8W.GetDeviceState
		DINPT_HOOKS.StPrpW       := IDirectInputDeviceW.SetProperty
		DINPT_HOOKS.StPrp8W      := IDirectInputDevice8W.SetProperty
		DINPT_HOOKS.EnumObjcsW   := IDirectInputDeviceW.EnumObjects
	    DINPT_HOOKS.EnumObjcs8W  := IDirectInputDevice8W.EnumObjects
		DINPT_HOOKS.SetDataFmtW  := IDirectInputDeviceW.SetDataFormat
	    DINPT_HOOKS.SetDataFmt8W := IDirectInputDevice8W.SetDataFormat
		DINPT_HOOKS.GetDataW     := IDirectInputDeviceW.GetDeviceData
	    DINPT_HOOKS.GetData8W    := IDirectInputDevice8W.GetDeviceData
	}	
					 
	mds              := strsplit(cfg.mds, ",")
	ls_mode          := mds[17]
	dp_mode          := mds[1] & 0xF
	DINPT_HOOKS.flag := ls_mode | (dp_mode << 4) 
	if cfg.rs
	DINPT_HOOKS.flag |= (cfg.rs << 8)
	g_dnpt.loger.log("flags " DINPT_HOOKS.flag)
	
	buts             := strsplit(cfg.a, ",")
	for k, v in strsplit(cfg.mds, ",")
	{
		if (k<5)
		continue
		else if (k>16)
		break
		if (v=3)
		{
			DINPT_HOOKS.buts[k-4]     := strsplit(buts[k], "Gamepad ")[2]
		} else DINPT_HOOKS.buts[k-4]  := 0
		g_dnpt.loger.log("Button " k " " DINPT_HOOKS.buts[k-4])	
	}
	
	(cfg.dz = 0) ?: cfg.dz := 0.25
	;cfg.dz := 0.25
	g_dnpt.dead    := cfg.dz * 32768 
	g_dnpt.dead_m  := g_dnpt.dead*(-1)
	
	DINPT_HOOKS.DZone   := g_dnpt.dead
	DINPT_HOOKS.NgDZone := g_dnpt.dead_m
			
	if (cfg.ff)
	{		
		g_dnpt.loger.log(IDirectInput8W.Hook("EnumDevices", "IDirectInput8W_EnumDevices") )	
		g_dnpt.loger.log(IDirectInput8A.Hook("EnumDevices", "IDirectInput8A_EnumDevices") )	
		g_dnpt.loger.log(IDirectInputA.Hook("EnumDevices", "IDirectInputA_EnumDevices") )	
		g_dnpt.loger.log(IDirectInputW.Hook("EnumDevices", "IDirectInputW_EnumDevices") )			
				
		g_dnpt.loger.log(IDirectInputDevice2A.Hook("EnumEffects", "DInputEnumeffectsA"))	
		g_dnpt.loger.log(IDirectInputDevice2W.Hook("EnumEffects", "DInputEnumeffectsW"))	
		g_dnpt.loger.log(IDirectInputDevice8A.Hook("EnumEffects", "DInputEnumeffectsA"))	
		g_dnpt.loger.log(IDirectInputDevice8W.Hook("EnumEffects", "DInputEnumeffectsW"))	
		g_dnpt.loger.log(IDirectInputDevice2A.dllHook("CreateEffect", "DinputCreateEffectHook"))	
		g_dnpt.loger.log(IDirectInputDevice8A.dllHook("CreateEffect", "DinputCreateEffectHook"))	
		g_dnpt.loger.log(IDirectInputDevice2A.dllHook("GetEffectInfo", "DiGetEffectInfoA"))	
		g_dnpt.loger.log(IDirectInputDevice8A.dllHook("GetEffectInfo", "DiGetEffectInfoA"))	
		if (cfg.layer)
		{
			g_dnpt.loger.log(IDirectInputDevice2W.dllHook("CreateEffect", "DinputCreateEffectHook"))	
		    g_dnpt.loger.log(IDirectInputDevice8W.dllHook("CreateEffect", "DinputCreateEffectHook"))	
			g_dnpt.loger.log(IDirectInputDevice2W.dllHook("GetEffectInfo", "DiGetEffectInfoW"))	
		    g_dnpt.loger.log(IDirectInputDevice8W.dllHook("GetEffectInfo", "DiGetEffectInfoW"))				
		}
		DINPT_HOOKS.CrtFx := IDirectInputDevice8A.CreateEffect
	}
	VarSetCapacity(zero, 32, 0)
	g_dnpt.pz := &zero	
	return
}

DInputEnumeffectsA(p1, p2, p3, p4)
{
	g_dnpt.loger.log("DInputEnumeffectsA")
	return dllcall("peixoto.dll\DIEnumEffectsA", ptr, p2, ptr, p3, uint, p4)
}

DInputEnumeffectsW(p1, p2, p3, p4)
{
	g_dnpt.loger.log("DInputEnumeffectsW")
	return dllcall("peixoto.dll\DIEnumEffectsW", ptr, p2, ptr, p3, uint, p4)
}

IDirectInputDeviceA_SetProperty(p1, p2, p3)
{
	r := dllcall(IDirectInputDeviceA.SetProperty, uint, p1, uint, p2, uint, p3)
	logerr("IDirectInputDeviceA::SetProperty " r " " p2)
	return 0
}

IDirectInputDeviceA_GetProperty(p1, p2, p3)
{	
	r := dllcall(IDirectInputDeviceA.GetProperty, uint, p1, uint, p2, uint, p3)
	logerr("IDirectInputDeviceA::GetProperty " r " " p2)
	return r
}

IDirectInputDeviceA_SetDataFormat(p1, p2)
{
	r := dllcall(IDirectInputDeviceA.SetDataFormat, uint, p1, uint, p2)
	logerr("IDirectInputDeviceA::SetDataFormat " r)
	return r
}

IDirectInputDeviceA_SetCooperativeLevel(p1, p2, p3)
{
	r := dllcall(IDirectInputDeviceA.SetCooperativeLevel, uint, p1, uint, p2, uint, p3)
	logerr("IDirectInputDeviceA::SetCooperativeLevel " r)
	return r
}

IDirectInputDeviceA_GetDeviceData(p1, p2, p3, p4, p5)
{
	r := dllcall(IDirectInputDeviceA.GetDeviceData, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
	if (r)
	{
		logerr("IDirectInputDeviceA::GetDeviceData failed")
		dllcall(IDirectInputDeviceA.Acquire, ptr, p1)
	}
	return 0
}

DiPatchCreateEffect(pDvc, caller)
{
	dvc1          := new ComInterfaceWrapper(dinput.IDirectInputDeviceA, pDvc, True)
	dvc1.released := True
	GUID_FromString(GUID, dinput.IID_IDirectInputDevice2A)
	q := dllcall(dvc1.QueryInterface, uint, dvc1.p, uint, &GUID, "uint*", d)
	if (q = 0)
	{
		Dvc := new ComInterfaceWrapper(dinput.IDirectInputDevice2A, d, True)	
		logerr("IDirectInputDeviceA_Acquire: " Dvc.PatchVTableWithdll("CreateEffect", "DinputCreateEffectHook") )
	}  	
}

IDirectInputDeviceA_Acquire(p1)
{
	r := dllcall(IDirectInputDeviceA.Acquire, uint, p1)
	if (r = 0)
	{
		;DiPatchCreateEffect(p1, "IDirectInputDeviceA::Acquire")	
	} 
	return r
}

IDirectInputA_CreateDevice(p1, p2, p3, p4)
{
	r := dllcall(IDirectInputA.CreateDevice, uint, p1, uint, p2, uint, p3, uint, p4)
	if (r = 0)
	{
		DiPatchCreateEffect(numget(p3+0, ptr), "IDirectInputA::CreateDevice")		
	} return 0
}

IDirectInputDeviceA_GetCapabilities(p1, p2)
{
	logerr(IDirectInputW.patchVtable("EnumDevices", "IDirectInputW_EnumDevices") )	
	if ! (r := dllcall(IDirectInputDeviceA.GetCapabilities, uint, p1, uint, p2))
	{		
		DIDEVCAPS[] := p2
		if (DIDEVCAPS.dwDevType & DIDEVTYPE_JOYSTICK)
		{
			if (DIDEVCAPS.dwSize = 44)
			{
				DIDEVCAPS.dwAxes    := 4 
				DIDEVCAPS.dwButtons := 12
				if (DINPT_HOOKS.CrtFx) 
				DIDEVCAPS.dwFlags |= DIDC_FORCEFEEDBACK  ;breaks shadows of the empire
			}
			else if (DIDEVCAPS.dwSize = 24)
			{
				DIDEVCAPS_DX3[]         := p2
				DIDEVCAPS_DX3.dwAxes    := 4 
				DIDEVCAPS_DX3.dwButtons := 12
				if (DINPT_HOOKS.CrtFx) 
				DIDEVCAPS_DX3.dwFlags |= DIDC_FORCEFEEDBACK 
			}	
		}			
	}
	return r	
}

IDirectInput8A_EnumDevices(p1, p2, p3, p4, p5)
{
	g_dnpt.loger.log("IDirectInput8A_EnumDevices " p5&DIEDFL_FORCEFEEDBACK )
	p5 &= ~ DIEDFL_FORCEFEEDBACK 
	return dllcall(IDirectInput8A.EnumDevices, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
}

IDirectInput8W_EnumDevices(p1, p2, p3, p4, p5)
{
	g_dnpt.loger.log("IDirectInput8W_EnumDevices " p5&DIEDFL_FORCEFEEDBACK )
	p5 &= ~ DIEDFL_FORCEFEEDBACK 
	return dllcall(IDirectInput8W.EnumDevices, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
}

IDirectInputA_EnumDevices(p1, p2, p3, p4, p5)
{
	g_dnpt.loger.log("IDirectInputA_EnumDevices " p5&DIEDFL_FORCEFEEDBACK )		
	p5 &= ~ DIEDFL_FORCEFEEDBACK 
	return dllcall(IDirectInputA.EnumDevices, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
}

IDirectInputW_EnumDevices(p1, p2, p3, p4, p5)
{
	g_dnpt.loger.log("IDirectInputW_EnumDevices " p5&DIEDFL_FORCEFEEDBACK )		
	p5 &= ~ DIEDFL_FORCEFEEDBACK 
	return dllcall(IDirectInputW.EnumDevices, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
}