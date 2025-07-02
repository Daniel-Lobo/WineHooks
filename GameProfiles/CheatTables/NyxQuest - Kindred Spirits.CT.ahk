#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global HP       := new CEEntry("H - inf HP")
global jmp      := new CEEntry("J - inf Jumps")
class NyxQuestTainer extends CETrainer
{
	OnLoop()
	{
		if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

        else if CETrainer.keyevent("j") > 0				
        this.Speak(jmp.Toogle("Infinite jumps"))			
	}
}

NyxQuestTainer.__init().TrainerLoop("NyxQuest.exe", 100)
return






