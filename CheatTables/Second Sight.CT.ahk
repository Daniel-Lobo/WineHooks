#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __Auto     := new CEEntry("Auto")
global ammo     := new CEEntry("B - inf Bullets")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global power    := new CEEntry("P - inf Powers")

class SecondSightTrainer extends CETrainer
{
    OnLoop() 
    {    
        if (!__Auto.IsFrozen())
		{
            this.open("SecondSight.exe")
            __Auto.SetFrozen(1, 1)	
            if __Auto.IsFrozen() 
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

        else if CETrainer.keyevent("p") > 0  	
        {		
            this.Speak(power.Toogle("Infinite Powers"))	
        }  
        
        else if CETrainer.keyevent("b") > 0  	
        {		
            this.Speak(ammo.Toogle("Infinite ammo"))	
        } 
    }        
}
SecondSightTrainer.__init().TrainerLoop("SecondSight.exe", 100)
return




