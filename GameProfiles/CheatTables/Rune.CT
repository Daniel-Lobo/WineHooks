<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>12</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>9</ID>
      <Description>"Auto - Core.dll+37002"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(new_mem, 512)
registersymbol(inf_hp_flag)
registersymbol(inf_rune_flag)
label(inf_hp_flag)
label(easy_kill_flag)
label(inf_rune_flag)
label(player)
label(rune_power)
label(enemy)
label(orig_code)
label(ret_point)

new_mem:
inf_hp_flag:
  db 00 00 00 00
easy_kill_flag:
  db 00 00 00 00
inf_rune_flag:
  db 00 00 00 00

player:
  sub eax,edx
  cmp [edi+68], f
  jne rune_power
  cmp [edi+6c], f
  jne rune_power
  cmp [edi+1c], 4b
  jne rune_power
  cmp [edi+24], 4b
  jne rune_power
  cmp [inf_hp_flag], 00
  je orig_code

  mov [edi+10],64
  mov [edi],64
  mov edi,eax
jmp ret_point

enemy:
  jmp rune_power
  mov [edi],0
  mov edi,eax
jmp ret_point

rune_power:
  cmp [edi+60], f
  jne orig_code
  cmp [edi+64], f
  jne orig_code
  cmp [edi+1c], 4b
  jne orig_code
  cmp [edi+24], 4b
  jne orig_code
  cmp [inf_rune_flag], 00
  je orig_code

  mov [edi],64
  mov edi,eax
jmp ret_point

orig_code:
  mov [edi],eax
  mov edi,eax
jmp ret_point

Core.dll+37002:
  jmp player
  nop
ret_point:

[disable]
Core.dll+37002:
  sub eax,edx
  mov [edi],eax
  mov edi,eax
unregistersymbol(inf_hp_flag)
unregistersymbol(inf_rune_flag)
dealloc(new_mem)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>10</ID>
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
          <ID>11</ID>
          <Description>"P - inf rune Power"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
inf_rune_flag:
  db 00 00 00 01

[disable]
inf_rune_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.07
</Comments>
</CheatTable>
