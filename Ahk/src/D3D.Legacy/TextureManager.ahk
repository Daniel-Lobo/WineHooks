global g_manager := {} 
global g_mngr    := {} 
InitMngr()
{
	g_mngr.SysMem               := new Collection()
    g_mngr.D                    := struct(ddSurfaceDesc2)
    g_mngr.D.dwSize             := ddSurfaceDesc2.size()
    g_mngr.SysD                 := struct(ddSurfaceDesc2)
    g_mngr.SysD.dwSize          := ddSurfaceDesc2.size()
    g_mngr.SysD.dwFlags         := DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH | DDSD_PIXELFORMAT    
	g_mngr.SysD.ddsCaps.dwCaps  := DDSCAPS_TEXTURE | DDSCAPS_SYSTEMMEMORY    
    D3DHOOKS_DATA.sysmem_surfaces           := g_mngr.SysMem.pc
	
	if (g_.cfg.TextSwap)
	{
		if (g_tswap.v)
		{
			l   := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "ManagerLock4")
			u   := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "ManagerUnLock4")
			ll  := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "Lock4Hook")
			uu  := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "UnLock4Hook")
			logerr("ManagerLock4   : " AltInstallHook(l, (lt := ll)) )
			logerr("ManagerUnLock4 : " AltInstallHook(u, (ut := uu)) )
			D3DHOOKS_DATA.Manager_Lock   := lt
			D3DHOOKS_DATA.Manager_UnLock := ut	
		} else 
		{	
			if (g_.cfg.HD)
			{
				D3DHOOKS_DATA.LockSurface     := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "ManagerLock4")
				D3DHOOKS_DATA.UnLockSurface4  := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "ManagerUnLock4")
				D3DHOOKS_DATA.Manager_Lock    := IDirectDrawSurface4.Lock
				D3DHOOKS_DATA.Manager_UnLock  := IDirectDrawSurface4.UnLock						
			} else {
				logerr(IDirectDrawSurface4.dllhook("Lock", "ManagerLock4"))
				logerr(IDirectDrawSurface4.dllhook("Unlock", "ManagerUnLock4"))
				D3DHOOKS_DATA.Manager_Lock   := IDirectDrawSurface4.Lock
				D3DHOOKS_DATA.Manager_UnLock := IDirectDrawSurface4.UnLock	
			}
		}
				
		g_mngr.query                 := IDirectDrawSurface.QueryInterface		
		D3DHOOKS_DATA.QueryTexture   := RegisterCallback("MngrQuery")		
		
		IDirect3DTexture2.UnHook("Release")
		logerr(IDirect3DTexture2.hook("Release", "MngrRelease"))
		g_mngr.release := RegisterCallback("IDirect3DTex2_Release", "F")
		g_mngr.release := RegisterCallback("IDirect3DTexture2_Release", "F")

	} else {
		logerr(IDirect3DTexture2.hook("Release", "MngrRelease"))
		g_mngr.release := IDirect3DTexture2.Release
		
		if (g_.cfg.HD)
		{
			D3DHOOKS_DATA.LockSurface     := IDirectDrawSurface4.Lock
			D3DHOOKS_DATA.UnLockSurface4  := IDirectDrawSurface4.UnLock	
			D3DHOOKS_DATA.LockSurface     := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "ManagerLock4")
			D3DHOOKS_DATA.UnLockSurface4  := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "ManagerUnLock4")
			D3DHOOKS_DATA.Manager_Lock    := IDirectDrawSurface4.Lock
			D3DHOOKS_DATA.Manager_UnLock  := IDirectDrawSurface4.UnLock	
			D3DHOOKS_DATA.QueryTexture    := RegisterCallback("MngrQuery")
			D3DHOOKS_DATA.QueryDevice     := RegisterCallback("Dvc1Query", "F")			
		} else {
			logerr(IDirectDrawSurface4.dllhook("Lock", "ManagerLock4"))
			logerr(IDirectDrawSurface4.dllhook("Unlock", "ManagerUnLock4"))
			D3DHOOKS_DATA.Manager_Lock   := IDirectDrawSurface4.Lock
			D3DHOOKS_DATA.Manager_UnLock := IDirectDrawSurface4.UnLock	
			
			logerr(IDirectDrawSurface.dllHook("QueryInterface", "SrfcQueryHook"))
			D3DHOOKS_DATA.QueryPrimary := IDirectDrawSurface.QueryInterface
			D3DHOOKS_DATA.QuerySurface := IDirectDrawSurface.QueryInterface		
			D3DHOOKS_DATA.QueryDevice  := RegisterCallback("Dvc1Query", "F")
			IDirectDrawSurface4.QueryInterface := IDirectDrawSurface.QueryInterface
		}
		g_mngr.query := IDirectDrawSurface.QueryInterface
	}
	
	D3DHOOKS_DATA.DLock        := IDirectDrawSurface4.Lock
    D3DHOOKS_DATA.DUnLock      := IDirectDrawSurface4.UnLock
	D3DHOOKS_DATA.Manager_Blt  := IDirectDrawSurface4.blt
	    
    g_tswap.ids4 := struct("DWORD[4]")
    dllcall("Ole32.dll\CLSIDFromString", str, ddraw.IID_IDirectDrawSurface4, uint, g_tswap.ids4[])
}

MngrQuery(p1, p2, p3)
{
    if !(p1|p2|p3)
    return DDERR_INVALIDPARAMS
	
    if (StringFromIID(p2) = d3d.IID_IDirect3DTexture2)
    {
        if dllcall(IDirectDrawSurface4.GetSurfacedesc, uint, p1, uint, g_mngr.D[])
        or (g_mngr.D.ddsCaps.dwCaps2 & DDSCAPS2_TEXTUREMANAGE) or (g_mngr.D.ddsCaps.dwCaps & DDSCAPS_MIPMAP)
		or (g_mngr.D.ddsCaps.dwCaps & DDSCAPS_SYSTEMMEMORY)
        return (g_.cfg.TextSwap) ? IDirectDrawSurface4_QueryInterface(p1, p2, p3) 
		: dllcall(g_mngr.query, uint, p1, uint, p2, uint, p3)
		
        SetPixelFormat(g_mngr.SysD, GetPixelFormat(g_mngr.D))
        if g_mngr.D.dwFlags & DDSD_CKSRCBLT {
            g_mngr.SysD.dwFlags |= DDSD_CKSRCBLT
            g_mngr.SysD.ddckCKSrcBlt.dwColorSpaceLowValue  := g_mngr.D.ddckCKSrcBlt.dwColorSpaceLowValue
            g_mngr.SysD.ddckCKSrcBlt.dwColorSpaceHighValue := g_mngr.D.ddckCKSrcBlt.dwColorSpaceLowValue
        } else  g_mngr.SysD.dwFlags &= ~ DDSD_CKSRCBLT
        g_mngr.SysD.dwWidth  :=  g_mngr.D.dwWidth
        g_mngr.SysD.dwHeight :=  g_mngr.D.dwHeight
        pMemSurface          := 0
		
        m := dllcall(IDirectDraw4.CreateSurface, uint, g_.pIDirectDraw4, uint, g_mngr.SysD[], "uint*", pMemSurface, uint, 0, uint)
        m ? logerr("Failed " ddraw.err[m . ""] " " GetPixelFormat(g_mngr.SysD)) : g_mngr.SysMem._add(p1, pMemSurface)       
    }
    return (g_.cfg.TextSwap) ? IDirectDrawSurface4_QueryInterface(p1, p2, p3) 
	: dllcall(g_mngr.query, uint, p1, uint, p2, uint, p3)
}

MngrRelease(p1)
{
    s4 := 0
    if ! dllcall(IDirect3DTexture2.QueryInterface, uint, p1, uint, g_tswap.ids4[], "uint*", s4, uint)
    {
        g_mngr.SysMem.discard(s4)
        dllcall(IDirectDrawSurface4.Release, uint, s4)
    }
    return dllcall(g_mngr.release, uint, p1)
}