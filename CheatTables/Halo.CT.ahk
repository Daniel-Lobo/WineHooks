<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>12</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>11</ID>
      <Description>"Auto - Player"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(player, 512)
registersymbol(player)
registersymbol(inf_hp_flag)
registersymbol(easy_kills_flag)
label(inf_hp_flag)
label(easy_kills_flag)

/* player + E4 - shield
 * player + E0 - hp
 */
player:
  db 00 00 00 00
inf_hp_flag:
  db 00 00 00 00
easy_kills_flag:
  db 00 00 00 00
  fld dword ptr [ecx+000000E4]
  mov [player], ecx
jmp retpoint

004B3C19:
jmp player+0c
  nop
retpoint:

[disable]
004B3C19:
fld dword ptr [ecx+000000E4]
dealloc(player)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>16</ID>
          <Description>"Auto - Damage"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
alloc(inf_hp, 512)
label(inf_hp_ret_point)
label(enemies)

inf_hp:
    fstp dword ptr [esi+000000E0]
    cmp [player], esi
    jne enemies
    cmp [inf_hp_flag], 0
    je inf_hp_ret_point
    mov [esi+000000E0], (float)1.0
    mov [esi+000000E4], (float)1.0
jmp inf_hp_ret_point

enemies:
    cmp [easy_kills_flag], 0
    je inf_hp_ret_point
    mov [esi+000000E0], (float)-1.0
    //mov [esi+000000E4], (float)-1.0
jmp inf_hp_ret_point

haloce.exe.text+F1DAF:
    jmp inf_hp
    nop
inf_hp_ret_point:

[disable]
haloce.exe.text+F1DAF:
fstp dword ptr [esi+000000E0]
dealloc(inf_hp)


</AssemblerScript>
          <Hotkeys>
            <Hotkey>
              <Action>Toggle Activation</Action>
              <Keys>
                <Key>73</Key>
              </Keys>
              <ID>0</ID>
              <ActivateSound>Activate</ActivateSound>
              <DeactivateSound>Deactivate</DeactivateSound>
            </Hotkey>
          </Hotkeys>
        </CheatEntry>
        <CheatEntry>
          <ID>17</ID>
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
          <ID>18</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
easy_kills_flag:
db 00 00 00 01

[disable]
easy_kills_flag:
db 00 00 00 00


</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>1</ID>
      <Description>"B - inf Bullets and grenades"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
//ammo
004C7456:
nop
nop
nop
nop

//grenades
00571A14:
nop
nop
nop
nop
nop
nop
nop

[disable]
004C7456:
mov [esi+08],ax

00571A14:
dec [eax+edi+0000031E]

</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Custom edition - http://hce.halomaps.org/?fid=410, 1.0.1 - http://hce.halomaps.org/index.cfm?fid=6798, 
         with Chimera - https://opencarnage.net/index.php?/topic/6916-chimera-download-source-and-discord-updated-2021-05-04/ 
HP\Shield:     Float.   Full HP\Shield values are 1, Shield adress is 4 bytes after HP, code shared with enemies
Ammo\Grenades: 2 bytes. Same value as shown in the HUD
</Comments>
</CheatTable>
