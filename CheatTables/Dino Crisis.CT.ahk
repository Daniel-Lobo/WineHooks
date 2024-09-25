#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"400x120
===============================================
INF BULLETS
You still have to reload and for the shotgun this won't be automatic, 
but it is suficient to enter then leave the menu
===============================================
"
)

global HP       := new CEEntry("H - freeze HP")
global HPauto   := new CEEntry("Auto - HP")
global KIll     := new CEEntry("K - easy Kills")
global Ammo     := new CEEntry("B - inf Bullets")

class DinoTrainer extends CETrainer
{
    OnLoop() 
    {    
        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("HP Frozen"))
            if HP.IsFrozen()
            {
                HPauto.SetValue("1200")
                HPauto.SetFrozen(1 ,1)
            }
        }         	        

        else if CETrainer.keyevent("k") > 0  	
        {		
            ;this.Speak(KIll.Toogle("easy kills"))	
        }

        else if CETrainer.keyevent("B") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        } 
    }        
}
DinoTrainer.TrainerLoop("Dino.exe", 100)
return




