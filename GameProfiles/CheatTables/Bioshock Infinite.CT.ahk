#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"330x130
======================================
GAIN SILVER\LOCKPICS
With these active, you gain 100 silver or 1 lockpick each
time you access the main menu 
======================================
"
)

global __auto       := new CEEntry("Auto")
global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy KIlls")
global Bullets      := new CEEntry("B - inf Bullets and salts")
global Money        := new CEEntry("G - Gain silver")
global LckPicks     := new CEEntry("L - gain Lockpicks")
class BioShockInfiniteTrainer extends CETrainer
{
	OnLoop() 
	{		
		if (!__auto.IsFrozen())
        {
            __auto.SetFrozen(1, 1)   
            if __auto.IsFrozen()
                this.PlaySound(1)  
        }

		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Ammo"))

		if CETrainer.keyevent("G") > 0				
		this.Speak(Money.Toogle("gain silver")) 

		if CETrainer.keyevent("L") > 0				
		this.Speak(LckPicks.Toogle("gain LockPicks"))
	}
}
BioShockInfiniteTrainer.TrainerLoop("BioShockInfinite.exe", 100)
return

