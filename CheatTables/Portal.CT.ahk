<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>2</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>1</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(inf_hp, 64)
label(inf_hp_ret)
aobscanmodule(hp, server.dll, 8B BF DC 00 00 00 33 C0)
registersymbol(hp)

inf_hp:
  mov [edi+000000DC],1f4
  mov edi,[edi+000000DC]
jmp inf_hp_ret

hp:
 jmp inf_hp
 nop
inf_hp_ret:

[disable]
hp:
  mov edi,[edi+000000DC]
dealloc(*)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>0</ID>
      <Description>"P - Portals anywhere"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscanmodule(portals_anywere, server.dll, D9 54 24 38 8B 15 * * * * 83 7A 30 00)
registersymbol(portals_anywere)

portals_anywere+a:
 db 83 7A 30 01

[disable]
portals_anywere+a:
 db 83 7A 30 00
unregistersymbol(portals_anywere)

</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>portals anywhere:
2418248f
24182494
</Comments>
</CheatTable>
