#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help :=
(
"610x140
=========================================================================
Start the game 1st or the table won't work

While holding ""T"" use the arrows to teleport up, left or right. The boy can clip through walls when he teleports 
Teleporting up more the once in a row can kill the boy on the fall if he doesn't land on an higher platform
=========================================================================
"
)

global __auto    := new CEEntry("Auto - Position")
global __x       := new CEEntry("x")
global __y       := new CEEntry("y")

class InsideTrainer extends CETrainer
{
    OnLoop()
	{
        if (!__auto.IsFrozen())
        {
            this.mono()
            __auto.SetFrozen(1, 0)
            if (__auto.IsFrozen())
                this.PlaySound(1)
        }       
   
        if (GetKeyState("T", "P"))
        {
            if (CETrainer.keyevent("up") > 0)
            {
                y_pos := __y.GetValue(16)
                __y.SetValue(y_pos+5)
            }
            if (CETrainer.keyevent("left") > 0)
            {
                y_pos := __y.GetValue(16)
                __y.SetValue(y_pos+0.5)
                x_pos := __x.GetValue(16)
                __x.SetValue(x_pos-2)
            }
            if (CETrainer.keyevent("right") > 0)
            {
                y_pos := __y.GetValue(16)
                __y.SetValue(y_pos+0.5)
                x_pos := __x.GetValue(16)
                __x.SetValue(x_pos+2)
            }
        }
    }
}
InsideTrainer.__init().TrainerLoop("Inside.exe", 100)
return






