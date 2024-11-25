#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include ini.ahk

;IniFast exemple
ini := new IniFast("target.txt")
ini.show_()
fileappend % ini.read("somekey", "section") "`n", *
ini.edit("somekey", "changedvalue", "section")
ini.show_()
ini.save()

exitapp