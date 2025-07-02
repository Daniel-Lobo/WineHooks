#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent


global HP       := new CEEntry("H - inf HP")
global Saves    := new CEEntry("C - inf Charms of Saving")
global Ammo     := new CEEntry("B - inf Bullets")

class AitD4Trainer extends CETrainer
{
    Reset()
    {
        this.Open("Alone4.exe")        
    }    
    OnLoop() 
    {    
        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("Infinite HP"))
        }			        

        else if CETrainer.keyevent("C") > 0  	
        {		
            this.Speak(Saves.Toogle("Infinite Saves"))	
        }

        else if CETrainer.keyevent("B") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        } 
    }        
}
AitD4Trainer.__init().TrainerLoop("alone4.exe", 100)
return




