<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>41</ID>
      <Description>"Auto - Core.UObject::execSubtractEqual_IntInt"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(ammo, 512)
registersymbol(Core_UObject_execSubtractEqual_IntInt_6E_game_code)
label(ammo_code)
label(Core_UObject_execSubtractEqual_IntInt_6E_game_code)
label(Core_UObject_execSubtractEqual_IntInt_6E_ret_point)
label(player)
label(enemie)
label(inf_hp_flag)
label(easy_kills_flag)
label(inf_ammo_flag)
registersymbol(inf_hp_flag)
registersymbol(easy_kills_flag)
registersymbol(inf_ammo_flag)

ammo:
inf_hp_flag:
  db 00 00 00 00
easy_kills_flag:
  db 00 00 00 00
inf_ammo_flag:
  db 00 00 00 00
ammo_code:
  cmp ecx, 1
  jne player
  cmp eax, 1
  jne player
  cmp [inf_ammo_flag], 00
  je Core_UObject_execSubtractEqual_IntInt_6E_game_code
  mov edi,[edi]
  mov ecx,[esp+14]
jmp Core_UObject_execSubtractEqual_IntInt_6E_ret_point

player:
  //cmp [edi+ac], 7
  cmp [edi+134], 2
  jne enemie
  cmp [inf_hp_flag], 00
  je Core_UObject_execSubtractEqual_IntInt_6E_game_code
  mov edi,[edi]
  mov ecx,[esp+14]
jmp Core_UObject_execSubtractEqual_IntInt_6E_ret_point

enemie:
  cmp eax, ecx
  jne Core_UObject_execSubtractEqual_IntInt_6E_game_code
  cmp [easy_kills_flag], 00
  je Core_UObject_execSubtractEqual_IntInt_6E_game_code
  mov [edi],00
  mov edi,[edi]
  mov ecx,[esp+14]
jmp Core_UObject_execSubtractEqual_IntInt_6E_ret_point

Core_UObject_execSubtractEqual_IntInt_6E_game_code:
  sub [edi],eax
  mov edi,[edi]
  mov ecx,[esp+14]
jmp Core_UObject_execSubtractEqual_IntInt_6E_ret_point

Core.UObject::execSubtractEqual_IntInt+6E:
  jmp ammo_code
  nop
  nop
  nop
Core_UObject_execSubtractEqual_IntInt_6E_ret_point:

[disable]
Core.UObject::execSubtractEqual_IntInt+6E:
  sub [edi],eax
  mov edi,[edi]
  mov ecx,[esp+14]
dealloc(ammo)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>43</ID>
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
          <ID>44</ID>
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
        <CheatEntry>
          <ID>45</ID>
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
    <CheatEntry>
      <ID>42</ID>
      <Description>"F - inf Flares"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(flares, 512)
label(flares_ret_point)

flares:
 mov edx,[esp+10]
 mov [edx],ecx
 dec [eax]
 cmp ebx, 01
 jne flares_ret_point
 cmp [eax+4], 1
 jne flares_ret_point
 inc [eax]
jmp flares_ret_point

Core.UObject::execSubtractSubtract_Int+46:
  jmp flares
  nop
  nop
  nop
flares_ret_point:

[disable]
Core.UObject::execSubtractSubtract_Int+46:
  mov edx,[esp+10]
  mov [edx],ecx
  dec [eax]
dealloc(flares)

</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Oldunreal, 227i</Comments>
</CheatTable>
