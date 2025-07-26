#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x180
Cheats will start torespond after you're in game

==========================================================================
GAIN COINS
With this active, each time you access the inventory, you gain 1000 gold coins
==========================================================================

==========================================================================
GAIN SKILLS POINTS
With this cheat active, on a campfilre, each time you access the skills updgrade menu, you gain 3 skill points
==========================================================================
"
)

global _auto       := new CEEntry("Auto")
global HP          := new CEEntry("H - inf HP")
global Kills       := new CEEntry("K - easy kills")
global Skills      := new CEEntry("P - gain skill Points")
global coins       := new CEEntry("G - Gain coins")
global Ammo        := new CEEntry("B - inf Bullets")

class SOTTRTrainer extends CETrainer
{
    ;this.__opened := false
	OnLoop() 
	{       
        if (!this.__opened){
            this.__opened := true
            this.AltOpen()
        }
        if (!_auto.IsFrozen()){
            _auto.SetFrozen(1, 0)
        }

        if CETrainer.keyevent("h") > 0
		this.Speak(HP.Toogle("infinite HP"))

		else if CETrainer.keyevent("k") > 0
		this.Speak(Kills.Toogle("1 hit kills"))

		if CETrainer.keyevent("p") > 0				
		this.Speak(Skills.Toogle("gain skill Points"))				

		else if CETrainer.keyevent("B") > 0				
		this.Speak(Ammo.Toogle("infinite Ammo"))

        else if CETrainer.keyevent("G") > 0				
        this.Speak(coins.Toogle("gain gold coins"))
	}
}
SOTTRTrainer.TrainerLoop("SOTTR.exe", 100)
return



	
