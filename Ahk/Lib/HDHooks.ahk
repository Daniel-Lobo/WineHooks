#include lib\SurfaceHooks.ahk
global g_HD   := {}
g_HD.Sclr     := struct("LPVOID ww, hh, DWORD step[4]; DWORD xOffset; DWORD x, y, w, h; DWORD dx, dy, dw, dh; LPVOID src, dst;")
g_HD._Sclr    := struct("LPVOID ww, hh, DWORD step[4]; DWORD xOffset; DWORD x, y, w, h; DWORD dx, dy, dw, dh; LPVOID src, dst;")
g_HD.Sclr.ww  := 0
g_HD.Sclr.hh  := 0
g_HD._Sclr.ww := 0
g_HD._Sclr.hh := 0
g_HD.rect     := struct(_RECT)
g_HD.ZBLTFX   := struct(DDBLTFX)
g_HD.DDBLTFX  := struct(DDBLTFX)
g_HD.DDBLTFX.dwSize                           := DDBLTFX.size()
DDBLTFX.dwSize                                := DDBLTFX.size()
DDBLTFX.dwDDFX                                := 0x00000008 ;DDBLTFX_NOTEARING 
DDBLTFX.ddckSrcColorkey.dwColorSpaceLowValue  := 0
DDBLTFX.ddckSrcColorkey.dwColorSpaceHighValue := 0
DDBLTFX.dwFillColor                           := 0
D3DVIEWPORT.dwSize                            := D3DVIEWPORT.size()
global _D3DVIEWPORT2                          := struct(D3DVIEWPORT2)
_D3DVIEWPORT2.dwSize                          := D3DVIEWPORT2.size()
g_HD.vw                                       := struct(D3DVIEWPORT2)
g_HD.vw2                                      := struct(D3DVIEWPORT2)
D3DHOOKS_DATA.VW2                             := g_HD.vw2[]

D3DHOOKS_DATA.scale            := 1
D3DHOOKS_DATA.displace         := False
D3DHOOKS_DATA.vert_displace    := False
D3DHOOKS_DATA.callback         := False
D3DHOOKS_DATA.fix_screencoords := (g_.cfg.HLFPX) ? True : False
D3DHOOKS_DATA.rct         := dllcall("VirtualAlloc", uint, 0, uint, 32, Int, 0x00001000, uint, 0x04)   
D3DHOOKS_DATA._rct        := dllcall("VirtualAlloc", uint, 0, uint, 32, Int, 0x00001000, uint, 0x04)  
D3DHOOKS_DATA.vertex_data := dllcall("VirtualAlloc", uint, 0, uint, 16777216, Int, 0x00001000 
									               , uint, 0x04) ; 16MB												  

/* catch the desktop resolution 
 */
g_.desktop := Desk()
logerr("Desktop " g_.desktop.w "x" g_.desktop.h)	
SetupHD(p2, p3)
{
	g_.res                 := g_.desktop	
	D3DHOOKS_DATA.HD_H     := g_.desktop.h	
	D3DHOOKS_DATA.HD_W     := g_.desktop.W		
	D3DHOOKS_DATA.w        := p2
	D3DHOOKS_DATA.h        := p3
	D3DHOOKS_DATA.scale    := D3DHOOKS_DATA.HD_H/D3DHOOKS_DATA.h
	D3DHOOKS_DATA.HD_X     := (D3DHOOKS_DATA.HD_W - p2*D3DHOOKS_DATA.scale)/2 
	D3DHOOKS_DATA.displace := True
	
	logerr("`nResolution\Viewport:")
	logerr("Requested                 : " D3DHOOKS_DATA.w " x " D3DHOOKS_DATA.h)
	logerr("Real                      : " D3DHOOKS_DATA.HD_W " x " D3DHOOKS_DATA.HD_H)
	logerr("Correction                : " D3DHOOKS_DATA.scale)
	logerr("Viewport width correction : " D3DHOOKS_DATA.HD_X)
		
	_rect_setscale()
	if g_.cfg.MCLP
	ClipCursor(0)
	dllcall("Peixoto.dll\DDrawDisplayModeChanged", uint, p2, uint, p3)
	dllcall("Peixoto.dll\SetMouseHooksParams", float, D3DHOOKS_DATA.HD_W/D3DHOOKS_DATA.w, float, D3DHOOKS_DATA.scale
											 , uint, D3DHOOKS_DATA.HD_X, uint, D3DHOOKS_DATA.w, uint, D3DHOOKS_DATA.h)		
	dllcall("peixoto.dll\Scaler", uint, D3DHOOKS_DATA.w, uint, D3DHOOKS_DATA.h, uint, D3DHOOKS_DATA.HD_W-D3DHOOKS_DATA.HD_X*2
	                            , uint, D3DHOOKS_DATA.HD_H, uint, D3DHOOKS_DATA.HD_X, uint, g_HD.Sclr[]) 	
	dllcall("peixoto.dll\Scaler", uint, D3DHOOKS_DATA.w, uint, D3DHOOKS_DATA.h, uint, D3DHOOKS_DATA.HD_W-D3DHOOKS_DATA.HD_X*2
	                            , uint, D3DHOOKS_DATA.HD_H, uint, D3DHOOKS_DATA.HD_X, uint, g_HD._Sclr[]) 							
}

/* ========================================================================
 * =============================Display Modes==============================
 */

CheckMode(pDD, w, h, dpt, lvl)
{
	(D := struct(DDSURFACEDESC2)).dwSize := (lvl < 3) ? DDSURFACEDESC.size() : DDSURFACEDESC2.size()
	dllcall([IDirectDraw, IDirectDraw2, IDirectDraw4, IDirectDraw7][lvl].GetDisplayMode, uint, pDD, uint, D[])
	if (w != D.dwWidth) || (h != D.dwHeight) || (dpt != D.ddpfPixelFormat.dwRGBBitCount)
	return 1
} 

SetDisplayMode(byref p2, byref p3, byref p4)
{
	D3DHOOKS_DATA.D     := p4
	(g_.cfg.32bit) ? p4 := 32
	if g_.cfg.HD
	{
		SetupHD(p2, p3)
		p2 := g_.desktop.w
		p3 := g_.desktop.h
	} else	{
		g_.res := {"w" : p2, "h" : p3}
		D3DHOOKS_DATA.w := p2
		D3DHOOKS_DATA.h := p3
		_rect.left := 0, _rect.top := 0, _rect.right := p2, _rect.bottom := p3
		rect.left  := 0,  rect.top := 0,  rect.right := p2,  rect.bottom := p3
	}
	D3DHOOKS_DATA.HD_W := p2
	D3DHOOKS_DATA.HD_H := p3
	/*
	if g_.cfg.8bitColorfix
	{
		DDRAWI_DIRECTDRAW_INT[] := p1
		DDRAWI_DIRECTDRAW_LCL[] := DDRAWI_DIRECTDRAW_INT.lpLcl
		if p4 = 8
		DDRAWI_DIRECTDRAW_LCL.dwAppHackFlags |= 0x800
		else DDRAWI_DIRECTDRAW_LCL.dwAppHackFlags &= ~ 0x800
	}
	*/
}

_rect_setscale(scale="")
{
	if ! g_.cfg.HD
		g_.desktop := {"w" : D3DHOOKS_DATA.HD_W, "h" : D3DHOOKS_DATA.HD_H}
	if scale {
		_rect.left   := (g_.desktop.w - D3DHOOKS_DATA.w*scale)/2
		_rect.top    := (g_.desktop.h - D3DHOOKS_DATA.h*scale)/2
		_rect.right  := _rect.left + D3DHOOKS_DATA.w*scale
		_rect.bottom := _rect.top + D3DHOOKS_DATA.h*scale
		rect.left   := (D3DHOOKS_DATA.HD_W - D3DHOOKS_DATA.w*scale)/2
		rect.top    := (D3DHOOKS_DATA.HD_H - D3DHOOKS_DATA.h*scale)/2
		rect.right  := rect.left + D3DHOOKS_DATA.w*scale
		rect.bottom := rect.top + D3DHOOKS_DATA.h*scale
	} else {
		res_correct  :=  g_.desktop.h/D3DHOOKS_DATA.h
		_RECT.left   := (g_.desktop.w - D3DHOOKS_DATA.w*res_correct)/2
		_RECT.right  := g_.desktop.w - _RECT.left
		_RECT.bottom := g_.desktop.h
		_RECT.top    := 0
		rect.left   := (D3DHOOKS_DATA.HD_W - D3DHOOKS_DATA.w*D3DHOOKS_DATA.HD_H/D3DHOOKS_DATA.h)/2
		rect.right  := D3DHOOKS_DATA.HD_W - rect.left
		rect.bottom := D3DHOOKS_DATA.HD_H
		rect.top    := 0
	}
}

ResList()
{
	d := g_.desktop
	w := d.w/d.h * 540
	d := d.w "x" d.h
	
	r := "512x384 640x480 "
	r .= "720x540 " w "x540 "
	r .= "800x600 1024x768 "
	for k, v in ["1280x720", "1920x1080"]
	{
		if instr(g_.cfg.rlst, v)
			r .= v " "
	}
	r .= d
	
	l := []
	for k, v in strsplit(r, " ")
	l.Push(strsplit(v, "x"))
	return l
}

IDirectDraw7_EnumDisplayModes(p1, p2, p3, p4, p5)
{
	desc         := struct(DDSURFACEDESC2)
	desc.dwSize  := DDSURFACEDESC2.size() 
	list         := ResList()
	sys          := [1, 0, 0]
	for k, v in list
	{
		for kk, vv in ["PAL8", "RG6B", "X8RGB"]
		{
			if ! isobject( s := new Surface7(p1, vv, v[1]<<16 | v[2], sys[kk]) )
			{
				dllcall(IDirectDraw7.SetCooperativeLevel, uint, p1, uint, 0, uint, DDSCL_NORMAL)
				s := new Surface7(vv, v[1]<<16 | v[2], sys[kk])
			}
			dllcall(IDirectDrawSurface7.GetSurfaceDesc, uint, s.surface7, uint, desc[])
			desc.dwFlags       |= 0x00040000
			desc.dwRefreshRate := 60
			logerr(kk " DD7 " desc.dwWidth "x" desc.dwHeight "-" desc.lPitch)
			if ! dllcall(p5, uint, desc[], uint, p4)	
			break
		}				
	} 
}

IDirectDraw4_EnumDisplayModes(p1, p2, p3, p4, p5)
{
	GUID_FromString(iid, ddraw.IID_IDirectDraw)
	if ! dllcall(IDirectDraw.QueryInterface, uint, p1, uint, &iid, "uint*", DD:=0)
	dllcall(IDirectDraw.Release, uint, DD)
	else return dllcall(IDirectDraw4.EnumDisplayModes, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
		
	desc         := struct(DDSURFACEDESC2)
	desc.dwSize  := DDSURFACEDESC2.size() 
	list         := ResList()
	sys          := [0, 0, 1]
	for kk, vv in ["X8RGB", "RG6B", "PAL8"]	
	{
		for k, v in list
		{
			if ! isobject( s := new Surface(DD, vv, v[1]<<16 | v[2], sys[kk]) )
			{
				dllcall(IDirectDraw.SetCooperativeLevel, uint, DD, uint, 0, uint, DDSCL_NORMAL)
				s := new Surface(DD, vv, v[1]<<16 | v[2], sys[kk])
			}
			dllcall(IDirectDrawSurface4.GetSurfaceDesc, uint, s.Surface4, uint, desc[])
			;logerr(kk " " desc.dwWidth "x" desc.dwHeight "-" desc.lPitch)
			if ! dllcall(p5, uint, desc[], uint, p4)	
			break
		}
	}		
	return 0	
}

IDirectDraw_SetDisplayMode(p1, p2, p3, p4)
{	
	r:=0
	SetDisplayMode(p2, p3, p4)
	logErr(IDirectDraw2.Unhook("SetDisplayMode"))
	logErr(IDirectDraw4.Unhook("SetDisplayMode"))
	if CheckMode(p1, p2, p3, p4, 1)
   	r := dllcall(IDirectDraw.SetDisplayMode, uint, p1, int, p2, int, p3, int, p4, uint)
	logErr(IDirectDraw2.hook("SetDisplayMode"))
	logErr(IDirectDraw4.hook("SetDisplayMode"))
    printl("IDirectDraw_SetDisplayMode " D3DHOOKS_DATA.HD_W "x" D3DHOOKS_DATA.HD_H r ddraw.result[r . ""])
	return r
} 
  
IDirectDraw2_SetDisplayMode(p1, p2, p3, p4, p5, p6)
{
	r:=0
	if (g_.cfg.SXTY)
	p5 := 60
	SetDisplayMode(p2, p3, p4)
	if CheckMode(p1, p2, p3, p4, 2)
   	r := dllcall(IDirectDraw2.SetDisplayMode, uint, p1, int, p2, int, p3, int, p4, int, p5, int, p6, uint)
    printl("IDirectDraw2_SetDisplayMode " r ddraw.result[r . ""])		
	return r
} 

IDirectDraw4_SetDisplayMode(p1, p2, p3, p4, p5, p6)
{	
	r:=0
	if (g_.cfg.SXTY)
	p5 := 60
	printl("IDirectDraw4_SetDisplayMode " p4)	
	SetDisplayMode(p2, p3, p4)
		
	;This check causes trouble when alt-tabing, but NEFS solves it
	if CheckMode(p1, p2, p3, p4, 3)
	r := dllcall(IDirectDraw4.SetDisplayMode, uint, p1, int, p2, int, p3, int, p4, int, p5, int, p6)
	return r
}

IDirect3DDevice_CreateExecuteBuffer(p1, p2, p3, p4)
{
	D3DEXECUTEBUFFERDESC[] := p2
	D3DEXECUTEBUFFERDESC.dwCaps := D3DDEBCAPS_SYSTEMMEMORY 
	return dllcall(IDirect3DDevice.CreateExecuteBuffer, uint, p1, uint, p2, uint, p3, uint, p4)
}

/* ========================================================================
 * =============================Viewports==================================
 */

IDirect3DViewPort_GetViewPort(p1, p2)
{
	if ! (r := dllcall(IDirect3DViewPort.GetViewPort, uint, p1, uint, p2))
	dllcall("RtlMoveMemory", ptr, p2, ptr, g_HD.vw[], int, D3DVIEWPORT.size())		
	return r		
}

IDirect3DViewPort_SetViewPort(p1, p2)
{	
	VarSetCapacity(v, D3DVIEWPORT.size())
	dllcall("RtlMoveMemory", ptr, &v, ptr, p2, int, D3DVIEWPORT.size())	
	dllcall("RtlMoveMemory", ptr, g_HD.vw[], ptr, p2, int, D3DVIEWPORT.size())	
	D3DVIEWPORT[]        := p2
	D3DVIEWPORT[]        := &v	
	
	r := dllcall(IDirect3DViewPort.SetViewPort, uint, p1, uint, D3DVIEWPORT[])	
	return r	
}	

IDirect3DViewPort2_SetViewPort2(p1, p2)
{	
	D3DVIEWPORT2[]        := p2
	D3DVIEWPORT2.dwY      *= D3DHOOKS_DATA.scale
	D3DVIEWPORT2.dwX      *= D3DHOOKS_DATA.scale
	D3DVIEWPORT2.dwX      += D3DHOOKS_DATA.HD_X	
	D3DVIEWPORT2.dwWidth  *= D3DHOOKS_DATA.scale
	D3DVIEWPORT2.dwHeight *= D3DHOOKS_DATA.scale
    r := dllcall(IDirect3DViewPort2.SetViewPort2, uint, p1, uint, D3DVIEWPORT2[])
	return r	
}

IDirect3DViewPort3_GetViewPort2(p1, p2)
{	
	if ! (r := dllcall(IDirect3DViewPort3.GetViewPort2, uint, p1, uint, p2))
	dllcall("RtlMoveMemory", ptr, p2, ptr, g_HD.vw2[], int, D3DVIEWPORT2.size())		
	return r
}

IDirect3DViewPort3_SetViewPort2(p1, p2)
{	
	VarSetCapacity(v, D3DVIEWPORT2.size())
	dllcall("RtlMoveMemory", ptr, &v, ptr, p2, int, D3DVIEWPORT2.size())	
	dllcall("RtlMoveMemory", ptr, g_HD.vw2[], ptr, p2, int, D3DVIEWPORT2.size())	
	D3DVIEWPORT2[]        := p2	
	D3DVIEWPORT2[]        := &v
	D3DVIEWPORT2.dwY      *= D3DHOOKS_DATA.scale
	D3DVIEWPORT2.dwX      *= D3DHOOKS_DATA.scale
	D3DVIEWPORT2.dwX      += D3DHOOKS_DATA.HD_X	
	D3DVIEWPORT2.dwWidth  *= D3DHOOKS_DATA.scale 
	D3DVIEWPORT2.dwHeight *= D3DHOOKS_DATA.scale 
	if (floor(D3DVIEWPORT2.dvClipX) > -1.0) 
	{		
		D3DVIEWPORT2.dvClipX      *= D3DHOOKS_DATA.scale
		D3DVIEWPORT2.dvClipX      += D3DHOOKS_DATA.HD_X
		D3DVIEWPORT2.dvClipWidth  *= D3DHOOKS_DATA.scale
		D3DVIEWPORT2.dvClipHeight *= D3DHOOKS_DATA.scale
	} 
	r := dllcall(IDirect3DViewPort3.SetViewPort2, uint, p1, uint, D3DVIEWPORT2[])
	return r	
}

IDirect3DViewPort3_SetViewPort(p1, p2)
{
	printl("Setviewport 1")
	return 0
}	

IDirect3DViewPort_Clear(p1, p2, p3, p4)
{		
	sz:=VarSetCapacity(v, g_HD.rect.size()*p2)
	dllcall("RtlMoveMemory", ptr, &v, ptr, p3, int, sz)	
	g_HD.rect[] := &v	
	loop, % p2
	{
		g_HD.rect.bottom *= D3DHOOKS_DATA.scale 
		g_HD.rect.right  *= D3DHOOKS_DATA.scale 
		g_HD.rect.right  += D3DHOOKS_DATA.HD_X	
		g_HD.rect[]      += rect.size()
	}
	r := dllcall(IDirect3DViewPort.Clear, uint, p1, uint, p2, uint, &v, uint, p4)	     
	return r	
}

IDirect3DViewPort2_Clear(p1, p2, p3, p4)
{
	sz:=VarSetCapacity(v, g_HD.rect.size()*p2)
	dllcall("RtlMoveMemory", ptr, &v, ptr, p3, int, sz)	
	g_HD.rect[] := &v
	loop, % p2
	{
		g_HD.rect.bottom *= D3DHOOKS_DATA.scale 
		g_HD.rect.right  *= D3DHOOKS_DATA.scale 
		g_HD.rect.right  += D3DHOOKS_DATA.HD_X	
		g_HD.rect[]      += g_HD.rect.size()
	}
	r := dllcall(IDirect3DViewPort2.Clear, uint, p1, uint, p2, uint, &v, uint, p4)	
	return r	
}

IDirect3DViewPort3_Clear(p1, p2, p3, p4)
{
	sz := VarSetCapacity(v, g_HD.rect.size()*p2)
	dllcall("RtlMoveMemory", ptr, &v, ptr, p3, int, sz)	
	g_HD.rect[] := &v
	loop, % p2
	{
		g_HD.rect.bottom *= D3DHOOKS_DATA.scale 
		g_HD.rect.right  *= D3DHOOKS_DATA.scale 
		g_HD.rect.right  += D3DHOOKS_DATA.HD_X	
		g_HD.rect[]      += g_HD.rect.size()
	}
	r := dllcall(IDirect3DViewPort3.Clear, uint, p1, uint, p2, uint, &v, uint, p4)
	return r	
}

IDirect3DViewPort3_Clear2(p1, p2, p3, p4, p5, p6, p7)
{	
	sz := VarSetCapacity(v, g_HD.rect.size()*p2)
	dllcall("RtlMoveMemory", ptr, &v, ptr, p3, int, sz)	
	g_HD.rect[] := &v	
	loop, % p2
	{
		g_HD.rect.bottom *= D3DHOOKS_DATA.scale 
		g_HD.rect.right  *= D3DHOOKS_DATA.scale 
		g_HD.rect.right  += D3DHOOKS_DATA.HD_X					
		g_HD.rect[]      += g_HD.rect.size()
	}
	r := dllcall(IDirect3DViewPort3.Clear2, uint, p1, uint, p2, uint, &v, uint, p4, uint, p5, uint, p6, uint, p7)		
	return r	
}
 
InitHDHooks3()
{    
	logErr(IDirectDraw.hook("SetDisplayMode"))
	logErr(IDirectDraw2.hook("SetDisplayMode"))
	logErr(IDirectDraw4.hook("SetDisplayMode"))
	logErr(IDirectDraw4.hook("EnumDisplayModes"))
	logerr(IDirect3DViewPort3.Hook("SetViewPort2"))
	logerr(IDirect3DViewPort3.Hook("GetViewPort2"))
	logerr(IDirect3DViewport3.Hook("Clear"))
	logerr(IDirect3DViewport3.Hook("Clear2"))	
	
	logerr(IDirect3DViewPort.Hook("SetViewPort"))
	logerr(IDirect3DViewPort.Hook("GetViewPort"))
	
	SetupPrxs4()	
	
	logErr(IDirect3DViewport3.dllHook("TransformVertices", "TransformVertices3Hook"))
	logErr(IDirect3DDevice3.dllHook("DrawPrimitive", "DrawPrimitive3Hook"))	
	logErr(IDirect3DDevice3.dllHook("DrawIndexedPrimitive", "DrawIndexedPrimitive3Hook"))
	logErr(IDirect3DDevice3.dllHook("DrawPrimitiveVB", "DrawPrimitive3VBHook"))
	logErr(IDirect3DDevice3.dllHook("DrawIndexedPrimitiveVB", "DrawIndexedPrimitive3VBHook"))
	
	
	D3DHOOKS_DATA.p_DrawPrimitive          := IDirect3DDevice3.DrawPrimitive
	D3DHOOKS_DATA.p_DrawIndexedPrimitive   := IDirect3DDevice3.DrawIndexedPrimitive
	D3DHOOKS_DATA.DrawPrimitive3           := IDirect3DDevice3.DrawPrimitive
	D3DHOOKS_DATA.DrawIPrimitive3          := IDirect3DDevice3.DrawIndexedPrimitive
	D3DHOOKS_DATA.p_DrawPrimitiveVB        := IDirect3DDevice3.DrawPrimitiveVB
	D3DHOOKS_DATA.p_DrawIndexedPrimitiveVB := IDirect3DDevice3.DrawIndexedPrimitiveVB
	D3DHOOKS_DATA.p_TransformVertices      := IDirect3DViewport3.TransformVertices
	D3DHOOKS_DATA.p_GetView                := IDirect3DViewPort3.GetViewPort2
	D3DHOOKS_DATA.p_SetView                := IDirect3DViewPort3.SetViewPort2
	D3DHOOKS_DATA.fix_screencoords         := (g_.cfg.HLFPX) ? True : False
	D3DHOOKS_DATA.p_GetVertexBufferDesc    := IDirect3DVertexBuffer.GetVertexBufferDesc
	D3DHOOKS_DATA.p_LockVertexBuffer       := IDirect3DVertexBuffer.Lock
	D3DHOOKS_DATA.p_UnLockVertexBuffer     := IDirect3DVertexBuffer.UnLock	

	logErr(IDirect3DDevice2.dllHook("DrawPrimitive", "DrawPrimitive2Hook"))	
	logErr(IDirect3DDevice2.dllHook("DrawIndexedPrimitive", "DrawIndexedPrimitive2Hook"))	
	D3DHOOKS_DATA.p_DrawIndexedPrimitive := IDirect3DDevice2.DrawIndexedPrimitive
	D3DHOOKS_DATA.p_DrawPrimitive        := IDirect3DDevice2.DrawPrimitive	
	
	logerr(IDirect3DDevice.DllHook("Execute", "IDirect3DDevice_ExecuteHook"))
	;logerr(IDirect3DDevice.Hook("Execute"))
	D3DHOOKS_DATA.execute := IDirect3DDevice.Execute
}

IDirect3DDevice_Execute(p1, p2, p3, p4)
{
	logerr("buff " p2)
	return dllcall(IDirect3DDevice.Execute, uint, p1, int, p2, int, p3, int, p4)
}


/* ========================================================================
 * =============================DirectX 7 =================================
 */

InitHDHooks7()
{
	logErr(IDirectDraw7.hook("SetDisplayMode"))
	logerr(IDirect3DDevice7.Hook("SetViewPort"))
	logerr(IDirect3DDevice7.Hook("Clear"))
	logErr(IDirectDraw7.hook("EnumDisplayModes"))
    if (g_.cfg.layer) 
        logErr(IDirect3DDevice7.dllHook("DrawPrimitive", "DrawPrimitive7Hook"))	
	else 
        logErr(IDirect3DDevice7.Hook("DrawPrimitive"))	
	logErr(IDirect3D7.Hook("CreateVertexBuffer"))
				
	logErr(IDirect3DDevice7.dllHook("DrawPrimitiveVB", "DrawPrimitive7VBHook"))
	D3DHOOKS_DATA.D3D7Draw := IDirect3DDevice7.DrawPrimitive
	logerr(IDirect3DDevice7.dllHook("DrawIndexedPrimitiveVB", "DrawIndexedPrimitive7VBHook"))
	D3DHOOKS_DATA.p_DrawIndexedPrimitiveVB := IDirect3DDevice7.DrawIndexedPrimitiveVB
	D3DHOOKS_DATA.p_GetVertexBufferDesc    := IDirect3DVertexBuffer7.GetVertexBufferDesc
	D3DHOOKS_DATA.p_LockVertexBuffer       := IDirect3DVertexBuffer7.Lock
	D3DHOOKS_DATA.p_UnLockVertexBuffer     := IDirect3DVertexBuffer7.UnLock	
	
	D3DHOOKS_DATA.displace              := True	
	D3DHOOKS_DATA.p_DrawPrimitiveVB     := IDirect3DDevice7.DrawPrimitiveVB
	D3DHOOKS_DATA.p_DrawPrimitive       := IDirect3DDevice7.DrawPrimitive
	D3DHOOKS_DATA.p_GetVertexBufferDesc := IDirect3DVertexBuffer7.GetVertexBufferDesc
	D3DHOOKS_DATA.p_LockVertexBuffer    := IDirect3DVertexBuffer7.Lock
	D3DHOOKS_DATA.p_UnLockVertexBuffer  := IDirect3DVertexBuffer7.Unlock	
	SetupPrxs7(0)	
	
	logerr(IDirect3DDevice7.dllHook("DrawIndexedPrimitive", "DrawIndexedPrimitive3Hook"))
	D3DHOOKS_DATA.DrawIPrimitive3   := IDirect3DDevice7.DrawIndexedPrimitive
	D3DHOOKS_DATA.DrawPrimitive3    := IDirect3DDevice7.DrawPrimitive
    
    if (g_.cfg.layer) {
        D3DHOOKS_DATA.DrawPrimitive3    := IDirect3DDevice7.DrawPrimitive
        DEVICE3_RECT.DrawPrimitive      := IDirect3DDevice7.DrawPrimitive
    }
	return	
}

IDirectDraw7_SetDisplayMode(p1, p2, p3, p4, p5, p6)
{		
	r:=0
	printl("IDirectDraw7_SetDisplayMode")	
	SetDisplayMode(p2, p3, p4)
		
	if CheckMode(p1, p2, p3, p4, 4)
	r := dllcall(IDirectDraw7.SetDisplayMode, uint, p1, int, p2, int, p3, int, p4, int, p5, int, p6)
	return r
}

IDirect3D7_CreateVertexBuffer(p1, p2, p3, p4)
{
	if (!p2)
	return D3DERR_INVALIDPARAMS	
	RW := numget(p2+4, "Uint") & 0x4
	if ( (g_.cfg.FHAL) || (g_.cfg.HD && RW) )
	numput(0x00000800, p2+4, "uint")
	return dllcall(IDirect3D7.CreateVertexBuffer, uint, p1, uint, p2, uint, p3, uint, p4)		
}

IDirect3DDevice7_SetViewPort(p1, p2)
{
	VW7 := struct(D3DVIEWPORT7)
	VarSetCapacity(v, D3DVIEWPORT7.size())
	dllcall("RtlMoveMemory", ptr, &v, ptr, p2, int, VW7.size())		
	VW7[]        := &v
	VW7.dwY      *= D3DHOOKS_DATA.scale
	VW7.dwX      *= D3DHOOKS_DATA.scale
	VW7.dwX      += D3DHOOKS_DATA.HD_X	
	VW7.dwWidth  *= D3DHOOKS_DATA.scale 
	VW7.dwHeight *= D3DHOOKS_DATA.scale 
	if dllcall(IDirect3DDevice7.SetViewPort, uint, p1, uint, VW7[])
	return dllcall(IDirect3DDevice7.SetViewPort, uint, p1, uint, p2)
	return 0
}	

IDirect3DDevice7_DrawPrimitive(p1, p2, p3, p4, p5, p6)
{
	r := dllcall("peixoto.dll\DrawPrimitive7Hook", uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)
	d := new ComInterfaceWrapper(d3d.IDirect3DDevice7, p1, True)	
	d.released := 1	
	logerr("IDirect3DDevice7_DrawPrimitive hook" IsObject(IDirect3DDevice7))
	logErr(IDirect3DDevice7.UnHook("DrawPrimitive"))
	logErr(IDirect3DDevice7.dllHook("DrawPrimitive", "DrawPrimitive7Hook"))	
	logErr(d.dllHook("DrawPrimitive", "DrawPrimitive7Hook"))	
	D3DHOOKS_DATA.DrawPrimitive3    := IDirect3DDevice7.DrawPrimitive
	DEVICE3_RECT.DrawPrimitive      := IDirect3DDevice7.DrawPrimitive	
	return r	
}

IDirect3DDevice7_DrawPrimitiveVB(p1, p2, p3, p4, p5, p6)
{	
	g_.call += 1
	static vertice := struct("float x; float y; float z; float w")
	dllcall(IDirect3DVertexBuffer7.GetVertexBufferDesc, uint, p3, uint, D3DVERTEXBUFFERDESC[])
	dllcall(IDirect3DVertexBuffer7.lock, uint, p3, uint, DDLOCK_READONLY, "uint*", src, uint, 0)		
			
	dwVertexTypeDesc := D3DVERTEXBUFFERDESC.dwFVF 
	dwVertexCount := D3DVERTEXBUFFERDESC.dwNumVertices
	size := 4*4
	(dwVertexTypeDesc & D3DFVF_DIFFUSE) ? size += 4
	(dwVertexTypeDesc & D3DFVF_SPECULAR) ? size += 4 
	size += ((dwVertexTypeDesc & D3DFVF_TEXCOUNT_MASK)>>D3DFVF_TEXCOUNT_SHIFT) * 8
	dllcall("peixoto.dll\ScaleVertices", ptr, src+p4*size, int, dwVertexTypeDesc, int, p5, float, D3DHOOKS_DATA.scale, float, D3DHOOKS_DATA.HD_X)
			
	r := dllcall(IDirect3DDevice7.DrawPrimitive, uint, p1, uint, p2, uint, D3DVERTEXBUFFERDESC.dwFVF, uint, src+p4*size, uint, p5, uint, 0)
	dllcall(IDirect3DVertexBuffer7.unlock, uint, p3)	
	return 0
}	

IDirect3DDevice7_Clear(p1, p2, p3, p4, p5, p6, p7)
{
	if ! p2
		return dllcall(IDirect3DDevice7.Clear, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)
	sz := VarSetCapacity(v, g_HD.rect.size()*p2)
	dllcall("RtlMoveMemory", ptr, &v, ptr, p3, int, sz)	
	g_HD.rect[] := &v
	loop, % p2
	{
		g_HD.rect.bottom *= D3DHOOKS_DATA.scale 
		g_HD.rect.right  *= D3DHOOKS_DATA.scale 
		g_HD.rect.right  += D3DHOOKS_DATA.HD_X	
		g_HD.rect[]      += g_HD.rect.size()
	}
	r := dllcall(IDirect3DDevice7.Clear, uint, p1, uint, p2, uint, &v, uint, p4, uint, p5, uint, p6, uint, p7)	
	return r	
}