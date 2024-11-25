global g_tswap_l = {}
LayerInitTextSwap(byref cfg, byref mnger_cfg)
{
    D3DHOOKS_DATA.LooseSurface := RegisterCallback("LooseSurface", "F")
	g_tswap_l                  := parsecfg(cfg)
	g_tswap_l.e                := (cfg) ? True : False
	if not g_tswap_l.path
	return
	g_tswap_l.path := g_.cfg.path g_tswap_l.path
    if (g_.cfg.common_path)
    g_tswap_l.path := g_.cfg.Mydocs "\WineHooks\Games\Textures" 
	for k, v in ["Dumps", "Replacements"] 
	{
		if not fileexist(g_tswap_l.path "\" v) 
		{
			path := g_tswap_l.path
			FileCreateDir, %path%\%v%
		}
	}	
    (g_tswap_l.dly)   ? dllcall("peixoto.dll\D3D12Config", astr, "DELAYRELEASE", uint, 1)
	(g_.cfg.TextSwap) ? dllcall("peixoto.dll\D3D12Config", astr, "TEXTSWAP", uint, 1) 
	(g_.cfg.mngr)     ? dllcall("peixoto.dll\D3D12Config", astr, "TEXTSWAP.MANAGE", uint, 1) 
	dllcall("peixoto.dll\D3D12Config", astr, "TEXT-SWAP.TOGGLE-SEARCH", uint, GetKeyVK(g_tswap_l.sw)) 
	dllcall("peixoto.dll\D3D12Config", astr, "TEXT-SWAP.NEXT",  uint, GetKeyVK(g_tswap_l.n)) 
	dllcall("peixoto.dll\D3D12Config", astr, "TEXT-SWAP.PREV",  uint, GetKeyVK(g_tswap_l.p)) 
	dllcall("peixoto.dll\D3D12Config", astr, "TEXT-SWAP.QUICK", uint, GetKeyVK(g_tswap_l.q)) 
	dllcall("peixoto.dll\D3D12Config", astr, "TEXT-SWAP.DUMP",  uint, GetKeyVK(g_tswap_l.d)) 
	dllcall("peixoto.dll\D3D12Config", astr, "TEXT-SWAP.A8FIX",  uint, GetKeyVK(g_tswap_l.A8Fix)) 
	dllcall("peixoto.dll\D3D12Config", astr, "TEXT-SWAP.AUTO",  uint, GetKeyVK(g_tswap_l.a)) 

	dllcall("peixoto.dll\SetSampleCount", uint, g_tswap_l.s)
	dllcall("peixoto.dll\SetTexturePaths", str, g_tswap_l.path "/dumps/", astr, g_.cfg.MyDocs "\WineHooks\checkerboard.dds")
	if fileexist((comp := g_tswap_l.path "\Dumps\dump._dds"))
		LoadCompiledDumpCollection(comp, lst := [])
	else LoadDumpCollection(g_tswap_l.path "\Dumps", lst := [])

    cfg             := ""	
    mnger_cfg       := ""
    g_.cfg.TextSwap := ""
    g_.cfg.mngr     := ""
}


TSwapBrowseSurfaces()
{
	if (!g_tswap_l.e){
		return
	} 
	return dllcall("peixoto.dll\DDrawBrowseTextures", ptr, g_.rtrgt, wstr) 
}