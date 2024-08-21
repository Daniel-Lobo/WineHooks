#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy KIlls")
global Bullets      := new CEEntry("B - inf Blaster")
global Force        := new CEEntry("F - inf Force")
class PhantomMenaceTrainer extends CETrainer
{
	OnLoop() 
	{		
        if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		else if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		else if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Blaster"))

		else if CETrainer.keyevent("f") > 0				
		this.Speak(Force.Toogle("Infinite Force"))
	}
}
PhantomMenaceTrainer.TrainerLoop("wmain.exe", 100)
return




