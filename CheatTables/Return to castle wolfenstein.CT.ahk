#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x180
=====================================================================
MANUAL ATTACH
This table has to be manually activaed with the 'M' key. Wait unil you load a level to do it
=====================================================================

=====================================================================
RESET
The cheats stop functioning when you clear a stage or load a save. When it happens, use 'R' reset them
=====================================================================
"
)

global Activate  := new CEEntry("M - Manual attach")
global Damage   := new CEEntry("Auto - Damage")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global InfAmmo  := new CEEntry("B - inf Bullets")
class RTCWTainer extends CETrainer
{
	RTCWReset()
	{
		Damage.SetFrozen(0, 1)	 
		Damage.SetFrozen(1, 1)		  
	}
	OnLoop()
	{
		if (CETrainer.keyevent("M"))
		{
			s:=
			(LTRIM
			"[ENABLE]
			{$lua}
			openProcess(""?"")          
			[DISABLE]        
			"
			)
			dllcall(CEFuncs.f.AutoAssemble, astr, StrReplace(s, "?", this.proc_name)) 
			Activate.SetFrozen(0, 1)	 
			Activate.SetFrozen(1, 0)							
		}	

		if CETrainer.keyevent("h") > 0	
		{	
			this.RTCWReset()			
			this.Speak(HP.Toogle("Infinite HP"))	
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.RTCWReset()			
			this.Speak(EZKills.Toogle("One hit kills"))	
		}
		else if CETrainer.keyevent("b") > 0	
		{	
			this.RTCWReset()					
			this.Speak(InfAmmo.Toogle("Infinite ammo"))	
		}				
	}
}

RTCWTainer.TrainerLoop("WolfSP.exe", 100)
return




