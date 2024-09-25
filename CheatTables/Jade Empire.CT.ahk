<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>58</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>52</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 128)
label(hp_flag)
label(kill_flag)
registersymbol(hp_flag)
registersymbol(kill_flag)
label(player)
label(player_code)
label(player_ret)
label(hit_code)
label(hit_ret)
label(enemy)
label(hit_og)
label(kill)
registersymbol(player)

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
player:
  db 00 00 00 00

player_code:
  fld dword ptr [eax+00000470]
  push eax
  pop [player]
  cmp [hp_flag], 00
  je player_ret
  fild [eax+00000948]
  fstp [eax+00000470]
jmp player_ret

hit_code:
  mov [esi+00000470],eax
  cmp [player], esi
  jne enemy
  cmp [hp_flag], 00
  je hit_ret
  fild [esi+00000948]
  fstp [esi+00000470]
jmp hit_ret

enemy:
  cmp [kill_flag], 00
  je hit_ret
  // simple heuristics to prevent enemies from
  // dying the moment they are spawned
  cmp [esi+00000470], (float)1
  je kill
  mov [esi+00000470], (float)1
  jmp hit_ret
kill:
  mov [esi+00000470], (float)0
jmp hit_ret

hit_og:
  mov [esi+00000470],eax
jmp hit_ret

JadeEmpire.exe+17E14B:
  jmp player_code
  nop
player_ret:

JadeEmpire.exe+C8DE5:
  jmp hit_code
  nop
hit_ret:

[disable]
JadeEmpire.exe+17E14B:
  fld dword ptr [eax+00000470]

JadeEmpire.exe+C8DE5:
  mov [esi+00000470],eax

dealloc(*)


</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>54</ID>
          <Description>"H - inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
hp_flag:
  db 10 00 00 00

[disable]
hp_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>55</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
kill_flag:
  db 10 00 00 00

[disable]
kill_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>68</ID>
          <Description>"F - inf Focus"</Description>
          <GroupHeader>1</GroupHeader>
        </CheatEntry>
        <CheatEntry>
          <ID>69</ID>
          <Description>"C - inf Chi"</Description>
          <GroupHeader>1</GroupHeader>
        </CheatEntry>
        <CheatEntry>
          <ID>67</ID>
          <Description>"Vars"</Description>
          <Options moHideChildren="1"/>
          <GroupHeader>1</GroupHeader>
          <CheatEntries>
            <CheatEntry>
              <ID>61</ID>
              <Description>"HP"</Description>
              <ShowAsSigned>0</ShowAsSigned>
              <VariableType>Float</VariableType>
              <Address>[player]+470</Address>
            </CheatEntry>
            <CheatEntry>
              <ID>62</ID>
              <Description>"Max HP"</Description>
              <ShowAsSigned>0</ShowAsSigned>
              <VariableType>4 Bytes</VariableType>
              <Address>[player]+948</Address>
            </CheatEntry>
            <CheatEntry>
              <ID>60</ID>
              <Description>"Chi"</Description>
              <ShowAsSigned>0</ShowAsSigned>
              <VariableType>Float</VariableType>
              <Address>[player]+478</Address>
            </CheatEntry>
            <CheatEntry>
              <ID>63</ID>
              <Description>"Max Chi"</Description>
              <ShowAsSigned>0</ShowAsSigned>
              <VariableType>4 Bytes</VariableType>
              <Address>[player]+948+4</Address>
            </CheatEntry>
            <CheatEntry>
              <ID>65</ID>
              <Description>"Focus"</Description>
              <ShowAsSigned>0</ShowAsSigned>
              <VariableType>Float</VariableType>
              <Address>[player]+48c</Address>
            </CheatEntry>
            <CheatEntry>
              <ID>66</ID>
              <Description>"Max Focus"</Description>
              <ShowAsSigned>0</ShowAsSigned>
              <VariableType>Float</VariableType>
              <Address>[player]+488</Address>
            </CheatEntry>
          </CheatEntries>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>57</ID>
      <Description>"G - Gain style point"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(points, 128)
label(points_ret)

points:
  add [esi+0000083C], 1
  mov esi,[esi+0000083C]
jmp points_ret

JadeEmpire.exe+17CD50:
  jmp points
  nop
points_ret:

[disable]
JadeEmpire.exe+17CD50:
  mov esi,[esi+0000083C]
dealloc(*)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>50</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>32</ID>
          <Description>"Style Points"</Description>
          <VariableType>Byte</VariableType>
          <Address>"JadeEmpire.exe"+0036C924</Address>
          <Offsets>
            <Offset>83C</Offset>
            <Offset>68</Offset>
            <Offset>0</Offset>
            <Offset>0</Offset>
            <Offset>A0</Offset>
          </Offsets>
        </CheatEntry>
        <CheatEntry>
          <ID>59</ID>
          <Description>"Lvl up"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
/* With this active and the player has any point to level up. each time the
 * player enters the lvl up screen, another point is gained
 */
alloc(abpoints, 128)
label(abpoints_ret)

abpoints:
  add [edi+00000958], 1
  mov edi,[edi+00000958]
jmp abpoints_ret

JadeEmpire.exe+165157:
   jmp abpoints
   nop
abpoints_ret:

[disable]
JadeEmpire.exe+165157:
   mov edi,[edi+00000958]
dealloc(*)


</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: GOG, 2.0.0.4
</Comments>
</CheatTable>
