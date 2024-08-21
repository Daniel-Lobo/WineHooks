#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"480x200
 ========================================================
 GAIN FLORINS
 While at the menu, press 'F' to gain 1000 florins
 ========================================================

 ========================================================
 GAIN POINTS
 This will afect the character you were in control the last time you've acessed the menu 
 You'll gain 1 point each time you press 'P'. If you're at the advancement menu, move
 the cursor up or down to see the points updated 
 ========================================================
"
)

global __auto       := new CEEntry("Auto")
global HP           := new CEEntry("H - inf HP")
global EZKills      := new CEEntry("K - easy kills")
global florins      := new CEEntry("Auto - Florins")
global APoints      := new CEEntry("Auto - Points")
global Points       := new CEEntry("Points")
global gain_florins := new CEEntry("F - gain Florins")
global spirit       := new CEEntry("I - Inf skills\spirit")
class SudekiTrainer extends CETrainer
{    
	OnLoop()
	{        
		if (!__auto.IsFrozen())
        {
            this.open("Sudeki.exe")
            __auto.SetFrozen(1, 0)	     
            florins.SetFrozen(1, 0)	    
            APoints.SetFrozen(1, 0)	     
        }           
		if CETrainer.keyevent("h") > 0	
		{	
			this.Speak(HP.Toogle("Infinite HP"))	
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.Speak(EZKills.Toogle("One hit kills"))	
		}	
        else if CETrainer.keyevent("F") > 0	 
        {
            gain_florins.SetFrozen(1, 0)	
            sleep, 10
            gain_florins.SetFrozen(0, 1)
        }    
        else if CETrainer.keyevent("P") > 0	 
        {
            Points.SetValue(Points.GetValue(16)+1)
        } 
        else if CETrainer.keyevent("i") > 0	
        {	
            this.Speak(spirit.Toogle("Infinite skills and spirit"))	
        }	
    }
}

SudekiTrainer.__Init().TrainerLoop("Sudeki.exe", 100)
return




