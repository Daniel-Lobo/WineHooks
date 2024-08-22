<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>16</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>24</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
/* Enemy attacks*/
sr2.exe+153CB:
nop, 5

/* Health drain */
sr2.exe+1CEFB:
nop, 6

[disable]
/* Health drain */
sr2.exe+1CEFB:
mov [sr2.exe+1808D0],ecx

/* Enemy attacks*/
sr2.exe+153CB:
mov [sr2.exe+1808D0],eax





</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>18</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(newmem, 1024)
alloc(newmem2, 1024)
label(return_point)
label(return_point2)

newmem:
push [esi+28]
mov [esi+28], (float)1000.0
fmul dword ptr [esi+28]
fmul dword ptr [004E34c8]
pop [esi+28]
jmp return_point

/* Max rever damage: unecessary. The 2nd cheat works for
 * all weapons */

/*
004C1dc3:
jmp newmem
nop
nop
nop
nop
*/
return_point:

newmem2:
mov [esi+000001FC],64
jmp return_point2

0042CA41:
jmp newmem2
nop
return_point2:

[disable]
004C1dc3:
fmul dword ptr [esi+28]
fmul dword ptr [004E34c8]
dealloc(newmem)

0042CA41:
mov [esi+000001FC],eax
dealloc(newmem2)






</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>23</ID>
      <Description>"M - shift to Material anywhere"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(shift_anywhere, 512)
label(shift_anywhere_ret_point)

shift_anywhere:
  mov [sr2.exe+1808E0],eax
  or [sr2.exe+1808E0],40
jmp shift_anywhere_ret_point

sr2.exe+1E9C5:
  jmp shift_anywhere
shift_anywhere_ret_point:

[disable]
sr2.exe+1E9C5:
mov [sr2.exe+1808E0],eax
dealloc(shift_anywhere)


</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>25</ID>
      <Description>"R - Reaver doesn't drain HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
sr2.exe+1B221:
nop, 6

[disable]
sr2.exe+1B221:
mov [sr2.exe+1808D0], ecx







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>26</ID>
      <Description>"1 to 6 - Change reaver"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>14</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>3</ID>
          <Description>"Health"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>sr2.exe+1808D0</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>13</ID>
          <Description>"Health Lvl"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>005808CC</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>11</ID>
          <Description>"Reaver base adress"</Description>
          <ShowAsHex>1</ShowAsHex>
          <VariableType>4 Bytes</VariableType>
          <Address>sr2.exe+303918</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>12</ID>
          <Description>"Reaver Bar"</Description>
          <VariableType>Float</VariableType>
          <Address>703918</Address>
          <Offsets>
            <Offset>28</Offset>
          </Offsets>
        </CheatEntry>
        <CheatEntry>
          <ID>8</ID>
          <Description>"I - Instant Reaver Cooldown"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
alloc(newmem, 1024)
label(return_point)

newmem:
mov [esi+28], (float)0.0
fcomp dword ptr [004E32A4]
jmp return_point


004C1BB7:
jmp newmem
nop
nop
nop
nop
return_point:



[disable]
004C1BB7:
fst dword ptr [esi+28]
fcomp dword ptr [004E32A4]
dealloc(newmem)


</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Structures StructVersion="2">
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Float" Bytesize="4" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="4" Vartype="Pointer" Bytesize="8" OffsetHex="00000004" DisplayMethod="unsigned integer"/>
        <Element Offset="8" Vartype="Float" Bytesize="4" OffsetHex="00000008" DisplayMethod="unsigned integer"/>
        <Element Offset="12" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000000C" DisplayMethod="unsigned integer"/>
        <Element Offset="20" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000014" DisplayMethod="hexadecimal"/>
        <Element Offset="28" Vartype="Float" Bytesize="4" RLECount="5" OffsetHex="0000001C" DisplayMethod="unsigned integer"/>
        <Element Offset="48" Vartype="Double" Bytesize="8" OffsetHex="00000030" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="Float" Bytesize="4" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="60" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000003C" DisplayMethod="unsigned integer"/>
        <Element Offset="72" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000048" DisplayMethod="hexadecimal"/>
        <Element Offset="84" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000054" DisplayMethod="unsigned integer"/>
        <Element Offset="92" Vartype="Double" Bytesize="8" OffsetHex="0000005C" DisplayMethod="unsigned integer"/>
        <Element Offset="100" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000064" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000006C" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000070" DisplayMethod="unsigned integer"/>
        <Element Offset="124" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000007C" DisplayMethod="unsigned integer"/>
        <Element Offset="128" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000080" DisplayMethod="unsigned integer"/>
        <Element Offset="140" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000008C" DisplayMethod="unsigned integer"/>
        <Element Offset="144" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000090" DisplayMethod="unsigned integer"/>
        <Element Offset="160" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000000A0" DisplayMethod="unsigned integer"/>
        <Element Offset="164" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000000A4" DisplayMethod="unsigned integer"/>
        <Element Offset="172" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000AC" DisplayMethod="unsigned integer"/>
        <Element Offset="176" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000B0" DisplayMethod="unsigned integer"/>
        <Element Offset="188" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000BC" DisplayMethod="unsigned integer"/>
        <Element Offset="192" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000C0" DisplayMethod="unsigned integer"/>
        <Element Offset="204" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000CC" DisplayMethod="unsigned integer"/>
        <Element Offset="208" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="000000D0" DisplayMethod="unsigned integer"/>
        <Element Offset="224" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000000E0" DisplayMethod="unsigned integer"/>
        <Element Offset="228" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000000E4" DisplayMethod="unsigned integer"/>
        <Element Offset="236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000EC" DisplayMethod="unsigned integer"/>
        <Element Offset="240" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000000F0" DisplayMethod="unsigned integer"/>
        <Element Offset="252" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000FC" DisplayMethod="unsigned integer"/>
        <Element Offset="256" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000100" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000110" DisplayMethod="unsigned integer"/>
        <Element Offset="288" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000120" DisplayMethod="unsigned integer"/>
        <Element Offset="292" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000124" DisplayMethod="unsigned integer"/>
        <Element Offset="300" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000012C" DisplayMethod="unsigned integer"/>
        <Element Offset="304" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000130" DisplayMethod="unsigned integer"/>
        <Element Offset="316" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000013C" DisplayMethod="unsigned integer"/>
        <Element Offset="320" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000140" DisplayMethod="unsigned integer"/>
        <Element Offset="332" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000014C" DisplayMethod="unsigned integer"/>
        <Element Offset="336" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000150" DisplayMethod="unsigned integer"/>
        <Element Offset="352" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000160" DisplayMethod="unsigned integer"/>
        <Element Offset="356" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000164" DisplayMethod="unsigned integer"/>
        <Element Offset="364" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000016C" DisplayMethod="unsigned integer"/>
        <Element Offset="368" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000170" DisplayMethod="unsigned integer"/>
        <Element Offset="380" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000017C" DisplayMethod="unsigned integer"/>
        <Element Offset="384" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000180" DisplayMethod="unsigned integer"/>
        <Element Offset="396" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000018C" DisplayMethod="unsigned integer"/>
        <Element Offset="400" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000190" DisplayMethod="unsigned integer"/>
        <Element Offset="416" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000001A0" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000001A4" DisplayMethod="unsigned integer"/>
        <Element Offset="428" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001AC" DisplayMethod="unsigned integer"/>
        <Element Offset="432" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000001B0" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="448" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000001C0" DisplayMethod="unsigned integer"/>
        <Element Offset="460" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001CC" DisplayMethod="unsigned integer"/>
        <Element Offset="464" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="000001D0" DisplayMethod="unsigned integer"/>
        <Element Offset="480" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000001E0" DisplayMethod="unsigned integer"/>
        <Element Offset="484" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000001E4" DisplayMethod="unsigned integer"/>
        <Element Offset="492" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001EC" DisplayMethod="unsigned integer"/>
        <Element Offset="496" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000001F0" DisplayMethod="unsigned integer"/>
        <Element Offset="508" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001FC" DisplayMethod="unsigned integer"/>
        <Element Offset="512" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000200" DisplayMethod="unsigned integer"/>
        <Element Offset="524" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000020C" DisplayMethod="unsigned integer"/>
        <Element Offset="528" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000210" DisplayMethod="unsigned integer"/>
        <Element Offset="544" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000220" DisplayMethod="unsigned integer"/>
        <Element Offset="548" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000224" DisplayMethod="unsigned integer"/>
        <Element Offset="556" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000022C" DisplayMethod="unsigned integer"/>
        <Element Offset="560" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000230" DisplayMethod="unsigned integer"/>
        <Element Offset="572" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000023C" DisplayMethod="unsigned integer"/>
        <Element Offset="576" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000240" DisplayMethod="unsigned integer"/>
        <Element Offset="588" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000024C" DisplayMethod="unsigned integer"/>
        <Element Offset="592" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000250" DisplayMethod="unsigned integer"/>
        <Element Offset="608" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000260" DisplayMethod="unsigned integer"/>
        <Element Offset="612" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000264" DisplayMethod="unsigned integer"/>
        <Element Offset="620" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000026C" DisplayMethod="unsigned integer"/>
        <Element Offset="624" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000270" DisplayMethod="unsigned integer"/>
        <Element Offset="636" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000027C" DisplayMethod="unsigned integer"/>
        <Element Offset="640" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000280" DisplayMethod="unsigned integer"/>
        <Element Offset="652" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000028C" DisplayMethod="unsigned integer"/>
        <Element Offset="656" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000290" DisplayMethod="unsigned integer"/>
        <Element Offset="672" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000002A0" DisplayMethod="unsigned integer"/>
        <Element Offset="676" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000002A4" DisplayMethod="unsigned integer"/>
        <Element Offset="684" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002AC" DisplayMethod="unsigned integer"/>
        <Element Offset="688" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000002B0" DisplayMethod="unsigned integer"/>
        <Element Offset="700" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002BC" DisplayMethod="unsigned integer"/>
        <Element Offset="704" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000002C0" DisplayMethod="unsigned integer"/>
        <Element Offset="716" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002CC" DisplayMethod="unsigned integer"/>
        <Element Offset="720" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="000002D0" DisplayMethod="unsigned integer"/>
        <Element Offset="748" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002EC" DisplayMethod="hexadecimal"/>
        <Element Offset="752" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000002F0" DisplayMethod="unsigned integer"/>
        <Element Offset="764" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002FC" DisplayMethod="hexadecimal"/>
        <Element Offset="768" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000300" DisplayMethod="unsigned integer"/>
        <Element Offset="780" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000030C" DisplayMethod="hexadecimal"/>
        <Element Offset="784" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000310" DisplayMethod="unsigned integer"/>
        <Element Offset="796" Vartype="Double" Bytesize="8" OffsetHex="0000031C" DisplayMethod="unsigned integer"/>
        <Element Offset="804" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000324" DisplayMethod="unsigned integer"/>
        <Element Offset="812" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000032C" DisplayMethod="unsigned integer"/>
        <Element Offset="816" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000330" DisplayMethod="unsigned integer"/>
        <Element Offset="828" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000033C" DisplayMethod="unsigned integer"/>
        <Element Offset="832" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000340" DisplayMethod="unsigned integer"/>
        <Element Offset="844" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000034C" DisplayMethod="unsigned integer"/>
        <Element Offset="848" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000350" DisplayMethod="unsigned integer"/>
        <Element Offset="876" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000036C" DisplayMethod="unsigned integer"/>
        <Element Offset="880" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000370" DisplayMethod="unsigned integer"/>
        <Element Offset="892" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000037C" DisplayMethod="unsigned integer"/>
        <Element Offset="896" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000380" DisplayMethod="unsigned integer"/>
        <Element Offset="908" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000038C" DisplayMethod="unsigned integer"/>
        <Element Offset="912" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000390" DisplayMethod="unsigned integer"/>
        <Element Offset="940" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003AC" DisplayMethod="unsigned integer"/>
        <Element Offset="944" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000003B0" DisplayMethod="unsigned integer"/>
        <Element Offset="956" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003BC" DisplayMethod="unsigned integer"/>
        <Element Offset="960" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000003C0" DisplayMethod="unsigned integer"/>
        <Element Offset="972" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003CC" DisplayMethod="unsigned integer"/>
        <Element Offset="976" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="000003D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1004" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1008" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000003F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1020" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1024" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000400" DisplayMethod="unsigned integer"/>
        <Element Offset="1036" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000040C" DisplayMethod="unsigned integer"/>
        <Element Offset="1040" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000410" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1084" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000043C" DisplayMethod="unsigned integer"/>
        <Element Offset="1088" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000440" DisplayMethod="unsigned integer"/>
        <Element Offset="1100" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000044C" DisplayMethod="unsigned integer"/>
        <Element Offset="1104" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000450" DisplayMethod="unsigned integer"/>
        <Element Offset="1132" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000046C" DisplayMethod="unsigned integer"/>
        <Element Offset="1136" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000470" DisplayMethod="unsigned integer"/>
        <Element Offset="1148" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000047C" DisplayMethod="unsigned integer"/>
        <Element Offset="1152" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000480" DisplayMethod="unsigned integer"/>
        <Element Offset="1164" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000048C" DisplayMethod="unsigned integer"/>
        <Element Offset="1168" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000490" DisplayMethod="unsigned integer"/>
        <Element Offset="1196" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1200" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000004B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1212" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1216" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000004C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1228" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1232" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="000004D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1260" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1264" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000004F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1276" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1280" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000500" DisplayMethod="unsigned integer"/>
        <Element Offset="1292" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000050C" DisplayMethod="unsigned integer"/>
        <Element Offset="1296" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000510" DisplayMethod="unsigned integer"/>
        <Element Offset="1324" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000052C" DisplayMethod="unsigned integer"/>
        <Element Offset="1328" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000530" DisplayMethod="unsigned integer"/>
        <Element Offset="1340" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000053C" DisplayMethod="unsigned integer"/>
        <Element Offset="1344" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000540" DisplayMethod="unsigned integer"/>
        <Element Offset="1356" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000054C" DisplayMethod="unsigned integer"/>
        <Element Offset="1360" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000550" DisplayMethod="unsigned integer"/>
        <Element Offset="1376" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000560" DisplayMethod="hexadecimal"/>
        <Element Offset="1380" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000564" DisplayMethod="unsigned integer"/>
        <Element Offset="1392" Vartype="Pointer" Bytesize="8" OffsetHex="00000570" DisplayMethod="unsigned integer"/>
        <Element Offset="1396" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000574" DisplayMethod="unsigned integer"/>
        <Element Offset="1404" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000057C" DisplayMethod="hexadecimal"/>
        <Element Offset="1408" Vartype="4 Bytes" Bytesize="4" RLECount="28" OffsetHex="00000580" DisplayMethod="unsigned integer"/>
        <Element Offset="1520" Vartype="Pointer" Bytesize="8" OffsetHex="000005F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1524" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000005F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1544" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000608" DisplayMethod="hexadecimal"/>
        <Element Offset="1548" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000060C" DisplayMethod="unsigned integer"/>
        <Element Offset="1552" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000610" DisplayMethod="hexadecimal"/>
        <Element Offset="1556" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000614" DisplayMethod="unsigned integer"/>
        <Element Offset="1564" Vartype="Double" Bytesize="8" OffsetHex="0000061C" DisplayMethod="unsigned integer"/>
        <Element Offset="1572" Vartype="Float" Bytesize="4" OffsetHex="00000624" DisplayMethod="unsigned integer"/>
        <Element Offset="1576" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000628" DisplayMethod="unsigned integer"/>
        <Element Offset="1580" Vartype="Double" Bytesize="8" OffsetHex="0000062C" DisplayMethod="unsigned integer"/>
        <Element Offset="1588" Vartype="Float" Bytesize="4" OffsetHex="00000634" DisplayMethod="unsigned integer"/>
        <Element Offset="1592" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000638" DisplayMethod="unsigned integer"/>
        <Element Offset="1604" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000644" DisplayMethod="unsigned integer"/>
        <Element Offset="1612" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000064C" DisplayMethod="unsigned integer"/>
        <Element Offset="1616" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000650" DisplayMethod="unsigned integer"/>
        <Element Offset="1640" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000668" DisplayMethod="unsigned integer"/>
        <Element Offset="1644" Vartype="Double" Bytesize="8" OffsetHex="0000066C" DisplayMethod="unsigned integer"/>
        <Element Offset="1652" Vartype="Float" Bytesize="4" OffsetHex="00000674" DisplayMethod="unsigned integer"/>
        <Element Offset="1656" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000678" DisplayMethod="unsigned integer"/>
        <Element Offset="1668" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000684" DisplayMethod="unsigned integer"/>
        <Element Offset="1676" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000068C" DisplayMethod="unsigned integer"/>
        <Element Offset="1680" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000690" DisplayMethod="unsigned integer"/>
        <Element Offset="1696" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006A0" DisplayMethod="hexadecimal"/>
        <Element Offset="1700" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000006A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1712" Vartype="Pointer" Bytesize="8" OffsetHex="000006B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1716" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000006B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1728" Vartype="Pointer" Bytesize="8" OffsetHex="000006C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1732" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000006C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1744" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006D0" DisplayMethod="hexadecimal"/>
        <Element Offset="1748" Vartype="Pointer" Bytesize="8" OffsetHex="000006D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1752" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006D8" DisplayMethod="hexadecimal"/>
        <Element Offset="1756" Vartype="Pointer" Bytesize="8" OffsetHex="000006DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1760" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006E0" DisplayMethod="hexadecimal"/>
        <Element Offset="1764" Vartype="Pointer" Bytesize="8" OffsetHex="000006E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1768" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006E8" DisplayMethod="hexadecimal"/>
        <Element Offset="1772" Vartype="Pointer" Bytesize="8" OffsetHex="000006EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1776" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006F0" DisplayMethod="hexadecimal"/>
        <Element Offset="1780" Vartype="Pointer" Bytesize="8" OffsetHex="000006F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1784" Vartype="Pointer" Bytesize="8" OffsetHex="000006F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1788" Vartype="Pointer" Bytesize="8" OffsetHex="000006FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1792" Vartype="Pointer" Bytesize="8" OffsetHex="00000700" DisplayMethod="unsigned integer"/>
        <Element Offset="1796" Vartype="Pointer" Bytesize="8" OffsetHex="00000704" DisplayMethod="unsigned integer"/>
        <Element Offset="1800" Vartype="Pointer" Bytesize="8" OffsetHex="00000708" DisplayMethod="unsigned integer"/>
        <Element Offset="1804" Vartype="Pointer" Bytesize="8" OffsetHex="0000070C" DisplayMethod="unsigned integer"/>
        <Element Offset="1808" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000710" DisplayMethod="hexadecimal"/>
        <Element Offset="1812" Vartype="Pointer" Bytesize="8" OffsetHex="00000714" DisplayMethod="unsigned integer"/>
        <Element Offset="1816" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000718" DisplayMethod="hexadecimal"/>
        <Element Offset="1820" Vartype="Pointer" Bytesize="8" OffsetHex="0000071C" DisplayMethod="unsigned integer"/>
        <Element Offset="1824" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000720" DisplayMethod="hexadecimal"/>
        <Element Offset="1828" Vartype="Pointer" Bytesize="8" OffsetHex="00000724" DisplayMethod="unsigned integer"/>
        <Element Offset="1832" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000728" DisplayMethod="unsigned integer"/>
        <Element Offset="1840" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000730" DisplayMethod="hexadecimal"/>
        <Element Offset="1844" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000734" DisplayMethod="unsigned integer"/>
        <Element Offset="1856" Vartype="String" Bytesize="5" OffsetHex="00000740" DisplayMethod="unsigned integer"/>
        <Element Offset="1861" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000745" DisplayMethod="unsigned integer"/>
        <Element Offset="1863" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000747" DisplayMethod="unsigned integer"/>
        <Element Offset="1865" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000749" DisplayMethod="unsigned integer"/>
        <Element Offset="1868" Vartype="Pointer" Bytesize="8" OffsetHex="0000074C" DisplayMethod="unsigned integer"/>
        <Element Offset="1872" Vartype="Pointer" Bytesize="8" OffsetHex="00000750" DisplayMethod="unsigned integer"/>
        <Element Offset="1876" Vartype="Unicode String" Bytesize="10" OffsetHex="00000754" DisplayMethod="unsigned integer"/>
        <Element Offset="1886" Vartype="Unicode String" Bytesize="5" OffsetHex="0000075E" DisplayMethod="unsigned integer"/>
        <Element Offset="1891" Vartype="Byte" Bytesize="1" OffsetHex="00000763" DisplayMethod="unsigned integer"/>
        <Element Offset="1892" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000764" DisplayMethod="unsigned integer"/>
        <Element Offset="1904" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000770" DisplayMethod="hexadecimal"/>
        <Element Offset="1908" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000774" DisplayMethod="unsigned integer"/>
        <Element Offset="1920" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000780" DisplayMethod="hexadecimal"/>
        <Element Offset="1924" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000784" DisplayMethod="unsigned integer"/>
        <Element Offset="1932" Vartype="Pointer" Bytesize="8" OffsetHex="0000078C" DisplayMethod="unsigned integer"/>
        <Element Offset="1936" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000790" DisplayMethod="unsigned integer"/>
        <Element Offset="1940" Vartype="Pointer" Bytesize="8" OffsetHex="00000794" DisplayMethod="unsigned integer"/>
        <Element Offset="1944" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000798" DisplayMethod="unsigned integer"/>
        <Element Offset="1948" Vartype="Pointer" Bytesize="8" OffsetHex="0000079C" DisplayMethod="unsigned integer"/>
        <Element Offset="1952" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007A0" DisplayMethod="hexadecimal"/>
        <Element Offset="1956" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000007A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1964" Vartype="Pointer" Bytesize="8" OffsetHex="000007AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1968" Vartype="Pointer" Bytesize="8" OffsetHex="000007B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1972" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000007B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1984" Vartype="Pointer" Bytesize="8" OffsetHex="000007C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1988" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000007C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2000" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007D0" DisplayMethod="hexadecimal"/>
        <Element Offset="2004" Vartype="Pointer" Bytesize="8" OffsetHex="000007D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2008" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007D8" DisplayMethod="hexadecimal"/>
        <Element Offset="2012" Vartype="Pointer" Bytesize="8" OffsetHex="000007DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007E0" DisplayMethod="hexadecimal"/>
        <Element Offset="2020" Vartype="Pointer" Bytesize="8" OffsetHex="000007E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2024" Vartype="Pointer" Bytesize="8" OffsetHex="000007E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2028" Vartype="Pointer" Bytesize="8" OffsetHex="000007EC" DisplayMethod="unsigned integer"/>
        <Element Offset="2032" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007F0" DisplayMethod="hexadecimal"/>
        <Element Offset="2036" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000007F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2044" Vartype="Pointer" Bytesize="8" OffsetHex="000007FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2048" Vartype="String" Bytesize="5" OffsetHex="00000800" DisplayMethod="unsigned integer"/>
        <Element Offset="2053" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000805" DisplayMethod="unsigned integer"/>
        <Element Offset="2056" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000808" DisplayMethod="hexadecimal"/>
        <Element Offset="2060" Vartype="Pointer" Bytesize="8" OffsetHex="0000080C" DisplayMethod="unsigned integer"/>
        <Element Offset="2064" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000810" DisplayMethod="unsigned integer"/>
        <Element Offset="2068" Vartype="Unicode String" Bytesize="14" OffsetHex="00000814" DisplayMethod="unsigned integer"/>
        <Element Offset="2082" Vartype="Unicode String" Bytesize="7" OffsetHex="00000822" DisplayMethod="unsigned integer"/>
        <Element Offset="2089" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000829" DisplayMethod="unsigned integer"/>
        <Element Offset="2092" Vartype="Pointer" Bytesize="8" OffsetHex="0000082C" DisplayMethod="unsigned integer"/>
        <Element Offset="2096" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000830" DisplayMethod="hexadecimal"/>
        <Element Offset="2100" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000834" DisplayMethod="unsigned integer"/>
        <Element Offset="2108" Vartype="Pointer" Bytesize="8" OffsetHex="0000083C" DisplayMethod="unsigned integer"/>
        <Element Offset="2112" Vartype="String" Bytesize="5" OffsetHex="00000840" DisplayMethod="unsigned integer"/>
        <Element Offset="2117" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000845" DisplayMethod="unsigned integer"/>
        <Element Offset="2120" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000848" DisplayMethod="hexadecimal"/>
        <Element Offset="2124" Vartype="Pointer" Bytesize="8" OffsetHex="0000084C" DisplayMethod="unsigned integer"/>
        <Element Offset="2128" Vartype="Pointer" Bytesize="8" OffsetHex="00000850" DisplayMethod="unsigned integer"/>
        <Element Offset="2132" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000854" DisplayMethod="hexadecimal"/>
        <Element Offset="2144" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000860" DisplayMethod="unsigned integer"/>
        <Element Offset="2152" Vartype="Pointer" Bytesize="8" OffsetHex="00000868" DisplayMethod="unsigned integer"/>
        <Element Offset="2156" Vartype="Pointer" Bytesize="8" OffsetHex="0000086C" DisplayMethod="unsigned integer"/>
        <Element Offset="2160" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000870" DisplayMethod="hexadecimal"/>
        <Element Offset="2164" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000874" DisplayMethod="unsigned integer"/>
        <Element Offset="2172" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000087C" DisplayMethod="hexadecimal"/>
        <Element Offset="2176" Vartype="String" Bytesize="5" OffsetHex="00000880" DisplayMethod="unsigned integer"/>
        <Element Offset="2181" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000885" DisplayMethod="unsigned integer"/>
        <Element Offset="2184" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000888" DisplayMethod="hexadecimal"/>
        <Element Offset="2188" Vartype="Pointer" Bytesize="8" OffsetHex="0000088C" DisplayMethod="unsigned integer"/>
        <Element Offset="2192" Vartype="Pointer" Bytesize="8" OffsetHex="00000890" DisplayMethod="unsigned integer"/>
        <Element Offset="2196" Vartype="Pointer" Bytesize="8" OffsetHex="00000894" DisplayMethod="unsigned integer"/>
        <Element Offset="2200" Vartype="Pointer" Bytesize="8" OffsetHex="00000898" DisplayMethod="unsigned integer"/>
        <Element Offset="2204" Vartype="Pointer" Bytesize="8" OffsetHex="0000089C" DisplayMethod="unsigned integer"/>
        <Element Offset="2208" Vartype="Pointer" Bytesize="8" OffsetHex="000008A0" DisplayMethod="unsigned integer"/>
        <Element Offset="2212" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="000008A4" DisplayMethod="hexadecimal"/>
        <Element Offset="2236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2240" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008C0" DisplayMethod="hexadecimal"/>
        <Element Offset="2244" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2256" Vartype="String" Bytesize="5" OffsetHex="000008D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2261" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000008D5" DisplayMethod="unsigned integer"/>
        <Element Offset="2263" Vartype="2 Bytes" Bytesize="2" OffsetHex="000008D7" DisplayMethod="unsigned integer"/>
        <Element Offset="2265" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="000008D9" DisplayMethod="unsigned integer"/>
        <Element Offset="2268" Vartype="Pointer" Bytesize="8" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2272" Vartype="Pointer" Bytesize="8" OffsetHex="000008E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2276" Vartype="4 Bytes" Bytesize="4" RLECount="12" OffsetHex="000008E4" DisplayMethod="hexadecimal"/>
        <Element Offset="2324" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000914" DisplayMethod="unsigned integer"/>
        <Element Offset="2336" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000920" DisplayMethod="hexadecimal"/>
        <Element Offset="2340" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000924" DisplayMethod="unsigned integer"/>
        <Element Offset="2348" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000092C" DisplayMethod="hexadecimal"/>
        <Element Offset="2352" Vartype="String" Bytesize="5" OffsetHex="00000930" DisplayMethod="unsigned integer"/>
        <Element Offset="2357" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000935" DisplayMethod="unsigned integer"/>
        <Element Offset="2360" Vartype="Pointer" Bytesize="8" OffsetHex="00000938" DisplayMethod="unsigned integer"/>
        <Element Offset="2364" Vartype="Pointer" Bytesize="8" OffsetHex="0000093C" DisplayMethod="unsigned integer"/>
        <Element Offset="2368" Vartype="Pointer" Bytesize="8" OffsetHex="00000940" DisplayMethod="unsigned integer"/>
        <Element Offset="2372" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000944" DisplayMethod="hexadecimal"/>
        <Element Offset="2380" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000094C" DisplayMethod="unsigned integer"/>
        <Element Offset="2384" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000950" DisplayMethod="hexadecimal"/>
        <Element Offset="2388" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000954" DisplayMethod="unsigned integer"/>
        <Element Offset="2396" Vartype="Pointer" Bytesize="8" OffsetHex="0000095C" DisplayMethod="unsigned integer"/>
        <Element Offset="2400" Vartype="String" Bytesize="5" OffsetHex="00000960" DisplayMethod="unsigned integer"/>
        <Element Offset="2405" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000965" DisplayMethod="unsigned integer"/>
        <Element Offset="2408" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000968" DisplayMethod="hexadecimal"/>
        <Element Offset="2412" Vartype="Pointer" Bytesize="8" OffsetHex="0000096C" DisplayMethod="unsigned integer"/>
        <Element Offset="2416" Vartype="Pointer" Bytesize="8" OffsetHex="00000970" DisplayMethod="unsigned integer"/>
        <Element Offset="2420" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000974" DisplayMethod="hexadecimal"/>
        <Element Offset="2456" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000998" DisplayMethod="unsigned integer"/>
        <Element Offset="2460" Vartype="Pointer" Bytesize="8" OffsetHex="0000099C" DisplayMethod="unsigned integer"/>
        <Element Offset="2464" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009A0" DisplayMethod="hexadecimal"/>
        <Element Offset="2468" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000009A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2480" Vartype="String" Bytesize="5" OffsetHex="000009B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2485" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="000009B5" DisplayMethod="unsigned integer"/>
        <Element Offset="2488" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009B8" DisplayMethod="hexadecimal"/>
        <Element Offset="2492" Vartype="Pointer" Bytesize="8" OffsetHex="000009BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2496" Vartype="Pointer" Bytesize="8" OffsetHex="000009C0" DisplayMethod="unsigned integer"/>
        <Element Offset="2500" Vartype="Pointer" Bytesize="8" OffsetHex="000009C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2504" Vartype="Pointer" Bytesize="8" OffsetHex="000009C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2508" Vartype="Pointer" Bytesize="8" OffsetHex="000009CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2512" Vartype="Pointer" Bytesize="8" OffsetHex="000009D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2516" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="000009D4" DisplayMethod="hexadecimal"/>
        <Element Offset="2540" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009EC" DisplayMethod="unsigned integer"/>
        <Element Offset="2544" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009F0" DisplayMethod="hexadecimal"/>
        <Element Offset="2548" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2556" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009FC" DisplayMethod="hexadecimal"/>
        <Element Offset="2560" Vartype="String" Bytesize="5" OffsetHex="00000A00" DisplayMethod="unsigned integer"/>
        <Element Offset="2565" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000A05" DisplayMethod="unsigned integer"/>
        <Element Offset="2568" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A08" DisplayMethod="hexadecimal"/>
        <Element Offset="2572" Vartype="Pointer" Bytesize="8" OffsetHex="00000A0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2576" Vartype="Pointer" Bytesize="8" OffsetHex="00000A10" DisplayMethod="unsigned integer"/>
        <Element Offset="2580" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000A14" DisplayMethod="hexadecimal"/>
        <Element Offset="2596" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A24" DisplayMethod="unsigned integer"/>
        <Element Offset="2604" Vartype="Float" Bytesize="4" OffsetHex="00000A2C" DisplayMethod="unsigned integer"/>
        <Element Offset="2608" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A30" DisplayMethod="unsigned integer"/>
        <Element Offset="2612" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000A34" DisplayMethod="hexadecimal"/>
        <Element Offset="2628" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A44" DisplayMethod="unsigned integer"/>
        <Element Offset="2632" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000A48" DisplayMethod="hexadecimal"/>
        <Element Offset="2644" Vartype="Pointer" Bytesize="8" OffsetHex="00000A54" DisplayMethod="unsigned integer"/>
        <Element Offset="2648" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A58" DisplayMethod="unsigned integer"/>
        <Element Offset="2652" Vartype="Pointer" Bytesize="8" OffsetHex="00000A5C" DisplayMethod="unsigned integer"/>
        <Element Offset="2656" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A60" DisplayMethod="hexadecimal"/>
        <Element Offset="2660" Vartype="Pointer" Bytesize="8" OffsetHex="00000A64" DisplayMethod="unsigned integer"/>
        <Element Offset="2664" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A68" DisplayMethod="unsigned integer"/>
        <Element Offset="2668" Vartype="Pointer" Bytesize="8" OffsetHex="00000A6C" DisplayMethod="unsigned integer"/>
        <Element Offset="2672" Vartype="Pointer" Bytesize="8" OffsetHex="00000A70" DisplayMethod="unsigned integer"/>
        <Element Offset="2676" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A74" DisplayMethod="hexadecimal"/>
        <Element Offset="2680" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A78" DisplayMethod="unsigned integer"/>
        <Element Offset="2684" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A7C" DisplayMethod="hexadecimal"/>
        <Element Offset="2688" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A80" DisplayMethod="unsigned integer"/>
        <Element Offset="2692" Vartype="Pointer" Bytesize="8" OffsetHex="00000A84" DisplayMethod="unsigned integer"/>
        <Element Offset="2696" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A88" DisplayMethod="unsigned integer"/>
        <Element Offset="2704" Vartype="Pointer" Bytesize="8" OffsetHex="00000A90" DisplayMethod="unsigned integer"/>
        <Element Offset="2708" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A94" DisplayMethod="unsigned integer"/>
        <Element Offset="2712" Vartype="Pointer" Bytesize="8" OffsetHex="00000A98" DisplayMethod="unsigned integer"/>
        <Element Offset="2716" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A9C" DisplayMethod="unsigned integer"/>
        <Element Offset="2720" Vartype="Pointer" Bytesize="8" OffsetHex="00000AA0" DisplayMethod="unsigned integer"/>
        <Element Offset="2724" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000AA4" DisplayMethod="unsigned integer"/>
        <Element Offset="2744" Vartype="Pointer" Bytesize="8" OffsetHex="00000AB8" DisplayMethod="unsigned integer"/>
        <Element Offset="2748" Vartype="Pointer" Bytesize="8" OffsetHex="00000ABC" DisplayMethod="unsigned integer"/>
        <Element Offset="2752" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AC0" DisplayMethod="unsigned integer"/>
        <Element Offset="2756" Vartype="String" Bytesize="4" OffsetHex="00000AC4" DisplayMethod="unsigned integer"/>
        <Element Offset="2760" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000AC8" DisplayMethod="unsigned integer"/>
        <Element Offset="2768" Vartype="Pointer" Bytesize="8" OffsetHex="00000AD0" DisplayMethod="unsigned integer"/>
        <Element Offset="2772" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AD4" DisplayMethod="hexadecimal"/>
        <Element Offset="2776" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AD8" DisplayMethod="unsigned integer"/>
        <Element Offset="2780" Vartype="Pointer" Bytesize="8" OffsetHex="00000ADC" DisplayMethod="unsigned integer"/>
        <Element Offset="2784" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000AE0" DisplayMethod="unsigned integer"/>
        <Element Offset="2816" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B00" DisplayMethod="hexadecimal"/>
        <Element Offset="2820" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B04" DisplayMethod="unsigned integer"/>
        <Element Offset="2828" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B0C" DisplayMethod="hexadecimal"/>
        <Element Offset="2832" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000B10" DisplayMethod="unsigned integer"/>
        <Element Offset="2848" Vartype="Pointer" Bytesize="8" OffsetHex="00000B20" DisplayMethod="unsigned integer"/>
        <Element Offset="2852" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B24" DisplayMethod="unsigned integer"/>
        <Element Offset="2856" Vartype="Pointer" Bytesize="8" OffsetHex="00000B28" DisplayMethod="unsigned integer"/>
        <Element Offset="2860" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000B2C" DisplayMethod="unsigned integer"/>
        <Element Offset="2872" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B38" DisplayMethod="hexadecimal"/>
        <Element Offset="2876" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2880" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B40" DisplayMethod="hexadecimal"/>
        <Element Offset="2884" Vartype="Pointer" Bytesize="8" OffsetHex="00000B44" DisplayMethod="unsigned integer"/>
        <Element Offset="2888" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B48" DisplayMethod="unsigned integer"/>
        <Element Offset="2892" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B4C" DisplayMethod="hexadecimal"/>
        <Element Offset="2900" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000B54" DisplayMethod="unsigned integer"/>
        <Element Offset="2916" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B64" DisplayMethod="hexadecimal"/>
        <Element Offset="2920" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B68" DisplayMethod="unsigned integer"/>
        <Element Offset="2924" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B6C" DisplayMethod="hexadecimal"/>
        <Element Offset="2928" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B70" DisplayMethod="unsigned integer"/>
        <Element Offset="2936" Vartype="Pointer" Bytesize="8" OffsetHex="00000B78" DisplayMethod="unsigned integer"/>
        <Element Offset="2940" Vartype="Pointer" Bytesize="8" OffsetHex="00000B7C" DisplayMethod="unsigned integer"/>
        <Element Offset="2944" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000B80" DisplayMethod="unsigned integer"/>
        <Element Offset="2968" Vartype="Pointer" Bytesize="8" OffsetHex="00000B98" DisplayMethod="unsigned integer"/>
        <Element Offset="2972" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000B9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3004" Vartype="Pointer" Bytesize="8" OffsetHex="00000BBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3008" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000BC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3020" Vartype="Pointer" Bytesize="8" OffsetHex="00000BCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3024" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3028" Vartype="Pointer" Bytesize="8" OffsetHex="00000BD4" DisplayMethod="unsigned integer"/>
        <Element Offset="3032" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000BD8" DisplayMethod="unsigned integer"/>
        <Element Offset="3040" Vartype="Pointer" Bytesize="8" OffsetHex="00000BE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3044" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BE4" DisplayMethod="hexadecimal"/>
        <Element Offset="3048" Vartype="Pointer" Bytesize="8" OffsetHex="00000BE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3052" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BEC" DisplayMethod="hexadecimal"/>
        <Element Offset="3056" Vartype="Pointer" Bytesize="8" OffsetHex="00000BF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3060" Vartype="Pointer" Bytesize="8" OffsetHex="00000BF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3064" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000BF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3084" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C0C" DisplayMethod="hexadecimal"/>
        <Element Offset="3088" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C10" DisplayMethod="unsigned integer"/>
        <Element Offset="3092" Vartype="Pointer" Bytesize="8" OffsetHex="00000C14" DisplayMethod="unsigned integer"/>
        <Element Offset="3096" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C18" DisplayMethod="unsigned integer"/>
        <Element Offset="3100" Vartype="Pointer" Bytesize="8" OffsetHex="00000C1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3104" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C20" DisplayMethod="hexadecimal"/>
        <Element Offset="3108" Vartype="String" Bytesize="6" OffsetHex="00000C24" DisplayMethod="unsigned integer"/>
        <Element Offset="3114" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000C2A" DisplayMethod="unsigned integer"/>
        <Element Offset="3116" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000C2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3132" Vartype="Pointer" Bytesize="8" OffsetHex="00000C3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3136" Vartype="Pointer" Bytesize="8" OffsetHex="00000C40" DisplayMethod="unsigned integer"/>
        <Element Offset="3140" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C44" DisplayMethod="unsigned integer"/>
        <Element Offset="3148" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C4C" DisplayMethod="hexadecimal"/>
        <Element Offset="3152" Vartype="Pointer" Bytesize="8" OffsetHex="00000C50" DisplayMethod="unsigned integer"/>
        <Element Offset="3156" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C54" DisplayMethod="hexadecimal"/>
        <Element Offset="3160" Vartype="Pointer" Bytesize="8" OffsetHex="00000C58" DisplayMethod="unsigned integer"/>
        <Element Offset="3164" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C5C" DisplayMethod="hexadecimal"/>
        <Element Offset="3168" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C60" DisplayMethod="unsigned integer"/>
        <Element Offset="3172" Vartype="Pointer" Bytesize="8" OffsetHex="00000C64" DisplayMethod="unsigned integer"/>
        <Element Offset="3176" Vartype="Pointer" Bytesize="8" OffsetHex="00000C68" DisplayMethod="unsigned integer"/>
        <Element Offset="3180" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C6C" DisplayMethod="hexadecimal"/>
        <Element Offset="3184" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C70" DisplayMethod="unsigned integer"/>
        <Element Offset="3188" Vartype="Pointer" Bytesize="8" OffsetHex="00000C74" DisplayMethod="unsigned integer"/>
        <Element Offset="3192" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C78" DisplayMethod="unsigned integer"/>
        <Element Offset="3196" Vartype="Pointer" Bytesize="8" OffsetHex="00000C7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3200" Vartype="Pointer" Bytesize="8" OffsetHex="00000C80" DisplayMethod="unsigned integer"/>
        <Element Offset="3204" Vartype="Pointer" Bytesize="8" OffsetHex="00000C84" DisplayMethod="unsigned integer"/>
        <Element Offset="3208" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C88" DisplayMethod="unsigned integer"/>
        <Element Offset="3212" Vartype="Pointer" Bytesize="8" OffsetHex="00000C8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3216" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C90" DisplayMethod="hexadecimal"/>
        <Element Offset="3220" Vartype="Pointer" Bytesize="8" OffsetHex="00000C94" DisplayMethod="unsigned integer"/>
        <Element Offset="3224" Vartype="Pointer" Bytesize="8" OffsetHex="00000C98" DisplayMethod="unsigned integer"/>
        <Element Offset="3228" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000C9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3248" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CB0" DisplayMethod="hexadecimal"/>
        <Element Offset="3252" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000CB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3260" Vartype="Pointer" Bytesize="8" OffsetHex="00000CBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3264" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3268" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3272" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3276" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000CCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3288" Vartype="Pointer" Bytesize="8" OffsetHex="00000CD8" DisplayMethod="unsigned integer"/>
        <Element Offset="3292" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000CDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3312" Vartype="Pointer" Bytesize="8" OffsetHex="00000CF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3316" Vartype="Pointer" Bytesize="8" OffsetHex="00000CF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3320" Vartype="Pointer" Bytesize="8" OffsetHex="00000CF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3324" Vartype="Pointer" Bytesize="8" OffsetHex="00000CFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3328" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D00" DisplayMethod="unsigned integer"/>
        <Element Offset="3332" Vartype="Pointer" Bytesize="8" OffsetHex="00000D04" DisplayMethod="unsigned integer"/>
        <Element Offset="3336" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000D08" DisplayMethod="unsigned integer"/>
        <Element Offset="3352" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D18" DisplayMethod="hexadecimal"/>
        <Element Offset="3356" Vartype="Pointer" Bytesize="8" OffsetHex="00000D1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3360" Vartype="Pointer" Bytesize="8" OffsetHex="00000D20" DisplayMethod="unsigned integer"/>
        <Element Offset="3364" Vartype="Pointer" Bytesize="8" OffsetHex="00000D24" DisplayMethod="unsigned integer"/>
        <Element Offset="3368" Vartype="Pointer" Bytesize="8" OffsetHex="00000D28" DisplayMethod="unsigned integer"/>
        <Element Offset="3372" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3376" Vartype="Pointer" Bytesize="8" OffsetHex="00000D30" DisplayMethod="unsigned integer"/>
        <Element Offset="3380" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D34" DisplayMethod="unsigned integer"/>
        <Element Offset="3388" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D3C" DisplayMethod="hexadecimal"/>
        <Element Offset="3392" Vartype="Pointer" Bytesize="8" OffsetHex="00000D40" DisplayMethod="unsigned integer"/>
        <Element Offset="3396" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D44" DisplayMethod="unsigned integer"/>
        <Element Offset="3400" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D48" DisplayMethod="hexadecimal"/>
        <Element Offset="3404" Vartype="Pointer" Bytesize="8" OffsetHex="00000D4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3408" Vartype="Pointer" Bytesize="8" OffsetHex="00000D50" DisplayMethod="unsigned integer"/>
        <Element Offset="3412" Vartype="Pointer" Bytesize="8" OffsetHex="00000D54" DisplayMethod="unsigned integer"/>
        <Element Offset="3416" Vartype="Pointer" Bytesize="8" OffsetHex="00000D58" DisplayMethod="unsigned integer"/>
        <Element Offset="3420" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3424" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D60" DisplayMethod="hexadecimal"/>
        <Element Offset="3428" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000D64" DisplayMethod="unsigned integer"/>
        <Element Offset="3468" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D8C" DisplayMethod="hexadecimal"/>
        <Element Offset="3472" Vartype="Pointer" Bytesize="8" OffsetHex="00000D90" DisplayMethod="unsigned integer"/>
        <Element Offset="3476" Vartype="Pointer" Bytesize="8" OffsetHex="00000D94" DisplayMethod="unsigned integer"/>
        <Element Offset="3480" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000D98" DisplayMethod="unsigned integer"/>
        <Element Offset="3500" Vartype="Pointer" Bytesize="8" OffsetHex="00000DAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3504" Vartype="Pointer" Bytesize="8" OffsetHex="00000DB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3508" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000DB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3528" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DC8" DisplayMethod="hexadecimal"/>
        <Element Offset="3532" Vartype="Pointer" Bytesize="8" OffsetHex="00000DCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3536" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000DD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3552" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3556" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3560" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3564" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3572" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3576" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3580" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3588" Vartype="Pointer" Bytesize="8" OffsetHex="00000E04" DisplayMethod="unsigned integer"/>
        <Element Offset="3592" Vartype="Pointer" Bytesize="8" OffsetHex="00000E08" DisplayMethod="unsigned integer"/>
        <Element Offset="3596" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3600" Vartype="Pointer" Bytesize="8" OffsetHex="00000E10" DisplayMethod="unsigned integer"/>
        <Element Offset="3604" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E14" DisplayMethod="hexadecimal"/>
        <Element Offset="3608" Vartype="Pointer" Bytesize="8" OffsetHex="00000E18" DisplayMethod="unsigned integer"/>
        <Element Offset="3612" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3620" Vartype="Pointer" Bytesize="8" OffsetHex="00000E24" DisplayMethod="unsigned integer"/>
        <Element Offset="3624" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E28" DisplayMethod="unsigned integer"/>
        <Element Offset="3628" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E2C" DisplayMethod="hexadecimal"/>
        <Element Offset="3636" Vartype="Pointer" Bytesize="8" OffsetHex="00000E34" DisplayMethod="unsigned integer"/>
        <Element Offset="3640" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E38" DisplayMethod="unsigned integer"/>
        <Element Offset="3648" Vartype="Pointer" Bytesize="8" OffsetHex="00000E40" DisplayMethod="unsigned integer"/>
        <Element Offset="3652" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E44" DisplayMethod="hexadecimal"/>
        <Element Offset="3656" Vartype="Pointer" Bytesize="8" OffsetHex="00000E48" DisplayMethod="unsigned integer"/>
        <Element Offset="3660" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3664" Vartype="Pointer" Bytesize="8" OffsetHex="00000E50" DisplayMethod="unsigned integer"/>
        <Element Offset="3668" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E54" DisplayMethod="hexadecimal"/>
        <Element Offset="3672" Vartype="Pointer" Bytesize="8" OffsetHex="00000E58" DisplayMethod="unsigned integer"/>
        <Element Offset="3676" Vartype="Pointer" Bytesize="8" OffsetHex="00000E5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3680" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E60" DisplayMethod="unsigned integer"/>
        <Element Offset="3688" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E68" DisplayMethod="hexadecimal"/>
        <Element Offset="3696" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E70" DisplayMethod="unsigned integer"/>
        <Element Offset="3704" Vartype="Pointer" Bytesize="8" OffsetHex="00000E78" DisplayMethod="unsigned integer"/>
        <Element Offset="3708" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3716" Vartype="Pointer" Bytesize="8" OffsetHex="00000E84" DisplayMethod="unsigned integer"/>
        <Element Offset="3720" Vartype="Pointer" Bytesize="8" OffsetHex="00000E88" DisplayMethod="unsigned integer"/>
        <Element Offset="3724" Vartype="Pointer" Bytesize="8" OffsetHex="00000E8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3728" Vartype="Pointer" Bytesize="8" OffsetHex="00000E90" DisplayMethod="unsigned integer"/>
        <Element Offset="3732" Vartype="Pointer" Bytesize="8" OffsetHex="00000E94" DisplayMethod="unsigned integer"/>
        <Element Offset="3736" Vartype="Pointer" Bytesize="8" OffsetHex="00000E98" DisplayMethod="unsigned integer"/>
        <Element Offset="3740" Vartype="Pointer" Bytesize="8" OffsetHex="00000E9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3744" Vartype="Pointer" Bytesize="8" OffsetHex="00000EA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3748" Vartype="Pointer" Bytesize="8" OffsetHex="00000EA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3752" Vartype="Pointer" Bytesize="8" OffsetHex="00000EA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3756" Vartype="Pointer" Bytesize="8" OffsetHex="00000EAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3760" Vartype="Pointer" Bytesize="8" OffsetHex="00000EB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3764" Vartype="Pointer" Bytesize="8" OffsetHex="00000EB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3768" Vartype="Pointer" Bytesize="8" OffsetHex="00000EB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3772" Vartype="Pointer" Bytesize="8" OffsetHex="00000EBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3776" Vartype="Pointer" Bytesize="8" OffsetHex="00000EC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3780" Vartype="Pointer" Bytesize="8" OffsetHex="00000EC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3784" Vartype="Pointer" Bytesize="8" OffsetHex="00000EC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3788" Vartype="Pointer" Bytesize="8" OffsetHex="00000ECC" DisplayMethod="unsigned integer"/>
        <Element Offset="3792" Vartype="Pointer" Bytesize="8" OffsetHex="00000ED0" DisplayMethod="unsigned integer"/>
        <Element Offset="3796" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000ED4" DisplayMethod="unsigned integer"/>
        <Element Offset="3804" Vartype="Pointer" Bytesize="8" OffsetHex="00000EDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3808" Vartype="Pointer" Bytesize="8" OffsetHex="00000EE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3812" Vartype="Pointer" Bytesize="8" OffsetHex="00000EE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3816" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3824" Vartype="Pointer" Bytesize="8" OffsetHex="00000EF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3828" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3836" Vartype="Pointer" Bytesize="8" OffsetHex="00000EFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3840" Vartype="Pointer" Bytesize="8" OffsetHex="00000F00" DisplayMethod="unsigned integer"/>
        <Element Offset="3844" Vartype="Pointer" Bytesize="8" OffsetHex="00000F04" DisplayMethod="unsigned integer"/>
        <Element Offset="3848" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000F08" DisplayMethod="unsigned integer"/>
        <Element Offset="3864" Vartype="Pointer" Bytesize="8" OffsetHex="00000F18" DisplayMethod="unsigned integer"/>
        <Element Offset="3868" Vartype="String" Bytesize="5" OffsetHex="00000F1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3873" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000F21" DisplayMethod="unsigned integer"/>
        <Element Offset="3876" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F24" DisplayMethod="unsigned integer"/>
        <Element Offset="3880" Vartype="Pointer" Bytesize="8" OffsetHex="00000F28" DisplayMethod="unsigned integer"/>
        <Element Offset="3884" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3896" Vartype="Pointer" Bytesize="8" OffsetHex="00000F38" DisplayMethod="unsigned integer"/>
        <Element Offset="3900" Vartype="Pointer" Bytesize="8" OffsetHex="00000F3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3904" Vartype="Pointer" Bytesize="8" OffsetHex="00000F40" DisplayMethod="unsigned integer"/>
        <Element Offset="3908" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F44" DisplayMethod="unsigned integer"/>
        <Element Offset="3912" Vartype="Pointer" Bytesize="8" OffsetHex="00000F48" DisplayMethod="unsigned integer"/>
        <Element Offset="3916" Vartype="Pointer" Bytesize="8" OffsetHex="00000F4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3920" Vartype="Pointer" Bytesize="8" OffsetHex="00000F50" DisplayMethod="unsigned integer"/>
        <Element Offset="3924" Vartype="Pointer" Bytesize="8" OffsetHex="00000F54" DisplayMethod="unsigned integer"/>
        <Element Offset="3928" Vartype="Pointer" Bytesize="8" OffsetHex="00000F58" DisplayMethod="unsigned integer"/>
        <Element Offset="3932" Vartype="Pointer" Bytesize="8" OffsetHex="00000F5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3936" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F60" DisplayMethod="unsigned integer"/>
        <Element Offset="3940" Vartype="Pointer" Bytesize="8" OffsetHex="00000F64" DisplayMethod="unsigned integer"/>
        <Element Offset="3944" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000F68" DisplayMethod="unsigned integer"/>
        <Element Offset="3960" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F78" DisplayMethod="hexadecimal"/>
        <Element Offset="3964" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000F7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3980" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F8C" DisplayMethod="hexadecimal"/>
        <Element Offset="3984" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000F90" DisplayMethod="unsigned integer"/>
        <Element Offset="4008" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FA8" DisplayMethod="hexadecimal"/>
        <Element Offset="4012" Vartype="Pointer" Bytesize="8" OffsetHex="00000FAC" DisplayMethod="unsigned integer"/>
        <Element Offset="4016" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000FB0" DisplayMethod="unsigned integer"/>
        <Element Offset="4036" Vartype="Pointer" Bytesize="8" OffsetHex="00000FC4" DisplayMethod="unsigned integer"/>
        <Element Offset="4040" Vartype="Pointer" Bytesize="8" OffsetHex="00000FC8" DisplayMethod="unsigned integer"/>
        <Element Offset="4044" Vartype="Pointer" Bytesize="8" OffsetHex="00000FCC" DisplayMethod="unsigned integer"/>
        <Element Offset="4048" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FD0" DisplayMethod="hexadecimal"/>
        <Element Offset="4052" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000FD4" DisplayMethod="unsigned integer"/>
        <Element Offset="4064" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FE0" DisplayMethod="hexadecimal"/>
        <Element Offset="4068" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000FE4" DisplayMethod="unsigned integer"/>
        <Element Offset="4076" Vartype="Pointer" Bytesize="8" OffsetHex="00000FEC" DisplayMethod="unsigned integer"/>
        <Element Offset="4080" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FF0" DisplayMethod="unsigned integer"/>
        <Element Offset="4084" Vartype="Pointer" Bytesize="8" OffsetHex="00000FF4" DisplayMethod="unsigned integer"/>
        <Element Offset="4088" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000FF8" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
  </Structures>
  <Comments>Version: Retail 1.02, proabaly works on GOG and Steam as well
</Comments>
</CheatTable>
