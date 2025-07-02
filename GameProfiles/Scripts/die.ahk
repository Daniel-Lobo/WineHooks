;REMOTE SCRIPT START

/*
DirectDrawCreate_hook(p1, p2, p3)
{
	static dd=
	g_.proxies := {} ;move to SetupPrxs		
		
	if (dd) 
	{
		dllcall(IDirectDraw.release, uint, dd) 
		dd := 0
	}		
	if (r := dllcall(g_.p.DirectDrawCreate, uint, p1, uint, p2, uint, p3))
	return r
	
	if (g_.cfg.layer)
	{
		DD := dllcall("Peixoto\WrappDDrawObject", ptr, numget(p2+0, "ptr"), ptr)
		numput(DD,p2+0, ptr)
	}
	
	dd := numget(p2+0, "ptr")	
	dllcall(IDirectDraw.addref, uint, dd)
	SetUPShaders()	
	return r
}
*/

AltDDrawCreate(p1, p2, p3)
{
	static dd=
			
	if (dd) 
	{
		dllcall(IDirectDraw.release, uint, dd) 
		dd := 0
	}		
	if (r := dllcall(g_.p.DirectDrawCreate, uint, p1, uint, p2, uint, p3))
	return r
    
    if (g_.cfg.layer)
	{
		DD := dllcall("Peixoto\WrappDDrawObject", ptr, numget(p2+0, "ptr"), ptr)
		numput(DD,p2+0, ptr)
	}
	
	dd := numget(p2+0, "ptr")	
	dllcall(IDirectDraw.addref, uint, dd)	
	return r
}

AltIDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{
	r := IDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
	if (r)
	return r
	; fixes green artifacs when the game saves
	if (DDSURFACEDESC.ddscaps.dwcaps & DDSCAPS_PRIMARYSURFACE)
	{
        if (! g_.cfg.NEFS && ! g_.cfg.SSAA)
        {
		    g_.proxies.d3d  := ""
		    g_.proxies.d3dz := ""
        }   
	}
}

