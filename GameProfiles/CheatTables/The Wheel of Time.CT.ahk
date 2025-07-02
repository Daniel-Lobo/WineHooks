#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x120
==========================================================================
LIMITATIONS
On TWoT one piece of code accesses multiple data and the heuristics to discern what data is what
is never perfect, so the cheats may fail here and there
==========================================================================

"
)

global common_code  := new CEEntry("Auto - Core.dll+33EAA")
global HPoints      := new CEEntry("H - inf HP")
global Ammo         := new CEEntry("M - inf Magic (ter'angreal)")
global EZKills      := new CEEntry("K - easy Kills")
class WoTTrainer extends CETrainer
{
	OnLoop() 
	{
		common_code.SetFrozen(1, True)
		
		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))		

		if CETrainer.keyevent("M") > 0				
		this.Speak(Ammo.Toogle("Infinite ter'angreal"))	

		if CETrainer.keyevent("K") > 0				
		this.Speak(EZKills.Toogle("easy Kills"))		
	}
}
WoTTrainer.TrainerLoop("WoT.exe", 100)
return


