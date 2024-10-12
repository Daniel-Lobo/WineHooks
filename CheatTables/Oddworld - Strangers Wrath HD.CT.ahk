#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"370x180
===========================================
INFINITE HP\EASY KILLS
Very Little testing. Bugs are possible
===========================================

===========================================
GAIN MONEY
Gives 50 money each time 'M' is pressed on the inventory screen
===========================================
"
)

global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global Kills    := new CEEntry("K - easy kills")
global money    := new CEEntry("M - gain Money")
global Ammo     := new CEEntry("B - inf Bullets")
class StrangerTainer extends CETrainer
{
	OnLoop()
	{
        if (!__auto.IsFrozen())
        {
            this.open("Stranger.exe")
            __auto.SetFrozen(1, 1)
        }    

		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))

        else if CETrainer.keyevent("k") > 0				
        this.Speak(kills.Toogle("easy kills"))

        else if CETrainer.keyevent("M") > 0		
        {		
            Money.setFrozen(1, 0)
            keywait, M, up
            Money.setFrozen(0, 1)
        }	
        
        else if CETrainer.keyevent("B") > 0  	
        {		
            this.Speak(Ammo.Toogle("Infinite ammo"))	
        } 
	}
}

StrangerTainer.__init().TrainerLoop("Stranger.exe", 100)
return






