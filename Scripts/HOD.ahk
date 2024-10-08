;REMOTE SCRIPT START
logerr(IDirectDrawSurface.Hook("flip"))
;logerr(IDirectDrawSurface.Hook("GetAttachedSurface"))
;g_.cfg.upscale ?: g_.desktop := {"w": 640, "h": 480}
logerr(IDirectDraw2.Hook("CreateSurface"))

AltIDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{
	D    := struct(DDSURFACEDESC)
	D[]  := pSurfaceDesc
	caps := D.ddsCaps.dwCaps
	if (r := IDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown))
		return r
	if (caps & DDSCAPS_PRIMARYSURFACE)
	{
		if (g_.cfg.frame)
		{
			g_.proxies.prms[1] := 1/256
			g_.proxies.prms[2] := 1/192
			g_.proxies.small := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary), "X8RGB",192|256<<16)
		}
		else 
		{
			g_.proxies.prms[1] := 1/320
			g_.proxies.prms[2] := 1/240
			g_.proxies.small := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary), "X8RGB",240|320<<16)	
		}			
	}
	return r
}

Alt_SetEntries(p1, p2, p3, p4, p5)
{
	rect.top := 48,	rect.bottom := 432,	rect.left := 64, rect.right := 576
	dllcall("RtlMoveMemory", ptr, g_.palette+(p3)*4, ptr, p5, int, (p4)*4)	
	Pal2RGB(g_.proxies.prim.surface)	
	;return dllcall(IDirectDrawSurface.blt, uint, g_.primary, uint, _RECT[]
		                                       ;, uint, g_.proxies.32bit.surface, uint, rect[]
									           ;, uint, DDBLTFAST_NOCOLORKEY | DDBLT_WAIT, uint, 0, uint)	
	return 0
}

Alt_flip(p1, p2, p3)
{	
	(g_.cfg.xBRh) ? keyevent(g_.cfg.xBRh) ?	g_.cfg.xBR := (g_.cfg.xBR) ? 0 : 1		
	Pal2RGB(g_.proxies.prim.surface)
	dllcall(IDirectDrawSurface.blt, uint, g_.proxies.small.surface, uint, 0
	                              , uint, g_.proxies.32bit.surface, uint, (g_.cfg.frame) ? rect[] : 0
								  , uint, 0, uint, 0, uint)	
	if (!g_.cfg.xbr) 
	{
		dllcall(IDirectDrawSurface.blt, uint, g_.primary, uint,  _rect[]
	                              , uint, g_.proxies.32bit.surface, uint, (g_.cfg.frame) ? rect[] : 0
								  , uint, 0, uint, 0, uint)	
	} else {
		DEVICE3_RECT.Texture  := g_.proxies.small.Texture
		DEVICE3_RECT.Device3  := g_.proxies.D3D.Device3
		D3DDDI_SetShaderOverride(g_.proxies.xbr)
		dllcall(G_D3DDDI.SetPixelShaderConst, uint, D3DDDI_HOOKS.hDev, "uint64*", 223 | 1<<32, uint, g_.proxies.prms[])
		dllcall(g_.p.Dev3_DrawRect, uint, DEVICE3_RECT[], uint, _rect[], uint, 0, uint)
		D3DDDI_RestoreShader()
		dllcall(IDirectDrawSurface.blt, uint, g_.primary, uint,  _rect[]
									  , uint, g_.proxies.D3D.surface, uint, _rect[]
									  , uint, 0, uint, 0, uint)	
	}
	
	;dllcall(IDirectDrawSurface.blt, uint, g_.primary, uint, _RECT[], uint, g_.proxies.32bit.surface, uint, (g_.cfg.frame) ? _rect[] : 0
								  ;, uint, 0, uint, 0, uint)	
	return flip()		
}

