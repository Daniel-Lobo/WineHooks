#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

global lvl      := new CEEntry("Level Skip")
global Damage   := new CEEntry("Auto")
global Reset    := new CEEntry("Auto - Damage")
global HP       := new CEEntry("H - inf HP")
global EZKills  := new CEEntry("K - easy kills")
global InfAmmo  := new CEEntry("M - inf magic")
class AliceTainer extends CETrainer
{
    ShowHelp()
    {
        ;CETrainer.ShowHelp.call(this)
        if (lvl.IsFrozen())
        {
            lvl.SetFrozen(0, 1)
            text=
            (LTRIM
            Paste this on your config.cfg file:

            alias lvl2 "map pandemonium; give all; bind l lvl3"
            alias lvl3 "map fortress1$fortress1_start1; give all; bind l lvl4"
            alias lvl4 "fortress2; give all; bind l lvl5"
            alias lvl5 "fortress1$fortress1_start2; give all; bind l lvl6"
            alias lvl6 "map skool2; give all; bind l lvl7"
            alias lvl7 "map skool1$skool1_start2; give all; bind l lvl8"
            alias lvl8 "map potears1; give all; bind l lvl9"
            alias lvl9 "map potears2; give all; bind l lvl10"
            alias lvl10 "map potears3; give all; bind l lvl11"
            alias lvl11 "map utemple; give all; bind l lvl12"
            alias lvl12 "map garden1; give all; bind l lvl13"
            alias lvl13 "map garden2; give all; bind l lvl14"
            alias lvl14 "map garden3; give all; bind l lvl15"
            alias lvl15 "map cetipede1; give all; bind l lvl16"
            alias lvl16 "map cetipede2; give all; bind l lvl17"
            alias lvl17 "map forest$wforest_start1; give all; bind l lvl18"
            alias lvl18 "map wchess1; give all; bind l lvl19"
            alias lvl19 "map wchess2; give all; bind l lvl20"
            alias lvl20 "map wchess3; give all; bind l lvl21"
            alias lvl21 "map rchess1; give all; bind l lvl22"
            alias lvl22 "map hatter1; give all; bind l lvl23"
            alias lvl23 "map hatter2; give all; bind l lvl24"
            alias lvl24 "map jlair1; give all; bind l lvl25"
            alias lvl25 "map jlair2; give all; bind l lvl26"
            alias lvl26 "map wforest$wforest_start2; give all; bind l lvl27"
            alias lvl27 "map hedge1; give all; bind l lvl28"
            alias lvl28 "map tower1; give all; bind l lvl29"
            alias lvl29 "map hedge2; give all; bind l lvl30"
            alias lvl30 "map tower2; give all; bind l lvl31"
            alias lvl31 "map hedge3; give all; bind l lvl32"
            alias lvl32 "map tower3; give all; bind l lvl33"
            alias lvl33 "map grounds1; give all; bind l lvl34"
            alias lvl34 "map grounds2; give all; bind l lvl35"
            alias lvl35 "map facade; give all; bind l lvl36"
            alias lvl36 "map keep; give all; bind l lvl37"     
            bind l "lvl2"       
            )
            this.Showtext(350, 600, "Level Skip", text)
        }
    }    
	OnLoop()
	{
        
		if (!Damage.IsFrozen())
        {
            this.Open("Alice.exe")
            Damage.SetFrozen(1)	           
        }
		if CETrainer.keyevent("h") > 0	
		{	
			this.Speak(HP.Toogle("Infinite HP"))	
		}	
		else if CETrainer.keyevent("k") > 0				
		{	
			this.Speak(EZKills.Toogle("One hit kills"))	
		}
		else if CETrainer.keyevent("m") > 0	
		{	
			this.Speak(InfAmmo.Toogle("Infinite mana"))	
		}	
        if(HP.IsFrozen() or EZKills.IsFrozen())
        {	
            Reset.SetFrozen(0, 1)
            Reset.SetFrozen(1, 1)	
        }
        if (InfAmmo.IsFrozen())
        {
            InfAmmo.SetFrozen(0, 1)	
            InfAmmo.SetFrozen(1, 1)	
        }    
	}
}

AliceTainer.__Init().TrainerLoop("Alice.exe", 100)
return




