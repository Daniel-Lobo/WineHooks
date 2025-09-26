#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent


global __auto        := new CEEntry("Auto")
global __auto_shards := new CEEntry("Auto - Shards")
global HPoints       := new CEEntry("H - inf HP")
global EKills        := new CEEntry("K - easy Kills")
global Bullets       := new CEEntry("B - inf Bullets")
global Shards        := new CEEntry("Shards")
class TFOCTrainer extends CETrainer
{
	OnLoop() 
	{
		if (!auto.IsFrozen())
		__auto.SetFrozen(1, True)	
		
		if (!__auto_shards.IsFrozen())
		__auto_shards.SetFrozen(1, True)	

		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Ammo"))	

		if CETrainer.keyevent("g") > 0
		{
			Shards.SetValue(Shards.GetValue(512)+1000)
			this.PlaySound(1)
		}
	}
}
TFOCTrainer.TrainerLoop("TFOC.exe", 100)
return


