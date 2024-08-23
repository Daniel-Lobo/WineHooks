if instr(g_.target_name, "2")
{
	h_game := Get_process_handle(g_.target_name)
	print()
	for k, v in get_modules_list(get_process_ID(g_.target_name))
	{
		if (v.name = "TR2Main.dll")
		{
			print("Widescreen disabled`n")
			return
		}
	}
	
	if g_.target_name = "Tomb2.exe"
	{
		h_res := 0x0047031c	
	} else {
		h_res := 0x0047334c	
	}	
	goto wide

	~Tab::
		wide:
		aspect := (g_.PSXAspect) ? 320/200 * 3/4 : 4/3
		HRes := round(read_process_memory(h_game, h_res, "int") * aspect)
		while not (HRes > 0)
			HRes := round(read_process_memory(h_game, h_res, "int") * aspect)
		print("->" round(read_process_memory(h_game, 0x0047031c, "int") * 4/3) "`n")
		AR1 := ""
		AR2 := ""
		;AR1 := new CodeInjection(h_game, 0x00402588, memlib_String2Bytearray("B8 " trim(memlib_Number2String(HRes, "int", False)))) ;works to
		AR1 := new CodeInjection(h_game, 0x00402588, memlib_String2Bytearray("B8 " memlib_Number2String(HRes, "int", False) "99"))
		soundplay, % AR1.switch()	
		AR2 := new CodeCave(h_game, 0x004025df,  memlib_String2Bytearray("68 " memlib_Number2String(HRes, "int", False) "DB 04 24 83 C4 04"))
		soundplay, % AR2.switch()			
	return
} else {

	h_game := Get_process_handle(g_.target_name)
	print()
	Hotkey, ~tab, Tab3, on

	if g_.target_name = "Tomb3.exe"
	{
		v_res := 0x004D790C
		projection_add  := 0x004020ae
		viewpot_add     := 0x00402048		
	} else {
		v_res           := 0x004D07FC
		projection_add  := 0x0040207E
		viewpot_add     := 0x00402018	
	}

	sleep, 2000
	gosub wide3

	Tab3:	
		wide3:
		aspect := (g_.PSXAspect) ? 320/200 * 3/4 : 4/3
		HRes := round(read_process_memory(h_game, v_res, "int") * aspect)
		while not (HRes > 0)
			HRes := round(read_process_memory(h_game, v_res, "int") * aspect)
		print("->" round(read_process_memory(h_game, 0x0047031c, "int") * 4/3) "`n")
		print("Hres" hres "`n")
		projection := ""
		viewport := ""
		projection := new CodeCave(h_game, projection_add,  memlib_String2Bytearray("68 " memlib_Number2String(HRes, "int", False) "DB 04 24 83 C4 04"))
		soundplay, % projection.switch()	
		viewport := new CodeInjection(h_game, viewpot_add, memlib_String2Bytearray("B8 " trim(memlib_Number2String(HRes, "int", False))))
		soundplay, % viewport.switch()		
	return
}


;REMOTE SCRIPT START

logerr("libvlccore.dll " dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlccore.dll") " " errorlevel)
logerr("libvlc.dll     " dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlc.dll") " "     errorlevel)
logerr("TR2Main.dll    " dllcall("GetModuleHandleA", astr, "TR2Main.dll") " "     errorlevel)
loop, fmv\*.*
	logerr(A_LoopFileName)

D3DHOOKS_DATA.LockPrimary := RegisterCallback("Alt_lock", "F")
g_.s                      := {}
g_.s.TLVertex := struct("float x; float y; float z; float rhw; DWORD clr; DWORD spec; float u; float v;")

if instr(g_.cfg.target_name, "2")
{
	regread, music_volume, HKCU, SOFTWARE\Core Design\Tomb Raider II\Game, MusicVolume
	if (music_volume > 10)
		regwrite, REG_DWORD, HKCU,SOFTWARE\Core Design\Tomb Raider II\Game, MusicVolume, 10
	
	regread, music_volume, HKCU, SOFTWARE\Core Design\Tomb Raider II Gold (Full Net)\Game, MusicVolume
	if (music_volume > 10)
		regwrite, REG_DWORD, HKCU,SOFTWARE\Core Design\Tomb Raider II Gold (Full Net)\Game, MusicVolume, 10
		
	logerr(IDirect3DDevice2.Hook("BeginScene", "TR2_BeginScene"))	
	D3DHOOKS_DATA.pCallback   := registercallback("TR2_DrawPrim", "F")
	
	if (g_.cfg.target_name = "tomb2.exe")
	{
		g_.tr2_inv_add := 0x004D7968
		g_.tr2_title := 0x004D7E78
		g_.tr2_levelcomplete := 0x004D9EB4
		g_.tr2_level_add := 0x004D9EB0
	} else {
		g_.tr2_inv_add := 0x004DA998
		g_.tr2_title := 0x00524D30
		g_.tr2_levelcomplete := 0x004DCF28	
		print("gold")
	}	
}  else {
	
	D3DHOOKS_DATA.pCallback  := registercallback("TR3_DrawPrim", "F")
	D3DHOOKS_DATA.BltPrimary := RegisterCallback("Alt_blt", "F")
	logerr(IDirect3DDevice2.Hook("BeginScene", "TR3_BeginScene"))	
	if (g_.cfg.target_name = "tomb3.exe")
	{				
		g_.s.inv            := 0x006a1bac			
	} else {		
		g_.s.inv            := 0x6291a4
	}
}
DEVICE2_RECT.BeginScene     := IDirect3DDevice2.BeginScene
g_.s.fmv := []

AltIDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{
	DDSURFACEDESC[] := pSurfaceDesc
	if ((DDSURFACEDESC.ddsCaps.dwCaps & DDSCAPS_PRIMARYSURFACE) and !g_.cfg.NEFS)
	{
		if (g_.s.fmv.Length())
		{
			dllcall(IDirectDraw2.SetCooperativeLevel, uint, pIDirectDraw, uint, g_.hwin, uint, DDSCL_NORMAL)			
			dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlccore.dll")
			dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlc.dll")
			for k, v in g_.s.fmv
				logerr("Vlc " dllcall("peixoto.dll\VlcDDrawPlay", ptr, 0, ptr, g_.proxies.fmvr[], astr, v, astr) errorlevel)
			g_.s.fmv := []
			dllcall(IDirectDrawSurface.blt, uint, g_.rtrgt, uint, 0, uint, 0, uint, 0, uint, DDBLT_COLORFILL, uint, DDBLTFX[], uint)
			f := g_.fllscrn ? DDSCL_FULLSCREEN|DDSCL_EXCLUSIVE : DDSCL_NORMAL
			dllcall(IDirectDraw2.SetCooperativeLevel, uint, pIDirectDraw, uint, g_.hwin, uint, f)
		}			
	}	
	r := IDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
	if (r)
		return r
	
    if ((DDSURFACEDESC.ddsCaps.dwCaps & DDSCAPS_PRIMARYSURFACE) and g_.cfg.NEFS)
	{
		dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlccore.dll")
		dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlc.dll")
		for k, v in g_.s.fmv
			logerr("Vlc " dllcall("peixoto.dll\VlcDDrawPlay", ptr, 0, ptr, g_.proxies.fmvr[], astr, v, astr) errorlevel)
		g_.s.fmv := []
		dllcall(IDirectDrawSurface.blt, uint, g_.rtrgt, uint, 0, uint, 0, uint, 0, uint, DDBLT_COLORFILL, uint, DDBLTFX[], uint)		
	}  	
	return r
}

TR2_BeginScene(p1)
{
	static inv_prev, levelcomplete_prev, blt
	inInventory   := numget(g_.tr2_inv_add+0, "uint")	
	title         := numget(g_.tr2_title+0, "uint")
	levelcomplete := numget(g_.tr2_levelcomplete+0, "uint")
	g_.tr2_level  := numget(g_.tr2_level_add+0, "uint")	
	
	if (inInventory) and not levelcomplete    
	{
		if (not inv_prev and not title and not levelcomplete and not levelcomplete_prev) 	
		{
			g_.background := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary),, D3DHOOKS_DATA.HD_W<<16 | D3DHOOKS_DATA.HD_H)	
			blt := dllcall(IDirectDrawSurface.Blt, uint, g_.background.Surface, uint, _RECT[], uint, g_.primary
			                                     , uint, _RECT[], uint, 0, uint, DDBLTFX[], uint)	
			printl("blt " blt ddraw.result[blt . ""])				
		}			
		blt := dllcall(IDirectDrawSurface.Blt, uint, g_.rtrgt, uint, RECT[], uint, g_.background.Surface
		                                     , uint, _RECT[], uint, 0, uint, DDBLTFX[], uint)					
	}	
	inv_prev := inInventory
	levelcomplete_prev := levelcomplete	
	
	D3DHOOKS_DATA.callback := False
	if (inInventory and not title)  and blt = 0
		D3DHOOKS_DATA.callback := True		
	return dllcall(IDirect3DDevice2.BeginScene, uint, p1, uint)
}

TR2_DrawPrim(pDevice2, n_vertices, pVertices)
{
	static TL_VERTEX := struct("float x; float y; float z; float rhw; DWORD color; DWORD specular; float u; float v;") 
	TL_VERTEX[] := pVertices
	if (TL_VERTEX.z > 0.99) 
		return true		
	else if (TL_VERTEX.z > 0.1) and (TL_VERTEX.z < 0.99) and g_.tr2_level = 8 
	{
		loop, % n_vertices
		{
			TL_VERTEX.y := D3DHOOKS_DATA.HD_H - TL_VERTEX.y	
			TL_VERTEX[] += TL_VERTEX.size()	
		}	
	} return 	
}

TR3_BeginScene(p1)
{
	static inv_prev := 1
	inv             := (g_.s.inv) ? numget(g_.s.inv, "uint") : 0
		
	if (inv = 1) and g_.s.blted
	{
		if (inv != inv_prev)
		{
			g_.s.BckGrnd  := new Surface(dllcall(g_.p.DDFrmSrfc, uint, g_.primary),, D3DHOOKS_DATA.HD_W<<16 | D3DHOOKS_DATA.HD_H)						 
			blt := dllcall(IDirectDrawSurface.Blt, uint, g_.s.BckGrnd.Surface, uint, _RECT[], uint, g_.primary
			                                     , uint, _RECT[], uint, DDBLTFAST_NOCOLORKEY, uint, DDBLTFX[], uint)	
			printl("blt " blt ddraw.result[blt . ""] " " inv " " )			
		}			
		blt := dllcall(IDirectDrawSurface.Blt, uint, g_.rtrgt, uint, RECT[], uint, g_.s.BckGrnd.Surface
		                                     , uint, _RECT[], uint, DDBLTFAST_NOCOLORKEY, uint, DDBLTFX[], uint)				
	} else if inv_prev and !inv 
		g_.s.blted := 0	
		
	D3DHOOKS_DATA.callback := False
	if (inv = 1) and g_.s.blted 
		D3DHOOKS_DATA.callback := True			
		
	inv_prev := inv			
	return dllcall(IDirect3DDevice2.BeginScene, uint, p1, uint)
}

TR3_DrawPrim(pDevice2, n_vertices, pVertices)
{
	static TL_VERTEX := struct("float x; float y; float z; float rhw; DWORD color; DWORD specular; float u; float v;") 
	TL_VERTEX[] := pVertices
	if (TL_VERTEX.z > 0.99) 
		return true			
}

Alt_Blt(p1, p2, p3, p4, p5, p6)	
{
	if p3
	{
		if ( GetSurfaceCaps(p3) & DDSCAPS_PRIMARYSURFACE)
		g_.s.blted := True		
	}
	return Surface1Blt(p1, p2, p3, p4, p5, p6)				
}

Alt_lock(p1, p2, p3, p4, p5)
{
	c := GetSurfaceCaps(p1)
	if (c & DDSCAPS_PRIMARYSURFACE) and !g_.rtrgt 
	{
		g_.proxies.FMV := True		 			
	} 
	else if (c & DDSCAPS_PRIMARYSURFACE) 
	{
		 g_.s.blted    := True
	} 
	else 
	{
		g_.proxies.FMV := 0	
	}		
	r := Surface1Lock(p1, p2, p3, p4, p5)	
}

AltCreateFileA(p1, p2, p3, p4, p5, p6, p7)
{
	file := strget(p1, "CP0")	
	if instr(file, ".rpl") && ! dllcall("GetModuleHandleA", astr, "TR2Main.dll")
	{
		logerr("FMV: " file)
		g_.proxies.fmvs  := D3DDDI_CreatePixelShader(G_D3DDDI.shader_code, "LineDoubling")
		mp4              := StrReplace(file, ".rpl", ".mp4")
		if ! fileexist(mp4)
		mp4              := StrReplace(file, ".rpl", ".bik")
		if fileexist(mp4)
		{ 
			logerr("Found: " mp4)
			g_.s.fmv.insert( mp4 )
			return -1			
		}				
	}	
	r := dllcall(g_fhks.pCreateFileA, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)		
	return r
}

AltMciSendStringA(p1, p2, p3, p4)
{
	static msg:=0, tracks, _from, _cmd, MCI:="MciSendStringA"
	cmd := strget(p1+0, "CP0")
	if instr(cmd, "open")
	{
		VarSetCapacity(_cmd, 260)		
		if ! isobject(tracks)
		{
			tracks := []
			fileread, info, audio\cdaudio.dat 	
			logerr(info)
			loop, Parse, info, `n`r
			{
				nfo    := strsplit(A_LoopField, " ")
				tracks[nfo[1]] := {"t" : nfo[1], "s" : nfo[2], "e": nfo[3]}
			}
		}
	}		 	
	else if instr(cmd, "play")
	{
		from := strsplit(strsplit(cmd, "from ")[2], " ")[1] 
		to   := strsplit(strsplit(cmd, "to ")[2], " ")[1] 
		for k, v in tracks
		{
			if (v.s = from)
				_from  := k
			if (v.s = to)
				_to    := k
		}
		logerr("Play from " _from " to " _to)
		StringReplace, cmd, cmd, %from%, %_from%
		StringReplace, cmd, cmd, %to%, %_to%
		StrPut(cmd, &_cmd, "CP0")		
		return %MCI%(&_cmd, p2, p3, p4)
	}
	else if instr(cmd, "position")
    {
		;printl("->" _from "..." tracks[_from].s)
        p := tracks[_from].s
        strput(p, p2+0, "CP0")
		return 0
    }
	return %MCI%(p1, p2, p3, p4)
}
