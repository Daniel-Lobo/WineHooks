<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>8</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 128)
label(ret)
label(hit_code)
label(hp_flag)
label(kill_flag)
label(enemy)
registersymbol(kill_flag)
registersymbol(hp_flag)
label(enemy)

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
hit_code:
  fstp dword ptr [eax+00000208]
  push eax
  add eax, 208
  cmp eax, 13cabb0
  pop eax
  jne enemy
  cmp [hp_flag], 0
  je ret
  mov [eax+00000208], (float)1
jp ret

enemy:
  cmp [kill_flag], 0
  je ret
  mov [eax+00000208], (float)0
jp ret

secondsight.EXE+1B4DBF:
  jmp hit_code
  nop
ret:

[disable]
secondsight.EXE+1B4DBF:
  fstp dword ptr [eax+00000208]
dealloc(*)



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
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>5</ID>
      <Description>"P - inf Powers"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(power, 64)
label(power_ret)

power:
  fsubr dword ptr [esi+18]
  fstp dword ptr [esi+18]
  mov [esi+18], (float)1
jmp power_ret

secondsight.EXE+1A0842:
  jmp power
  nop
power_ret:

[disable]
secondsight.EXE+1A0842:
  fsubr dword ptr [esi+18]
  fstp dword ptr [esi+18]
dealloc(8)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>6</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
secondsight.EXE+101C59:
  nop
  nop
  nop
  nop

[disable]
secondsight.EXE+101C59:
  sub [eax+ecx*4+34],edx


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>7</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>4</ID>
          <Description>"HP"</Description>
          <VariableType>Float</VariableType>
          <Address>secondsight.EXE+FCABB0</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>1</ID>
          <Description>"Power"</Description>
          <VariableType>Float</VariableType>
          <Address>secondsight.EXE+255D770</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.0</Comments>
</CheatTable>
