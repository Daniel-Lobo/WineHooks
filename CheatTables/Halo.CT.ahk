#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x100
Works with Halo custom edition (http://hce.halomaps.org/?fid=410)
version 1.0.1 (http://hce.halomaps.org/index.cfm?fid=6798)
with Chimera (https://opencarnage.net/index.php?/topic/6916-chimera-download-source-and-discord-updated-2021-05-04/)
"
)

global Player   := new CEEntry("Auto - Player")
global Damage   := new CEEntry("Auto - Damage")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global InfAmmo  := new CEEntry("B - inf Bullets and grenades")
class HaloCETainer extends CETrainer
{
	OnLoop()
	{
		if (!Player.IsFrozen())
		{
			Player.SetFrozen(1)			
			Damage.SetFrozen(1)
		}	

		if CETrainer.keyevent("h") > 0					
		this.Speak(HP.Toogle("Infinite HP"))		

		else if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("One hit kills"))	

		else if CETrainer.keyevent("b") > 0				
		this.Speak(InfAmmo.Toogle("Infinite ammo"))			
	}
}

HaloCETainer.TrainerLoop("Haloce.exe", 100)
return




