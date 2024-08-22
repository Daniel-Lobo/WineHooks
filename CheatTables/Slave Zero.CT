<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>7</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hp, 128)
label(hp_ret)

hp:
  mov [edx+000000F4], (float)100
  fld dword ptr [edx+000000F4]
jmp hp_ret

zplayer.dll+C92B:
  nop
  nop
  nop

zplayer.dll+39BB:
  jmp hp
  nop
hp_ret:

[disable]
zplayer.dll+C92B:
  fsub dword ptr [ebp+20]
zplayer.dll+39BB:
  fld dword ptr [edx+000000F4]
dealloc(*)




</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>5</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(ammo, 128)
label(ammo_ret)
label(missle)
label(missle_ret)

ammo:
  push [eax+00002C98+4]
  pop [eax+00002C98]
jmp ammo_ret

missle:
  cmp [edi+ebx*4+00000284],eax
  ja missle_ret
  mov [edi+ebx*4+00000284],eax
jmp missle_ret

whud.dll+4C53:
  jmp ammo
  nop
ammo_ret:

zplayer.dll+A919:
  jmp missle
  nop
  nop
missle_ret:

[disable]
whud.dll+4C53:
  mov [eax+00002C98],edx

zplayer.dll+A919:
  mov [edi+ebx*4+00000284],eax

dealloc(*)



</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail + update + d3d patch
</Comments>
</CheatTable>
