#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __auto := new CEEntry("Auto")
global little := new CEEntry("L - teleport Little brother")
global bit    := new CEEntry("B - teleport Big brother")

class BrothersTrainer extends CETrainer
{
    OnLoop() 
    {     
        if (!__auto.IsFroozen())
        {
            __auto.SetFrozen(1, 1)            
        }  

        if CETrainer.keyevent("b") > 0  
        {
            bit.setFrozen(0, 1)    
            bit.setFrozen(1, 1)            
        }    
        
        if CETrainer.keyevent("l") > 0  
        {
            little.setFrozen(0, 1)    
            little.setFrozen(1, 1)           
        }  
    }    
}
BrothersTrainer.TrainerLoop("Brothers.exe", 100)
return




