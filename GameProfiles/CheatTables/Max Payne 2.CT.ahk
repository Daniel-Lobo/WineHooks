#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent


global __auto   := new CEEntry("Auto")
global Damage   := new CEEntry("Auto - Damage")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global ammo     := new CEEntry("B - inf Bullets")
global time     := new CEEntry("T - inf bullet Time")

class MaxPayne2Trainer extends CETrainer
{
	OnLoop() 
	{			
		if (!__auto.IsFrozen())
		{
			__auto.SetFrozen(1, 1)			
		} 

		if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

        if CETrainer.keyevent("b") > 0				
        this.Speak(ammo.Toogle("Infinite bullets"))	
    
        else if CETrainer.keyevent("t") > 0				
        this.Speak(time.Toogle("Infinite bullet time"))
	}
}
MaxPayne2Trainer.TrainerLoop("MaxPayne2.exe", 100)
return



	