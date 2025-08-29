#include lib\DirectX\D3D11.ahk
D3D11_HOOKS :=
(
"
LPVOID CrtSmplrStt;
DWORD Aniso, Point;
DWORD W, H, WinW, WinH, HD_W, HD_H, VW_X;
float  Scale;
LPVOID AHKSetup;
LPVOID CreateChain;
LPVOID CreateChainForHwnd;
LPVOID GetDesc;
LPVOID GetDesc1;
LPVOID Getbff;
LPVOID Rsz;
LPVOID RszTrgt;
LPVOID GetModes;
LPVOID StVW;   
LPVOID GtVW;
LPVOID StScsr;
LPVOID GtScsr;
LPVOID StTrgt; 
LPVOID GtTrgt;
LPVOID Clear;
LPVOID ClearRT;
LPVOID DscrdRsrc;
LPVOID DscrdVW;
LPVOID StSmplr;
LPVOID PxCreate; 
LPVOID PxRelease; 
LPVOID PxSet;
LPVOID PxShdrs;
LPVOID PxBlob;
LPVOID CrrntPxR;
LPVOID CrrntPx;
LPVOID  present; 
LPVOID _present; 
LPVOID Dev; 
LPVOID Ctx; 
LPVOID Bltvx; 
LPVOID Bltpx;
LPVOID Textpx;
LPVOID Texttx;
LPVOID Textvw;
LPCTSTR tex;
LPCTSTR dump;
DWORD clr;
LPVOID Resolve;
LPVOID Copy;
LPVOID CopyRegion;
LPVOID UpdateSubrsrc;
LPVOID ReadSubresource;
LPVOID map;
LPVOID unmap;
LPVOID ImSetResources;
LPVOID CreateTex2D;
LPVOID ReleaseTex2D;
LPVOID CreateResView;
LPVOID ReleaseResView;
DWORD txt_rct_x;
DWORD txt_rct_y;
DWORD txt_rct_w;
DWORD txt_rct_h;
DWORD img_rct_x;
DWORD img_rct_y;
DWORD img_rct_w;
DWORD img_rct_h;
BOOL search;
LPVOID current;
LPVOID texts;
LPVOID replace;
LPVOID paths;
DWORD autodmp; 
"
)

Global D3D11_HOOKS := struct(D3D11_HOOKS)
D3D11_HOOKS.clr    := 0x00FFFFFF
global g_TSwap     := {"thumb" : 256} ; When textswap is not enabled, Pxswap neeeds this value
global g_PxOvrrd   := {}

#Include D3D10.Hooks.ahk

PxOvrr11dInit()
{
	g_PxOvrrd           := parsecfg(g_.cfg.PxSwap)
	g_PxOvrrd.user_path := g_.cfg.path "pixelshaders"
	if ! fileexist(g_PxOvrrd.user_path) 
	{	
		path := g_PxOvrrd.user_path
		FileCreateDir, %path%
	}	
	
	name           := g_.cfg.target_name
	StringLower, name, name
	name           := strsplit(name, ".exe")[1]
	g_PxOvrrd.path := g_.cfg.injector_dir "\patches\" name 
	
	g_PxOvrrd.PxShdrs   := new Collection()
	D3D11_HOOKS.PxShdrs := g_PxOvrrd.PxShdrs.pc
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"	
	
	for k, v in [g_PxOvrrd.user_path, g_PxOvrrd.path]
	{
		loop, % v "\*.hlsl"
		{
			bin := StrReplace(A_LoopFileFullPath, ".hlsl", ".bin")
			if FileExist(bin)
			{
				VarSetCapacity(dat, (bin := FileOpen(bin, "r")).Length)
				bin.RawRead(&dat, bin.Length)
				
				hl    := FileOpen(A_LoopFileFullPath, "r").read()
				prfl  := StrSplit( StrSplit(hl, "//")[2], "@" )[1]
				if (r := _D3D11Compile(blob, hl, prfl))
				{
					logerr("Failed to compile " A_LoopFileFullPath ":`n`n" r)					
				} else				
				logerr("Inserted Dump " dllcall(dll "\D3D11InsetPxDump", ptr, &dat, ptr, bin.Length, str, A_LoopFileName, ptr, blob.p, ptr, blob.sz, uint) " " A_LoopFileName)
			}			
		}
	}
	if (! parsecfg(g_.cfg.TextSwap).e)
	{
		D3D11_HOOKS.txt_rct_x := 0
		D3D11_HOOKS.txt_rct_y := 0
		D3D11_HOOKS.txt_rct_w := 512
		D3D11_HOOKS.txt_rct_h := 512
	}

	dllcall(dll "\D3D12Config", astr, "PXSWAP", uint, true)
	dllcall(dll "\D3D12Config", astr, "PIXEL-SWAP.TOGGLE", uint, GetKeyVK(g_PxOvrrd.sw)) 
	dllcall(dll "\D3D12Config", astr, "PIXEL-SWAP.NEXT",  uint, GetKeyVK(g_PxOvrrd.n)) 
	dllcall(dll "\D3D12Config", astr, "PIXEL-SWAP.PREV",  uint, GetKeyVK(g_PxOvrrd.p)) 
	dllcall(dll "\D3D12Config", astr, "PIXEL-SWAP.QUICK", uint, GetKeyVK(g_PxOvrrd.q)) 
	dllcall(dll "\D3D12Config", astr, "PIXEL-SWAP.DUMP",  uint, GetKeyVK(g_PxOvrrd.d)) 
}

TSwapInit(dll)
{
	g_TSwap       := parsecfg(g_.cfg.TextSwap)
	g_TSwap.path  := g_.cfg.path g_TSwap.path
	g_TSwap.thumb := g_TSwap.sz
	for k, v in ["Dumps", "Replacements"] 
	{
		if ! fileexist(g_TSwap.path "\" v) 
		{
			path := g_TSwap.path
			FileCreateDir, %path%\%v%
		}
	}
	
	g_TSwap.texts       := new Collection()
	D3D11_HOOKS.texts   := g_TSwap.texts.pc
	g_TSwap.replace     := new Collection()
	D3D11_HOOKS.replace := g_TSwap.replace.pc
	g_TSwap.paths       := new Collection()
	D3D11_HOOKS.paths   := g_TSwap.paths.pc
	D3D11_HOOKS.autodmp := g_TSwap.a
	
	D3D11_HOOKS.txt_rct_x := 0
	D3D11_HOOKS.txt_rct_y := g_TSwap.thumb
	D3D11_HOOKS.txt_rct_w := g_TSwap.thumb
	D3D11_HOOKS.txt_rct_h := g_TSwap.thumb*2
	D3D11_HOOKS.img_rct_x :=
	D3D11_HOOKS.img_rct_y :=
	D3D11_HOOKS.img_rct_w := g_TSwap.thumb
	D3D11_HOOKS.img_rct_h := g_TSwap.thumb

	dllcall(dll "\D3D12Config", astr, "TEXTSWAP", uint, true) 
	dllcall(dll "\D3D12Config", astr, "TEXT-SWAP.TOGGLE-SEARCH", uint, GetKeyVK(g_TSwap.sw)) 
	dllcall(dll "\D3D12Config", astr, "TEXT-SWAP.NEXT",  uint, GetKeyVK(g_TSwap.n)) 
	dllcall(dll "\D3D12Config", astr, "TEXT-SWAP.PREV",  uint, GetKeyVK(g_TSwap.p)) 
	dllcall(dll "\D3D12Config", astr, "TEXT-SWAP.QUICK", uint, GetKeyVK(g_TSwap.q)) 
	dllcall(dll "\D3D12Config", astr, "TEXT-SWAP.DUMP",  uint, GetKeyVK(g_TSwap.d)) 	
	dllcall(dll "\D3D12Config", astr, "TEXT-SWAP.AUTO",  uint, GetKeyVK(g_TSwap.a)) 
	
	dllcall(dll "\SetSampleCount", uint, g_TSwap.s)
	dllcall(dll "\SetTexturePaths", str, g_TSwap.path "/dumps/", astr, g_.cfg.MyDocs "\Games\checkerboard.dds")
	if fileexist((comp := g_TSwap.path "\Dumps\dump._dds"))
		LoadCompiledDumpCollection(comp, lst := [])
	else LoadDumpCollection(g_TSwap.path "\Dumps", lst := [])
	g_TSwap.dumps := []
	return	
}

D3D11InitHDHooks(dll)
{
	if (g_.cfg.HD)
	{
		if g_.cfg.MHKS
		dllcall(dll "\InitMouseHooks")				
		g_.WnAPI.SetWindowPos := dllcall("GetProcAddress", ptr, dllcall("LoadLibraryW", astr, "User32.dll", ptr), astr, "SetWindowPos", ptr)
		
		logerr(IDXGISwapChain.dllHook("ResizeTarget", "D3D11ResizeTargetHook", dll))
		logerr(IDXGISwapChain.dllHook("ResizeBuffers", "D3D11ResizeBuffersHook", dll))
		logerr(IDXGISwapChain.dllHook("GetBuffer", "DXGIGetBufferHook", dll))		
	}
	D3D11_HOOKS.Getbff   := IDXGISwapChain.GetBuffer
	D3D11_HOOKS.GetDesc  := IDXGISwapChain.GetDesc
	D3D11_HOOKS.GetDesc1 := IDXGISwapChain1.GetDesc1
	D3D11_HOOKS.Rsz      := IDXGISwapChain.ResizeBuffers
	D3D11_HOOKS.RszTrgt  := IDXGISwapChain.ResizeTarget
	D3D11_HOOKS.GetModes := IDXGIOutput.GetDisplayModeList
}

InitD3D11Hooks()
InitD3D11Hooks()
{	
	d                  := Desk()
	D3D11_HOOKS.HD_W   := d.w
	D3D11_HOOKS.HD_H   := d.h
	D3D11_HOOKS.W      := d.w
	D3D11_HOOKS.H      := d.h
	if (g_.cfg.RLMT)
	{
		d := strsplit(g_.cfg.res_lmt_lts[g_.cfg.RLMT], "x" )	
		D3D11_HOOKS.W := d[1]
		D3D11_HOOKS.H := d[2]
	}	
	
	if (g_.cfg.D3D = 10)
	return InitD3D10Hooks()			
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	
	dllcall(dll "\D3D12Config", astr, "D3D.VERSION", ptr, 11)
    dllcall(dll "\NVIDIA_Set", wstr, g_.cfg.target, uint, g_.cfg.NVAA)
	hd_cfg := g_.cfg.HD
	StringUpper, hd_cfg_up, hd_cfg
	for k ,v in strsplit(hd_cfg_up, "|")
		dllcall(dll "\D3D12Config", astr, v, uint, 2) ; 2 for full precision FSR 
	(g_.cfg.WHKS)    ? dllcall(dll "\D3D12Config", astr, "FIXWINSIZE", ptr, 1)
	(g_.cfg.MHKS)    ? dllcall(dll "\D3D12Config", astr, "MOUSEHOOKS", ptr, 1)	
	(g_.cfg.gamma)   ? dllcall(dll "\D3D12Config", astr, "GAMMA", ptr, 1)	
	(g_.cfg.VSNC)    ? dllcall(dll "\D3D12Config", astr, "VSYNC", ptr, 1)	
	(g_.cfg.MCLP)    ? dllcall(dll "\D3D12Config", astr, "MOUSECLIP" , str, g_.cfg.MCLP)
    (g_.cfg.DBLBFF)  ? dllcall(dll "\D3D12Config", astr, "DOUBLEBUFF", uint, 1)
	arch      := A_PtrSize = 8 ? "System32" : "SysWOW64"
	wine_path := g_.cfg.injector_dir . "\wined3d\"  g_.cfg.wine "\" arch 
	dxvk_path := g_.cfg.injector_dir . "\dxvk\"  g_.cfg.dxvkv "\" arch 
	flags     := g_.cfg.dxvk ? 0xd : 0
	dllcall(dll "\InitD3D11Hooks", ptr, D3D11_HOOKS[], astr, wine_path, astr, dxvk_path, astr, g_.cfg.target_dir, uint, flags)	
				
 	logerr(GetDirect3D11())		
	logerr(IDXGIFactory2.dllHook("CreateSwapChainForHwnd", "D3D11CreateSwapChainForHwnd", dll))	
	logerr(IDXGIFactory.dllHook("CreateSwapChain", "D3D11CreateSwapChain", dll))	
	D3D11_HOOKS.CreateChainForHwnd := IDXGIFactory2.CreateSwapChainForHwnd
	D3D11_HOOKS.CreateChain        := IDXGIFactory.CreateSwapChain	
	logerr(IDXGISwapChain.dllHook("Present", "IDXGISwapChainPresentHook", dll))
		
	D3D11_HOOKS.present         := IDXGISwapChain.Present	
	D3D11_HOOKS.ImSetResources  := ID3D11ImDeviceContext.PSSetShaderResources
	D3D11_HOOKS.CreateTex2D     := ID3D11Device.CreateTexture2D
	D3D11_HOOKS.CreateResView   := ID3D11Device.CreateShaderResourceView 
	D3D11_HOOKS.ReadSubresource := ID3D11Device3.ReadFromSubresource	
	D3D11_HOOKS.Map             := ID3D11ImDeviceContext.Map	
	D3D11_HOOKS.Unmap           := ID3D11ImDeviceContext.Unmap	
	D3D11_HOOKS.CopyRegion      := ID3D11ImDeviceContext.CopySubresourceRegion 
	
	if (parsecfg(g_.cfg.TextSwap).e or instr(g_.cfg.HD, "USEPROXIES")) 
	{
		if ! parsecfg(g_.cfg.TextSwap).e
		{
			g_TSwap             := {}
			g_TSwap.texts       := new Collection()
			D3D11_HOOKS.texts   := g_TSwap.texts.pc
			g_TSwap.replace     := new Collection()
			D3D11_HOOKS.replace := g_TSwap.replace.pc			 
		}
		else 
		{
			TSwapInit(dll)
			/*  Adding textures to the collection is troublesome in some games, but ideally that should be fixed
			 */
			logerr(ID3D11Device.dllHook("CreateTexture2D", "D3D11CreateTexture2DHook", dll))	
		}			
			
		logerr(ID3D11Texture2D.dllHook("Release", "D3D11Texture2DReleaseHook", dll))					
		logerr(ID3D11ImDeviceContext.dllHook("PSSetShaderResources", "D3D11PSSetShaderResourcesHook", dll))				
		logerr(ID3D11ImDeviceContext.dllHook("Map", "D3D11MapHook", dll))		 
		logerr(ID3D11ImDeviceContext.dllHook("Unmap", "D3D11UnmapHook", dll))		
		logerr(ID3D11ImDeviceContext.dllHook("CopySubresourceRegion", "D3D11CopySubresourceRegionHook", dll))		
		logerr(ID3D11ImDeviceContext.dllHook("UpdateSubresource", "D3D11UpdateSubresourceHook", dll))			
	} 
	D3D11_HOOKS.CreateResView  := ID3D11Device.CreateShaderResourceView 	
	D3D11_HOOKS.ReleaseResView := ID3D11ShaderResourceView.Release
	D3D11_HOOKS.CreateTex2D    := ID3D11Device.CreateTexture2D 		
	D3D11_HOOKS.ReleaseTex2D   := ID3D11Texture2D.Release	
	D3D11_HOOKS.ImSetResources := ID3D11ImDeviceContext.PSSetShaderResources 
	D3D11_HOOKS.map            := ID3D11ImDeviceContext.Map
	D3D11_HOOKS.Unmap          := ID3D11ImDeviceContext.Unmap
	D3D11_HOOKS.CopyRegion     := ID3D11ImDeviceContext.CopySubresourceRegion
	D3D11_HOOKS.UpdateSubrsrc  := ID3D11ImDeviceContext.UpdateSubresource
	
	if (parsecfg(g_.cfg.PxSwap).e or g_.cfg.HD)
	{
		if (! parsecfg(g_.cfg.PxSwap).e ) 
		{
			g_PxOvrrd           := {}
			g_PxOvrrd.PxShdrs   := new Collection()
			D3D11_HOOKS.PxShdrs := g_PxOvrrd.PxShdrs.pc
		} else PxOvrr11dInit()
		logerr(ID3D11ImDeviceContext.dllHook("PsSetShader", "D3D11PsSetShaderHook", dll))
		logerr(ID3D11Device.dllHook("CreatePixelShader", "CreatePixelShader11Hook", dll))
		if ( !parsecfg(g_.cfg.TextSwap).e && !g_.cfg.HD )
			logerr(ID3D11PixelShader.dllHook("Release", "ReleasePixelShader11Hook", dll))			
	} 
	D3D11_HOOKS.PxCreate  := ID3D11Device.CreatePixelShader
	D3D11_HOOKS.PxRelease := ID3D11PixelShader.Release
	D3D11_HOOKS.PxSet     := ID3D11ImDeviceContext.PsSetShader
	
	if (g_.cfg.HD)
	{
		logerr(ID3D11ImDeviceContext.dllHook("ResolveSubresource", "D3D11ResolveSubresourceHook", dll))
		logerr(ID3D11ImDeviceContext.dllHook("CopyResource", "D3D11CopyResourceHook", dll))
		logerr(ID3D11ImDeviceContext.dllHook("OMSetRenderTargets", "D3D11OMSetRenderTargetsHook", dll)) 
		logerr(ID3D11ImDeviceContext.dllHook("OMGetRenderTargets", "D3D11OMGetRenderTargetsHook", dll)) 
		logerr(ID3D11ImDeviceContext.dllHook("ClearDepthStencilView", "D3D11ClearDepthStencilViewHook", dll) )
		logerr(ID3D11ImDeviceContext.dllHook("ClearRenderTargetView", "D3D11ClearRenderTargetViewHook", dll) )		 	
		;logerr(ID3D11ImDeviceContext1.dllHook("DiscardView", "D3D11DiscardViewHook", dll)) 			
	}
	D3D11_HOOKS.StTrgt   := ID3D11ImDeviceContext.OMSetRenderTargets
	D3D11_HOOKS.GtTrgt   := ID3D11ImDeviceContext.OMGetRenderTargets
	D3D11_HOOKS.Clear    := ID3D11ImDeviceContext.ClearDepthStencilView 
	D3D11_HOOKS.ClearRT  := ID3D11ImDeviceContext.ClearRenderTargetView 
	D3D11_HOOKS.StVW     := ID3D11ImDeviceContext.RSSetViewports
	D3D11_HOOKS.StScsr   := ID3D11ImDeviceContext.RSSetScissorRects
	D3D11_HOOKS.GtVW     := ID3D11ImDeviceContext.RSGetViewports
	D3D11_HOOKS.GtScsr   := ID3D11ImDeviceContext.RSGetScissorRects
	D3D11_HOOKS.Copy     := ID3D11ImDeviceContext.CopyResource
	D3D11_HOOKS.Resolve  := ID3D11ImDeviceContext.ResolveSubresource
	D3D11_HOOKS.DscrdVW  := ID3D11ImDeviceContext1.DiscardView
	D3D11InitHDHooks(dll)
	
	if (g_.cfg.fltr || g_.cfg.TextSwap.a)
	logerr(ID3D11ImDeviceContext.dllHook("PSSetSamplers", "D3D11PSSetSamplersHook", dll)) 
	D3D11_HOOKS.StSmplr := ID3D11ImDeviceContext.PSSetSamplers
	D3D11_HOOKS.Aniso := g_.cfg.TextSwap.a
	D3D11_HOOKS.Point := g_.cfg.FLTR
	dllcall(dll "\D3D11SetupFinished", ptr, IDXGISwapChain.p)	
	IDXGISwapChain.GetDesc         := D3D11_HOOKS.GetDesc
	IDXGISwapChain1.GetDesc1       := D3D11_HOOKS.GetDesc1
	IDXGIOutput.GetDisplayModeList := D3D11_HOOKS.GetModes ; not initialized
}
