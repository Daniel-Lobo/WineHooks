#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global feathers  := new CEEntry("F - inf Feathers")
class ShortHikeTrainer extends CETrainer
{
    OnLoop()
	{        
		if CETrainer.keyevent("f") > 0	
		{	
            this.mono()
			this.Speak(feathers.Toogle("Infinite Feathers"))	
		}			
	}
}

ShortHikeTrainer.__Init().TrainerLoop("ashorthike.exe", 100)
return




