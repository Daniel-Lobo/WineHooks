;REMOTE SCRIPT START

D3DHOOKS_DATA.UnLockPrimary := RegisterCallback("Alt_Unlock", "F")

/*
AltCreateFileA(p1, p2, p3, p4, p5, p6, p7)
{
	file := strget(p1, "CP0")
	bink := StrReplace(file, ".jam", ".bik")
	if instr(file, ".jam") and fileexist(bink)
	{
		dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlccore.dll")
		dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlc.dll")
		logerr("Vlc " dllcall("peixoto.dll\VlcDDrawPlay", ptr, 0, ptr, g_.proxies.fmvr[], astr, bink, astr) errorlevel)
		return -1							
	}	
	r := dllcall(g_fhks.pCreateFileA, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)		
	return r
}

AltIDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{
	
	D    := struct(DDSURFACEDESC)
	D[]  := pSurfaceDesc
	caps := D.ddsCaps.dwCaps
	if (r := IDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown))
		return r
	
	if (caps & DDSCAPS_PRIMARYSURFACE)
	{
		g_.proxies.prim  := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary), "RG6B",,1)				
	}
	return r
}	
*/	

Alt_SetEntries(p1, p2, p3, p4, p5)
{
	if not g_.cfg.NoScan
		return IDirectDrawPalette_SetEntries(p1, p2, p3, p4, p5)
	dllcall("RtlMoveMemory", ptr, g_.palette+(p3)*4, ptr, p5, int, (p4)*4)	
	Pal2RGB(g_.proxies.prim.surface)		
	return 0
}


Alt_Unlock(p1, p2)
{
	g_.proxies.fmv := 0
	(g_.cfg.xBRh) ? keyevent(g_.cfg.xBRh) ?	g_.cfg.xBR := (g_.cfg.xBR) ? 0 : 1		
	if ! (GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE)
		return Surface1Unlock(p1, p2)		
	if (g_.proxies.32bit)
	{
		(g_.cfg.NoScan) ? g_.proxies.fmv := 2
		_rect_setscale( g_.cfg.FMV )
		r := Surface1Unlock(p1, p2)	
		_rect_setscale()
		return r
	}
	else if (!g_.proxies.32bit)
	{
		return Surface1Unlock(p1, p2)	
		r := dllcall(IDirectDrawSurface.Unlock, uint, g_.proxies.prim.surface, uint, p2)
		Pal2RGB(g_.proxies.prim.surface)	
		dllcall(IDirectDrawSurface.blt, uint, g_.proxies.dev.surface, uint, 0
		                              , uint, g_.proxies.prim.surface, uint, 0
									  , uint, 0, uint, 0, uint)
		DEVICE3_RECT.Texture := g_.proxies.dev.Texture
		DEVICE3_RECT.Device3 := g_.proxies.D3D.Device3
		(g_.cfg.xbr)?D3DDDI_SetShaderOverride(g_.proxies.xbr)
		dllcall(G_D3DDDI.SetPixelShaderConst, uint, D3DDDI_HOOKS.hDev, "uint64*", 223 | 1<<32, uint, g_.proxies.prms[])
		(g_.proxies.D3D.Device3) ? dllcall(g_.p.Dev3_DrawRect, uint, DEVICE3_RECT[], uint, rect[], uint, 0, uint)
		D3DDDI_RestoreShader()
		dllcall(IDirectDrawSurface.blt, uint, g_.primary, uint,  _rect[]
		                              , uint, g_.proxies.D3D.surface, uint, rect[]
									  , uint, 0, uint, 0, uint)	
		RETURN	r
	}
	return Surface1Unlock(p1, p2)		
}