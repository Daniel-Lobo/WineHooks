#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"470x70
Everytime you see a loding screen, cheats are reset.
Infinte HP or easy Kills (whatever you activate 1st) take a few secons to to have effect
"
)

global HPoints      := new CEEntry("H - inf HP")
global EKills       := new CEEntry("K - easy KIlls")
global Bullets      := new CEEntry("B - inf Bullets")

GetModuleFileName()
{
    VarSetCapacity(path, 260, 0)
    dllcall("GetModuleFileNameA", uint, 0, ptr, &path, int, 260)
    return strget(&path+0, "CP0")
}

activate()
{
    entry := new CEEntry("Auto - damage (taken) multipliers")
    while (!entry.IsFrozen())
        entry.SetFrozen(1, 0)      
}

class DxIWTrainer extends CETrainer
{
	OnLoop()
	{
		if CETrainer.keyevent("h") > 0		
        {
            activate()
		    this.Speak(HPoints.Toogle("Infinite HP"))
            this.__states__["HP"] := -1*this.__states__["HP"]
        }

		if CETrainer.keyevent("k") > 0		
        {		
            activate()
		    this.Speak(EKills.Toogle("One hit kills"))
            this.__states__["Kills"] := -1*this.__states__["Kills"]
        }

		if CETrainer.keyevent("b") > 0		
        {	
            activate()	
		    this.Speak(Bullets.Toogle("Infinite Ammo"))
            this.__states__["Bullets"] := -1*this.__states__["Bullets"]
        }    
	}

	DxIWLoop() 
	{
        this.__states__   := {"HP" : -1, "Kills" : -1, "Bullets" : -1}
		this.voice        := ComObjCreate("SAPI.SpVoice")	
        CETrainer.OnClose := RegisterCallback("CETrainer_OnClose", "F")
        this.proc_name    := "DX2Main.exe"
        Loop
        {
            this.table_help := new CEEntry("Table Help")
            while (IsObject(this.p) = 0)
            {
                this.p := new CELib_Process("DX2Main.exe")
                this.ShowHelp()
                sleep, 100 
            }    
            Process, Exist, DX2Main.exe   
            id := ErrorLevel  
            this.AltOpen()       
            sleep, 2000     
			;entry := new CEEntry("Auto - damage (taken) multipliers")
            ;while (!entry.IsFrozen())
               ; entry.SetFrozen(1, 0)            
            if this.__states__["HP"]>0
                HPoints.SetFrozen(1, 1)
            if this.__states__["Kills"]>0
                EKills.SetFrozen(1, 1)
            if this.__states__["Bullets"]>0
                Bullets.SetFrozen(1, 1)
            Loop
            {
                this.ShowHelp()
                this.OnLoop()
                
                sleep, 100  
                Process, exist, %id%
                if (errorlevel = 0)
				{
                    ;this.p := ""
                    ;break
                    table  := StrReplace(A_ScriptFullPath, ".ahk", "")
                    ce     := GetModuleFileName()
                    run, "%ce%" "%table%"
                    dllcall("ExitProcess", uint, 0)
				}
            }            
        }
	}
}
DxIWTrainer.DxIWLoop()
return


