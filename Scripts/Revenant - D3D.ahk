h_game := Get_process_handle((g_.rnm) ? "_revenant.exe" : "revenant.exe")

if (h_game)
{
	if (read_process_memory(h_game, 0x4a6115, "uchar") = 0x74)
		write_process_memory(h_game, 0x4a6115, "uchar", 0xEB)
}

;REMOTE SCRIPT START
iniread, soft, revenant.ini, Options, Software3D
g_.s.soft := (soft="Yes" or g_.s.soft=1) ? True :False
logerr(IDirect3DDevice3.Hook("GetClipStatus"))
logErr(IDirect3DDevice3.hook("SetTexture"))

IDirect3DDevice3_SetTexture(p1, p2, p3)
{
    if (p3)
    {   
        GUID_FromString(iid, ddraw.IID_IDirectDrawSurface4) 
        dllcall(IDirect3DTexture2.QueryInterface, uint, p3, ptr, &iid, "uint*", pS4:=0, uint)	        
        if (pS4)
        {
            if (GetSfc4MemType(pS4)="System")
            {
                fx        := struct(DDBLTFX)
                fx.dwSize := DDBLTFX.size()
                d         := struct(DDSURFACEDESC2)
                d.dwSize  := DDSURFACEDESC2.size()
                dllcall(IDirectDrawSurface4.GetSurfaceDesc, ptr, pS4, ptr, d[])
                
                rep := new Surface(dllcall(g_.p.DDFrmSrfc, uint, pS4), GetPixelFormat(d), d.dwHeight | (d.dwWidth << 16))
                dllcall(Idirectdrawsurface.blt, uint, rep.Surface, uint, 0, uint, pS4, uint, 0, uint, DDBLT_WAIT, uint, fx[], uint)
                dllcall(IDirectDrawSurface4.release, uint, pS4)	
                if isobject(rep)
                return dllcall(IDirect3DDevice3.SetTexture, ptr, p1, uint, p2, ptr, rep.Texture)              
            }            
        }
    }
    return dllcall(IDirect3DDevice3.SetTexture, ptr, p1, uint, p2, ptr, p3)
}

AltIDirectDraw4_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown)
{
	(d := struct(DDSURFACEDESC2))[] := pSurfaceDesc
	
	r := IDirectDraw4_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown)
    if (d.ddscaps.dwcaps & DDSCAPS_PRIMARYSURFACE)
	{
		logerr(d.dwWidth "x" d.dwHeight)
	}
	return r
} 

AltIDirectDrawSurface4_GetAttachedSurface(p1, p2, p3)
{
	if ( GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE )
	{
		NEFS(p1, D, DD, sz, fmt, sys)		
		g_.proxies.flp := new Surface(DD, fmt, sz, sys)
		g_.proxies.flp.Attach((f:=new Surface(DD, fmt, sz, sys)).surface)		
	}
	return dllcall(IDirectDrawSurface4.GetAttachedSurface, uint, p1, uint, p2, uint, p3)
}

AltIDirectDrawSurface_AddAttachedSurface(p1, p2)
{
	if (GetSurfaceCaps(p2) & DDSCAPS_ZBUFFER)
	{	
		(g_.s.soft) ?: p1 := g_.proxies.flp.surface
		if (g_.cfg.XBR)
		{
			dllcall(IDirectDrawSurface.AddAttachedSurface, uint, g_.proxies.prim.surface4, uint, p2)
			return dllcall(IDirectDrawSurface.AddAttachedSurface, uint, g_.proxies.dev.surface4, uint, p2)
		}
		g_.proxies.z := new zprx(p1, p2)
		p2           := g_.proxies.z.Surface
	}
	return dllcall(IDirectDrawSurface.AddAttachedSurface, uint, p1, uint, p2)
}
		
AltIDirect3D3_CreateDevice(p1, p2, p3, p4, p5)
{
	r := IDirect3D3_CreateDevice(p1, p2, (g_.s.soft) ? p3 : g_.proxies.flp.surface4, p4, p5)
	(g_.s.soft) ? g_.rtrgt := ""
	return r
}
	
AltIDirect3DDevice3_GetClipStatus(p1, p2)
{
	;return 0
	r := dllcall(IDirect3DDevice3.GetClipStatus, uint, p1, uint, p2)
	if (!r)
	{
		s := struct("DWORD dwFlags; DWORD dwStatus; float minx, maxx; float miny, maxy; float minz, maxz;")
		s[] := p2
		s.minx -= D3DHOOKS_DATA.HD_X	
		s.maxx -= D3DHOOKS_DATA.HD_X	
		s.minx /= D3DHOOKS_DATA.scale	
		s.maxx /= D3DHOOKS_DATA.scale
		s.miny /= D3DHOOKS_DATA.scale	
		s.maxy /= D3DHOOKS_DATA.scale
	}
	return r
}