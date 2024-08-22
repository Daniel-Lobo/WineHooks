#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

;ommited the table help entry, because this bug never happened again
CETrainer.help := 
(
"420x100
=================================================
EASY KILLS
crashes the game when you load a save or complete a level
=================================================
"
)

global __Auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Ammo     := new CEEntry("B - inf Bullets")
global Stamina  := new CEEntry("Z - inf stamina")
global oil      := new CEEntry("O - inf Oil")

class OutlawsTrainer extends CETrainer
{
    OnLoop() 
    {    
        if (!__Auto.IsFrozen())
		{
            __Auto.SetFrozen(1, 1)	            	
		}
                
        if CETrainer.keyevent("h") > 0 
        {   
            this.Speak(HP.Toogle("Infinite HP"))
        }			        

        else if CETrainer.keyevent("k") > 0  	
        {		
            this.Speak(EZKills.Toogle("One hit kills"))	
        }

        else if CETrainer.keyevent("b") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        }  
        
        else if CETrainer.keyevent("Z") > 0  	
        {		
            this.Speak(Stamina.Toogle("Infinite stamina"))	
        }  

        else if CETrainer.keyevent("o") > 0  	
        {		
            this.Speak(oil.Toogle("Infinite Oil"))	
        }  
    }        
}
OutlawsTrainer.__init().TrainerLoop("olwin.exe", 100)
return




