<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>17</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>10</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
gamex86.dll+313738:
nop
nop
nop
nop
nop
nop
nop
nop

[disable]
gamex86.dll+313738:
movss [esi+000000D8],xmm0


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>9</ID>
      <Description>"K - easy kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(one_hit, 512)
label(one_hit_ret_point)

one_hit:
mov [ecx+000000D8],(float)0.0
jmp one_hit_ret_point


gamex86.dll+729E:
jmp one_hit
nop
nop
nop
one_hit_ret_point:

[disable]
gamex86.dll+729E:
movss [ecx+000000D8],xmm0
dealloc(one_hit)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>11</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
gamex86.dll+38B2AD:
nop
nop
nop
nop
nop

[disable]
gamex86.dll+38B2AD:
movss [ecx+38],xmm0



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>12</ID>
      <Description>"P - inf Power"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(veil, 512)
label(veil_ret_add)

veil:
//mov [ecx+08],(float)1.0
jmp veil_ret_add

gamex86.dll+3D2BAC:
jmp veil
veil_ret_add:

[disable]
gamex86.dll+3D2BAC:
movss [ecx+08],xmm0



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>16</ID>
      <Description>"M - gain Money"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(money, 512)
label(money_ret_add)
label(no_money_gain)

money:
db 00 00 00 01
push eax
mov eax, money
cmp [eax], 00
mov [eax], 00
pop eax
je no_money_gain
add [esi+00001BA8], 3E8

no_money_gain:
cvtsi2ss xmm1,[esi+00001BA8]
jmp money_ret_add

gamex86.dll+31AFD3:
jmp money+4
nop
nop
nop
money_ret_add:

[disable]
gamex86.dll+31AFD3:
cvtsi2ss xmm1,[esi+00001BA8]




</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.2, probably works with GOG and Steam as well</Comments>
</CheatTable>
