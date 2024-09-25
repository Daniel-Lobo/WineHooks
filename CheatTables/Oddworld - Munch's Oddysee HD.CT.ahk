<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>15</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>9</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscanmodule(hit0, Munch.exe, F3 0F 11 46 30 EB 05 F3 0F 11 4E 30 0F 2F 56 30)
registersymbol(hit0)
alloc(hit_new, 256)
label(hit0_new)
label(hit1_new)
label(hit0_player)
label(hit1_player)
label(hit0_ret)
label(hit1_ret)
label(hit0_og)
label(hit1_og)
label(kill_flag)
label(hp_flag)
registersymbol(kill_flag)
registersymbol(hp_flag)


hit_new:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00

hit0_new:
  cmp [esi+4], 1
  je hit0_player
  cmp [esi+4], 2
  je hit0_player
  cmp [kill_flag], 00
  je hit0_og
  mov [esi+30],(float)0.0
jmp hit0_ret

hit0_player:
  cmp [hp_flag], 00
  je hit0_og
  push [esi+38]
  pop [esi+30]
jmp hit0_ret

hit0_og:
  movss [esi+30],xmm0
jmp hit0_ret

hit1_new:
  cmp [esi+4], 1
  je hit1_player
  cmp [esi+4], 2
  je hit1_player
  cmp [kill_flag], 00
  je hit1_og
  mov [esi+30],(float)0.0
jmp hit1_ret

hit1_player:
  cmp [hp_flag], 00
  je hit1_og
  push [esi+38]
  pop [esi+30]
jmp hit1_ret

hit1_og:
  movss [esi+30],xmm1
jmp hit1_ret

hit0:
  jmp hit0_new
hit0_ret:

hit0+7:
  jmp hit1_new
hit1_ret:

[disable]
hit0:
  db F3 0F 11 46 30 EB 05 F3 0F 11 4E 30 0F 2F 56 30
unregistersymbol(*)
dealloc(*)
</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>10</ID>
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
          <ID>11</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
kill_flag:
  db 01 00 00 00

[disable]
kill_flag:
  db 00 00 00 00
</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>12</ID>
      <Description>"G - Gain spooce"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscanmodule(spooce, Munch.exe, F3 0F 10 42 08 8D 45 CC)
registersymbol(spooce)
alloc(spooce_new, 64)
label(spooce_ret)

spooce_new:
  movss xmm0,[edx+08]
  mov [edx+08], (float)10.0
  addss xmm0, [edx+08]
  movss [edx+08],xmm0
jmp spooce_ret


spooce:
  jmp spooce_new
spooce_ret:

[disable]
spooce:
  db F3 0F 10 42 08
unregistersymbol(*)
dealloc(*)
</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>13</ID>
      <Description>"B - always Bounce"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscanmodule(jmp_og, Munch.exe, F3 0F 10 4A 04 F3 0F 10 02)
registersymbol(jmp_og)
alloc(jmp_new, 64)
label(jmp_code)
label(jmp_ret)

jmp_new:
  dd (float)74
jmp_code:
  movss xmm1,[jmp_new]
jmp jmp_ret

jmp_og:
  jmp jmp_code
jmp_ret:

[disable]
jmp_og:
  db F3 0F 10 4A 04 F3 0F 10 02
unregistersymbol(*)
dealloc(*)
</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>14</ID>
      <Description>"Z - always Zap"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscanmodule(zap, Munch.exe, 83 7E 70 00 75 31)
registersymbol(zap)

zap+4:
  db eb

[disable]
zap:
  db 83 7E 70 00 75 31

</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Structures StructVersion="2">
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Pointer" Bytesize="8" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="4" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000004" DisplayMethod="unsigned integer"/>
        <Element Offset="8" Vartype="Float" Bytesize="4" OffsetHex="00000008" DisplayMethod="unsigned integer"/>
        <Element Offset="12" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000000C" DisplayMethod="unsigned integer"/>
        <Element Offset="16" Vartype="Float" Bytesize="4" OffsetHex="00000010" DisplayMethod="unsigned integer"/>
        <Element Offset="20" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000014" DisplayMethod="unsigned integer"/>
        <Element Offset="36" Vartype="Float" Bytesize="4" OffsetHex="00000024" DisplayMethod="unsigned integer"/>
        <Element Offset="40" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000028" DisplayMethod="unsigned integer"/>
        <Element Offset="48" Vartype="Float" Bytesize="4" OffsetHex="00000030" DisplayMethod="unsigned integer"/>
        <Element Offset="52" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000034" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="Float" Bytesize="4" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="60" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000003C" DisplayMethod="unsigned integer"/>
        <Element Offset="68" Vartype="Double" Bytesize="8" OffsetHex="00000044" DisplayMethod="unsigned integer"/>
        <Element Offset="76" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="0000004C" DisplayMethod="unsigned integer"/>
        <Element Offset="84" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000054" DisplayMethod="unsigned integer"/>
        <Element Offset="88" Vartype="Pointer" Bytesize="8" OffsetHex="00000058" DisplayMethod="unsigned integer"/>
        <Element Offset="92" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000005C" DisplayMethod="unsigned integer"/>
        <Element Offset="104" Vartype="Pointer" Bytesize="8" OffsetHex="00000068" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="Pointer" Bytesize="8" OffsetHex="0000006C" Description="Pointer to instance of MudokonAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Pointer" Bytesize="8" OffsetHex="00000070" Description="Pointer to instance of LegMotion" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="Pointer" Bytesize="8" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="Pointer" Bytesize="8" OffsetHex="00000078" Description="Pointer to instance of Mudokon" DisplayMethod="unsigned integer"/>
        <Element Offset="124" Vartype="Pointer" Bytesize="8" OffsetHex="0000007C" DisplayMethod="unsigned integer"/>
        <Element Offset="128" Vartype="Pointer" Bytesize="8" OffsetHex="00000080" DisplayMethod="unsigned integer"/>
        <Element Offset="132" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000084" DisplayMethod="unsigned integer"/>
        <Element Offset="136" Vartype="Pointer" Bytesize="8" OffsetHex="00000088" DisplayMethod="unsigned integer"/>
        <Element Offset="140" Vartype="Pointer" Bytesize="8" OffsetHex="0000008C" DisplayMethod="unsigned integer"/>
        <Element Offset="144" Vartype="Pointer" Bytesize="8" OffsetHex="00000090" DisplayMethod="unsigned integer"/>
        <Element Offset="148" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000094" DisplayMethod="unsigned integer"/>
        <Element Offset="152" Vartype="Double" Bytesize="8" OffsetHex="00000098" DisplayMethod="unsigned integer"/>
        <Element Offset="160" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000A0" DisplayMethod="unsigned integer"/>
        <Element Offset="172" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000000AC" DisplayMethod="unsigned integer"/>
        <Element Offset="184" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000B8" DisplayMethod="unsigned integer"/>
        <Element Offset="196" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000C4" DisplayMethod="unsigned integer"/>
        <Element Offset="200" Vartype="Pointer" Bytesize="8" OffsetHex="000000C8" DisplayMethod="unsigned integer"/>
        <Element Offset="204" Vartype="Pointer" Bytesize="8" OffsetHex="000000CC" DisplayMethod="unsigned integer"/>
        <Element Offset="208" Vartype="Pointer" Bytesize="8" OffsetHex="000000D0" DisplayMethod="unsigned integer"/>
        <Element Offset="212" Vartype="Pointer" Bytesize="8" OffsetHex="000000D4" DisplayMethod="unsigned integer"/>
        <Element Offset="216" Vartype="Pointer" Bytesize="8" OffsetHex="000000D8" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="220" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000DC" DisplayMethod="unsigned integer"/>
        <Element Offset="224" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000000E0" DisplayMethod="unsigned integer"/>
        <Element Offset="226" Vartype="2 Bytes" Bytesize="2" OffsetHex="000000E2" DisplayMethod="unsigned integer"/>
        <Element Offset="228" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000000E4" DisplayMethod="unsigned integer"/>
        <Element Offset="236" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000000EC" DisplayMethod="unsigned integer"/>
        <Element Offset="248" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000F8" DisplayMethod="unsigned integer"/>
        <Element Offset="260" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000104" DisplayMethod="unsigned integer"/>
        <Element Offset="264" Vartype="Pointer" Bytesize="8" OffsetHex="00000108" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="Float" Bytesize="4" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000110" DisplayMethod="hexadecimal"/>
        <Element Offset="284" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="0000011C" DisplayMethod="unsigned integer"/>
        <Element Offset="300" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000012C" DisplayMethod="hexadecimal"/>
        <Element Offset="304" Vartype="Float" Bytesize="4" OffsetHex="00000130" DisplayMethod="unsigned integer"/>
        <Element Offset="308" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000134" DisplayMethod="hexadecimal"/>
        <Element Offset="312" Vartype="Pointer" Bytesize="8" OffsetHex="00000138" DisplayMethod="unsigned integer"/>
        <Element Offset="316" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000013C" DisplayMethod="unsigned integer"/>
        <Element Offset="320" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000140" DisplayMethod="unsigned integer"/>
        <Element Offset="332" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000014C" DisplayMethod="unsigned integer"/>
        <Element Offset="336" Vartype="Float" Bytesize="4" OffsetHex="00000150" DisplayMethod="unsigned integer"/>
        <Element Offset="340" Vartype="Pointer" Bytesize="8" OffsetHex="00000154" DisplayMethod="unsigned integer"/>
        <Element Offset="344" Vartype="Pointer" Bytesize="8" OffsetHex="00000158" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000015C" DisplayMethod="unsigned integer"/>
        <Element Offset="368" Vartype="Pointer" Bytesize="8" OffsetHex="00000170" DisplayMethod="unsigned integer"/>
        <Element Offset="372" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000174" DisplayMethod="unsigned integer"/>
        <Element Offset="392" Vartype="Pointer" Bytesize="8" OffsetHex="00000188" DisplayMethod="unsigned integer"/>
        <Element Offset="396" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="0000018C" DisplayMethod="unsigned integer"/>
        <Element Offset="448" Vartype="Byte" Bytesize="1" OffsetHex="000001C0" DisplayMethod="unsigned integer"/>
        <Element Offset="449" Vartype="String" Bytesize="5" OffsetHex="000001C1" DisplayMethod="unsigned integer"/>
        <Element Offset="454" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000001C6" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="4 Bytes" Bytesize="4" RLECount="32" OffsetHex="000001C8" DisplayMethod="unsigned integer"/>
        <Element Offset="584" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000248" DisplayMethod="hexadecimal"/>
        <Element Offset="596" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000254" DisplayMethod="unsigned integer"/>
        <Element Offset="604" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000025C" DisplayMethod="hexadecimal"/>
        <Element Offset="608" Vartype="Float" Bytesize="4" OffsetHex="00000260" DisplayMethod="unsigned integer"/>
        <Element Offset="612" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000264" DisplayMethod="hexadecimal"/>
        <Element Offset="616" Vartype="Float" Bytesize="4" OffsetHex="00000268" DisplayMethod="unsigned integer"/>
        <Element Offset="620" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000026C" DisplayMethod="hexadecimal"/>
        <Element Offset="624" Vartype="Pointer" Bytesize="8" OffsetHex="00000270" DisplayMethod="unsigned integer"/>
        <Element Offset="628" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000274" DisplayMethod="unsigned integer"/>
        <Element Offset="632" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000278" DisplayMethod="unsigned integer"/>
        <Element Offset="644" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000284" DisplayMethod="unsigned integer"/>
        <Element Offset="648" Vartype="Float" Bytesize="4" OffsetHex="00000288" DisplayMethod="unsigned integer"/>
        <Element Offset="652" Vartype="Pointer" Bytesize="8" OffsetHex="0000028C" DisplayMethod="unsigned integer"/>
        <Element Offset="656" Vartype="Pointer" Bytesize="8" OffsetHex="00000290" DisplayMethod="unsigned integer"/>
        <Element Offset="660" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000294" DisplayMethod="unsigned integer"/>
        <Element Offset="680" Vartype="Pointer" Bytesize="8" OffsetHex="000002A8" DisplayMethod="unsigned integer"/>
        <Element Offset="684" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000002AC" DisplayMethod="unsigned integer"/>
        <Element Offset="704" Vartype="Pointer" Bytesize="8" OffsetHex="000002C0" DisplayMethod="unsigned integer"/>
        <Element Offset="708" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="000002C4" DisplayMethod="unsigned integer"/>
        <Element Offset="760" Vartype="Pointer" Bytesize="8" OffsetHex="000002F8" DisplayMethod="unsigned integer"/>
        <Element Offset="764" Vartype="4 Bytes" Bytesize="4" RLECount="33" OffsetHex="000002FC" DisplayMethod="unsigned integer"/>
        <Element Offset="896" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000380" DisplayMethod="hexadecimal"/>
        <Element Offset="908" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="0000038C" DisplayMethod="unsigned integer"/>
        <Element Offset="916" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000394" DisplayMethod="hexadecimal"/>
        <Element Offset="920" Vartype="Float" Bytesize="4" OffsetHex="00000398" DisplayMethod="unsigned integer"/>
        <Element Offset="924" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000039C" DisplayMethod="hexadecimal"/>
        <Element Offset="928" Vartype="Float" Bytesize="4" OffsetHex="000003A0" DisplayMethod="unsigned integer"/>
        <Element Offset="932" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003A4" DisplayMethod="hexadecimal"/>
        <Element Offset="936" Vartype="Pointer" Bytesize="8" OffsetHex="000003A8" DisplayMethod="unsigned integer"/>
        <Element Offset="940" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003AC" DisplayMethod="unsigned integer"/>
        <Element Offset="944" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000003B0" DisplayMethod="unsigned integer"/>
        <Element Offset="956" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000003BC" DisplayMethod="unsigned integer"/>
        <Element Offset="960" Vartype="Float" Bytesize="4" OffsetHex="000003C0" DisplayMethod="unsigned integer"/>
        <Element Offset="964" Vartype="Pointer" Bytesize="8" OffsetHex="000003C4" DisplayMethod="unsigned integer"/>
        <Element Offset="968" Vartype="Pointer" Bytesize="8" OffsetHex="000003C8" DisplayMethod="unsigned integer"/>
        <Element Offset="972" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000003CC" DisplayMethod="unsigned integer"/>
        <Element Offset="992" Vartype="Pointer" Bytesize="8" OffsetHex="000003E0" DisplayMethod="unsigned integer"/>
        <Element Offset="996" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000003E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1016" Vartype="Pointer" Bytesize="8" OffsetHex="000003F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1020" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="000003FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="Byte" Bytesize="1" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1073" Vartype="String" Bytesize="9" OffsetHex="00000431" DisplayMethod="unsigned integer"/>
        <Element Offset="1082" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="0000043A" DisplayMethod="unsigned integer"/>
        <Element Offset="1084" Vartype="4 Bytes" Bytesize="4" RLECount="31" OffsetHex="0000043C" DisplayMethod="unsigned integer"/>
        <Element Offset="1208" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000004B8" DisplayMethod="hexadecimal"/>
        <Element Offset="1220" Vartype="String" Bytesize="6" OffsetHex="000004C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1226" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="000004CA" DisplayMethod="unsigned integer"/>
        <Element Offset="1229" Vartype="String" Bytesize="4" OffsetHex="000004CD" DisplayMethod="unsigned integer"/>
        <Element Offset="1233" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="000004D1" DisplayMethod="unsigned integer"/>
        <Element Offset="1236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004D4" DisplayMethod="hexadecimal"/>
        <Element Offset="1240" Vartype="Float" Bytesize="4" OffsetHex="000004D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1244" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004DC" DisplayMethod="hexadecimal"/>
        <Element Offset="1248" Vartype="Pointer" Bytesize="8" OffsetHex="000004E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1252" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1256" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000004E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1268" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000004F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1272" Vartype="Float" Bytesize="4" OffsetHex="000004F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1276" Vartype="Pointer" Bytesize="8" OffsetHex="000004FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1280" Vartype="Pointer" Bytesize="8" OffsetHex="00000500" DisplayMethod="unsigned integer"/>
        <Element Offset="1284" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000504" DisplayMethod="unsigned integer"/>
        <Element Offset="1304" Vartype="Pointer" Bytesize="8" OffsetHex="00000518" DisplayMethod="unsigned integer"/>
        <Element Offset="1308" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000051C" DisplayMethod="unsigned integer"/>
        <Element Offset="1328" Vartype="Pointer" Bytesize="8" OffsetHex="00000530" DisplayMethod="unsigned integer"/>
        <Element Offset="1332" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="00000534" DisplayMethod="unsigned integer"/>
        <Element Offset="1384" Vartype="Byte" Bytesize="1" OffsetHex="00000568" DisplayMethod="unsigned integer"/>
        <Element Offset="1385" Vartype="String" Bytesize="11" OffsetHex="00000569" DisplayMethod="unsigned integer"/>
        <Element Offset="1396" Vartype="4 Bytes" Bytesize="4" RLECount="31" OffsetHex="00000574" DisplayMethod="unsigned integer"/>
        <Element Offset="1520" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000005F0" DisplayMethod="hexadecimal"/>
        <Element Offset="1532" Vartype="String" Bytesize="4" OffsetHex="000005FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1536" Vartype="Float" Bytesize="4" OffsetHex="00000600" DisplayMethod="unsigned integer"/>
        <Element Offset="1540" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000604" DisplayMethod="hexadecimal"/>
        <Element Offset="1544" Vartype="Float" Bytesize="4" OffsetHex="00000608" DisplayMethod="unsigned integer"/>
        <Element Offset="1548" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000060C" DisplayMethod="hexadecimal"/>
        <Element Offset="1560" Vartype="Pointer" Bytesize="8" OffsetHex="00000618" DisplayMethod="unsigned integer"/>
        <Element Offset="1564" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000061C" DisplayMethod="unsigned integer"/>
        <Element Offset="1568" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000620" DisplayMethod="unsigned integer"/>
        <Element Offset="1580" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000062C" DisplayMethod="unsigned integer"/>
        <Element Offset="1584" Vartype="Float" Bytesize="4" OffsetHex="00000630" DisplayMethod="unsigned integer"/>
        <Element Offset="1588" Vartype="Pointer" Bytesize="8" OffsetHex="00000634" DisplayMethod="unsigned integer"/>
        <Element Offset="1592" Vartype="Pointer" Bytesize="8" OffsetHex="00000638" DisplayMethod="unsigned integer"/>
        <Element Offset="1596" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000063C" DisplayMethod="unsigned integer"/>
        <Element Offset="1616" Vartype="Pointer" Bytesize="8" OffsetHex="00000650" DisplayMethod="unsigned integer"/>
        <Element Offset="1620" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000654" DisplayMethod="unsigned integer"/>
        <Element Offset="1640" Vartype="Pointer" Bytesize="8" OffsetHex="00000668" DisplayMethod="unsigned integer"/>
        <Element Offset="1644" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="0000066C" DisplayMethod="unsigned integer"/>
        <Element Offset="1696" Vartype="Byte" Bytesize="1" OffsetHex="000006A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1697" Vartype="String" Bytesize="5" OffsetHex="000006A1" DisplayMethod="unsigned integer"/>
        <Element Offset="1702" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000006A6" DisplayMethod="unsigned integer"/>
        <Element Offset="1704" Vartype="4 Bytes" Bytesize="4" RLECount="32" OffsetHex="000006A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1832" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000728" DisplayMethod="hexadecimal"/>
        <Element Offset="1844" Vartype="String" Bytesize="5" OffsetHex="00000734" DisplayMethod="unsigned integer"/>
        <Element Offset="1849" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000739" DisplayMethod="unsigned integer"/>
        <Element Offset="1852" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000073C" DisplayMethod="hexadecimal"/>
        <Element Offset="1856" Vartype="Float" Bytesize="4" OffsetHex="00000740" DisplayMethod="unsigned integer"/>
        <Element Offset="1860" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000744" DisplayMethod="hexadecimal"/>
        <Element Offset="1872" Vartype="Pointer" Bytesize="8" OffsetHex="00000750" DisplayMethod="unsigned integer"/>
        <Element Offset="1876" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000754" DisplayMethod="unsigned integer"/>
        <Element Offset="1880" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000758" DisplayMethod="unsigned integer"/>
        <Element Offset="1892" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000764" DisplayMethod="unsigned integer"/>
        <Element Offset="1896" Vartype="Float" Bytesize="4" OffsetHex="00000768" DisplayMethod="unsigned integer"/>
        <Element Offset="1900" Vartype="Pointer" Bytesize="8" OffsetHex="0000076C" DisplayMethod="unsigned integer"/>
        <Element Offset="1904" Vartype="Pointer" Bytesize="8" OffsetHex="00000770" DisplayMethod="unsigned integer"/>
        <Element Offset="1908" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000774" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="Pointer" Bytesize="8" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1932" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000078C" DisplayMethod="unsigned integer"/>
        <Element Offset="1952" Vartype="Pointer" Bytesize="8" OffsetHex="000007A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1956" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="000007A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2008" Vartype="Byte" Bytesize="1" OffsetHex="000007D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2009" Vartype="String" Bytesize="5" OffsetHex="000007D9" DisplayMethod="unsigned integer"/>
        <Element Offset="2014" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000007DE" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="4 Bytes" Bytesize="4" RLECount="32" OffsetHex="000007E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2144" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000860" DisplayMethod="hexadecimal"/>
        <Element Offset="2156" Vartype="Byte" Bytesize="1" OffsetHex="0000086C" DisplayMethod="unsigned integer"/>
        <Element Offset="2157" Vartype="String" Bytesize="4" OffsetHex="0000086D" DisplayMethod="unsigned integer"/>
        <Element Offset="2161" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000871" DisplayMethod="unsigned integer"/>
        <Element Offset="2164" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000874" DisplayMethod="hexadecimal"/>
        <Element Offset="2168" Vartype="Float" Bytesize="4" OffsetHex="00000878" DisplayMethod="unsigned integer"/>
        <Element Offset="2172" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000087C" DisplayMethod="hexadecimal"/>
        <Element Offset="2184" Vartype="Pointer" Bytesize="8" OffsetHex="00000888" DisplayMethod="unsigned integer"/>
        <Element Offset="2188" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000088C" DisplayMethod="unsigned integer"/>
        <Element Offset="2192" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000890" DisplayMethod="unsigned integer"/>
        <Element Offset="2204" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000089C" DisplayMethod="unsigned integer"/>
        <Element Offset="2208" Vartype="Float" Bytesize="4" OffsetHex="000008A0" DisplayMethod="unsigned integer"/>
        <Element Offset="2212" Vartype="Pointer" Bytesize="8" OffsetHex="000008A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2216" Vartype="Pointer" Bytesize="8" OffsetHex="000008A8" DisplayMethod="unsigned integer"/>
        <Element Offset="2220" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000008AC" DisplayMethod="unsigned integer"/>
        <Element Offset="2240" Vartype="Pointer" Bytesize="8" OffsetHex="000008C0" DisplayMethod="unsigned integer"/>
        <Element Offset="2244" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000008C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2264" Vartype="Pointer" Bytesize="8" OffsetHex="000008D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2268" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2320" Vartype="Byte" Bytesize="1" OffsetHex="00000910" DisplayMethod="unsigned integer"/>
        <Element Offset="2321" Vartype="String" Bytesize="9" OffsetHex="00000911" DisplayMethod="unsigned integer"/>
        <Element Offset="2330" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="0000091A" DisplayMethod="unsigned integer"/>
        <Element Offset="2332" Vartype="4 Bytes" Bytesize="4" RLECount="31" OffsetHex="0000091C" DisplayMethod="unsigned integer"/>
        <Element Offset="2456" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000998" DisplayMethod="hexadecimal"/>
        <Element Offset="2468" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000009A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2472" Vartype="Float" Bytesize="4" OffsetHex="000009A8" DisplayMethod="unsigned integer"/>
        <Element Offset="2476" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009AC" DisplayMethod="hexadecimal"/>
        <Element Offset="2480" Vartype="Float" Bytesize="4" OffsetHex="000009B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2484" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000009B4" DisplayMethod="hexadecimal"/>
        <Element Offset="2496" Vartype="Pointer" Bytesize="8" OffsetHex="000009C0" DisplayMethod="unsigned integer"/>
        <Element Offset="2500" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2504" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000009C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2516" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000009D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2520" Vartype="Float" Bytesize="4" OffsetHex="000009D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2524" Vartype="Pointer" Bytesize="8" OffsetHex="000009DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2528" Vartype="Pointer" Bytesize="8" OffsetHex="000009E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2532" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000009E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2552" Vartype="Pointer" Bytesize="8" OffsetHex="000009F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2556" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000009FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2576" Vartype="Pointer" Bytesize="8" OffsetHex="00000A10" DisplayMethod="unsigned integer"/>
        <Element Offset="2580" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="00000A14" DisplayMethod="unsigned integer"/>
        <Element Offset="2632" Vartype="Byte" Bytesize="1" OffsetHex="00000A48" DisplayMethod="unsigned integer"/>
        <Element Offset="2633" Vartype="String" Bytesize="9" OffsetHex="00000A49" DisplayMethod="unsigned integer"/>
        <Element Offset="2642" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000A52" DisplayMethod="unsigned integer"/>
        <Element Offset="2644" Vartype="4 Bytes" Bytesize="4" RLECount="31" OffsetHex="00000A54" DisplayMethod="unsigned integer"/>
        <Element Offset="2768" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000AD0" DisplayMethod="hexadecimal"/>
        <Element Offset="2780" Vartype="String" Bytesize="4" OffsetHex="00000ADC" DisplayMethod="unsigned integer"/>
        <Element Offset="2784" Vartype="Float" Bytesize="4" OffsetHex="00000AE0" DisplayMethod="unsigned integer"/>
        <Element Offset="2788" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AE4" DisplayMethod="hexadecimal"/>
        <Element Offset="2792" Vartype="Float" Bytesize="4" OffsetHex="00000AE8" DisplayMethod="unsigned integer"/>
        <Element Offset="2796" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000AEC" DisplayMethod="hexadecimal"/>
        <Element Offset="2808" Vartype="Pointer" Bytesize="8" OffsetHex="00000AF8" DisplayMethod="unsigned integer"/>
        <Element Offset="2812" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AFC" DisplayMethod="unsigned integer"/>
        <Element Offset="2816" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000B00" DisplayMethod="unsigned integer"/>
        <Element Offset="2828" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000B0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2832" Vartype="Float" Bytesize="4" OffsetHex="00000B10" DisplayMethod="unsigned integer"/>
        <Element Offset="2836" Vartype="Pointer" Bytesize="8" OffsetHex="00000B14" DisplayMethod="unsigned integer"/>
        <Element Offset="2840" Vartype="Pointer" Bytesize="8" OffsetHex="00000B18" DisplayMethod="unsigned integer"/>
        <Element Offset="2844" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000B1C" DisplayMethod="unsigned integer"/>
        <Element Offset="2864" Vartype="Pointer" Bytesize="8" OffsetHex="00000B30" DisplayMethod="unsigned integer"/>
        <Element Offset="2868" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000B34" DisplayMethod="unsigned integer"/>
        <Element Offset="2888" Vartype="Pointer" Bytesize="8" OffsetHex="00000B48" DisplayMethod="unsigned integer"/>
        <Element Offset="2892" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="00000B4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2944" Vartype="Pointer" Bytesize="8" OffsetHex="00000B80" DisplayMethod="unsigned integer"/>
        <Element Offset="2948" Vartype="4 Bytes" Bytesize="4" RLECount="33" OffsetHex="00000B84" DisplayMethod="unsigned integer"/>
        <Element Offset="3080" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C08" DisplayMethod="hexadecimal"/>
        <Element Offset="3092" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000C14" DisplayMethod="unsigned integer"/>
        <Element Offset="3096" Vartype="Float" Bytesize="4" OffsetHex="00000C18" DisplayMethod="unsigned integer"/>
        <Element Offset="3100" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C1C" DisplayMethod="hexadecimal"/>
        <Element Offset="3104" Vartype="Float" Bytesize="4" OffsetHex="00000C20" DisplayMethod="unsigned integer"/>
        <Element Offset="3108" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C24" DisplayMethod="hexadecimal"/>
        <Element Offset="3120" Vartype="Pointer" Bytesize="8" OffsetHex="00000C30" DisplayMethod="unsigned integer"/>
        <Element Offset="3124" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C34" DisplayMethod="unsigned integer"/>
        <Element Offset="3128" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000C38" DisplayMethod="unsigned integer"/>
        <Element Offset="3140" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000C44" DisplayMethod="unsigned integer"/>
        <Element Offset="3144" Vartype="Float" Bytesize="4" OffsetHex="00000C48" DisplayMethod="unsigned integer"/>
        <Element Offset="3148" Vartype="Pointer" Bytesize="8" OffsetHex="00000C4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3152" Vartype="Pointer" Bytesize="8" OffsetHex="00000C50" DisplayMethod="unsigned integer"/>
        <Element Offset="3156" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000C54" DisplayMethod="unsigned integer"/>
        <Element Offset="3176" Vartype="Pointer" Bytesize="8" OffsetHex="00000C68" DisplayMethod="unsigned integer"/>
        <Element Offset="3180" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000C6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3200" Vartype="Pointer" Bytesize="8" OffsetHex="00000C80" DisplayMethod="unsigned integer"/>
        <Element Offset="3204" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="00000C84" DisplayMethod="unsigned integer"/>
        <Element Offset="3256" Vartype="Byte" Bytesize="1" OffsetHex="00000CB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3257" Vartype="String" Bytesize="9" OffsetHex="00000CB9" DisplayMethod="unsigned integer"/>
        <Element Offset="3266" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000CC2" DisplayMethod="unsigned integer"/>
        <Element Offset="3268" Vartype="4 Bytes" Bytesize="4" RLECount="31" OffsetHex="00000CC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3392" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000D40" DisplayMethod="hexadecimal"/>
        <Element Offset="3404" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000D4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3408" Vartype="Float" Bytesize="4" OffsetHex="00000D50" DisplayMethod="unsigned integer"/>
        <Element Offset="3412" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000D54" DisplayMethod="unsigned integer"/>
        <Element Offset="3416" Vartype="Float" Bytesize="4" OffsetHex="00000D58" DisplayMethod="unsigned integer"/>
        <Element Offset="3420" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000D5C" DisplayMethod="hexadecimal"/>
        <Element Offset="3432" Vartype="Pointer" Bytesize="8" OffsetHex="00000D68" DisplayMethod="unsigned integer"/>
        <Element Offset="3436" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3440" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000D70" DisplayMethod="unsigned integer"/>
        <Element Offset="3452" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000D7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3456" Vartype="Float" Bytesize="4" OffsetHex="00000D80" DisplayMethod="unsigned integer"/>
        <Element Offset="3460" Vartype="Pointer" Bytesize="8" OffsetHex="00000D84" DisplayMethod="unsigned integer"/>
        <Element Offset="3464" Vartype="Pointer" Bytesize="8" OffsetHex="00000D88" DisplayMethod="unsigned integer"/>
        <Element Offset="3468" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000D8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3488" Vartype="Pointer" Bytesize="8" OffsetHex="00000DA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3492" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000DA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3512" Vartype="Pointer" Bytesize="8" OffsetHex="00000DB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3516" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="00000DBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3568" Vartype="Byte" Bytesize="1" OffsetHex="00000DF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3569" Vartype="String" Bytesize="9" OffsetHex="00000DF1" DisplayMethod="unsigned integer"/>
        <Element Offset="3578" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000DFA" DisplayMethod="unsigned integer"/>
        <Element Offset="3580" Vartype="4 Bytes" Bytesize="4" RLECount="31" OffsetHex="00000DFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3704" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E78" DisplayMethod="hexadecimal"/>
        <Element Offset="3716" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000E84" DisplayMethod="unsigned integer"/>
        <Element Offset="3720" Vartype="Float" Bytesize="4" OffsetHex="00000E88" DisplayMethod="unsigned integer"/>
        <Element Offset="3724" Vartype="Byte" Bytesize="1" OffsetHex="00000E8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3725" Vartype="String" Bytesize="4" OffsetHex="00000E8D" DisplayMethod="unsigned integer"/>
        <Element Offset="3729" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E91" DisplayMethod="unsigned integer"/>
        <Element Offset="3732" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E94" DisplayMethod="hexadecimal"/>
        <Element Offset="3744" Vartype="Pointer" Bytesize="8" OffsetHex="00000EA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3748" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000EA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3752" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000EA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3764" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000EB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3768" Vartype="Float" Bytesize="4" OffsetHex="00000EB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3772" Vartype="Pointer" Bytesize="8" OffsetHex="00000EBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3776" Vartype="Pointer" Bytesize="8" OffsetHex="00000EC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3780" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000EC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3800" Vartype="Pointer" Bytesize="8" OffsetHex="00000ED8" DisplayMethod="unsigned integer"/>
        <Element Offset="3804" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000EDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3824" Vartype="Pointer" Bytesize="8" OffsetHex="00000EF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3828" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="00000EF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3880" Vartype="Byte" Bytesize="1" OffsetHex="00000F28" DisplayMethod="unsigned integer"/>
        <Element Offset="3881" Vartype="String" Bytesize="9" OffsetHex="00000F29" DisplayMethod="unsigned integer"/>
        <Element Offset="3890" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000F32" DisplayMethod="unsigned integer"/>
        <Element Offset="3892" Vartype="4 Bytes" Bytesize="4" RLECount="15" OffsetHex="00000F34" DisplayMethod="unsigned integer"/>
        <Element Offset="3952" Vartype="Pointer" Bytesize="8" OffsetHex="00000F70" DisplayMethod="unsigned integer"/>
        <Element Offset="3956" Vartype="Float" Bytesize="4" OffsetHex="00000F74" DisplayMethod="unsigned integer"/>
        <Element Offset="3960" Vartype="4 Bytes" Bytesize="4" RLECount="14" OffsetHex="00000F78" DisplayMethod="unsigned integer"/>
        <Element Offset="4016" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000FB0" DisplayMethod="hexadecimal"/>
        <Element Offset="4028" Vartype="Byte" Bytesize="1" OffsetHex="00000FBC" DisplayMethod="unsigned integer"/>
        <Element Offset="4029" Vartype="String" Bytesize="4" OffsetHex="00000FBD" DisplayMethod="unsigned integer"/>
        <Element Offset="4033" Vartype="Byte" Bytesize="1" RLECount="7" OffsetHex="00000FC1" DisplayMethod="unsigned integer"/>
        <Element Offset="4040" Vartype="Float" Bytesize="4" OffsetHex="00000FC8" DisplayMethod="unsigned integer"/>
        <Element Offset="4044" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000FCC" DisplayMethod="hexadecimal"/>
        <Element Offset="4056" Vartype="Pointer" Bytesize="8" OffsetHex="00000FD8" DisplayMethod="unsigned integer"/>
        <Element Offset="4060" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FDC" DisplayMethod="unsigned integer"/>
        <Element Offset="4064" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000FE0" DisplayMethod="unsigned integer"/>
        <Element Offset="4076" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000FEC" DisplayMethod="unsigned integer"/>
        <Element Offset="4080" Vartype="Float" Bytesize="4" OffsetHex="00000FF0" DisplayMethod="unsigned integer"/>
        <Element Offset="4084" Vartype="Pointer" Bytesize="8" OffsetHex="00000FF4" DisplayMethod="unsigned integer"/>
        <Element Offset="4088" Vartype="Pointer" Bytesize="8" OffsetHex="00000FF8" DisplayMethod="unsigned integer"/>
        <Element Offset="4092" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FFC" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Pointer" Bytesize="8" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="4" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000004" DisplayMethod="hexadecimal"/>
        <Element Offset="8" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000008" DisplayMethod="unsigned integer"/>
        <Element Offset="16" Vartype="Float" Bytesize="4" OffsetHex="00000010" DisplayMethod="unsigned integer"/>
        <Element Offset="20" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000014" DisplayMethod="unsigned integer"/>
        <Element Offset="36" Vartype="Float" Bytesize="4" OffsetHex="00000024" DisplayMethod="unsigned integer"/>
        <Element Offset="40" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000028" DisplayMethod="unsigned integer"/>
        <Element Offset="48" Vartype="Float" Bytesize="4" OffsetHex="00000030" DisplayMethod="unsigned integer"/>
        <Element Offset="52" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000034" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="Float" Bytesize="4" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="60" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000003C" DisplayMethod="unsigned integer"/>
        <Element Offset="68" Vartype="Double" Bytesize="8" OffsetHex="00000044" DisplayMethod="unsigned integer"/>
        <Element Offset="76" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="0000004C" DisplayMethod="unsigned integer"/>
        <Element Offset="84" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000054" DisplayMethod="unsigned integer"/>
        <Element Offset="88" Vartype="Pointer" Bytesize="8" OffsetHex="00000058" DisplayMethod="unsigned integer"/>
        <Element Offset="92" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000005C" DisplayMethod="unsigned integer"/>
        <Element Offset="104" Vartype="Pointer" Bytesize="8" OffsetHex="00000068" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="Pointer" Bytesize="8" OffsetHex="0000006C" Description="Pointer to instance of SlogAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Pointer" Bytesize="8" OffsetHex="00000070" Description="Pointer to instance of LegMotion" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="Pointer" Bytesize="8" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="Pointer" Bytesize="8" OffsetHex="00000078" Description="Pointer to instance of Slog" DisplayMethod="unsigned integer"/>
        <Element Offset="124" Vartype="Pointer" Bytesize="8" OffsetHex="0000007C" DisplayMethod="unsigned integer"/>
        <Element Offset="128" Vartype="Pointer" Bytesize="8" OffsetHex="00000080" DisplayMethod="unsigned integer"/>
        <Element Offset="132" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000084" DisplayMethod="unsigned integer"/>
        <Element Offset="136" Vartype="Pointer" Bytesize="8" OffsetHex="00000088" DisplayMethod="unsigned integer"/>
        <Element Offset="140" Vartype="Pointer" Bytesize="8" OffsetHex="0000008C" DisplayMethod="unsigned integer"/>
        <Element Offset="144" Vartype="Pointer" Bytesize="8" OffsetHex="00000090" DisplayMethod="unsigned integer"/>
        <Element Offset="148" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000094" DisplayMethod="unsigned integer"/>
        <Element Offset="152" Vartype="Double" Bytesize="8" OffsetHex="00000098" DisplayMethod="unsigned integer"/>
        <Element Offset="160" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000A0" DisplayMethod="unsigned integer"/>
        <Element Offset="172" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000000AC" DisplayMethod="unsigned integer"/>
        <Element Offset="184" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000B8" DisplayMethod="unsigned integer"/>
        <Element Offset="196" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000C4" DisplayMethod="unsigned integer"/>
        <Element Offset="204" Vartype="Pointer" Bytesize="8" OffsetHex="000000CC" DisplayMethod="unsigned integer"/>
        <Element Offset="208" Vartype="Pointer" Bytesize="8" OffsetHex="000000D0" DisplayMethod="unsigned integer"/>
        <Element Offset="212" Vartype="Pointer" Bytesize="8" OffsetHex="000000D4" DisplayMethod="unsigned integer"/>
        <Element Offset="216" Vartype="Pointer" Bytesize="8" OffsetHex="000000D8" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="220" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000DC" DisplayMethod="unsigned integer"/>
        <Element Offset="224" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000E0" DisplayMethod="unsigned integer"/>
        <Element Offset="236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000EC" DisplayMethod="hexadecimal"/>
        <Element Offset="240" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000F0" DisplayMethod="unsigned integer"/>
        <Element Offset="248" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000F8" DisplayMethod="unsigned integer"/>
        <Element Offset="260" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000104" DisplayMethod="hexadecimal"/>
        <Element Offset="264" Vartype="Pointer" Bytesize="8" OffsetHex="00000108" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="Float" Bytesize="4" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000110" DisplayMethod="hexadecimal"/>
        <Element Offset="312" Vartype="Pointer" Bytesize="8" OffsetHex="00000138" DisplayMethod="unsigned integer"/>
        <Element Offset="316" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000013C" DisplayMethod="hexadecimal"/>
        <Element Offset="320" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000140" DisplayMethod="unsigned integer"/>
        <Element Offset="328" Vartype="Float" Bytesize="4" OffsetHex="00000148" DisplayMethod="unsigned integer"/>
        <Element Offset="332" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="0000014C" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="Float" Bytesize="4" OffsetHex="0000015C" DisplayMethod="unsigned integer"/>
        <Element Offset="352" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000160" DisplayMethod="unsigned integer"/>
        <Element Offset="360" Vartype="Float" Bytesize="4" OffsetHex="00000168" DisplayMethod="unsigned integer"/>
        <Element Offset="364" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000016C" DisplayMethod="unsigned integer"/>
        <Element Offset="368" Vartype="Float" Bytesize="4" OffsetHex="00000170" DisplayMethod="unsigned integer"/>
        <Element Offset="372" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000174" DisplayMethod="unsigned integer"/>
        <Element Offset="384" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000180" DisplayMethod="unsigned integer"/>
        <Element Offset="396" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000018C" DisplayMethod="unsigned integer"/>
        <Element Offset="400" Vartype="Pointer" Bytesize="8" OffsetHex="00000190" DisplayMethod="unsigned integer"/>
        <Element Offset="404" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000194" DisplayMethod="unsigned integer"/>
        <Element Offset="416" Vartype="Pointer" Bytesize="8" OffsetHex="000001A0" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="Pointer" Bytesize="8" OffsetHex="000001A4" Description="Pointer to instance of DoorAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="424" Vartype="Pointer" Bytesize="8" OffsetHex="000001A8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="428" Vartype="Pointer" Bytesize="8" OffsetHex="000001AC" DisplayMethod="unsigned integer"/>
        <Element Offset="432" Vartype="Pointer" Bytesize="8" OffsetHex="000001B0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="436" Vartype="Pointer" Bytesize="8" OffsetHex="000001B4" DisplayMethod="unsigned integer"/>
        <Element Offset="440" Vartype="Pointer" Bytesize="8" OffsetHex="000001B8" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="448" Vartype="Pointer" Bytesize="8" OffsetHex="000001C0" DisplayMethod="unsigned integer"/>
        <Element Offset="452" Vartype="Pointer" Bytesize="8" OffsetHex="000001C4" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="Pointer" Bytesize="8" OffsetHex="000001C8" DisplayMethod="unsigned integer"/>
        <Element Offset="460" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001CC" DisplayMethod="unsigned integer"/>
        <Element Offset="464" Vartype="Double" Bytesize="8" OffsetHex="000001D0" DisplayMethod="unsigned integer"/>
        <Element Offset="472" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000001D8" DisplayMethod="unsigned integer"/>
        <Element Offset="484" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000001E4" DisplayMethod="unsigned integer"/>
        <Element Offset="496" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000001F0" DisplayMethod="unsigned integer"/>
        <Element Offset="508" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001FC" DisplayMethod="unsigned integer"/>
        <Element Offset="516" Vartype="Pointer" Bytesize="8" OffsetHex="00000204" DisplayMethod="unsigned integer"/>
        <Element Offset="520" Vartype="Pointer" Bytesize="8" OffsetHex="00000208" DisplayMethod="unsigned integer"/>
        <Element Offset="524" Vartype="Pointer" Bytesize="8" OffsetHex="0000020C" DisplayMethod="unsigned integer"/>
        <Element Offset="528" Vartype="Pointer" Bytesize="8" OffsetHex="00000210" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="532" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000214" DisplayMethod="unsigned integer"/>
        <Element Offset="544" Vartype="Float" Bytesize="4" OffsetHex="00000220" DisplayMethod="unsigned integer"/>
        <Element Offset="548" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000224" DisplayMethod="unsigned integer"/>
        <Element Offset="560" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000230" DisplayMethod="unsigned integer"/>
        <Element Offset="572" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000023C" DisplayMethod="hexadecimal"/>
        <Element Offset="576" Vartype="Pointer" Bytesize="8" OffsetHex="00000240" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="580" Vartype="Float" Bytesize="4" OffsetHex="00000244" DisplayMethod="unsigned integer"/>
        <Element Offset="584" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000248" DisplayMethod="hexadecimal"/>
        <Element Offset="624" Vartype="Pointer" Bytesize="8" OffsetHex="00000270" DisplayMethod="unsigned integer"/>
        <Element Offset="628" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000274" DisplayMethod="hexadecimal"/>
        <Element Offset="632" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000278" DisplayMethod="unsigned integer"/>
        <Element Offset="640" Vartype="Float" Bytesize="4" OffsetHex="00000280" DisplayMethod="unsigned integer"/>
        <Element Offset="644" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000284" DisplayMethod="unsigned integer"/>
        <Element Offset="660" Vartype="Float" Bytesize="4" OffsetHex="00000294" DisplayMethod="unsigned integer"/>
        <Element Offset="664" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000298" DisplayMethod="unsigned integer"/>
        <Element Offset="672" Vartype="Float" Bytesize="4" OffsetHex="000002A0" DisplayMethod="unsigned integer"/>
        <Element Offset="676" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002A4" DisplayMethod="unsigned integer"/>
        <Element Offset="680" Vartype="Float" Bytesize="4" OffsetHex="000002A8" DisplayMethod="unsigned integer"/>
        <Element Offset="684" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000002AC" DisplayMethod="unsigned integer"/>
        <Element Offset="692" Vartype="Double" Bytesize="8" OffsetHex="000002B4" DisplayMethod="unsigned integer"/>
        <Element Offset="700" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002BC" DisplayMethod="unsigned integer"/>
        <Element Offset="704" Vartype="Float" Bytesize="4" OffsetHex="000002C0" DisplayMethod="unsigned integer"/>
        <Element Offset="708" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000002C4" DisplayMethod="unsigned integer"/>
        <Element Offset="728" Vartype="Pointer" Bytesize="8" OffsetHex="000002D8" DisplayMethod="unsigned integer"/>
        <Element Offset="732" Vartype="Pointer" Bytesize="8" OffsetHex="000002DC" Description="Pointer to instance of NullAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="736" Vartype="Pointer" Bytesize="8" OffsetHex="000002E0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="740" Vartype="Pointer" Bytesize="8" OffsetHex="000002E4" DisplayMethod="unsigned integer"/>
        <Element Offset="744" Vartype="Pointer" Bytesize="8" OffsetHex="000002E8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="748" Vartype="Pointer" Bytesize="8" OffsetHex="000002EC" DisplayMethod="unsigned integer"/>
        <Element Offset="752" Vartype="Pointer" Bytesize="8" OffsetHex="000002F0" DisplayMethod="unsigned integer"/>
        <Element Offset="756" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002F4" DisplayMethod="unsigned integer"/>
        <Element Offset="760" Vartype="Pointer" Bytesize="8" OffsetHex="000002F8" DisplayMethod="unsigned integer"/>
        <Element Offset="764" Vartype="Pointer" Bytesize="8" OffsetHex="000002FC" DisplayMethod="unsigned integer"/>
        <Element Offset="768" Vartype="Pointer" Bytesize="8" OffsetHex="00000300" DisplayMethod="unsigned integer"/>
        <Element Offset="772" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000304" DisplayMethod="unsigned integer"/>
        <Element Offset="776" Vartype="Double" Bytesize="8" OffsetHex="00000308" DisplayMethod="unsigned integer"/>
        <Element Offset="784" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000310" DisplayMethod="unsigned integer"/>
        <Element Offset="828" Vartype="Pointer" Bytesize="8" OffsetHex="0000033C" DisplayMethod="unsigned integer"/>
        <Element Offset="832" Vartype="Pointer" Bytesize="8" OffsetHex="00000340" DisplayMethod="unsigned integer"/>
        <Element Offset="836" Vartype="Pointer" Bytesize="8" OffsetHex="00000344" DisplayMethod="unsigned integer"/>
        <Element Offset="840" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000348" DisplayMethod="unsigned integer"/>
        <Element Offset="856" Vartype="Float" Bytesize="4" OffsetHex="00000358" DisplayMethod="unsigned integer"/>
        <Element Offset="860" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000035C" DisplayMethod="unsigned integer"/>
        <Element Offset="872" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000368" DisplayMethod="unsigned integer"/>
        <Element Offset="884" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000374" DisplayMethod="hexadecimal"/>
        <Element Offset="888" Vartype="Pointer" Bytesize="8" OffsetHex="00000378" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="892" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000037C" DisplayMethod="unsigned integer"/>
        <Element Offset="896" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000380" DisplayMethod="hexadecimal"/>
        <Element Offset="936" Vartype="Pointer" Bytesize="8" OffsetHex="000003A8" DisplayMethod="unsigned integer"/>
        <Element Offset="940" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003AC" DisplayMethod="hexadecimal"/>
        <Element Offset="944" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003B0" DisplayMethod="unsigned integer"/>
        <Element Offset="952" Vartype="Float" Bytesize="4" OffsetHex="000003B8" DisplayMethod="unsigned integer"/>
        <Element Offset="956" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000003BC" DisplayMethod="unsigned integer"/>
        <Element Offset="972" Vartype="Float" Bytesize="4" OffsetHex="000003CC" DisplayMethod="unsigned integer"/>
        <Element Offset="976" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003D0" DisplayMethod="unsigned integer"/>
        <Element Offset="984" Vartype="Float" Bytesize="4" OffsetHex="000003D8" DisplayMethod="unsigned integer"/>
        <Element Offset="988" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003DC" DisplayMethod="unsigned integer"/>
        <Element Offset="992" Vartype="Float" Bytesize="4" OffsetHex="000003E0" DisplayMethod="unsigned integer"/>
        <Element Offset="996" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1004" Vartype="Double" Bytesize="8" OffsetHex="000003EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1012" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1016" Vartype="Float" Bytesize="4" OffsetHex="000003F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1020" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000003FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1040" Vartype="Pointer" Bytesize="8" OffsetHex="00000410" DisplayMethod="unsigned integer"/>
        <Element Offset="1044" Vartype="Pointer" Bytesize="8" OffsetHex="00000414" Description="Pointer to instance of NullAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="1048" Vartype="Pointer" Bytesize="8" OffsetHex="00000418" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1052" Vartype="Pointer" Bytesize="8" OffsetHex="0000041C" DisplayMethod="unsigned integer"/>
        <Element Offset="1056" Vartype="Pointer" Bytesize="8" OffsetHex="00000420" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1060" Vartype="Pointer" Bytesize="8" OffsetHex="00000424" DisplayMethod="unsigned integer"/>
        <Element Offset="1064" Vartype="Pointer" Bytesize="8" OffsetHex="00000428" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="Pointer" Bytesize="8" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1076" Vartype="Pointer" Bytesize="8" OffsetHex="00000434" DisplayMethod="unsigned integer"/>
        <Element Offset="1080" Vartype="Pointer" Bytesize="8" OffsetHex="00000438" DisplayMethod="unsigned integer"/>
        <Element Offset="1084" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000043C" DisplayMethod="unsigned integer"/>
        <Element Offset="1088" Vartype="Double" Bytesize="8" OffsetHex="00000440" DisplayMethod="unsigned integer"/>
        <Element Offset="1096" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000448" DisplayMethod="unsigned integer"/>
        <Element Offset="1140" Vartype="Pointer" Bytesize="8" OffsetHex="00000474" DisplayMethod="unsigned integer"/>
        <Element Offset="1144" Vartype="Pointer" Bytesize="8" OffsetHex="00000478" DisplayMethod="unsigned integer"/>
        <Element Offset="1148" Vartype="Pointer" Bytesize="8" OffsetHex="0000047C" DisplayMethod="unsigned integer"/>
        <Element Offset="1152" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000480" DisplayMethod="unsigned integer"/>
        <Element Offset="1168" Vartype="Float" Bytesize="4" OffsetHex="00000490" DisplayMethod="unsigned integer"/>
        <Element Offset="1172" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000494" DisplayMethod="unsigned integer"/>
        <Element Offset="1184" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000004A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1196" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004AC" DisplayMethod="hexadecimal"/>
        <Element Offset="1200" Vartype="Pointer" Bytesize="8" OffsetHex="000004B0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1204" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1208" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="000004B8" DisplayMethod="hexadecimal"/>
        <Element Offset="1248" Vartype="Pointer" Bytesize="8" OffsetHex="000004E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1252" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004E4" DisplayMethod="hexadecimal"/>
        <Element Offset="1256" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000004E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1264" Vartype="Float" Bytesize="4" OffsetHex="000004F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1268" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000004F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1284" Vartype="Float" Bytesize="4" OffsetHex="00000504" DisplayMethod="unsigned integer"/>
        <Element Offset="1288" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000508" DisplayMethod="unsigned integer"/>
        <Element Offset="1296" Vartype="Float" Bytesize="4" OffsetHex="00000510" DisplayMethod="unsigned integer"/>
        <Element Offset="1300" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000514" DisplayMethod="unsigned integer"/>
        <Element Offset="1304" Vartype="Float" Bytesize="4" OffsetHex="00000518" DisplayMethod="unsigned integer"/>
        <Element Offset="1308" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000051C" DisplayMethod="unsigned integer"/>
        <Element Offset="1320" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000528" DisplayMethod="unsigned integer"/>
        <Element Offset="1332" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000534" DisplayMethod="unsigned integer"/>
        <Element Offset="1336" Vartype="Pointer" Bytesize="8" OffsetHex="00000538" DisplayMethod="unsigned integer"/>
        <Element Offset="1340" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000053C" DisplayMethod="unsigned integer"/>
        <Element Offset="1352" Vartype="Pointer" Bytesize="8" OffsetHex="00000548" DisplayMethod="unsigned integer"/>
        <Element Offset="1356" Vartype="Pointer" Bytesize="8" OffsetHex="0000054C" Description="Pointer to instance of SimpleAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="1360" Vartype="Pointer" Bytesize="8" OffsetHex="00000550" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1364" Vartype="Pointer" Bytesize="8" OffsetHex="00000554" DisplayMethod="unsigned integer"/>
        <Element Offset="1368" Vartype="Pointer" Bytesize="8" OffsetHex="00000558" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1372" Vartype="Pointer" Bytesize="8" OffsetHex="0000055C" DisplayMethod="unsigned integer"/>
        <Element Offset="1376" Vartype="Pointer" Bytesize="8" OffsetHex="00000560" DisplayMethod="unsigned integer"/>
        <Element Offset="1380" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000564" DisplayMethod="unsigned integer"/>
        <Element Offset="1384" Vartype="Pointer" Bytesize="8" OffsetHex="00000568" DisplayMethod="unsigned integer"/>
        <Element Offset="1388" Vartype="Pointer" Bytesize="8" OffsetHex="0000056C" DisplayMethod="unsigned integer"/>
        <Element Offset="1392" Vartype="Pointer" Bytesize="8" OffsetHex="00000570" DisplayMethod="unsigned integer"/>
        <Element Offset="1396" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000574" DisplayMethod="unsigned integer"/>
        <Element Offset="1400" Vartype="Double" Bytesize="8" OffsetHex="00000578" DisplayMethod="unsigned integer"/>
        <Element Offset="1408" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000580" DisplayMethod="unsigned integer"/>
        <Element Offset="1412" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000584" DisplayMethod="unsigned integer"/>
        <Element Offset="1420" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000058C" DisplayMethod="unsigned integer"/>
        <Element Offset="1432" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000598" DisplayMethod="unsigned integer"/>
        <Element Offset="1436" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="0000059C" DisplayMethod="unsigned integer"/>
        <Element Offset="1444" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000005A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1452" Vartype="Pointer" Bytesize="8" OffsetHex="000005AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1456" Vartype="Pointer" Bytesize="8" OffsetHex="000005B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1460" Vartype="Pointer" Bytesize="8" OffsetHex="000005B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1464" Vartype="Pointer" Bytesize="8" OffsetHex="000005B8" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="1468" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000005BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1480" Vartype="Float" Bytesize="4" OffsetHex="000005C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1484" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000005CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1496" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000005D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1500" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000005DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1508" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005E4" DisplayMethod="hexadecimal"/>
        <Element Offset="1512" Vartype="Pointer" Bytesize="8" OffsetHex="000005E8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1516" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1520" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="000005F0" DisplayMethod="hexadecimal"/>
        <Element Offset="1560" Vartype="Pointer" Bytesize="8" OffsetHex="00000618" DisplayMethod="unsigned integer"/>
        <Element Offset="1564" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000061C" DisplayMethod="hexadecimal"/>
        <Element Offset="1568" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000620" DisplayMethod="unsigned integer"/>
        <Element Offset="1576" Vartype="Float" Bytesize="4" OffsetHex="00000628" DisplayMethod="unsigned integer"/>
        <Element Offset="1580" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="0000062C" DisplayMethod="unsigned integer"/>
        <Element Offset="1596" Vartype="Float" Bytesize="4" OffsetHex="0000063C" DisplayMethod="unsigned integer"/>
        <Element Offset="1600" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000640" DisplayMethod="unsigned integer"/>
        <Element Offset="1608" Vartype="Float" Bytesize="4" OffsetHex="00000648" DisplayMethod="unsigned integer"/>
        <Element Offset="1612" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000064C" DisplayMethod="unsigned integer"/>
        <Element Offset="1616" Vartype="Float" Bytesize="4" OffsetHex="00000650" DisplayMethod="unsigned integer"/>
        <Element Offset="1620" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000654" DisplayMethod="unsigned integer"/>
        <Element Offset="1628" Vartype="Double" Bytesize="8" OffsetHex="0000065C" DisplayMethod="unsigned integer"/>
        <Element Offset="1636" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000664" DisplayMethod="unsigned integer"/>
        <Element Offset="1640" Vartype="Float" Bytesize="4" OffsetHex="00000668" DisplayMethod="unsigned integer"/>
        <Element Offset="1644" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000066C" DisplayMethod="unsigned integer"/>
        <Element Offset="1664" Vartype="Pointer" Bytesize="8" OffsetHex="00000680" DisplayMethod="unsigned integer"/>
        <Element Offset="1668" Vartype="Pointer" Bytesize="8" OffsetHex="00000684" Description="Pointer to instance of NullAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="1672" Vartype="Pointer" Bytesize="8" OffsetHex="00000688" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1676" Vartype="Pointer" Bytesize="8" OffsetHex="0000068C" DisplayMethod="unsigned integer"/>
        <Element Offset="1680" Vartype="Pointer" Bytesize="8" OffsetHex="00000690" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1684" Vartype="Pointer" Bytesize="8" OffsetHex="00000694" DisplayMethod="unsigned integer"/>
        <Element Offset="1688" Vartype="Pointer" Bytesize="8" OffsetHex="00000698" DisplayMethod="unsigned integer"/>
        <Element Offset="1692" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000069C" DisplayMethod="unsigned integer"/>
        <Element Offset="1696" Vartype="Pointer" Bytesize="8" OffsetHex="000006A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1700" Vartype="Pointer" Bytesize="8" OffsetHex="000006A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1704" Vartype="Pointer" Bytesize="8" OffsetHex="000006A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1708" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1712" Vartype="Double" Bytesize="8" OffsetHex="000006B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1720" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="000006B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1764" Vartype="Pointer" Bytesize="8" OffsetHex="000006E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1768" Vartype="Pointer" Bytesize="8" OffsetHex="000006E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1772" Vartype="Pointer" Bytesize="8" OffsetHex="000006EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1776" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000006F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1792" Vartype="Float" Bytesize="4" OffsetHex="00000700" DisplayMethod="unsigned integer"/>
        <Element Offset="1796" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000704" DisplayMethod="unsigned integer"/>
        <Element Offset="1808" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000710" DisplayMethod="unsigned integer"/>
        <Element Offset="1820" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000071C" DisplayMethod="hexadecimal"/>
        <Element Offset="1824" Vartype="Pointer" Bytesize="8" OffsetHex="00000720" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1828" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000724" DisplayMethod="unsigned integer"/>
        <Element Offset="1832" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000728" DisplayMethod="hexadecimal"/>
        <Element Offset="1872" Vartype="Pointer" Bytesize="8" OffsetHex="00000750" DisplayMethod="unsigned integer"/>
        <Element Offset="1876" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000754" DisplayMethod="hexadecimal"/>
        <Element Offset="1880" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000758" DisplayMethod="unsigned integer"/>
        <Element Offset="1888" Vartype="Float" Bytesize="4" OffsetHex="00000760" DisplayMethod="unsigned integer"/>
        <Element Offset="1892" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000764" DisplayMethod="unsigned integer"/>
        <Element Offset="1908" Vartype="Float" Bytesize="4" OffsetHex="00000774" DisplayMethod="unsigned integer"/>
        <Element Offset="1912" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000778" DisplayMethod="unsigned integer"/>
        <Element Offset="1920" Vartype="Float" Bytesize="4" OffsetHex="00000780" DisplayMethod="unsigned integer"/>
        <Element Offset="1924" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000784" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="Float" Bytesize="4" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1932" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000078C" DisplayMethod="unsigned integer"/>
        <Element Offset="1940" Vartype="Double" Bytesize="8" OffsetHex="00000794" DisplayMethod="unsigned integer"/>
        <Element Offset="1948" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000079C" DisplayMethod="unsigned integer"/>
        <Element Offset="1952" Vartype="Float" Bytesize="4" OffsetHex="000007A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1956" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000007A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1976" Vartype="Pointer" Bytesize="8" OffsetHex="000007B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1980" Vartype="Pointer" Bytesize="8" OffsetHex="000007BC" Description="Pointer to instance of NullAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="1984" Vartype="Pointer" Bytesize="8" OffsetHex="000007C0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1988" Vartype="Pointer" Bytesize="8" OffsetHex="000007C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1992" Vartype="Pointer" Bytesize="8" OffsetHex="000007C8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1996" Vartype="Pointer" Bytesize="8" OffsetHex="000007CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2000" Vartype="Pointer" Bytesize="8" OffsetHex="000007D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2004" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2008" Vartype="Pointer" Bytesize="8" OffsetHex="000007D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2012" Vartype="Pointer" Bytesize="8" OffsetHex="000007DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="Pointer" Bytesize="8" OffsetHex="000007E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2020" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2024" Vartype="Double" Bytesize="8" OffsetHex="000007E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2032" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="000007F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2076" Vartype="Pointer" Bytesize="8" OffsetHex="0000081C" DisplayMethod="unsigned integer"/>
        <Element Offset="2080" Vartype="Pointer" Bytesize="8" OffsetHex="00000820" DisplayMethod="unsigned integer"/>
        <Element Offset="2084" Vartype="Pointer" Bytesize="8" OffsetHex="00000824" DisplayMethod="unsigned integer"/>
        <Element Offset="2088" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000828" DisplayMethod="unsigned integer"/>
        <Element Offset="2104" Vartype="Float" Bytesize="4" OffsetHex="00000838" DisplayMethod="unsigned integer"/>
        <Element Offset="2108" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000083C" DisplayMethod="unsigned integer"/>
        <Element Offset="2120" Vartype="Float" Bytesize="4" OffsetHex="00000848" DisplayMethod="unsigned integer"/>
        <Element Offset="2124" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000084C" DisplayMethod="unsigned integer"/>
        <Element Offset="2128" Vartype="Float" Bytesize="4" OffsetHex="00000850" DisplayMethod="unsigned integer"/>
        <Element Offset="2132" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000854" DisplayMethod="hexadecimal"/>
        <Element Offset="2136" Vartype="Pointer" Bytesize="8" OffsetHex="00000858" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2140" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000085C" DisplayMethod="unsigned integer"/>
        <Element Offset="2144" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000860" DisplayMethod="hexadecimal"/>
        <Element Offset="2184" Vartype="Pointer" Bytesize="8" OffsetHex="00000888" DisplayMethod="unsigned integer"/>
        <Element Offset="2188" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000088C" DisplayMethod="hexadecimal"/>
        <Element Offset="2192" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000890" DisplayMethod="unsigned integer"/>
        <Element Offset="2200" Vartype="Float" Bytesize="4" OffsetHex="00000898" DisplayMethod="unsigned integer"/>
        <Element Offset="2204" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="0000089C" DisplayMethod="unsigned integer"/>
        <Element Offset="2220" Vartype="Float" Bytesize="4" OffsetHex="000008AC" DisplayMethod="unsigned integer"/>
        <Element Offset="2224" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2232" Vartype="Float" Bytesize="4" OffsetHex="000008B8" DisplayMethod="unsigned integer"/>
        <Element Offset="2236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2240" Vartype="Float" Bytesize="4" OffsetHex="000008C0" DisplayMethod="unsigned integer"/>
        <Element Offset="2244" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2256" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000008D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2268" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2272" Vartype="Pointer" Bytesize="8" OffsetHex="000008E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2276" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2288" Vartype="Pointer" Bytesize="8" OffsetHex="000008F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2292" Vartype="Pointer" Bytesize="8" OffsetHex="000008F4" Description="Pointer to instance of DoorAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="2296" Vartype="Pointer" Bytesize="8" OffsetHex="000008F8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2300" Vartype="Pointer" Bytesize="8" OffsetHex="000008FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2304" Vartype="Pointer" Bytesize="8" OffsetHex="00000900" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2308" Vartype="Pointer" Bytesize="8" OffsetHex="00000904" DisplayMethod="unsigned integer"/>
        <Element Offset="2312" Vartype="Pointer" Bytesize="8" OffsetHex="00000908" DisplayMethod="unsigned integer"/>
        <Element Offset="2316" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000090C" DisplayMethod="unsigned integer"/>
        <Element Offset="2320" Vartype="Pointer" Bytesize="8" OffsetHex="00000910" DisplayMethod="unsigned integer"/>
        <Element Offset="2324" Vartype="Pointer" Bytesize="8" OffsetHex="00000914" DisplayMethod="unsigned integer"/>
        <Element Offset="2328" Vartype="Pointer" Bytesize="8" OffsetHex="00000918" DisplayMethod="unsigned integer"/>
        <Element Offset="2332" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000091C" DisplayMethod="unsigned integer"/>
        <Element Offset="2336" Vartype="Double" Bytesize="8" OffsetHex="00000920" DisplayMethod="unsigned integer"/>
        <Element Offset="2344" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000928" DisplayMethod="unsigned integer"/>
        <Element Offset="2356" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000934" DisplayMethod="unsigned integer"/>
        <Element Offset="2368" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000940" DisplayMethod="unsigned integer"/>
        <Element Offset="2380" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000094C" DisplayMethod="unsigned integer"/>
        <Element Offset="2388" Vartype="Pointer" Bytesize="8" OffsetHex="00000954" DisplayMethod="unsigned integer"/>
        <Element Offset="2392" Vartype="Pointer" Bytesize="8" OffsetHex="00000958" DisplayMethod="unsigned integer"/>
        <Element Offset="2396" Vartype="Pointer" Bytesize="8" OffsetHex="0000095C" DisplayMethod="unsigned integer"/>
        <Element Offset="2400" Vartype="Pointer" Bytesize="8" OffsetHex="00000960" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="2404" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000964" DisplayMethod="unsigned integer"/>
        <Element Offset="2416" Vartype="Float" Bytesize="4" OffsetHex="00000970" DisplayMethod="unsigned integer"/>
        <Element Offset="2420" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000974" DisplayMethod="unsigned integer"/>
        <Element Offset="2432" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000980" DisplayMethod="unsigned integer"/>
        <Element Offset="2444" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000098C" DisplayMethod="hexadecimal"/>
        <Element Offset="2448" Vartype="Pointer" Bytesize="8" OffsetHex="00000990" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2452" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000994" DisplayMethod="unsigned integer"/>
        <Element Offset="2456" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000998" DisplayMethod="hexadecimal"/>
        <Element Offset="2496" Vartype="Pointer" Bytesize="8" OffsetHex="000009C0" DisplayMethod="unsigned integer"/>
        <Element Offset="2500" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009C4" DisplayMethod="hexadecimal"/>
        <Element Offset="2504" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2512" Vartype="Float" Bytesize="4" OffsetHex="000009D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2516" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000009D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2532" Vartype="Float" Bytesize="4" OffsetHex="000009E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2536" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2544" Vartype="Float" Bytesize="4" OffsetHex="000009F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2548" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2552" Vartype="Float" Bytesize="4" OffsetHex="000009F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2556" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000009FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2568" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A08" DisplayMethod="unsigned integer"/>
        <Element Offset="2580" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A14" DisplayMethod="unsigned integer"/>
        <Element Offset="2584" Vartype="Pointer" Bytesize="8" OffsetHex="00000A18" DisplayMethod="unsigned integer"/>
        <Element Offset="2588" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000A1C" DisplayMethod="unsigned integer"/>
        <Element Offset="2600" Vartype="Pointer" Bytesize="8" OffsetHex="00000A28" DisplayMethod="unsigned integer"/>
        <Element Offset="2604" Vartype="Pointer" Bytesize="8" OffsetHex="00000A2C" Description="Pointer to instance of DoorAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="2608" Vartype="Pointer" Bytesize="8" OffsetHex="00000A30" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2612" Vartype="Pointer" Bytesize="8" OffsetHex="00000A34" DisplayMethod="unsigned integer"/>
        <Element Offset="2616" Vartype="Pointer" Bytesize="8" OffsetHex="00000A38" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2620" Vartype="Pointer" Bytesize="8" OffsetHex="00000A3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2624" Vartype="Pointer" Bytesize="8" OffsetHex="00000A40" DisplayMethod="unsigned integer"/>
        <Element Offset="2628" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A44" DisplayMethod="unsigned integer"/>
        <Element Offset="2632" Vartype="Pointer" Bytesize="8" OffsetHex="00000A48" DisplayMethod="unsigned integer"/>
        <Element Offset="2636" Vartype="Pointer" Bytesize="8" OffsetHex="00000A4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2640" Vartype="Pointer" Bytesize="8" OffsetHex="00000A50" DisplayMethod="unsigned integer"/>
        <Element Offset="2644" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A54" DisplayMethod="unsigned integer"/>
        <Element Offset="2648" Vartype="Double" Bytesize="8" OffsetHex="00000A58" DisplayMethod="unsigned integer"/>
        <Element Offset="2656" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A60" DisplayMethod="unsigned integer"/>
        <Element Offset="2668" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000A6C" DisplayMethod="unsigned integer"/>
        <Element Offset="2680" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A78" DisplayMethod="unsigned integer"/>
        <Element Offset="2692" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A84" DisplayMethod="unsigned integer"/>
        <Element Offset="2700" Vartype="Pointer" Bytesize="8" OffsetHex="00000A8C" DisplayMethod="unsigned integer"/>
        <Element Offset="2704" Vartype="Pointer" Bytesize="8" OffsetHex="00000A90" DisplayMethod="unsigned integer"/>
        <Element Offset="2708" Vartype="Pointer" Bytesize="8" OffsetHex="00000A94" DisplayMethod="unsigned integer"/>
        <Element Offset="2712" Vartype="Pointer" Bytesize="8" OffsetHex="00000A98" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="2716" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000A9C" DisplayMethod="unsigned integer"/>
        <Element Offset="2728" Vartype="Float" Bytesize="4" OffsetHex="00000AA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2732" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000AAC" DisplayMethod="unsigned integer"/>
        <Element Offset="2744" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000AB8" DisplayMethod="unsigned integer"/>
        <Element Offset="2756" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AC4" DisplayMethod="hexadecimal"/>
        <Element Offset="2760" Vartype="Pointer" Bytesize="8" OffsetHex="00000AC8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2764" Vartype="Float" Bytesize="4" OffsetHex="00000ACC" DisplayMethod="unsigned integer"/>
        <Element Offset="2768" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000AD0" DisplayMethod="hexadecimal"/>
        <Element Offset="2808" Vartype="Pointer" Bytesize="8" OffsetHex="00000AF8" DisplayMethod="unsigned integer"/>
        <Element Offset="2812" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AFC" DisplayMethod="hexadecimal"/>
        <Element Offset="2816" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B00" DisplayMethod="unsigned integer"/>
        <Element Offset="2824" Vartype="Float" Bytesize="4" OffsetHex="00000B08" DisplayMethod="unsigned integer"/>
        <Element Offset="2828" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000B0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2844" Vartype="Float" Bytesize="4" OffsetHex="00000B1C" DisplayMethod="unsigned integer"/>
        <Element Offset="2848" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B20" DisplayMethod="unsigned integer"/>
        <Element Offset="2856" Vartype="Float" Bytesize="4" OffsetHex="00000B28" DisplayMethod="unsigned integer"/>
        <Element Offset="2860" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B2C" DisplayMethod="unsigned integer"/>
        <Element Offset="2864" Vartype="Float" Bytesize="4" OffsetHex="00000B30" DisplayMethod="unsigned integer"/>
        <Element Offset="2868" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B34" DisplayMethod="unsigned integer"/>
        <Element Offset="2876" Vartype="Double" Bytesize="8" OffsetHex="00000B3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2884" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B44" DisplayMethod="unsigned integer"/>
        <Element Offset="2888" Vartype="Float" Bytesize="4" OffsetHex="00000B48" DisplayMethod="unsigned integer"/>
        <Element Offset="2892" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000B4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2912" Vartype="Pointer" Bytesize="8" OffsetHex="00000B60" DisplayMethod="unsigned integer"/>
        <Element Offset="2916" Vartype="Pointer" Bytesize="8" OffsetHex="00000B64" Description="Pointer to instance of Humshrub" DisplayMethod="unsigned integer"/>
        <Element Offset="2920" Vartype="Pointer" Bytesize="8" OffsetHex="00000B68" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2924" Vartype="Pointer" Bytesize="8" OffsetHex="00000B6C" DisplayMethod="unsigned integer"/>
        <Element Offset="2928" Vartype="Pointer" Bytesize="8" OffsetHex="00000B70" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2932" Vartype="Pointer" Bytesize="8" OffsetHex="00000B74" DisplayMethod="unsigned integer"/>
        <Element Offset="2936" Vartype="Pointer" Bytesize="8" OffsetHex="00000B78" DisplayMethod="unsigned integer"/>
        <Element Offset="2940" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B7C" DisplayMethod="unsigned integer"/>
        <Element Offset="2944" Vartype="Pointer" Bytesize="8" OffsetHex="00000B80" DisplayMethod="unsigned integer"/>
        <Element Offset="2948" Vartype="Pointer" Bytesize="8" OffsetHex="00000B84" DisplayMethod="unsigned integer"/>
        <Element Offset="2952" Vartype="Pointer" Bytesize="8" OffsetHex="00000B88" DisplayMethod="unsigned integer"/>
        <Element Offset="2956" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B8C" DisplayMethod="unsigned integer"/>
        <Element Offset="2960" Vartype="Double" Bytesize="8" OffsetHex="00000B90" DisplayMethod="unsigned integer"/>
        <Element Offset="2968" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000B98" DisplayMethod="unsigned integer"/>
        <Element Offset="3012" Vartype="Pointer" Bytesize="8" OffsetHex="00000BC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3016" Vartype="Pointer" Bytesize="8" OffsetHex="00000BC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3020" Vartype="Pointer" Bytesize="8" OffsetHex="00000BCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3024" Vartype="Pointer" Bytesize="8" OffsetHex="00000BD0" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="3028" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000BD4" DisplayMethod="unsigned integer"/>
        <Element Offset="3040" Vartype="Float" Bytesize="4" OffsetHex="00000BE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3044" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000BE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3056" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000BF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3068" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BFC" DisplayMethod="hexadecimal"/>
        <Element Offset="3072" Vartype="Pointer" Bytesize="8" OffsetHex="00000C00" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3076" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C04" DisplayMethod="unsigned integer"/>
        <Element Offset="3080" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000C08" DisplayMethod="hexadecimal"/>
        <Element Offset="3120" Vartype="Pointer" Bytesize="8" OffsetHex="00000C30" DisplayMethod="unsigned integer"/>
        <Element Offset="3124" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C34" DisplayMethod="hexadecimal"/>
        <Element Offset="3128" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C38" DisplayMethod="unsigned integer"/>
        <Element Offset="3136" Vartype="Float" Bytesize="4" OffsetHex="00000C40" DisplayMethod="unsigned integer"/>
        <Element Offset="3140" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000C44" DisplayMethod="unsigned integer"/>
        <Element Offset="3156" Vartype="Float" Bytesize="4" OffsetHex="00000C54" DisplayMethod="unsigned integer"/>
        <Element Offset="3160" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C58" DisplayMethod="unsigned integer"/>
        <Element Offset="3168" Vartype="Float" Bytesize="4" OffsetHex="00000C60" DisplayMethod="unsigned integer"/>
        <Element Offset="3172" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C64" DisplayMethod="unsigned integer"/>
        <Element Offset="3176" Vartype="Float" Bytesize="4" OffsetHex="00000C68" DisplayMethod="unsigned integer"/>
        <Element Offset="3180" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3188" Vartype="Double" Bytesize="8" OffsetHex="00000C74" DisplayMethod="unsigned integer"/>
        <Element Offset="3196" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3200" Vartype="Float" Bytesize="4" OffsetHex="00000C80" DisplayMethod="unsigned integer"/>
        <Element Offset="3204" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000C84" DisplayMethod="unsigned integer"/>
        <Element Offset="3224" Vartype="Pointer" Bytesize="8" OffsetHex="00000C98" DisplayMethod="unsigned integer"/>
        <Element Offset="3228" Vartype="Pointer" Bytesize="8" OffsetHex="00000C9C" Description="Pointer to instance of NullAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="3232" Vartype="Pointer" Bytesize="8" OffsetHex="00000CA0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3236" Vartype="Pointer" Bytesize="8" OffsetHex="00000CA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3240" Vartype="Pointer" Bytesize="8" OffsetHex="00000CA8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3244" Vartype="Pointer" Bytesize="8" OffsetHex="00000CAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3248" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3252" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3256" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3260" Vartype="Pointer" Bytesize="8" OffsetHex="00000CBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3264" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3268" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3272" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3276" Vartype="Float" Bytesize="4" OffsetHex="00000CCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3280" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000CD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3324" Vartype="Pointer" Bytesize="8" OffsetHex="00000CFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3328" Vartype="Pointer" Bytesize="8" OffsetHex="00000D00" DisplayMethod="unsigned integer"/>
        <Element Offset="3332" Vartype="Pointer" Bytesize="8" OffsetHex="00000D04" DisplayMethod="unsigned integer"/>
        <Element Offset="3336" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000D08" DisplayMethod="unsigned integer"/>
        <Element Offset="3352" Vartype="Float" Bytesize="4" OffsetHex="00000D18" DisplayMethod="unsigned integer"/>
        <Element Offset="3356" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000D1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3380" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D34" DisplayMethod="hexadecimal"/>
        <Element Offset="3384" Vartype="Pointer" Bytesize="8" OffsetHex="00000D38" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3388" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3392" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000D40" DisplayMethod="hexadecimal"/>
        <Element Offset="3432" Vartype="Pointer" Bytesize="8" OffsetHex="00000D68" DisplayMethod="unsigned integer"/>
        <Element Offset="3436" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D6C" DisplayMethod="hexadecimal"/>
        <Element Offset="3440" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D70" DisplayMethod="unsigned integer"/>
        <Element Offset="3448" Vartype="Float" Bytesize="4" OffsetHex="00000D78" DisplayMethod="unsigned integer"/>
        <Element Offset="3452" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000D7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3468" Vartype="Float" Bytesize="4" OffsetHex="00000D8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3472" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D90" DisplayMethod="unsigned integer"/>
        <Element Offset="3480" Vartype="Float" Bytesize="4" OffsetHex="00000D98" DisplayMethod="unsigned integer"/>
        <Element Offset="3484" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3488" Vartype="Float" Bytesize="4" OffsetHex="00000DA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3492" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000DA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3504" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000DB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3516" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3520" Vartype="Pointer" Bytesize="8" OffsetHex="00000DC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3524" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000DC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3536" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3540" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD4" Description="Pointer to instance of DoorAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="3544" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3548" Vartype="Pointer" Bytesize="8" OffsetHex="00000DDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3552" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3556" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3560" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3564" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3568" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3572" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3576" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3580" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3584" Vartype="Double" Bytesize="8" OffsetHex="00000E00" DisplayMethod="unsigned integer"/>
        <Element Offset="3592" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000E08" DisplayMethod="unsigned integer"/>
        <Element Offset="3604" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E14" DisplayMethod="unsigned integer"/>
        <Element Offset="3616" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000E20" DisplayMethod="unsigned integer"/>
        <Element Offset="3628" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3636" Vartype="Pointer" Bytesize="8" OffsetHex="00000E34" DisplayMethod="unsigned integer"/>
        <Element Offset="3640" Vartype="Pointer" Bytesize="8" OffsetHex="00000E38" DisplayMethod="unsigned integer"/>
        <Element Offset="3644" Vartype="Pointer" Bytesize="8" OffsetHex="00000E3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3648" Vartype="Pointer" Bytesize="8" OffsetHex="00000E40" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="3652" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E44" DisplayMethod="unsigned integer"/>
        <Element Offset="3664" Vartype="Float" Bytesize="4" OffsetHex="00000E50" DisplayMethod="unsigned integer"/>
        <Element Offset="3668" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E54" DisplayMethod="unsigned integer"/>
        <Element Offset="3680" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000E60" DisplayMethod="unsigned integer"/>
        <Element Offset="3692" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E6C" DisplayMethod="hexadecimal"/>
        <Element Offset="3696" Vartype="Pointer" Bytesize="8" OffsetHex="00000E70" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3700" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E74" DisplayMethod="unsigned integer"/>
        <Element Offset="3704" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000E78" DisplayMethod="hexadecimal"/>
        <Element Offset="3744" Vartype="Pointer" Bytesize="8" OffsetHex="00000EA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3748" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000EA4" DisplayMethod="hexadecimal"/>
        <Element Offset="3752" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3760" Vartype="Float" Bytesize="4" OffsetHex="00000EB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3764" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000EB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3780" Vartype="Float" Bytesize="4" OffsetHex="00000EC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3784" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3792" Vartype="Float" Bytesize="4" OffsetHex="00000ED0" DisplayMethod="unsigned integer"/>
        <Element Offset="3796" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000ED4" DisplayMethod="unsigned integer"/>
        <Element Offset="3800" Vartype="Float" Bytesize="4" OffsetHex="00000ED8" DisplayMethod="unsigned integer"/>
        <Element Offset="3804" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3812" Vartype="Double" Bytesize="8" OffsetHex="00000EE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3820" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000EEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3824" Vartype="Float" Bytesize="4" OffsetHex="00000EF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3828" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000EF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3848" Vartype="Pointer" Bytesize="8" OffsetHex="00000F08" DisplayMethod="unsigned integer"/>
        <Element Offset="3852" Vartype="Pointer" Bytesize="8" OffsetHex="00000F0C" Description="Pointer to instance of NullAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="3856" Vartype="Pointer" Bytesize="8" OffsetHex="00000F10" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3860" Vartype="Pointer" Bytesize="8" OffsetHex="00000F14" DisplayMethod="unsigned integer"/>
        <Element Offset="3864" Vartype="Pointer" Bytesize="8" OffsetHex="00000F18" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3868" Vartype="Pointer" Bytesize="8" OffsetHex="00000F1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3872" Vartype="Pointer" Bytesize="8" OffsetHex="00000F20" DisplayMethod="unsigned integer"/>
        <Element Offset="3876" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F24" DisplayMethod="unsigned integer"/>
        <Element Offset="3880" Vartype="Pointer" Bytesize="8" OffsetHex="00000F28" DisplayMethod="unsigned integer"/>
        <Element Offset="3884" Vartype="Pointer" Bytesize="8" OffsetHex="00000F2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3888" Vartype="Pointer" Bytesize="8" OffsetHex="00000F30" DisplayMethod="unsigned integer"/>
        <Element Offset="3892" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F34" DisplayMethod="unsigned integer"/>
        <Element Offset="3896" Vartype="Double" Bytesize="8" OffsetHex="00000F38" DisplayMethod="unsigned integer"/>
        <Element Offset="3904" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000F40" DisplayMethod="unsigned integer"/>
        <Element Offset="3948" Vartype="Pointer" Bytesize="8" OffsetHex="00000F6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3952" Vartype="Pointer" Bytesize="8" OffsetHex="00000F70" DisplayMethod="unsigned integer"/>
        <Element Offset="3956" Vartype="Pointer" Bytesize="8" OffsetHex="00000F74" DisplayMethod="unsigned integer"/>
        <Element Offset="3960" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000F78" DisplayMethod="unsigned integer"/>
        <Element Offset="3976" Vartype="Float" Bytesize="4" OffsetHex="00000F88" DisplayMethod="unsigned integer"/>
        <Element Offset="3980" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3992" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F98" DisplayMethod="unsigned integer"/>
        <Element Offset="4004" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FA4" DisplayMethod="hexadecimal"/>
        <Element Offset="4008" Vartype="Pointer" Bytesize="8" OffsetHex="00000FA8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="4012" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FAC" DisplayMethod="unsigned integer"/>
        <Element Offset="4016" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000FB0" DisplayMethod="hexadecimal"/>
        <Element Offset="4056" Vartype="Pointer" Bytesize="8" OffsetHex="00000FD8" DisplayMethod="unsigned integer"/>
        <Element Offset="4060" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FDC" DisplayMethod="hexadecimal"/>
        <Element Offset="4064" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000FE0" DisplayMethod="unsigned integer"/>
        <Element Offset="4072" Vartype="Float" Bytesize="4" OffsetHex="00000FE8" DisplayMethod="unsigned integer"/>
        <Element Offset="4076" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000FEC" DisplayMethod="unsigned integer"/>
        <Element Offset="4092" Vartype="Float" Bytesize="4" OffsetHex="00000FFC" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Pointer" Bytesize="8" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="4" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000004" DisplayMethod="unsigned integer"/>
        <Element Offset="16" Vartype="Float" Bytesize="4" OffsetHex="00000010" DisplayMethod="unsigned integer"/>
        <Element Offset="20" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000014" DisplayMethod="unsigned integer"/>
        <Element Offset="36" Vartype="Float" Bytesize="4" OffsetHex="00000024" DisplayMethod="unsigned integer"/>
        <Element Offset="40" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000028" DisplayMethod="unsigned integer"/>
        <Element Offset="48" Vartype="Float" Bytesize="4" OffsetHex="00000030" DisplayMethod="unsigned integer"/>
        <Element Offset="52" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000034" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="Float" Bytesize="4" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="60" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000003C" DisplayMethod="unsigned integer"/>
        <Element Offset="68" Vartype="Double" Bytesize="8" OffsetHex="00000044" DisplayMethod="unsigned integer"/>
        <Element Offset="76" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="0000004C" DisplayMethod="unsigned integer"/>
        <Element Offset="84" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000054" DisplayMethod="unsigned integer"/>
        <Element Offset="88" Vartype="Pointer" Bytesize="8" OffsetHex="00000058" DisplayMethod="unsigned integer"/>
        <Element Offset="92" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000005C" DisplayMethod="unsigned integer"/>
        <Element Offset="104" Vartype="Pointer" Bytesize="8" OffsetHex="00000068" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="Pointer" Bytesize="8" OffsetHex="0000006C" Description="Pointer to instance of InternAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Pointer" Bytesize="8" OffsetHex="00000070" Description="Pointer to instance of LegMotion" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="Pointer" Bytesize="8" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="Pointer" Bytesize="8" OffsetHex="00000078" Description="Pointer to instance of Intern" DisplayMethod="unsigned integer"/>
        <Element Offset="124" Vartype="Pointer" Bytesize="8" OffsetHex="0000007C" DisplayMethod="unsigned integer"/>
        <Element Offset="128" Vartype="Pointer" Bytesize="8" OffsetHex="00000080" DisplayMethod="unsigned integer"/>
        <Element Offset="132" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000084" DisplayMethod="unsigned integer"/>
        <Element Offset="136" Vartype="Pointer" Bytesize="8" OffsetHex="00000088" DisplayMethod="unsigned integer"/>
        <Element Offset="140" Vartype="Pointer" Bytesize="8" OffsetHex="0000008C" DisplayMethod="unsigned integer"/>
        <Element Offset="144" Vartype="Pointer" Bytesize="8" OffsetHex="00000090" DisplayMethod="unsigned integer"/>
        <Element Offset="148" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000094" DisplayMethod="unsigned integer"/>
        <Element Offset="152" Vartype="Double" Bytesize="8" OffsetHex="00000098" DisplayMethod="unsigned integer"/>
        <Element Offset="160" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000A0" DisplayMethod="unsigned integer"/>
        <Element Offset="172" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000000AC" DisplayMethod="unsigned integer"/>
        <Element Offset="184" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000B8" DisplayMethod="unsigned integer"/>
        <Element Offset="196" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000C4" DisplayMethod="unsigned integer"/>
        <Element Offset="204" Vartype="Pointer" Bytesize="8" OffsetHex="000000CC" DisplayMethod="unsigned integer"/>
        <Element Offset="208" Vartype="Pointer" Bytesize="8" OffsetHex="000000D0" DisplayMethod="unsigned integer"/>
        <Element Offset="212" Vartype="Pointer" Bytesize="8" OffsetHex="000000D4" DisplayMethod="unsigned integer"/>
        <Element Offset="216" Vartype="Pointer" Bytesize="8" OffsetHex="000000D8" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="220" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000DC" DisplayMethod="unsigned integer"/>
        <Element Offset="224" Vartype="Double" Bytesize="8" OffsetHex="000000E0" DisplayMethod="unsigned integer"/>
        <Element Offset="232" Vartype="Float" Bytesize="4" OffsetHex="000000E8" DisplayMethod="unsigned integer"/>
        <Element Offset="236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000EC" DisplayMethod="hexadecimal"/>
        <Element Offset="240" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000F0" DisplayMethod="unsigned integer"/>
        <Element Offset="248" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000F8" DisplayMethod="unsigned integer"/>
        <Element Offset="260" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000104" DisplayMethod="unsigned integer"/>
        <Element Offset="264" Vartype="Pointer" Bytesize="8" OffsetHex="00000108" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="Float" Bytesize="4" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000110" DisplayMethod="hexadecimal"/>
        <Element Offset="312" Vartype="Pointer" Bytesize="8" OffsetHex="00000138" DisplayMethod="unsigned integer"/>
        <Element Offset="316" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000013C" DisplayMethod="hexadecimal"/>
        <Element Offset="320" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000140" DisplayMethod="unsigned integer"/>
        <Element Offset="328" Vartype="Float" Bytesize="4" OffsetHex="00000148" DisplayMethod="unsigned integer"/>
        <Element Offset="332" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="0000014C" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="Float" Bytesize="4" OffsetHex="0000015C" DisplayMethod="unsigned integer"/>
        <Element Offset="352" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000160" DisplayMethod="unsigned integer"/>
        <Element Offset="360" Vartype="Float" Bytesize="4" OffsetHex="00000168" DisplayMethod="unsigned integer"/>
        <Element Offset="364" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000016C" DisplayMethod="unsigned integer"/>
        <Element Offset="368" Vartype="Float" Bytesize="4" OffsetHex="00000170" DisplayMethod="unsigned integer"/>
        <Element Offset="372" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000174" DisplayMethod="unsigned integer"/>
        <Element Offset="380" Vartype="Double" Bytesize="8" OffsetHex="0000017C" DisplayMethod="unsigned integer"/>
        <Element Offset="388" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000184" DisplayMethod="unsigned integer"/>
        <Element Offset="392" Vartype="Float" Bytesize="4" OffsetHex="00000188" DisplayMethod="unsigned integer"/>
        <Element Offset="396" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000018C" DisplayMethod="unsigned integer"/>
        <Element Offset="416" Vartype="Pointer" Bytesize="8" OffsetHex="000001A0" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="Pointer" Bytesize="8" OffsetHex="000001A4" Description="Pointer to instance of Projectile" DisplayMethod="unsigned integer"/>
        <Element Offset="424" Vartype="Pointer" Bytesize="8" OffsetHex="000001A8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="428" Vartype="Pointer" Bytesize="8" OffsetHex="000001AC" DisplayMethod="unsigned integer"/>
        <Element Offset="432" Vartype="Pointer" Bytesize="8" OffsetHex="000001B0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="436" Vartype="Pointer" Bytesize="8" OffsetHex="000001B4" DisplayMethod="unsigned integer"/>
        <Element Offset="440" Vartype="Pointer" Bytesize="8" OffsetHex="000001B8" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="Pointer" Bytesize="8" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="448" Vartype="Pointer" Bytesize="8" OffsetHex="000001C0" DisplayMethod="unsigned integer"/>
        <Element Offset="452" Vartype="Pointer" Bytesize="8" OffsetHex="000001C4" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="Pointer" Bytesize="8" OffsetHex="000001C8" DisplayMethod="unsigned integer"/>
        <Element Offset="460" Vartype="Pointer" Bytesize="8" OffsetHex="000001CC" DisplayMethod="unsigned integer"/>
        <Element Offset="464" Vartype="Pointer" Bytesize="8" OffsetHex="000001D0" DisplayMethod="unsigned integer"/>
        <Element Offset="468" Vartype="Float" Bytesize="4" OffsetHex="000001D4" DisplayMethod="unsigned integer"/>
        <Element Offset="472" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="000001D8" DisplayMethod="unsigned integer"/>
        <Element Offset="508" Vartype="Pointer" Bytesize="8" OffsetHex="000001FC" DisplayMethod="unsigned integer"/>
        <Element Offset="512" Vartype="Pointer" Bytesize="8" OffsetHex="00000200" DisplayMethod="unsigned integer"/>
        <Element Offset="516" Vartype="Pointer" Bytesize="8" OffsetHex="00000204" DisplayMethod="unsigned integer"/>
        <Element Offset="520" Vartype="Pointer" Bytesize="8" OffsetHex="00000208" DisplayMethod="unsigned integer"/>
        <Element Offset="524" Vartype="Pointer" Bytesize="8" OffsetHex="0000020C" DisplayMethod="unsigned integer"/>
        <Element Offset="528" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000210" DisplayMethod="unsigned integer"/>
        <Element Offset="544" Vartype="Float" Bytesize="4" OffsetHex="00000220" DisplayMethod="unsigned integer"/>
        <Element Offset="548" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000224" DisplayMethod="unsigned integer"/>
        <Element Offset="572" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000023C" DisplayMethod="hexadecimal"/>
        <Element Offset="576" Vartype="Pointer" Bytesize="8" OffsetHex="00000240" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="580" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000244" DisplayMethod="unsigned integer"/>
        <Element Offset="584" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000248" DisplayMethod="hexadecimal"/>
        <Element Offset="624" Vartype="Pointer" Bytesize="8" OffsetHex="00000270" DisplayMethod="unsigned integer"/>
        <Element Offset="628" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000274" DisplayMethod="unsigned integer"/>
        <Element Offset="640" Vartype="Float" Bytesize="4" OffsetHex="00000280" DisplayMethod="unsigned integer"/>
        <Element Offset="644" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000284" DisplayMethod="unsigned integer"/>
        <Element Offset="660" Vartype="Float" Bytesize="4" OffsetHex="00000294" DisplayMethod="unsigned integer"/>
        <Element Offset="664" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000298" DisplayMethod="unsigned integer"/>
        <Element Offset="672" Vartype="Float" Bytesize="4" OffsetHex="000002A0" DisplayMethod="unsigned integer"/>
        <Element Offset="676" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002A4" DisplayMethod="unsigned integer"/>
        <Element Offset="680" Vartype="Float" Bytesize="4" OffsetHex="000002A8" DisplayMethod="unsigned integer"/>
        <Element Offset="684" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000002AC" DisplayMethod="unsigned integer"/>
        <Element Offset="692" Vartype="Double" Bytesize="8" OffsetHex="000002B4" DisplayMethod="unsigned integer"/>
        <Element Offset="700" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000002BC" DisplayMethod="unsigned integer"/>
        <Element Offset="708" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002C4" DisplayMethod="unsigned integer"/>
        <Element Offset="712" Vartype="Pointer" Bytesize="8" OffsetHex="000002C8" DisplayMethod="unsigned integer"/>
        <Element Offset="716" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000002CC" DisplayMethod="unsigned integer"/>
        <Element Offset="728" Vartype="Pointer" Bytesize="8" OffsetHex="000002D8" DisplayMethod="unsigned integer"/>
        <Element Offset="732" Vartype="Pointer" Bytesize="8" OffsetHex="000002DC" Description="Pointer to instance of FuzzleAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="736" Vartype="Pointer" Bytesize="8" OffsetHex="000002E0" Description="Pointer to instance of LegMotion" DisplayMethod="unsigned integer"/>
        <Element Offset="740" Vartype="Pointer" Bytesize="8" OffsetHex="000002E4" DisplayMethod="unsigned integer"/>
        <Element Offset="744" Vartype="Pointer" Bytesize="8" OffsetHex="000002E8" Description="Pointer to instance of Fuzzle" DisplayMethod="unsigned integer"/>
        <Element Offset="748" Vartype="Pointer" Bytesize="8" OffsetHex="000002EC" DisplayMethod="unsigned integer"/>
        <Element Offset="752" Vartype="Pointer" Bytesize="8" OffsetHex="000002F0" DisplayMethod="unsigned integer"/>
        <Element Offset="756" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002F4" DisplayMethod="unsigned integer"/>
        <Element Offset="760" Vartype="Pointer" Bytesize="8" OffsetHex="000002F8" DisplayMethod="unsigned integer"/>
        <Element Offset="764" Vartype="Pointer" Bytesize="8" OffsetHex="000002FC" DisplayMethod="unsigned integer"/>
        <Element Offset="768" Vartype="Pointer" Bytesize="8" OffsetHex="00000300" DisplayMethod="unsigned integer"/>
        <Element Offset="772" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000304" DisplayMethod="unsigned integer"/>
        <Element Offset="776" Vartype="Double" Bytesize="8" OffsetHex="00000308" DisplayMethod="unsigned integer"/>
        <Element Offset="784" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000310" DisplayMethod="unsigned integer"/>
        <Element Offset="792" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000318" DisplayMethod="unsigned integer"/>
        <Element Offset="794" Vartype="2 Bytes" Bytesize="2" OffsetHex="0000031A" DisplayMethod="unsigned integer"/>
        <Element Offset="796" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000031C" DisplayMethod="unsigned integer"/>
        <Element Offset="808" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000328" DisplayMethod="unsigned integer"/>
        <Element Offset="816" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000330" DisplayMethod="unsigned integer"/>
        <Element Offset="818" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000332" DisplayMethod="unsigned integer"/>
        <Element Offset="820" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000334" DisplayMethod="unsigned integer"/>
        <Element Offset="828" Vartype="Pointer" Bytesize="8" OffsetHex="0000033C" DisplayMethod="unsigned integer"/>
        <Element Offset="832" Vartype="Pointer" Bytesize="8" OffsetHex="00000340" DisplayMethod="unsigned integer"/>
        <Element Offset="836" Vartype="Pointer" Bytesize="8" OffsetHex="00000344" DisplayMethod="unsigned integer"/>
        <Element Offset="840" Vartype="Pointer" Bytesize="8" OffsetHex="00000348" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="844" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000034C" DisplayMethod="unsigned integer"/>
        <Element Offset="856" Vartype="Float" Bytesize="4" OffsetHex="00000358" DisplayMethod="unsigned integer"/>
        <Element Offset="860" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000035C" DisplayMethod="hexadecimal"/>
        <Element Offset="864" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000360" DisplayMethod="unsigned integer"/>
        <Element Offset="872" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000368" DisplayMethod="unsigned integer"/>
        <Element Offset="880" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000370" DisplayMethod="unsigned integer"/>
        <Element Offset="882" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000372" DisplayMethod="unsigned integer"/>
        <Element Offset="884" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000374" DisplayMethod="unsigned integer"/>
        <Element Offset="888" Vartype="Pointer" Bytesize="8" OffsetHex="00000378" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="892" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000037C" DisplayMethod="unsigned integer"/>
        <Element Offset="896" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000380" DisplayMethod="hexadecimal"/>
        <Element Offset="936" Vartype="Pointer" Bytesize="8" OffsetHex="000003A8" DisplayMethod="unsigned integer"/>
        <Element Offset="940" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000003AC" DisplayMethod="unsigned integer"/>
        <Element Offset="952" Vartype="Float" Bytesize="4" OffsetHex="000003B8" DisplayMethod="unsigned integer"/>
        <Element Offset="956" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000003BC" DisplayMethod="unsigned integer"/>
        <Element Offset="972" Vartype="Float" Bytesize="4" OffsetHex="000003CC" DisplayMethod="unsigned integer"/>
        <Element Offset="976" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003D0" DisplayMethod="unsigned integer"/>
        <Element Offset="984" Vartype="Float" Bytesize="4" OffsetHex="000003D8" DisplayMethod="unsigned integer"/>
        <Element Offset="988" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003DC" DisplayMethod="unsigned integer"/>
        <Element Offset="992" Vartype="Float" Bytesize="4" OffsetHex="000003E0" DisplayMethod="unsigned integer"/>
        <Element Offset="996" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1004" Vartype="Double" Bytesize="8" OffsetHex="000003EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1012" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1016" Vartype="Float" Bytesize="4" OffsetHex="000003F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1020" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000003FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1040" Vartype="Pointer" Bytesize="8" OffsetHex="00000410" DisplayMethod="unsigned integer"/>
        <Element Offset="1044" Vartype="Pointer" Bytesize="8" OffsetHex="00000414" Description="Pointer to instance of NullAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="1048" Vartype="Pointer" Bytesize="8" OffsetHex="00000418" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1052" Vartype="Pointer" Bytesize="8" OffsetHex="0000041C" DisplayMethod="unsigned integer"/>
        <Element Offset="1056" Vartype="Pointer" Bytesize="8" OffsetHex="00000420" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1060" Vartype="Pointer" Bytesize="8" OffsetHex="00000424" DisplayMethod="unsigned integer"/>
        <Element Offset="1064" Vartype="Pointer" Bytesize="8" OffsetHex="00000428" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="Pointer" Bytesize="8" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="Pointer" Bytesize="8" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1076" Vartype="Pointer" Bytesize="8" OffsetHex="00000434" DisplayMethod="unsigned integer"/>
        <Element Offset="1080" Vartype="Pointer" Bytesize="8" OffsetHex="00000438" DisplayMethod="unsigned integer"/>
        <Element Offset="1084" Vartype="Pointer" Bytesize="8" OffsetHex="0000043C" DisplayMethod="unsigned integer"/>
        <Element Offset="1088" Vartype="Pointer" Bytesize="8" OffsetHex="00000440" DisplayMethod="unsigned integer"/>
        <Element Offset="1092" Vartype="Float" Bytesize="4" OffsetHex="00000444" DisplayMethod="unsigned integer"/>
        <Element Offset="1096" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000448" DisplayMethod="unsigned integer"/>
        <Element Offset="1140" Vartype="Pointer" Bytesize="8" OffsetHex="00000474" DisplayMethod="unsigned integer"/>
        <Element Offset="1144" Vartype="Pointer" Bytesize="8" OffsetHex="00000478" DisplayMethod="unsigned integer"/>
        <Element Offset="1148" Vartype="Pointer" Bytesize="8" OffsetHex="0000047C" DisplayMethod="unsigned integer"/>
        <Element Offset="1152" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000480" DisplayMethod="unsigned integer"/>
        <Element Offset="1168" Vartype="Float" Bytesize="4" OffsetHex="00000490" DisplayMethod="unsigned integer"/>
        <Element Offset="1172" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="00000494" DisplayMethod="unsigned integer"/>
        <Element Offset="1200" Vartype="Pointer" Bytesize="8" OffsetHex="000004B0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1204" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1208" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="000004B8" DisplayMethod="hexadecimal"/>
        <Element Offset="1248" Vartype="4 Bytes" Bytesize="4" RLECount="66" OffsetHex="000004E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1512" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="000005E8" DisplayMethod="hexadecimal"/>
        <Element Offset="1544" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000608" DisplayMethod="unsigned integer"/>
        <Element Offset="1552" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000610" DisplayMethod="hexadecimal"/>
        <Element Offset="1560" Vartype="4 Bytes" Bytesize="4" RLECount="66" OffsetHex="00000618" DisplayMethod="unsigned integer"/>
        <Element Offset="1824" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000720" DisplayMethod="hexadecimal"/>
        <Element Offset="1856" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000740" DisplayMethod="unsigned integer"/>
        <Element Offset="1864" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000748" DisplayMethod="hexadecimal"/>
        <Element Offset="1872" Vartype="Pointer" Bytesize="8" OffsetHex="00000750" DisplayMethod="unsigned integer"/>
        <Element Offset="1876" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000754" DisplayMethod="hexadecimal"/>
        <Element Offset="1880" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000758" DisplayMethod="unsigned integer"/>
        <Element Offset="1888" Vartype="Float" Bytesize="4" OffsetHex="00000760" DisplayMethod="unsigned integer"/>
        <Element Offset="1892" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000764" DisplayMethod="unsigned integer"/>
        <Element Offset="1908" Vartype="Float" Bytesize="4" OffsetHex="00000774" DisplayMethod="unsigned integer"/>
        <Element Offset="1912" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000778" DisplayMethod="unsigned integer"/>
        <Element Offset="1920" Vartype="Float" Bytesize="4" OffsetHex="00000780" DisplayMethod="unsigned integer"/>
        <Element Offset="1924" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000784" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="Float" Bytesize="4" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1932" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000078C" DisplayMethod="unsigned integer"/>
        <Element Offset="1940" Vartype="Double" Bytesize="8" OffsetHex="00000794" DisplayMethod="unsigned integer"/>
        <Element Offset="1948" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000079C" DisplayMethod="unsigned integer"/>
        <Element Offset="1952" Vartype="Float" Bytesize="4" OffsetHex="000007A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1956" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000007A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1976" Vartype="Pointer" Bytesize="8" OffsetHex="000007B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1980" Vartype="Pointer" Bytesize="8" OffsetHex="000007BC" Description="Pointer to instance of Projectile" DisplayMethod="unsigned integer"/>
        <Element Offset="1984" Vartype="Pointer" Bytesize="8" OffsetHex="000007C0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1988" Vartype="Pointer" Bytesize="8" OffsetHex="000007C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1992" Vartype="Pointer" Bytesize="8" OffsetHex="000007C8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1996" Vartype="Pointer" Bytesize="8" OffsetHex="000007CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2000" Vartype="Pointer" Bytesize="8" OffsetHex="000007D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2004" Vartype="Pointer" Bytesize="8" OffsetHex="000007D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2008" Vartype="Pointer" Bytesize="8" OffsetHex="000007D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2012" Vartype="Pointer" Bytesize="8" OffsetHex="000007DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="Pointer" Bytesize="8" OffsetHex="000007E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2020" Vartype="Pointer" Bytesize="8" OffsetHex="000007E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2024" Vartype="Pointer" Bytesize="8" OffsetHex="000007E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2028" Vartype="Float" Bytesize="4" OffsetHex="000007EC" DisplayMethod="unsigned integer"/>
        <Element Offset="2032" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="000007F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2068" Vartype="Pointer" Bytesize="8" OffsetHex="00000814" DisplayMethod="unsigned integer"/>
        <Element Offset="2072" Vartype="Pointer" Bytesize="8" OffsetHex="00000818" DisplayMethod="unsigned integer"/>
        <Element Offset="2076" Vartype="Pointer" Bytesize="8" OffsetHex="0000081C" DisplayMethod="unsigned integer"/>
        <Element Offset="2080" Vartype="Pointer" Bytesize="8" OffsetHex="00000820" DisplayMethod="unsigned integer"/>
        <Element Offset="2084" Vartype="Pointer" Bytesize="8" OffsetHex="00000824" DisplayMethod="unsigned integer"/>
        <Element Offset="2088" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000828" DisplayMethod="unsigned integer"/>
        <Element Offset="2104" Vartype="Float" Bytesize="4" OffsetHex="00000838" DisplayMethod="unsigned integer"/>
        <Element Offset="2108" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="0000083C" DisplayMethod="unsigned integer"/>
        <Element Offset="2132" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000854" DisplayMethod="hexadecimal"/>
        <Element Offset="2136" Vartype="Pointer" Bytesize="8" OffsetHex="00000858" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2140" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000085C" DisplayMethod="unsigned integer"/>
        <Element Offset="2144" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000860" DisplayMethod="hexadecimal"/>
        <Element Offset="2184" Vartype="Pointer" Bytesize="8" OffsetHex="00000888" DisplayMethod="unsigned integer"/>
        <Element Offset="2188" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000088C" DisplayMethod="unsigned integer"/>
        <Element Offset="2200" Vartype="Float" Bytesize="4" OffsetHex="00000898" DisplayMethod="unsigned integer"/>
        <Element Offset="2204" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="0000089C" DisplayMethod="unsigned integer"/>
        <Element Offset="2220" Vartype="Float" Bytesize="4" OffsetHex="000008AC" DisplayMethod="unsigned integer"/>
        <Element Offset="2224" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2232" Vartype="Float" Bytesize="4" OffsetHex="000008B8" DisplayMethod="unsigned integer"/>
        <Element Offset="2236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2240" Vartype="Float" Bytesize="4" OffsetHex="000008C0" DisplayMethod="unsigned integer"/>
        <Element Offset="2244" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2252" Vartype="Double" Bytesize="8" OffsetHex="000008CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2260" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000008D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2268" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2288" Vartype="Pointer" Bytesize="8" OffsetHex="000008F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2292" Vartype="Pointer" Bytesize="8" OffsetHex="000008F4" Description="Pointer to instance of Lever360Animation" DisplayMethod="unsigned integer"/>
        <Element Offset="2296" Vartype="Pointer" Bytesize="8" OffsetHex="000008F8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2300" Vartype="Pointer" Bytesize="8" OffsetHex="000008FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2304" Vartype="Pointer" Bytesize="8" OffsetHex="00000900" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2308" Vartype="Pointer" Bytesize="8" OffsetHex="00000904" DisplayMethod="unsigned integer"/>
        <Element Offset="2312" Vartype="Pointer" Bytesize="8" OffsetHex="00000908" DisplayMethod="unsigned integer"/>
        <Element Offset="2316" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000090C" DisplayMethod="unsigned integer"/>
        <Element Offset="2320" Vartype="Pointer" Bytesize="8" OffsetHex="00000910" DisplayMethod="unsigned integer"/>
        <Element Offset="2324" Vartype="Pointer" Bytesize="8" OffsetHex="00000914" DisplayMethod="unsigned integer"/>
        <Element Offset="2328" Vartype="Pointer" Bytesize="8" OffsetHex="00000918" DisplayMethod="unsigned integer"/>
        <Element Offset="2332" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000091C" DisplayMethod="unsigned integer"/>
        <Element Offset="2336" Vartype="Double" Bytesize="8" OffsetHex="00000920" DisplayMethod="unsigned integer"/>
        <Element Offset="2344" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000928" DisplayMethod="unsigned integer"/>
        <Element Offset="2388" Vartype="Pointer" Bytesize="8" OffsetHex="00000954" DisplayMethod="unsigned integer"/>
        <Element Offset="2392" Vartype="Pointer" Bytesize="8" OffsetHex="00000958" DisplayMethod="unsigned integer"/>
        <Element Offset="2396" Vartype="Pointer" Bytesize="8" OffsetHex="0000095C" DisplayMethod="unsigned integer"/>
        <Element Offset="2400" Vartype="Pointer" Bytesize="8" OffsetHex="00000960" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="2404" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000964" DisplayMethod="unsigned integer"/>
        <Element Offset="2416" Vartype="Float" Bytesize="4" OffsetHex="00000970" DisplayMethod="unsigned integer"/>
        <Element Offset="2420" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000974" DisplayMethod="unsigned integer"/>
        <Element Offset="2432" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000980" DisplayMethod="unsigned integer"/>
        <Element Offset="2444" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000098C" DisplayMethod="unsigned integer"/>
        <Element Offset="2448" Vartype="Pointer" Bytesize="8" OffsetHex="00000990" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2452" Vartype="Float" Bytesize="4" OffsetHex="00000994" DisplayMethod="unsigned integer"/>
        <Element Offset="2456" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000998" DisplayMethod="hexadecimal"/>
        <Element Offset="2492" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2496" Vartype="Pointer" Bytesize="8" OffsetHex="000009C0" DisplayMethod="unsigned integer"/>
        <Element Offset="2500" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000009C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2512" Vartype="Float" Bytesize="4" OffsetHex="000009D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2516" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000009D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2532" Vartype="Float" Bytesize="4" OffsetHex="000009E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2536" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2544" Vartype="Float" Bytesize="4" OffsetHex="000009F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2548" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2552" Vartype="Float" Bytesize="4" OffsetHex="000009F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2556" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2564" Vartype="Double" Bytesize="8" OffsetHex="00000A04" DisplayMethod="unsigned integer"/>
        <Element Offset="2572" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000A0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2580" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000A14" DisplayMethod="unsigned integer"/>
        <Element Offset="2600" Vartype="Pointer" Bytesize="8" OffsetHex="00000A28" DisplayMethod="unsigned integer"/>
        <Element Offset="2604" Vartype="Pointer" Bytesize="8" OffsetHex="00000A2C" Description="Pointer to instance of Lever360Animation" DisplayMethod="unsigned integer"/>
        <Element Offset="2608" Vartype="Pointer" Bytesize="8" OffsetHex="00000A30" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2612" Vartype="Pointer" Bytesize="8" OffsetHex="00000A34" DisplayMethod="unsigned integer"/>
        <Element Offset="2616" Vartype="Pointer" Bytesize="8" OffsetHex="00000A38" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2620" Vartype="Pointer" Bytesize="8" OffsetHex="00000A3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2624" Vartype="Pointer" Bytesize="8" OffsetHex="00000A40" DisplayMethod="unsigned integer"/>
        <Element Offset="2628" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A44" DisplayMethod="unsigned integer"/>
        <Element Offset="2632" Vartype="Pointer" Bytesize="8" OffsetHex="00000A48" DisplayMethod="unsigned integer"/>
        <Element Offset="2636" Vartype="Pointer" Bytesize="8" OffsetHex="00000A4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2640" Vartype="Pointer" Bytesize="8" OffsetHex="00000A50" DisplayMethod="unsigned integer"/>
        <Element Offset="2644" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A54" DisplayMethod="unsigned integer"/>
        <Element Offset="2648" Vartype="Double" Bytesize="8" OffsetHex="00000A58" DisplayMethod="unsigned integer"/>
        <Element Offset="2656" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000A60" DisplayMethod="unsigned integer"/>
        <Element Offset="2700" Vartype="Pointer" Bytesize="8" OffsetHex="00000A8C" DisplayMethod="unsigned integer"/>
        <Element Offset="2704" Vartype="Pointer" Bytesize="8" OffsetHex="00000A90" DisplayMethod="unsigned integer"/>
        <Element Offset="2708" Vartype="Pointer" Bytesize="8" OffsetHex="00000A94" DisplayMethod="unsigned integer"/>
        <Element Offset="2712" Vartype="Pointer" Bytesize="8" OffsetHex="00000A98" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="2716" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000A9C" DisplayMethod="unsigned integer"/>
        <Element Offset="2728" Vartype="Float" Bytesize="4" OffsetHex="00000AA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2732" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000AAC" DisplayMethod="unsigned integer"/>
        <Element Offset="2744" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000AB8" DisplayMethod="unsigned integer"/>
        <Element Offset="2756" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AC4" DisplayMethod="unsigned integer"/>
        <Element Offset="2760" Vartype="Pointer" Bytesize="8" OffsetHex="00000AC8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2764" Vartype="Float" Bytesize="4" OffsetHex="00000ACC" DisplayMethod="unsigned integer"/>
        <Element Offset="2768" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000AD0" DisplayMethod="hexadecimal"/>
        <Element Offset="2808" Vartype="4 Bytes" Bytesize="4" RLECount="66" OffsetHex="00000AF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3072" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000C00" DisplayMethod="hexadecimal"/>
        <Element Offset="3104" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C20" DisplayMethod="unsigned integer"/>
        <Element Offset="3112" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C28" DisplayMethod="hexadecimal"/>
        <Element Offset="3120" Vartype="Pointer" Bytesize="8" OffsetHex="00000C30" DisplayMethod="unsigned integer"/>
        <Element Offset="3124" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C34" DisplayMethod="unsigned integer"/>
        <Element Offset="3136" Vartype="Float" Bytesize="4" OffsetHex="00000C40" DisplayMethod="unsigned integer"/>
        <Element Offset="3140" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000C44" DisplayMethod="unsigned integer"/>
        <Element Offset="3156" Vartype="Float" Bytesize="4" OffsetHex="00000C54" DisplayMethod="unsigned integer"/>
        <Element Offset="3160" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C58" DisplayMethod="unsigned integer"/>
        <Element Offset="3168" Vartype="Float" Bytesize="4" OffsetHex="00000C60" DisplayMethod="unsigned integer"/>
        <Element Offset="3172" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C64" DisplayMethod="unsigned integer"/>
        <Element Offset="3176" Vartype="Float" Bytesize="4" OffsetHex="00000C68" DisplayMethod="unsigned integer"/>
        <Element Offset="3180" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3188" Vartype="Double" Bytesize="8" OffsetHex="00000C74" DisplayMethod="unsigned integer"/>
        <Element Offset="3196" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3200" Vartype="Float" Bytesize="4" OffsetHex="00000C80" DisplayMethod="unsigned integer"/>
        <Element Offset="3204" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000C84" DisplayMethod="unsigned integer"/>
        <Element Offset="3224" Vartype="Pointer" Bytesize="8" OffsetHex="00000C98" DisplayMethod="unsigned integer"/>
        <Element Offset="3228" Vartype="Pointer" Bytesize="8" OffsetHex="00000C9C" Description="Pointer to instance of NullAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="3232" Vartype="Pointer" Bytesize="8" OffsetHex="00000CA0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3236" Vartype="Pointer" Bytesize="8" OffsetHex="00000CA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3240" Vartype="Pointer" Bytesize="8" OffsetHex="00000CA8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3244" Vartype="Pointer" Bytesize="8" OffsetHex="00000CAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3248" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3252" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3256" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3260" Vartype="Pointer" Bytesize="8" OffsetHex="00000CBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3264" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3268" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3272" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3276" Vartype="Float" Bytesize="4" OffsetHex="00000CCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3280" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000CD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3324" Vartype="Pointer" Bytesize="8" OffsetHex="00000CFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3328" Vartype="Pointer" Bytesize="8" OffsetHex="00000D00" DisplayMethod="unsigned integer"/>
        <Element Offset="3332" Vartype="Pointer" Bytesize="8" OffsetHex="00000D04" DisplayMethod="unsigned integer"/>
        <Element Offset="3336" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000D08" DisplayMethod="unsigned integer"/>
        <Element Offset="3352" Vartype="Float" Bytesize="4" OffsetHex="00000D18" DisplayMethod="unsigned integer"/>
        <Element Offset="3356" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="00000D1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3384" Vartype="Pointer" Bytesize="8" OffsetHex="00000D38" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3388" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3392" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000D40" DisplayMethod="hexadecimal"/>
        <Element Offset="3432" Vartype="Pointer" Bytesize="8" OffsetHex="00000D68" DisplayMethod="unsigned integer"/>
        <Element Offset="3436" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D6C" DisplayMethod="hexadecimal"/>
        <Element Offset="3440" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D70" DisplayMethod="unsigned integer"/>
        <Element Offset="3448" Vartype="Float" Bytesize="4" OffsetHex="00000D78" DisplayMethod="unsigned integer"/>
        <Element Offset="3452" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000D7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3468" Vartype="Float" Bytesize="4" OffsetHex="00000D8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3472" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D90" DisplayMethod="unsigned integer"/>
        <Element Offset="3480" Vartype="Float" Bytesize="4" OffsetHex="00000D98" DisplayMethod="unsigned integer"/>
        <Element Offset="3484" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3488" Vartype="Float" Bytesize="4" OffsetHex="00000DA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3492" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3500" Vartype="Double" Bytesize="8" OffsetHex="00000DAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3508" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3512" Vartype="Float" Bytesize="4" OffsetHex="00000DB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3516" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000DBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3536" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3540" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD4" Description="Pointer to instance of Projectile" DisplayMethod="unsigned integer"/>
        <Element Offset="3544" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3548" Vartype="Pointer" Bytesize="8" OffsetHex="00000DDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3552" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3556" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3560" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3564" Vartype="Pointer" Bytesize="8" OffsetHex="00000DEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3568" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3572" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3576" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3580" Vartype="Pointer" Bytesize="8" OffsetHex="00000DFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3584" Vartype="Pointer" Bytesize="8" OffsetHex="00000E00" DisplayMethod="unsigned integer"/>
        <Element Offset="3588" Vartype="Float" Bytesize="4" OffsetHex="00000E04" DisplayMethod="unsigned integer"/>
        <Element Offset="3592" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000E08" DisplayMethod="unsigned integer"/>
        <Element Offset="3628" Vartype="Pointer" Bytesize="8" OffsetHex="00000E2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3632" Vartype="Pointer" Bytesize="8" OffsetHex="00000E30" DisplayMethod="unsigned integer"/>
        <Element Offset="3636" Vartype="Pointer" Bytesize="8" OffsetHex="00000E34" DisplayMethod="unsigned integer"/>
        <Element Offset="3640" Vartype="Pointer" Bytesize="8" OffsetHex="00000E38" DisplayMethod="unsigned integer"/>
        <Element Offset="3644" Vartype="Pointer" Bytesize="8" OffsetHex="00000E3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3648" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000E40" DisplayMethod="unsigned integer"/>
        <Element Offset="3664" Vartype="Float" Bytesize="4" OffsetHex="00000E50" DisplayMethod="unsigned integer"/>
        <Element Offset="3668" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000E54" DisplayMethod="unsigned integer"/>
        <Element Offset="3692" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E6C" DisplayMethod="hexadecimal"/>
        <Element Offset="3696" Vartype="Pointer" Bytesize="8" OffsetHex="00000E70" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3700" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E74" DisplayMethod="unsigned integer"/>
        <Element Offset="3704" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000E78" DisplayMethod="hexadecimal"/>
        <Element Offset="3744" Vartype="Pointer" Bytesize="8" OffsetHex="00000EA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3748" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3760" Vartype="Float" Bytesize="4" OffsetHex="00000EB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3764" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000EB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3780" Vartype="Float" Bytesize="4" OffsetHex="00000EC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3784" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3792" Vartype="Float" Bytesize="4" OffsetHex="00000ED0" DisplayMethod="unsigned integer"/>
        <Element Offset="3796" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000ED4" DisplayMethod="unsigned integer"/>
        <Element Offset="3800" Vartype="Float" Bytesize="4" OffsetHex="00000ED8" DisplayMethod="unsigned integer"/>
        <Element Offset="3804" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3812" Vartype="Double" Bytesize="8" OffsetHex="00000EE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3820" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000EEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3828" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000EF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3832" Vartype="Pointer" Bytesize="8" OffsetHex="00000EF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3836" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3848" Vartype="Pointer" Bytesize="8" OffsetHex="00000F08" DisplayMethod="unsigned integer"/>
        <Element Offset="3852" Vartype="Pointer" Bytesize="8" OffsetHex="00000F0C" Description="Pointer to instance of InternAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="3856" Vartype="Pointer" Bytesize="8" OffsetHex="00000F10" Description="Pointer to instance of LegMotion" DisplayMethod="unsigned integer"/>
        <Element Offset="3860" Vartype="Pointer" Bytesize="8" OffsetHex="00000F14" DisplayMethod="unsigned integer"/>
        <Element Offset="3864" Vartype="Pointer" Bytesize="8" OffsetHex="00000F18" Description="Pointer to instance of Intern" DisplayMethod="unsigned integer"/>
        <Element Offset="3868" Vartype="Pointer" Bytesize="8" OffsetHex="00000F1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3872" Vartype="Pointer" Bytesize="8" OffsetHex="00000F20" DisplayMethod="unsigned integer"/>
        <Element Offset="3876" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F24" DisplayMethod="unsigned integer"/>
        <Element Offset="3880" Vartype="Pointer" Bytesize="8" OffsetHex="00000F28" DisplayMethod="unsigned integer"/>
        <Element Offset="3884" Vartype="Pointer" Bytesize="8" OffsetHex="00000F2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3888" Vartype="Pointer" Bytesize="8" OffsetHex="00000F30" DisplayMethod="unsigned integer"/>
        <Element Offset="3892" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F34" DisplayMethod="unsigned integer"/>
        <Element Offset="3896" Vartype="Double" Bytesize="8" OffsetHex="00000F38" DisplayMethod="unsigned integer"/>
        <Element Offset="3904" Vartype="Float" Bytesize="4" RLECount="5" OffsetHex="00000F40" DisplayMethod="unsigned integer"/>
        <Element Offset="3924" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F54" DisplayMethod="unsigned integer"/>
        <Element Offset="3928" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F58" DisplayMethod="unsigned integer"/>
        <Element Offset="3940" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F64" DisplayMethod="unsigned integer"/>
        <Element Offset="3948" Vartype="Pointer" Bytesize="8" OffsetHex="00000F6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3952" Vartype="Pointer" Bytesize="8" OffsetHex="00000F70" DisplayMethod="unsigned integer"/>
        <Element Offset="3956" Vartype="Pointer" Bytesize="8" OffsetHex="00000F74" DisplayMethod="unsigned integer"/>
        <Element Offset="3960" Vartype="Pointer" Bytesize="8" OffsetHex="00000F78" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="3964" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3976" Vartype="Float" Bytesize="4" OffsetHex="00000F88" DisplayMethod="unsigned integer"/>
        <Element Offset="3980" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F8C" DisplayMethod="hexadecimal"/>
        <Element Offset="3984" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F90" DisplayMethod="unsigned integer"/>
        <Element Offset="3992" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F98" DisplayMethod="unsigned integer"/>
        <Element Offset="4004" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FA4" DisplayMethod="unsigned integer"/>
        <Element Offset="4008" Vartype="Pointer" Bytesize="8" OffsetHex="00000FA8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="4012" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FAC" DisplayMethod="unsigned integer"/>
        <Element Offset="4016" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000FB0" DisplayMethod="hexadecimal"/>
        <Element Offset="4056" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000FD8" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Pointer" Bytesize="8" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="4" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000004" DisplayMethod="unsigned integer"/>
        <Element Offset="16" Vartype="Float" Bytesize="4" OffsetHex="00000010" DisplayMethod="unsigned integer"/>
        <Element Offset="20" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000014" DisplayMethod="unsigned integer"/>
        <Element Offset="36" Vartype="Float" Bytesize="4" OffsetHex="00000024" DisplayMethod="unsigned integer"/>
        <Element Offset="40" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000028" DisplayMethod="unsigned integer"/>
        <Element Offset="48" Vartype="Float" Bytesize="4" OffsetHex="00000030" DisplayMethod="unsigned integer"/>
        <Element Offset="52" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000034" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="Float" Bytesize="4" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="60" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000003C" DisplayMethod="unsigned integer"/>
        <Element Offset="68" Vartype="Double" Bytesize="8" OffsetHex="00000044" DisplayMethod="unsigned integer"/>
        <Element Offset="76" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="0000004C" DisplayMethod="unsigned integer"/>
        <Element Offset="84" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000054" DisplayMethod="unsigned integer"/>
        <Element Offset="88" Vartype="Pointer" Bytesize="8" OffsetHex="00000058" DisplayMethod="unsigned integer"/>
        <Element Offset="92" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000005C" DisplayMethod="unsigned integer"/>
        <Element Offset="104" Vartype="Pointer" Bytesize="8" OffsetHex="00000068" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="Pointer" Bytesize="8" OffsetHex="0000006C" Description="Pointer to instance of InternAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Pointer" Bytesize="8" OffsetHex="00000070" Description="Pointer to instance of LegMotion" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="Pointer" Bytesize="8" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="Pointer" Bytesize="8" OffsetHex="00000078" Description="Pointer to instance of Intern" DisplayMethod="unsigned integer"/>
        <Element Offset="124" Vartype="Pointer" Bytesize="8" OffsetHex="0000007C" DisplayMethod="unsigned integer"/>
        <Element Offset="128" Vartype="Pointer" Bytesize="8" OffsetHex="00000080" DisplayMethod="unsigned integer"/>
        <Element Offset="132" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000084" DisplayMethod="unsigned integer"/>
        <Element Offset="136" Vartype="Pointer" Bytesize="8" OffsetHex="00000088" DisplayMethod="unsigned integer"/>
        <Element Offset="140" Vartype="Pointer" Bytesize="8" OffsetHex="0000008C" DisplayMethod="unsigned integer"/>
        <Element Offset="144" Vartype="Pointer" Bytesize="8" OffsetHex="00000090" DisplayMethod="unsigned integer"/>
        <Element Offset="148" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000094" DisplayMethod="unsigned integer"/>
        <Element Offset="152" Vartype="Double" Bytesize="8" OffsetHex="00000098" DisplayMethod="unsigned integer"/>
        <Element Offset="160" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000A0" DisplayMethod="unsigned integer"/>
        <Element Offset="172" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000000AC" DisplayMethod="unsigned integer"/>
        <Element Offset="184" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000B8" DisplayMethod="unsigned integer"/>
        <Element Offset="196" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000C4" DisplayMethod="unsigned integer"/>
        <Element Offset="204" Vartype="Pointer" Bytesize="8" OffsetHex="000000CC" DisplayMethod="unsigned integer"/>
        <Element Offset="208" Vartype="Pointer" Bytesize="8" OffsetHex="000000D0" DisplayMethod="unsigned integer"/>
        <Element Offset="212" Vartype="Pointer" Bytesize="8" OffsetHex="000000D4" DisplayMethod="unsigned integer"/>
        <Element Offset="216" Vartype="Pointer" Bytesize="8" OffsetHex="000000D8" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="220" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000DC" DisplayMethod="unsigned integer"/>
        <Element Offset="224" Vartype="Float" Bytesize="4" OffsetHex="000000E0" DisplayMethod="unsigned integer"/>
        <Element Offset="228" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000000E4" DisplayMethod="unsigned integer"/>
        <Element Offset="232" Vartype="Float" Bytesize="4" OffsetHex="000000E8" DisplayMethod="unsigned integer"/>
        <Element Offset="236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000EC" DisplayMethod="hexadecimal"/>
        <Element Offset="240" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000F0" DisplayMethod="unsigned integer"/>
        <Element Offset="248" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000F8" DisplayMethod="unsigned integer"/>
        <Element Offset="260" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000104" DisplayMethod="unsigned integer"/>
        <Element Offset="264" Vartype="Pointer" Bytesize="8" OffsetHex="00000108" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="Float" Bytesize="4" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000110" DisplayMethod="hexadecimal"/>
        <Element Offset="312" Vartype="Pointer" Bytesize="8" OffsetHex="00000138" DisplayMethod="unsigned integer"/>
        <Element Offset="316" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000013C" DisplayMethod="hexadecimal"/>
        <Element Offset="320" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000140" DisplayMethod="unsigned integer"/>
        <Element Offset="328" Vartype="Float" Bytesize="4" OffsetHex="00000148" DisplayMethod="unsigned integer"/>
        <Element Offset="332" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="0000014C" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="Float" Bytesize="4" OffsetHex="0000015C" DisplayMethod="unsigned integer"/>
        <Element Offset="352" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000160" DisplayMethod="unsigned integer"/>
        <Element Offset="360" Vartype="Float" Bytesize="4" OffsetHex="00000168" DisplayMethod="unsigned integer"/>
        <Element Offset="364" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000016C" DisplayMethod="unsigned integer"/>
        <Element Offset="368" Vartype="Float" Bytesize="4" OffsetHex="00000170" DisplayMethod="unsigned integer"/>
        <Element Offset="372" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000174" DisplayMethod="unsigned integer"/>
        <Element Offset="380" Vartype="Double" Bytesize="8" OffsetHex="0000017C" DisplayMethod="unsigned integer"/>
        <Element Offset="388" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000184" DisplayMethod="unsigned integer"/>
        <Element Offset="392" Vartype="Float" Bytesize="4" OffsetHex="00000188" DisplayMethod="unsigned integer"/>
        <Element Offset="396" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000018C" DisplayMethod="unsigned integer"/>
        <Element Offset="416" Vartype="Pointer" Bytesize="8" OffsetHex="000001A0" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="Pointer" Bytesize="8" OffsetHex="000001A4" Description="Pointer to instance of Projectile" DisplayMethod="unsigned integer"/>
        <Element Offset="424" Vartype="Pointer" Bytesize="8" OffsetHex="000001A8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="428" Vartype="Pointer" Bytesize="8" OffsetHex="000001AC" DisplayMethod="unsigned integer"/>
        <Element Offset="432" Vartype="Pointer" Bytesize="8" OffsetHex="000001B0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="436" Vartype="Pointer" Bytesize="8" OffsetHex="000001B4" DisplayMethod="unsigned integer"/>
        <Element Offset="440" Vartype="Pointer" Bytesize="8" OffsetHex="000001B8" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="Pointer" Bytesize="8" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="448" Vartype="Pointer" Bytesize="8" OffsetHex="000001C0" DisplayMethod="unsigned integer"/>
        <Element Offset="452" Vartype="Pointer" Bytesize="8" OffsetHex="000001C4" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="Pointer" Bytesize="8" OffsetHex="000001C8" DisplayMethod="unsigned integer"/>
        <Element Offset="460" Vartype="Pointer" Bytesize="8" OffsetHex="000001CC" DisplayMethod="unsigned integer"/>
        <Element Offset="464" Vartype="Pointer" Bytesize="8" OffsetHex="000001D0" DisplayMethod="unsigned integer"/>
        <Element Offset="468" Vartype="Float" Bytesize="4" OffsetHex="000001D4" DisplayMethod="unsigned integer"/>
        <Element Offset="472" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="000001D8" DisplayMethod="unsigned integer"/>
        <Element Offset="508" Vartype="Pointer" Bytesize="8" OffsetHex="000001FC" DisplayMethod="unsigned integer"/>
        <Element Offset="512" Vartype="Pointer" Bytesize="8" OffsetHex="00000200" DisplayMethod="unsigned integer"/>
        <Element Offset="516" Vartype="Pointer" Bytesize="8" OffsetHex="00000204" DisplayMethod="unsigned integer"/>
        <Element Offset="520" Vartype="Pointer" Bytesize="8" OffsetHex="00000208" DisplayMethod="unsigned integer"/>
        <Element Offset="524" Vartype="Pointer" Bytesize="8" OffsetHex="0000020C" DisplayMethod="unsigned integer"/>
        <Element Offset="528" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000210" DisplayMethod="unsigned integer"/>
        <Element Offset="544" Vartype="Float" Bytesize="4" OffsetHex="00000220" DisplayMethod="unsigned integer"/>
        <Element Offset="548" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000224" DisplayMethod="unsigned integer"/>
        <Element Offset="572" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000023C" DisplayMethod="hexadecimal"/>
        <Element Offset="576" Vartype="Pointer" Bytesize="8" OffsetHex="00000240" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="580" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000244" DisplayMethod="unsigned integer"/>
        <Element Offset="584" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000248" DisplayMethod="hexadecimal"/>
        <Element Offset="624" Vartype="Pointer" Bytesize="8" OffsetHex="00000270" DisplayMethod="unsigned integer"/>
        <Element Offset="628" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000274" DisplayMethod="unsigned integer"/>
        <Element Offset="640" Vartype="Float" Bytesize="4" OffsetHex="00000280" DisplayMethod="unsigned integer"/>
        <Element Offset="644" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000284" DisplayMethod="unsigned integer"/>
        <Element Offset="660" Vartype="Float" Bytesize="4" OffsetHex="00000294" DisplayMethod="unsigned integer"/>
        <Element Offset="664" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000298" DisplayMethod="unsigned integer"/>
        <Element Offset="672" Vartype="Float" Bytesize="4" OffsetHex="000002A0" DisplayMethod="unsigned integer"/>
        <Element Offset="676" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002A4" DisplayMethod="unsigned integer"/>
        <Element Offset="680" Vartype="Float" Bytesize="4" OffsetHex="000002A8" DisplayMethod="unsigned integer"/>
        <Element Offset="684" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000002AC" DisplayMethod="unsigned integer"/>
        <Element Offset="692" Vartype="Double" Bytesize="8" OffsetHex="000002B4" DisplayMethod="unsigned integer"/>
        <Element Offset="700" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000002BC" DisplayMethod="unsigned integer"/>
        <Element Offset="708" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002C4" DisplayMethod="unsigned integer"/>
        <Element Offset="712" Vartype="Pointer" Bytesize="8" OffsetHex="000002C8" DisplayMethod="unsigned integer"/>
        <Element Offset="716" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000002CC" DisplayMethod="unsigned integer"/>
        <Element Offset="728" Vartype="Pointer" Bytesize="8" OffsetHex="000002D8" DisplayMethod="unsigned integer"/>
        <Element Offset="732" Vartype="Pointer" Bytesize="8" OffsetHex="000002DC" Description="Pointer to instance of FuzzleAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="736" Vartype="Pointer" Bytesize="8" OffsetHex="000002E0" Description="Pointer to instance of LegMotion" DisplayMethod="unsigned integer"/>
        <Element Offset="740" Vartype="Pointer" Bytesize="8" OffsetHex="000002E4" DisplayMethod="unsigned integer"/>
        <Element Offset="744" Vartype="Pointer" Bytesize="8" OffsetHex="000002E8" Description="Pointer to instance of Fuzzle" DisplayMethod="unsigned integer"/>
        <Element Offset="748" Vartype="Pointer" Bytesize="8" OffsetHex="000002EC" DisplayMethod="unsigned integer"/>
        <Element Offset="752" Vartype="Pointer" Bytesize="8" OffsetHex="000002F0" DisplayMethod="unsigned integer"/>
        <Element Offset="756" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002F4" DisplayMethod="unsigned integer"/>
        <Element Offset="760" Vartype="Pointer" Bytesize="8" OffsetHex="000002F8" DisplayMethod="unsigned integer"/>
        <Element Offset="764" Vartype="Pointer" Bytesize="8" OffsetHex="000002FC" DisplayMethod="unsigned integer"/>
        <Element Offset="768" Vartype="Pointer" Bytesize="8" OffsetHex="00000300" DisplayMethod="unsigned integer"/>
        <Element Offset="772" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000304" DisplayMethod="unsigned integer"/>
        <Element Offset="776" Vartype="Double" Bytesize="8" OffsetHex="00000308" DisplayMethod="unsigned integer"/>
        <Element Offset="784" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000310" DisplayMethod="unsigned integer"/>
        <Element Offset="792" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000318" DisplayMethod="unsigned integer"/>
        <Element Offset="794" Vartype="2 Bytes" Bytesize="2" OffsetHex="0000031A" DisplayMethod="unsigned integer"/>
        <Element Offset="796" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000031C" DisplayMethod="unsigned integer"/>
        <Element Offset="808" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000328" DisplayMethod="unsigned integer"/>
        <Element Offset="816" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000330" DisplayMethod="unsigned integer"/>
        <Element Offset="818" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000332" DisplayMethod="unsigned integer"/>
        <Element Offset="820" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000334" DisplayMethod="unsigned integer"/>
        <Element Offset="828" Vartype="Pointer" Bytesize="8" OffsetHex="0000033C" DisplayMethod="unsigned integer"/>
        <Element Offset="832" Vartype="Pointer" Bytesize="8" OffsetHex="00000340" DisplayMethod="unsigned integer"/>
        <Element Offset="836" Vartype="Pointer" Bytesize="8" OffsetHex="00000344" DisplayMethod="unsigned integer"/>
        <Element Offset="840" Vartype="Pointer" Bytesize="8" OffsetHex="00000348" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="844" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000034C" DisplayMethod="unsigned integer"/>
        <Element Offset="856" Vartype="Float" Bytesize="4" OffsetHex="00000358" DisplayMethod="unsigned integer"/>
        <Element Offset="860" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000035C" DisplayMethod="hexadecimal"/>
        <Element Offset="864" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000360" DisplayMethod="unsigned integer"/>
        <Element Offset="872" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000368" DisplayMethod="unsigned integer"/>
        <Element Offset="880" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000370" DisplayMethod="unsigned integer"/>
        <Element Offset="882" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000372" DisplayMethod="unsigned integer"/>
        <Element Offset="884" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000374" DisplayMethod="unsigned integer"/>
        <Element Offset="888" Vartype="Pointer" Bytesize="8" OffsetHex="00000378" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="892" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000037C" DisplayMethod="unsigned integer"/>
        <Element Offset="896" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000380" DisplayMethod="hexadecimal"/>
        <Element Offset="936" Vartype="Pointer" Bytesize="8" OffsetHex="000003A8" DisplayMethod="unsigned integer"/>
        <Element Offset="940" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000003AC" DisplayMethod="unsigned integer"/>
        <Element Offset="952" Vartype="Float" Bytesize="4" OffsetHex="000003B8" DisplayMethod="unsigned integer"/>
        <Element Offset="956" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000003BC" DisplayMethod="unsigned integer"/>
        <Element Offset="972" Vartype="Float" Bytesize="4" OffsetHex="000003CC" DisplayMethod="unsigned integer"/>
        <Element Offset="976" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003D0" DisplayMethod="unsigned integer"/>
        <Element Offset="984" Vartype="Float" Bytesize="4" OffsetHex="000003D8" DisplayMethod="unsigned integer"/>
        <Element Offset="988" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003DC" DisplayMethod="unsigned integer"/>
        <Element Offset="992" Vartype="Float" Bytesize="4" OffsetHex="000003E0" DisplayMethod="unsigned integer"/>
        <Element Offset="996" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1004" Vartype="Double" Bytesize="8" OffsetHex="000003EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1012" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1016" Vartype="Float" Bytesize="4" OffsetHex="000003F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1020" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000003FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1040" Vartype="Pointer" Bytesize="8" OffsetHex="00000410" DisplayMethod="unsigned integer"/>
        <Element Offset="1044" Vartype="Pointer" Bytesize="8" OffsetHex="00000414" Description="Pointer to instance of NullAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="1048" Vartype="Pointer" Bytesize="8" OffsetHex="00000418" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1052" Vartype="Pointer" Bytesize="8" OffsetHex="0000041C" DisplayMethod="unsigned integer"/>
        <Element Offset="1056" Vartype="Pointer" Bytesize="8" OffsetHex="00000420" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1060" Vartype="Pointer" Bytesize="8" OffsetHex="00000424" DisplayMethod="unsigned integer"/>
        <Element Offset="1064" Vartype="Pointer" Bytesize="8" OffsetHex="00000428" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="Pointer" Bytesize="8" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="Pointer" Bytesize="8" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1076" Vartype="Pointer" Bytesize="8" OffsetHex="00000434" DisplayMethod="unsigned integer"/>
        <Element Offset="1080" Vartype="Pointer" Bytesize="8" OffsetHex="00000438" DisplayMethod="unsigned integer"/>
        <Element Offset="1084" Vartype="Pointer" Bytesize="8" OffsetHex="0000043C" DisplayMethod="unsigned integer"/>
        <Element Offset="1088" Vartype="Pointer" Bytesize="8" OffsetHex="00000440" DisplayMethod="unsigned integer"/>
        <Element Offset="1092" Vartype="Float" Bytesize="4" OffsetHex="00000444" DisplayMethod="unsigned integer"/>
        <Element Offset="1096" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000448" DisplayMethod="unsigned integer"/>
        <Element Offset="1140" Vartype="Pointer" Bytesize="8" OffsetHex="00000474" DisplayMethod="unsigned integer"/>
        <Element Offset="1144" Vartype="Pointer" Bytesize="8" OffsetHex="00000478" DisplayMethod="unsigned integer"/>
        <Element Offset="1148" Vartype="Pointer" Bytesize="8" OffsetHex="0000047C" DisplayMethod="unsigned integer"/>
        <Element Offset="1152" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000480" DisplayMethod="unsigned integer"/>
        <Element Offset="1168" Vartype="Float" Bytesize="4" OffsetHex="00000490" DisplayMethod="unsigned integer"/>
        <Element Offset="1172" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="00000494" DisplayMethod="unsigned integer"/>
        <Element Offset="1200" Vartype="Pointer" Bytesize="8" OffsetHex="000004B0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1204" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1208" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="000004B8" DisplayMethod="hexadecimal"/>
        <Element Offset="1248" Vartype="4 Bytes" Bytesize="4" RLECount="66" OffsetHex="000004E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1512" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="000005E8" DisplayMethod="hexadecimal"/>
        <Element Offset="1544" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000608" DisplayMethod="unsigned integer"/>
        <Element Offset="1552" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000610" DisplayMethod="hexadecimal"/>
        <Element Offset="1560" Vartype="4 Bytes" Bytesize="4" RLECount="66" OffsetHex="00000618" DisplayMethod="unsigned integer"/>
        <Element Offset="1824" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000720" DisplayMethod="hexadecimal"/>
        <Element Offset="1856" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000740" DisplayMethod="unsigned integer"/>
        <Element Offset="1864" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000748" DisplayMethod="hexadecimal"/>
        <Element Offset="1872" Vartype="Pointer" Bytesize="8" OffsetHex="00000750" DisplayMethod="unsigned integer"/>
        <Element Offset="1876" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000754" DisplayMethod="hexadecimal"/>
        <Element Offset="1880" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000758" DisplayMethod="unsigned integer"/>
        <Element Offset="1888" Vartype="Float" Bytesize="4" OffsetHex="00000760" DisplayMethod="unsigned integer"/>
        <Element Offset="1892" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000764" DisplayMethod="unsigned integer"/>
        <Element Offset="1908" Vartype="Float" Bytesize="4" OffsetHex="00000774" DisplayMethod="unsigned integer"/>
        <Element Offset="1912" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000778" DisplayMethod="unsigned integer"/>
        <Element Offset="1920" Vartype="Float" Bytesize="4" OffsetHex="00000780" DisplayMethod="unsigned integer"/>
        <Element Offset="1924" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000784" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="Float" Bytesize="4" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1932" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000078C" DisplayMethod="unsigned integer"/>
        <Element Offset="1940" Vartype="Double" Bytesize="8" OffsetHex="00000794" DisplayMethod="unsigned integer"/>
        <Element Offset="1948" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000079C" DisplayMethod="unsigned integer"/>
        <Element Offset="1952" Vartype="Float" Bytesize="4" OffsetHex="000007A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1956" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000007A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1976" Vartype="Pointer" Bytesize="8" OffsetHex="000007B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1980" Vartype="Pointer" Bytesize="8" OffsetHex="000007BC" Description="Pointer to instance of Projectile" DisplayMethod="unsigned integer"/>
        <Element Offset="1984" Vartype="Pointer" Bytesize="8" OffsetHex="000007C0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1988" Vartype="Pointer" Bytesize="8" OffsetHex="000007C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1992" Vartype="Pointer" Bytesize="8" OffsetHex="000007C8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="1996" Vartype="Pointer" Bytesize="8" OffsetHex="000007CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2000" Vartype="Pointer" Bytesize="8" OffsetHex="000007D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2004" Vartype="Pointer" Bytesize="8" OffsetHex="000007D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2008" Vartype="Pointer" Bytesize="8" OffsetHex="000007D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2012" Vartype="Pointer" Bytesize="8" OffsetHex="000007DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="Pointer" Bytesize="8" OffsetHex="000007E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2020" Vartype="Pointer" Bytesize="8" OffsetHex="000007E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2024" Vartype="Pointer" Bytesize="8" OffsetHex="000007E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2028" Vartype="Float" Bytesize="4" OffsetHex="000007EC" DisplayMethod="unsigned integer"/>
        <Element Offset="2032" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="000007F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2068" Vartype="Pointer" Bytesize="8" OffsetHex="00000814" DisplayMethod="unsigned integer"/>
        <Element Offset="2072" Vartype="Pointer" Bytesize="8" OffsetHex="00000818" DisplayMethod="unsigned integer"/>
        <Element Offset="2076" Vartype="Pointer" Bytesize="8" OffsetHex="0000081C" DisplayMethod="unsigned integer"/>
        <Element Offset="2080" Vartype="Pointer" Bytesize="8" OffsetHex="00000820" DisplayMethod="unsigned integer"/>
        <Element Offset="2084" Vartype="Pointer" Bytesize="8" OffsetHex="00000824" DisplayMethod="unsigned integer"/>
        <Element Offset="2088" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000828" DisplayMethod="unsigned integer"/>
        <Element Offset="2104" Vartype="Float" Bytesize="4" OffsetHex="00000838" DisplayMethod="unsigned integer"/>
        <Element Offset="2108" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="0000083C" DisplayMethod="unsigned integer"/>
        <Element Offset="2132" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000854" DisplayMethod="hexadecimal"/>
        <Element Offset="2136" Vartype="Pointer" Bytesize="8" OffsetHex="00000858" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2140" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000085C" DisplayMethod="unsigned integer"/>
        <Element Offset="2144" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000860" DisplayMethod="hexadecimal"/>
        <Element Offset="2184" Vartype="Pointer" Bytesize="8" OffsetHex="00000888" DisplayMethod="unsigned integer"/>
        <Element Offset="2188" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000088C" DisplayMethod="unsigned integer"/>
        <Element Offset="2200" Vartype="Float" Bytesize="4" OffsetHex="00000898" DisplayMethod="unsigned integer"/>
        <Element Offset="2204" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="0000089C" DisplayMethod="unsigned integer"/>
        <Element Offset="2220" Vartype="Float" Bytesize="4" OffsetHex="000008AC" DisplayMethod="unsigned integer"/>
        <Element Offset="2224" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2232" Vartype="Float" Bytesize="4" OffsetHex="000008B8" DisplayMethod="unsigned integer"/>
        <Element Offset="2236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2240" Vartype="Float" Bytesize="4" OffsetHex="000008C0" DisplayMethod="unsigned integer"/>
        <Element Offset="2244" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2252" Vartype="Double" Bytesize="8" OffsetHex="000008CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2260" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000008D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2268" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2288" Vartype="Pointer" Bytesize="8" OffsetHex="000008F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2292" Vartype="Pointer" Bytesize="8" OffsetHex="000008F4" Description="Pointer to instance of Lever360Animation" DisplayMethod="unsigned integer"/>
        <Element Offset="2296" Vartype="Pointer" Bytesize="8" OffsetHex="000008F8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2300" Vartype="Pointer" Bytesize="8" OffsetHex="000008FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2304" Vartype="Pointer" Bytesize="8" OffsetHex="00000900" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2308" Vartype="Pointer" Bytesize="8" OffsetHex="00000904" DisplayMethod="unsigned integer"/>
        <Element Offset="2312" Vartype="Pointer" Bytesize="8" OffsetHex="00000908" DisplayMethod="unsigned integer"/>
        <Element Offset="2316" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000090C" DisplayMethod="unsigned integer"/>
        <Element Offset="2320" Vartype="Pointer" Bytesize="8" OffsetHex="00000910" DisplayMethod="unsigned integer"/>
        <Element Offset="2324" Vartype="Pointer" Bytesize="8" OffsetHex="00000914" DisplayMethod="unsigned integer"/>
        <Element Offset="2328" Vartype="Pointer" Bytesize="8" OffsetHex="00000918" DisplayMethod="unsigned integer"/>
        <Element Offset="2332" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000091C" DisplayMethod="unsigned integer"/>
        <Element Offset="2336" Vartype="Double" Bytesize="8" OffsetHex="00000920" DisplayMethod="unsigned integer"/>
        <Element Offset="2344" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000928" DisplayMethod="unsigned integer"/>
        <Element Offset="2388" Vartype="Pointer" Bytesize="8" OffsetHex="00000954" DisplayMethod="unsigned integer"/>
        <Element Offset="2392" Vartype="Pointer" Bytesize="8" OffsetHex="00000958" DisplayMethod="unsigned integer"/>
        <Element Offset="2396" Vartype="Pointer" Bytesize="8" OffsetHex="0000095C" DisplayMethod="unsigned integer"/>
        <Element Offset="2400" Vartype="Pointer" Bytesize="8" OffsetHex="00000960" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="2404" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000964" DisplayMethod="unsigned integer"/>
        <Element Offset="2416" Vartype="Float" Bytesize="4" OffsetHex="00000970" DisplayMethod="unsigned integer"/>
        <Element Offset="2420" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000974" DisplayMethod="unsigned integer"/>
        <Element Offset="2432" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000980" DisplayMethod="unsigned integer"/>
        <Element Offset="2444" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000098C" DisplayMethod="unsigned integer"/>
        <Element Offset="2448" Vartype="Pointer" Bytesize="8" OffsetHex="00000990" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2452" Vartype="Float" Bytesize="4" OffsetHex="00000994" DisplayMethod="unsigned integer"/>
        <Element Offset="2456" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000998" DisplayMethod="hexadecimal"/>
        <Element Offset="2492" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2496" Vartype="Pointer" Bytesize="8" OffsetHex="000009C0" DisplayMethod="unsigned integer"/>
        <Element Offset="2500" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000009C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2512" Vartype="Float" Bytesize="4" OffsetHex="000009D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2516" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000009D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2532" Vartype="Float" Bytesize="4" OffsetHex="000009E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2536" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2544" Vartype="Float" Bytesize="4" OffsetHex="000009F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2548" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2552" Vartype="Float" Bytesize="4" OffsetHex="000009F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2556" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2564" Vartype="Double" Bytesize="8" OffsetHex="00000A04" DisplayMethod="unsigned integer"/>
        <Element Offset="2572" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000A0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2580" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000A14" DisplayMethod="unsigned integer"/>
        <Element Offset="2600" Vartype="Pointer" Bytesize="8" OffsetHex="00000A28" DisplayMethod="unsigned integer"/>
        <Element Offset="2604" Vartype="Pointer" Bytesize="8" OffsetHex="00000A2C" Description="Pointer to instance of Lever360Animation" DisplayMethod="unsigned integer"/>
        <Element Offset="2608" Vartype="Pointer" Bytesize="8" OffsetHex="00000A30" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2612" Vartype="Pointer" Bytesize="8" OffsetHex="00000A34" DisplayMethod="unsigned integer"/>
        <Element Offset="2616" Vartype="Pointer" Bytesize="8" OffsetHex="00000A38" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2620" Vartype="Pointer" Bytesize="8" OffsetHex="00000A3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2624" Vartype="Pointer" Bytesize="8" OffsetHex="00000A40" DisplayMethod="unsigned integer"/>
        <Element Offset="2628" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A44" DisplayMethod="unsigned integer"/>
        <Element Offset="2632" Vartype="Pointer" Bytesize="8" OffsetHex="00000A48" DisplayMethod="unsigned integer"/>
        <Element Offset="2636" Vartype="Pointer" Bytesize="8" OffsetHex="00000A4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2640" Vartype="Pointer" Bytesize="8" OffsetHex="00000A50" DisplayMethod="unsigned integer"/>
        <Element Offset="2644" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A54" DisplayMethod="unsigned integer"/>
        <Element Offset="2648" Vartype="Double" Bytesize="8" OffsetHex="00000A58" DisplayMethod="unsigned integer"/>
        <Element Offset="2656" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000A60" DisplayMethod="unsigned integer"/>
        <Element Offset="2700" Vartype="Pointer" Bytesize="8" OffsetHex="00000A8C" DisplayMethod="unsigned integer"/>
        <Element Offset="2704" Vartype="Pointer" Bytesize="8" OffsetHex="00000A90" DisplayMethod="unsigned integer"/>
        <Element Offset="2708" Vartype="Pointer" Bytesize="8" OffsetHex="00000A94" DisplayMethod="unsigned integer"/>
        <Element Offset="2712" Vartype="Pointer" Bytesize="8" OffsetHex="00000A98" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="2716" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000A9C" DisplayMethod="unsigned integer"/>
        <Element Offset="2728" Vartype="Float" Bytesize="4" OffsetHex="00000AA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2732" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000AAC" DisplayMethod="unsigned integer"/>
        <Element Offset="2744" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000AB8" DisplayMethod="unsigned integer"/>
        <Element Offset="2756" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AC4" DisplayMethod="unsigned integer"/>
        <Element Offset="2760" Vartype="Pointer" Bytesize="8" OffsetHex="00000AC8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="2764" Vartype="Float" Bytesize="4" OffsetHex="00000ACC" DisplayMethod="unsigned integer"/>
        <Element Offset="2768" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000AD0" DisplayMethod="hexadecimal"/>
        <Element Offset="2808" Vartype="4 Bytes" Bytesize="4" RLECount="66" OffsetHex="00000AF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3072" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000C00" DisplayMethod="hexadecimal"/>
        <Element Offset="3104" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C20" DisplayMethod="unsigned integer"/>
        <Element Offset="3112" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C28" DisplayMethod="hexadecimal"/>
        <Element Offset="3120" Vartype="Pointer" Bytesize="8" OffsetHex="00000C30" DisplayMethod="unsigned integer"/>
        <Element Offset="3124" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C34" DisplayMethod="unsigned integer"/>
        <Element Offset="3136" Vartype="Float" Bytesize="4" OffsetHex="00000C40" DisplayMethod="unsigned integer"/>
        <Element Offset="3140" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000C44" DisplayMethod="unsigned integer"/>
        <Element Offset="3156" Vartype="Float" Bytesize="4" OffsetHex="00000C54" DisplayMethod="unsigned integer"/>
        <Element Offset="3160" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C58" DisplayMethod="unsigned integer"/>
        <Element Offset="3168" Vartype="Float" Bytesize="4" OffsetHex="00000C60" DisplayMethod="unsigned integer"/>
        <Element Offset="3172" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C64" DisplayMethod="unsigned integer"/>
        <Element Offset="3176" Vartype="Float" Bytesize="4" OffsetHex="00000C68" DisplayMethod="unsigned integer"/>
        <Element Offset="3180" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3188" Vartype="Double" Bytesize="8" OffsetHex="00000C74" DisplayMethod="unsigned integer"/>
        <Element Offset="3196" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3200" Vartype="Float" Bytesize="4" OffsetHex="00000C80" DisplayMethod="unsigned integer"/>
        <Element Offset="3204" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000C84" DisplayMethod="unsigned integer"/>
        <Element Offset="3224" Vartype="Pointer" Bytesize="8" OffsetHex="00000C98" DisplayMethod="unsigned integer"/>
        <Element Offset="3228" Vartype="Pointer" Bytesize="8" OffsetHex="00000C9C" Description="Pointer to instance of NullAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="3232" Vartype="Pointer" Bytesize="8" OffsetHex="00000CA0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3236" Vartype="Pointer" Bytesize="8" OffsetHex="00000CA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3240" Vartype="Pointer" Bytesize="8" OffsetHex="00000CA8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3244" Vartype="Pointer" Bytesize="8" OffsetHex="00000CAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3248" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3252" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3256" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3260" Vartype="Pointer" Bytesize="8" OffsetHex="00000CBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3264" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3268" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3272" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3276" Vartype="Float" Bytesize="4" OffsetHex="00000CCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3280" Vartype="4 Bytes" Bytesize="4" RLECount="11" OffsetHex="00000CD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3324" Vartype="Pointer" Bytesize="8" OffsetHex="00000CFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3328" Vartype="Pointer" Bytesize="8" OffsetHex="00000D00" DisplayMethod="unsigned integer"/>
        <Element Offset="3332" Vartype="Pointer" Bytesize="8" OffsetHex="00000D04" DisplayMethod="unsigned integer"/>
        <Element Offset="3336" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000D08" DisplayMethod="unsigned integer"/>
        <Element Offset="3352" Vartype="Float" Bytesize="4" OffsetHex="00000D18" DisplayMethod="unsigned integer"/>
        <Element Offset="3356" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="00000D1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3384" Vartype="Pointer" Bytesize="8" OffsetHex="00000D38" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3388" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3392" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000D40" DisplayMethod="hexadecimal"/>
        <Element Offset="3432" Vartype="Pointer" Bytesize="8" OffsetHex="00000D68" DisplayMethod="unsigned integer"/>
        <Element Offset="3436" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D6C" DisplayMethod="hexadecimal"/>
        <Element Offset="3440" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D70" DisplayMethod="unsigned integer"/>
        <Element Offset="3448" Vartype="Float" Bytesize="4" OffsetHex="00000D78" DisplayMethod="unsigned integer"/>
        <Element Offset="3452" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000D7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3468" Vartype="Float" Bytesize="4" OffsetHex="00000D8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3472" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D90" DisplayMethod="unsigned integer"/>
        <Element Offset="3480" Vartype="Float" Bytesize="4" OffsetHex="00000D98" DisplayMethod="unsigned integer"/>
        <Element Offset="3484" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3488" Vartype="Float" Bytesize="4" OffsetHex="00000DA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3492" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3500" Vartype="Double" Bytesize="8" OffsetHex="00000DAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3508" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3512" Vartype="Float" Bytesize="4" OffsetHex="00000DB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3516" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000DBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3536" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3540" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD4" Description="Pointer to instance of Projectile" DisplayMethod="unsigned integer"/>
        <Element Offset="3544" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3548" Vartype="Pointer" Bytesize="8" OffsetHex="00000DDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3552" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE0" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3556" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3560" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3564" Vartype="Pointer" Bytesize="8" OffsetHex="00000DEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3568" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3572" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3576" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3580" Vartype="Pointer" Bytesize="8" OffsetHex="00000DFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3584" Vartype="Pointer" Bytesize="8" OffsetHex="00000E00" DisplayMethod="unsigned integer"/>
        <Element Offset="3588" Vartype="Float" Bytesize="4" OffsetHex="00000E04" DisplayMethod="unsigned integer"/>
        <Element Offset="3592" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000E08" DisplayMethod="unsigned integer"/>
        <Element Offset="3628" Vartype="Pointer" Bytesize="8" OffsetHex="00000E2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3632" Vartype="Pointer" Bytesize="8" OffsetHex="00000E30" DisplayMethod="unsigned integer"/>
        <Element Offset="3636" Vartype="Pointer" Bytesize="8" OffsetHex="00000E34" DisplayMethod="unsigned integer"/>
        <Element Offset="3640" Vartype="Pointer" Bytesize="8" OffsetHex="00000E38" DisplayMethod="unsigned integer"/>
        <Element Offset="3644" Vartype="Pointer" Bytesize="8" OffsetHex="00000E3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3648" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000E40" DisplayMethod="unsigned integer"/>
        <Element Offset="3664" Vartype="Float" Bytesize="4" OffsetHex="00000E50" DisplayMethod="unsigned integer"/>
        <Element Offset="3668" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000E54" DisplayMethod="unsigned integer"/>
        <Element Offset="3692" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E6C" DisplayMethod="hexadecimal"/>
        <Element Offset="3696" Vartype="Pointer" Bytesize="8" OffsetHex="00000E70" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="3700" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E74" DisplayMethod="unsigned integer"/>
        <Element Offset="3704" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000E78" DisplayMethod="hexadecimal"/>
        <Element Offset="3744" Vartype="Pointer" Bytesize="8" OffsetHex="00000EA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3748" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3760" Vartype="Float" Bytesize="4" OffsetHex="00000EB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3764" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000EB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3780" Vartype="Float" Bytesize="4" OffsetHex="00000EC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3784" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3792" Vartype="Float" Bytesize="4" OffsetHex="00000ED0" DisplayMethod="unsigned integer"/>
        <Element Offset="3796" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000ED4" DisplayMethod="unsigned integer"/>
        <Element Offset="3800" Vartype="Float" Bytesize="4" OffsetHex="00000ED8" DisplayMethod="unsigned integer"/>
        <Element Offset="3804" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3812" Vartype="Double" Bytesize="8" OffsetHex="00000EE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3820" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000EEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3828" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000EF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3832" Vartype="Pointer" Bytesize="8" OffsetHex="00000EF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3836" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3848" Vartype="Pointer" Bytesize="8" OffsetHex="00000F08" DisplayMethod="unsigned integer"/>
        <Element Offset="3852" Vartype="Pointer" Bytesize="8" OffsetHex="00000F0C" Description="Pointer to instance of InternAnimation" DisplayMethod="unsigned integer"/>
        <Element Offset="3856" Vartype="Pointer" Bytesize="8" OffsetHex="00000F10" Description="Pointer to instance of LegMotion" DisplayMethod="unsigned integer"/>
        <Element Offset="3860" Vartype="Pointer" Bytesize="8" OffsetHex="00000F14" DisplayMethod="unsigned integer"/>
        <Element Offset="3864" Vartype="Pointer" Bytesize="8" OffsetHex="00000F18" Description="Pointer to instance of Intern" DisplayMethod="unsigned integer"/>
        <Element Offset="3868" Vartype="Pointer" Bytesize="8" OffsetHex="00000F1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3872" Vartype="Pointer" Bytesize="8" OffsetHex="00000F20" DisplayMethod="unsigned integer"/>
        <Element Offset="3876" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F24" DisplayMethod="unsigned integer"/>
        <Element Offset="3880" Vartype="Pointer" Bytesize="8" OffsetHex="00000F28" DisplayMethod="unsigned integer"/>
        <Element Offset="3884" Vartype="Pointer" Bytesize="8" OffsetHex="00000F2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3888" Vartype="Pointer" Bytesize="8" OffsetHex="00000F30" DisplayMethod="unsigned integer"/>
        <Element Offset="3892" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F34" DisplayMethod="unsigned integer"/>
        <Element Offset="3896" Vartype="Double" Bytesize="8" OffsetHex="00000F38" DisplayMethod="unsigned integer"/>
        <Element Offset="3904" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F40" DisplayMethod="unsigned integer"/>
        <Element Offset="3916" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3928" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F58" DisplayMethod="unsigned integer"/>
        <Element Offset="3940" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F64" DisplayMethod="unsigned integer"/>
        <Element Offset="3948" Vartype="Pointer" Bytesize="8" OffsetHex="00000F6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3952" Vartype="Pointer" Bytesize="8" OffsetHex="00000F70" DisplayMethod="unsigned integer"/>
        <Element Offset="3956" Vartype="Pointer" Bytesize="8" OffsetHex="00000F74" DisplayMethod="unsigned integer"/>
        <Element Offset="3960" Vartype="Pointer" Bytesize="8" OffsetHex="00000F78" Description="Pointer to instance of OwActorNode" DisplayMethod="unsigned integer"/>
        <Element Offset="3964" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3976" Vartype="Float" Bytesize="4" OffsetHex="00000F88" DisplayMethod="unsigned integer"/>
        <Element Offset="3980" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F8C" DisplayMethod="hexadecimal"/>
        <Element Offset="3984" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F90" DisplayMethod="unsigned integer"/>
        <Element Offset="3992" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000F98" DisplayMethod="unsigned integer"/>
        <Element Offset="4004" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FA4" DisplayMethod="unsigned integer"/>
        <Element Offset="4008" Vartype="Pointer" Bytesize="8" OffsetHex="00000FA8" Description="Pointer to instance of Actor" DisplayMethod="unsigned integer"/>
        <Element Offset="4012" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FAC" DisplayMethod="unsigned integer"/>
        <Element Offset="4016" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000FB0" DisplayMethod="hexadecimal"/>
        <Element Offset="4056" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000FD8" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
  </Structures>
  <Comments>Version: GOG, 2.0.0.3
Spooce:  Float, same value as seen when you collect some or press the left or right on the dpad
HP:      Float, max 1100, address close to spooce, code shared with enemies
Bounce:  Float, base value 42, increases to 72 
Zap:     4 bytes, 1 if available, 0 if not
</Comments>
</CheatTable>
