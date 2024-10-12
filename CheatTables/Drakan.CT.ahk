#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"420x180
=================================================
INFINITE MAGIC
Affects magic weapons, but not magic crystals
=================================================

=================================================
INFINITE POTIONS
Affects invisibility potions and health elixirs
=================================================
"
)

global HP         := new CEEntry("H - inf HP")
global ezkill     := new CEEntry("K - easy Kills")
global CommonCode := new CEEntry("Auto - Dragon.rfl+831EC")
global NoBreak    := new CEEntry("U - Unbreakable weapons and inf arrows")
global Magic      := new CEEntry("M - inf Magic")
global Potions    := new CEEntry("P - inf Potions")
global Dragon     := new CEEntry("B - inf dragon Breath")
class DrakanTrainer extends CETrainer
{
	OnLoop() 
	{
        if (!CommonCode.IsFrozen())
		{
            this.Open("Drakan.exe")
			CommonCode.SetFrozen(1)			
		}

		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite Health"))

        else if CETrainer.keyevent("k") > 0				
		this.Speak(ezkill.Toogle("easy Kills"))	       

        else if CETrainer.keyevent("B") > 0				
		this.Speak(Dragon.Toogle("Infinite dragon Breath"))	

        else if CETrainer.keyevent("p") > 0				
		this.Speak(Potions.Toogle("Infinite Potions"))

        else if CETrainer.keyevent("u") > 0				
		this.Speak(NoBreak.Toogle("Unbreakable weapons and Infinite arrows"))	   

        else if CETrainer.keyevent("m") > 0				
		this.Speak(Magic.Toogle("Infinite magic"))	      	        			
	}
}
DrakanTrainer.__init().TrainerLoop("Drakan.exe", 100)
return


