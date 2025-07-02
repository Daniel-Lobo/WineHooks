#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x120
=====================================================================
=====================================================================
"
)

global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global InfAmmo  := new CEEntry("B - inf Bullets")
class WolfTNCTrainer extends CETrainer
{
	OnLoop() 
	{
		if CETrainer.keyevent("h") > 0					
		this.Speak(HP.Toogle("Infinite HP"))	
			
		else if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("One hit kills"))	
		
		else if CETrainer.keyevent("b") > 0						
		this.Speak(InfAmmo.Toogle("Infinite ammo"))				
	}		
}

WolfTNCTrainer.TrainerLoop("NewColossus_x64vk.exe", 100)
return
	





