#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"370x120
===========================================
GAIN SPOOCE
With this active, whenever you press left or right on the dpad to 
check your current Spooce and health, you get 10 more Spooce 
===========================================
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global Kills    := new CEEntry("K - easy kills")
global spooce   := new CEEntry("G - Gain spooce")
global _jmp     := new CEEntry("B - always Bounce")
global _zap     := new CEEntry("Z - always Zap")
class MunchTrainer extends CETrainer
{
	OnLoop()
	{
        if (!__auto.IsFrozen())
        {
            this.open("Munch.exe")
            __auto.SetFrozen(1, 1)
        }    

		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))

        else if CETrainer.keyevent("k") > 0				
        this.Speak(kills.Toogle("easy kills"))

        else if CETrainer.keyevent("G") > 0		
        this.Speak(spooce.Toogle("Gain spooce"))

        else if CETrainer.keyevent("B") > 0				
        this.Speak(_jmp.Toogle("always Bounce"))
    
        else if CETrainer.keyevent("z") > 0		
        this.Speak(_zap.Toogle("Z - always Zap"))        	
	}
}
MunchTrainer.__init().TrainerLoop("Munch.exe", 100)
return






