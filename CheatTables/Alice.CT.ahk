<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>15</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(damage_new_mem, 512)
label(damage_new_code)
registersymbol(damage_new_code)
label(damage_new_code_ret_point)
label(player)
label(enemy)
label(exit)
label(inf_hp_flag)
registersymbol(inf_hp_flag)
label(ez_kills_flag)
registersymbol(ez_kills_flag)
label(exit)

damage_new_mem:
inf_hp_flag:
  db 00 00 00 00
ez_kills_flag:
  db 00 00 00 00

damage_new_code:
  fstp dword ptr [ebp+00000170]
  //cmp [ebp+8], 00
  //je player
  cmp [ebp+c], 00
  je player
jmp enemy

player:
  cmp [inf_hp_flag], 00
  je exit
  mov [ebp+00000170], (float)100.
jmp exit

enemy:
  cmp [ez_kills_flag], 00
  je exit
  mov [ebp+00000170], (float)0.
jmp exit

exit:
  cmp ebx, 1f
jmp damage_new_code_ret_point

fgamex86.dll+13D894:
  jmp damage_new_code
  nop
damage_new_code_ret_point:

[disable]
fgamex86.dll+13D894:
  fstp dword ptr [ebp+00000170]
dealloc(*)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>17</ID>
          <Description>"H - inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
inf_hp_flag:
  db 00 00 00 01

[disable]
inf_hp_flag:
  db 00 00 00 00


</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>18</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
ez_kills_flag:
  db 00 00 00 01

[disable]
ez_kills_flag:
  db 00 00 00 00


</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>16</ID>
          <Description>"Auto - damage"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
fgamex86.dll+13D894:
  jmp damage_new_code
  nop

[disable]
fgamex86.dll+13D894:
  fstp dword ptr [ebp+00000170]


</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>20</ID>
      <Description>"M - inf Magic"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
fgamex86.dll+141121:
  nop
  nop
  nop
  nop

[disable]
fgamex86.dll+141121:
  fsub dword ptr [esp+30]



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>21</ID>
      <Description>"Level Skip"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail "1.0"
</Comments>
</CheatTable>
