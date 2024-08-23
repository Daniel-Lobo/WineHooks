h_game := Get_process_handle(g_.target_name)
;if ! g_.HD
	;sleep, 2000
goto wide

~Tab::
	wide:
	aspect := (g_.PSXAspect) ? 320/200 * 3/4 : 4/3
	if (g_.target_name = "tomb4.exe")
	{
		HRes := round(read_process_memory(h_game, 0x00753c48, "int") * aspect)
		while not HRes {
			sleep, 100
			HRes := round(read_process_memory(h_game, 0x00753c48, "int") * aspect)
		}
		print("->" round(read_process_memory(h_game, 0x00753c48, "int") * aspect) "`n")		
		AR1 := ""
		AR2 := ""
		;AR1 := new CodeInjection(h_game, 0x00402588, memlib_String2Bytearray("B8 " trim(memlib_Number2String(HRes, "int", False)))) ;works to
		AR1 := new CodeInjection(h_game, 0x0048f9ef, memlib_String2Bytearray("B8 " memlib_Number2String(HRes, "int", False) "99"))
		soundplay, % AR1.switch()	
		AR2 := new CodeCave(h_game, 0x0048fA4b,  memlib_String2Bytearray("68 " memlib_Number2String(HRes, "int", False) "DB 04 24 83 C4 04"))
		soundplay, % AR2.switch()
	} else {
		HRes := round(read_process_memory(h_game, 0x0055D204, "int") * aspect)
		while not HRes {
			sleep, 100
			HRes := round(read_process_memory(h_game, 0x0055D204, "int") * aspect)
		}
		(HRes = 1023) ? HRes := 1024
		print("->" HRes "`n")
		AR1 := ""
		AR1 := new CodeInjection(h_game, 0x0048EDF4, memlib_String2Bytearray("B8 " memlib_Number2String(HRes, "int", False) "99"))
		soundplay, % AR1.switch()
	}
return	

;REMOTE SCRIPT START

;fix TR4 crashing in windowed mode
;(g_.cfg.target_name = "tomb4.exe" ) ? logerr(InstallHook("SetWindowLong", pSetWindowLong, "User32.dll", "SetWindowLongW") " <- 0 means no error")
;g_.pSetWindowLong := pSetWindowLong

g_.surfacehooks := True 
logerr(IDirect3DDevice3.Hook("BeginScene"))
logErr(IDirect3DDevice3.dllHook("DrawPrimitive", "DrawPrimitive3Hook"))

D3DHOOKS_DATA.p_DrawPrimitive := IDirect3DDevice3.DrawPrimitive
D3DHOOKS_DATA.pCallback := registercallback("drawPrimitiveCallback3", "F")
;D3DHOOKS_DATA.callback := false 
D3DHOOKS_DATA.displace := False
D3DHOOKS_DATA.scale := 1

g_.cfg.target_name = "tomb4.exe" 
? g_.tr4_inv_add := 0x536f1c	: g_.tr4_inv_add := 0x87B81C	

g_.cfg.target_name = "tomb4.exe" 
? g_.tr4_on_inv := 0x4bf3c8	: g_.tr4_on_inv := 0x87B81C	

if g_.cfg.create_links
{
	links := ["savegame.0"]
	loop, 14
		links.insert("savegame." A_index)
	CreateLinksCollection(links)
}	

g_.cfg.target_name = "tomb4.exe" 
? redirectCall(0x00479f2d, "InventoryAcess", "F CDecl") : redirectCall(0x004AC43D, "InventoryAcess5", "F CDecl") 

AltIDirect3DDevice3_BeginScene(p1)
{
	D3DHOOKS_DATA.callback := false 
	numget(g_.tr4_on_inv, "uint") ? D3DHOOKS_DATA.callback := dllcall(IDirectDrawSurface4.Blt, uint, g_.rtrgt
					  , uint, RECT[], uint, g_.inv_background.Surface4, uint, _RECT[]
					  , uint, 0, uint, DDBLTFX[], uint)	+ 1						  
		
	r := dllcall(IDirect3DDevice3.BeginScene, uint, p1)
	return r
}

InventoryAcess5(p1) {
	InventoryAcess(False)
	return 
}

InventoryAcess(p1)
{
	DDBLTFX.dwSize := DDBLTFX.size()	
	if g_.primary4 
	{
		g_.inv_background := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary4),,D3DHOOKS_DATA.HD_W<<16 | D3DHOOKS_DATA.HD_H)		
		dllcall(IDirectDrawSurface4.Blt, uint, g_.inv_background.Surface4
					  , uint, 0, uint, g_.primary4, uint, 0
					  , uint, 0, uint, DDBLTFX[], uint)				
	}	
	return 
}	

DrawPrimitiveCallback3(pDevice3, vertice_size, n_vertices, pVertex)
{
	Texture := 0
	dllcall(IDirect3DDevice3.GetTexture, uint, pDevice3, uint, 0, "uint*", Texture)
	if !Texture 
		return True
	else dllcall(IDirect3DTexture2.release, uint, Texture)	
	return 0
}

AltIDirectDraw4_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown)
{	
	D    := struct(DDSURFACEDESC2)
	D[]  := pSurfaceDesc
	caps := D.ddsCaps.dwCaps
	if !(caps & DDSCAPS_TEXTURE) && (caps & DDSCAPS_SYSTEMMEMORY)
	{
		D   := struct(DDSURFACEDESC2)
		D[] := pSurfaceDesc
		D.ddsCaps.dwCaps &= ~ DDSCAPS_SYSTEMMEMORY
	}		
	if (r := IDirectDraw4_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown))
	return r	
	return r
}


AltCreateFileA(p1, p2, p3, p4, p5, p6, p7)
{
	static lastfmv := "dummy" 
	file           := strget(p1, "CP0")
	if instr(file, ".bik") and g_.cfg.NEFS
	{
		stringreplace, mp4, file, .bik, .mp4
		if fileexist(mp4)
		{
			if (file != lastfmv)
			{
				dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlccore.dll")
				dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlc.dll")		
				logerr("Vlc " dllcall("peixoto.dll\VlcDDrawPlay", ptr, 0, ptr, g_.proxies.fmvr[], astr, mp4, astr) errorlevel)
			}
			
			lastfmv := file
			return -1
		}			
	}
	;VarSetCapacity(stringU, strlen(file)*2)
	;strput(file, &stringU, "UTF-16")
	r := dllcall(g_fhks.pCreateFileA, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)		
	return r
}

