<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>26</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>5</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
{$lua}
mono_compile_method(mono_findMethod('Assembly-CSharp', 'SeinHealthController', 'TakeDamage'))

{$asm}
SeinHealthController:TakeDamage+3e:
fstp st(0)
nop

SeinHealthController:TakeDamage+1f:
fstp st(0)
nop

[disable]
SeinHealthController:TakeDamage+3e:
fstp dword ptr [esi+1C]

SeinHealthController:TakeDamage+1f:
fstp dword ptr [esi+1C]


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>14</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
{$lua}
mono_compile_method(mono_findMethod('Assembly-CSharp', 'DamageReciever', 'OnRecieveDamage'))

{$asm}
alloc(ez_kill, 512)
label(ez_kill_ret_point)

ez_kill:
  fsubp st(1),st(0)
  fstp dword ptr [esi+30]
  mov [esi+30], (float)0.0
jmp ez_kill_ret_point

DamageReciever:OnRecieveDamage+a3:
  jmp ez_kill
ez_kill_ret_point:

[disable]
DamageReciever:OnRecieveDamage+a3:
fsubp st(1),st(0)
fstp dword ptr [esi+30]
dealloc(ez_kill)







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>12</ID>
      <Description>"S - inf Saves"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
{$lua}
mono_compile_method(mono_findMethod('Assembly-CSharp', 'SeinEnergy', 'Spend'))

{$asm}
SeinEnergy:Spend+12:
fstp st(0)
nop

[disable]
SeinEnergy:Spend+12:
fstp dword ptr [edi+20]



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>24</ID>
      <Description>"P - gain skill Point"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
{$lua}
mono_compile_method(mono_findMethod('Assembly-CSharp', 'SeinSkillPointsProvider', 'GetFloatValue'))

{$asm}
alloc(get_skill_point, 512)
label(get_skill_point_code)
label(get_skill_point_continue)
label(get_skill_point_ret_point)

get_skill_point:
  db 00 00 00 01
get_skill_point_code:
  mov eax,[eax+38]
  cmp [get_skill_point], 00
  mov [get_skill_point], 00
  je get_skill_point_continue
  add [eax+24], 1
  get_skill_point_continue:
  mov eax,[eax+24]
jmp get_skill_point_ret_point

SeinSkillPointsProvider:GetFloatValue+c:
  jmp get_skill_point_code
  nop
get_skill_point_ret_point:

[disable]
SeinSkillPointsProvider:GetFloatValue+c:
mov eax,[eax+38]
mov eax,[eax+24]
dealloc(get_skill_point)







</AssemblerScript>
      <Hotkeys>
        <Hotkey>
          <Action>Toggle Activation</Action>
          <Keys>
            <Key>85</Key>
          </Keys>
          <ID>0</ID>
          <ActivateSound>Activate</ActivateSound>
          <DeactivateSound>Deactivate</DeactivateSound>
        </Hotkey>
      </Hotkeys>
    </CheatEntry>
    <CheatEntry>
      <ID>25</ID>
      <Description>"Left  overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>10</ID>
          <Description>"Free skill Upgrades"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[ENABLE]
{$lua}
mono_compile_method(mono_findMethod('Assembly-CSharp', 'SkillTreeManager', 'OnMenuItemPressed'))

{$asm}
SkillTreeManager:OnMenuItemPressed+16f:
nop
nop
nop


[disable]
SkillTreeManager:OnMenuItemPressed+16f:
mov [eax+24],ecx





</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, Definitive Edition, 2.0.0.2
HP:           Float.   4 per icon in the HUD
Enemy HP:     Float.   Aprox. 3 per hit need to kill, 'jumping monkey' enemy HP is 13 on normal
Saves:        Float.   1 per icon in the HUD
Skill Points: 4 bytes. Same as the value seen in the HUD
</Comments>
</CheatTable>
