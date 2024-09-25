<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>6</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
ForsakenHW.exe+D7CFE:
  fstp st(0)
  nop
  nop
  nop
  nop

[disable]
ForsakenHW.exe+D7CFE:
  fstp dword ptr [ecx+ForsakenHW.exe+966654]

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>12</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
alloc(hit, 128)
label(ret_add)

hit:
  mov [esi+0000017C], (float)-128
jmp ret_add

ForsakenHW.exe+3C6B8:
  jmp hit
  nop
ret_add:

[disable]
ForsakenHW.exe+3C6B8:
  fstp dword ptr [esi+0000017C]
dealloc(*)




</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>8</ID>
      <Description>"L - inf Lives"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
ForsakenHW.exe+D8CF5:
  db 90 90 90 90 90 90

[disable]
ForsakenHW.exe+D8CF5:
 mov [ForsakenHW.exe+1BAA64],ax


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>14</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
ForsakenHW.exe+A30F0:
  db 90 90 90 90 90 90

ForsakenHW.exe+BDB0A:
  db 90 90 90 90 90 90 90

[disable]
ForsakenHW.exe+A30F0:
  fsub dword ptr [ebp+ForsakenHW.exe+1C1C30]

ForsakenHW.exe+BDB0A:
  mov [eax+ForsakenHW.exe+605160],cx







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>10</ID>
      <Description>"T - inf Time"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
ForsakenHW.exe+B6C3A:
  db 90 90 90 90 90 90

[disable]
ForsakenHW.exe+B6C3A:
  fst dword ptr [ForsakenHW.exe+1C3964]



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>16</ID>
      <Description>"Left overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>5</ID>
          <Description>"HP"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>Float</VariableType>
          <Address>ForsakenHW.exe+966654</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>7</ID>
          <Description>"Lifes"</Description>
          <VariableType>Byte</VariableType>
          <Address>ForsakenHW.exe+1BAA64</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>9</ID>
          <Description>"Remaining time"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>ForsakenHW.exe+1C3964</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>13</ID>
          <Description>"Weapon"</Description>
          <VariableType>Float</VariableType>
          <Address>ForsakenHW.exe+1C1B78</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>15</ID>
          <Description>"Missiles"</Description>
          <VariableType>Byte</VariableType>
          <Address>ForsakenHW.exe+605160</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.1</Comments>
</CheatTable>
