#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __auto     := new CEEntry("Auto")
global hp         := new CEEntry("H - freeze HP")
global power      := new CEEntry("T - freeze sand Tanks")
class POPSOTTrainer extends CETrainer
{
    Reset()
    {
        this.open("POP3.exe")        
    }
	OnLoop() 
	{
        if (!__auto.IsFrozen())
        {
            this.open("POP3.exe")
            __auto.SetFrozen(1, 0)	  
            if ! (__auto.IsFrozen())
            sleep, 1000
        } 
        else if CETrainer.keyevent("h") > 0				
        {	
            if (!hp.IsFrozen())
            {
                hp.SetValue("255")
                hp.SetFrozen(1, 0)
                this.Speak("hp froozen")
            } else {
                hp.SetFrozen(0, 0)
                this.Speak("hp unfroozen")
            }
        }
        else if CETrainer.keyevent("T") > 0				
        {	
            if (!power.IsFrozen())
            {
                power.SetValue("6")
                power.SetFrozen(1, 0)
                this.Speak("sand tanks froozen")
            } else {
                power.SetFrozen(0, 0)
                this.Speak("sand tanks unfroozen")
            }           
        }	                  	        			
	}
}
POPSOTTrainer.__init().TrainerLoop("POP3.exe", 100)
return


