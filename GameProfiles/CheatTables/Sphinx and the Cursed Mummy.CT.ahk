#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"620x200
==========================================================================
GAIN GOLD
With this active, access the inventory and each time you bring the ability items section into view, you'll gain 10 
gold and 10 onix scarabs
==========================================================================

==========================================================================
INFINITE MONSTERS
Also gives infinite darts
==========================================================================
"
)

global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global Gold     := new CEEntry("G - gain Gold") 
global Breath   := new CEEntry("B - inf Breath")
global Monsters := new CEEntry("M - inf Monsters")

class SphynxDTrainer extends CETrainer
{
    OnLoop() 
    {
        if CETrainer.keyevent("h") > 0           				
        this.Speak(HP.Toogle("Infinite HP"))      		        

        else if CETrainer.keyevent("k") > 0		
        this.Speak(EZKills.Toogle("One hit kills"))	
     
        else if CETrainer.keyevent("g") > 0	       		
        this.Speak(Gold.Toogle("Gain gold"))        

        else if CETrainer.keyevent("b") > 0	       		
        this.Speak(Breath.Toogle("Infinite Breath"))   

         else if CETrainer.keyevent("m") > 0	       		
        this.Speak(Monsters.Toogle("Infinite Monsters"))     
    }
}
SphynxDTrainer.__init().TrainerLoop("SphinxD_GL.exe", 100)
return




