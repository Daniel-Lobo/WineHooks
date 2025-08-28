#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"520x120
==============================================================
GAIN MONEY
You gain 1000 money each time you press G.
This will only work after the money has been shonw in the HUD at least once
==============================================================
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy Kills")
global souls    := new CEEntry("G - Gain souls") 
global m_auto   := new CEEntry("Auto - Souls")
global m_souls  := new CEEntry("Souls")

class Darksiders3Tainer extends CETrainer
{
	OnLoop()
	{		
		if (!m_auto.IsFrozen())
			m_auto.SetFrozen(1, 0)

		if (!__auto.IsFrozen())
			__auto.SetFrozen(1, 0)

		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	
			
		g := CETrainer.keyevent("G")
		if (g=1)
		{
			m_souls.SetValue(m_souls.GetValue(512)+1000)
			this.PlaySound(1)
		}				
	}
}

Darksiders3Tainer.__init().TrainerLoop("Darksiders3-Win64-Shipping.exe", 100)
return






