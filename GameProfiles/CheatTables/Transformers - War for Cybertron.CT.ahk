#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent


global __auto        := new CEEntry("Auto")
global __auto_shards := new CEEntry("Auto - Shards")
global HPoints       := new CEEntry("H - inf HP")
global EKills        := new CEEntry("K - easy Kills")
global Bullets       := new CEEntry("B - inf Bullets")
class TWFCTrainer extends CETrainer
{
	OnLoop() 
	{
		if (!auto.IsFrozen())
		__auto.SetFrozen(1, True)			

		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Ammo"))			
	}
}
TWFCTrainer.TrainerLoop("TWFC.exe", 100)
return


