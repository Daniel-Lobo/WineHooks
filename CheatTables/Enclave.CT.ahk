#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"320x100
=====================================
GAIN GOLD
Press 'G' on the menu before a mission to gain 100 gold
=====================================
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global gold     := new CEEntry("G - Gain gold")
class EnclaveTainer extends CETrainer
{    
	OnLoop()
	{        
		if (!__auto.IsFrozen())
        {
            this.open("Enclave.exe")
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
        else if ((evnt:=CETrainer.keyevent("g") > 0))
        {	
            gold.setfrozen(1, 0)
            KeyWait, g,  up
            this.playsound(1)
            gold.setfrozen(0, 1)
        }	        
	}
}

EnclaveTainer.__Init().TrainerLoop("Enclave.exe", 100)
return




