#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"560x200
===================================================================
GAIN SALVAGE
While this is active, you'll gain 100 salvage each time you enter a campfire
===================================================================

===================================================================
GAIN SKILLS POINTS
Gives one skill point when you enter a campfire. To gain another point, deactivate and reactivate the
cheat then enter the campfire again
===================================================================
"
)

global HP         := new CEEntry("H - inf HP")
global Kills      := new CEEntry("K - easy kills")
global Skills     := new CEEntry("P - gain skill Points")
global salvage    := new CEEntry("G - Gain salvage")
global Ammo       := new CEEntry("B - inf Bullets")


class TRTrainer extends CETrainer
{
	OnLoop() 
	{
		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("infinite HP"))

		else if CETrainer.keyevent("k") > 0				
		this.Speak(Kills.Toogle("1 hit kills"))

		else if CETrainer.keyevent("p") > 0				
		this.Speak(Skills.Toogle("gain skill Points"))

		else if CETrainer.keyevent("g") > 0				
		this.Speak(salvage.Toogle("Gain salvage"))		

		else if CETrainer.keyevent("B") > 0				
		this.Speak(Ammo.Toogle("infinite Ammo"))	
	}
}
TRTrainer.TrainerLoop("TombRaider.exe", 100)
return



	