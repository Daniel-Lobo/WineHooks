#NoEnv
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help :=
(
    "300x60
    EASY KILLS causes a bug on the last boss
    "
)

global HP      := new CEEntry("H - inf HP")
global EZKills := new CEEntry("K - easy kills")
global InfAmmo := new CEEntry("B - inf Bullets")
class SIGNALISTainer extends CETrainer
{
    Attatch()
    {
        if (this.Attatched)
        Return
        this.lua("openProcess", 0, this.proc_name)
        this.Attatched := True
    }
    OnLoop()
    {
        if (CETrainer.keyevent("h") > 0)
        {
            this.Attatch()
            this.Speak(HP.Toogle("Infinite HP"))
        }
        else if (CETrainer.keyevent("k") > 0)
        {
            this.Attatch()
            this.Speak(EZKills.Toogle("Easy kills"))
        }
        else if (CETrainer.keyevent("b") > 0)
        {
            this.Attatch()
            this.Speak(InfAmmo.Toogle("Infinite ammo"))
        }
    }
}

SIGNALISTainer.TrainerLoop("SIGNALIS.exe", 100)
return
