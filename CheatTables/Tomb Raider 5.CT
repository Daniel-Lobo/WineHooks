<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>8</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hp, 64)
label(hp_ret)

hp:
  mov eax,[PCTomb5.exe+A5BF08]
  mov cx, 3ef
  mov [eax+22], cx
  movsx ecx,word ptr [eax+22]
jmp hp_ret

PCTomb5.exe+39E50:
  jmp hp
  db 90 90 90 90
hp_ret:

[disable]
PCTomb5.exe+39E50:
  mov eax,[PCTomb5.exe+A5BF08]
  movsx ecx,word ptr [eax+22]

dealloc(*)







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>0</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
PCTomb5.exe+535C6:
  nop


[disable]
PCTomb5.exe+535C6:
  dec ecx








</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"F - inf Flares"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
PCTomb5.exe+525A3:
  nop
  nop

[disable]
PCTomb5.exe+525A3:
  dec ax








</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>17</ID>
      <Description>"S - inf Sprint"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
PCTomb5.exe+44C5D:
  db 90 90 90 90 90 90 90

[disable]
PCTomb5.exe+44C5D:
 dec word ptr [PCTomb5.exe+A5BF04]









</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>3</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>18</ID>
          <Description>"Flares"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>Tomb4.exe+40E11D</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Multipatch - https://www.tombraiderchronicles.com/windows10/patch.html</Comments>
</CheatTable>
