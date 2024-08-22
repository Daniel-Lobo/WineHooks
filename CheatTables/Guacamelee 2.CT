<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>9</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"Auto - Player"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(player_hp)
alloc(player_hp, 512)
label(player_hp_access_new_code)
label(inf_hp_flag)
label(easy_kills_flag)
registersymbol(inf_hp_flag)
registersymbol(easy_kills_flag)
label(player_hp_access_new_code)
registersymbol(player_hp_access)
aobscanmodule(player_hp_access, "Guac2_64.exe", F3 0F 10 B0 20 01 00 00 F3 0F 5E F0)
label(player_hp_access_ret_point)

player_hp:
  db 00 00 00 00 00 00 00 00
inf_hp_flag:
  db 00 00 00 00
easy_kills_flag:
  db 00 00 00 00
player_hp_access_new_code:
  mov [player_hp], rax
  add [player_hp], 00000120
  movss xmm6,[rax+00000120]
  divss xmm6,xmm0
jmp player_hp_access_ret_point

player_hp_access:
  jmp player_hp_access_new_code
  movaps xmm6,xmm9
player_hp_access_ret_point:

[disable]
player_hp_access:
  db F3 0F 10 B0 20 01 00 00 F3 0F 5E F0 EB 04
  //movss xmm6,[rax+00000120]
  //divss xmm6,xmm0
dealloc(player_hp)
unregistersymbol(player_hp)
unregistersymbol(player_hp_access)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>6</ID>
          <Description>"Auto - Damage"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
registersymbol(damage0)
aobscanmodule(damage0, "Guac2_64.exe", 89 87 20 01 00 00 44 8B C8 44 8B 87 1C 01 00 00)
alloc(damage0_new_code, 512)
label(damage0_original)
label(enemy)
label(damage0_ret_point)

registersymbol(damage1)
aobscanmodule(damage1, "Guac2_64.exe", 89 87 20 01 00 00 8B 87 A0 00 00 00 C1 E8 14)
label(damage1_original)
label(damage1_new_code)
label(enemy1)
label(damage1_ret_point)

damage0_new_code:
  push rdi
  add rdi, 120
  cmp rdi, [player_hp]
  pop rdi
  jne enemy
  cmp [inf_hp_flag], 00
  je damage0_original
  //push [rdi+00000118]
  //pop [rdi+00000120]
  mov r9d,eax
  mov r8d,[rdi+0000011C]
jmp damage0_ret_point

enemy:
  cmp [easy_kills_flag], 00
  je damage0_original
  mov [rdi+00000120],(float)-1.0
  mov r9d,eax
  mov r8d,[rdi+0000011C]
jmp damage0_ret_point

damage0_original:
  mov [rdi+00000120],eax
  mov r9d,eax
  mov r8d,[rdi+0000011C]
jmp damage0_ret_point

damage1_new_code:
  push rdi
  add rdi, 120
  cmp rdi, [player_hp]
  pop rdi
  jne enemy1
  cmp [inf_hp_flag], 00
  je damage1_original
  //push [rdi+00000118]
  //pop [rdi+00000120]
  mov eax,[rdi+000000A0]
  shr eax,14
jmp damage1_ret_point

enemy1:
  cmp [easy_kills_flag], 00
  je damage1_original
  mov [rdi+00000120],(float)-1.0
  mov eax,[rdi+000000A0]
  shr eax,14
jmp damage1_ret_point

damage1_original:
  mov [rdi+00000120],eax
  mov eax,[rdi+000000A0]
  shr eax,14
jmp damage1_ret_point

damage0:
  jmp damage0_new_code
  nop
  nop
damage0_ret_point:

damage1:
  jmp damage1_new_code
  nop
damage1_ret_point:

[disable]
damage0:
  mov [rdi+00000120],eax
  mov r9d,eax
  mov r8d,[rdi+0000011C]
unregistersymbol(damage0)
dealloc(damage0_new_code)

damage1:
  mov [rdi+00000120],eax
  mov eax,[rdi+000000A0]
  shr eax,14
unregistersymbol(damage1)
//dealloc(damage1_new_code)
</AssemblerScript>
          <CheatEntries>
            <CheatEntry>
              <ID>7</ID>
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
              <ID>8</ID>
              <Description>"K - easy Kills"</Description>
              <VariableType>Auto Assembler Script</VariableType>
              <AssemblerScript>[enable]
easy_kills_flag:
db 00 00 00 01

[disable]
easy_kills_flag:
db 00 00 00 00



</AssemblerScript>
            </CheatEntry>
          </CheatEntries>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>3</ID>
      <Description>"Z - inf stamina"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(use_stamina)
aobscanmodule(use_stamina, "Guac2_64.exe", F3 0F 11 84 81 BC 00 00 00)
use_stamina:
db 90 90 90 90 90 90 90 90 90


[disable]
use_stamina:
movss [rcx+rax*4+000000BC],xmm0
unregistersymbol(use_stamina)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>12</ID>
      <Description>"G - gain Gold"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>11</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>10</ID>
          <Description>"Gold"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>Guac2_64.exe+7002C8</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, Complete Edition, 2.0.11, 64 bit
HP:          Float.   Full HP Starts at 100
Gold:        4 bytes. Same value as seen in the HUD or map screen 
Stamina:     Float.   1 per icon in the HUD
    
</Comments>
</CheatTable>
