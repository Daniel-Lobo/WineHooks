;REMOTE SCRIPT START
;while ! Keyevent("q")
	;continue
	
logErr(IDirectDraw4.unhook("EnumDisplayModes"))	
logErr(IDirectdraw4.Hook("Initialize"))
IDirectdraw4_Initialize(p1)
{
	;dllcall(IDirectdraw4.Initialize, ptr, p1)
	return 0
}

