#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x240
==========================================================================
LIMITATIONS
Rune is one of those games where one piece of code accesses multiple data and the heuristics to discern what 
data is what is never perfect, so the cheats may fail here and there
==========================================================================

==========================================================================
EASY KILLS\INFINITE RUNE POWER
I could not develop a one hit kill cheat for this one, but the inf power can make up for it, even with the undead
after you get a weapon with an incediary power. The 1st one you can't miss is the Roman sword, but there's also 
an axe before that, see this: 
https://steamcommunity.com/sharedfiles/filedetails/?id=398935934
==========================================================================
"
)

global common_code  := new CEEntry("Auto - Core.dll+37002")
global HPoints      := new CEEntry("H - inf HP")
global RPower       := new CEEntry("P - inf rune Power")
class RuneTrainer extends CETrainer
{
	OnLoop() 
	{
		common_code.SetFrozen(1, True)
		
		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))		

		if CETrainer.keyevent("P") > 0				
		this.Speak(RPower.Toogle("Infinite Rune power"))		
	}
}
RuneTrainer.TrainerLoop("Rune.exe", 100)
return


