StartDll()
{
	if g_.ex_script
	{
		ahktextdll := dllcall("GetProcAddress", uint, dllcall("GetModuleHandle", str, "AutoHotkey.dll"), astr, "ahktextdll")
		id         := g_.proc.Thread_id
		dllcall(ahktextdll, Str, "#NoTrayIcon`n" g_.ex_script, Str, g_.cmdstring "^-ThreadID^" id, Str, "", "Cdecl UPTR")		
	}
}	

class Codex 
{
	__new()
	{
		if (!g_.svs)
		return 	
		/* Delay dll loading after file hooks are installed
		 * peixoto.dll takes care of loading those latter
		 */
		if fileexist( (dir := g_.target_dir) "\Codex*.dll")
		FileMove, %dir%\winmm.dll, %dir%\_winmm.dll, 1 ;Talos principle: proxy winmm loads codex dlls	
	}
	__delete()
	{
		if fileexist( (dir := g_.target_dir) "\Codex*.dll")
		FileMove, %dir%\_winmm.dll, %dir%\winmm.dll, 1 
	}
}

print(msg = "")
{
	static hnd=0	
	if not hnd
	{
		target := g_.target
		splitpath, target, name, dir
		g_.console_icon.h := EnumIcons( (g_.target_icon) ? dir "\" g_.target_icon : g_.target)
		DllCall("AllocConsole")			
		hnd := DllCall("GetStdHandle", "int", -11)			
		dllcall("SetConsoleTitle", str, name)
		dllcall("SetConsoleIcon", uint, g_.console_icon.h) 		
		dllcall("SendMessageW", ptr, dllcall("GetConsoleWindow"), uint, 0x0080, uint, 0, uint, g_.console_icon.h)
		dllcall("SendMessageW", ptr, dllcall("GetConsoleWindow"), uint, 0x0080, uint, 1, uint, g_.console_icon.h)
	}	
	return dllcall("WriteConsole", "int", hnd , "ptr", &msg, "int", strlen(msg))
}

GetcmdStringFromFile(File)
{
	parent := GetParentDir()
	cfg    := {}
	cmd    := ""
	dirs   := ""
	mods   := ""
	pid    := DllCall("GetCurrentProcessId")
	
	ini    := new ini(File)
	for k, v in ini.listKeys()
	{
		value := ini.read(v)
		if (v = "console")
		{
			print("Devmode (console=true) can only be set on the main.ini file`n")
			continue
		}
		if not value or value="0" or value="False" or v="Help"
		continue		
		if (value = "True") and ! (Key = "DSR")
		cmd .= "^/" v 
		else cmd .= "^-" v "^" value
	}
	
	for k, section in ini.listSections()
	{
		if (section = "Help")
			continue
		cmd .= "^-" section "^"
		for i, key in ini.listKeys(section)
		{
			cmd .= key "=" ini.read(key, section) ";"
		}		
	}
	target := ini.read("target")
	splitpath, target, ,target_dir
	stringreplace, cmd, cmd, `%target_dir`%, %target_dir%	
	
	cmd .= "^-script_hwnd^" A_scripthwnd
	cmd .= "^-error_log^" A_WorkingDir "\error.log"
	cmd .= "^-Mydocs^" A_mydocuments
	cmd .= "^-injector_dir^" A_WorkingDir
			
	reslist := ""
	for k, v in D3D9_EnumDisplayModes()
	{
		w := v.w, 
		h := v.h	
		res := w "x" h	
		instr(reslist, res) ?: reslist .= res . A_space
		if ( ( (w>max_w) or (h>max_h) ) and round(w/h*100) = 133 )
		{
			max_w := w
			max_h := h
		}
		if ( (w>dsr_w) or (h>dsr_h) ) 
		{
			dsr_w := w
			dsr_h := h
		}				
	}
	dsr := ini.read("DSR")
	((dsr = "True") || (dsr = "1")) ? cmd .= "^-DSR^" dsr_w "x" dsr_h
	cmd .= "^-rlst^" reslist
	cmd .= "^-max_4x3_res^" max_w "x" max_h		
	cmd .= "^-dsk^" A_screenwidth "x" A_screenheight

	loop, HKLM, System\CurrentControlSet\Control\Class, 1, 1
	{
		if (A_LoopRegName = "UserModeDriverNameWOw") {
			regread, driver, HKLM, %A_LoopRegSubkey%, %A_loopRegName%		
			break
		} else if (A_LoopRegName = "UserModeDriverName")	
			regread, driver, HKLM, %A_LoopRegSubkey%, %A_loopRegName%		
	} 
	driver := strsplit(driver, "`n")
	for k, v in driver
	{
		if !v
			continue
		h := dllcall("LoadLibraryW", str, v)
		if ! (OpenAdapter := dllcall("GetProcAddress", uint, h, astr, "OpenAdapter"))
			dllcall("FreeLibrary", uint, h)
		else 
			break
	}
	cmd .= "^-D3D_Driver^" v
			
	stringreplace, cmd, cmd, ^, , 0	
	stringreplace, cmd, cmd, p?, %parent%, All	
	stringreplace, cmd, cmd, d?, %A_mydocuments%, All
	stringreplace, cmd, cmd, c?, %A_scriptdir%, All	
	return cmd
}

ParseCommandLine(file="")
{
	file ?: file := GetCommandLineValueB("-f")
	cmd          := GetCmdStringFromFile( file )	
	VarSetCapacity(OSVERSIONINFO, 276)
	numput(276, &OSVERSIONINFO+0)
	dllcall("GetVersionExW", ptr, &OSVERSIONINFO)
	os_version    := numget(&OSVERSIONINFO+4, "int") + numget(&OSVERSIONINFO+8, "int")*0.1
	cmd           .= "^-os_version^" os_version
	OSVERSIONINFO := ""		
	if isobject( (dev := new ini("main.ini")) )
	{
		game := strsplit(file, ".ini")[1]
		stringreplace, game, game, \\, \, All		
		stringreplace, game, game, %A_MyDocuments%\WineHooks\Profiles, ,All
		stringreplace, game, game, \, ,All
		stringreplace, game, game, Scripts, ,All
		stringreplace, game, game, Peixoto, ,All
		stringreplace, game, game, Profiles, ,All
		stringreplace, game, game, User, ,All
		stringreplace, game, game, Dev, ,All		
		devflags := dev.read(game, "devflags")			
		stringreplace, devflags, devflags, `", ^, All
		stringreplace, devflags, devflags, %A_Space%, ^, All
		stringreplace, devflags, devflags, @, %A_Space%, All		
		while instr(devflags, "^^")
			stringreplace, devflags, devflags, ^^, ^, All
		cmd .= "^" devflags			
	}
	; give the cosole window focus and wait a bit or getkeystate fails on linux
	print("....")
	sleep, 100
	if getkeystate("ctrl", "p") 
	{
		stringreplace, cmd, cmd, -!, -
		stringreplace, cmd, cmd, /!, /
	}
	if getkeystate("alt", "p")
	{
		stringreplace, cmd, cmd, -?, -
		stringreplace, cmd, cmd, /?, /
	}
	if getkeystate("shift", "p") 
	{
		stringreplace, cmd, cmd, -#, -
		stringreplace, cmd, cmd, /#, /
	}
	if getkeystate("ins", "p")
	{
		stringreplace, cmd, cmd, -@, -
		stringreplace, cmd, cmd, /@, /
	}
	_cmd := strsplit(cmd, "^")		
	cfg  := {}
	for k, v in _cmd
	{
		Key := SubStr(v, 1, 1)
		if (Key = "-")
			cfg[SubStr(v, 2, strlen(v)-1)] := _cmd[k + 1]	
		else if (Key = "/")
			cfg[SubStr(v, 2, strlen(v)-1)] := True
	}
    if (cfg.saves = "CODEX")
        cfg.saves := "fldrs"
	if not cfg.target 
		quit("No target supplied!")
	target := cfg.target
	splitpath, target, target_name, dir 
	cfg.target_dir   := dir
	cfg.target_name  := target_name
	cmd .= "^-target_dir^" dir
	cmd .= "^-target_name^" target_name
    cfg.layer := new ini("main.ini").read("ddrawlayer")
    if (cfg.layer)
        cmd .= "^-layer^1"
	cfg.wine  := new ini("main.ini").read("wine")
	cfg.dxvkv := new ini("main.ini").read("dxvkv")
    if (cfg.wine)
        cmd .= "^-wine^" . cfg.wine
	if (cfg.dxvkv)
        cmd .= "^-dxvkv^" . cfg.dxvkv
    cfg.common_path := new ini("main.ini").read("common_path")
    if (cfg.common_path)
        cmd .= "^-common_path^1"
	cfg.cmdstring    := cmd
	cfg.console_icon := {"h" : 0, "w" : 0, "pitch" : 0}    
    ;ClearNVAPIProfile(cfg)
	return cfg
}

Parsecfg(item)
{
	c := {}
	for k, v in strsplit(item, ";")
	{
		split := strsplit(v, "=")
		key   := split[1]
		val   := split[2]
		if not split[2]
		{
			continue
		}
		(val = "True")  ? val := True
		(val = "False") ? val := False
		c[key] := val			
	}
	return c		
}	

quit(msg)
{
	msgbox, 16, , % msg
	ExitApp
}

Receive_WM_COPYDATA(wParam, lParam)
{	
	StringAddress := NumGet(lParam + 2*A_PtrSize)  
    CopyOfData := StrGet(StringAddress)
	if isfunc(CopyOfData)
		%CopyOfData%()
	return True
}

EnumIcons(Filename, Type=14)
{
    hModule := DllCall("LoadLibraryW", "str", Filename)
	enumproc := RegisterCallback("EnumIconsCallback","F")	
	       
    DllCall("EnumResourceNamesW", "uint", hModule, "uint", Type, "uint", enumproc, "uint", hModule) 
    DllCall("GlobalFree", "uint", enumproc)    
    DllCall("FreeLibrary", "uint", hModule)	
    return NumGet(param,4)
}

EnumIconsCallback(hModule, lpszType, lpszName, lParam)
{
	critical
	static ICONINFO="", BITMAP="", pass=0 
	pass+=1
	ICONINFO ?: VarSetCapacity(ICONINFO, 20)
	BITMAP ?: VarSetCapacity(ICONINFO, 28)
	hIcon := dllcall("LoadImageW", uint, lParam, "uint", lpszName, int, 1, int, 0, int, 0, uint, 0x00000040)
	dllcall("GetIconInfo", uint, hIcon, ptr, &ICONINFO)
	dllcall("GetObject", uint, numget(&ICONINFO+16, "uint"), uint, 28, ptr, &BITMAP)
	
	if g_.icon
	{
		if (g_.icon = pass)
			g_.console_icon := {"h" : hIcon, "w" : numget(&BITMAP+4, "uint"), "pitch" : numget(&BITMAP+12, "uint")}
		else dllcall("DestroyIcon", uint, hIcon)
		return true
	}
	
	if (numget(&BITMAP+4, "uint") >= g_.console_icon.w) and (numget(&BITMAP+12, "uint") >= g_.console_icon.pitch)
	{
		fileappend, updating `n, *
		if g_.console_icon.h 
		{
			dllcall("DestroyIcon", uint, g_.console_icon.h)
			fileappend, destroying `n, *
		}
		g_.console_icon := {"h" : hIcon, "w" : numget(&BITMAP+4, "uint"), "pitch" : numget(&BITMAP+12, "uint")}
	} else dllcall("DestroyIcon", uint, hIcon)	
	fileappend, % numget(&BITMAP+4, "uint") " x " numget(&BITMAP+8, "uint") " x " numget(&BITMAP+12, "uint")  "`n" , *	
	return true
}	

FileRemoveLink(lnk)
{
	static FILE_ATTRIBUTE_REPARSE_POINT := 1024
	attributes := dllcall("GetFileAttributesW", str, "savedat1.dat", uint)
	if not attributes & FILE_ATTRIBUTE_REPARSE_POINT
		return
	FileDelete, %lnk%
}

GetMods(dir)
{
	static mods := ""
	modslst := []
	names   := []
	loop, Files, %dir%\*.*, D
	{
		modslst.insert(A_loopfilefullpath)
		names.insert(A_loopfilename)
	}
	
	mods := ""
	gui, new
	gui, +hwndThisWindow
	gui, -SysMenu 
	maxxx := 0
	maxhh := 0
	hwnds := {}
	n_cols := modslst._MaxIndex() > 25 ? 15 : round(Sqrt(modslst._MaxIndex())) 
	for k, v in names
	{
		state := instr(current, path "\" v)		
		if !Mod(k-1, 20) 
			gui, add, checkbox, ym hwndhwnd gboxes checked%state%, %v%		
		else gui, add, checkbox, hwndhwnd gboxes checked%state%, %v%
		guicontrolget, pos, pos, %hwnd%
		if (posx+posw > maxx)
		{
			maxx  := posx+posw 
			maxxx := posx + posw + 25
		}
		if (posy+posh > maxy)
		{
			maxy  := posy+posh 
			maxhh := posy + posh + 25
		}
		hwnds[hwnd] := modslst[k]
	}
	state := instr(current, "?")		
	gui, add, button, y%maxhh% x%maxxx% w80 h30, Cancel
	gui, add, button, x+5 w80 h30, OK

	gui, show
	WinWaitClose, ahk_id %ThisWindow%
	return mods 
		
	boxes:
		van := hwnds["Vanilla"] 
		guicontrolget, state, ,%van%	
		if (state = 1)
		{
			for k, v in hwnds
			{
				guicontrol, ,%k%, 0
				guicontrol, disable ,%k%				
			}
		guicontrol, ,%van%, 1	
		guicontrol, enable ,%van%		
		}else {	
			for k, v in hwnds
				guicontrol, enable ,%k%				
		}			
	return
	
	guiclose:
		gui, %ThisWindow%: destroy
		exitapp
	return
	
	buttonCancel:
		gui, %ThisWindow%: destroy
		exitapp
	return	
	
	buttonok:	
		for k, v in hwnds
		{
			guicontrolget, state, ,%k% 
			state ? mods .=	";" v 
		}
		stringreplace, mods, mods, `;, ,
		gui, %ThisWindow%: destroy
	return		
}

D3D9_EnumDisplayModes()
{
	VarSetCapacity(SysDir, 261*2)
	DllCall("GetSystemDirectoryW", Str, SysDir, uint, 261*2)
		
	hModule         := dllcall("LoadLibraryW", str, SysDir "\D3D9.dll", ptr)
	Direct3DCreate9 := dllcall("GetProcAddress", uint, hModule, astr, "Direct3DCreate9", ptr)
		
	if ( (! hModule) or (! Direct3DCreate9) )
		return "Failed to get the entry point of the Direct3DCreate9 procedure or get the handle to d3D9.dll " A_lasterror

	p_D3D9 := dllcall(Direct3DCreate9, uint, 32)
	if (!p_D3D9)
	return "Failed to create the Direct3D9 Device " A_lasterror

	VarSetCapacity(dm, 16)
	mode  := 0
	modes := []
	while(dllcall(numget(numget(p_D3D9+0, "ptr")+A_PtrSize*7, "ptr"), ptr, p_D3D9, uint, 0, uint, 22, uint, mode, ptr, &dm, uint) = 0)
	{
		modes.Insert({"w" : numget(&dm, "uint"), "h" : numget(&dm+4, "uint")})		
		mode += 1
	}
	dllcall(numget(numget(p_D3D9+0, "ptr")+A_PtrSize*2, "ptr"), ptr, p_D3D9)
	return modes
}

ClearNVAPIProfile(cfg)
{
    dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
    dllcall("LoadLibraryW", str, dll)
    dllcall(dll "\NVIDIA_Set", wstr, cfg.target, uint, 0)
}