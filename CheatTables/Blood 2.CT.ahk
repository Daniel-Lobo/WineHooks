#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"420x180
Waint until you start a game to activate the cheats. You'll hear the windows
ding once the cheats are ready to be activated

You'll need to reset the cheats everytime you load a game or finish a level

=================================================
INFINITE BULLETS
Also gives you infinite enery for the flahslight and nightvision googles
=================================================
"
)

global __Auto     := new CEEntry("Auto")
global __reset    := new CEEntry("R - Reset")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Ammo     := new CEEntry("B - inf Bullets")

class Blood2Trainer extends CETrainer
{
    OnLoop() 
    {    
        if (CETrainer.keyevent("r") > 0 )
        {
            frozen := []
            for key, objct in [HP, EZKills, Ammo]
            {
                if (objct.IsFrozen())               
                    frozen.Insert(objct)
            }
            __Auto.SetFrozen(0, 1)           
            __Auto.SetFrozen(1, 1)	
            for key, objct in frozen
            {
                objct.SetFrozen(0, 0)	
                objct.SetFrozen(1, 0)	   
            }    
            ;this.Playsound(1)	
        }

        if (!__Auto.IsFrozen())
		{
            this.open("Client.exe")
            __Auto.SetFrozen(1, 1)	
            if (__Auto.SetFrozen(1, 1))
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
    }        
}
Blood2Trainer.__init().TrainerLoop("Client.exe", 100)
return




