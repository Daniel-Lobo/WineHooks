;REMOTE SCRIPT START
;D3DHOOKS_DATA.BltPrimary  := RegisterCallback("AltIDirectDrawSurface4_blt", "F")
;D3DHOOKS_DATA.UnLockPrimary :=	RegisterCallback("ZUnlock", "F")	
;D3DHOOKS_DATA.LockPrimary :=	RegisterCallback("Zlock", "F")	
;logerr(IDirectDraw.Hook("GetCaps"))

IDirectDraw_GetCaps(p1, p2, p3)
{
	r := dllcall(IDirectDraw.GetCaps, uint, p1, uint, p2, uint, p3)
	;numput(DDBD_16, p3+56, "uint")	
	return r
}

g_.cfg.z24 := 0

/*
ZUnLock(p1, p2)
{	
	if (GetSurfaceCaps(p1) & DDSCAPS_ZBUFFER) 
	{		
		r :=  Surface1Unlock(g_.proxies.z.sys, p2)
		dllcall(IDirectDrawSurface.blt, uint, g_.proxies.z.vid, uint, 0, uint, g_.proxies.z.sys, uint, 0 
									  , uint, DDBLT_WAIT, uint, 0, uint)	
		dllcall(IDirectDrawSurface.blt, uint, p1, uint, RECT[], uint, g_.proxies.z.vid, uint, 0 
									  , uint, DDBLT_WAIT, uint, 0, uint)	
		return r							  
	}	
	return Surface1Unlock(p1, p2)	
}

Zlock(p1, p2, p3, p4, p5)
{
	if (GetSurfaceCaps(p1) & DDSCAPS_ZBUFFER) 
	{	
		b := dllcall(IDirectDrawSurface.blt, uint, g_.proxies.z.vid, uint, 0, uint, p1, uint, RECT[]
										   , uint, DDBLT_WAIT, uint, 0, uint)
		dllcall(IDirectDrawSurface.blt, uint, g_.proxies.z.sys, uint, 0, uint, g_.proxies.z.vid, uint, 0
									  , uint, DDBLT_WAIT, uint, 0, uint)								   
										   
		;logerr(b ddraw.err[b . ""])
		p1 := g_.proxies.z.sys
	}	
	return Surface1lock(p1, p2, p3, p4, p5)	
}
*/

ZUnLock(p1, p2)
{	
	if (GetSurfaceCaps(p1) & DDSCAPS_ZBUFFER) 
	{	
		if g_.cfg.z24
		{
			r := Surface1Unlock(g_.proxies.z.sys, p2)
			dllcall(IDirectDrawSurface.blt, uint, g_.proxies.z.vid, uint, 0, uint, g_.proxies.z.sys, uint, 0 
										  , uint, DDBLT_WAIT, uint, 0, uint)
		} else r := Surface1Unlock(g_.proxies.z.vid, p2)										  
		dllcall(IDirectDrawSurface.blt, uint, p1, uint, RECT[], uint, g_.proxies.z.vid, uint, 0 
									  , uint, DDBLT_WAIT, uint, 0, uint)	
		return r							  
	}	
	return Surface1Unlock(p1, p2)	
}

Zlock(p1, p2, p3, p4, p5)
{
	if (GetSurfaceCaps(p1) & DDSCAPS_ZBUFFER) 
	{	
		dllcall(IDirectDrawSurface.blt, uint, g_.proxies.z.vid, uint, 0, uint, p1, uint, RECT[]
									  , uint, DDBLT_WAIT, uint, 0, uint)
		if g_.cfg.z24
		{
			dllcall(IDirectDrawSurface.blt, uint, g_.proxies.z.sys, uint, 0, uint, g_.proxies.z.vid, uint, 0
									      , uint, DDBLT_WAIT, uint, 0, uint)
			p1 := g_.proxies.z.sys						  
		}  	
		else p1 := g_.proxies.z.vid
	}	
	return Surface1lock(p1, p2, p3, p4, p5)	
}
