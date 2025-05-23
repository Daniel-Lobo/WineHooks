#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory. 
Menu, Tray, Icon, img\favicon.ico

dllcall("AllocConsole")
print(msg){
    FileOpen("*", "w").write(msg "`n")
}

GetCommonPath( csidl )
{
	CSIDL_APPDATA = 0x001A               ; Application Data, new for NT4
	CSIDL_COMMON_APPDATA = 0x0023        ; All Users\Application Data
	CSIDL_COMMON_DOCUMENTS = 0x002e      ; All Users\Documents
	CSIDL_DESKTOP = 0x0010               ; C:\Documents and Settings\username\Desktop
	CSIDL_FONTS = 0x0014                 ; C:\Windows\Fonts
	CSIDL_LOCAL_APPDATA = 0x001C         ; non roaming, user\Local Settings\Application Data
	CSIDL_MYMUSIC = 0x000d               ; "My Music" folder
	CSIDL_MYPICTURES = 0x0027            ; My Pictures, new for Win2K
	CSIDL_PERSONAL = 0x0005              ; My Documents
	CSIDL_PROGRAM_FILES_COMMON = 0x002b  ; C:\Program Files\Common
	CSIDL_PROGRAM_FILES = 0x0026         ; C:\Program Files
	CSIDL_PROGRAMS = 0x0002              ; C:\Documents and Settings\username\Start Menu\Programs
	CSIDL_RESOURCES = 0x0038             ; %windir%\Resources\, For theme and other windows resources.
	CSIDL_STARTMENU = 0x000b             ; C:\Documents and Settings\username\Start Menu
	CSIDL_STARTUP = 0x0007               ; C:\Documents and Settings\username\Start Menu\Programs\Startup.
	CSIDL_SYSTEM = 0x0025                ; GetSystemDirectory()
	CSIDL_WINDOWS = 0x0024               ; GetWindowsDirectory()
	
	val = % CSIDL_%csidl%
	SHGetFolderPath := A_IsUnicode ? "shell32\SHGetFolderPath" : "shell32\SHGetFolderPathA"
	VarSetCapacity(fpath, A_IsUnicode ? 260 * 2 : 260)
	DllCall(SHGetFolderPath, uint, 0, int, val, uint, 0, int, 0, str, fpath)
	return %fpath%
}

class IniFile {
    __new(path){
		this.__path  := path
        this.__text  := FileOpen(path, 4).read()
        this.__Lines := []
        section      := ""
        for n, line in strsplit(this.__text, "`n"){                      
            if (S(line).StartsWith("[") and S(line).EndsWith("]")){
                section   := substr(line, 2, -1)
                line_desc := {"Type" : "SectionHead", "Content" : line}
                this.__Lines.Push(line_desc)
            } else if (StrSplit(line, "=").length() >= 2) {                
                split     := StrSplit(line, "=", ,2)
                line_desc := {"Type" : "KeyVal", "Key" : split[1], "Value" : split[2], "Section" : section}
                this.__Lines.Push(line_desc)
            } else {
                line_desc := {"Type" : "Comment", "Content" : line}
                this.__Lines.Push(line_desc)
            }
        }
    }
	GetFilePath(){
		return this.__path
	}
    Print() {
        for n, line in this.__Lines {
            desc := ""
            for k, v in line{
                desc .= k ":" v " "
            }
            print(desc)
        }
    }
    Get(key, section="") {
        for n, line in this.__Lines {           
            if (line["Type"] = "KeyVal" and line["Key"] = key and line["Section"] = section)
            return line["Value"]             
        }
        return ""
    }
	HasSection(section){
		if (section = "")
		return true	
		for n, line in this.__Lines{			
            if (line["Type"] = "SectionHead"){	
				if (section = StrReplace(StrReplace(line["Content"], "[", ""), "]", ""))
				return true
			}	
		}
		return False
	}
    IsTrue(key, section=""){
        val := this.Get(key, section)
		return  val = "true" or val = true or val = "1" ? true : false       
    }
	Add(key, val, section=""){
		print(key " " val " " section " " this.HasSection(section))
		if (this.HasSection(section) = False){			
			this.__Lines.push({"Type" : "SectionHead", "Content" : "[" section "]"})
		}
		new_line     := {"Type" : "KeyVal", "Key" : key, "Value" : val, "Section" : section}
		curr_section := ""
		for n, line in this.__Lines{			
            if (line["Type"] = "SectionHead"){								
                if (curr_section = section){
					this.__Lines.InsertAt(n-1, new_line)				
				}
				curr_section := StrReplace(StrReplace(line["Content"], "[", ""), "]", "")				
            }
        }		
		if (curr_section = section) ; it was the last section
			this.__Lines.push(new_line)
        return this
	}
    Edit(key, val, section=""){		
        for n, line in this.__Lines{			
            if ((line["Type"] = "KeyVal") and (line["Key"] = key) and (line["Section"] = section)){				
                this.__Lines[n]["Value"] := val
                return this
            }
        }
		return this.Add(key, val, section)
        ;return this
    }
    EditBoolean(key, val, section=""){
        return this.Edit(key, val ? "true" : "false", section)
    }
	Save(){
		text := ""
		for n, line in this.__Lines{
			if (line["type"] = "KeyVal")
				text .= "`n" line["Key"] "=" line["Value"]
			else
				text .= "`n" line["Content"]
		}
		FileOpen(this.__path , "w").write(trim(text, "`n"))
	}
}
class IniString Extends IniFile {
	__new(str) {	
		this.__text  := str
		this.__Lines := []
		section      := ""
		for n, line in strsplit(this.__text, "`n"){                      
			if (S(line).StartsWith("[") and S(line).EndsWith("]")){
				section   := substr(line, 2, -1)
				line_desc := {"Type" : "SectionHead", "Content" : line}
				this.__Lines.Push(line_desc)
			} else if (StrSplit(line, "=").length() >= 2) {                
				split     := StrSplit(line, "=", ,2)
				line_desc := {"Type" : "KeyVal", "Key" : split[1], "Value" : split[2], "Section" : section}
				this.__Lines.Push(line_desc)
			} else {
				line_desc := {"Type" : "Comment", "Content" : line}
				this.__Lines.Push(line_desc)
			}
		}
	}
	Save(){
		return
	}
}

global g_ = {"p_send" : 0, "games_list" : []
,"BasePath"        : A_mydocuments "\WineHooks\"
,"HelpPath"        : A_mydocuments "\WineHooks\Help\"
,"CheatTablesPath" : A_mydocuments "\WineHooks\CheatTables\"
,"Profiles"        : A_mydocuments "\WineHooks\Profiles\"
,"URLScapeCodes"   : {"%20" : " ", "%21" : "!", "%22" : """", "%23" : "#", "%24" : "$"
	, "%25" : "%", "%26" : "&", "%27" : "'", "%28" : "(", "%29" : ")"
	, "%2A" : "*", "%2B" : "+", "%2C" : ",", "%2D" : "-", "%2E" : "."
	, "%2F" : "/", "%3A" : ":", "%3B" : ";", "%3C" : "<", "%3D" : "="
	, "%3E" : ">", "%3F" : "?", "%40" : "@", "%5B" : "[", "%5C" : "\"
	, "%5D" : "]", "%5E" : "^", "%5F" : "_", "%60" : "`", "%7B" : "{"
	, "%7C" : "|", "%7D" : "}", "%7E" : "~", "%09" : "`t"}} 

g_.Links :=  {"Donate"   : "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=E68RE3UWG2ZEU&lc=US&"
    . "item_name=Peixoto&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted"
    , "Peixoto"      : "http://www.vogons.org/viewtopic.php?f=24&t=53121"
    , "cheat"        : "https://www.cheatengine.org/"
    , "patreon_home" : "https://www.patreon.com/user/about?u=44312848"
    , "Archive"      : "https://github.com/Daniel-Lobo/WineHooks/releases"
    , "Wine"         : "https://www.winehq.org/"
	, "winecfg"      : "https://gitlab.winehq.org/wine/wine/-/wikis/Commands/winecfg"
    , "dxvk"         : "https://github.com/doitsujin/dxvk/releases"
	, "old_version_redirect" : "https://github.com/Daniel-Lobo/WineHooks/releases"
	, "winwhooks_git"        : "https://github.com/Daniel-Lobo/WineHooks"
	, "winwhooks_updatehistory" : "https://daniel-lobo.github.io/"}

ReverseString(Str) {
    nStr := ""
    Loop, Parse, Str
        nStr=%A_LoopField%%nStr%
    Return nStr
}  
StartsWith(this, needle){
    return InStr(this.__str, needle) = 1 ? true: false
}
EndsWith(this, needle){
    return InStr(ReverseString(this.__str), ReverseString(needle)) = 1 ? true: false
}
S(s){
    srt := {"__str" : s, "StartsWith" : Func("StartsWith"), "EndsWith" : Func("EndsWith")}
    return srt
}

BuidGamesList(){	
    g_.games_list := []
    loop, % g_.BasePath "Profiles\*.*" 
        g_.games_list.Insert(StrReplace(A_loopfilename, ".ini", ""))    	
}

GetGamesList(){
    BuidGamesList()
    list := "["
    for k, game in g_.games_list{
        list .= "," """" game """"
    }
    list  := StrReplace(list, "[,", "[") . "]"        
    return "{""Games"" : " list "}"	
}

serve(){
    h_peixoto := DllCall("LoadLibrary", str, "..\peixoto.dll", ptr)
    p_Serve   := DllCall("GetProcAddress", ptr, h_peixoto, astr, "Serve")
    h_Ws2_32  := DllCall("LoadLibrary", str, "Ws2_32.dll", ptr)
    g_["p_send"] := DllCall("GetProcAddress", ptr, h_Ws2_32, astr, "send")
    ;print(h_Ws2_32 " " p_send)
    dllcall(p_Serve, ptr, RegisterCallback("GetHandler"), ptr, RegisterCallback("PostHandler"))    
}

LoadFile(filename){
    html := StrReplace(FileOpen("html\" Filename ".html", "r").read(), "%My Documents%", A_mydocuments)
    html := StrReplace(html, "%BasePath%", SubStr(g_.BasePath, 1,-1))
    html := StrReplace(html, "%HelpPath%", Substr(g_.HelpPath, 1,-1))
    html := StrReplace(html, "%ProfilesPath%", SubStr(g_.Profiles, 1,-1))
    return html
}

HTMLReply(html){
    reply := "HTTP/1.1 200 OK`r`nContent-Type: text/html`r`nContent-Length: " . strlen(html) . "`r`n`r`n"   
    return reply . html
}

PlainReply(txt){
    reply := "HTTP/1.1 200 OK`r`nContent-Type: text/plain`r`nContent-Length: " . strlen(txt) . "`r`n`r`n"   
    return reply . txt
}

ScapeUrlString(url){
	_raw := url
	;needs to be twice to remove scape sequences like %2520
	for scape, char in g_.URLScapeCodes {
		url := StrReplace(url, scape, char)
	}
	for scape, char in g_.URLScapeCodes {
		url := StrReplace(url, scape, char)
	}
	;print("raw " _raw)
	;print("url " url)
	return url
}

GetArgs(args){
    args := StrGet(args+0, ,"CP0")
	;args := ScapeUrlString(args)
    ;print("args " args)
    ret  := {}
    for _, arg in StrSplit(args, "&")
    {
        split := StrSplit(arg, "=")
        if (split.Length() >= 2)
        {		
            ret[ScapeUrlString(split[1])] := ScapeUrlString(split[2])
        } 
    }
    ;for key, val in ret
        ;print(key " = " val)
    return ret
}

Image(socket, path){
    file:= "img" . StrReplace(path, "/png", "")
    ext := SubStr(file, -2)
    if (ext = "svg")
        ext .= "+xml"
    else if (ext = "ico")
        ext .= "x-icon"
    print(file)
    file   := FileOpen(file, "r")    
    header := "HTTP/1.1 200 OK`r`nContent-Type: image/" . ext . "`r`nContent-Length: " . file.Length() . "`r`n`r`n"
    file.RawRead(bin:=0, file.Length())    
    DllCall(g_.p_send, uint, socket, astr, header, uint, strlen(header), uint, 0, uint) 
    DllCall(g_.p_send, uint, socket, ptr, &bin, uint, file.Length(), uint, 0, uint) 
}

CSS(socket, path){
    file   := "css" . path    
    file   := FileOpen(file, "r")    
    css    := file.Read()    
    reply  := "HTTP/1.1 200 OK`r`nContent-Type: text/css`r`nContent-Length: " . strlen(css) . "`r`n`r`n" . css  
    ;print( reply )
    DllCall(g_.p_send, uint, socket, astr, reply, uint, StrLen(reply), uint, 0, uint) 
}

RootRoute(){
    home_html         := StrReplace(LoadFile("base"), "{home}", LoadFile("home"))
    home_html         := StrReplace(home_html, "{config-ini}", LoadFile("config-ini"))
    home_html         := StrReplace(home_html, "{game-page-renderer}", LoadFile("game-page-renderer"))
    games_list_loader := LoadFile("games-list-loader")
    return StrReplace(home_html, "{games-list}", games_list_loader)
}

HomeRoute(){
    if (g_.games_list.Length() = 0)
    BuidGamesList()    
    home_html           := StrReplace(LoadFile("base"), "{home}", LoadFile("home"))
    home_html           := StrReplace(home_html, "{config-ini}", LoadFile("config-ini"))
    home_html           := StrReplace(home_html, "{game-page-renderer}", LoadFile("game-page-renderer"))
    games_list_template := LoadFile("games-list")
    games_list          := ""
    for _, game in g_.games_list {
        html = 
        (LTRIM
            <button type="button"  onclick="RenderGamePage(this);" class="btn btn-light nav-item-container" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-title="%game%">
				<span class='nav-item nav-item-container'>  %game% </span>
			</button>   
        )        
        games_list .= html
    }
    games_list_template := StrReplace(games_list_template, "{games-list}", games_list)
    return StrReplace(home_html, "{games-list}", games_list_template)
}

GetHandler(socket, p, a){    
    print("GetHandler: " strGet(p+0, ,"CP0"))
    path := S(StrGet(p+0, ,"CP0"))       
    ext  := SubStr(path.__str, -3, 4)
    if InStr(".png .jpg .ico .svg", ext)
    return Image(socket, path.__str)
    else if (ext = ".css")
    return CSS(socket, path.__str)    

    args  := GetArgs(a)  
    reply := HTMLReply("<div>Not Found</div>")    
    if (path.__str = "/")
        reply := HTMLReply(RootRoute())
    else if (path.__str = "/home")
        reply := HTMLReply(HomeRoute())
      
    
    DllCall(g_.p_send, uint, socket, astr, reply, uint, strlen(reply), uint, 0, uint) 
}

JSONReply(reply){
    return "HTTP/1.1 200 OK`r`nContent-Type: application/json`r`nContent-Length: " . strlen(reply) . "`r`n`r`n" . reply 
}

Runscript(script){	
	path       := FileExist(path := "..\AutoHotkey.dll") ? path : A_mydocuments "\AutoHotkey\dlls\AutoHotkey.dll"
	ahktextdll := dllcall("GetProcAddress", uint, dllcall("LoadLibraryW", str, path), astr, "ahktextdll")
	hThread    := dllcall(ahktextdll, Str, fileopen("lib.txt", "r").read() "`n" script, Str, "", Str, "", "Cdecl UPTR")
	dllcall("WaitForSingleObject", "ptr", hThread, "uint", 0xffffffff)
}

SetDeviceGammaRamp(brightness, ramp=1.0){
	(brightness > 256) ? brightness := 256
	(brightness < 0) ? brightness := 0
	VarSetCapacity(gr, 512*3)
	x := 1/ramp
	Loop, 256
	{
		(nValue:=(brightness+128)*(A_Index-1))>65535 ? nValue:=65535
		nValue := (nValue**x/65535**x)*65535
		NumPut(nValue, gr,      2*(A_Index-1), "Ushort")
		NumPut(nValue, gr,  512+2*(A_Index-1), "Ushort")
		NumPut(nValue, gr, 1024+2*(A_Index-1), "Ushort")
	}
	hDC := DllCall("GetDC", "Uint", A_scripthwnd)
	DllCall("SetDeviceGammaRamp", "Uint", hDC, "Uint", &gr)
	DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
}

CloneDir(Template, Clone)
{
	FileCreateDir, %Clone%\
	loop, %Template%*.*, 1, 1
	{
		lnk := StrReplace(A_LoopFileFullPath, Template, Clone)		
		if InStr(FileExist(A_LoopFileFullPath), "D")  
		{
			FileCreateDir, %lnk%\
			msg := "Createdir " lnk " " A_lasterror "`n"
		}		
		else 
		{
			msg     := "Create link : " lnk "`nto          : " A_LoopFileFullPath "`n"
			;success := dllcall("CreateSymbolicLinkW", str, lnk, str, A_LoopFileFullPath, uint, 0) || ErrorLevel
			;if (!success)
			;{
				;MsgBox % errorlevel " " A_LastError
			;}
			FileCopy, %A_LoopFileFullPath%, %lnk%, 1
		}
		print(msg " success: ")		
	}	
	;msgbox
}

InstallShideldInstall(v)
	{
		FileRemoveDir, %A_Temp%\InstallShield v3, 1
		FileRemoveDir, %A_Temp%\InstallShield v5, 1
		
		msg = 
		(LTRIM
		You will  now  be asked to point to the 16 bit setup
		program in the game's CD ROM. 
		
		This is usually named: "setup.exe"
		
		If you left click that file to examine its properties, you 
		will see in the details tab:
		
		Product name: InstallShield		
		)
		msgbox, 64, ,% msg		
		FileSelectFile, setup, 3, c:\, Please select the 16-bit setup executable file, *.exe
		if !setup
		return
		SplitPath, setup, ,dir , , ,Drv
		FileGetAttrib, att, %setup%
		setup_temp := StrReplace(dir, Drv, A_Temp "\InstallShield v" v)
		read_only  := instr(att, "R") ? "Yes" : "No"  
		Drv_type   := "DRIVE_UNKNOWN DRIVE_NO_ROOT_DIR DRIVE_REMOVABLE DRIVE_FIXED DRIVE_REMOTE DRIVE_CDROM DRIVE_RAMDISK"
		Drv_type   := strsplit(Drv_type, " ")[dllcall("GetDriveTypeA", astr, Drv "\", uint)+1]
		msg= 
		(LTRIM
		Setup File : %setup%
		Read Only  : %read_only%
		Drive      : %Drv%
		Type       : %Drv_type% 	
		New Path   : %setup_temp%`n
		)	
		print(msg)
		
		if (dllcall("GetDriveTypeA", astr, Drv "\", uint) != 5)
		{
			msgbox, 16, ,Drive: %Drv%\ is not a CDRom Drive
			return	
		}
		
		if (!instr(att, "R"))
		{
			msgbox, 16, ,File: "%setup%\" is not Read Only
			return	
		}	
		
			
		Progress, w200 h50 FS16 M C0 zh0, ,Creating symbolic links
		CloneDir(Drv "\", A_Temp "\InstallShield v" v "\")
		Progress, off
		;dllcall("FreeConsole")
		filecopy, ..\InstallShield\setupv%v%.exe, %setup_temp%\setupv%v%.exe 
		
		ini :=  new IniFile("..\InstallShield\InstallShield.ini")
		ini.edit("target", setup_temp "\setupv" v ".exe")
		ini.edit("drive", Drv)
		ini.edit("tempdir", A_Temp "\InstallShield v" v "\")		
		if (v=3)
		msgbox, 36, ,Set Windows 95 compatibility ?
		else 
		msgbox, 36, ,Set Windows 98 compatibility ?	
		IfMsgBox, yes
		ini.edit("compatlayer", v = 3 ? "win95" : "win98")	
		else ini.edit("compatlayer", "HIGHDPIAWARE")		
		ini.save()
		
		
		;run ..\Injector.exe -f InstallShield\InstallShield.ini, ..\
		;run InstallShield.bat
		;runwait, ..\injector.exe src\injector.txt -f InstallShield\InstallShield.ini, ..\
		run, Server.exe InstallShield.ahk %v%		
		ExitApp
		return
	}

HandleAction(action){	
    if (link := g_.Links[action]){
        if (Instr(action, "script")){
			return RunScript(link)
		}
        run, %link%    
        return
    }
	else if (RegExMatch(action, "[A-Za-z]:\\")){
		if (!FileExist(action)){
			MsgBox, 64, ,%action%`ndoesn't exist`nMake sure you start the game once with WineHooks
			return
		}		
	} 	
	else if (action = "gammatool"){
		return SetDeviceGammaRamp(128, 1)
	}
	else if S(action).StartsWith("InstallShield"){
		version := StrReplace(action, "InstallShield", "")
		return InstallShideldInstall(version)
	}
	print(RegExMatch(action, "[A-Z]:\\"))
    print(action)
    run, %action%
}

GetHelpFileName(profile_name){
	cfg    := new IniFile(g_.BasePath . profile_name)
    help   := trim(cfg.Get("Help"))
	print(g_.BasePath . profile_name . " " . help)
	ignore := {"ddraw" : True, "directdraw" : True, "gl" : True, "DX8" : True, "DX9" : True, "DX10" : True, "DX11" : True, "DX12" : True, "CPU" : True, "Sound" : True, "Input" : True}
	if not InStr(help, ".") and not ignore[help]
		return help ".txt"
	return ""	
}

GetCheatTableName(name){
	for kk, vv in StrSplit("OpenGl D3D7 D3D8 D3D9 D3D10 D3D11 D3D12 GOG DirectDraw DX6 Software Hardware", " ") {
		name := StrReplace(name, " - " vv, "")	
	}
	return trim(StrReplace(name, ".ini", ".ct"))
}

GetCheatTablePath(name){		
	for kk, vv in StrSplit("OpenGl D3D7 D3D8 D3D9 D3D10 D3D11 D3D12 GOG DirectDraw DX6 Software Hardware", " ")
	name := StrReplace(name, " - " vv, "")	
	path := g_.CheatTablesPath name ".ct"	
	return fileexist(path) ? path : ""	
}

GetScriptFileName(cfg){	
	script := new IniString(cfg).Get("script")	
	if InStr(script, "\") {
		split  := StrSplit(script, "\")
		script := split[ split.Length() ]
	}
	return trim(script)
}

GetGitProfilesList(){
    url := "https://api.github.com/repos/Daniel-Lobo/WineHooks/contents/"		
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", url . "Profiles", true)			
    whr.SetRequestHeader("Accept", "application/vnd.github.v3.raw")		
    whr.Send()
    whr.WaitForResponse()
    profiles := whr.ResponseText . ""		
    whr.Open("GET", url . "Help", true)		
    whr.Send()
    whr.WaitForResponse()
    help     := whr.ResponseText . ""	
    whr.Open("GET", url . "CheatTables", true)		
    whr.Send()
    whr.WaitForResponse()
    tables   := whr.ResponseText . ""
    whr.Open("GET", url . "Scripts", true)		
    whr.Send()
    whr.WaitForResponse()
    scripts   := whr.ResponseText . ""
    ;print(profiles " " help " " tables " " scripts)
    return JSONReply("{""Profiles"" : " . profiles . ", ""Help"" : " . help . ", ""CheatTables"" : " . tables . ", ""Scripts"" : " . scripts . "}")    	
}

SaveFile(file_name, contents){	
	try {
        print(file_name)
        ;print(contents)
		FileOpen(g_.BasePath . file_name, "w").write(contents)
        ;print("saved " . file_name)
        ;print(contents)
        ;Sleep, 1000
        Return JSONReply("{""Err"" : ""S_OK""}")
    } catch {
        Return JSONReply("{""Err"" : ""Error saving file""}")
    }
}

FindGame(){
   	FileSelectFile, newtarget, Options, , , (*.exe)
	Return newtarget
}

ReadFile(path){
    ; 4:= read and replace \n\r with \n
    return FileOpen(path, 4).read()
}

ProcessHelpDocument(txt, wip=False) {
    if (InStr(txt, "::Title::")) {
        txt := "::Title::" . StrSplit(txt, "::Title::")[2]
    }
	for k, v in {"DX9SSAA" : "DX9", "DX8HDSA" : "DX8", "glSSAA" : "gl", "DX11FSR" : "DX11", "DX12FSR" : "DX12"
			,"DX11CE"  : "DX11", "DX9CE"  : "DX9"} 
	{
		if (txt = k)	
		{		
			txt := "::Title::user::{h1 Fixes and improvements}`n" 
			if (instr(k, "SSAA") && (instr(k, "9") || instr(k, "8") || instr(k, "gl")))
			{
				txt .= "{i [gototab_graphics_HD Forced resolution], while not absolutely necessary"
				. "  on this game, allows a<gototab_graphics_SSAA -- super sampling anti aliasing>a}"
			}
			if (instr(k, "HDSA") && (instr(k, "9") || instr(k, "8") || instr(k, "gl")))
			{
				txt .= "{i [gototab_graphics_HD Forced resolution] allows hight resolution " 
				. "without shrinking the HUD\menus and [gototab_...graphics_SSAA super "
				. " sampling anti aliasing]}"  
			}
			if (instr(k, "CE"))
			{
				txt .= "{ce [show_ce_div Cheats]}" 
			}
			if (instr(k, "FSR"))
			{
				txt .= "{i [gototab_graphics_HD FidelityFx super resolution] upscaling}" 
			}
			txt  .= "%" v "%"								
		}
	}	
	
	for k, v in ["ddraw", "directdraw", "gl", "DX8", "DX9", "DX10","DX11", "DX12", "CPU", "Sound", "Input"]  
	{
		if instr(txt, "%" v "%")
		{
			dx  := v = "directdraw" ? ReadFile(g_.HelpPath v "-0.10.18+.txt") : ReadFile(g_.HelpPath v ".txt") 
			dx  := StrReplace(dx, "::Title::user", "")
			txt := StrReplace(txt, "%" v "%", dx)					
		}
	}	
    return txt
}

GetGameHelp(ini_file_name){
    cfg  := new IniFile(g_.Profiles . ini_file_name . ".ini")
    path := trim(cfg.Get("help"))
    path := FileExist(g_.HelpPath path ".txt") ? g_.HelpPath path ".txt" : g_.Profiles "\" path
    path := StrReplace(path, "user\", "")	
    return FileExist(path) ? ReadFile(path) : trim(cfg.Get("help"))
}

GetVal(ini_file_name, key, section){
	val := new IniFile(g_.Profiles . ini_file_name . ".ini").Get(key, section)
	;print("GetVal: " g_.Profiles . ini_file_name . ".ini key : " key " val : " val)	
    return val
}

SetValue(ini_file_name, key, val, section){
	if (ini_file_name = "undefined" or key = "undefined" or val = "undefined" or section = "undefined")
	return
	return new IniFile(g_.Profiles . ini_file_name . ".ini").Edit(key, val, section).Save()
}

IsTrue(ini_file_name, key, section){
    return new IniFile(g_.Profiles . ini_file_name . ".ini").IsTrue(key, section) = true ? "true" : "false"
}

ParseText(txt){
    _MCI =
	(LTRIM
	To get the CD music working properly, check the a|gototab_sound_WNMM.MCI ^ MCI emulation |a option on the 
	a|gototab_sound_WNMM.MCI ^ sound tab |a
	)
	autodmp =
	(
	{b <b>Dumping textures</b>  <br> <br>	

	Manual dumps are impratical for dumping several textures for obvios reazons, plus the fact that there is no check 
	if a texture was already dumped and so one can be dumped many times over <br>	
	Auto dumping in the other hand, never dumps the same texture twice, but for other reazons is still impratical 
	in several games <br>	
	In future versions, a feature to dump all currently loaded texures with a check for duplicates will be added to 
	complement the two curent options}
	)
	autodmp := StrReplace(autodmp, "`n")
	stringreplace, txt, txt, `%_MCI`%, %_MCI%
	txt := StrReplace(txt, "%Xinput%", " Better compatibility with Xinput gamepads, see a|gototab_input_j2k.u ^ this|a")
	txt := StrReplace(txt, "%EAX%", " Restores 3D audio and EAX, see a|gototab_sound_Dsnd.e ^ this|a")
	txt := StrReplace(txt, "`r", "")
	txt := StrReplace(txt, "`n", " ")	
	txt := StrReplace(txt, "\", "&#92;")	
	;txt := StrReplace(txt, "'", "&#96;")
	txt := StrReplace(txt, "||n", "<br><br>")	
	txt := StrReplace(txt, "|n", "<br>")	
	txt := StrReplace(txt, "i|", "<i>")
	txt := StrReplace(txt, "|i", "</i>")
	txt := StrReplace(txt, "b|", "<b>")
	txt := StrReplace(txt, "|b", "</b>")
	txt := StrReplace(txt, ">>n", "<br><br>")	
	txt := StrReplace(txt, ">n", "<br>")		
	;txt := StrReplace(txt, "cc<", "<font color='" g_.color_c "'><b>")
	txt := StrReplace(txt, ">cc", "</b></font>")
	;txt := StrReplace(txt, "c<", "<font color='" g_.color_c "'>")
	txt := StrReplace(txt, ">c", "</font>")
	txt := StrReplace(txt, "a|", "<a id='")
	txt := StrReplace(txt, " ^ ", "' href='javascript:dummy()' onclick='PostActionB(this)'>")
	txt := StrReplace(txt, "|a", "</a>")	
	txt := StrReplace(txt, "l|", "<li>")	
	txt := StrReplace(txt, "<ul>", "<ul style='margin-top:0px;margin-bottom:0px;'>")
	;txt := StrReplace(txt, "%__path__%", this.__path__)
	
	;p := A_mydocuments "\games\" new ini(this.cfg_file).read("path") 
	txt := StrReplace(txt, "<td>", "<td style='vertical-align: top; padding-right: 20px'>")
	txt := RegExReplace(txt, "i<([^>.]*)>i", "<i>$1</i>")	
	txt := RegExReplace(txt, "b<([^>.]*)>b", "<b>$1</b>")	
	txt := RegExReplace(txt, "t<([^>.]*)>t", "<table>$1</table>")				
	txt := RegExReplace(txt, "a<([^>.]*)--([^>.]*)>a", "<a id='$1' href='javascript:dummy()' onclick='PostActionB(this)'>$2</a>")
	StringReplace, txt, txt, `", `',1
	stringreplace, txt, txt, `%ModsLink`%, <a onclick='PostActionB(this)' id='gototab_File System_modstuto' href='javascript:dummy()'>Mods manager</a>
	stringreplace, txt, txt, `%TexturesB`%, <a onclick='PostActionB(this)' id='gototab_graphics..._Textswap.e' href='javascript:dummy()'>Texture swapping</a>
	stringreplace, txt, txt, `%Textures`%, <a onclick='PostActionB(this)' id='gototab_graphics..._Textswap.e' href='javascript:dummy()'>Texture swapping</a>
	stringreplace, txt, txt, `%TexturesC`%, <a onclick='PostActionB(this)' id='gototab_graphics_Textswap.e' href='javascript:dummy()'>Texture swapping</a>
	stringreplace, txt, txt, `%FOLDERID_LocalAppData`%, % GetCommonPath("LOCAL_APPDATA"), All
	stringreplace, txt, txt, `%FOLDERID_RoamingAppData`%, % GetCommonPath("APPDATA"), All
	stringreplace, txt, txt, `%FOLDERID_ProgramData`%, % GetCommonPath("COMMON_APPDATA"), All
	stringreplace, txt, txt, `%FOLDERID_Documents`%, % A_mydocuments, All	
	;stringreplace, txt, txt, `%smallres`%, <b>%g_smallres%</b>, All
	;stringreplace, txt, txt, `%path`%, <b>%p%</b>, All
	;stringreplace, txt, txt, `%verysmallres`%, <b>%g_verysmallres%</b>, Al ;g_verysmallres not 'defined'
	txt := StrReplace(txt, "\", "\\")
	txt := StrReplace(txt, "%autodmp%", autodmp)
	
	txt := StrReplace(txt, "{f}", "<img width='20px'; height='20px'; src='fix.svg';></img>")
	txt := StrReplace(txt, "{nfo}", "<img width='20px'; height='20px'; src='nfo.svg';></img>")
	txt := StrReplace(txt, "{i}", "<img width='20px'; height='20px'; src='star.svg';></img>")
	txt := StrReplace(txt, "{bad}", "<img width='20px'; height='20px'; src='bad.svg';></img>")		
	txt := RegExReplace(txt, "s)==\[([^=]*)\]==", "<div class='center'><b>$1</b></div><br><br>" )	
	txt := RegExReplace(txt, "s)=\[([^=]*)\]=", "<b>$1</b>" )	
	txt := RegExReplace(txt, "s)-\[([^-]*)\]-", "<i>$1</i>" )	
	txt := RegExReplace(txt, "s)\[([^]\s]*)\s([^]]*)\]", "<a id='$1' href='javascript:dummy()' onclick='PostActionB(this)'>$2</a>" )	
	fix =
	(LTRIM
	<div style='display:flex;margin-left:40px'>
		<div style="color:transparent;text-shadow:0 0 0 darkblue;font-size:24px;font-weight:normal;margin-top:-8px;margin-right:4px">🛠️</div>
		<div>$1</div>
	</div>	
	)
	imp =
	(LTRIM
	<div style='display:flex;margin-left:40px'>
		<div style="color:transparent;text-shadow:0 0 0 #1ab288;font-size:24px;margin-top:-8px;margin-right:4px">&#x1F44D</div>
		<div>$1</div>
	</div>	
	)
	nfo =
	(LTRIM
	<div style='display:flex;margin-left:40px'>
		<div style="font-size:24px;margin-top:-8px;margin-right:4px"><i class="fa-solid fa-info"></i></div>
		<div>$1</div>
	</div>	
	)
	bad =
	(LTRIM
	<div style='display:flex;margin-left:40px'>
		<div style="color:transparent;text-shadow:0 0 0 #b00111;font-size:24px;margin-top:-4px;margin-right:4px">&#x1F44E</div>
		<div>$1</div>
	</div>
	)
	ce =
	(LTRIM
	<dd><div class='fix-master'>
		<div class='ce-icon'></div>
		<div class='fix-text'>$1</div>
	</div></dd>
	)
	linux =
	(LTRIM
	<div style='display:flex;'>
		<div style='margin-right:2px'><img src='linux.svg' width='18px' height='18px'></img></div>
		<div>$1</div>
	</div>
	)
	win =
	(LTRIM
	<div style='display:flex;'>
		<div style='margin-right:2px'><img src='windows.svg' width='18px' height='18px'></img></div>
		<div>$1</div>
	</div>
	)
	txt :=  RegExReplace(txt, "s){lnx\s([^}]*)}", StrReplace(linux, "`n", "") )	
	txt :=  RegExReplace(txt, "s){win\s([^}]*)}", StrReplace(win, "`n", "") )	
	txt :=  RegExReplace(txt, "s){f\s([^}]*)}", StrReplace(fix, "`n", "") )	
	txt :=  RegExReplace(txt, "s){i\s([^}]*)}", StrReplace(imp, "`n", "") )	
	txt :=  RegExReplace(txt, "s){nfo\s([^}]*)}", StrReplace(nfo, "`n", "") )	
	txt :=  RegExReplace(txt, "s){bad\s([^}]*)}", StrReplace(bad, "`n", "") )	
	txt :=  RegExReplace(txt, "s){ce\s([^}]*)}", StrReplace(ce, "`n", "") )
	fix =
	(LTRIM
	<div class='fix-master'>
		<div class='fix-icon'></div>
		<div class='fix-text'>$1</div>
	</div>
	)
	imp =
	(LTRIM
	<div class='fix-master'>
		<div class='improve-icon'></div>
		<div class='fix-text'>$1</div>
	</div>
	)
	nfo =
	(LTRIM
	<div class='fix-master'>
		<div class='nfo-icon'></div>
		<div class='fix-text'>$1</div>
	</div>
	)
	WARN = 
	(LTRIM
	<div class='warning'>			
		<div>$1</div>
	</div>
	)		
	txt :=  RegExReplace(txt, "s){F\s([^}]*)}", StrReplace(fix, "`n", "") )	
	txt :=  RegExReplace(txt, "s){I\s([^}]*)}", StrReplace(imp, "`n", "") )	
	txt :=  RegExReplace(txt, "s){NFO\s([^}]*)}", StrReplace(nfo, "`n", "") )		
	txt :=  RegExReplace(txt, "s){ce\s([^}]*)}", StrReplace(ce, "`n", "") )	
	txt :=  RegExReplace(txt, "s){WARN\s([^}]*)}", StrReplace(WARN, "`n", "") )	
	txt :=  RegExReplace(txt, "s){h1\s([^}]*)}", "<div class='features'>$1</div>" )	
	txt :=  RegExReplace(txt, "s){b\s([^}]*)}", "<div class='box'>$1</div>" )					
	return txt
}

LaunchCE(IniFileName){
    cfg    := new IniFile(g_.Profiles . IniFileName . ".ini")
    target := cfg.Get("Target")    
	table  := StrReplace(GetCheatTablePath(IniFileName), "\", "\\")
	SplitPath, target, exe		
	run ..\injector.exe "Cheat Engine.ahk" "%table%" "%exe%"
}

AppendLink(name, url){
    g_.Links[name] := url
}

SelectKey(){	
	Gui, SelectKey:New
	Gui, SelectKey:+Hwndhwin
	Gui, SelectKey:+AlwaysOnTop
	Gui, SelectKey:Add, Text, x60 y20, Waiting for key
	Gui, SelectKey:Add, Text, x6 y36, Close this window to clear the assigment
	Gui, SelectKey:Show, w214 h80		
	keys := "LButton RButton MButton WheelDown WheelUp CapsLock Space Tab Enter Esc BS ScrollLock Del Ins Home End PgUp PgDn Up Down Left Right" 
	. " Numpad0 Numpad1 Numpad2 Numpad3 Numpad4 Numpad5 Numpad6 Numpad7 Numpad8 Numpad9 NumpadDiv NumpadMult NumpadAdd NumpadSub" 
	. " F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 Ctrl Alt Shift Q W E R T Y U I O P A S D F G H J K L Z X C V B N M < > [ ] 1 2 3 4 5 6 7 8 9 0 / \ ~ - ="
	;keywait, LButton
	While True
	{
		for k, key in StrSplit(keys, " ")
		{
			if not WinActive("ahk_id" hwin)
			return ""
			KeyWait, %key%, D T0.001
			if (ErrorLevel = 0)
			{			
				KeyWait, %key%
				Gui, SelectKey:destroy
				return key
			}	
		}	
	}	
}

SelectXButton(){
	static selected := ""
	selected        := ""
	Gui, SelectKey:New
	Gui, SelectKey:+Hwndhwin
	Gui, SelectKey:Add, Button, Section x10 y10 g_SelectXButton, Button 1
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 2
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 3
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 4
	Gui, SelectKey:Add, Button, Section ys xs+60  g_SelectXButton, Button 5
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 6
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 7
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 8
	Gui, SelectKey:Add, Button, xs ys xs+60  g_SelectXButton, Button 9
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 10
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 11
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 12
	Gui, SelectKey:Add, text, y+10 x10, To clear the assigment, close this window
	Gui, SelectKey:Show	
	While (selected=""){
		if not WinActive("ahk_id" hwin)
		return ""
		Sleep, 100
	}
	Gui, SelectKey:Destroy
	return selected

	_SelectXButton:
		selected := StrReplace(A_GuiControl, "Button", "Gamepad")
	return 
}

GuiClose(){
	MsgBox
	;SoundPlay, *16
	Return true
}

DownloadFile(url, dest){
	if dest = "undefined" or url = "undefined"
	return
	dest := g_.BasePath dest
	print("url : " url)
	print("path: " dest)

	success := False
	while (!success) {
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", url, false)
		whr.Send()
		; Using 'true' above and the call below allows the script to remain responsive.
		whr.WaitForResponse()
		file := whr.ResponseText
		if (file = "")
			success := False
		else {
			FileOpen(dest, "w").Write(file)
			success := FileOpen(dest, "r").read() = "" ? False : True
		}
	}	
	return

	/*
	err := 1
	while (err != 0)
	{
		UrlDownloadToFile, %url%, %dest%
		err := ErrorLevel
		print("Retying download " err)
	}
	*/
}	

IsExecutable(path)
{
	r := dllcall("GetBinaryType", astr, path, "uint*", bintype:=0, "uint")
	return (r > 0 && (bintype = 0 || bintype = 6)) ? true : false
}

FindGameExecutable(){
	msgbox, 64, ,Prease indicate the path of the game's executable`nThis is a one time only procedure
	FileSelectFile, newtarget, Options, , , (*.exe)
	return newtarget
}

LaunchGame(game){
	cfgfile  := g_.Profiles . game . ".ini"
	cfg      := new IniFile(cfgfile)
	path     := cfg.Get("Target")
	if (InStr("A-Dx11 A-Dx10 A-Dx9 A-Dx8 A-Dx7 A-GL", game)){
		path := ""
	}
	if (!FileExist(path) or !IsExecutable(path)){
		newpath := FindGameExecutable()
		if (newpath = "")
		return
		cfg.Edit("Target", newpath).save()
	}
	run ..\injector.exe src\injector.txt -f "%cfgfile%", ..\
}

CreateShortCut(game){
	cfgfile  := g_.Profiles . game . ".ini"
	cfg      := new IniFile(cfgfile)
	path     := cfg.Get("Target")
	if (!FileExist(path) or !IsExecutable(path)){
		newpath := FindGameExecutable()
		if (newpath = "")
		return
		path := newpath
		cfg.Edit("Target", newpath).save()
	}
	splitpath, path, , , ,name
	path := StrReplace(A_ScriptDir, "Server", "injector.exe")	
	name := name
	lnk  := A_desktop "\" name ".lnk"
	dir  := StrReplace(A_ScriptDir, "Server", "")
	FileCreateShortcut, %path%, %lnk%, %dir%, src\injector.txt -f "%cfgfile%", ,%path%
	msgbox, 64, ,Done! A shortcut was placed in the desktop
}

PostHandler(socket, p, a, b){
    ;print("Post")
    path  := S(StrGet(p+0, ,"CP0"))  
    reply := JSONReply("{""Err"" : ""Test""}")
    args  := GetArgs(a)  
    body  := StrGet(b+0, ,"CP0")
    if (path.__str = "/Action"){
        HandleAction(args.Action)        
    }    
    else if (path.__str = "/games-list"){
       reply := JSONReply(GetGamesList())
    }
    else if (path.__str = "/Print"){
        print(body)
    }
    else if (path.__str = "/GetHelpFileName"){
        reply := PlainReply(GetHelpFileName(args.Profile))
    }
    else if (path.__str = "/GetCheatTableName"){
        reply := PlainReply(GetCheatTableName(args.IniFileName))
    }
    else if (path.__str = "/GetCheatTablePath"){
        reply := PlainReply(GetCheatTablePath(args.IniFileName))        
    }
    else if (path.__str = "/GetScriptFileName"){
        reply := PlainReply(GetScriptFileName(body))
    }
    else if (path.__str = "/GetGitProfilesList"){
        reply := GetGitProfilesList()
    }   
    else if (path.__str = "/SaveFile"){
        reply := SaveFile(args.Path, body)
    }
    else if (path.__str = "/FindGame"){
        reply := PlainReply(FindGame())
    }
    else if (path.__str = "/FileExist"){
        ;print(body)
        reply := PlainReply(FileExist(body))
    } 
    else if (path.__str = "/GameHelp"){
        reply := PlainReply(ProcessHelpDocument(GetGameHelp(args.Game)))
    } 
    else if (path.__str = "/GetVal"){
        reply := PlainReply(GetVal(args.Game, args.Key, args.Section))
    } 
    else if (path.__str = "/IsTrue"){
        reply := PlainReply(IsTrue(args.Game, args.Key, args.Section))
    }
	else if (path.__str = "/SetVal"){
		SetValue(args.Game, args.Key, args.Val, args.Section)
	}
    else if (path.__str = "/ParseText"){
        reply := PlainReply(ParseText(body))
    }
    else if (path.__str = "/AppendLink"){
        ;AppendLink(args.Name, args.Url)
		AppendLink(args.Name, body)
    }
    else if (path.__str = "/LaunchCE"){
        LaunchCE(args.IniFileName)
	}    
	else if (path.__str = "/SelectKey"){
		reply := PlainReply(SelectKey())
	}
	else if (path.__str = "/SelectXButton"){
		reply := PlainReply(SelectXButton())
	} 
	else if (path.__str = "/DownloadFile"){
		DownloadFile(args.Url, args.Path)
	} 
	else if (path.__str = "/LaunchGame"){
		LaunchGame(args.Game)
	}
	else if (path.__str = "/CreateShortCut"){
		CreateShortCut(args.Game)
	}
    result := DllCall(g_.p_send, uint, socket, astr, reply, uint, strlen(reply), uint, 0, int) 
	if (result = -1)
		print("Socket error")
	else if (result != strlen(reply)){
		print("Reply was" StrLen(reply) " bytes, but " result "were sent")
	}
}

serve()
