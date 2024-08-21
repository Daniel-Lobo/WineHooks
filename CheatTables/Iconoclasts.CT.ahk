#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Breath   := new CEEntry("B - inf Breath")

class IconoclastsTrainer extends CETrainer
{
    OnLoop() 
    {
        if CETrainer.keyevent("h") > 0           				
        this.Speak(HP.Toogle("Infinite HP"))      		        

        else if CETrainer.keyevent("k") > 0		
        this.Speak(EZKills.Toogle("One hit kills"))	     
        
        else if CETrainer.keyevent("b") > 0	       		
        this.Speak(Breath.Toogle("Infinite Breath"))       
    }
}
IconoclastsTrainer.TrainerLoop("Iconoclasts.exe", 100)
return




