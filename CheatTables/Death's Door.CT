<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>6</ID>
      <Description>"Auto - Player"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(player)
registersymbol(player_trampoline)
registersymbol(player_hp)
registersymbol(inf_hp_flag)
registersymbol(easy_kill_flag)
label(player)
label(inf_hp_flag)
label(easy_kill_flag)
label(player_ret_point)
alloc(player_trampoline, 16, DamageablePlayer:Update+58)
alloc(player_hp, 512)

player_hp:
  db 00 00 00 00 00 00 00 00
inf_hp_flag:
  db 00 00 00 00 00 00 00 00
easy_kill_flag:
  db 00 00 00 00 00 00 00 00
player:
  mov [player_hp], rsi
  add [player_hp], 48
  movss xmm0,[rsi+48]
jmp player_ret_point

player_trampoline:
jmp player

DamageablePlayer:Update+58:
  jmp player_trampoline
player_ret_point:

[disable]
  DamageablePlayer:Update+58:
  movss xmm0,[rsi+48]
dealloc(player_trampoline)
dealloc(player_hp)
unregistersymbol(player)
unregistersymbol(player_trampoline)
unregistersymbol(player_hp)
unregistersymbol(inf_hp_flag)
unregistersymbol(easy_kill_flag)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>4</ID>
          <Description>"Auto - Damage"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
alloc(damage_trampoline, 16, Damageable:applyHealthChange)
alloc(damage_new_code, 512)
label(damage_ret_point)
label(player_hit)

damage_new_code:
  push rsi
  add rsi, 48
  cmp rsi, [player_hp]
  pop rsi
  je player_hit
  movss [rsi+48],xmm5
  cmp [easy_kill_flag], 00
  je damage_ret_point
  mov [rsi+48],(float)0.0
jmp damage_ret_point

player_hit:
  cmp [inf_hp_flag], 00
  jne damage_ret_point
  movss [rsi+48],xmm5
jmp damage_ret_point

damage_trampoline:
  jmp damage_new_code

Damageable:applyHealthChange+2c:
  jmp damage_trampoline
damage_ret_point:

[disable]
Damageable:applyHealthChange+2c:
  movss [rsi+48],xmm5
dealloc(damage_trampoline)
dealloc(damage_new_code)

</AssemblerScript>
          <CheatEntries>
            <CheatEntry>
              <ID>12</ID>
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
              <ID>13</ID>
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
          </CheatEntries>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>10</ID>
      <Description>"G - Gain souls"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(GetSoulCount_trampoline, 16, Inventory:GetSoulCount)
alloc(GetSoulCount_new_code, 512)
label(GetSoulCount_ret_point)

GetSoulCount_new_code:
  db 00 00 00 01
  movsxd rdi,dword ptr [rsi+44]
  mov rax,rdi
  cmp [GetSoulCount_new_code], 00
  je GetSoulCount_ret_point
  mov [GetSoulCount_new_code], 00
  add [rsi+44], 64
  movsxd rdi,dword ptr [rsi+44]
  mov rax,rdi
jmp GetSoulCount_ret_point

GetSoulCount_trampoline:
  jmp GetSoulCount_new_code+8

Inventory:GetSoulCount+4f:
  jmp GetSoulCount_trampoline
  nop
  nop
GetSoulCount_ret_point:

[disable]
Inventory:GetSoulCount+4f:
  movsxd rdi,dword ptr [rsi+44]
  mov rax,rdi
dealloc(GetSoulCount_trampoline)
dealloc(GetSoulCount_new_code)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>11</ID>
      <Description>"P - gain Plant seed"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(GetSeedCount_trampoline, 16, Inventory:GetSeedCount)
alloc(GetSeedCount_new_code, 512)
label(GetSeedCount_ret_point)

GetSeedCount_new_code:
  db 00 00 00 01
  movsxd rdi,dword ptr [rsi+44]
  mov rax,rdi
  cmp [GetSeedCount_new_code], 00
  je GetSeedCount_ret_point
  mov [GetSeedCount_new_code], 00
  add [rsi+44], 1
  movsxd rdi,dword ptr [rsi+44]
  mov rax,rdi
jmp GetSeedCount_ret_point

GetSeedCount_trampoline:
  jmp GetSeedCount_new_code+8

Inventory:GetSeedCount+4f:
  jmp GetSeedCount_trampoline
  nop
  nop
GetSeedCount_ret_point:


[disable]
Inventory:GetSeedCount+4f:
  movsxd  rdi,dword ptr [rsi+44]
  mov rax,rdi
dealloc(GetSeedCount_trampoline)
dealloc(GetSeedCount_new_code)

</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, Delux Edition, 1.1.4e 
HP:              Float.   Full HP is 1 per icon in the HUD and starts at 4. Code is shared with enemies 
Seeds and Souls: 4 bytes. Values are the same as shown in the HUD 
</Comments>
</CheatTable>
