#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"440x180
===================================================
INFINITE HP\EASY KILLS
Easy kills might sometimes kill you, inf HP is fine  
===================================================

===================================================
GAIN SKILL POINTS
With this active, everytime you acess the skills menu you gain one point
===================================================
"
)

;dllcall("AllocConsole")
global AA       := new CEEntry("Auto - Disable screen space AA")
global Player   := new CEEntry("Auto - Player")
global Damage   := new CEEntry("Auto - Damage")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global energy   := new CEEntry("P - inf Powers")     
global bullets  := new CEEntry("B - inf Bullets")  
global skill    := new CEEntry("G - Gain skill points")
global Activate 

class Control_Trainer extends CETrainer
{
	OnLoop() 
	{
		fileopen("*", "w").write(AA.GetValue(512))
		if (AA.GetValue(512)="1")
		{			
			AA.SetValue("0")
			AA := ""
		}
	
		if (Activate.IsFrozen())
		{
			if (!Player.IsFrozen())
			{
				Player.SetFrozen(1)
				Damage.SetFrozen(1)			
			}	
		} else Activate.SetFrozen(1)

		if CETrainer.keyevent("k") > 0				
		this.Speak(EZKills.Toogle("easy kills"))	

		else if CETrainer.keyevent("h") > 0				
		this.Speak(HP.Toogle("Infinite HP"))	

		else if CETrainer.keyevent("p") > 0
		this.Speak(energy.Toogle("Infinite Powers"))

		else if CETrainer.keyevent("b") > 0
		this.Speak(bullets.Toogle("Infinite ammo"))		

		else if CETrainer.keyevent("g") > 0
		this.Speak(skill.Toogle("gain skill points"))	 
	}
}

CETrainer.OnClose          := RegisterCallback("CETrainer_OnClose", "F")
Control_Trainer.table_help := new CEEntry("Table Help")
Loop
{	
	Control_Trainer.ShowHelp()
	activate_entry := ["Auto - DX12 Activate", "Auto - DX11 Activate"]
	for k, v in ["Control_DX12.exe", "Control_DX11.exe"]
	{
		Activate := new CEEntry(activate_entry[k])
		if isobject(new CELib_Process(v))
			Control_Trainer.TrainerLoop(v, 100)
	}	
	sleep, 150
}
return



	