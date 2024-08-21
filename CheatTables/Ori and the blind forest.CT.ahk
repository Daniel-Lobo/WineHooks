#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x100
==========================================================================
GAIN SKILL POINT
Press P during normal gameplay to gain 1 skill point
==========================================================================
"
)


global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Saves    := new CEEntry("S - inf Saves")
global SPoint   := new CEEntry("P - gain skill Point") 

class OriTrainer extends CETrainer
{
    OnLoop() 
    {
        if CETrainer.keyevent("h") > 0  
        {   
            this.mono()   				
            this.Speak(HP.Toogle("Infinite HP"))
        }			        

        else if CETrainer.keyevent("k") > 0		
        {		
            this.mono()  
            this.Speak(EZKills.Toogle("One hit kills"))	
        }

        else if CETrainer.keyevent("s") > 0	
        {	
            this.mono() 		
            this.Speak(Saves.Toogle("Infinite Saves"))	
        }

        else if (p := CETrainer.keyevent("p"))	
        {	
            this.mono() 	
            SPoint.SetFrozen(p=1?1:0, p=1?0:1)	
        }	
    }
}
OriTrainer.TrainerLoop("oriDE.exe", 100)
return




