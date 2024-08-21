#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"270x230
==============================
INFINITE BULLETS
This gives infinite magazines for the pulse rifle 
and infinite ammo for the spear gun 
==============================   

==============================
QUICK SAVING LOADIND:
Edit you CONFIG.CGF file is the game's directory with:
BIND F5 QUICKSAVE
BIND F9 QUICKLOAD
==============================
"
)

global Auto      := new CEEntry("Auto")
global HP        := new CEEntry("H - inf HP")
global EZKills   := new CEEntry("K - easy kills")
global Ammo      := new CEEntry("B - inf Bullets")
global saves     := new CEEntry("saves")
global u_saves   := new CEEntry("U - Unlimited saves")
global spear_gun := new CEEntry("Spear gun")
global quick     := new CEEntry("Quick Saving\Loading")

class AVPClassicTrainer extends CETrainer
{
    OnLoop() 
    {    
        if (!Auto.IsFrozen())
		{
            Auto.SetFrozen(1, 1)			
		}
        
        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("Infinite HP"))
        }			        

        else if CETrainer.keyevent("k") > 0  	
        {		
            this.Speak(EZKills.Toogle("One hit kills"))	
        }

        else if CETrainer.keyevent("B") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite magazines"))	
        } 

        else if CETrainer.keyevent("u") > 0  	
        {		
            this.Speak(u_saves.Toogle("Infinite saves"))	
        } 

        if (u_saves.IsFrozen())
        {
            saves.SetValue("4")
        }    

        if (Ammo.IsFrozen())
        {
            spear_gun.SetValue("1835008")
        }        
    }        
}
AVPClassicTrainer.__Init().TrainerLoop("AvP_Classic.exe", 100)
return




