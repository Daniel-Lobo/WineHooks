#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP         := new CEEntry("H - inf HP")
global kill       := new CEEntry("K - easy Kills")       
global Magic      := new CEEntry("B - inf Bullets")
global __auto     := new CEEntry("Auto")
class TNPTrainer extends CETrainer
{
	OnLoop() 
	{
        if (!__auto.IsFrozen())
		{
            __auto.SetFrozen(1)			
		}

		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite Health"))   
        
        if CETrainer.keyevent("k") > 0				
        this.Speak(kill.Toogle("1 hit kills"))   

        else if CETrainer.keyevent("b") > 0				
		this.Speak(Magic.Toogle("Infinite ammo"))	      	        			
	}
}
TNPTrainer.__init().TrainerLoop("tnp.exe", 100)
return


