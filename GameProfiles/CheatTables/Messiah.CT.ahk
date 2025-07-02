#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"400x100
===============================================
INFINITE HP
Doesn't work with some instant kill attacks and enviromental hazards
===============================================
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global KIll     := new CEEntry("K - easy Kills")
global Ammo     := new CEEntry("B - inf Bullets")

class MessiahTrainer extends CETrainer
{
    OnLoop() 
    {    
        if (!__auto.IsFrozen())
        {
            __auto.SetFrozen(1)			
        }    

        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("Infinite HP"))            
        }         	        

        else if CETrainer.keyevent("k") > 0  	
        {		
            this.Speak(KIll.Toogle("easy kills"))	
        }

        else if CETrainer.keyevent("B") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        } 
    }        
}
MessiahTrainer.TrainerLoop("MessiahD3D.exe", 100)
return




