<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>30</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>23</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscanmodule(y_code, unravel.exe, F3 0F 58 68 3C F3 0F 58 48 38)
aobscanmodule(xy_code, unravel.exe, 48 89 42 38 41 FF C2)
registersymbol(y_code)
registersymbol(xy_code)
alloc(y_trampoline, 16, y_code)
alloc(xy_trampoline, 16, xy_code)
alloc(y_new, 128)
alloc(y_new, 128)
label(y_newcode)
label(y_offset)
label(x_offset)
label(y_ret)
label(pos)
label(fly_flag)
label(copy_of_xmm5)
label(xy_new)
label(xy_ret)
label(xy_og)
registersymbol(fly_flag)
registersymbol(pos)
registersymbol(y_offset)
registersymbol(x_offset)

y_new:
y_offset:
  dd (float)0.000
x_offset:
  dd (float)0.000
fly_flag:
  db 00 00 00 00
pos:
  db 00 00 00 00 00 00 00 00
copy_of_xmm5:
  db 00 00 00 00
copy_of_xmm4:
  db 00 00 00 00
y_newcode:
  movss [copy_of_xmm5], xmm5
  mov [pos], rax
  addss xmm5,[rax+3C]
  cmp dword ptr [fly_flag], 00
  jmp y_ret
  movss xmm5, [rax+3c]
  addss xmm5, [y_offset]
  movss [rax+3c], xmm5
  movss xmm5, [copy_of_xmm5]
jmp y_ret

xy_new:
  inc r10d
  cmp dword ptr [fly_flag], 00
  je xy_og
  cmp [pos], rdx
  jne xy_og
  movss [copy_of_xmm5], xmm5
  movss xmm5, [rdx+3c]
  addss xmm5, [y_offset]
  movss [rdx+3c], xmm5
  movss xmm5, [copy_of_xmm5]
  movss xmm5, [rdx+38]
  addss xmm5, [x_offset]
  movss [rdx+38], xmm5
  movss xmm5, [copy_of_xmm5]
  jmp xy_ret
xy_og:
  mov [rdx+38],rax
jmp xy_ret

y_trampoline:
  jmp y_newcode

xy_trampoline:
  jmp xy_new

y_code:
  jmp y_trampoline
y_ret:

xy_code:
  jmp xy_trampoline
  nop
  nop
xy_ret:

[disable]
y_code:
  db F3 0F 58 68 3C F3 0F 58 48 38
xy_code:
  db 48 89 42 38 41 FF C2
unregistersymbol(y_code)
dealloc(*)
</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>24</ID>
          <Description>"F - Float mode"</Description>
          <Options moAlwaysHideChildren="1"/>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
fly_flag:
  db 00 00 00 01

[disable]
fly_flag:
  db 00 00 00 00

</AssemblerScript>
          <CheatEntries>
            <CheatEntry>
              <ID>26</ID>
              <Description>"float down"</Description>
              <VariableType>Auto Assembler Script</VariableType>
              <AssemblerScript>[enable]
y_offset:
  dd (float)-0.02

[disable]
y_offset:
  dd (float)0.000


</AssemblerScript>
            </CheatEntry>
            <CheatEntry>
              <ID>27</ID>
              <Description>"float up"</Description>
              <VariableType>Auto Assembler Script</VariableType>
              <AssemblerScript>[enable]
y_offset:
  dd (float)0.02

[disable]
y_offset:
  dd (float)0.000

</AssemblerScript>
            </CheatEntry>
            <CheatEntry>
              <ID>28</ID>
              <Description>"float left"</Description>
              <VariableType>Auto Assembler Script</VariableType>
              <AssemblerScript>[enable]
x_offset:
  dd (float)-0.03

[disable]
x_offset:
  dd (float)0.00

</AssemblerScript>
            </CheatEntry>
            <CheatEntry>
              <ID>29</ID>
              <Description>"float right"</Description>
              <VariableType>Auto Assembler Script</VariableType>
              <AssemblerScript>[enable]
x_offset:
  dd (float)0.03

[disable]
x_offset:
  dd (float)0.000

</AssemblerScript>
            </CheatEntry>
          </CheatEntries>
        </CheatEntry>
        <CheatEntry>
          <ID>25</ID>
          <Description>"Vertical pos"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>Float</VariableType>
          <Address>pos</Address>
          <Offsets>
            <Offset>3c</Offset>
          </Offsets>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <CheatCodes>
    <CodeEntry>
      <Description>Change of mov [rbx+38],rax</Description>
      <AddressString>Unravel.exe+19ABFAB</AddressString>
      <Before>
        <Byte>48</Byte>
        <Byte>8B</Byte>
        <Byte>44</Byte>
        <Byte>24</Byte>
        <Byte>50</Byte>
      </Before>
      <Actual>
        <Byte>48</Byte>
        <Byte>89</Byte>
        <Byte>43</Byte>
        <Byte>38</Byte>
      </Actual>
      <After>
        <Byte>0F</Byte>
        <Byte>28</Byte>
        <Byte>74</Byte>
        <Byte>24</Byte>
        <Byte>30</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Change of mov [rbx+38],rax</Description>
      <AddressString>Unravel.exe+19AEDF2</AddressString>
      <Before>
        <Byte>48</Byte>
        <Byte>8B</Byte>
        <Byte>44</Byte>
        <Byte>24</Byte>
        <Byte>50</Byte>
      </Before>
      <Actual>
        <Byte>48</Byte>
        <Byte>89</Byte>
        <Byte>43</Byte>
        <Byte>38</Byte>
      </Actual>
      <After>
        <Byte>0F</Byte>
        <Byte>28</Byte>
        <Byte>74</Byte>
        <Byte>24</Byte>
        <Byte>30</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Code :mov [rbx+38],rax</Description>
      <AddressString>Unravel.exe+19ABFAB</AddressString>
      <Before>
        <Byte>48</Byte>
        <Byte>8B</Byte>
        <Byte>44</Byte>
        <Byte>24</Byte>
        <Byte>50</Byte>
      </Before>
      <Actual>
        <Byte>48</Byte>
        <Byte>89</Byte>
        <Byte>43</Byte>
        <Byte>38</Byte>
      </Actual>
      <After>
        <Byte>0F</Byte>
        <Byte>28</Byte>
        <Byte>74</Byte>
        <Byte>24</Byte>
        <Byte>30</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Code :mov [rbx+38],rax</Description>
      <AddressString>Unravel.exe+19AEDF2</AddressString>
      <Before>
        <Byte>48</Byte>
        <Byte>8B</Byte>
        <Byte>44</Byte>
        <Byte>24</Byte>
        <Byte>50</Byte>
      </Before>
      <Actual>
        <Byte>48</Byte>
        <Byte>89</Byte>
        <Byte>43</Byte>
        <Byte>38</Byte>
      </Actual>
      <After>
        <Byte>0F</Byte>
        <Byte>28</Byte>
        <Byte>74</Byte>
        <Byte>24</Byte>
        <Byte>30</Byte>
      </After>
    </CodeEntry>
  </CheatCodes>
  <UserdefinedSymbols/>
</CheatTable>
