#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"360x205
==========================================
INFINITE HP
Every other hit will still deal damage, but the next one will heal
==========================================

==========================================
EASY KILLS
Work with all but a small flying enemy that appears in the 2nd
and last levels. There is also an enemy latter in the game
that's initially invunerable, but that's how the game goes
==========================================
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Weapon   := new CEEntry("M - inf Mana")
class DVTainer extends CETrainer
{    
	OnLoop()
	{        
		if (!__auto.IsFrozen())
        {
            __auto.SetFrozen(1, 0)	           
        }           
		if CETrainer.keyevent("h") > 0	
		{	
			this.Speak(HP.Toogle("Infinite HP"))	
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.Speak(EZKills.Toogle("One hit kills"))	
		}		
        else if CETrainer.keyevent("m") > 0				
        {	
            this.Speak(Weapon.Toogle("Infinite mana"))	
        }	
	}
}

DVTainer.TrainerLoop("dv.exe", 100)
return




