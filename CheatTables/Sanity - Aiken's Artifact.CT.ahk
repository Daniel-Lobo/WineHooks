<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>12</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>6</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 128)
label(hit_code)
label(hit_ret)
label(enemy)
label(player)
label(player_og)
label(hp_flag)
label(kill_flag)
registersymbol(hp_flag)
registersymbol(kill_flag)
label(player_code)
label(player_ret)

hit:
player:
  db 00 00 00 00
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
player_code:
  push esi
  pop [player]
cmp [hp_flag], 00
je player_og
  push [esi+1c]
  pop [esi+14]
  //mov [esi+14], (float)100
player_og:
  fld dword ptr [esi+14]
  fld dword ptr [esi+24]
jmp player_ret

hit_code:
  mov [esi+14],eax
  fnstsw ax
  cmp esi, [player]
  jne enemy
  cmp [hp_flag], 00
  je hit_ret
  mov [esi+14],(float)100
jmp hit_ret

enemy:
  cmp [kill_flag], 00
  je hit_ret
  mov [esi+14],(float)0
jmp hit_ret

object.lto+95B9B:
  jmp player_code
  nop
player_ret:

object.lto+94E70:
  jmp hit_code
hit_ret:

[disable]
object.lto+95B9B:
  fld dword ptr [esi+14]
  fld dword ptr [esi+24]

object.lto+94E70:
  mov [esi+14],eax
  fnstsw ax
dealloc(*)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>10</ID>
          <Description>"H - inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
hp_flag:
  db 00 00 00 01

[disable]
hp_flag:
  db 00 00 00 00


</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>11</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
kill_flag:
  db 00 00 00 01

[disable]
kill_flag:
  db 00 00 00 00


</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>9</ID>
      <Description>"P - inf Powers"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(power, 54)
label(power_ret)

power:
  pop ebp
  push [esi+1c]
  pop [esi+18]
  //mov [esi+18],eax
  pop ebx
jmp power_ret

object.lto+9512D:
  jmp power
power_ret:

[disable]
object.lto+9512D:
  pop ebp
  mov [esi+18],eax
  pop ebx
dealloc(*)



</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, "1.0"
</Comments>
</CheatTable>
