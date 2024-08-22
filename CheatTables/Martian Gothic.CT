<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>37</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>36</ID>
      <Description>"H - inf HP"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>1</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(bullets, 128)
label(bullets_ret)

bullets:
  mov word ptr[eax+0075197C],63
  jmp bullets_ret

004079F0:
jmp bullets
nop
nop
bullets_ret:


[disable]
004079F0:
add [eax+0075197C],cx
dealloc(*)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>34</ID>
      <Description>"G - Gain save"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(gain_saves, 128)
label(gain_saves_retadd)

gain_saves:
  add byte ptr [edx+"martian gothic.exe"+1BB51E], 1
  mov al,[edx+"martian gothic.exe"+1BB51E]
jmp gain_saves_retadd

martian gothic.exe+E773:
  jmp gain_saves
  nop
gain_saves_retadd:

[disable]
martian gothic.exe+E773:
  mov al,[edx+"martian gothic.exe"+1BB51E]
dealloc(*)



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>35</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>31</ID>
          <Description>"SavesCount[0]"</Description>
          <VariableType>Byte</VariableType>
          <Address>"martian gothic.exe"+1BB51f</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>32</ID>
          <Description>"SavesCount[-1]"</Description>
          <VariableType>Byte</VariableType>
          <Address>"martian gothic.exe"+1BB52b</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>2</ID>
          <Description>"Matlock HP"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>"martian gothic.exe"+1BE630</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>3</ID>
          <Description>"Kenzo HP"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>"martian gothic.exe"+1BDB6C</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>4</ID>
          <Description>"Karne HP"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>"martian gothic.exe"+1BD0A8</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Retail, patch 3
</Comments>
</CheatTable>
