#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"320x180
===================================
EASY KILLS
Enemies take two hits to kill
===================================

===================================
GAIN GOLD\SILVER
On the map screen press G to gain 1000 gold
===================================
"
)

global Player_hp_acess  := new CEEntry("Auto - Player")
global Damage           := new CEEntry("Auto - Damage")
global Gold             := new CEEntry("Gold")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Stamina  := new CEEntry("Z - inf stamina")
class Guacamelee2Tainer extends CETrainer
{
	OnLoop()
	{
		if (!Player_hp_acess.IsFrozen())
		{
			Player_hp_acess.SetFrozen(1)
			Damage.SetFrozen(1)
		}

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

		else if CETrainer.keyevent("z") > 0				
		this.Speak(Stamina.Toogle("Infinite Stamina"))			

		g := CETrainer.keyevent("g")
		if (g=1)
		{
			Gold.SetValue(Gold.GetValue(512)+1000)
			this.PlaySound(1)
		}				
	}
}

Guacamelee2Tainer.TrainerLoop("Guac2_64.exe", 100)
return






