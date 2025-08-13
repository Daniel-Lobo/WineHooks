#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x400"
)

global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy KIlls")
global Bullets      := new CEEntry("B - inf Bullets")
class DxIWTrainer extends CETrainer
{
	OnLoop()
	{
		if CETrainer.keyevent("h") > 0		
        {
		    this.Speak(HPoints.Toogle("Infinite HP"))
            this.__states__["HP"] := !this.__states__["HP"]
        }

		if CETrainer.keyevent("k") > 0		
        {		
		    this.Speak(EKills.Toogle("One hit kills"))
            this.__states__["Kills"] := !this.__states__["Kills"]
        }

		if CETrainer.keyevent("b") > 0		
        {		
		    this.Speak(Bullets.Toogle("Infinite Ammo"))
            this.__states__["Bullets"] := !this.__states__["Bullets"]
        }    
	}

	DxIWLoop() 
	{
        this.__states__   := {"HP" : 0, "Kills" : 0, "Bullets" : 0}
		this.voice        := ComObjCreate("SAPI.SpVoice")	
        CETrainer.OnClose := RegisterCallback("CETrainer_OnClose", "F")
        this.proc_name    := "DX2Main.exe"
        Loop
        {
            this.table_help := new CEEntry("Table Help")
            while (IsObject(this.p) = 0)
            {
                this.p := new CELib_Process(Proc)
                this.ShowHelp()
                sleep, 100 
            } 
            sleep, 1000
			new CEEntry("Auto - damage (taken) multipliers").SetFrozen(1, 0)
            if this.__states__["HP"]
                HPoints.SetFrozen(1, 1)
            if this.__states__["Kills"]
                EKills.SetFrozen(1, 1)
            if this.__states__["Bullets"]
                Bullets.SetFrozen(1, 1)
            Loop
            {
                this.ShowHelp()
                this.OnLoop()
                
                sleep, 100    
				id := this._ID            
                Process, exist, %id%
                if (errorlevel = 0)
				{
					this.p := ""
                	break
				}
            }            
        }
	}
}
DxIWTrainer.DxIWLoop()
return


