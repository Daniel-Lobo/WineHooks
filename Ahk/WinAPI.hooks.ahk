
g_.WnAPI := {}
InitWWnAPIHooks()
InitWWnAPIHooks()
{
	if (g_.cfg.HD) 
	{
		if (g_.cfg.WHKS)
		{
			InstallHook(isfunc("AltMovewindow") ? "AltMovewindow" : "Movewindow", p, "User32.dll", "MoveWindow")	
			g_.WnAPI.Move   := p
			InstallHook(isfunc("AltSetWindowPos") ? "AltSetWindowPos" : "SetWindowPos", p, "User32.dll", "SetWindowPos")	
			g_.WnAPI.SetPos := p
		}	
		
		if (g_.cfg.MCLP)	
		{
			InstallHook("ClipCursor", p, "User32.dll", "ClipCursor")
			g_.WnAPI.ClpCrsr := p
		} else g_.WnAPI.ClpCrsr := dllcall("GetProcAddress", uint, dllcall("GetModuleHandleA", astr, "User32.dll", uint), astr, "ClipCursor")	
			
		if (g_.cfg.GDI)	
		{
			hook := isfunc(h:="AltStretchBltHook") ? h : "StretchBltHook"
			logerr("StretchBlthook " InstallHook(hook, p, "Gdi32Full.dll", "StretchBlt")) 
			g_.WnAPI.Sblt         := p
			
			hook := isfunc(h:="AltBitBltHook") ? h : "BitBltHook"
			logerr("BitBlthook " InstallHook(hook, p, "Gdi32Full.dll", "BitBlt")) 
			g_.WnAPI.Bitblt       := p
			
			hook := isfunc(h:="PatBlt") ? h : "PatBltHook"
			logerr("PatBlthook " InstallHook(hook, p, "Gdi32Full.dll", "PatBlt")) 
			g_.WnAPI.PatBlt       := p
			
			hook := isfunc(h:="TextOutA") ? h : "TextOutAHook"
			logerr("TextOutAhook " InstallHook(hook, p, "Gdi32Full.dll", "TextOutA")) 
			g_.WnAPI.TextOutA    := p
			
			hook := isfunc(h:="ExtTextOutA") ? h : "ExtTextOutAHook"
			logerr("ExtTextOutAhook " InstallHook(hook, p, "Gdi32Full.dll", "ExtTextOutA")) 
			g_.WnAPI.ExtTextOutA := p
		}
	}
}

ExtTextOutAHook(p1, p2, p3, p4, p5, p7, p8)
{
	if (dllcall("WindowFromDC", ptr, p1) = 0)
	return dllcall(g_.WnAPI.ExtTextOutA, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7, uint, p8)
	dllcall(IDirectDrawSurface.GetDC, uint, g_.proxies.prim.Surface, "uint*", DC)
	r := dllcall(g_.WnAPI.ExtTextOutA, uint, DC, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7, uint, p8)	
	dllcall(IDirectDrawSurface.ReleaseDC, uint, g_.proxies.prim.Surface, uint, DC)
	Surface1UpDatePrim(g_.primary, 0)
	return r
}

TextOutAHook(p1, p2, p3, p4, p5)
{
	if (dllcall("WindowFromDC", ptr, p1) = 0)
	return dllcall(g_.WnAPI.TextOutA, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
	dllcall(IDirectDrawSurface.GetDC, uint, g_.proxies.prim.Surface, "uint*", DC)
	r := dllcall(g_.WnAPI.TextOutA, uint, DC, uint, p2, uint, p3, uint, p4, uint, p5)	
	dllcall(IDirectDrawSurface.ReleaseDC, uint, g_.proxies.prim.Surface, uint, DC)
	Surface1UpDatePrim(g_.primary, 0)
	return r
}

PatBltHook(p1, p2, p3, p4, p5, p6)
{
	if (dllcall("WindowFromDC", ptr, p1) = 0)
	return dllcall(g_.WnAPI.PatBlt, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)
	dllcall(IDirectDrawSurface.GetDC, uint, g_.proxies.prim.Surface, "uint*", DC)
	r := dllcall(g_.WnAPI.PatBlt, uint, DC, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)	
	dllcall(IDirectDrawSurface.ReleaseDC, uint, g_.proxies.prim.Surface, uint, DC)
	Surface1UpDatePrim(g_.primary, 0)
	return r
}

BitBltHook(p1, p2, p3, p4, p5, p6, p7, p8, p9)
{
	if (dllcall("WindowFromDC", ptr, p1) = 0)
	return dllcall(g_.WnAPI.Bitblt, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7, uint, p8, uint, p9)
	return StretchBltHook(p1, p2, p3, p4, p5, p6, p7, p8, p4, p5, p9)
}

StretchBltHook(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)
{	
	dllcall(IDirectDrawSurface.GetDC, uint, g_.proxies.prim.Surface, "uint*", DC:=0)		
	r := dllcall(g_.WnAPI.Sblt, uint, DC, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7, uint, p8, uint, p9, uint, p10, uint, p11)	
	dllcall(IDirectDrawSurface.ReleaseDC, uint, g_.proxies.prim.Surface, uint, DC)
	Surface1UpDatePrim(g_.primary, 0)	
	return r
}

ClipCursor(p1)
{
	if (g_.cfg.MCLP=2)
	{
		VarSetCapacity(r, 8, 0)
		numput(D3DHOOKS_DATA.HD_X, &r+08, "uint")
		numput(D3DHOOKS_DATA.HD_W-D3DHOOKS_DATA.HD_X, &r+08, "uint")
		numput(D3DHOOKS_DATA.HD_H, &r+12, "uint")
		return dllcall(g_.WnAPI.ClpCrsr, uint, &r)
	}
	VarSetCapacity(r, 8, 0)
	numput(D3DHOOKS_DATA.W, &r+08, "uint")
	numput(D3DHOOKS_DATA.H, &r+12, "uint")
	return dllcall(g_.WnAPI.ClpCrsr, uint, &r)
}

Movewindow(p1, p2, p3, p4, p5, p6)
{
	if (p1 = g_.hwin)
	{
		d  := Desk()
		p4 := d.w
		p5 := d.h
	}
	return dllcall(g_.WnAPI.Move, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)
}

SetWindowPos(p1, p2, p3, p4, p5, p6, p7)
{
	if (p1 = g_.hwin)
	{
		d  := Desk()
		p5 := d.w
		p6 := d.h
	}	
	return dllcall(g_.WnAPI.SetPos, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)
}