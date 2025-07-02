#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"420x140
Waint until you start a game to activate the cheats. You'll hear the windows
ding once the cheats are ready to be activated

=================================================
INFINITE AMMO
Doesn't work with all weapons yet
=================================================
"
)

global __Auto     := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Ammo     := new CEEntry("B - inf Bullets")
global light    := new CEEntry("L - inf flashlight")

class HLTrainer extends CETrainer
{
    OnLoop() 
    {    
        if (!__Auto.IsFrozen())
		{
            this.open("hl.exe")
            __Auto.SetFrozen(1, 1)	
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

        else if CETrainer.keyevent("b") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        }    
        
        else if CETrainer.keyevent("l") > 0  	
        {		
            this.Speak(light.Toogle("Infinite flashlight"))	
        }   
    }        
}
HLTrainer.__init().TrainerLoop("hl.exe", 100)
return




