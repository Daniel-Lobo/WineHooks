<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>1</ID>
      <Description>"Auto - Player"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(player, 1024)
label(player_code)
label(player_ret)
label(player_fatige)
label(player_hp)
label(hp_flag)
label(fatige_flag)
label(player_og)
registersymbol(hp_flag)
registersymbol(fatige_flag)

player:
  db 00 00 00 00
hp_flag:
  db 00 00 00 00
fatige_flag:
  db 00 00 00 00

player_code:
  mov edx,[esi+00000350]
  cmp eax, 4
  je player_fatige
  cmp eax, 3
  je player_hp
  mov [edx+eax*8+04],edi
jmp player_ret

player_fatige:
  cmp [fatige_flag], 00
  je player_og
  cmp [edx+eax*8+04],edi
  jb player_og
jmp player_ret

player_hp:
  mov [player], edx
  add [player], 1c
  cmp [hp_flag], 00
  je player_og
  cmp [edx+eax*8+04],edi
  jb player_og
jmp player_ret

jmp player_ret

player_og:
  mov [edx+eax*8+04],edi
jmp player_ret

revenant.exe+11AE01:
  jmp player_code
  nop 5
player_ret:

[disable]
revenant.exe+11AE01:
  mov edx,[esi+00000350]
  mov [edx+eax*8+04],edi
dealloc(*)
unregistersymbol(*)



</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>11</ID>
          <Description>"N - No fatigue"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
fatige_flag:
  db 01 00 00 00

[disable]
fatige_flag:
  db 00 00 00 00



</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>10</ID>
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
      <ID>4</ID>
      <Description>"K - easy kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 128)
label(hit_ret)
label(kill)

hit:
  mov edx,[esp+08]
  cmp eax, 03
  je kill
  mov [ecx+eax*4],edx
jmp hit_ret

kill:
  mov [ecx+eax*4],00
jmp hit_ret

revenant.exe+D74C5:
  jmp hit
  nop
  nop
hit_ret:

[disable]
revenant.exe+D74C5:
  mov edx,[esp+08]
  mov [ecx+eax*4],edx
dealloc(*)
unregistersymbol(*)



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>5</ID>
      <Description>"Auto - Player stats"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(player_stats, 1024)
registersymbol(player_stats)
label(player_stats_code)
label(player_stats_ret)

player_stats:
  db 00 00 00 00
player_stats_code:
  cmp eax, 03
  mov eax,[ecx+eax*8+04]
  jne player_stats_ret
  mov [player_stats], ecx
  add [player_stats], 1c
player_stats_ret:
  ret 0004

revenant.exe+11AE45:
  jmp player_stats_code
  nop
  nop

[disable]
revenant.exe+11AE45:
  mov eax,[ecx+eax*8+04]
  ret 0004
dealloc(*)
unregistersymbol(*)



</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>12</ID>
          <Description>"L - Gain level"</Description>
          <GroupHeader>1</GroupHeader>
        </CheatEntry>
        <CheatEntry>
          <ID>7</ID>
          <Description>"HP"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>4 Bytes</VariableType>
          <Address>[player_stats]</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>6</ID>
          <Description>"MP"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>4 Bytes</VariableType>
          <Address>[player_stats]+10</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>9</ID>
          <Description>"Level"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>4 Bytes</VariableType>
          <Address>[player_stats]+70</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>16</ID>
      <Description>"G  - gain Gold - use while on shop screen, move mouse to update value"</Description>
      <Options moAlwaysHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>14</ID>
          <Description>"Auto - Gold"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
alloc(gold, 1024)
registersymbol(gold)
label(gold_code)

gold:
  db 00 00 00 00
gold_code:
  movsx edx,word ptr [ecx+000000A8]
  mov eax,[esp+04]
  cmp eax,edx
  db 73 0c
  mov ecx,[ecx+000000AC]
  mov [gold], ecx
  add [gold], eax
  add [gold], eax
  add [gold], eax
  add [gold], eax
  mov eax,[ecx+eax*4]
  ret 0004
  xor eax,eax
  ret 0004

revenant.exe+116929:
  call gold_code
  nop

[disable]
revenant.exe+116929:
  call dword ptr [eax+000000DC]

dealloc(*)
unregistersymbol(*)



</AssemblerScript>
          <CheatEntries>
            <CheatEntry>
              <ID>15</ID>
              <Description>"Gold"</Description>
              <ShowAsSigned>0</ShowAsSigned>
              <VariableType>4 Bytes</VariableType>
              <Address>[gold]</Address>
            </CheatEntry>
          </CheatEntries>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.22
All values: 4 bytes
</Comments>
</CheatTable>
