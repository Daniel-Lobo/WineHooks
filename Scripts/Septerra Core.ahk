;REMOTE SCRIPT START

logerr(IDirectDrawSurface.Hook("SetColorKey")) ;setting the destoverlay colorkey on the primary breaks FMVs
AltIDirectDrawSurface_SetColorKey(p1, p2, p3)
{
	return
}

AltGetClientRect(p1, p2)
{	
	rct   := struct("int x, y, w, h;")
	rct[] := p2	
	rct.x := 0
	rct.y := 0	
	rct.w := 640
	rct.h := 480	
	return 1		
}

if (g_.cfg.HD)
{
	logerr("GetClientRect " InstallHook("AltGetClientRect", p, "peixoto.dll", "D3D12GetClientRectHook"))				
}




