#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __auto  := new CEEntry("Auto")
global __hp    := new CEEntry("HP - Zero is full health, Game over when HP == 10")
global __ammo  := new CEEntry("Shoots fired - needs reload when value == 5")
class BSTrainer extends CETrainer
{
    OnLoop()
	{
        if (!__auto.IsFrozen())
        {
            this.open("bs.exe")
            __auto.SetFrozen(1, 0)
            if (__auto.IsFrozen())
                this.PlaySound(1)
        }  
        if (CETrainer.keyevent("H") > 0)
        {
            this.Speak(__hp.Toogle("Freeze HP"))   
            __hp.SetValue(0)
        }         
        if (CETrainer.keyevent("B") > 0)
        {
            this.Speak(__ammo.Toogle("Freeze bullets")) 
            __ammo.SetValue(0)
        }             
    }
}
BSTrainer.__init().TrainerLoop("bs.exe", 100)
return






