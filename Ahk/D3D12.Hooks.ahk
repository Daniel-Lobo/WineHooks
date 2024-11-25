/*
InitD3D12("peixoto64.dll")
InitD3D12(dll)
{
	for k ,v in strsplit(g_.cfg.HD, "|")
		dllcall(dll "\D3D12Config", astr, v, uint, 1) ; 2 for full precision FSR 
	(g_.cfg.WHKS)   ? dllcall(dll "\D3D12Config", astr, "FIXWINSIZE", ptr, 1)
	(g_.cfg.MHKS)   ? dllcall(dll "\D3D12Config", astr, "MOUSEHOOKS", ptr, 1)
	if (g_.cfg.RLMT)
	{
		g_.cfg.RLMT := strsplit(["640x480", "800x600", "1024x768", "960x540", "1280x720", "1366x768", "1600x900", "1920x1080", "2560x1440", "3840x2160"][g_.cfg.RLMT], "x" )
		logerr("RESLMT " g_.cfg.RLMT[1] "x" g_.cfg.RLMT[2])
		dllcall(dll "\D3D12Config", astr, "RESLMT", "ptr", (g_.cfg.RLMT[1]<<16)|g_.cfg.RLMT[2])	
	}	
	dllcall(dll "\D3D12Init")
}
*/