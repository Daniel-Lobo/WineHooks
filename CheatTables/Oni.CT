<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="45">
  <CheatEntries>
    <CheatEntry>
      <ID>7</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 128)
label(hit_code)
label(hit_retadd)
label(enemy)
label(hit_ogcode)
label(hp_flag)
label(kill_flag)
label(player)
label(player_ogcode)
registersymbol(hp_flag)
registersymbol(kill_flag)
registersymbol(player)
label(player_code)
label(player_retadd)

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
player:
  db 00 00 00 01
player_code:
  mov [player], esi
  mov edx,[esi+3C]
  mov ecx,eax
  cmp [hp_flag], 00
  je player_retadd
  push [esi+3C]
  pop [esi+38]
jmp player_retadd

player_ogcode:
  mov edx,[esi+3C]
  mov ecx,eax
jmp player_retadd

hit_code:
  mov edx,[esp+14]
  cmp esi, [player]
  jne enemy
  cmp [hp_flag], 00000000
  je hit_ogcode
jmp hit_retadd

enemy:
  cmp [kill_flag], 00
  je hit_ogcode
  sub eax, eax
jmp hit_retadd

hit_ogcode:
  //mov edx,[esp+14]
  sub eax,ebx
jmp hit_retadd

Oni.exe+100C39:
  jmp player_code
  nop
player_retadd:

Oni.exe+E6A4E:
  jmp hit_code
  nop
hit_retadd:

[disable]
Oni.exe+100C39:
  mov edx,[esi+3C]
  mov ecx,eax

//Oni.exe+E6A52:
Oni.exe+E6A4E:
  mov edx,[esp+14]
  sub eax,ebx


dealloc(*)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>9</ID>
          <Description>"H - inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
hp_flag:
  db 01 00 00 00

[disable]
hp_flag:
  db 00 00 00 00


</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>10</ID>
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
      <ID>8</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Oni.exe+119CC8:
  db 90 90 90 90

[disable]
Oni.exe+119CC8:
  sub [esi+56],dx


</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail "1.0" with daodan 4.0 - http://mods.oni2.net/node/233
</Comments>
</CheatTable>
