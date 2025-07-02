#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global __auto    := new CEEntry("Auto")
global noclip    := new CEEntry("C - no Clip")
; breaks emerging from water in the beginning of the game
global oxy       := new CEEntry("O - inf Oxygen, activate before going into water")
global oxyval    := new CEEntry("Oxigen")
global xcoord    := new CEEntry("offset X")
global ycoord    := new CEEntry("offset Y")
global quick     := new CEEntry("Q - Quick charge: shield and super shot charges faster")

class anoworTrainer extends CETrainer
{
    OnLoop()
	{
        if (!__auto.IsFrozen())
        {
            this.open("anowor.exe")
            __auto.SetFrozen(1, 0)
            if (__auto.IsFrozen())
                this.PlaySound(1)
        }  
        if (CETrainer.keyevent("C") > 0)
        {
            this.Speak(noclip.Toogle("np clip"))   
        }         
        if (CETrainer.keyevent("Q") > 0)
        {
            this.Speak(quick.Toogle("quick charge"))   
        }            
        if (oxy.IsFrozen()) 
        {
            oxyval.SetValue(0x7ff)
        }

        /*
        if getkeystate("w")
            ycoord.SetValue(-5)   
        else if getkeystate("s")
            ycoord.SetValue(5) 
        else ycoord.SetValue(0)  
        
        if getkeystate("A")
            xcoord.SetValue(-20)   
        else if getkeystate("D")
            xcoord.SetValue(20) 
        else xcoord.SetValue(0)  
        */
    }
}
anoworTrainer.__init().TrainerLoop("anowor.exe", 100)
return






