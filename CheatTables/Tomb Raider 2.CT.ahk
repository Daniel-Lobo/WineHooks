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
  mov eax,[Tomb2.exe+1207BC]
  mov cx, 3ef
  mov [eax+22], cx
  movsx ecx,word ptr [eax+22]
jmp hp_ret

Tomb2.exe+21B50:
  jmp hp
  db 90 90 90 90
hp_ret:

[disable]
Tomb2.exe+21B50:
  mov eax,[Tomb2.exe+1207BC]
  movsx ecx,word ptr [eax+22]
dealloc(*)







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>0</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Tomb2.exe+2F414:
  nop

Tomb2.exe+2C5A9:
  db 90 90 90 90 90 90

Tomb2.exe+2C160:
  db 90 90 90 90 90 90

[disable]
Tomb2.exe+2F414:
  dec ecx

Tomb2.exe+2C5A9:
  dec [Tomb2.exe+1207B0]

Tomb2.exe+2C160:
  dec [Tomb2.exe+1207AC]




</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"F - inf Flares"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Tomb2.exe+24D6F:
  db 90 90 90 90 90 90 90 90

[disable]
Tomb2.exe+24D6F:
  dec word ptr [edx*2+Tomb2.exe+654E8]





</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>3</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>2</ID>
          <Description>"Flares"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>Tomb2.exe+654F8</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Multipatch - https://www.tombraiderchronicles.com/windows10/patch.html</Comments>
</CheatTable>
