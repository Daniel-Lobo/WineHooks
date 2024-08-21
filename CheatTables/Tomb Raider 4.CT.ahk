#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP         := new CEEntry("H - inf HP")
global Ammo       := new CEEntry("B - inf Bullets")
global flares     := new CEEntry("F - inf Flares")
global sprint     := new CEEntry("S - inf Sprint")

class Tomb4Trainer extends CETrainer
{
	OnLoop() 
	{
		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("infinite HP"))			

		else if CETrainer.keyevent("B") > 0				
		this.Speak(Ammo.Toogle("infinite Ammo"))	

        else if CETrainer.keyevent("f") > 0				
        this.Speak(flares.Toogle("infinite flares"))	

        else if CETrainer.keyevent("s") > 0				
        this.Speak(sprint.Toogle("infinite sprint"))	
	}
}
Tomb4Trainer.TrainerLoop("tomb4.exe", 100)
return



	