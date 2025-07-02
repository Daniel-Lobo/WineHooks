#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global common_code  := new CEEntry("Auto - Core.UObject::execSubtractEqual_IntInt")
global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy KIlls")
global Bullets      := new CEEntry("B - inf Bullets")
global Flares       := new CEEntry("F - inf Flares")
class UnrealTrainer extends CETrainer
{
	OnLoop() 
	{
		common_code.SetFrozen(1, True)
		
		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		else if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		else if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Ammo"))

		else if CETrainer.keyevent("f") > 0				
		this.Speak(Flares.Toogle("Infinite Flares"))
	}
}
UnrealTrainer.TrainerLoop("Unreal.exe", 100)
return




