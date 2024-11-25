#include lib\DirectX\Headers\_D3D8.h.ahk
global IDirect3D8:=0, IDirect3DDevice8:=0, IDirect3DPixelShader8:=0, IDirect3DVertexBuffer8:=0, IDirect3DMVertexBuffer8:=0
global IDirect3DTexture8 :=0, IDirect3DMTexture8:=0, IDirect3DSurface8:=0, IDirect3DMSurface8:=0, IDirect3D_Surface8:=0 
global IDirect3DCubeTexture8:=0, IDirect3DCubeFace8:=0

GetDirect3D8(hwin="", windowed = True, ww = 640, hh = 480)
{
	pDevice:=0, pTexture:=0, pSurface:=0, pMTexture:=0, pMSurface:=0, pVB8:=0
	hwin ?: hwin := A_scripthwnd
	pD3D8Create := dllcall("GetProcAddress", uint, dllcall("LoadLibraryW", str, "D3D8.dll"), astr, "Direct3DCreate8")
	;if not (pD3D8 := dllcall(pD3D8Create, uint, 0xdc))
	if not (pD3D8 := Direct3DCreate8_hook(0xdc))
		return "Failed to create Direct3D8"
	IDirect3D8 := new ComInterfaceWrapper(D3D8.IDirect3D8, pD3D8, True)	
	
	if (r := dllcall(IDirect3D8.GetAdapterDisplayMode, uint, IDirect3D8.p, uint, 0, uint, D3DDISPLAYMODE[]))
		return "Failed to get the display mode " r D3D8.err[r . ""]
		
	D3DPRESENT_PARAMETERS.BackBufferWidth         := ww
    D3DPRESENT_PARAMETERS.BackBufferHeight        := hh
    D3DPRESENT_PARAMETERS.BackBufferFormat        := D3DDISPLAYMODE.Format
    D3DPRESENT_PARAMETERS.SwapEffect              := 1 
    D3DPRESENT_PARAMETERS.hDeviceWindow           := hwin
    D3DPRESENT_PARAMETERS.Windowed                := windowed
	
	if (r := dllcall(IDirect3D8.CreateDevice, uint, IDirect3D8.p, uint, 0, uint, 1, uint, hwin
	                                        , uint, D3DCREATE_HARDWARE_VERTEXPROCESSING
									        , uint, D3DPRESENT_PARAMETERS[], "uint*", pDevice))
		return 	"Failed to create the Direct3D8 device " r D3D8.err[r . ""] 
	IDirect3DDevice8 := new ComInterfaceWrapper(D3D8.IDirect3DDevice8, pDevice, True)
	
	if (r := dllcall(IDirect3DDevice8.GetBackBuffer, uint, IDirect3DDevice8.p, uint, 0, uint, 0, "uint*", s:=0))
		return 	"Failed to accquire the defalt framebuffer " r D3D8.err[r . ""] 
	IDirect3DSurface8 := new ComInterfaceWrapper(D3D8.IDirect3DSurface8, s, True)
	
	if (r := dllcall(IDirect3DDevice8.CreateTexture, uint, IDirect3DDevice8.p, uint, 256, uint, 256, uint, 1
	                                               , uint, 0, uint, D3DFMT_R5G6B5, uint, 0, "uint*", pTexture)) 
		return "Failed to create a Direct3DTexture8 interface" r D3D8.err[r . ""]	
	IDirect3DTexture8 := new ComInterfaceWrapper(D3D8.IDirect3DTexture8, pTexture, True)

	;if (r := dllcall(IDirect3DTexture8.GetSurfaceLevel, uint, IDirect3DTexture8.p, uint, 0, "uint*", pSurface))
		;return "Failed to accquire a IDirect3DSurface8 interface" r D3D8.err[r . ""]
	;IDirect3DSurface8 := new ComInterfaceWrapper(D3D8.IDirect3DSurface8, pSurface, True)
	
	if (r := dllcall(IDirect3DDevice8.CreateCubeTexture, uint, IDirect3DDevice8.p, uint, 256, uint, 1
													, uint, 1, uint, D3DFMT_R5G6B5, uint, 0, "uint*", pCTx)) 
	return "Failed to create a IDirect3DCubeTexture8 interface" r D3D8.err[r . ""]	
	IDirect3DCubeTexture8 := new ComInterfaceWrapper(D3D8.IDirect3DCubeTexture8, pCTx, True)

	if (r := dllcall(IDirect3DCubeTexture8.GetCubeMapSurface, uint, IDirect3DCubeTexture8.p, uint, 0
														    , uint, 0, "uint*", pCf))
		return "Failed to accquire a IDirect3DSurface8 interface" r D3D8.err[r . ""]
	IDirect3DCubeFace8 := new ComInterfaceWrapper(D3D8.IDirect3DSurface8, pCf, True)
			
	if (r := dllcall(IDirect3DDevice8.CreateVertexBuffer, uint, IDirect3DDevice8.p, uint, 96, uint, 0
														, uint, D3DFVF_XYZRHW|D3DFVF_TEX1, uint, 1, "uint*", pMVB8))
		return "Failed to create a managed IDirect3DVertexBuffer interface" r D3D8.err[r . ""]
	IDirect3DMVertexBuffer8 := new ComInterfaceWrapper(D3D8.IDirect3DVertexBuffer8, pMVB8, True)
	
	if (r := dllcall(IDirect3DDevice8.CreateVertexBuffer, uint, IDirect3DDevice8.p, uint, 96, uint, 0
														, uint, D3DFVF_XYZRHW|D3DFVF_TEX1, uint, 0, "uint*", pVB8))
		return "Failed to create a managed IDirect3DVertexBuffer interface" r D3D8.err[r . ""]
	IDirect3DVertexBuffer8 := new ComInterfaceWrapper(D3D8.IDirect3DVertexBuffer8, pVB8, True)
	
	return "Succeeded to create Direct3D8"
}

D3D8CreatePixelShader(codestring, dvc)
{	
	blob=""
	r := D3DX9.Asm2DXBC(codestring, blob)
	if (r) 
	return logerr("D3D8CreatePixelShader: D3D9.Asm2DXBC Failed `n" r)
	r := dllcall(IDirect3DDevice8.CreatePixelShader, ptr, dvc, ptr, dllcall(numget(numget(blob+0, "ptr")+A_PtrSize*3, "ptr"), uint, blob), "ptr*", hShader)
	dllcall(numget(numget(blob+0, "ptr")+A_PtrSize*2, "ptr"), uint, blob)
	if (r)
	return logerr("D3D8CreatePixelShader: IDirect3DDevice8::CreatePixelShader " r)
	return hShader
	
}

D3D8SetPixelFormat(s)
{
	if instr(s, "DX")
	return FourCC(s)
	f := {"A8RGB" : D3DFMT_A8R8G8B8, "X8RGB" : D3DFMT_X8R8G8B8, "RG6B"  : D3DFMT_R5G6B5
	     ,"X1RGB" : D3DFMT_X1R5G5B5, "A1RGB" : D3DFMT_A1R5G5B5, "A4RGB" : D3DFMT_A4R4G4B4}	       
	return f[s]
}

D3D8GetPixelFormat(fmt)
{
	f := {D3DFMT_A8R8G8B8 "": "A8RGB", D3DFMT_X8R8G8B8 "": "X8RGB", D3DFMT_A4R4G4B4 "": "A4RGB"
	     ,D3DFMT_X1R5G5B5 "": "X1RGB", D3DFMT_A1R5G5B5 "": "A1RGB", D3DFMT_R5G6B5   "": "RG6B"}
	loop, 5
	f[FourCC("DXT" A_index) ""] := "DXT" A_index			 
	return f[fmt . ""]
}

D3D8LoadManagedTexture(pDevice, file)
{
	pT := 0
	pS := 0
	
	if ! fileexist(file)
		return
	if ! px := OpenDDS(file, hFile)
		return logerr("Unknown pixelformat")
	
	n := (DDS_HEADER.dwFlags & 0x20000) ? DDS_HEADER.dwMipMapCount : 1
	if (r := dllcall(IDirect3DDevice8.CreateTexture, uint, pDevice, uint, DDS_HEADER.dwWidth, uint, DDS_HEADER.dwHeight, uint, n
	                                               , uint, 0, uint, D3D8SetPixelFormat(px), uint, 1, "uint*", pT) != 0)
		return logerr("Failed to create texture " r " " D3D8.err[r . ""])	
		
	bypp := instr(px, "8") ? 4 : 2
	if instr(px, "D")
	{
		bypp                := (px="DXT1") ? 2 : 4
		DDS_HEADER.dwHeight := (DDS_HEADER.dwHeight + 3) / 4	
	}
	w   := DDS_HEADER.dwWidth
	h   := DDS_HEADER.dwHeight
	msk := 0xFFFFFFFF
	loop
	{
		if dllcall(IDirect3DTexture8.GetSurfaceLevel, uint, pT, uint, A_index-1, "uint*", pS)
			break
		pS := dllcall(IDirect3DSurface8.release, uint, pS)
		printl("Lock lvl " A_index-1 ": " dllcall(IDirect3DTexture8.LockRect, uint, pT, uint, A_index-1, "uint64*", r, uint, 0, uint, 0) errorlevel)
		dllcall(g_.p.LoadSurfData, uint, r >> 32, uint, hFile, uint, r & msk, uint, w, uint, h, uint, bypp)
		printl("UnLock lvl " A_index-1 ": " dllcall(IDirect3DTexture8.UnLockRect, uint, pT, uint, A_index-1))
		w /= 2
		h /= 2
	}	
	return pT
}

FindOffSrfc8(s, u)
{
	if (rs := g_HD.trgts.value(s))
	{
		;Logerr("Text known")
		AddRef(rs)	
		return rs
	} else {
		D := struct(D3DSURFACE_DESC)
		dllcall(numget(numget(s+0, "ptr")+A_PtrSize*8), uint, s, uint, D[])	
		if (u & 1)
		{
			;Logerr("RT unknown")
			r := dllcall(IDirect3DDevice8.CreateRenderTarget, uint, g_.pDevice8, uint, D.Width*D3D8_HOOKS.scale	
			, uint, D.Height*D3D8_HOOKS.scale, uint, D.Format, uint, D.MultiSampleType, uint, 0, "uint*", rs) 
			if (r) 
			return logerr("Failed to create render target")
			AddRef(rs)				
			g_HD.trgts._add(s, rs)
			return rs	
		} else if (u & 2) {
			;Logerr("Z unknown")
			r := dllcall(IDirect3DDevice8.CreateDepthStencilSurface, uint, g_.pDevice8, uint, D.Width*D3D8_HOOKS.scale	
			, uint, D.Height*D3D8_HOOKS.scale, uint, D.Format, uint, D.MultiSampleType, "uint*", rs) 
			logerr("Create z" r " " rs " " D.Width "x" D.Height)
			if (r) 
			return logerr("Failed to create z surface")
			AddRef(rs)				
			g_HD.trgts._add(s, rs)
			return rs	
		}		
	}
}

FindCbSrfc8Face(t, s)
{
	loop, 6
	{
		if dllcall(IDirect3DCubeTexture8.GetCubeMapSurface, uint, t, uint, A_index-1, uint, 0, "uint*", pCf)
		return -1
		else Release(pCf)
		if (pCf = s)
		return A_index-1
	}
	return -1	
}

FindCbSrfc8(t, s, u)
{
	if (r := dllcall("peixoto.dll\D3D8GetReplacement", ptr, t))
	{
		f   := (x:=dllcall(g_.p.GtCbFc, uint, s)) & 0xf
		lvl := (x&0xf)>>4
		Release(t)
		dllcall(IDirect3DCubeTexture8.GetCubeMapSurface, uint, r, uint, f, uint, lvl, "uint*", rs)
		return rs
	} else {
		D := struct(D3DSURFACE_DESC)
		dllcall(IDirect3DSurface8.GetDesc, uint, s, uint, D[])	
		if dllcall(IDirect3DDevice8.CreateCubeTexture, uint, g_.pDevice8, uint, D.Width*D3D8_HOOKS.scale, uint, 1
	                                                 , uint, u, uint, D.format, uint, 0, "uint*", r)		
		{
			Release(t)
			return logerr("Can't create cube texture ")
		}
		dllcall("peixoto.dll\D3D8ReplaceRTTexture", ptr, t, ptr, r)
		Release(t)	
		f   := (x:=dllcall(g_.p.GtCbFc, uint, s)) & 0xf
		lvl := (x&0xf)>>4		
		dllcall(IDirect3DCubeTexture8.GetCubeMapSurface, uint, r, uint, f, uint, lvl, "uint*", rs)	
		return rs	
	}	
}

FindSrfc8(s, u="")
{
	if (s=g_.Proxies.clr.s) {
		dllcall(numget(numget(g_.proxies.rt.s+0, "ptr")+4, "ptr"), uint, g_.proxies.rt.s)
		return g_.proxies.rt.s
	} else if (s=g_.Proxies.z.s) {
		dllcall(numget(numget(g_.proxies.rt.zs+0, "ptr")+4, "ptr"), uint, g_.proxies.rt.zs)
		return g_.proxies.rt.zs		
	}
	
	t := dllcall(g_.p.GtCntnr8, uint, s, astr, "TX2D")
	if (t=0)
	{
		t := dllcall(g_.p.GtCntnr8, uint, s, astr, "CUBE")
		return t ? FindCbSrfc8(t, s, u) : FindOffSrfc8(s, u)
	}
	
	if (r := dllcall("peixoto.dll\D3D8GetReplacement", ptr, t))
	{
		Release(t)
		dllcall(IDirect3DTexture8.GetSurfaceLevel, uint, r, uint, 0, "uint*", rs) 
		return rs
	} else {
		D := struct(D3DSURFACE_DESC)
		dllcall(numget(numget(s+0, "ptr")+A_PtrSize*8), uint, s, uint, D[])		
		hr := dllcall(IDirect3DDevice8.CreateTexture, uint, g_.pDevice8, uint, D.Width*D3D8_HOOKS.scale, uint, D.Height*D3D8_HOOKS.scale
											    , uint, 1, uint, D.usage, uint, D.format, uint, 0, "uint*", r)
		if (hr)
		{			
			Release(t)
			return logerr("Can't create texture "  D.Width "x" D.Height " " s " " D.usage " "  D.format " " g_.pDevice8 " " hr " for" t)
		} 		
		logerr("Created texture " D.Width "x" D.Height)		
		dllcall(IDirect3DTexture8.GetSurfaceLevel, uint, r, uint, 0, "uint*", rs) 
		dllcall("peixoto.dll\D3D8ReplaceRTTexture", ptr, t, ptr, r)		
		Release(t)
		return rs	
	}	
}

FindSDSrfc(HD, u)
{
	if (HD=g_.proxies.rt.s) 
	{
		dllcall(numget(numget(g_.Proxies.clr.s+0, "ptr")+4, "ptr"), uint, g_.Proxies.clr.s)
		return g_.proxies.clr.s
	} else if (HD=g_.proxies.rt.zs) 
	{
		dllcall(numget(numget(g_.Proxies.z.s+0, "ptr")+4, "ptr"), uint, g_.Proxies.z.s)
		return g_.Proxies.z.s	
	} else if ( SD := g_HD.trgts.Key(HD) )
	{
		dllcall(numget(numget(SD+0, "ptr")+4, "ptr"), uint, SD)
		return SD
	} else if ( cntr := dllcall(g_.p.GtCntnr8, uint, s, astr, "TX2D") )
	{
		if (r := dllcall("peixoto.dll\D3D8GetSDTexture", ptr, cntr))
		{
			Release(cntr)
			dllcall(IDirect3DTexture8.GetSurfaceLevel, uint, r, uint, 0, "uint*", rs) 
			return rs
		}
	} 
	;logerr("Srfc not found") ;enclave		
}

class SProxie8 {
__new(w, h, m, f, zf="")
{
	r := dllcall(IDirect3DDevice8.CreateRenderTarget, uint, g_.pDevice8, uint, w, uint, h
													, uint, f, uint, m, uint, 0, "uint*", s:=0)
	Logerr("S Proxie: color buffer:        " r " " D3D8.err[r . ""])
	if (r)
	return r
	this.s := s	
	
	if zf
	{
		r := dllcall(IDirect3DDevice8.CreateDepthStencilSurface, uint, g_.pDevice8, uint, w, uint, h 
	                                                           , uint, zf, uint, m, "uint*", z:=0)
		Logerr("S Proxie: z buffer:            " r " " D3D8.err[r . ""])
		if (r)
		return r	
		this.zs := z		
	}	
	this.t := new Proxie8(w, h, f, zf)
}
tx(){
	dllcall(IDirect3DDevice8.CopyRects, uint, g_.pDevice8, uint, this.s, uint, 0, uint, 0, uint, this.t.s, uint, 0)
	return this.t.t
}
__delete(){
	this.t := ""
	(this.s)  ? printl("Release clr surface " dllcall(numget(numget(this.s+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.s)	)
	(this.zs) ? printl("Release z surface   " dllcall(numget(numget(this.zs+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.zs))
}
}

class Proxie8 {
__new(w, h, f, zf="", m=0)
{
	u := m ? 0:1
	r := dllcall(IDirect3DDevice8.CreateTexture, uint, g_.pDevice8, uint, w, uint, h, uint, 1
	                                           , uint, u, uint, f, uint, m, "uint*", t:=0)
	Logerr("Proxie: color buffer:         " r " " D3D8.err[r . ""])
	if (r)
	return r	
	r := dllcall(IDirect3DTexture8.GetSurfaceLevel, uint, t, uint, 0, "uint*", s:=0)
	Logerr("Proxie: color buffer level 0: " r D3D8.err[r . ""])	
	if (r)
	return r
	this.t := t
	this.s := s
	
	if zf
	{
		r := dllcall(IDirect3DDevice8.CreateTexture, uint, g_.pDevice8, uint, w, uint, h, uint, 1
	                                               , uint, 2, uint, zf, uint, 0, "uint*", t:=0)
		Logerr("Proxie: z buffer:             " r " " D3D8.err[r . ""])
		if (r)
		return r	
		r := dllcall(IDirect3DTexture8.GetSurfaceLevel, uint, t, uint, 0, "uint*", s:=0)
		Logerr("Proxie: z buffer level 0:     " r D3D8.err[r . ""])	
		if (r)
		return r
		this.zt := t
		this.zs := s
	}	
	;dllcall(IDirect3DDevice8.SetRenderTarget, uint, g_.pDevice8, uint, this.s, uint, this.zs)	
}
tx(){
	return this.t
}
__Delete(){
	(this.s)  ? PRINTL("Release clr surface " dllcall(numget(numget(this.s+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.s)	)
	(this.zs) ? PRINTL("Release z surface   " dllcall(numget(numget(this.zs+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.zs))	

	(this.t)  ? PRINTL("Release clr texture " dllcall(numget(numget(this.t+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.t))
	(this.zt) ? PRINTL("Release z texture   " dllcall(numget(numget(this.zt+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.zt))
	
}
}

GetTargets()
{
	dllcall(IDirect3DDevice8.GetRenderTarget, uint, g_.pDevice8, "uint*", rt:=0)	
	dllcall(IDirect3DDevice8.GetDepthStencilSurface, uint, g_.pDevice8, "uint*", ds:=0)	
	return {"s" : rt, "zs" : ds}
}

SetTargets(prx="")
{
	if prx
	{
		r := dllcall(IDirect3DDevice8.SetRenderTarget, uint, g_.pDevice8, uint, prx.s, uint, prx.zs)
		return		
	} 
	dllcall(IDirect3DDevice8.GetBackBuffer, uint, g_.pDevice8, uint, 0, uint, 0, "uint*", b:=0)
	dllcall(IDirect3DDevice8.SetRenderTarget, uint, g_.pDevice8, uint, b, uint, 0, uint)	
	b ? Release(b)		
}

