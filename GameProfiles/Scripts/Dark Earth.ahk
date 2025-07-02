;REMOTE SCRIPT START

logerr("CloseHandle Hook  : " InstallHook("CloseHandle", pCloseHandle, "Kernel32.dll", "CloseHandle") " <- 0 means no error")	
g_.pCloseHandle           := pCloseHandle
g_.FMV                    := 0
D3DHOOKS_DATA.Bltprimary  := registercallback("Alt_blt", "f")
(g_.cfg.D3D) ?: GetDirectDraw(), IDirectDraw.Hook("CreateSurface")
BuildfileslistDE()

Alt_blt(p1, p2, p3, p4, p5, p6)
{
	static hint := "Collumn-Line|6-6|3-3|3-5|6-7|6-4|6-2|8-4|5-8|1-5|1-7|8-3|3-7"
	. "`nClick the board after you beat Sadak to continue the game`nTomb Puzzle:down|up|up|up|down|up"
	keyevent("h") ? g_.hint := (g_.hint & True) ? False : True
		
	if (g_.FMV < 0) 
		g_.proxies.fmv := 0	
	else if	(g_.FMV > 0) 
		g_.proxies.fmv := 1		
	
	(g_.hint & True) ? WriteOnSurface(p3, hint, 0x00FFFFFF)
	Surface1Blt(p1, p2, p3, p4, p5, p6)	
	return 0	
}

AltIDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{

	D    := struct(DDSURFACEDESC)
	D[]  := pSurfaceDesc
	;D.ddsCaps.dwCaps &= ~ DDSCAPS_3DDEVICE
	/*
	if ! (DDSURFACEDESC.ddsCaps.dwCaps & DDSCAPS_PRIMARYSURFACE)
	{
		DDSURFACEDESC.ddsCaps.dwCaps |= DDSCAPS_SYSTEMMEMORY
		DDSURFACEDESC.ddsCaps.dwCaps &= ~ DDSCAPS_VIDEOMEMORY
	}
	*/
	setformat, integer, hex
	if not g_.cfg.D3D
		return dllcall(IDirectDraw.CreateSurface, uint, pIDirectDraw, uint, pSurfaceDesc, uint, ppSurface, uint, pIUnknown, uint)
	if r := IDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
		logerr(D.ddsCaps.dwCaps GetPixelFormat(D))
	g_.proxies.fmvs := ""
	return r
}	

AltCreateFileA(p1, p2, p3, p4, p5, p6, p7)
{
	file := strget(p1, "CP0")
	VarSetCapacity(stringU, strlen(file)*2)
	strput(file, &stringU, "UTF-16")
	r := AltCreateFileW(&stringU, p2, p3, p4, p5, p6, p7)
		
	n := 2	
	while (r = -1)
	{
		splitpath, file, file_name, dir, 
		file := dir "\" SubStr(file_name, 2)
		VarSetCapacity(stringU, strlen(file)*2)
		strput(file, &stringU, "UTF-16")
		r := AltCreateFileW(&stringU, p2, p3, p4, p5, p6, p7)
		n += 1
		if n > 5
			break
	}	

	splitpath, file, , , ext		
	if (ext = "CRH"){
		dllcall(IDirectDrawSurface.blt, uint, g_.primary, uint, 0, uint, 0, uint, 0
									  , uint, DDBLT_COLORFILL, uint, DDBLTFX[], uint)	
		g_.FMV := r	
	}
	return r
}

AltCreateFileW(p1, p2, p3, p4, p5, p6, p7)
{
	file := strget(p1, "UTF-16")
	stringreplace, file, file, /, \, 1	
	Splitpath, file, filename
		
	g_.filesList[filename] ? file := g_.filesList[filename]			

	r := dllcall(g_fhks.pCreateFileW, str, file, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)
	return r
}

CloseHandle(hwnd)
{
	if (hwnd = g_.FMV) 
		g_.FMV := -1
	return dllcall(g_.pCloseHandle, uint, hwnd)
}

BuildfileslistDE()
{
	g_.filesList := {}
	dir := g_.cfg.target_dir
	loop, %dir%\*.*, 0, 1
		g_.filesList[A_loopfilename] := A_loopfilefullpath
	g_.filesList.remove("error.log")
}