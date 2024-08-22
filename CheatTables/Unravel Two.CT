<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>2</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscanmodule(y_code, UnravelTwo.exe, F3 0F 5C 4B 40 F3 0F 5C 6B 3C)
registersymbol(y_code)
alloc(y_trampoline, 16, y_code)
alloc(y_new, 128)
label(y_newcode)
label(fly_flag)
label(y_ret)
label(y_og)
registersymbol(fly_flag)

y_new:
  dd (float)0.01
fly_flag:
  db 00 00 00 00
y_newcode:
  cmp dword ptr [fly_flag], 00
  je y_og
  movss xmm3,[rbx+40]
  addss xmm3,[y_new]
  movss [rbx+40],xmm3
y_og:
  subss xmm1,[rbx+40]
jmp y_ret

y_trampoline:
  jmp y_newcode

y_code:
  jmp y_trampoline
y_ret:

[disable]
y_code:
  db F3 0F 5C 4B 40 F3 0F 5C 6B 3C
unregistersymbol(y_code)
dealloc(*)
</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>1</ID>
          <Description>"F - hold to Float"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
fly_flag:
  db 00 00 00 01

[disable]
fly_flag:
  db 00 00 00 00
</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
</CheatTable>
