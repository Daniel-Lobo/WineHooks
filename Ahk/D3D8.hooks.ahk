global D3D8_HOOKS :=
(
"
LPVOID p_DrawPrimitive;
LPVOID p_DrawPrimitiveUP;
LPVOID p_DrawIndexedPrimitive;
LPVOID p_DrawIndexedPrimitiveUp;
LPVOID CreateVertexBuffer;
LPVOID SetStreamSource;
LPVOID SetVertexShader;
LPVOID VbLock;
LPVOID VbUnlock;
LPVOID MVbLock;
LPVOID MVbUnlock;
LPVOID VbGetDesc;
LPVOID VbLocks;
float  scale;
DWORD  HD_X;
BOOL   screenspace;
LPVOID current_vbuff;
DWORD  stride;
LPVOID vertex_data;
BOOL   HLFPX;
DWORD  SglCore;
LPVOID RTrgs;
LPVOID End;
LPVOID pIDirect3DDevice8_CreateTexture;
LPVOID pIDirect3DDevice8_UpdateTexture;
LPVOID pIDirect3DDevice8_CopyRects;
LPVOID pIDirect3DDevice8_SetTexture;
LPVOID pIDirect3DTexture8_GetSurfaceLevel;
LPVOID pIDirect3DTexture8_LockRect;
LPVOID pIDirect3DTexture8_UnlockRect;
LPVOID pIDirect3DTexture8_QueryInterface;
LPVOID pIDirect3DTexture8_Release;
LPVOID pIDirect3DSurface8_LockRect;
LPVOID pIDirect3DSurface8_UnlockRect;
LPVOID pIDirect3DSurface8_Release;
LPVOID Srfc8_Release;
LPVOID pTextureFound;
LPVOID pDumpTexture;
BOOL   ignore_release;
BOOL   searching;
LPVOID Currentexture8;
LPVOID Textures;
LPVOID Surfaces;
LPVOID Replacements;
LPVOID CreatePixelShader;
LPVOID SetPixelShader;
LPVOID DeletePixelShader;
LPVOID pShaderFound;
DWORD  Override;
BOOL   ignore_creation;
BOOL   srchng;
LPVOID Current;
LPVOID shaders;
LPVOID Overrides;
LPVOID DDI_Overrides;
DWORD  ShaderDumpsSize;
LPVOID ShaderDumps;
"
)
D3D8_HOOKS := struct(D3D8_HOOKS)
if (g_.cfg.console)
	dllcall("peixoto.dll\D3D12Config", astr, "DBUG", uint, 1)
if (g_.cfg.WHKS)
	dllcall("peixoto.dll\D3D12Config", astr, "FIXWINSIZE", uint, 1)
dllcall("peixoto.dll\InitD3D8HooksData", uint, D3D8_HOOKS[], uint, (g_.cfg.HD) ? Desk().H | (Desk().W << 16) : 0)	

#include lib\DirectX\D3D8.ahk
#include lib\TexSwapLib8.ahk
#include lib\ShaderOverride8.ahk

HookD3D8Create()
{
	D3D8Create := dllcall("GetProcAddress", ptr, dllcall("LoadLibraryW", str, A_windir "\SysWOW64\D3D8.dll"), astr, "Direct3DCreate8")
	hook       := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "Direct3DCreate8")
	logerr("D3D8Create Hook: " AltInstallHook(hook, D3D8Create))
}

Direct3DCreate8_hook(p1){
	D3DPRESENT_PARAMETERS.hDeviceWindow := ""
	g_.Proxies     := {}	
	g_.Proxie.clr  := ""
	g_.pDevice8    := ""	
	return dllcall(g_.pDirect3DCreate8, uint, 0xdc)
}

g_.p.ddiCreatePx      := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "d3dddiCreatePxShader")
g_.p.ddiDeletePx      := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "d3dddiDeletePxShader")	
g_.p.ddiSetOvrrd      := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "d3dddiSetOverride")	

g_.cfg.layer := ""
if (g_.cfg.layer)
	HookD3D8Create()
else
{
	VarSetCapacity(SysDir, 261)
	DllCall("GetSystemDirectoryW", Str, SysDir, UInt, 261)
	logerr("Direct3DCreate8 Hook: " InstallHook(isfunc("AltDirect3DCreate8") ? "AltDirect3DCreate8" : "Direct3DCreate8_hook", pDirect3DCreate8, SysDir "\d3d8.dll", "Direct3DCreate8"))
	g_.pDirect3DCreate8 := pDirect3DCreate8

	if (! dllcall("GetModuleHandleW", str, "wined3d.dll")) {  ; only load wine if not on linux
		arch        := A_PtrSize == 8 ? "x64" : "x32"
		;g_.cfg.dxvk := True
		if (g_.cfg.dxvk){
			h_wined3d8    := dllcall("LoadLibraryW", str, g_.cfg.injector_dir . "\dxvk\"  g_.cfg.dxvkv "\" arch "\d3d8.dll")
			p_dxvkCreate9 := dllcall("GetProcAddress", ptr, dllcall("LoadLibraryW", str, g_.cfg.injector_dir . "\dxvk\"  g_.cfg.dxvkv "\" arch "\d3d9.dll"), astr, "Direct3DCreate9", ptr)
			p_msCreate9   := dllcall("GetProcAddress", ptr, dllcall("LoadLibraryW", str, "d3d9.dll"), astr, "Direct3DCreate9", ptr)
			logerr("dcvk D3D9 Hook: " AltInstallHook(p_dxvkCreate9, p_msCreate9))
			dllcall("peixoto.dll\D3D12Config", astr, "DXVK", uint, 8)
		}
		else {
			dllcall("LoadLibraryW", str,  g_.cfg.injector_dir . "\wined3d\"  g_.cfg.wine "\" arch "\wined3d.dll")
			h_wined3d8  := dllcall("LoadLibraryW", str, g_.cfg.injector_dir . "\wined3d\" . g_.cfg.wine . "\" arch "\d3d8.dll")
		}	
		g_.pDirect3DCreate8 := dllcall("GetProcAddress", ptr, h_wined3d8, astr, "Direct3DCreate8")
	}

	;printl("InitDDIHooks" D3DDDI_Init())
	logerr(GetDirect3D8())
	logerr(IDirect3D8.Hook("CreateDevice"))
	logerr(IDirect3DDevice8.Hook("EndScene"))
	(g_.cfg.TextSwap) ? TS8Init(g_.cfg.TextSwap)
	(g_.cfg.PxSwap)   ? PS8Init(g_.cfg.PxSwap)   
	GetKeyState(g_tswap8.sw, "P") ? g_tswap8.srch := True 
}

g_.p.GtCntnr8 := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "GetContainer8S", uint)
g_.p.GtCbFc   := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "GetFaceAndLevel8", uint) 

g_.cfg.FLTR := ""
if (g_.cfg.FLTR)
	logerr(IDirect3DDevice8.Hook("SetTextureStageState"))

if (g_.cfg.HD && !g_.cfg.layer) 
{
	global G_HD, g_HD := {}
	G_HD := (g_.cfg.HD = True) ? Desk() 
	: {"w" : trim(strsplit(g_.cfg.HD, "x")[1]), "h" : trim(strsplit(g_.cfg.HD, "x")[2])} 
	G_HD.HD_W := G_HD.W
	G_HD.HD_H := G_HD.H	
	
	logerr("Max Primitives " (max_primitives := dllcall("Peixoto.dll\D3D8GetmaxPrimitiveCount", uint, IDirect3D8.p)))
	
	/*    Realistic maximum vertex size
	 *    x, y, x, w coordinates               16
	 *    diffuse and specular light           8
	 *    4, 2D texture sets                   32
	 *    TOTAL                                56 * 3(Up to e vertices per primitive) = 168
	 */
	D3D8_HOOKS.vertex_data := dllcall("VirtualAlloc", uint, 0, uint, 67108864, Int, 0x00001000, uint, 0x04) ; 64MB	
	
	logerr(IDirect3D8.hook("EnumAdapterModes"))
    logerr(IDirect3D8.Hook("GetAdapterDisplayMode"))
	logerr(IDirect3DDevice8.Hook("SetRenderTarget"))
	logerr(IDirect3DDevice8.Hook("GetRenderTarget"))
	logerr(IDirect3DDevice8.Hook("GetDepthStencilSurface"))   
	logerr(IDirect3DDevice8.Hook("GetBackBuffer"))
	logerr(IDirect3DDevice8.Hook("Present"))   
	logerr(IDirect3DDevice8.Hook("SetViewPort"))
	logerr(IDirect3DDevice8.Hook("GetViewPort"))
	logerr(IDirect3DDevice8.Hook("Reset"))
	logErr(IDirect3DDevice8.hook("Clear"))	
	logerr(IDirect3DSurface8.Hook("LockRect"))		
	logerr(IDirect3DSurface8.Hook("UnLockRect"))	
	logerr(IDirect3DSurface8.Hook("GetDesc"))
	logerr(IDirect3DDevice8.dllHook("SetVertexShader", "SetVertexShader8Hook"))	
	logerr(IDirect3DDevice8.dllHook("SetStreamSource", "SetStreamSource8Hook"))		
	logerr(IDirect3DDevice8.dllHook("DrawPrimitiveUp", "DrawPrimitiveUp8Hook"))	
	logerr(IDirect3DDevice8.dllHook("DrawPrimitive", "DrawPrimitive8Hook"))	
	logerr(IDirect3DDevice8.dllHook("DrawIndexedPrimitiveUp", "DrawIndexedPrimitiveUP8Hook"))	
	logerr(IDirect3DDevice8.dllHook("DrawIndexedPrimitive", "DrawIndexedPrimitive8Hook"))		
	logerr(IDirect3DDevice8.dllHook("CreateVertexBuffer", "CreateVertexBuffer8Hook"))	
    logerr(IDirect3DDevice8.Hook("GetDisplaymode"))    	
	D3D8_HOOKS.SetVertexShader          := IDirect3DDevice8.SetVertexShader
	D3D8_HOOKS.SetStreamSource          := IDirect3DDevice8.SetStreamSource	
	D3D8_HOOKS.p_DrawPrimitiveUP        := IDirect3DDevice8.DrawPrimitiveUp	
	D3D8_HOOKS.p_DrawPrimitive          := IDirect3DDevice8.DrawPrimitive
	D3D8_HOOKS.p_DrawIndexedPrimitiveUP := IDirect3DDevice8.DrawIndexedPrimitiveUp	
	D3D8_HOOKS.p_DrawIndexedPrimitive   := IDirect3DDevice8.DrawIndexedPrimitive
	D3D8_HOOKS.CreateVertexBuffer       := IDirect3DDevice8.CreateVertexBuffer	
	D3D8_HOOKS.VbLock                   := IDirect3DVertexBuffer8.Lock
	D3D8_HOOKS.VbUnLock                 := IDirect3DVertexBuffer8.Unlock	
	D3D8_HOOKS.MVbLock                  := IDirect3DMVertexBuffer8.Lock
	D3D8_HOOKS.MVbUnLock                := IDirect3DMVertexBuffer8.Unlock
	;D3D8_HOOKS.Srfc8_Release            := IDirect3D_Surface8.Release 
	
	g_HD.trgts                       := new Collection()
	D3D8_HOOKS.RTrgs                 := g_HD.trgts.pc 
	g_HD.VbLocks                     := new Collection()
	D3D8_HOOKS.VbLocks               := g_HD.VbLocks.pc	
	D3D8_HOOKS.HLFPX                 := g_.cfg.HLFPX
	D3D8_HOOKS.SglCore               := g_.cfg.SNGL
	(g_.cfg.TextSwap)                ?: _TS8Init()	
	(g_.cfg.MHKS)                    ? dllcall("Peixoto.dll\InitMouseHooks")
} else if (g_.cfg.SXTY)
	logerr(IDirect3DDevice8.Hook("Present"))  	

;if (g_.cfg.HD || g_.cfg.TextSwap)
;logerr(IDirect3DDevice8.Hook("CopyRects"))

D3D8_HOOKS.p_DrawPrimitiveUP  := IDirect3DDevice8.DrawPrimitiveUp	
D3D8_HOOKS.end                := IDirect3DDevice8.EndScene
D3D8_HOOKS.SetPixelShader     := IDirect3DDevice8.SetPixelShader

D3DX9.__new("d3dx9_43.dll")
IDirect3DDevice8.__Release()
IDirect3D8.__Release()

g_.WnAPI := {}
if (g_.cfg.MCLP)	
{
	logerr("ClipCursor Hook" InstallHook("ClipCursor8", p, "User32.dll", "ClipCursor"))
	g_.WnAPI.ClpCrsr := p			
}
else g_.WnAPI.ClpCrsr := dllcall("GetProcAddress", uint, dllcall("GetModuleHandleA", astr, "User32.dll", uint), astr, "ClipCursor")	

IDirect3D8_EnumAdapterModes(p1, p2, p3, p4)
{
	r := dllcall(IDirect3D8.EnumAdapterModes, uint, p1, uint, p2, uint, p3, uint, p4)
	if (r=0)
	{
		DMD   := struct("UINT w, h;")
		DMD[] := p4
		if (DMD.w = 720) 
		{
			if (DMD.h = 480)
			{
				DMD.h := 540 
				DMD.w := 540*G_HD.HD_W/G_HD.HD_H 
			}
			else if (DMD.h = 576)
			{
				DMD.h := 540
				DMD.w := DMD.h *4/3
			}
		}
        if (p3 = 0x00EFFFFF) ;D3DCURRENT_DISPLAY_MODE 
        {
            DMD.h := G_HD.H
			DMD.w := G_HD.W
        }
	}
	return r
}

IDirect3D8_GetAdapterDisplayMode(p1, p2, p3)
{
    r := dllcall(IDirect3D8.GetAdapterDisplayMode, ptr, p1, uint, p2, ptr, p3)
    if (r)
        return r
    mode        := struct("UINT Width; UINT Height; UINT RefreshRate; UINT Format;")
    mode[]      := p3
    mode.Width  := G_HD.W
    mode.Height := G_HD.H
    return 0
}

IDirect3DDevice8_GetDisplaymode(p1, p2)
{
    r := dllcall(IDirect3DDevice8.GetDisplaymode, ptr, p1, ptr, p2)
    if (r)
        return r
    mode        := struct("UINT Width; UINT Height; UINT RefreshRate; UINT Format;")
    mode[]      := p2
    mode.Width  := G_HD.W
    mode.Height := G_HD.H
    return 0
}

CleanUp8(pp)
{
	if ( (g_.cfg.HD) and (D3DPRESENT_PARAMETERS[] := pp) )
	{
		g_.Proxies       := {}	
		G_HD.W := D3DPRESENT_PARAMETERS.BackBufferWidth
		G_HD.H := D3DPRESENT_PARAMETERS.BackBufferHeight		
		D3D8_HOOKS.scale := G_HD.HD_H/D3DPRESENT_PARAMETERS.BackBufferHeight
		D3D8_HOOKS.HD_X  := (G_HD.HD_W - D3DPRESENT_PARAMETERS.BackBufferWidth*D3D8_HOOKS.scale)/2 

		G_HD.rct    := struct("DWORD x, y, w, h;")	
		G_HD.rct.w  := D3DPRESENT_PARAMETERS.BackBufferWidth * D3D8_HOOKS.scale
		G_HD.rct.h  := G_HD.HD_H
						
		dllcall("Peixoto.dll\SetMouseHooksParams", float, G_HD.HD_W/D3DPRESENT_PARAMETERS.BackBufferWidth, float, D3D8_HOOKS.scale
											     , uint, D3D8_HOOKS.HD_X, uint, D3DPRESENT_PARAMETERS.BackBufferWidth
												 , uint, D3DPRESENT_PARAMETERS.BackBufferHeight)	
									
		D3DPRESENT_PARAMETERS.BackBufferWidth   := G_HD.HD_W
		D3DPRESENT_PARAMETERS.BackBufferHeight  := G_HD.HD_H	
        DllCall("Peixoto.dll\D3D8HDSetUP", uint, G_HD.W, uint, G_HD.H)				
	}
	if ( (g_.cfg.SXTY) and (D3DPRESENT_PARAMETERS[] := pp) )
	{
		if (!D3DPRESENT_PARAMETERS.Windowed)
		D3DPRESENT_PARAMETERS.FullScreen_RefreshRateInHz := 60
	}
	if (!D3DPRESENT_PARAMETERS.Windowed)
	D3DPRESENT_PARAMETERS.FullScreen_PresentationInterval := 1 ;D3DPRESENT_INTERVAL_ONE 	
}

Setup8(pD)
{
	static h		
	g_.pDevice8  := pD	

	if (g_.cfg.HD) 
	{
		logerr("Resquested " G_HD.W " x " G_HD.H)
		fmt := D3D8SetPixelFormat("X8RGB")
		if (g_.cfg.SSAA)
			D3D8_HOOKS.scale := g_.cfg.SSAA * ceil(D3D8_HOOKS.scale)
		p              := D3DPRESENT_PARAMETERS		
		;g_.Proxies     := {}	
		if (g_.cfg.SSAA=4)
		g_.Proxies.hlf := new Proxie8(G_HD.W*D3D8_HOOKS.scale/2, G_HD.H*D3D8_HOOKS.scale/2, fmt)	
		if (m := p.MultiSampleType)
		g_.Proxies.rt  := new SProxie8(G_HD.W*D3D8_HOOKS.scale, G_HD.H*D3D8_HOOKS.scale, m, fmt, p.EnableAutoDepthStencil ? p.AutoDepthStencilFormat : "")
		else 
		g_.Proxies.rt  := new Proxie8(G_HD.W*D3D8_HOOKS.scale, G_HD.H*D3D8_HOOKS.scale, fmt, p.EnableAutoDepthStencil ? p.AutoDepthStencilFormat : "")
		g_.Proxies.lck := new Proxie8(G_HD.W, G_HD.H, p.BackBufferFormat,,1)
		SetTargets(g_.Proxies.rt)
		s8             := new ComInterfaceWrapper(D3D8.IDirect3DSurface8, g_.Proxies.rt.s, True)
		s8.released    := 1		
		
		if ! isobject(g_.Proxies.clr)
		{
			g_.Proxies.clr := new Proxie8(1, 1, p.BackBufferFormat, p.EnableAutoDepthStencil ? p.AutoDepthStencilFormat : "")
			g_.Proxies.z   := new Proxie8(1, 1, p.BackBufferFormat, ,1)
		}
		
		;g_.proxies.lnr      := D3DDDI_CreatePixelShader(G_D3DDDI.shader_code, "Linear")
		g_.proxies.prms     := Struct("Float[12]")
		g_.proxies.prms[7]  := G_HD.W*D3D8_HOOKS.scale
		g_.proxies.prms[8]  := G_HD.H*D3D8_HOOKS.scale
		g_.proxies.prms[5]  := 1/g_.proxies.prms[7]
		g_.proxies.prms[6]  := 1/g_.proxies.prms[8]
		g_.proxies.prms[11] := g_.proxies.prms[7]/2
		g_.proxies.prms[12] := g_.proxies.prms[8]/2
		g_.proxies.prms[9]  := 1/g_.proxies.prms[11]
		g_.proxies.prms[10] := 1/g_.proxies.prms[12]		
		
		G_HD.rct.X     += D3D8_HOOKS.HD_X
		G_HD.rct.W     += D3D8_HOOKS.HD_X
		G_HD.hrct      := struct(G_HD.rct)	
		G_HD.hrct.W    := G_HD.W*D3D8_HOOKS.scale/2
		G_HD.hrct.H    := G_HD.H*D3D8_HOOKS.scale/2		
		D3DVIEWPORT8.Width  := G_HD.W	
		D3DVIEWPORT8.Height := G_HD.H
		D3DVIEWPORT8.X      := 0	
		D3DVIEWPORT8.Y      := 0
	}
	if g_.cfg.MCLP
	ClipCursor8(0)
}

IDirect3DDevice8_Reset(p1, p2)
{
	CleanUp8(p2)
	Setup8(p1)
}

IDirect3D8_CreateDevice(p1, p2, p3, p4, p5, p6, p7)
{
	CleanUp8(p6)
	(g_tswap8.shader)     ? g_tswap8.shader  := dllcall(IDirect3DDevice8.DeletePixelShader, uint, g_.pDevice8, uint, g_tswap8.shader)
	(g_pswap8.over)       ? g_pswap8.over    := dllcall(IDirect3DDevice8.DeletePixelShader, uint, g_.pDevice8, uint, g_pswap8.over)
	(g_pswap8._over)      ? g_pswap8._over   := dllcall(IDirect3DDevice8.DeletePixelShader, uint, g_.pDevice8, uint, g_pswap8.over)
	(G_HD.HD_HS)          ? G_HD.HD_HS       := dllcall(IDirect3DDevice8.DeletePixelShader, uint, g_.pDevice8, uint, G_HD.HD_HS)
	logerr("IDirect3D8_CreateDevice D3DCREATE_MULTITHREADED " p5&D3DCREATE_MULTITHREADED)	
	
	if (g_.cfg.safe)
	p5|=D3DCREATE_MULTITHREADED		
	fmt := D3DPRESENT_PARAMETERS.BackBufferFormat
	if ! (r := dllcall(IDirect3D8.CreateDevice, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7, uint))
	{
		(hWin := D3DPRESENT_PARAMETERS.hDeviceWindow) ?: hWin := p4
		if (g_.cfg.HD)
		{
			dllcall("SetWindowPos", uint, hWin, int, 0, uint, 0, uint, 0, uint, G_HD.HD_W, uint, G_HD.HD_H, uint, 0x0454)
            dllcall("SendMessage", ptr, hWin, uint, 0x5, ptr, 0, ptr, G_HD.W|(G_HD.H<<16)) 
			dllcall("peixoto.dll\D3D12Config", astr, "HWND", ptr, hWin)			
			D3DPRESENT_PARAMETERS.BackBufferFormat := fmt 
		}
		Setup8(numget(p7+0, "ptr"))
		g_tswap8.shader     := D3D8CreatePixelShader("ps.1.0`ntex t0`nmov r0, t0", g_.pDevice8)
		g_pswap8.over	    := D3D8CreatePixelShader("ps.1.0`ntex t0`nmov r0, t0", g_.pDevice8)	
		g_pswap8._over      := D3D8CreatePixelShader("ps.1.0`nmov r0, v0", g_.pDevice8)
		D3D8_HOOKS.Override := g_pswap8.over
		if (g_.cfg.HD) 
			G_HD.HD_HS := D3D8CreatePixelShader("ps.1.0`ntex t0`nmov r0, t0", g_.pDevice8)			
		if (g_.cfg.FLTR){
			loop, 4 {
				IDirect3DDevice8_SetTextureStageState(numget(p7+0, "ptr"), A_index-1, 16, 1)
				IDirect3DDevice8_SetTextureStageState(numget(p7+0, "ptr"), A_index-1, 17, 3)
				IDirect3DDevice8_SetTextureStageState(numget(p7+0, "ptr"), A_index-1, 21, 16)
			}
		}
	}
	return r	
}

IDirect3DDevice8_SetRenderTarget(p1, p2, p3)
{
	
	if (p2) and (p2 != g_.Proxies.rt.s)
	{
		if (c := FindSrfc8(p2, 1))
		p2 := c
	}
	if (p3) and (p3 != g_.Proxies.rt.zs)
	{
		if (z := FindSrfc8(p3, 2))
		p3 := z
	}
	r := dllcall(IDirect3DDevice8.SetRenderTarget, uint, p1, uint, p2, uint, p3)
	c ? dllcall(numget(numget(c+0, "ptr")+A_PtrSize*2, "ptr"), uint, c)
	z ? dllcall(numget(numget(z+0, "ptr")+A_PtrSize*2, "ptr"), uint, z)		
	return r
}

IDirect3DDevice8_GetDepthStencilSurface(p1, p2)
{
	dllcall(IDirect3DDevice8.GetDepthStencilSurface, uint, p1, "uint*", z:=0)
	if (SD := FindSDSrfc(z, 2))
	{
		dllcall(numget(numget(z+0, "ptr")+8, "ptr"), uint, z)
		numput(SD, p2+0, "ptr")
		return 0
	} ;else Logerr("Z SURFACE NOT FOUND " z "=====================================") ;enclave		
	return 0	
}

IDirect3DDevice8_GetRenderTarget(p1, p2)
{
	dllcall(IDirect3DDevice8.GetRenderTarget, uint, p1, "uint*", rt:=0)
	if (SD := FindSDSrfc(rt, 1))
	{
		dllcall(numget(numget(rt+0, "ptr")+8, "ptr"), uint, rt)
		numput(SD, p2+0, "ptr")
		return 0
	} ;else Logerr("RENDER TARGET SURFACE NOT FOUND =====================================")	;enclave			
	return 0	
}

IDirect3DDevice8_GetBackBuffer(p1, p2, p3, p4)
{
	dllcall(numget(numget(g_.proxies.clr.s+0, "ptr")+4, "ptr"), uint, g_.proxies.clr.s)
	numput(g_.Proxies.clr.s, p4+0, "ptr")	
	return 0	
}

IDirect3DDevice8_Clear(p1, p2, p3, p4, p5, p6, p7)
{
	if !p3
		return dllcall(IDirect3DDevice8.Clear, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)
	r   := struct(D3D8_RECT)
	sz  := VarSetCapacity(rr, r.size()*p2)
	r[] := &rr
	dllcall("RtlMoveMemory", ptr, &rr, ptr, p3, int, sz)
	loop, % p2
	{
		r.left   *= D3D8_HOOKS.scale
		r.right  *= D3D8_HOOKS.scale
		r.bottom *= D3D8_HOOKS.scale
		r.top    *= D3D8_HOOKS.scale
		r[] += r.size()
	}
	return dllcall(IDirect3DDevice8.Clear, uint, p1, uint, p2, uint, &rr, uint, p4, uint, p5, uint, p6, uint, p7)
}

IDirect3DDevice8_SetViewPort(p1, p2)
{	
	if p2
	{
		vw  := struct(D3DVIEWPORT8)
		dllcall("RtlMoveMemory", ptr, vw[], ptr, p2, int, vw.size())
		dllcall("RtlMoveMemory", ptr, D3DVIEWPORT8[], ptr, p2, int, vw.size())
		vw.Width  *= D3D8_HOOKS.scale	
		vw.Height *= D3D8_HOOKS.scale	
		vw.X      *= D3D8_HOOKS.scale	
		vw.Y      *= D3D8_HOOKS.scale			
	}	
	r := dllcall(IDirect3DDevice8.SetViewport, uint, p1, uint, vw[])
	return 0
}

IDirect3DDevice8_GetViewPort(p1, p2)
{
	if p2 
	{
		dllcall("RtlMoveMemory", ptr, p2, ptr, D3DVIEWPORT8[], int, D3DVIEWPORT8.size())
		return 0		
	}	
	return dllcall(IDirect3DDevice8.GetViewport, uint, g_.pDevice8, uint, p2)
}

IDirect3DDevice8_EndScene(p1)
{	
	if (g_.cfg.SNGL)
	dllcall("peixoto.dll\SetThreAdffinity", int, -1)		
	
	static clr := 0xFFFFFFFF		
	keyevent(g_tswap8.c) or keyevent(g_pswap8.c) 
	? clr                  := cicleColor(clr&~0xff000000) | 0xff000000
	
	keyevent(g_tswap8.sw) 
	? g_tswap8.srch        := (g_tswap8.srch) ? False : True
	, D3D8_HOOKS.searching :=  g_tswap8.srch
	
	keyevent(g_pswap8.sw) 
	? g_pswap8.srch        := (g_pswap8.srch) ? False : True
	, D3D8_HOOKS.srchng    := g_pswap8.srch 
	
	keyevent(g_pswap8.s) 
	? D3D8_HOOKS.OVerride  := (D3D8_HOOKS.Override = g_pswap8.over) 
	? g_pswap8._over : g_pswap8.over
		
	(g_tswap8.srch)   ? BrowseTextures8(p1, clr)	
    (g_pswap8.srch)   ? BrowseShaders8(p1, clr)
	return dllcall(IDirect3DDevice8.EndScene, uint, p1)
}

VBlank(d)
{
	return  ; with wine vsync is enforced on device creation
	while !(s & 0xffffffff)
		dllcall(IDirect3DDevice8.GetRasterStatus, uint, d, "uint64*", s:=0)	
}

IDirect3DDevice8_Present(p1, p2, p3, p4, p5)
{
	if (g_.cfg.HD) 
	{	
		t := GetTargets()
		if (g_.cfg.SSAA=4)
		{
			SetTargets(g_.Proxies.hlf)
			;D3DDDI_SetShaderOverride(g_.proxies.lnr)
			dllcall(G_D3DDDI.SetPixelShaderConst, uint, D3DDDI_HOOKS.hDev, "uint64*", 223 | 1<<32, uint, g_.proxies.prms[]+16)
			dllcall("peixoto.dll\__D3D8DrawRect", uint, p1, uint, g_.Proxies.rt.tx(), uint, G_HD.hrct[], uint, G_HD.HD_HS, uint, 0, uint, 2)
			
			SetTargets()
			dllcall(G_D3DDDI.SetPixelShaderConst, uint, D3DDDI_HOOKS.hDev, "uint64*", 223 | 1<<32, uint, g_.proxies.prms[]+32)
			dllcall("peixoto.dll\__D3D8DrawRect", uint, p1, uint, g_.Proxies.hlf.tx(), uint, G_HD.rct[], uint, G_HD.HD_HS, uint, 0, uint, 2)
		} else {		
			SetTargets()
			if (g_.cfg.SSAA)
			{
				;D3DDDI_SetShaderOverride(g_.proxies.lnr)
				;dllcall(G_D3DDDI.SetPixelShaderConst, uint, D3DDDI_HOOKS.hDev, "uint64*", 223 | 1<<32, uint, g_.proxies.prms[]+16)
			}		
			dllcall("peixoto.dll\__D3D8DrawRect", uint, p1, uint, g_.Proxies.rt.tx(), uint, G_HD.rct[], uint, G_HD.HD_HS, uint, 0, uint, 2)
		}
		
		SetTargets(t)
		(t.s)  ? printl("RELEASE clr surface " dllcall(numget(numget(t.s+0, "ptr")+A_PtrSize*2, "ptr"),  uint, t.s))
		(t.zs) ? printl("RELEASE z surface   " dllcall(numget(numget(t.zs+0, "ptr")+A_PtrSize*2, "ptr"), uint, t.zs))
		;D3DDDI_RestoreShader()		
		
		if (g_.cfg.SYNC) 
		VBlank(p1) 
		r := dllcall(IDirect3DDevice8.Present, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)				
		return r		
				
		dllcall(IDirect3DDevice8.GetBackBuffer, uint, p1, uint, 0, uint, 0, "uint*", s:=0)
		dllcall(IDirect3DDevice8.CopyRects, uint, p1, uint, g_.Proxie.s, uint, G_HD.rct[], uint, 1, uint, s, "uint64*", D3D8_HOOKS.HD_X)
		s ?  dllcall(numget(numget(s+0, "ptr")+A_PtrSize*2, "ptr"))			
	}	
	if (g_.cfg.SYNC) 
	VBlank(p1)	
	return dllcall(IDirect3DDevice8.Present, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)	
}

IDirect3DDevice8_CopyRects(p1, p2, p3, p4, p5, p6)
{
	logerr("...")
	d := struct(D3DSURFACE_DESC)
	dllcall(IDirect3DSurface.GetDesc, ptr, p2, uint, 0, ptr, d[])
	
	if (d.Pool=0)
	{
		if (g_.cfg.HD)
		{
			if (rs := FindSrfc8(p5))
				p5 := rs
			if (rd := FindSrfc8(p2))
				p2 := rd
			r  := dllcall(IDirect3DDevice8.CopyRects, uint, p1, uint, p2, uint, 0, uint, 0, uint, p5, uint, 0)	
			rs ? dllcall(dllcall(numget(numget(rs+0, "ptr")+A_PtrSize*2, "ptr"), uint, z), uint, rs)
			rd ? dllcall(dllcall(numget(numget(rd+0, "ptr")+A_PtrSize*2, "ptr"), uint, z), uint, rd)
			dllcall(IDirect3DDevice8.SetRenderState, uint, p1, uint, 26, uint, 1)
			dllcall(IDirect3DDevice8.SetRenderState, uint, p1, uint, 154, float, D3D8_HOOKS.scale*D3D8_HOOKS.scale)
		}
	} else if (d.Pool>1)
	{
		if (g_.cfg.TextSwap)
		{
			r  := dllcall(IDirect3DDevice8.CopyRects, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, 0)
			if (r) 
			return r
			dllcall("peixoto.dll\CopyRects8Check")
			return r
		}
	} return dllcall(IDirect3DDevice8.CopyRects, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, 0)
	return 0
}

IDirect3DSurface8_LockRect(p1, p2, p3, p4)
{
	if (p1 != g_.proxies.clr.s)
	return dllcall(IDirect3DSurface8.LockRect, uint, p1, uint, p2, uint, p3, uint, p4)	
	
	D := struct(D3DSURFACE_DESC)
	dllcall(IDirect3DSurface8.GetDesc, uint, p1, ptr, D[])	
	
	p := new Proxie8(G_HD.W, G_HD.H, D.Format)
	g_.Proxies.lck := new Proxie8(G_HD.W, G_HD.H, D.Format,,1)
	
	dst   := struct("DWORD x, y, w, h;")	
	dst.w := G_HD.W
	dst.h := G_HD.H		
		
	SetTargets(p)
	dllcall("peixoto.dll\_D3D8DrawRect", uint, g_.pDevice8, uint, g_.Proxies.rt.t, uint, dst[], uint, G_HD.HD_HS, uint, 0)
	dllcall(IDirect3DDevice8.CopyRects, uint, g_.pDevice8, uint, p.s, uint, dst[], uint, 1, uint, g_.Proxies.lck.s, "uint64*", pnt:=0) 
	SetTargets(g_.Proxies.rt)
	return dllcall(IDirect3DSurface8.LockRect, uint, g_.Proxies.lck.s, uint, p2, uint, p3, uint, p4)	
}

IDirect3DSurface8_UnLockRect(p1)
{
	if (p1 != g_.proxies.clr.s)
	return dllcall(IDirect3DSurface8.UnLockRect, uint, p1)	

	if (r := dllcall(IDirect3DSurface8.UnLockRect, uint, g_.Proxies.lck.s))
	return r

	SetTargets(g_.Proxies.rt)
	dst   := struct("DWORD x, y, w, h;")	
	dst.w := G_HD.W*D3D8_HOOKS.scale
	dst.h := G_HD.H*D3D8_HOOKS.scale	
	dllcall("peixoto.dll\_D3D8DrawRect", uint, g_.pDevice8, uint, g_.Proxies.lck.t, uint, dst[], uint, G_HD.HD_HS, uint, 0)
	return 	 
}

IDirect3DSurface8_GetDesc(p1, p2)
{
	if (r := dllcall(IDirect3DSurface8.GetDesc, uint, p1, uint, p2))
	return r	
	
	if ( p1 = g_.proxies.z.s ||  p1 = g_.proxies.clr.s )
	{
		D   := struct(D3DSURFACE_DESC)
		D[] := p2
		D.Width  := G_HD.W
		D.Height := G_HD.H
	}
	return r
}

ClipCursor8(p1)
{
	if (g_.cfg.MCLP=2)
	{
		VarSetCapacity(r, 8, 0)
		numput(D3D8_HOOKS.HD_X-1, &r+08, "uint")
		numput(G_HD.HD_W-D3D8_HOOKS.HD_X, &r+08, "uint")
		numput(G_HD.HD_H-1, &r+12, "uint")
		return dllcall(g_.WnAPI.ClpCrsr, uint, &r)
	}
	VarSetCapacity(r, 8, 0)
	numput(G_HD.HD_W/D3D8_HOOKS.scale-1, &r+08, "uint")
	numput(G_HD.HD_H/D3D8_HOOKS.scale-1, &r+12, "uint")
	return dllcall(g_.WnAPI.ClpCrsr, uint, &r)
}

IDirect3DDevice8_SetTextureStageState(p1, p2, p3, p4)
{
	;16 = D3DTSS_MAGFILTER
	;17 = D3DTSS_MINFILTER
	;21 = D3DTSS_MAXANISOTROPY
	;1  = D3DTFG_POINT
	;3  = D3DTFN_ANISOTROPIC
	p4 := p3 = 16 ? 1 : p3 = 17 ? 3 : p3 = 21 ? 16 : p4
	return dllcall(IDirect3DDevice8.SetTextureStageState, ptr, p1, uint, p2, uint, p3, uint, p4)
  
}