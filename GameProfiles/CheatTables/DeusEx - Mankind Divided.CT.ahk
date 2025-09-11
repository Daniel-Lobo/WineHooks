#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"600x210
======================================================================
GAIN PRAXIS
While in the augmentations menu, press G to gain 1 Praxis point. To see the value updated on the menu, 
switch to another tab, then back to the augs tab	
======================================================================

======================================================================
ININITE HP and EZ KILLS
For theses to work properlly, you nedd to performa any action that consumer energy after loading a save
or entering a new area
======================================================================
"
)

global __auto       := new CEEntry("Auto")
global __autoP      := new CEEntry("Auto - Praxis")
global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy Kills")
global Bullets      := new CEEntry("B - inf Bullets")
global energy       := new CEEntry("I - inf Energy")
global praxis       := new CEEntry("Praxis")
class DxMDTrainer extends CETrainer
{
	OnLoop() 
	{
		if (!auto.IsFrozen())
		__auto.SetFrozen(1, True)	
		
		if (!__autoP.IsFrozen())
		__autoP.SetFrozen(1, True)	

		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Ammo"))	

		if CETrainer.keyevent("I") > 0				
		this.Speak(energy.Toogle("Infinite Energy"))

		if CETrainer.keyevent("g") > 0
		{
			praxis.SetValue(praxis.GetValue(512)+1)
			this.PlaySound(1)
		}
	}
}
DxMDTrainer.TrainerLoop("dxmd.exe", 100)
return


