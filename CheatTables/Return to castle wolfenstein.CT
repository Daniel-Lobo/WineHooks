<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>34</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>26</ID>
      <Description>"M - Manual attach"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(damage, 512)
registersymbol(damage)
label(damage_ret_point)
label(player)
label(enemy)

damage:
  db 00 00 00 00             // Inf health flag
  db 00 00 00 00             // One hit flag
  push edx
  add edx, 000003D8
  cmp edx, 20579118          // Player Health
  pop edx
  jne enemy

player:
  push eax
  mov eax, damage
  cmp [eax], 00
  pop eax
  jne damage_ret_point
  mov [edx+000003D8],ecx     // Normal damage
jmp damage_ret_point

enemy:
  mov [edx+000003D8], ecx    // Normal damage
  push eax
  mov eax, damage
  add eax, 4
  cmp [eax], 00
  pop eax
  je damage_ret_point
  mov [edx+000003D8],00
jmp damage_ret_point

qagamex86.dll+5BD83:
damage_ret_point:

[disable]
dealloc(damage)
</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>35</ID>
          <Description>"Auto - Damage"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
qagamex86.dll+5BD7D:
  jmp damage+8
  nop

[disable]
  qagamex86.dll+5BD7D:
  mov [edx+000003D8],ecx

</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>36</ID>
          <Description>"R - Reset"</Description>
          <GroupHeader>1</GroupHeader>
        </CheatEntry>
        <CheatEntry>
          <ID>27</ID>
          <Description>"H - Inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
damage:
db 00 00 00 01             // Inf health flag

[disable]
damage+4:
db 00 00 00 00
</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>28</ID>
          <Description>"K - easy kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
damage+4:// Inf health flag
db 00 00 00 01

[disable]
damage+4:
db 00 00 00 00
</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>29</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
qagamex86.dll+45747:
nop
nop
nop
nop
nop
nop
nop


[disable]
qagamex86.dll+45747:
mov [edx+ecx*4+00000290],eax

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>33</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>20</ID>
          <Description>"Health"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>qagamex86.dll+579118</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>30</ID>
          <Description>"Shield"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>qagamex86.dll+6E31B8</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>32</ID>
          <Description>"Sprint"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>cgamex86.dll+5CDCF0</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>21</ID>
          <Description>"Pistol"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>qagamex86.dll+6E3378</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>22</ID>
          <Description>"Machine gun"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>qagamex86.dll+6E337C</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: https://www.moddb.com/downloads/return-to-castle-wolfenstein-v142d-patch
</Comments>
</CheatTable>
