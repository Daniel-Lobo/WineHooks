<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>14</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>3</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registerSymbol(damage_player)
aobscan(damage_player, 29 9E B0 09 00 00)
registerSymbol(damage_player2)
aobscan(damage_player2, 8B 80 4C 01 00 00 FF 88 B0 09 00 00) // fall death in some places
label(damage_player_new_code)
label(damage_player_ret_point)
alloc(player_hp_add, 512)

player_hp_add:
  db 00 00 00 00 // store hp adress
damage_player_new_code:
  push esi
  pop [player_hp_add]
  add [player_hp_add], 000009B0
jmp damage_player_ret_point

damage_player:
  jmp damage_player_new_code
  nop
damage_player_ret_point:

damage_player2+6:
  db 90 90 90 90 90 90

[disable]
damage_player:
  sub [esi+000009B0],ebx
  dealloc(player_hp)
  unregisterSymbol(damage_player)
damage_player2+6:
  dec [eax+000009B0]
  unregisterSymbol(damage_player2)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>10</ID>
      <Description>"K - easy kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(enemy_hit)
aobscan(enemy_hit, 88 86 AE 03 00 00 8B 8E 40 03 00 00 85 C9)
label(enemy_hit_ret_point)
alloc(easy_kill, 512)

easy_kill:
  db 00
  mov al, 00
  mov [esi+000003AE],al
  mov al, [easy_kill]
jmp enemy_hit_ret_point

enemy_hit:
  jmp easy_kill+1
  nop
enemy_hit_ret_point:

[disable]
enemy_hit:
  mov [esi+000003AE],al
  mov ecx,[esi+00000340]
  test ecx,ecx
unregistersymbol(enemy_hit)
dealloc(easy_kill)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>7</ID>
      <Description>"B - inf Breath"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(breath)
aobscan(breath, 80 3D C0 ** ** ** ** 75 ** FF 8E 70 0A 00 00)
breath+9:
  db 90 90 90 90 90 90



[disable]
breath+9:
  dec [esi+00000A70]


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>5</ID>
      <Description>"G - gain Gold"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(gold)
aobscan(gold, FF 74 08 04 8B CB 57)
label(gold_ret_point)
alloc(gold_new_code, 512)

gold_new_code:
  add [eax+ecx+04], a
  add [eax+ecx+14], a // Onix
  push [eax+ecx+04]
  mov ecx,ebx
  push edi
jmp gold_ret_point

gold:
  jmp gold_new_code
  nop
  nop
gold_ret_point:

[disable]
gold:
  push [eax+ecx+04]
  mov ecx,ebx
  push edi
dealloc(gold_new_code)
unregistersymbol(gold)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>13</ID>
      <Description>"M - inf Monsters"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(monsters)
aobscan(monsters, 89 46 04 3B C1 7E **)
alloc(monsters_new_code, 512)
label(monsters_original_code)
label(monsters_ret_point)

monsters_new_code:
  cmp [esi+04],eax
  jng monsters_original_code
  cmp eax,ecx
jmp monsters_ret_point

monsters_original_code:
  mov [esi+04],eax
  cmp eax,ecx
jmp monsters_ret_point

monsters:
 jmp monsters_new_code
monsters_ret_point:

[disable]
monsters:
  mov [esi+04],eax
  db 3b c1 //cmp eax,ecx
unregistersymbol(monsters)
dealloc(monsters_new_code)


</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, 2018.05.23
HP:       4 bytes. 3 per icon in the HUD
Enemy HP: 4 bytes. 1 per hit needed to kill
Scarabs:  4 bytes. Same as the value seen in the HUD or inventory screen 
Monsters: 4 bytes. Same as the value seen in the HUD
Breath:   4 bytes. Full value is 1999
</Comments>
</CheatTable>
