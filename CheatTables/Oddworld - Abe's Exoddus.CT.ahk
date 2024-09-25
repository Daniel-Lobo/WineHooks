<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>29</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>6</ID>
      <Description>"G - inf Grenades"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Exoddus.exe.text+4E71B:
  nop
  nop

Exoddus.exe.text+55DD6:
  nop
  nop

[disable]
Exoddus.exe.text+4E71B:
  dec al

Exoddus.exe.text+55DD6: // Trow when crouching
  dec al



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>27</ID>
      <Description>"I - Invulnerable"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Exoddus.exe.text+2128A:
  db 90 90 90 90 90 90 90

Exoddus.exe.text+212B3:
  db 90 90 90 90 90 90 90

Exoddus.exe.text+45D28:
  db 90 90 90 90 90 90 90

Exoddus.exe.text+4AAD7:
  db 90 90 90 90

Exoddus.exe.text+4B0A3:
  db 90 90

Exoddus.exe.text+4BA44:
  db 90 90 90 90 90 90

[disable]
Exoddus.exe.text+2128A:
  mov ax,[esi+00000114]

Exoddus.exe.text+212B3:
  mov [esi+00000114],ax

Exoddus.exe.text+45D28:
  test byte ptr [ecx+00000114],40

Exoddus.exe.text+4AAD7:
test byte ptr [ecx+24],04

Exoddus.exe.text+4B0A3:
  test bl,dl

Exoddus.exe.text+4BA44:
  mov [esi+0000010C],edx
dealloc(*)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>23</ID>
      <Description>"Shift + L - select Level"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>24</ID>
      <Description>"Shift + F - view Fmsvs"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>25</ID>
      <Description>"Shift + N - Next checkpoint"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>32</ID>
      <Description>"Z - Zero casualities"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>30</ID>
          <Description>"Escapees"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>Exoddus.exe+1C1F52</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>31</ID>
          <Description>"casualities"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>005C1F50</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
</CheatTable>
