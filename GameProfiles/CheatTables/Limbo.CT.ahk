#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __auto    := new CEEntry("Auto - Gravity")
global vgrav     := new CEEntry("VGrav")
global hgrav     := new CEEntry("HGrav")`
global fly       := new CEEntry("F - Float mode, use WASD to float to desired direction")	

class LimboTrainer extends CETrainer
{
    OnLoop()
	{
        if (!__auto.IsFrozen())
        {
            __auto.SetFrozen(1, 0)
            if (__auto.IsFrozen())
                this.PlaySound(1)
        }  

        fly := CETrainer.keyevent("f")
        if (fly > 0) 
        vgrav.SetValue(2)
        else if (fly < 0)  
        vgrav.SetValue(-10)

        __left  := getkeystate("<")
        __right := getkeystate(">")         
                        
        if      (__left > 0)
        hgrav.SetValue(-5)
        else if (__right > 0)
        hgrav.SetValue(5)
        else hgrav.SetValue(0)                     
    }
}
LimboTrainer.__init().TrainerLoop("Limbo.exe", 100)
return






