#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

;Neither INFINITE HP (autoscript) or EASY KILLS work 100%, but with the instant health regen you will be pretty much invincible

global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy Kills")
global magic    := new CEEntry("M - inf Magic")
global gold     := new CEEntry("Gold")
class Ecstatica2Tainer extends CETrainer
{
	OnLoop()
	{
		if (!__auto.IsFrozen())
		{
			__auto.SetFrozen(1)			
		}

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

        else if CETrainer.keyevent("m") > 0				
        this.Speak(magic.Toogle("Infinite Magic"))	
		
		else if CETrainer.keyevent("g") > 0	
        {
            gold.SetValue(9000)   	 			
            this.PlaySound(1)
        }
	}
}

Ecstatica2Tainer.TrainerLoop("e2vista.exe", 100)
return






