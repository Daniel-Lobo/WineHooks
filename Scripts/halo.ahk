;REMOTE SCRIPT START
;if (fileexist("chimera.ini"))
	;IniWrite, 0, chimera.ini, video_mode, enabled

;EnvSet, USERPROFILE, C:\users\%A_UserName% 
D3D9_HOOKS.DrawUp    := IDirect3DDevice9.DrawPrimitiveUp
Alt_CreateDevice(p1, p2, p3, p4, p5, p6, p7)
{
	r := IDirect3D9_CreateDevice(p1, p2, p3, p4, p5, p6, p7)
	if (r)
		return r
	if (fileexist("chimera.ini"))
	HaloSetGammaRamp(128, 1)
}

HaloSetGammaRamp(brightness, ramp=1.0)
{
	(brightness > 256) ? brightness := 256
	(brightness < 0)   ? brightness := 0
	VarSetCapacity(gr, 512*3)
	x := 1/ramp
	
	Loop, 256
	{
		nValue := (brightness+128) * (A_Index-1)
		nValue > 65535 ? nValue:=65535
		nValue := (nValue**x/65535**x)*65535
		NumPut(nValue, gr,      2*(A_Index-1), "Ushort")
		NumPut(nValue, gr,  512+2*(A_Index-1), "Ushort")
		NumPut(nValue, gr, 1024+2*(A_Index-1), "Ushort")
	}
	
	dllcall(IDirect3DDevice9.SetGammaRamp, ptr, g_.pDevice9, uint, 0, uint, 0, ptr, &gr)
}