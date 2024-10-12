#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"320x200
"
)

global __auto_player    := new CEEntry("Auto - Player")
global __auto_stats     := new CEEntry("Auto - Player stats")
global fatige           := new CEEntry("N - No fatigue")
global HP               := new CEEntry("H - inf HP")
global EZKills          := new CEEntry("K - easy kills")
global level            := new CEEntry("Level") 
global gold             := new CEEntry("Gold") 
global gold_auto        := new CEEntry("Auto - Gold") 
class RevenantTrainer extends CETrainer
{
	OnLoop()
	{
        if (!__auto_player.IsFrozen())
		{
            this.open("Revenant.exe")
			__auto_player.SetFrozen(1)	
            __auto_stats.SetFrozen(1)			
		}

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

        else if CETrainer.keyevent("N") > 0				
        this.Speak(fatige.Toogle("No fatigue"))	

        else if CETrainer.keyevent("G") > 0	
        {			
            gold_auto.SetFrozen(1)	
            gold.SetValue(gold.GetValue(512)+100)
        }

        if (CETrainer.keyevent("L")=1)
        {
            level.SetValue(level.GetValue(512)+1)
            this.PlaySound(1)
        }		
	}
}

RevenantTrainer.__init().TrainerLoop("Revenant.exe", 100)
return






