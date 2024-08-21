<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>33</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(player, 64)
label(player_retadd)

player:
  mov [eax+00000084],1000
jmp player_retadd

dkev.exe+165D:
  jmp player
  nop
player_retadd:

[disable]
dkev.exe+165D:
  sub [eax+00000084],ebx

dealloc(*)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>31</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 64)
label(hit_retadd)

hit:
  mov [eax+00000084],00
jmp hit_retadd

dkev.exe+7062D:
  jmp hit
  nop
hit_retadd:

[disable]
dkev.exe+7062D:
  sub [eax+00000084],ebx
dealloc(*)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>27</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
00426ACF:
nop
nop
nop
nop
nop
nop
nop

[disable]
00426ACF:
dec [eax*4+004B345C]

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>32</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>26</ID>
          <Description>"Darkness"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>4 Bytes</VariableType>
          <Address>dkev.exe+B6F70</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, update 1
</Comments>
</CheatTable>
