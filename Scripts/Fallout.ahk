;REMOTE SCRIPT START

/*
FalloutEditIni()
FalloutEditIni()
{
	
	ini := fileexist(f := "f1_res.ini") ? f : "f2_res.ini"
	if fileexist(ini) 
	{
		d3d  := g_.cfg.d3d
		mode := d3d=9 ? 2 : d3d=7 ? 1 : 0
		IniWrite, %mode%, %ini%, MAIN, GRAPHICS_MODE 
		IniWrite, 0, %ini%, MAIN, UAC_AWARE 		
	}
}
*/

if (g_.cfg.d3d = 7)
logerr("DirectDrawCreate Hook  : " InstallHook("FalloutDDrawCreate", p, "ddraw.dll", "DirectDrawCreate"))

FalloutDDrawCreate(p1, p2, p3)
{
	GUID_FromString(iid, ddraw.IID_IDirectDraw7)
	; Its safe to return the IDirectDraw7 surface since the game won't do anything with it except query a IDirectDraw7 surface
	return dllcall(Registercallback("DDCreateEx_hook", "F"), ptr, p1, ptr, p2, ptr, &iid, ptr, p3)
}


