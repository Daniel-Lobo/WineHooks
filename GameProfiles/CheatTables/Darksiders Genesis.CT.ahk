#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"520x220
==============================================================
GAIN SOULS
You gain 1000 souls each time you press G.
==============================================================	

==============================================================
GAIN COIN
You gain 1 coin each time you press B.
==============================================================

Note: if you're on the shop screen, you won't see the updated coin/soul count until you exit 
and re-enter the shop.
"
)

global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global horse    := new CEEntry("Z - inf horse Stamina")
global m_auto   := new CEEntry("Auto")
global m_coins  := new CEEntry("coins")
global m_souls  := new CEEntry("souls")

class DarksidersGTainer extends CETrainer
{
	OnLoop()
	{		
		if (!m_auto.IsFrozen())
			m_auto.SetFrozen(1, 0)

		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

	    if CETrainer.keyevent("Z") > 0				
		this.Speak(horse.Toogle("Infinite Horse Stamina"))

		g := CETrainer.keyevent("G")
		if (g=1)
		{
			m_souls.SetValue(m_souls.GetValue(512)+1000)
			this.PlaySound(1)
		}	
		b := CETrainer.keyevent("B")
		if (b=1)
		{
			m_coins.SetValue(m_coins.GetValue(512)+1)
			this.PlaySound(1)
		}			
	}
}

DarksidersGTainer.__init().TrainerLoop("DarksidersGenesis-Win64-Shipping.exe", 100)
return






