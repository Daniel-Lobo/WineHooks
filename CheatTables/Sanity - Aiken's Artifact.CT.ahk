#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x60
 After you start the game, wait until you start a level and hear the windows ding only then cheats can be activated
"
)

global __Auto     := new CEEntry("Auto")
global __reset    := new CEEntry("R - Reset")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global power    := new CEEntry("P - inf Powers")

class SanityTrainer extends CETrainer
{
    OnLoop() 
    {    
        if (!__Auto.IsFrozen())
		{
            this.open("Client.dll")
            __Auto.SetFrozen(1, 1)	
            if __Auto.IsFrozen() 
                this.Playsound(1)		
		}
                
        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("Infinite HP"))
        }			        

        else if CETrainer.keyevent("k") > 0  	
        {		
            this.Speak(EZKills.Toogle("One hit kills"))	
        }

        else if CETrainer.keyevent("p") > 0  	
        {		
            this.Speak(power.Toogle("Infinite Powers"))	
        }      
    }        
}
SanityTrainer.__init().TrainerLoop("client.dll", 100)
return




