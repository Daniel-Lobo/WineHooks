;REMOTE SCRIPT START
InitKega()
InitKega()
{
	cfg := fileopen("Fusion.ini", "r").read()	
	sec := "[Kega] `;Dummy section"	
	if (!instr(cfg, sec))
	{
		FileDelete, Fusion.ini
		FileAppend, % sec "`n" cfg, Fusion.ini
	}
	if (g_.cfg.svs)
	{		
		p := g_.cfg.path
		FileCreateDir, %p%saves\states		
		iniwrite, %p%saves, Fusion.ini, Kega, SxMFiles
		iniwrite, %p%saves\states, Fusion.ini, Kega, SMSStateFiles  		
		iniwrite, %p%saves, Fusion.ini, Kega, SRMFiles  
		iniwrite, %p%saves\states, Fusion.ini, Kega, StateFiles  
		iniwrite, %p%saves\states, Fusion.ini, Kega, SCDStateFiles 
	}
	D3DHOOKS_DATA.BltPrimary := RegisterCallback("KegaBlt", "F")
	g_.s.Use_xBRz := True
}

Alt_CreateDevice(p1, p2, p3, p4)
{	
	g_.proxies.prms[1] := 1/512
	g_.proxies.prms[2] := 1/512
	D3DDDI_SetShaderOverride(g_.proxies.xbr)
	dllcall(G_D3DDDI.SetPixelShaderConst, uint, D3DDDI_HOOKS.hDev, "uint64*", 223 | 1<<32, uint, g_.proxies.prms[])		
	return IDirect3D7_CreateDevice(p1, p2, p3, p4)
}

KegaReset()
{
	keyevent("Q") ? g_.s.Use_xBRz := (g_.s.Use_xBRz) ? False : True
	if (g_.s.Use_xBRz )
		D3DDDI_SetShaderOverride(g_.proxies.xbr)
	else 
		D3DDDI_RestoreShader()
}

Alt_flip(p1, p2, p3)
{
	KegaReset()
	return IDirectDrawSurface7_flip(p1, p2, p3)
}

KegaBlt(p1, p2, p3, p4, p5, p6)
{
	D3DDDI_RestoreShader()
	if (g_.fllscrn)
	return Surface1Blt(p1, p2, p3, p4, p5, p6)
	D3DHOOKS_DATA.scale    := 1
	D3DHOOKS_DATA.HD_X     := 0	
	return dllcall(IDirectDrawSurface.blt, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint)
}