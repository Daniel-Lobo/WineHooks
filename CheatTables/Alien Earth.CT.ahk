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
global credits  := new CEEntry("Credits")
class AlienTrainer extends CETrainer
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
        
        else if CETrainer.keyevent("g") > 0	
        {   
            credits.SetValue(credits.GetValue(32)+100)
            this.PlaySound(1)
        }            
	}
}

AlienTrainer.__init().TrainerLoop("Alien.exe", 100)
return






