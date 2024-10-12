#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP         := new CEEntry("HP")
global Magic      := new CEEntry("MP")
global MaxHP      := new CEEntry("Max HP")
global MaxMagic   := new CEEntry("Max MP")
global FHP        := new CEEntry("H - freeze HP")
global FMagic     := new CEEntry("M - freeze Magic")
global __auto     := new CEEntry("Auto")
class MAGESLAYTrainer extends CETrainer
{
	OnLoop() 
	{
        if (!__auto.IsFrozen())
		{
            __auto.SetFrozen(1)			
		}

		if CETrainer.keyevent("h") > 0				
		this.Speak(FHP.Toogle("Infinite Health"))        	   

        else if CETrainer.keyevent("m") > 0				
		this.Speak(FMagic.Toogle("Infinite magic"))	   
        
        if (FHP.IsFrozen())
        HP.SetValue(MaxHP.GetValue(32))    

        if (FMagic.IsFrozen())
         Magic.SetValue(MaxMagic.GetValue(32))    
	}
}
MAGESLAYTrainer.__init().TrainerLoop("MAGESLAY.exe", 100)
return


