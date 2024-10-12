#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"575x120
 Wait unil you hear the winddows ding to activate the cheats, that will happen as soon as you load a save 
 or start a new game

 Leave the 'reset' entries alone. The're threre to reset the cheats automatically every time you clear a level, 
 load a save or start a new game
"
)

global __auto     := new CEEntry("Auto")
global Reset      := new CEEntry("Auto reset")
global HP         := new CEEntry("H - inf HP")
global EZKills    := new CEEntry("K - easy kills")
global InfAmmo    := new CEEntry("B - inf Bullets")
global ammoreset  := new CEEntry("Auto reset - ammo")
class Eliteforce2Tainer extends CETrainer
{            
	OnLoop()
	{        
		if (!__auto.IsFrozen())
        {
            this.Open("EF2.exe")
            __auto.SetFrozen(1, 1)	      
            if (__auto.IsFrozen())
                this.PlaySound(1)      
        }
		if CETrainer.keyevent("h") > 0	
		{	
			this.Speak(HP.Toogle("Infinite HP"))	
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.Speak(EZKills.Toogle("One hit kills"))	
		}
		else if CETrainer.keyevent("b") > 0	
		{	
			this.Speak(InfAmmo.Toogle("Infinite ammo"))	
		}	
        if (HP.IsFrozen() or EZKills.IsFrozen())
        {	
            Reset.SetFrozen(0, 1)
            Reset.SetFrozen(1, 1)	
        }    
        if (InfAmmo.IsFrozen())
        {	
            ammoreset.SetFrozen(0, 1)
            ammoreset.SetFrozen(1, 1)	
        }       
	}
}

Eliteforce2Tainer.__Init().TrainerLoop("EF2.exe", 100)
return




