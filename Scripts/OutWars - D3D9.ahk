;REMOTE SCRIPT START


if (g_.cfg.HD)		
{	
	;dllcall("LoadLibraryA", astr, "Msvfw32.dll", uint)
	/*
	a := dllcall("peixoto.dll\findProcAddressInIat", uint, dllcall("LoadLibraryA", astr, "Msvfw32.dll", uint), astr, "Gdi32.dll", astr, "StretchBlt", uint)
	msgbox % a
	g_.s.Sblt    := numget(a+0, "ptr")	
	p := new Prtct(a, 4)
	msgbox % numput(registercallback("AltStretchBlt", "F"), a+0, "Uint")
	p := ""
	msgbox % a "... " dllcall("peixoto.dll\findProcAddressInIat", uint, dllcall("LoadLibraryA", astr, "Msvfw32.dll", uint), astr, "Gdi32.dll", astr, "StretchBlt")
	dllcall("peixoto.dll\hookIatFunction"
	, uint, dllcall("GetModuleHandleA", astr, "", uint),  astr, "Gdi32.dll", astr, "StretchBlt", uint, registercallback("AltStretchBlt", "F"))
	*/
	;windows own hooks are implemented in Gdi32Full.dll
	logerr("StretchBlt" InstallHook("AltStretchBlt", p, "Gdi32Full.dll", "StretchBlt")) 
	g_.s.Sblt    := p		
	;logerr("GetDC" InstallHook("GetDC", p, "User32.dll", "GetDCEx")) 
	
	
}

GetDC(uint)
{
	return 1
}

AltMovewindow(p1, p2, p3, p4, p5, p6)
{
	;if (p1 = g_.hwin)
		return Movewindow(p1, p2, p3, p4, p5, p6)
	
	p2 *= D3DHOOKS_DATA.scale
	p3 *= D3DHOOKS_DATA.scale
	p4 *= D3DHOOKS_DATA.scale
	p5 *= D3DHOOKS_DATA.scale	
	p2 += D3DHOOKS_DATA.HD_X 	
	return dllcall(g_.WnAPI.Move, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)
}

AltStretchBlt(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)
{	
	logerr("...")
	return r
}

