<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>2</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Darkstone.exe+B5A91:
db 90 90 90 90 90 90

[disable]
Darkstone.exe+B5A91:
  sub [esi+000000A0],ebx

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>3</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 64)
label(hit_ret)

hit:
  mov [ebp+50],ffffffff
  mov ecx,[ebp+4C]
jmp hit_ret

Darkstone.exe+987AE:
  jmp hit
  nop
hit_ret:

[disable]
Darkstone.exe+987AE:
  sub [ebp+50],edi
  mov ecx,[ebp+4C]
dealloc(*)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"M - inf Magic"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Darkstone.exe+BCC1B:
db 90 90 90 90 90 90

[disable]
Darkstone.exe+BCC1B:
  sub [ebx+000000A4],esi


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>9</ID>
      <Description>"N - no hunger"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Darkstone.exe+A9A19:
  nop
  nop

[disable]
Darkstone.exe+A9A19:
  fsub st(0),st(1)




</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>10</ID>
      <Description>"L - inf Level points"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Darkstone.exe+BEEB6:
  nop

[disable]
Darkstone.exe+BEEB6:
  dec eax





</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>13</ID>
      <Description>"G - Gain level point"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>12</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>11</ID>
          <Description>"Level Points"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>Darkstone.exe+6F9FAC</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.0.5b
</Comments>
</CheatTable>
