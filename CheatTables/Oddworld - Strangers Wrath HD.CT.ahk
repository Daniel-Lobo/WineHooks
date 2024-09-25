<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>49</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>46</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 128)
label(hit_retadd)
label(hp_flag)
label(kill_flag)
registersymbol(hp_flag)
registersymbol(kill_flag)
label(hit_code)
label(enemy)
label(hit_ogcode)

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00

hit_code:
  cmp [ecx+28], 0
  jne enemy
  cmp [hp_flag], 0
  je hit_ogcode
  fst dword ptr [ecx]
  push [ecx+4]
  pop [ecx]
  fucompp
  fnstsw ax
jmp hit_retadd

enemy:
  cmp [kill_flag], 0
  je hit_ogcode
  fst dword ptr [ecx]
  mov [ecx], (float)0
  fucompp
  fnstsw ax
jmp hit_retadd

hit_ogcode:
  fst dword ptr [ecx]
  fucompp
  fnstsw ax
jmp hit_retadd

stranger.exe+6A3B5:
  jmp hit_code
  nop
hit_retadd:

[disable]
stranger.exe+6A3B5:
  fst dword ptr [ecx]
  fucompp
  fnstsw ax
dealloc(*)
</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>47</ID>
          <Description>"H - inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
hp_flag:
  db 00 00 00 01

[disable]
hp_flag:
  db 00 00 00 00
</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>48</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
kill_flag:
  db 00 00 00 01

[disable]
kill_flag:
  db 00 00 00 00
</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>50</ID>
      <Description>"M - gain Money"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(money, 128)
label(money_flag)
label(money_end)
label(money_retadd)
label(more_money)

money:
  cmp [money_flag], 00
  mov [money_flag], 00
  je money_end
  fld [ebx+0c]
  fadd [more_money]
  fstp [ebx+0c]
money_end:
  mov esi,[ebx+00000088]
jmp money_retadd
money_flag:
  db 00 00 00 01
more_money:
  dd (float)50

stranger.exe+1CE948:
  jmp money
  nop
money_retadd:

[disable]
stranger.exe+1CE948:
  mov esi,[ebx+00000088]
dealloc(*)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>52</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
stranger.exe+AA376:
  db 90 90 90

stranger.exe+AA38E:
  db 90

[disable]
stranger.exe+AA376:
  add eax,-01

stranger.exe+AA38E:
  dec eax



</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols>
    <SymbolEntry>
      <Name>health</Name>
      <Address>00BC0000</Address>
    </SymbolEntry>
  </UserdefinedSymbols>
  <Structures StructVersion="2">
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Pointer" Bytesize="4" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="4" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000004" DisplayMethod="unsigned integer"/>
        <Element Offset="12" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000000C" DisplayMethod="hexadecimal"/>
        <Element Offset="16" Vartype="Double" Bytesize="8" OffsetHex="00000010" DisplayMethod="unsigned integer"/>
        <Element Offset="24" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000018" DisplayMethod="hexadecimal"/>
        <Element Offset="32" Vartype="Pointer" Bytesize="4" OffsetHex="00000020" DisplayMethod="unsigned integer"/>
        <Element Offset="36" Vartype="Pointer" Bytesize="4" OffsetHex="00000024" Description="Pointer to instance of MotionImpl" DisplayMethod="unsigned integer"/>
        <Element Offset="40" Vartype="Pointer" Bytesize="4" OffsetHex="00000028" Description="Pointer to instance of MindBasic" DisplayMethod="unsigned integer"/>
        <Element Offset="44" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="0000002C" DisplayMethod="unsigned integer"/>
        <Element Offset="80" Vartype="Pointer" Bytesize="4" OffsetHex="00000050" DisplayMethod="unsigned integer"/>
        <Element Offset="84" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000054" DisplayMethod="unsigned integer"/>
        <Element Offset="96" Vartype="Float" Bytesize="4" OffsetHex="00000060" DisplayMethod="unsigned integer"/>
        <Element Offset="100" Vartype="Pointer" Bytesize="4" OffsetHex="00000064" DisplayMethod="unsigned integer"/>
        <Element Offset="104" Vartype="Float" Bytesize="4" OffsetHex="00000068" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="Pointer" Bytesize="4" OffsetHex="0000006C" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000070" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000078" DisplayMethod="hexadecimal"/>
        <Element Offset="124" Vartype="String" Bytesize="20" OffsetHex="0000007C" DisplayMethod="unsigned integer"/>
        <Element Offset="144" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000090" DisplayMethod="unsigned integer"/>
        <Element Offset="147" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000093" DisplayMethod="unsigned integer"/>
        <Element Offset="149" Vartype="Byte" Bytesize="1" RLECount="14" OffsetHex="00000095" DisplayMethod="unsigned integer"/>
        <Element Offset="163" Vartype="2 Bytes" Bytesize="2" OffsetHex="000000A3" DisplayMethod="unsigned integer"/>
        <Element Offset="165" Vartype="Byte" Bytesize="1" RLECount="6" OffsetHex="000000A5" DisplayMethod="unsigned integer"/>
        <Element Offset="171" Vartype="2 Bytes" Bytesize="2" OffsetHex="000000AB" DisplayMethod="unsigned integer"/>
        <Element Offset="173" Vartype="String" Bytesize="31" OffsetHex="000000AD" DisplayMethod="unsigned integer"/>
        <Element Offset="204" Vartype="Byte" Bytesize="1" RLECount="23" OffsetHex="000000CC" DisplayMethod="unsigned integer"/>
        <Element Offset="227" Vartype="2 Bytes" Bytesize="2" OffsetHex="000000E3" DisplayMethod="unsigned integer"/>
        <Element Offset="229" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000000E5" DisplayMethod="unsigned integer"/>
        <Element Offset="231" Vartype="2 Bytes" Bytesize="2" OffsetHex="000000E7" DisplayMethod="unsigned integer"/>
        <Element Offset="233" Vartype="Byte" Bytesize="1" RLECount="7" OffsetHex="000000E9" DisplayMethod="unsigned integer"/>
        <Element Offset="240" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000F0" DisplayMethod="unsigned integer"/>
        <Element Offset="248" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="000000F8" DisplayMethod="unsigned integer"/>
        <Element Offset="256" Vartype="Pointer" Bytesize="4" OffsetHex="00000100" Description="Pointer to instance of NPCClub" DisplayMethod="unsigned integer"/>
        <Element Offset="260" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000104" DisplayMethod="unsigned integer"/>
        <Element Offset="264" Vartype="Pointer" Bytesize="4" OffsetHex="00000108" Description="Pointer to instance of NPCPrefs" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="Pointer" Bytesize="4" RLECount="5" OffsetHex="00000110" DisplayMethod="unsigned integer"/>
        <Element Offset="292" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000124" DisplayMethod="hexadecimal"/>
        <Element Offset="308" Vartype="Pointer" Bytesize="4" OffsetHex="00000134" DisplayMethod="unsigned integer"/>
        <Element Offset="312" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000138" DisplayMethod="unsigned integer"/>
        <Element Offset="320" Vartype="Double" Bytesize="8" OffsetHex="00000140" DisplayMethod="unsigned integer"/>
        <Element Offset="328" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000148" DisplayMethod="unsigned integer"/>
        <Element Offset="368" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000170" DisplayMethod="unsigned integer"/>
        <Element Offset="376" Vartype="Float" Bytesize="4" OffsetHex="00000178" DisplayMethod="unsigned integer"/>
        <Element Offset="380" Vartype="Pointer" Bytesize="4" OffsetHex="0000017C" DisplayMethod="unsigned integer"/>
        <Element Offset="384" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000180" DisplayMethod="unsigned integer"/>
        <Element Offset="400" Vartype="Float" Bytesize="4" OffsetHex="00000190" DisplayMethod="unsigned integer"/>
        <Element Offset="404" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000194" DisplayMethod="unsigned integer"/>
        <Element Offset="416" Vartype="Pointer" Bytesize="4" OffsetHex="000001A0" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001A4" DisplayMethod="unsigned integer"/>
        <Element Offset="424" Vartype="Double" Bytesize="8" OffsetHex="000001A8" DisplayMethod="unsigned integer"/>
        <Element Offset="432" Vartype="Float" Bytesize="4" OffsetHex="000001B0" DisplayMethod="unsigned integer"/>
        <Element Offset="436" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001B4" DisplayMethod="unsigned integer"/>
        <Element Offset="440" Vartype="Pointer" Bytesize="4" OffsetHex="000001B8" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="468" Vartype="String" Bytesize="49" OffsetHex="000001D4" DisplayMethod="unsigned integer"/>
        <Element Offset="517" Vartype="Byte" Bytesize="1" OffsetHex="00000205" DisplayMethod="unsigned integer"/>
        <Element Offset="518" Vartype="String" Bytesize="57" OffsetHex="00000206" DisplayMethod="unsigned integer"/>
        <Element Offset="575" Vartype="Byte" Bytesize="1" OffsetHex="0000023F" DisplayMethod="unsigned integer"/>
        <Element Offset="576" Vartype="String" Bytesize="31" OffsetHex="00000240" DisplayMethod="unsigned integer"/>
        <Element Offset="607" Vartype="Byte" Bytesize="1" OffsetHex="0000025F" DisplayMethod="unsigned integer"/>
        <Element Offset="608" Vartype="String" Bytesize="31" OffsetHex="00000260" DisplayMethod="unsigned integer"/>
        <Element Offset="639" Vartype="Byte" Bytesize="1" OffsetHex="0000027F" DisplayMethod="unsigned integer"/>
        <Element Offset="640" Vartype="String" Bytesize="31" OffsetHex="00000280" DisplayMethod="unsigned integer"/>
        <Element Offset="671" Vartype="Byte" Bytesize="1" OffsetHex="0000029F" DisplayMethod="unsigned integer"/>
        <Element Offset="672" Vartype="String" Bytesize="34" OffsetHex="000002A0" DisplayMethod="unsigned integer"/>
        <Element Offset="706" Vartype="Byte" Bytesize="1" OffsetHex="000002C2" DisplayMethod="unsigned integer"/>
        <Element Offset="707" Vartype="String" Bytesize="28" OffsetHex="000002C3" DisplayMethod="unsigned integer"/>
        <Element Offset="735" Vartype="Byte" Bytesize="1" OffsetHex="000002DF" DisplayMethod="unsigned integer"/>
        <Element Offset="736" Vartype="String" Bytesize="28" OffsetHex="000002E0" DisplayMethod="unsigned integer"/>
        <Element Offset="764" Vartype="Byte" Bytesize="1" OffsetHex="000002FC" DisplayMethod="unsigned integer"/>
        <Element Offset="765" Vartype="String" Bytesize="67" OffsetHex="000002FD" DisplayMethod="unsigned integer"/>
        <Element Offset="832" Vartype="Byte" Bytesize="1" OffsetHex="00000340" DisplayMethod="unsigned integer"/>
        <Element Offset="833" Vartype="String" Bytesize="32" OffsetHex="00000341" DisplayMethod="unsigned integer"/>
        <Element Offset="865" Vartype="Byte" Bytesize="1" OffsetHex="00000361" DisplayMethod="unsigned integer"/>
        <Element Offset="866" Vartype="String" Bytesize="13" OffsetHex="00000362" DisplayMethod="unsigned integer"/>
        <Element Offset="879" Vartype="Byte" Bytesize="1" OffsetHex="0000036F" DisplayMethod="unsigned integer"/>
        <Element Offset="880" Vartype="String" Bytesize="13" OffsetHex="00000370" DisplayMethod="unsigned integer"/>
        <Element Offset="893" Vartype="Byte" Bytesize="1" OffsetHex="0000037D" DisplayMethod="unsigned integer"/>
        <Element Offset="894" Vartype="String" Bytesize="15" OffsetHex="0000037E" DisplayMethod="unsigned integer"/>
        <Element Offset="909" Vartype="Byte" Bytesize="1" OffsetHex="0000038D" DisplayMethod="unsigned integer"/>
        <Element Offset="910" Vartype="String" Bytesize="34" OffsetHex="0000038E" DisplayMethod="unsigned integer"/>
        <Element Offset="944" Vartype="Byte" Bytesize="1" OffsetHex="000003B0" DisplayMethod="unsigned integer"/>
        <Element Offset="945" Vartype="String" Bytesize="98" OffsetHex="000003B1" DisplayMethod="unsigned integer"/>
        <Element Offset="1043" Vartype="Byte" Bytesize="1" OffsetHex="00000413" DisplayMethod="unsigned integer"/>
        <Element Offset="1044" Vartype="String" Bytesize="25" OffsetHex="00000414" DisplayMethod="unsigned integer"/>
        <Element Offset="1069" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="0000042D" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1076" Vartype="String" Bytesize="37" OffsetHex="00000434" DisplayMethod="unsigned integer"/>
        <Element Offset="1113" Vartype="Byte" Bytesize="1" OffsetHex="00000459" DisplayMethod="unsigned integer"/>
        <Element Offset="1114" Vartype="String" Bytesize="88" OffsetHex="0000045A" DisplayMethod="unsigned integer"/>
        <Element Offset="1202" Vartype="Byte" Bytesize="1" OffsetHex="000004B2" DisplayMethod="unsigned integer"/>
        <Element Offset="1203" Vartype="String" Bytesize="79" OffsetHex="000004B3" DisplayMethod="unsigned integer"/>
        <Element Offset="1282" Vartype="Byte" Bytesize="1" OffsetHex="00000502" DisplayMethod="unsigned integer"/>
        <Element Offset="1283" Vartype="String" Bytesize="37" OffsetHex="00000503" DisplayMethod="unsigned integer"/>
        <Element Offset="1320" Vartype="Byte" Bytesize="1" OffsetHex="00000528" DisplayMethod="unsigned integer"/>
        <Element Offset="1321" Vartype="String" Bytesize="25" OffsetHex="00000529" DisplayMethod="unsigned integer"/>
        <Element Offset="1346" Vartype="Byte" Bytesize="1" OffsetHex="00000542" DisplayMethod="unsigned integer"/>
        <Element Offset="1347" Vartype="String" Bytesize="43" OffsetHex="00000543" DisplayMethod="unsigned integer"/>
        <Element Offset="1390" Vartype="Byte" Bytesize="1" OffsetHex="0000056E" DisplayMethod="unsigned integer"/>
        <Element Offset="1391" Vartype="String" Bytesize="45" OffsetHex="0000056F" DisplayMethod="unsigned integer"/>
        <Element Offset="1436" Vartype="Byte" Bytesize="1" OffsetHex="0000059C" DisplayMethod="unsigned integer"/>
        <Element Offset="1437" Vartype="String" Bytesize="28" OffsetHex="0000059D" DisplayMethod="unsigned integer"/>
        <Element Offset="1465" Vartype="Byte" Bytesize="1" OffsetHex="000005B9" DisplayMethod="unsigned integer"/>
        <Element Offset="1466" Vartype="String" Bytesize="17" OffsetHex="000005BA" DisplayMethod="unsigned integer"/>
        <Element Offset="1483" Vartype="Byte" Bytesize="1" OffsetHex="000005CB" DisplayMethod="unsigned integer"/>
        <Element Offset="1484" Vartype="String" Bytesize="34" OffsetHex="000005CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1518" Vartype="Byte" Bytesize="1" OffsetHex="000005EE" DisplayMethod="unsigned integer"/>
        <Element Offset="1519" Vartype="String" Bytesize="133" OffsetHex="000005EF" DisplayMethod="unsigned integer"/>
        <Element Offset="1652" Vartype="Byte" Bytesize="1" OffsetHex="00000674" DisplayMethod="unsigned integer"/>
        <Element Offset="1653" Vartype="String" Bytesize="25" OffsetHex="00000675" DisplayMethod="unsigned integer"/>
        <Element Offset="1678" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="0000068E" DisplayMethod="unsigned integer"/>
        <Element Offset="1680" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000690" DisplayMethod="unsigned integer"/>
        <Element Offset="1684" Vartype="String" Bytesize="37" OffsetHex="00000694" DisplayMethod="unsigned integer"/>
        <Element Offset="1721" Vartype="Byte" Bytesize="1" OffsetHex="000006B9" DisplayMethod="unsigned integer"/>
        <Element Offset="1722" Vartype="String" Bytesize="37" OffsetHex="000006BA" DisplayMethod="unsigned integer"/>
        <Element Offset="1759" Vartype="Byte" Bytesize="1" OffsetHex="000006DF" DisplayMethod="unsigned integer"/>
        <Element Offset="1760" Vartype="String" Bytesize="31" OffsetHex="000006E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1791" Vartype="Byte" Bytesize="1" OffsetHex="000006FF" DisplayMethod="unsigned integer"/>
        <Element Offset="1792" Vartype="String" Bytesize="31" OffsetHex="00000700" DisplayMethod="unsigned integer"/>
        <Element Offset="1823" Vartype="Byte" Bytesize="1" OffsetHex="0000071F" DisplayMethod="unsigned integer"/>
        <Element Offset="1824" Vartype="String" Bytesize="31" OffsetHex="00000720" DisplayMethod="unsigned integer"/>
        <Element Offset="1855" Vartype="Byte" Bytesize="1" OffsetHex="0000073F" DisplayMethod="unsigned integer"/>
        <Element Offset="1856" Vartype="String" Bytesize="31" OffsetHex="00000740" DisplayMethod="unsigned integer"/>
        <Element Offset="1887" Vartype="Byte" Bytesize="1" OffsetHex="0000075F" DisplayMethod="unsigned integer"/>
        <Element Offset="1888" Vartype="String" Bytesize="15" OffsetHex="00000760" DisplayMethod="unsigned integer"/>
        <Element Offset="1903" Vartype="Byte" Bytesize="1" OffsetHex="0000076F" DisplayMethod="unsigned integer"/>
        <Element Offset="1904" Vartype="String" Bytesize="23" OffsetHex="00000770" DisplayMethod="unsigned integer"/>
        <Element Offset="1927" Vartype="Byte" Bytesize="1" OffsetHex="00000787" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="String" Bytesize="46" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1974" Vartype="Byte" Bytesize="1" OffsetHex="000007B6" DisplayMethod="unsigned integer"/>
        <Element Offset="1975" Vartype="String" Bytesize="35" OffsetHex="000007B7" DisplayMethod="unsigned integer"/>
        <Element Offset="2010" Vartype="Byte" Bytesize="1" OffsetHex="000007DA" DisplayMethod="unsigned integer"/>
        <Element Offset="2011" Vartype="String" Bytesize="39" OffsetHex="000007DB" DisplayMethod="unsigned integer"/>
        <Element Offset="2050" Vartype="Byte" Bytesize="1" OffsetHex="00000802" DisplayMethod="unsigned integer"/>
        <Element Offset="2051" Vartype="String" Bytesize="28" OffsetHex="00000803" DisplayMethod="unsigned integer"/>
        <Element Offset="2079" Vartype="Byte" Bytesize="1" OffsetHex="0000081F" DisplayMethod="unsigned integer"/>
        <Element Offset="2080" Vartype="String" Bytesize="24" OffsetHex="00000820" DisplayMethod="unsigned integer"/>
        <Element Offset="2104" Vartype="Byte" Bytesize="1" OffsetHex="00000838" DisplayMethod="unsigned integer"/>
        <Element Offset="2105" Vartype="String" Bytesize="15" OffsetHex="00000839" DisplayMethod="unsigned integer"/>
        <Element Offset="2120" Vartype="Byte" Bytesize="1" OffsetHex="00000848" DisplayMethod="unsigned integer"/>
        <Element Offset="2121" Vartype="String" Bytesize="34" OffsetHex="00000849" DisplayMethod="unsigned integer"/>
        <Element Offset="2155" Vartype="Byte" Bytesize="1" OffsetHex="0000086B" DisplayMethod="unsigned integer"/>
        <Element Offset="2156" Vartype="String" Bytesize="97" OffsetHex="0000086C" DisplayMethod="unsigned integer"/>
        <Element Offset="2253" Vartype="Byte" Bytesize="1" OffsetHex="000008CD" DisplayMethod="unsigned integer"/>
        <Element Offset="2254" Vartype="String" Bytesize="25" OffsetHex="000008CE" DisplayMethod="unsigned integer"/>
        <Element Offset="2279" Vartype="Byte" Bytesize="1" OffsetHex="000008E7" DisplayMethod="unsigned integer"/>
        <Element Offset="2280" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2292" Vartype="Pointer" Bytesize="4" OffsetHex="000008F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2296" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008F8" DisplayMethod="hexadecimal"/>
        <Element Offset="2300" Vartype="Pointer" Bytesize="4" OffsetHex="000008FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2304" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000900" DisplayMethod="hexadecimal"/>
        <Element Offset="2308" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000904" DisplayMethod="unsigned integer"/>
        <Element Offset="2320" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000910" DisplayMethod="unsigned integer"/>
        <Element Offset="2328" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000918" DisplayMethod="unsigned integer"/>
        <Element Offset="2340" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000924" DisplayMethod="unsigned integer"/>
        <Element Offset="2348" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="0000092C" DisplayMethod="unsigned integer"/>
        <Element Offset="2360" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000938" DisplayMethod="unsigned integer"/>
        <Element Offset="2368" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000940" DisplayMethod="unsigned integer"/>
        <Element Offset="2380" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000094C" DisplayMethod="unsigned integer"/>
        <Element Offset="2388" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000954" DisplayMethod="unsigned integer"/>
        <Element Offset="2400" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000960" DisplayMethod="unsigned integer"/>
        <Element Offset="2408" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000968" DisplayMethod="unsigned integer"/>
        <Element Offset="2420" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000974" DisplayMethod="unsigned integer"/>
        <Element Offset="2428" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="0000097C" DisplayMethod="unsigned integer"/>
        <Element Offset="2440" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000988" DisplayMethod="unsigned integer"/>
        <Element Offset="2448" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000990" DisplayMethod="unsigned integer"/>
        <Element Offset="2460" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000099C" DisplayMethod="unsigned integer"/>
        <Element Offset="2468" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000009A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2480" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2488" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000009B8" DisplayMethod="unsigned integer"/>
        <Element Offset="2500" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2508" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000009CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2520" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2524" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="000009DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2540" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009EC" DisplayMethod="unsigned integer"/>
        <Element Offset="2548" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000009F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2560" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A00" DisplayMethod="unsigned integer"/>
        <Element Offset="2568" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A08" DisplayMethod="unsigned integer"/>
        <Element Offset="2580" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A14" DisplayMethod="unsigned integer"/>
        <Element Offset="2588" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A1C" DisplayMethod="unsigned integer"/>
        <Element Offset="2600" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A28" DisplayMethod="unsigned integer"/>
        <Element Offset="2608" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A30" DisplayMethod="unsigned integer"/>
        <Element Offset="2620" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2628" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A44" DisplayMethod="unsigned integer"/>
        <Element Offset="2640" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A50" DisplayMethod="unsigned integer"/>
        <Element Offset="2648" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A58" DisplayMethod="unsigned integer"/>
        <Element Offset="2660" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A64" DisplayMethod="unsigned integer"/>
        <Element Offset="2668" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A6C" DisplayMethod="unsigned integer"/>
        <Element Offset="2680" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A78" DisplayMethod="unsigned integer"/>
        <Element Offset="2688" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A80" DisplayMethod="unsigned integer"/>
        <Element Offset="2700" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A8C" DisplayMethod="unsigned integer"/>
        <Element Offset="2708" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A94" DisplayMethod="unsigned integer"/>
        <Element Offset="2720" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000AA0" DisplayMethod="unsigned integer"/>
        <Element Offset="2728" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000AA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2740" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000AB4" DisplayMethod="unsigned integer"/>
        <Element Offset="2748" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000ABC" DisplayMethod="unsigned integer"/>
        <Element Offset="2760" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000AC8" DisplayMethod="unsigned integer"/>
        <Element Offset="2768" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000AD0" DisplayMethod="unsigned integer"/>
        <Element Offset="2780" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000ADC" DisplayMethod="unsigned integer"/>
        <Element Offset="2788" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000AE4" DisplayMethod="unsigned integer"/>
        <Element Offset="2800" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000AF0" DisplayMethod="unsigned integer"/>
        <Element Offset="2808" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000AF8" DisplayMethod="unsigned integer"/>
        <Element Offset="2820" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B04" DisplayMethod="unsigned integer"/>
        <Element Offset="2824" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000B08" DisplayMethod="unsigned integer"/>
        <Element Offset="2840" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B18" DisplayMethod="unsigned integer"/>
        <Element Offset="2848" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000B20" DisplayMethod="unsigned integer"/>
        <Element Offset="2860" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B2C" DisplayMethod="unsigned integer"/>
        <Element Offset="2868" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000B34" DisplayMethod="unsigned integer"/>
        <Element Offset="2880" Vartype="4 Bytes" Bytesize="4" RLECount="304" OffsetHex="00000B40" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="12" Vartype="Double" Bytesize="8" OffsetHex="0000000C" DisplayMethod="unsigned integer"/>
        <Element Offset="20" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000014" DisplayMethod="unsigned integer"/>
        <Element Offset="32" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000020" DisplayMethod="hexadecimal"/>
        <Element Offset="36" Vartype="Double" Bytesize="8" OffsetHex="00000024" DisplayMethod="unsigned integer"/>
        <Element Offset="44" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000002C" DisplayMethod="hexadecimal"/>
        <Element Offset="52" Vartype="Pointer" Bytesize="4" OffsetHex="00000034" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="4 Bytes" Bytesize="4" RLECount="15" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="Float" Bytesize="4" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000078" DisplayMethod="unsigned integer"/>
        <Element Offset="128" Vartype="Float" Bytesize="4" OffsetHex="00000080" DisplayMethod="unsigned integer"/>
        <Element Offset="132" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000084" DisplayMethod="hexadecimal"/>
        <Element Offset="136" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000088" DisplayMethod="unsigned integer"/>
        <Element Offset="140" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000008C" DisplayMethod="hexadecimal"/>
        <Element Offset="144" Vartype="Float" Bytesize="4" RLECount="11" OffsetHex="00000090" DisplayMethod="unsigned integer"/>
        <Element Offset="188" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000000BC" DisplayMethod="unsigned integer"/>
        <Element Offset="192" Vartype="Float" Bytesize="4" RLECount="17" OffsetHex="000000C0" DisplayMethod="unsigned integer"/>
        <Element Offset="260" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000104" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="Float" Bytesize="4" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="Pointer" Bytesize="4" OffsetHex="00000110" DisplayMethod="unsigned integer"/>
        <Element Offset="276" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000114" DisplayMethod="unsigned integer"/>
        <Element Offset="292" Vartype="Pointer" Bytesize="4" RLECount="5" OffsetHex="00000124" DisplayMethod="unsigned integer"/>
        <Element Offset="312" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000138" DisplayMethod="hexadecimal"/>
        <Element Offset="328" Vartype="Pointer" Bytesize="4" OffsetHex="00000148" DisplayMethod="unsigned integer"/>
        <Element Offset="332" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000014C" DisplayMethod="unsigned integer"/>
        <Element Offset="340" Vartype="Double" Bytesize="8" OffsetHex="00000154" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="0000015C" DisplayMethod="unsigned integer"/>
        <Element Offset="384" Vartype="Pointer" Bytesize="4" RLECount="3" OffsetHex="00000180" DisplayMethod="unsigned integer"/>
        <Element Offset="396" Vartype="Float" Bytesize="4" OffsetHex="0000018C" DisplayMethod="unsigned integer"/>
        <Element Offset="400" Vartype="Pointer" Bytesize="4" OffsetHex="00000190" DisplayMethod="unsigned integer"/>
        <Element Offset="404" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000194" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="Float" Bytesize="4" OffsetHex="000001A4" DisplayMethod="unsigned integer"/>
        <Element Offset="424" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000001A8" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="Double" Bytesize="8" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="452" Vartype="Float" Bytesize="4" OffsetHex="000001C4" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001C8" DisplayMethod="unsigned integer"/>
        <Element Offset="460" Vartype="Float" Bytesize="4" OffsetHex="000001CC" DisplayMethod="unsigned integer"/>
        <Element Offset="464" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="000001D0" DisplayMethod="unsigned integer"/>
        <Element Offset="488" Vartype="Pointer" Bytesize="4" RLECount="3" OffsetHex="000001E8" DisplayMethod="unsigned integer"/>
        <Element Offset="500" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001F4" DisplayMethod="unsigned integer"/>
        <Element Offset="504" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001F8" DisplayMethod="hexadecimal"/>
        <Element Offset="508" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000001FC" DisplayMethod="unsigned integer"/>
        <Element Offset="520" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000208" DisplayMethod="hexadecimal"/>
        <Element Offset="524" Vartype="Float" Bytesize="4" OffsetHex="0000020C" DisplayMethod="unsigned integer"/>
        <Element Offset="528" Vartype="Pointer" Bytesize="4" RLECount="4" OffsetHex="00000210" DisplayMethod="unsigned integer"/>
        <Element Offset="544" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000220" DisplayMethod="unsigned integer"/>
        <Element Offset="552" Vartype="Pointer" Bytesize="4" OffsetHex="00000228" DisplayMethod="unsigned integer"/>
        <Element Offset="556" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000022C" DisplayMethod="unsigned integer"/>
        <Element Offset="560" Vartype="Double" Bytesize="8" OffsetHex="00000230" DisplayMethod="unsigned integer"/>
        <Element Offset="568" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000238" DisplayMethod="unsigned integer"/>
        <Element Offset="572" Vartype="Pointer" Bytesize="4" OffsetHex="0000023C" DisplayMethod="unsigned integer"/>
        <Element Offset="576" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="00000240" DisplayMethod="unsigned integer"/>
        <Element Offset="604" Vartype="Pointer" Bytesize="4" OffsetHex="0000025C" DisplayMethod="unsigned integer"/>
        <Element Offset="608" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000260" DisplayMethod="unsigned integer"/>
        <Element Offset="620" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="0000026C" DisplayMethod="unsigned integer"/>
        <Element Offset="622" Vartype="2 Bytes" Bytesize="2" OffsetHex="0000026E" DisplayMethod="unsigned integer"/>
        <Element Offset="624" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000270" DisplayMethod="unsigned integer"/>
        <Element Offset="626" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000272" DisplayMethod="unsigned integer"/>
        <Element Offset="628" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000274" DisplayMethod="unsigned integer"/>
        <Element Offset="640" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000280" DisplayMethod="hexadecimal"/>
        <Element Offset="644" Vartype="Double" Bytesize="8" OffsetHex="00000284" DisplayMethod="unsigned integer"/>
        <Element Offset="652" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000028C" DisplayMethod="hexadecimal"/>
        <Element Offset="660" Vartype="Pointer" Bytesize="4" OffsetHex="00000294" DisplayMethod="unsigned integer"/>
        <Element Offset="664" Vartype="4 Bytes" Bytesize="4" RLECount="15" OffsetHex="00000298" DisplayMethod="unsigned integer"/>
        <Element Offset="724" Vartype="Float" Bytesize="4" OffsetHex="000002D4" DisplayMethod="unsigned integer"/>
        <Element Offset="728" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="000002D8" DisplayMethod="unsigned integer"/>
        <Element Offset="736" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002E0" DisplayMethod="unsigned integer"/>
        <Element Offset="740" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002E4" DisplayMethod="hexadecimal"/>
        <Element Offset="744" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002E8" DisplayMethod="unsigned integer"/>
        <Element Offset="748" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002EC" DisplayMethod="hexadecimal"/>
        <Element Offset="752" Vartype="4 Bytes" Bytesize="4" RLECount="31" OffsetHex="000002F0" DisplayMethod="unsigned integer"/>
        <Element Offset="876" Vartype="Byte" Bytesize="1" OffsetHex="0000036C" DisplayMethod="unsigned integer"/>
        <Element Offset="877" Vartype="String" Bytesize="7" OffsetHex="0000036D" DisplayMethod="unsigned integer"/>
        <Element Offset="884" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000374" DisplayMethod="unsigned integer"/>
        <Element Offset="900" Vartype="Pointer" Bytesize="4" RLECount="5" OffsetHex="00000384" DisplayMethod="unsigned integer"/>
        <Element Offset="920" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000398" DisplayMethod="hexadecimal"/>
        <Element Offset="932" Vartype="Double" Bytesize="8" OffsetHex="000003A4" DisplayMethod="unsigned integer"/>
        <Element Offset="940" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003AC" DisplayMethod="unsigned integer"/>
        <Element Offset="948" Vartype="Double" Bytesize="8" OffsetHex="000003B4" DisplayMethod="unsigned integer"/>
        <Element Offset="956" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="000003BC" DisplayMethod="unsigned integer"/>
        <Element Offset="992" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="000003E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1000" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003E8" DisplayMethod="hexadecimal"/>
        <Element Offset="1004" Vartype="Float" Bytesize="4" OffsetHex="000003EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1008" Vartype="String" Bytesize="5" OffsetHex="000003F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1013" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="000003F5" DisplayMethod="unsigned integer"/>
        <Element Offset="1016" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000003F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1028" Vartype="Float" Bytesize="4" OffsetHex="00000404" DisplayMethod="unsigned integer"/>
        <Element Offset="1032" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000408" DisplayMethod="unsigned integer"/>
        <Element Offset="1052" Vartype="Double" Bytesize="8" OffsetHex="0000041C" DisplayMethod="unsigned integer"/>
        <Element Offset="1060" Vartype="Float" Bytesize="4" OffsetHex="00000424" DisplayMethod="unsigned integer"/>
        <Element Offset="1064" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000428" DisplayMethod="unsigned integer"/>
        <Element Offset="1096" Vartype="Pointer" Bytesize="4" OffsetHex="00000448" DisplayMethod="unsigned integer"/>
        <Element Offset="1100" Vartype="4 Bytes" Bytesize="4" RLECount="151" OffsetHex="0000044C" DisplayMethod="unsigned integer"/>
        <Element Offset="1704" Vartype="Pointer" Bytesize="4" RLECount="3" OffsetHex="000006A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1716" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1720" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006B8" DisplayMethod="hexadecimal"/>
        <Element Offset="1724" Vartype="Pointer" Bytesize="4" OffsetHex="000006BC" Description="Pointer to instance of GeometryHierarchyInst" DisplayMethod="unsigned integer"/>
        <Element Offset="1728" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000006C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1736" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006C8" DisplayMethod="hexadecimal"/>
        <Element Offset="1740" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000006CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1748" Vartype="Pointer" Bytesize="4" OffsetHex="000006D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1752" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1756" Vartype="Pointer" Bytesize="4" OffsetHex="000006DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1760" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000006E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1768" Vartype="Pointer" Bytesize="4" OffsetHex="000006E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1772" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1776" Vartype="Double" Bytesize="8" OffsetHex="000006F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1784" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1788" Vartype="Pointer" Bytesize="4" OffsetHex="000006FC" Description="Pointer to instance of NPC" DisplayMethod="unsigned integer"/>
        <Element Offset="1792" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000700" DisplayMethod="unsigned integer"/>
        <Element Offset="1808" Vartype="Pointer" Bytesize="4" OffsetHex="00000710" Description="Pointer to instance of Sentence" DisplayMethod="unsigned integer"/>
        <Element Offset="1812" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000714" DisplayMethod="unsigned integer"/>
        <Element Offset="1820" Vartype="Pointer" Bytesize="4" OffsetHex="0000071C" DisplayMethod="unsigned integer"/>
        <Element Offset="1824" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000720" DisplayMethod="unsigned integer"/>
        <Element Offset="1836" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000072C" DisplayMethod="hexadecimal"/>
        <Element Offset="1844" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000734" DisplayMethod="unsigned integer"/>
        <Element Offset="1856" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000740" DisplayMethod="hexadecimal"/>
        <Element Offset="1860" Vartype="Double" Bytesize="8" OffsetHex="00000744" DisplayMethod="unsigned integer"/>
        <Element Offset="1868" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000074C" DisplayMethod="hexadecimal"/>
        <Element Offset="1876" Vartype="Pointer" Bytesize="4" OffsetHex="00000754" DisplayMethod="unsigned integer"/>
        <Element Offset="1880" Vartype="Pointer" Bytesize="4" OffsetHex="00000758" Description="Pointer to instance of MotionImplDummy" DisplayMethod="unsigned integer"/>
        <Element Offset="1884" Vartype="4 Bytes" Bytesize="4" RLECount="14" OffsetHex="0000075C" DisplayMethod="unsigned integer"/>
        <Element Offset="1940" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000794" DisplayMethod="unsigned integer"/>
        <Element Offset="1948" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000079C" DisplayMethod="unsigned integer"/>
        <Element Offset="1952" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1956" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007A4" DisplayMethod="hexadecimal"/>
        <Element Offset="1960" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1964" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007AC" DisplayMethod="hexadecimal"/>
        <Element Offset="1968" Vartype="4 Bytes" Bytesize="4" RLECount="32" OffsetHex="000007B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2096" Vartype="Pointer" Bytesize="4" OffsetHex="00000830" DisplayMethod="unsigned integer"/>
        <Element Offset="2100" Vartype="Pointer" Bytesize="4" OffsetHex="00000834" Description="Pointer to instance of NPCClub" DisplayMethod="unsigned integer"/>
        <Element Offset="2104" Vartype="Pointer" Bytesize="4" OffsetHex="00000838" Description="Pointer to instance of NPCFirearm" DisplayMethod="unsigned integer"/>
        <Element Offset="2108" Vartype="Pointer" Bytesize="4" OffsetHex="0000083C" Description="Pointer to instance of NPCPrefs" DisplayMethod="unsigned integer"/>
        <Element Offset="2112" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000840" DisplayMethod="unsigned integer"/>
        <Element Offset="2116" Vartype="Pointer" Bytesize="4" RLECount="5" OffsetHex="00000844" DisplayMethod="unsigned integer"/>
        <Element Offset="2136" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000858" DisplayMethod="hexadecimal"/>
        <Element Offset="2148" Vartype="Double" Bytesize="8" OffsetHex="00000864" DisplayMethod="unsigned integer"/>
        <Element Offset="2156" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000086C" DisplayMethod="unsigned integer"/>
        <Element Offset="2164" Vartype="Double" Bytesize="8" OffsetHex="00000874" DisplayMethod="unsigned integer"/>
        <Element Offset="2172" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="0000087C" DisplayMethod="unsigned integer"/>
        <Element Offset="2212" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="000008A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2220" Vartype="Double" Bytesize="8" OffsetHex="000008AC" DisplayMethod="unsigned integer"/>
        <Element Offset="2228" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000008B4" DisplayMethod="unsigned integer"/>
        <Element Offset="2244" Vartype="Float" Bytesize="4" OffsetHex="000008C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2248" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2260" Vartype="Pointer" Bytesize="4" OffsetHex="000008D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2264" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2268" Vartype="Double" Bytesize="8" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2276" Vartype="Float" Bytesize="4" OffsetHex="000008E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2280" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="000008E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2312" Vartype="Pointer" Bytesize="4" RLECount="4" OffsetHex="00000908" DisplayMethod="unsigned integer"/>
        <Element Offset="2328" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000918" DisplayMethod="hexadecimal"/>
        <Element Offset="2332" Vartype="Pointer" Bytesize="4" OffsetHex="0000091C" Description="Pointer to instance of GeometryHierarchyInst" DisplayMethod="unsigned integer"/>
        <Element Offset="2336" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000920" DisplayMethod="unsigned integer"/>
        <Element Offset="2344" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000928" DisplayMethod="hexadecimal"/>
        <Element Offset="2348" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="0000092C" DisplayMethod="unsigned integer"/>
        <Element Offset="2356" Vartype="Pointer" Bytesize="4" OffsetHex="00000934" DisplayMethod="unsigned integer"/>
        <Element Offset="2360" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000938" DisplayMethod="unsigned integer"/>
        <Element Offset="2364" Vartype="Pointer" Bytesize="4" OffsetHex="0000093C" DisplayMethod="unsigned integer"/>
        <Element Offset="2368" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000940" DisplayMethod="unsigned integer"/>
        <Element Offset="2376" Vartype="Pointer" Bytesize="4" OffsetHex="00000948" DisplayMethod="unsigned integer"/>
        <Element Offset="2380" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000094C" DisplayMethod="unsigned integer"/>
        <Element Offset="2384" Vartype="Double" Bytesize="8" OffsetHex="00000950" DisplayMethod="unsigned integer"/>
        <Element Offset="2392" Vartype="Pointer" Bytesize="4" OffsetHex="00000958" DisplayMethod="unsigned integer"/>
        <Element Offset="2396" Vartype="Pointer" Bytesize="4" OffsetHex="0000095C" Description="Pointer to instance of NPC" DisplayMethod="unsigned integer"/>
        <Element Offset="2400" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000960" DisplayMethod="unsigned integer"/>
        <Element Offset="2416" Vartype="Pointer" Bytesize="4" OffsetHex="00000970" Description="Pointer to instance of Sentence" DisplayMethod="unsigned integer"/>
        <Element Offset="2420" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000974" DisplayMethod="unsigned integer"/>
        <Element Offset="2428" Vartype="Pointer" Bytesize="4" OffsetHex="0000097C" DisplayMethod="unsigned integer"/>
        <Element Offset="2432" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000980" DisplayMethod="unsigned integer"/>
        <Element Offset="2444" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000098C" DisplayMethod="hexadecimal"/>
        <Element Offset="2452" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000994" DisplayMethod="unsigned integer"/>
        <Element Offset="2464" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009A0" DisplayMethod="hexadecimal"/>
        <Element Offset="2468" Vartype="Double" Bytesize="8" OffsetHex="000009A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2476" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009AC" DisplayMethod="hexadecimal"/>
        <Element Offset="2484" Vartype="Pointer" Bytesize="4" OffsetHex="000009B4" DisplayMethod="unsigned integer"/>
        <Element Offset="2488" Vartype="Pointer" Bytesize="4" OffsetHex="000009B8" Description="Pointer to instance of MotionImplDummy" DisplayMethod="unsigned integer"/>
        <Element Offset="2492" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="000009BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2544" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="000009F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2552" Vartype="Float" Bytesize="4" OffsetHex="000009F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2556" Vartype="Pointer" Bytesize="4" OffsetHex="000009FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2560" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A00" DisplayMethod="unsigned integer"/>
        <Element Offset="2564" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A04" DisplayMethod="hexadecimal"/>
        <Element Offset="2568" Vartype="Pointer" Bytesize="4" OffsetHex="00000A08" DisplayMethod="unsigned integer"/>
        <Element Offset="2572" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2576" Vartype="Double" Bytesize="8" OffsetHex="00000A10" DisplayMethod="unsigned integer"/>
        <Element Offset="2584" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000A18" DisplayMethod="unsigned integer"/>
        <Element Offset="2592" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A20" DisplayMethod="unsigned integer"/>
        <Element Offset="2600" Vartype="Pointer" Bytesize="4" OffsetHex="00000A28" DisplayMethod="unsigned integer"/>
        <Element Offset="2604" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000A2C" DisplayMethod="unsigned integer"/>
        <Element Offset="2616" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A38" DisplayMethod="unsigned integer"/>
        <Element Offset="2628" Vartype="String" Bytesize="4" OffsetHex="00000A44" DisplayMethod="unsigned integer"/>
        <Element Offset="2632" Vartype="Pointer" Bytesize="4" OffsetHex="00000A48" DisplayMethod="unsigned integer"/>
        <Element Offset="2636" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2644" Vartype="Float" Bytesize="4" OffsetHex="00000A54" DisplayMethod="unsigned integer"/>
        <Element Offset="2648" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A58" DisplayMethod="unsigned integer"/>
        <Element Offset="2652" Vartype="Double" Bytesize="8" OffsetHex="00000A5C" DisplayMethod="unsigned integer"/>
        <Element Offset="2660" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000A64" DisplayMethod="unsigned integer"/>
        <Element Offset="2668" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A6C" DisplayMethod="unsigned integer"/>
        <Element Offset="2676" Vartype="Pointer" Bytesize="4" OffsetHex="00000A74" DisplayMethod="unsigned integer"/>
        <Element Offset="2680" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000A78" DisplayMethod="unsigned integer"/>
        <Element Offset="2704" Vartype="Pointer" Bytesize="4" OffsetHex="00000A90" DisplayMethod="unsigned integer"/>
        <Element Offset="2708" Vartype="Pointer" Bytesize="4" OffsetHex="00000A94" Description="Pointer to instance of NPCClub" DisplayMethod="unsigned integer"/>
        <Element Offset="2712" Vartype="Pointer" Bytesize="4" OffsetHex="00000A98" Description="Pointer to instance of NPCFirearm" DisplayMethod="unsigned integer"/>
        <Element Offset="2716" Vartype="Pointer" Bytesize="4" OffsetHex="00000A9C" Description="Pointer to instance of NPCPrefs" DisplayMethod="unsigned integer"/>
        <Element Offset="2720" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AA0" DisplayMethod="unsigned integer"/>
        <Element Offset="2724" Vartype="Pointer" Bytesize="4" RLECount="5" OffsetHex="00000AA4" DisplayMethod="unsigned integer"/>
        <Element Offset="2744" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000AB8" DisplayMethod="hexadecimal"/>
        <Element Offset="2756" Vartype="Double" Bytesize="8" OffsetHex="00000AC4" DisplayMethod="unsigned integer"/>
        <Element Offset="2764" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000ACC" DisplayMethod="unsigned integer"/>
        <Element Offset="2772" Vartype="Double" Bytesize="8" OffsetHex="00000AD4" DisplayMethod="unsigned integer"/>
        <Element Offset="2780" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000ADC" DisplayMethod="unsigned integer"/>
        <Element Offset="2820" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000B04" DisplayMethod="unsigned integer"/>
        <Element Offset="2828" Vartype="Double" Bytesize="8" OffsetHex="00000B0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2836" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000B14" DisplayMethod="unsigned integer"/>
        <Element Offset="2852" Vartype="Float" Bytesize="4" OffsetHex="00000B24" DisplayMethod="unsigned integer"/>
        <Element Offset="2856" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000B28" DisplayMethod="unsigned integer"/>
        <Element Offset="2868" Vartype="Pointer" Bytesize="4" OffsetHex="00000B34" DisplayMethod="unsigned integer"/>
        <Element Offset="2872" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B38" DisplayMethod="unsigned integer"/>
        <Element Offset="2876" Vartype="Double" Bytesize="8" OffsetHex="00000B3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2884" Vartype="Float" Bytesize="4" OffsetHex="00000B44" DisplayMethod="unsigned integer"/>
        <Element Offset="2888" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000B48" DisplayMethod="unsigned integer"/>
        <Element Offset="2920" Vartype="Pointer" Bytesize="4" OffsetHex="00000B68" DisplayMethod="unsigned integer"/>
        <Element Offset="2924" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B6C" DisplayMethod="hexadecimal"/>
        <Element Offset="2932" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B74" DisplayMethod="unsigned integer"/>
        <Element Offset="2936" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B78" DisplayMethod="hexadecimal"/>
        <Element Offset="2940" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B7C" DisplayMethod="unsigned integer"/>
        <Element Offset="2944" Vartype="4 Bytes" Bytesize="4" RLECount="144" OffsetHex="00000B80" DisplayMethod="hexadecimal"/>
        <Element Offset="3520" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3528" Vartype="Pointer" Bytesize="4" RLECount="3" OffsetHex="00000DC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3540" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000DD4" DisplayMethod="unsigned integer"/>
        <Element Offset="3552" Vartype="Float" Bytesize="4" OffsetHex="00000DE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3556" Vartype="Pointer" Bytesize="4" OffsetHex="00000DE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3560" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000DE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3576" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000DF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3588" Vartype="Float" Bytesize="4" OffsetHex="00000E04" DisplayMethod="unsigned integer"/>
        <Element Offset="3592" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000E08" DisplayMethod="unsigned integer"/>
        <Element Offset="3600" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E10" DisplayMethod="unsigned integer"/>
        <Element Offset="3612" Vartype="Float" Bytesize="4" OffsetHex="00000E1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3616" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000E20" DisplayMethod="unsigned integer"/>
        <Element Offset="3624" Vartype="Byte" Bytesize="1" OffsetHex="00000E28" DisplayMethod="unsigned integer"/>
        <Element Offset="3625" Vartype="String" Bytesize="4" OffsetHex="00000E29" DisplayMethod="unsigned integer"/>
        <Element Offset="3629" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E2D" DisplayMethod="unsigned integer"/>
        <Element Offset="3632" Vartype="Pointer" Bytesize="4" OffsetHex="00000E30" DisplayMethod="unsigned integer"/>
        <Element Offset="3636" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E34" DisplayMethod="unsigned integer"/>
        <Element Offset="3648" Vartype="Float" Bytesize="4" OffsetHex="00000E40" DisplayMethod="unsigned integer"/>
        <Element Offset="3652" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000E44" DisplayMethod="unsigned integer"/>
        <Element Offset="3660" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3672" Vartype="Float" Bytesize="4" OffsetHex="00000E58" DisplayMethod="unsigned integer"/>
        <Element Offset="3676" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000E5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3684" Vartype="Float" Bytesize="4" OffsetHex="00000E64" DisplayMethod="unsigned integer"/>
        <Element Offset="3688" Vartype="Double" Bytesize="8" OffsetHex="00000E68" DisplayMethod="unsigned integer"/>
        <Element Offset="3696" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E70" DisplayMethod="unsigned integer"/>
        <Element Offset="3708" Vartype="Float" Bytesize="4" OffsetHex="00000E7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3712" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000E80" DisplayMethod="unsigned integer"/>
        <Element Offset="3720" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E88" DisplayMethod="unsigned integer"/>
        <Element Offset="3732" Vartype="Float" Bytesize="4" OffsetHex="00000E94" DisplayMethod="unsigned integer"/>
        <Element Offset="3736" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000E98" DisplayMethod="unsigned integer"/>
        <Element Offset="3744" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000EA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3752" Vartype="Pointer" Bytesize="4" OffsetHex="00000EA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3756" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3768" Vartype="Float" Bytesize="4" OffsetHex="00000EB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3772" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000EBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3780" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3792" Vartype="Float" Bytesize="4" OffsetHex="00000ED0" DisplayMethod="unsigned integer"/>
        <Element Offset="3796" Vartype="Pointer" Bytesize="4" OffsetHex="00000ED4" DisplayMethod="unsigned integer"/>
        <Element Offset="3800" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000ED8" DisplayMethod="unsigned integer"/>
        <Element Offset="3812" Vartype="Pointer" Bytesize="4" OffsetHex="00000EE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3816" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000EE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3820" Vartype="Double" Bytesize="8" OffsetHex="00000EEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3828" Vartype="Float" Bytesize="4" OffsetHex="00000EF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3832" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000EF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3840" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F00" DisplayMethod="unsigned integer"/>
        <Element Offset="3852" Vartype="Float" Bytesize="4" OffsetHex="00000F0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3856" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000F10" DisplayMethod="unsigned integer"/>
        <Element Offset="3864" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F18" DisplayMethod="unsigned integer"/>
        <Element Offset="3876" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F24" DisplayMethod="unsigned integer"/>
        <Element Offset="3888" Vartype="Float" Bytesize="4" OffsetHex="00000F30" DisplayMethod="unsigned integer"/>
        <Element Offset="3892" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000F34" DisplayMethod="unsigned integer"/>
        <Element Offset="3900" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3912" Vartype="Float" Bytesize="4" OffsetHex="00000F48" DisplayMethod="unsigned integer"/>
        <Element Offset="3916" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000F4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3924" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F54" DisplayMethod="unsigned integer"/>
        <Element Offset="3936" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F60" DisplayMethod="unsigned integer"/>
        <Element Offset="3948" Vartype="Float" Bytesize="4" OffsetHex="00000F6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3952" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000F70" DisplayMethod="unsigned integer"/>
        <Element Offset="3960" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F78" DisplayMethod="unsigned integer"/>
        <Element Offset="3972" Vartype="Float" Bytesize="4" OffsetHex="00000F84" DisplayMethod="unsigned integer"/>
        <Element Offset="3976" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000F88" DisplayMethod="unsigned integer"/>
        <Element Offset="3984" Vartype="Float" Bytesize="4" OffsetHex="00000F90" DisplayMethod="unsigned integer"/>
        <Element Offset="3988" Vartype="Pointer" Bytesize="4" OffsetHex="00000F94" DisplayMethod="unsigned integer"/>
        <Element Offset="3992" Vartype="Float" Bytesize="4" OffsetHex="00000F98" DisplayMethod="unsigned integer"/>
        <Element Offset="3996" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F9C" DisplayMethod="unsigned integer"/>
        <Element Offset="4008" Vartype="Float" Bytesize="4" OffsetHex="00000FA8" DisplayMethod="unsigned integer"/>
        <Element Offset="4012" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000FAC" DisplayMethod="unsigned integer"/>
        <Element Offset="4020" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000FB4" DisplayMethod="unsigned integer"/>
        <Element Offset="4032" Vartype="Float" Bytesize="4" OffsetHex="00000FC0" DisplayMethod="unsigned integer"/>
        <Element Offset="4036" Vartype="Pointer" Bytesize="4" OffsetHex="00000FC4" DisplayMethod="unsigned integer"/>
        <Element Offset="4040" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000FC8" DisplayMethod="unsigned integer"/>
        <Element Offset="4056" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000FD8" DisplayMethod="unsigned integer"/>
        <Element Offset="4068" Vartype="Float" Bytesize="4" OffsetHex="00000FE4" DisplayMethod="unsigned integer"/>
        <Element Offset="4072" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000FE8" DisplayMethod="unsigned integer"/>
        <Element Offset="4080" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000FF0" DisplayMethod="unsigned integer"/>
        <Element Offset="4092" Vartype="Float" Bytesize="4" OffsetHex="00000FFC" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="12" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000000C" DisplayMethod="hexadecimal"/>
        <Element Offset="20" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000014" DisplayMethod="unsigned integer"/>
        <Element Offset="32" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000020" DisplayMethod="hexadecimal"/>
        <Element Offset="36" Vartype="Double" Bytesize="8" OffsetHex="00000024" DisplayMethod="unsigned integer"/>
        <Element Offset="44" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000002C" DisplayMethod="hexadecimal"/>
        <Element Offset="52" Vartype="Pointer" Bytesize="4" OffsetHex="00000034" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="Pointer" Bytesize="4" OffsetHex="00000038" Description="Pointer to instance of MotionImpl" DisplayMethod="unsigned integer"/>
        <Element Offset="60" Vartype="Pointer" Bytesize="4" OffsetHex="0000003C" Description="Pointer to instance of MindDead" DisplayMethod="unsigned integer"/>
        <Element Offset="64" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000040" DisplayMethod="unsigned integer"/>
        <Element Offset="76" Vartype="Pointer" Bytesize="4" OffsetHex="0000004C" Description="Pointer to instance of JobWaitForIdle" DisplayMethod="unsigned integer"/>
        <Element Offset="80" Vartype="Pointer" Bytesize="4" OffsetHex="00000050" Description="Pointer to instance of ShortGoalWaitForAIMotion" DisplayMethod="unsigned integer"/>
        <Element Offset="84" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000054" DisplayMethod="unsigned integer"/>
        <Element Offset="100" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000064" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000006C" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="Float" Bytesize="4" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000078" DisplayMethod="unsigned integer"/>
        <Element Offset="128" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000080" DisplayMethod="unsigned integer"/>
        <Element Offset="140" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000008C" DisplayMethod="hexadecimal"/>
        <Element Offset="144" Vartype="4 Bytes" Bytesize="4" RLECount="31" OffsetHex="00000090" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="276" Vartype="Pointer" Bytesize="4" OffsetHex="00000114" Description="Pointer to instance of NPCClub" DisplayMethod="unsigned integer"/>
        <Element Offset="280" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000118" DisplayMethod="unsigned integer"/>
        <Element Offset="284" Vartype="Pointer" Bytesize="4" OffsetHex="0000011C" Description="Pointer to instance of NPCPrefs" DisplayMethod="unsigned integer"/>
        <Element Offset="288" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000120" DisplayMethod="unsigned integer"/>
        <Element Offset="292" Vartype="Pointer" Bytesize="4" RLECount="5" OffsetHex="00000124" DisplayMethod="unsigned integer"/>
        <Element Offset="312" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000138" DisplayMethod="hexadecimal"/>
        <Element Offset="324" Vartype="Double" Bytesize="8" OffsetHex="00000144" DisplayMethod="unsigned integer"/>
        <Element Offset="332" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000014C" DisplayMethod="unsigned integer"/>
        <Element Offset="340" Vartype="Double" Bytesize="8" OffsetHex="00000154" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="Pointer" Bytesize="4" OffsetHex="0000015C" DisplayMethod="unsigned integer"/>
        <Element Offset="352" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000160" DisplayMethod="unsigned integer"/>
        <Element Offset="388" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000184" DisplayMethod="unsigned integer"/>
        <Element Offset="396" Vartype="Double" Bytesize="8" OffsetHex="0000018C" DisplayMethod="unsigned integer"/>
        <Element Offset="404" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000194" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="Float" Bytesize="4" OffsetHex="000001A4" DisplayMethod="unsigned integer"/>
        <Element Offset="424" Vartype="Pointer" Bytesize="4" OffsetHex="000001A8" DisplayMethod="unsigned integer"/>
        <Element Offset="428" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001AC" DisplayMethod="unsigned integer"/>
        <Element Offset="436" Vartype="Pointer" Bytesize="4" OffsetHex="000001B4" DisplayMethod="unsigned integer"/>
        <Element Offset="440" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001B8" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="Double" Bytesize="8" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="452" Vartype="Float" Bytesize="4" OffsetHex="000001C4" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="000001C8" DisplayMethod="unsigned integer"/>
        <Element Offset="488" Vartype="Pointer" Bytesize="4" RLECount="3" OffsetHex="000001E8" DisplayMethod="unsigned integer"/>
        <Element Offset="500" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001F4" DisplayMethod="unsigned integer"/>
        <Element Offset="504" Vartype="Float" Bytesize="4" OffsetHex="000001F8" DisplayMethod="unsigned integer"/>
        <Element Offset="508" Vartype="Pointer" Bytesize="4" OffsetHex="000001FC" Description="Pointer to instance of GeometryHierarchyInst" DisplayMethod="unsigned integer"/>
        <Element Offset="512" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000200" DisplayMethod="unsigned integer"/>
        <Element Offset="520" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000208" DisplayMethod="hexadecimal"/>
        <Element Offset="524" Vartype="Float" Bytesize="4" OffsetHex="0000020C" DisplayMethod="unsigned integer"/>
        <Element Offset="528" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000210" DisplayMethod="unsigned integer"/>
        <Element Offset="532" Vartype="Pointer" Bytesize="4" OffsetHex="00000214" DisplayMethod="unsigned integer"/>
        <Element Offset="536" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000218" DisplayMethod="unsigned integer"/>
        <Element Offset="540" Vartype="Pointer" Bytesize="4" OffsetHex="0000021C" DisplayMethod="unsigned integer"/>
        <Element Offset="544" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000220" DisplayMethod="unsigned integer"/>
        <Element Offset="552" Vartype="Pointer" Bytesize="4" OffsetHex="00000228" DisplayMethod="unsigned integer"/>
        <Element Offset="556" Vartype="Float" Bytesize="4" OffsetHex="0000022C" DisplayMethod="unsigned integer"/>
        <Element Offset="560" Vartype="Double" Bytesize="8" OffsetHex="00000230" DisplayMethod="unsigned integer"/>
        <Element Offset="568" Vartype="Float" Bytesize="4" OffsetHex="00000238" DisplayMethod="unsigned integer"/>
        <Element Offset="572" Vartype="Pointer" Bytesize="4" OffsetHex="0000023C" Description="Pointer to instance of NPC" DisplayMethod="unsigned integer"/>
        <Element Offset="576" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000240" DisplayMethod="unsigned integer"/>
        <Element Offset="592" Vartype="Pointer" Bytesize="4" OffsetHex="00000250" Description="Pointer to instance of Sentence" DisplayMethod="unsigned integer"/>
        <Element Offset="596" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000254" DisplayMethod="unsigned integer"/>
        <Element Offset="604" Vartype="Pointer" Bytesize="4" OffsetHex="0000025C" DisplayMethod="unsigned integer"/>
        <Element Offset="608" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000260" DisplayMethod="unsigned integer"/>
        <Element Offset="620" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000026C" DisplayMethod="hexadecimal"/>
        <Element Offset="628" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000274" DisplayMethod="unsigned integer"/>
        <Element Offset="640" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000280" DisplayMethod="hexadecimal"/>
        <Element Offset="644" Vartype="Double" Bytesize="8" OffsetHex="00000284" DisplayMethod="unsigned integer"/>
        <Element Offset="652" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000028C" DisplayMethod="hexadecimal"/>
        <Element Offset="660" Vartype="Pointer" Bytesize="4" OffsetHex="00000294" DisplayMethod="unsigned integer"/>
        <Element Offset="664" Vartype="Pointer" Bytesize="4" OffsetHex="00000298" Description="Pointer to instance of MotionImplDummy" DisplayMethod="unsigned integer"/>
        <Element Offset="668" Vartype="4 Bytes" Bytesize="4" RLECount="14" OffsetHex="0000029C" DisplayMethod="unsigned integer"/>
        <Element Offset="724" Vartype="Float" Bytesize="4" OffsetHex="000002D4" DisplayMethod="unsigned integer"/>
        <Element Offset="728" Vartype="Byte" Bytesize="1" RLECount="8" OffsetHex="000002D8" DisplayMethod="unsigned integer"/>
        <Element Offset="736" Vartype="Pointer" Bytesize="4" OffsetHex="000002E0" DisplayMethod="unsigned integer"/>
        <Element Offset="740" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002E4" DisplayMethod="hexadecimal"/>
        <Element Offset="744" Vartype="Float" Bytesize="4" RLECount="13" OffsetHex="000002E8" DisplayMethod="unsigned integer"/>
        <Element Offset="796" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000031C" DisplayMethod="unsigned integer"/>
        <Element Offset="800" Vartype="Float" Bytesize="4" RLECount="17" OffsetHex="00000320" DisplayMethod="unsigned integer"/>
        <Element Offset="868" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000364" DisplayMethod="unsigned integer"/>
        <Element Offset="880" Vartype="Pointer" Bytesize="4" OffsetHex="00000370" DisplayMethod="unsigned integer"/>
        <Element Offset="884" Vartype="Pointer" Bytesize="4" OffsetHex="00000374" Description="Pointer to instance of NPCClub" DisplayMethod="unsigned integer"/>
        <Element Offset="888" Vartype="Pointer" Bytesize="4" OffsetHex="00000378" Description="Pointer to instance of NPCFirearm" DisplayMethod="unsigned integer"/>
        <Element Offset="892" Vartype="Pointer" Bytesize="4" OffsetHex="0000037C" Description="Pointer to instance of NPCPrefs" DisplayMethod="unsigned integer"/>
        <Element Offset="896" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000380" DisplayMethod="unsigned integer"/>
        <Element Offset="900" Vartype="Pointer" Bytesize="4" RLECount="5" OffsetHex="00000384" DisplayMethod="unsigned integer"/>
        <Element Offset="920" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000398" DisplayMethod="hexadecimal"/>
        <Element Offset="936" Vartype="Pointer" Bytesize="4" OffsetHex="000003A8" DisplayMethod="unsigned integer"/>
        <Element Offset="940" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003AC" DisplayMethod="unsigned integer"/>
        <Element Offset="948" Vartype="Double" Bytesize="8" OffsetHex="000003B4" DisplayMethod="unsigned integer"/>
        <Element Offset="956" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="000003BC" DisplayMethod="unsigned integer"/>
        <Element Offset="996" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="000003E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1004" Vartype="Double" Bytesize="8" OffsetHex="000003EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1012" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000003F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1028" Vartype="Float" Bytesize="4" OffsetHex="00000404" DisplayMethod="unsigned integer"/>
        <Element Offset="1032" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000408" DisplayMethod="unsigned integer"/>
        <Element Offset="1044" Vartype="Pointer" Bytesize="4" OffsetHex="00000414" DisplayMethod="unsigned integer"/>
        <Element Offset="1048" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000418" DisplayMethod="unsigned integer"/>
        <Element Offset="1052" Vartype="Double" Bytesize="8" OffsetHex="0000041C" DisplayMethod="unsigned integer"/>
        <Element Offset="1060" Vartype="Float" Bytesize="4" OffsetHex="00000424" DisplayMethod="unsigned integer"/>
        <Element Offset="1064" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000428" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="Pointer" Bytesize="4" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1096" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000448" DisplayMethod="unsigned integer"/>
        <Element Offset="1104" Vartype="Float" Bytesize="4" OffsetHex="00000450" DisplayMethod="unsigned integer"/>
        <Element Offset="1108" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000454" DisplayMethod="unsigned integer"/>
        <Element Offset="1120" Vartype="Float" Bytesize="4" OffsetHex="00000460" DisplayMethod="unsigned integer"/>
        <Element Offset="1124" Vartype="Pointer" Bytesize="4" OffsetHex="00000464" DisplayMethod="unsigned integer"/>
        <Element Offset="1128" Vartype="Float" Bytesize="4" OffsetHex="00000468" DisplayMethod="unsigned integer"/>
        <Element Offset="1132" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000046C" DisplayMethod="unsigned integer"/>
        <Element Offset="1136" Vartype="Double" Bytesize="8" OffsetHex="00000470" DisplayMethod="unsigned integer"/>
        <Element Offset="1144" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000478" DisplayMethod="unsigned integer"/>
        <Element Offset="1156" Vartype="Float" Bytesize="4" OffsetHex="00000484" DisplayMethod="unsigned integer"/>
        <Element Offset="1160" Vartype="Pointer" Bytesize="4" OffsetHex="00000488" DisplayMethod="unsigned integer"/>
        <Element Offset="1164" Vartype="Float" Bytesize="4" OffsetHex="0000048C" DisplayMethod="unsigned integer"/>
        <Element Offset="1168" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000490" DisplayMethod="unsigned integer"/>
        <Element Offset="1180" Vartype="Float" Bytesize="4" OffsetHex="0000049C" DisplayMethod="unsigned integer"/>
        <Element Offset="1184" Vartype="Pointer" Bytesize="4" OffsetHex="000004A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1188" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000004A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1200" Vartype="Pointer" Bytesize="4" OffsetHex="000004B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1204" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000004B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1216" Vartype="Float" Bytesize="4" OffsetHex="000004C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1220" Vartype="Pointer" Bytesize="4" OffsetHex="000004C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1224" Vartype="Float" Bytesize="4" OffsetHex="000004C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1228" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000004CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1240" Vartype="Float" Bytesize="4" OffsetHex="000004D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1244" Vartype="Pointer" Bytesize="4" OffsetHex="000004DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1248" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="000004E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1264" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000004F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1276" Vartype="Float" Bytesize="4" OffsetHex="000004FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1280" Vartype="Pointer" Bytesize="4" OffsetHex="00000500" DisplayMethod="unsigned integer"/>
        <Element Offset="1284" Vartype="Float" Bytesize="4" OffsetHex="00000504" DisplayMethod="unsigned integer"/>
        <Element Offset="1288" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000508" DisplayMethod="unsigned integer"/>
        <Element Offset="1300" Vartype="Float" Bytesize="4" OffsetHex="00000514" DisplayMethod="unsigned integer"/>
        <Element Offset="1304" Vartype="Pointer" Bytesize="4" OffsetHex="00000518" DisplayMethod="unsigned integer"/>
        <Element Offset="1308" Vartype="Float" Bytesize="4" OffsetHex="0000051C" DisplayMethod="unsigned integer"/>
        <Element Offset="1312" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000520" DisplayMethod="unsigned integer"/>
        <Element Offset="1316" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000524" DisplayMethod="unsigned integer"/>
        <Element Offset="1324" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000052C" DisplayMethod="unsigned integer"/>
        <Element Offset="1336" Vartype="Float" Bytesize="4" OffsetHex="00000538" DisplayMethod="unsigned integer"/>
        <Element Offset="1340" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="0000053C" DisplayMethod="unsigned integer"/>
        <Element Offset="1348" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000544" DisplayMethod="unsigned integer"/>
        <Element Offset="1360" Vartype="Float" Bytesize="4" OffsetHex="00000550" DisplayMethod="unsigned integer"/>
        <Element Offset="1364" Vartype="Pointer" Bytesize="4" OffsetHex="00000554" DisplayMethod="unsigned integer"/>
        <Element Offset="1368" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000558" DisplayMethod="unsigned integer"/>
        <Element Offset="1380" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000564" DisplayMethod="unsigned integer"/>
        <Element Offset="1384" Vartype="Double" Bytesize="8" OffsetHex="00000568" DisplayMethod="unsigned integer"/>
        <Element Offset="1392" Vartype="Pointer" Bytesize="4" OffsetHex="00000570" DisplayMethod="unsigned integer"/>
        <Element Offset="1396" Vartype="Float" Bytesize="4" OffsetHex="00000574" DisplayMethod="unsigned integer"/>
        <Element Offset="1400" Vartype="Pointer" Bytesize="4" OffsetHex="00000578" DisplayMethod="unsigned integer"/>
        <Element Offset="1404" Vartype="Float" Bytesize="4" OffsetHex="0000057C" DisplayMethod="unsigned integer"/>
        <Element Offset="1408" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000580" DisplayMethod="unsigned integer"/>
        <Element Offset="1420" Vartype="Float" Bytesize="4" OffsetHex="0000058C" DisplayMethod="unsigned integer"/>
        <Element Offset="1424" Vartype="Pointer" Bytesize="4" OffsetHex="00000590" DisplayMethod="unsigned integer"/>
        <Element Offset="1428" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000594" DisplayMethod="unsigned integer"/>
        <Element Offset="1444" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000005A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1456" Vartype="Float" Bytesize="4" OffsetHex="000005B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1460" Vartype="Pointer" Bytesize="4" OffsetHex="000005B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1464" Vartype="Float" Bytesize="4" OffsetHex="000005B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1468" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000005BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1480" Vartype="Float" Bytesize="4" OffsetHex="000005C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1484" Vartype="Pointer" Bytesize="4" OffsetHex="000005CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1488" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="000005D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1504" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000005E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1516" Vartype="Float" Bytesize="4" OffsetHex="000005EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1520" Vartype="Pointer" Bytesize="4" OffsetHex="000005F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1524" Vartype="Float" Bytesize="4" OffsetHex="000005F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1528" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000005F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1540" Vartype="Float" Bytesize="4" OffsetHex="00000604" DisplayMethod="unsigned integer"/>
        <Element Offset="1544" Vartype="Pointer" Bytesize="4" OffsetHex="00000608" DisplayMethod="unsigned integer"/>
        <Element Offset="1548" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="0000060C" DisplayMethod="unsigned integer"/>
        <Element Offset="1564" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000061C" DisplayMethod="unsigned integer"/>
        <Element Offset="1576" Vartype="Float" Bytesize="4" OffsetHex="00000628" DisplayMethod="unsigned integer"/>
        <Element Offset="1580" Vartype="Pointer" Bytesize="4" OffsetHex="0000062C" DisplayMethod="unsigned integer"/>
        <Element Offset="1584" Vartype="Float" Bytesize="4" OffsetHex="00000630" DisplayMethod="unsigned integer"/>
        <Element Offset="1588" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000634" DisplayMethod="unsigned integer"/>
        <Element Offset="1600" Vartype="Float" Bytesize="4" OffsetHex="00000640" DisplayMethod="unsigned integer"/>
        <Element Offset="1604" Vartype="Pointer" Bytesize="4" OffsetHex="00000644" DisplayMethod="unsigned integer"/>
        <Element Offset="1608" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000648" DisplayMethod="unsigned integer"/>
        <Element Offset="1616" Vartype="String" Bytesize="5" OffsetHex="00000650" DisplayMethod="unsigned integer"/>
        <Element Offset="1621" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000655" DisplayMethod="unsigned integer"/>
        <Element Offset="1624" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000658" DisplayMethod="unsigned integer"/>
        <Element Offset="1636" Vartype="Float" Bytesize="4" OffsetHex="00000664" DisplayMethod="unsigned integer"/>
        <Element Offset="1640" Vartype="Pointer" Bytesize="4" OffsetHex="00000668" DisplayMethod="unsigned integer"/>
        <Element Offset="1644" Vartype="String" Bytesize="5" OffsetHex="0000066C" DisplayMethod="unsigned integer"/>
        <Element Offset="1649" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000671" DisplayMethod="unsigned integer"/>
        <Element Offset="1652" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000674" DisplayMethod="unsigned integer"/>
        <Element Offset="1660" Vartype="Float" Bytesize="4" OffsetHex="0000067C" DisplayMethod="unsigned integer"/>
        <Element Offset="1664" Vartype="Pointer" Bytesize="4" OffsetHex="00000680" DisplayMethod="unsigned integer"/>
        <Element Offset="1668" Vartype="Float" Bytesize="4" OffsetHex="00000684" DisplayMethod="unsigned integer"/>
        <Element Offset="1672" Vartype="Pointer" Bytesize="4" OffsetHex="00000688" DisplayMethod="unsigned integer"/>
        <Element Offset="1676" Vartype="Float" Bytesize="4" OffsetHex="0000068C" DisplayMethod="unsigned integer"/>
        <Element Offset="1680" Vartype="Pointer" Bytesize="4" OffsetHex="00000690" DisplayMethod="unsigned integer"/>
        <Element Offset="1684" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000694" DisplayMethod="unsigned integer"/>
        <Element Offset="1704" Vartype="Pointer" Bytesize="4" OffsetHex="000006A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1708" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="000006AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1724" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000006BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1728" Vartype="Float" Bytesize="4" RLECount="26" OffsetHex="000006C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1832" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000728" DisplayMethod="unsigned integer"/>
        <Element Offset="1836" Vartype="Float" Bytesize="4" RLECount="12" OffsetHex="0000072C" DisplayMethod="unsigned integer"/>
        <Element Offset="1884" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000075C" DisplayMethod="unsigned integer"/>
        <Element Offset="1888" Vartype="Float" Bytesize="4" RLECount="31" OffsetHex="00000760" DisplayMethod="unsigned integer"/>
        <Element Offset="2012" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000007DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2014" Vartype="2 Bytes" Bytesize="2" OffsetHex="000007DE" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="Float" Bytesize="4" RLECount="9" OffsetHex="000007E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2052" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000804" DisplayMethod="unsigned integer"/>
        <Element Offset="2056" Vartype="Float" Bytesize="4" RLECount="62" OffsetHex="00000808" DisplayMethod="unsigned integer"/>
        <Element Offset="2304" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000900" DisplayMethod="unsigned integer"/>
        <Element Offset="2312" Vartype="Pointer" Bytesize="4" RLECount="3" OffsetHex="00000908" DisplayMethod="unsigned integer"/>
        <Element Offset="2324" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000914" DisplayMethod="unsigned integer"/>
        <Element Offset="2328" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000918" DisplayMethod="hexadecimal"/>
        <Element Offset="2332" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000091C" DisplayMethod="unsigned integer"/>
        <Element Offset="2344" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000928" DisplayMethod="hexadecimal"/>
        <Element Offset="2348" Vartype="Float" Bytesize="4" OffsetHex="0000092C" DisplayMethod="unsigned integer"/>
        <Element Offset="2352" Vartype="Pointer" Bytesize="4" OffsetHex="00000930" DisplayMethod="unsigned integer"/>
        <Element Offset="2356" Vartype="Float" Bytesize="4" OffsetHex="00000934" DisplayMethod="unsigned integer"/>
        <Element Offset="2360" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000938" DisplayMethod="unsigned integer"/>
        <Element Offset="2368" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000940" DisplayMethod="unsigned integer"/>
        <Element Offset="2376" Vartype="Pointer" Bytesize="4" OffsetHex="00000948" DisplayMethod="unsigned integer"/>
        <Element Offset="2380" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000094C" DisplayMethod="unsigned integer"/>
        <Element Offset="2384" Vartype="Double" Bytesize="8" OffsetHex="00000950" DisplayMethod="unsigned integer"/>
        <Element Offset="2392" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000958" DisplayMethod="unsigned integer"/>
        <Element Offset="2396" Vartype="Pointer" Bytesize="4" OffsetHex="0000095C" DisplayMethod="unsigned integer"/>
        <Element Offset="2400" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="00000960" DisplayMethod="unsigned integer"/>
        <Element Offset="2428" Vartype="Pointer" Bytesize="4" OffsetHex="0000097C" DisplayMethod="unsigned integer"/>
        <Element Offset="2432" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000980" DisplayMethod="unsigned integer"/>
        <Element Offset="2444" Vartype="Double" Bytesize="8" OffsetHex="0000098C" DisplayMethod="unsigned integer"/>
        <Element Offset="2452" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000994" DisplayMethod="unsigned integer"/>
        <Element Offset="2464" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009A0" DisplayMethod="hexadecimal"/>
        <Element Offset="2468" Vartype="Double" Bytesize="8" RLECount="2" OffsetHex="000009A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2484" Vartype="Pointer" Bytesize="4" OffsetHex="000009B4" DisplayMethod="unsigned integer"/>
        <Element Offset="2488" Vartype="4 Bytes" Bytesize="4" RLECount="15" OffsetHex="000009B8" DisplayMethod="unsigned integer"/>
        <Element Offset="2548" Vartype="Float" Bytesize="4" OffsetHex="000009F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2552" Vartype="Pointer" Bytesize="4" OffsetHex="000009F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2556" Vartype="Float" Bytesize="4" OffsetHex="000009FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2560" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A00" DisplayMethod="unsigned integer"/>
        <Element Offset="2568" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A08" DisplayMethod="hexadecimal"/>
        <Element Offset="2572" Vartype="4 Bytes" Bytesize="4" RLECount="32" OffsetHex="00000A0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2700" Vartype="Float" Bytesize="4" OffsetHex="00000A8C" DisplayMethod="unsigned integer"/>
        <Element Offset="2704" Vartype="Pointer" Bytesize="4" OffsetHex="00000A90" DisplayMethod="unsigned integer"/>
        <Element Offset="2708" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000A94" DisplayMethod="unsigned integer"/>
        <Element Offset="2724" Vartype="Pointer" Bytesize="4" RLECount="5" OffsetHex="00000AA4" DisplayMethod="unsigned integer"/>
        <Element Offset="2744" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000AB8" DisplayMethod="hexadecimal"/>
        <Element Offset="2760" Vartype="Pointer" Bytesize="4" OffsetHex="00000AC8" DisplayMethod="unsigned integer"/>
        <Element Offset="2764" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000ACC" DisplayMethod="unsigned integer"/>
        <Element Offset="2772" Vartype="Double" Bytesize="8" OffsetHex="00000AD4" DisplayMethod="unsigned integer"/>
        <Element Offset="2780" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000ADC" DisplayMethod="unsigned integer"/>
        <Element Offset="2816" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000B00" DisplayMethod="unsigned integer"/>
        <Element Offset="2824" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B08" DisplayMethod="hexadecimal"/>
        <Element Offset="2828" Vartype="Double" Bytesize="8" OffsetHex="00000B0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2836" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000B14" DisplayMethod="unsigned integer"/>
        <Element Offset="2852" Vartype="Float" Bytesize="4" OffsetHex="00000B24" DisplayMethod="unsigned integer"/>
        <Element Offset="2856" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000B28" DisplayMethod="unsigned integer"/>
        <Element Offset="2876" Vartype="Double" Bytesize="8" OffsetHex="00000B3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2884" Vartype="Float" Bytesize="4" OffsetHex="00000B44" DisplayMethod="unsigned integer"/>
        <Element Offset="2888" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000B48" DisplayMethod="unsigned integer"/>
        <Element Offset="2920" Vartype="Pointer" Bytesize="4" RLECount="3" OffsetHex="00000B68" DisplayMethod="unsigned integer"/>
        <Element Offset="2932" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B74" DisplayMethod="unsigned integer"/>
        <Element Offset="2936" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B78" DisplayMethod="hexadecimal"/>
        <Element Offset="2940" Vartype="Pointer" Bytesize="4" OffsetHex="00000B7C" Description="Pointer to instance of GeometryHierarchyInst" DisplayMethod="unsigned integer"/>
        <Element Offset="2944" Vartype="Pointer" Bytesize="4" OffsetHex="00000B80" Description="Pointer to instance of VMInstanceInternal" DisplayMethod="unsigned integer"/>
        <Element Offset="2948" Vartype="Pointer" Bytesize="4" OffsetHex="00000B84" Description="Pointer to instance of AudioEmitter" DisplayMethod="unsigned integer"/>
        <Element Offset="2952" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B88" DisplayMethod="hexadecimal"/>
        <Element Offset="2956" Vartype="Float" Bytesize="4" OffsetHex="00000B8C" DisplayMethod="unsigned integer"/>
        <Element Offset="2960" Vartype="Pointer" Bytesize="4" RLECount="4" OffsetHex="00000B90" DisplayMethod="unsigned integer"/>
        <Element Offset="2976" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000BA0" DisplayMethod="unsigned integer"/>
        <Element Offset="2984" Vartype="Pointer" Bytesize="4" OffsetHex="00000BA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2988" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BAC" DisplayMethod="unsigned integer"/>
        <Element Offset="2992" Vartype="Double" Bytesize="8" OffsetHex="00000BB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3000" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3004" Vartype="Pointer" Bytesize="4" OffsetHex="00000BBC" Description="Pointer to instance of NPC" DisplayMethod="unsigned integer"/>
        <Element Offset="3008" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BC0" DisplayMethod="hexadecimal"/>
        <Element Offset="3012" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3016" Vartype="Pointer" Bytesize="4" OffsetHex="00000BC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3020" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3024" Vartype="Pointer" Bytesize="4" OffsetHex="00000BD0" Description="Pointer to instance of Sentence" DisplayMethod="unsigned integer"/>
        <Element Offset="3028" Vartype="Byte" Bytesize="1" OffsetHex="00000BD4" DisplayMethod="unsigned integer"/>
        <Element Offset="3029" Vartype="String" Bytesize="4" OffsetHex="00000BD5" DisplayMethod="unsigned integer"/>
        <Element Offset="3033" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000BD9" DisplayMethod="unsigned integer"/>
        <Element Offset="3036" Vartype="Pointer" Bytesize="4" OffsetHex="00000BDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3040" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000BE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3052" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000BEC" DisplayMethod="hexadecimal"/>
        <Element Offset="3060" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000BF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3072" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C00" DisplayMethod="hexadecimal"/>
        <Element Offset="3076" Vartype="Double" Bytesize="8" OffsetHex="00000C04" DisplayMethod="unsigned integer"/>
        <Element Offset="3084" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C0C" DisplayMethod="hexadecimal"/>
        <Element Offset="3092" Vartype="Pointer" Bytesize="4" OffsetHex="00000C14" DisplayMethod="unsigned integer"/>
        <Element Offset="3096" Vartype="Pointer" Bytesize="4" OffsetHex="00000C18" Description="Pointer to instance of MotionImpl" DisplayMethod="unsigned integer"/>
        <Element Offset="3100" Vartype="Pointer" Bytesize="4" OffsetHex="00000C1C" Description="Pointer to instance of MindDead" DisplayMethod="unsigned integer"/>
        <Element Offset="3104" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C20" DisplayMethod="unsigned integer"/>
        <Element Offset="3116" Vartype="Pointer" Bytesize="4" OffsetHex="00000C2C" Description="Pointer to instance of JobWaitForIdle" DisplayMethod="unsigned integer"/>
        <Element Offset="3120" Vartype="Pointer" Bytesize="4" OffsetHex="00000C30" Description="Pointer to instance of ShortGoalWaitForAIMotion" DisplayMethod="unsigned integer"/>
        <Element Offset="3124" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000C34" DisplayMethod="unsigned integer"/>
        <Element Offset="3140" Vartype="Pointer" Bytesize="4" OffsetHex="00000C44" DisplayMethod="unsigned integer"/>
        <Element Offset="3144" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C48" DisplayMethod="unsigned integer"/>
        <Element Offset="3156" Vartype="Float" Bytesize="4" OffsetHex="00000C54" DisplayMethod="unsigned integer"/>
        <Element Offset="3160" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000C58" DisplayMethod="unsigned integer"/>
        <Element Offset="3168" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C60" DisplayMethod="unsigned integer"/>
        <Element Offset="3180" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C6C" DisplayMethod="hexadecimal"/>
        <Element Offset="3184" Vartype="4 Bytes" Bytesize="4" RLECount="31" OffsetHex="00000C70" DisplayMethod="unsigned integer"/>
        <Element Offset="3308" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000CEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3316" Vartype="Pointer" Bytesize="4" OffsetHex="00000CF4" Description="Pointer to instance of NPCClub" DisplayMethod="unsigned integer"/>
        <Element Offset="3320" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3324" Vartype="Pointer" Bytesize="4" OffsetHex="00000CFC" Description="Pointer to instance of NPCPrefs" DisplayMethod="unsigned integer"/>
        <Element Offset="3328" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D00" DisplayMethod="unsigned integer"/>
        <Element Offset="3332" Vartype="Pointer" Bytesize="4" RLECount="5" OffsetHex="00000D04" DisplayMethod="unsigned integer"/>
        <Element Offset="3352" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000D18" DisplayMethod="hexadecimal"/>
        <Element Offset="3368" Vartype="Pointer" Bytesize="4" OffsetHex="00000D28" DisplayMethod="unsigned integer"/>
        <Element Offset="3372" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3380" Vartype="Double" Bytesize="8" OffsetHex="00000D34" DisplayMethod="unsigned integer"/>
        <Element Offset="3388" Vartype="Pointer" Bytesize="4" OffsetHex="00000D3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3392" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000D40" DisplayMethod="unsigned integer"/>
        <Element Offset="3428" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000D64" DisplayMethod="unsigned integer"/>
        <Element Offset="3436" Vartype="Double" Bytesize="8" OffsetHex="00000D6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3444" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000D74" DisplayMethod="unsigned integer"/>
        <Element Offset="3460" Vartype="Float" Bytesize="4" OffsetHex="00000D84" DisplayMethod="unsigned integer"/>
        <Element Offset="3464" Vartype="Pointer" Bytesize="4" OffsetHex="00000D88" DisplayMethod="unsigned integer"/>
        <Element Offset="3468" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3476" Vartype="Pointer" Bytesize="4" OffsetHex="00000D94" DisplayMethod="unsigned integer"/>
        <Element Offset="3480" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D98" DisplayMethod="unsigned integer"/>
        <Element Offset="3484" Vartype="Double" Bytesize="8" OffsetHex="00000D9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3492" Vartype="Float" Bytesize="4" OffsetHex="00000DA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3496" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000DA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3528" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000DC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3536" Vartype="String" Bytesize="5" OffsetHex="00000DD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3541" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000DD5" DisplayMethod="unsigned integer"/>
        <Element Offset="3544" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DD8" DisplayMethod="unsigned integer"/>
        <Element Offset="3552" Vartype="Float" Bytesize="4" OffsetHex="00000DE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3556" Vartype="Pointer" Bytesize="4" OffsetHex="00000DE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3560" Vartype="String" Bytesize="4" OffsetHex="00000DE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3564" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000DEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3576" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000DF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3588" Vartype="Float" Bytesize="4" OffsetHex="00000E04" DisplayMethod="unsigned integer"/>
        <Element Offset="3592" Vartype="Pointer" Bytesize="4" OffsetHex="00000E08" DisplayMethod="unsigned integer"/>
        <Element Offset="3596" Vartype="String" Bytesize="5" OffsetHex="00000E0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3601" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E11" DisplayMethod="unsigned integer"/>
        <Element Offset="3604" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E14" DisplayMethod="unsigned integer"/>
        <Element Offset="3612" Vartype="Float" Bytesize="4" OffsetHex="00000E1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3616" Vartype="Pointer" Bytesize="4" OffsetHex="00000E20" DisplayMethod="unsigned integer"/>
        <Element Offset="3620" Vartype="String" Bytesize="4" OffsetHex="00000E24" DisplayMethod="unsigned integer"/>
        <Element Offset="3624" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000E28" DisplayMethod="unsigned integer"/>
        <Element Offset="3632" Vartype="Pointer" Bytesize="4" OffsetHex="00000E30" DisplayMethod="unsigned integer"/>
        <Element Offset="3636" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E34" DisplayMethod="unsigned integer"/>
        <Element Offset="3648" Vartype="Float" Bytesize="4" OffsetHex="00000E40" DisplayMethod="unsigned integer"/>
        <Element Offset="3652" Vartype="Pointer" Bytesize="4" OffsetHex="00000E44" DisplayMethod="unsigned integer"/>
        <Element Offset="3656" Vartype="String" Bytesize="5" OffsetHex="00000E48" DisplayMethod="unsigned integer"/>
        <Element Offset="3661" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E4D" DisplayMethod="unsigned integer"/>
        <Element Offset="3664" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E50" DisplayMethod="unsigned integer"/>
        <Element Offset="3672" Vartype="Float" Bytesize="4" OffsetHex="00000E58" DisplayMethod="unsigned integer"/>
        <Element Offset="3676" Vartype="Pointer" Bytesize="4" OffsetHex="00000E5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3680" Vartype="String" Bytesize="5" OffsetHex="00000E60" DisplayMethod="unsigned integer"/>
        <Element Offset="3685" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E65" DisplayMethod="unsigned integer"/>
        <Element Offset="3688" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000E68" DisplayMethod="unsigned integer"/>
        <Element Offset="3696" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E70" DisplayMethod="unsigned integer"/>
        <Element Offset="3708" Vartype="Float" Bytesize="4" OffsetHex="00000E7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3712" Vartype="Pointer" Bytesize="4" OffsetHex="00000E80" DisplayMethod="unsigned integer"/>
        <Element Offset="3716" Vartype="String" Bytesize="5" OffsetHex="00000E84" DisplayMethod="unsigned integer"/>
        <Element Offset="3721" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E89" DisplayMethod="unsigned integer"/>
        <Element Offset="3724" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3732" Vartype="Float" Bytesize="4" OffsetHex="00000E94" DisplayMethod="unsigned integer"/>
        <Element Offset="3736" Vartype="Pointer" Bytesize="4" OffsetHex="00000E98" DisplayMethod="unsigned integer"/>
        <Element Offset="3740" Vartype="String" Bytesize="4" OffsetHex="00000E9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3744" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000EA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3752" Vartype="Pointer" Bytesize="4" OffsetHex="00000EA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3756" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3768" Vartype="Float" Bytesize="4" OffsetHex="00000EB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3772" Vartype="Pointer" Bytesize="4" OffsetHex="00000EBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3776" Vartype="Float" Bytesize="4" OffsetHex="00000EC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3780" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3792" Vartype="Float" Bytesize="4" OffsetHex="00000ED0" DisplayMethod="unsigned integer"/>
        <Element Offset="3796" Vartype="Pointer" Bytesize="4" OffsetHex="00000ED4" DisplayMethod="unsigned integer"/>
        <Element Offset="3800" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000ED8" DisplayMethod="unsigned integer"/>
        <Element Offset="3808" Vartype="Pointer" Bytesize="4" RLECount="2" OffsetHex="00000EE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3816" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000EE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3820" Vartype="Double" Bytesize="8" OffsetHex="00000EEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3828" Vartype="Float" Bytesize="4" OffsetHex="00000EF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3832" Vartype="Pointer" Bytesize="4" OffsetHex="00000EF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3836" Vartype="String" Bytesize="5" OffsetHex="00000EFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3841" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000F01" DisplayMethod="unsigned integer"/>
        <Element Offset="3844" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F04" DisplayMethod="unsigned integer"/>
        <Element Offset="3852" Vartype="Float" Bytesize="4" OffsetHex="00000F0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3856" Vartype="Pointer" Bytesize="4" OffsetHex="00000F10" DisplayMethod="unsigned integer"/>
        <Element Offset="3860" Vartype="String" Bytesize="4" OffsetHex="00000F14" DisplayMethod="unsigned integer"/>
        <Element Offset="3864" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F18" DisplayMethod="unsigned integer"/>
        <Element Offset="3876" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F24" DisplayMethod="unsigned integer"/>
        <Element Offset="3888" Vartype="Float" Bytesize="4" OffsetHex="00000F30" DisplayMethod="unsigned integer"/>
        <Element Offset="3892" Vartype="Pointer" Bytesize="4" OffsetHex="00000F34" DisplayMethod="unsigned integer"/>
        <Element Offset="3896" Vartype="String" Bytesize="5" OffsetHex="00000F38" DisplayMethod="unsigned integer"/>
        <Element Offset="3901" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000F3D" DisplayMethod="unsigned integer"/>
        <Element Offset="3904" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F40" DisplayMethod="unsigned integer"/>
        <Element Offset="3912" Vartype="Float" Bytesize="4" OffsetHex="00000F48" DisplayMethod="unsigned integer"/>
        <Element Offset="3916" Vartype="Pointer" Bytesize="4" OffsetHex="00000F4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3920" Vartype="String" Bytesize="4" OffsetHex="00000F50" DisplayMethod="unsigned integer"/>
        <Element Offset="3924" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F54" DisplayMethod="unsigned integer"/>
        <Element Offset="3936" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F60" DisplayMethod="unsigned integer"/>
        <Element Offset="3948" Vartype="Float" Bytesize="4" OffsetHex="00000F6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3952" Vartype="Pointer" Bytesize="4" OffsetHex="00000F70" DisplayMethod="unsigned integer"/>
        <Element Offset="3956" Vartype="String" Bytesize="5" OffsetHex="00000F74" DisplayMethod="unsigned integer"/>
        <Element Offset="3961" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000F79" DisplayMethod="unsigned integer"/>
        <Element Offset="3964" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3972" Vartype="Float" Bytesize="4" OffsetHex="00000F84" DisplayMethod="unsigned integer"/>
        <Element Offset="3976" Vartype="Pointer" Bytesize="4" OffsetHex="00000F88" DisplayMethod="unsigned integer"/>
        <Element Offset="3980" Vartype="String" Bytesize="7" OffsetHex="00000F8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3987" Vartype="Byte" Bytesize="1" RLECount="5" OffsetHex="00000F93" DisplayMethod="unsigned integer"/>
        <Element Offset="3992" Vartype="Float" Bytesize="4" OffsetHex="00000F98" DisplayMethod="unsigned integer"/>
        <Element Offset="3996" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F9C" DisplayMethod="unsigned integer"/>
        <Element Offset="4008" Vartype="Float" Bytesize="4" OffsetHex="00000FA8" DisplayMethod="unsigned integer"/>
        <Element Offset="4012" Vartype="Pointer" Bytesize="4" OffsetHex="00000FAC" DisplayMethod="unsigned integer"/>
        <Element Offset="4016" Vartype="String" Bytesize="5" OffsetHex="00000FB0" DisplayMethod="unsigned integer"/>
        <Element Offset="4021" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000FB5" DisplayMethod="unsigned integer"/>
        <Element Offset="4024" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000FB8" DisplayMethod="unsigned integer"/>
        <Element Offset="4032" Vartype="Float" Bytesize="4" OffsetHex="00000FC0" DisplayMethod="unsigned integer"/>
        <Element Offset="4036" Vartype="Pointer" Bytesize="4" OffsetHex="00000FC4" DisplayMethod="unsigned integer"/>
        <Element Offset="4040" Vartype="String" Bytesize="4" OffsetHex="00000FC8" DisplayMethod="unsigned integer"/>
        <Element Offset="4044" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000FCC" DisplayMethod="unsigned integer"/>
        <Element Offset="4056" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000FD8" DisplayMethod="unsigned integer"/>
        <Element Offset="4068" Vartype="Float" Bytesize="4" OffsetHex="00000FE4" DisplayMethod="unsigned integer"/>
        <Element Offset="4072" Vartype="Pointer" Bytesize="4" OffsetHex="00000FE8" DisplayMethod="unsigned integer"/>
        <Element Offset="4076" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000FEC" DisplayMethod="unsigned integer"/>
        <Element Offset="4080" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000FF0" DisplayMethod="unsigned integer"/>
        <Element Offset="4092" Vartype="Float" Bytesize="4" OffsetHex="00000FFC" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
  </Structures>
  <Comments>Version: GOG, 2.1.0.12
HP:      Float, starts at 300, code shared with enemies
Money:   Float, same value as seen in the inventory screen
Ammo:    4 bytes, same value as seen in the HUD</Comments>
</CheatTable>
