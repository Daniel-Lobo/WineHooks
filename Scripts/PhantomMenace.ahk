;REMOTE SCRIPT START

if (g_.cfg.target_name != "wmain.exe") 
{
	
	D3DHOOKS_DATA.UnLockPrimary4 :=	RegisterCallback("ZUnlock", "F")	
	;D3DHOOKS_DATA.LockPrimary :=	RegisterCallback("Zlock", "F")			
	;logerr(IDirectInputDeviceW.Unhook("GetDeviceState")) 
	;logerr(IDirectInputDeviceW.hook("GetDeviceState", "AltGetDeviceState", ,1))				
}

/*
IDirectDraw_Release(p1)
{
	if ((r := dllcall(IDirectDraw.Release, uint, p1)) = 1)
	{
		;r := dllcall(IDirectDraw.release, uint, g_.pIDirectDraw) 
		;g_.pIDirectDraw:=""
		return 0
	}	
}
*/

AltIDirectDraw4_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown)
{
	D    := struct(DDSURFACEDESC2)
	D[]  := pSurfaceDesc
	caps := D.ddsCaps.dwCaps
	
	if (caps & DDSCAPS_ZBUFFER) 
	{
		;D.ddpfPixelFormat.dwRGBBitCount := 24
		;D.ddpfPixelFormat.dwGBitMask := 0xffffff00
	}
			
	if (r := IDirectDraw4_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown))
	return r
	
	if (caps & DDSCAPS_PRIMARYSURFACE) 
	{
		(Display := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()	
		dllcall(IDirectDraw4.GetDisplayMode, uint, g_.pIDirectDraw4, uint, Display[])
		
		(D := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
		dllcall(IDirectDrawSurface4.GetSurfacedesc, uint, g_.primary4, uint, D[])
		logerr("primary " GetPixelFormat(D) " "  GetPixelFormat(Display))
	}
	
	if (caps & DDSCAPS_ZBUFFER) 
	{
		UpdateGameWin(dllcall(g_.p.DDFrmSrfc, uint, g_.primary4))
		dllcall("ShowCursor", uint, 0)	

		/*
		(g_.proxies.zbuffb) ? dllcall(IDirectDrawSurface4.release, uint, g_.proxies.zbuffb)
		(g_.proxies.zbuff)  ? dllcall(IDirectDrawSurface4.release, uint, g_.proxies.zbuff)
		g_.proxies.zbuff  := ""
		g_.proxies.zbuffb := ""
		
		D.dwWidth  := D3DHOOKS_DATA.w
		D.dwHeight := D3DHOOKS_DATA.h
		DDBLTFX.dwFillDepth     := DDSURFACEDESC2.ddpfPixelFormat.dwGBitMask
		
		z := dllcall(IDirectDraw4.CreateSurface, uint, pIDirectDraw4, uint, D[]
	                                           , "uint*", zbuff:=0, uint, 0, uint)
		g_.proxies.zbuffb := zbuff		

		D.ddsCaps.dwCaps                := DDSCAPS_ZBUFFER | DDSCAPS_SYSTEMMEMORY
		D.ddpfPixelFormat.dwRGBBitCount := 16
		D.ddpfPixelFormat.dwGBitMask    := 0xffff		
		z := dllcall(IDirectDraw4.CreateSurface, uint, pIDirectDraw4, uint, D[]
	                                           , "uint*", zbuff:=0, uint, 0, uint)
		g_.proxies.zbuff := zbuff
		*/
	}
	
	return r
}

Zlock(p1, p2, p3, p4, p5)
{
	if (GetSurfaceCaps4(p1) & DDSCAPS_ZBUFFER) and g_.proxies.z.SD16
	{	
		g_.proxies.zbuff  := g_.proxies.z.SD16
		g_.proxies.zbuffb := g_.proxies.z.SD24
		
		dllcall(IDirectDrawSurface4.blt, uint, g_.proxies.zbuffb, uint, 0, uint, g_.proxies.z.surface, uint, _RECT[]
									   , uint, DDBLT_WAIT, uint, g_HD.DDBLTFX[], uint)
		dllcall(IDirectDrawSurface4.blt, uint, g_.proxies.zbuff, uint, 0, uint, g_.proxies.zbuffb, uint, 0
									   , uint, DDBLT_WAIT, uint, g_HD.DDBLTFX[], uint)
		p1 := g_.proxies.zbuff
	}
	return Surface1lock(p1, p2, p3, p4, p5)
}

ZUnLock(p1, p2)
{
	r := Surface4Unlock(p1, p2)
	if (GetSurfaceCaps4(p1) & DDSCAPS_ZBUFFER) 
	{
		;r := dllcall(IDirectDrawSurface4.Unlock, uint, g_.proxies.zbuff, uint, p2)	
		dllcall(IDirect3DDevice3.GetCurrentViewport, uint, g_.Device3, "uint*", vw:=0)
		dllcall(IDirect3DViewport3.Clear2, uint, vw, uint, 1, uint, _rect[], uint, 2, uint, 0, float, 1, float, 0.)
		dllcall(IDirect3DViewport3.release, uint, vw)
		return r											  
	} 
	return r
	return Surface4Unlock(p1, p2) ;Surface4Unlock(p1, p2)
}

AltIDirectDrawSurface4_blt(p1, p2, p3, p4, p5, p6)
{
	static s
	return Surface1Blt(p1, p2, p3, p4, p5, p6)
	s ?: s := struct(DDBLTFX)
	if (GetSurfaceCaps4(p1) & DDSCAPS_ZBUFFER) 
	{
		s[] := p6
		setformat, integer, hex
		logerr("zblit " s.dwFillDepth " " s[] " " p5 & DDBLT_DEPTHFILL)
		dllcall(IDirect3DDevice3.GetCurrentViewport, uint, g_.Device3, "uint*", vw:=0)
		dllcall(IDirect3DViewport3.Clear2, uint, vw, uint, 1, uint, _rect[], uint, 2, uint, 0, float, 0, float, 0.)
		dllcall(IDirect3DViewport3.release, uint, vw)
		return 0
	}		
	return Surface1Blt(p1, p2, p3, p4, p5, p6)
}