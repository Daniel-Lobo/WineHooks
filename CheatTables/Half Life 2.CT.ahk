<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>32</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>17</ID>
      <Description>"Auto - Player"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(player_hp_acess)
aobscanmodule(player_hp_acess, "server.dll", 5d c3 83 BB E0 00 00 00 00)
registersymbol(player_hp)
alloc(player_hp, 512)
registersymbol(inf_hp_flag)
label(inf_hp_flag)
registersymbol(ez_kill_flag)
label(ez_kill_flag)
label(player_hp_acess_ret_point)
label(player_hp_acess_new_code)
label(player_hp_acess_new_code_no_heal)
label(player_hp_acess_ret_point)

player_hp:
  db 00 00 00 00
inf_hp_flag:
  db 00 00 00 00
ez_kill_flag:
  db 00 00 00 00

player_hp_acess_new_code:
  mov [player_hp],ebx
  add [player_hp], 000000E0
  cmp [inf_hp_flag], 00
  je player_hp_acess_new_code_no_heal
  mov [ebx+000000E0],64
  player_hp_acess_new_code_no_heal:
  cmp dword ptr [ebx+000000E0],00
jmp player_hp_acess_ret_point

player_hp_acess+2:
  jmp player_hp_acess_new_code
  nop
  nop
player_hp_acess_ret_point:

[disable]
player_hp_acess+2:
  cmp dword ptr [ebx+000000E0],00
unregistersymbol(player_hp_acess)
unregistersymbol(player_hp)
dealloc(player_hp)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>6</ID>
          <Description>"Auto - Damage"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
registersymbol(player_hit)
aobscanmodule(player_hit, "server.dll", 89 3E 5F B8 01 00 00 00)
alloc(player_hit_new_code, 512)
label(player_hit_ret_point)
label(player_hit_original)
label(player)
label(enemy)

player_hit_new_code:
  cmp esi, [player_hp]
  je player
  jmp enemy

player:
  cmp [inf_hp_flag], 00
  je player_hit_original
  mov [esi],64
  pop edi
  mov eax,00000001
jmp player_hit_ret_point

enemy:
  cmp [ez_kill_flag], 00
  je player_hit_original
  mov [esi],0
  pop edi
  mov eax,00000001
jmp player_hit_ret_point

player_hit_original:
  mov [esi],edi
  pop edi
  mov eax,00000001
jmp player_hit_ret_point

player_hit:
  jmp player_hit_new_code
  nop
  nop
  nop
player_hit_ret_point:

[disable]
player_hit:
  mov [esi],edi
  pop edi
  mov eax,00000001

unregistersymbol(player_hit)]
dealloc(player_hit_new_code)

</AssemblerScript>
          <CheatEntries>
            <CheatEntry>
              <ID>18</ID>
              <Description>"H - inf HP"</Description>
              <VariableType>Auto Assembler Script</VariableType>
              <AssemblerScript>[enable]
inf_hp_flag:
db 00 00 00 01

[disable]
inf_hp_flag:
db 00 00 00 00


</AssemblerScript>
            </CheatEntry>
            <CheatEntry>
              <ID>19</ID>
              <Description>"K - easy Kills"</Description>
              <VariableType>Auto Assembler Script</VariableType>
              <AssemblerScript>[enable]
ez_kill_flag:
db 00 00 00 01

[disable]
ez_kill_flag:
db 00 00 00 00



</AssemblerScript>
            </CheatEntry>
          </CheatEntries>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>26</ID>
      <Description>"P - inf aux Power"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(aux_power)
aobscanmodule(aux_power, "server.dll", F3 0F 10 45 FC F3 0F 11 06 F3 0F 10 05)

aux_power+5:
  db 90 90 90 90

[disable]
aux_power+5:
  db f3 0f 11 06 // movss [esi],xmm0
unregistersymbol(aux_power)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>31</ID>
      <Description>"l - inf flashLight"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(flashlight)
aobscanmodule(flashlight, "server.dll", ff 10 F3 0F 10 45 FC F3 0F 11 07 f3 0f)

flashlight+7:
  db 90 90 90 90

[disable]
flashlight+7:
  db f3 0f 11 07 // movss [edi],xmm0
unregistersymbol(flashlight)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>22</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(shotgun)
aobscanmodule(shotgun, "server.dll", 89 83 AC 04 00 00 8B 06 8D 4D E8)
registersymbol(magnun)
aobscanmodule(magnun, "server.dll", 89 1E 8B C7 5F 5E 5B 8B E5 5D C2 04 00 CC CC CC CC CC CC CC CC CC CC 55 8B EC 56 68 6C 05 00 00)
registersymbol(explosives)
aobscanmodule(explosives, "server.dll", 89 1E 5F 5E 5B 8B E5 5D C2 08 00)
//registersymbol(pistol)
//aobscanmodule(pistol, "server.dll", 55 8B EC 8B 45 08 56 8B F1 8D 4D 08 57 8B 3E 2B 38 8B 06 89 7D 08 3B 01 74 32 80 BE A8 FB FF FF 00 8D 8E 54 FB FF FF 74 0E 80 49 58 01 8B C6 89 3E 5F 5E 5D C2 04 00 8B 51 18 85 D2 74 0C 8B C6 2B C1 8B CA 50 E8 86 4C F5 FF 89 3E 5F 8B C6 5E 5D C2 04 00)

shotgun:
  db 90 90 90 90 90 90

magnun:
  db 90 90

explosives:
  db 90 90

//pistol+4a:
  //db 90 90

[disable]
shotgun:
  mov [ebx+000004AC],eax

magnun:
  mov [esi],ebx

explosives:
  mov [esi],ebx

//pistol+4a:
  //mov [esi],edi
unregistersymbol(shotgun)
unregistersymbol(explosives)
//unregistersymbol(pistol)
unregistersymbol(magnun)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>27</ID>
          <Description>"Auto - pistol"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
registersymbol(pistol)
aobscanmodule(pistol, "server.dll", 55 8B EC 8B 45 08 56 8B F1 8D 4D 08 57 8B 3E 2B 38 8B 06 89 7D 08 3B 01 74 32 80 BE A8 FB FF FF 00 8D 8E 54 FB FF FF 74 0E 80 49 58 01 8B C6 89 3E 5F 5E 5D C2 04 00 8B 51 18 85 D2 74 0C 8B C6 2B C1 8B CA 50 E8 86 4C F5 FF 89 3E 5F 8B C6 5E 5D C2 04 00)

pistol+4a:
  db 90 90

[disable]
pistol+4a:
  mov [esi],edi
unregistersymbol(pistol)


</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: 5377866, as shown with the 'version' console command
HP:         4 bytes. Full HP is 100, code shared with enemies, 
                     several adresses per value including some that update the HUD when changed
Aux Power:  Float.   Full Aux Power is 100, code shared with flashlight except on episode 2
Flashlight: Float.   Full Flashlight power is 100
Bullets:    4 bytes. Value is the same as shown in the HUD with several adresses per value 
                     including some that update the HUD when changed, one adress for pistol and
                     rifles, another for magnun and crosbow, another for explosives and at last 
                     one for the shotgun, byte signatures are similar to several other code 
                     segments so aobscans must be long, pistol code not shared between main 
                     game and apisodes
</Comments>
</CheatTable>
