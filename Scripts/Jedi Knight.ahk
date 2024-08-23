h_game := Get_process_handle(g_.target_name)
if (g_.target_name = "JK.exe")
{
	;SetFormat, integer, hex
	r      := Desk()
	fov    := FOV(90., r.w ":" r.h)
	fovsig := "D9 59 38 8B 44 24 0C"
	fovadd := aobscan(h_game, get_process_ID("JK.exe"), "JK.exe", memlib_String2ByteArray(fovsig), "peixoto.dll")
	val    := memlib_Number2String(fov/90., "float")
	stringreplace, val, val, 0x, ,1
	code   := "D9 59 38 B8 C8 C2 8E 00 D9 00 C7 41 38 " val "D8 49 38 D9 C9 D9 59 38 D9 59 38 8B 44 24 0C"
	codeb  := "8B 44 24 04 50 D9 58 38 50 B8 C8 C2 8E 00 D9 00 58 C7 40 38 " val "D8 48 38 D9 C9 D9 58 38 D9 58 38"	
	
	print("add " fovadd "`n")
	print("fov " fov "`n")
	cave := new CodeCave(h_game, fovadd, memlib_String2ByteArray(code), 1)
	cave._enable()
	caveb := new CodeCave(h_game, 0x00443756, memlib_String2ByteArray(codeb), 2)
	caveb._enable()
		
	fix := "B9 00 00 48 43 89 8E F8 00 00 00 89 8E FC 00 00 00 89 8E 00 01 00 00 89 8E 04"
	. " 01 00 00 90 90 90 90 90 90 90 90 90 90 90 90 E8 D1 11 F6 FF 85 C0 74 5D B9 00 00 48"
	. " 43 89 8E 08 01 00 00 89 8E 0C 01 00 00 89 8E 10 01 00 00 89 8E 14 01 00 00 90 90 90"
	. " 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 E8 98 11 F6 FF 85 C0 74 24 B9 00 00"
	. " 48 43 89 8E 18 01 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 E8 74 11 F6"
	. " FF 85 C0 75 04 33 C0 5E C3 B9 00 00 48 43 89 8E 1C 01 00 00 90 90 90 90 90 90 90 90"
	. " 90 90 90 90 90 90 90 90"
	add := aobscan(h_game, get_process_ID("JK.exe"), "JK.exe", memlib_String2ByteArray("8D 86 00 01 00 00 52 8D 8E FC"), "peixoto.dll")
}	else {
	r      := Desk()
	fov    := FOV(90., r.w ":" r.h)
	val    := memlib_Number2String(fov/90., "float")
	stringreplace, val, val, 0x, ,1
	code   := "D9 59 38 B8 6C 1B 9D 00 D9 00 C7 41 38 " val "D8 49 38 D9 C9 D9 59 38 D9 59 38 8B 44 24 0C"
	cave := new CodeCave(h_game, 0x00447AF1, memlib_String2ByteArray(code), 1)
	cave._enable()
	
	codeb   := "8B 44 24 04 50 50 D9 58 38 B8 6C 1B 9D 00 D9 00 58 C7 40 38 " val "D8 48 38 D9 C9 D9 58 38 D9 58 38"
	caveb := new CodeCave(h_game, 0x00447C46, memlib_String2ByteArray(codeb), 2)
	caveb._enable()
	
	
	print("fov " fov "`n")	
	
	fix := "B9 00 00 48 43 89 8E F8 00 00 00 89 8E FC 00 00 00 89 8E 00 01 00 00 89 8E 04 01"
	. " 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 E8 91 66 F1 FF 85 C0 74 5D"
	. " B9 00 00 48 43 89 8E 08 01 00 00 89 8E 0C 01 00 00 89 8E 10 01 00 00 89 8E 14 01 00 00"
	. " 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 E8 58 66 F1 FF 85 C0 74 24 B9" 
	. " 00 00 48 43 89 8E 18 01 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 E8 34 66"
 	. " F1 FF 85 C0 75 04 33 C0 5E C3 B9 00 00 48 43 89 8E 1C 01 00 00 90 90 90 90 90 90 90 90"
	. " 90 90 90 90 90 90 90 90"
	add := aobscan(h_game, get_process_ID("JKM.exe"), "JKM.exe", memlib_String2ByteArray("8D 96 04 01 00 00 8D 86 00 01 00 00"), "peixoto.dll")
}
print("Mips " add "`n")
write_process_memory(h_game, add, "array", memlib_String2ByteArray(fix))
return

;REMOTE SCRIPT START

InitJKHooks()
InitJKHooks()
{
	(g_.cfg.target_name = "JKM.EXE") ? logerr(IDirect3DDevice.Hook("BeginScene")) 
	D3DHOOKS_DATA.BltPrimary      := RegisterCallback("AltIDirectDrawSurface_blt", "F")

	;logerr("D3D_DDI_Setrenderstate " InstallHook("D3D_DDI_Setrenderstate", p, "peixoto.dll", "D3D_DDI_Setrenderstate"))
	g_.s.ddi_srstt := p
	g_.s.rstt      := struct("DWORD stt, val;")
	dllcall("peixoto.dll\D3DDDI_Init", astr, "COLORKEYFIX", uint, 1)	
}

D3D_DDI_Setrenderstate(p1, p2)
{
	g_.s.rstt[] := p2
	if (g_.s.rstt.stt = 41)
	return
	return dllcall(g_.s.ddi_srstt, ptr, p1, ptr, p2)	
}

AltIDirect3DDevice_BeginScene(p1)
{
	if 	(numget(0x9D1B6C+0, "float") > 91)
	{
		numput(90, 0x9D1B6C+0, "float")
	}
	return dllcall(IDirect3DDevice.BeginScene, uint, p1)
}

AlIDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{
	D    := struct(DDSURFACEDESC)
	D[]  := pSurfaceDesc
	
	if (g_.cfg.32Z && (D.ddsCaps.dwCaps & DDSCAPS_ZBUFFER))
	D.dwZBufferBitDepth := 24 	
	
	r := IDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
	if r and (D.ddsCaps.dwCaps & DDSCAPS_ZBUFFER)
	{
		logerr("Failed to create a " D.dwZBufferBitDepth " bit Zbuffer " r ": " ddraw.err[r . ""])					
		logerr("Attempting 24 bit Zbuffer")
		
		D.dwZBufferBitDepth := 24 
		r                   := IDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown) 
		logerr(r ? "Failed" : "Success")			
	}		
	return r	
}

AltIDirectDrawSurface_blt(p1, p2, p3, p4, p5, p6)
{	
    if (g_.cfg.layer)
        return Surface1Blt(p1, p2, p3, p4, p5, p6)	
	if (caps := GetSurfaceCaps(p1) & DDSCAPS_ZBUFFER) && (p5 & DDBLT_DEPTHFILL)
	{
		g_HD.ZBLTFX[] := p6
		vw1 := 0
		vw3 := 0
		if (g_.device)
		{
			dllcall(IDirect3DDevice.NextViewport, uint, g_.device, uint, 0, "uint*", vw1:=0, uint, D3DNEXT_HEAD)
			GUID_FromString(iid, d3d.IID_IDirect3DViewport3)
			z := dllcall(IDirect3DViewport.QueryInterface, uint, vw1, ptr, &iid, "ptr*", vw3:=0, uint)
			d := g_HD.ZBLTFX.dwFillDepth/D3DHOOKS_DATA.zmsk
			r := dllcall(IDirect3DViewport3.Clear2, uint, vw3, uint, 1, uint, RECT[], uint, 2, uint, 0, float, d, float, 0.)
			dllcall(IDirect3DViewport3.Release, uint, vw3)
			dllcall(IDirect3DViewport.Release, uint, vw1)
			return
		}				
	} 
	r := Surface1Blt(p1, p2, p3, p4, p5, p6)	
	return r	
}