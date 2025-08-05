#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"330x130
======================================
GAIN MONEY\ADAM
Press to gain $100 or 100 adam 
Enter and leave the main menu to see the values updated
======================================
"
)

global __auto       := new CEEntry("Auto")
global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy KIlls")
global Bullets      := new CEEntry("B - inf Bullets, eve hypos and fuel")
global Money        := new CEEntry("M - gain Money")
global Adam         := new CEEntry("G - Gain adam")
global MoneyValue   := new CEEntry("Money")
global AdamValue    := new CEEntry("Adam")
class BioShock2Trainer extends CETrainer
{
	OnLoop() 
	{		
		if (!__auto.IsFrozen())
        {
            __auto.SetFrozen(1, 1)   
            if __auto.IsFrozen()
                this.PlaySound(1)  
        }

		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Ammo"))

		if CETrainer.keyevent("M") > 0	
		{
			MoneyValue.SetValue(MoneyValue.GetValue(512)+100)
			this.PlaySound(1)
		}

		if CETrainer.keyevent("G")
		{
			AdamValue.SetValue(AdamValue.GetValue(512)+100)
			this.PlaySound(1)
		}
	}
}
BioShock2Trainer.TrainerLoop("Bioshock2.exe", 100)
return


