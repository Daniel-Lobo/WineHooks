;REMOTE SCRIPT START
logerr(IDirectDrawSurface.unHook("GetPalette"))
;logerr(IDirectDrawSurface.unHook("SetPalette"))			
;logerr(IDirectDrawPalette.unHook("SetEntries"))
logerr(IDirectDrawPalette.unHook("GetEntries"))

D3DHOOKS_DATA.BltfastPrimary := RegisterCallback("AltBltFast", "f")
D3DHOOKS_DATA.LockPrimary    := RegisterCallback("AltLock", "f")
D3DHOOKS_DATA.UnLockPrimary  := RegisterCallback("AltUnLock", "f")
logerr(IDirectDraw.Hook("WaitforVerticalBlank"))

_AltIDirectDraw_SetDisplayMode(p1, p2, p3, p4)
{
	logerr("set")
	IDirectDraw_SetDisplayMode(p1, p2, p3, p4)
	return  dllcall(IDirectDraw.SetDisplayMode, uint, p1, uint, D3DHOOKS_DATA.HD_W, uint, D3DHOOKS_DATA.HD_H, uint, 32)
}

AltIDirectDraw_WaitforVerticalBlank(p1, p2, p3)
{
	g_.s.skip := true
	return 0
}

AltIDirectDrawPalette_SetEntries(p1, p2, p3, p4, p5)
{
	cps:=0
	dllcall("RtlMoveMemory", ptr, g_.palette+(p3)*4, ptr, p5, int, (p4)*4)
	dllcall(IDirectDrawPalette.GetCaps, uint, p1, "uint*", cps)
	if ! (cps & DDPCAPS_ALLOW256)
	{
		numput(0, g_.palette+0, "uint")
		numput(0xffffffff, g_.palette+1020, "uint")
	}
	;Surface1UpDatePrim(0)
	;return dllcall(IDirectDrawPalette.SetEntries, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)	
}

AltIDirectDrawSurface_SetPalette(p1, p2)
{
	if ( (caps := GetSurfaceCaps(p1)) & DDSCAPS_PRIMARYSURFACE  )
    {
		p1 := g_.proxies.prim
		g_.proxies.pltt := p2				
	} return dllcall(IDirectDrawSurface.SetPalette, uint p1, uint, p2)
	return 0
}

AltIDirectDraw_CreateSurface(p1, p2, p3, p4)
{
	D    := struct(DDSURFACEDESC)
	D[]  := p2
	caps := D.ddsCaps.dwCaps 
	r := IDirectDraw_CreateSurface(p1, p2, p3, p4)
	if caps & DDSCAPS_PRIMARYSURFACE
	{
		g_.proxies.32bit  := "" 
		g_.proxies.s32bit := ""
		g_.proxies.prim   := "" 
		g_.proxies.dev    := "" 
		;g_.proxies.D3D    := ""	
		
		g_.s.prim    := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary),"PAL8",,1)
		g_.s.dev     := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary),"PAL8",,1)
		g_.s.32bit   := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary),"X8RGB")	
		g_.s.s32bit  := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary),"X8RGB",,1)		
		;g_.s.D3D     := new D3DDevice()
		;g_.s.dv      := new DvcFrmSrfc(g_.s.32bit.surface)
	}  
	return r
}

AltLock(p1, p2, p3, p4, p5)
{
	if (GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE)
		return dllcall(IDirectDrawSurface.lock, uint, g_.s.32bit.surface, uint, p2, uint, p3, uint, p4, uint, P5, uint)
	if (GetSurfaceCaps(p1) & DDSCAPS_FLIP)
	{
		;g_.proxies.prim := new Surface("PAL8",,1)
		return dllcall(IDirectDrawSurface.lock, uint, g_.s.dev.surface, uint, p2, uint, p3, uint, p4, uint, P5, uint)
	}
	return dllcall(IDirectDrawSurface.lock, uint, p1, uint, p2, uint, p3, uint, p4, uint, P5, uint)
}

AltUnlock(p1, p2)
{
	if (GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE)
	{
		dllcall(IDirectDrawSurface.Unlock, uint, g_.s.32bit.surface, uint, p2)
		return dllcall(IDirectDrawSurface.blt, uint, p1, uint, _RECT[], uint, g_.s.32bit.surface, uint, 0, uint, 0, uint, 0)	
	}
	if (GetSurfaceCaps(p1) & DDSCAPS_FLIP) 
	{
		r := dllcall(IDirectDrawSurface.Unlock, uint, g_.s.dev.surface, uint, p2)
		;AltUpDatePrim(0, p1)		
		return r
	}
	return dllcall(IDirectDrawSurface.Unlock, uint, p1, uint, p2)
}

Alt_flip(p1, p2, p3)
{
	D         := g_.s.dev
	g_.s.dev  := g_.s.prim
	g_.s.prim := D
	;dllcall(IDirectDrawSurface.flip, uint, g_.s.prim.surface, uint, 0, uint, 0)
    DDWait(p1, p2&DDFLIP_WAIT)
	if ! g_.s.skip
		AltUpDatePrim(0, g_.primary)
	g_.s.skip := 0
	return 0
	;return dllcall(IDirectDrawSurf
}

AltBltFast(p1, p2, p3, p4, p5, p6)
{
	dllcall(IDirectDrawSurface.BltFast, uint, g_.s.dev.surface, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)
	;AltUpDatePrim(0, g_.primary)
	;return dllcall(IDirectDrawSurface.BltFast, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)
}

AltUpDatePrim(pRECT, dest)
{
	(g_.cfg.xBRh) ? keyevent(g_.cfg.xBRh) ?	g_.cfg.xBR := (g_.cfg.xBR) ? 0 : 1
	dllcall(g_.p.Scale, uint, pRECT, uint, g_HD._Sclr[])
	AltPal2RGB(g_.s.prim.surface, (g_.cfg.xBR) ? g_HD._Sclr.src : pRECT)
	
	if (g_.cfg.xBR)
	{
		DEVICE3_RECT.Texture := g_.s.32bit.Texture
		DEVICE3_RECT.Device3 := g_.proxies.D3D.Device3
		D3DDDI_SetShaderOverride(g_.proxies.xbr)
		dllcall(G_D3DDDI.SetPixelShaderConst, uint, D3DDDI_HOOKS.hDev, "uint64*", 223 | 1<<32, uint, g_.proxies.prms[])
		dllcall(g_.p.Dev3_DrawRect, uint, DEVICE3_RECT[], uint, g_HD._Sclr.dst, uint, g_HD._Sclr.src, uint)	
		D3DDDI_RestoreShader()
		return dllcall(IDirectDrawSurface.blt, uint, dest, uint, g_HD._Sclr.dst, uint, g_.proxies.D3D.surface
		, uint, g_HD._Sclr.dst, uint, 0, uint, 0, uint)
	}
	return dllcall(IDirectDrawSurface.blt, uint, dest, uint, _RECT[], uint, g_.s.32bit.surface, uint, 0
	, uint, DDBLT_WAIT, uint, 0, uint)
}

AltPal2RGB(src, rect_=0)
{
	f := g_.cfg.injector_dir "\error.log"
	(D := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
	(D2:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
	l1 := dllcall(IDirectDrawSurface.lock, uint, src, uint, rect_, uint, D[], uint, 0, uint, 0, uint)
	l2 := dllcall(IDirectDrawSurface.lock, uint, g_.s.s32bit.surface, uint, rect_, uint, D2[], uint, DDLOCK_WRITEONLY, uint, 0, uint)	
	dllcall(g_.p.Pal2RGB, uint, D.lpSurface, uint, D.lPitch, uint, g_.palette, uint, D2.lpSurface, uint, D2.lPitch, uint, D.dwWidth, uint, D.dwHeight, uint, rect_)		
	dllcall(IDirectDrawSurface.Unlock, uint, src, uint, 0)
	dllcall(IDirectDrawSurface.Unlock, uint, g_.s.s32bit.surface, uint, 0)
	dllcall(IDirectDrawSurface.blt, uint, g_.s.32bit.surface, uint, rect_, uint, g_.s.s32bit.surface, uint, rect_, uint, 0, uint, 0) 	
}


