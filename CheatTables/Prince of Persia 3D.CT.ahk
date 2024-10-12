#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __auto     := new CEEntry("auto")
global HP         := new CEEntry("H - inf HP")
global ezkill     := new CEEntry("K - easy Kills")
global arrows     := new CEEntry("A - inf Arrows")
class POP3DTrainer extends CETrainer
{    
	OnLoop() 
	{
        if not __auto.IsFrozen()
        {
            __auto.SetFrozen(1, 1)
            if __auto.IsFrozen()
                this.PlaySound(1)
        }    

        if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite Health"))

        else if CETrainer.keyevent("k") > 0				
		this.Speak(ezkill.Toogle("easy Kills"))	
        
        else if CETrainer.keyevent("A") > 0				
         this.Speak(arrows.Toogle("Infinite arrows"))	
	}
}
POP3DTrainer.__init().TrainerLoop("POP3D.exe", 100)
return


