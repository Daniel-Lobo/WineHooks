;REMOTE SCRIPT START

logerr(IDirectDrawSurface.Hook("GetAttachedSurface"))
logerr(IDirectDrawSurface.Hook("flip"))
D3DHOOKS_DATA.BltFastPrimary         := RegisterCallback("IDirectDrawSurface_BltFast", "F")	

logerr("CloseHandle Hook  : " InstallHook("CloseHandle", pCloseHandle, "Kernel32.dll", "CloseHandle") " <- 0 means no error")	
g_.pCloseHandle   := pCloseHandle
g_.FMV            := 0
g_.cfg.cursor_fix := 0

Alt_GetAttachedSurface(p1, p2, p3)
{
	r :=  dllcall(IDirectDrawSurface.GetAttachedSurface, uint, p1, uint, p2, uint, p3)
	if ( (numget(p2+0, "uint") & DDSCAPS_BACKBUFFER) or (numget(p2+0, "uint") & DDSCAPS_FLIP) )
	{
		g_.mousex := D3DHOOKS_DATA.w/D3DHOOKS_DATA.HD_W
		g_.mousey := D3DHOOKS_DATA.h/D3DHOOKS_DATA.HD_H
		g_.captionrect := struct(rect), g_.captionrect.top := 420, g_.captionrect.left := 0
		g_.captionrect.right := 640, g_.captionrect.bottom := 480
		return (g_.cfg.NEFS) ? IDirectDrawSurface_GetAttachedSurface(p1, p2, p3) : dllcall(IDirectDrawSurface.GetAttachedSurface, uint, p1, uint, p2, uint, p3)
	}
	return r
}

IDirectDrawSurface_BltFast(p1, p2, p3, p4, p5, p6)
{
	dllcall(g_.p.Critical, uint, 1)
	static caps:=0, srccaps:=0
	dllcall(IDirectDrawSurface.GetCaps, uint, p1, "uint*", caps)
	dllcall(IDirectDrawSurface.GetCaps, uint, p4, "uint*", srccaps)
	g_.proxies.rct.left   := p2
	g_.proxies.rct.top    := p3
	g_.proxies.rct.right  := p2 + numget(p5+8) - numget(p5+0, "uint")
	g_.proxies.rct.bottom := p3 + numget(p5+12)- numget(p5+4, "uint")
	f := (p6 & DDBLTFAST_SRCCOLORKEY) ? DDBLT_KEYSRC : 0
		
	if (srccaps & DDSCAPS_PRIMARYSURFACE)
	p4 := g_.proxies.prim.surface
	else if (srccaps & DDSCAPS_FLIP)
	p4 := g_.proxies.dev.surface
	
	if (caps & DDSCAPS_PRIMARYSURFACE)
	{
		r := dllcall(IDirectDrawSurface.Blt, uint, g_.proxies.prim.surface, uint, g_.proxies.rct[], uint, p4, uint, p5, uint, f, uint, 0)
		SaniUpdate(p1, g_.proxies.rct[])							  
		dllcall(g_.p.Critical, uint, 0)							  
		return r	
			
	} else if (caps & DDSCAPS_FLIP)
		p1 := g_.proxies.dev.surface		
	dllcall(g_.p.Critical, uint, 0)
	return dllcall(IDirectDrawSurface.Blt, uint, p1, uint, g_.proxies.rct[], uint, p4, uint, p5, uint, f, uint, 0)		
}

Alt_flip(p1, p2, p3)
{	
	flip()	
	if (g_.FMV)
	{
		Pal2RGB(g_.proxies.prim.surface)
		(g_.cfg.FMV) ? _rect_setscale(1)		
		g_.proxies.D3D.draw(g_.proxies.fmvr[], g_.proxies.32bit.Texture, 0, g_.proxies.fmvs)	
		dllcall(IDirectDrawSurface.blt, uint, g_.proxies.D3D.surface, uint, g_.captionrect[] 
									  , uint, g_.proxies.32bit.surface, uint, g_.captionrect[] 
									  , uint, 0, uint, DDBLTFX[], uint)	
		dllcall(IDirectDrawSurface.blt, uint, p1, uint,  _rect[]
		                              , uint, g_.proxies.D3D.surface, uint, g_.proxies.fmvr[]
									  , uint, 0, uint, 0, uint)
		_rect_setscale(0)
		return 0		
	}	
	DDWait(p1, p2&DDFLIP_WAIT)
	SaniUpdate(p1, 0, "Flip")
	return				
}

SaniUpdate(p1, p2, f=False)
{
	return Surface1UpDatePrim(p1, p2)
}

AltCreateFileA(p1, p2, p3, p4, p5, p6, p7)
{
	file := strget(p1, "CP0")
	splitpath, file, , , ext	
	r := dllcall(g_fhks.pCreateFileA, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)	
	if (ext = "smk")
		g_.FMV := r		
	return r
}

CloseHandle(hwnd)
{
	if (hwnd = g_.FMV) 
		g_.FMV := 0
	return dllcall(g_.pCloseHandle, uint, hwnd)
}