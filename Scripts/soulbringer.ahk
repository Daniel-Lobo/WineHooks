;REMOTE SCRIPT START

logerr(IDirectDraw.unhook("EnumdisplayModes"))
logerr(IDirectDraw4.unhook("EnumdisplayModes"))

AltIDirectDraw2_CreateSurface(p1, p2, p3, p4)
{
	d    := struct(DDSURFACEDESC)
	d[] := p2
	if (d.ddsCaps.dwCaps & DDSCAPS_PRIMARYSURFACE)
		d.ddsCaps.dwCaps &= ~ DDSCAPS_SYSTEMMEMORY
	
	return IDirectDraw2_CreateSurface(p1, p2, p3, p4)	
}

AltIDirectDrawSurface_GetAttachedSurface(p1, p2, p3)
{
	logerr("..............")
	if ( GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE )
	{
		NEFS(p1, D, DD, sz, fmt, sys)		
		g_.proxies.flp := new Surface(DD, fmt, sz, sys)
		g_.proxies.flp.Attach((f:=new Surface(DD, fmt, sz, sys)).surface)	
		numput(g_.proxies.flp.surface, p3+0, "uint")
		dllcall(IDirectDrawSurface.addref, uint, g_.proxies.flp.surface) 		
		return 0
	}
	else if (numget(p2+0, "uint") & DDSCAPS_ZBUFFER)
	{
		if (g_.proxies.z)
		{
			GUID_FromString(iid, ddraw.IID_IDirectDrawSurface)
			q := dllcall(IDirectDrawSurface.QueryInterface, ptr, g_.proxies.z.id, ptr, &iid, ptr, p3)
			logerr("IDirectDrawSurface::GetAttachedSurface ZBuffer::QueryInterface " q " "ddraw.err[q . ""])
			return q
		}
	}
	return dllcall(IDirectDrawSurface.GetAttachedSurface, uint, p1, uint, p2, uint, p3)
}



