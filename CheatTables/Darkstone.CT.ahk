#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global magic    := new CEEntry("M - inf Magic") 
global points   := new CEEntry("Level Points") 
global food     := new CEEntry("N - no hunger") 
global lvlpnt   := new CEEntry("L - inf Level points") 

class DarkstoneTainer extends CETrainer
{
	OnLoop()
	{		

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

        else if CETrainer.keyevent("m") > 0				
        this.Speak(magic.Toogle("Infinite magic"))		

        else if CETrainer.keyevent("n") > 0				
        this.Speak(food.Toogle("no hunger"))	
    
        else if CETrainer.keyevent("l") > 0				
        this.Speak(lvlpnt.Toogle("Infinite Level points"))	

		g := CETrainer.keyevent("G")
		if (g=1)
		{
			points.SetValue(points.GetValue(512)+1)
			this.PlaySound(1)
		}				
	}
}

DarkstoneTainer.__init().TrainerLoop("Darkstone.exe", 100)
return






