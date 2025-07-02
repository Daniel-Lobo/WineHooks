#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"320x200
"
)

global __auto           := new CEEntry("Auto")
global HP               := new CEEntry("H - inf HP")
global EZKills          := new CEEntry("K - easy kills")
global gold             := new CEEntry("Gold") 
global gold_auto        := new CEEntry("Auto - Gold") 
class SilverTrainer extends CETrainer
{
	OnLoop()
	{
        if (!__auto_player.IsFrozen())
		{
            __auto.SetFrozen(1, 1)	            		
		}

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	 

        else if CETrainer.keyevent("G") > 0	
        {			
            gold_auto.SetFrozen(1)	
            gold.SetValue(gold.GetValue(512)+100)
        }        
	}
}

SilverTrainer.__init().TrainerLoop("Silver.exe", 100)
return






