#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP       := new CEEntry("H - inf HP")
global KIll     := new CEEntry("K - easy Kills")
global HPVal    := new CEEntry("HP") 
global jump     := new CEEntry("J - inf Jetpack fuel")
global fuel     := new CEEntry("JetpackFuel")
global Ammo     := new CEEntry("B - inf Bullets")

class OutwarsTrainer extends CETrainer
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

        else if CETrainer.keyevent("j") > 0  	
        {		
            this.Speak(jump.Toogle("Infinite Fuel"))	
        }

        else if CETrainer.keyevent("b") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        }           
        
        if HP.IsFrozen()
        {
            HPVal.SetValue(50)
        }	
        
        if jump.IsFrozen()
        {
            fuel.SetValue(300)
        }	
    }        
}
OutwarsTrainer.__init().TrainerLoop("Outwars.exe", 100)
return




