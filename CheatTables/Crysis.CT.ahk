#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"280x100
================================
EZ KILLS
is buggy with the aliens
================================
"
)

global __auto         := new CEEntry("Auto")
global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy Kills")
global Bullets      := new CEEntry("B - inf Bullets")
global Power        := new CEEntry("P - inf suit Power")
class CrysisTrainer extends CETrainer
{
	OnLoop() 
	{
		if (!__auto.IsFroozen())
        {
            this.open("Crysis")
            __auto.SetFrozen(1, 0)
        }         

		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Ammo"))

        if CETrainer.keyevent("p") > 0				
        this.Speak(Power.Toogle("Infinite suit Power"))
	}
}
CrysisTrainer.__Init().TrainerLoop("Crysis.exe", 100)
return


