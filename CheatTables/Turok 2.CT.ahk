#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent


global HP        := new CEEntry("H - inf HP")
global KIll      := new CEEntry("K - easy Kills")
global Ammo      := new CEEntry("B - inf Bullets")

class Turok2Trainer extends CETrainer
{
    OnLoop() 
    {    
        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("infinite HP"))	
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
Turok2Trainer.__Init().TrainerLoop("Turok2.exe", 100)
return




