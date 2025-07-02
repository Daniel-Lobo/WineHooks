#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"545x130
=================================================================
EASY KILLS
This makes enemies spawn with 1 HP. So even if you disable it after the enemy has spawned, it will 
still die in one hit. If you enable this after the enemy has spawned, it will die with two hits.
=================================================================
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global items    := new CEEntry("B - inf Bullets")
class TLOUSTrainer extends CETrainer
{    
	OnLoop()
	{        
		if (!__auto.IsFrozen())
        {
			this.AltOpen()		
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
        else if CETrainer.keyevent("b") > 0				
        {	
            this.Speak(items.Toogle("Infinite ammo"))	
        }	
	}
}

TLOUSTrainer.TrainerLoop("tlou-ii.exe", 100)
return




