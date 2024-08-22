#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global Player   := new CEEntry("Auto - Player")
global Damage   := new CEEntry("Auto - Damage")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Souls    := new CEEntry("G - Gain souls")
global Seeds    := new CEEntry("P - gain Plant seed")
class DDoorTrainer extends CETrainer
{	
	Activate()
	{
		if (Player.IsFrozen()=0)
		{
			this.mono()
			Player.SetFrozen(1, 1)	
			Damage.SetFrozen(1, 1)			
		}
	}
	OnLoop() 
	{
		if CETrainer.keyevent("h") > 0  
        {   
			this.Activate()
            this.Speak(HP.Toogle("Infinite HP"))
        }			        

        else if CETrainer.keyevent("k") > 0		
        {		
			this.Activate()
            this.Speak(EZKills.Toogle("One hit kills"))	
        }	

		else if (p := CETrainer.keyevent("G") = 1)	
        {	
			this.mono()
            Souls.SetFrozen(1, 0)	           
            Souls.SetFrozen(0, 1)	
        }

		else if (p := CETrainer.keyevent("P") = 1)	
        {	
			this.mono()
            Seeds.SetFrozen(1, 0)	           
            Seeds.SetFrozen(0, 1)	
        }					
	}
}
DDoorTrainer.__init().TrainerLoop("DeathsDoor.exe", 100)
return


