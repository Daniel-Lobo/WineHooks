<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>0</ID>
      <Description>"Z - inf stamina"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(stamina)
aobscan(stamina, F3 0F 11 41 28 40 C2 08 00 F3 0F 10 51 28)
alloc(inf_stamina, 512)
label(retpoint)

inf_stamina:
movss [ecx+28],xmm0
mov [ecx+28],42A00000
mov [ecx+34],42A00000
jmp retpoint

stamina:
jmp inf_stamina
retpoint:

[disable]
stamina:
movss [ecx+28],xmm0
dealloc(inf_stamina)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>1</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(bullets)
aobscan(bullets, F3 0F 2A 86 00 09 00 00 6A 01)
alloc(inf_bullets, 512)
label(retpoint)

inf_bullets:
mov byte ptr [esi+00000900],05
cvtsi2ss xmm0,[esi+00000900]b
jmp retpoint

bullets:
jmp inf_bullets
nop
nop
nop
retpoint:

[disable]
bullets:
cvtsi2ss xmm0,[esi+00000900]b
dealloc(inf_bullets)


</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, 1.01
</Comments>
</CheatTable>
