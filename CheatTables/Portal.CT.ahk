#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"400x80
Adapted from:
https://guidedhacking.com/resources/portal-cheat-table-trainer-3.302/
"
)

global HP       := new CEEntry("H - inf HP")
global portals  := new CEEntry("P - Portals anywhere")

class PortalTrainer extends CETrainer
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
        if CETrainer.keyevent("p") > 0  
        {   
            this.reset()
            this.Speak(portals.Toogle("Portals anywhere"))
        }			        

    }
}
PortalTrainer.TrainerLoop("hl2.exe", 100)
return




