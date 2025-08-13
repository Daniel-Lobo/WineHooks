#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global cheats  := new CEEntry("C - enable Cheats")

class Talos2Trainer extends CETrainer
{   
    OnLoop() 
    {   
        if CETrainer.keyevent("C") > 0   
        {
            cheats.SetFrozen(1, 0)
            this.speak("Cheats Activated")
        }
    }           
}
Talos2Trainer.TrainerLoop("Talos2-Win64-Shipping.exe", 100)
return




