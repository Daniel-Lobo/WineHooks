#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP       := new CEEntry("H - inf HP")
global KIll     := new CEEntry("K - easy Kills")
global Ammo     := new CEEntry("B - inf Bullets")

class EdenTrainer extends CETrainer
{
    OnLoop() 
    {         
        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("Infinite HP"))
        }	
        
        else if CETrainer.keyevent("k") > 0 
        {   
            this.Speak(KIll.Toogle("one hit kills"))
        }	
       
        else if CETrainer.keyevent("b") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        }       
    }        
}
EdenTrainer.__init().TrainerLoop("Eden.exe", 100)
return




