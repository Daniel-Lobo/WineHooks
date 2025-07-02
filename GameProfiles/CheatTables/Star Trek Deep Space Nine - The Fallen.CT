<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>4</ID>
      <Description>"Auto - Core.dll+3429F"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(newmem, 512)
label(ret_point)
label(orig_code)
label(player)
label(enemy)
label(inf_hp)
label(ammo)
label(flashlight)
label(inf_hp_flag)
label(easy_kills_flag)
label(inf_ammo_flag)
label(inf_light_flag)
registersymbol(inf_hp_flag)
registersymbol(easy_kills_flag)
registersymbol(inf_ammo_flag)
registersymbol(inf_light_flag)

newmem:
inf_hp_flag:
db 00 00 00 00
easy_kills_flag:
db 00 00 00 00
inf_ammo_flag:
db 00 00 00 00
inf_light_flag:
db 00 00 00 00
player:
  push eax
  mov eax, [edi+c4]
  cmp eax, [edi+c8]
  pop eax
  jne ammo

  cmp [edi+c4], 9
  je inf_hp
  cmp [edi+c4], a
  je inf_hp
  cmp [edi+c4], b
  je inf_hp
  cmp [edi+c4], c
  je inf_hp
  cmp [edi+c4], d
  je inf_hp
  cmp [edi+c4], f
  je inf_hp
  cmp [edi+c4], 10
  je inf_hp
  //cmp [edi+2c], 301 // enemy and player
  //je inf_hp
  jmp enemy
inf_hp:
  cmp [inf_hp_flag], 00
  je orig_code
  mov eax,64
  mov [esi+0C],ecx
  mov [edi],eax
  jmp ret_point

enemy:
  cmp [edi+c4], 0
  je ammo
  //cmp [edi+2c], 301
  //jmp ammo
  cmp [easy_kills_flag], 00
  je orig_code
  sub eax,eax
  mov [esi+0C],ecx
  mov [edi],eax
jmp ret_point

ammo:
  cmp edx, a
  jne flashlight
  cmp [inf_ammo_flag], 00
  je orig_code
  mov eax,[edi+4]
  mov [esi+0C],ecx
  mov [edi],eax
jmp ret_point

flashlight:
  cmp [edi+48], b
  jne orig_code
  cmp [edi+4c], b
  jne orig_code
  cmp [inf_light_flag], 00
  je orig_code
  mov [esi+0C],ecx
  mov [edi],eax
jmp ret_point

orig_code:
  sub eax,edx
  mov [esi+0C],ecx
  mov [edi],eax
jmp ret_point

Core.dll+3429F:
  jmp player
  nop
  nop
ret_point:

[disable]
Core.dll+3429F:
  sub eax,edx
  mov [esi+0C],ecx
  mov [edi],eax
unregistersymbol(inf_hp_flag)
unregistersymbol(easy_kills_flag)
unregistersymbol(inf_ammo_flag)
unregistersymbol(inf_light_flag)
dealloc(newmem)


</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>5</ID>
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
          <ID>6</ID>
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
          <ID>7</ID>
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
        <CheatEntry>
          <ID>8</ID>
          <Description>"F - inf Flashlight"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
inf_light_flag:
db 00 00 00 01

[disable]
inf_light_flag:
db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 112000-a
</Comments>
</CheatTable>
