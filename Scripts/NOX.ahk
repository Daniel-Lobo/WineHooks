;REMOTE SCRIPT START
;logerr("GetDeviceCaps Hook:" InstallHook(isfunc(a:="AltGetDeviceCaps9") ? a:"GetDeviceCaps9", p, "Gdi32.dll", "GetDeviceCaps") " <- 0 means no error")

AltGetDeviceCaps9(p1, p2)
{
	if      (p2 = 8)
	return strsplit(["640x480", "800x600", "1024x768", "960x540", "1280x720", "1366x768", "1920x1080"][g_.cfg.RLMT], "x" )[1]
	else if	(p2 = 10)
	return 480	
	return strsplit(["640x480", "800x600", "1024x768", "960x540", "1280x720", "1366x768", "1920x1080"][g_.cfg.RLMT], "x" )[2]
}
