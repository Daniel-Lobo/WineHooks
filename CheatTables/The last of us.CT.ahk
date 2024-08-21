#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"545x130
=================================================================
INFINITE ITEMS
When enabled, this will freeze the amount of most ammunitions, items, and upgrade items at 1000 
and that of most craft items at 250. When disabled, the items will return their original amount plus 
any amount you collected
=================================================================
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global items    := new CEEntry("I - Inf ammo and items")
class TLOUSTrainer extends CETrainer
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
        else if CETrainer.keyevent("ì") > 0				
        {	
            this.Speak(EZKills.Toogle("Infinite items"))	
        }	
	}
}

TLOUSTrainer.TrainerLoop("tlou.exe", 100)
return




