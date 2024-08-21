#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP     := new CEEntry("H - inf HP")
global Kills  := new CEEntry("K - easy Kills")
global Magic  := new CEEntry("M - inf Magic")
global items  := new CEEntry("I - inf Items")

class KainTrainer extends CETrainer
{
	RefillBlood()
	{
		maxblood := this.short(0x008A703E) 
		this.WriteShort(0x008A703C, maxblood)					
	}
	Refillmagic()
	{
		maxmagic := this.short(0x008A7044) 
		this.WriteShort(0x008A7042, maxmagic)
	}	

	OnLoop() 
	{
		if CETrainer.keyevent("i") > 0				
		this.Speak(items.Toogle("Infinite Items"))

		else if CETrainer.keyevent("k") > 0				
		this.Speak(Kills.Toogle("1 hit kills"))		

		else if CETrainer.keyevent("h") > 0		
		{				
			this.Speak(HP.Toogle("infinite HP"))	
			if (HP.IsFrozen())	
			this.RefillBlood()
		}
		
		else if CETrainer.keyevent("m") > 0	
		{			
			this.Speak(Magic.Toogle("infinite Magic"))
			if (Magic.IsFrozen())			
			this.Refillmagic()
				
		}		
	}
}
KainTrainer.TrainerLoop("Kain.exe", 100)
return



	