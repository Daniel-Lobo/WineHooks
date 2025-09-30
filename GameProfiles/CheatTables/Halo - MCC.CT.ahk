#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"460x70
Wait until you start a game to activate cheats. After that, if you leave that game
and try to start another one, it will crash or go back to the title screen 
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global InfAmmo  := new CEEntry("B - inf Bullets")
global power    :=  new CEEntry(  "P inf armor Power")
class HaloMCCTainer extends CETrainer
{
	HaloMCCSctivate()
	{
		if (!__auto.IsFrozen())
		{
			__auto.SetFrozen(1)	
		}	
	}

	OnLoop()
	{		

		if CETrainer.keyevent("h") > 0
		{		
			this.HaloMCCSctivate()			
			this.Speak(HP.Toogle("Infinite HP"))		
		}

		else if CETrainer.keyevent("k") > 0		
		{		
			this.HaloMCCSctivate()					
			this.Speak(EZKills.Toogle("One hit kills"))	
		}

		else if CETrainer.keyevent("b") > 0	
		{									
			this.Speak(InfAmmo.Toogle("Infinite ammo"))	
		}
		
		else if CETrainer.keyevent("p") > 0		
		{									
			this.Speak(power.Toogle("Infinite armor ability"))	
		}
	}
}

HaloMCCTainer.TrainerLoop("MCCWinStore-Win64-Shipping.exe", 100)
return




