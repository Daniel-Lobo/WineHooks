<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>5</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 128)
label(hit_code)
label(hit_retadd)
label(enemy)
label(player)
label(player_code)
label(player_retadd)
label(hp_flag)
label(kill_flag)
registersymbol(hp_flag)
registersymbol(kill_flag)

hit:
player:
  db 00 00 00 00
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00

player_code:
  fld dword ptr [eax+00000154]
  mov [player], eax
  cmp [hp_flag], 0
  je player_retadd
  mov [eax+00000154], (float)200
jmp player_retadd

hit_code:
  fstp dword ptr [esi+00000154]
  cmp [player], esi
  jne enemy
  cmp [hp_flag], 0
  je hit_retadd
  mov [esi+00000154], (float)200
jmp hit_retadd

enemy:
  cmp [kill_flag], 0
  je hit_retadd
  mov [esi+00000154], (float)0
jmp hit_retadd

IronStorm.exe+BF253:
  jmp player_code
  nop
player_retadd:

IronStorm.exe+2A6C9:
  jmp hit_code
  nop
hit_retadd:

[disable]
IronStorm.exe+BF253:
  fld dword ptr [eax+00000154]

IronStorm.exe+2A6C9:
  fstp dword ptr [esi+00000154]
dealloc(*)
unregistersymbol(*)


</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>7</ID>
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
          <ID>8</ID>
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
      <ID>6</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
IronStorm.exe+13B95:
  db 90 90 90 90


[disable]
IronStorm.exe+13B95:
  dec word ptr [eax+08]



</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.04
</Comments>
</CheatTable>
