<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>10</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>2</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscan(player_orig_code, 0f 84 ?? ?? ?? ?? D9 81 60 01 00 00)
registersymbol(player_orig_code)
aobscan(hit_orig_code, D8 64 24 64 D9 98 60 01 00 00)
registersymbol(hit_orig_code)
alloc(hit, 512)
label(hit_code)
label(player)
label(player_code)
label(player_retadd)
label(hit_retadd)
label(enemy)
label(hp_flag)
label(kill_flag)
registersymbol(hp_flag)
registersymbol(kill_flag)
registersymbol(player)

hit:
player:
  db 00 00 00 00
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
player_code:
  mov [player], ecx
  fld dword ptr [ecx+00000160]
jmp player_retadd

hit_code:
  fstp dword ptr [eax+00000160]
  cmp eax, [player]
  jne enemy
  cmp [hp_flag], 0
  je hit_retadd
  mov [eax+00000160], (float)100
jmp hit_retadd

enemy:
  cmp [kill_flag], 0
  je hit_retadd
  mov [eax+00000160], (float)0
jmp hit_retadd

//hl.player+13A5:
player_orig_code+6:
  jmp player_code
  nop
player_retadd:

//hl.CGib::StickyGibTouch+625:
hit_orig_code+4:
  jmp hit_code
  nop
hit_retadd:

[disable]
//hl.player+13A5:
player_orig_code+6:
  fld dword ptr [ecx+00000160]

//hl.CGib::StickyGibTouch+625:
hit_orig_code+4:
  fstp dword ptr [eax+00000160]



</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>3</ID>
          <Description>"H - inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
hp_flag:
  db 00 00 00 01

[disable]
hp_flag:
  db 00 00 00 00



</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>4</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
kill_flag:
  db 00 00 00 01

[disable]
kill_flag:
  db 00 00 00 00



</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>5</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscan(ammo, 2B D0 89 11 8B 4E 70)
aobscan(granades, 4F 89 38 8B 86 98 00 00 00)
registersymbol(ammo)
registersymbol(granades)

ammo:
  nop
  nop

granades:
  nop

[disable]
ammo:
  db 2b d0
granades:
  db 4F
unregistersymbol(*)





</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>9</ID>
      <Description>"L - inf flashLight"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscan(light, 89 86 C8 02 00 00 D9 9E C4 02 00 00)
registersymbol(light)
alloc(inf_light, 128)
label(inf_light_retadd)

inf_light:
  mov [esi+000002C8],64
jmp inf_light_retadd

light:
  jmp inf_light
  nop
inf_light_retadd:

[disable]
light:
  db 89 86 C8 02 00 00
unregistersymbol(*)





</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version:    1.1.2.2
HP:         Float.   Full HP is 100, code shared with enemies, 
                     several adresses per value including some that update the HUD when changed
FlashLoght: 4 bytes. Full HP is 100, code shared with enemies, 
                     several adresses per value including some that update the HUD when changed
Bullets:    4 bytes. Value is the same as shown in the HUD with several adresses per value 
                     including some that update the HUD when changed, several different code locations
                     for differect weapons
</Comments>
</CheatTable>
