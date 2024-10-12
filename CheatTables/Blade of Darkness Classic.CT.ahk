#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"280x100
================================
EZ KILLS
With this active, fire will kill you instantly
================================
"
)

global __auto   := new CEEntry("Auto Blade.SetEntityFloatProperty+68C")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global stamina  := new CEEntry("Z - inf Stamina")
class BladeTainer extends CETrainer
{    
	OnLoop()
	{        
		if (!__auto.IsFrozen())
        {
            __auto.SetFrozen(1, 0)	           
        }           
		if CETrainer.keyevent("h") > 0	
		{	
			this.Speak(HP.Toogle("Infinite HP"))	
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.Speak(EZKills.Toogle("One hit kills"))	
		}		
        else if CETrainer.keyevent("z") > 0				
		{	
			this.Speak(stamina.Toogle("Infinite stamina"))	
		}	
	}
}

BladeTainer.TrainerLoop("Blade.exe", 100)
return




