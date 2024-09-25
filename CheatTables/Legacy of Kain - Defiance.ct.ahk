<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>10</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
"defiance.exe"+107E96:
nop
nop
nop
nop
nop
nop

"defiance.exe"+107C61:
nop
nop
nop
nop
nop
nop

[DISABLE]
// Damage
"defiance.exe"+107E96:
fst dword ptr [eax+00000368]

// Heath Drain
"defiance.exe"+107C61:
fst dword ptr [ecx+00000368]
</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>7</ID>
      <Description>"Z - EZ kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
"defiance.exe"+7E8BE:
mov [ebx+00000454],0
 
[DISABLE]
"defiance.exe"+7E8BE:
mov [ebx+00000454],eax
</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>9</ID>
      <Description>"M - shift to Material anywhere"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, 1.02. proabaly works on Retail and Steam as well
</Comments>
</CheatTable>
