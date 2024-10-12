#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"500x60
 Cheats need to be reset eveytime you complete a level or load a save
"
)

global HP         := new CEEntry("H - inf HP")
global ammo       := new CEEntry("B - inf Bullets")
global hp_state   := 0
global ammo_state := 0

class SlaveZeroTrainer extends CETrainer
{
    OnLoop() 
    {                            
        if CETrainer.keyevent("h") > 0 
        {   
            this.Open("d3d_SlaveZero.exe")	
            this.Speak(HP.Toogle("Infinite HP"))
            hp_state := HP.IsFrozen()           
        }
        else if CETrainer.keyevent("b") > 0  	
        {	
            this.Open("d3d_SlaveZero.exe")		
            this.Speak(ammo.Toogle("Infinite ammo"))	
            ammo_state := ammo.IsFrozen()
            
        }         
        else if CETrainer.keyevent("R") > 0  	
        {	
            return
        }  
    }        
}
SlaveZeroTrainer.__init().TrainerLoop("d3d_SlaveZero.exe", 100)
return




