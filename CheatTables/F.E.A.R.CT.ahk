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
If it seems it's not working, pay close attention
=================================================
"
)

global __Auto     := new CEEntry("Auto")
global __reset    := new CEEntry("R - Reset")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Ammo     := new CEEntry("B - inf Bullets")
global light    := new CEEntry("L - inf flashLight")

class FEARTrainer extends CETrainer
{
    OnLoop() 
    {    
        if (CETrainer.keyevent("r") > 0 )
        {
            frozen := []
            for key, objct in [HP, EZKills, Ammo, light]
            {
                if (objct.IsFrozen())               
                    frozen.Insert(objct)
            }
            __Auto.SetFrozen(0, 1)	
            __Auto.SetFrozen(1, 1)	
            for key, objct in frozen
            {
                objct.SetFrozen(0, 1)	
                objct.SetFrozen(1, 1)	   
            }    
        }

        if (!__Auto.IsFrozen())
		{
            this.open("FEAR.exe")
            __Auto.SetFrozen(1, 1)	
            if (__Auto.IsFrozen())
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
                this.Speak(light.Toogle("Infinite flashLight"))	
            }   
    }        
}
FEARTrainer.__init().TrainerLoop("FEAR.exe", 100)
return




