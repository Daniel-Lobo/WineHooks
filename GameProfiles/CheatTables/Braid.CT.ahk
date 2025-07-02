#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global monsters     := new CEEntry("Auto - kill monsters on contact")
global plants       := new CEEntry("Auto - invunerable to plants")
global invulnerable := new CEEntry("I - Invulnarable, protects from enemies, including plants, but not other hazards")	

class BraidTrainer extends CETrainer
{
    OnLoop()
	{
        If CETrainer.keyevent("I") > 0
        {
            this.open("Braid.exe")
            this.Speak(invulnerable.Toogle("invulnerability"))   
            if (invulnerable.IsFrozen())
            {
                plants.setFrozen(1, 1)
                monsters.setFrozen(1, 1)
            } else {
                plants.setFrozen(0, 1)
                monsters.setFrozen(0, 1)
            }  
        }           
    }
}
BraidTrainer.__init().TrainerLoop("Braid.exe", 100)
return






