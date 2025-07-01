;REMOTE SCRIPT START
/*
D3DHOOKS_DATA.LockSurface    := IDirectDrawSurface4.lock
D3DHOOKS_DATA.UnLockSurface4 := IDirectDrawSurface4.Unlock
D3DHOOKS_DATA.LockPrimary    := RegisterCallback("Alt_lock")
D3DHOOKS_DATA.UnLockPrimary  := RegisterCallback("Alt_Unlock")
D3DHOOKS_DATA.Bltprimary     := IDirectDrawSurface4.blt
*/

;InitSRHooks()
InitSRHooks()
{
	; Fixes the achivments text on wrace's patch 
	InstallHook("AltGetClientRect", p, "peixoto.dll", "D3D12GetClientRectHook")
	g_.s.getclient   := p
	InstallHook("_BinkClose", p, "BinkW32.dll", "_BinkClose@4")
	g_.s._BinkClose  := p
	InstallHook("_BinkOpen", p, "BinkW32.dll", "_BinkOpen@8")
	g_.s._BinkOpen  := p
}

_BinkClose(p1)
{
	g_.s._BinkOpened := 0
	return dllcall(g_.s._BinkClose, uint, p1)
}

_BinkOpen(p1, p2)
{
	g_.s._BinkOpened := 1
	return dllcall(g_.s._BinkOpen, uint, p1, uint, p2)
}

AltGetClientRect(p1, p2)
{
	;logerr("AltGetClientRect")
	if (!g_.s._BinkOpened and p1 = g_.hwin)
	{
		r := struct("UINT x, y, w, h")
		r[] := p2
		r.w := D3DHOOKS_DATA.w
		r.h := D3DHOOKS_DATA.h
		return 1
	}
	return dllcall(g_.s.getclient, uint, p1, uint, p2)
}

/*
AltIDirectDrawSurface_QueryInterface(p1, p2, p3)
{
	r := IDirectDrawSurface4_QueryInterface(p1, p2, p3)		
	return r
}


AltIDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{
	D    := struct(DDSURFACEDESC)
	D[]  := pSurfaceDesc
	caps := D.ddsCaps.dwCaps
	if (r := IDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown))
		return r
	if (caps & DDSCAPS_PRIMARYSURFACE)
	{
		g_.proxies.D3D        := new D3DDevice(dllcall(g_.p.DDFrmSrfc, uint, g_.primary), (640<<16)|480)
		g_.proxies.prim       := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary), "", (g_.desktop.w<<16)|g_.desktop.h)
		g_.proxies.dev        := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary), "", (640<<16)|480)				
		g_.rect               := struct(rect), g_.rect.top := 0, g_.rect.left := 0, g_.rect.right := 640, g_.Rect.bottom := 480
		
	}
	return r
}

Alt_lock(p1, p2, p3, p4, p5)
{
	if (GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE)
	{
		;logerr("Lock primary " isobject(g_.proxies.prim))
		p1 := g_.proxies.prim.Surface
		return dllcall(IDirectDrawSurface4.lock, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint)
	}
	return surface1lock(p1, p2, p3, p4, p5)
}	

Alt_Unlock(p1, p2)
{
	if (GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE) 
	{
		prim := p1
		p1   := g_.proxies.prim.Surface
		r    := dllcall(IDirectDrawSurface.Unlock, uint, p1, uint, p2)
		;return r
		if (p1 = g_.proxies.prim.surface)
		{
			_rect_setscale(g_.cfg.FMV)	
			x8 := new Surface(dllcall(g_.p.DDFrmSrfc, uint, p1), "X8RGB",, sys=False, m=False)
			dllcall(IDirectDrawSurface4.blt, uint, x8.Surface, uint, g_.rect[]
										   , uint, g_.proxies.prim.surface, uint, g_.rect[]
										   , uint, DDBLT_WAIT, uint, 0, uint)	
			
			;dllcall("peixoto.dll\DDCPUDeinterlace", ptr, x8.surface, str)									 
			dllcall(IDirectDrawSurface4.blt, uint, prim, uint,  g_.cfg.SCLR ? g_.rect[] : _rect[]
										   , uint, x8.surface, uint,g_.proxies.fmvr[]
										   , uint, DDBLT_WAIT, uint, 0, uint)	
			_rect_setscale(0)								 
		}
		return r
	}
	return surface4unlock(p1, p2)
}
*/

/*
AltDDrawCreate(p1, p2, p3)
{
	(g_.pIDirectDraw) ? g_.pIDirectDraw := dllcall(IDirectDraw.Release, uint, g_.pIDirectDraw) * 0
	if (r := dllcall(g_.pDirectDrawCreate, uint, p1, uint, p2, uint, p3))
		return r
	g_.pIDirectDraw := numget(p2+0, "ptr")
	dllcall(IDirectDraw.addref, uint, g_.pIDirectDraw)	
	return r
}
*/
