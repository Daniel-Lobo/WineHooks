InitD3D10Hooks()	
{
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"	
	(g_.cfg.MCLP)   ? dllcall(dll "\D3D12Config", astr, "MOUSECLIP" , str, g_.cfg.MCLP)
	hd_cfg := g_.cfg.HD
	StringUpper, hd_cfg_up, hd_cfg
	for k ,v in strsplit(hd_cfg_up, "|")
		dllcall(dll "\D3D12Config", astr, v, uint, 2) ; 2 for full precision FSR 
	(g_.cfg.WHKS)   ? dllcall(dll "\D3D12Config", astr, "FIXWINSIZE", ptr, 1)
	(g_.cfg.MHKS)   ? dllcall(dll "\D3D12Config", astr, "MOUSEHOOKS", ptr, 1)
	(g_.cfg.VSNC)   ? dllcall(dll "\D3D12Config", astr, "VSYNC", ptr, 1)	
	arch      := A_PtrSize == 8 ? "System32" : "SysWOW64"
	wine_path := g_.cfg.injector_dir . "\wined3d\"  g_.cfg.wine "\" arch 
	dxvk_path := g_.cfg.injector_dir . "\dxvk\"  g_.cfg.dxvkv "\" arch 
	flags     := g_.cfg.dxvk ? 0xd : 0
	dllcall(dll "\InitD3D11Hooks", ptr, D3D11_HOOKS[], astr, wine_path, astr, dxvk_path, astr, g_.cfg.target_dir, uint, flags)
	
	logerr(GetDirect3D10())	
	;logerr(IDXGIFactory.Hook("CreateSwapChain", "CreateSwapChain10"))
	logerr(IDXGIFactory.dllHook("CreateSwapChain", "D3D10CreateSwapChain", dll))
	D3D11_HOOKS.CreateChain := IDXGIFactory.CreateSwapChain
	logerr(IDXGISwapChain.dllHook("Present", "IDXGISwapChainPresentHook", dll))
	D3D11_HOOKS.present  := IDXGISwapChain.Present	
	D3D11_HOOKS._present := RegisterCallback("IDXGISwapChain_Present", "F")
	
	if (parsecfg(g_.cfg.TextSwap).e or g_.cfg.HD)
	{
		if ! parsecfg(g_.cfg.TextSwap).e
		{
			g_TSwap             := {}
			g_TSwap.texts       := new Collection()
			D3D11_HOOKS.texts   := g_TSwap.texts.pc
			g_TSwap.replace     := new Collection()
			D3D11_HOOKS.replace := g_TSwap.replace.pc			 
		}
		else TSwapInit(dll)
		logerr(ID3D10Device.dllHook("CopySubresourceRegion", "D3D10CopySubresourceRegionHook", dll))
		logerr(ID3D10Device.dllHook("CreateShaderResourceView", "D3D10CreateShaderResourceViewHook", dll))		
		logerr(ID3D10Device.dllHook("UpdateSubresource", "D3D10UpdateSubresourceHook", dll))
		logerr(ID3D10Device.dllHook("PSSetShaderResources", "D3D10PSSetShaderResourcesHook", dll))		
		logerr(ID3D10ShaderResourceView.dllHook("Release", "D3D10ResourceViewReleaseHook", dll))		
		logerr(ID3D10Device.dllHook("CreateTexture2D", "D3D10CreateTexture2DHook", dll))
		logerr(ID3D10Texture2D.dllHook("Release", "D3D10Texture2DReleaseHook", dll))		
		logerr(ID3D10Texture2D.dllHook("Map", "D3D10MapHook", dll))		
		logerr(ID3D10Texture2D.dllHook("Unmap", "D3D10UnmapHook", dll))		
	} 
	
	D3D11_HOOKS.CreateResView  := ID3D10Device.CreateShaderResourceView 
	D3D11_HOOKS.ReleaseResView := ID3D10ShaderResourceView.Release
	D3D11_HOOKS.CreateTex2D    := ID3D10Device.CreateTexture2D 	
	D3D11_HOOKS.ReleaseTex2D   := ID3D10Texture2D.Release
	D3D11_HOOKS.map            := ID3D10Texture2D.Map 
	D3D11_HOOKS.Unmap          := ID3D10Texture2D.Unmap	
	D3D11_HOOKS.UpdateSubrsrc  := ID3D10Device.UpdateSubresource
	D3D11_HOOKS.ImSetResources := ID3D10Device.PSSetShaderResources
	D3D11_HOOKS.CopyRegion     := ID3D10Device.CopySubresourceRegion	
	
	if (parsecfg(g_.cfg.PxSwap).e or g_.cfg.HD)
	{
		if (! parsecfg(g_.cfg.PxSwap).e ) 
		{
			g_PxOvrrd           := {}
			g_PxOvrrd.PxShdrs   := new Collection()
			D3D11_HOOKS.PxShdrs := g_PxOvrrd.PxShdrs.pc
		} else PxOvrr11dInit()
		logerr(ID3D10Device.dllHook("CreatePixelShader", "CreatePixelShader10Hook", dll))
		logerr(ID3D10PixelShader.dllHook("Release", "ReleasePixelShader10Hook", dll))
		logerr(ID3D10Device.dllHook("PsSetShader", "D3D10PsSetShaderHook", dll))
	} 
	D3D11_HOOKS.PxShdrs   := g_PxOvrrd.PxShdrs.pc
	D3D11_HOOKS.PxCreate  := ID3D10Device.CreatePixelShader
	D3D11_HOOKS.PxRelease := ID3D10PixelShader.Release
	D3D11_HOOKS.PxSet     := ID3D10Device.PsSetShader
	
	if (g_.cfg.HD)
	{
		logerr(ID3D10Device.dllHook("CopyResource", "D3D10CopyResourceHook", dll))
		logerr(ID3D10Device.dllHook("ResolveSubresource", "D3D10ResolveSubresourceHook", dll))
		logerr(ID3D10Device.dllHook("OMSetRenderTargets", "D3D10OMSetRenderTargetsHook", dll)) 
		logerr(ID3D10Device.dllHook("OMGetRenderTargets", "D3D10OMGetRenderTargetsHook", dll)) 
		logerr(ID3D10Device.dllHook("ClearDepthStencilView", "D3D10ClearDepthStencilViewHook", dll)) 
		logerr(ID3D10Device.dllHook("ClearRenderTargetView", "D3D10ClearRenderTargetViewHook", dll)) 				
	}	
	D3D11_HOOKS.StTrgt     := ID3D10Device.OMSetRenderTargets
	D3D11_HOOKS.GtTrgt     := ID3D10Device.OMGetRenderTargets
	D3D11_HOOKS.Clear      := ID3D10Device.ClearDepthStencilView 
	D3D11_HOOKS.ClearRT    := ID3D10Device.ClearRenderTargetView 
	D3D11_HOOKS.StVW       := ID3D10Device.RSSetViewports
	D3D11_HOOKS.StScsr     := ID3D10Device.RSSetScissorRects
	D3D11_HOOKS.GtVW       := ID3D10Device.RSGetViewports
	D3D11_HOOKS.GtScsr     := ID3D10Device.RSGetScissorRects
	D3D11_HOOKS.Resolve	   := ID3D10Device.ResolveSubresource
	D3D11_HOOKS.Copy       := ID3D10Device.CopyResource


	;D3D11InitHDHooks(dll)
	if (g_.cfg.HD)
	{			
		g_.WnAPI.SetWindowPos := dllcall("GetProcAddress", ptr, dllcall("LoadLibraryW", astr, "User32.dll", ptr), astr, "SetWindowPos", ptr)		
	}
	flags := 0
	if (g_.cfg.MHKS)                      flags |= 0x1
	if (g_.cfg.HD)                        flags |= 0x2	
	if (parsecfg(g_.cfg.TextSwap).e)      flags |= 0x4	
	if (parsecfg(g_.cfg.PxSwap).e)        flags |= 0x8	
	if (g_.cfg.fltr || g_.cfg.TextSwap.a) flags |= 0x10	
	dllcall(dll "\D3D10Hook", ptr, IDXGISwapChain.p, ptr, IDXGISwapChain1.p, ptr, IDXGIOutput.p, ptr, ID3D10Device.p, ptr, ID3D10Device1.p
		, ptr, ID3D10Texture2D.p, ptr, ID3D10ShaderResourceView.p, ptr, ID3D10PixelShader.p, uint, flags)	
	
	D3D11_HOOKS.GetDesc  := IDXGISwapChain.GetDesc
	D3D11_HOOKS.GetDesc1 := IDXGISwapChain1.GetDesc1	
	D3D11_HOOKS.GetModes := IDXGIOutput.GetDisplayModeList
	
	if (g_.cfg.fltr || g_.cfg.TextSwap.a)
	logerr(ID3D10Device.dllHook("PSSetSamplers", "D3D10PSSetSamplersHook", dll)) 
	D3D11_HOOKS.StSmplr := ID3D10Device.PSSetSamplers
	D3D11_HOOKS.MxOvrrd := g_.cfg.FLTR
	D3D11_HOOKS.MnOvrrd := g_.cfg.FLTR		
	dllcall(dll "\D3D11SetupFinished", ptr, IDXGISwapChain.p)	
	IDXGISwapChain.GetDesc         := D3D11_HOOKS.GetDesc
	IDXGISwapChain1.GetDesc1       := D3D11_HOOKS.GetDesc1
	IDXGIOutput.GetDisplayModeList := D3D11_HOOKS.GetModes ; not initialized
}

D3D10UpdateHook(Intrfc, Mthd, Trmpln)
{
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	if !instr(Intrfc.dllHook(Mthd, "D3D10" Mthd "Hook", dll), "FAILED")
	D3D11_HOOKS[Trmpln] := Intrfc[Mthd]
}

D3D10ResetPreentCallback(Callback)
{
	if (D3D11_HOOKS._present) 
	dllcall("GlobalFree", ptr, D3D11_HOOKS._present)	
	D3D11_HOOKS._present := RegisterCallback(Callback, "F")
}

CreateSwapChain10(p1, p2, p3, p4)
{
	p3 := D3D11SetUPSwapChain(p3, "IDXGIFactory::CreateSwapChain")	
	r  := dllcall(IDXGIFactory.CreateSwapChain, ptr, p1, ptr, p2, ptr, p3, ptr, p4)
	if (r)
		return r	
	D3D11GetSwapChainDsc(numget(p4+0, "ptr"))
	if (DXGI_SWAP_CHAIN_DESC.OutputWindow && g_.cfg.HD)
		dllcall("SendMessage", ptr, DXGI_SWAP_CHAIN_DESC.OutputWindow, uint, 0x5, ptr, 0, ptr, D3D11_HOOKS.W|(D3D11_HOOKS.H<<16)) 	
			
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	dllcall(dll "\D3D10CreateShaders", ptr, numget(p4+0, "ptr"))	
	return r
}
