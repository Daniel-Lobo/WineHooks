#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Ammo     := new CEEntry("B - inf Bullets")

class BloodTrainer extends CETrainer
{
    OnLoop() 
    {               
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
BloodTrainer.__init().TrainerLoop("anuket_x64.exe", 100)
return




