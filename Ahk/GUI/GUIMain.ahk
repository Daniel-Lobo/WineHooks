#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

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

Base64Enc(FileName, LineLength := 64, LeadingSpaces := 0 ) { ; By SKAN / 18-Aug-2017
    Local Rqd := 0, B64, B := "", N := 0 - LineLength + 1  ; CRYPT_STRING_BASE64 := 0x1
	Bin    := ""
    img    := FileOpen(FileName, "r")
    nBytes := img.RawRead(Bin, img.Length)          
    DllCall( "Crypt32.dll\CryptBinaryToString", "Ptr", &Bin ,"UInt", nBytes, "UInt", 0x1, "Ptr", 0,   "UIntP", Rqd)
    VarSetCapacity( B64, Rqd * ( A_Isunicode ? 2 : 1 ), 0 )
    DllCall( "Crypt32.dll\CryptBinaryToString", "Ptr", &Bin, "UInt", nBytes, "UInt", 0x1, "Str", B64, "UIntP", Rqd)
    If ( LineLength = 64 and ! LeadingSpaces )
        Return B64
    B64 := StrReplace( B64, "`r`n" )        
    Loop % Ceil( StrLen(B64) / LineLength )
        B .= Format("{1:" LeadingSpaces "s}","" ) . SubStr( B64, N += LineLength, LineLength ) . "`n" 
    Return RTrim( B,"`n" )    
}

;dllcall("AllocConsole")
global g_ := {"BasePath" : A_mydocuments "\WineHooks\"
,"HelpPath"        : A_mydocuments "\WineHooks\Help\"
,"Profiles"        : A_mydocuments "\WineHooks\Profiles\"
,"WindowWidth"     : 1366
,"WindowHeight"    : 768
,"GamesListWidth"  : 260
,"CheatTablesPath" : A_mydocuments "\WineHooks\CheatTables\"
,"GameCfg"         : {}
,"Controls"        : {}
,"Links"           : {}
,"Name"            : ""
,"Stabe"           : "https://github.com/Daniel-Lobo/WineHooks/releases/download/v0.10.12/Peixoto.zip"
,"Hierarchy"       : {"32Bit" :  ["z24", "Safe",  "DisableFontAA"
, {"READ"  : ["CPY"]}
, {"HD"    : ["GDI", "NEFS", "DSR", "WHKS", "HLFPX", "MHKS", "MCLP", "xBR", "VPOS", "POW2", "WNWM", "BLNK", {"SSAA": ["BLT3D"]}]}  ]}}

print(msg){
    FileOpen("*", "w").write(msg "`n")
}
print(A_AhkVersion)
ResetLinks()
ResetLinks(){
	g_.Links :=  {"Donate"   : "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=E68RE3UWG2ZEU&lc=US&"
	    . "item_name=Peixoto&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted"
		, "Peixoto"      : "http://www.vogons.org/viewtopic.php?f=24&t=53121"
		, "cheat"        : "https://www.cheatengine.org/"
		, "patreon_home" : "https://www.patreon.com/user/about?u=44312848"
		, "Stable"       : "https://github.com/Daniel-Lobo/WineHooks/releases/download/v0.10.12/Peixoto.zip"
		, "Wine"         : "https://www.winehq.org/"
	    , "dxvk"         : "https://github.com/doitsujin/dxvk/releases"}
}

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
ReadFile(path){
    ; 4:= read and replace \n\r with \n
    return FileOpen(path, 4).read()
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
Main() {   
	Menu, Tray, Icon, png\wine.ico
    static GamesList  
    w         := g_.WindowWidth
    h         := g_.WindowHeight
    ListWidth := g_.GamesListWidth 
	Gui,Create:Destroy  
	Gui, Main: Destroy
	Gui, Main: Color, 0xececec
	Gui, Main: Font, Times New Roman s10
    Gui, Main: -Theme
    Gui, Main: Add, ListView, Background0xececec vGamesList gGameSelected x0 y0 h%h%-30 w%ListWidth% -multi +NoSortHdr AltSubmit hwndhListView, Games
	GuiControl, Font, GamesList  ; Put the above font into effect for a control.
    Gui, Main: Show, w%w% h%h%, WineHooks`, 0.10.13-Beta   
    Gui, Main: Margin, 0, 0, 0, 0 
    winehooks := A_mydocuments "\WineHooks"   
    Gui, Main:Default 
	ListGames()    
}
ListGames(){
	Gui, Main:Default 
	LV_Add("", "Home")
    loop, % g_.BasePath "Profiles\*.*" {   
        game := StrReplace(A_loopfilename, ".ini", "")          
        LV_Add("", game)
    }  
}
GameSelected(){
    static last_game := ""
    if !instr(A_GuiEvent, "I")
    return       
    LV_GetText(game, LV_GetNext("F"))
    if (last_game = game)
    return
    last_game := game
	if (last_game = "Home")
	return Wellcome()	
    ShowHelp(g_.BasePath "Profiles\" game ".ini", game)
}
ReadHelpFile(byref cfg){
    path := trim(cfg.Get("help"))
    path := FileExist(g_.HelpPath path ".txt") ? g_.HelpPath path ".txt" : g_.Profiles "\" path
    path := StrReplace(path, "user\", "")	
    return FileExist(path) ? ReadFile(path) : trim(cfg.Get("help"))
}
ProcessText(txt){
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
	txt := StrReplace(txt, " ^ ", "' href='javascript:dummy()'>")
	txt := StrReplace(txt, "|a", "</a>")	
	txt := StrReplace(txt, "l|", "<li>")	
	txt := StrReplace(txt, "<ul>", "<ul style='margin-top:0px;margin-bottom:0px;'>")
	;txt := StrReplace(txt, "%__path__%", this.__path__)
	
	;p := A_mydocuments "\games\" new ini(this.cfg_file).read("path") 
	txt := StrReplace(txt, "<td>", "<td style='vertical-align: top; padding-right: 20px'>")
	txt := RegExReplace(txt, "i<([^>.]*)>i", "<i>$1</i>")	
	txt := RegExReplace(txt, "b<([^>.]*)>b", "<b>$1</b>")	
	txt := RegExReplace(txt, "t<([^>.]*)>t", "<table>$1</table>")				
	txt := RegExReplace(txt, "a<([^>.]*)--([^>.]*)>a", "<a id='$1' href='javascript:dummy()'>$2</a>")
	StringReplace, txt, txt, `", `',1
	stringreplace, txt, txt, `%ModsLink`%, <a id='gototab_File System_modstuto' href='javascript:dummy()'>Mods manager</a>
	stringreplace, txt, txt, `%TexturesB`%, <a id='gototab_graphics..._Textswap.e' href='javascript:dummy()'>Texture swapping</a>
	stringreplace, txt, txt, `%Textures`%, <a id='gototab_graphics..._Textswap.e' href='javascript:dummy()'>Texture swapping</a>
	stringreplace, txt, txt, `%TexturesC`%, <a id='gototab_graphics_Textswap.e' href='javascript:dummy()'>Texture swapping</a>
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
	txt := RegExReplace(txt, "s)\[([^]\s]*)\s([^]]*)\]", "<a id='$1' href='javascript:dummy()'>$2</a>" )	
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
		<div style="color:transparent;text-shadow:0 0 0 darkblue;font-size:24px;margin-top:-8px;margin-right:4px">ℹ️</div>
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
GetCheatTablePath(name){		
	for kk, vv in StrSplit("OpenGl D3D7 D3D8 D3D9 D3D10 D3D11 D3D12 GOG DirectDraw DX6 Software Hardware", " ")
	name := StrReplace(name, " - " vv, "")	
	path := g_.CheatTablesPath name ".ct"	
	return fileexist(path) ? path : ""	
}
PreProcessHelpDocument(txt, wip=False) {
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
			dx  := ReadFile(g_.HelpPath v ".txt")
			dx  := StrReplace(dx, "::Title::user", "")
			txt := StrReplace(txt, "%" v "%", dx)					
		}
	}	

	;if (wip)
		;txt  := StrReplace(StrReplace(txt, "wip<", ""), ">wip", "")
	;else
		;txt  := RegExReplace(txt, "wip<.*>wip", "")		

	return txt
}
GetKeyAndSection(_id){
	if (InStr(_id, ".") = 0)
	return  {"Key" : _id, "Section" : ""}
	split := StrSplit(_id, ".")
	key   := split[2]
	sect  := split[1] 
	return {"Key" : key, "Section" : sect}
}
GetKeySectionAndValue(_id){
	if (InStr(_id, ".") = 0)
	_id := "." _id
	split1  := StrSplit(_id, ".")
	split2  := StrSplit(split1[2], "=")
	sect    := split1[1] 
	key     := split2[1] 
	val     := split2[2] 
	return {"Key" : key, "Section" : sect, "Value" : val}
}
GetTrueOrFalse(byref cfg, _id){
	k := GetKeyAndSection(_id)
	return cfg.IsTrue(k.Key, k.Section)
}
GetVal(byref cfg, _id){
	k := GetKeyAndSection(_id)
	return cfg.Get(k.Key, k.Section)
}
ShowHelp(path, name){    
    static IE, TabsHwnd
	ResetLinks()
	x            := g_.GamesListWidth + 10
    w            := g_.WindowWidth  - g_.GamesListWidth - 8
    h            := g_.WindowHeight  
    IEHeight     := h
    IEWidth      := w
    g_.GameCfg   := new IniFile(path)
	g_.Name      := name
    help         := PreProcessHelpDocument(ReadHelpFile(g_.GameCfg)) 
    parent_id    := "content"
    ;print(g_.GameCfg.get("d3d"))
	;g_.GameCfg.Print()
	title := Chr(0x2139)
	test  := Chr(0x2139)
	Gui,Create:Destroy  
	GUI, TSwap: Destroy
	GUI, PxSwap: Destroy
	GUI, XInput: Destroy
	GUI, Macros: Destroy
	GUI, Selectkey: Destroy
	GUI, Macros: Destroy
	GUI, Create: Destroy
    Gui,Cfg:New   
	Gui, Cfg: Color, 0xececec
    Gui,Cfg:+ParentMain  
    Gui,Cfg:-0x00C00000   
	Gui,Cfg: Font, s14 bold cblack   
    Gui,Cfg: Font, s10
    Gui,Cfg: Margin, 0, 0, 0, 0       
    Gui,Cfg: Margin, 0, 0, 0, 0
    Gui,Cfg: Add, activeX,x0 y0 h%IEHeight% w%IEWidth% vIE, Shell.Explorer
    IE.Navigate("file:///" . A_ScriptDir . "/main.html")
    sleep, 100
    IEGui.document := IE.document
    ComObjConnect(IEGui.document, IEGui)  
	IEGui.Document.parentWindow.AhkShowHint       := Func("ShowHint")
	IEGui.Document.parentWindow.AhkSetCompatLayer := Func("SetCompatLayer")
    tokens := StrSplit(help, "::")
    for index, token in tokens
    {
        sec := Trim(token) 
        if (sec = "Title"){		
			if (tokens[index+1]  = "user")
				tokens[index+1] := name	
			IEGui.document.parentWindow.AppendContent("<div id='title_container' class='cntrl_group'></div>")
			IEGui.document.parentWindow.AddDefaultButtons(g_.GameCfg.Get("wiki"), GetCheatTablePath(name))
			IEGui.document.parentWindow.AppendContent("<h1>" tokens[index+1] "</h1>", "title_container")
			if (ver := g_.GameCfg.get("ver"))
			IEGui.document.parentWindow.AddVersionWarning(ver, "title_container")
            IEGui.document.parentWindow.AppendContent(ProcessText(tokens[index+2]), "title_container")
			IEGui.document.parentWindow.AppendContent("<div><br><a id='MANUAL_EDIT' href='javascript:dummy()'>Edit</a> config file. For developer use</div>", "title_container")
		} else if (sec = "Tab"){
			IEGui.document.parentWindow.AddTabs(tokens[index+1])
		} else if (sec = "parent"){
			if S(tokens[index+1]).StartsWith("textswap")
			continue	
			if S(tokens[index+1]).StartsWith("PxSwap")
			continue 
			parent_id := tokens[index+1]			
		} else if (S(sec).EndsWith("Tab")){
			parent_id := StrReplace(token, "Tab", "_div")
			if (parent_id = "Input_div")
				parent_id := ""
			if (sec = "File SystemTab") {										
				html =
				(LTRIM
					<div class="warning" style="height:50px;padding-top:28px">
						Not yet implemented in the currrent beta version. If you're on windows, you can download the <a id="LAST_STABLE" href="javascript:dummy()">last stable version</a>
					</div>
				)					
				IEGui.document.parentWindow.AppendContent(html, "File System_div")
			} else if (sec = "InputTab") {
				html =
				(LTRIM
					<div style="margin-left: 8px">&bull; &ensp;XInput translation
						<div style="margin-left: 18px">Cusmomize how Xinput gamepads are reconized by the game:
						<a id="XINPUT::GUI" href="javascript:dummy()">configure</a></div>
					</div>
					<div style="margin-left: 8px">&bull; &ensp;Macros
						<div style="margin-left: 18px">Create keyboard and mouse macros:
						<a id="MACROS::GUI" href="javascript:dummy()">configure</a></div>
					</div>
				)					
				IEGui.document.parentWindow.AppendContent(html, "Input_div")
			}
		} else if (sec = "BOOL"){		
			if S(tokens[index+1]).StartsWith("textswap")
			continue	
			if S(tokens[index+1]).StartsWith("PxSwap")
			continue 
			state := GetTrueOrFalse(g_.GameCfg, tokens[index+1]) 			
			IEGui.document.parentWindow.AddBoolean(tokens[index+1], ProcessText(tokens[index+2]), ProcessText(tokens[index+3]), parent_id, state)
		} else if (sec = "HIDDEN"){	
			if S(tokens[index+1]).StartsWith("textswap")
			continue						
			IEGui.document.parentWindow.AddHint(tokens[index+1], ProcessText(tokens[index+3]), parent_id)
		} else if (sec = "RADIOHEAD"){	
			if S(tokens[index+1]).StartsWith("textswap")
			continue								
			IEGui.document.parentWindow.AddRadioHeader(tokens[index+1], tokens[index+2], parent_id)
		} else if (sec = "RADIO"){		
			if S(tokens[index+1]).StartsWith("textswap")
			continue		
			k        := GetKeySectionAndValue(tokens[index+1])
			k.Value  := k.Value = "False" ? False : k.Value
			v        := g_.GameCfg.Get(k.key, k.section)	
			v        := v = "" ? False : v
			selected :=	v = k.Value ? True : False	
			print(tokens[index+1] " v=" v " key=" k.key " sec=" k.section " val=" k.value " v=val? " (v = k.Value) " selected=" selected)
			IEGui.document.parentWindow.AddRadio(tokens[index+1], ProcessText(tokens[index+3]), parent_id, selected)
		} else if (sec = "_RLMT_"){								
			IEGui.document.parentWindow.AddResLimitWidget(tokens[index+1], tokens[index+2], ProcessText(tokens[index+4]), parent_id, GetVal(g_.GameCfg, tokens[index+1]))
		} else if (sec = "TEXT"){				
			IEGui.document.parentWindow.AppendContent(ProcessText(tokens[index+1]), parent_id)
		} else if (sec = "FLOAT"){	
			state := GetVal(g_.GameCfg, tokens[index+1])			
			IEGui.document.parentWindow.AddSlider(tokens[index+1], tokens[index+2], tokens[index+3], ProcessText(tokens[index+4]), parent_id, state)
		} else if (sec = "endofsettings"){	
			IEGui.document.parentWindow.AddBoolean("HDPI", "Hight DPI aware", "", parent_id)			
			IEGui.document.parentWindow.AddCompatLayerDropdown(parent_id, g_.GameCfg.get("CompatLayer"))
		} else if (sec = "link") {
			s := strsplit(tokens[index+1], "->")
			g_.Links[s[1]] := s[2]	
		} else if (sec = "%_Textswap_%") {			
			html =
			(LTRIM
				<div style="margin-left: 7px">&bull; &ensp;Texture swapping
					<div style="margin-left: 20px">Dump and replace textures <a id="TEXTSWAP::GUI" href="javascript:dummy()">configure</a></div>
				</label>
			)					
			IEGui.document.parentWindow.AppendContent(html, parent_id)
		} else if (sec = "%_PixelSwap_%") {						
			html =
			(LTRIM
				<div style="margin-left: 7px">&bull; &ensp;Pixel shader override
					<div style="margin-left: 20px">Dump and replace pixel shaders <a id="PXSWAP::GUI" href="javascript:dummy()">configure</a></div>
				</label>
			)					
			IEGui.document.parentWindow.AppendContent(html, parent_id)
		} 
    }
	if (IEGui.document.getElementById("32bit"))
		HandleHierachcy(IEGui.document, "32bit", IEGui.document.getElementById("32bit").checked ? false : true, true)
	else if (IEGui.document.getElementById("HD")) {
		if (IEGui.document.getElementById("HD").tagName = "input")
			HandleHierachcy(IEGui.document, "HD", IEGui.document.getElementById("HD").checked ? false : true, true)
		else if (IEGui.document.getElementById("HD").tagName = "div")
			HandleHierachcy(IEGui.document, "HD", IEGui.document.getElementById("HD=0").value ? true : false, true)
	}	
    Gui,Cfg: Show, x%x% y0 h%h% w%w%
}
BoolClicked(){
	GuiControlGet, hwnd, hwnd, % A_GuiControl
	ControlGet, state, Checked,,, ahk_id %hwnd%
	msgbox % g_[hwnd ""] "=" state
}
ShowHint(hint){
	print(hint)
}
findnode(id, node=""){
	if (node = "") 
	node := g_.Hierarchy
	if not Isobject(node)
	return false
	if (node[id]) 
	return node			
	for k, v in node
	{
		candidate := findnode(id, v)
		if IsObject(candidate)
		return candidate
	}
} 
CommitBoolean(element){	
	k := GetKeyAndSection(element.id)		
	g_.GameCfg.edit(k.key, (element.checked = 0) ? "false" : "true", k.section).save()
}
CommitRadio(element){	
	k := GetKeyAndSection(StrSplit(element.name, "=")[1])	
	print(k.key " " k.section " " element.checked " " element.value)	
	if (element.checked = 0)
	return
	val := element.value = "False" ? 0 : element.value 
	g_.GameCfg.edit(k.key, val, k.section).save()
}
HandleHierachcy(document, id, state, noupdates=false, node=""){	
	node := findnode(id)
	if (node = false)
	return
	for k, v in node[id] {			
		child_id := IsObject(v) ? k : V		
		if (child := document.getElementById(child_id)) {					
			if (child.tagName = "input" and child.type = "checkbox")
			{
				if (state){
					child.checked := 0
					if (noupdates = false)
						CommitBoolean(child)
				}
				child.disabled := state		
			} else {								
				for i, sufix in StrSplit("False false 0 1 2 3 4 5 6 7 8 9", " "){				
					if (radio := document.getElementById(child_id "=" sufix)) {						
						radio.disabled := state
						if (state)	{
							if (i < 4) {
								radio.checked := -1 
								if (noupdates = false)
									CommitRadio(radio)
							}
							else 
								radio.checked := 0
						}
					}
				}
			}
		} 		
		if IsObject(v) 
		HandleHierachcy(document, k, state)	
	}
}
SetCompatLayer(val){
	if (val = "None")
	val := ""
	else if S(val).StartsWith("Don")
	val := "#"		
	g_.GameCfg.edit("CompatLayer", val, "").save()
}
HandleInput(document, el){
	print("id=" el.id " value=" el.value " checked=" el.checked " name=" el.name " type=" el.type)  
	if (el.type = "checkbox") {		
		HandleHierachcy(document, el.id, el.checked ? false : true)
		CommitBoolean(el)
	} else if (el.type = "radio") {			
		if ((state := el.value) = "False")
		state := 0
		HandleHierachcy(document, el.name, state ? false : true)
		CommitRadio(el)
	} else if (el.type = "range"){
		print(el.id " " el.value)
		if (el.id="RLMT"){
			g_.GameCfg.edit("RLMT", el.value, "").save()
		}
	}	
	;"Don't Change,None,DWM8And16BitMitigation,Layer_Win95VersionLie,Win95,Win98,FaultTolerantHeap,Win2000,Win2000Sp2,Win2000Sp3,WinXP,WinXPSp2,WinXPSp3,VistaSp2"	
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
GetTargetName(){
	target := g_.GameCfg.Get("Target")
	SplitPath, target, name
	return name
}
FindGameExecutable(){
	msgbox, 64, ,Prease indicate the path of the game's executable`nThis is a one time only procedure
	FileSelectFile, newtarget, Options, , , (*.exe)
	if not newtarget
	return 
	g_.GameCfg.Edit("Target", "" newtarget).save()	
	return True
}
Runscript(script){	
	path       := FileExist(path := "..\AutoHotkey.dll") ? path : A_mydocuments "\AutoHotkey\dlls\AutoHotkey.dll"
	ahktextdll := dllcall("GetProcAddress", uint, dllcall("LoadLibraryW", str, path), astr, "ahktextdll")
	hThread    := dllcall(ahktextdll, Str, fileopen("lib.txt", "r").read() "`n" script, Str, "", Str, "", "Cdecl UPTR")
	dllcall("WaitForSingleObject", "ptr", hThread, "uint", 0xffffffff)
}
class IEGui{
    document := ""
    onclick(){    
		element := this.document.parentWindow.event.srcElement  
		id      := trim(element.id)
		print(id)
		if (element.tagName = "input")
			return HandleInput(this.document, element)
		else if (element.id = "MANUAL_EDIT")
			run % g_.GameCfg.GetFilePath()
		else if instr(element.id, "gototab")
		{
			print(element.id)
			split   := strsplit(element.id, "_")			
			tab     := StrReplace(StrReplace(StrReplace(StrReplace(split[2], "graphics", "Graphics"), "input", "Input"), "cpu", "CPU"), "sound", "Sound")
			control := split[3]			
			if S(tab).StartsWith("input")
				return BetaWarn()	
			if this.document.getElementById(tab "_div") {
				this.document.parentWindow.SelectTab(tab)
				this.document.getElementById(tab  "_div").style.display = "flex"
			}
			control := trim(control)
			if (InStr(control, "="))
				control := StrSplit(control, "=")[1]
			if (control = "gamma")
			control := "Gamma"
			else if (control = "sync")
			control := "SYNC"
			else if (control = "sxty")
			control := "SXTY"
			else if (control = "compatlayer")
			control := "CompatLayer"
			else if (control = "blt3d")
			control := "BLT3D"
			else if (control = "sngl")
			control := "SNGL"
			else if (control = "whks")
			control := "WHKS"
			else if (control = "rlmt")
			control := "RLMT"
			else if (control = "hd")
			control := "HD"
			else if (control = "nefs")
			control := "NEFS"
			else if (control = "safe")
			control := "SAFE"
			else if (control = "dly")
			control := "DLY"
			else if (control = "read")
			control := "READ"
			else if (control = "cpy")
			control := "CPY"
			else if (control = "SYS")
			control := "SYS"
			else if (control = "SCLR")
			return BetaWarn()
			else if (control = "fltr")
			return BetaWarn()	

			if S(control).StartsWith("TextSwap")
				ConfigTextSawp()
			else if S(control).StartsWith("PxSwap")
				ConfigPxSwap()
			else if S(control).StartsWith("PixelSwap")
				ConfigPxSwap()
			else if S(control).StartsWith("xBr")
				return BetaWarn()				
			else {
				print("Scroll=" control " " IsObject(this.document.getElementById(control))) 
				this.document.getElementById(trim(control)).scrollIntoView()
			} 
		} else if instr(element.id, "goto_"){
			control := strsplit(element.id, "_")[2]
			this.document.getElementById(trim(control)).scrollIntoView()
		}	
        else if (id="InstallShield5" or id="InstallShield3")
			BetaWarn()	
		else if (id="TEXTSWAP::GUI")
			ConfigTextSawp()	
		else if (id="PxSwap::GUI")
			ConfigPxSwap()
		else if (id="XINPUT::GUI")
			ConfigXInput()
		else if (id="MACROS::GUI")
			ConfigMacros()
		else if (id="LAST_STABLE")
			run % g_.Stabe
		else if (g_.Links[id]) {
			print("Opening link=" id)
			if Instr(id, "SCRIPT")
				return runscript(g_.Links[id])	
			run % g_.Links[id]
		}
		else if(id="old_version_redirect")
            run, % "https://github.com/Daniel-Lobo/WineHooks/releases"
		else if(id="gammatool")
			SetDeviceGammaRamp(128, 1)
		else if(id="BUTTON::CE"){
			table := StrReplace(GetCheatTablePath(g_.name), "\", "\\")
			exe   := GetTargetName()		
			run ..\injector.exe "Cheat Engine.ahk" "%table%" "%exe%"
		}
		else if(id="BUTTON::Play"){
			target := g_.GameCfg.Get("Target")
			if ! dllcall("GetBinaryTypeW", str, target, "uint*", type:=0)
			{
				if (FindGameExecutable() = False)
				return				
			}			
			cfg := g_.BasePath "Profiles\" g_.name ".ini"
			run ..\injector.exe src\injector.txt -f "%cfg%", ..\
		}
		else if(id="BUTTON::WIKI"){
			run, % g_.GameCfg.Get("Wiki")
		}
		else if(id="BUTTON::Shortcut"){
			target :=g_.GameCfg.Get("Target")
			if (!target)
			{
				if (FindGameExecutable() = False)
				return		
			} 
			splitpath, target, , , ,name
			path := StrReplace(A_ScriptDir, "GUI", "injector.exe")
			cfg  := g_.BasePath "Profiles\" g_.name ".ini"
			name := g_.name
			lnk  := A_desktop "\" name ".lnk"
			dir  := StrReplace(A_ScriptDir, "GUI", "")
			FileCreateShortcut, %path%, %lnk%, %dir%, src\injector.txt -f "%cfg%", ,%target%
			msgbox, 64, ,Done! A shortcut was placed in the desktop
		}
		else if (id="show_ce_div"){
			this.document.parentWindow.ShowCEDiv()
		}			
    }
}
GetHelpFileName(cfg){	
	help   := trim(new IniString(cfg).Get("Help"))
	ignore := {"ddraw" : True, "directdraw" : True, "gl" : True, "DX8" : True, "DX9" : True, "DX10" : True, "DX11" : True, "DX12" : True, "CPU" : True, "Sound" : True, "Input" : True}
	if not InStr(help, ".") and not ignore[help]
		return help ".txt"
	return ""	
}
GetScriptFileName(cfg){	
	script := new IniString(cfg).Get("script")	
	if InStr(script, "\") {
		split  := StrSplit(script, "\")
		script := split[ split.Length() ]
	}
	return trim(script)
}
GetCheatTableName(name){
	for kk, vv in StrSplit("OpenGl D3D7 D3D8 D3D9 D3D10 D3D11 D3D12 GOG DirectDraw DX6 Software Hardware", " ") {
		name := StrReplace(name, " - " vv, "")	
	}
	return trim(StrReplace(name, ".ini", ".ct"))
}
DownLoadFinished(){
	msgbox, 64, ,Download finished!
	Main()
	Wellcome()
}
SaveFile(file_name, contents){	
	try {
		FileOpen(g_.BasePath . file_name, "w").write(contents)
	}
}
class WellcomeEventhandler{
	document      := ""
	auxdoc        :=
    onclick(){
		element := this.document.parentWindow.event.srcElement  
		id      := trim(element.id)
		print(id)
		if (id = "donwload"){			
			this.document.getElementById("loading").style.display := "flex"			
			this.auxdoc.parentWindow.AhkPrint              := Func("Print")
			this.auxdoc.parentWindow.AhkSaveFile           := Func("SaveFile")
			this.auxdoc.parentWindow.AhkGetHelpFileName    := Func("GetHelpFileName")
			this.auxdoc.parentWindow.AhkGetCheatTableName  := Func("GetCheatTableName")
			this.auxdoc.parentWindow.AhkDownLoadFinished   := Func("DownLoadFinished")
			this.auxdoc.parentWindow.AhkGetScriptFileName  := Func("GetScriptFileName")
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
			this.auxdoc.parentWindow.ParseGITHubReply(profiles, help, tables, scripts)
			this.document.getElementById("loading").style.display := "none"		
		} else if (id="Create"){
			return CreateProfile()
		} else if (id="Patreon" or element.innerHTML="Patreon") {
			run % g_.Links.patreon_home
		}
	}
}
Wellcome(){  
	static IE, IEWellcome
stable := g_.Stabe
warn =
(
This is a beta version. Currently, I'm adapting the program to be fully compatible with <a href="https://www.winehq.org/">wine</a> and use
wine's Direct3D dlls on Windows. While the transition is fairly advanced, several things are broken 
or missing on the GUI and on Direct3D 7 and earlier games, but if you're on windows, you can always 
download the <a href="%stable%">last stable version</a> 
)	
	patreon   := g_.Links.patreon_home
	x         := g_.GamesListWidth + 2  
	w         := g_.WindowWidth  - g_.GamesListWidth - 12
    h         := g_.WindowHeight  
    IEHeight  := h
    IEWidth   := w
    Gui,Cfg:New   
	Gui, Cfg: Color, white
    Gui,Cfg:+ParentMain  ;
    Gui,Cfg:-0x00C00000	
	Gui,Cfg:Add, activeX, x0 y0 h330 w%IEWidth% vIEWellcome, Shell.Explorer
	Gui,Cfg:Add, activeX, x0 h440 w%IEWidth% vIE, Shell.Explorer
    IE.Navigate("file:///" . A_ScriptDir . "/main.html")
	IEWellcome.Navigate("file:///" . A_ScriptDir . "/main.html")
    sleep, 100    
	
	IEGui.document := IE.document
    ComObjConnect(IEGui.document, IEGui) 
	try {
		IE.Document.parentWindow.AddHomePageWarning()
	} catch {
		Wellcome()
	}
	WellcomeEventhandler.document := IEWellcome.document
	WellcomeEventhandler.auxdoc   := IE.document
    ComObjConnect(WellcomeEventhandler.document, WellcomeEventhandler) 
	try {
		WellcomeEventhandler.Document.parentWindow.Wellcome()
	} catch {
		Wellcome()
	}
    Gui,Cfg: Show, x%x% y0 h%h% w%w%    
	FileCreateDir, % g_.BasePath "scripts"
	FileCreateDir, % g_.HelpPath  
	FileCreateDir, % g_.Profiles
	FileCreateDir, % g_.CheatTablesPath
	return 
}

IsFileNameValid(p, allow_slash=false){
	bad_chars := allow_slash ? "<>:""/|?*" : "<>:""/\|?*"
	for i, char in StrSplit(bad_chars){
		if InStr(p, char)
			return False
	} 
}

CreateProfile(){
path := g_.Basepath
folder_caption =  
(
	Name of a folder that will be created on`n%path%Games`nwhere the program may dump textures and pixel shaders, if you use any of these features
)		
	static api, gamepath, entryname, entryfolder, _gampath
	Gui,Create:New   
    ;Gui,Create:+ParentCfg
	;Gui,Create:+AlwaysOnTop 
	Gui,Create:Color, f9edbe
	Gui,Create:Margin, 4
	Gui,Create:Font, s12
	Gui,Create:Add, Groupbox, x6 h220 w610 c0000aa, API
	Gui,Create:Add, Radio, yp+20 xp+12 checked vapi, OpenGl
	Gui,Create:Add, Radio, , DirectX 6 and earlier
	Gui,Create:Add, Radio, , DirectX 7 
	Gui,Create:Add, Radio, , DirectX 8
	Gui,Create:Add, Radio, , DirectX 9
	Gui,Create:Add, Radio, , DirectX 10
	Gui,Create:Add, Radio, , DirectX 11
	Gui,Create:Add, Groupbox, x6 h50 w610 c0000aa, Executable path
	Gui,Create:Add, Link, yp+24 xp+8 hwndgamepath w596 gSelectGameExe, <a>[...]</a>	
	Gui,Create:Add, Groupbox, x6 h58 w610 c0000aa, Entry name - the name that will be shown in the games list
	Gui,Create:Add, Edit, yp+24 xp+8 ventryname w596, 
	Gui,Create:Add, Groupbox, x6 h118 w610 c0000aa, Game folder name
	Gui,Create:Add, Edit, yp+24 xp+8 ventryfolder w596, 
	Gui,Create:Font, s11
	Gui,Create:Add, Text, w596, Name of a folder that will be created on
	Gui,Create:Font, bold s11
	Gui,Create:Add, Text, w596 y+0, %path%Games
	Gui,Create:Font
	Gui,Create:Font, s11
	Gui,Create:Add, Text, w596 y+0, where the program may dump textures and pixel shaders, if you use any of these features
	Gui,Create:Font, s12	
	Gui,Create:Add, Button, x550 gCreate, Create	
	Gui,Create:Show, w620
	return

	Create:
		Gui,Create:submit,nohide
		ControlGetText, userpath, , ahk_id %gamepath%
		__path := StrReplace(StrReplace(userpath, "<a>", ""), "</a>", "")
		if (False = IsFileNameValid(entryname)){
			msgbox, 16, , % "The entry name cannot contain any of the folowing characters: < > : "" / \ | ? **"
			return
		}
		if (False = IsFileNameValid(entryfolder, true)){
			msgbox, 16, , % "The folder name cannot contain any of the folowing characters: < > : "" / | ? **"
			return
		}		
		if (entryfolder = ""){
			msgbox, 16, , % "Please enter a folder name"
			return
		}
		if (entryname = ""){
			msgbox, 16, , % "Please enter a entry name"
			return
		}
		if (__path = "[...]"){
			msgbox, 16, , % "Please select the path of the game's executable"
			return
		}
		__api  := strsplit("Gl 1 7 8 9 10 11 12 Vk", " ")[api]
		help   := strsplit("Gl ddraw ddraw DX8 DX9 DX10 DX11 DX12 Vulkan", " ")[api]
		cfg=
		(LTRIM
		Target=%__path%
		D3D=%__api%
		Help=%help%
		path=%entryfolder%		
		
		[Textswap]
		e=False
		sw=End
		n=>
		p=<
		d=Home
		q=Shift
		sz=256
		s=4
		path=Textures\VOKSI		

		[J2K]
		mds=0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		a=,,,,,,,,,,,,,,,,,,,
		b=,,,,,,,,,,,,,,,,,,,
		x=,,,,,,,,,,,,,,,,,,,
		y=,,,,,,,,,,,,,,,,,,,
		rs=False
		u=false
		FF=False
		
		[k2k]
		r0e=false
		r1e=false
		s0e=false
		s1e=false
		s2e=false
		s3e=false
		s4e=false
		s5e=false
		t0e=false
		)
		IniName := entryname . ".ini"
		if FileExist(g_.profiles IniName){
			Msgbox, 16, ,There is already a profile called %entryname%
			return
		}
		FileOpen(g_.profiles IniName, "w").write(cfg)
		msgbox, 64, ,The profile %entryname% has been created		
		Main()
		Wellcome()
	return	

	SelectGameExe:
		FileSelectFile, exe, 3, , , *.exe		
		if (exe = "") 
			return
		WM_SETTEXT := 0x000C
		dllcall("SendMessageA", uint, gamepath, uint, WM_SETTEXT, uint, 0, astr, "<a>" exe "</a>")		
	return	
}

class XInputEventhandler{
	document      := ""	
    onclick(){
		element := this.document.parentWindow.event.srcElement  
		id      := trim(element.id)
		print(id)		
	}
}

SelectXButton(){
	static selected := ""
	selected        := ""
	Gui, SelectKey:New
	Gui, SelectKey:Add, Button, Section x10 y10 g_SelectXButton, Button 1
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 2
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 3
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 4
	Gui, SelectKey:Add, Button, Section ys xs+60, Button 5
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 6
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 7
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 8
	Gui, SelectKey:Add, Button, xs ys xs+60, Button 9
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 10
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 11
	Gui, SelectKey:Add, Button, y+10 g_SelectXButton, Button 12
	Gui, SelectKey:Show	
	While (selected=""){
		Sleep, 100
	}
	Gui, SelectKey:Destroy
	return selected

	_SelectXButton:
		selected := A_GuiControl
	return 
}

SelectKey(){	
	Gui, SelectKey:New
	Gui, SelectKey:Add, Text, x60 y20, Waiting for key
	Gui, SelectKey:Show, w200 h60		
	keys := "LButton RButton MButton WheelDown WheelUp CapsLock Space Tab Enter Esc BS ScrollLock Del Ins Home End PgUp PgDn Up Down Left Right" 
	. " Numpad0 Numpad1 Numpad2 Numpad3 Numpad4 Numpad5 Numpad6 Numpad7 Numpad8 Numpad9 NumpadDiv NumpadMult NumpadAdd NumpadSub" 
	. " F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 Ctrl Alt Shift Q W E R T Y U I O P A S D F G H J K L Z X C V B N M < > [ ] 1 2 3 4 5 6 7 8 9 0 / \ ~ - ="
	While True
	{
		for k, key in StrSplit(keys, " ")
		{
			if GetKeyState(key, "P")
			{			
				Gui, SelectKey:destroy
				return key
			}	
		}	
	}	
}

EditCfg(section, key, val){
	g_.GameCfg.Edit(key, val, section)			
}
SaveCfg(){
	g_.GameCfg.Save()
}

ConfigMacros(){
	static IE
	Gui, Macros:New   
	Gui, Macros:Color, 0xececec
    Gui, Macros:+ParentMain   	
	Gui, Macros:Add, activeX, x5 h460 w600 vIE, Shell.Explorer
    IE.Navigate("file:///" . A_ScriptDir . "/main.html")	
    sleep, 100   
	json := "{"
	for k, v in StrSplit("r0,r1,s0,s1,s2,s3,s4,s5,t0,t1", ","){
		for kk, vv in ["e", "k", "v"] {
			what := v . vv
			json .= """" what """" " : " """" g_.GameCfg.Get(what, "k2k") """" ", "
		}
	}	
	json .= "}"
	json := StrReplace(json, ", }", "}")
	print(json)

	try {		
		IE.Document.parentWindow.CfgKBmacros(json)
		IE.Document.parentWindow.SelectKey     := Func("SelectKey")		
		IE.Document.parentWindow.AhkPrint      := Func("Print")
		IE.Document.parentWindow.AhkEditCfg    := Func("EditCfg")
		IE.Document.parentWindow.AhkSaveCfg    := Func("SaveCfg")
	} catch {
		ConfigMacros()
	}
	
	gui, Macros:Show
	return
}

ConfigXInput(){	
	static IE
	Gui, XInput:New   
	Gui, XInput:Color, 0xececec
    Gui, XInput:+ParentMain   	
	Gui, XInput:Add, activeX, x5 h700 w800 vIE, Shell.Explorer
    IE.Navigate("file:///" . A_ScriptDir . "/main.html")	
    sleep, 100    
	cfg := {}
	for k, v in StrSplit("mds,a,b,x,y,rs,u,FF", ",")
	{
		val    := g_.GameCfg.Get(v, "j2k")
		cfg[v] := val 
		if ((cfg[v] = "0" or cfg[v] = "false" or  cfg[v] = "")  and k < 6) {
			print("======")
			cfg[v] := v = "mds" ? "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" : ",,,,,,,,,,,,,,,,,,," 
		}
		print(v "->" cfg[v])
	}
	
	XInputEventhandler.document := IE.document
    ComObjConnect(XInputEventhandler.document, XInputEventhandler) 
	XInputEventhandler.document.parentWindow.SelectKey     := Func("SelectKey")
	XInputEventhandler.document.parentWindow.SelectXButton := Func("SelectXButton")
	XInputEventhandler.document.parentWindow.AhkPrint      := Func("Print")
	XInputEventhandler.document.parentWindow.AhkEditCfg    := Func("EditCfg")
	XInputEventhandler.document.parentWindow.AhkSaveCfg    := Func("SaveCfg")
	try {
		IE.Document.parentWindow.ConfigXInput(cfg.mds, cfg.a, cfg.b, cfg.x, cfg.y, cfg.rs, cfg.u, cfg.ff
		, g_.GameCfg.Get("m", "j2k"), g_.GameCfg.Get("dz", "j2k"), g_.GameCfg.Get("spd", "j2k"), g_.GameCfg.Get("rs_alt", "j2k"))
	} catch {
		ConfigXInput()
	}
	gui, XInput:Show
	return
}

ConfigPxSwap(){
	static IE
	static e
	static sw	
	static n
	static p
	static d
	static q	
	n         := g_.GameCfg.Get("n", "PxSwap")
	p         := g_.GameCfg.Get("p", "PxSwap")
	q         := g_.GameCfg.Get("q", "PxSwap")
	d         := g_.GameCfg.Get("d", "PxSwap")
	sw        := g_.GameCfg.Get("sw", "PxSwap")
	enabled   := g_.GameCfg.IsTrue("e", "PxSwap") ? 1 : 0

	GUI, PxSwap: New
	GUI, PxSwap: +hwndhwin
	Gui, PxSwap: +ParentMain  
	GUI, PxSwap: Font, s12	
	GUI, PxSwap: Add, checkbox, x5 h26 gPxEnable checked%enabled% ve section, Enabled
	GUI, PxSwap: Font, bold
	GUI, PxSwap: Add, Text, x5 ,Dump Path:
	GUI, PxSwap: Font, s12 normal
	GUI, PxSwap: Add, Link, gOpenPxPath x+5, % "<a>" A_mydocuments "\WineHooks\Games\" g_.GameCfg.Get("path") "\pixelshaders</a>"
	GUI, PxSwap: Add, Hotkey, x5 y+15 h26 gPxSwapKey vsw section, % sw
	GUI, PxSwap: Add, Text, x+2, Start browsing shaders
	GUI, PxSwap: Add, Hotkey, y+10 xs h26 gPxSwapKey vn, % n
	GUI, PxSwap: Add, Text, x+2, Select the next shader
	GUI, PxSwap: Add, Hotkey, y+10 xs h26 gPxSwapKey vp, % p
	GUI, PxSwap: Add, Text, x+2, Select the previous shader
	GUI, PxSwap: Add, Hotkey, y+10 xs h26 gPxSwapKey vq, % q
	GUI, PxSwap: Add, Text, x+2, Hold this when you click the prev or next hotkeys to quicklly browse shader
	GUI, PxSwap: Add, Hotkey, y+10 xs h26 gPxSwapKey vd, % d
	GUI, PxSwap: Add, Text, x+2, Dump shader
	Gui, PxSwap: Add, activeX, x5 w800 h220 vIE, Shell.Explorer
    IE.Navigate("file:///" . A_ScriptDir . "/main.html")	
	GUI, PxSwap: Show, x300
	WinSetTitle, % "ahk_id " hwin,, % "Configuring: " g_.name
	try {
		IE.document.parentWindow.PSwapHelp()		
	} catch{
		ConfigPxSwap()
	}
	return

	PxEnable:
		Gui, PxSwap: Submit, nohide
		g_.GameCfg.Edit("e", e ? "true" : "false", "PxSwap").save()
	return

	PxSwapKey:
		Gui, PxSwap: Submit, nohide		
		val := {"sw" : sw, "n" : n, "p" : p, "q" : q, "d" : d}[A_GuiControl]		
		;print(A_GuiControl " "val)
		g_.GameCfg.Edit(A_GuiControl, val, "PxSwap").save()
	return

	OpenPxPath:
		try {
			run % A_mydocuments "\WineHooks\Games\" g_.GameCfg.Get("path") "\pixelshaders"
		}catch{
			msgbox, 16, ,The path doesn't exists yet. Please start the game using WineHooks so it will be created 
		}
	return
}

CompileTextures(path){	
	path .= StrReplace(g_.GameCfg.Get("path", "TextSwap"), "Textures\", "")
	run GUIMain.exe "%A_scriptDir%\TextureCompiler.ahk" "%path%"	
	return
} 

ConfigTextSawp(){
/*
➤ DEFAULT REPLACEMENT  ommit this since its meelly for debugging
You can put a .dds file (preferably DXT5 format) named checkerboard.dds on %common_path% and that texture 
will be used to replace any dump missing a replacement in any game
*/
	static TSwapPath := 0	
tuto_0 =
(LTRIM
	Texture swapping allows replacement of a game's textures with no restrictions on size and format and whithout modifing the game's files. 
	Bellow are the texture swapping options (individual, per game), which also seve as a simple tutorial on how to use it 
)	
common_path := A_mydocuments "\WineHooks"
path        := A_mydocuments "\WineHooks\Games\" g_.GameCfg.Get("path") "\Textures\"

	static n 
	static p 
	static q 
	static d 
	static sw
	static IE

	a         := g_.GameCfg.IsTrue("a", "Textswap") 
	e         := g_.GameCfg.IsTrue("e", "Textswap")
	dly       := g_.GameCfg.IsTrue("dly", "Textswap")
	n         := g_.GameCfg.Get("n", "Textswap")
	p         := g_.GameCfg.Get("p", "Textswap")
	q         := g_.GameCfg.Get("q", "Textswap")
	d         := g_.GameCfg.Get("d", "Textswap")
	sw        := g_.GameCfg.Get("sw", "Textswap")	 
	curr_path := StrReplace(g_.GameCfg.Get("path", "Textswap"), "Textures\", "")

	; always set a default value for variables not yet on the GUI 	
	g_.GameCfg.Edit("sz", "384", "TextSwap").Edit("s", "4", "TextSwap").save()

	GUI, TSwap: New
	GUI, TSwap: +hwndhwin	
	GUI, TSwap: Font, s12
	GUI, TSwap: Add, Text, ,% tuto_0
	GUI, TSwap: Add, Checkbox, gtswapcheck checked%e%, Enabled 
	GUI, TSwap: Add, Hotkey, h26 gTswapKey vsw section, % sw
	GUI, TSWap: Add, Text, x+2, To replace textures, 1st you have to dump them to disk. Configure here a hotkey to start browsing the game's textures
	GUI, TSwap: Add, Hotkey, y+10 xs h26 gTswapKey vn, % n
	GUI, TSWap: Add, Text, x+2, Select the next texture
	GUI, TSwap: Add, Hotkey, y+10 xs h26 gTswapKey vp, % p
	GUI, TSWap: Add, Text, x+2, Select the previous texture
	GUI, TSwap: Add, Hotkey, y+10 xs h26 gTswapKey vq, % q
	GUI, TSWap: Add, Text, x+2, Hold this when you click the prev or next hotkeys to quicklly browse textures
	GUI, TSwap: Add, Hotkey, y+10 xs h26 gTswapKey vd, % d
	GUI, TSWap: Add, Text, x+2, Dump the curreclly select texture to disk
	GUI, TSwap: Add, Text, y+10 xs, Path where to dump textures to:
	path_checked := curr_path = "VOKSI" ? 1 : 0
	GUI, TSWap: Add, Radio, y+2 checked%path_checked% vTSwapPath gTextSwapPath section, % path "VOKSI"
	for i, p in StrSplit("CPY CODEX SKIDROW RELOADED EMPRESS FITGIRL", " ") {
		path_checked := curr_path = p ? 1 : 0
		GUI, TSWap: Add, Radio, checked%path_checked% y+1 gTextSwapPath, % path "" p
	}		
	Gui, TSwap: Add, activeX, y+20 w1300 h300 vIE, Shell.Explorer
    IE.Navigate("file:///" . A_ScriptDir . "/main.html")	
	GUI, TSwap: Add, Checkbox, ys-2 xs+900 gtswapcheck checked%a%, Auto dump
	GUI, TSwap: Add, Checkbox, y+3 gtswapcheck checked%dly%, Delay releases - need by some Direct3D "1" games
	GUI, TSwap: Add, Button, y+3 gtswapviewfolders, 📂 Open selected folder
	;GUI, TSwap: Add, Checkbox, ys-2 xs+900, Alpha textures fix - Direct3D 7
	GUI, TSwap: Show
	;Gui, TSwap:+ParentMain  	

	try {
		IE.document.parentWindow.TSwapHelp(path)
		IE.document.parentWindow.CompileTextures := Func("CompileTextures")
	} catch{
		ConfigTextSawp()
	}

	WinSetTitle, % "ahk_id " hwin,, % "Configuring: " g_.name
	;WinMove, % "ahk_id " hwin, , 0, 0
	return

	tswapviewfolders:
		Gui,TSwap: submit, nohide
		try{	
		run % A_mydocuments "\WineHooks\Games\" g_.GameCfg.Get("path") "\Textures\" StrSplit("VOKSI CPY CODEX SKIDROW RELOADED EMPRESS FITGIRL" , " ")[TSwapPath]
		}catch{
			Msgbox, 16, ,The path doesn't exists yet. Please start the game using WineHooks so it will be created 
		}
	return	

	tswapcheck:	
		GuiControlGet, hbox, TSwap:hwnd, % A_GuiControl
		ControlGet, state, Checked,,, ahk_id %hbox%
		state := state ? "true" : "false"
		vmap  := {"Enabled" : "e", "Auto dump" : "a", "Delay releases - need by some Direct3D ""1"" games" : "dly"}		
		g_.GameCfg.Edit(vmap[A_GuiControl], state, "TextSwap").save()
	return

	TswapKey:		
	    val := {"sw" : sw, "n" : n, "p" : p, "q" : q, "d" : d}[A_GuiControl]				
		g_.GameCfg.Edit(A_GuiControl, val, "TextSwap").save()		
	return	

	TextSwapPath:
		Gui,TSwap: submit, nohide	
		selected_path := StrSplit("VOKSI CPY CODEX SKIDROW RELOADED EMPRESS FITGIRL", " ")[TSwapPath]		
		g_.GameCfg.Edit("path", "Textures\" selected_path, "TextSwap").save()
	return
}
BetaWarn(){
stable := g_.Stabe
warn =
(
Not immplemented on the beta. If you're on windows, please download the 
<a href="%stable%">last stable version</a> 
)	
	Gui,Warn:+hwndhwin	     
	Gui,Warn:Font, bold s20 c761602
	Gui,Warn:Add, Text, , WARNING
	Gui,Warn:Font, bold s16 c761602
	Gui,Warn:Add, Link, y+2, % warn
    Gui,Warn: Show
	WinSetTitle, % "ahk_id " hwin,, WineHooks`, 0.10.13 beta  
}
Linkcliked(){
    msgbox % errorlevel
}
MainGuiClose(hwin) {
    ExitApp
}
Main()
Wellcome()
return
