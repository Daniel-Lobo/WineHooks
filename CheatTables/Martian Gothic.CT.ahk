#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"455x100
======================================================
GAIN SAVES
When active, gives you one extra save each time you access the save game menu
======================================================
"
)


global HP       := new CEEntry("H - inf HP")
global Saves    := new CEEntry("G - Gain Save")
global Ammo     := new CEEntry("B - inf Bullets")
global Matlock  := new CEEntry("Matlock HP")
global Kenzo    := new CEEntry("Kenzo HP")
global Karne    := new CEEntry("Karne HP")
class MartinTrainer extends CETrainer
{       
    OnLoop() 
    {    
        if CETrainer.keyevent("G") > 0  	
        {		
            this.Speak(Saves.Toogle("Infinite Saves"))	
        }

        else if CETrainer.keyevent("B") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        } 

        else if CETrainer.keyevent("h") > 0  	
        {		
                this.Speak(HP.Toogle("Infinite HP"))	
        } 

        if (HP.IsFrozen())
        {   
            Matlock.SetValue(100)
            Kenzo.SetValue(100)
            Karne.SetValue(80)
        }	
    }        
}
MartinTrainer.__init().TrainerLoop("martian gothic.exe", 100)
return




