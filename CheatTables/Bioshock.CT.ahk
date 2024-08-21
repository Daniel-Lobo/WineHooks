#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"260x200
=============================
EASY KILLS
With this active, cigarretes will kill you
=============================

=============================
GAIN MONEY\ADAM
With those active, you gain $100 or 100
adam each time you access pause the menu
=============================
"
)

global __auto       := new CEEntry("Auto")
global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy KIlls")
global Bullets      := new CEEntry("B - inf Bullets")
class BioShockTrainer extends CETrainer
{
	OnLoop() 
	{
		if (!__auto.IsFroozen())
        {
            __auto.SetFroozen(1, 1)   
            if __auto.IsFroozen()
                this.PlaySound(1)  
        }

		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Ammo"))
	}
}
BioShockTrainer.TrainerLoop("Bioshock.exe", 100)
return


