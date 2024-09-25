<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>23</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>11</ID>
      <Description>"Auto - Flags"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(inf_hp_flag, 512)
registersymbol(inf_hp_flag)
alloc(easy_kill_flag, 512)
registersymbol(easy_kill_flag)

inf_hp_flag:
db 00 00 00 00

easy_kill_flag:
db 00 00 00 00

[disable]
dealloc(inf_hp_flag, 512)
unregistersymbol(inf_hp_flag)
dealloc(easy_kill_flag, 512)
unregistersymbol(easy_kill_flag)


</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>8</ID>
          <Description>"Auto - Player"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
label(player_hp)
registersymbol(player_hp)
alloc(player_hp_acess, 512)
label(player_hp_ret_point)

player_hp_acess:
player_hp:
  db 00 00 00 00
  push eax,
  mov eax, player_hp
  mov [eax], edx
  pop eax
  fld dword ptr [edx+000001AC]
jmp player_hp_ret_point

GameDRMFree.exe+28E82B:
  jmp player_hp_acess+4
  nop
player_hp_ret_point:

[disable]
GameDRMFree.exe+28E82B:
fld dword ptr [edx+000001AC]
unregistersymbol(player_hp)
dealloc(player_hp_acess, 512)



</AssemblerScript>
          <CheatEntries>
            <CheatEntry>
              <ID>10</ID>
              <Description>"Auto - Damage"</Description>
              <VariableType>Auto Assembler Script</VariableType>
              <AssemblerScript>[enable]
alloc(damage, 512)
label(damage_ret_point)
label(normal_damage)
label(player)
label(enemy)

damage:
  lea esi,[edi+000001AC]
  push ecx
  push esi
  cmp edi, [player_hp]     // check if player
  jne enemy

player:
  cmp [inf_hp_flag], 00    // check inf hp flag
  je normal_damage
jmp damage_ret_point

enemy:
  cmp [easy_kill_flag], 00 // check easy kill flag
  je normal_damage
  push ebx                 // check enemy hp value
  mov ebx, (float)1.0
  cmp ebx, [edi+000001AC]
  pop ebx
  je normal_damage
  mov [esi],(float)1.0
jmp damage_ret_point

normal_damage:
  mov [esi],eax
jmp damage_ret_point

GameDRMFree.exe+256E30:
  jmp damage
  nop
  nop
  nop
  nop
  nop
damage_ret_point:

[disable]
GameDRMFree.exe+256E30:
lea esi,[edi+000001AC]
push ecx
push esi
mov [esi], eax
dealloc(damage)

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
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>2</ID>
      <Description>"Z - inf stamina"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
GameDRMFree.exe+2902B7:
nop
nop
nop
nop
nop
nop

[disable]
GameDRMFree.exe+2902B7:
fst dword ptr [ecx+00000148]

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>17</ID>
      <Description>"I - easy Intenso"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
GameDRMFree.exe+293146:
fld dword ptr [esi-10]  // max intenso

[disable]
GameDRMFree.exe+293146:
fld dword ptr [ebp-08]




</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>21</ID>
      <Description>"G - gain Gold"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>22</ID>
      <Description>"C - gain silver Coins"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>20</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>15</ID>
          <Description>"Max Intenso"</Description>
          <VariableType>Float</VariableType>
          <Address>00915F94</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>14</ID>
          <Description>"Intenso"</Description>
          <VariableType>Float</VariableType>
          <Address>GameDRMFree.exe+515FA4</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>16</ID>
          <Description>"inf Intenso"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
easy_kill_flag:
nop
nop

[disable]
GameDRMFree.exe+293492:
fsubp st(1),st(0)



</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>18</ID>
          <Description>"Gold"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>GameDRMFree.exe+5161D4</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>19</ID>
          <Description>"Silver Coins"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>GameDRMFree.exe+5154CC</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, Super turbo championship edition, 2.0.0.1
HP:          4 bytes. Full HP Starts at 80
Gold\Silver: 4 bytes. Same value as seen in the HUD or map screen 
Stamina:     Float.   1 per icon in the HUD
Intenso:     Float.   Full intenso starts at 70     
</Comments>
</CheatTable>
