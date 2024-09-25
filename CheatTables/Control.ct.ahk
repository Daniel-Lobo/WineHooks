<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>7</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>3</ID>
      <Description>"Auto - DX11 Activate"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(loose_source)
registersymbol(health_read)
registersymbol(real_damage)
aobScanModule(loose_source, Control_DX11.exe, 48 2B D0 48 8B 41 18 48 C1 E8 3E 48 89 51 40) //death
aobScanModule(health_read, Control_DX11.exe, 49 8B 46 48 0F 57 FF 48 85 C0 74 05 F3 0F 10 78 40)
aobScanModule(real_damage, Control_DX11.exe,F3 0F 11 0A 4C 8B 00 4D 85 C0 74 ** 49 8B C8 E8 ** ** ** ** 48 8B 4B 58)


[disable]
unregistersymbol(loose_source)
unregistersymbol(health_read)
unregistersymbol(real_damage)


</AssemblerScript>
      <Hotkeys>
        <Hotkey>
          <Action>Activate</Action>
          <Keys>
            <Key>122</Key>
          </Keys>
          <ID>0</ID>
          <ActivateSound>Activate</ActivateSound>
          <DeactivateSound>Deactivate</DeactivateSound>
        </Hotkey>
      </Hotkeys>
    </CheatEntry>
    <CheatEntry>
      <ID>2</ID>
      <Description>"Auto - DX12 Activate"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(loose_source)
registersymbol(health_read)
registersymbol(real_damage)
aobScanModule(loose_source, Control_DX11.exe, 48 2B D0 48 8B 41 18 48 C1 E8 3E 48 89 51 40) //death
aobScanModule(health_read, Control_DX11.exe, 49 8B 46 48 0F 57 FF 48 85 C0 74 05 F3 0F 10 78 40)
aobScanModule(real_damage, Control_DX11.exe,F3 0F 11 0A 4C 8B 00 4D 85 C0 74 ** 49 8B C8 E8 ** ** ** ** 48 8B 4B 58)


[disable]
unregistersymbol(loose_source)
unregistersymbol(health_read)
unregistersymbol(real_damage)

</AssemblerScript>
      <Hotkeys>
        <Hotkey>
          <Action>Activate</Action>
          <Keys>
            <Key>123</Key>
          </Keys>
          <ID>0</ID>
          <ActivateSound>Activate</ActivateSound>
          <DeactivateSound>Deactivate</DeactivateSound>
        </Hotkey>
      </Hotkeys>
    </CheatEntry>
    <CheatEntry>
      <ID>12</ID>
      <Description>"Auto - Player"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
//registersymbol(player)
registersymbol(inf_hp_flag)
registersymbol(easy_kill_flag)
globalalloc(player, 1024)
label(inf_hp_flag)
label(easy_kill_flag)
label(player_code)
label(player_code_1)
label(health_read_ret_point)

player:
  db 00 00 00 00 00 00 00 00
inf_hp_flag:
  db 00 00 00 00
easy_kill_flag:
  db 00 00 00 00
player_code:
  mov rax,[r14+48]
  xorps xmm7,xmm7
  test rax,rax
  je player_code_1
  movss xmm7,[rax+40]
  push rax
  pop [player]
  add [player], 40
  player_code_1:
  mov r12d,00000003
jmp health_read_ret_point

health_read:
  jmp player_code
  db 90 90 90 90 90 90 90 90 90
health_read_ret_point:

[disable]
health_read:
  mov rax,[r14+48]
  xorps xmm7,xmm7
  test rax,rax
  db 74 05 //je 5 bytes
  movss xmm7,[rax+40]
  mov r12d,00000003

dealloc(player)
unregistersymbol(player)
unregistersymbol(inf_hp_flag)
unregistersymbol(easy_kill_flag)



</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>25</ID>
          <Description>"Auto - Damage"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
alloc(damage_trampoline, 16, real_damage)
alloc(damage_newcode, 512)
label(damage_oldcode)
label(damage_retpoint)
label(inf_hp)
label(enemy)

damage_newcode:
  push rax
  mov rax, [player]
  cmp rax, 00
  pop rax
  je damage_oldcode

  push rax
  mov rax, [player]
  cmp rdx, rax
  pop rax
  je inf_hp
  jmp enemy
jmp damage_oldcode

inf_hp:
  push rax
  mov rax, [inf_hp_flag]
  cmp rax, 00
  pop rax
  je damage_oldcode
  movss [rdx],xmm1
  mov r8,[rax]
  mov [rdx], (float)1.0
  mov [rcx+64], (float)1.0
jmp damage_retpoint

enemy:
  push rax
  mov rax, [easy_kill_flag]
  cmp rax, 00
  pop rax
  movss [rdx],xmm1
  mov r8,[rax]
  mov [rdx], (float)0.0
  mov [rcx+64], (float)0.0
jmp damage_retpoint

damage_oldcode:
  movss [rdx],xmm1
  mov r8,[rax]
jmp damage_retpoint

damage_trampoline:
jmp damage_newcode

real_damage:
  jmp damage_trampoline
  nop
  nop
damage_retpoint:

[disable]
real_damage:
  mov rax,[Control_DX11.exe+D9EFA0]
  movss [rdx],xmm1
  mov r8,[rax]
dealloc(damage_newcode)
dealloc(damage_trampoline)
</AssemblerScript>
          <CheatEntries>
            <CheatEntry>
              <ID>16</ID>
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
            <CheatEntry>
              <ID>15</ID>
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
          </CheatEntries>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>1</ID>
      <Description>"Auto - Disable screen space AA"</Description>
      <VariableType>Byte</VariableType>
      <Address>rend::RenderOptions::ScreenSpaceAntialiasing</Address>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols>
    <SymbolEntry>
      <Name>player</Name>
      <Address>18F86420000</Address>
    </SymbolEntry>
  </UserdefinedSymbols>
  <Comments>Version: GOG, Update 2
HP: Float. Full HP is 1.0 regardless of upgrades. Code shared with enemies
</Comments>
</CheatTable>
