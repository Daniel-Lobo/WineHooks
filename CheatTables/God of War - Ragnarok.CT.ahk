#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"622x80
The heuristics for distihguishing between player and enemy is not perfect. You might still be hit, but other hits will 
heal and some enemies might be killed in one hit only by trowing the axe, or with arrows
"
)


global __auto   := new CEEntry("Auto")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
class GOWTainer extends CETrainer
{    
	OnLoop()
	{       
		if (!__auto.IsFrozen())
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
            __auto.SetFrozen(1, 0)	           
        }           
		if CETrainer.keyevent("h") > 0	
		{	
			this.Speak(HP.Toogle("Infinite HP"))	
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.Speak(EZKills.Toogle("One hit kills"))	
		}		
	}
}

GOWTainer.TrainerLoop("GoWR.exe", 100)
return




