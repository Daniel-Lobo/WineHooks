#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Ammo     := new CEEntry("B - inf Bullets")

class KongTrainer extends CETrainer
{
    OnLoop() 
    {   
        if CETrainer.keyevent("h") > 0  	
        {	
            this.Open("KingKong8.exe")	
            this.Speak(HP.Toogle("infinite hp"))	
        }    

        else if CETrainer.keyevent("k") > 0  	
        {	
            this.Open("KingKong8.exe")	
            this.Speak(EZKills.Toogle("One hit kills"))	
        }

        else if CETrainer.keyevent("b") > 0  	
        {		
            this.Open("KingKong8.exe")	
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        }        
    }        
}
KongTrainer.__Init().TrainerLoop("KingKong8.exe", 100)
return




