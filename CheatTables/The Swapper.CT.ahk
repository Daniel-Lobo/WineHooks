#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global clones := new CEEntry("C - inf Clones")

class SwapperTrainer extends CETrainer
{
    OnLoop()
	{
        If CETrainer.keyevent("C") > 0
        {
            this.Speak(clones.Toogle("infinite clones"))   
        }                    
    }
}
SwapperTrainer.__init().TrainerLoop("TheSwapper.exe", 100)
return






