#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global auto     := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global InfAmmo  := new CEEntry("B - inf Bullets")
class OniTainer extends CETrainer
{
	OnLoop()
	{
		if (!auto.IsFrozen())
		{
			auto.SetFrozen(1)		
		}	

		if CETrainer.keyevent("h") > 0					
		this.Speak(HP.Toogle("Infinite HP"))		

		else if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("One hit kills"))	

		else if CETrainer.keyevent("b") > 0				
		this.Speak(InfAmmo.Toogle("Infinite ammo"))			
	}
}

OniTainer.TrainerLoop("Oni.exe", 100)
return




