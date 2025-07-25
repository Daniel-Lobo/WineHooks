#include lib\DirectX\D3D9.ahk
D3D9_HOOKS := 
(
"
LPVOID AhkDvc;
DWORD sdk;
DWORD BLNK;
DWORD DblTxlSz;
DWORD W, H, HD_W, HD_H, HD_X, rx, ry, rw, rh;
float scale;
LPVOID GetDisplayMode;
LPVOID GtMntrNfoA; GtSysMtrcs;
LPVOID xBR;
LPVOID StFVF, STVxShdr, STVxDcl, StStream, EndBlck, ApplyBlck, RlsBlck;
LPVOID CrtVtxB, CrtIdxB;
LPVOID CreateTxHD, CreateCube, CreateRT, CreateZS, CreateZSEx;
LPVOID Draw, DrawIdx, DrawUp, DrawIdxUp, CFill, Clr, StrtchRct, Prsnt, PrsntEx, StVW, GtVW, StScsr, GtScsr;
LPVOID GtRTDt, GtSrfcDsc, GtRTDsc, GtBck, GtDpth, StDpth, GtTrgt, StTrgt, RTLOck, RTUnlock;
LPVOID UPdateHDSrfc, UPdateHDTxtr;
LPVOID HDSrfc, HDZSrfc, SDSrfc, SDZSrfc, HlfSrfc;
LPVOID Srfcs;
LPVOID vrtx;
BOOL Pow2;
BOOL FixvPos;
LPVOID vPosFix;
DWORD Fltr;
LPVOID StSS;
LPVOID End; LPVOID Callback; LPVOID Font; DWORD fntx,fnty,fntw,fnth; LPCTSTR tex; DWORD color;
LPVOID t; LPVOID px; DWORD tx,ty,tw,th; LPVOID SetTexture; LPVOID ReleaseShader; LPCTSTR dump;
LPVOID pIDirect3DDevice9_CreateTexture;
LPVOID pIDirect3DDevice9_UpdateTexture;
LPVOID UpdtSrfc;
LPVOID pIDirect3DDevice9_StretchRect;
LPVOID pIDirect3DDevice9_SetTexture;
LPVOID pIDirect3DTexture9_GetSurfaceLevel;
LPVOID pIDirect3DTexture9_LockRect;
LPVOID pIDirect3DTexture9_UnlockRect;
LPVOID pIDirect3DTexture9_QueryInterface;
LPVOID pIDirect3DTexture9_Release;
LPVOID pIDirect3DSurface9_LockRect;
LPVOID pIDirect3DSurface9_UnlockRect;
LPVOID pIDirect3DSurface9_Release;
LPVOID RTRelease;
LPVOID CbtRls;
LPVOID CbsRls;
LPVOID pTextureFound;
BOOL   autodmp;
BOOl   dyntxts;
BOOL   safe;
BOOL   ignore_release;
BOOL   searching;
LPVOID Currentexture9;
LPVOID Textures;
LPVOID Surfaces;
LPVOID Replacements;
LPVOID Paths;
LPVOID Dev9;
LPVOID CreatePixelShader;
LPVOID SetPixelShader;
LPVOID GetFunction;
LPVOID Release;
LPVOID pShaderFound;
LPVOID Override;
BOOL   s_ignore_release;
BOOL   srchng;
BOOL   enabled;
LPVOID IsSelected;
LPVOID CurrentSelectedShader;
LPVOID Current;
LPVOID Shaders;
LPVOID Overrides;
LPVOID Blobs;
DWORD  SDumpsSize;
LPVOID SDumps;
LPCTSTR SPath;
LPCTSTR StxtPath;
"
)
global D3D9_HOOKS := struct(D3D9_HOOKS)
global D3D9_RECT  := struct("LPVOID t; LPVOID Px; DWORD x, y, w, h; LPVOID SetTx; LPVOID ShdrRelease;")
D3D9_HOOKS.color  := 0x00ffffff
g_.p.DrawRect9    := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "D3D9_DrawRect", uint)

#include lib\TexSwapLib9.ahk
#include lib\ShaderOverride9.ahk

;setformat, Integer, H
test := new Collection()
test._add(1, 1)
test._add(2, 2)
;msgbox % test.Value(1) " " test.Value(2) " " test.KeyAt(0) " " test.KeyAt(1) 

global VW9 := struct(D3DVIEWPORT9)
D3D9_HOOKS.vrtx := dllcall("VirtualAlloc", uint, 0, uint, 2097152, Int, 0x00001000, uint, 0x04) ; 2MB

D3D9CreateHook(p1){
	logerr("==================================================================")	
	D3DPRESENT_PARAMETERS.hDeviceWindow := ""
	g_.Proxies     := {}	
	g_.pDevice9    := ""
	D3D9_HOOKS.sdk := p1
	return dllcall(g_.pD3D9Create, uint, p1)
}

D3D9CreateExHook(p1, p2){
	logerr("==================================================================")	
	D3DPRESENT_PARAMETERS.hDeviceWindow := ""
	g_.Proxies     := {}	
	g_.pDevice9    := ""
	D3D9_HOOKS.sdk := p1	
	return dllcall(g_.pD3D9CreateEx, uint, p1, ptr, p2)	
}

HookD3D9Create(){		
	VarSetCapacity(SysDir, 261)
	DllCall("GetSystemDirectoryW", Str, SysDir, UInt, 261)	
	logerr("D3D9Create Hook: " InstallHook(isfunc("AltD3D9Create") ? "AltD3D9Create" : "D3D9CreateHook", p, SysDir "\d3d9.dll", "Direct3DCreate9"))
	g_.pD3D9Create   := p	
	logerr("D3D9Create Hook: " InstallHook(isfunc("AltD3D9CreateEx") ? "AltD3D9CreateEx" : "D3D9CreateExHook", pEx, SysDir "\d3d9.dll", "Direct3DCreate9Ex"))
	g_.pD3D9CreateEx := pEx		
}

D3D9IsLinux(){
	if (!FileExist(GetSystemDir() "\wined3d.dll")) 
	return False
	if (dllcall("LoadLibraryW", str, "wined3d.dll"))
	{
		if (h_d3d9 := dllcall("LoadLibraryW", str, "d3d9.dll"))
		{
			if dllcall("GetProcAddress", uint, h_d3d9, astr, "Direct3DCreate9On12")
			{				
				dllcall("peixoto.dll\D3D12Config", astr, "DXVK", uint, 9)
				return "dxvk"
			} 
			return "wined"
		}
	}	
	RETURN False
}

D3D9LoadWine(){
	;if dllcall("GetModuleHandleW", str, "wined3d.dll")
	logerr("Linux: " D3D9IsLinux() " SysDir: " GetSystemDir() " Exists: " FileExist(GetSystemDir() "\wined3d.dll"))
	if (D3D9IsLinux())
	return	
	logerr("Loading WineD3D")
	arch  := A_PtrSize = 8 ? "System32" : "SysWOW64"
	;g_.cfg.dxvk := True
	if (g_.cfg.dxvk)
		h_wined3d9  := dllcall("LoadLibraryW", str, g_.cfg.injector_dir . "\dxvk\" . g_.cfg.dxvkv "\" arch "\d3d9.dll")
	else {
		dllcall("LoadLibraryW", str,  g_.cfg.injector_dir . "\wined3d\"  g_.cfg.wine "\" arch "\wined3d.dll")
		h_wined3d9  := dllcall("LoadLibraryW", str, g_.cfg.injector_dir . "\wined3d\" . g_.cfg.wine . "\" arch "\d3d9.dll")
	}	
	g_.pD3D9Create   :=  dllcall("GetProcAddress", ptr, h_wined3d9, astr, "Direct3DCreate9")
	g_.pD3D9CreateEx :=  dllcall("GetProcAddress", ptr, h_wined3d9, astr, "Direct3DCreate9Ex")
}

D3D9IniHooks()
D3D9IniHooks()
{	
	dllcall(g_.p.Critical, uint, 1)	
	HookD3D9Create()	
	D3D9LoadWine()
	logerr(GetDirect3D9())
	logerr(IDirect3D9.Hook("CreateDevice"))
	logerr(IDirect3D9Ex.hook("CreateDeviceEx"))
	logerr(IDirect3DDevice9.Hook("Reset"))
	logerr(IDirect3DDevice9Ex.Hook("ResetEx"))
	logerr(IDirect3DDevice9.Hook("BeginStateBlock"))
	logerr(IDirect3DDevice9.dllHook("EndScene", "D3D9_EndSceneHook"))
	D3D9_HOOKS.End        := IDirect3DDevice9.EndScene
	D3D9_HOOKS.Callback   := Registercallback(Isfunc("Alt_EndScene") ? "Alt_EndScene" : "IDirect3DDevice9_EndScene", "F")
	D3D9_HOOKS.AhkDvc     := IDirect3DDevice9.p	
	D3D9_HOOKS.BLNK       := g_.cfg.BLNK
	D3D9_HOOKS.BLNK       := 0
				
	(parsecfg(g_.cfg.TextSwap).e) ? TS9Init(g_.cfg.TextSwap)
	(parsecfg(g_.cfg.PxSwap).e)   ? PS9Init(g_.cfg.PxSwap)		
	GetKeyState(g_tswap9.sw, "P") ? g_tswap9.srch := True 
	
	D3D9_RECT.SetTx       := IDirect3DDevice9.SetTexture
	D3D9_RECT.ShdrRelease := IDirect3DPixelShader9.Release	
			
	g_.cfg.FLTR := ""
	if (g_.cfg.xBR)
		g_.cfg.FLTR := 1
	
	if (g_.cfg.TxlSz) 
	{
		D3D9_HOOKS.DblTxlSz := g_.cfg.TxlSz+1
		if (g_.cfg.TxlSz > 2)
			D3D9_HOOKS.DblTxlSz := D3D9_HOOKS.DblTxlSz-2 | 0xf0		
	}
	
	D3D9_HOOKS.Fltr |= g_.cfg.FLTR
	(g_tswap9.Fltr) ? D3D9_HOOKS.Fltr |= 0xf0
	if (D3D9_HOOKS.Fltr)
	{
		logerr(IDirect3DDevice9.dllHook("SetSamplerState", "SetSamplerState9Hook"))
		D3D9_HOOKS.StSS := IDirect3DDevice9.SetSamplerState
	}	
		
	if (g_.cfg.HD) 
	{
		d := desk()
		D3D9_HOOKS.HD_W := d.W
		D3D9_HOOKS.HD_H := d.H
		D3D9_HOOKS.W := d.W
		D3D9_HOOKS.H := d.H		
		if (g_.cfg.RLMT)	
		{
			r := strsplit(["640x480", "800x600", "1024x768", "960x540", "1280x720", "1366x768", "1600x900", "1920x1080", "2560x1440", "3840x2160"][g_.cfg.RLMT], "x" )	
			D3D9_HOOKS.W := r[1]
			D3D9_HOOKS.H := r[2]
		}			

		if (!g_.cfg.dxvk and !(D3D9IsLinux()="dxvk") )
			logerr(IDirect3DSwapChain9.Hook("Present")) 
		logerr(IDirect3DDevice9.dllHook("Present", (g_.cfg.xBR) ? "xBRPresent9Hook":"Present9Hook"))
		D3D9_HOOKS.Prsnt     := IDirect3DDevice9.Present	
		
		logerr(IDirect3DDevice9Ex.dllHook("PresentEx", "Present9ExHook"))
		D3D9_HOOKS.PrsntEx   := IDirect3DDevice9Ex.PresentEx	
		
		logerr(IDirect3DDevice9.dllHook("StretchRect", "StretchRect9Hook"))
		D3D9_HOOKS.StrtchRct := IDirect3DDevice9.StretchRect
		
		;logerr(IDirect3DSwapChain9.Hook("GetBackBuffer")) ;Breaks MGS
		logerr(IDirect3DDevice9.dllHook("GetBackBuffer", "GetBackBuffer9Hook"))
		D3D9_HOOKS.GtBck     := IDirect3DDevice9.GetBackBuffer 
		
		logerr(IDirect3DSurface9.dllHook("GetDesc", "GetDesc9Hook"))
		D3D9_HOOKS.GtSrfcDsc := IDirect3DSurface9.GetDesc
		
		logerr(IDirect3DDevice9.dllHook("GetDepthStencilSurface", "GetDepthStencilSurface9Hook"))
		D3D9_HOOKS.GtDpth  := IDirect3DDevice9.GetDepthStencilSurface 
		
		logerr(IDirect3DDevice9.dllHook("SetDepthStencilSurface", "SetDepthStencilSurface9Hook"))
		D3D9_HOOKS.StDpth  := IDirect3DDevice9.SetDepthStencilSurface 
		
		logerr(IDirect3DDevice9.dllHook("SetRenderTarget", "SetRenderTarget9Hook"))
		D3D9_HOOKS.StTrgt  := IDirect3DDevice9.SetRenderTarget 
		
		logerr(IDirect3DDevice9.dllHook("GetRenderTarget", "GetRenderTarget9Hook"))
		D3D9_HOOKS.GtTrgt  := IDirect3DDevice9.GetRenderTarget 
		
		logerr(IDirect3DDevice9.dllHook("GetViewPort", "GetViewPort9Hook"))
		D3D9_HOOKS.GtVW    := IDirect3DDevice9.GetViewPort 
		logerr(IDirect3DDevice9.dllHook("SetViewPort", "SetViewPort9Hook"))
		D3D9_HOOKS.StVW    := IDirect3DDevice9.SetViewPort 
		
		logerr(IDirect3DDevice9.dllHook("SetScissorRect", "SetScissorRect9Hook"))
		D3D9_HOOKS.StScsr  := IDirect3DDevice9.SetScissorRect 	
		logerr(IDirect3DDevice9.dllHook("GetScissorRect", "GetScissorRect9Hook"))
		D3D9_HOOKS.GtScsr  := IDirect3DDevice9.SetScissorRect 			
		
		logerr(IDirect3D9.hook("EnumAdapterModes"))
		logerr(IDirect3D9.hook("GetAdapterDisplaymode"))
		;logerr(IDirect3DDevice9.PatchVtable("GetDisplaymode"))
		logerr(IDirect3DDevice9.dllHook("GetDisplaymode", "D3D9_GetDisplayModeHook"))
		D3D9_HOOKS.GetDisplayMode  := IDirect3DDevice9.GetDisplayMode 
		
		logerr(IDirect3DDevice9.dllHook("Clear", "Clear9Hook"))
		D3D9_HOOKS.Clr    := IDirect3DDevice9.Clear 
		logerr(IDirect3DDevice9.dllHook("ColorFill", "ColorFill9Hook"))
		D3D9_HOOKS.CFill  := IDirect3DDevice9.ColorFill 
		
		;logerr(IDirect3DDevice9.dllHook("CreateIndexBuffer", "CreateIndexBuffer9Hook"))
		D3D9_HOOKS.CrtIdxB  := IDirect3DDevice9.CreateIndexBuffer 
		;logerr(IDirect3DDevice9.dllHook("CreateVertexBuffer", "CreateVertexBuffer9Hook"))
		D3D9_HOOKS.CrtVtxB  := IDirect3DDevice9.CreateVertexBuffer 
		
		logerr(IDirect3DDevice9.dllHook("GetRenderTargetData", "GetRenderTargetData9Hook"))
		D3D9_HOOKS.GtRTDt := IDirect3DDevice9.GetRenderTargetData 
		
		(parsecfg(g_.cfg.TextSwap).e) ?: _TS9Init()
		(parsecfg(g_.cfg.PxSwap).e)   ?: _PS9Init()

		D3D9_HOOKS.DrawUp    := IDirect3DDevice9.DrawPrimitiveUp
		D3D9_HOOKS.Draw      := IDirect3DDevice9.DrawPrimitive 	
		D3D9_HOOKS.DrawIdx   := IDirect3DDevice9.DrawIndexedPrimitive			
		D3D9_HOOKS.DrawIdxUp := IDirect3DDevice9.DrawIndexedPrimitiveUp	
		
		pex := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
		if (!g_.cfg.xBR)
		{						
			Hook := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "CreateTx9HD")
			H    :=	dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "CreateTexture9Hook")
			logerr("CreateTexture Hook: " AltInstallHook(Hook, H))
			D3D9_HOOKS.CreateTxHD := H	
			
			Hook := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "UpdateHDSurface9Hook")
			H    :=	dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "UpdateSurface9Hook")
			logerr("UpdateSurface Hook: " AltInstallHook(Hook, H))
			D3D9_HOOKS.UPdateHDSrfc := H
			
			logerr(IDirect3DDevice9.dllHook("CreateCubeTexture", "CreateCubeTexture9Hook"))
			D3D9_HOOKS.CreateCube := IDirect3DDevice9.CreateCubeTexture 		
			logerr(IDirect3DDevice9.dllHook("CreateRenderTarget", "CreateRenderTarget9Hook"))
			D3D9_HOOKS.CreateRT   := IDirect3DDevice9.CreateRenderTarget 
			logerr(IDirect3DDevice9.dllHook("CreateDepthStencilSurface", "CreateDepthStencilSurface9Hook"))
			D3D9_HOOKS.CreateZS   := IDirect3DDevice9.CreateDepthStencilSurface
			logerr(IDirect3DDevice9Ex.dllHook("CreateDepthStencilSurfaceEx", "CreateDepthStencilSurface9ExHook"))
			D3D9_HOOKS.CreateZSEx := IDirect3DDevice9Ex.CreateDepthStencilSurfaceEX
			
			logerr(IDirect3DDevice9.dllHook("DrawPrimitiveUp", "DrawPrimitiveUp9Hook"))
			D3D9_HOOKS.DrawUp    := IDirect3DDevice9.DrawPrimitiveUp
			logerr(IDirect3DDevice9.dllHook("DrawPrimitive", "DrawPrimitive9Hook"))
			D3D9_HOOKS.Draw      := IDirect3DDevice9.DrawPrimitive 			
			logerr(IDirect3DDevice9.dllHook("DrawIndexedPrimitive", "DrawIndexedPrimitive9Hook"))
			D3D9_HOOKS.DrawIdx   := IDirect3DDevice9.DrawIndexedPrimitive	
			logerr(IDirect3DDevice9.dllHook("DrawIndexedPrimitiveUp", "DrawIndexedPrimitiveUP9Hook"))
			D3D9_HOOKS.DrawIdxUp := IDirect3DDevice9.DrawIndexedPrimitiveUp	
			
			;logerr(IDirect3DDevice9.dllHook("SetFVF", "SetFVF9Hook"))
			;logerr(IDirect3DDevice9.dllHook("SetVertexDeclaration", "SetVertexDeclaration9Hook"))
			;logerr(IDirect3DDevice9.dllHook("SetStreamSource", "SetStreamSource9Hook"))
			
			;logerr(IDirect3DDevice9.dllHook("SetVertexShader", "SetVertexShader9Hook"))
			;logerr(IDirect3DDevice9.dllHook("EndStateBlock", "EndStateBlock9Hook"))
			;logerr(IDirect3DStateBlock9.dllHook("Apply", "ApplyStateBlock9Hook"))
			;logerr(IDirect3DStateBlock9.dllHook("Release", "ReleaseStateBlock9Hook"))	
			D3D9_HOOKS.EndBlck   := IDirect3DDevice9.EndStateBlock
            D3D9_HOOKS.ApplyBlck := IDirect3DStateBlock9.Apply 
			D3D9_HOOKS.RlsBlck   := IDirect3DStateBlock9.Release
			D3D9_HOOKS.STVxShdr  := IDirect3DDevice9.SetVertexShader
						
			logerr(IDirect3DCubeTexture9.dllHook("Release", "ReleaseCubeTexture9Hook"))
			D3D9_HOOKS.CbtRls    := IDirect3DCubeTexture9.Release
			;logerr(IDirect3DCubeFace9.dllHook("Release", "ReleaseCubeSurface9Hook")) ; on wine sane adress as IDirect3DSurface9
			;D3D9_HOOKS.CbsRls    := IDirect3DCubeFace9.Release
			
			D3D9_HOOKS.POW2    := (g_.cfg.POW2) ? 1 : 0
			D3D9_HOOKS.FixvPos := (g_.cfg.vPos) ? 1 : 0
			;D3D9_HOOKS.FixvPos := 0
			D3D9_HOOKS.vPosFix := RegisterCallback("vPosFix", "F")	
			;if (g_.cfg.vPos)
				;logerr("Vpos fix " dllcall(pex "\InitWineHoooks", str, "", wstr))
		}		

		if g_.cfg.RLMT
		{
			h := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "D3D9GetMonitorInfoAHook", ptr)
			f := dllcall("GetProcAddress", ptr, dllcall("GetModuleHandleA", astr, "User32.dll", ptr), astr, "GetMonitorInfoA", ptr)
			;s                     := AltInstallHook(h, f)
			D3D9_HOOKS.GtMntrNfoA := f
			logerr("GetMonitorInfoA Hook: " s)

			h := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "D3D9GetSystemMetricsHook", ptr)
			f := dllcall("GetProcAddress", ptr, dllcall("GetModuleHandleA", astr, "User32.dll", ptr), astr, "GetSystemMetrics", ptr)
			;s                     := AltInstallHook(h, f)
			D3D9_HOOKS.GtSysMtrcs := f
			logerr("GetSystemMetrics Hook: " s)
			
			d            := strsplit(["640x480", "800x600", "1024x768", "960x540", "1280x720", "1366x768", "1920x1080"][g_.cfg.RLMT], "x" )			
			D3D9_HOOKS.W := d[1]
			D3D9_HOOKS.H := d[2]
		}
				
		(g_.cfg.MHKS) ? dllcall("Peixoto.dll\InitMouseHooks")
		g_.WnAPI := {}	
		logerr("ChangeDisplaySettingsA Hook: " InstallHook("D3D9ChangeDisplaySettingsA", pChangeDisplaySettingsA, "User32.dll", "ChangeDisplaySettingsA"))	
		if (g_.cfg.MCLP)	
		{
			logerr("ClipCursor Hook" InstallHook("ClipCursor9", p, "User32.dll", "ClipCursor"))
			g_.WnAPI.ClpCrsr := p			
		}
		else g_.WnAPI.ClpCrsr := dllcall("GetProcAddress", uint, dllcall("GetModuleHandleA", astr, "User32.dll", uint), astr, "ClipCursor")
			
		if (g_.cfg.WHKS=2)
		{			
			InstallHook("SetWindowPos9", p, "User32.dll", "SetWindowPos")   
			g_.WnAPI.SetWindowPos := p			
			InstallHook("MoveWindow9", p, "User32.dll", "MoveWindow")
			g_.WnAPI.MoveWindow := p
		}
	}
	D3D9_HOOKS.StFVF    := IDirect3DDevice9.SetFVF
	D3D9_HOOKS.STVxShdr := IDirect3DDevice9.SetVertexShader
	D3D9_HOOKS.STVxDcl  := IDirect3DDevice9.SetVertexDeclaration
	D3D9_HOOKS.StStream := IDirect3DDevice9.SetStreamSource
	
	for k, v in g_.WnAPI
		printl(k " " v)
	
	g_.RTrgts        := new Collection()
	D3D9_HOOKS.Srfcs := g_.RTrgts.pc 
	
	f := g_.cfg.HD
	if (g_.cfg.RLMT)
	f |= 0xf0	
	dllcall("Peixoto.dll\InitHDHooks9", ptr, D3D9_HOOKS[], uint, f)
	if (g_.cfg.console)
		dllcall("peixoto.dll\D3D12Config", astr, "DBUG", uint, 1)
	if (g_.cfg.dxvk)
		dllcall("peixoto.dll\D3D12Config", astr, "DXVK", uint, 9)
	if (g_.cfg.WHKS)
		dllcall("peixoto.dll\D3D12Config", astr, "FIXWINSIZE", uint, 1)
	if (g_.cfg.FLTR)
		logerr(IDirect3DDevice9.Hook("SetSamplerState"))
	ReleaseDirect3D9()
	dllcall(g_.p.Critical, uint, 0)
}

vPosFix(asm)
{
	logerr("vPos shader found")
	static n := 0
	s := strget(asm+0, "cp0")
	if instr(s, " vPos", 2)
	{
		n += 1
		logerr(n "vPos shaders found")
		s := "    ps_3_0" . strsplit(s, "ps_3_0")[2]
		
		c  := 0
		while instr(s, "c" . c)
		c  += 1				
		p  := instr(s, "dcl_")
		v  := 1/D3D9_HOOKS.scale
		ss := SubStr(s, 1, p-1) . "def c" c ", " v ", " v ", " v ", " v
		. "`n    " SubStr(s, p)
		
		r := 1
		while instr(s, "r" . r)
		r += 1	
		
		p := instr(ss, "dcl_", ,-1)
		p := instr(ss, "`n", ,p)
		s := SubStr(ss, 1, p-1) . "`n    mul r" r ".xy, c" c ".xy, vPos" 
		
		ss := SubStr(ss, p)
		stringreplace, ss, ss, vPos.x, r%r%.x, 1
		stringreplace, ss, ss, vPos.y, r%r%.y, 1
		stringreplace, ss, ss, vPos.xy, r%r%.xy, 1
		stringreplace, ss, ss, vPos, r%r%.xy, 1
		s .= ss
		
		logerr("...." s)		
		err := D3DX9.Asm2DXBC(s, blob)	
		if (err)		
			logerr("vPos fix: " err "`n" s)		
		else 
		{
			logerr("vPos fix: OK =)" s)		
			return blob	
		}			
	}
}

D3D9ChangeDisplaySettingsA(p1, p2)
{
	/*
	 * Basic implementation, so IDirect3D9::GetAdapterDisplaymode will
	 * return the correct value in Portal
	 */
	if (!p1)
	{
		w := D3D9_HOOKS.HD_W
		h := D3D9_HOOKS.HD_H
	} else {
		w := numget(p3+108, "int")
		h := numget(p3+112, "int")
	}
	return 0	
}

IDirect3D9_GetAdapterDisplaymode(p1, p2, p3)
{
	r := dllcall(IDirect3D9.GetAdapterDisplaymode, uint, p1, uint, p2, uint, p3) 
	if (r)
	return r
	;logerr("==================================================================")
	DMD   := struct("UINT w, h, r, f;")
	DMD[] := p3
	DMD.w := D3D9_HOOKS.w
	DMD.h := D3D9_HOOKS.h
	return r
}

IDirect3D9_EnumAdapterModes(p1, p2, p3, p4, p5)
{
	r := dllcall(IDirect3D9.EnumAdapterModes, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
	if (r=0)
	{
		DMD   := struct("UINT w, h;")
		DMD[] := p5
		if (DMD.w = 720) 
		{
			if (DMD.h = 480)
			{
				DMD.h := 540 
				DMD.w := 540*D3D9_HOOKS.HD_W/D3D9_HOOKS.HD_H 
			}
			else if (DMD.h = 576)
			{
				DMD.h := 540
				DMD.w := DMD.h *4/3
			}
		}	
		if (g_.cfg.RLMT)
		{
			r := strsplit(g_.cfg.res_lmt_lts[g_.cfg.RLMT], "x" )		
			if (DMD.h > r[2])
				DMD.h := r[2]
			if (DMD.w > r[1])
				DMD.w := r[1]
		}
	}
	return r
}

IDirect3DSwapChain9_GetBackBuffer(p1, p2, p3, p4)
{
	if (dllcall(IDirect3DSwapChain9.GetDevice, ptr, p1, "ptr*", Dvc:=0))
	return dllcall(IDirect3DSwapChain9.GetBackBuffer, ptr, p1, uint, p2, uint, p3, ptr, p4)	
	dllcall(IDirect3DDevice9.release, ptr, Dvc)
	return dllcall("peixoto.dll\GetBackBuffer9Hook", ptr, Dvc, uint, 0, uint, p2, uint, p3, ptr, p4)
}

IDirect3DSwapChain9_Present(p1, p2, p3, p4, p5, p6)
{
	if (dllcall(IDirect3DSwapChain9.GetDevice, ptr, p1, "ptr*", Dvc:=0))
	return dllcall(IDirect3DSwapChain9.Present, ptr, p1, ptr, p2, ptr, p3, ptr, p4, ptr, p5, uint, p6)	
	dllcall(IDirect3DDevice9.release, ptr, Dvc)
	return dllcall("peixoto.dll\Present9Hook", uint, Dvc, uint, 0, uint, 0, uint, 0, uint, 0)
	return dllcall("peixoto.dll\Present9Hook", uint, g_.pDevice9, uint, 0, uint, 0, uint, 0, uint, 0)
}

IDirect3DDevice9_BeginStateBlock(p1)
{
	logerr("BeginStateBlock")
	d 		    := new ComInterfaceWrapper(D3D9.IDirect3DDevice9, p1, True)	
	d.released  := True	
	r           := d.reset
	hr          := dllcall(IDirect3DDevice9.BeginStateBlock, uint, p1)
	
	d 		    := new ComInterfaceWrapper(D3D9.IDirect3DDevice9, p1, True)	
	d.released  := True		
	
	if (d.reset != r)
	{			
		logerr(d.hook("Reset", isfunc("Alt_Reset") ? "Alt_Reset" : "IDirect3DDevice9_reset"))	
		logerr(IDirect3DDevice9.Unhook("BeginStateBlock"))
		IDirect3DDevice9.reset := d.reset		
	}
	return hr
}

IDirect3DDevice9_GetDisplaymode(p1, p2, p3)
{
	if (p3=0)
	return 	D3DERR_INVALIDCALL
	;dllcall(IDirect3DDevice9.GetDisplaymode, uint, p1, uint, p2, uint, p3)
	D       := struct(D3DDISPLAYMODE)
	D[]     := p3
	D.Width  := D3D9_HOOKS.W 
	D.Height := D3D9_HOOKS.H 
	D.Format := D3D9SetPixelFormat("X8RGB")		
	return r
}

D3D9CleanUp(pp)
{
	if ( g_.cfg.HD && pp )
	{
		D3D9_HOOKS.Srfc	 := 0
		D3D9_HOOKS.ZSrfc := 0
		D3D9_HOOKS.Txtr  := 0
		D3D9_HOOKS.ZTxtr := 0
		D3D9_HOOKS.W := D3DPRESENT_PARAMETERS.BackBufferWidth
		D3D9_HOOKS.H := D3DPRESENT_PARAMETERS.BackBufferHeight		
		D3D9_HOOKS.scale :=  D3D9_HOOKS.HD_H/D3DPRESENT_PARAMETERS.BackBufferHeight
		D3D9_HOOKS.HD_X  := (D3D9_HOOKS.HD_W - D3DPRESENT_PARAMETERS.BackBufferWidth*D3D9_HOOKS.scale)/2 

		D3D9_HOOKS.rx  := 0
		D3D9_HOOKS.rw  := D3DPRESENT_PARAMETERS.BackBufferWidth * D3D9_HOOKS.scale
		D3D9_HOOKS.rh  := D3D9_HOOKS.HD_H		
						
		dllcall("Peixoto.dll\SetMouseHooksParams", float, D3D9_HOOKS.HD_W/D3D9_HOOKS.w, float, D3D9_HOOKS.scale
											     , uint, D3D9_HOOKS.HD_X, uint, D3D9_HOOKS.w, uint, D3D9_HOOKS.h)		
									
		D3DPRESENT_PARAMETERS.BackBufferWidth   := D3D9_HOOKS.HD_W
		D3DPRESENT_PARAMETERS.BackBufferHeight  := D3D9_HOOKS.HD_H	
		DllCall("Peixoto.dll\D3D9HDSetUP", uint, D3D9_HOOKS.W, uint, D3D9_HOOKS.h)		
	}	
	g_.D3D9Font          := ""
	D3D9_HOOKS.Font      := ""
	(D3D9_HOOKS.override) ? D3D9_HOOKS.override := dllcall(IDirect3DPixelShader9.release, uint, D3D9_HOOKS.override)
	(D3D9_HOOKS.px)       ? D3D9_HOOKS.px       := dllcall(IDirect3DPixelShader9.release, uint, D3D9_HOOKS.px)
	(D3D9_HOOKS.xBR)      ? D3D9_HOOKS.xBR      := dllcall(IDirect3DPixelShader9.release, uint, D3D9_HOOKS.xBR)
	
}

D3D9Setup()
{
	dllcall("peixoto.dll\D3D12Config", str, "HWND", ptr, D3DPRESENT_PARAMETERS.hDeviceWindow)
	if (D3D9_HOOKS.Fltr & 0xf)
	{
		loop, 4		
			dllcall(IDirect3DDevice9.SetSamplerState, uint, g_.pDevice9, uint, A_index-1, uint, 5, uint, D3D9_HOOKS.Fltr & 0xf)		
	}
	if (D3D9_HOOKS.Fltr & 0xf0)
	{
		loop, 4
		{
			dllcall(IDirect3DDevice9.SetSamplerState, uint, g_.pDevice9, uint, A_index-1, uint, 6, uint, 3)	
			dllcall(IDirect3DDevice9.SetSamplerState, uint, g_.pDevice9, uint, A_index-1, uint, 10, uint, 16)
			dllcall(IDirect3DDevice9.SetSamplerState, uint, g_.pDevice9, uint, A_index-1, uint, 7, uint, 2)
		}
	}
	
	;g_.D3D9Font := D3DX9.CreateFontW(g_.pDevice9)
	;(parsecfg(g_.cfg.TextSwap).e) ? g_tswap9.TextureRect := new FlatRect9(g_.pDevice9, "0|0|" g_tswap9.bltsz "|" g_tswap9.bltsz)	
	fileread, xBR, % g_.cfg.injector_dir "\Shaders\xBRz.fx"	
	if (parsecfg(g_.cfg.PxSwap).e)
	{
		logerr(g_pswap9.code)
		logerr("Compiling shader " D3DX9.CompileShader(g_.pDevice9, g_pswap9.code, "main", pShader))
		;logerr("Compiling shader " D3DX9.CompileShader(g_.pDevice9, g_pswap9.code, "main", tShader))  // this shaders makes texts disapear
	}
	logerr("Compiling shader " D3DX9.CompileShader(g_.pDevice9, xBR, "main_fragment", hxBR) )
	D3D9_HOOKS.xBR      := hxBR
	D3D9_HOOKS.override := pShader
	D3D9_HOOKS.Dev9     := g_.pDevice9
	;D3D9_HOOKS.Font     := g_.D3D9Font.p
	D3D9_HOOKS.px       := tShader
	D3D9_HOOKS.fntx := 0
	D3D9_HOOKS.fnty := g_tswap9.sz
	D3D9_HOOKS.fntw := g_tswap9.sz
	D3D9_HOOKS.fnth := g_tswap9.sz+64
	D3D9_HOOKS.tx := 0
	D3D9_HOOKS.ty := 0
	D3D9_HOOKS.tw := g_tswap9.sz
	D3D9_HOOKS.th := g_tswap9.sz
	D3D9_HOOKS.SetTexture    := IDirect3DDevice9.SetTexture
	D3D9_HOOKS.ReleaseShader := IDirect3DPixelShader9.Release
	if g_.cfg.HD
	{
		p := D3DPRESENT_PARAMETERS
		if (p.BackBufferFormat =0)
			p.BackBufferFormat:=22
		if (g_.cfg.SSAA)
			D3D9_HOOKS.scale := g_.cfg.SSAA * ceil(D3D9_HOOKS.scale)	
		if (g_.cfg.xBR)
			D3D9_HOOKS.scale := 1		 
		
		w := D3D9_HOOKS.w*D3D9_HOOKS.scale
		h := D3D9_HOOKS.h*D3D9_HOOKS.scale	

		g_.Proxies.hlf   := ""
		if (g_.cfg.SSAA)		
			g_.Proxies.hlf := new SProxie9(w/2, h/2, p.BackBufferFormat, 0, 0)
		
		g_.Proxies.rt    := ""
		if (g_.cfg.xBR)
		g_.Proxies.rt    := new Proxie9(w, h, p.BackBufferFormat, p.EnableAutoDepthStencil ? p.AutoDepthStencilFormat : "")
		else
		g_.Proxies.rt    := new SProxie9(w, h, p.BackBufferFormat, p.MultiSampleType, p.MultiSampleQuality
										, p.EnableAutoDepthStencil ? p.AutoDepthStencilFormat : "", p.Flags & 0x2)
		
		g_.Proxies.rt.Set()
		D3D9_HOOKS.HlfSrfc   := g_.Proxies.hlf.s
		D3D9_HOOKS.HDSrfc	 := g_.Proxies.rt.s
		D3D9_HOOKS.HDZSrfc   := g_.Proxies.rt.zs	
		D3D9_HOOKS.rx  += D3D9_HOOKS.HD_X
		D3D9_HOOKS.rw  += D3D9_HOOKS.HD_X
		
		logerr(D3D9_HOOKS.rw "x" D3D9_HOOKS.rh "x" D3D9_HOOKS.rx ":" D3D9_HOOKS.scale " " p.BackBufferFormat)		
		
		if ! isobject(g_.Proxies.clr)
		{
			isobject(g_.Proxies.clr := new Proxie9(1, 1, p.BackBufferFormat, ,1))
			? :      g_.Proxies.clr := new Proxie9(1, 1, p.BackBufferFormat, ,0)
			isobject(g_.Proxies.z   := new Proxie9(1, 1, p.BackBufferFormat, ,1))
			? :      g_.Proxies.z   := new Proxie9(1, 1, p.BackBufferFormat, ,0)
			D3D9_HOOKS.SDSrfc  := g_.Proxies.clr.s
			D3D9_HOOKS.SDZSrfc := g_.Proxies.z.s
		}
		logerr("SDSrfc  " D3D9_HOOKS.SDSrfc)
		logerr("SDZSrfc " D3D9_HOOKS.SDZSrfc)
		dllcall("Peixoto.dll\SetRenderTarget9Hook", uint, g_.pDevice9, UINT, 0, UINT, g_.Proxies.clr.s)	
		logerr("Requested  " D3D9_HOOKS.W " x "	D3D9_HOOKS.H)
		logerr("Real       " D3D9_HOOKS.HD_W " x "	D3D9_HOOKS.HD_H)
		logerr("Scale      " D3D9_HOOKS.scale)
		logerr("Viewport X " D3D9_HOOKS.HD_X)
		logerr("Rect:      " D3D9_HOOKS.rx " " D3D9_HOOKS.ry " " D3D9_HOOKS.rw " " D3D9_HOOKS.rh " ")
		dllcall("peixoto.dll\ResetViewPortPort9", uint)
			
		if g_.cfg.MCLP
		ClipCursor9(0)	
	}		
}

IDirect3D9_CreateDevice(p1, p2, p3, p4, p5, p6, p7)
{
	dllcall(g_.p.Critical, uint, 1)
	Logerr("CREATE DEVICE")
	if (p6)	
		dllcall("RtlMoveMemory", ptr, D3DPRESENT_PARAMETERS[], ptr, p6, int, D3DPRESENT_PARAMETERS.size())	
	D3D9CleanUp(p6)
	if (g_.cfg.hd)
	{
		if (!D3DPRESENT_PARAMETERS.hDeviceWindow)
			 D3DPRESENT_PARAMETERS.hDeviceWindow             := p4
		p5 &= ~ 0x00000010 ;D3DCREATE_PUREDEVICE Halo: Fixexs shadows when foced resolution is enabled	
		if (g_.cfg.WNWM = 2) 
			D3DPRESENT_PARAMETERS.Windowed := 0	
		else if (g_.cfg.WNWM = 1) 
		{
			D3DPRESENT_PARAMETERS.Windowed                   := 1
			D3DPRESENT_PARAMETERS.BackBufferCount            := 1
			D3DPRESENT_PARAMETERS.SwapEffect                 := 2			
			D3DPRESENT_PARAMETERS.FullScreen_RefreshRateInHz := 0			
		}			
	}
	
	(g_.pDevice9)           ? logerr("Ref: " dllcall(IDirect3DDevice9.AddRef, uint, g_.pDevice9))
	                          logerr("About to create device:"), g_.proxies := {}
	(g_tswap9.Replacements) ? logerr(g_tswap9.Replacements.count() " Replacements")
	(g_.RTrgts)             ? logerr(g_.RTrgts.count() " Render surfaces")
	(g_.pDevice9)           ? logerr("Ref: " dllcall(IDirect3DDevice9.release, uint, g_.pDevice9))
	
	for k, v in D3DPRESENT_PARAMETERS
	logerr(k "->" v)
	logerr("Focus " p4)	
	D3DPRESENT_PARAMETERS.PresentationInterval := 1
	if (g_.cfg.SYNC)	
	D3DPRESENT_PARAMETERS.BackBufferCount := 2	
	
	logerr(IDirect3D9Ex.Unhook("CreateDeviceEx"))
	if ! (r := dllcall(IDirect3D9.CreateDevice, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, D3DPRESENT_PARAMETERS[], uint, p7, uint))
	{
		D3D9_HOOKS.safe := (p5 & D3DCREATE_MULTITHREADED) ? 1: 0
		g_.pDevice9 := numget(p7+0, "ptr")	
		d 		    := new ComInterfaceWrapper(D3D9.IDirect3DDevice9, g_.pDevice9, True)	
		d.released  := True	
				
		logerr("multithread " D3D9_HOOKS.safe)	
		D3D9Setup()		
		if (g_.cfg.WHKSEX && g_.cfg.HD) ; Wolfenstein 2009
		{		
			logerr("MoveWindow " dllcall("MoveWindow", ptr, D3DPRESENT_PARAMETERS.hDeviceWindow, uint, 0, uint, 0, uint, D3D9_HOOKS.HD_W, uint, D3D9_HOOKS.HD_H, uint, 0))	;crashes never alone
			dllcall("SendMessage", ptr, D3DPRESENT_PARAMETERS.hDeviceWindow, uint, 0x5, ptr, 0, ptr, D3D9_HOOKS.W|(D3D9_HOOKS.H<<16)) 
			dllcall("peixoto.dll\D3D12Config", astr, "HWND", ptr,  D3DPRESENT_PARAMETERS.hDeviceWindow)	
		}
		if (g_.cfg.FLTR){
			loop, 4 {
				IDirect3DDevice9_SetSamplerState(numget(p7+0, "ptr"), A_index-1, 5, 1)
				IDirect3DDevice9_SetSamplerState(numget(p7+0, "ptr"), A_index-1, 6, 3)
				IDirect3DDevice9_SetSamplerState(numget(p7+0, "ptr"), A_index-1, 10, 16)
			}
		}
	} else Logerr("CREATE DEVICE FAILED")	
	logerr(IDirect3D9Ex.hook("CreateDeviceEx"))
	dllcall(g_.p.Critical, uint, 0)
	return r	
}

IDirect3D9Ex_CreateDeviceEx(p1, p2, p3, p4, p5, p6, p7, p8)
{		
	Logerr("CREATE DEVICEEX")
	if (p6)	
		dllcall("RtlMoveMemory", ptr, D3DPRESENT_PARAMETERS[], ptr, p6, int, D3DPRESENT_PARAMETERS.size())	
	if (p7)
		dllcall("RtlMoveMemory", ptr, D3DDISPLAYMODEEX[], ptr, p7, int, D3DDISPLAYMODEEX.size())	
	D3D9CleanUp(p6)
	if (g_.cfg.hd)
	{
		if (!D3DPRESENT_PARAMETERS.hDeviceWindow)
			 D3DPRESENT_PARAMETERS.hDeviceWindow             := p4
		p5 &= ~ 0x00000010 ;D3DCREATE_PUREDEVICE Halo: Fixexs shadows when foced resolution is enabled	
		if (g_.cfg.WNWM = 2) 
			D3DPRESENT_PARAMETERS.Windowed := 0	
		else if (g_.cfg.WNWM = 1) 
		{
			D3DPRESENT_PARAMETERS.Windowed                   := 1
			D3DPRESENT_PARAMETERS.BackBufferCount            := 1
			D3DPRESENT_PARAMETERS.SwapEffect                 := 2			
			D3DPRESENT_PARAMETERS.FullScreen_RefreshRateInHz := 0			
		}		
		D3DDISPLAYMODEEX.Width            := D3D9_HOOKS.HD_W	
		D3DDISPLAYMODEEX.Height           := D3D9_HOOKS.HD_H	
		;D3DDISPLAYMODEEX.Format           := D3D9SetPixelFormat("X8RGB")
		;D3DDISPLAYMODEEX.RefreshRate      := 0
		;D3DDISPLAYMODEEX.ScanLineOrdering := 1 ;D3DSCANLINEORDERING_PROGRESSIVE
	}
	
	(g_.pDevice9)           ? logerr("Ref: " dllcall(IDirect3DDevice9.AddRef, uint, g_.pDevice9))
	                          logerr("About to create device:"), g_.proxies := {}
	(g_tswap9.Replacements) ? logerr(g_tswap9.Replacements.count() " Replacements")
	(g_.RTrgts)             ? logerr(g_.RTrgts.count() " Render surfaces")
	(g_.pDevice9)           ? logerr("Ref: " dllcall(IDirect3DDevice9.release, uint, g_.pDevice9))

	for k, v in D3DDISPLAYMODEEX
	logerr("D3DDISPLAYMODEEX" k "->" v)	
	
	for k, v in D3DPRESENT_PARAMETERS
	logerr("D3DPRESENT_PARAMETERS" k "->" v)
	logerr("Focus " p4)	
	D3DPRESENT_PARAMETERS.PresentationInterval := 1
	if (g_.cfg.SYNC)	
	D3DPRESENT_PARAMETERS.BackBufferCount := 2		
	
	r := dllcall(IDirect3D9Ex.CreateDeviceEX, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5
	, uint, D3DPRESENT_PARAMETERS[], uint, p7? D3DDISPLAYMODEEX[]:p7, uint, p8, uint)
	if (r=0)
	{		
		GUID_FromString(dvc_guid, D3D9.IID_IDirect3DDevice9)
		if (dllcall(IDirect3DDevice9.QueryInterface, ptr, numget(p8+0, "ptr"), ptr, &dvc_guid, "ptr*", pDvc9:=0) != 0){
			logerr("Failed to query the IDirect3DDevice9")
		}
		g_.pDevice9     := pDvc9	
		D3D9_HOOKS.safe := (p5 & D3DCREATE_MULTITHREADED) ? 1: 0			
				
		logerr("multithread " D3D9_HOOKS.safe)	
		D3D9Setup()		
		if (g_.cfg.WHKSEX && g_.cfg.HD) ; Wolfenstein 2009
		{		
			logerr("MoveWindow " dllcall("MoveWindow", ptr, D3DPRESENT_PARAMETERS.hDeviceWindow, uint, 0, uint, 0, uint, D3D9_HOOKS.HD_W, uint, D3D9_HOOKS.HD_H, uint, 0))	;crashes never alone
			dllcall("SendMessage", ptr, D3DPRESENT_PARAMETERS.hDeviceWindow, uint, 0x5, ptr, 0, ptr, D3D9_HOOKS.W|(D3D9_HOOKS.H<<16)) 
			dllcall("peixoto.dll\D3D12Config", astr, "HWND", ptr,  D3DPRESENT_PARAMETERS.hDeviceWindow)	
		}
		if (g_.cfg.FLTR){
			loop, 4 {
				IDirect3DDevice9_SetSamplerState(numget(p8+0, "ptr"), A_index-1, 5, 1)
				IDirect3DDevice9_SetSamplerState(numget(p8+0, "ptr"), A_index-1, 6, 3)
				IDirect3DDevice9_SetSamplerState(numget(p8+0, "ptr"), A_index-1, 10, 16)
			}
		}
	} else Logerr("CREATE DEVICEEX FAILED " r  " " d3d9.err[r . ""])		
	return r	
}

IDirect3DDevice9_Reset(p1, p2)
{	
	dllcall(g_.p.Critical, uint, 1)
	g_.pDevice9  := p1
	Logerr("RESET " p2)
	if g_.cfg.HD
	{
		hwin := D3DPRESENT_PARAMETERS.hDeviceWindow
		if (p2)	
		{
			dllcall("RtlMoveMemory", ptr, D3DPRESENT_PARAMETERS[], ptr, p2, int, D3DPRESENT_PARAMETERS.size())
			if (!D3DPRESENT_PARAMETERS.hDeviceWindow)
				 D3DPRESENT_PARAMETERS.hDeviceWindow := hwin
		}
		D3D9CleanUp(p2)
		D3D9Setup()
		dllcall("peixoto.dll\vPosReset9", uint, p1)
	} else	r := dllcall(IDirect3DDevice9.Reset, uint, p1, uint, p2)
	dllcall(g_.p.Critical, uint, 0)
	return r
}

IDirect3DDevice9Ex_ResetEx(p1, p2, p3)
{	
	dllcall(g_.p.Critical, uint, 1)
	g_.pDevice9  := p1
	Logerr("RESETEx " p2)
	if g_.cfg.HD
	{
		hwin := D3DPRESENT_PARAMETERS.hDeviceWindow
		if (p2)	
		{
			dllcall("RtlMoveMemory", ptr, D3DPRESENT_PARAMETERS[], ptr, p2, int, D3DPRESENT_PARAMETERS.size())
			if (!D3DPRESENT_PARAMETERS.hDeviceWindow)
				 D3DPRESENT_PARAMETERS.hDeviceWindow := hwin
		}
		D3D9CleanUp(p2)
		D3D9Setup()
		dllcall("peixoto.dll\vPosReset9", uint, p1)
	} else	r := dllcall(IDirect3DDevice9Ex.ResetEx, uint, p1, uint, p2)
	dllcall(g_.p.Critical, uint, 0)
	return r
}

IDirect3DDevice9_EndScene(p1)
{
	keyevent(g_tswap9.sw) 
	? g_tswap9.srch        := (g_tswap9.srch) ? False : True
	, D3D9_HOOKS.searching :=  g_tswap9.srch
	
	keyevent(g_pswap9.sw) 
	? g_pswap9.srch        := (g_pswap9.srch) ? False : True
	, D3D9_HOOKS.srchng    := g_pswap9.srch 
	
	if (g_pswap9.srch) 
		return BrowseShaders9(p1)
	if (g_tswap9.srch) 
		return BrowseTextures9(p1)		
	
	return 0
}

ClipCursor9(p1)
{
	if (g_.cfg.MCLP=2)
	{
		VarSetCapacity(r, 8, 0)
		numput(D3D9_HOOKS.HD_X-1, &r+08, "uint")
		numput(D3D9_HOOKS.HD_W-D3D9_HOOKS.HD_X, &r+08, "uint")
		numput(D3D9_HOOKS.HD_H-1, &r+12, "uint")
		return dllcall(g_.WnAPI.ClpCrsr, uint, &r)
	}
	VarSetCapacity(r, 8, 0)
	numput(D3D9_HOOKS.HD_W/D3D9_HOOKS.scale-1, &r+08, "uint")
	numput(D3D9_HOOKS.HD_H/D3D9_HOOKS.scale-1, &r+12, "uint")
	return dllcall(g_.WnAPI.ClpCrsr, uint, &r)
}

MoveWindow9(p1, p2, p3, p4, p5, p6)
{
	if (p1 = D3DPRESENT_PARAMETERS.hDeviceWindow)
	{
		p5 := D3D9_HOOKS.HD_H
		p4 := D3D9_HOOKS.HD_W
		p3 := 0
		p2 := 0
	}	
	r := dllcall(g_.WnAPI.MoveWindow, ptr, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)	
	return r
}

SetWindowPos9(p1, p2, p3, p4, p5, p6, p7)
{
	;return
	if (p1 = D3DPRESENT_PARAMETERS.hDeviceWindow)
	{
		p6 := D3D9_HOOKS.HD_H
		p5 := D3D9_HOOKS.HD_W
		p4 := 0
		p3 := 0
	}	
	r := dllcall(g_.WnAPI.SetWindowPos, ptr, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)
	return r
}

GetClientRect9(h, rr)
{
	if (h = D3DPRESENT_PARAMETERS.hDeviceWindow)
	{
		r    := struct("DWORD x, y, w, h")
		r[]  := rr
		r.x  := 
		r.y  := 0 
		r.w  := D3D9_HOOKS.W
		r.h  := D3D9_HOOKS.H
		return 1
	}
	return dllcall(g_.WnAPI.GetClientRect, uint, h, uint, rr)
}

GetWindowRect9(h, rr)
{
	if (h = D3DPRESENT_PARAMETERS.hDeviceWindow)
	{
		r    := struct("DWORD x, y, w, h")
		r[]  := rr
		r.x  := 
		r.y  := 0 
		r.w  := D3D9_HOOKS.W
		r.h  := D3D9_HOOKS.H
		return 1
	}
	return dllcall(g_.WnAPI.GetWindowRect, uint, h, uint, rr)
}

GetDeviceCaps9(p1, p2)
{
	if      (p2 = 8)
	return D3D9_HOOKS.W
	else if	(p2 = 10)
	return D3D9_HOOKS.H	
	return dllcall(g_.WnAPI.GetDeviceCaps9, uint, p1, uint, p2)
}

IDirect3DDevice9_SetSamplerState(p1, p2, p3, p4)
{
	/*
	D3DSAMP_MAGFILTER       = 5
	D3DSAMP_MINFILTER       = 6	
	D3DSAMP_MAXANISOTROPY   = 10
	D3DTEXF_NONE            = 0
	D3DTEXF_POINT           = 1
	D3DTEXF_LINEAR          = 2
	D3DTEXF_ANISOTROPIC     = 3
	*/

	p4 := p3 = 5 ? 1 : p3 = 6 ? 3 : p3 = 10 ? 16 : p4
	return dllcall(IDirect3DDevice9.SetSamplerState, ptr, p1, uint, p2, uint, p3, uint, p4)
  
}