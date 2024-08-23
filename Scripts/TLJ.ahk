target := g_.target
SplitPath, target, ,dir
if fileexist(dir "\tweak.ini")
IniWrite, 500 %dir%\tweak.ini, FloatingMenu, int_MouseOutsideDelay
;REMOTE SCRIPT START
;logerr("Alt_GetDoubleClickTime  " InstallHook("Alt_GetDoubleClickTime", p, "User32.dll", "GetDoubleClickTime")) 
g_.s.GetDoubleClickTime := p

Alt_GetDoubleClickTime(){	
	DoubleClickTime := DllCall(g_.s.GetDoubleClickTime, uint)
	logerr("DoubleClickTime" DoubleClickTime)
	return DoubleClickTime
}