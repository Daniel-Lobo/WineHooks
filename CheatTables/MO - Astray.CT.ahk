#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x100
==========================================================================
INFINITE HP
MO still suffers damage and it's HP can get to zero, but it won't die
==========================================================================
"
)

global HP    := new CEEntry("H - inf HP")
global DASH  := new CEEntry("I - Inf dash")

class MOTrainer extends CETrainer
{
    OnLoop() 
    {       
        if CETrainer.keyevent("h") > 0  
        {   
            this.Speak(HP.Toogle("Infinite HP"))
        }			        

        else if CETrainer.keyevent("i") > 0		
        {		
            this.Speak(DASH.Toogle("Infinite dash"))	
        }        
    }
}
MOTrainer.TrainerLoop("MOAstray.exe", 100)
return




