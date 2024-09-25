<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>22</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>13</ID>
      <Description>"S - Speed Multiplier"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(speedx, 512)
label(speedx_ret_add)
registersymbol(speedx)

speedx:
db 00 00 00 00
mov eax, speedx
mov [eax], (float)1.0
fld, [esi+000000AC]
fld, [eax]
fmul, ST(0), ST(1)
fstp, [eax]
movsx eax,word ptr [eax]
fcomp st(0)
jmp speedx_ret_add

0044235C:
jmp speedx+4
nop
nop
speedx_ret_add:

[disable]
0044235C:
movsx eax,word ptr [esi+000000AC]
dealloc(speedx)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>15</ID>
          <Description>"x2"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
speedx+9:
mov [eax], (float)2.0
[disable]




</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>14</ID>
          <Description>"x3"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
speedx+9:
mov [eax], (float)3.0
[disable]



</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>11</ID>
          <Description>"Max"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
alloc(max_speed_checks, 512)
label(max_speed_ret_add)
label(max_speed)
label(normal_speed)

// offset between chars 1c8

max_speed_checks:
mov eax, esi
add eax, 000000AC

/*  Check if its maya's speed add */
cmp eax, 004DE734
je max_speed

/*  Check if its Grubb's speed add - untested */
cmp eax, 004DE8fc
je max_speed

/*  Check if its runner's speed add */
cmp eax, 004DEAC4
je max_speed

/*  Check if its corgan's speed add */
cmp eax, 004DEC8C
je max_speed

/*  Check if its led's speed add untested */
cmp eax, 004DEe54
je max_speed

/*  Check if its Selina's speed add untested */
cmp eax, 004DF01c
je max_speed

/*  Check if its Araym's speed add untested */
cmp eax, 004DF1e4
je max_speed

/*  Check if its Badu's speed add untested */
cmp eax, 004DF3ac
je max_speed

/*  Check if its lobos's speed add untested */
cmp eax, 004DF574
je max_speed

/*  Normal speed */
normal_speed:
movsx eax,word ptr [esi+000000AC]
jmp max_speed_ret_add

/*  Max speed */
max_speed:
mov eax, 7fff
jmp max_speed_ret_add

0044235C:
jmp max_speed_checks
nop
nop
max_speed_ret_add:

[disable]
0044235C:
movsx eax,word ptr [esi+000000AC]
dealloc(max_speed_checks)

</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>16</ID>
      <Description>"Auto - 0042d500"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(damage, 512)
registersymbol(inf_hp_flag)
registersymbol(easy_kill_flag)
label(inf_hp_flag)
label(easy_kill_flag)
label(damage_newcode)
label(damage_code)
label(damage_ret_add)
label(player)
label(enemy)

// offset between chars 1c8

damage:
inf_hp_flag:
  db 00 00 00 00
easy_kill_flag:
  db 00 00 00 00

damage_newcode:
  /* Maya */
  cmp ebp, 4de688
  je player

  /* Grubb */
  cmp ebp, 4de850
  je player

  /* Runner */
  cmp ebp, 4DEA18
  je player

  /* Corgan */
  cmp ebp, 4DEBE0
  je player

  /* Led    */
  cmp ebp, 4DEDA8
  je player

  /* Selina  */
  cmp ebp, 4DEF70
  je player

  /* Araym   */
  cmp ebp, 4DF138
  je player

  /* Badu - untested */
  cmp ebp, 4DF300
  je player

  /* Lobo - untested */
  cmp ebp, 4DF4c8
  je player

enemy:
  cmp [easy_kill_flag], 00
  je damage_code
  mov [ebp+0000012E],00
jmp damage_ret_add

player:
  cmp [inf_hp_flag], 00
  je damage_code
jmp damage_ret_add

damage_code:
  sub [ebp+0000012E],ebx
jmp damage_ret_add

0042d500:
  jmp damage
  nop
damage_ret_add:

[disable]
0042d500:
  sub [ebp+0000012E],ebx
dealloc(one_hit, 512)


</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>26</ID>
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
          <ID>27</ID>
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
    <CheatEntry>
      <ID>9</ID>
      <Description>"Left overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>3</ID>
          <Description>"Maya Power"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>septerra.exe+DE730</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>4</ID>
          <Description>"Maya Speed"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>004DE734</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>10</ID>
          <Description>"Runner Speed"</Description>
          <VariableType>2 Bytes</VariableType>
          <Address>septerra.exe+DEAC4</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>12</ID>
          <Description>"Corgan speed"</Description>
          <VariableType>2 Bytes</VariableType>
          <Address>septerra.exe+DEC8C</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>5</ID>
          <Description>"Maya max speed"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
alloc(max_speed, 512)
label(max_speed_ret_add)

max_speed:
mov eax, esi
add eax, 000000AC
cmp eax, 004DE734
movsx eax,word ptr [esi+000000AC]
jne max_speed_ret_add
mov eax, ffff
jmp max_speed_ret_add

0044235C:
jmp max_speed
nop
nop
max_speed_ret_add:

[disable]
0044235C:
movsx eax,word ptr [esi+000000AC]
dealloc(max_speed)

</AssemblerScript>
          <Hotkeys>
            <Hotkey>
              <Action>Toggle Activation</Action>
              <Keys/>
              <ID>0</ID>
              <ActivateSound>Activate</ActivateSound>
              <DeactivateSound>Deactivate</DeactivateSound>
            </Hotkey>
          </Hotkeys>
        </CheatEntry>
        <CheatEntry>
          <ID>6</ID>
          <Description>"Maya max power"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
alloc(max_power, 512)
label(max_power_ret_add)

max_power:
mov eax, esi
add eax, 000000A8
cmp eax, 004DE730
movsx eax,word ptr [esi+000000A8]
jne max_power_ret_add
mov eax, ffff
jmp max_power_ret_add

0040240F:
jmp max_power
nop
nop
max_power_ret_add:

[disable]
0040240F:
movsx eax,word ptr [esi+000000A8]
dealloc(max_power)

</AssemblerScript>
          <Hotkeys>
            <Hotkey>
              <Action>Toggle Activation</Action>
              <Keys/>
              <ID>0</ID>
              <ActivateSound>Activate</ActivateSound>
              <DeactivateSound>Activate</DeactivateSound>
            </Hotkey>
          </Hotkeys>
        </CheatEntry>
        <CheatEntry>
          <ID>17</ID>
          <Description>"Maya HP"</Description>
          <VariableType>2 Bytes</VariableType>
          <Address>septerra.exe+DE7B6</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>18</ID>
          <Description>"Grubb HP"</Description>
          <VariableType>2 Bytes</VariableType>
          <Address>septerra.exe+DE97E</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>19</ID>
          <Description>"Corgan HP"</Description>
          <VariableType>2 Bytes</VariableType>
          <Address>septerra.exe+DED0E</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>20</ID>
          <Description>"Runner HP"</Description>
          <VariableType>2 Bytes</VariableType>
          <Address>septerra.exe+DEB46</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>23</ID>
          <Description>"Led HP"</Description>
          <VariableType>2 Bytes</VariableType>
          <Address>septerra.exe+DEED6</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>24</ID>
          <Description>"Selina HP"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>septerra.exe+DF09E</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>25</ID>
          <Description>"Araym"</Description>
          <VariableType>2 Bytes</VariableType>
          <Address>septerra.exe+DF266</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.04 or GOG
</Comments>
</CheatTable>
