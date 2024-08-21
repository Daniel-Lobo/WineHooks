#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP       := new CEEntry("H - inf HP")
global jumps    := new CEEntry("J - inf Jumps")

class EntropyTrainer extends CETrainer
{
    Reset()
    {
        dllcall(CEFuncs.f.openProcessEx, ptr, this.p.ProcID(this.proc_name))  
    }
    OnLoop() 
    {         
        if CETrainer.keyevent("h") > 0  
        {   
            this.reset()
            this.Speak(HP.Toogle("Infinite HP"))
        }	
        if CETrainer.keyevent("j") > 0  
        {   
            this.reset()
            this.Speak(jumps.Toogle("Infinite Jumps"))
        }			        

    }
}
EntropyTrainer.TrainerLoop("EntropyCentre-Win64-Shipping.exe", 100)
return




