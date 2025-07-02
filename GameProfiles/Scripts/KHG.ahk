;REMOTE SCRIPT START
Winclose, Curtain 
g_.s.SSAA   := g_.cfg.SSAA
g_.cfg.SSAA := 0
#include %A_ScriptDir%\src\d3d_ddi.hooks.txt
#include %A_ScriptDir%\src\d3d.hooks.txt
g_.cfg.SSAA  := g_.s.SSAA

AltMoveWindow(p1, p2, p3, p4, p5, p6)
{
	KHGSetGammaRamp(128, 1.6)
	Winclose, Curtain 
	SetupGl(p4, p5, "AltMoveWindow")
	return MoveWindow(p1, p2, p3, p4, p5, p6)	
}

KHGSetGammaRamp(brightness, ramp=1.0)
{
	(brightness > 256) ? brightness := 256
	(brightness < 0) ? brightness := 0
	VarSetCapacity(gr, 512*3)
	x := 1/ramp
	Loop, 256
	{
		(nValue:=(brightness+128)*(A_Index-1))>65535 ? nValue:=65535
		nValue := (nValue**x/65535**x)*65535
		NumPut(nValue, gr,      2*(A_Index-1), "Ushort")
		NumPut(nValue, gr,  512+2*(A_Index-1), "Ushort")
		NumPut(nValue, gr, 1024+2*(A_Index-1), "Ushort")
	}
	hDC := DllCall("GetDC", "Uint", A_scripthwnd)
	DllCall("SetDeviceGammaRamp", "Uint", hDC, "Uint", &gr)
	DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
}

Alt_Blt(p1, p2, p3, p4, p5, p6)
{
	winhide, Curtain
	SSAA        := g_.cfg.SSAA
	g_.cfg.SSAA := 0
	;setformat, integer, hex
	logerr(p5)
	if (p5&DDBLT_KEYSRC) 	
	{
		(D      := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
		dllcall(IDirectDrawSurface.lock, ptr, p3, uint, 0, uint, D[], uint, 0, uint, 0, uint)	
	    ckey := numget(D.lpSurface+0, "short")	 		
		dllcall(IDirectDrawSurface.Unlock, ptr, p3, ptr, 0)	
		dllcall(IDirectDrawSurface.SetColorKey, ptr, p3, uint, DDCKEY_SRCBLT, "uint64*", ckey)			
	}		
	r := Surface1Blt(p1, p2, p3, p4, p5, p6)
	g_.cfg.SSAA := SSAA
	return r
}

