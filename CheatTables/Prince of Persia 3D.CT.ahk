<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>3</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 128)
label(player)
label(player_code)
label(hp_flag)
label(kill_flag)
registersymbol(hp_flag)
registersymbol(kill_flag)
label(player_ret)
label(hit_code)
label(hit_ret)
label(enemy)

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
player:
  db 00 00 00 00

player_code:
  mov [player], eax
  cmp dword ptr [eax+00000130],01
jmp player_ret

hit_code:
  cmp esi, [player]
  jne enemy
  sub [esi+00000130],ecx
  cmp [hp_flag], 00
  je hit_ret
  add [esi+00000130],ecx
jmp hit_ret

enemy:
  sub [esi+00000130],ecx
  cmp [kill_flag], 00
  je hit_ret
  mov [esi+00000130],00
jmp hit_ret

POP3D.exe+A9A22:
  jmp player_code
  nop
  nop
player_ret:

POP3D.exe+CA08E:
  jmp hit_code
  nop
hit_ret:

[disable]
POP3D.exe+A9A22:
  cmp dword ptr [eax+00000130],01

POP3D.exe+CA08E:
  sub [esi+00000130],ecx
dealloc(*)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>4</ID>
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
          <ID>5</ID>
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
      <ID>7</ID>
      <Description>"A - inf Arrows"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
POP3D.exe+C4BE2:
  db 90 90 90 90

[disable]
POP3D.exe+C4BE2:
  dec [esi+edx*4+14]


</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.01
</Comments>
</CheatTable>
