<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>13</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>22</ID>
      <Description>"Quick Saving\Loading: Click  Table Help" for instructions"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>8</ID>
      <Description>"B - inf Bullets"</Description>
      <Options moAlwaysHideChildren="1"/>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
AvP_Classic.exe+FF508:
  nop
  nop
  nop

[disable]
AvP_Classic.exe+FF508:
  dec [esi+14]



</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>21</ID>
          <Description>"Spear gun"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>4 Bytes</VariableType>
          <Address>AvP_Classic.exe+47E148</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>11</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(new_mem, 512)
label(player1)
label(player2)
label(enemy1)
label(enemy2)
label(hit1)
label(hit2)
label(hit1_retpoint)
label(hit2_retpoint)
label(code1)
label(code2)
label(inf_hp_flag)
label(ez_kill_flag)
registersymbol(inf_hp_flag)
registersymbol(ez_kill_flag)

new_mem:
inf_hp_flag:
  db 00 00 00 00
ez_kill_flag:
  db 00 00 00 00

hit1:
  //jmp player1
  cmp ebx, 20
  je player1
  cmp EBX, 31
  je player1
jmp enemy1

player1:
  cmp [inf_hp_flag], 00
  je code1
  mov eax,[edi]
  cmp eax,ecx
  jnl AvP_Classic.exe+F6EF2
jmp AvP_Classic.exe+F6Ee8

enemy1:
  cmp [ez_kill_flag], 00
  je code1
  mov [edi], 00
  mov eax,[edi]
  mov ecx,eax
  cmp eax,ecx
  jnl AvP_Classic.exe+F6EF2
jmp AvP_Classic.exe+F6Ee8

code1:
  mov eax,[edi]
  cmp eax,ecx
  jnl AvP_Classic.exe+F6EF0
jmp AvP_Classic.exe+F6Ee8

hit2:
  //jmp player2
  cmp EBX, 20
  je player2
  cmp EBX, 31
  je player2
jmp enemy2

player2:
  cmp [inf_hp_flag], 00
  je code2
  mov eax,[edi]
  cmp eax,esi
  jnl AvP_Classic.exe+F6D5a
jmp AvP_Classic.exe+F6D50

enemy2:
  cmp [ez_kill_flag], 00
  je code2
  mov [edi], 00
  mov eax,[edi]
  mov esi,eax
  cmp eax,esi
  jnl AvP_Classic.exe+F6D5a
jmp AvP_Classic.exe+F6D50

code2:
  mov eax,[edi]
  cmp eax,ecx
  jnl AvP_Classic.exe+F6D58
jmp AvP_Classic.exe+F6D50

AvP_Classic.exe+F6EE2:
  jmp hit1
  nop
hit1_retpoint:

AvP_Classic.exe+F6D4A:
  jmp hit2
  nop
hit2_retpoint:

[disable]
AvP_Classic.exe+F6D4A:
  mov eax,[edi]
  cmp eax,esi
  jnl AvP_Classic.exe+F6D58

AvP_Classic.exe+F6EE2:
  mov eax,[edi]
  cmp eax,ecx
  jnl AvP_Classic.exe+F6EF0
dealloc(*)




</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>14</ID>
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
          <ID>15</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
ez_kill_flag:
  db 00 00 00 01

[disable]
ez_kill_flag:
  db 00 00 00 00




</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>17</ID>
      <Description>"U - Unlimited saves"</Description>
      <Options moAlwaysHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>16</ID>
          <Description>"Saves"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>AvP_Classic.exe+4C06E8</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, 2.2.0.26
</Comments>
</CheatTable>
