#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x400
==========================================================================
LIMITATIONS
On Deusex one piece of code accesses multiple data and the heuristics to discern what data is what is never 
perfect, so the cheats may fail here and there
==========================================================================

==========================================================================
INFINITE BULLETS
Most reliable of the cheats, never saw it fail or cause bugs.
For most weapons, you're still going to see the ammo count decrease, but at some point when you fire the 1st
few shots in a clip, you'll gain another clip 
==========================================================================

==========================================================================
INFINITE HP
JC still suffer damage on the left arm, but is otherwise invulnerable to anything. This cheat only fails very rarely 
==========================================================================

==========================================================================
EASY KILLS
Least reliable of the cheats, only rarely works as a 1 hit, makes some other enemies easier to kill and doesn't work 
for turrets, cameras and robot spiders
==========================================================================
"
)

;global AllInOne  := new CEEntry("J - Skils, items, ammo")
;global Money     := new CEEntry("L - Money")
global flags        := new CEEntry("Auto - Flags")
global common_code  := new CEEntry("Auto - 101345DF")
global common_code1 := new CEEntry("Auto - 10165d1c")
global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy KIlls")
global Bullets      := new CEEntry("B - inf Bullets")
class DxTrainer extends CETrainer
{
	OnLoop() 
	{
		flags.SetFrozen(1, True)
		common_code.SetFrozen(1, True)
		common_code1.SetFrozen(1, True)

		if CETrainer.keyevent("h") > 0				
		this.Speak(HPoints.Toogle("Infinite HP"))

		if CETrainer.keyevent("k") > 0				
		this.Speak(EKills.Toogle("One hit kills"))

		if CETrainer.keyevent("b") > 0				
		this.Speak(Bullets.Toogle("Infinite Ammo"))

		/*
		j := CETrainer.keyevent("J")				
		if (j)
		AllInOne.SetFrozen(j=1?1:0)
		
		l := CETrainer.keyevent("l")				
		if (l)
		Money.SetFrozen(l=1?1:0)
		*/	
	}
}
DxTrainer.TrainerLoop("DeusEx.exe", 100)
return


