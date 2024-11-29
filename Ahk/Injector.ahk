#persistent
#NoEnv  
;#NoTrayIcon
SendMode Input  
SetWorkingDir %A_AhkPath% 
#include lib\Shell.ahk
#include lib\_filesystem.ahk
#include lib\memlib.ahk
#include Injector_common.ahk
#include lib\Directx\dsound.ahk
#include lib\_Struct.ahk
#include lib\ini.ahk
#include lib\GUID.ahk
#include lib\Syslinks.ahk
;#warn all, OutputDebug
SetBatchLines, -1

regwrite, REG_SZ, HKCU, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_scriptFullPath%, HIGHDPIAWARE
RunAsAdmin()

if (tool := GetCommandLineValueB("-tool:"))
{
	script := LoadResource("remote_lib.txt") "`n"
	script .= LoadResource("HelpEx.txt", "Help.exe") "`n"
	for k, v in GetScriptParamsAsList()
	{
		if instr(v, ".txt")
		{
			stringreplace, vv, v, /, ,
			script .= "`n" LoadResource(vv) 			
		}	
	}	
	fileread, s, Tools\%tool%.ahk	
	script .= "`n" s 
		
	dlls       := "\Autohotkey\dlls\"
	_pex       := FileExist(A_scriptdir "\peixoto.dll") ? A_scriptdir "\peixoto.dll" : A_mydocuments dlls "peixoto.dll"	
	dllcall("LoadLibraryW", str, _pex)
	_ahk       := FileExist(A_scriptdir "\AutoHotkey.dll") ? A_scriptdir "\AutoHotkey.dll" : A_mydocuments dlls "AutoHotkey.dll"
	ahktextdll := dllcall("GetProcAddress", uint, dllcall("LoadLibraryW", str, _ahk), astr, "ahktextdll")
	hThread    := dllcall(ahktextdll, Str, "#NoTrayIcon`n" script, Str, "", Str, "", "Cdecl UPTR")
	dllcall("WaitForSingleObject", "ptr", hThread, "uint", 0xffffffff)
	exitapp
}

if instr(dllcall("GetCommandLine", str), "/wait")
{
	global g_, g_hhookex, g_games := {}
	loop, scripts\*.ini
	{
		g := new ini(A_LoopFileFullPath).read("target")
		print(A_LoopFileFullPath " " g "`n")
		g_games[g] := A_LoopFileFullPath
	}
	loop, user\*.ini
	{
		g := new ini(A_LoopFileFullPath).read("target")
		print(A_LoopFileFullPath " " g "`n")
		g_games[g] := A_LoopFileFullPath
	}
	OnMessage(dllcall("RegisterWindowMessageW", str, "Peixoto.FindTarget"), "FindTarget")
	_pex      := FileExist(A_scriptdir "\peixoto.dll") ? A_scriptdir "\peixoto.dll" : A_mydocuments "\Autohotkey\dlls\peixoto.dll"
	hPex      := dllcall("LoadLibraryW", str, _pex)
	hProc     := dllcall("GetProcAddress", uint, hPex, astr, "CBTProc")
	g_hhookex := dllcall("SetWindowsHookExA", uint, 5, uint, hProc, uint, hPex, uint, 0)
	gui, add, text, ,Waiting
	gui, show
	return
}

FindTarget(w, l, m, h)
{
	VarSetCapacity(n, 520)
	hP   := dllcall("OpenProcess", uint, 0x0400, uint, 1, uint, w)
	r    := dllcall("psapi.dll\GetModuleFileNameExA", uint, hP, uint, 0, uint, &n, uint, 520)
	name := strget(&n, "UTF-8")
	if (file := g_games[name])
	{
		g_   := ParseCommandLine(file)
		dlls := "\Autohotkey\dlls\"
		_ahk := FileExist(A_scriptdir "\AutoHotkey.dll") ? A_scriptdir "\AutoHotkey.dll" : A_mydocuments dlls "AutoHotkey.dll"
		g_.proc := {"hProcess" : get_process_handle(g_.target_name)}
		dllcallEx(g_.proc.hProcess, "Kernel32.dll", "LoadLibraryW", _ahk)		
	
		GetRemoteScript()	
		FileDelete, last
		fileappend, % g_.remoteScript, last
		print("Attached to " strget(&n, "UTF-8") "`n")
		return g_hhookex		
	}
	print("Attached to " strget(&n, "UTF-8") " " success "`n")
	return
}

if not dllcall("LoadLibraryW", str, "d3dx9_43.dll")
	msgbox, 16, ,Failed to load D3Dx9_43.dll, some features will not work, make sure DirectX is up to date

OnMessage(0x4a, "ProcNameMessage")
OnMessage(dllcall("RegisterWindowMessageW", str, "Peixoto.Hwnd"), "ProcHwndMessage")
OnMessage(dllcall("RegisterWindowMessageW", str, "Peixoto.MCI"), "MCI")
OnMessage(dllcall("RegisterWindowMessageW", str, "Peixoto.Thread"), "StartDll")
OnMessage(dllcall("RegisterWindowMessageW", str, "Peixoto.Inject"), "InjectMsg")
;runwait, Sdbinst.exe -q "%A_Workingdir%\Peixoto.sdb"
global g_ := ParseCommandLine()
CheckTarget()
launchTarget()

launchTarget()
{
	print("`r")
	dlls := "\Autohotkey\dlls\"
	_ahk := FileExist(A_workingdir "\AutoHotkey.dll") ? A_workingdir "\AutoHotkey.dll" : A_mydocuments dlls "AutoHotkey.dll"
	_pex := FileExist(A_workingdir "\peixoto.dll") ? A_workingdir "\peixoto.dll" : A_mydocuments dlls "peixoto.dll"	
	_ahk := A_workingdir "\AutoHotkey.dll" 
	_pex := A_workingdir "\peixoto.dll" 
	
	target := g_.target
	splitpath, target, name
	process, exist, %name%	
	fileexist(g_.target) ?: quit(name " not found in`n`n" g_.target_dir)	
	errorlevel ? quit(name ".exe already running")
	
	dllcall((ld:="LoadLibraryW"), str, _ahk) ?: Quit("Unable to find or load`n" _ahk "-" A_lasterror)
	dllcall(ld, str, _pex)                   ?: Quit("Unable to find or load`n" _pex "-" A_lasterror)

	/*
	if instr(g_.svs, "links")
    links := new Syslinks(g_.target_dir, A_mydocuments "\games\" g_.path "\saves")     
	else if instr(g_.svs, "xlive")
	links := new Syslinks(GetCommonPath( "LOCAL_APPDATA" ) "\Microsoft\XLive", A_mydocuments "\games\" g_.path "\saves")	
	else if (g_.svs = "CODEX") ;Codepath never taken as function ParseCommandLine changes g_.svs = "CODEX" to g_.svs = "fldrs" 
	links := new Syslinks(GetCommonPath( "COMMON_DOCUMENTS" ) "\Steam\CODEX", A_mydocuments "\games\" g_.path "\saves")
    else if (g_.svs = "fldrs" and FileExist(g_.target_dir "\codex.dll"))
    {
        p := A_mydocuments "\games\" g_.path "\saves\"
        EnvSet, PUBLIC, %p% 
    }  
	*/
		
	c   := Setup()
	;cdx := new codex()	
	if (g_.cmmd)
	{
		args := ""
		for k, v in strsplit(g_.cmmd, ";")
			args .= strsplit(v, "=")[2] " "
	} else	args := g_.args
	stringreplace, args, args, `"`"`"`",`",1	
	g_.args := args	
	g_.args := """" g_.target_dir "\" g_.target """ " args ; Breaks VVVVVV. CreateIdleProcess puts everything in the lpCommandLine param
	g_.args := " " args                                    ; Dark earth needs this space
	g_.args := args                                        ; CreateIdleProcess fuction now adds this space
	EnvSet, Peixoto.HWND, %A_ScriptHwnd%
	if (g_.Nohooks)
	{
		if (g_.d3d = 10 or g_.d3d = 11)	
			dllcall("SetDllDirectoryA", astr, g_.injector_dir "\dxvk\" g_.dxvkv "\x32")
		g_.proc := CreateIdleProcess(g_.target, g_.target_dir, g_.args,, True)
	} 
	else 
	{
		;if (g_.d3d = 10 or g_.d3d = 11)	
			;dllcall("SetDllDirectoryA", astr, g_.injector_dir "\dxvk\" g_.dxvkv "\x32")
		g_.proc := CreateIdleProcess(g_.target, g_.target_dir, g_.args)		
		SetupProc(g_.proc.hProcess, name)
		Inject(_ahk, _pex)
	}	
					
	if g_.gamma {
		hDC := DllCall("GetDC", "Uint", 0)
		VarSetCapacity(gramp, 256*6)
		DllCall("GetDeviceGammaRamp", "Uint", hDC, "Uint", &gramp) 
		DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)		
	}
	
	id := g_.proc.Process_id
	process, Exist, %id%
	while ErrorLevel
	{
		sleep, 100
		id := g_.proc.Process_id
		process, Exist, %id%	

		if getkeystate("ctrl", "p") && getkeystate("alt", "p") & getkeystate("del", "p")
		process, close, %id%			
	}	
	links := ""
	CleanUP(c, &gramp)	
	exitapp
}

InjectMsg(h, m, w, l)
{
	dlls := "\Autohotkey\dlls\"
	_ahk := FileExist(A_workingdir "\AutoHotkey.dll") ? A_workingdir "\AutoHotkey.dll" : A_mydocuments dlls "AutoHotkey.dll"
	_pex := FileExist(A_workingdir "\peixoto.dll") ? A_workingdir "\peixoto.dll" : A_mydocuments dlls "peixoto.dll"	
	_ahk := A_workingdir "\AutoHotkey.dll" 
	_pex := A_workingdir "\peixoto.dll" 
	Inject(_ahk, _pex)
	return
}

Inject(_ahk, _pex)
{
	while ! g_.proc.hProcess
	continue
	
	dllcallEx(g_.proc.hProcess, "Kernel32.dll", "LoadLibraryW", _ahk)	
	dllcallEx(g_.proc.hProcess, "Kernel32.dll", "LoadLibraryW", _pex)	
		
	GetRemoteScript()	
	FileDelete, last
	fileappend, % g_.remoteScript, last
	success := dllcallEx(g_.proc.hProcess, "peixoto.dll", "RunScript", A_workingdir "\last")	
	
	if (success = 2)
	{
		quit("Could not allocate memory for dll injection: " A_lasterror)
	}
	else if (success = 3)
		quit("Could not write to memory allocated for dll injection " A_lasterror)
	else if (success = 4)
		quit("Could not create remote thread for dll injection " A_lasterror)
}

SetupProc(hProc, name)
{	
	if (g_.singlecore)
	{
		i := 12
		S := 0
		while (!s)
		{
			s := dllcall("SetProcessAffinityMask", uint, hProc, uint, 1 << i, uint) 
			i-= 1			
		}
	}	
	
	print("hProc " hProc "`n")
	if (g_.D3D > 0 and g_.D3D < 4) 
	{
		dllcallEx(g_.proc.hProcess, "Kernel32.dll", "LoadLibraryW", "D3Dim.dll") 
		loop, 2
		{
			ad := aobscan(hProc, get_process_ID(name), "D3Dim.dll", memlib_String2ByteArray("B8 00 08 00 00 39"), "peixoto.dll")
			if ad is number
				write_process_memory(hProc, ad+1, "array", [0x00, 0x20, 0x00, 00]) 
		}	
	}
	else if (g_.D3D = 7) 
	{
		dllcallEx(g_.proc.hProcess, "Kernel32.dll", "LoadLibraryW", "d3dim700.dll") 		
		while ! find_module("d3dim700.dll", g_.proc.Process_id) ;Avp2 dllcallex is returning before the dll is loaded
			continue
		loop, 2
		{
			ad := aobscan(g_.proc.hProcess, g_.proc.Process_id, "d3dim700.dll", memlib_String2ByteArray("B8 00 08 00 00 39"), "peixoto.dll")
			if ad is number
				write_process_memory(g_.proc.hProcess, ad+1, "array", [0x00, 0x20, 0x00, 00])			
		}	
	}
	print("hProc " g_.proc.hProcess "`n")
}

Setup()
{
	cmpt           := g_.compatLayer
	(g_.HDPI)      ? cmpt .= cmpt ? " HIGHDPIAWARE" : "HIGHDPIAWARE"
	;Workarround for not catching IDirectDrawSurface::lock and IDirectDrawSurface::Unlock calls in several games
	(g_.D3D=1||g_.D3D=2||g_.D3D=3||g_.D3D=7) ? cmpt .= cmpt ? " DWM8And16BitMitigation" : "DWM8And16BitMitigation"
	print("Changing compability for " g_.target " " cmpt " " g_.s_cmptlr "`n")
	chng           := g_.target
	if (cmpt != "#")
	{
		regwrite, REG_SZ, HKCU, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %chng%, ~ %cmpt%		
		EnvSet, __COMPAT_LAYER, %cmpt%	
	}	
	if (g_.rnm)
	{
		RegDelete, HKLM, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Custom, %chng%
		RegDelete, HKLM, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %chng%
	}		
	if g_.DSR 
	{
		VarSetCapacity(DM, 156, 0)
		NumPut(156, DM, 36,"ushort")	
		DllCall("EnumDisplaySettingsA", uint, 0, uint, -1, uint, &DM)
		cw := NumGet(DM, 108, "uint")
		ch := NumGet(DM, 112, "uint")		
			
		res := strsplit(g_.dsr, "x")
		Numput(res[1], &DM+108, "uint")
		Numput(res[2], &DM+112, "uint")
		DllCall("ChangeDisplaySettingsA", uint, &DM, uint, 0) 
	}
	if g_.SXTY
	{
		dllcall("peixoto.dll\GDISetHz", uint, 60)
	}	
	return [cw, ch]
}

CleanUP(c, byref cramp)
{
	if g_.DSR 
	{
		VarSetCapacity(DM, 156, 0)
		NumPut(156, DM, 36,"ushort")
		DllCall("EnumDisplaySettingsA", uint, 0, uint, -1, uint, &DM)
		Numput(c[1], &DM+108, "uint")
		Numput(c[2], &DM+112, "uint")
		DllCall("ChangeDisplaySettingsA", uint, &DM, uint, 0)
	}
	
	if g_.gamma {
		hDC := DllCall("GetDC", "Uint", 0)
		DllCall("SetDeviceGammaRamp", "Uint", hDC, "Uint", cramp) 
		DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)		
	} 
	
	if g_["LNKS"] 
	{
		lnk := g_.target_dir "\" g_["lnks"]
		Print("`nRemoving simbolic link : " lnk)
		fileremovedir, %lnk%
	}		
}

ProcNameMessage(W, L)
{
	trgt := StrGet( NumGet(L+8), NumGet(L+4), "UTF-16" )
	splitpath, trgt, name, dir 
	g_.target       := trgt
	g_.target_dir   := dir
	g_.target_name  := name		
	print( "Recived " StrGet( NumGet(L+8), NumGet(L+4), "UTF-16" ) "`n")
	Setup()
	return
}

Is64Bit(){
    r := dllcall("GetBinaryType", astr, g_.target, "uint*", target)
	return r > 0 and target = 6		
}

ProcHwndMessage(w, l)
{
	print("ProcHwndMessage recived`n")
    if Is64Bit(){
        cmd  := StrSplit(dllcall("GetCommandLineW", str), "-f"" ")[2]	
        trgt := g_.target
		run, Injector64.exe src/injector64.txt -f %cmd% -32bitparent "%trgt%"
        sleep, 1000       
        OnMessage(dllcall("RegisterWindowMessageW", str, "Peixoto.Hwnd"), "")
        dllcall("PostMessageW", uint, 0xffff, uint, dllcall("RegisterWindowMessageW", str, "Peixoto.Hwnd")
        , uint, w, uint, l) 
        exitapp
    }
	g_.proc            := {}
	g_.proc.hProcess   := w
	g_.proc.hProcess   := dllcall("OpenProcess", uint, 0x30|0x02|0x08|0x00100000|0x0200, uint, 0, uint, l) ;get_process_handle(g_.target_name)
	g_.proc.Thread_id  := w
	g_.proc.Process_id := l
	SetupProc(g_.proc.hProcess, g_.target_name)
	dlls := "\Autohotkey\dlls\"
	_ahk := FileExist(A_workingdir "\AutoHotkey.dll") ? A_workingdir "\AutoHotkey.dll" : A_mydocuments dlls "AutoHotkey.dll"
	_pex := FileExist(A_workingdir "\peixoto.dll") ? A_workingdir "\peixoto.dll" : A_mydocuments dlls "peixoto.dll"	
	_ahk := A_workingdir "\AutoHotkey.dll" 
	_pex := A_workingdir "\peixoto.dll" 
	Inject(_ahk, _pex)
	return
}

GetRemoteScript()
{
	g_.remoteScript := ""
	if g_.console 
		g_.remoteScript := "#warn all, OutputDebug`n"
	g_.remoteScript := "global g_MainThreadID := " g_.proc.Thread_id " `;<Tag> `n" g_.remoteScript 
	g_.remoteScript .= "global g_cmdstring := """ g_.cmdstring """`n"
	g_.remoteScript .= LoadResource("remote_lib.txt")	
	g_.remoteScript .= "`n" LoadResource("CreateProcessHooks.txt") 
	g_.remoteScript .= "`n" LoadResource("..\Xinput.ahk") 
	if (Parsecfg(g_.WNMM).MCI) 
	{
		g_.remoteScript .= "`n" LoadResource("MCI.txt")
		if g_.console 
		{
			fileread, MCIDbug, dev\MCI Debug.ahk
			g_.remoteScript .= "`n" MCIDbug	
		}			
	}
	if g_.dshow or Parsecfg(g_.J2K).u
		g_.remoteScript .= LoadResource("Xinput.txt") "`n"	
	if g_.dshow
		g_.remoteScript .= "`n`r" LoadResource("dshow.hooks.txt")
	if Parsecfg(g_.dsnd).e
		g_.remoteScript .= "`n`r" LoadResource("dsound.hooks.txt")		
	if Parsecfg(g_.J2K).u
		g_.remoteScript .= "`n" LoadResource("dinput.hooks.txt") "`n"
	if (g_.D3D > 0 and g_.D3D < 4) or (g_.D3D = 7) or (g_.ddraw)
		g_.remoteScript .= "`n" LoadResource((g_.ver or g_.layeroff) ? "D3D.hooks.txt" : "D3D.hooks.txt") "`n" LoadResource("WinAPI.hooks.txt")
	else if (g_.D3D = 8)
		g_.remoteScript .=  "`n" LoadResource("D3DX9.txt") "`n" LoadResource("D3D8.hooks.txt")
	else if (g_.D3D = 9)
		g_.remoteScript .=  "`n" LoadResource("D3DX9.txt") "`n" LoadResource("D3D9.hooks.txt")
	else if (g_.D3D = "gl")
		g_.remoteScript .= "`n" LoadResource("gl.hooks.txt")
	else if (g_.D3D = 11 or g_.D3D = 10)
		g_.remoteScript .= "`n" LoadResource("D3D11.hooks.txt") "`n" LoadResource("HLSLGen.txt")	
	if g_.Script
	{
		g_.ex_script := LoadResource("exlib.txt") "`n"
		g_.ex_script .= LoadResource("Xinput.txt") "`n"			
	    script_file  := A_mydocuments "\WineHooks\" g_.Script
		if fileexist(script_file)
		{
			fileread, script, %script_file%
			script := strsplit(script, ";REMOTE SCRIPT START")
			g_.remoteScript .= "`n" script[2] "`n"
			g_.ex_script .= "`n" script[1]
		} else {
			script := strsplit(script_file, "|")
			g_.remoteScript .= "`n" script[2] "`n"
			g_.ex_script .= "`n" script[1]
		}
	} else if g_.J2K or g_.K2K
	{
		g_.ex_script := LoadResource("exlib.txt") "`n"
		g_.ex_script .= LoadResource("Xinput.txt") "`n"
	}
		
	if ! g_.console 
		g_.remoteScript .= "`nprintl()"
	(g_.D3D > 0 and g_.D3D < 4) or (g_.ddraw) ? g_.remoteScript .= "`n" "ReleaseDirectDraw()`n"
	g_.remoteScript .= "`nresume()"		
}	

CompileScript(script)
{
	if A_iscompiled 
		return	
	splitpath, script, , , ,name	
	runwait, Ahk2Exe.exe /in %script% /out %name%.exe 							
	txt := LoadResource(">AUTOHOTKEY SCRIPT<", name ".exe")
	filedelete, %name%.txt
	fileappend, %txt%, %name%.txt
}	

LoadResource(res, _mod = "")
{
	return fileopen("src\" res, "r").read()	
}

CheckTarget()
{
	r := dllcall("GetBinaryType", astr, g_.target, "uint*", target)
	if (target = 0) and r
		return
	else if (target = 6) {
		cmd_line := dllcall("GetCommandLineW", str)		
		cmd      := instr(cmd_line , "-f"" ") ? StrSplit(cmd_line, "-f"" ")[2] :  StrSplit(cmd_line, "-f ")[2]   		
		run, Injector64.exe src/injector64.txt -f %cmd%
		ExitApp
	} else quit(g_.target " is not a valid windows 32 or 64 bit program")
}

MCI(wP, lParam, msg, hwnd)
{
	critical
	static from, to, hEvent, Ntf, pNtf
	static sndbuff=0, vol:=0, volr:=0xffff, tracks, last, lg, reply, flags, hwin, path := "\" 
		
	if (wP = 1)                 ; Open ======================================================================================
	{
		if isobject(IDirectSound)
		return
		hEvent     := dllcall("CreateEventW", uint, 0, uint, 1, uint, 1, str, "Peixoto.MCI", uint)
		Ntf        := struct("LPVOID hEvent; DWORD hwin; DWORD Abrt; DWORD ANtf; DWORD SB;")
		Ntf.hEvent := hEvent
		pNtf       := dllcall("GetProcAddress", uint, dllcall("GetModuleHandle", str, "peixoto.dll"), astr, "MCINofify", uint)
		reply      := dllcall("GetProcAddress", uint, dllcall("LoadLibraryW", str, "User32.dll"), astr, "ReplyMessage", uint)
		lg         := g_.injector_dir "\error.log"
		tracks     := []
		GetDSound(hwin := dllcall("GetForegroundWindow", uint))
		ms         := 0		
		total      := 0	
		Loop
		{
			track := g_.target_dir path GetTrackName(A_index)
			if ! fileexist(track)
				break
			;track := "C:\Games\Tomb Raider\TOMBENG\08 Track 8.wav"
			if fileexist(track)
			{
				t     := GetWAVInfo(track)
				t.ms  := ms
				ms    := t.ms + t._ms
				t.pos := total
				tracks.insert(t)
				ts .= track " " t.m " minutes :" t.s " seconds :" t.f " frames - total: " t.t " seconds`n" 	
				total += t._ms						
			} else break
		}	
		out := "OPEN:`n"
		for i, t in tracks
			out .=  "`t track " i ": " t.m " minutes :" t.s " seconds :" t.f " frames - total: " t._ms " mili seconds, position(ms):" t.pos "`n"
		MCILog(rtrim(out, "`n"))			
	}
	else if (wP = 2)
	{
		path := (lParam) ? "\Disk2\" : "\" 
		if isobject(IDirectSound)
		return	
		Ntf.Abrt := 1
		Ntf.ANtf := 0
		dllcall(sndbuff.stop, uint, sndbuff.p) 
		dllcall("SetEvent", uint, hEvent)
		dllcall(sndbuff.release, uint, sndbuff.p)
		sndbuff  := 0		
		tracks   := []
		ms       := 0		
		Loop
		{
			track := g_.target_dir path GetTrackName(A_index)
			if fileexist(track)
			{
				t    := GetWAVInfo(track)
				t.ms := ms
				ms   := t.ms + t._ms
				tracks.insert(t)
				ts .= track " " t.m " minutes :" t.s " seconds :" t.f " frames - total: " t.t " seconds`n" 							
			} else break
		}		
		return dllcall(reply, uint, wp)	
	}	
	else if (wp = 6)
	{
		from := lParam
	}
	else if (wp = 7)
	{
		to   := lParam 
	}
	else if (wp = 3)
	{
		t := 0
		for k, v in tracks
		{
			if (t >= from)
			{
				from := k+1 				
				break
			}
			t += MSF_to_MScnd(v)			
		}	
		to := from
	}
	else if (wp = 8)
	{
		fcs      := (hwin != dllcall("GetForegroundWindow"))
		t0       := (from & 0xff)-1
		tf       := (to   & 0xff)-1
		offset   := (from & 0xffffff)		
				
		if (tf = t0)
		tf       := t0+1		
		ntracks  := tf-t0
		last	 := t0	
		fcs      := hwin != dllcall("GetForegroundWindow", uint) ? 1 : 0
					
		;if (t0 < 1) and isobject(sndbuff)
			;return dllcall(sndbuff.play, uint, sndbuff.p, uint, 0, uint, 0, uint, flags, uint)
		
		if isobject(sndbuff)
		{
			Ntf.Abrt := 1	
			Ntf.ANtf := 0
			dllcall(sndbuff.stop, uint, sndbuff.p) 
			dllcall("SetEvent", uint, hEvent)
			dllcall(sndbuff.release, uint, sndbuff.p)
			sndbuff  := 0
		}
		dllcall("ResetEvent", uint, hEvent)			
						
		if ((ntracks > 1) && (ntracks <= (tracks._MaxIndex() - t0)))
		sndbuff      := loadWAVS(g_.target_dir path, t0, ntracks)
		else sndbuff := InjectorLoadWAV(g_.target_dir path GetTrackName(t0),,fcs) 		
		if (!isobject(sndbuff))
		{
			dllcall("SetEvent", uint, hEvent)
			return
		}			
		if (offset)
		{		
			dllcall(sndbuff.GetFormat, uint, sndbuff.p, uint, WAVEFORMATEX[], uint, WAVEFORMATEX.size(), "uint*", p4)
			scds   := (offset & 0xff0000)      >> 16 
			scds   += (offset & 0xff00)*60     >> 8
			scds   += (offset & 0xff000000)/75 >> 24
			smpls  := WAVEFORMATEX.nSamplesPerSec*scds
			bytes  := WAVEFORMATEX.wBitsPerSample*smpls*WAVEFORMATEX.nChannels/8
			dllcall(sndbuff.SetCurrentPosition, uint, sndbuff.p, uint, bytes)					
		}
		v := dllcall(sndbuff.SetVolume, uint, sndbuff.p, int, vol, uint)
		v .= dsound.err[v . ""]
		
		Ntf.hWin := lParam&0xffff
		Ntf.Abrt := 0
		Ntf.ANtf := 0		
		;f := dllcall("IsWindow", uint, lParam) ? DSBPLAY_LOOPING : 0
		dllcall(sndbuff.play, uint, sndbuff.p, uint, 0, uint, 0, uint, f, uint)	
			
		Ntf.SB := sndbuff.p
		if (Ntf.hWin) ; prevents music on the yellow text in shadows of the empire from playing twice
		dllcall("CreateThread", ptr, 0, uint, 0, ptr, pNtf, ptr, Ntf[], uint, 0, uint, 0)			
		MCILog("Play " ntracks " tracks, " t0 " to " t1 ": " GetTrackName(t0))		 
	}	
	else if (wp = 9)
	{
		return dllcall(reply, uint, 1)	
	}
	else if ( (wP = 4) || (wP = 5) )    ; Stop(4) or Pause(5) ========================================================================
	{
		if ! isobject(sndbuff)
		return
		Ntf.Abrt := 1
		Ntf.ANtf := lParam
		dllcall(sndbuff.stop, uint, sndbuff.p) 
		dllcall("SetEvent", uint, hEvent)		
		return dllcall(reply, uint, wp)		
	}
	else if (wP = 11)                   ; Track lenght ===============================================================================
	{
		if (lParam = 1)
			lParam := 2
		t := tracks[lParam-1]
		dllcall(reply,uint,TMSF(t)>>8)  ; FIX THIS: Turok 2 needs this shifted 8 bits ================================================ 
	}	
	else if (wP = 104)                  ; Status =====================================================================================
	{
		if ! isobject(sndbuff)
			return dllcall(reply, uint, 525)
		r := dllcall(sndbuff.GetStatus, uint, sndbuff.p, "uint*", _status)
		return dllcall(reply, uint, (_status & DSBSTATUS_PLAYING) ? 526 : 525)
	}		
	else if (wP = 103)                  ; Number of track ============================================================================
	{
		;Print("lenght "  tracks._MaxIndex()+1)
		return dllcall(reply, uint, tracks._MaxIndex()+1)	
	}
	else if (wP = 102)                  ; Disk Position ==============================================================================
	{
		if ! isobject(sndbuff)
			dllcall(reply, uint, 2)
		play := 0
		w    := 0
		p := dllcall(sndbuff.GetCurrentPosition, uint, sndbuff.p, "uint*", play, "uint*", w)
		f := dllcall(sndbuff.GetFormat, uint, sndbuff.p, uint, WAVEFORMATEX[], uint, WAVEFORMATEX.size(), "uint*", sz:=0)		
		t := WavTime(play, WAVEFORMATEX)
		if !lparam
		;dllcall(reply, uint, current+1 | (t.m << 8) | (t.s << 16) | (t.f << 24))
		dllcall(reply, uint, last+1 | TMSF(t))
		else if lparam
		dllcall(reply, uint, tracks[last].ms + t._ms)		
	}
	else if (wP = 120)                  ; track Position milisseconds =================================================================
	{
		;if (lParam = 1)  // removal untested
		;lParam := 2
		t := tracks[lParam-1]
		p := 0
		for k, v in tracks
		{
			if (k = lParam-1)
			return dllcall(reply, uint, p)	
			print("track " k " " MSF_to_MScnd(v) " milisseconds`n")
			p += MSF_to_MScnd(v)			
		}		
	}
	else if (wP = 110)                  ; track lenght milisseconds   =================================================================
	{
		if (lParam = 1)
		lParam := 2
		t := tracks[lParam-1]		
		dllcall(reply, uint, MSF_to_MScnd(t))	
	}
	else if (wP = 1000)                 ; Volume =====================================================================================
	{
		volr := lParam 
		vol  := volr ? (log(volr&0xFFFF)*10000/log(0xFFFF))-10000 : -10000
		if isobject(sndbuff)
		{
			dllcall(sndbuff.GetStatus, uint, sndbuff.p, "uint*", stts)
			(stts & 1) ? dllcall(sndbuff.stop, uint, sndbuff.p) 
			dllcall(sndbuff.SetVolume, uint, sndbuff.p, int, vol)	
			(stts & 1) ? dllcall(sndbuff.play, uint, sndbuff.p, uint, 0, uint, 0, uint, flags, uint)			
		}
	}
	else if (wP = 3000)                 ; Volume (send string) =======================================================================
	{
		volr := lParam 		
		vol  := volr ? (log(volr)*10000/log(1000))-10000 : -10000		
		if isobject(sndbuff)
		{
			dllcall(sndbuff.GetStatus, uint, sndbuff.p, "uint*", stts)
			(stts & 1) ? dllcall(sndbuff.stop, uint, sndbuff.p) 
			dllcall(sndbuff.SetVolume, uint, sndbuff.p, int, vol)	
			(stts & 1) ? dllcall(sndbuff.play, uint, sndbuff.p, uint, 0, uint, 0, uint, flags, uint)			
		}
	}
	else if (wP = 2000)                 ; Get volume ================================================================================
	/* Call ReplyMessage by name instead of pointer, excalibur 2555 AD
	 * calls auxgetvolume before opening te MCI device
	 */
	dllcall("ReplyMessage", uint, volr)	
	return 0
}

GetDSound(hwin)
{
	return GetDirectSound(hwin)
	GetDirectSound8(hwin)
	
	GUID_FromString(iid, dsound.IDirectSound)
	r := dllcall(IDirectSound8.QueryInterface, uint, IDirectSound8.p, uint, &iid, "uint*", pDS:=0)
	if r
		return "Failed to create the IDirectSound interface " r dsound.err[r . ""]	
	IDirectSound := new ComInterfaceWrapper(dsound.IDirectSound, pDS, True)  
	
	GUID_FromString(iid, dsound.IDirectSoundBuffer)
	r := dllcall(IDirectSoundBuffer8.QueryInterface, uint, IDirectSoundBuffer8.p, uint, &iid, "uint*", pDSb:=0)
	if r
		return "Failed to create the IDirectSoundBuffer interface " r  " - " dsound.IID_IKsPropertySet " " dsound.err[r . ""]	
	IDirectSoundBuffer := new ComInterfaceWrapper(dsound.IDirectSoundBuffer, pDSb, True) 
}

MSF_to_MScnd(msf)
{
	m := msf.m * 60 * 1000
	m += msf.s * 1000
	m += msf.f * 1000 / 75
	return m
}

TMSF(t)
{
	return (t.m << 8) | (t.s << 16) | (t.f << 24)
}

InjectorLoadWAV(file_, formatcheck = True, fcs = False) 
{ 		
	;file_ := "E:\Games\Tomb Raider\TOMBENG\08 Track 8.wav"
	
	plock:=0, plocksize:=0
	file := FileOpen(file_, "r")
	if (!isobject(file))
	return 0	
	VarSetCapacity(data, file.Length)
	file.RawRead(data, file.Length)
	file.close()
	
	loop, % file.Length
	{
		if strget(&data + A_index, 3, "CP0") = "fmt" 
		{
			index := A_index + 8
			break
		}	
	}	
		
	if not index
		return "File format must be .wav (PCM)"
	
	VarSetCapacity(wav, sizeof(WAVEFORMATEX))
	dllcall("RtlMoveMemory", ptr, &wav, ptr, &data + index, int, sizeof(WAVEFORMATEX))	
	WAVEFORMATEX[] := &wav		
	
	if 	WAVEFORMATEX.wFormatTag = 1
		WAVEFORMATEX.wFormatTag := WAVE_FORMAT_PCM	
	else 
		if formatcheck 
			return "WAV file must be on PCM format"	
		
	loop, % file.Length
	{
		if strget(&data + A_index, 4,"CP0") = "data" 
		{
			index := A_index
			break
		}	
	}
		
	data_size := numget(&data + index + 4, "int")	
	VarSetCapacity(wave_data, data_size)
	dllcall("RtlMoveMemory", ptr, &wave_data, ptr, &data + index + 8, int, data_size)		
		
	DSBUFFERDESC.dwSize        := sizeof(DSBUFFERDESC)
	DSBUFFERDESC.dwFlags       := DSBCAPS_CTRLVOLUME | DSBCAPS_LOCSOFTWARE 
	DSBUFFERDESC.dwBufferBytes := data_size
	DSBUFFERDESC.lpwfxFormat   := WAVEFORMATEX[] 
	fcs ? DSBUFFERDESC.dwFlags |= (DSBCAPS_STICKYFOCUS | DSBCAPS_GLOBALFOCUS )
	DSBUFFERDESC.dwFlags |= (DSBCAPS_STICKYFOCUS | DSBCAPS_GLOBALFOCUS )
	
	buff := 0	
	r := dllcall(IDirectSound.CreateSoundBuffer, uint, IDirectSound.p, uint, DSBUFFERDESC[], "uint*", buff, uint, 0, uint)
	if r		
		return r  " CreateSoundBuffer " dsound.err[r . ""]
		
	sndbuff := new ComInterfaceWrapper(dsound.IDirectSoundBuffer, buff, True) 
	r := dllcall(sndbuff.Lock, uint, sndbuff.p, uint, 0, uint, data_size, "uint*", plock
							 , "uint*", plocksize, uint, 0, uint, 0, uint, DSBLOCK_ENTIREBUFFER, uint)
	if r		
		return r  " Lock " dsound.err[r . ""]
	
	dllcall("RtlMoveMemory", ptr, plock, ptr, &wave_data, int, data_size)
	
	r := dllcall(sndbuff.UnLock, uint, sndbuff.p, uint, plock, uint, data_size, uint, 0, uint, 0, uint)
	if r		
		return r  " Unlock " dsound.err[r . ""]
	
	wav := ""
	wave_data := ""	
	return sndbuff			
}	

loadWAVS(dir, strt, n) 
{
	lg     := g_.injector_dir "\error.log"
	sz     := 0
	
	loop, %n%
	{
		f := GetTrackName(strt+A_index-1)
		f := FileOpen(dir "\" f, "r")
		if (!isobject(f))
		return	
	
		loop
		{
			if (f.Read(3) = "fmt" )
				break						
			f.seek(A_index, 0)
		}	
		
		f.seek(5, 1)
		f.RawRead(WAVEFORMATEX[], sizeof(WAVEFORMATEX))
		
		if 	WAVEFORMATEX.wFormatTag <> 1
			return "WAV file must be on PCM format"	
			
		loop
		{
			if (f.Read(4) = "data")
				break				
			f.seek(A_index, 0)	
		}
		sz += f.ReadInt()
		f.close()		
	}
	
	DSBUFFERDESC.dwSize        := sizeof(DSBUFFERDESC)
	DSBUFFERDESC.dwFlags       := DSBCAPS_CTRLVOLUME | DSBCAPS_CTRLPOSITIONNOTIFY | DSBCAPS_LOCSOFTWARE ;| DSBCAPS_STICKYFOCUS | DSBCAPS_GLOBALFOCUS 
	DSBUFFERDESC.dwBufferBytes := sz
	DSBUFFERDESC.lpwfxFormat   := WAVEFORMATEX[] 
						  
	r       := dllcall(IDirectSound.CreateSoundBuffer, uint, IDirectSound.p, uint, DSBUFFERDESC[], "uint*", buff, uint, 0, uint)
	r       :=  "CreateSoundBuffer " r " " dsound.err[r . ""] "`n"
	sndbuff := new ComInterfaceWrapper(dsound.IDirectSoundBuffer, buff, True) 
	VarSetCapacity(buff_data, sz)
	sz      := 0
		
	loop, %n%
	{
		f := GetTrackName(strt+A_index-1)
		file := FileOpen(dir "\" f, "r")	
		
		VarSetCapacity(data, file.Length)
		file.RawRead(data, file.Length)
		file.close()
	
		loop, % file.Length
		{
			if strget(&data + A_index, 3, "CP0") = "fmt" 
			{
				index := A_index + 8
				break
			}	
		}	
		
		if not index
			return "File format must be .wav (PCM)"
		
		VarSetCapacity(wav, sizeof(WAVEFORMATEX))
		dllcall("RtlMoveMemory", ptr, &wav, ptr, &data + index, int, sizeof(WAVEFORMATEX))	
		WAVEFORMATEX[] := &wav		
		
		if 	WAVEFORMATEX.wFormatTag = 1
			WAVEFORMATEX.wFormatTag := WAVE_FORMAT_PCM	
		else 
			if formatcheck 
				return "WAV file must be on PCM format"	
			
		loop, % file.Length
		{
			if strget(&data + A_index, 4,"CP0") = "data" 
			{
				index := A_index
				break
			}	
		}
			
		data_size := numget(&data + index + 4, "int")	
		dllcall("RtlMoveMemory", ptr, &buff_data+sz, ptr, &data + index + 8, int, data_size)		  
		sz += data_size	
	}	
	r  := dllcall(sndbuff.Lock, uint, sndbuff.p, uint, 0, uint, sz, "uint*", plock
							  , "uint*", plocksize, uint, 0, int, 0, uint, DSBLOCK_ENTIREBUFFER, uint)
	dllcall("RtlMoveMemory", ptr, plock, ptr, &buff_data, int, plocksize)		
	r  := dllcall(sndbuff.UnLock, uint, sndbuff.p, uint, plock, uint, plocksize, uint, 0, int, 0, uint)	
	return sndbuff	
}

GetTrackName(n)
{
	frmt := A_FormatInteger
	setformat, integer, D
	((trck := n)<10) ? append := true
	trck   := trck " Track " trck ".wav"
	append ? trck := "0" trck
	setformat, integer, %frmt%
	return trck
}

GetWAVInfo(f) 
{ 		
	f := FileOpen(f, "r")	
	
	loop
	{
		if (f.Read(3) = "fmt" )
			break						
		f.seek(A_index, 0)
	}	
	
	f.seek(5, 1)
	f.RawRead(WAVEFORMATEX[], sizeof(WAVEFORMATEX))
	
	if 	WAVEFORMATEX.wFormatTag <> 1
		return "WAV file must be on PCM format"	
		
	loop
	{
		if (f.Read(4) = "data")
			break				
		f.seek(A_index, 0)	
	}
	sz := f.ReadInt()
	f.close()
	return WavTime(sz, WAVEFORMATEX)	
}

WavTime(sz, byref fmt)
{
	sz_bts     := (sz*8)/fmt.nChannels
	smpls      := sz_bts/fmt.wBitsPerSample
	scnds      := smpls/fmt.nSamplesPerSec	
	mnts       := floor(scnds/60)
	scnds      := scnds-(mnts*60)
	frame      := abs((scnds-floor(scnds))*(-75))
	scnds      := floor(scnds)
	return {"m" : mnts, "s" : scnds, "f" : round(frame), "t" : sz_bts/fmt.wBitsPerSample, "_ms" : smpls/fmt.nSamplesPerSec*1000}	
}

MCIGetWAVInfo(f) 
{ 		
	VarSetCapacity(stat, 50)
	dllcall("Winmm.dll\mciSendStringA", astr, "open """ f """ type waveaudio alias voice1", uint, 0, uint, 0, uint, 0)
    dllcall("Winmm.dll\mciSendStringA", astr, "set voice1 time format ms", uint, 0, uint, 0, uint, 0)
    dllcall("Winmm.dll\mciSendStringA", astr, "status voice1 length", uint, &stat, uint, 260, uint, 0)
    dllcall("Winmm.dll\mciSendStringA", astr, "close voice1", uint, 0, uint, 0, uint, 0)
    return MCIWavTime( strget(&stat, "CP0") )
}

MCIGetWAVSamples(f) 
{ 	
	VarSetCapacity(stat, 50)
	dllcall("Winmm.dll\mciSendStringA", astr, "open """ f """ type waveaudio alias voice1", uint, 0, uint, 0, uint, 0)
    dllcall("Winmm.dll\mciSendStringA", astr, "set voice1 time format ms", uint, 0, uint, 0, uint, 0)
    dllcall("Winmm.dll\mciSendStringA", astr, "status voice1 length", uint, &stat, uint, 260, uint, 0)
    dllcall("Winmm.dll\mciSendStringA", astr, "close voice1", uint, 0, uint, 0, uint, 0)
	return strget(&stat, "CP0") 
}

MCIWavTime(ms)
{
	scnds      := ms/1000
	mnts       := floor(scnds/60)
	scnds      := scnds-(mnts*60)
	frame      := abs((scnds-floor(scnds))*(-75))
	scnds      := floor(scnds)
	return {"m" : mnts, "s" : scnds, "f" : round(frame), "t" : ms/1000}	
}

Class ComInterfaceWrapper
{
	__New(byref d, ppIface, v8 = False)
	{
		this.offsets := {}
		n := 0
		def := d.def
		loop, parse, def, `n 
		{
			if instr(A_loopfield , "STDMETHOD")
			{
				m := RegExReplace(A_loopfield, "s)\).*" ,"")
				m := RegExReplace(m, "s).*\(" ,"")
				if instr(m, ",")
				{
					stringsplit, m_, m,`, 
					m := trim(m_2)
				}
				this.offsets[m] := n * A_ptrsize
				n += 1							
			}	
		}		
			
		pIface := v8 ? ppIface : numget(ppIface+0, "ptr")
		if pIface 
		{
			Vtbl := numget(pIface + 0, "Ptr")			
			for k, v in this.offsets
			{
				vv := numget(Vtbl + v, "Ptr")
				this[k] := vv															
			}
		}
			
		this.dwSize   := n*A_ptrsize			
		this.pVTbl    := Vtbl					
		this.p        := pIface	
		this.released := False		
	}
}

MCILog(t)
{
	FileAppend, `tPlay Thread: %t%`n, WinMM.log
}

struct(d){
	return new _Struct(d)
}