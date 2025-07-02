;REMOTE SCRIPT START
logerr(IDirect3DDevice7.UnHook("SetTexture"))		
logErr(IDirect3DDevice7.dllhook("SetTexture", "AltSetTexture7Hook"))	
D3DHOOKS_DATA.IDirect3DDevice7_SetTexture   := IDirect3DDevice7.SetTexture 
;logerr(IDirectDrawSurface.UnHook("GetPalette"))
;logerr(IDirectDrawSurface.UnHook("SetPalette"))			
;logerr(IDirectDrawPalette.UnHook("SetEntries"))
;logerr(IDirectDrawPalette.UnHook("GetEntries"))

AltIDirectDrawSurface_GetPalette(p1, p2)
{
	return dllcall(IDirectDrawSurface.GetPalette, uint, p1, uint, p2)	
}

AltIDirectDrawSurface_SetPalette(p1, p2)
{
	r := dllcall(IDirectDrawSurface.SetPalette, uint p1, uint, p2)	
	if (r)
		logerr("IDirectDrawSurface::SetPalette Failed")
	else logerr("Passed ")
	return r
}