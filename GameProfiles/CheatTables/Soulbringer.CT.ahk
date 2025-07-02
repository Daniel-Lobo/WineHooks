#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"320x200
=====================================
GAIN ADVACEMENT POINT
Gives one extra points each time 'A' is pressed

GAIN GOLD
Gives 50 gold each time 'G' is pressed

Use thoses cheats on the character screen, then leave 
and come back to see the changes 
=====================================
"
)

global __auto_player    := new CEEntry("Auto - Player")
global __auto_gold      := new CEEntry("Auto - Gold")
global gold             := new CEEntry("Gold")
global advpoints        := new CEEntry("Adv Points")
global HP               := new CEEntry("H - inf HP")
global EZKills          := new CEEntry("K - easy kills")
global magic            := new CEEntry("MP") 
global max_magic        := new CEEntry("Max MP") 
class SoulbringerTrainer extends CETrainer
{
	OnLoop()
	{
        if (!__auto_player.IsFrozen())
		{
            this.open("SOULBR~2.exe")
			__auto_player.SetFrozen(1)	
            __auto_gold.SetFrozen(1)			
		}

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

        if (CETrainer.keyevent("M")=1)
        {
            magic.SetValue(max_magic.GetValue(512))
            this.PlaySound(1)
        }				
		if (CETrainer.keyevent("g")=1)
		{
			Gold.SetValue(Gold.GetValue(512)+100)
			this.PlaySound(1)
		}		        
        if (CETrainer.keyevent("A")=1)
        {
            advpoints.SetValue(advpoints.GetValue(512)+1)
            this.PlaySound(1)
        }	
	}
}

SoulbringerTrainer.__init().TrainerLoop("SOULBR~2.exe", 100)
return






