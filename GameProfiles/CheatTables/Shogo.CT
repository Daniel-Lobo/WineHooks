<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>2</ID>
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
label(hit_og)
label(enemy)

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
player:
  db 00 00 00 00
player_code:
  fld dword ptr [ebp+000001DC]
  push ebp
  pop [player]
  add [player], 1DC
jmp player_ret

hit_code:
  push edi
  add edi, 44
  cmp edi, [player]
  pop edi
  jne enemy
  cmp [hp_flag], 00
  je hit_og
  fld dword ptr [edi+44]
jmp hit_ret

enemy:
  cmp [kill_flag], 00
  je hit_og
  fld dword ptr [edi+44]
  fsub dword ptr [edi+44]
jmp hit_ret

hit_og:
  fld dword ptr [edi+44]
  fsub dword ptr [esp+7C]
jmp hit_ret

object.ObjectDLLSetup+75FB:
  jmp player_code
  nop
player_ret:

object.lto+23E50:
  jmp hit_code
  nop
  nop
hit_ret:

[disable]
object.ObjectDLLSetup+75FB:
  fld dword ptr [ebp+000001DC]

object.lto+23E50:
  fld dword ptr [edi+44]
  fsub dword ptr [esp+7C]
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
      <ID>0</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
object.lto+66CD4:
  nop


[disable]
object.lto+66CD4:
  dec eax

</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 2.2</Comments>
</CheatTable>
