#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"520x140
==============================================================
GAIN SOULS
You gain 1000 sould each time you press G.
This will only work after you have visited the inventory at least once
If use this while at the inventory screen, leave, then return to the inventory to see the change.
==============================================================
"
)

global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global souls    := new CEEntry("G - Gain souls") 
global s_auto   := new CEEntry("Auto - Souls")
global p_souls  := new CEEntry("Souls")

class DarksidersPCTainer extends CETrainer
{
	OnLoop()
	{		
		if (!s_auto.IsFrozen())
			s_auto.SetFrozen(1, 0)

		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	
			
		g := CETrainer.keyevent("G")
		if (g=1)
		{
			p_souls.SetValue(p_souls.GetValue(512)+1000)
			this.PlaySound(1)
		}				
	}
}

DarksidersPCTainer.__init().TrainerLoop("DarksidersPC.exe", 100)
return






