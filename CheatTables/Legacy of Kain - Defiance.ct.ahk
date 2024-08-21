#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"560x110
===================================================================
SHIFT TO MATERIAL ANYWHERE
This cheat is disabled when you load a save of complete a level. Just re-activate it when needed
===================================================================
"
)

global HP         := new CEEntry("H - inf HP")
global Kills      := new CEEntry("Z - EZ kills")
global FreeShift  := new CEEntry("M - shift to Material anywhere")

class SR3Trainer extends CETrainer
{
	OnLoop() 
	{
		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("infinite HP"))

		else if CETrainer.keyevent("z") > 0				
		this.Speak(Kills.Toogle("1 hit kills"))

		flags := this.UByte(0x5b1a64)
		if (flags&0x40)
		FreeShift.SetFrozen(1, 1)
		else 
		FreeShift.SetFrozen(0, 1)

	    if CETrainer.keyevent("m") > 0	
		{			
			this.Speak(FreeShift.Toogle("shift to Material anywhere"))
			flags := this.UByte(0x5b1a64) 
			if (FreeShift.IsFrozen())
				this.WriteByte(0x5b1a64, flags|0x40)	
			else
			{
				flags &= ~ 0x40
				this.WriteByte(0x5b1a64, flags)	
			}
		}
	}
}
SR3Trainer.TrainerLoop("defiance.exe", 100)
return



	