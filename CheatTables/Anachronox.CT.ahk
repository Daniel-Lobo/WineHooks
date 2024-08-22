#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"490x270
==========================================================
INFINTE HEALTH
Only protects from physical attacks, but refills the HP of the character that takes the hit.
HP also instantly refils when not in battle 
==========================================================

==========================================================
EASY KILLS
One hit kills with physical attacks
==========================================================

==========================================================
RECHAGE ENERGY
When enabled, energy instantly recharges at any point, except battles
==========================================================
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global energy   := new CEEntry("R - Recharge energy")
class AnoxTrainer extends CETrainer
{    
	OnLoop()
	{        
		if (!__auto.IsFrozen())
        {
            this.Open("Anox.exe")
            __auto.SetFrozen(1)	           
        }
		if CETrainer.keyevent("h") > 0	
		{	
			this.Speak(HP.Toogle("Infinite HP"))	
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.Speak(EZKills.Toogle("One hit kills"))	
		}	
        else if CETrainer.keyevent("R") > 0				
		{	
			this.Speak(energy.Toogle("Recharge energy"))	
		}	
	}
}

AnoxTrainer.__Init().TrainerLoop("Anox.exe", 100)
return




