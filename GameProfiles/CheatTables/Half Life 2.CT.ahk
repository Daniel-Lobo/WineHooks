#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x260
==========================================================================
TURRETS BUG
The table will crash the game whenever a turret recives damage. To get arroound that, alt-tab and manualy 
disable the 'Auto - Damage' entry. That will cause the 'easy kills' cheat to stop working and the inf HP cheat
will work somewhat differently: gordon can get hurt but never killed
==========================================================================

==========================================================================
EASY KILLS
This will kill companions as well, so is not usable on some parts on the main game and on most parts of the
episodes
==========================================================================

==========================================================================
INF BULLETS
On the episodes, this doesn't work with the pistol and rifles
==========================================================================
"
)

global Player_hp_acess  := new CEEntry("Auto - Player")
global Damage           := new CEEntry("Auto - Damage")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Power    := new CEEntry("P - inf aux Power")
global Bullets  := new CEEntry("B - inf Bullets")
global Pistol   := new CEEntry("Auto - pistol")
global FLights  := new CEEntry("l - inf flashLight")

class HL2Trainer extends CETrainer
{
    Reset()
    {
        dllcall(CEFuncs.f.openProcessEx, ptr, this.p.ProcID(this.proc_name))
        ;msgbox % this.proc_name " " this.p.ProcID(this.proc_name)
    }
    OnLoop() 
    {    
        if (!Player_hp_acess.IsFrozen())
		{
            dllcall(CEFuncs.f.openProcessEx, ptr, this.p.ProcID(this.proc_name))
			Player_hp_acess.SetFrozen(1)
			Damage.SetFrozen(1)
		}
        
        if CETrainer.keyevent("b") > 0 
        {
            this.Speak(Bullets.Toogle("Infinite Ammo"))
            if (Bullets.IsFrozen())
                Pistol.SetFrozen(1, 1)
            else 
                Pistol.SetFrozen(0, 1)
        }
        
        else if CETrainer.keyevent("h") > 0  
        {   
            this.Speak(HP.Toogle("Infinite HP"))
        }			        

        else if CETrainer.keyevent("k") > 0		
        {		
            this.Speak(EZKills.Toogle("One hit kills"))	
        }

        else if CETrainer.keyevent("p") > 0		
        {		
            this.Speak(Power.Toogle("Infinite auxiliary Power"))	
        }    

        else if CETrainer.keyevent("l") > 0		
        {		
            this.Speak(FLights.Toogle("Infinite flashlight"))	
        }      
    }
}
HL2Trainer.TrainerLoop("hl2.exe", 100)
return




