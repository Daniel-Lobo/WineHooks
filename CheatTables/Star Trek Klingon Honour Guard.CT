<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>4</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>0</ID>
      <Description>"Auto - Core.UObject::execSubtractEqual_IntInt+85"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(new_mem, 512)
registersymbol(inf_hp_flag)
registersymbol(inf_ammo_flag)
registersymbol(easy_kill_flag)
label(inf_hp_flag)
label(easy_kill_flag)
label(inf_ammo_flag)
label(player)
label(enemy)
label(ammo)
label(kill)
label(orig_code)
label(ret_point)
label(inf_ammo)

new_mem:
inf_hp_flag:
  db 00 00 00 00
easy_kill_flag:
  db 00 00 00 00
inf_ammo_flag:
  db 00 00 00 00

player:
  cmp [ecx+10], 0   // pig
  je enemy
  cmp [ecx+14], 201
  jne enemy
  cmp [inf_hp_flag], 00
  je orig_code
  sub edx,eax
  mov edx, 64
  mov eax,[esp+18]
  mov [ecx],edx
jmp ret_point

ammo:
  cmp [inf_ammo_flag], 00
  je orig_code
  cmp [ecx+168] 7f
  je inf_ammo
  cmp [ecx+4e8] 7f
  je inf_ammo
  cmp [ecx+28] 47f
  je inf_ammo
  //cmp [ecx+34] 100b0000 // to large, maybe pointer?
  //je inf_ammo
  jmp orig_code


inf_ammo:
  mov eax,[esp+18]
  mov [ecx],edx
jmp ret_point

enemy:
  cmp [ecx+14],301  // kling0n
  je kill
  cmp [ecx+14],201  // Pig
  je kill
  jp ammo

kill:
  cmp [easy_kill_flag], 00
  je orig_code
  sub edx,edx
  mov edx, 00
  mov eax,[esp+18]
  mov [ecx],edx
jmp ret_point

orig_code:
  sub edx,eax
  mov eax,[esp+18]
  mov [ecx],edx
jmp ret_point

Core.UObject::execSubtractEqual_IntInt+85:
  jmp player
  nop
  nop
  nop
ret_point:

[disable]
Core.UObject::execSubtractEqual_IntInt+85:
  sub edx,eax
  mov eax,[esp+18]
  mov [ecx],edx
unregistersymbol(inf_hp_flag)
dealloc(new_mem)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>1</ID>
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
          <ID>2</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
easy_kill_flag:
  db 00 00 00 01

[disable]
easy_kill_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>3</ID>
          <Description>"B - inf Bullets"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
inf_ammo_flag:
  db 00 00 00 01

[disable]
inf_ammo_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: 1.1
</Comments>
</CheatTable>
