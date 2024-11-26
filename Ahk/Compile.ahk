#NoEnv 
#Warn
SendMode Input 
SetWorkingDir %A_ScriptDir%

scripts := "Xinput injector injector64 exlib remote_lib CreateProcessHooks MCI dshow.hooks dsound.hooks dinput.hooks WinAPI.Hooks "
. "D3D.hooks D3D8.hooks D3D9.hooks D3DX9 D3D11.hooks D3D12.hooks gl.hooks"
dir := A_scriptdir "\GUI"

for k, v in strsplit(scripts, " ")
	Gui, add, checkbox, ,%v%.ahk
Gui, add, button, w80 h30, Compile
gui, add, checkbox, vwip checked1 h30 w80 y0 x200, wip
gui, add, checkbox, vdprctd checked0 h30 w80 yp+22 x200, deprecated
gui, add, button, grun h30 w80, gl
gui, add, button, grun h30 w80, dx7-
gui, add, button, grun h30 w80, dx7c
gui, add, button, grun h30 w80, dx8
gui, add, button, grun h30 w80, dx9
gui, add, button, grun h30 w80, dx10+
gui, add, button, grun h30 w80, WHKS
gui, add, button, grun h30 w80, mci
gui, add, button, grun h30 w80, fldrs
gui, add, button, grun h30 w80, links
gui, add, button, grun h30 w80, MHKS
gui, add, button, grun h30 w80, dsnd
gui, add, button, grun h30 w80, j2k
gui, add, button, grun h30 w80, lst
Gui, show, w300
return

run:    
    gui, submit, nohide 
    exe    := dir "\GUIMain.exe"
    script := dir "\GUIMain.ahk" 
    cmd    := wip ? "-wip" : ""
    cmd    .= dprctd ? " -dprctd -" : " -" 
    cmd    .= A_GuiControl      
    run, % """" exe """ "  """" script """ " cmd, %dir%
return     

CompileScript(script)
{
	if A_iscompiled 
		return	
	fileappend, processing %script%, *
	splitpath, script, , , ,name	
	if (name="Xinput")
		runwait, "%A_scriptDir%\Compiler\Ahk2Exe.exe" /in "%A_scriptdir%\lib\DirectX\%script%" /out "%A_Temp%\%name%".exe 
	else runwait, "%A_scriptDir%\Compiler\Ahk2Exe.exe" /in "%A_scriptDir%\%script%" /out "%A_Temp%\%name%".exe 							
	txt := LoadResource(">AUTOHOTKEY SCRIPT<", A_Temp "\" name ".exe")
	fileopen("src\" name ".txt", "w").write(txt)	
}

LoadResource(res, _mod = "")
{
	hmod   := dllcall("LoadLibraryW", str, _mod)
	HRSRC  := dllcall("FindResourceW", uint, hmod, str, res, ptr, 10)
	hRes   := dllcall("LoadResource", uint, hmod, uint, HRSRC)
	sz     := DllCall("SizeofResource", ptr, hmod, ptr, HRSRC, uint)
	pResDt := dllcall("LockResource", uint, hRes, ptr)
	ret    := strget(pResDt, sz, "UTF-8")	
	dllcall("FreeLibrary", uint, hmod)	
	return ret
}

ButtonCompile:
	stat := 0
	for k, v in strsplit(scripts, " ")
	{	
		guicontrolget, stat, ,%v%.ahk
		if (stat)
			CompileScript(v ".ahk")
	}
	fileappend, Done`n, *
return

Guiclose:
exitapp
