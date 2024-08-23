;REMOTE SCRIPT START 

AltIDirect3DDevice3_EndScene(p1)
{
	r := IDirect3DDevice3_EndScene(p1)	
	
	/*
	GUID_FromString(idd_surface, ddraw.IID_IDirectDrawSurface)
	q := dllcall(IDirectDrawSurface4.QueryInterface, uint, g_.RenderTarget, uint, &idd_surface, "uint*", pBack, uint)
	
	h += writeOnSurface(pBack,"3d " numget(0x673730+0, "int"),0x00ffffff , 0, h) 
	h += writeOnSurface(pBack,"3d2 "  numget(0x674048+0, "int"),0x00ffffff ,0, h) 
	h += writeOnSurface(pBack,"inv "  numget(0x67A2d0+0, "int"),0x00ffffff ,0, h) 
	h += writeOnSurface(pBack,"title "  numget(0x67e89c+0, "int"),0x00ffffff ,0, h) 
	h += writeOnSurface(pBack,"prompt "  numget(0x6d6720+0, "uchar"),0x00ffffff ,0, h) 
	h += writeOnSurface(pBack,"_menu "  numget(0x6d6708+0, "uchar"),0x00ffffff ,0, h) 
	h += writeOnSurface(pBack,"puzzle "  numget(0x6d671c+0, "short"),0x00ffffff ,0, h) 
	h += writeOnSurface(pBack,"call " HDHOOKS_DATA.callback,0x00ffffff ,0, h) 
	h += writeOnSurface(pBack,"tag " g_.tags.size ,0x00ffffff ,0, h) g_.tag 
	dllcall(IDirectDrawSurface.release, uint, pBack)
	*/
	;_rect_setscale() 
	;keyevent("w") ?	g_.cfg.wide := (g_.cfg.wide) ? False : True 		
	return r
}

Alt_SetViewPort2(p1, p2)
{	
	if g_.cfg.wide 
	{
		D3DVIEWPORT2[] := p2	
		D3DVIEWPORT2.dwWidth *= g_.resolution_correction 
		D3DVIEWPORT2.dwHeight *= g_.resolution_correction 
		D3DVIEWPORT2.dwWidth += g_.viewport_correction*2	
		r := dllcall(IDirect3DViewPort3.SetViewPort2, uint, p1, uint, D3DVIEWPORT2[])
		return r	
	} else return IDirect3DViewPort3_SetViewPort2(p1, p2)
}

D3DHOOKS_DATA.BltPrimary  := RegisterCallback("DinoBlt")

DinoBlt(p1, p2, p3, p4, p5, p6)
{	
    if (GetSurfaceCaps(p3) & DDSCAPS_3DDEVICE)
    {
        dev            := g_.proxies.dev
        g_.proxies.dev := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary4), "RG6B")	
        r := Surface1Blt(p1, p2, p3, p4, p5, p6)	
        g_.proxies.dev := dev
        return r
    }
    return Surface1Blt(p1, p2, p3, p4, p5, p6)	
}

AltIDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{
	return dllcall(IDirectDraw.CreateSurface, uint, pIDirectDraw, uint, pSurfaceDesc, uint, ppSurface, uint, pIUnknown, uint)	
}

AltIDirectDraw4_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown)
{
    D    := struct(DDSURFACEDESC)
	D[]  := pSurfaceDesc
	caps := D.ddsCaps.dwCaps	
	if (r := IDirectDraw4_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown))
	return r    
	
	if (caps&DDSCAPS_PRIMARYSURFACE)
	{
		; To handle directshow creating its surface on X8RGB format
		g_.proxies.dev := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary4), "X8RGB")		
	} 		
	return r	
}