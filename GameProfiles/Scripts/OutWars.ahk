;REMOTE SCRIPT START
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

AltStretchBltHook(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)
{	
	;logerr("...")
	if (h := dllcall("WindowFromDC", uint, p1, uint))
	{
		VarSetCapacity(r, 4)		
		dllcall("GetWindowRect", uint, h, uint, &r)		
		p2 += numget(&r+0, "uint")
		p3 += numget(&r+4, "uint")		
		dllcall("CloseHandle", uint, h)
	}
	return StretchBltHook(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)	
}

UnhookExtTextOutA(){
	hgdi                    := dllcall("GetModuleHandleA", "astr", g_.cfg.winedd ? "gdi32.dll" : "Gdi32Full.dll")
	pTExtTextOutA           := dllcall("GetProcAddress", ptr, hgdi, "astr", "ExtTextOutA")
	pTExtTextOutATrampoline := g_.WnAPI.ExtTextOutA
	if !g_.cfg.winedd 
	return
	logerr("hdgi: " hgdi " pTExtTextOutA " pTExtTextOutA " pTExtTextOutATrampoline " pTExtTextOutATrampoline) 	
	UnHook(pTExtTextOutA, pTExtTextOutATrampoline) 
}

UnhookExtTextOutA()
