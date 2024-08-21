#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"420x100
=================================================
GAIN COINS
Gives 10 coins each time 'G' is pressed
=================================================
"
)

global __auto           := new CEEntry("Auto")
global Coins            := new CEEntry("Coins")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global magic    := new CEEntry("M - inf Magic") 
global leaves   := new CEEntry("L - inf Leaves")
class LBATainer extends CETrainer
{
	OnLoop()
	{
		if (!__auto.IsFrozen())
		{
			__auto.SetFrozen(1)			
		}

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

        else if CETrainer.keyevent("m") > 0				
        this.Speak(magic.Toogle("Infinite magic"))		

        else if CETrainer.keyevent("l") > 0				
        this.Speak(leaves.Toogle("Infinite leaves"))		

		g := CETrainer.keyevent("g")
		if (g=1)
		{
			Coins.SetValue(Coins.GetValue(512)+10)
			this.PlaySound(1)
		}				
	}
}

LBATainer.TrainerLoop("Lbawin.exe", 100)
return






