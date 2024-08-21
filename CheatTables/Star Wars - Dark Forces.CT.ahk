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
global Bullets      := new CEEntry("B - inf Bullets, blasters only")
global lives        := new CEEntry("L - inf Lives") 
global battery      := new CEEntry("P - inf battery Power")   
class JKTrainer extends CETrainer
{
	OnLoop() 
	{	
        if ! __auto.IsFrozen()
        {
            __auto.SetFrozen(1)
        }

        if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		else if CETrainer.keyevent("b") > 0 				
		this.Speak(Bullets.Toogle("Infinite ammo"))  

        else if CETrainer.keyevent("l") > 0 				
        this.Speak(lives.Toogle("Infinite Lives"))  

        else if CETrainer.keyevent("p") > 0 	
        this.Speak(battery.Toogle("Infinite battery Power"))          
	}
}
JKTrainer.TrainerLoop("TheForceEngine.exe", 100)
return




