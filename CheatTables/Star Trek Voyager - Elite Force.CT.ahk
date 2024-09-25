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

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
hit_code:
  mov [esi+0000021C],edx
  push esi
  add esi, 21c
  cmp esi, 20286c14
  pop esi
  jne enemy
  cmp [hp_flag], 00
  je hit_ret
  mov [esi+0000021C],64
jmp hit_ret

enemy:
  cmp [kill_flag], 00
  je hit_ret
  mov [esi+0000021C],0
jmp hit_ret

efgamex86.dll+5E9E4:
  jmp hit_code
  nop
hit_ret:

[disable]
efgamex86.dll+5E9E4:
  mov [esi+0000021C],edx

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
efgamex86.dll+5E9E4:
  jmp hit_code
  nop


[disable]
efgamex86.dll+5E9E4:
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
efgamex86.dll+14323:
  nop
  nop


[disable]
efgamex86.dll+14323:
  sub edx,edi


</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>12</ID>
          <Description>"Auto reset - ammo"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
efgamex86.dll+14323:
  nop
  nop


[disable]
efgamex86.dll+14323:
  nop
  nop


</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>8</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>5</ID>
          <Description>"HP"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>efgamex86.dll+286C14</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, 1.2</Comments>
</CheatTable>
