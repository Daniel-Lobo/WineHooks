SetupPrxs7(dd7, prim="")		
{
	if ! prim
	{
		if !(g_.cfg.NEFS)
		{
			logerr(IDirectDrawSurface7.Hook("flip"))
			logerr(IDirectDrawSurface7.Hook("EnumAttachedSurfaces"))			
		}
		
		; Fallout: changed to patchvtable: CreateDevice fails in 8bit colr mode using .hook, may break other games
		; logerr(IDirectDrawSurface7.PatchVtable("GetPixelFormat")) ; Breaks Messiah FMVs
		logerr(IDirectDrawSurface7.Hook("GetPixelFormat"))	
		; Fallout: Crashes zanzarah in 16 bit color mode, may break other games
		logerr(IDirectDrawSurface7.PatchVtable("GetSurfaceDesc"))				
		logerr(IDirectDraw7.Hook("GetDisplayMode"))
		logerr(IDirectDrawSurface7.Hook("AddAttachedSurface"))
		D3DHOOKS_DATA.GetDDSCaps := IDirectDrawSurface7.GetCaps		
				
		logerr(IDirectDraw.Hook("CreatePalette"))
		logerr(IDirectDrawSurface.Hook("GetPalette"))
		logerr(IDirectDrawSurface.Hook("SetPalette"))			
		logerr(IDirectDrawPalette.Hook("SetEntries"))
		logerr(IDirectDrawPalette.Hook("GetEntries"))		
						
		logerr(IDirectDrawSurface.dllHook("GetDC","SurfaceGetDCHook"))
		logerr(IDirectDrawSurface.dllHook("ReleaseDC","SurfaceReleaseDCHook"))
		D3DHOOKS_DATA.GetDCPrim := RegisterCallback("Surface1GetDC", "F")
		D3DHOOKS_DATA.RelDCPrim := RegisterCallback("Surface1ReleaseDC", "F")
		D3DHOOKS_DATA.GetDCSrfc := IDirectDrawSurface.GetDC		
		D3DHOOKS_DATA.RelDCSrfc := IDirectDrawSurface.ReleaseDC
		
		logerr(IDirectDrawSurface7.dllHook("Lock", "LockSurfaceHook"))
		logerr(IDirectDrawSurface7.dllHook("UnLock", "UnLockSurface4Hook"))
		D3DHOOKS_DATA.LockSurface    := IDirectDrawSurface7.Lock
		D3DHOOKS_DATA.UnLockSurface4 := IDirectDrawSurface7.UnLock
		D3DHOOKS_DATA.LockPrimary    := RegisterCallback("Surface7lock", "F")
		D3DHOOKS_DATA.UnLockPrimary4 := RegisterCallback("Surface7Unlock", "F")
		IDirectDrawSurface.lock      := IDirectDrawSurface7.lock
		IDirectDrawSurface4.Unlock   := IDirectDrawSurface7.Unlock

        if (g_.cfg.layer) {
            logerr(IDirectDrawSurface.dllHook("UnLock", "UnLockSurfaceHook"))
            D3DHOOKS_DATA.UnLockPrimary := RegisterCallback("Surface7Unlock", "F")
            D3DHOOKS_DATA.UnLockSurface := IDirectDrawSurface.UnLock
        }
			
		logerr(IDirectDrawSurface7.dllHook("Blt", "SurfaceBltHook"))
		D3DHOOKS_DATA.BltPrimary := RegisterCallback("Surface1Blt", "F")
		D3DHOOKS_DATA.BltSurface := IDirectDrawSurface7.blt	
		IDirectDrawSurface.blt	 := IDirectDrawSurface7.blt	
		IDirectDrawSurface4.blt	 := IDirectDrawSurface7.blt	
		
        if (!g_.cfg.TextSwap)
        {
            logerr(IDirectDrawSurface.dllHook("QueryInterface", "SrfcQueryHook"))
            D3DHOOKS_DATA.QueryPrimary         := IDirectDrawSurface.QueryInterface            
            D3DHOOKS_DATA.QueryDevice          := RegisterCallback("Dvc1Query", "F")
            IDirectDrawSurface4.QueryInterface := IDirectDrawSurface.QueryInterface	
        }
		D3DHOOKS_DATA.QuerySurface := IDirectDrawSurface.QueryInterface
		if (g_.cfg.dly)
		logerr(IDirect3DDevice7.Hook("BeginScene"))
	}	
	else
	{
		;isobject(g_.proxies.D3D) ? g_.proxies.D3D.check() : SetUpD3D(dd7)
		for k, v in strsplit("prim dev 32bit s32bit vid cmp cpy D3D D3DZ primcpy", " ")
		g_.proxies[v] := ""	
		SetUpD3D(dd7)		
		if (g_.cfg.32bit and D3DHOOKS_DATA.D = 8)
		{
			g_.proxies.prim    := new Surface7(dd7, "PAL8",,1)
			g_.proxies.dev     := new Surface7(dd7, "PAL8",,1)
			g_.proxies.32bit   := new Surface7(dd7,"X8RGB")	
			g_.proxies.s32bit  := new Surface7(dd7,"X8RGB",,1)			
		} else 
		{
			g_.proxies.prim := new Surface7(dd7)
			g_.proxies.dev  := new Surface7(dd7,,,g_.cfg.sys)
		}		
		if (g_.cfg.sys)
			g_.proxies.vid := new Surface7(dd7)
		if (g_.cfg.cpy)
		{
			g_.proxies.cpy := new Surface7(dd7)
			g_.proxies.cmp := new Surface7(dd7)
		}
		SetupCkey()

        if (! g_.cfg.layer) {
            (prim := new ComInterfaceWrapper(ddraw.IDirectDrawSurface7, g_.primary7, True)).released := True
            logerr(prim.PatchVtableWithDll("lock", "LockSurfaceHook"))
            logerr(prim.PatchVtableWithDll("Unlock", "UnLockSurface4Hook"))
            logerr(prim.PatchVtableWithDll("GetDC", "SurfaceGetDCHook"))
            logerr(prim.PatchVtableWithDll("ReleaseDC", "SurfaceReleaseDCHook"))	
        }
	}
}

SetupPrxs4(DD="")
{
	;return
	if not DD
	{
		logerr("SetupPrxs4(...)")
		if !(g_.cfg.NEFS || g_.cfg.SSAA)
		{
			logerr(IDirectDrawSurface.Hook("flip"))
			logerr(IDirectDrawSurface4.PatchVtable("EnumAttachedSurfaces"))				
			logerr(IDirectDrawSurface.PatchVtable("EnumAttachedSurfaces"))
		}
		logerr(IDirectDrawSurface4.Hook("GetSurfaceDesc"))		
		D3DHOOKS_DATA.GetDDSCaps  := IDirectDrawSurface.GetCaps
		
		logerr(IDirectDraw.Hook("CreatePalette"))
		logerr(IDirectDraw.Hook("GetDisplayMode"))	
		logerr(IDirectDraw4.Hook("GetDisplayMode"))	
		logerr(IDirectDrawSurface.Hook("GetPixelFormat"))	
		logerr(IDirectDrawSurface.Hook("GetSurfaceDesc"))
		logerr(IDirectDrawSurface.Hook("AddAttachedSurface"))
		
		if g_.cfg.32bit 
		{
			;Dangerous, torment, heart of darkness, sanitarium and others stop working, but why??
			logerr(IDirectDrawSurface.Hook("GetPalette"))
			logerr(IDirectDrawSurface.Hook("SetPalette"))			
			logerr(IDirectDrawPalette.Hook("SetEntries"))
			logerr(IDirectDrawPalette.Hook("GetEntries"))
		}
				
		logerr(IDirectDrawSurface.dllHook("QueryInterface", "SrfcQueryHook"))
		D3DHOOKS_DATA.QueryPrimary := IDirectDrawSurface.QueryInterface
		;D3DHOOKS_DATA.QueryPrimary := Registercallback("QueryPrimary", "F")
		D3DHOOKS_DATA.QuerySurface := IDirectDrawSurface.QueryInterface
		D3DHOOKS_DATA.QueryTexture := IDirectDrawSurface.QueryInterface
		D3DHOOKS_DATA.QueryDevice  := RegisterCallback("Dvc1Query", "F")
		IDirectDrawSurface4.QueryInterface := IDirectDrawSurface.QueryInterface
		D3DHOOKS_DATA.IDirectDrawSurface_QueryInterface  := IDirectDrawSurface.QueryInterface
		
		logerr(IDirectDrawSurface4.dllHook("Lock", "LockSurfaceHook"))
		logerr(IDirectDrawSurface4.dllHook("UnLock", "UnLockSurface4Hook"))
		D3DHOOKS_DATA.LockPrimary     := RegisterCallback("Surface1lock", "F")
		D3DHOOKS_DATA.UnLockPrimary4  := RegisterCallback("Surface4Unlock", "F")
		D3DHOOKS_DATA.LockSurface     := IDirectDrawSurface4.Lock
		D3DHOOKS_DATA.UnLockSurface4  := IDirectDrawSurface4.UnLock
		IDirectDrawSurface.Lock       := IDirectDrawSurface4.Lock
		
		logerr(IDirectDrawSurface.dllHook("UnLock", "UnLockSurfaceHook"))
		D3DHOOKS_DATA.UnLockPrimary := RegisterCallback("Surface1Unlock", "F")
		D3DHOOKS_DATA.UnLockSurface := IDirectDrawSurface.UnLock
		
		logerr(IDirectDrawSurface4.dllHook("Blt", "SurfaceBltHook"))
		D3DHOOKS_DATA.BltPrimary             := RegisterCallback(isfunc("Alt_Blt") ? "Alt_Blt" : "Surface1Blt", "F")
		D3DHOOKS_DATA.BltSurface             := IDirectDrawSurface4.blt
		IDirectDrawSurface.blt               := IDirectDrawSurface4.blt
		
		logerr(IDirectDrawSurface4.dllHook("Bltfast", "SurfaceBltFastHook"))
		D3DHOOKS_DATA.BltFastPrimary         := RegisterCallback("Surface1bltfast", "F")
		D3DHOOKS_DATA.BltFastSurface         := IDirectDrawSurface4.bltFast	
		IDirectDrawSurface.bltFast           := IDirectDrawSurface4.bltFast		
		
		logerr(IDirectDrawSurface4.dllHook("GetDC","SurfaceGetDCHook"))
		logerr(IDirectDrawSurface4.dllHook("ReleaseDC","SurfaceReleaseDCHook"))
		D3DHOOKS_DATA.GetDCPrim := RegisterCallback("Surface1GetDC", "F")
		D3DHOOKS_DATA.RelDCPrim := RegisterCallback("Surface1ReleaseDC", "F")
		D3DHOOKS_DATA.GetDCSrfc := IDirectDrawSurface4.GetDC		
		D3DHOOKS_DATA.RelDCSrfc := IDirectDrawSurface4.ReleaseDC
		IDirectDrawSurface.GetDC     := IDirectDrawSurface4.GetDC		
		IDirectDrawSurface.ReleaseDC := IDirectDrawSurface4.ReleaseDC
		
		if (g_.cfg.dly)
		{
			logerr(IDirect3DDevice2.Hook("BeginScene"))
			logerr(IDirect3DDevice3.Hook("BeginScene"))
		}
		logerr(IDirect3DDevice2.Hook("SetRenderTarget"))
	} 
	else 
	{	
        if (! g_.cfg.layer) {
            logerr("SetupPrxs4(dd)")
            g_.proxies.rct := struct(RECT)
            
            logerr(IDirectDrawSurface4.PatchVtableWithDll("blt", "SurfaceBltHook"))	
            logerr(IDirectDrawSurface2.PatchVtableWithDll("blt", "SurfaceBltHook"))	
            logerr(IDirectDrawSurface.PatchVtableWithDll("blt", "SurfaceBltHook"))	
            
            ;logerr(IDirectDrawSurface4.PatchVtableWithDll("Bltfast", "SurfaceBltFastHook"))	
            ;logerr(IDirectDrawSurface2.PatchVtableWithDll("Bltfast", "SurfaceBltFastHook"))	
            ;logerr(IDirectDrawSurface.PatchVtableWithDll("Bltfast", "SurfaceBltFastHook"))	
            
            logerr(IDirectDrawSurface4.PatchVtableWithDll("lock", "LockSurfaceHook"))
            logerr(IDirectDrawSurface4.PatchVtableWithDll("Unlock", "UnLockSurface4Hook"))
            logerr(IDirectDrawSurface.PatchVtableWithDll("Unlock", "UnLockSurfaceHook"))
            logerr(IDirectDrawSurface.PatchVtableWithDll("Unlock", "UnLockSurfaceHook"))
            
            logerr(IDirectDrawSurface2.PatchVtableWithDll("lock", "LockSurfaceHook"))
            logerr(IDirectDrawSurface2.PatchVtableWithDll("Unlock", "UnLockSurfaceHook"))
        }
				
		SetupPrxs(DD)
		SetupCkey()		
	}		
}

SetupPrxs(DD)
{
	;isobject(g_.proxies.D3D) ? g_.proxies.D3D.check() : SetUpD3D(DD)
	for k, v in strsplit("prim dev 32bit s32bit vid cmp cpy D3D D3DZ primcpy", " ")
	g_.proxies[v] := ""	
	SetUpD3D(DD) ;breaks die
	if (g_.cfg.32bit and D3DHOOKS_DATA.D = 8)
	{
		g_.proxies.prim    := new Surface(DD, "PAL8",,1)
		g_.proxies.dev     := new Surface(DD, "PAL8",,1)
		g_.proxies.32bit   := new Surface(DD,"X8RGB")	
		g_.proxies.s32bit  := new Surface(DD,"X8RGB",,1)			
	} else {
		g_.proxies.32bit  := ""
		g_.proxies.s32bit := ""
		g_.proxies.prim   := new Surface(DD)
		g_.proxies.dev    := new Surface(DD,,,g_.cfg.sys)	
		if (g_.cfg.sys)
			g_.proxies.vid  := new Surface(DD)
		if (g_.cfg.cpy)
		{
			g_.proxies.cpy := new Surface(DD)
			g_.proxies.cmp := new Surface(DD)
		}
	}
}

SetUpD3D(DD)
{
	sz := (_RECT.right - _RECT.left) << 16 | (_RECT.bottom - _RECT.top)
	g_.proxies.primcpy := (g_.cfg.D3D = 7) ? new Surface7(DD, "X8RGB", sz) : new Surface(DD, "X8RGB", sz)
	if (g_.cfg.winedd)
	return		
	g_.proxies.D3DZ    := (g_.cfg.D3D = 7) ? new D3DDevice7(DD,0x00010001,,0) : new D3DDevice(DD,0x00010001,,0)			
}

SetUPShaders()
{
	return
}

SetupCkey()
{
	g_.proxies.fmvr    := Struct("UINT64 xy; DWORD w, h:")
	g_.proxies.fmvr.xy := 0
	g_.proxies.fmvr.w  := D3DHOOKS_DATA.w
	g_.proxies.fmvr.h  := D3DHOOKS_DATA.h
	g_.proxies.prms    := Struct("Float[12]")
	g_.proxies.prms[1] := 1/D3DHOOKS_DATA.w
	g_.proxies.prms[2] := 1/D3DHOOKS_DATA.h
	g_.proxies.prms[3] := D3DHOOKS_DATA.HD_W
	g_.proxies.prms[4] := D3DHOOKS_DATA.HD_H
	g_HD.DDBLTFX.dwFillColor                           := (D3DHOOKS_DATA.D=16) ? 0xF81f : 0xFFFF00FF
	g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceLowValue  := (g_.cfg.32bit) ? 0xFFFF00FF : g_HD.DDBLTFX.dwFillColor 
	g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceHighValue := g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceLowValue
}

QueryPrimary(p1, p2, p3)
{
	r := dllcall(IDirectDrawSurface.QueryInterface, ptr, p1, ptr, p2, ptr, p3)
	p          := new ComInterfaceWrapper(ddraw.IDirectDrawSurface, p1, True)
	p.released := True
	logerr(p.PatchVtableWithDll("lock", "LockSurfaceHook"))
	logerr(p.PatchVtableWithDll("Unlock", "UnLockSurfaceHook"))
	
	return r
}

IDirectDraw_CreatePalette(p1, p2, p3, p4, p5)
{
	if (!g_.cfg.layer) 
        logerr(IDirectDrawSurface.PatchVtable("Setpalette"))
	return dllcall(IDirectDraw.CreatePalette, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5) 
}

SetZ(z)
{
	if (g_.proxies.z.ID != dllcall(g_.p.GetSurfaceID, uint, z))
	return z 
	if (g_.proxies.z.SD16)
	{	
		dllcall(IDirectDrawSurface4.blt, uint, g_.proxies.z.SD24, uint, 0, uint, g_.proxies.z.SD16, uint, 0
									   , uint, DDBLT_WAIT, uint, g_HD.DDBLTFX[], uint)
		dllcall(IDirectDrawSurface4.blt, uint, g_.proxies.z.surface, uint, RECT[], uint, g_.proxies.z.SD24, uint, 0
									   , uint, DDBLT_WAIT, uint, g_HD.DDBLTFX[], uint)	
		return g_.proxies.z.SD16							   
	}
	b := dllcall(IDirectDrawSurface.blt, uint, g_.proxies.z.surface, uint, RECT[], uint, z, uint, 0, uint, 0, uint, 0, uint, 0)
	return z
}

GetZ(z)
{
	if (g_.proxies.z.ID != dllcall(g_.p.GetSurfaceID, uint, z))
	return z
	if (g_.proxies.z.SD16)
	{	
		dllcall(IDirectDrawSurface4.blt, uint, g_.proxies.z.SD24, uint, 0, uint, g_.proxies.z.surface, uint, RECT[]
									   , uint, DDBLT_WAIT, uint, g_HD.DDBLTFX[], uint)
		dllcall(IDirectDrawSurface4.blt, uint, g_.proxies.z.SD16, uint, 0, uint, g_.proxies.z.SD24, uint, 0
									   , uint, DDBLT_WAIT, uint, g_HD.DDBLTFX[], uint)	
		return g_.proxies.z.SD16							   
	}	
	dllcall(IDirectDrawSurface.blt, uint, z, uint, 0, uint, g_.proxies.z.surface, uint, RECT[], uint, 0, uint, 0, uint, 0)
	return z
}

Surface7lock(p1, p2, p3, p4, p5)
{    
	if ((caps := GetSurfaceCaps7(p1)) & DDSCAPS_PRIMARYSURFACE)  
	{
		p          := new ComInterfaceWrapper(ddraw.IDirectDrawSurface7, p1, True)
		p.released := True
		p.PatchVtableWithDll("Unlock", "UnLockSurface4Hook")
		;p1 := g_.proxies.prim.surface7
	}
	return Surface1lock(p1, p2, p3, p4, p5)
}

Surface7Unlock(p1, p2)
{	    
	r := dllcall(IDirectDrawSurface7.Unlock, uint, (p := GetProxy7(p1, z)).surface7, uint, p2)
	UpdateSrfc(p.surface, p1, z, D3DHOOKS_DATA._rct, D3DHOOKS_DATA.rct, g_.cfg.cpy)
	return r
}

Surface4Unlock(p1, p2)
{	
	r := dllcall(IDirectDrawSurface4.Unlock, uint, (p := GetProxy4(p1, z)).surface4, uint, p2)
	UpdateSrfc(p.surface, p1, z, D3DHOOKS_DATA._rct, D3DHOOKS_DATA.rct, g_.cfg.cpy)
	return r
}

Surface1GetDC(p1, p2)
{
	UpdateProxy(p:=GetSrcProxy(p1).surface, p1)
	r := dllcall(IDirectDrawSurface.GetDC, uint, p, uint, p2, uint)	
	return r
}	

Surface1ReleaseDC(p1, p2)
{
	r := dllcall(IDirectDrawSurface.ReleaseDC, uint, p:=GetProxy(p1, z).surface, uint, p2)	
	UpdateSrfc(p, p1, z, 0, g_.proxies.FMVr[])
	return r
}

Surface1lock(p1, p2, p3, p4, p5)
{	
	UpdateProxy(p := GetSrcProxy(p1).surface, p1, p2, g_.cfg.READ, g_.cfg.cpy)
	r := dllcall(IDirectDrawSurface.lock, uint, p, uint, p2, uint, p3, uint, p4, uint, P5, uint)
	return r
}

Surface1Unlock(p1, p2)
{		
	r := dllcall(IDirectDrawSurface.Unlock, uint, (p := GetProxy(p1, z)).surface, uint, p2)
	UpdateSrfc(p.surface, p1, z, D3DHOOKS_DATA._rct, D3DHOOKS_DATA.rct, g_.cfg.cpy)
	return r
}

zclear(fx)
{
	fx ? g_HD.ZBLTFX[] := fx
	vw1 := 0
	vw3 := 0
	if (g_.device)
	dllcall(IDirect3DDevice.NextViewport, uint, g_.device, uint, 0, "uint*", vw1:=0, uint, D3DNEXT_HEAD)
	else if (g_.device2)
	dllcall(IDirect3DDevice2.NextViewport, uint, g_.device2, uint, 0, "uint*", vw1:=0, uint, D3DNEXT_HEAD)
	else if (g_.device3)
	dllcall(IDirect3DDevice3.GetCurrentViewport, uint, g_.Device3, "uint*", vw3:=0)	
	if (vw1 && !vw3)
	{
		GUID_FromString(iid, d3d.IID_IDirect3DViewport3)
		z := dllcall(IDirect3DViewport.QueryInterface, uint, vw1, ptr, &iid, "ptr*", vw3:=0, uint)	
		dllcall(IDirect3DViewport.Release, uint, vw1)
	}	
	d := fx ? g_HD.ZBLTFX.dwFillDepth/D3DHOOKS_DATA.zmsk : 1
	r := dllcall(IDirect3DViewport3.Clear2, uint, vw3, uint, 1, uint, RECT[], uint, 2, uint, 0, float, d, float, 0.)
	dllcall(IDirect3DViewport3.Release, uint, vw3)	
	return		
}

Surface1Blt(p1, p2, p3, p4, p5, p6)
{		
	UpdateProxy(src:=GetSrcProxy(p3).surface, p3, p4, True)
	r := dllcall(IDirectDrawSurface.blt, uint, dst:=GetProxy(p1, z).surface, uint, p2, uint, src, uint, p4, uint, p5, uint, p6, uint)
	UpdateSrfc(dst, p1, z, p2, p2)
	return r		
}

Surface1Bltfast(p1, p2, p3, p4, p5, p6)
{
	g_.proxies.rct.left   := p2
	g_.proxies.rct.top    := p3
	g_.proxies.rct.right  := p2 + numget(p5+8) - numget(p5+0, "uint")
	g_.proxies.rct.bottom := p3 + numget(p5+12)- numget(p5+4, "uint")
	UpdateProxy(src:=GetSrcProxy(p4).surface, p4, g_.proxies.rct[], True)
	r := dllcall(IDirectDrawSurface.Bltfast, uint, dst:=GetProxy(p1, z).surface, uint, p2, uint, p3, uint, src, uint, p5, uint, p6, uint)
	
	UpdateSrfc(dst, p1, z, g_.proxies.rct[], g_.proxies.rct[])
	return r
}

_GetZ(z)
{
	if (g_.proxies.z.SD16)
	return {"surface4" : g_.proxies.z.SD16, "surface" : g_.proxies.z.SD16} 	
	return {"surface4" : z, "surface" : z}
}

GetSrcProxy(s)
{
	p := GetProxy(s, z)
	if (z)
	{
		GetZ(s)
		return _GetZ(s)
	}
	return p
}

GetProxy7(s, byref z)
{
	return _GetProxy(s, GetSurfaceCaps7(s), z)	
}

GetProxy4(s, byref z)
{
	return _GetProxy(s, GetSurfaceCaps4(s), z)	
}

FindProxy(cps, s)
{
	p := cps & DDSCAPS_PRIMARYSURFACE ? g_.proxies.prim 
	: cps & DDSCAPS_FLIP or (g_.cfg.winedd and g_.proxies.flp.IsThatYou(s)) ? g_.proxies.dev
	: {"surface4" : s, "surface" : s}	
	return p
}

_GetProxy(s, cps, byref z)
{
	/*
	cps & DDSCAPS_PRIMARYSURFACE ? p := g_.proxies.prim 
	: cps & DDSCAPS_FLIP ? p := g_.proxies.dev	
	: p := {"surface4" : s, "surface" : s}
	*/
	p := FindProxy(cps, s)
	if (z := cps & DDSCAPS_ZBUFFER)
	return _GetZ(s)
	return p
}

GetProxy(s, byref z)
{
	/*
	(cps := GetSurfaceCaps(s)) & DDSCAPS_PRIMARYSURFACE  ? p := g_.proxies.prim 
	: cps & DDSCAPS_FLIP ? p := g_.proxies.dev	
	: p := {"surface4" : s, "surface" : s}
	*/
	p := FindProxy(cps := GetSurfaceCaps(s), s)
	if (z := cps & DDSCAPS_ZBUFFER)
	return _GetZ(s)
	return p
}

GetrfcStr(s)
{
	cps := GetSurfaceCaps(s)
	if      (cps & DDSCAPS_PRIMARYSURFACE)
	return "primary"	
	else if (cps & DDSCAPS_FLIP)
	return "flip"
	else if (cps & DDSCAPS_ZBUFFER)
	return "zbuffer"
	else if (cps & DDSCAPS_SYSTEMMEMORY)
	return "system memory"	
	return "surface"
}

SrfcDbug(f, d, r, s=0)
{
	str := f . " "
	if (s)
	str .= GetrfcStr(s) . " to "
	str .= GetrfcStr(d) . " " r " " ddraw.err[r . ""]
	logerr(str)
}

UpdateProxy(prx, s, rct=0, r=False, cpy=False)
{
	if (!g_.rtrgt)
	return
	if (prx = g_.proxies.prim.Surface) 
	Getprmr(s)	
	else if ( (prx = g_.proxies.dev.Surface) and r )
	{
		if (D3DHOOKS_DATA.Delay = 2)
		{
			return
			Surface1UpDateRT(0, cpy)
			D3DHOOKS_DATA.Delay := 1
		}
		GetRT(rct, cpy)								  
	}			
}

UpdateSrfc(p, s, z, PrmrRct=0, RTRct=0, cpy=False)
{
	if (p = g_.proxies.prim.surface) 
	return (g_.rtrgt) ? Surface1UpDatePrimB(s, PrmrRct) : Surface1UpDatePrim(s, PrmrRct)	
	else if (p = g_.proxies.dev.Surface) and g_.rtrgt
	{
		if (g_.cfg.dly)
			return D3DHOOKS_DATA.Delay := 2
		return Surface1UpDateRT(RTRct, cpy)
	}
	else if (z) 
	SetZ(s)
}

DumpRT(s)
{
	return
	str := g_.dbg.frm " - " g_.dbg.op " " s " "
	DumpSurface(g_.rtrgt, str " Render Target.dds")
	DumpSurface(g_.proxies.dev.surface, str " Proxy.dds")
}

DDBlt(d, dr, s, sr, f, bfx)
{
	if (f=3){
		dllcall(g_.p_SetFilterBlits, "uint")
		fgs := DDBLT_WAIT
	} else if (f=0){
		fgs := DDBLT_WAIT
	} else fgs := [(g_.cfg.winedd)?DDBLT_KEYSRC:DDBLT_KEYSRCOVERRIDE, DDBLT_COLORFILL][f] | DDBLT_WAIT ;| DDBLT_DDFX 
	return dllcall(Idirectdrawsurface.blt, uint, d, uint, dr, uint, s, uint, sr, uint, fgs, uint, bfx, uint)
}

D3DBlt(dst, dst_rct, src, src_rect, f, bfx, dvc="")
{
	if (!g_.cfg.Blt3D and !dvc)
	return DDBlt(dst.surface, dst_rct, src.surface, src_rect, f, bfx)	
		 	
	if (dvc)
		return dvc.DrawRect(dst, dst_rct, src, src_rect, f)
	if (g_.cfg.d3d = "7")
		return g_.proxies.d3dz.DrawRect(dst, dst_rct, src, src_rect, f)
	new D3DDevice(dllcall(g_.p.DDFrmSrfc, ptr, dst.surface)).DrawRect(dst, dst_rct, src, src_rect, f)
}

GetRT(rct=0, cpy=0)
{
	src := RECT[]
	dst := 0
	rct	:= 0
	
	; TODO: g_.proxies.flp.surface should be the same as g_.rtrgt, yet we need this disticion here	
	if (g_.cfg.sys)
	{
		DDBlt(g_.proxies.vid.surface, dst, g_.cfg.SSAA ? g_.proxies.flp.surface : g_.rtrgt, src, 0, g_HD.DDBLTFX[])
		DDBlt(g_.proxies.dev.Surface, dst, g_.proxies.vid.Surface, dst, 0, g_HD.DDBLTFX[])			
	} else 
		DDBlt(g_.proxies.dev.surface, dst, g_.cfg.SSAA ? g_.proxies.flp.surface : g_.rtrgt, src, 0, g_HD.DDBLTFX[])			
}

Surface1UpDateRTC()
{
	return Surface1UpDateRT(0, g_.cfg.cpy)
}

Surface1UpDateRT(pRECT="", cpy=False)
{	
	dst   := RECT[]
	pRECT := g_.proxies.FMVr[]
	src   := g_.proxies.FMVr[]
			
	s := g_.proxies.dev
	if (g_.cfg.sys)
	{
		DDBlt(g_.proxies.vid.Surface, 0, g_.proxies.dev.Surface, 0, 0, g_HD.DDBLTFX[])
		s := g_.proxies.vid
	}		

	if (cpy)
	{
		DDBlt(g_.proxies.cpy.Surface, 0, g_.cfg.SSAA ? g_.proxies.flp.surface : g_.rtrgt, RECT[], 0, g_HD.DDBLTFX[])
		logerr(dllcall("peixoto.dll\DDMaskSurface", ptr, s.Surface, ptr, g_.proxies.cpy.Surface, str))
	} 	
	trgt := IsObject(g_.proxies.flp) ? g_.proxies.flp : {"surface" : g_.rtrgt, "surface7" : g_.rtrgt}	
	D3DBlt(trgt, dst, s, 0, 1, g_HD.DDBLTFX[])							 
	DDBlt(s.Surface, 0, 0, 0, 2, g_HD.DDBLTFX[])
	
	g_.dbg.op  += 1
	if (g_.cfg.sys)									  
		DDBlt(g_.proxies.dev.Surface, 0, 0, 0, 2, g_HD.DDBLTFX[])	
}

Getprmr(p)
{		
	dllcall(IDirectDrawSurface.blt, uint, g_.proxies.prim.surface, uint, 0, uint, p, uint, _RECT[], uint, 0, uint, 0, uint)									 
}

Surface1UpDatePrimB(p, pRECT)
{
	g_.dbg.frm += 1
	g_.dbg.op  := 0		
	dllcall(IDirectDrawSurface.blt, uint, g_.proxies.primcpy.surface, uint, 0, uint, p, uint, _RECT[], uint, DDBLT_WAIT, uint, 0, uint)
	dllcall(IDirectDrawSurface.blt, uint, g_.proxies.primcpy.surface, uint, 0, uint, g_.proxies.prim.Surface, uint, 0, uint, DDBLT_KEYSRCOVERRIDE, uint, g_HD.DDBLTFX[], uint)
	dllcall(IDirectDrawSurface.blt, uint, p, uint, _RECT[], uint, g_.proxies.primcpy.surface, uint, 0, uint, DDBLT_WAIT, uint, 0, uint)							   
	dllcall(IDirectdrawSurface.blt, uint, g_.proxies.prim.Surface, uint, 0, uint, 0, uint, 0, uint, DDBLT_COLORFILL, uint, g_HD.DDBLTFX[], uint)	
	return 	
}

Surface1UpDatePrim(p, pRECT)
{
	(g_.cfg.xBRh) ? keyevent(g_.cfg.xBRh) ?	g_.cfg.xBR := (g_.cfg.xBR) ? 0 : 1
	(g_.cfg.xBR or g_.cfg.SCLR) ? dllcall(g_.p.Scale, uint, pRECT, uint, g_HD._Sclr[])
	if (g_.proxies.32bit)
	{
		Pal2RGB(g_.proxies.prim.surface, (g_.cfg.xBR or g_.cfg.SCLR) ? g_HD._Sclr.src : pRECT)
		src := g_.proxies.32bit
	} else
		src := g_.proxies.prim
	
	if (g_.proxies.fmv)
	{
		x8 := new Surface(dllcall(g_.p.DDFrmSrfc, uint, p), "X8RGB",, sys=False, m=False)
		dllcall(IDirectDrawSurface.blt, uint, x8.surface, uint, 0, uint, src.surface, uint, 0, uint, 0, uint, 0, uint)
		dllcall("peixoto.dll\DDCPUDeinterlace", ptr, x8.surface)
		dllcall(IDirectDrawSurface.blt, uint, p, uint, _RECT[], uint, x8.surface, uint, g_.proxies.fmvr[], uint, 0, uint, 0, uint)		
		return
	} else if (g_.cfg.xBR)
	{	
		system := new Surface(dllcall(g_.p.DDFrmSrfc, uint, p),"X8RGB",, sys=True, m=False)
		DDBlt(system.Surface, 0, src.Surface, 0, 0, g_HD.DDBLTFX[])
		DDWait(p)			
		dllcall("peixoto.dll\DDxBRzScale", ptr, system.surface, ptr, p, ptr,  _RECT[], str)			
		return	
	}	
	else if (g_.cfg.SCLR)
	{	
		;TODO: implement partial updates with xBRz	
		DDWait(p)				
		dllcall(IDirectDrawSurface.blt, uint, p, uint, g_HD._Sclr.dst, uint, src, uint, g_HD._Sclr.src, uint, 0, uint, 0, uint)
		return
	}
	DDWait(p)	
	dllcall(IDirectDrawSurface.blt, uint, p, uint, _RECT[], uint, src.surface, uint, 0
	, uint, 0, uint, 0, uint)	
	return 	
}

Pal2RGB(src, rect_=0)
{
	f := g_.cfg.injector_dir "\error.log"
	(D := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
	(D2:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
	l1 := dllcall(IDirectDrawSurface.lock, uint, src, uint, rect_, uint, D[], uint, 0, uint, 0, uint)
	l2 := dllcall(IDirectDrawSurface.lock, uint, g_.proxies.s32bit.surface, uint, rect_, uint, D2[], uint, DDLOCK_WRITEONLY, uint, 0, uint)	
	dllcall(g_.p.Pal2RGB, uint, D.lpSurface, uint, D.lPitch, uint, g_.palette, uint, D2.lpSurface, uint, D2.lPitch, uint, D.dwWidth, uint, D.dwHeight, uint, rect_)		
	dllcall(IDirectDrawSurface.Unlock, uint, src, uint, 0)
	dllcall(IDirectDrawSurface.Unlock, uint, g_.proxies.s32bit.surface, uint, 0)
	dllcall(IDirectDrawSurface.blt, uint, g_.proxies.32bit.surface, uint, rect_, uint, g_.proxies.s32bit.surface, uint, rect_, uint, 0, uint, 0) 	
}