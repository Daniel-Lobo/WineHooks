<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>10</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(player, 128)
label(player_code)
label(player_code_retpoint)
label(hit)
label(hit_retpoint)
label(inf_hp_flag)
label(ez_kills_flag)
registersymbol(inf_hp_flag)
registersymbol(ez_kills_flag)

player:
  db 00 00 00 00
inf_hp_flag:
  db 00 00 00 00
ez_kills_flag:
  db 00 00 00 00
player_code:
  push esi
  pop [player]
  add [player],000002A0
  fld dword ptr [esi+000002A0]
  cmp [inf_hp_flag], 0
  je player_code_retpoint
  mov [esi+000002A0], (float)100
jmp player_code_retpoint

hit:
  fstp dword ptr [esi+0000024C]
  push esi
  add esi,0000024C
  cmp esi, [player]
  pop esi
  je hit_retpoint
  cmp [ez_kills_flag], 0
  je hit_retpoint
  mov [esi+0000024C], (float)0
jmp hit_retpoint

object.lto+1CDC45:
  jmp player_code
  nop
player_code_retpoint:

object.lto+193C63:
  jmp hit
  nop
hit_retpoint:

[disable]
object.lto+1CDC45:
  fld dword ptr [esi+000002A0]
object.lto+193C63:
  fstp dword ptr [esi+0000024C]
dealloc(*)




</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>8</ID>
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
          <ID>9</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
ez_kills_flag:
  db 00 00 00 01

[disable]
ez_kills_flag:
  db 00 00 00 00









</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>7</ID>
      <Description>"L - inf flashLight, flares and night vision"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(flashlight, 128)
label(flashlight_retpoint)
LABEL(NIGHTVISION)
LABEL(NIGHTVISION_RET)
label(cloak)
label(cloak_ret)
label(cloak_read)

flashlight:
  fstp dword ptr [esi+000017DC]
  mov [esi+000017DC], (float)255
jmp flashlight_retpoint

NIGHTVISION:
  fstp dword ptr [esi+000017DC]
  mov [esi+000017DC], (float)255
jmp NIGHTVISION_RET

cloak:
   mov [eax],36
   mov eax,[esi+18]
jmp cloak_ret

cloak_read:
  mov eax,[eax]
  pop esi
  mov [ecx+eax*4], (float)54
  mov eax,[ecx+eax*4]
ret

object.lto+15A188:
  nop
  nop

object.lto+17E80B:  //flashlight
  jmp flashlight
  nop
flashlight_retpoint:

object.lto+17E8CC:
  jmp NIGHTVISION
  nop
NIGHTVISION_RET:

object.lto+15A1E8:
  //jmp cloak
cloak_ret:

cshell.dll+9D30E:
  //jmp cloak_read
  nop

[disable]
object.lto+15A188:
  mov [ecx],edi

object.lto+17E80B:
  fstp dword ptr [esi+000017DC]

object.lto+17E8CC:
  fstp dword ptr [esi+000017DC]

object.lto+15A1E8:
  mov [eax],ecx
  mov eax,[esi+18]

cshell.dll+9D30E:
  mov eax,[eax]
  pop esi
  mov eax,[ecx+eax*4]













</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>17</ID>
      <Description>"Left overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>15</ID>
          <Description>"P - inf Predator energy"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
aobscanmodule(cloak, object.lto, 8B 04 88 C2 04 00)
registersymbol(cloak)
alloc(inf_pred_energy, 128)
label(is_energy)
inf_pred_energy:
  cmp ecx, 04
  je is_energy
  mov eax,[eax+ecx*4]
ret 0004
  is_energy:
  mov [eax+ecx*4], (float)54
  mov eax,[eax+ecx*4]
ret 0004

cloak:
  jmp inf_pred_energy

[disable]
cloak:
  mov eax,[eax+ecx*4]
ret 0004
dealloc(inf_pred_energy)
unregistersymbol(cloak)










</AssemblerScript>
          <CheatEntries>
            <CheatEntry>
              <ID>16</ID>
              <Description>"Shoulder cannon"</Description>
              <VariableType>Auto Assembler Script</VariableType>
              <AssemblerScript>[enable]
aobscanmodule(s_cannon, cshell.dll, 29 08 5F 5E)
registersymbol(s_cannon)
s_cannon:
  nop
  nop

[disable]
s_cannon:
  sub [eax],ecx
unregistersymbol(s_cannon)












</AssemblerScript>
            </CheatEntry>
          </CheatEntries>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.0.96
</Comments>
</CheatTable>
