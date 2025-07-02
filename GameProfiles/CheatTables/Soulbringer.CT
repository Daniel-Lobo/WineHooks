<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>19</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>1</ID>
      <Description>"Auto - Player"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(player, 256)
label(player_code)
label(player_ret)
registersymbol(player)
label(hit)
label(hit_ret)
label(hp_flag)
label(kill_flag)
registersymbol(hp_flag)
registersymbol(kill_flag)
label(enemy)
label(hit_og)
registersymbol(enemy)
registersymbol(hit)
registersymbol(hit_og)
registersymbol(hit_ret)
label(player_og)

player:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
  db 00 00 00 00
hp_flag:
  db 00 00 00 00
player_code:
  mov [player], eax
  cmp [hp_flag], 00
  je player_og
  push word ptr [eax+2e]
  pop word ptr [eax+2c]
player_og:
  movsx eax, word ptr [eax+2C]
  mov [esp+18],ecx
jmp player_ret

hit:
  pushfd
  cmp edx, [player]
  jne enemy
  cmp [hp_flag], 00
  je hit_og
  mov ax, [edx+2E]
  mov [edx+2C],ax
  mov eax,[ebp-0C]
  popfd
jmp hit_ret

hit_og:
  mov [edx+2C],ax
  mov eax,[ebp-0C]
  popfd
jmp hit_ret

enemy:
  mov ax, 00
  mov [edx+2C],ax
  mov eax,[ebp-0C]
  popfd
jmp hit_ret

00423529:
  jmp player_code
  nop
  nop
  nop
player_ret:

0045E289:
  mov [edx+2C],ax
  mov eax,[ebp-0C]
hit_ret:

[disable]
00423529:
  movsx eax,word ptr [eax+2C]
  mov [esp+18],ecx

unregistersymbol(*)
dealloc()

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>14</ID>
          <Description>"H - inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
hp_flag:
  db 01 00 00 00

[disable]
hp_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>15</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
0045E289:
  jmp hit
  nop
  nop
hit_ret:

[disable]
0045E289:
  mov [edx+2C],ax
  mov eax,[ebp-0C]

</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>2</ID>
          <Description>"HP"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>[player]+2c</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>3</ID>
          <Description>"Max HP"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>[player]+2e</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>4</ID>
          <Description>"MP"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>[player]+30</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>5</ID>
          <Description>"Max MP"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>[player]+32</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>6</ID>
          <Description>"XP"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>[player]+34</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>18</ID>
      <Description>"M -replenish Magic "</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>16</ID>
      <Description>"G - gain Gold"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>8</ID>
          <Description>"Auto - Gold"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
alloc(gold, 128)
label(gold_code)
label(gold_ret)
registersymbol(gold)

gold:
  db 00 00 00 00
gold_code:
  mov [gold], ecx
  mov ecx,[ecx+000000A4]
jmp gold_ret

0066EECA:
  jmp gold_code
  nop
gold_ret:

[disable]
0066EECA:
  mov ecx,[ecx+000000A4]
unregistersymbol(*)
dealloc()

</AssemblerScript>
          <CheatEntries>
            <CheatEntry>
              <ID>9</ID>
              <Description>"Gold"</Description>
              <ShowAsSigned>0</ShowAsSigned>
              <VariableType>4 Bytes</VariableType>
              <Address>[gold]+000000A4</Address>
            </CheatEntry>
          </CheatEntries>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>17</ID>
      <Description>"P - gain Advancement point"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>13</ID>
          <Description>"Adv Points"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>2 Bytes</VariableType>
          <Address>0202F528</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <CheatCodes>
    <CodeEntry>
      <Description>read mana</Description>
      <AddressString>SOULBR~2.EXE+6AD16</AddressString>
      <Before>
        <Byte>C8</Byte>
        <Byte>7D</Byte>
        <Byte>02</Byte>
        <Byte>8B</Byte>
        <Byte>C1</Byte>
      </Before>
      <Actual>
        <Byte>0F</Byte>
        <Byte>BF</Byte>
        <Byte>4A</Byte>
        <Byte>30</Byte>
      </Actual>
      <After>
        <Byte>66</Byte>
        <Byte>89</Byte>
        <Byte>42</Byte>
        <Byte>2C</Byte>
        <Byte>0F</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>mana</Description>
      <AddressString>SOULBR~2.EXE+234CD</AddressString>
      <Before>
        <Byte>32</Byte>
        <Byte>89</Byte>
        <Byte>4C</Byte>
        <Byte>24</Byte>
        <Byte>18</Byte>
      </Before>
      <Actual>
        <Byte>0F</Byte>
        <Byte>BF</Byte>
        <Byte>52</Byte>
        <Byte>30</Byte>
      </Actual>
      <After>
        <Byte>DB</Byte>
        <Byte>44</Byte>
        <Byte>24</Byte>
        <Byte>18</Byte>
        <Byte>89</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>hp exclusive</Description>
      <AddressString>SOULBR~2.EXE+23529</AddressString>
      <Before>
        <Byte>03</Byte>
        <Byte>0F</Byte>
        <Byte>BF</Byte>
        <Byte>48</Byte>
        <Byte>2E</Byte>
      </Before>
      <Actual>
        <Byte>0F</Byte>
        <Byte>BF</Byte>
        <Byte>40</Byte>
        <Byte>2C</Byte>
      </Actual>
      <After>
        <Byte>89</Byte>
        <Byte>4C</Byte>
        <Byte>24</Byte>
        <Byte>18</Byte>
        <Byte>DB</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>hit</Description>
      <AddressString>SOULBR~2.EXE+5E289</AddressString>
      <Before>
        <Byte>00</Byte>
        <Byte>00</Byte>
        <Byte>8B</Byte>
        <Byte>55</Byte>
        <Byte>F4</Byte>
      </Before>
      <Actual>
        <Byte>66</Byte>
        <Byte>89</Byte>
        <Byte>42</Byte>
        <Byte>2C</Byte>
      </Actual>
      <After>
        <Byte>8B</Byte>
        <Byte>45</Byte>
        <Byte>F4</Byte>
        <Byte>8B</Byte>
        <Byte>7D</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>access gold</Description>
      <AddressString>SOULBR~2.EXE+26EECA</AddressString>
      <Before>
        <Byte>C4</Byte>
        <Byte>F0</Byte>
        <Byte>89</Byte>
        <Byte>57</Byte>
        <Byte>60</Byte>
      </Before>
      <Actual>
        <Byte>8B</Byte>
        <Byte>89</Byte>
        <Byte>A4</Byte>
        <Byte>00</Byte>
        <Byte>00</Byte>
        <Byte>00</Byte>
      </Actual>
      <After>
        <Byte>8B</Byte>
        <Byte>95</Byte>
        <Byte>98</Byte>
        <Byte>FE</Byte>
        <Byte>FF</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>advancement points</Description>
      <AddressString>SOULBR~2.EXE+2E46E</AddressString>
      <Before>
        <Byte>84</Byte>
        <Byte>30</Byte>
        <Byte>EC</Byte>
        <Byte>FF</Byte>
        <Byte>FF</Byte>
      </Before>
      <Actual>
        <Byte>0F</Byte>
        <Byte>B7</Byte>
        <Byte>05</Byte>
        <Byte>28</Byte>
        <Byte>F5</Byte>
        <Byte>02</Byte>
        <Byte>02</Byte>
      </Actual>
      <After>
        <Byte>8B</Byte>
        <Byte>5D</Byte>
        <Byte>DC</Byte>
        <Byte>C7</Byte>
        <Byte>05</Byte>
      </After>
    </CodeEntry>
  </CheatCodes>
  <UserdefinedSymbols/>
</CheatTable>
