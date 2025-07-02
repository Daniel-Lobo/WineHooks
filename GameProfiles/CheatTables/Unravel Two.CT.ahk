#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __auto   := new CEEntry("Auto")
global fly      := new CEEntry("F - hold to Float")
class Unravel2Trainer extends CETrainer
{
    OnLoop()
	{
        if (!__auto.IsFrozen())
        {
            this.open("UnravelTwo.exe")
            __auto.SetFrozen(1, 0)	
            if (__auto.IsFrozen())
                this.PlaySound(1)
        }       	

        if CETrainer.keyevent("f") > 0	
        {	
            fly.SetFrozen(1, 1)
            KeyWait, f, Up
            fly.SetFrozen(0, 1)
        }			
	}
}
Unravel2Trainer.__init().TrainerLoop("UnravelTwo.exe", 100)
return






