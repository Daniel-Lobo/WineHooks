#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
    "530x390
    ===============================================================
    EASY KILLS
    To avoid killing the allies, because the code can't discern between them and enemies, this 
    cheat only works when infinite AP is enabled as well, in which case enemies never have a turn
    ===============================================================
   
    ===============================================================
    INFINITE AMMO
    Can prevent you from equiping a weapons, so disable it, equipe the weapon and enable it again
    I'm also not sure if it will work for all weapons
    ===============================================================
   
    ===============================================================
    GAIN SKILL POINT
    If you're at the char screen when you activate this. You'll need to click somewhere so the 
    screen will be updated and you'll see the new value
    ===============================================================   
   "
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global KIll     := new CEEntry("K - easy Kills")
global AP       := new CEEntry("A - inf AP")
global Ammo     := new CEEntry("B - inf Bullets")
global skillp   := new CEEntry("Skill Points")

class Fallout2Trainer extends CETrainer
{
    OnLoop() 
    {    
        if (!__auto.IsFrozen())
        {
            __auto.SetFrozen(1)			
        }    

        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("Infinite HP"))            
        }         	        

        else if CETrainer.keyevent("k") > 0  	
        {		
            this.Speak(KIll.Toogle("easy kills"))	
        }

        else if CETrainer.keyevent("B") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        } 

        else if CETrainer.keyevent("a") > 0  	
        {		
            this.Speak(AP.Toogle("Infinite AP"))	
        } 

        else if CETrainer.keyevent("p") > 0  	
        {		
            skillp.SetValue(skillp.GetValue(16)+1)	
            this.PlaySound(1)
        } 
    }        
}
Fallout2Trainer.TrainerLoop("fallout2.exe", 100)
return




