<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>9</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
/* attacks */
KAIN.EXE+32D37:
nop, 3

/* water */
KAIN.EXE+17880:
nop, 3

/* magic attacks */
KAIN.EXE+33C43:
nop, 3

/* Blood loss */
KAIN.EXE+2AC59:
nop, 3

[DISABLE]
/* attacks */
KAIN.EXE+32D37:
mov [ecx],ax

/* water */
KAIN.EXE+17880:
sub [esi],dx

/* magic attacks */
KAIN.EXE+33C43:
sub [eax],di

/* Blood loss */
KAIN.EXE+2AC59:
dec word ptr [edx]





</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
alloc(easy_kills,2048)
label(easy_kills_ret_point)

easy_kills:
  mov [ebx+24],0
  cmp dx,32
jmp easy_kills_ret_point


"KAIN.EXE"+17E39:
  jmp easy_kills
  nop 3
easy_kills_ret_point:


[DISABLE]
"KAIN.EXE"+17E39:
mov [ebx+24],ax
cmp dx,32
dealloc(easy_kills, 512)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>13</ID>
      <Description>"M - inf Magic"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
/* speels */
KAIN.EXE+4A311:
nop, 4

/* Shape shift */
KAIN.EXE+2B3BA:
nop, 4

[DISABLE]
/* speels */
KAIN.EXE+4A311:
mov [eax+06],bx

/* Shape shift */
KAIN.EXE+2B3BA:
mov [ecx+06],di


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>3</ID>
      <Description>"I - inf Items"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
"KAIN.EXE"+4A2DA:
nop
nop
nop
nop
nop
nop

KAIN.EXE+4C8BB:
nop, 6

[disable]
"KAIN.EXE"+4A2DA:
sub [eax+004BFBD4],bl

KAIN.EXE+4C8BB:
mov [KAIN.EXE+BFBE6],dh



</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: http://cubanraul.altervista.org/kain/index.htm</Comments>
</CheatTable>
