#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"550x92
=================================================================
GAIN XP
You gain 100 XP every time you press X during normal gameplay and with the XP visible on the HUD
=================================================================
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global stamina  := new CEEntry("X - gain XP")
global xp_read  := new CEEntry("Auto - read xp")
global XP       := new CEEntry("XP")
class LoSU2Tainer extends CETrainer
{    
	OnLoop()
	{        
		if (!__auto.IsFrozen())
        {
            __auto.SetFrozen(1, 0)
			xp_read.SetFrozen(1, 0)
        }           
		if CETrainer.keyevent("h") > 0	
		{	
			this.Speak(HP.Toogle("Infinite HP"))	
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.Speak(EZKills.Toogle("One hit kills"))	
		}		
        else if CETrainer.keyevent("x") > 0				
		{	
			XP.SetValue(XP.GetValue(512)+100.00000)
			this.PlaySound(1)
		}	
	}
}

LoSU2Tainer.TrainerLoop("CLOS2.exe", 100)
return




