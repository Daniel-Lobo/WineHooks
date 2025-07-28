#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP         := new CEEntry("H - inf HP")
global Ammo       := new CEEntry("B - inf Bullets")
global light      := new CEEntry("F - inf Flashlight")
global ezkill     := new CEEntry("K - easy Kills")


class TomblegendTrainer extends CETrainer
{
	OnLoop() 
	{
		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("infinite HP"))			

		else if CETrainer.keyevent("k") > 0
		this.Speak(ezkill.Toogle("easy kills"))

		else if CETrainer.keyevent("B") > 0				
		this.Speak(Ammo.Toogle("infinite Ammo"))	    
        
        else if CETrainer.keyevent("f") > 0				
        this.Speak(light.Toogle("infinite Flashlight"))	    
	}
}
TomblegendTrainer.TrainerLoop("trl.exe", 100)
return



	
