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
  mov eax,[Tomb4.exe+40E13C]
  mov cx, 3ef
  mov [eax+22], cx
  movsx ecx,word ptr [eax+22]
jmp hp_ret

Tomb4.exe+52DE0:
  jmp hp
  db 90 90 90 90
hp_ret:

[disable]
Tomb4.exe+52DE0:
  mov eax,[Tomb4.exe+40E13C]
  movsx ecx,word ptr [eax+22]
dealloc(*)







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>0</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
tomb4.exe+2E676:
  nop

Tomb4.exe+296B2:
  nop

Tomb4.exe+2A324:
  nop

[disable]
Tomb4.exe+2E676:
  dec ecx

Tomb4.exe+296B2:
  dec eax

Tomb4.exe+2A324:
  dec eax







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"F - inf Flares"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Tomb4.exe+2D9C3:
  db 90 90 90 90 90 90

[disable]
Tomb4.exe+2D9C3:
  mov [Tomb4.exe+40E11D],ax







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>17</ID>
      <Description>"S - inf Sprint"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Tomb4.exe+220ED:
  db 90 90 90 90 90 90 90

[disable]
Tomb4.exe+220ED:
  dec word ptr [Tomb4.exe+40E13A]








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
