#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"300x100
 ==================================
 INFINITE CHARACTER POINTS
 This remains active only while you hold the 'C' key
 ==================================
"
)

global __auto     := new CEEntry("Auto")
global HP         := new CEEntry("H - inf HP")
global EZKills    := new CEEntry("K - easy kills")
global charpoint  := new CEEntry("P - inf char Points")
class tormentTainer extends CETrainer
{    
	OnLoop()
	{        
		if (!__auto.IsFrozen())
        {
            this.open("torment.exe")
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
        else if ((evnt:=CETrainer.keyevent("p") > 0))
        {	
            charpoint.setfrozen(1, 0)
            this.playsound(1)
            KeyWait, p,  up            
            charpoint.setfrozen(0, 1)
            this.playsound(0)
        }	        
	}
}

tormentTainer.__Init().TrainerLoop("torment.exe", 100)
return




