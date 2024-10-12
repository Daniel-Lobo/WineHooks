#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"740x280
=========================================================================================
INVULNERABILITY
Adapted from here: https://www.youtube.com/watch?v=1BHu_lNHX8U
=========================================================================================

=========================================================================================
LEVEL AND FMV SELECT
These are just macros for the game's built in cheats and will just work on the main menu. Just hold shift and then 'L' or 'F' and 
keep both down until the senquence of keys that activates the cheat completes
=========================================================================================`

=========================================================================================
ZERO CASUALTIES
Casualities are turned into scapes
=========================================================================================
"
)

global dead         := new CEEntry("Casualities")
global spcaped      := new CEEntry("Escapees")
global invulnerable := new CEEntry("I - Invulnerable")
global grenades     := new CEEntry("G - inf Grenades")
;exoddus: https://www.youtube.com/watch?v=1BHu_lNHX8U

class key
{
    __new(key, interval=100)
    {
        this.vk            := GetKeyVK(key)
		this.sc            := GetKeySC(key)
        this.extended_flag := instr("shift up down left right", key) ? 0x0001 : 0
        this.interval      := interval
    }
    send()
    {
        interval := this.interval
        dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.extended_flag, uint, 0)
        sleep, % interval
        dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.extended_flag|0x0002, uint, 0)
    }
    senddown()
    {
        dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.extended_flag, uint, 0)        
    }
    sendup()
    {
        dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.extended_flag|0x0002, uint, 0)        
    }
}

class ExoddusTrainer extends CETrainer
{    
	OnLoop()
	{
        if CETrainer.keyevent("i") > 0	
        {		
            this.speak(invulnerable.Toogle("Invulnerability"))         
        }

        if CETrainer.keyevent("g") > 0	
        {	    
            this.speak(grenades.Toogle("infinite granades"))           
        }   
        
        if CETrainer.keyevent("z") > 0	
        {	
            spcaped.SetValue(spcaped.GetValue(512)+dead.GetValue(512))           
            dead.SetValue(0)
            this.PlaySound(1)
        } 

        if GetKeyState("shift", "P")
        {  
            if CETrainer.keyevent("L") > 0		
            {	            
                for i, k in ["Down", "Right", "Left", "Right", "Left", "Right", "Left", "UP"]
                {
                    new key(k).send()
                }                              
            }	
            else if CETrainer.keyevent("F") > 0		
            {	   
                for i, k in ["Up", "Left", "Right", "Left", "Right", "Left", "Right", "Down"]
                {
                    new key(k).send()
                }                                                        
            }	
            else if CETrainer.keyevent("N") > 0		
            {	   
                for i, k in ["Left", "Right", "Up", "Down", "Left", "Right"]
                {
                        new key(k).send()
                }                                                        
            }	 
        }       	
	}
}

ExoddusTrainer.__init().TrainerLoop("Exoddus.exe", 100)
return






