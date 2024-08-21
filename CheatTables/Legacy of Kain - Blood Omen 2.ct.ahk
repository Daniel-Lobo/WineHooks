#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x130
==========================================================================
LEVEL UP
This is ment to reduce the tiresome blood sucking. It is possible to level up 15 times. Each upgrade will zero the 
lore metter, so you can disconsider any eventual upgrades from the blood you will have to suck to restore 
Kain's HP. 
==========================================================================
"
)

global level_up  := new CEEntry("U - level UP")
global HP        := new CEEntry("H - inf HP")
global Kills     := new CEEntry("K - easy kills")
global Rage      := new CEEntry("R - inf Rage ")
class BO2Trainer extends CETrainer
{
	OnLoop() 
	{
		if CETrainer.keyevent("k") > 0				
		this.Speak(Kills.Toogle("1 hit kills"))

		else if CETrainer.keyevent("r") > 0				
		this.Speak(Rage.Toogle("infinite Rage"))		

		else if CETrainer.keyevent("h") > 0					
		this.Speak(HP.Toogle("infinite HP"))	
		
		else if this.Keyevent("u")		
		{				
			level_up.SetFrozen(1, 0)		
			KeyWait, u, UP			
			level_up.SetFrozen(0, True)			
		}
	}
}
BO2Trainer.TrainerLoop("bo2.exe", 100)
return



	