﻿#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP         := new CEEntry("H - inf HP")
global Ammo       := new CEEntry("B - inf Bullets")

class TombAnniversaryTrainer extends CETrainer
{
	OnLoop() 
	{
		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("infinite HP"))			

		else if CETrainer.keyevent("B") > 0				
		this.Speak(Ammo.Toogle("infinite Ammo"))	       
	}
}
TombAnniversaryTrainer.TrainerLoop("tra.exe", 100)
return



	