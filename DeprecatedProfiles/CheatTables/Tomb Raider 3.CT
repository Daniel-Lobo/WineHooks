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
  mov eax,[tomb3.exe+2D62A4]
  mov cx, 3ef
  mov [eax+22], cx
  movsx ecx,word ptr [eax+22]
jmp hp_ret

tomb3.exe+34A10:
  jmp hp
  db 90 90 90 90
hp_ret:

[disable]
tomb3.exe+34A10:
  mov eax,[tomb3.exe+2D62A4]
  movsx ecx,word ptr [eax+22]
dealloc(*)







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>0</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
tomb3.exe+4A932:
  nop

tomb3.exe+4598E:
  db 90 90 90 90 90 90

tomb3.exe+46DB7:
  db 90 90 90 90 90 90

tomb3.exe+460CE:
  db 90 90 90 90 90 90

[disable]
tomb3.exe+4A932:
  dec ecx

tomb3.exe+4598E:
  dec [tomb3.exe+2D6276]

tomb3.exe+46DB7:
  dec [tomb3.exe+2D627E]

tomb3.exe+460CE:
  dec [tomb3.exe+2D627A]






</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"F - inf Flares"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
tomb3.exe+384DF:
  db 90 90 90 90 90 90 90 90

[disable]
tomb3.exe+384DF:
  dec word ptr [edx*2+tomb3.exe+C6AF8]






</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>17</ID>
      <Description>"S - inf Sprint"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
tomb3.exe+3F63D:
  db 90 90 90 90 90 90 90

[disable]
tomb3.exe+3F63D:
  dec word ptr [tomb3.exe+2D62A0]







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>3</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>9</ID>
          <Description>"Flares"</Description>
          <VariableType>Byte</VariableType>
          <Address>tomb3.exe+C6B0A</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Multipatch - https://www.tombraiderchronicles.com/windows10/patch.html</Comments>
</CheatTable>
