#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __auto  := new CEEntry("Auto")
global cheats  := new CEEntry("Auto - cheats")
global clip    := new CEEntry("N - No clip")

class TalosTrainer extends CETrainer
{   
    OnLoop() 
    {        
        if (!__auto.IsFrozen())
        {
            this.open("Talos.exe")
            __auto.SetFrozen(1, 0)	     
            if (__auto.IsFrozen())
            {
                this.PlaySound(1)
            }
        }    
        if CETrainer.keyevent("N") > 0  
        {              
            if (clip.GetValue(16) = "0")      
            {
                cheats.SetValue(3)
                clip.SetValue(1)
                this.speak("No clip enabled")
            } else {
                cheats.SetValue(0)
                clip.SetValue(0)
                this.speak("No clip disabled")
            }
        }			        

    }
}
TalosTrainer.TrainerLoop("Talos.exe", 100)
return




