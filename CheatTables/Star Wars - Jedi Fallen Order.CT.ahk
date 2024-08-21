#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global Auto     := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global Force    := new CEEntry("I - Inf force")
class JediOrderTrainer extends CETrainer
{	
	OnLoop() 
	{
        if (Auto.IsFrozen()=0)
        {
            Auto.SetFrozen(1, 1)	           			
        }
		if CETrainer.keyevent("h") > 0  
        {   
			this.Speak(HP.Toogle("Infinite HP"))
        }
        else if CETrainer.keyevent("k") > 0	
        {
            this.Speak(EZKills.Toogle("easy kills"))	
        }		
        else if CETrainer.keyevent("k") > 0	
        {
            this.Speak(EZKills.Toogle("Infinite force"))	
        }			
	}
}
JediOrderTrainer.TrainerLoop("SwGame-Win64-Shipping.exe", 100)
return


