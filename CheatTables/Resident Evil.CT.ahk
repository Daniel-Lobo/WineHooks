#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent


global HP       := new CEEntry("H - inf HP")
global HPval    := new CEEntry("HP")
global KIll     := new CEEntry("K - easy Kills")
global Ammo     := new CEEntry("B - inf Bullets")
global ribbons  := new CEEntry("I - inf Ink ribbons")

class RETrainer extends CETrainer
{
    OnLoop() 
    {    
        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("Infinite HP"))
            if HP.IsFrozen()
            {
                HPval.SetValue("100")
                HPval.SetFrozen(1 ,1)
            }
        }         	        

        else if CETrainer.keyevent("k") > 0  	
        {		
            this.Speak(KIll.Toogle("easy kills"))	
        }

        else if CETrainer.keyevent("B") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        } 

        else if CETrainer.keyevent("i") > 0  	
        {		
            this.Speak(ribbons.Toogle("Infinite ammo"))	
        } 
    }        
}
RETrainer.TrainerLoop("NEWEUR.exe", 100)
return




