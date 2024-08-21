#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"485x110
 ==========================================================
 INF AMMO:
 Gives +30 ammo for the Pistol, StormTrooper Rifle, Concussion Rifle Bow and Repeater
 ==========================================================
"
)

global __auto       := new CEEntry("Auto")
global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy KIlls")
global IForce       := new CEEntry("F - inf Force")
global Force        := new CEEntry("Force")
global MForce       := new CEEntry("Max Force")
global Bullets      := new CEEntry("Pistol, StormTrooper Rifle, Concussion Rifle")
global Bullets2     := new CEEntry("Bow, Repeater")
class JKMTrainer extends CETrainer
{
	OnLoop() 
	{	
        if ! __auto.IsFrozen()
        {
            __auto.SetFrozen(1)
        }

        if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		else if CETrainer.keyevent("k") > 0 				
		this.Speak(EKills.Toogle("One hit kills"))  

        else if CETrainer.keyevent("f") > 0 				
        this.Speak(IForce.Toogle("Infinite Force"))  

		else if CETrainer.keyevent("g") > 0	
        {
            Bullets.SetValue(Bullets.GetValue(512)+30)
            Bullets2.SetValue(Bullets2.GetValue(512)+30)
			this.PlaySound(1)
        }
        
        if IForce.IsFrozen()
        {
            max     := MForce.GetValue(512) + 0
            current := Force.GetValue(512) + 0
            if (max > current)
                Force.SetValue(max)			
        }

	}
}
JKMTrainer.TrainerLoop("JKM.exe", 100)
return




