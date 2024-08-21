#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __auto := new CEEntry("Auto")
global fly    := new CEEntry("F - Fly mode")
global y_pos  := new CEEntry("y_pos")

class ContrastTrainer extends CETrainer
{
    OnLoop() 
    {     
        if (!__auto.IsFroozen())
        {
            __auto.SetFrozen(1, 1)            
        }  

        if CETrainer.keyevent("f") > 0  
        {
            this.Speak(fly.Toogle("Fly mode"))   
        }    
        while getkeystate("r")
        {
            y_pos.SetValue(y_pos.GetValue(16)+5) 
            sleep, 15
        }
        while getkeystate("v")
        {
            y_pos.SetValue(y_pos.GetValue(16)-5) 
            sleep, 15
        }
    }    
}
ContrastTrainer.TrainerLoop("ContrastGame.exe", 100)
return




