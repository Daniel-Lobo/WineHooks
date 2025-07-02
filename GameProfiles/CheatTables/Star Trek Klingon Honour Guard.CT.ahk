#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"360x120
=========================================
INF AMMO:
The ammo in the clip decreases, but the total ammo doesn't when you reload
=========================================
"
)

global common_code  := new CEEntry("Auto - Core.UObject::execSubtractEqual_IntInt+85")
global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy KIlls")
global Bullets      := new CEEntry("B - inf Bullets")
class khgTrainer extends CETrainer
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
	}
}
khgTrainer.TrainerLoop("khg.exe", 100)
return




