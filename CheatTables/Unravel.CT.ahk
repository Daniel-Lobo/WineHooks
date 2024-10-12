#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help :=
(
"400x210
===============================================
FLOAT
With float mode active use the arrows to move up or down, left or right

Float is disabled by holding ""s"" which is the default key to make the
yarny hold it's tail, so it won't die from the fall - any height will kill
it otherwise
===============================================
"
)

global __auto    := new CEEntry("Auto")
global fly       := new CEEntry("F - Float mode")
global fly_down  := new CEEntry("float down")
global fly_up    := new CEEntry("float up")
global fly_left  := new CEEntry("float left")
global fly_right := new CEEntry("float right")

class UnravelTrainer extends CETrainer
{
    OnLoop()
	{
        if (!__auto.IsFrozen())
        {
            this.open("Unravel.exe")
            __auto.SetFrozen(1, 0)
            if (__auto.IsFrozen())
                this.PlaySound(1)
        }

        if (CETrainer.keyevent("f") > 0	)
        {
            if (not fly.IsFrozen())
                fly.SetFrozen(1, 1)
        }
        if (CETrainer.keyevent("S") > 0	)
        {
            if (fly.IsFrozen())
            {
                sleep, 1000
                fly.SetFrozen(0, 1)
            }
        }

        __up := CETrainer.keyevent("up")
        if (__up > 0)
            fly_up.SetFrozen(1, 1)
        else if (__up < 0)
            fly_up.SetFrozen(0, 1)

        __down := CETrainer.keyevent("down")
        if (__down > 0)
            fly_down.SetFrozen(1, 1)
        else if (__down < 0)
            fly_down.SetFrozen(0, 1)

        __left := CETrainer.keyevent("left")
        if (__left > 0)
            fly_left.SetFrozen(1, 1)
        else if (__left < 0)
            fly_left.SetFrozen(0, 1)

        __right := CETrainer.keyevent("right")
        if (__right > 0)
            fly_right.SetFrozen(1, 1)
        else if (__right < 0)
            fly_right.SetFrozen(0, 1)
	}
}
UnravelTrainer.__init().TrainerLoop("Unravel.exe", 100)
return






