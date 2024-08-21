<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>15</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>7</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hit, 64)
label(hp_flag)
label(kill_flag)
label(hit_ret)
registersymbol(hp_flag)
registersymbol(kill_flag)
label(hit_ret)
label(hit_code)
label(hit_og)
label(energy)
label(inf_energy)
label(energy_flag)
registersymbol(energy_flag)
label(energy_ret)
label(player)

hit:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
energy_flag:
  db 00 00 00 00
hit_code:
  cmp [ebp+34], gamex86.dll+3DA08
  je enemy
  cmp [ebp+14],NoxGame.dll+A57FF
  je enemy
//energy
  cmp [energy_flag], 00
  je player
  //push [ecx+28]
  //pop [ecx+2c]
  player:
  cmp [hp_flag], 00
  je hit_og
  mov ecx,[eax+08]
  fstp st(0)
  push [ecx+20]
  pop [ecx+24]
jmp hit_ret

enemy:
  cmp [kill_flag], 00
  je hit_og
  mov ecx,[eax+08]
  fstp dword ptr [ecx+24]
  mov [ecx+24], (float)0
jmp hit_ret

hit_og:
  mov ecx,[eax+08]
  fstp dword ptr [ecx+24]
jmp hit_ret

energy:
  fld dword ptr [ecx+2C]
  fcomp dword ptr [edx+28]
  cmp [hp_flag], 00
  je inf_energy
  push [ecx+20]
  pop [ecx+24]

inf_energy:
  cmp [energy_flag], 00
  je energy_ret
  push [ecx+28]
  pop [ecx+2c]
jmp energy_ret

NoxGame.STATS_GetPartyEdicts+2421:
  jmp hit_code
  nop
hit_ret:

NoxGame.dll+8107E:
  jmp energy
  nop
energy_ret:

[disable]
NoxGame.STATS_GetPartyEdicts+2421:
  mov ecx,[eax+08]
  fstp dword ptr [ecx+24]

NoxGame.dll+8107E:
  fld dword ptr [ecx+2C]
  fcomp dword ptr [edx+28]
dealloc(*)




</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>8</ID>
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
          <ID>9</ID>
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
        <CheatEntry>
          <ID>13</ID>
          <Description>"R - Recharge energy"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
energy_flag:
  db 00 00 00 01

[disable]
energy_flag:
  db 00 00 00 00
</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>11</ID>
      <Description>"Money"</Description>
      <ShowAsSigned>0</ShowAsSigned>
      <VariableType>4 Bytes</VariableType>
      <Address>[NoxGame.dll+CA580]+0c</Address>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Structures StructVersion="2">
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="24" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000018" DisplayMethod="hexadecimal"/>
        <Element Offset="28" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000001C" DisplayMethod="unsigned integer"/>
        <Element Offset="32" Vartype="Byte" Bytesize="1" RLECount="8" OffsetHex="00000020" DisplayMethod="unsigned integer"/>
        <Element Offset="40" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000028" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="96" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000060" DisplayMethod="hexadecimal"/>
        <Element Offset="104" Vartype="Pointer" Bytesize="8" OffsetHex="00000068" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="Pointer" Bytesize="8" OffsetHex="0000006C" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Pointer" Bytesize="8" OffsetHex="00000070" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000078" DisplayMethod="unsigned integer"/>
        <Element Offset="144" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000090" DisplayMethod="hexadecimal"/>
        <Element Offset="148" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000094" DisplayMethod="unsigned integer"/>
        <Element Offset="152" Vartype="Byte" Bytesize="1" RLECount="8" OffsetHex="00000098" DisplayMethod="unsigned integer"/>
        <Element Offset="160" Vartype="4 Bytes" Bytesize="4" RLECount="14" OffsetHex="000000A0" DisplayMethod="unsigned integer"/>
        <Element Offset="216" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000D8" DisplayMethod="hexadecimal"/>
        <Element Offset="224" Vartype="Pointer" Bytesize="8" OffsetHex="000000E0" DisplayMethod="unsigned integer"/>
        <Element Offset="228" Vartype="Pointer" Bytesize="8" OffsetHex="000000E4" DisplayMethod="unsigned integer"/>
        <Element Offset="232" Vartype="Pointer" Bytesize="8" OffsetHex="000000E8" DisplayMethod="unsigned integer"/>
        <Element Offset="236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000EC" DisplayMethod="unsigned integer"/>
        <Element Offset="240" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000000F0" DisplayMethod="unsigned integer"/>
        <Element Offset="264" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000108" DisplayMethod="hexadecimal"/>
        <Element Offset="268" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="Float" Bytesize="4" OffsetHex="00000110" DisplayMethod="unsigned integer"/>
        <Element Offset="276" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000114" DisplayMethod="unsigned integer"/>
        <Element Offset="280" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000118" DisplayMethod="unsigned integer"/>
        <Element Offset="292" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000124" DisplayMethod="unsigned integer"/>
        <Element Offset="332" Vartype="String" Bytesize="5" OffsetHex="0000014C" DisplayMethod="unsigned integer"/>
        <Element Offset="337" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000151" DisplayMethod="unsigned integer"/>
        <Element Offset="340" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000154" DisplayMethod="hexadecimal"/>
        <Element Offset="344" Vartype="Pointer" Bytesize="8" OffsetHex="00000158" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="Pointer" Bytesize="8" OffsetHex="0000015C" DisplayMethod="unsigned integer"/>
        <Element Offset="352" Vartype="Pointer" Bytesize="8" OffsetHex="00000160" DisplayMethod="unsigned integer"/>
        <Element Offset="356" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000164" DisplayMethod="unsigned integer"/>
        <Element Offset="360" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000168" DisplayMethod="unsigned integer"/>
        <Element Offset="384" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000180" DisplayMethod="hexadecimal"/>
        <Element Offset="388" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000184" DisplayMethod="unsigned integer"/>
        <Element Offset="392" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000188" DisplayMethod="unsigned integer"/>
        <Element Offset="416" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="000001A0" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001C8" DisplayMethod="hexadecimal"/>
        <Element Offset="464" Vartype="Pointer" Bytesize="8" OffsetHex="000001D0" DisplayMethod="unsigned integer"/>
        <Element Offset="468" Vartype="Pointer" Bytesize="8" OffsetHex="000001D4" DisplayMethod="unsigned integer"/>
        <Element Offset="472" Vartype="Pointer" Bytesize="8" OffsetHex="000001D8" DisplayMethod="unsigned integer"/>
        <Element Offset="476" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001DC" DisplayMethod="unsigned integer"/>
        <Element Offset="480" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000001E0" DisplayMethod="unsigned integer"/>
        <Element Offset="504" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001F8" DisplayMethod="unsigned integer"/>
        <Element Offset="512" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000200" DisplayMethod="unsigned integer"/>
        <Element Offset="516" Vartype="4 Bytes" Bytesize="4" RLECount="14" OffsetHex="00000204" DisplayMethod="unsigned integer"/>
        <Element Offset="572" Vartype="String" Bytesize="4" OffsetHex="0000023C" DisplayMethod="unsigned integer"/>
        <Element Offset="576" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000240" DisplayMethod="hexadecimal"/>
        <Element Offset="584" Vartype="Pointer" Bytesize="8" OffsetHex="00000248" DisplayMethod="unsigned integer"/>
        <Element Offset="588" Vartype="Pointer" Bytesize="8" OffsetHex="0000024C" DisplayMethod="unsigned integer"/>
        <Element Offset="592" Vartype="Pointer" Bytesize="8" OffsetHex="00000250" DisplayMethod="unsigned integer"/>
        <Element Offset="596" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000254" DisplayMethod="unsigned integer"/>
        <Element Offset="600" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000258" DisplayMethod="unsigned integer"/>
        <Element Offset="624" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000270" DisplayMethod="unsigned integer"/>
        <Element Offset="632" Vartype="Float" Bytesize="4" OffsetHex="00000278" DisplayMethod="unsigned integer"/>
        <Element Offset="636" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000027C" DisplayMethod="unsigned integer"/>
        <Element Offset="640" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="00000280" DisplayMethod="unsigned integer"/>
        <Element Offset="692" Vartype="Pointer" Bytesize="8" OffsetHex="000002B4" DisplayMethod="unsigned integer"/>
        <Element Offset="696" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000002B8" DisplayMethod="hexadecimal"/>
        <Element Offset="704" Vartype="Pointer" Bytesize="8" OffsetHex="000002C0" DisplayMethod="unsigned integer"/>
        <Element Offset="708" Vartype="Pointer" Bytesize="8" OffsetHex="000002C4" DisplayMethod="unsigned integer"/>
        <Element Offset="712" Vartype="Pointer" Bytesize="8" OffsetHex="000002C8" DisplayMethod="unsigned integer"/>
        <Element Offset="716" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002CC" DisplayMethod="unsigned integer"/>
        <Element Offset="720" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000002D0" DisplayMethod="unsigned integer"/>
        <Element Offset="744" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000002E8" DisplayMethod="unsigned integer"/>
        <Element Offset="752" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000002F0" DisplayMethod="unsigned integer"/>
        <Element Offset="760" Vartype="4 Bytes" Bytesize="4" RLECount="14" OffsetHex="000002F8" DisplayMethod="unsigned integer"/>
        <Element Offset="816" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000330" DisplayMethod="hexadecimal"/>
        <Element Offset="824" Vartype="Pointer" Bytesize="8" OffsetHex="00000338" DisplayMethod="unsigned integer"/>
        <Element Offset="828" Vartype="Pointer" Bytesize="8" OffsetHex="0000033C" DisplayMethod="unsigned integer"/>
        <Element Offset="832" Vartype="Pointer" Bytesize="8" OffsetHex="00000340" DisplayMethod="unsigned integer"/>
        <Element Offset="836" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000344" DisplayMethod="unsigned integer"/>
        <Element Offset="840" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000348" DisplayMethod="unsigned integer"/>
        <Element Offset="864" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000360" DisplayMethod="hexadecimal"/>
        <Element Offset="868" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000364" DisplayMethod="unsigned integer"/>
        <Element Offset="872" Vartype="Byte" Bytesize="1" RLECount="8" OffsetHex="00000368" DisplayMethod="unsigned integer"/>
        <Element Offset="880" Vartype="4 Bytes" Bytesize="4" RLECount="14" OffsetHex="00000370" DisplayMethod="unsigned integer"/>
        <Element Offset="936" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003A8" DisplayMethod="hexadecimal"/>
        <Element Offset="944" Vartype="Pointer" Bytesize="8" OffsetHex="000003B0" DisplayMethod="unsigned integer"/>
        <Element Offset="948" Vartype="Pointer" Bytesize="8" OffsetHex="000003B4" DisplayMethod="unsigned integer"/>
        <Element Offset="952" Vartype="Pointer" Bytesize="8" OffsetHex="000003B8" DisplayMethod="unsigned integer"/>
        <Element Offset="956" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003BC" DisplayMethod="unsigned integer"/>
        <Element Offset="960" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000003C0" DisplayMethod="unsigned integer"/>
        <Element Offset="984" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003D8" DisplayMethod="unsigned integer"/>
        <Element Offset="992" Vartype="Byte" Bytesize="1" RLECount="8" OffsetHex="000003E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1000" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="000003E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1052" Vartype="String" Bytesize="4" OffsetHex="0000041C" DisplayMethod="unsigned integer"/>
        <Element Offset="1056" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000420" DisplayMethod="hexadecimal"/>
        <Element Offset="1064" Vartype="Pointer" Bytesize="8" OffsetHex="00000428" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="Pointer" Bytesize="8" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="Pointer" Bytesize="8" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1076" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000434" DisplayMethod="unsigned integer"/>
        <Element Offset="1092" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000444" DisplayMethod="unsigned integer"/>
        <Element Offset="1100" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000044C" DisplayMethod="unsigned integer"/>
        <Element Offset="1112" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000458" DisplayMethod="unsigned integer"/>
        <Element Offset="1124" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000464" DisplayMethod="unsigned integer"/>
        <Element Offset="1136" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000470" DisplayMethod="unsigned integer"/>
        <Element Offset="1148" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000047C" DisplayMethod="unsigned integer"/>
        <Element Offset="1160" Vartype="Pointer" Bytesize="8" OffsetHex="00000488" DisplayMethod="unsigned integer"/>
        <Element Offset="1164" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000048C" DisplayMethod="unsigned integer"/>
        <Element Offset="1168" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000490" DisplayMethod="hexadecimal"/>
        <Element Offset="1172" Vartype="String" Bytesize="4" OffsetHex="00000494" DisplayMethod="unsigned integer"/>
        <Element Offset="1176" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000498" DisplayMethod="hexadecimal"/>
        <Element Offset="1184" Vartype="Pointer" Bytesize="8" OffsetHex="000004A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1188" Vartype="Pointer" Bytesize="8" OffsetHex="000004A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1192" Vartype="Pointer" Bytesize="8" OffsetHex="000004A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1196" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1200" Vartype="String" Bytesize="91" OffsetHex="000004B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1291" Vartype="Byte" Bytesize="1" OffsetHex="0000050B" DisplayMethod="unsigned integer"/>
        <Element Offset="1292" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000050C" DisplayMethod="hexadecimal"/>
        <Element Offset="1304" Vartype="Pointer" Bytesize="8" OffsetHex="00000518" DisplayMethod="unsigned integer"/>
        <Element Offset="1308" Vartype="Pointer" Bytesize="8" OffsetHex="0000051C" DisplayMethod="unsigned integer"/>
        <Element Offset="1312" Vartype="Pointer" Bytesize="8" OffsetHex="00000520" DisplayMethod="unsigned integer"/>
        <Element Offset="1316" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000524" DisplayMethod="unsigned integer"/>
        <Element Offset="1352" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000548" DisplayMethod="unsigned integer"/>
        <Element Offset="1364" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000554" DisplayMethod="unsigned integer"/>
        <Element Offset="1376" Vartype="Double" Bytesize="8" OffsetHex="00000560" DisplayMethod="unsigned integer"/>
        <Element Offset="1384" Vartype="Float" Bytesize="4" OffsetHex="00000568" DisplayMethod="unsigned integer"/>
        <Element Offset="1388" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000056C" DisplayMethod="unsigned integer"/>
        <Element Offset="1400" Vartype="Pointer" Bytesize="8" OffsetHex="00000578" DisplayMethod="unsigned integer"/>
        <Element Offset="1404" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000057C" DisplayMethod="unsigned integer"/>
        <Element Offset="1408" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000580" DisplayMethod="hexadecimal"/>
        <Element Offset="1412" Vartype="String" Bytesize="28" OffsetHex="00000584" DisplayMethod="unsigned integer"/>
        <Element Offset="1440" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005A0" DisplayMethod="hexadecimal"/>
        <Element Offset="1444" Vartype="String" Bytesize="33" OffsetHex="000005A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1477" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="000005C5" DisplayMethod="unsigned integer"/>
        <Element Offset="1480" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005C8" DisplayMethod="hexadecimal"/>
        <Element Offset="1484" Vartype="String" Bytesize="17" OffsetHex="000005CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1501" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="000005DD" DisplayMethod="unsigned integer"/>
        <Element Offset="1504" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005E0" DisplayMethod="hexadecimal"/>
        <Element Offset="1508" Vartype="String" Bytesize="12" OffsetHex="000005E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1520" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005F0" DisplayMethod="hexadecimal"/>
        <Element Offset="1524" Vartype="String" Bytesize="5" OffsetHex="000005F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1529" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="000005F9" DisplayMethod="unsigned integer"/>
        <Element Offset="1532" Vartype="Pointer" Bytesize="8" OffsetHex="000005FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1536" Vartype="Pointer" Bytesize="8" OffsetHex="00000600" DisplayMethod="unsigned integer"/>
        <Element Offset="1540" Vartype="Pointer" Bytesize="8" OffsetHex="00000604" DisplayMethod="unsigned integer"/>
        <Element Offset="1544" Vartype="String" Bytesize="8" OffsetHex="00000608" DisplayMethod="unsigned integer"/>
        <Element Offset="1552" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000610" DisplayMethod="unsigned integer"/>
        <Element Offset="1556" Vartype="Pointer" Bytesize="8" OffsetHex="00000614" DisplayMethod="unsigned integer"/>
        <Element Offset="1560" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000618" DisplayMethod="hexadecimal"/>
        <Element Offset="1564" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000061C" DisplayMethod="unsigned integer"/>
        <Element Offset="1568" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000620" DisplayMethod="hexadecimal"/>
        <Element Offset="1572" Vartype="String" Bytesize="4" OffsetHex="00000624" DisplayMethod="unsigned integer"/>
        <Element Offset="1576" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000628" DisplayMethod="hexadecimal"/>
        <Element Offset="1588" Vartype="Pointer" Bytesize="8" OffsetHex="00000634" DisplayMethod="unsigned integer"/>
        <Element Offset="1592" Vartype="Pointer" Bytesize="8" OffsetHex="00000638" DisplayMethod="unsigned integer"/>
        <Element Offset="1596" Vartype="4 Bytes" Bytesize="4" RLECount="12" OffsetHex="0000063C" DisplayMethod="hexadecimal"/>
        <Element Offset="1644" Vartype="Pointer" Bytesize="8" OffsetHex="0000066C" DisplayMethod="unsigned integer"/>
        <Element Offset="1648" Vartype="4 Bytes" Bytesize="4" RLECount="12" OffsetHex="00000670" DisplayMethod="hexadecimal"/>
        <Element Offset="1696" Vartype="Pointer" Bytesize="8" OffsetHex="000006A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1700" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1704" Vartype="Pointer" Bytesize="8" OffsetHex="000006A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1708" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="000006AC" DisplayMethod="hexadecimal"/>
        <Element Offset="1760" Vartype="Pointer" Bytesize="8" OffsetHex="000006E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1764" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000006E4" DisplayMethod="hexadecimal"/>
        <Element Offset="1776" Vartype="Pointer" Bytesize="8" OffsetHex="000006F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1780" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000006F4" DisplayMethod="hexadecimal"/>
        <Element Offset="1796" Vartype="Pointer" Bytesize="8" OffsetHex="00000704" DisplayMethod="unsigned integer"/>
        <Element Offset="1800" Vartype="Pointer" Bytesize="8" OffsetHex="00000708" DisplayMethod="unsigned integer"/>
        <Element Offset="1804" Vartype="Pointer" Bytesize="8" OffsetHex="0000070C" DisplayMethod="unsigned integer"/>
        <Element Offset="1808" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000710" DisplayMethod="hexadecimal"/>
        <Element Offset="1816" Vartype="Unicode String" Bytesize="12" OffsetHex="00000718" DisplayMethod="unsigned integer"/>
        <Element Offset="1828" Vartype="Unicode String" Bytesize="6" OffsetHex="00000724" DisplayMethod="unsigned integer"/>
        <Element Offset="1834" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="0000072A" DisplayMethod="unsigned integer"/>
        <Element Offset="1836" Vartype="Pointer" Bytesize="8" OffsetHex="0000072C" DisplayMethod="unsigned integer"/>
        <Element Offset="1840" Vartype="Pointer" Bytesize="8" OffsetHex="00000730" DisplayMethod="unsigned integer"/>
        <Element Offset="1844" Vartype="Unicode String" Bytesize="11" OffsetHex="00000734" DisplayMethod="unsigned integer"/>
        <Element Offset="1855" Vartype="Byte" Bytesize="1" OffsetHex="0000073F" DisplayMethod="unsigned integer"/>
        <Element Offset="1856" Vartype="Unicode String" Bytesize="5" OffsetHex="00000740" DisplayMethod="unsigned integer"/>
        <Element Offset="1861" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000745" DisplayMethod="unsigned integer"/>
        <Element Offset="1864" Vartype="Pointer" Bytesize="8" OffsetHex="00000748" DisplayMethod="unsigned integer"/>
        <Element Offset="1868" Vartype="Pointer" Bytesize="8" OffsetHex="0000074C" DisplayMethod="unsigned integer"/>
        <Element Offset="1872" Vartype="Pointer" Bytesize="8" OffsetHex="00000750" DisplayMethod="unsigned integer"/>
        <Element Offset="1876" Vartype="Pointer" Bytesize="8" OffsetHex="00000754" DisplayMethod="unsigned integer"/>
        <Element Offset="1880" Vartype="Pointer" Bytesize="8" OffsetHex="00000758" DisplayMethod="unsigned integer"/>
        <Element Offset="1884" Vartype="Pointer" Bytesize="8" OffsetHex="0000075C" DisplayMethod="unsigned integer"/>
        <Element Offset="1888" Vartype="Pointer" Bytesize="8" OffsetHex="00000760" DisplayMethod="unsigned integer"/>
        <Element Offset="1892" Vartype="Pointer" Bytesize="8" OffsetHex="00000764" DisplayMethod="unsigned integer"/>
        <Element Offset="1896" Vartype="Pointer" Bytesize="8" OffsetHex="00000768" DisplayMethod="unsigned integer"/>
        <Element Offset="1900" Vartype="Pointer" Bytesize="8" OffsetHex="0000076C" DisplayMethod="unsigned integer"/>
        <Element Offset="1904" Vartype="Pointer" Bytesize="8" OffsetHex="00000770" DisplayMethod="unsigned integer"/>
        <Element Offset="1908" Vartype="Pointer" Bytesize="8" OffsetHex="00000774" DisplayMethod="unsigned integer"/>
        <Element Offset="1912" Vartype="Pointer" Bytesize="8" OffsetHex="00000778" DisplayMethod="unsigned integer"/>
        <Element Offset="1916" Vartype="Pointer" Bytesize="8" OffsetHex="0000077C" DisplayMethod="unsigned integer"/>
        <Element Offset="1920" Vartype="Pointer" Bytesize="8" OffsetHex="00000780" DisplayMethod="unsigned integer"/>
        <Element Offset="1924" Vartype="Pointer" Bytesize="8" OffsetHex="00000784" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="Pointer" Bytesize="8" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1932" Vartype="Pointer" Bytesize="8" OffsetHex="0000078C" DisplayMethod="unsigned integer"/>
        <Element Offset="1936" Vartype="Pointer" Bytesize="8" OffsetHex="00000790" DisplayMethod="unsigned integer"/>
        <Element Offset="1940" Vartype="Pointer" Bytesize="8" OffsetHex="00000794" DisplayMethod="unsigned integer"/>
        <Element Offset="1944" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000798" DisplayMethod="hexadecimal"/>
        <Element Offset="1948" Vartype="Pointer" Bytesize="8" OffsetHex="0000079C" DisplayMethod="unsigned integer"/>
        <Element Offset="1952" Vartype="Pointer" Bytesize="8" OffsetHex="000007A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1956" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="000007A4" DisplayMethod="hexadecimal"/>
        <Element Offset="1996" Vartype="Double" Bytesize="8" OffsetHex="000007CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2004" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000007D4" DisplayMethod="hexadecimal"/>
        <Element Offset="2024" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="000007E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2027" Vartype="2 Bytes" Bytesize="2" OffsetHex="000007EB" DisplayMethod="unsigned integer"/>
        <Element Offset="2029" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000007ED" DisplayMethod="unsigned integer"/>
        <Element Offset="2033" Vartype="String" Bytesize="5" OffsetHex="000007F1" DisplayMethod="unsigned integer"/>
        <Element Offset="2038" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000007F6" DisplayMethod="unsigned integer"/>
        <Element Offset="2040" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000007F8" DisplayMethod="hexadecimal"/>
        <Element Offset="2048" Vartype="Float" Bytesize="4" OffsetHex="00000800" DisplayMethod="unsigned integer"/>
        <Element Offset="2052" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000804" DisplayMethod="hexadecimal"/>
        <Element Offset="2096" Vartype="Float" Bytesize="4" OffsetHex="00000830" DisplayMethod="unsigned integer"/>
        <Element Offset="2100" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000834" DisplayMethod="hexadecimal"/>
        <Element Offset="2116" Vartype="Pointer" Bytesize="8" OffsetHex="00000844" DisplayMethod="unsigned integer"/>
        <Element Offset="2120" Vartype="Pointer" Bytesize="8" OffsetHex="00000848" DisplayMethod="unsigned integer"/>
        <Element Offset="2124" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000084C" DisplayMethod="hexadecimal"/>
        <Element Offset="2136" Vartype="Float" Bytesize="4" OffsetHex="00000858" DisplayMethod="unsigned integer"/>
        <Element Offset="2140" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000085C" DisplayMethod="hexadecimal"/>
        <Element Offset="2160" Vartype="Byte" Bytesize="1" RLECount="5" OffsetHex="00000870" DisplayMethod="unsigned integer"/>
        <Element Offset="2165" Vartype="String" Bytesize="5" OffsetHex="00000875" DisplayMethod="unsigned integer"/>
        <Element Offset="2170" Vartype="Byte" Bytesize="1" RLECount="6" OffsetHex="0000087A" DisplayMethod="unsigned integer"/>
        <Element Offset="2176" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000880" DisplayMethod="hexadecimal"/>
        <Element Offset="2200" Vartype="Float" Bytesize="4" OffsetHex="00000898" DisplayMethod="unsigned integer"/>
        <Element Offset="2204" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000089C" DisplayMethod="hexadecimal"/>
        <Element Offset="2224" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000008B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2232" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008B8" DisplayMethod="hexadecimal"/>
        <Element Offset="2244" Vartype="Pointer" Bytesize="8" OffsetHex="000008C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2248" Vartype="Pointer" Bytesize="8" OffsetHex="000008C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2252" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000008CC" DisplayMethod="hexadecimal"/>
        <Element Offset="2268" Vartype="String" Bytesize="4" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2272" Vartype="Float" Bytesize="4" OffsetHex="000008E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2276" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008E4" DisplayMethod="hexadecimal"/>
        <Element Offset="2280" Vartype="String" Bytesize="8" OffsetHex="000008E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2288" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008F0" DisplayMethod="hexadecimal"/>
        <Element Offset="2296" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000008F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2300" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000008FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2308" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000904" DisplayMethod="hexadecimal"/>
        <Element Offset="2312" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000908" DisplayMethod="unsigned integer"/>
        <Element Offset="2316" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000090C" DisplayMethod="hexadecimal"/>
        <Element Offset="2324" Vartype="Pointer" Bytesize="8" OffsetHex="00000914" DisplayMethod="unsigned integer"/>
        <Element Offset="2328" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000918" DisplayMethod="hexadecimal"/>
        <Element Offset="2332" Vartype="Pointer" Bytesize="8" OffsetHex="0000091C" DisplayMethod="unsigned integer"/>
        <Element Offset="2336" Vartype="Pointer" Bytesize="8" OffsetHex="00000920" DisplayMethod="unsigned integer"/>
        <Element Offset="2340" Vartype="Pointer" Bytesize="8" OffsetHex="00000924" DisplayMethod="unsigned integer"/>
        <Element Offset="2344" Vartype="Pointer" Bytesize="8" OffsetHex="00000928" DisplayMethod="unsigned integer"/>
        <Element Offset="2348" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000092C" DisplayMethod="hexadecimal"/>
        <Element Offset="2356" Vartype="Pointer" Bytesize="8" OffsetHex="00000934" DisplayMethod="unsigned integer"/>
        <Element Offset="2360" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000938" DisplayMethod="hexadecimal"/>
        <Element Offset="2368" Vartype="Byte" Bytesize="1" RLECount="5" OffsetHex="00000940" DisplayMethod="unsigned integer"/>
        <Element Offset="2373" Vartype="String" Bytesize="5" OffsetHex="00000945" DisplayMethod="unsigned integer"/>
        <Element Offset="2378" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="0000094A" DisplayMethod="unsigned integer"/>
        <Element Offset="2380" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000094C" DisplayMethod="hexadecimal"/>
        <Element Offset="2384" Vartype="Float" Bytesize="4" OffsetHex="00000950" DisplayMethod="unsigned integer"/>
        <Element Offset="2388" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000954" DisplayMethod="unsigned integer"/>
        <Element Offset="2392" Vartype="Float" Bytesize="4" OffsetHex="00000958" DisplayMethod="unsigned integer"/>
        <Element Offset="2396" Vartype="Byte" Bytesize="1" RLECount="5" OffsetHex="0000095C" DisplayMethod="unsigned integer"/>
        <Element Offset="2401" Vartype="String" Bytesize="5" OffsetHex="00000961" DisplayMethod="unsigned integer"/>
        <Element Offset="2406" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000966" DisplayMethod="unsigned integer"/>
        <Element Offset="2408" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000968" DisplayMethod="hexadecimal"/>
        <Element Offset="2412" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000096C" DisplayMethod="unsigned integer"/>
        <Element Offset="2416" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000970" DisplayMethod="hexadecimal"/>
        <Element Offset="2420" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000974" DisplayMethod="unsigned integer"/>
        <Element Offset="2424" Vartype="Float" Bytesize="4" OffsetHex="00000978" DisplayMethod="unsigned integer"/>
        <Element Offset="2428" Vartype="String" Bytesize="4" OffsetHex="0000097C" DisplayMethod="unsigned integer"/>
        <Element Offset="2432" Vartype="Byte" Bytesize="1" OffsetHex="00000980" DisplayMethod="unsigned integer"/>
        <Element Offset="2433" Vartype="String" Bytesize="9" OffsetHex="00000981" DisplayMethod="unsigned integer"/>
        <Element Offset="2442" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="0000098A" DisplayMethod="unsigned integer"/>
        <Element Offset="2444" Vartype="Pointer" Bytesize="8" OffsetHex="0000098C" DisplayMethod="unsigned integer"/>
        <Element Offset="2448" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000990" DisplayMethod="hexadecimal"/>
        <Element Offset="2452" Vartype="Pointer" Bytesize="8" OffsetHex="00000994" DisplayMethod="unsigned integer"/>
        <Element Offset="2456" Vartype="4 Bytes" Bytesize="4" RLECount="132" OffsetHex="00000998" DisplayMethod="hexadecimal"/>
        <Element Offset="2984" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2988" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000BAC" DisplayMethod="hexadecimal"/>
        <Element Offset="3000" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3004" Vartype="4 Bytes" Bytesize="4" RLECount="24" OffsetHex="00000BBC" DisplayMethod="hexadecimal"/>
        <Element Offset="3100" Vartype="Pointer" Bytesize="8" OffsetHex="00000C1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3104" Vartype="Pointer" Bytesize="8" OffsetHex="00000C20" DisplayMethod="unsigned integer"/>
        <Element Offset="3108" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000C24" DisplayMethod="hexadecimal"/>
        <Element Offset="3124" Vartype="Pointer" Bytesize="8" OffsetHex="00000C34" DisplayMethod="unsigned integer"/>
        <Element Offset="3128" Vartype="4 Bytes" Bytesize="4" RLECount="16" OffsetHex="00000C38" DisplayMethod="hexadecimal"/>
        <Element Offset="3192" Vartype="Pointer" Bytesize="8" OffsetHex="00000C78" DisplayMethod="unsigned integer"/>
        <Element Offset="3196" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C7C" DisplayMethod="hexadecimal"/>
        <Element Offset="3200" Vartype="Pointer" Bytesize="8" OffsetHex="00000C80" DisplayMethod="unsigned integer"/>
        <Element Offset="3204" Vartype="Pointer" Bytesize="8" OffsetHex="00000C84" DisplayMethod="unsigned integer"/>
        <Element Offset="3208" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C88" DisplayMethod="hexadecimal"/>
        <Element Offset="3216" Vartype="Pointer" Bytesize="8" OffsetHex="00000C90" DisplayMethod="unsigned integer"/>
        <Element Offset="3220" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C94" DisplayMethod="hexadecimal"/>
        <Element Offset="3228" Vartype="Pointer" Bytesize="8" OffsetHex="00000C9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3232" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000CA0" DisplayMethod="hexadecimal"/>
        <Element Offset="3248" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3252" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CB4" DisplayMethod="hexadecimal"/>
        <Element Offset="3256" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3260" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CBC" DisplayMethod="hexadecimal"/>
        <Element Offset="3264" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3268" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3272" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3276" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CCC" DisplayMethod="hexadecimal"/>
        <Element Offset="3280" Vartype="Pointer" Bytesize="8" OffsetHex="00000CD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3284" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CD4" DisplayMethod="hexadecimal"/>
        <Element Offset="3288" Vartype="Pointer" Bytesize="8" OffsetHex="00000CD8" DisplayMethod="unsigned integer"/>
        <Element Offset="3292" Vartype="Pointer" Bytesize="8" OffsetHex="00000CDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3296" Vartype="4 Bytes" Bytesize="4" RLECount="17" OffsetHex="00000CE0" DisplayMethod="hexadecimal"/>
        <Element Offset="3364" Vartype="Pointer" Bytesize="8" OffsetHex="00000D24" DisplayMethod="unsigned integer"/>
        <Element Offset="3368" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D28" DisplayMethod="hexadecimal"/>
        <Element Offset="3372" Vartype="Pointer" Bytesize="8" OffsetHex="00000D2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3376" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D30" DisplayMethod="hexadecimal"/>
        <Element Offset="3384" Vartype="Pointer" Bytesize="8" OffsetHex="00000D38" DisplayMethod="unsigned integer"/>
        <Element Offset="3388" Vartype="Pointer" Bytesize="8" OffsetHex="00000D3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3392" Vartype="Pointer" Bytesize="8" OffsetHex="00000D40" DisplayMethod="unsigned integer"/>
        <Element Offset="3396" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D44" DisplayMethod="hexadecimal"/>
        <Element Offset="3400" Vartype="Pointer" Bytesize="8" OffsetHex="00000D48" DisplayMethod="unsigned integer"/>
        <Element Offset="3404" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D4C" DisplayMethod="hexadecimal"/>
        <Element Offset="3408" Vartype="Pointer" Bytesize="8" OffsetHex="00000D50" DisplayMethod="unsigned integer"/>
        <Element Offset="3412" Vartype="Pointer" Bytesize="8" OffsetHex="00000D54" DisplayMethod="unsigned integer"/>
        <Element Offset="3416" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D58" DisplayMethod="hexadecimal"/>
        <Element Offset="3420" Vartype="Pointer" Bytesize="8" OffsetHex="00000D5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3424" Vartype="Pointer" Bytesize="8" OffsetHex="00000D60" DisplayMethod="unsigned integer"/>
        <Element Offset="3428" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D64" DisplayMethod="hexadecimal"/>
        <Element Offset="3436" Vartype="Pointer" Bytesize="8" OffsetHex="00000D6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3440" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D70" DisplayMethod="hexadecimal"/>
        <Element Offset="3444" Vartype="Pointer" Bytesize="8" OffsetHex="00000D74" DisplayMethod="unsigned integer"/>
        <Element Offset="3448" Vartype="Pointer" Bytesize="8" OffsetHex="00000D78" DisplayMethod="unsigned integer"/>
        <Element Offset="3452" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D7C" DisplayMethod="hexadecimal"/>
        <Element Offset="3460" Vartype="Pointer" Bytesize="8" OffsetHex="00000D84" DisplayMethod="unsigned integer"/>
        <Element Offset="3464" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D88" DisplayMethod="hexadecimal"/>
      </Elements>
    </Structure>
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="24" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000018" DisplayMethod="hexadecimal"/>
        <Element Offset="28" Vartype="Pointer" Bytesize="8" OffsetHex="0000001C" DisplayMethod="unsigned integer"/>
        <Element Offset="32" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000020" DisplayMethod="unsigned integer"/>
        <Element Offset="40" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000028" DisplayMethod="unsigned integer"/>
        <Element Offset="48" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000030" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="92" Vartype="Float" Bytesize="4" OffsetHex="0000005C" DisplayMethod="unsigned integer"/>
        <Element Offset="96" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000060" DisplayMethod="hexadecimal"/>
        <Element Offset="104" Vartype="Pointer" Bytesize="8" OffsetHex="00000068" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="Pointer" Bytesize="8" OffsetHex="0000006C" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Pointer" Bytesize="8" OffsetHex="00000070" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="128" Vartype="Double" Bytesize="8" OffsetHex="00000080" DisplayMethod="unsigned integer"/>
        <Element Offset="136" Vartype="Float" Bytesize="4" OffsetHex="00000088" DisplayMethod="unsigned integer"/>
        <Element Offset="140" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000008C" DisplayMethod="unsigned integer"/>
        <Element Offset="152" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000098" DisplayMethod="unsigned integer"/>
        <Element Offset="164" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000000A4" DisplayMethod="unsigned integer"/>
        <Element Offset="176" Vartype="Float" Bytesize="4" OffsetHex="000000B0" DisplayMethod="unsigned integer"/>
        <Element Offset="180" Vartype="Double" Bytesize="8" OffsetHex="000000B4" DisplayMethod="unsigned integer"/>
        <Element Offset="188" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000000BC" DisplayMethod="unsigned integer"/>
        <Element Offset="200" Vartype="Pointer" Bytesize="8" OffsetHex="000000C8" DisplayMethod="unsigned integer"/>
        <Element Offset="204" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000CC" DisplayMethod="unsigned integer"/>
        <Element Offset="208" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000000D0" DisplayMethod="unsigned integer"/>
        <Element Offset="216" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000D8" DisplayMethod="hexadecimal"/>
        <Element Offset="224" Vartype="Pointer" Bytesize="8" OffsetHex="000000E0" DisplayMethod="unsigned integer"/>
        <Element Offset="228" Vartype="Pointer" Bytesize="8" OffsetHex="000000E4" DisplayMethod="unsigned integer"/>
        <Element Offset="232" Vartype="Pointer" Bytesize="8" OffsetHex="000000E8" DisplayMethod="unsigned integer"/>
        <Element Offset="236" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="000000EC" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000110" DisplayMethod="unsigned integer"/>
        <Element Offset="284" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000011C" DisplayMethod="unsigned integer"/>
        <Element Offset="304" Vartype="Float" Bytesize="4" OffsetHex="00000130" DisplayMethod="unsigned integer"/>
        <Element Offset="308" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000134" DisplayMethod="unsigned integer"/>
        <Element Offset="320" Vartype="Pointer" Bytesize="8" OffsetHex="00000140" DisplayMethod="unsigned integer"/>
        <Element Offset="324" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000144" DisplayMethod="unsigned integer"/>
        <Element Offset="328" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000148" DisplayMethod="unsigned integer"/>
        <Element Offset="336" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000150" DisplayMethod="hexadecimal"/>
        <Element Offset="344" Vartype="Pointer" Bytesize="8" OffsetHex="00000158" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="Pointer" Bytesize="8" OffsetHex="0000015C" DisplayMethod="unsigned integer"/>
        <Element Offset="352" Vartype="Pointer" Bytesize="8" OffsetHex="00000160" DisplayMethod="unsigned integer"/>
        <Element Offset="356" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000164" DisplayMethod="unsigned integer"/>
        <Element Offset="392" Vartype="Byte" Bytesize="1" OffsetHex="00000188" DisplayMethod="unsigned integer"/>
        <Element Offset="393" Vartype="String" Bytesize="4" OffsetHex="00000189" DisplayMethod="unsigned integer"/>
        <Element Offset="397" Vartype="Byte" Bytesize="1" OffsetHex="0000018D" DisplayMethod="unsigned integer"/>
        <Element Offset="398" Vartype="String" Bytesize="4" OffsetHex="0000018E" DisplayMethod="unsigned integer"/>
        <Element Offset="402" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000192" DisplayMethod="unsigned integer"/>
        <Element Offset="404" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000194" DisplayMethod="unsigned integer"/>
        <Element Offset="412" Vartype="Double" Bytesize="8" OffsetHex="0000019C" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000001A4" DisplayMethod="unsigned integer"/>
        <Element Offset="428" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000001AC" DisplayMethod="unsigned integer"/>
        <Element Offset="440" Vartype="Pointer" Bytesize="8" OffsetHex="000001B8" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001C8" DisplayMethod="hexadecimal"/>
        <Element Offset="464" Vartype="Pointer" Bytesize="8" OffsetHex="000001D0" DisplayMethod="unsigned integer"/>
        <Element Offset="468" Vartype="Pointer" Bytesize="8" OffsetHex="000001D4" DisplayMethod="unsigned integer"/>
        <Element Offset="472" Vartype="Pointer" Bytesize="8" OffsetHex="000001D8" DisplayMethod="unsigned integer"/>
        <Element Offset="476" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001DC" DisplayMethod="unsigned integer"/>
        <Element Offset="480" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000001E0" DisplayMethod="unsigned integer"/>
        <Element Offset="504" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001F8" DisplayMethod="unsigned integer"/>
        <Element Offset="512" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000200" DisplayMethod="unsigned integer"/>
        <Element Offset="520" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="00000208" DisplayMethod="unsigned integer"/>
        <Element Offset="572" Vartype="Float" Bytesize="4" OffsetHex="0000023C" DisplayMethod="unsigned integer"/>
        <Element Offset="576" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000240" DisplayMethod="hexadecimal"/>
        <Element Offset="584" Vartype="Pointer" Bytesize="8" OffsetHex="00000248" DisplayMethod="unsigned integer"/>
        <Element Offset="588" Vartype="Pointer" Bytesize="8" OffsetHex="0000024C" DisplayMethod="unsigned integer"/>
        <Element Offset="592" Vartype="Pointer" Bytesize="8" OffsetHex="00000250" DisplayMethod="unsigned integer"/>
        <Element Offset="596" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000254" DisplayMethod="unsigned integer"/>
        <Element Offset="612" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000264" DisplayMethod="unsigned integer"/>
        <Element Offset="620" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000026C" DisplayMethod="unsigned integer"/>
        <Element Offset="632" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000278" DisplayMethod="unsigned integer"/>
        <Element Offset="644" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000284" DisplayMethod="hexadecimal"/>
        <Element Offset="652" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000028C" DisplayMethod="unsigned integer"/>
        <Element Offset="656" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000290" DisplayMethod="unsigned integer"/>
        <Element Offset="668" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000029C" DisplayMethod="unsigned integer"/>
        <Element Offset="680" Vartype="Pointer" Bytesize="8" OffsetHex="000002A8" DisplayMethod="unsigned integer"/>
        <Element Offset="684" Vartype="Double" Bytesize="8" OffsetHex="000002AC" DisplayMethod="unsigned integer"/>
        <Element Offset="692" Vartype="Float" Bytesize="4" OffsetHex="000002B4" DisplayMethod="unsigned integer"/>
        <Element Offset="696" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000002B8" DisplayMethod="hexadecimal"/>
        <Element Offset="704" Vartype="Pointer" Bytesize="8" OffsetHex="000002C0" DisplayMethod="unsigned integer"/>
        <Element Offset="708" Vartype="Pointer" Bytesize="8" OffsetHex="000002C4" DisplayMethod="unsigned integer"/>
        <Element Offset="712" Vartype="Pointer" Bytesize="8" OffsetHex="000002C8" DisplayMethod="unsigned integer"/>
        <Element Offset="716" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000002CC" DisplayMethod="unsigned integer"/>
        <Element Offset="728" Vartype="Double" Bytesize="8" OffsetHex="000002D8" DisplayMethod="unsigned integer"/>
        <Element Offset="736" Vartype="Float" Bytesize="4" OffsetHex="000002E0" DisplayMethod="unsigned integer"/>
        <Element Offset="740" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002E4" DisplayMethod="unsigned integer"/>
        <Element Offset="744" Vartype="Pointer" Bytesize="8" OffsetHex="000002E8" DisplayMethod="unsigned integer"/>
        <Element Offset="748" Vartype="Pointer" Bytesize="8" OffsetHex="000002EC" DisplayMethod="unsigned integer"/>
        <Element Offset="752" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000002F0" DisplayMethod="unsigned integer"/>
        <Element Offset="764" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000002FC" DisplayMethod="unsigned integer"/>
        <Element Offset="776" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000308" DisplayMethod="unsigned integer"/>
        <Element Offset="788" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000314" DisplayMethod="unsigned integer"/>
        <Element Offset="800" Vartype="Pointer" Bytesize="8" OffsetHex="00000320" DisplayMethod="unsigned integer"/>
        <Element Offset="804" Vartype="Double" Bytesize="8" OffsetHex="00000324" DisplayMethod="unsigned integer"/>
        <Element Offset="812" Vartype="Float" Bytesize="4" OffsetHex="0000032C" DisplayMethod="unsigned integer"/>
        <Element Offset="816" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000330" DisplayMethod="hexadecimal"/>
        <Element Offset="824" Vartype="Pointer" Bytesize="8" OffsetHex="00000338" DisplayMethod="unsigned integer"/>
        <Element Offset="828" Vartype="Pointer" Bytesize="8" OffsetHex="0000033C" DisplayMethod="unsigned integer"/>
        <Element Offset="832" Vartype="Pointer" Bytesize="8" OffsetHex="00000340" DisplayMethod="unsigned integer"/>
        <Element Offset="836" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000344" DisplayMethod="unsigned integer"/>
        <Element Offset="872" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000368" DisplayMethod="unsigned integer"/>
        <Element Offset="884" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000374" DisplayMethod="unsigned integer"/>
        <Element Offset="892" Vartype="Double" Bytesize="8" OffsetHex="0000037C" DisplayMethod="unsigned integer"/>
        <Element Offset="900" Vartype="Float" Bytesize="4" OffsetHex="00000384" DisplayMethod="unsigned integer"/>
        <Element Offset="904" Vartype="String" Bytesize="5" OffsetHex="00000388" DisplayMethod="unsigned integer"/>
        <Element Offset="909" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="0000038D" DisplayMethod="unsigned integer"/>
        <Element Offset="912" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000390" DisplayMethod="unsigned integer"/>
        <Element Offset="920" Vartype="Pointer" Bytesize="8" OffsetHex="00000398" DisplayMethod="unsigned integer"/>
        <Element Offset="924" Vartype="Double" Bytesize="8" OffsetHex="0000039C" DisplayMethod="unsigned integer"/>
        <Element Offset="932" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003A4" DisplayMethod="unsigned integer"/>
        <Element Offset="936" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003A8" DisplayMethod="hexadecimal"/>
        <Element Offset="944" Vartype="Pointer" Bytesize="8" OffsetHex="000003B0" DisplayMethod="unsigned integer"/>
        <Element Offset="948" Vartype="Pointer" Bytesize="8" OffsetHex="000003B4" DisplayMethod="unsigned integer"/>
        <Element Offset="952" Vartype="Pointer" Bytesize="8" OffsetHex="000003B8" DisplayMethod="unsigned integer"/>
        <Element Offset="956" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000003BC" DisplayMethod="unsigned integer"/>
        <Element Offset="968" Vartype="Double" Bytesize="8" OffsetHex="000003C8" DisplayMethod="unsigned integer"/>
        <Element Offset="976" Vartype="Float" Bytesize="4" OffsetHex="000003D0" DisplayMethod="unsigned integer"/>
        <Element Offset="980" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003D4" DisplayMethod="unsigned integer"/>
        <Element Offset="984" Vartype="Pointer" Bytesize="8" OffsetHex="000003D8" DisplayMethod="unsigned integer"/>
        <Element Offset="988" Vartype="Pointer" Bytesize="8" OffsetHex="000003DC" DisplayMethod="unsigned integer"/>
        <Element Offset="992" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000003E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1004" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1012" Vartype="Double" Bytesize="8" OffsetHex="000003F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1020" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000003FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1028" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000404" DisplayMethod="unsigned integer"/>
        <Element Offset="1040" Vartype="Pointer" Bytesize="8" OffsetHex="00000410" DisplayMethod="unsigned integer"/>
        <Element Offset="1044" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000414" DisplayMethod="unsigned integer"/>
        <Element Offset="1048" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000418" DisplayMethod="unsigned integer"/>
        <Element Offset="1056" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000420" DisplayMethod="hexadecimal"/>
        <Element Offset="1064" Vartype="Pointer" Bytesize="8" OffsetHex="00000428" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="Pointer" Bytesize="8" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="Pointer" Bytesize="8" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1076" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000434" DisplayMethod="unsigned integer"/>
        <Element Offset="1088" Vartype="Double" Bytesize="8" OffsetHex="00000440" DisplayMethod="unsigned integer"/>
        <Element Offset="1096" Vartype="Float" Bytesize="4" OffsetHex="00000448" DisplayMethod="unsigned integer"/>
        <Element Offset="1100" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000044C" DisplayMethod="unsigned integer"/>
        <Element Offset="1104" Vartype="Pointer" Bytesize="8" OffsetHex="00000450" DisplayMethod="unsigned integer"/>
        <Element Offset="1108" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000454" DisplayMethod="unsigned integer"/>
        <Element Offset="1112" Vartype="Float" Bytesize="4" OffsetHex="00000458" DisplayMethod="unsigned integer"/>
        <Element Offset="1116" Vartype="String" Bytesize="6" OffsetHex="0000045C" DisplayMethod="unsigned integer"/>
        <Element Offset="1122" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000462" DisplayMethod="unsigned integer"/>
        <Element Offset="1124" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000464" DisplayMethod="hexadecimal"/>
        <Element Offset="1132" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000046C" DisplayMethod="unsigned integer"/>
        <Element Offset="1136" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000470" DisplayMethod="unsigned integer"/>
        <Element Offset="1148" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000047C" DisplayMethod="unsigned integer"/>
        <Element Offset="1160" Vartype="Pointer" Bytesize="8" OffsetHex="00000488" DisplayMethod="unsigned integer"/>
        <Element Offset="1164" Vartype="Double" Bytesize="8" OffsetHex="0000048C" DisplayMethod="unsigned integer"/>
        <Element Offset="1172" Vartype="Float" Bytesize="4" OffsetHex="00000494" DisplayMethod="unsigned integer"/>
        <Element Offset="1176" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000498" DisplayMethod="hexadecimal"/>
        <Element Offset="1184" Vartype="Pointer" Bytesize="8" OffsetHex="000004A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1188" Vartype="Pointer" Bytesize="8" OffsetHex="000004A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1192" Vartype="Pointer" Bytesize="8" OffsetHex="000004A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1196" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000004AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1208" Vartype="Double" Bytesize="8" OffsetHex="000004B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1216" Vartype="Float" Bytesize="4" OffsetHex="000004C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1220" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1224" Vartype="Pointer" Bytesize="8" OffsetHex="000004C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1228" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="000004CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1256" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000004E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1280" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000500" DisplayMethod="unsigned integer"/>
        <Element Offset="1284" Vartype="Double" Bytesize="8" OffsetHex="00000504" DisplayMethod="unsigned integer"/>
        <Element Offset="1292" Vartype="Float" Bytesize="4" OffsetHex="0000050C" DisplayMethod="unsigned integer"/>
        <Element Offset="1296" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000510" DisplayMethod="hexadecimal"/>
        <Element Offset="1304" Vartype="Pointer" Bytesize="8" OffsetHex="00000518" DisplayMethod="unsigned integer"/>
        <Element Offset="1308" Vartype="Pointer" Bytesize="8" OffsetHex="0000051C" DisplayMethod="unsigned integer"/>
        <Element Offset="1312" Vartype="Pointer" Bytesize="8" OffsetHex="00000520" DisplayMethod="unsigned integer"/>
        <Element Offset="1316" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000524" DisplayMethod="unsigned integer"/>
        <Element Offset="1328" Vartype="Double" Bytesize="8" OffsetHex="00000530" DisplayMethod="unsigned integer"/>
        <Element Offset="1336" Vartype="Float" Bytesize="4" OffsetHex="00000538" DisplayMethod="unsigned integer"/>
        <Element Offset="1340" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000053C" DisplayMethod="unsigned integer"/>
        <Element Offset="1348" Vartype="Pointer" Bytesize="8" OffsetHex="00000544" DisplayMethod="unsigned integer"/>
        <Element Offset="1352" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000548" DisplayMethod="unsigned integer"/>
        <Element Offset="1364" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000554" DisplayMethod="unsigned integer"/>
        <Element Offset="1376" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000560" DisplayMethod="unsigned integer"/>
        <Element Offset="1388" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000056C" DisplayMethod="unsigned integer"/>
        <Element Offset="1400" Vartype="Pointer" Bytesize="8" OffsetHex="00000578" DisplayMethod="unsigned integer"/>
        <Element Offset="1404" Vartype="Double" Bytesize="8" OffsetHex="0000057C" DisplayMethod="unsigned integer"/>
        <Element Offset="1412" Vartype="Float" Bytesize="4" OffsetHex="00000584" DisplayMethod="unsigned integer"/>
        <Element Offset="1416" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000588" DisplayMethod="hexadecimal"/>
        <Element Offset="1424" Vartype="Pointer" Bytesize="8" OffsetHex="00000590" DisplayMethod="unsigned integer"/>
        <Element Offset="1428" Vartype="Pointer" Bytesize="8" OffsetHex="00000594" DisplayMethod="unsigned integer"/>
        <Element Offset="1432" Vartype="Pointer" Bytesize="8" OffsetHex="00000598" DisplayMethod="unsigned integer"/>
        <Element Offset="1436" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000059C" DisplayMethod="unsigned integer"/>
        <Element Offset="1448" Vartype="Double" Bytesize="8" OffsetHex="000005A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1456" Vartype="Float" Bytesize="4" OffsetHex="000005B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1460" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000005B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1468" Vartype="Pointer" Bytesize="8" OffsetHex="000005BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1472" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="000005C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1488" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000005D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1492" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="000005D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1520" Vartype="Pointer" Bytesize="8" OffsetHex="000005F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1524" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000005F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1532" Vartype="Pointer" Bytesize="8" OffsetHex="000005FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1536" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000600" DisplayMethod="hexadecimal"/>
        <Element Offset="1544" Vartype="Pointer" Bytesize="8" OffsetHex="00000608" DisplayMethod="unsigned integer"/>
        <Element Offset="1548" Vartype="Pointer" Bytesize="8" OffsetHex="0000060C" DisplayMethod="unsigned integer"/>
        <Element Offset="1552" Vartype="Pointer" Bytesize="8" OffsetHex="00000610" DisplayMethod="unsigned integer"/>
        <Element Offset="1556" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000614" DisplayMethod="unsigned integer"/>
        <Element Offset="1568" Vartype="Double" Bytesize="8" OffsetHex="00000620" DisplayMethod="unsigned integer"/>
        <Element Offset="1576" Vartype="Float" Bytesize="4" OffsetHex="00000628" DisplayMethod="unsigned integer"/>
        <Element Offset="1580" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000062C" DisplayMethod="unsigned integer"/>
        <Element Offset="1584" Vartype="Pointer" Bytesize="8" OffsetHex="00000630" DisplayMethod="unsigned integer"/>
        <Element Offset="1588" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000634" DisplayMethod="unsigned integer"/>
        <Element Offset="1592" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000638" DisplayMethod="unsigned integer"/>
        <Element Offset="1604" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000644" DisplayMethod="unsigned integer"/>
        <Element Offset="1612" Vartype="Double" Bytesize="8" OffsetHex="0000064C" DisplayMethod="unsigned integer"/>
        <Element Offset="1620" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000654" DisplayMethod="unsigned integer"/>
        <Element Offset="1628" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000065C" DisplayMethod="unsigned integer"/>
        <Element Offset="1640" Vartype="Pointer" Bytesize="8" OffsetHex="00000668" DisplayMethod="unsigned integer"/>
        <Element Offset="1644" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000066C" DisplayMethod="unsigned integer"/>
        <Element Offset="1652" Vartype="Pointer" Bytesize="8" OffsetHex="00000674" DisplayMethod="unsigned integer"/>
        <Element Offset="1656" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000678" DisplayMethod="hexadecimal"/>
        <Element Offset="1664" Vartype="Pointer" Bytesize="8" OffsetHex="00000680" DisplayMethod="unsigned integer"/>
        <Element Offset="1668" Vartype="Pointer" Bytesize="8" OffsetHex="00000684" DisplayMethod="unsigned integer"/>
        <Element Offset="1672" Vartype="Pointer" Bytesize="8" OffsetHex="00000688" DisplayMethod="unsigned integer"/>
        <Element Offset="1676" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000068C" DisplayMethod="unsigned integer"/>
        <Element Offset="1688" Vartype="Double" Bytesize="8" OffsetHex="00000698" DisplayMethod="unsigned integer"/>
        <Element Offset="1696" Vartype="Float" Bytesize="4" OffsetHex="000006A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1700" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000006A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1708" Vartype="Double" Bytesize="8" OffsetHex="000006AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1716" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000006B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1724" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000006BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1732" Vartype="Double" Bytesize="8" OffsetHex="000006C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1740" Vartype="Float" Bytesize="4" OffsetHex="000006CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1744" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000006D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1748" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000006D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1760" Vartype="Pointer" Bytesize="8" OffsetHex="000006E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1764" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000006E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1772" Vartype="Pointer" Bytesize="8" OffsetHex="000006EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1776" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000006F0" DisplayMethod="hexadecimal"/>
        <Element Offset="1784" Vartype="Pointer" Bytesize="8" OffsetHex="000006F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1788" Vartype="Pointer" Bytesize="8" OffsetHex="000006FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1792" Vartype="Pointer" Bytesize="8" OffsetHex="00000700" DisplayMethod="unsigned integer"/>
        <Element Offset="1796" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000704" DisplayMethod="unsigned integer"/>
        <Element Offset="1808" Vartype="Double" Bytesize="8" OffsetHex="00000710" DisplayMethod="unsigned integer"/>
        <Element Offset="1816" Vartype="Float" Bytesize="4" OffsetHex="00000718" DisplayMethod="unsigned integer"/>
        <Element Offset="1820" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000071C" DisplayMethod="unsigned integer"/>
        <Element Offset="1828" Vartype="Pointer" Bytesize="8" OffsetHex="00000724" DisplayMethod="unsigned integer"/>
        <Element Offset="1832" Vartype="Float" Bytesize="4" OffsetHex="00000728" DisplayMethod="unsigned integer"/>
        <Element Offset="1836" Vartype="Byte" Bytesize="1" OffsetHex="0000072C" DisplayMethod="unsigned integer"/>
        <Element Offset="1837" Vartype="String" Bytesize="4" OffsetHex="0000072D" DisplayMethod="unsigned integer"/>
        <Element Offset="1841" Vartype="Byte" Bytesize="1" OffsetHex="00000731" DisplayMethod="unsigned integer"/>
        <Element Offset="1842" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000732" DisplayMethod="unsigned integer"/>
        <Element Offset="1844" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000734" DisplayMethod="unsigned integer"/>
        <Element Offset="1868" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000074C" DisplayMethod="unsigned integer"/>
        <Element Offset="1872" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000750" DisplayMethod="unsigned integer"/>
        <Element Offset="1880" Vartype="Pointer" Bytesize="8" OffsetHex="00000758" DisplayMethod="unsigned integer"/>
        <Element Offset="1884" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000075C" DisplayMethod="unsigned integer"/>
        <Element Offset="1888" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000760" DisplayMethod="unsigned integer"/>
        <Element Offset="1896" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000768" DisplayMethod="hexadecimal"/>
        <Element Offset="1904" Vartype="Pointer" Bytesize="8" OffsetHex="00000770" DisplayMethod="unsigned integer"/>
        <Element Offset="1908" Vartype="Pointer" Bytesize="8" OffsetHex="00000774" DisplayMethod="unsigned integer"/>
        <Element Offset="1912" Vartype="Pointer" Bytesize="8" OffsetHex="00000778" DisplayMethod="unsigned integer"/>
        <Element Offset="1916" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000077C" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="Double" Bytesize="8" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1936" Vartype="Float" Bytesize="4" OffsetHex="00000790" DisplayMethod="unsigned integer"/>
        <Element Offset="1940" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000794" DisplayMethod="unsigned integer"/>
        <Element Offset="1944" Vartype="Pointer" Bytesize="8" OffsetHex="00000798" DisplayMethod="unsigned integer"/>
        <Element Offset="1948" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000079C" DisplayMethod="unsigned integer"/>
        <Element Offset="1952" Vartype="Float" Bytesize="4" OffsetHex="000007A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1956" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000007A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1976" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000007B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1988" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000007C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1992" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000007C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2000" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000007D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2008" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000007D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000007E0" DisplayMethod="hexadecimal"/>
        <Element Offset="2024" Vartype="Pointer" Bytesize="8" OffsetHex="000007E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2028" Vartype="Pointer" Bytesize="8" OffsetHex="000007EC" DisplayMethod="unsigned integer"/>
        <Element Offset="2032" Vartype="Pointer" Bytesize="8" OffsetHex="000007F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2036" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="000007F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2072" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000818" DisplayMethod="unsigned integer"/>
        <Element Offset="2084" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000824" DisplayMethod="hexadecimal"/>
        <Element Offset="2092" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000082C" DisplayMethod="unsigned integer"/>
        <Element Offset="2096" Vartype="Double" Bytesize="8" OffsetHex="00000830" DisplayMethod="unsigned integer"/>
        <Element Offset="2104" Vartype="Float" Bytesize="4" OffsetHex="00000838" DisplayMethod="unsigned integer"/>
        <Element Offset="2108" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000083C" DisplayMethod="unsigned integer"/>
        <Element Offset="2120" Vartype="Pointer" Bytesize="8" OffsetHex="00000848" DisplayMethod="unsigned integer"/>
        <Element Offset="2124" Vartype="Double" Bytesize="8" OffsetHex="0000084C" DisplayMethod="unsigned integer"/>
        <Element Offset="2132" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000854" DisplayMethod="unsigned integer"/>
        <Element Offset="2136" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000858" DisplayMethod="hexadecimal"/>
        <Element Offset="2144" Vartype="Pointer" Bytesize="8" OffsetHex="00000860" DisplayMethod="unsigned integer"/>
        <Element Offset="2148" Vartype="Pointer" Bytesize="8" OffsetHex="00000864" DisplayMethod="unsigned integer"/>
        <Element Offset="2152" Vartype="Pointer" Bytesize="8" OffsetHex="00000868" DisplayMethod="unsigned integer"/>
        <Element Offset="2156" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="0000086C" DisplayMethod="unsigned integer"/>
        <Element Offset="2192" Vartype="Float" Bytesize="4" OffsetHex="00000890" DisplayMethod="unsigned integer"/>
        <Element Offset="2196" Vartype="Byte" Bytesize="1" OffsetHex="00000894" DisplayMethod="unsigned integer"/>
        <Element Offset="2197" Vartype="String" Bytesize="5" OffsetHex="00000895" DisplayMethod="unsigned integer"/>
        <Element Offset="2202" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="0000089A" DisplayMethod="unsigned integer"/>
        <Element Offset="2204" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000089C" DisplayMethod="unsigned integer"/>
        <Element Offset="2212" Vartype="Double" Bytesize="8" OffsetHex="000008A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2220" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000008AC" DisplayMethod="unsigned integer"/>
        <Element Offset="2228" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008B4" DisplayMethod="unsigned integer"/>
        <Element Offset="2240" Vartype="Pointer" Bytesize="8" OffsetHex="000008C0" DisplayMethod="unsigned integer"/>
        <Element Offset="2244" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2248" Vartype="Byte" Bytesize="1" OffsetHex="000008C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2249" Vartype="String" Bytesize="4" OffsetHex="000008C9" DisplayMethod="unsigned integer"/>
        <Element Offset="2253" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="000008CD" DisplayMethod="unsigned integer"/>
        <Element Offset="2256" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008D0" DisplayMethod="hexadecimal"/>
        <Element Offset="2264" Vartype="Pointer" Bytesize="8" OffsetHex="000008D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2268" Vartype="Pointer" Bytesize="8" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2272" Vartype="Pointer" Bytesize="8" OffsetHex="000008E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2276" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2288" Vartype="Double" Bytesize="8" OffsetHex="000008F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2296" Vartype="Float" Bytesize="4" OffsetHex="000008F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2300" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2304" Vartype="Pointer" Bytesize="8" OffsetHex="00000900" DisplayMethod="unsigned integer"/>
        <Element Offset="2308" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000904" DisplayMethod="unsigned integer"/>
        <Element Offset="2312" Vartype="Float" Bytesize="4" OffsetHex="00000908" DisplayMethod="unsigned integer"/>
        <Element Offset="2316" Vartype="Byte" Bytesize="1" OffsetHex="0000090C" DisplayMethod="unsigned integer"/>
        <Element Offset="2317" Vartype="String" Bytesize="5" OffsetHex="0000090D" DisplayMethod="unsigned integer"/>
        <Element Offset="2322" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000912" DisplayMethod="unsigned integer"/>
        <Element Offset="2324" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000914" DisplayMethod="hexadecimal"/>
        <Element Offset="2332" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000091C" DisplayMethod="unsigned integer"/>
        <Element Offset="2336" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000920" DisplayMethod="unsigned integer"/>
        <Element Offset="2348" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000092C" DisplayMethod="unsigned integer"/>
        <Element Offset="2360" Vartype="Pointer" Bytesize="8" OffsetHex="00000938" DisplayMethod="unsigned integer"/>
        <Element Offset="2364" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000093C" DisplayMethod="unsigned integer"/>
        <Element Offset="2368" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000940" DisplayMethod="unsigned integer"/>
        <Element Offset="2376" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000948" DisplayMethod="hexadecimal"/>
        <Element Offset="2384" Vartype="Pointer" Bytesize="8" OffsetHex="00000950" DisplayMethod="unsigned integer"/>
        <Element Offset="2388" Vartype="Pointer" Bytesize="8" OffsetHex="00000954" DisplayMethod="unsigned integer"/>
        <Element Offset="2392" Vartype="Pointer" Bytesize="8" OffsetHex="00000958" DisplayMethod="unsigned integer"/>
        <Element Offset="2396" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000095C" DisplayMethod="unsigned integer"/>
        <Element Offset="2408" Vartype="Double" Bytesize="8" OffsetHex="00000968" DisplayMethod="unsigned integer"/>
        <Element Offset="2416" Vartype="Float" Bytesize="4" OffsetHex="00000970" DisplayMethod="unsigned integer"/>
        <Element Offset="2420" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000974" DisplayMethod="unsigned integer"/>
        <Element Offset="2432" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000980" DisplayMethod="unsigned integer"/>
        <Element Offset="2444" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000098C" DisplayMethod="unsigned integer"/>
        <Element Offset="2456" Vartype="Float" Bytesize="4" OffsetHex="00000998" DisplayMethod="unsigned integer"/>
        <Element Offset="2460" Vartype="Double" Bytesize="8" OffsetHex="0000099C" DisplayMethod="unsigned integer"/>
        <Element Offset="2468" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000009A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2480" Vartype="Pointer" Bytesize="8" OffsetHex="000009B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2484" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009B4" DisplayMethod="unsigned integer"/>
        <Element Offset="2488" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000009B8" DisplayMethod="unsigned integer"/>
        <Element Offset="2496" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009C0" DisplayMethod="hexadecimal"/>
        <Element Offset="2504" Vartype="Pointer" Bytesize="8" OffsetHex="000009C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2508" Vartype="Pointer" Bytesize="8" OffsetHex="000009CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2512" Vartype="Pointer" Bytesize="8" OffsetHex="000009D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2516" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="000009D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2544" Vartype="Pointer" Bytesize="8" OffsetHex="000009F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2548" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2552" Vartype="Float" Bytesize="4" OffsetHex="000009F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2556" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000009FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2560" Vartype="Float" Bytesize="4" RLECount="10" OffsetHex="00000A00" DisplayMethod="unsigned integer"/>
        <Element Offset="2600" Vartype="Pointer" Bytesize="8" OffsetHex="00000A28" DisplayMethod="unsigned integer"/>
        <Element Offset="2604" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A2C" DisplayMethod="unsigned integer"/>
        <Element Offset="2608" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000A30" DisplayMethod="unsigned integer"/>
        <Element Offset="2616" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A38" DisplayMethod="hexadecimal"/>
        <Element Offset="2624" Vartype="Pointer" Bytesize="8" OffsetHex="00000A40" DisplayMethod="unsigned integer"/>
        <Element Offset="2628" Vartype="Pointer" Bytesize="8" OffsetHex="00000A44" DisplayMethod="unsigned integer"/>
        <Element Offset="2632" Vartype="Pointer" Bytesize="8" OffsetHex="00000A48" DisplayMethod="unsigned integer"/>
        <Element Offset="2636" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000A4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2648" Vartype="Double" Bytesize="8" OffsetHex="00000A58" DisplayMethod="unsigned integer"/>
        <Element Offset="2656" Vartype="Float" Bytesize="4" OffsetHex="00000A60" DisplayMethod="unsigned integer"/>
        <Element Offset="2660" Vartype="Pointer" Bytesize="8" OffsetHex="00000A64" DisplayMethod="unsigned integer"/>
        <Element Offset="2664" Vartype="Pointer" Bytesize="8" OffsetHex="00000A68" DisplayMethod="unsigned integer"/>
        <Element Offset="2668" Vartype="Pointer" Bytesize="8" OffsetHex="00000A6C" DisplayMethod="unsigned integer"/>
        <Element Offset="2672" Vartype="Float" Bytesize="4" OffsetHex="00000A70" DisplayMethod="unsigned integer"/>
        <Element Offset="2676" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A74" DisplayMethod="unsigned integer"/>
        <Element Offset="2684" Vartype="Float" Bytesize="4" OffsetHex="00000A7C" DisplayMethod="unsigned integer"/>
        <Element Offset="2688" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000A80" DisplayMethod="unsigned integer"/>
        <Element Offset="2728" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000AA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2736" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000AB0" DisplayMethod="hexadecimal"/>
        <Element Offset="2744" Vartype="Pointer" Bytesize="8" OffsetHex="00000AB8" DisplayMethod="unsigned integer"/>
        <Element Offset="2748" Vartype="Pointer" Bytesize="8" OffsetHex="00000ABC" DisplayMethod="unsigned integer"/>
        <Element Offset="2752" Vartype="Pointer" Bytesize="8" OffsetHex="00000AC0" DisplayMethod="unsigned integer"/>
        <Element Offset="2756" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000AC4" DisplayMethod="unsigned integer"/>
        <Element Offset="2792" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000AE8" DisplayMethod="unsigned integer"/>
        <Element Offset="2804" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000AF4" DisplayMethod="unsigned integer"/>
        <Element Offset="2812" Vartype="Double" Bytesize="8" OffsetHex="00000AFC" DisplayMethod="unsigned integer"/>
        <Element Offset="2820" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000B04" DisplayMethod="unsigned integer"/>
        <Element Offset="2828" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000B0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2840" Vartype="Pointer" Bytesize="8" OffsetHex="00000B18" DisplayMethod="unsigned integer"/>
        <Element Offset="2844" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B1C" DisplayMethod="unsigned integer"/>
        <Element Offset="2848" Vartype="Float" Bytesize="4" OffsetHex="00000B20" DisplayMethod="unsigned integer"/>
        <Element Offset="2852" Vartype="Byte" Bytesize="1" OffsetHex="00000B24" DisplayMethod="unsigned integer"/>
        <Element Offset="2853" Vartype="String" Bytesize="4" OffsetHex="00000B25" DisplayMethod="unsigned integer"/>
        <Element Offset="2857" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000B29" DisplayMethod="unsigned integer"/>
        <Element Offset="2859" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000B2B" DisplayMethod="unsigned integer"/>
        <Element Offset="2861" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000B2D" DisplayMethod="unsigned integer"/>
        <Element Offset="2864" Vartype="Pointer" Bytesize="8" OffsetHex="00000B30" DisplayMethod="unsigned integer"/>
        <Element Offset="2868" Vartype="Pointer" Bytesize="8" OffsetHex="00000B34" DisplayMethod="unsigned integer"/>
        <Element Offset="2872" Vartype="Pointer" Bytesize="8" OffsetHex="00000B38" DisplayMethod="unsigned integer"/>
        <Element Offset="2876" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000B3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2912" Vartype="Float" Bytesize="4" OffsetHex="00000B60" DisplayMethod="unsigned integer"/>
        <Element Offset="2916" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000B64" DisplayMethod="unsigned integer"/>
        <Element Offset="2920" Vartype="Float" Bytesize="4" OffsetHex="00000B68" DisplayMethod="unsigned integer"/>
        <Element Offset="2924" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B6C" DisplayMethod="unsigned integer"/>
        <Element Offset="2932" Vartype="Double" Bytesize="8" OffsetHex="00000B74" DisplayMethod="unsigned integer"/>
        <Element Offset="2940" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000B7C" DisplayMethod="unsigned integer"/>
        <Element Offset="2948" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000B84" DisplayMethod="unsigned integer"/>
        <Element Offset="2960" Vartype="Pointer" Bytesize="8" OffsetHex="00000B90" DisplayMethod="unsigned integer"/>
        <Element Offset="2964" Vartype="Double" Bytesize="8" OffsetHex="00000B94" DisplayMethod="unsigned integer"/>
        <Element Offset="2972" Vartype="Float" Bytesize="4" OffsetHex="00000B9C" DisplayMethod="unsigned integer"/>
        <Element Offset="2976" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000BA0" DisplayMethod="hexadecimal"/>
        <Element Offset="2984" Vartype="Pointer" Bytesize="8" OffsetHex="00000BA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2988" Vartype="Pointer" Bytesize="8" OffsetHex="00000BAC" DisplayMethod="unsigned integer"/>
        <Element Offset="2992" Vartype="Pointer" Bytesize="8" OffsetHex="00000BB0" DisplayMethod="unsigned integer"/>
        <Element Offset="2996" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000BB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3032" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000BD8" DisplayMethod="unsigned integer"/>
        <Element Offset="3044" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000BE4" DisplayMethod="hexadecimal"/>
        <Element Offset="3052" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000BEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3064" Vartype="Float" Bytesize="4" OffsetHex="00000BF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3068" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000BFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3080" Vartype="Pointer" Bytesize="8" OffsetHex="00000C08" DisplayMethod="unsigned integer"/>
        <Element Offset="3084" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3088" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000C10" DisplayMethod="unsigned integer"/>
        <Element Offset="3096" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C18" DisplayMethod="hexadecimal"/>
        <Element Offset="3104" Vartype="Pointer" Bytesize="8" OffsetHex="00000C20" DisplayMethod="unsigned integer"/>
        <Element Offset="3108" Vartype="Pointer" Bytesize="8" OffsetHex="00000C24" DisplayMethod="unsigned integer"/>
        <Element Offset="3112" Vartype="Pointer" Bytesize="8" OffsetHex="00000C28" DisplayMethod="unsigned integer"/>
        <Element Offset="3116" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3128" Vartype="Double" Bytesize="8" OffsetHex="00000C38" DisplayMethod="unsigned integer"/>
        <Element Offset="3136" Vartype="Float" Bytesize="4" OffsetHex="00000C40" DisplayMethod="unsigned integer"/>
        <Element Offset="3140" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C44" DisplayMethod="unsigned integer"/>
        <Element Offset="3148" Vartype="Pointer" Bytesize="8" OffsetHex="00000C4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3152" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000C50" DisplayMethod="unsigned integer"/>
        <Element Offset="3164" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3172" Vartype="Double" Bytesize="8" OffsetHex="00000C64" DisplayMethod="unsigned integer"/>
        <Element Offset="3180" Vartype="Float" Bytesize="4" OffsetHex="00000C6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3184" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000C70" DisplayMethod="unsigned integer"/>
        <Element Offset="3188" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C74" DisplayMethod="unsigned integer"/>
        <Element Offset="3200" Vartype="Pointer" Bytesize="8" OffsetHex="00000C80" DisplayMethod="unsigned integer"/>
        <Element Offset="3204" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C84" DisplayMethod="unsigned integer"/>
        <Element Offset="3208" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000C88" DisplayMethod="unsigned integer"/>
        <Element Offset="3216" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C90" DisplayMethod="hexadecimal"/>
        <Element Offset="3224" Vartype="Pointer" Bytesize="8" OffsetHex="00000C98" DisplayMethod="unsigned integer"/>
        <Element Offset="3228" Vartype="Pointer" Bytesize="8" OffsetHex="00000C9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3232" Vartype="Pointer" Bytesize="8" OffsetHex="00000CA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3236" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000CA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3248" Vartype="Double" Bytesize="8" OffsetHex="00000CB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3256" Vartype="Float" Bytesize="4" OffsetHex="00000CB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3260" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000CBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3268" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3272" Vartype="Float" Bytesize="4" OffsetHex="00000CC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3276" Vartype="String" Bytesize="5" OffsetHex="00000CCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3281" Vartype="Byte" Bytesize="1" OffsetHex="00000CD1" DisplayMethod="unsigned integer"/>
        <Element Offset="3282" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000CD2" DisplayMethod="unsigned integer"/>
        <Element Offset="3284" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000CD4" DisplayMethod="unsigned integer"/>
        <Element Offset="3308" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000CEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3312" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000CF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3320" Vartype="Pointer" Bytesize="8" OffsetHex="00000CF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3324" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3328" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000D00" DisplayMethod="unsigned integer"/>
        <Element Offset="3336" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D08" DisplayMethod="hexadecimal"/>
        <Element Offset="3344" Vartype="Pointer" Bytesize="8" OffsetHex="00000D10" DisplayMethod="unsigned integer"/>
        <Element Offset="3348" Vartype="Pointer" Bytesize="8" OffsetHex="00000D14" DisplayMethod="unsigned integer"/>
        <Element Offset="3352" Vartype="Pointer" Bytesize="8" OffsetHex="00000D18" DisplayMethod="unsigned integer"/>
        <Element Offset="3356" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000D1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3368" Vartype="Double" Bytesize="8" OffsetHex="00000D28" DisplayMethod="unsigned integer"/>
        <Element Offset="3376" Vartype="Float" Bytesize="4" OffsetHex="00000D30" DisplayMethod="unsigned integer"/>
        <Element Offset="3380" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D34" DisplayMethod="unsigned integer"/>
        <Element Offset="3388" Vartype="Pointer" Bytesize="8" OffsetHex="00000D3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3392" Vartype="Float" Bytesize="4" OffsetHex="00000D40" DisplayMethod="unsigned integer"/>
        <Element Offset="3396" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000D44" DisplayMethod="unsigned integer"/>
        <Element Offset="3400" Vartype="Float" Bytesize="4" RLECount="10" OffsetHex="00000D48" DisplayMethod="unsigned integer"/>
        <Element Offset="3440" Vartype="Pointer" Bytesize="8" OffsetHex="00000D70" DisplayMethod="unsigned integer"/>
        <Element Offset="3444" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D74" DisplayMethod="unsigned integer"/>
        <Element Offset="3448" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000D78" DisplayMethod="unsigned integer"/>
        <Element Offset="3456" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D80" DisplayMethod="hexadecimal"/>
        <Element Offset="3464" Vartype="Pointer" Bytesize="8" OffsetHex="00000D88" DisplayMethod="unsigned integer"/>
        <Element Offset="3468" Vartype="Pointer" Bytesize="8" OffsetHex="00000D8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3472" Vartype="Pointer" Bytesize="8" OffsetHex="00000D90" DisplayMethod="unsigned integer"/>
        <Element Offset="3476" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000D94" DisplayMethod="unsigned integer"/>
        <Element Offset="3512" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000DB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3524" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DC4" DisplayMethod="hexadecimal"/>
        <Element Offset="3532" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3536" Vartype="Double" Bytesize="8" OffsetHex="00000DD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3544" Vartype="Float" Bytesize="4" OffsetHex="00000DD8" DisplayMethod="unsigned integer"/>
        <Element Offset="3548" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000DDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3568" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000DF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3576" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DF8" DisplayMethod="hexadecimal"/>
        <Element Offset="3584" Vartype="Pointer" Bytesize="8" OffsetHex="00000E00" DisplayMethod="unsigned integer"/>
        <Element Offset="3588" Vartype="Pointer" Bytesize="8" OffsetHex="00000E04" DisplayMethod="unsigned integer"/>
        <Element Offset="3592" Vartype="Pointer" Bytesize="8" OffsetHex="00000E08" DisplayMethod="unsigned integer"/>
        <Element Offset="3596" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3608" Vartype="Double" Bytesize="8" OffsetHex="00000E18" DisplayMethod="unsigned integer"/>
        <Element Offset="3616" Vartype="Float" Bytesize="4" OffsetHex="00000E20" DisplayMethod="unsigned integer"/>
        <Element Offset="3620" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E24" DisplayMethod="unsigned integer"/>
        <Element Offset="3624" Vartype="Pointer" Bytesize="8" OffsetHex="00000E28" DisplayMethod="unsigned integer"/>
        <Element Offset="3628" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="00000E2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3656" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000E48" DisplayMethod="unsigned integer"/>
        <Element Offset="3680" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E60" DisplayMethod="unsigned integer"/>
        <Element Offset="3688" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000E68" DisplayMethod="unsigned integer"/>
        <Element Offset="3696" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E70" DisplayMethod="hexadecimal"/>
        <Element Offset="3704" Vartype="Pointer" Bytesize="8" OffsetHex="00000E78" DisplayMethod="unsigned integer"/>
        <Element Offset="3708" Vartype="Pointer" Bytesize="8" OffsetHex="00000E7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3712" Vartype="Pointer" Bytesize="8" OffsetHex="00000E80" DisplayMethod="unsigned integer"/>
        <Element Offset="3716" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000E84" DisplayMethod="unsigned integer"/>
        <Element Offset="3732" Vartype="Double" Bytesize="8" OffsetHex="00000E94" DisplayMethod="unsigned integer"/>
        <Element Offset="3740" Vartype="Pointer" Bytesize="8" OffsetHex="00000E9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3744" Vartype="Pointer" Bytesize="8" OffsetHex="00000EA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3748" Vartype="Double" Bytesize="8" OffsetHex="00000EA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3756" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3764" Vartype="Float" Bytesize="4" OffsetHex="00000EB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3768" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000EB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3808" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000EE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3816" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EE8" DisplayMethod="hexadecimal"/>
        <Element Offset="3824" Vartype="Pointer" Bytesize="8" OffsetHex="00000EF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3828" Vartype="Pointer" Bytesize="8" OffsetHex="00000EF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3832" Vartype="Pointer" Bytesize="8" OffsetHex="00000EF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3836" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3848" Vartype="Double" Bytesize="8" OffsetHex="00000F08" DisplayMethod="unsigned integer"/>
        <Element Offset="3856" Vartype="Float" Bytesize="4" OffsetHex="00000F10" DisplayMethod="unsigned integer"/>
        <Element Offset="3860" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F14" DisplayMethod="unsigned integer"/>
        <Element Offset="3864" Vartype="Pointer" Bytesize="8" OffsetHex="00000F18" DisplayMethod="unsigned integer"/>
        <Element Offset="3868" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3872" Vartype="Float" Bytesize="4" OffsetHex="00000F20" DisplayMethod="unsigned integer"/>
        <Element Offset="3876" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000F24" DisplayMethod="unsigned integer"/>
        <Element Offset="3896" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F38" DisplayMethod="unsigned integer"/>
        <Element Offset="3908" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000F44" DisplayMethod="unsigned integer"/>
        <Element Offset="3912" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000F48" DisplayMethod="unsigned integer"/>
        <Element Offset="3920" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F50" DisplayMethod="unsigned integer"/>
        <Element Offset="3928" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000F58" DisplayMethod="unsigned integer"/>
        <Element Offset="3936" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F60" DisplayMethod="hexadecimal"/>
        <Element Offset="3944" Vartype="Pointer" Bytesize="8" OffsetHex="00000F68" DisplayMethod="unsigned integer"/>
        <Element Offset="3948" Vartype="Pointer" Bytesize="8" OffsetHex="00000F6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3952" Vartype="Pointer" Bytesize="8" OffsetHex="00000F70" DisplayMethod="unsigned integer"/>
        <Element Offset="3956" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F74" DisplayMethod="unsigned integer"/>
        <Element Offset="3968" Vartype="Double" Bytesize="8" OffsetHex="00000F80" DisplayMethod="unsigned integer"/>
        <Element Offset="3976" Vartype="Float" Bytesize="4" OffsetHex="00000F88" DisplayMethod="unsigned integer"/>
        <Element Offset="3980" Vartype="Pointer" Bytesize="8" OffsetHex="00000F8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3984" Vartype="Pointer" Bytesize="8" OffsetHex="00000F90" DisplayMethod="unsigned integer"/>
        <Element Offset="3988" Vartype="Double" Bytesize="8" OffsetHex="00000F94" DisplayMethod="unsigned integer"/>
        <Element Offset="3996" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F9C" DisplayMethod="unsigned integer"/>
        <Element Offset="4004" Vartype="Float" Bytesize="4" OffsetHex="00000FA4" DisplayMethod="unsigned integer"/>
        <Element Offset="4008" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000FA8" DisplayMethod="unsigned integer"/>
        <Element Offset="4048" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000FD0" DisplayMethod="unsigned integer"/>
        <Element Offset="4056" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000FD8" DisplayMethod="hexadecimal"/>
        <Element Offset="4064" Vartype="Pointer" Bytesize="8" OffsetHex="00000FE0" DisplayMethod="unsigned integer"/>
        <Element Offset="4068" Vartype="Pointer" Bytesize="8" OffsetHex="00000FE4" DisplayMethod="unsigned integer"/>
        <Element Offset="4072" Vartype="Pointer" Bytesize="8" OffsetHex="00000FE8" DisplayMethod="unsigned integer"/>
        <Element Offset="4076" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000FEC" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
  </Structures>
  <Comments>Version: GOG, 1.0, same as retail 1.02
</Comments>
</CheatTable>
