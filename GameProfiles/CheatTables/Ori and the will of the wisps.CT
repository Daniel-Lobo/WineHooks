<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>57</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>2</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(player_hit)
aobscanmodule(player_hit, "GameAssembly.dll", 89 41 10 33 D2 0F 28 74 24 50 0F 28 7C 24 40)
alloc(player_hp, 512)
label(player_hit_new_code)
label(player_hit_ret_point)
label(inf_hp)

player_hp:
db 00 00 00 00 00 00 00 00 00
player_hit_new_code:
  cmp eax, [rcx+10]
  jl inf_hp
  mov [rcx+10],eax
inf_hp:
  xor edx,edx
  movaps xmm6,[rsp+50]
  movaps xmm7,[rsp+40]
jmp player_hit_ret_point

player_hit:
  jmp player_hit_new_code
  nop
player_hit_ret_point:

[disable]
player_hit:
db 89 41 10 33 D2 0F 28 74 24 50 0F 28 7C 24 40
/*
  mov [rcx+10],eax
  xor edx,edx
  movaps xmm6,[rsp+50]
  movaps xmm7,[rsp+40]
*/

unregistersymbol(player_hit)
dealloc(player_hp)
</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>54</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(enemy_hit)
registersymbol(enemy_hit_fucntion)
aobscanmodule(enemy_hit, "GameAssembly.dll", F3 0F 11 73 28 0F 28 74 24 40 48 83 C4 50)
aobscanmodule(enemy_hit_fucntion, "GameAssembly.dll", 40 53 48 83 EC 50 48 C7 44 24 20 FE FF FF FF)
alloc(enemy_dead, 512)
label(enemy_hit_fucntion_new_code)
label(enemy_hit_fucntion_ret_point)
label(enemy_hit_new_code)
label(enemy_hit_original_code)
label(enemy_hit_ret_point)

enemy_dead:
db (float)0.0
db (float)100.0

enemy_hit_fucntion_new_code:
  sub rsp,50
  mov qword ptr [rsp+20],FFFFFFFFFFFFFFFE
  movaps [rsp+40],xmm6
jmp enemy_hit_fucntion_ret_point

enemy_hit_new_code:
  comiss xmm6, [rbx+28]
  jnb enemy_hit_original_code
  //movss xmm6,[enemy_dead]
  //movss [rbx+28],xmm6
  //mov [enemy_dead],(float)0.0
  mov [rbx+28],(float)0.0
  movaps xmm6,[rsp+40]
  add rsp,50
jmp enemy_hit_ret_point

enemy_hit_original_code:
  movss [rbx+28],xmm6
  movaps xmm6,[rsp+40]
  add rsp,50
jmp enemy_hit_ret_point

enemy_hit:
  jmp enemy_hit_new_code
enemy_hit_ret_point:

enemy_hit_fucntion: // doesn't do anything
  jmp enemy_hit_fucntion_new_code
  nop
enemy_hit_fucntion_ret_point:

[disable]
enemy_hit:
db F3 0F 11 73 28 0F 28 74 24 40 48 83 C4 50
/*
  movss [rbx+28],xmm6
  movaps xmm6,[rsp+40]
  add rsp,50
*/
enemy_hit_fucntion:
db 40 53 48 83 EC 50 48 C7 44 24 20 FE FF FF FF
/*
  sub rsp,50
  mov qword ptr [rsp+20],FFFFFFFFFFFFFFFE
  movaps [rsp+40],xmm6
*/
unregistersymbol(enemy_hit_fucntion)
unregistersymbol(enemy_hit)
dealloc(enemy_hit_new_code)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>52</ID>
      <Description>"E - inf Energy"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(used_energy)
aobscanmodule(used_energy, "GameAssembly.dll", F3 0F 11 73 18 33 D2 48 8B CB)

used_energy:
db 90 90 90 90 90

[disable]
used_energy:
db F3 0F 11 73 18 33 D2 48 8B CB
/*
  movss [rbx+18],xmm6
  xor edx,edx
  mov rcx,rbx

*/
unregistersymbol(used_energy)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>56</ID>
      <Description>"L - gain spirit Light"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(light)
registersymbol(light_flag)
aobscanmodule(light, "GameAssembly.dll", 48 8B 40 18 48 85 C0 74 14 8B 40 30 48 83 C4 48)
alloc(light_flag, 512)
label(light_new_code)
label(light_ret_point)
label(no_light_gain)

light_flag:
db 00 00 00 01 00 00 00 01
light_new_code:
//je light+1b
  mov rax,[rax+18]
  test rax,rax
  je light+1b
  PUSHFQ
  cmp [light_flag], 00
  mov [light_flag], 00
  je no_light_gain
  add [rax+30], 64
  no_light_gain:
  POPFQ
  mov eax,[rax+30]
  add rsp,48
jmp light_ret_point

light:
 jmp light_new_code
 nop
 nop
light_ret_point:

[disable]
light:
db 48 8B 40 18 48 85 C0 74 14 8B 40 30 48 83 C4 48
/*
  mov rax,[rax+18]
  test rax,rax
  je 14
  mov eax,[rax+30]
  add rsp,48
*/
unregistersymbol(light)
unregistersymbol(light_new_code)
dealloc(light_new_code)


</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Steam\FitGirl\HOODLUM, 1.0
HP:           Float.   10 per icon in the HUD
Enemy HP:     Float.   Aprox. 4 per hit needed to kill, 'mosquito' enemy HP is 20 on normal
Energy:       Float.   1 per icon in the HUD
Spirit Light: 4 bytes. Same as the value seen on the HUD
 
</Comments>
</CheatTable>
