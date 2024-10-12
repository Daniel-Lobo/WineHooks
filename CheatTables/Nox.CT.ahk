#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"240x100
===========================
GAIN GOLD
Gives 1000 gold each time 'G' is pressed
===========================
"
)

global __auto           := new CEEntry("Auto - scans")
global Gold             := new CEEntry("Gold")
global HP          := new CEEntry("H - inf HP")
global EZKills     := new CEEntry("K - easy kills")
global magic       := new CEEntry("M - inf Magic") 
global InfShuriken := new CEEntry("U - Unlimited shurikens")
class NoxTainer extends CETrainer
{
	OnLoop()
	{
		if (!__auto.IsFrozen())
		{
            this.open("Game.exe")
			__auto.SetFrozen(1)			
		}

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

        else if CETrainer.keyevent("m") > 0				
        this.Speak(magic.Toogle("Infinite magic"))		

        else if CETrainer.keyevent("u") > 0				
        this.Speak(InfShuriken.Toogle("Infinite Shurikens"))	
        
      	g := CETrainer.keyevent("g")
		if (g=1)
		{
			Gold.SetValue(Gold.GetValue(512)+1000)
			this.PlaySound(1)
		}				
	}
}

NoxTainer.__init().TrainerLoop("Game.exe", 100)
return






