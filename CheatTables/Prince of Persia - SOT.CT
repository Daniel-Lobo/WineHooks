<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>12</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
POP.exe+243DC0:
  db 90 90 90 90 90 90

[DISABLE]
POP.exe+243DC0:
  mov [edi+0000019C],ecx

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>11</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(enemy, 64)
enemy:
  mov [esi+00000554],0
jmp enemy_retadd

POP.exe+1FF761:
  jmp enemy
  nop
enemy_retadd:

[DISABLE]
POP.exe+1FF761:
  mov [esi+00000554],edx
dealloc(*)
</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>13</ID>
      <Description>"T - inf sand Tanks"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
POP.exe+181912:
  db 90 90 90 90 90 90

POP.exe+F6119:
  db 90 90 90 90 90 90

[DISABLE]
POP.exe+23BC4E:
  add dword ptr [edi+00000CA8],-02

POP.exe+181912:
  dec [esi+000007AC]




</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>14</ID>
      <Description>"P - inf Power tanks"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
POP.exe+23BC4E:
  db 90 90 90 90 90 90 90

[DISABLE]
POP.exe+23BC4E:
  add dword ptr [edi+00000CA8],-02





</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.81
</Comments>
</CheatTable>
