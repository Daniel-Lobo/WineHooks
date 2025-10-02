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
		WinSet, Transparent, , ahk_id %h%
		dllcall("CloseHandle", uint, h)
	}	
	return StretchBltHook(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)	
}

/* Linux:
 * Even on vanilla wine, the overlya FMV windows is not sized of positioned correctly,
 * wo we use some heuristics to fix it.
 */
AltStretchDIBits(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
{	
	;logerr("...")		
	if (p4 = 320)
	{
		p4 *= 2
		p5 *= 2 
	} else {
		p2 += 45
		p3 += 55
		if (h := dllcall("WindowFromDC", uint, p1, uint))
		{
			dllcall("SetWindowPos", uint, h, uint, 0, int, p2, int, p3, int, 0, int, 0, uint, 0x0001) ; SWP_NOSIZE
			dllcall("CloseHandle", uint, h)
		}		
	}
	p2 *= D3DHOOKS_DATA.scale
	p2 += D3DHOOKS_DATA.HD_X 	
	p3 *= D3DHOOKS_DATA.scale
	p4 *= D3DHOOKS_DATA.scale
	p5 *= D3DHOOKS_DATA.scale
	dc := dllcall("GetDC", uint, 0)
	dllcall(g_.WnAPI.StretchDIBits, uint, DC, uint, p2, uint, p3, uint, p4, uint, p5
	, uint, p6, uint, p7, uint, p8, uint, p9, uint, p10, uint, p11, uint, p12, uint, p13)	
	dllcall("ReleaseDC", uint, 0, uint, DC)	
	return p4
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
