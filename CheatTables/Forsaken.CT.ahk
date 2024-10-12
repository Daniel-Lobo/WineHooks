#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent


global HP        := new CEEntry("H - inf HP")
global KIll      := new CEEntry("K - easy Kills")
global Lifes     := new CEEntry("L - inf Lives")
global Ammo      := new CEEntry("B - inf Bullets")
global Time      := new CEEntry("T - inf Time")

class ForsakenTrainer extends CETrainer
{
    OnLoop() 
    {    
        this.reset()
        {
            this.Open("ForsakenHW.exe")
        }

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

        else if CETrainer.keyevent("L") > 0  	
        {		
            this.Speak(Lifes.Toogle("Infinite Lifes"))	
        }

        else if CETrainer.keyevent("t") > 0  	
        {		
            this.Speak(time.Toogle("Infinite Time"))	
        } 
    }        
}
ForsakenTrainer.__Init().TrainerLoop("ForsakenHW.exe", 100)
return




