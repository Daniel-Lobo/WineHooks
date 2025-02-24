#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory. 

dllcall("AllocConsole")
print(msg){
    FileOpen("*", "w").write(msg "`n")
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
,"BasePath"   : A_mydocuments "\WineHooks\"
,"HelpPath"   : A_mydocuments "\WineHooks\Help\"
,"Profiles"   : A_mydocuments "\WineHooks\Profiles\"} 

g_.Links :=  {"Donate"   : "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=E68RE3UWG2ZEU&lc=US&"
    . "item_name=Peixoto&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted"
    , "Peixoto"      : "http://www.vogons.org/viewtopic.php?f=24&t=53121"
    , "cheat"        : "https://www.cheatengine.org/"
    , "patreon_home" : "https://www.patreon.com/user/about?u=44312848"
    , "Archive"      : "https://github.com/Daniel-Lobo/WineHooks/releases"
    , "Wine"         : "https://www.winehq.org/"
    , "dxvk"         : "https://github.com/doitsujin/dxvk/releases"}
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

GetArgs(args){
    args := StrReplace(StrGet(args+0, ,"CP0"), "%20", " ")
    ;print("args " args)
    ret  := {}
    for _, arg in StrSplit(args, "&")
    {
        split := StrSplit(arg, "=")
        if (split.Length() = 2)
        {
            ret[split[1]] := split[2]
        }
    }
    ;for key, val in ret
        ;print(key " = " val)
    return ret
}

Image(socket, path){
    file:= "img" . path
    ext := SubStr(file, -3)
    ;print(file)
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
    games_list_loader := LoadFile("games-list-loader")
    return StrReplace(home_html, "{games-list}", games_list_loader)
}

HomeRoute(){
    if (g_.games_list.Length() = 0)
    BuidGamesList()    
    home_html           := StrReplace(LoadFile("base"), "{home}", LoadFile("home"))
    home_html           := StrReplace(home_html, "{config-ini}", LoadFile("config-ini"))
    games_list_template := LoadFile("games-list")
    games_list          := ""
    for _, game in g_.games_list {
        html = 
        (LTRIM
            <button type="button" class="btn btn-light nav-item-container" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-title="%game%">
				<span class='nav-item nav-item-container'>  %game% </span>
			</button>   
        )        
        games_list .= html
    }
    games_list_template := StrReplace(games_list_template, "{games-list}", games_list)
    return StrReplace(home_html, "{games-list}", games_list_template)
}

GetHandler(socket, p, a){    
    ;print("GetHandler: " strGet(p+0, ,"CP0"))
    path := S(StrGet(p+0, ,"CP0"))       
    ext  := SubStr(path.__str, -3, 4)
    if InStr(".png .jpg .ico", ext)
    return Image(socket, path.__str)
    else if (ext = ".css")
    return CSS(socket, path.__str)    

    args  := GetArgs(a)  
    reply := HTMLReply("<div><img src=""WINE.png"" /></div>")    
    if (path.__str = "/")
        reply := HTMLReply(RootRoute())
    else if (path.__str = "/home")
        reply := HTMLReply(HomeRoute())
      
    
    DllCall(g_.p_send, uint, socket, astr, reply, uint, strlen(reply), uint, 0, uint) 
}

JSONReply(reply){
    return "HTTP/1.1 200 OK`r`nContent-Type: application/json`r`nContent-Length: " . strlen(reply) . "`r`n`r`n" . reply 
}

HandleAction(action){
    if (link := g_.Links[action]){
        ;print(link)
        run, %link%    
        return
    }
    print(action)
    run, %action%
}

GetHelpFileName(cfg){
    help   := trim(new IniString(cfg).Get("Help"))
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
    print(profiles " " help " " tables " " scripts)
    return JSONReply("{""Profiles"" : " . profiles . ", ""Help"" : " . help . ", ""CheatTables"" : " . tables . ", ""Scripts"" : " . scripts . "}")    	
}

SaveFile(file_name, contents){	
	try {
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
        reply := PlainReply(GetHelpFileName(body))
    }
    else if (path.__str = "/GetCheatTableName"){
        reply := PlainReply(GetCheatTableName(args.IniFileName))
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
        print(body)
        reply := PlainReply(FileExist(body))
    }
    DllCall(g_.p_send, uint, socket, astr, reply, uint, strlen(reply), uint, 0, uint) 
}

serve()
