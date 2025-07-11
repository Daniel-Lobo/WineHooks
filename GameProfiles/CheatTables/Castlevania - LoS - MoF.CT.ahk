#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"500x170
===========================================================
FEEZE HP\MAGIC
Both are froozen a 100, which is the initial value. These can
only be activated after after loading or starting a new game
===========================================================

===========================================================
EASY KILLS
Enamies are spawned with 1 HP, so even if disable the cheat,
enemies already spawned are easily killed
===========================================================
"
)

global __auto    := new CEEntry("Auto")
global __auto_m  := new CEEntry("Auto - Magic")
global HP        := new CEEntry("H - freeze HP")
global magic     := new CEEntry("M - freeze Magic")
global EZKills   := new CEEntry("K - easy Kills")
class MOFTrainer extends CETrainer
{    
	OnLoop()
	{     
		if (!__auto.IsFrozen())
        {
			;this.AltOpen("CMOF.exe")
            __auto.SetFrozen(1, 0)
			__auto_m.SetFrozen(1, 0)
        }           
		if CETrainer.keyevent("h") > 0	
		{	
			if (HP.IsFrozen())
			{
				HP.SetFrozen(0, 1)
				this.speek("HP Unfrozen")
			} else {
				HP.SetValue(100)
				HP.SetFrozen(1, 1)
				this.speek("HP Frozen")
			} 
		}	
		if CETrainer.keyevent("m") > 0	
		{	
			if (magic.IsFrozen())
			{
				magic.SetFrozen(0, 1)
				this.speed("Magic Unfrozen")
			} else {
				magic.SetValue(100)
				magic.SetFrozen(1, 1)
				this.speed("Magic Frozen")
			} 
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.Speak(EZKills.Toogle("One hit kills"))	
		}	
	}
}

MOFTrainer.TrainerLoop("CMOF.exe", 100)
return




