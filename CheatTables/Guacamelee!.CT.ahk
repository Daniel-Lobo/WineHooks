#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"320x270
===================================
EASY INTENSO
1 hit refills the intenso bar
===================================

===================================
EASY KILLS
Enemies take two hits to kill
===================================

===================================
GAIN GOLD\SILVER
On the map screen press G to gain 1000 gold and C to gain 5 silver coins
===================================
"
)

global Flags            := new CEEntry("Auto - Flags")
global Player_hp_acess  := new CEEntry("Auto - Player")
global Damage           := new CEEntry("Auto - Damage")
global Gold             := new CEEntry("Gold")
global Skul_Coins       := new CEEntry("Silver Coins")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Stamina  := new CEEntry("Z - inf stamina")
global Intenso  := new  CEEntry("I - easy Intenso")
class GuacameleeTainer extends CETrainer
{
	OnLoop()
	{
		if (!Flags.IsFrozen())
		{
			Flags.SetFrozen(1)
			Player_hp_acess.SetFrozen(1)
			Damage.SetFrozen(1)
		}

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

		else if CETrainer.keyevent("z") > 0				
		this.Speak(Stamina.Toogle("Infinite Stamina"))	

		else if CETrainer.keyevent("i") > 0				
		this.Speak(Intenso.Toogle("Infinite Intenso"))	

		g := CETrainer.keyevent("g")
		if (g=1)
		{
			Gold.SetValue(Gold.GetValue(512)+1000)
			this.PlaySound(1)
		}
		c := CETrainer.keyevent("c")
		if (c=1)
		{
			Skul_Coins.SetValue(Skul_Coins.GetValue(512)+5)
			this.PlaySound(1)
		}			
	}
}

GuacameleeTainer.TrainerLoop("GameDRMFree.exe", 100)
return






