#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"480x100
 ========================================================
 GAIN STYLE POINT 
 With this active, you gain one style point everytime you access the Style menu 
 ========================================================
"
)

global __auto       := new CEEntry("Auto")
global HP           := new CEEntry("H - inf HP")
global EZKills      := new CEEntry("K - easy kills")
global style        := new CEEntry("G - Gain style point")
global chi          := new CEEntry("Chi")
global max_chi      := new CEEntry("Max Chi")
global focus        := new CEEntry("Focus")
global max_focus    := new CEEntry("Max Focus")
global inf_chi      := new CEEntry("C - inf Chi")
global inf_focus    := new CEEntry("F - inf Focus")
class JadeEmpireTrainer extends CETrainer
{    
	OnLoop()
	{        
		if (!__auto.IsFrozen())
        {
            this.open("JadeEmpire.exe")
            __auto.SetFrozen(1, 0)	     
            florins.SetFrozen(1, 0)	       
        }           
		if CETrainer.keyevent("h") > 0	
		{	
			this.Speak(HP.Toogle("Infinite HP"))	
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.Speak(EZKills.Toogle("One hit kills"))	
		}	
        else if CETrainer.keyevent("c") > 0				
		{	
			this.Speak(inf_chi.Toogle("Infinite Chi"))	
		}	
        else if CETrainer.keyevent("f") > 0				
		{	
			this.Speak(inf_focus.Toogle("Infinite Focus"))	
		}	
        if (inf_focus.IsFrozen())
        {
            focus.SetValue(max_focus.GetValue(32))
        }   
        if (inf_chi.IsFrozen())
        {
            chi.SetValue(max_chi.GetValue(32))
        }    
        if CETrainer.keyevent("g") > 0	 
        {
            this.Speak(style.Toogle("Gain style points"))	
        }            
	}
}

JadeEmpireTrainer.__Init().TrainerLoop("JadeEmpire.exe", 100)
return




