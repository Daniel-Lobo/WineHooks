;REMOTE SCRIPT START
/*
if g_.cfg.create_links
{
	target := g_.cfg.target
	splitpath, target, , , ,name
	target := g_.cfg.mydocs "\Games\ResidentEvil2\" name
	FileCreateDir, %target%
	splitpath, A_windir, , , , ,Drive
	FileRemoveDir, %drive%\RE2SAVES\
	printl("Simbolic link : " lnk "-> Succes= " dllcall("CreateSymbolicLinkW"
	, str, Drive "\RE2SAVES", str, target, uint, 1) " code= " A_lasterror)
	regwrite, REG_SZ, HKLM, SOFTWARE\Wow6432Node\CAPCOM\RESIDENT EVIL2,Save path, %drive%\RE2SAVES
}
*/

logerr(GetDirectShow())
logerr(IVideoWindow.hook("SetWindowPosition"))
logerr(IMediaControl.hook("Run"))

if isobject(IDirectSoundBuffer) {
	logerr(IDirectSoundBuffer.Hook("Play"))
	logerr(IVideoWindow.hook("put_Visible"))
}

Alt_SetWindowPosition(p1, p2, p3, p4, p5)
{
	IDirectSoundBuffer.UnHook("Play")
	return AltIVideoWindow_SetWindowPosition(p1, p2, p3, p4, p5) 		
}

AltIVideoWindow_put_Visible(p1, p2)
{
	p2 ?: IDirectSoundBuffer.Hook("Play")
	return dllcall(IVideoWindow.put_Visible, uint, p1, uint, p2)
}

AltIVideoWindow_SetWindowPosition(p1, p2, p3, p4, p5)
{
	return dllcall(IVideoWindow.SetWindowPosition, uint, p1, uint, 0, uint, 0, uint, D3DHOOKS_DATA.HD_W, uint, D3DHOOKS_DATA.HD_H)
}

AltIMediaControl_Run(p1)
{
	pBasicVideo    := 0, ww:=0, hh:=0, x:=0, y:=0
	GUIDFromString := "GUID_FromString"
	%GUIDFromString%(idd_IBasicVideo, dshow.IID_IBasicVideo)
	dllcall(IMediaControl.QueryInterface, uint, p1, uint, &idd_IBasicVideo, "uint*", pBasicVideo)
	dllcall(IBasicVideo.get_VideoWidth, uint, pBasicVideo, "uint*", ww)	
	dllcall(IBasicVideo.get_VideoHeight, uint, pBasicVideo, "uint*", hh)
	if (g_.cfg.FMV)
	{
		dllcall(IBasicVideo.put_DestinationHeight, uint, pBasicVideo, "uint", D3DHOOKS_DATA.HD_H)	
		dllcall(IBasicVideo.put_DestinationWidth, uint, pBasicVideo, "uint", D3DHOOKS_DATA.HD_W-D3DHOOKS_DATA.HD_X*2)	
		dllcall(IBasicVideo.put_DestinationLeft, uint, pBasicVideo, "uint", D3DHOOKS_DATA.HD_X)	
		dllcall(IBasicVideo.put_DestinationTop, uint, pBasicVideo, "uint", 0)
	} else {
		dllcall(IBasicVideo.put_DestinationHeight, uint, pBasicVideo, "uint", hh)	
		dllcall(IBasicVideo.put_DestinationWidth, uint, pBasicVideo, "uint", ww)	
		dllcall(IBasicVideo.put_DestinationLeft, uint, pBasicVideo, "uint", (D3DHOOKS_DATA.HD_W-ww)/2)	
		dllcall(IBasicVideo.put_DestinationTop, uint, pBasicVideo, "uint", (D3DHOOKS_DATA.HD_H-hh)/2)
	}
	dllcall(IBasicVideo.release, uint, pBasicVideo)	
	return dllcall(IMediaControl.Run, uint, p1)
}


AltIDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown) {
	
	D    := struct(DDSURFACEDESC)
	D[]  := pSurfaceDesc
	caps := D.ddsCaps.dwCaps
	r := IDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
	if (caps & DDSCAPS_PRIMARYSURFACE) and not r {
		;Magenta doesn't work with RE2
		g_.proxies.sys    := new SurrogateSurface(,,1)
		g_HD.DDBLTFX.dwFillColor                           := 0
		g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceLowValue  := 0
		g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceHighValue := 0				
	}
	if r and (caps & DDSCAPS_ZBUFFER)
	{
		logerr("Failed to create a " D.dwZBufferBitDepth " bit Zbuffer " r ": " ddraw.err[r . ""])	
		D.dwZBufferBitDepth := 24 	
		logerr("Attempting  " D.dwZBufferBitDepth " bit Zbuffer")
		r := IDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown) 
		logerr(r ? "Failed" : "Success")		
	}			
	return r
}

TimeGetTime()
{
	static freq := 0
	timenow     := 0
	freq ?:	DllCall("QueryPerformanceFrequency", "Int64*", freq)			
	DllCall("QueryPerformanceCounter", "Int64*", timenow)	
	timenow *= 1000/freq
	return timenow * g_.cfg.GameSpeed
}

IDirectSoundBuffer_Play(p1, p2, p3, p4)
{
	if (p4 & DSBPLAY_LOOPING)
	{
		(D := struct(DSBCAPS)).dwSize := DSBCAPS.size()
		dllcall(IDirectSoundBuffer.GetCaps, uint, p1, uint, D[])
		printl("sndbuffersize " D.dwBufferBytes)
		if (D.dwBufferBytes > 60000)
			return 0
	}
	r := dllcall(IDirectSoundBuffer.Play, uint, p1, uint, p2, uint, p3, uint, p4)
	return r
}

AltIDirect3D2_CreateDevice(p1, p2, p3, p4)	
{
	r := IDirect3D2_CreateDevice(p1, p2, p3, p4)	
	return r
}

