#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x100
==========================================================================
GAIN SPIRIT LIGHT
Press L during normal gameplay to gain 100 spirit light
==========================================================================
"
)


global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Saves    := new CEEntry("E - inf Energy")
global Light    := new CEEntry("L - gain spirit Light") 

class Ori2Trainer extends CETrainer
{
    Reset()
    {
        dllcall(CEFuncs.f.openProcessEx, ptr, this.p.ProcID(this.proc_name))
    }
    OnLoop() 
    {       
        if CETrainer.keyevent("h") > 0  
        {   
            this.Speak(HP.Toogle("Infinite HP"))
        }			        

        else if CETrainer.keyevent("k") > 0		
        {		
            this.Speak(EZKills.Toogle("One hit kills"))	
        }

        else if CETrainer.keyevent("E") > 0	
        {	
            this.Speak(Saves.Toogle("inf Energy"))	
        }

        else if (p := CETrainer.keyevent("L") = 1)	
        {	
            Light.SetFrozen(1, 0)	
            keywait, L
            Light.SetFrozen(0, 1)	
        }	
    }
}
Ori2Trainer.TrainerLoop("oriwotw.exe", 100)
return




