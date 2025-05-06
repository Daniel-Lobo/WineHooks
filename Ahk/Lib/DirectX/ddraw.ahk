#include lib\DirectX\headers\_ddraw.h.ahk
#include lib\DirectX\headers\_d3D.h.ahk

/*
Surface3: Directshow
DirectX3 - DirectDraw2, Surface2, Direct3D, 3DDevice, ExecuteBuffer, Viewport, Texture, Material, Direct3DLight
DirectX5 - DirectDraw, Surface, Direct3D2, 3DDevice2, no Excutebuffer, Viewport2, Texture2, Material2, Lights?
DirectX6 - DirectDraw4, Surface4, Direct3D3, 3DDevice3, VertexBuffer, Viewport3, Texture2, Material3, Lights?
*/

global IDirectDrawSurface3="", IDirectDrawClipper="", IDirectDrawPalette=""
, IDirectDraw="", IDirectDrawSurface="", IDirectDrawGammaControl=""
, IDirectDraw2="", IDirectDrawSurface2=""								    	
, IDirectDraw4="", IDirectDrawSurface4=""
, IDirect3D="", IDirect3DDevice="", IDirect3DExecuteBuffer="", IDirect3DViewPort="", IDirect3DTexture=""                            
, IDirect3D2="", IDirect3DDevice2="", IDirect3DViewPort2="", IDirect3DTexture2=""       													    	
, IDirect3D3="", IDirect3DDevice3="", IDirect3DViewPort3="", IDirect3DVertexBuffer=""
, IDirectDraw7="", IDirectDrawSurface7=""
, IDirect3D7="", IDirect3dDevice7="", IDirect3DVertexBuffer7=""

SetPixelFormat(byref desc, format = "")
{
	(format = "") ? format := (D3DHOOKS_DATA.D=16) ? "RG6B" : (D3DHOOKS_DATA.D=8) ? "PAL8" : "X8RGB"
	desc.ddpfPixelFormat.dwSize := DDPIXELFORMAT.size()
	return dllcall(g_.p.SetDDSPxFmt, uint, desc[]+desc.Offset("ddpfPixelFormat"), astr, format)	
}	

GetPixelFormat(byref desc)
{
	if (desc.ddpfPixelFormat.dwRGBBitCount = 32)
	{
		if desc.ddpfPixelFormat.dwRBitMask = 0x00FF0000
			return (desc.ddpfPixelFormat.dwFlags & DDPF_ALPHAPIXELS) ? "A8RGB" : "X8RGB"
		else if desc.ddpfPixelFormat.dwRBitMask = 0x000000FF
			return (desc.ddpfPixelFormat.dwFlags & DDPF_ALPHAPIXELS) ? "A8BGR" : "X8BGR"
	}
	else if (desc.ddpfPixelFormat.dwRGBBitCount = 16)
	{
		if (desc.ddpfPixelFormat.dwFlags & DDPF_RGB)
		{
			if (desc.ddpfPixelFormat.dwRBitMask = 0xF800)
				return "RG6B"
			else if (desc.ddpfPixelFormat.dwRBitMask = 0x00007C00)
				return (desc.ddpfPixelFormat.dwFlags & DDPF_ALPHAPIXELS) ? "A1RGB" : "X1RGB"	
			else if (desc.ddpfPixelFormat.dwRBitMask = 0xf00)
				return "A4RGB"
		} else if (desc.ddpfPixelFormat.dwFlags & DDPF_BUMPDUDV)
			return (desc.ddpfPixelFormat.dwFlags & DDPF_BUMPLUMINANCE) ? "L6V5U5 - Unsupported" : "V8U8"		
	}
	else if (desc.ddpfPixelFormat.dwRGBBitCount = 8)
		return "PAL8"
	else if (desc.ddpfPixelFormat.dwFlags & DDPF_FOURCC)
	{
		VarSetCapacity(fmt, 4, 0)
		Numput(desc.ddpfPixelFormat.dwFourCC, &fmt, "uint") 		
		return strget(&fmt, "Cp0", 4)
	}
	return "Unknown"
}

LoadTexture(pInterface, pDevice, file_, mip="")
{	
	pTexture  := 0, hText := 0
	pTexture2 := LoadTexture2(pInterface, "", file_, mip)
	GUID_FromString(idd_texture, d3d.IID_IDirect3DTexture)
	r := dllcall(IDirect3DTexture2.QueryInterface, uint, pTexture2, ptr, &idd_texture, "ptr*", pTexture, uint)
	printl("Texture Load Texture: " r " " ddraw.err[r . ""])
	dllcall(IDirect3DTexture2.release, uint, pTexture2)
	s := dllcall(IDirect3DTexture.GetHandle, uint, pTexture, uint, pDevice, "uint*", hText, uint)
	printl("Texture hwnd: "	s " " ddraw.err[s . ""] errorlevel " " pTexture " " g_tswap.device " " hText)	
	return pTexture
}	

LoadTexture2(pInterface, pDevice, file_, mip="")
{
	pSurface:=0, pSysMem:=0, hFile:=0, pTexture:=0, hText:=0
														 
	(desc:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
	pixelformat         := OpenDDS(file_, hFile)	
	desc.dwSize         := DDSURFACEDESC.size()
	desc.dwFlags        := DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT 
	desc.dwWidth        := DDS_HEADER.dwWidth 
	desc.dwHeight       := DDS_HEADER.dwHeight		
	desc.ddsCaps.dwCaps := DDSCAPS_VIDEOMEMORY | DDSCAPS_TEXTURE
	SetPixelFormat(desc, pixelformat)	
	
	if mip
	{
		k := dllcall(g_.p.c2c, astr, mip.f, astr, pixelformat, uint, numget(mip.k+0, "uint"), uint)
		logerr("colorkey " k " : " mip.f)
		desc.dwFlags |= DDSD_CKSRCBLT 
		desc.ddckCKSrcBlt.dwColorSpaceLowValue  := k
		desc.ddckCKSrcBlt.dwColorSpaceHighValue := k
	}
	
	(DDS_HEADER.dwFlags & 0x20000) ? desc.ddsCaps.dwCaps |= DDSCAPS_MIPMAP | DDSCAPS_COMPLEX	
	if (r := dllcall(IDirectDraw.CreateSurface, uint, pInterface, uint, desc[], "ptr*", pSurface, uint, 0, uint))
	{
		if ddraw.err[r . ""] = "DDERR_OUTOFVIDEOMEMORY"
		{
			logerr("Failed to load texture : " r " " ddraw.err[r . ""])
			return
		} 
		desc.ddsCaps.dwCaps      := DDSCAPS_VIDEOMEMORY | DDSCAPS_TEXTURE
		DDS_HEADER.dwMipMapCount := 0
		r := dllcall(IDirectDraw.CreateSurface, uint, pInterface, uint, desc[], "ptr*", pSurface, uint, 0, uint)
	}
	printl("Texture Load Surface: "	r " " ddraw.err[r . ""])
	
	desc.dwFlags        := DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT 
	desc.ddsCaps.dwCaps := DDSCAPS_SYSTEMMEMORY | DDSCAPS_TEXTURE
	(DDS_HEADER.dwMipMapCount > 0) ? desc.ddsCaps.dwCaps |= DDSCAPS_MIPMAP | DDSCAPS_COMPLEX
	SetPixelFormat(desc, pixelformat)
	r := dllcall(IDirectDraw.CreateSurface, uint, pInterface, uint, desc[], "ptr*", pSysMem, uint, 0, uint)
	printl("Texture Load SMSurface: " A_index " " desc.dwWidth "x" desc.dwHeight " " r " " ddraw.err[r . ""])			
	
	dllcall(IDirectDrawSurface.AddRef, uint, slevel := pSysMem)	
	dllcall(IDirectDrawSurface.AddRef, uint, level := pSurface)
	
	loop
	{			
		r := dllcall(IDirectDrawSurface.Lock, uint, slevel, uint, 0, uint, desc[], uint, DDLOCK_WRITEONLY, uint, 0, uint)
		printl("Texture Load Lock: " A_index " " r " " ddraw.err[r . ""])
		
		if instr(pixelformat, "DXT")
			dllcall("ReadFile", uint, hFile, uint, desc.lpSurface, uint, desc.lpitch, "uint*", (rd:=0), uint, 0)	
		else
		{			
			pitch     := desc.lpitch
			pSurfdata := desc.lpSurface
			hLines    := desc.dwHeight		
									 
			if (r:= dllcall(g_.p.LoadSurfData, uint, pSurfdata, uint, hFile, uint, pitch, uint, desc.dwWidth
											 , uint, hLines, uint, DDS_HEADER.ddspf.dwRGBBitCount/8))
			{
				logerr("Texture Load - Copy " r)
				size := desc.dwWidth*DDS_HEADER.ddspf.dwRGBBitCount/8
				loop, % hLines 
					dllcall("ReadFile", uint, hFile, uint, pSurfdata + pitch * (A_index-1), uint, size, "uint*", (rd:=0), uint, 0)			
			}			
		}		
			
		r := dllcall(IDirectDrawSurface.UnLock, uint, slevel, uint, desc.lpSurface, uint)
		printl("Texture Load UnLock: " r " " ddraw.err[r . ""])	
		
		r := dllcall(IDirectDrawSurface.Blt, uint, level, uint, 0, uint, slevel, uint, 0, uint, 0, uint, 0, uint)
			
		cps  := DDSCAPS_TEXTURE | DDSCAPS_MIPMAP
		next := 0

		sbrk := dllcall(IDirectDrawSurface.GetAttachedSurface, uint, slevel, "uint*", cps, "uint*", snext := 0)
		brk  := dllcall(IDirectDrawSurface.GetAttachedSurface, uint, level, "uint*", cps, "uint*", next := 0)
		slevel ? dllcall(IDirectDrawSurface.Release, uint, slevel)			
		level  ? dllcall(IDirectDrawSurface.Release, uint, level)
		
		if brk or sbrk		
			break
		level  := next
		slevel := snext
		desc.dwWidth  /= 2
		desc.dwHeight /= 2					
	}	
	dllcall("CloseHandle", uint, hFile)	
	pSysMem ? dllcall(IDirectDrawSurface.Release, uint, pSysMem)
		
	GUID_FromString(idd_texture, d3d.IID_IDirect3DTexture2)
	r := dllcall(IDirectDrawSurface.QueryInterface, uint, pSurface, ptr, &idd_texture, "ptr*", pTexture, uint)
	printl("Texture Load Texture: " r " " ddraw.err[r . ""] " " pTexture)
	
	if pDevice  
	{
		s := dllcall(IDirect3DTexture2.GetHandle, uint, pTexture, uint, pDevice, "uint*", hText, uint)
		printl("Texture hwnd: "	s " " ddraw.err[s . ""] errorlevel " " pTexture " " g_tswap.device " " hText)
	}	
	
	dllcall(IDirectDrawSurface.release, uint, pSurface)
	return pTexture
}

LoadSurface7(f, s, ck="")
{
	p                 := OpenDDS(f, hF)	
	d                 := struct(DDSURFACEDESC2)
	d.dwSize          := DDSURFACEDESC2.size()
	d.dwFlags         := DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT 
	d.dwWidth         := DDS_HEADER.dwWidth 
	d.dwHeight        := DDS_HEADER.dwHeight		
	d.ddsCaps.dwCaps  := DDSCAPS_TEXTURE 
	d.ddsCaps.dwCaps2 := DDSCAPS2_TEXTUREMANAGE
	SetPixelFormat(d, p)	
	(DDS_HEADER.dwFlags & 0x20000) ? d.ddsCaps.dwCaps |= DDSCAPS_MIPMAP | DDSCAPS_COMPLEX	
	
	dllcall(IDirectDrawSurface7.GetDDInterface, uint, s, "Uint*", dd7:=0)
	dd7 ? dllcall(IDirectDraw7.release, uint, dd7)	
	
	if ck
	{
		k := dllcall(g_.p.c2c, astr, ck.f, astr, p, uint, numget(ck.k+0, "uint"), uint)
		logerr("colorkey " k " : " ck.f)
		d.dwFlags |= DDSD_CKSRCBLT 
		d.ddckCKSrcBlt.dwColorSpaceLowValue  := k
		d.ddckCKSrcBlt.dwColorSpaceHighValue := k
	}
	
	if (r := dllcall(IDirectDraw7.CreateSurface, uint, dd7, uint, d[], "ptr*", S7:=0, uint, 0, uint))
	{
		d.ddsCaps.dwCaps := DDSCAPS_TEXTURE 
		r := dllcall(IDirectDraw7.CreateSurface, uint, dd7, uint, d[], "ptr*", S7, uint, 0, uint)
	}
	printl("Texture Load Surface: "	r " " ddraw.err[r . ""])
	
	dllcall(IDirectDrawSurface7.AddRef, uint, lvl := S7)	
	loop
	{			
		r := dllcall(IDirectDrawSurface7.Lock, uint, lvl, uint, 0, uint, d[], uint, DDLOCK_WRITEONLY, uint, 0, uint)
		printl("Texture Load Lock: " A_index " " r " " ddraw.err[r . ""])
		
		if instr(p, "DXT")
			dllcall("ReadFile", uint, hF, uint, d.lpSurface, uint, d.lpitch, "uint*", (rd:=0), uint, 0)	
		else
		{			
			pitch     := d.lpitch
			pSurfdata := d.lpSurface
			hLines    := d.dwHeight		
									 
			if (r:= dllcall(g_.p.LoadSurfData, uint, pSurfdata, uint, hf, uint, pitch, uint, d.dwWidth
											 , uint, hLines, uint, DDS_HEADER.ddspf.dwRGBBitCount/8))
			{
				logerr("Texture Load - Copy " r)
				size := d.dwWidth*DDS_HEADER.ddspf.dwRGBBitCount/8
				loop, % hLines 
					dllcall("ReadFile", uint, hf, uint, pSurfdata + pitch * (A_index-1), uint, size, "uint*", (rd:=0), uint, 0)			
			}			
		}		
			
		r := dllcall(IDirectDrawSurface7.UnLock, uint, lvl, uint, d.lpSurface, uint)
		printl("Texture Load UnLock: " r " " ddraw.err[r . ""])	
		
		VarSetCapacity(cps, 16)
		numput(DDSCAPS_TEXTURE|DDSCAPS_MIPMAP, &cps, "uint")
		brk := dllcall(IDirectDrawSurface7.GetAttachedSurface, uint, lvl, uint, &cps, "uint*", nxt := 0)
		dllcall(IDirectDrawSurface7.Release, uint, lvl)		
		if brk 	
			break
		lvl := nxt						
	}	
	dllcall("CloseHandle", uint, hF)
	return S7	
}

DumpSurface(pSurface, dest)
{
	(D:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
	r := dllcall(IDirectDrawSurface.Lock, uint, pSurface, uint, 0, uint, D[], uint, DDLOCK_READONLY|DDLOCK_WAIT, uint, 0, uint)
	print("Dump Lock " r  ddraw.err[r . ""] "`n")	
	fmt   := GetPixelFormat(D)
	if (fmt="DXT1")
		pitch := d.dwWidth*2
	else if instr(fmt, "D") 
		pitch := d.dwWidth*4
	else
		pitch :=  d.lPitch
	dllcall("peixoto.dll\DumpDDS", str, dest, astr, fmt, uint, d.dwWidth, uint, d.dwHeight
								 , ptr, d.lpSurface, uint, pitch) 
	dllcall(IDirectDrawSurface.UnLock, ptr, pSurface)								 
	print("Dump UnLock " r  ddraw.err[r . ""] "`n")	
}

WriteOnSurface(pSuf, txt, clr = 0xffffffff, x = 0, y = 0)
{	
	h_DC := 0
	c    := g_.cfg.D3D + 0
	i    := c = 7 ? IDirectDrawSurface7 : c = 3 ? IDirectDrawSurface4 : IDirectDrawSurface
	dllcall(i.GetDC, uint, pSuf, "uint*", h_DC, uint)	
	
	HORZRES := 8, VERTRES := 10	
	w := dllcall("GetDeviceCaps", uint, h_DC, uint, HORZRES, int)
	h := dllcall("GetDeviceCaps", uint, h_DC, uint, VERTRES, int)
	
	crds   := struct("DWORD x, y, w, h;")
	crds.x := x
	crds.y := y
	crds.w := w 
	crds.h := h 	
	
	dllcall("Gdi32.dll\SetBkMode", uint, h_DC, uint, 1)
	dllcall("Gdi32.dll\SetTextColor", uint, h_DC, uint, clr)
	dllcall("DPtoLP", uint, h_DC, uint, crds[], uint, 2)

	r :=  dllcall("DrawTextW", uint, h_DC, str, txt, int, -1, uint, crds[], uint, 0) 	
	dllcall(i.ReleaseDC, uint, pSuf, uint, h_DC, uint)
	return r	
}

DirectDrawCreate(software = False)
{
	if !(p := g_.p.DirectDrawCreate) 	
	{
		if !(p := dllcall("GetProcAddress", int, dllcall("LoadLibraryW", str, "ddraw.dll"), astr, "DirectDrawCreate"))
		return -1	
	}	
		
	if ( (r := dllcall(p, uint, 0, "ptr*", DD := "", int, 0, uint)) = 0)
	{
		if (g_.cfg.layer)
		{
			logerr("DDraw: " DD)
			DD := dllcall("Peixoto\WrappDDrawObject", ptr, DD, ptr)
			logerr("Wrapped: " DD)
		}
		IDirectDraw := new ComInterfaceWrapper(ddraw.IDirectDraw, DD, True)	
	}
	return r
}

GetDirectDraw(h_win = "")
{
	if not h_win
		h_win := A_scripthwnd 
	
	r := DirectDrawCreate(0)
	if (r != 0)
		return "Failed to create the IDirectDraw interface " r " - " ddraw.err[r . ""]
	
	pDDraw2:="", pDDraw4:="", pSurf:="", pSurface:="", pSurface2:="", pSurface3:="", pClipper="", pGamma:="", pPal:=""
	
	GUID_FromString(idd_ddraw2, ddraw.IID_IDirectDraw2)
	r := dllcall(IDirectDraw.QueryInterface, uint, IDirectDraw.p, uint, &idd_ddraw2, "uint*", pDDraw2, uint)
	Print("IDirectDraw2: " r  ":" ddraw.err[r . ""] "`n")	
	if r
		return "Failed to create the IDirectDraw2 Interface " r " - " ddraw.err[r . ""]	
	else IDirectDraw2 := new ComInterfaceWrapper(ddraw.IDirectDraw2, pDDraw2, True)
	
	GUID_FromString(idd_ddraw4, ddraw.IID_IDirectDraw4)
	r := dllcall(IDirectDraw.QueryInterface, uint, IDirectDraw.p, uint, &idd_ddraw4, "uint*", pDDraw4, uint)
	Print("IDirectDraw4: " r  ":" ddraw.err[r . ""] "`n")	
	if r
		return "Failed to create the IDirectDraw4 Interface " r " - " ddraw.err[r . ""]	
	else IDirectDraw4 := new ComInterfaceWrapper(ddraw.IDirectDraw4, pddraw4, True)
		
	(g_.cfg.DisableMaxWindowedMode) ?  logerr("CompatData " dllcall("ddraw.dll\SetAppCompatData", uint, 12, uint, 0) " " errorlevel)
	r := dllcall(IDirectDraw4.SetCooperativeLevel, ptr, IDirectDraw4.p, uint, h_win, uint, DDSCL_NORMAL, uint)
	Print("CoopLevel: " r  ":" ddraw.err[r . ""] "`n") 
	if r
		return "Failed to set the Cooperatve Level " r " - " ddraw.err[r . ""]	
		
	DDSURFACEDESC.dwsize                 := DDSURFACEDESC.size()
	DDSURFACEDESC2.dwSize                := DDSURFACEDESC2.size()		
	(D:= struct(DDSURFACEDESC2)).dwSize  := DDSURFACEDESC2.size()	
	D.dwFlags        := DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH ;| DDSD_PIXELFORMAT  
	D.ddsCaps.dwCaps := DDSCAPS_3DDEVICE | DDSCAPS_VIDEOMEMORY  
    D.dwWidth        := 640
	D.dwHeight       := 480
	SetPixelFormat(D, "X8RGB")
	r := dllcall(IDirectDraw4.CreateSurface, uint, IDirectDraw4.p, uint, D[]
										   , "uint*", pSurf, uint, 0, uint)
	if (r = DDERR_NODIRECTDRAWHW)
	{
		D.ddsCaps.dwCaps := 0 
		r := dllcall(IDirectDraw4.CreateSurface, uint, IDirectDraw4.p, uint, D[]
										       , "uint*", pSurf, uint, 0, uint)
	}
	Print("Surface4: " r  ":" ddraw.err[r . ""] "`n")	
	if r
		return "Failed to create the IDirectDrawSurface4 Interface " r " - " ddraw.err[r . ""]	
	else IDirectDrawSurface4 := new ComInterfaceWrapper(ddraw.IDirectDrawSurface4, pSurf, True)
		
	GUID_FromString(idd_surface, ddraw.IID_IDirectDrawSurface3)
	r := dllcall(IDirectDrawSurface4.QueryInterface, uint, IDirectDrawSurface4.p, uint, &idd_surface, "uint*", pSurface3, uint)
	Print("Surface3: " r  ":" ddraw.err[r . ""] "`n")
	if r
		return "Failed to create the IDirectDrawSurface3 Interface " r " - " ddraw.err[r . ""]	
	IDirectDrawSurface3 := new ComInterfaceWrapper(ddraw.IDirectDrawSurface3, pSurface3, True)
	
	GUID_FromString(idd_surface2, ddraw.IID_IDirectDrawSurface2)
	r := dllcall(IDirectDrawSurface4.QueryInterface, uint, IDirectDrawSurface4.p, uint, &idd_surface2, "uint*", pSurface2, uint)
	Print("Surface2: " r  ":" ddraw.err[r . ""] "`n")
	if r
		return "Failed to create the IDirectDrawSurface2 Interface " r " - " ddraw.err[r . ""]	
	IDirectDrawSurface2 := new ComInterfaceWrapper(ddraw.IDirectDrawSurface2, pSurface2, True)	
		
	GUID_FromString(idd_surface, ddraw.IID_IDirectDrawSurface)
	r := dllcall(IDirectDrawSurface4.QueryInterface, uint, IDirectDrawSurface4.p, uint, &idd_surface, "uint*", pSurface, uint)
	Print("Surface: " r  ":" ddraw.err[r . ""] "`n")
	if r
		return "Failed to create the IDirectDrawSurface Interface " r " - " ddraw.err[r . ""]	
	IDirectDrawSurface := new ComInterfaceWrapper(ddraw.IDirectDrawSurface, pSurface, True)
		
	GUID_FromString(idd_gamma, ddraw.IID_IDirectDrawGammaControl)
	r := dllcall(IDirectDrawSurface.QueryInterface, uint, IDirectDrawSurface.p, uint, &idd_gamma, "uint*", pGamma, uint)
	if r
		return "Failed to create the IDirectDrawGammaControl Interface " r " - " ddraw.err[r . ""]	
	IDirectDrawGammaControl := new ComInterfaceWrapper(ddraw.IDirectDrawGammaControl, pGamma, True)
					
	r := dllcall(IDirectDraw.CreateClipper, uint, IDirectDraw.p, uint, 0, "uint*", pClipper, uint, 0, uint)
	if r
		return "Failed to create the IDirectDrawCliper Interface " r " - " ddraw.err[r . ""]	
	IDirectDrawClipper := new ComInterfaceWrapper(ddraw.IDirectDrawClipper, pClipper, True)	
	
	VarSetCapacity(pal, 256*4)
	r := dllcall(IDirectDraw.CreatePalette, uint, IDirectDraw.p, uint, DDPCAPS_8BIT, ptr, &pal, "uint*", pPal, uint, 0, uint)
	if r
		return "Failed to create the IDirectDrawPalette Interface " r " - " ddraw.err[r . ""]	
	IDirectDrawPalette := new ComInterfaceWrapper(ddraw.IDirectDrawPalette, pPal, True)	
	
	return "Succeeded to create DirectDraw"
}

GetDirect3D()
{
	wine := dllcall("GetModuleHandle", "str",  "libwine.dll")
	
	pD3D:="", pViewPort:="", pTexture:="", pD3D2:="", pViewPort2:="", pTexture2:="", pD3D3:="", pViewPort3="", pVerTexBuffer:=""
	pDevice3:="", pDevice2:="", pDevice:="", pExecBuffer:=""
	
	device := d3d.IID_IDirect3DHALDevice
	GUID_FromString(idd_d3d, d3d.IID_IDirect3D)
	r := dllcall(IDirectDraw.QueryInterface, uint, IDirectDraw.p, uint, &idd_d3d, "uint*", pD3D, uint)
	print("Direct3D: " r ":" ddraw.err[r . ""] "`n")
	if r
		return "Failed to create the IDirect3D Interface " r " - " ddraw.err[r . ""]	
	else IDirect3D := new ComInterfaceWrapper(d3d.IDirect3d, pD3D, True)
		
	GUID_FromString(idd_ViewPort, d3d.IID_IDirect3DViewport)
	r := dllcall(IDirect3D.CreateViewport, uint, IDirect3D.p, "uint*", pViewPort, uint, 0, uint)
	Print("ViewPort: " r  ":" ddraw.err[r . ""] "`n")
	if r
		return "Failed to create the IDirect3DViewPort Interface " r " - " d3D.err[r . ""]	
	else IDirect3DViewPort := new ComInterfaceWrapper(d3d.IDirect3DViewPort, pViewPort, True)			
				
	GUID_FromString(idd_texture, d3d.IID_IDirect3DTexture)
	r := dllcall(IDirectDrawSurface.QueryInterface, uint, IDirectDrawSurface2.p
				, ptr, &idd_texture, "uint*", pTexture, uint)
	Print("Texture: " 	r  ":" ddraw.err[r . ""] "`n")						
	if r
		return "Failed to create the IDirect3DTexture Interface " r " - " d3D.err[r . ""]	
	else IDirect3DTexture := new ComInterfaceWrapper(d3d.IDirect3DTexture, pTexture, True)
						
	GUID_FromString(idd_d3d, d3d.IID_IDirect3D2)
	r := dllcall(IDirectDraw.QueryInterface, uint, IDirectDraw.p, uint, &idd_d3d, "uint*", pD3D2, uint)
	print("Direct3D2: " r ":" ddraw.err[r . ""] "`n")
	if r
		return "Failed to create the IDirect3D2 Interface " r " - " ddraw.err[r . ""]		
	else IDirect3D2 := new ComInterfaceWrapper(d3d.IDirect3d2, pD3D2, True)
			
	GUID_FromString(idd_ViewPort, d3d.IID_IDirect3DViewport2)
	r := dllcall(IDirect3D2.CreateViewport, uint, IDirect3D2.p, "uint*", pViewPort2, uint, 0, uint)
	Print("ViewPort2: " r  ":" d3D.err[r . ""] "`n")
	if r
		return "Failed to create the IDirect3DViewPor2 Interface " r " - " d3D.err[r . ""]		
	else IDirect3DViewPort2 := new ComInterfaceWrapper(d3d.IDirect3DViewPort2, pViewPort2, True)	
		
	GUID_FromString(idd_texture, d3d.IID_IDirect3DTexture2)
	r := dllcall(IDirectDrawSurface.QueryInterface, uint, IDirectDrawSurface.p
				, ptr, &idd_texture, "uint*", pTexture2, uint)
	Print("Texture2: " 	r  ":" ddraw.err[r . ""] "`n")						
	if r
		return "Failed to create the IDirect3DTexture2 Interface " r " - " d3D.err[r . ""]		
	else IDirect3DTexture2 := new ComInterfaceWrapper(d3d.IDirect3DTexture2, pTexture2, True)
		
	GUID_FromString(idd_d3d, d3d.IID_IDirect3D3)
	r := dllcall(IDirectDraw.QueryInterface, uint, IDirectDraw.p, uint, &idd_d3d, "uint*", pD3D3, uint)
	print("Direct3D3: " r ":" ddraw.err[r . ""] "`n")
	if r
		return "Failed to create the IDirect3D3 Interface " r " - " ddraw.err[r . ""]		
	else IDirect3D3 := new ComInterfaceWrapper(d3d.IDirect3d3, pD3D3, True)
			
	r := dllcall(IDirect3D3.CreateViewport, uint, IDirect3D3.p, "uint*", pViewPort3, uint, 0, uint)
	Print("ViewPort3: " r  ":" d3D.err[r . ""] "`n")
	if r
		return "Failed to create the IDirect3DViewPor2 Interface " r " - " d3D.err[r . ""]		
	else IDirect3DViewPort3 := new ComInterfaceWrapper(d3d.IDirect3DViewPort3, pViewPort3, True)	
		
	D3DVERTEXBUFFERDESC.dwSize := D3DVERTEXBUFFERDESC.size()
	D3DVERTEXBUFFERDESC.dwFVF := D3DFVF_XYZRHW | D3DFVF_DIFFUSE 
	D3DVERTEXBUFFERDESC.dwNumVertices := 4
	r := dllcall(IDirect3D3.CreateVertexBuffer, uint, IDirect3D3.p, uint, D3DVERTEXBUFFERDESC[], "uint*", pVerTexBuffer
                                              , uint, 0, uint, 0, uint)
	Print("VertexBuffer: " r  ":" d3D.err[r . ""] "`n")										  
	if r
		return "Failed to create the IDirect3DVertexBuffer Interface " r " - " d3D.err[r . ""]		
	else IDirect3DVertexBuffer := new ComInterfaceWrapper(d3d.IDirect3DVertexBuffer, pVerTexBuffer, True)
		
	/*
	if !wine or (g_.cfg.d3D = "3") 
	{	
		GUID_FromString(idd_d3DDevice, device)		
		r := dllcall(IDirect3D3.CreateDevice, uint, IDirect3D3.p
					, ptr, &idd_d3DDevice, uint, IDirectDrawSurface4.p, "uint*", pDevice3, uint, 0, uint)
		Print("Device3: " r  ":" ddraw.err[r . ""] "`n")						
		if r
			return "Failed to create the IDirect3DDevice3 Interface " r " - " d3D.err[r . ""] IDirectDrawSurface4.p		
		else IDirect3DDevice3 := new ComInterfaceWrapper(d3d.IDirect3DDevice3, pDevice3, True)
	}
	if !wine or (g_.cfg.d3D = "2") 
	{	
		GUID_FromString(idd_d3DDevice, device)
		r := dllcall(IDirect3D2.Createdevice, uint, IDirect3D2.p, uint, &idd_d3DDevice, uint, IDirectDrawSurface.p,  "uint*", pDevice2, uint)
		Print("IDirect3DDevice2: " r  ":" ddraw.err[r . ""] "`n")
		if r
			return "Failed to create the IDirect3DDevice2 Interface " r " - " d3D.err[r . ""]	
		else IDirect3DDevice2 := new ComInterfaceWrapper(d3d.IDirect3DDevice2, pDevice2, True)		
	} 			
	if !wine or (g_.cfg.d3D = "1") 
	{
        GUID_FromString(idd_d3DDevice, device)	
		r := dllcall(IDirectDrawSurface.QueryInterface, uint, IDirectDrawSurface.p, uint, &idd_d3DDevice, "uint*", pDevice, uint)	
        Print("Device: " r  ":" ddraw.err[r . ""] "`n")
        if (r)
        {   
            ; Workarround for the above call faliing with the passtrought layer
            ; the header parser wrongly generated the d3d.IID_IDirect3DDevice var as: {64108800-957d-0X11d0-89ab-00a0c9054129}, because of the upper case "X"            
            GUID_FromString(idd_d3DDevice, "{64108800-957d-11d0-89ab-00a0c9054129}")	
            r := dllcall(IDirect3DDevice2.QueryInterface, uint, IDirect3DDevice2.p, uint, &idd_d3DDevice, "uint*", pDevice, uint)	
            Print("Device: " r  ":" ddraw.err[r . ""] "`n")
        }	
		if r
			return "Failed to create the IDirect3DDevice Interface " r " - " D3D.err[r . ""]		
		else IDirect3DDevice := new ComInterfaceWrapper(d3d.IDirect3DDevice, pDevice, True)		
					
		D3DEXECUTEBUFFERDESC.dwSize       := D3DEXECUTEBUFFERDESC.size()
		D3DEXECUTEBUFFERDESC.dwFlags      := 0x00000001 ;D3DDEB_BUFSIZE 
		D3DEXECUTEBUFFERDESC.dwBufferSize := 16
		r := dllcall(IDirect3DDevice.CreateExecuteBuffer, uint, IDirect3DDevice.p, uint, D3DEXECUTEBUFFERDESC[], "uint*", pExecBuffer, uint, 0, uint)
		Print("Exec Buffer: " r  ":" d3D.err[r . ""] "`n")
		if r
			return "Failed to create the IDirect3DExecuteBuffer Interface " r " - " D3D.err[r . ""]	
		else IDirect3DExecuteBuffer :=	new ComInterfaceWrapper(d3d.IDirect3DExecuteBuffer, pExecBuffer, True)
	}	
	*/				

	GUID_FromString(idd_d3DDevice, device)		
	r := dllcall(IDirect3D3.CreateDevice, uint, IDirect3D3.p, ptr, &idd_d3DDevice, uint, IDirectDrawSurface4.p, "uint*", pDevice3, uint, 0, uint)
	Print("Device3: " r  ":" ddraw.err[r . ""] "`n")						
	if r
		return "Failed to create the IDirect3DDevice3 Interface " r " - " d3D.err[r . ""] IDirectDrawSurface4.p		
	else IDirect3DDevice3 := new ComInterfaceWrapper(d3d.IDirect3DDevice3, pDevice3, True)	

	GUID_FromString(idd_d3DDevice2, d3d.IID_IDirect3DDevice2)	
	r := dllcall(IDirect3DDevice3.QueryInterface, uint, IDirect3DDevice3.p, uint, &idd_d3DDevice2, "uint*", pDevice2, uint)	
	if r
		return "Failed to create the IDirect3DDevice2 Interface " r " - " d3D.err[r . ""]	
	else IDirect3DDevice2 := new ComInterfaceWrapper(d3d.IDirect3DDevice2, pDevice2, True)	

	GUID_FromString(idd_d3DDevice, "{64108800-957d-11d0-89ab-00a0c9054129}")	
	r := dllcall(IDirect3DDevice3.QueryInterface, uint, IDirect3DDevice3.p, uint, &idd_d3DDevice, "uint*", pDevice, uint)	
	if r
		return "Failed to create the IDirect3DDevice Interface " r " - " D3D.err[r . ""]		
	else IDirect3DDevice := new ComInterfaceWrapper(d3d.IDirect3DDevice, pDevice, True)		
				
	D3DEXECUTEBUFFERDESC.dwSize       := D3DEXECUTEBUFFERDESC.size()
	D3DEXECUTEBUFFERDESC.dwFlags      := 0x00000001 ;D3DDEB_BUFSIZE 
	D3DEXECUTEBUFFERDESC.dwBufferSize := 16
	r := dllcall(IDirect3DDevice.CreateExecuteBuffer, uint, IDirect3DDevice.p, uint, D3DEXECUTEBUFFERDESC[], "uint*", pExecBuffer, uint, 0, uint)
	Print("Exec Buffer: " r  ":" d3D.err[r . ""] "`n")
	if r
		return "Failed to create the IDirect3DExecuteBuffer Interface " r " - " D3D.err[r . ""]	
	else IDirect3DExecuteBuffer :=	new ComInterfaceWrapper(d3d.IDirect3DExecuteBuffer, pExecBuffer, True)		
	return "Succeeded to create Direct3D"	
}

class D3DWin9xFlag{
    __New(){
        if (g_.cfg.layer and instr(g_.cfg.compatLayer, "WIN9"))
            msgbox % dllcall("peixoto.dll/SetWin9xFlag", uint, 1) errorlevel
    }
    __Delete(){
        if (g_.cfg.layer and instr(g_.cfg.compatLayer, "WIN9"))
            dllcall("peixoto.dll/SetWin9xFlag", uint, 0)
    }
}

ReleaseDirectDraw()
{
    if (g_.cfg.layer and instr(g_.cfg.compatLayer, "WIN9"))
    return
	for k, v in [IDirect3DDevice7, IDirect3DVertexBuffer7, IDirect3D7, IDirectDrawSurface7, IDirectDraw7
				,IDirect3DDevice3, IDirect3DViewPort3, IDirect3DVertexBuffer, 
				,IDirect3DDevice2, IDirect3DViewPort2, IDirect3DTexture2, IDirect3DExecuteBuffer 
				,IDirect3DDevice, IDirect3DViewPort, IDirect3DTexture
				,IDirect3D3, IDirect3D2, IDirect3D
				,IDirectDrawClipper, IDirectDrawPalette, IDirectDrawGammaControl, IDirectDrawSurface
				,IDirectDrawSurface2, IDirectDrawSurface3, IDirectDrawSurface4
				,IDirectDraw4, IDirectDraw2, "FIX ME: Not Releasing DirectDraw"]
		isobject(v) ? logerr("Releasing " v.name " " v.p " " v.__release())					
}

GetDirect3D7()
{
	if !(pdirectdrawcreateEx := g_.p.DDCreateEx) 	
	{	
		h_ddrawdll          := dllcall("LoadLibrary", str, "ddraw.dll")
		pdirectdrawcreateEx := dllcall("GetProcAddress", int, h_ddrawdll, astr, "DirectDrawCreateEx")
		if not h_ddrawdll or not pdirectdrawcreateEx
		return "Failed to load ddraw.dll"
	}		
	
	GUID_FromString(idd_ddraw7, ddraw.IID_IDirectDraw7)
	r := dllcall(pdirectdrawcreateEx, uint, 0, "uint*", pddraw7:=0, uint, &idd_ddraw7, int, 0, uint) 
	printl("Directdraw7 " r ddraw.err[r . ""])
	if (g_.cfg.layer)
	{		
		pddraw7 := dllcall("Peixoto\WrappDDraw7Object", ptr, pddraw7, ptr)		
	}
	if not r
		IDirectDraw7 := new ComInterfaceWrapper(ddraw.IDirectDraw7, pddraw7, True)
	else return "Failed to create the IDirectDraw7 interface " r " - " ddraw.err[r . ""]
	
	r := dllcall(IDirectDraw7.SetCooperativeLevel, ptr, IDirectDraw7.p, uint, 0, int, DDSCL_NORMAL, uint)
	Print("CoopLevel: " r  ":" ddraw.err[r . ""] "`n")
	if r
		return "Failed to set the Cooperatve Level " r " - " ddraw.err[r . ""]	
	
	DDSURFACEDESC.dwsize                 := DDSURFACEDESC.size()
	DDSURFACEDESC2.dwSize                := DDSURFACEDESC2.size()		
	(D:= struct(DDSURFACEDESC2)).dwSize  := DDSURFACEDESC2.size()	
	D.dwFlags        := DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH ;| DDSD_PIXELFORMAT  
	D.ddsCaps.dwCaps := DDSCAPS_3DDEVICE | DDSCAPS_VIDEOMEMORY  
    D.dwWidth        := 640
	D.dwHeight       := 480
	SetPixelFormat(D, "X8RGB")
			
	r := dllcall(IDirectDraw7.CreateSurface, uint, IDirectDraw7.p, uint, D[], "ptr*", pPrimary:=0, uint, 0, uint)	
	print("Surface7: " r  ":" ddraw.err[r . ""] "`n")		
	if r
		return "Failed to create the IDirectDrawSurface7 Interface " r " - " ddraw.err[r . ""]	
	else IDirectDrawSurface7 := new ComInterfaceWrapper(ddraw.IDirectDrawSurface7, pPrimary, True)
	;dllcall("RtlMoveMemory", ptr, ISURFACE7_VTBL[], ptr, IDirectDrawSurface7.pVTbl, int, IDirectDrawSurface7.dwSize)	
	
	GUID_FromString(idd_surf, ddraw.IID_IDirectDrawSurface)
	r := dllcall(IDirectDrawSurface7.QueryInterface, uint, IDirectDrawSurface7.p, uint, &idd_surf, "uint*", pSurface:=0)
	print("Surface: " r  ":" ddraw.err[r . ""] "`n")	
	if r
		return "Failed to create the IDirectDrawSurface Interface " r " - " ddraw.err[r . ""]	
	else IDirectDrawSurface := new ComInterfaceWrapper(ddraw.IDirectDrawSurface, pSurface, True)
		
	GUID_FromString(idd_4, ddraw.IID_IDirectDrawSurface4)
	r := dllcall(IDirectDrawSurface7.QueryInterface, uint, IDirectDrawSurface7.p, uint, &idd_4, "uint*", pS4:=0)
	print("Surface4: " r  ":" ddraw.err[r . ""] "`n")	
	if r
		return "Failed to create the IDirectDrawSurface4 Interface " r " - " ddraw.err[r . ""]	
	else IDirectDrawSurface4 := new ComInterfaceWrapper(ddraw.IDirectDrawSurface4, pS4, True)
		
	GUID_FromString(idd_gamma, ddraw.IID_IDirectDrawGammaControl)
	r := dllcall(IDirectDrawSurface.QueryInterface, uint, IDirectDrawSurface.p, uint, &idd_gamma, "uint*", pGamma:=0, uint)
	if r
		return "Failed to create the IDirectDrawGammaControl Interface " r " - " ddraw.err[r . ""]	
	IDirectDrawGammaControl := new ComInterfaceWrapper(ddraw.IDirectDrawGammaControl, pGamma, True)
	
	r := dllcall(IDirectDraw.CreateClipper, uint, IDirectDraw.p, uint, 0, "uint*", pClipper:=0, uint, 0, uint)
	if r
		return "Failed to create the IDirectDrawCliper Interface " r " - " ddraw.err[r . ""]	
	IDirectDrawClipper := new ComInterfaceWrapper(ddraw.IDirectDrawClipper, pClipper, True)	
	
	GUID_FromString(idd_d3D7, d3d.IID_IDirect3D7)
	r := dllcall(IDirectDraw7.QueryInterface, uint, IDirectDraw7.p, uint, &idd_d3D7, "uint*", pd3D7:=0, uint)
	print("d3D7: " r  ":" ddraw.err[r . ""] "`n")
	if r
		return "Failed to create the IDirect3D7 Interface " r " - " ddraw.err[r . ""]	
	else IDirect3D7 := new ComInterfaceWrapper(d3D.IDirect3D7, pd3D7, True)	
		
	D3DVERTEXBUFFERDESC.dwSize := D3DVERTEXBUFFERDESC.size()
	D3DVERTEXBUFFERDESC.dwFVF := D3DFVF_XYZRHW | D3DFVF_DIFFUSE 
	D3DVERTEXBUFFERDESC.dwNumVertices := 4
	r := dllcall(IDirect3D7.CreateVertexBuffer, uint, IDirect3D7.p, uint, D3DVERTEXBUFFERDESC[], "uint*", pVerTexBuffer:=0, uint, 0, uint)
	Print("VertexBuffer7: " r  ":" d3D.err[r . ""] "`n")										  
	if r
		return "Failed to create the IDirect3DVertexBuffer7 Interface " r " - " d3D.err[r . ""]		
	else IDirect3DVertexBuffer7 := new ComInterfaceWrapper(d3d.IDirect3DVertexBuffer7, pVerTexBuffer, True)	
		
	devices := 	{"RGB Emulation" : d3d.IID_IDirect3DRGBDevice, "Direct3D HAL" :  d3d.IID_IDirect3DHALDevice
	            , "Direct3D T&L HAL" : d3d.IID_IDirect3DTnLHalDevice }
	GUID_FromString(idd_device7, devices["Direct3D HAL"])	
    r := dllcall(IDirect3D7.CreateDevice, uint, IDirect3D7.p,  uint, &idd_device7, uint, pPrimary, "uint*", pd3Ddevice7:=0, uint)
	print("D3DDevice7: " r  ":" ddraw.err[r . ""] "`n")	
	if r
		return "Failed to create the IDirect3DDevice7 Interface " r " - " ddraw.err[r . ""]	
	else IDirect3DDevice7 := new ComInterfaceWrapper(d3d.IDirect3DDevice7, pd3Ddevice7, True)
		
	return "Succeeded to create the DirectDraw7 and Direct3D7 Interfaces" 
}

class Surface {
    __new(DD, px="", res="", sys=False, m=False)
    {
		;DD      := g_.pIDirectDraw
        (D      := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
        (Display:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
        px ?: px := (D3DHOOKS_DATA.D=16) ? "RG6B" : (D3DHOOKS_DATA.D=8) ? "PAL8" : "X8RGB"
        if res {
            resw := (res>>16) & 0xffff
            resh :=  res & 0xffff
        }else  if (g_.cfg.HD)  {
            resw := D3DHOOKS_DATA.w
            resh := D3DHOOKS_DATA.h
        }else  {
            dllcall(IDirectDraw.GetDisplayMode, uint, DD, uint, Display[])
            resw :=  Display.dwWidth
            resh :=  Display.dwHeight
        }		
        pSurface         := 0
		D.ddckCKSrcBlt.dwColorSpaceLowValue  := (D3DHOOKS_DATA.D=16) ? 0xF81f : 0xFFFF00FF
		D.ddckCKSrcBlt.dwColorSpaceHighValue := (D3DHOOKS_DATA.D=16) ? 0xF81f : 0xFFFF00FF
        D.dwFlags        := DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT | DDSD_CKSRCBLT 
        D.dwWidth        := resw
        D.dwHeight       := resh
        cps := (px = "PAL8") ? DDSCAPS_OFFSCREENPLAIN : (px = "A4RGB") ? DDSCAPS_TEXTURE : DDSCAPS_TEXTURE | DDSCAPS_3DDEVICE ; A4RGB (revenant map fix)
        mem := sys ? DDSCAPS_SYSTEMMEMORY : DDSCAPS_VIDEOMEMORY
        D.ddsCaps.dwCaps := cps | mem
		m ? D.ddsCaps.dwCaps |= (DDSCAPS_MIPMAP | DDSCAPS_COMPLEX)
        SetPixelFormat(D, px)
        r := dllcall(IDirectDraw.CreateSurface, uint, DD, uint, D[], "ptr*", pSurface, uint, 0, uint)
        if (r = DDERR_NODIRECTDRAWHW)
		{
            D.ddsCaps.dwCaps := 0
            r := dllcall(IDirectDraw.CreateSurface, uint,DD, uint, D[], "ptr*", pSurface, uint, 0, uint)
        } 
        printl("Create Surrogate - Surface1 " r " " ddraw.err[r . ""] " format " px " "
        . D.dwWidth "x" D.dwHeight)
        if r
        return
        this.Surface := pSurface
        this.flip    := 0
        pSurface4 := 0, pTexture2 := 0
        GUID_FromString(idd_surface4, ddraw.IID_IDirectDrawSurface4)
        r := dllcall(IDirectDrawSurface.QueryInterface, uint, this.Surface, ptr, &idd_surface4, "ptr*", pSurface4, uint)
        Printl("Create Surrogate - Surface4 " r " " ddraw.err[r . ""])
        if r
        return
        this.Surface4 := pSurface4
        GUID_FromString(idd_texture2, d3d.IID_IDirect3DTexture2)
        r := dllcall(IDirectDrawSurface.QueryInterface, uint, this.Surface, ptr, &idd_texture2, "ptr*", pTexture2, uint)
        printl("Create Surrogate - Texture2 " r " " ddraw.err[r . ""])
        if r
        return
        this.Texture := pTexture2		
    }
    GetHandle(pDevice) {
        if not this.Texture
        return
        handle := 0
        r := dllcall(IDirect3DTexture2.GetHandle, uint, this.Texture, uint, pDevice, "uint*", handle)
        printl("Create Surrogate - Handle " r " " d3D.err[r . ""])
        this.handle := handle
    }  
	Attach(s)
	{
		if ( (r := dllcall(IDirectDrawSurface.AddAttachedSurface, uint, this.surface, uint, s, uint)) = 0)
		{
			dllcall(IDirectDrawSurface.addref, uint, this.flip := s	)
			GUID_FromString(iid, ddraw.IID_IDirectDrawSurface4)
			if (dllcall(IDirectDrawSurface.QueryInterface, uint, this.flip, ptr, &iid, "ptr*", p4:=0, uint) = 0)
			dllcall(IDirectDrawSurface4.release, uint, p4)
			this.flip4 := p4
		} else {
			logerr("Surface::Attach : AddAttachedSurface FAILED " r " " ddraw.err[r . ""])
		}		
	}
	Mip4()
	{
		dllcall(IDirectDrawSurface.addref, uint, this.surface4)
		s := this.surface4
		c := DDSCAPS_TEXTURE | DDSCAPS_MIPMAP
		Loop
		{
			d := 0
			if dllcall(IDirectDrawSurface4.GetAttachedSurface, uint, s, "uint*", c, "uint*", d)
			{
				dllcall(IDirectDrawSurface4.release, uint, s)
				break
			}
			if dllcall(IDirectDrawSurface4.blt, uint, d, uint, 0, uint, s, uint, 0, uint, 0, uint, 0)
				logerr("mip blt failed")
			dllcall(IDirectDrawSurface4.release, uint, s)
			s := d	
		} 
	}
    Check()
    {
        if ! dllcall(IDirectDrawSurface.isLost, uint, this.surface)
        return
        dllcall(IDirectDrawSurface.restore, uint, this.surface)
        (this.flip) ? dllcall(IDirectDrawSurface.restore, uint, this.flip)
    }
	IsThatYou(s){
		_this := dllcall(g_.p.GetSurfaceID, ptr, this.surface)
		_that := dllcall(g_.p.GetSurfaceID, ptr, s)
		if (_this and _this = _that)
		return True
		return False		
	}
	__Delete()
    {
        (this.Texture) ? printl("Releasing Surrogate Texture2 " dllcall(IDirect3DTexture2.release, uint, this.Texture, uint))
        (this.Surface4) ? printl("Releasing Surrogate Surface4 " dllcall(IDirectDrawSurface4.release, uint, this.Surface4))
        (this.flip)  ? printl("Deleting  Attachment " ddraw.err["" . dllcall(IDirectDrawSurface.release, uint, this.flip, uint, 0, uint, 0, uint)])
        (this.Surface) ? printl("Releasing Surrogate Surface1 " dllcall(IDirectDrawSurface.release, uint, this.Surface))
    }	
}

class TxlSz
{
	__new(w=0, h=0)
	{
		this.w := D3DHOOKS_DATA.w
		this.h := D3DHOOKS_DATA.h
		D3DHOOKS_DATA.w := w
		D3DHOOKS_DATA.h := h
		g_.proxies.prms[1] := 1/D3DHOOKS_DATA.w
		g_.proxies.prms[2] := 1/D3DHOOKS_DATA.h
	}
	__delete()
	{
		D3DHOOKS_DATA.w := this.w
		D3DHOOKS_DATA.h := this.h
		g_.proxies.prms[1] := 1/D3DHOOKS_DATA.w
		g_.proxies.prms[2] := 1/D3DHOOKS_DATA.h
	}
}

class D3DDevice {
    __new(DD, res="", px="", fgs="")
    {
		;DD      := g_.pIDirectDraw
        (D       := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
        (Display := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
        D.dwFlags := DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT
        dllcall(IDirectDraw.GetDisplayMode, uint, DD, uint, Display[])
        if res {
            D.dwWidth  := (res>>16) & 0xffff
            D.dwHeight :=  res & 0xffff
        }else  {
            D.dwWidth := Display.dwWidth, D.dwHeight := Display.dwHeight
        }
        pS               := 0
        D.ddsCaps.dwCaps := DDSCAPS_3DDEVICE | DDSCAPS_VIDEOMEMORY | DDSCAPS_TEXTURE
		;m ? D.ddsCaps.dwCaps |= (DDSCAPS_MIPMAP | DDSCAPS_COMPLEX)
        SetPixelFormat(D, px?px:GetPixelFormat(Display))
        r := dllcall(IDirectDraw.CreateSurface, uint, DD, uint, D[], "ptr*", pS, uint, 0, uint)
        if (r = DDERR_INVALIDPIXELFORMAT)
		{
            D.dwFlags := DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT
            r := dllcall(IDirectDraw.CreateSurface, uint, DD, uint, D[], "ptr*", pS, uint, 0, uint)
        }
        printl("Create device - Surface1 "  r " " ddraw.err[r . ""] D.dwWidth " x " D.dwHeight)
        if r
        return
        this.ww      := D.dwWidth
        this.hh      := D.dwHeight
        this.Surface := pS
        pS4:=0, pD3D:=0, pT2:=0, pD3:=0, pVW:=0
        GUID_FromString(iid4, ddraw.IID_IDirectDrawSurface4)
        GUID_FromString(iid2, d3d.IID_IDirect3DTexture2)
        r := dllcall(IDirectDrawSurface.QueryInterface, uint, this.Surface, ptr, &iid4, "ptr*", pS4, uint)
        printl("Create device - Surface4 " r " " ddraw.err[r . ""])
        if r
        return
        this.Surface4 := pS4
		if (fgs & 1)
		{
			D.ddsCaps.dwCaps := DDSCAPS_ZBUFFER
			D.ddpfPixelFormat.dwRGBBitCount := 16
			D.ddpfPixelFormat.dwGBitMask    := 0xffff
			r := dllcall(IDirectDraw.CreateSurface, uint, DD, uint, D[], "ptr*", pZ:=0, uint, 0, uint)
			printl("Create device - Zbuffer " r " " ddraw.err[r . ""])
			this.z4 := pZ
			r := dllcall(IDirectDrawSurface.AddAttachedSurface, uint, this.surface, uint, pZ)
			printl("Create device - Attatch Z " r " " ddraw.err[r . ""])
		}
        r := dllcall(IDirectDrawSurface.QueryInterface, uint, this.Surface, ptr, &iid2, "ptr*", pT2, uint)
        printl("Create device - Texture2 " r " " d3d.err[r . ""])
        if r
        return
        this.Texture := pT2 
		
        GUID_FromString(iid3D, d3d.IID_IDirect3D3)
		GUID_FromString(iidDv, d3d.IID_IDirect3DHALDevice)
		r := dllcall(IDirectDraw.QueryInterface, uint, DD, ptr, &iid3D, "ptr*", pD3D, uint)
        printl("Create device - Direct3D " r " " ddraw.err[r . ""])
        if r
        return
        r := dllcall(IDirect3D3.CreateDevice, uint, pD3D, ptr, &iidDv, uint, this.surface4, "uint*", pD3, uint, 0, uint)
        Printl("Create device - Device3  " r  " " ddraw.err[r . ""])
        if this.reset(r, DD)
        {
            r := dllcall(IDirect3D3.CreateDevice, uint, pD3D, ptr, &iidDv, uint, this.surface4, "uint*", pD3, uint, 0, uint)
            Printl("Create device - Device3  " r  " " ddraw.err[r . ""])
            if r
            return
        }
        this.Device3 := pD3
        GUID_FromString(Dev2, d3d.IID_IDirect3DDevice2)
        r := dllcall(IDirect3DDevice3.QueryInterface, uint, pD3, ptr, &Dev2, "uint*", pD2:=0, uint, 0, uint)
        Printl("Create device - Device2  " r  " " ddraw.err[r . ""])
        if r
        return
        this.Device2 := pD2
        r := dllcall(IDirect3D3.CreateViewport, uint, pD3D, "uint*", pVW, uint, 0, uint)
        Printl("Create device - ViewPort: " r  ":" d3D.err[r . ""])
        if r
        return
        this.viewport := pVW
        printl("Add viewport " dllcall(IDirect3DDevice3.AddViewport, uint, pD3, uint, pVW))
        printl("Set viewport " dllcall(IDirect3DDevice3.SetCurrentViewport, uint, pD3, uint, pVW))
        v := this.VW(this.ww, this.hh)
        dllcall(IDirect3DViewPort3.SetViewPort2, uint, pVW, uint, v[], uint)
        dllcall(IDirect3DViewport3.release, uint, pVW)
        dllcall(IDirect3DDevice3.SetTextureStageState, uint, pD3, uint, 0, uint, 12, uint, 3)
		dllcall(IDirect3DDevice3.SetTextureStageState, uint, pD3, uint, 1, uint, 12, uint, 3)
		dllcall(IDirect3DDevice3.SetTextureStageState, uint, pD3, uint, 0, uint, 16, uint, 1)
		dllcall(IDirect3DDevice3.SetTextureStageState, uint, pD3, uint, 1, uint, 16, uint, 2)
        dllcall(IDirect3D3.release, uint, pD3D)
    }
	Trgt(t="")
	{
		t := t ? t.surface4 : this.Surface4
		r := dllcall(IDirect3DDevice3.SetRenderTarget, uint, this.Device3, uint, t)
		(D := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
		dllcall(IDirectDrawSurface4.GetSurfaceDesc, uint, t, uint, D[])
		dllcall(IDirect3DViewPort3.SetViewPort2, uint, this.viewport, uint, this.VW(d.dwWidth, d.dwHeight)[], uint)
		return r		
	}
	Reset(r, DD)
    {
        if ddraw.err[r . ""] = "DDERR_INVALIDPIXELFORMAT"
        {
            dllcall(IDirectDraw.SetDisplayMode, uint, DD, uint, D3DHOOKS_DATA.HD_W, uint, D3DHOOKS_DATA.HD_H, uint, 32)
            dllcall(IDirectDrawSurface.restore, uint, g_.primary)
            dllcall(IDirectDrawSurface4.restore, uint, this.Surface4)
            return True
        }
	}
    VW(w, h){
		static v
        (v := struct(D3DVIEWPORT2)).dwSize := D3DVIEWPORT2.size()
        v.dwX         := 0,  v.dwY          := 0
        v.dwWidth     := w,  v.dwHeight     := h
        v.dvClipX     := 0,  v.dvClipY      := 0
        v.dvClipWidth := w,  v.dvClipHeight := h
        v.dvMinZ      := 0., v.dvMaxZ       := 1.
        return v
    }
	SetTexture(s, t)
	{
		return dllcall(IDirect3DDevice3.SetTexture, uint, this.Device3, uint, s, uint, t)
	}
	draw(d=0, t=0, s=0, p=0, o=0)
	{
		DEVICE3_RECT.Texture := t
		DEVICE3_RECT.Device3 := this.Device3
		if (p) 
		{
			D3DDDI_SetShaderOverride(p)
			dllcall(G_D3DDDI.SetPixelShaderConst, uint, 0, "uint64*", 223 | 1<<32, uint, g_.proxies.prms[]+o)
		}
		dllcall(g_.p.Dev3_DrawRect, uint, DEVICE3_RECT[], uint, d, uint, s, uint)		
		D3DDDI_RestoreShader()		
	}
	draw2(d=0, t=0, s=0, p=0, o=0)
	{
		DEVICE2_RECT.Text    := t
		DEVICE2_RECT.Device2 := this.Device2
		if (p) 
		{
			D3DDDI_SetShaderOverride(p)
			dllcall(G_D3DDDI.SetPixelShaderConst, uint, 0, "uint64*", 223 | 1<<32, uint, g_.proxies.prms[]+o)
		}
		dllcall(g_.p.Dev2_DrawRect, uint, DEVICE2_RECT[], uint, d, uint, s, uint)		
		D3DDDI_RestoreShader()
	}
	Blt(d, dr, s=0, sr=0, p=0)
	{
		this.Trgt(d)
		this.draw(dr, s, sr, p)
		this.Trgt()
	}
	DrawRect(target, target_rect, src, src_rect, flags)
	{
		this.Trgt(target)
		DEVICE3_RECT.Texture := src.texture
		DEVICE3_RECT.Device3 := this.Device3		
		dllcall(g_.p.Dev3_DrawRctWithFlags, uint, DEVICE3_RECT[], uint, target_rect, uint, 0, uint, flags) 
		dllcall(IDirect3DDevice3.SetRenderTarget, uint, this.Device3, uint, g_.rtrgt)
	}
	Mip()
	{
		dllcall(IDirectDrawSurface.addref, uint, this.surface)
		s := this.surface
		c := DDSCAPS_TEXTURE | DDSCAPS_MIPMAP
		Loop
		{
			d := 0
			if dllcall(IDirectDrawSurface.GetAttachedSurface, uint, s, "uint*", c, "uint*", d)
			{
				dllcall(IDirectDrawSurface.release, uint, s)
				break
			}
			if dllcall(IDirectDrawSurface.blt, uint, d, uint, 0, uint, s, uint, 0, uint, 0, uint, 0)
				logerr("mip blt failed")
			dllcall(IDirectDrawSurface.release, uint, s)
			s := d	
		} 
	}
    Check()
    {
        if dllcall(IDirectDrawSurface.isLost, uint, this.surface)
        dllcall(IDirectDrawSurface.restore, uint, this.surface)
    }	
    __delete() {
        (this.viewport && this.Device3) ? printl("Delete Vieport " dllcall(IDirect3DDevice3.DeleteViewport, uint, this.Device3, uint, this.viewport))
        (this.Device2)  ? printl("Releasing DSurrogate Device2 " dllcall(IDirect3DDevice2.release, uint, this.Device2))
        (this.Device3)  ? printl("Releasing DSurrogate Device  " dllcall(IDirect3DDevice3.release, uint, this.Device3))
		(this.Surface) ? printl("Releasing DSurrogate Surface4 " dllcall(IDirectDrawSurface.release, uint, this.Surface))
        (this.Surface4) ? printl("Releasing DSurrogate Surface4 " dllcall(IDirectDrawSurface4.release, uint, this.Surface4))
        (this.Texture) ? printl("Releasing DSurrogate Texture2 " dllcall(IDirect3DTexture2.release, uint, this.Texture))
        (this.Surface) ? printl("Releasing DSurrogate Surface1 " dllcall(IDirectDrawSurface.release, uint, this.Surface))
		(this.z4) ? printl("Releasing DSurrogate Surface4 " dllcall(IDirectDrawSurface4.release, uint, this.z4))		
    }
}

class zprx {
	__new(rt, s)
	{
		dd := dllcall(g_.p.DDFrmSrfc, uint, s)
		GUID_FromString(iid, ddraw.IID_IDirectDraw4)
		r := dllcall(IDirectDraw.QueryInterface, uint, dd, uint, &iid, "uint*", dd4:=0)
		Printl("Create z surface - ddraw     " r  " " ddraw.err[r . ""])
		
		D         := struct(DDSURFACEDESC2)
		D.dwSize  := DDSURFACEDESC2.size()
		r         := dllcall(IDirectDrawSurface4.GetSurfaceDesc, uint, s, uint, D[])
		Printl("Create z surface - z  desc      " r  " " ddraw.err[r . ""])
		
		D_        := struct(DDSURFACEDESC2)
		D_.dwSize := DDSURFACEDESC2.size()
		r         := dllcall(IDirectDrawSurface4.GetSurfaceDesc, uint, rt, uint, D_[])
		Printl("Create z surface - rt desc      " r  " " ddraw.err[r . ""])
		
		if (g_.cfg.z24 && D.ddpfPixelFormat.dwZBufferBitDepth = 16)
		{
			c                := D.ddsCaps.dwCaps
			D.ddsCaps.dwCaps := DDSCAPS_ZBUFFER | DDSCAPS_SYSTEMMEMORY ;| DDSCAPS_LOCALVIDEOMEM
			
			r := dllcall(IDirectDraw4.CreateSurface, uint, dd4, uint, d[], "uint*", z16:=0, uint, 0)
			Printl("Create z16 surface - surf4   " r  " " ddraw.err[r . ""])
			this.SD16 := z16			
						
			D.ddpfPixelFormat.dwRGBBitCount := 24
			D.ddpfPixelFormat.dwGBitMask    := 0xffffff00
			D.ddsCaps.dwCaps                := c   
									
			r := dllcall(IDirectDraw4.CreateSurface, uint, dd4, uint, d[], "uint*", z24:=0, uint, 0)
			Printl("Create z24 surface - surf4   " r  " " ddraw.err[r . ""])
			this.SD24 := z24	
		}					
				
		D.dwWidth  := D_.dwWidth
        D.dwHeight := D_.dwHeight
        
		;D.ddsCaps.dwCaps := DDSCAPS_ZBUFFER | DDSCAPS_VIDEOMEMORY ;| DDSCAPS_LOCALVIDEOMEM
		r := dllcall(IDirectDraw4.CreateSurface, uint, dd4, uint, d[], "uint*", z4:=0, uint, 0)
		Printl("Create z surface - surf4     " r  " " ddraw.err[r . ""])	
		
		GUID_FromString(iid, ddraw.IID_IDirectDrawSurface)
        r := dllcall(IDirectDrawSurface4.QueryInterface, uint, z4, ptr, &iid, "ptr*", z1:=0, uint)
        printl("Create z surface - surf1     " r " " ddraw.err[r . ""])
		
		r := dllcall(IDirectDraw4.release, uint, dd4)
		printl("Create z surface - release4  " r " ")		
		
		this.Surface  := z1
		this.Surface4 := z4
		this.ID       := dllcall(g_.p.GetSurfaceID, uint, s)
		dllcall(IDirectDrawSurface.addRef, ptr, s)
		logerr("z id " this.ID)
	}	
	__delete()
	{
		(this.Surface4) ? printl("Releasing z Surface4 " dllcall(IDirectDrawSurface4.release, uint, this.Surface4))
        (this.Surface)  ? printl("Releasing z Surface1 " dllcall(IDirectDrawSurface.release, uint, this.Surface))
		(this.SD24)     ? printl("Releasing z Surface24 " dllcall(IDirectDrawSurface4.release, uint, this.SD24))
		(this.SD16)     ? printl("Releasing z Surface16 " dllcall(IDirectDrawSurface4.release, uint, this.SD16))
		dllcall(IDirectDrawSurface4.release, uint, this.ID)
	}
}

class Surface7 {
    __new(dd7, px="", res="", sys=False)
    {
        (D      := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
        (Display:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
        px ?: px := (D3DHOOKS_DATA.D=16) ? "RG6B" : (D3DHOOKS_DATA.D=8) ? "PAL8" : "X8RGB"
        if res {
            resw := (res>>16) & 0xffff
            resh :=  res & 0xffff
        }else if (g_.cfg.HD)  {
            resw := D3DHOOKS_DATA.w
            resh := D3DHOOKS_DATA.h
        }else  {
            dllcall(IDirectDraw7.GetDisplayMode, uint, dd7, uint, Display[])
            resw :=  Display.dwWidth
            resh :=  Display.dwHeight
        }
        pSurface         := 0
		D.ddckCKSrcBlt.dwColorSpaceLowValue  := (D3DHOOKS_DATA.D=16) ? 0xF81f : 0xFFFF00FF
		D.ddckCKSrcBlt.dwColorSpaceHighValue := (D3DHOOKS_DATA.D=16) ? 0xF81f : 0xFFFF00FF       
        D.dwFlags        := DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT | DDSD_CKSRCBLT 
        D.dwWidth        := resw
        D.dwHeight       := resh
        cps := (px = "PAL8" || sys) ? DDSCAPS_OFFSCREENPLAIN : DDSCAPS_TEXTURE | DDSCAPS_3DDEVICE 
        mem := sys ? DDSCAPS_SYSTEMMEMORY : DDSCAPS_VIDEOMEMORY
        D.ddsCaps.dwCaps := cps | mem
        SetPixelFormat(D, px)
        r := dllcall(IDirectDraw7.CreateSurface, uint, dd7, uint, D[], "ptr*", pSurface, uint, 0, uint)
        logerr("Create Surrogate - Surface7 " r " " ddraw.err[r . ""] " format " px " " . D.dwWidth "x" D.dwHeight)
        if r
        return
		this.Surface7 := pSurface
		this.Texture  := pSurface		

		GUID_FromString(iids, ddraw.IID_IDirectDrawSurface)
		r := dllcall(IDirectDrawSurface7.QueryInterface, uint, this.Surface7, uint, &iids, "uint*", pS:=0)
		logerr("Create Surrogate - Surface1 " r " " ddraw.err[r . ""])
		if r
        return
		this.Surface := pS  
			
		GUID_FromString(iids4, ddraw.IID_IDirectDrawSurface4)
		r := dllcall(IDirectDrawSurface7.QueryInterface, uint, this.Surface7, uint, &iids4, "uint*", pS4:=0)
		logerr("Create Surrogate - Surface1 " r " " ddraw.err[r . ""])
		if r
        return
		this.Surface4 := pS4 			
    }
    Attach(pSurf) {
		if ! dllcall(IDirectDrawSurface.AddAttachedSurface, uint, this.Surface, uint, pSurf)		
        this.flip := pSurf
    }
    Check()
    {
		return
        if ! dllcall(IDirectDrawSurface.isLost, uint, this.surface)
        return
        dllcall(IDirectDrawSurface.restore, uint, this.surface)
        (this.flip) ? dllcall(IDirectDrawSurface.restore, uint, this.flip)
    }
	__Delete()
    {
        (this.Surface7) ? printl("Releasing Surrogate Surface7 " dllcall(IDirectDrawSurface7.release, uint, this.Surface7))
		(this.Surface4) ? printl("Releasing Surrogate Surface4 " dllcall(IDirectDrawSurface4.release, uint, this.Surface4))
		(this.Surface)  ? printl("Releasing Surrogate Surface1 " dllcall(IDirectDrawSurface.release, uint, this.Surface))
		(this.flip)     ? printl("Deleting  Attachment " ddraw.err["" . dllcall(IDirectDrawSurface.release, uint, this.flip, uint, 0, uint, 0, uint)])
    }	
}

class D3DDevice7 {
    __new(dd7, res="")
    {
        (D       := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
        (Display := struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
        D.dwFlags := DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT
        dllcall(IDirectDraw7.GetDisplayMode, uint, dd7, uint, Display[])
        if res {
            D.dwWidth  := (res>>16) & 0xffff
            D.dwHeight :=  res & 0xffff
        }else  {
            D.dwWidth := Display.dwWidth, D.dwHeight := Display.dwHeight
        }
        pSurface         := 0
        D.ddsCaps.dwCaps := DDSCAPS_3DDEVICE | DDSCAPS_VIDEOMEMORY | DDSCAPS_TEXTURE
        SetPixelFormat(D, GetPixelFormat(Display))
        r := dllcall(IDirectDraw7.CreateSurface, uint, dd7, uint, D[], "ptr*", pSurface, uint, 0, uint)
        logerr("Create device - Surface7 "  r " " ddraw.err[r . ""] )
        if r
        return
		
		this.ww       := D.dwWidth
        this.hh       := D.dwHeight
        this.Surface7 := pSurface  
		this.Texture  := pSurface 
		
		GUID_FromString(iids, ddraw.IID_IDirectDrawSurface)
		r := dllcall(IDirectDrawSurface7.QueryInterface, uint, this.Surface7, uint, &iids, "uint*", pS:=0)
		logerr("Create Surrogate - Surface1 " r " " ddraw.err[r . ""])
		if r
        return
		this.Surface := pS  
			
		GUID_FromString(iids4, ddraw.IID_IDirectDrawSurface4)
		r := dllcall(IDirectDrawSurface7.QueryInterface, uint, this.Surface7, uint, &iids4, "uint*", pS4:=0)
		logerr("Create Surrogate - Surface4 " r " " ddraw.err[r . ""])
		if r
        return
		this.Surface4 := pS4 		
              
        GUID_FromString(iid, d3d.IID_IDirect3D7)
		GUID_FromString(iid_dev, d3d.IID_IDirect3DHALDevice)        
		r := dllcall(IDirectDraw7.QueryInterface, uint, dd7, ptr, &iid, "ptr*", pD3D7:=0, uint)		
        logerr("Create device - Direct3D7 " r " " ddraw.err[r . ""])
        if r
		return r
		
		r := dllcall(IDirect3D7.CreateDevice, uint, pD3D7, ptr, &iid_dev, uint, pSurface, "uint*", pDev7:=0, uint)
		logerr("Create device - Device7  " r  " " d3d.err[r . ""] errorlevel)
        if r
		return r
		this.D3D7 := pDev7
        dllcall(IDirect3D7.release, uint, pD3D7)
		dllcall(IDirect3DDevice7.SetTextureStageState, uint, pDev7, uint, 0, uint, 12, uint, 3)
		dllcall(IDirect3DDevice7.SetTextureStageState, uint, pDev7, uint, 1, uint, 12, uint, 3)
		dllcall(IDirect3DDevice7.SetTextureStageState, uint, pDev7, uint, 0, uint, 16, uint, 1)
		dllcall(IDirect3DDevice7.SetTextureStageState, uint, pDev7, uint, 1, uint, 16, uint, 2)
    }
    Reset(r)
    {
        return
	}
	Trgt(t="")
	{
		t := t ? t.surface7 : this.Surface7
		return dllcall(IDirect3DDevice7.SetRenderTarget, uint, this.D3D7, uint, t)
	}
    VW(w, h){
        return
    }
    Check()
    {
        return
    }
	SetTexture(s, t)
	{
		return dllcall(IDirect3DDevice7.SetTexture, uint, this.D3D7, uint, s, uint, t)
	}
	draw(d=0, t=0, s=0, p=0, o=0, w=0, h=0)
	{
		DEVICE3_RECT.Texture := t
		DEVICE3_RECT.Device3 := this.D3D7
		if (p) 
		{
			D3DDDI_SetShaderOverride(p)
			dllcall(G_D3DDDI.SetPixelShaderConst, uint, 0, "uint64*", 223 | 1<<32, uint, g_.proxies.prms[]+o)
		}
		dllcall(g_.Dev7_DrawRect, uint, DEVICE3_RECT[], uint, d, uint, s, uint)		
		D3DDDI_RestoreShader()
	}
	Blt(d, dr, s=0, sr=0, p=0)
	{
		this.Trgt(d)
		this.draw(dr, s, sr, p)
	}
	DrawRect(target, target_rect, src, src_rect, flags)
	{
		this.Trgt(target)
		DEVICE3_RECT.Texture := src.Texture
		DEVICE3_RECT.Device3 := this.D3D7				
		dllcall(g_.Dev7_DrawRctWithFlags, ptr, DEVICE3_RECT[], ptr, target_rect, ptr, src_rect, uint, flags) 
	}
    __delete() {
        (this.Surface7)  ? printl("Releasing DSurrogate Surface7 " dllcall(IDirectDrawSurface7.release, uint, this.Surface7))
		(this.Surface4)  ? printl("Releasing Surrogate Surface4 " dllcall(IDirectDrawSurface4.release, uint, this.Surface4))
		(this.Surface1)  ? printl("Releasing Surrogate Surface1 " dllcall(IDirectDrawSurface.release, uint, this.Surface))
        (this.D3D7)      ? printl("Releasing DSurrogate Device7 " dllcall(IDirect3DDevice7.release, uint, this.D3D7))       
    }
}

class zprx7 {
	__new(rt, s)
	{
		r := dllcall(IDirectDrawSurface7.GetDDInterface, uint, s, "Uint*", dd7:=0)
		printl("Create z surface - ddraw7     " r  " " ddraw.err[r . ""])
		
		D         := struct(DDSURFACEDESC2)
		D.dwSize  := DDSURFACEDESC2.size()
		r         := dllcall(IDirectDrawSurface7.GetSurfaceDesc, uint, s, uint, D[])
		printl("Create z surface - z  desc      " r  " " ddraw.err[r . ""])
		
		D_        := struct(DDSURFACEDESC2)
		D_.dwSize := DDSURFACEDESC2.size()
		r         := dllcall(IDirectDrawSurface7.GetSurfaceDesc, uint, rt, uint, D_[])
		printl("Create z surface - rt desc      " r  " " ddraw.err[r . ""])

		D.dwWidth  := D_.dwWidth
        D.dwHeight := D_.dwHeight
        
		;D.ddsCaps.dwCaps := DDSCAPS_ZBUFFER | DDSCAPS_VIDEOMEMORY ;| DDSCAPS_LOCALVIDEOMEM
		if (g_.cfg.z24 && D.ddpfPixelFormat.dwZBufferBitDepth = 16)
		{					
			D.ddpfPixelFormat.dwRGBBitCount := 24
			D.ddpfPixelFormat.dwGBitMask    := 0xffffff00			
		}
		r := dllcall(IDirectDraw7.CreateSurface, uint, dd7, uint, d[], "uint*", z7:=0, uint, 0)
		printl("Create z surface - surf7     " r  " " ddraw.err[r . ""])	
		
		GUID_FromString(iid, ddraw.IID_IDirectDrawSurface)
        r := dllcall(IDirectDrawSurface7.QueryInterface, uint, z7, ptr, &iid, "ptr*", z1:=0, uint)
        printl("Create z surface - surf1     " r " " ddraw.err[r . ""])
		
		r := dllcall(IDirectDraw7.release, uint, dd7)
		printl("Create z surface - release7  " r " ")		
		
		this.Surface  := z1
		this.Surface7 := z7			
	}
	__delete()
	{
		(this.Surface7) ? printl("Releasing z Surface7 " dllcall(IDirectDrawSurface7.release, uint, this.Surface7))
        (this.Surface)  ? printl("Releasing z Surface1 " dllcall(IDirectDrawSurface.release, uint, this.Surface))
	}
}

GetSurfaceCaps(surf){
	caps:=0
	dllcall(IDirectDrawSurface.GetCaps, uint, surf, "uint*", caps)
	return caps
}

GetSurfaceCaps4(surf){
	VarSetCapacity(caps, 16, 0)
	dllcall(IDirectDrawSurface4.GetCaps, uint, surf, "ptr", &caps)
	return numget(&caps+0, "uint")
}

GetSurfaceCaps7(surf, i=0){
	VarSetCapacity(caps, 16, 0)
	dllcall(IDirectDrawSurface7.GetCaps, uint, surf, "ptr", &caps)
	return numget(&caps+i, "uint")
}

S7Mem(s)
{
	if ( (c := GetSurfaceCaps7(s, 4)) & DDSCAPS2_TEXTUREMANAGE || c & DDSCAPS2_D3DTEXTUREMANAGE )
	return 1
	if (GetSurfaceCaps7(s) & DDSCAPS_VIDEOMEMORY)
	return 2	
	return 0
}

GetSfc4MemType(s)
{
    if ( (c := GetSurfaceCaps4(s)) & DDSCAPS2_TEXTUREMANAGE || c & DDSCAPS2_D3DTEXTUREMANAGE )
	return "Managed"
	if (GetSurfaceCaps4(s) & DDSCAPS_VIDEOMEMORY)
	return "Video"	
	return "System"
}

GetSrfcPxFmt(s)
{
	(D:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC.size()
	dllcall(IDirectDrawSurface.GetSurfaceDesc, ptr, s, ptr, D[])
	return GetPixelFormat(D) 
}

GetSrfcPxFmt7(s7)
{
	(D:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
	dllcall(IDirectDrawSurface7.GetSurfaceDesc, ptr, s7, ptr, D[])
	return GetPixelFormat(D) 
}