#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 

global Stamina  := new CEEntry("Z - inf stamina")
global ammo     := new  CEEntry("B - inf Bullets")
class AliveTrainer extends CETrainer
{
	OnLoop()
	{
		if CETrainer.keyevent("z") > 0				
		this.Speak(Stamina.Toogle("Infinite Stamina"))	

		else if CETrainer.keyevent("B") > 0				
		this.Speak(ammo.Toogle("Infinite ammo"))				
	}
}

AliveTrainer.TrainerLoop("IAmAlive_game.exe", 100)
return






