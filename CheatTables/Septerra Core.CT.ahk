#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x240
==========================================================================
SPEED MULTIPLIER

Tap S to cycle 4 speed modes:
- Normal speed for all
- Double speed for playable characters and enemies
- Triple speed for playable characters and enemies
- Max speed for playable characters

You'll hear a voice message confirming the selected mode

Double and triple speed work more like a mod - to make the earlier game less tiresome - than a cheat
==========================================================================
"
)

global Max         := new CEEntry("Max")
global Double      := new CEEntry("x2")
global Triple      := new CEEntry("x3")
global NormalSpeed := new CEEntry("S - Speed Multiplier")
;global Money       := new CEEntry("M - inf Money")
global Damage   := new CEEntry("Auto - 0042d500")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
class SepterraTrainer extends CETrainer
{
	Init()
	{
		this.voice       := ComObjCreate("SAPI.SpVoice")	
		this.speed_mode  := "Normal"
		this.speed_modes := ["Normal", "Double", "Triple", "Max", "Normal"]
		this.voice.Rate  := -2
		return this
	}	
	reset()
	{
		for k, v in [Max, Double, Triple, NormalSpeed]
		v.SetFrozen(0, True)
	}
	OnLoop() 
	{
		if (!Damage.IsFrozen())
		Damage.SetFrozen(1, 1)

	    if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("One hit kills"))	

		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("infinite HP"))	

		m := CETrainer.keyevent("m")				
		if (m)
		Money.SetFrozen(m=1?1:0)
		if (SepterraTrainer.keyevent("S") = 1)
		{
			for k, v in this.speed_modes
			{
				if (this.speed_mode = v)
				{
					this.speed_mode := this.speed_modes[k+1]
					Break
				}
			} 
			this.reset() 
			if (this.speed_mode = "Max")
				Max.SetFrozen(1, True)
			else
			{
				NormalSpeed.SetFrozen(1, True)				
				if (this.speed_mode = "Double") 
				{
					new CEEntry("Double").SetFrozen(1, True)
					Double.SetFrozen(1, True)					
				}
				else if (this.speed_mode = "Triple") 
					Triple.SetFrozen(1, True)
				else NormalSpeed.SetFrozen(0, True)									
			}
			this.speak(this.speed_mode . " Speed")
		}		
	}
}
new SepterraTrainer().Init().TrainerLoop("septerra.exe", 100)
return


