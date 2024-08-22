<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>3</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 256)
label(hp_flag)
label(kill_flag)
label(hit_code)
label(hit_ret)
label(enemy)
registersymbol(hp_flag)
registersymbol(kill_flag)

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
hit_code:
  push ecx
  add ecx, 02
  cmp ecx, Alien.exe+167C96
  pop ecx
  jne enemy
  add [ecx+02],ax
  mov eax,[edx+78]
  cmp [hp_flag], 00
  je hit_ret
  push word ptr [ecx]
  pop word ptr [ecx+2]
jmp hit_ret

enemy:
  add [ecx+02],ax
  mov eax,[edx+78]
  cmp [kill_flag], 00
  je hit_ret
  mov word ptr [ecx+02],00
jmp hit_ret

Alien.exe+19D90:
  jmp hit_code
  nop
  nop
hit_ret:

[disable]
Alien.exe+19D90:
  add [ecx+02],ax
  mov eax,[edx+78]
unregistersymbol(*)
dealloc(*)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>6</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
kill_flag:
  db 01 00 00 00

[disable]
kill_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>5</ID>
          <Description>"H - inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
hp_flag:
  db 01 00 00 00

[disable]
hp_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>8</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(inf_ammo, 256)
label(inf_ammo_ret)
label(ammo_exit)

inf_ammo:
  PUSHFD
  add eax,[edx+04]
  cmp eax,[edx+04]
  jb ammo_exit
  add eax,[edx+04]
  mov [edx+04],eax
ammo_exit:
  popfd
jmp inf_ammo_ret

Alien.exe+1C4CC:
  jmp inf_ammo
  nop
inf_ammo_ret:

[disable]
Alien.exe+1C4CC:
  add eax,[edx+04]
  mov [edx+04],eax
unregistersymbol(*)
dealloc(*)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>10</ID>
      <Description>"G - Gain 100 credits: need to reload inventory to see updated value"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>0</ID>
          <Description>"HP"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>Alien.exe+167C96</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>7</ID>
          <Description>"Pistol Ammo"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>Alien.exe+87CBC</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>9</ID>
          <Description>"Credits"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>Alien.exe+167CDC</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, "1.0"
HP: 2 bytes. Starts as 50. Code shared with enemies
</Comments>
</CheatTable>
