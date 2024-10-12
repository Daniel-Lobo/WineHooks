#NoEnv
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"740x280
=========================================================================================
INVULNERABILITY
This changes a single byte, making Abe invunerable. I belivethis was a debug flag used by the developers and was addpated from here:
http://www.gamepatchplanet.com/game/download-tr.php?file=ODDWORLD.ABES.ODDYSEE.IMMORTAL.TRAINER.BY.kapteeni13.zip
=========================================================================================

=========================================================================================
LEVEL AND FMV SELECT
These are just macros for the game's built in cheats and will just work on the main menu. Just hold shift and then 'L' or 'F' and 
keep both down until the senquence of keys that activates the cheat completes
=========================================================================================

=========================================================================================
ZERO CASUALTIES
Casualities are turned into scapes
=========================================================================================
"
)

global dead         := new CEEntry("Casualities")
global spcaped      := new CEEntry("Escapees")
global invulnerable := new CEEntry("I - Invulnerable")
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

class AbeTrainer extends CETrainer
{    
	OnLoop()
	{
        if CETrainer.keyevent("i") > 0	
        {	
            invulnerable.SetValue(invulnerable.GetValue(32)+0 > 0 ? 0 : 1, 1)           
            msg := invulnerable.GetValue(32)+0 > 0 ? "Activated": "deactivated"
            this.speak("Invulnerability " . msg)             
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
        }       	
	}
}

AbeTrainer.__init().TrainerLoop("ABEWIN.exe", 100)
return






