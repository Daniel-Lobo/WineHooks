#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x120
=====================================================================
GAIN MONEY
You must use this during normal gameplay before entering the buy\sell\upgrade screen. You'll gain $1000 
each time you press 'M'
=====================================================================
"
)


global money    := new CEEntry("M - gain Money")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global InfAmmo  := new CEEntry("B - inf Bullets")
global InfPower := new CEEntry("P - inf Power")
class Wolf2Trainer extends CETrainer
{
	OnLoop() 
	{
		if (m := CETrainer.keyevent("m"))
		{
			money.SetFrozen(m=1?1:0, m=1?0:1)					
		}
		else if CETrainer.keyevent("h") > 0					
		this.Speak(HP.Toogle("Infinite HP"))	
			
		else if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("One hit kills"))	
		
		else if CETrainer.keyevent("b") > 0						
		this.Speak(InfAmmo.Toogle("Infinite ammo"))	

		else if CETrainer.keyevent("p") > 0						
		this.Speak(InfPower.Toogle("Infinite Power"))		
	}		
}

Wolf2Trainer.TrainerLoop("Wolf2.exe", 100)
return
	





