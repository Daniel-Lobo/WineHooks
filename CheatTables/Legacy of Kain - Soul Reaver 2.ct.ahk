#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"560x210
===================================================================
INFINITE HP:
Disables any damage taken from enemy attacks and over time HP drain on the material realm. The HP 
drain from the reaver is a separated cheat, but it is automatically activated whenever infinite HP is 
activated
===================================================================

===================================================================
SHIFT TO MATERIAL ANYWHERE
Shifting to material will still require full HP, so whenever activated, this cheat also restores the HP
===================================================================
"
)

;Reaver: 7352e9 - 4(spectral), 8(Material), 16(Dark), 32(light), 64(Air), 128(Fire)   
global HP         := new CEEntry("H - inf HP")
global Kills      := new CEEntry("K - easy kills")
global FreeShift  := new CEEntry("M - shift to Material anywhere")
globaL REAVER     := new CEEntry("R - Reaver doesn't drain HP")

class SR2Trainer extends CETrainer
{
	OnLoop() 
	{
		if (CETrainer.keyevent("h") > 0)
		{
			this.Speak(HP.Toogle("infinite HP"))
			if (HP.IsFrozen())
			{
				REAVER.SetFrozen(1, 1)
			}
		}		

		else if CETrainer.keyevent("k") > 0				
		this.Speak(Kills.Toogle("1 hit kills"))

	    else if CETrainer.keyevent("m") > 0	
		{			
			this.Speak(FreeShift.Toogle("shift to Material anywhere"))	
			if (FreeShift.IsFrozen())
			{
				lvl := this.Uint(0x005808CC)
				this.WriteUint(0x005808D0, 100000*(lvl+1))
			}
		}	

		else if CETrainer.keyevent("r") > 0				
		this.Speak(REAVER.Toogle("R - Reaver doesn't drain HP"))	

		else 
		{
			loop, 6
			{
				if (CETrainer.keyevent(A_index) > 0)
				{
					this.WriteUByte(0x7352e9, 2**(A_index+1))
					this.PlaySound(1)	
				}
			}
		}		
	}
}
SR2Trainer.TrainerLoop("sr2.exe", 100)
return



	