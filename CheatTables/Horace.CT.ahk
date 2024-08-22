#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x270
==========================================================================
MACROS
This Helps with some of the more obnoxious mini games. When enabled, 'D' repeatedly sends 'A' keystrokes and 
'F' alternates 'A' and 'X' keystrokes
==========================================================================

==========================================================================
INFINITE SHIELDS\RESPAWN SHIELDS
Those will work after you gain the 1st shield and so are not usable on the very early game
==========================================================================

==========================================================================
GAIN MONEY
Works inside shops or train stations, just hit the 'G' key and you'll instanttly see the money go up by 1000
==========================================================================
"
)


global regen      := new CEEntry("R - Respawn shields")
global money      := new CEEntry("G - Gain money")
global macros     := new CEEntry("M - Macros")
global lives      := new CEEntry("S - inf Shields")
class HoraceTrainer extends CETrainer
{
	HoraceOnLoop()
	{
		if CETrainer.keyevent("M") > 0		
		this.Speak(lives.Toogle("macros"))	

		if CETrainer.keyevent("s") > 0		
		{		
			this.Mono()
			this.Speak(lives.Toogle("Infinite Shields"))
		}					
		
		r := CETrainer.keyevent("R")				
		if (r)
		{
			this.Mono()
			regen.SetFrozen(r=1?1:0)
		}
		
		g := CETrainer.keyevent("g")				
		if (g)
		{
			this.Mono()
			money.SetFrozen(g=1?1:0)	
		}		
	}
	OnLoop() 
	{
		if (macros.IsFrozen())
		{
			while (GetKeyState("d", "p"))
			{
				Send, {a down}
				sleep 150
				Send, {a up}
				sleep 150
				this.HoraceOnLoop()
				return
			}
			
			while (GetKeyState("f", "p"))
			{
				Send, a
				sleep 15
				Send, x
				sleep 15
				this.HoraceOnLoop()
				return
			}
		}
		this.HoraceOnLoop()			
	}
}
HoraceTrainer.TrainerLoop("Horace.exe", 100)
return


