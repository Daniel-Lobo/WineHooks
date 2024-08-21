#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"560x360
===================================================================
EASY KILLS:
Enemies on the spectral realm are killed in one hit. Enemies on the material realm are stuned in one hit
and nerver recover. Impaled enemies never come back to life
===================================================================

===================================================================
POWER UP:
Gives, while active, the soul reaver, fire reaver and projectile, and the soul reaver will reamain active on 
the material realm even without full HP. When deactivated, abilities reset to the ones normally 
accquired. If you shift realms with this activated, the fire reaver won't be spawned on the material 
realm and will not disapear on the spectral realm. You will need to deactivate and re-activate the cheat to gain or loose the fire reaver
===================================================================

===================================================================
SHIFT TO MATERIAL ANYWHERE
This cheat also gives, while active, the swim ability, When deactivated, abilities reset to the ones 
normally accquired. Shifting to material will still require full HP, so whenever activated, this cheat
also restores the HP
===================================================================
"
)

global common_code  := new CEEntry("Auto - abilities")
global HP           := new CEEntry("H - inf HP")
global Kills        := new CEEntry("K - easy kills")
global FreeShift    := new CEEntry("M - shift to Material anywhere")
globaL PowerUP      := new CEEntry("U - power UP")
globaL Projectile   := new CEEntry("P - Projectile")

class Kain2Trainer extends CETrainer
{
	RefillHP()
	{
		max := this.Byte(0x00B08810)+1			
		this.WriteUint(0x00B08814, max*100000)				
	}

	OnLoop() 
	{
		common_code.SetFrozen(1, True)

	    if CETrainer.keyevent("k") > 0				
		this.Speak(Kills.Toogle("1 hit kills"))

		else if CETrainer.keyevent("u") > 0				
		this.Speak(PowerUP.Toogle("power UP"))

		else if CETrainer.keyevent("p") > 0				
		this.Speak(Projectile.Toogle("Projectile"))

		else if CETrainer.keyevent("h") > 0	
		{			
			this.Speak(HP.Toogle("infinite HP"))	
			if (HP.IsFrozen())
			{
				this.RefillHP()
			}
		}	

	    else if CETrainer.keyevent("m") > 0	
		{			
			this.Speak(FreeShift.Toogle("shift to Material anywhere"))	
			if (FreeShift.IsFrozen())
			{
				this.RefillHP()
			}
		}	

		

		/*		
		if gliph.IsFrozen()
		{
			max := this.Byte(0x00B0882A)			
			this.WriteByte(0x00B08828, max)
		}
		*/
	}
}
Kain2Trainer.TrainerLoop("Kain2.exe", 100)
return



	