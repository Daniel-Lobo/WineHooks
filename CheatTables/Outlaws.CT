<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>2</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 128)
label(hit_code)
label(hit_retadd)
label(enemy)
label(player)
label(player_code)
label(player_retadd)
label(hp_flag)
label(kill_flag)
registersymbol(hp_flag)
registersymbol(kill_flag)

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
player:
  db 00 00 00 00
player_code:
  push edi
  pop [player]
  mov eax,[edi+000000A0]
  cmp [hp_flag], 00
  je player_retadd
  mov [edi+20], (float)10
jmp player_retadd

hit_code:
  mov [olwin.exe+1D58C8],ecx
  cmp esi [player]
  jne enemy
  cmp [hp_flag], 00
  je hit_retadd
  mov edx, (float)0
jmp hit_retadd

enemy:
  mov [olwin.exe+1D58C8],ecx
  cmp [kill_flag], 00
  je hit_retadd
  mov edx, (float)0
jmp hit_retadd

olwin.exe+40EB6:
  jmp player_code
  nop
player_retadd:

olwin.exe+40BD2:
  jmp hit_code
  nop
hit_retadd:

[disable]
olwin.exe+40EB6:
  mov eax,[edi+000000A0]
olwin.exe+40BD2:
  mov [olwin.exe+1D58C8],ecx

dealloc(*)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>3</ID>
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
          <ID>4</ID>
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
      <ID>6</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
olwin.exe+7149B:
  db 90 90 90 90 90 90

[disable]
olwin.exe+7149B:
  dec [ecx+00000204]


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>8</ID>
      <Description>"Z - inf Stamina"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
olwin.exe+454B9:
  db 90 90 90


[disable]
olwin.exe+454B9:
  mov [edi+24],eax



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>11</ID>
      <Description>"O - inf Oil"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
olwin.exe+41E17:
  db 90 90


[disable]
olwin.exe+41E17:
  mov [edx],eax




</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, 2.1.0.1
</Comments>
</CheatTable>
