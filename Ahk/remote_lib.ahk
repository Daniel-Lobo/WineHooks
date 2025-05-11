#NoEnv 
#persistent  
#notrayicon  
#KeyHistory 0
#MaxThreads 1
critical, 0xFFFFFFFF
ListLines, Off
SetBatchLines, -1

#include lib\ahkhook.ahk
#include lib\lib.ahk
#include lib\FileHooks.ahk

global g_                    := ParseCfg()
g_cmdstring                  := ""
g_.h_PeixotoDll              := dllcall("GetModuleHandleW", str, (A_ptrsize = 4) ? "peixoto.dll" : "peixoto64.dll", ptr)
g_.p                         := {}
g_.p.Scale                   := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "Scale", uint)
g_.p.Critical                := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "Critical")
g_.p.GetDDSFilePxFmt         := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GetDDSFileFormat", ptr)
g_.p.LoadSurfData            := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "LoadData2Surface", uint)
g_.p.GetTicks                := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "TimeGetTimeF", uint)
ComInterfaceWrapper.sethooks := dllcall("GetProcAddress", "ptr", g_.h_PeixotoDll, "astr", "sethook", ptr)		
ComInterfaceWrapper._unhook  := dllcall("GetProcAddress", "ptr", g_.h_PeixotoDll, "astr", "unhook", ptr)	

;g_.p_Critical   := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "Critical")
g_.s := {}

InitGlobals()
InitGlobals()
{
	if ! g_.cfg.path
	{
		path := g_.cfg.target 
		splitpath, path, , , ,name
		g_.cfg.path := g_.cfg.MyDocs "\WineHooks\Games\" name "\"
	} else 	g_.cfg.path :=  g_.cfg.MyDocs "\WineHooks\Games\" g_.cfg.path "\"
	if !fileexist((mds := g_.cfg.path "mods"))	
	FileCreateDir, % mds

	cfg := "Peixotos's patch remote settings:`nCommand Line: " dllcall("GetCommandLineA", astr) "`n"
	for kk, vv in g_.cfg
		cfg .= kk ": " vv "`n"
	;FileAppend, , % g_.cfg.error_log
	;g_.cfg.error_log := StrReplace(g_.cfg.error_log, "error.log", "d3d_hooks.log")
	if g_.cfg.console
	logErr(g_.cfg.error_log "|100")
	else 
	logErr(g_.cfg.error_log "|100")	
	logerr(cfg)
	logerr("Working directory: " A_workingdir)
	
	InitFileHooks(g_.cfg)
	
	if (g_.cfg.HRT)
	{
		logerr("TimeGetTime Hook " AltInstallHook(dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "TimeGetTimeHook") 
		, dllcall("GetProcAddress", ptr, dllcall("LoadLibrary", str, "Winmm.dll"), astr, "timeGetTime")))
		logerr("GetTckCount Hook " AltInstallHook(dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "TimeGetTimeHook") 
		, dllcall("GetProcAddress", ptr, dllcall("LoadLibrary", str, "Kernel32.dll"), astr, "GetTickCount")))
		g_.cfg.HRT := ""		
	}
	if (g_.cfg.QPCFix)
		dllcall("peixoto.dll\HookQueryPerformanceCounter")
	g_.cfg.QPCFix := ""		
	
	if (g_.cfg.iso)
	new VirtualDisk().Mount("E:\Users\dllob\Downloads\Game ISOS\" trim(g_.cfg.iso), "D")

	/*
	if (g_.cfg.GMEM)
		logerr("GlobalMemoryStatus Hook " InstallHook("GlobalMemHook", p, "Kernel32.dll", "GlobalMemoryStatus"))
	g_.p.GlobalMem := p	
	logerr("sleep Hook " InstallHook("sleephook", p, "Kernel32.dll", "UnhandledExceptionFilter"))
	logerr("SdbGetMatchingExe Hook:" InstallHook("SdbGetMatchingExe", pSdbGetMatchingExe, "apphelp.dll", "SdbGetMatchingExe") " <- 0 means no error")
	if (g_.cfg.32bit)
	{
		logerr("DWM8And16Bit_IsShimApplied_CallOut Hook: " 
		. InstallHook("DWMShimCallOut", p, "apphelp.dll", "DWM8And16Bit_IsShimApplied_CallOut"))
		g_.DWMShimCallOut := p
		g_.cfg.DWMShimOff := ""
	}
	*/
}

sleephook(p1){
	return
	}

GlobalMemHook(p1)
{
	dllcall(g_.p.GlobalMem, uint, p1)
	m   := struct("DWORD Length; DWORD Load; SIZE_T TotalPhys; SIZE_T AvailPhys; SIZE_T TotalPage; SIZE_T AvailPage; SIZE_T TotalVirt; SIZE_T AvailVirt;")
	m[] := p1
	mg  := 1024*1024
	logerr("&&&&&&&&&&&&&&&&&&&& " m.AvailPage)
	if (m.AvailPage >= 0x7fffffff)
		m.AvailPage := 256*mg
}

SdbGetMatchingExe()
{
	return
}

DWMShimCallOut()
{
	logerr("DWMShimCallOut " dllcall(g_.DWMShimCallOut))
	return 0
}

wait()
{
	static l = 0		
	n := dllcall(g_.p.GetTicks, double)	
	while ( n - l < g_.cfg.LMT )
		n := dllcall(g_.p.GetTicks, double)	
	l := n
}

Class VirtualDisk
{	
	Mount(path, drv)
	{
		dllcall("Kernel32.dll\DeleteVolumeMountPointW", str, drv ":\")
		vol := this.EnumVolumes()
		dllcall("peixoto.dll\MountISO", str, path)
		for k, v in this.EnumVolumes()
		{
			if ! vol[k]
			{
				FileAppend, % "Mounted " k "`n", *
				if (dllcall("Kernel32.dll\SetVolumeMountPointW", str, drv ":\", str, k) = 0) 
				return A_Lasterror
			}
		}			
	}	
	EnumVolumes()
	{		
		VarSetCapacity(VolName, 1024)	
		Volumes  := []
		hFVol    := dllcall("Kernel32.dll\FindFirstVolumeW", str, VolName, uint, 1024)
		if (hFVol = -1)
		{
			FileAppend, % "FindFirstVolumeW Failed`n", *
		} 		
		Volumes[VolName] := True
		
		success := 1
		while (success)
		{
			success          := dllcall("Kernel32.dll\FindNextVolumeW", ptr, hFVol, str, VolName, uint, 1024)
			Volumes[VolName] := True
		}
		
		for k, v in Volumes
		{
			dllcall("GetVolumePathNameW", str, v, str, VolName, uint, 1024)
			FileAppend, % v " " k " " VolName "`n", *
		}
		return Volumes
	}	
}


