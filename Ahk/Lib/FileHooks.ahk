global g_fhks := {}

global CSIDL_FLAG_CREATE    := 0x8000
global CSIDL_COMMON_APPDATA := 35
global CSIDL_LOCAL_APPDATA  := 28
global CSIDL_APPDATA        := 26
global CSIDL_PERSONAL       := 5
global CSIDL_WINDOWS     := 36
global CSIDL_SYSTEM	     := 37
global CSIDL_SYSTEMX86	 := 41

InitFileHooks(byref cfg)
{
	flags       := 0
	g_fhks.docs := g_.cfg.path
	path        := g_fhks.docs
	FileCreateDir, %path%\Saves
	FileCreateDir, %path%\mods
	FileCreateDir, %path%\cfg
	  
	g_fhks.files     := new Collection()
	f := HasFiles(path "cfg")
		
	if isfunc("AltCreateFileA")
	{
		if (g_.cfg.mods)
			 logerr("CreateFileA_Hook : " InstallHook("AltCreateFileA", pCreateFileA, "peixoto.dll", "CreateFileA_Hook") " <- 0 means no error")
		else logerr("CreateFileA_Hook : " InstallHook("AltCreateFileA", pCreateFileA, "Kernel32.dll", "CreateFileA") " <- 0 means no error")
		g_fhks.pCreateFileA := pCreateFileA	
	}
	if isfunc("AltCreateFileW")
	{
		if (g_.cfg.mods or f)
			 logerr("CreateFileW_Hook : " InstallHook("AltCreateFileW", pCreateFileW, "peixoto.dll", "CreateFileW_Hook") " <- 0 means no error")
		else logerr("CreateFileW_Hook : " InstallHook("AltCreateFileW", pCreateFileW, "Kernel32.dll", "CreateFileW") " <- 0 means no error")
		g_fhks.pCreateFileW := pCreateFileW	
	}
	/* ;Disable file redirection: deprecated
	if (instr(g_.cfg.svs, "FLDRS") || (instr(g_.cfg.svs, "links") && fileexist("codex*.dll")))
	{
		flags |= 0x01			
	}		
	if (instr(g_.cfg.svs, "links_cpp"))
	flags  |= 0x100
	*/	
	f := HasFiles(path "cfg")
	if (g_.cfg.mods or f)
	{
		flags        |= 0x10
		g_fhks.paths := []
		for k, v in strsplit(g_.cfg.mods, ";")
			g_fhks.paths.insert(g_.cfg.path "mods\" v)	
		if (f) 
			g_fhks.paths.insert(g_.cfg.path "cfg")	
		Buildfileslist()
	}
	path := StrReplace(path "\Saves\", "\\", "\")
	pex  := A_PtrSize=8 ? "peixoto64.dll\" : "peixoto.dll\"
	dllcall(pex "InitFileHooks", str, path, astr, path, ptr, g_fhks.files.pc, ptr, 0, uint, flags)	
    return
    for k, v in g_fhks.filesList
    {
        logerr(k " " v)
        dllcall(pex "FileHooksInsertFile", wstr, k, wstr, v)
        logerr(errorlevel)
    }
}

HasFiles(dir)
{
	logerr(dir "Files: " )
	loop, %dir%\*.*, 0, 0
	{
		logerr(A_loopfilefullpath)
		FileGetAttrib, att, %A_loopfilefullpath%
		if not instr(att, "D"){
			logerr("HasFiles 1")
		    return 1
		}
	}
	logerr("HasFiles 0")
}

InitSteamFileHooks()
{
	name    := "INIT_STEAM_FILE_HOOKS: "
	hSteam  := dllcall("GetModuleHandleA", astr, A_PtrSize=4 ? "steamclient.dll" : "steamclient64.dll", ptr)
	if (!hSteam)
	return logerr(name "no handle " errorlevel)
	pFunc   := dllcall("GetProcAddress", ptr, hSteam, astr, "CreateInterface", ptr)	
	if (!pFunc)
	return logerr(name "no adress " errorlevel)		
	
	pIntrfc := DllCall(pFunc, astr, "SteamUser018", "int*", r:=0, ptr)
	if (!pIntrfc)
	return logerr(name "no pointer " errorlevel)	
	pTable  := numget(pIntrfc+0, "ptr")
	pGtFldr := numget(pTable+A_ptrsize*6, "ptr")	
	VarSetCapacity(path, 260)
	logerr(name dllcall(pGtFldr, ptr, pIntrfc, ptr, &path, int, 260) " " errorlevel)
	logerr(name strget(&path+0, "CP0"))	
	h := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "ISteamUser_GetUserDataFolder_Hook", ptr)	
	logerr(name AltInstallHook(h, pGtFldr))	
	logerr(name "OK")	
}

IsSteamCloudnabled(steam)
{
	logerr("IsSteamCloudnabled ==========================================")
	return 0
}

OpenFile(p1, p2, p3)
{
	file := strget(p1, "CP0")	
	printl("open " file)
	stringreplace, file, file, /, \, 1	
	Splitpath, file, filename, filedir, ext
							
	g_fhks.filesList[filename] ? file := g_fhks.filesList[filename] 
	r := dllcall(g_fhks.pOpenFile , astr, file, uint, p2, uint, p3)
	return r
}	

BuildDirFlslst(dir, byref collec)	
{
	logerr("isobject " isobject(collec))
	loop, %dir%\*.*, 1, 0
	{
		if (instr(FileExist(A_LoopFileFullPath), "D"))
		{
			name  := A_loopfilename
			g_fhks.fldrs.lst[A_loopfilename] := new Collection()
			pK := dllcall("VirtualAlloc", ptr, 0, ptr, (strlen(name)+1)*2, uint, 0x00003000, uint, 0x04, ptr)
			strput(name, pK, "UTF-16")
			g_fhks.fldrs._add(pK, g_fhks.fldrs.lst[A_loopfilename].pc)
			BuildDirFlslst(A_LoopFileFullPath, g_fhks.fldrs.lst[A_loopfilename])	
		} else 
		{	
			;StringLower, name, A_loopfilename
			name  := A_loopfilename
			logerr("Found file" A_LoopFileFullPath)
			pK := dllcall("VirtualAlloc", ptr, 0, ptr, (strlen(name)+1)*2, uint, 0x00003000, uint, 0x04, ptr)
			strput(name, pK, "UTF-16")
			strput(A_loopfilefullpath, collec._Insert(pK, (strlen(A_loopfilefullpath)+1)*2, "UTF-16"))
		}			
	}
	logerr("Collection size " collec.Count())
}

Buildfileslist()
{
	folders          := g_fhks.paths 
	g_fhks.filesList := {}
	for k, v in folders
	{
		loop, %v%\*.*, 0, 1
		{
			StringLower, name, A_loopfilename
			;name  := A_loopfilename
			if (name = "error.log")
				continue
			pK := dllcall("VirtualAlloc", ptr, 0, ptr, (strlen(name)+1)*2, uint, 0x00003000, uint, 0x04, ptr)
			strput(name, pK, "UTF-16")
			strput(A_loopfilefullpath, g_fhks.files._Insert(pK, (strlen(A_loopfilefullpath)+1)*2, "UTF-16"))
			g_fhks.filesList[name] := A_loopfilefullpath	
		}			
	}
	err := g_.cfg.error_log
	splitpath, err, errofile
	g_fhks.filesList.remove(errofile)	
}