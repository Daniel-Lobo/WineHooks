#persistent
#NoEnv  
SendMode Input  
SetWorkingDir %A_AhkPath% 
#include lib\Shell.ahk
#include lib\_filesystem.ahk
#include lib\memlib.ahk
#include Injector_common.ahk
#include lib\ini.ahk
#include lib\Syslinks.ahk
SetBatchLines, -1

;unAsAdmin()
if not A_iscompiled 
{
	;splitpath, A_ahkpath, ,dir
	;run %dir%\Compiler\Ahk2Exe.exe /in Injector64.ahk /out Injector64.exe /bin "%dir%\Compiler\Unicode 64-bit.bin"
}

;OnMessage(0x4a, "Receive_WM_COPYDATA") 
OnMessage(0x4a, "ProcNameMessage")
OnMessage(dllcall("RegisterWindowMessageW", str, "Peixoto.Hwnd"), "ProcHwndMessage")
global g_ := parseCommandLine()
launchTarget64()

launchTarget64()
{
	print("`r")    
    if IsParent32Bit(){
        return
    }
	g_ahkpath     := FileExist(A_workingdir "\AutoHotkey64.dll") ? A_workingdir "\AutoHotkey64.dll" : A_mydocuments "\Autohotkey\dlls\AutoHotkey64.dll"
	g_peixotopath := FileExist(A_workingdir "\peixoto64.dll") ? A_workingdir "\peixoto64.dll" : A_mydocuments "\Autohotkey\dlls\peixoto64.dll"	
	g_ahkpath     := A_workingdir "\AutoHotkey64.dll"
	g_peixotopath := A_workingdir "\peixoto64.dll"
		
	target := g_.target
	splitpath, target, name
	process, close, % name
	process, exist, %name%	
	fileexist(g_.target) ?: quit(name " not found in`n`n" g_.target_dir)	
	errorlevel ? quit(name ".exe already running")
		
	dllcall("LoadLibraryW", str, g_ahkpath) ?: Quit("Unable to find or load`n" g_ahkpath "-" A_lasterror)
	dllcall("LoadLibraryW", str, g_peixotopath) ?: Quit("Unable to find or load`n" g_peixotopath "-" A_lasterror)		
	
	Setup()
	/*
	if instr(g_.svs, "links")
	links := new Syslinks(g_.target_dir, A_mydocuments "\games\" g_.path "\saves")
    else if (g_.svs = "fldrs" and FileExist(g_.target_dir "\codex64.dll"))
    {
        p := A_mydocuments "\games\" g_.path "\saves\"
        EnvSet, PUBLIC, %p% 
    }     
	else if (g_.svs = "CODEX") ;Codepath never takes as function ParseCommandLine changes g_.svs = "CODEX" to g_.svs = "fldrs" 
	links := new Syslinks(GetCommonPath( "COMMON_DOCUMENTS" ) "\Steam\CODEX", A_mydocuments "\games\" g_.path "\saves")
	;cdx     := new codex()	
	*/	
	;if (g_.d3d = 10 or g_.d3d = 11)	
	;dllcall("SetDllDirectoryA", astr, g_.injector_dir "\dxvk\" g_.dxvkv "\x64")
	g_.proc := CreateIdleProcess(g_.target, g_.target_dir, g_.args)		
			
	SetupProc() 	
	;GetRemoteScript64()
	Inject(g_peixotopath, g_ahkpath)
		
	id := g_.proc.Process_id
	process, waitclose, %id%
	
	exitapp	
}

IsParent32Bit(){
    cmd := dllcall("GetCommandLine", str)    
    if instr(cmd, "-32bitparent")
    {        
        trgt := StrSplit(cmd, "-32bitparent ")[2]
        trgt := StrReplace(trgt, """", "") ;
        splitpath, trgt, name, dir 
        g_.target       := trgt
        g_.target_dir   := dir
        g_.target_name  := name	
        g_.cmdstring    := StrReplace(g_.cmdstring, "-target^" old, "-target^" g_.target)
        g_.cmdstring    := StrReplace(g_.cmdstring, "-target_dir^" old_dir, "-target_dir^" g_.target_dir)
        g_.cmdstring    := StrReplace(g_.cmdstring, "-target_name^" old_name, "-target_name^" g_.target_name)
        print("Recived " trgt "`n")	
        Setup()
        return True
    }    
}

Inject(pex, ahk)
{
	for k, v in	[pex, ahk] {	
		dllcallEx(g_.proc.hProcess, "Kernel32.dll", "LoadLibraryW", v) 		
	}	
	GetRemoteScript64()
	FileDelete, last
	fileappend, % g_.remoteScript, last
	success := dllcallEx(g_.proc.hProcess, "autohotkey64.dll", "ahkdll", A_workingdir "\last")			
	if (success = 2)
	{
		quit("Could not allocate memory for dll injection: " A_lasterror)
	}
	else if (success = 3)
		quit("Could not write to memory allocated for dll injection")
	else if (success = 4)
		quit("Could not create remote thread for dll injection")		
}
	
Setup()
{
	compat := g_.compatLayer 
	if compat
		EnvSet, __COMPAT_LAYER, %compat%	
	
	if (g_.svs = "ENV")
	{
		p := A_mydocuments "\games\" g_.path "\saves\"
		;EnvSet, LOCALAPPDATA, %p% ;Unravel			
	}
}

SetupProc()
{
	(g_.singlecore) & True ? dllcall("SetProcessAffinityMask", uint, g_.proc.hProcess, uint, 0x00000008) 
	? : dllcall("SetProcessAffinityMask", uint, g_.proc.hProcess, uint, 0x00000002) 
}	

GetRemoteScript64()
{
	g_.remoteScript := "" ;Amid Evil
	if g_.console 
		g_.remoteScript := "#warn all, OutputDebug`n"
	g_.remoteScript := "global g_MainThreadID := " g_.proc.Thread_id " `;<Tag> `n" g_.remoteScript 
	g_.remoteScript .= "global g_cmdstring := """ g_.cmdstring """`n"
	g_.remoteScript .= LoadResource("remote_lib.txt")
	g_.remoteScript .= "`n" LoadResource("CreateProcessHooks.txt")
	if (g_.D3D = 11)
		g_.remoteScript .= "`n" LoadResource("D3D11.hooks.txt") "`n" LoadResource("HLSLGen.txt")
	if (g_.D3D = 12)
		g_.remoteScript .= "`n" LoadResource("D3D12.hooks.txt") "`n" 
	else if (g_.D3D = "gl")
		g_.remoteScript .= "`n" LoadResource("gl.hooks.txt")
	if g_.Script
	{
		g_.ex_script := LoadResource("exlib.txt") "`n"
	    script_file  := A_mydocuments "\WineHooks\" g_.Script
		if fileexist(script_file) {
			fileread, script, %script_file%
			script := strsplit(script, ";REMOTE SCRIPT START")
			g_.remoteScript .= "`n" script[2] "`n"
			g_.ex_script .= "`n" script[1]
		} else {
			script := strsplit(script_file, "|")
			g_.remoteScript .= "`n" script[2] "`n"
			g_.ex_script .= "`n" script[1]
		}		
	}	
		
	;if not g_.console and not g_.dev
		;g_.remoteScript .= "`nprintl()"	
	g_.remoteScript := g_.remoteScript . "`nresume()"	    
}	

ProcNameMessage(w, l)
{
	old      := g_.target
	old_name := g_.target_name
	old_dir  := g_.target_dir 
	trgt := StrGet(numget(l+A_PtrSize*2, "int"), numget(l+A_PtrSize, "int"), "UTF-16")
	trgt := StrReplace(trgt, """", "") ;Amid Evil
	splitpath, trgt, name, dir 
	g_.target       := trgt
	g_.target_dir   := dir
	g_.target_name  := name	
	g_.cmdstring    := StrReplace(g_.cmdstring, "-target^" old, "-target^" g_.target)
	g_.cmdstring    := StrReplace(g_.cmdstring, "-target_dir^" old_dir, "-target_dir^" g_.target_dir)
	g_.cmdstring    := StrReplace(g_.cmdstring, "-target_name^" old_name, "-target_name^" g_.target_name)
	print("Recived " StrGet(numget(l+A_PtrSize*2, "int"), numget(l+A_PtrSize, "int"), "UTF-16") "`n")	
	Setup()
	return
}

ProcHwndMessage(w, l)
{    
	print("ProcHwndMessage recived " w " " l "`n")
	g_.proc := {}
	g_.proc.hProcess   := w
	g_.proc.hProcess   := dllcall("OpenProcess", uint, 0x30|0x02|0x08|0x00100000|0x0200, uint, 0, uint, l, ptr) ;get_process_handle(g_.target_name)
	g_.proc.Thread_id  := w
	g_.proc.Process_id := l
	SetupProc()
	dlls := "\Autohotkey\dlls\"
	_ahk := FileExist(A_workingdir "\AutoHotkey64.dll") ? A_workingdir "\AutoHotkey64.dll" : A_mydocuments dlls "AutoHotkey64.dll"
	_pex := FileExist(A_workingdir "\peixoto64.dll") ? A_workingdir "\peixoto64.dll" : A_mydocuments dlls "peixoto64.dll"	
	_ahk := A_workingdir "\AutoHotkey64.dll" 
	_pex := A_workingdir "\peixoto64.dll" 
	Inject(_pex, _ahk)
	return
}

LoadResource(resource, module = "Injector.exe")
{
	return fileopen("src\" resource, "r").read()
	if ! module
		hModule := dllcall("GetModuleHandle", uint,  0, ptr)
	else FreeLater := hModule := dllcall("LoadLibraryExW", str, A_scriptdir "\Injector.exe", uint, 0, uint, (LOAD_LIBRARY_AS_DATAFILE := 0x00000002), ptr)
	HRSRC := dllcall("FindResourceW", ptr, hModule, str, resource, ptr, 10)
	hResource := dllcall("LoadResource", ptr, hModule, uint, HRSRC)
	DataSize := DllCall("SizeofResource", ptr, hModule, ptr, HRSRC, uint)
	pResData := dllcall("LockResource", ptr, hResource, ptr)
	ret := strget(pResData, DataSize, "UTF-8")
	FreeLater ? dllcall("FreeLibrary", uint, hModule)
	return ret
}