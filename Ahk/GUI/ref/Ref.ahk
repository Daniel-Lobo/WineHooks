#NoEnv                       ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn                        ; Enable warnings to assist with detecting common errors.
SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;wbs.document.parentwindow.execScript("alert('Hello, world!')");
dllcall("AllocConsole")
StartServer()

/*
;Gui, +0x00040000
Gui, Add, ActiveX, x0 y0 w1460 h900 vwb hwndhwb,about:<!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge"></meta></html></head>
wb.Navigate("http://127.0.0.1:5000")
Gui, Margin, 0 0
Gui, Show, w1460 h900
OnMessage(0x0005, "OnWindowResized")
*/

GuiClose() {
    ExitApp
}

OnWindowResized(wParam, lParam, msg, hwnd){
    height := (lParam & 0xFFFF0000) >> 16
    width  := (lParam & 0xFFFF)
    FileOpen("*", "w").write(width "x" height "`n")
    GuiControl, Move, WB, % "w" width " h" height
}

StartServer() {
    hpex    := dllcall("LoadLibraryW", str, StrReplace(A_ScriptDir, "GUI", "") "\peixoto.dll")
    pServer := dllcall("GetProcAddress", ptr, hpex, astr, "Serve")    
   ;; dllcall("CreateThread", uint, 0, uint, 0, ptr, pServer, ptr, RegisterCallback("Requesthandler"), uint, 0, ptr, 0)
   dllcall( pServer, ptr, RegisterCallback("Requesthandler"))
}

Base64Enc( ByRef Bin, nBytes, LineLength := 64, LeadingSpaces := 0 ) { ; By SKAN / 18-Aug-2017
    Local Rqd := 0, B64, B := "", N := 0 - LineLength + 1  ; CRYPT_STRING_BASE64 := 0x1
    DllCall( "Crypt32.dll\CryptBinaryToString", "Ptr",&Bin ,"UInt",nBytes, "UInt",0x1, "Ptr",0,   "UIntP",Rqd )
    VarSetCapacity( B64, Rqd * ( A_Isunicode ? 2 : 1 ), 0 )
    DllCall( "Crypt32.dll\CryptBinaryToString", "Ptr",&Bin, "UInt",nBytes, "UInt",0x1, "Str",B64, "UIntP",Rqd )
    If ( LineLength = 64 and ! LeadingSpaces )
        Return B64
    B64 := StrReplace( B64, "`r`n" )        
    Loop % Ceil( StrLen(B64) / LineLength )
        B .= Format("{1:" LeadingSpaces "s}","" ) . SubStr( B64, N += LineLength, LineLength ) . "`n" 
    Return RTrim( B,"`n" )    
}

Reverse(Str) {
    Loop, Parse, Str
        nStr=%A_LoopField%%nStr%
    Return nStr
}    

EndsWith(Haystack, Needle){    
    return InStr(Reverse(Haystack), Reverse(Needle)) = 1 ? true : false
}

Requesthandler(path){
    static reply := "OK"
    request      := StrReplace(StrGet(path, "Cp0"), "/", "",,1)
    winehooks    := A_mydocuments "\WineHooks"   
    FileOpen("*", "w").write(request "`n")
    if (request = ""){
        reply := FileOpen("Main.html", "r").read()
    }
    else if EndsWith(request, ".jpg") or EndsWith(request, ".png"){
        bytes := ""
        img   := FileOpen("test.jpg", "r")
        count := img.RawRead(bytes, img.Length)       
        reply := Base64Enc(bytes, count)       
       ; FileOpen("*", "w").write(reply "`n")
    }
    else if (InStr(request, "GetGamesList") > 0) {        
        reply := ""
        loop, % winehooks "\Profiles\*.*" {           
            reply .= A_loopfilename . "\n"
        }           
    }
    else {
        reply := FileOpen(request, "r").read()
    }
    ;FileOpen("*", "w").write(reply "`n")
    return &reply
}
return
