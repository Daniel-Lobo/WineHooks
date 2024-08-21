#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x200
==========================================================================
GAIN XP
Press X on the menu - not the main menu or enhance menu - the in game, inventory menu - to gain 200 XP
==========================================================================

==========================================================================
INFINITE MAGIC
Doesn't work with wind magic - if you have a save with the wind sword accquired, send it to me:
https://www.patreon.com/user?u=44312848 and I'll implement it
==========================================================================
"
)


global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Magic    := new CEEntry("M - inf Magic")
global XPoint   := new CEEntry("X - gain XP") 

class OniTrainer extends CETrainer
{
	OnLoop() 
	{
		if CETrainer.keyevent("h") > 0
		{				
			this.Speak(HP.Toogle("Infinite HP"))
			if (HP.IsFrozen())
			this.WriteShort(0x8BF6E8, this.short(0x8BF6E6))
		}

		else if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("One hit kills"))	

		else if CETrainer.keyevent("m") > 0				
		this.Speak(Magic.Toogle("Infinite Magic"))	

		else if (x := CETrainer.keyevent("x"))			
		XPoint.SetFrozen(x=1?1:0, x=1?0:1)		
	}
}
OniTrainer.TrainerLoop("OnimuPC.exe", 100)
return




