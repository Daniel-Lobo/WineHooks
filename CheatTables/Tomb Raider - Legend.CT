<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>0</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hp, 128)
label(hp_ret)

hp:
  mov [ecx+000005A0], (float)2000
  mov edx,[ecx+000005A0]
jmp hp_ret

trl.exe+EB148:
  jmp hp
  nop
hp_ret:

[disable]
trl.exe+EB148:
  mov edx,[ecx+000005A0]
dealloc(*)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>2</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
trl.exe+14D3D7:
  nop
  nop

[disable]
trl.exe+14D3D7:
  dec al


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"F - inf Flashlight"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
trl.exe+12D1CE:
  nop
  nop
  nop

[disable]
trl.exe+12D1CE:
  fsubr dword ptr [esi+70]




</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.2</Comments>
</CheatTable>
