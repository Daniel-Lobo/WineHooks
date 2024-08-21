<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>47</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>30</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
0045493A:
  nop
  nop
  nop
  nop
  nop
  nop

0043E80D:
  nop
  nop
  nop
  nop
  nop
  nop

004520B3:
  nop
  nop
  nop
  nop
  nop
  nop


[disable]
// HP Drain
0045493A:
mov [00B08814],ecx

// Attacks
0043E80D:
mov [00B08814],esi

// Spectral Vampire
004520B3:
mov [00B08814],ecx











</AssemblerScript>
      <Hotkeys>
        <Hotkey>
          <Action>Toggle Activation</Action>
          <Keys>
            <Key>77</Key>
          </Keys>
          <ID>0</ID>
          <ActivateSound>Activate</ActivateSound>
          <DeactivateSound>Deactivate</DeactivateSound>
        </Hotkey>
      </Hotkeys>
    </CheatEntry>
    <CheatEntry>
      <ID>41</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(enemie, 512)
registersymbol(enemie)
label(enemie_demaged)
label(enemie_demaged_ret_point)
//label(reanimation)
//label(reanimation_ret_point)

// stun
enemie:
  db 00 00 00 00
  enemie_demaged:
  push [esi+00000130]
  pop [enemie]
  mov word ptr [esi+00000130],0000
jmp enemie_demaged_ret_point

0041016F:
  jmp enemie_demaged
  nop
  nop
enemie_demaged_ret_point:

// Recover from stun
00413D50:
  ret
  nop
  nop

// reanimation
00414310:
  ret

[disable]
// stun
00410180:
jg 004101CB

// Recover from stun
00413D50:
sub esp,08

// reanimation
00414310:
  sub esp,40
  push ebx
  push ebp
  push esi
  mov esi,[esp+50]
  xor ebx,ebx
  xor ecx,ecx
  mov ebp,[esi+0000014C]
  push edi
  mov [esp+18],ecx
  mov [esp+54],ebx
  mov eax,[ebp+000000D8]
dealloc(enemie)









</AssemblerScript>
      <Hotkeys>
        <Hotkey>
          <Action>Toggle Activation</Action>
          <Keys>
            <Key>77</Key>
          </Keys>
          <ID>0</ID>
          <ActivateSound>Activate</ActivateSound>
          <DeactivateSound>Deactivate</DeactivateSound>
        </Hotkey>
      </Hotkeys>
    </CheatEntry>
    <CheatEntry>
      <ID>42</ID>
      <Description>"Auto - abilities"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(skills, 512)
label(skills_code)
registersymbol(power_up_flag)
registersymbol(shift_flag)
registersymbol(material_flag)
registersymbol(reaver_type_flag)
label(power_up_flag)
label(shift_flag)
label(shift_flag_check)
label(material_flag)
label(reaver_type_flag)
label(skills_read)
label(skills_write)
label(skills_write2)
label(spectral_write)
label(reaver_type_read)
label(reaver_type_write)
label(skills_read_ret_point)
label(skills_write_ret_point)
label(skills_write2_ret_point)
label(spectral_write_ret_point)
label(reaver_type_read_ret_point)
label(reaver_type_write_ret_point)

skills:
  db 00 00 00 00
power_up_flag:
  db 00 00 00 00
shift_flag:
  db 00 00 00 00
material_flag:
  db 00 00 00 00
reaver_type_flag:
  db 00 00 00 00

skills_code:
  push [00C644F4]
  pop [skills]

  skills_read:
  mov eax,[00C644F4]
  mov [00B08820], eax  /* Copy of Abilities */
  mov ecx,[00C644F8]   /* Reaver type       */
  cmp [power_up_flag], 0
  je shift_flag_check
  or eax, 8            /* Soul Reaver       */
  or eax, 4            /* Projectile        */
  mov [00B08820],eax   /* Copy of Abilities */
  shift_flag_check:
  cmp [shift_flag], 0
  je skills_read_ret_point
  or eax, 50           /* Shift/swim        */
  mov [00B08820],eax   /* Copy of Abilities */
jmp skills_read_ret_point

skills_write:
  push [skills]
  pop eax
  mov [00C644F4],eax
jmp skills_write_ret_point

skills_write2:
  mov [material_flag], 1
  cmp [power_up_flag], 0
  jne skills_write2_ret_point
  mov [00C644F8],00000800        /* Skills write    */
  mov [00C644F4],eax
jmp skills_write2_ret_point

spectral_write:
  mov [material_flag], 0
  cmp [power_up_flag], 0
  jne spectral_write_ret_point
  mov [00C644F8],00000400        /* Spectral write  */
  mov [00C644F4],eax
jmp spectral_write_ret_point

reaver_type_read:
  mov edx,[00C644F8]
  cmp [power_up_flag], 0
  je reaver_type_read_ret_point
  cmp [material_flag], 0
  je reaver_type_read_ret_point
  mov [reaver_type_flag], 1
  or edx, 8000                  /* 4000 for ariel, 1000 for sunlight */
jmp reaver_type_read_ret_point

reaver_type_write:
  cmp [reaver_type_flag], 1
  mov [reaver_type_flag], 0
  je reaver_type_write_ret_point
  mov [00C644F8],ebp
jmp reaver_type_write_ret_point

00455F63:
  jmp skills_code
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
skills_read_ret_point:

00455F8D:
  jmp skills_write
skills_write_ret_point:

0045583C:
  jmp skills_write2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
skills_write2_ret_point:

00455861:
  jmp spectral_write
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
spectral_write_ret_point:

004556F0:
  jmp reaver_type_read
  nop
reaver_type_read_ret_point:

004559C7:
  jmp reaver_type_write
  nop
reaver_type_write_ret_point:

[disable]
00455F63:
mov eax,[00C644F4]       /* Skills read         */
mov ecx,[00C644F8]       /* Reaver type read    */
mov [00B08820],eax

00455F8D:
mov [00C644F4],eax       /* Skills write        */

0045583C:
mov [00C644F8],00000800  /* Skills write        */
mov [00C644F4],eax       /* Reaver type write   */

00455861:
mov [00C644F8],00000400  /* Spectral write      */
mov [00C644F4],eax       /* Spectral type write */

004556F0:
mov edx,[00C644F8]       /* Reaver type raad 2  */

004559C7:
mov [00C644F8],ebp       /* Reaver type write 2 */

dealloc(skills, 512)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>45</ID>
          <Description>"U - power UP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
power_up_flag:
db 00 00 00 01

[disable]
power_up_flag:
db 00 00 00 00



</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>46</ID>
          <Description>"M - shift to Material anywhere"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
shift_flag:
db 00 00 00 01

[disable]
shift_flag:
db 00 00 00 00



</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>43</ID>
      <Description>"P - Projectile"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(skills, 512)
label(projectile_test_ret_point)

skills:
  push [00B08820]
  or [00B08820], 04
  test byte ptr [00B08820],04
  pop [00B08820]
jmp projectile_test_ret_point

0044443D:
  jmp skills
  nop
  nop
projectile_test_ret_point:

[disable]
0044443D:
test byte ptr [00B08820],04
dealloc(skills, 512)








</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>24</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>14</ID>
          <Description>"Health"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>00B08814</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>15</ID>
          <Description>"Num health upgrades"</Description>
          <VariableType>Byte</VariableType>
          <Address>00B08810</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>16</ID>
          <Description>"Glypth energy"</Description>
          <VariableType>Byte</VariableType>
          <Address>00B08828</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>17</ID>
          <Description>"Max Gliph energy"</Description>
          <VariableType>Byte</VariableType>
          <Address>00B0882A</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>18</ID>
          <Description>"Abylities"</Description>
          <ShowAsHex>1</ShowAsHex>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>00C644F4</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>19</ID>
          <Description>"Glyphs"</Description>
          <VariableType>2 Bytes</VariableType>
          <Address>00C644F6</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>20</ID>
          <Description>"Reaver type"</Description>
          <ShowAsHex>1</ShowAsHex>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>00C644F8</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>44</ID>
          <Description>"Copy of abilities"</Description>
          <ShowAsHex>1</ShowAsHex>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>b08820</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>23</ID>
          <Description>"Reaver without max health"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
00454798:
jmp 00454D10
nop

00454D68:
jmp 00454D73
nop

[disable]
00454798:
je 00454D10

00454D68:
je 00454D73



</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: 1.02, Retail, GOG, Steam or Wrace: https://steamcommunity.com/app/224920/discussions/0/2837788120352512948 
</Comments>
</CheatTable>
