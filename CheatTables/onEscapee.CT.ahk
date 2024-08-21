#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __hp    := new CEEntry("H - freeze HP")
class onScappeTrainer extends CETrainer
{
    OnLoop()
	{        
        if (CETrainer.keyevent("H") > 0)
        {
            this.Speak(__hp.Toogle("Freeze HP"))   
            __hp.SetValue(0xFF)
        }                   
    }
}
onScappeTrainer.__init().TrainerLoop("onEscapee.exe", 100)
return






