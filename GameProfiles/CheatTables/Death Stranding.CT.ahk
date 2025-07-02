#NoEnv  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include CEpluginLib.ahk
#persistent

CETrainer.help := 
(
"590x575
 ======================================================================
 INIFINITE BLOOD, BOOTS, etc... 
 While the hotkey will toggle all these at once, you can toggle them manually, if you wish 
 Infinite endurance will allow Sam to hold his breath for as long as you want
 ======================================================================

 ======================================================================
 INIFINITE BATTERIES AND VEHICLE DURABILITY
 Same as above, regarding the hotkey
 ======================================================================

 ======================================================================
 INIFINITE ITEMS AND AMMO
 Same as above, regarding the hotkey
 Infinite items lets you use items like ladders and PCC's an infinite number of times 
 ======================================================================

 ======================================================================
 INIFINITE MATERIALS 
 This does three things
 1. You won't spend materials on the reclaim materials and fabricate equipment screens. You'll still see the 
 total amount of materials decrease after reclaiming them or fabricating equipment, but when you return 
 to either screen, you'll see that their total ammount remains the same
 2. When you aproach any auto paver or safe house, you'll see the required materias already set to 10000, 
 except for quiral crystals which are set to 0 to prevent you from getting locked out of accessing the 
 structure menu before building anything. The required special aloys for upgrading safe houses from lvl 1
 to 2 will be updated the moment you donate your crystals, to upgrade from lvl 2 to 3, the cheat won't work
 unfortunatelly 
 3. You gain 1000 quiral crystals averytime you enable the cheat
 ======================================================================

 ======================================================================
 REPAIR CARGO
 With this active, access the cargo menu and your cargo and containers will be repaired. Equipments are 
 not affected
 ======================================================================
"
)

global Materials  := new CEEntry("M - inf Materials\ez build")
global build      := [new CEEntry("Auto - ez build"), new CEEntry("Auto - gain crystals")]

global Weight     := new CEEntry("L - Light weight")
global unbreak    := new CEEntry("R - Repair cargo")

global AutoPlayer   := new CEEntry("Auto - Player")
global Player       := new CEEntry("B - inf Blood, boots, stamina and endurance") 
global PlayerStats  := [new CEEntry("Auto - boots"), new CEEntry("Auto - blood"), new CEEntry("Auto - stamina\endurance")] 

global AutoEquip  := new CEEntry("Auto - Equipment")
global Equip      := new CEEntry("P - inf battery Power and vehicle durability") 
global EquipStats := [new CEEntry("Auto - exo suit batery"), new CEEntry("Auto - vehicle battery"), new CEEntry("Auto - vehicle durability")] 

global AutoItems  := new CEEntry("Auto - Items\Ammo")
global Items      := new CEEntry("I - inf Items and ammo") 
global ItemsStats := [new CEEntry("Auto - ammo"), new CEEntry("Auto - items")] 

class DSTrainer extends CETrainer
{
    OnLoop() 
    {
        if (!AutoPlayer.IsFrozen())
        {
            this.Open("ds.exe")
            AutoPlayer.SetFrozen(1, 0)
            AutoEquip.SetFrozen(1, 0)
            AutoItems.SetFrozen(1, 0)
        }

        if CETrainer.keyevent("m") > 0  
        {
            this.Speak(Materials.Toogle("Infinite Materials"))   
            if Materials.IsFrozen() 
            {
                for k, v in build
                {
                    v.SetFrozen(1, 1)
                }
            } else {
                for k, v in build
                {
                    v.SetFrozen(0, 1)
                }
            } 
        }      
        
        else if CETrainer.keyevent("l") > 0           				
        this.Speak(Weight.Toogle("Always light weight"))

        else if CETrainer.keyevent("r") > 0           				
        this.Speak(unbreak.Toogle("Repair cargo"))

        else if CETrainer.keyevent("b") > 0   
        {        				
            this.Speak(Player.Toogle("infinite Blood, boots, stamina and endurance"))
            if Player.IsFrozen() 
            {
                for k, v in PlayerStats
                {
                    v.SetFrozen(1, 1)
                }
            } else {
                for k, v in PlayerStats
                {
                    v.SetFrozen(0, 1)
                }
            } 
        }  

        else if CETrainer.keyevent("p") > 0   
        {        				
            this.Speak(Equip.Toogle("infinite batteries and vehicle durability"))
            if Equip.IsFrozen() 
            {
                for k, v in EquipStats
                {
                    v.SetFrozen(1, 1)
                }
            } else {
                for k, v in EquipStats
                {
                    v.SetFrozen(0, 1)
                }
            } 
        }  

        else if CETrainer.keyevent("i") > 0   
        {        				
            this.Speak(Items.Toogle("infinite items and ammo"))
            if Items.IsFrozen() 
            {
                for k, v in ItemsStats
                {
                    v.SetFrozen(1, 1)
                }
            } else {
                for k, v in ItemsStats
                {
                    v.SetFrozen(0, 1)
                }
            } 
        }  
    }
}
DSTrainer.__init().TrainerLoop("ds.exe", 100)
return

