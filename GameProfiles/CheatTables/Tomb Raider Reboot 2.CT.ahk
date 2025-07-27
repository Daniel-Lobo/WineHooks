#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x370
==========================================================================
AUTO ATTATCH
Start cheat engine after you start the game, when the 'launcher' show up, or it may not automatically 
attatch to the game
==========================================================================

==========================================================================
EASY KILLS\INFINTE BULLETS (AMMO)
Both can cause bugs, even on story sequences (ez kills), to the prevent bugs the easy way, I made it so
the cheats will only work if the right mouse button is held down, therefore you can't use these with gamepads
==========================================================================

==========================================================================
GAIN COINS
While on the shop, get close to an item and press 'G' to gain 50 coins. The new amount won't show on the screen 
right away, but if you move away from then close to the item again, you'll see the new value
==========================================================================

==========================================================================
GAIN SKILLS POINTS
With this cheat active, everytime you enter a campfilre, Lara gains one skill point
==========================================================================
"
)

global _auto       := new CEEntry("Auto")
global HP          := new CEEntry("H - inf HP")
global Kills       := new CEEntry("K - easy kills")
global aKills      := new CEEntry("Auto - easy kills")
global Skills      := new CEEntry("P - gain skill Points")
global coins       := new CEEntry("G - Gain coins")
global coins_flag  := new CEEntry("Coins flag")
global Ammo        := new CEEntry("B - inf Bullets")
global AAmmo       := new CEEntry("Auto - inf Bullets")


class ROTTRTrainer extends CETrainer
{
	OnLoop() 
	{
        _auto.SetFrozen(1, True)    

		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("infinite HP"))

		else if CETrainer.keyevent("k") > 0				
		this.Speak(Kills.Toogle("1 hit kills"))

		else if CETrainer.keyevent("p") > 0				
		this.Speak(Skills.Toogle("gain skill Points"))				

		else if CETrainer.keyevent("B") > 0				
		this.Speak(Ammo.Toogle("infinite Ammo"))

        gevnt := CETrainer.keyevent("G")
        if (gevnt)
        {
            coins.SetFrozen(gevnt>0?1:0, True)  
            if (gevnt < 0)
                this.PlaySound(1)
        }    
        revnt := CETrainer.keyevent("RButton")
        if (revnt)
        {
            Kills.IsFrozen() ? aKills.SetFrozen(revnt>0?1:0, True)  
            Ammo.IsFrozen()  ? AAmmo.SetFrozen(revnt>0?1:0, True)  
        }         
	}
}
ROTTRTrainer.TrainerLoop("ROTTR.exe", 100)
return



	
