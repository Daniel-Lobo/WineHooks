if g_.gpadfix
{
	h_game := Get_process_handle(g_.target_name)
	pad := new CodeInjection(h_game, 0x00421daf, [0x7a])
	pad._enable()
}
return

;REMOTE SCRIPT START
/*
logErr(IDirect3DDevice3.hook("BeginScene"))
D3DHOOKS_DATA.UnLockPrimary := RegisterCallback("Alt_Unlock", "F")

IDirect3DDevice3_BeginScene(p1)
{
	g_HD.DDBLTFX.dwFillColor                           := 0
	g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceLowValue  := 0
	g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceHighValue := 0
	dllcall(IDirectDrawSurface4.blt, uint, g_.proxies.dev.Surface4, uint, 0, uint, 0, uint, 0
								   , uint, DDBLT_COLORFILL, uint, g_HD.DDBLTFX[], uint)	
	return dllcall(IDirect3DDevice3.BeginScene, uint, p1)
}

Alt_Unlock(p1, p2)
{
	g_HD.DDBLTFX.dwFillColor                           := (D3DHOOKS_DATA.D=16) ? 0xF81f : 0xFFFF00FF
	g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceLowValue  := (g_.cfg.32bit) ? 0xFFFF00FF : g_HD.DDBLTFX.dwFillColor 
	g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceHighValue :=  g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceLowValue	
	return	Surface4Unlock(p1, p2) 
}
*/