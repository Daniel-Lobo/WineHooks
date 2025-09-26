#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x100
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global InfAmmo  := new CEEntry("B - inf Bullets")
global power    :=  new CEEntry(  "P inf armor Power")
class HaloMCCTainer extends CETrainer
{
	OnLoop()
	{
		if (!__auto.IsFrozen())
		{
			__auto.SetFrozen(1)	
		}	

		if CETrainer.keyevent("h") > 0					
		this.Speak(HP.Toogle("Infinite HP"))		

		else if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("One hit kills"))	

		else if CETrainer.keyevent("b") > 0				
		this.Speak(InfAmmo.Toogle("Infinite ammo"))	
		
		else if CETrainer.keyevent("p") > 0				
		this.Speak(power.Toogle("Infinite armor ability"))	
	}
}

HaloMCCTainer.TrainerLoop("MCCWinStore-Win64-Shipping.exe", 100)
return




