#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"410x245
================================================
INVULNERABLE
This protects against almost everything when in land. On whater, Andy is
vulnerable and when climbing, he's only invunerable to hole bugs and 
plant shadows
You also have to disable this to hit and kick seeds
================================================

================================================
FLY
When used - F key down - crashes the game in many screens, regardless 
don't remove or modify this as the INVULNERABLE cheat shares code
with this one
================================================
"
)


global flag     := new CEEntry("Auto - fly direction")
global xpos     := new CEEntry("X")
global __auto   := new CEEntry("Auto Position")
global __scans  := new CEEntry("Auto Position Scans")
global __enable := new CEEntry("Auto enable")
global __inv    := new CEEntry("I - invulnerable")

class HODTrainer extends CETrainer
{
    OnLoop()
	{   
        if (!__auto_player.IsFrozen())
        {
            __scans.SetFrozen(1, 1)	
            __auto.SetFrozen(1, 1)	            		
        }  

        if CETrainer.keyevent("i") > 0
        {
            this.Speak(__inv.Toogle("invulnerable"))	
        }    

        f := CETrainer.keyevent("f")
        if (f > 0)
        {
            __enable.SetFrozen(1, 1)	
            flag.SetValue(3)
        } else if  (f < 0)
        {
            __enable.SetFrozen(0, 1)	
            flag.SetValue(0)
        }

        if __enable.IsFrozen()
        {           
            __up   := CETrainer.keyevent("Up")
            __down := CETrainer.keyevent("down")
            if (__up = 1)
            flag.SetValue(1)
            else if (__down = -1) 
            flag.SetValue(2) 
            else if (__down < 0 or __up < 0)                
            flag.SetValue(3)    

            if getkeystate("left", "p")
            xpos.SetValue(xpos.GetValue(16)-2)  
            else if getkeystate("right", "p")
            xpos.SetValue(xpos.GetValue(16)+2)             
        }           
    }
}
HODTrainer.__init().TrainerLoop("HODWin32.exe", 15)
return






