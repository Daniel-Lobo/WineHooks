<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>13</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>6</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 125)
label(hit_code)
registersymbol(hit_code)
label(enemy)
label(hp_flag)
label(kill_flag)
registersymbol(hp_flag)
registersymbol(kill_flag)
label(hit_ret)
label(player_code)
registersymbol(player_code)
label(player_ret)
label(player)

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
player:
  db 00 00 00 00

player_code:
  fld dword ptr [edx+000001CC]
  push edx
  pop [player]
  cmp [hp_flag], 00
  je player_ret
  mov [edx+000001CC], (float)100
jmp player_ret

hit_code:
  fstp dword ptr [eax+000001CC]
  cmp eax, [player]
  jne enemy
  cmp [hp_flag], 00
  je hit_ret
  mov [eax+000001CC], (float)100
jmp hit_ret

enemy:
  cmp [kill_flag], 00
  je hit_ret
  mov [eax+000001CC], (float)0
jmp hit_ret

gamex86.dll+e8e66:
  jmp player_code
  nop
player_ret:

gamex86.dll+2F18A8:
  jmp hit_code
  nop
hit_ret:

[disable]
gamex86.dll+e8e66:
  fld dword ptr [edx+000001CC]

gamex86.dll+2F18A8:
  fstp dword ptr [eax+000001CC]



</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>9</ID>
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
        <CheatEntry>
          <ID>11</ID>
          <Description>"Auto reset"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
gamex86.dll+e8e66:
  jmp player_code
  nop

gamex86.dll+2F18A8:
  jmp hit_code
  nop

[disable]
gamex86.dll+e8e66:
  jmp player_code
  nop


gamex86.dll+2F18A8:
  jmp hit_code
  nop





</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>7</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
gamex86.dll+346C6D:
  nop
  nop


[disable]
gamex86.dll+346C6D:
  sub eax,ebx



</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>12</ID>
          <Description>"Auto reset - ammo"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
gamex86.dll+346C6D:
  nop
  nop


[disable]
gamex86.dll+346C6D:
  nop
  nop


</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, 1.1</Comments>
</CheatTable>
