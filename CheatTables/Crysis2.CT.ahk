#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"510x180
=============================================================
EZ KILLS
Will only work with enemies spawned after you activate the cheat
=============================================================

=============================================================
GAIN NANO CATALYS
With this active, everytime yuou acess the suoit upgrade menu, you gain 1000 nano catalyst.
=============================================================
"
)

global nano_c       := new CEEntry("G - Gain nano catalyst")
global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy Kills")
global Bullets      := new CEEntry("B - inf Bullets")
global Power        := new CEEntry("P - inf suit Power")
class Crysis2Trainer extends CETrainer
{
	OnLoop() 
	{	
		if(!this.__opened)
		{
			this.__opened := true
			this.AltOpen()
		}

		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Ammo"))

        if CETrainer.keyevent("p") > 0				
        this.Speak(Power.Toogle("Infinite suit Power"))

		if (CETrainer.keyevent("g") > 0)					
		this.Speak(nano_c.Toogle("Gain nano catalyst"))		
	}
}
Crysis2Trainer.__Init().TrainerLoop("Crysis2.exe", 100)
return


