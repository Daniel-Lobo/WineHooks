#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP         := new CEEntry("H - inf HP")
global ezkill     := new CEEntry("K - easy Kills")
global sand       := new CEEntry("T - inf sand Tanks")
global power      := new CEEntry("P - inf Power tanks")
class POPSOTTrainer extends CETrainer
{
    Reset()
    {
        this.open("POP.exe")        
    }
	OnLoop() 
	{
        if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite Health"))

        else if CETrainer.keyevent("k") > 0				
		this.Speak(ezkill.Toogle("easy Kills"))	    
        
        else if CETrainer.keyevent("p") > 0				
		this.Speak(power.Toogle("Infinite Power Tanks"))

        else if CETrainer.keyevent("T") > 0				
		this.Speak(sand.Toogle("Infinite sand tanks"))	          	        			
	}
}
POPSOTTrainer.__init().TrainerLoop("POP.exe", 100)
return


