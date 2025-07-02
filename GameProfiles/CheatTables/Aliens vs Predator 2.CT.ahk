#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"420x120
Waint until you start a game to activate the cheats. You'll hear the windows
ding once the cheats are ready to be activated

Inf flashLight, flares and night vision will crash the game with the predator
"
)

global Auto     := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global FLights  := new CEEntry("L - inf flashLight, flares and night vision")
global energy   := new CEEntry("P - inf Predator energy")
global cannon   := new CEEntry("Shoulder cannon")

class AVP2Trainer extends CETrainer
{
    OnLoop() 
    {    
        if (!Auto.IsFrozen())
		{
            this.open("lithtech.exe")
            Auto.SetFrozen(1, 1)
			if (Auto.IsFrozen())
            this.PlaySound(1)
		}
        
        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("Infinite HP"))
        }			        

        else if CETrainer.keyevent("k") > 0  	
        {		
            this.Speak(EZKills.Toogle("One hit kills"))	
        }

        else if CETrainer.keyevent("l") > 0  	
        {		
            this.Speak(FLights.Toogle("Infinite flashLight, flares, night vision"))	
        } 

        else if CETrainer.keyevent("p") > 0  	
        {		
            ;this.Speak(energy.Toogle("Infinite energy"))	
            ;cannon.SetFrozen(energy.IsFrozen(), true)
        } 
    }        
}
AVP2Trainer.__Init().TrainerLoop("lithtech.exe", 100)
return




