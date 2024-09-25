<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>1</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
aobscanmodule(hit, "MaxPayne.exe", 8B ** ** ** 89 81 85) // should be unique
registersymbol(hit)
alloc(hitmem, 128)
label(hitcode)
label(enemy)
label(hit_retadd)
label(hp_flag)
label(kill_flag)
registersymbol(hp_flag)
registersymbol(kill_flag)

hitmem:
hp_flag:
  db 00 00 00 00
kill_flag:
  db 00 00 00 00
hitcode:
  mov [ecx+00000085],eax
  cmp [ecx+000003C2],0
  jne enemy
  cmp [hp_flag], 0
  je hit_retadd
  mov [ecx+00000085],(float)100
jmp hit_retadd

enemy:
  cmp [kill_flag], 0
  je hit_retadd
  mov [ecx+00000085],(float)0
jmp hit_retadd

hit+04:
  jmp hitcode
  nop
hit_retadd:

[DISABLE]
hit+04:
  mov [ecx+00000085],eax
  //db 89 81 85 00 00 00
dealloc(*)
unregistersymbol(*)
</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>19</ID>
          <Description>"H - inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[ENABLE]
hp_flag:
  db 00 00 00 01


[DISABLE]
hp_flag:
  db 00 00 00 00
</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>20</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[ENABLE]
kill_flag:
  db 00 00 00 01


[DISABLE]
kill_flag:
  db 00 00 00 00
</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>18</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
aobscanmodule(ammo, "MaxPayne.exe", FF 89 CB 01) // should be unique
registersymbol(ammo)

ammo:
  db 90 90 90 90 90 90 // also writes to ammo adresses of enemies

[DISABLE]
ammo:
  dec [ecx+000001CB]
  //db FF 89 CB 01 00 00
unregistersymbol(ammo)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>5</ID>
      <Description>"T - inf bullet Time"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[ENABLE]
aobscanmodule(time, "MaxPayne.exe", D9 81 F0 12) // should be unique
alloc(time_mem, 128)
label(time_retadd)
registersymbol(time)

time_mem:
  mov [ecx+000012F0],(float)1
  fld dword ptr [ecx+000012F0]
jmp time_retadd

time:
  jmp time_mem
  nop
time_retadd:

[DISABLE]
time:
  fld dword ptr [ecx+000012F0]
  //db D8 83 F0 12 00 00
dealloc(*)
unregistersymbol(*)
</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Structures StructVersion="2">
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Pointer" Bytesize="8" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="4" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000004" DisplayMethod="unsigned integer"/>
        <Element Offset="16" Vartype="String" Bytesize="5" OffsetHex="00000010" DisplayMethod="unsigned integer"/>
        <Element Offset="21" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000015" DisplayMethod="unsigned integer"/>
        <Element Offset="24" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000018" DisplayMethod="unsigned integer"/>
        <Element Offset="44" Vartype="Double" Bytesize="8" OffsetHex="0000002C" DisplayMethod="unsigned integer"/>
        <Element Offset="52" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000034" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="Float" Bytesize="4" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="60" Vartype="Double" Bytesize="8" OffsetHex="0000003C" DisplayMethod="unsigned integer"/>
        <Element Offset="68" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000044" DisplayMethod="unsigned integer"/>
        <Element Offset="72" Vartype="Float" Bytesize="4" OffsetHex="00000048" DisplayMethod="unsigned integer"/>
        <Element Offset="76" Vartype="Double" Bytesize="8" OffsetHex="0000004C" DisplayMethod="unsigned integer"/>
        <Element Offset="84" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000054" DisplayMethod="unsigned integer"/>
        <Element Offset="96" Vartype="Pointer" Bytesize="8" OffsetHex="00000060" Description="Pointer to instance of X_LevelRuntimeRoom" DisplayMethod="unsigned integer"/>
        <Element Offset="100" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000064" DisplayMethod="unsigned integer"/>
        <Element Offset="104" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000068" DisplayMethod="hexadecimal"/>
        <Element Offset="108" Vartype="Pointer" Bytesize="8" OffsetHex="0000006C" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Pointer" Bytesize="8" OffsetHex="00000070" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="Pointer" Bytesize="8" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000078" DisplayMethod="unsigned integer"/>
        <Element Offset="132" Vartype="Pointer" Bytesize="8" OffsetHex="00000084" Description="Pointer to instance of X_LevelRuntimeRoom" DisplayMethod="unsigned integer"/>
        <Element Offset="136" Vartype="Float" Bytesize="4" OffsetHex="00000088" DisplayMethod="unsigned integer"/>
        <Element Offset="140" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000008C" DisplayMethod="unsigned integer"/>
        <Element Offset="144" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000090" DisplayMethod="hexadecimal"/>
        <Element Offset="148" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000094" DisplayMethod="unsigned integer"/>
        <Element Offset="160" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000A0" DisplayMethod="hexadecimal"/>
        <Element Offset="164" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="000000A4" DisplayMethod="unsigned integer"/>
        <Element Offset="188" Vartype="Pointer" Bytesize="8" OffsetHex="000000BC" DisplayMethod="unsigned integer"/>
        <Element Offset="192" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000C0" DisplayMethod="unsigned integer"/>
        <Element Offset="200" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000C8" DisplayMethod="hexadecimal"/>
        <Element Offset="204" Vartype="Pointer" Bytesize="8" OffsetHex="000000CC" DisplayMethod="unsigned integer"/>
        <Element Offset="208" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000D0" DisplayMethod="hexadecimal"/>
        <Element Offset="212" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000000D4" DisplayMethod="unsigned integer"/>
        <Element Offset="224" Vartype="Float" Bytesize="4" OffsetHex="000000E0" DisplayMethod="unsigned integer"/>
        <Element Offset="228" Vartype="Pointer" Bytesize="8" OffsetHex="000000E4" DisplayMethod="unsigned integer"/>
        <Element Offset="232" Vartype="Pointer" Bytesize="8" OffsetHex="000000E8" DisplayMethod="unsigned integer"/>
        <Element Offset="236" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000EC" DisplayMethod="unsigned integer"/>
        <Element Offset="240" Vartype="Float" Bytesize="4" OffsetHex="000000F0" DisplayMethod="unsigned integer"/>
        <Element Offset="244" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000F4" DisplayMethod="unsigned integer"/>
        <Element Offset="248" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000F8" DisplayMethod="hexadecimal"/>
        <Element Offset="252" Vartype="Pointer" Bytesize="8" OffsetHex="000000FC" DisplayMethod="unsigned integer"/>
        <Element Offset="256" Vartype="Pointer" Bytesize="8" OffsetHex="00000100" DisplayMethod="unsigned integer"/>
        <Element Offset="260" Vartype="Pointer" Bytesize="8" OffsetHex="00000104" DisplayMethod="unsigned integer"/>
        <Element Offset="264" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000108" DisplayMethod="hexadecimal"/>
        <Element Offset="276" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000114" DisplayMethod="unsigned integer"/>
        <Element Offset="288" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000120" DisplayMethod="hexadecimal"/>
        <Element Offset="292" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000124" DisplayMethod="unsigned integer"/>
        <Element Offset="296" Vartype="Double" Bytesize="8" OffsetHex="00000128" DisplayMethod="unsigned integer"/>
        <Element Offset="304" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000130" DisplayMethod="hexadecimal"/>
        <Element Offset="312" Vartype="Float" Bytesize="4" OffsetHex="00000138" DisplayMethod="unsigned integer"/>
        <Element Offset="316" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000013C" DisplayMethod="hexadecimal"/>
        <Element Offset="328" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000148" DisplayMethod="unsigned integer"/>
        <Element Offset="336" Vartype="Pointer" Bytesize="8" OffsetHex="00000150" DisplayMethod="unsigned integer"/>
        <Element Offset="340" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000154" DisplayMethod="unsigned integer"/>
        <Element Offset="352" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000160" DisplayMethod="hexadecimal"/>
        <Element Offset="368" Vartype="Pointer" Bytesize="8" OffsetHex="00000170" DisplayMethod="unsigned integer"/>
        <Element Offset="372" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000174" DisplayMethod="unsigned integer"/>
        <Element Offset="384" Vartype="Pointer" Bytesize="8" OffsetHex="00000180" DisplayMethod="unsigned integer"/>
        <Element Offset="388" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000184" DisplayMethod="hexadecimal"/>
        <Element Offset="392" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000188" DisplayMethod="unsigned integer"/>
        <Element Offset="395" Vartype="2 Bytes" Bytesize="2" OffsetHex="0000018B" DisplayMethod="unsigned integer"/>
        <Element Offset="397" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="0000018D" DisplayMethod="unsigned integer"/>
        <Element Offset="399" Vartype="2 Bytes" Bytesize="2" OffsetHex="0000018F" DisplayMethod="unsigned integer"/>
        <Element Offset="401" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000191" DisplayMethod="unsigned integer"/>
        <Element Offset="404" Vartype="Pointer" Bytesize="8" OffsetHex="00000194" DisplayMethod="unsigned integer"/>
        <Element Offset="408" Vartype="Pointer" Bytesize="8" OffsetHex="00000198" DisplayMethod="unsigned integer"/>
        <Element Offset="412" Vartype="Pointer" Bytesize="8" OffsetHex="0000019C" DisplayMethod="unsigned integer"/>
        <Element Offset="416" Vartype="Pointer" Bytesize="8" OffsetHex="000001A0" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000001A4" DisplayMethod="hexadecimal"/>
        <Element Offset="432" Vartype="Float" Bytesize="4" OffsetHex="000001B0" DisplayMethod="unsigned integer"/>
        <Element Offset="436" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000001B4" DisplayMethod="hexadecimal"/>
        <Element Offset="448" Vartype="Pointer" Bytesize="8" OffsetHex="000001C0" DisplayMethod="unsigned integer"/>
        <Element Offset="452" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001C4" DisplayMethod="hexadecimal"/>
        <Element Offset="460" Vartype="Float" Bytesize="4" OffsetHex="000001CC" DisplayMethod="unsigned integer"/>
        <Element Offset="464" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001D0" DisplayMethod="hexadecimal"/>
        <Element Offset="468" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000001D4" DisplayMethod="unsigned integer"/>
        <Element Offset="472" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001D8" DisplayMethod="hexadecimal"/>
        <Element Offset="480" Vartype="Pointer" Bytesize="8" OffsetHex="000001E0" DisplayMethod="unsigned integer"/>
        <Element Offset="484" Vartype="Float" Bytesize="4" OffsetHex="000001E4" DisplayMethod="unsigned integer"/>
        <Element Offset="488" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000001E8" DisplayMethod="hexadecimal"/>
        <Element Offset="500" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000001F4" DisplayMethod="unsigned integer"/>
        <Element Offset="504" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000001F8" DisplayMethod="hexadecimal"/>
        <Element Offset="516" Vartype="Pointer" Bytesize="8" OffsetHex="00000204" DisplayMethod="unsigned integer"/>
        <Element Offset="520" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000208" DisplayMethod="unsigned integer"/>
        <Element Offset="532" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000214" DisplayMethod="hexadecimal"/>
        <Element Offset="536" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000218" DisplayMethod="unsigned integer"/>
        <Element Offset="544" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000220" DisplayMethod="hexadecimal"/>
        <Element Offset="560" Vartype="Float" Bytesize="4" OffsetHex="00000230" DisplayMethod="unsigned integer"/>
        <Element Offset="564" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000234" DisplayMethod="unsigned integer"/>
        <Element Offset="568" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000238" DisplayMethod="hexadecimal"/>
        <Element Offset="572" Vartype="Pointer" Bytesize="8" OffsetHex="0000023C" DisplayMethod="unsigned integer"/>
        <Element Offset="576" Vartype="String" Bytesize="4" OffsetHex="00000240" DisplayMethod="unsigned integer"/>
        <Element Offset="580" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000244" DisplayMethod="hexadecimal"/>
        <Element Offset="592" Vartype="Float" Bytesize="4" OffsetHex="00000250" DisplayMethod="unsigned integer"/>
        <Element Offset="596" Vartype="Pointer" Bytesize="8" OffsetHex="00000254" DisplayMethod="unsigned integer"/>
        <Element Offset="600" Vartype="Pointer" Bytesize="8" OffsetHex="00000258" DisplayMethod="unsigned integer"/>
        <Element Offset="604" Vartype="Pointer" Bytesize="8" OffsetHex="0000025C" DisplayMethod="unsigned integer"/>
        <Element Offset="608" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000260" DisplayMethod="hexadecimal"/>
        <Element Offset="612" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000264" DisplayMethod="unsigned integer"/>
        <Element Offset="620" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000026C" DisplayMethod="hexadecimal"/>
        <Element Offset="624" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000270" DisplayMethod="unsigned integer"/>
        <Element Offset="636" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000027C" DisplayMethod="hexadecimal"/>
        <Element Offset="640" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000280" DisplayMethod="unsigned integer"/>
        <Element Offset="652" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000028C" DisplayMethod="hexadecimal"/>
        <Element Offset="656" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000290" DisplayMethod="unsigned integer"/>
        <Element Offset="668" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000029C" DisplayMethod="hexadecimal"/>
        <Element Offset="672" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002A0" DisplayMethod="unsigned integer"/>
        <Element Offset="676" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002A4" DisplayMethod="hexadecimal"/>
        <Element Offset="680" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002A8" DisplayMethod="unsigned integer"/>
        <Element Offset="684" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002AC" DisplayMethod="hexadecimal"/>
        <Element Offset="688" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002B0" DisplayMethod="unsigned integer"/>
        <Element Offset="692" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002B4" DisplayMethod="hexadecimal"/>
        <Element Offset="696" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002B8" DisplayMethod="unsigned integer"/>
        <Element Offset="700" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002BC" DisplayMethod="hexadecimal"/>
        <Element Offset="704" Vartype="Float" Bytesize="4" OffsetHex="000002C0" DisplayMethod="unsigned integer"/>
        <Element Offset="708" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002C4" DisplayMethod="unsigned integer"/>
        <Element Offset="712" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002C8" DisplayMethod="hexadecimal"/>
        <Element Offset="716" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000002CC" DisplayMethod="unsigned integer"/>
        <Element Offset="720" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002D0" DisplayMethod="unsigned integer"/>
        <Element Offset="724" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000002D4" DisplayMethod="unsigned integer"/>
        <Element Offset="728" Vartype="Pointer" Bytesize="8" OffsetHex="000002D8" DisplayMethod="unsigned integer"/>
        <Element Offset="732" Vartype="Pointer" Bytesize="8" OffsetHex="000002DC" DisplayMethod="unsigned integer"/>
        <Element Offset="736" Vartype="Pointer" Bytesize="8" OffsetHex="000002E0" DisplayMethod="unsigned integer"/>
        <Element Offset="740" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000002E4" DisplayMethod="hexadecimal"/>
        <Element Offset="752" Vartype="String" Bytesize="4" OffsetHex="000002F0" DisplayMethod="unsigned integer"/>
        <Element Offset="756" Vartype="Pointer" Bytesize="8" OffsetHex="000002F4" DisplayMethod="unsigned integer"/>
        <Element Offset="760" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002F8" DisplayMethod="unsigned integer"/>
        <Element Offset="764" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002FC" DisplayMethod="hexadecimal"/>
        <Element Offset="768" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000300" DisplayMethod="unsigned integer"/>
        <Element Offset="780" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000030C" DisplayMethod="hexadecimal"/>
        <Element Offset="784" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000310" DisplayMethod="unsigned integer"/>
        <Element Offset="808" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000328" DisplayMethod="hexadecimal"/>
        <Element Offset="812" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000032C" DisplayMethod="unsigned integer"/>
        <Element Offset="820" Vartype="Float" Bytesize="4" OffsetHex="00000334" DisplayMethod="unsigned integer"/>
        <Element Offset="824" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000338" DisplayMethod="hexadecimal"/>
        <Element Offset="828" Vartype="Float" Bytesize="4" OffsetHex="0000033C" DisplayMethod="unsigned integer"/>
        <Element Offset="832" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000340" DisplayMethod="unsigned integer"/>
        <Element Offset="840" Vartype="Double" Bytesize="8" OffsetHex="00000348" DisplayMethod="unsigned integer"/>
        <Element Offset="848" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000350" DisplayMethod="hexadecimal"/>
        <Element Offset="852" Vartype="Float" Bytesize="4" OffsetHex="00000354" DisplayMethod="unsigned integer"/>
        <Element Offset="856" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000358" DisplayMethod="unsigned integer"/>
        <Element Offset="860" Vartype="Float" Bytesize="4" OffsetHex="0000035C" DisplayMethod="unsigned integer"/>
        <Element Offset="864" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000360" DisplayMethod="unsigned integer"/>
        <Element Offset="868" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000364" DisplayMethod="hexadecimal"/>
        <Element Offset="884" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000374" DisplayMethod="unsigned integer"/>
        <Element Offset="888" Vartype="Pointer" Bytesize="8" OffsetHex="00000378" DisplayMethod="unsigned integer"/>
        <Element Offset="892" Vartype="Float" Bytesize="4" OffsetHex="0000037C" DisplayMethod="unsigned integer"/>
        <Element Offset="896" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000380" DisplayMethod="unsigned integer"/>
        <Element Offset="908" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000038C" DisplayMethod="hexadecimal"/>
        <Element Offset="912" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000390" DisplayMethod="unsigned integer"/>
        <Element Offset="916" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000394" DisplayMethod="hexadecimal"/>
        <Element Offset="920" Vartype="Double" Bytesize="8" OffsetHex="00000398" DisplayMethod="unsigned integer"/>
        <Element Offset="928" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003A0" DisplayMethod="hexadecimal"/>
        <Element Offset="932" Vartype="Pointer" Bytesize="8" OffsetHex="000003A4" Description="Pointer to instance of X_AudioImplementation" DisplayMethod="unsigned integer"/>
        <Element Offset="936" Vartype="Pointer" Bytesize="8" OffsetHex="000003A8" Description="Pointer to instance of X_SoundOmni" DisplayMethod="unsigned integer"/>
        <Element Offset="940" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003AC" DisplayMethod="unsigned integer"/>
        <Element Offset="948" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000003B4" DisplayMethod="hexadecimal"/>
        <Element Offset="960" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000003C0" DisplayMethod="unsigned integer"/>
        <Element Offset="972" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003CC" DisplayMethod="hexadecimal"/>
        <Element Offset="980" Vartype="Pointer" Bytesize="8" OffsetHex="000003D4" DisplayMethod="unsigned integer"/>
        <Element Offset="984" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003D8" DisplayMethod="unsigned integer"/>
        <Element Offset="988" Vartype="Pointer" Bytesize="8" OffsetHex="000003DC" Description="Pointer to instance of X_ProjectileImplementation" DisplayMethod="unsigned integer"/>
        <Element Offset="992" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000003E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1004" Vartype="Float" Bytesize="4" OffsetHex="000003EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1008" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003F0" DisplayMethod="hexadecimal"/>
        <Element Offset="1012" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000003F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1020" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003FC" DisplayMethod="hexadecimal"/>
        <Element Offset="1028" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000404" DisplayMethod="unsigned integer"/>
        <Element Offset="1036" Vartype="Pointer" Bytesize="8" OffsetHex="0000040C" DisplayMethod="unsigned integer"/>
        <Element Offset="1040" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000410" DisplayMethod="unsigned integer"/>
        <Element Offset="1048" Vartype="Pointer" Bytesize="8" OffsetHex="00000418" DisplayMethod="unsigned integer"/>
        <Element Offset="1052" Vartype="Pointer" Bytesize="8" OffsetHex="0000041C" Description="Pointer to instance of KF2::KF_ObjectAnimationLODs" DisplayMethod="unsigned integer"/>
        <Element Offset="1056" Vartype="Pointer" Bytesize="8" OffsetHex="00000420" DisplayMethod="unsigned integer"/>
        <Element Offset="1060" Vartype="Pointer" Bytesize="8" OffsetHex="00000424" DisplayMethod="unsigned integer"/>
        <Element Offset="1064" Vartype="Pointer" Bytesize="8" OffsetHex="00000428" Description="Pointer to instance of KF2::KF_ObjectAnimationLODs" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="Pointer" Bytesize="8" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1076" Vartype="Float" Bytesize="4" OffsetHex="00000434" DisplayMethod="unsigned integer"/>
        <Element Offset="1080" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000438" DisplayMethod="unsigned integer"/>
        <Element Offset="1084" Vartype="Float" Bytesize="4" RLECount="8" OffsetHex="0000043C" DisplayMethod="unsigned integer"/>
        <Element Offset="1116" Vartype="String" Bytesize="4" OffsetHex="0000045C" DisplayMethod="unsigned integer"/>
        <Element Offset="1120" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000460" DisplayMethod="unsigned integer"/>
        <Element Offset="1136" Vartype="Pointer" Bytesize="8" OffsetHex="00000470" DisplayMethod="unsigned integer"/>
        <Element Offset="1140" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000474" DisplayMethod="hexadecimal"/>
        <Element Offset="1144" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000478" DisplayMethod="unsigned integer"/>
        <Element Offset="1152" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000480" DisplayMethod="hexadecimal"/>
        <Element Offset="1156" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000484" DisplayMethod="unsigned integer"/>
        <Element Offset="1172" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000494" DisplayMethod="hexadecimal"/>
        <Element Offset="1184" Vartype="Float" Bytesize="4" OffsetHex="000004A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1188" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000004A4" DisplayMethod="hexadecimal"/>
        <Element Offset="1204" Vartype="Float" Bytesize="4" OffsetHex="000004B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1208" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004B8" DisplayMethod="hexadecimal"/>
        <Element Offset="1212" Vartype="Pointer" Bytesize="8" OffsetHex="000004BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1216" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004C0" DisplayMethod="hexadecimal"/>
        <Element Offset="1220" Vartype="Pointer" Bytesize="8" OffsetHex="000004C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1224" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004C8" DisplayMethod="hexadecimal"/>
        <Element Offset="1228" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000004CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1232" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004D0" DisplayMethod="hexadecimal"/>
        <Element Offset="1236" Vartype="Double" Bytesize="8" OffsetHex="000004D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1244" Vartype="Float" Bytesize="4" RLECount="5" OffsetHex="000004DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1264" Vartype="Byte" Bytesize="1" OffsetHex="000004F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1265" Vartype="String" Bytesize="5" OffsetHex="000004F1" DisplayMethod="unsigned integer"/>
        <Element Offset="1270" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000004F6" DisplayMethod="unsigned integer"/>
        <Element Offset="1272" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004F8" DisplayMethod="hexadecimal"/>
        <Element Offset="1276" Vartype="Float" Bytesize="4" OffsetHex="000004FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1280" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000500" DisplayMethod="hexadecimal"/>
        <Element Offset="1284" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000504" DisplayMethod="unsigned integer"/>
        <Element Offset="1288" Vartype="Pointer" Bytesize="8" OffsetHex="00000508" DisplayMethod="unsigned integer"/>
        <Element Offset="1292" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000050C" DisplayMethod="unsigned integer"/>
        <Element Offset="1304" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000518" DisplayMethod="hexadecimal"/>
        <Element Offset="1308" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000051C" DisplayMethod="unsigned integer"/>
        <Element Offset="1320" Vartype="Pointer" Bytesize="8" OffsetHex="00000528" DisplayMethod="unsigned integer"/>
        <Element Offset="1324" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000052C" DisplayMethod="unsigned integer"/>
        <Element Offset="1332" Vartype="Double" Bytesize="8" RLECount="5" OffsetHex="00000534" DisplayMethod="unsigned integer"/>
        <Element Offset="1372" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="0000055C" DisplayMethod="unsigned integer"/>
        <Element Offset="1384" Vartype="Pointer" Bytesize="8" OffsetHex="00000568" Description="Pointer to instance of X_LevelRuntimeRoom" DisplayMethod="unsigned integer"/>
        <Element Offset="1388" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000056C" DisplayMethod="unsigned integer"/>
        <Element Offset="1392" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000570" DisplayMethod="hexadecimal"/>
        <Element Offset="1396" Vartype="Pointer" Bytesize="8" OffsetHex="00000574" DisplayMethod="unsigned integer"/>
        <Element Offset="1400" Vartype="Pointer" Bytesize="8" OffsetHex="00000578" DisplayMethod="unsigned integer"/>
        <Element Offset="1404" Vartype="Double" Bytesize="8" OffsetHex="0000057C" DisplayMethod="unsigned integer"/>
        <Element Offset="1412" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000584" DisplayMethod="unsigned integer"/>
        <Element Offset="1420" Vartype="Pointer" Bytesize="8" OffsetHex="0000058C" Description="Pointer to instance of X_LevelRuntimeRoom" DisplayMethod="unsigned integer"/>
        <Element Offset="1424" Vartype="Pointer" Bytesize="8" OffsetHex="00000590" DisplayMethod="unsigned integer"/>
        <Element Offset="1428" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000594" DisplayMethod="unsigned integer"/>
        <Element Offset="1432" Vartype="Float" Bytesize="4" OffsetHex="00000598" DisplayMethod="unsigned integer"/>
        <Element Offset="1436" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000059C" DisplayMethod="unsigned integer"/>
        <Element Offset="1448" Vartype="Float" Bytesize="4" OffsetHex="000005A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1452" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="000005AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1476" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005C4" DisplayMethod="hexadecimal"/>
        <Element Offset="1480" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000005C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1488" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005D0" DisplayMethod="hexadecimal"/>
        <Element Offset="1492" Vartype="Pointer" Bytesize="8" OffsetHex="000005D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1496" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000005D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1500" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000005DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1512" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005E8" DisplayMethod="hexadecimal"/>
        <Element Offset="1516" Vartype="Pointer" Bytesize="8" OffsetHex="000005EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1520" Vartype="Pointer" Bytesize="8" OffsetHex="000005F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1524" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1528" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005F8" DisplayMethod="hexadecimal"/>
        <Element Offset="1532" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1536" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000600" DisplayMethod="hexadecimal"/>
        <Element Offset="1540" Vartype="Pointer" Bytesize="8" OffsetHex="00000604" DisplayMethod="unsigned integer"/>
        <Element Offset="1544" Vartype="Pointer" Bytesize="8" OffsetHex="00000608" DisplayMethod="unsigned integer"/>
        <Element Offset="1548" Vartype="Pointer" Bytesize="8" OffsetHex="0000060C" DisplayMethod="unsigned integer"/>
        <Element Offset="1552" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000610" DisplayMethod="hexadecimal"/>
        <Element Offset="1560" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000618" DisplayMethod="unsigned integer"/>
        <Element Offset="1576" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000628" DisplayMethod="hexadecimal"/>
        <Element Offset="1580" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000062C" DisplayMethod="unsigned integer"/>
        <Element Offset="1584" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000630" DisplayMethod="unsigned integer"/>
        <Element Offset="1588" Vartype="Float" Bytesize="4" OffsetHex="00000634" DisplayMethod="unsigned integer"/>
        <Element Offset="1592" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000638" DisplayMethod="hexadecimal"/>
        <Element Offset="1604" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000644" DisplayMethod="unsigned integer"/>
        <Element Offset="1612" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000064C" DisplayMethod="hexadecimal"/>
        <Element Offset="1616" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000650" DisplayMethod="unsigned integer"/>
        <Element Offset="1624" Vartype="Pointer" Bytesize="8" OffsetHex="00000658" DisplayMethod="unsigned integer"/>
        <Element Offset="1628" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000065C" DisplayMethod="unsigned integer"/>
        <Element Offset="1640" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000668" DisplayMethod="hexadecimal"/>
        <Element Offset="1656" Vartype="Pointer" Bytesize="8" OffsetHex="00000678" DisplayMethod="unsigned integer"/>
        <Element Offset="1660" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000067C" DisplayMethod="unsigned integer"/>
        <Element Offset="1680" Vartype="Float" Bytesize="4" OffsetHex="00000690" DisplayMethod="unsigned integer"/>
        <Element Offset="1684" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000694" DisplayMethod="unsigned integer"/>
        <Element Offset="1687" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000697" DisplayMethod="unsigned integer"/>
        <Element Offset="1689" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000699" DisplayMethod="unsigned integer"/>
        <Element Offset="1692" Vartype="Pointer" Bytesize="8" OffsetHex="0000069C" DisplayMethod="unsigned integer"/>
        <Element Offset="1696" Vartype="Pointer" Bytesize="8" OffsetHex="000006A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1700" Vartype="Pointer" Bytesize="8" OffsetHex="000006A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1704" Vartype="Pointer" Bytesize="8" OffsetHex="000006A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1708" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000006AC" DisplayMethod="hexadecimal"/>
        <Element Offset="1720" Vartype="Float" Bytesize="4" OffsetHex="000006B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1724" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1728" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000006C0" DisplayMethod="hexadecimal"/>
        <Element Offset="1740" Vartype="Pointer" Bytesize="8" OffsetHex="000006CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1744" Vartype="Pointer" Bytesize="8" OffsetHex="000006D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1748" Vartype="Pointer" Bytesize="8" OffsetHex="000006D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1752" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000006D8" DisplayMethod="hexadecimal"/>
        <Element Offset="1772" Vartype="Pointer" Bytesize="8" OffsetHex="000006EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1776" Vartype="Byte" Bytesize="1" OffsetHex="000006F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1777" Vartype="String" Bytesize="5" OffsetHex="000006F1" DisplayMethod="unsigned integer"/>
        <Element Offset="1782" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000006F6" DisplayMethod="unsigned integer"/>
        <Element Offset="1784" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006F8" DisplayMethod="hexadecimal"/>
        <Element Offset="1788" Vartype="Float" Bytesize="4" OffsetHex="000006FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1792" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000700" DisplayMethod="hexadecimal"/>
        <Element Offset="1804" Vartype="Pointer" Bytesize="8" OffsetHex="0000070C" DisplayMethod="unsigned integer"/>
        <Element Offset="1808" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000710" DisplayMethod="unsigned integer"/>
        <Element Offset="1820" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000071C" DisplayMethod="hexadecimal"/>
        <Element Offset="1824" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000720" DisplayMethod="unsigned integer"/>
        <Element Offset="1832" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000728" DisplayMethod="hexadecimal"/>
        <Element Offset="1856" Vartype="Pointer" Bytesize="8" OffsetHex="00000740" DisplayMethod="unsigned integer"/>
        <Element Offset="1860" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000744" DisplayMethod="hexadecimal"/>
        <Element Offset="1864" Vartype="Pointer" Bytesize="8" OffsetHex="00000748" DisplayMethod="unsigned integer"/>
        <Element Offset="1868" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="0000074C" DisplayMethod="hexadecimal"/>
        <Element Offset="1888" Vartype="Pointer" Bytesize="8" OffsetHex="00000760" DisplayMethod="unsigned integer"/>
        <Element Offset="1892" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000764" DisplayMethod="hexadecimal"/>
        <Element Offset="1900" Vartype="String" Bytesize="4" OffsetHex="0000076C" DisplayMethod="unsigned integer"/>
        <Element Offset="1904" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000770" DisplayMethod="hexadecimal"/>
        <Element Offset="1912" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000778" DisplayMethod="unsigned integer"/>
        <Element Offset="1924" Vartype="Pointer" Bytesize="8" OffsetHex="00000784" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1940" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000794" DisplayMethod="hexadecimal"/>
        <Element Offset="1944" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000798" DisplayMethod="unsigned integer"/>
        <Element Offset="1956" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007A4" DisplayMethod="hexadecimal"/>
        <Element Offset="1960" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1964" Vartype="Float" Bytesize="4" OffsetHex="000007AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1968" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1972" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007B4" DisplayMethod="hexadecimal"/>
        <Element Offset="1976" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1980" Vartype="Float" Bytesize="4" OffsetHex="000007BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1984" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1988" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000007C4" DisplayMethod="hexadecimal"/>
        <Element Offset="2000" Vartype="Pointer" Bytesize="8" OffsetHex="000007D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2004" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000007D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2008" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2012" Vartype="Float" Bytesize="4" OffsetHex="000007DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000007E0" DisplayMethod="hexadecimal"/>
        <Element Offset="2032" Vartype="Double" Bytesize="8" OffsetHex="000007F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2040" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000007F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2044" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007FC" DisplayMethod="hexadecimal"/>
        <Element Offset="2048" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000800" DisplayMethod="unsigned integer"/>
        <Element Offset="2052" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000804" DisplayMethod="hexadecimal"/>
        <Element Offset="2056" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000808" DisplayMethod="unsigned integer"/>
        <Element Offset="2068" Vartype="Float" Bytesize="4" OffsetHex="00000814" DisplayMethod="unsigned integer"/>
        <Element Offset="2072" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000818" DisplayMethod="unsigned integer"/>
        <Element Offset="2096" Vartype="Float" Bytesize="4" OffsetHex="00000830" DisplayMethod="unsigned integer"/>
        <Element Offset="2100" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000834" DisplayMethod="unsigned integer"/>
        <Element Offset="2108" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000083C" DisplayMethod="hexadecimal"/>
        <Element Offset="2120" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000848" DisplayMethod="unsigned integer"/>
        <Element Offset="2132" Vartype="Float" Bytesize="4" OffsetHex="00000854" DisplayMethod="unsigned integer"/>
        <Element Offset="2136" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000858" DisplayMethod="hexadecimal"/>
        <Element Offset="2144" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000860" DisplayMethod="unsigned integer"/>
        <Element Offset="2148" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000864" DisplayMethod="hexadecimal"/>
        <Element Offset="2152" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000868" DisplayMethod="unsigned integer"/>
        <Element Offset="2156" Vartype="Pointer" Bytesize="8" OffsetHex="0000086C" DisplayMethod="unsigned integer"/>
        <Element Offset="2160" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000870" DisplayMethod="hexadecimal"/>
        <Element Offset="2172" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000087C" DisplayMethod="unsigned integer"/>
        <Element Offset="2176" Vartype="Pointer" Bytesize="8" OffsetHex="00000880" DisplayMethod="unsigned integer"/>
        <Element Offset="2180" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000884" DisplayMethod="hexadecimal"/>
        <Element Offset="2184" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000888" DisplayMethod="unsigned integer"/>
        <Element Offset="2196" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000894" DisplayMethod="hexadecimal"/>
        <Element Offset="2200" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000898" DisplayMethod="unsigned integer"/>
        <Element Offset="2204" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000089C" DisplayMethod="hexadecimal"/>
        <Element Offset="2208" Vartype="Double" Bytesize="8" OffsetHex="000008A0" DisplayMethod="unsigned integer"/>
        <Element Offset="2216" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008A8" DisplayMethod="hexadecimal"/>
        <Element Offset="2220" Vartype="Pointer" Bytesize="8" OffsetHex="000008AC" Description="Pointer to instance of X_AudioImplementation" DisplayMethod="unsigned integer"/>
        <Element Offset="2224" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2236" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008BC" DisplayMethod="hexadecimal"/>
        <Element Offset="2248" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000008C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2260" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008D4" DisplayMethod="hexadecimal"/>
        <Element Offset="2268" Vartype="Pointer" Bytesize="8" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2272" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2276" Vartype="Pointer" Bytesize="8" OffsetHex="000008E4" Description="Pointer to instance of X_ProjectileImplementation" DisplayMethod="unsigned integer"/>
        <Element Offset="2280" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000008E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2296" Vartype="Pointer" Bytesize="8" OffsetHex="000008F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2300" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000008FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2308" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000904" DisplayMethod="hexadecimal"/>
        <Element Offset="2316" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="0000090C" DisplayMethod="unsigned integer"/>
        <Element Offset="2324" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000914" DisplayMethod="unsigned integer"/>
        <Element Offset="2336" Vartype="Pointer" Bytesize="8" OffsetHex="00000920" DisplayMethod="unsigned integer"/>
        <Element Offset="2340" Vartype="Pointer" Bytesize="8" OffsetHex="00000924" Description="Pointer to instance of KF2::KF_ObjectAnimationLODs" DisplayMethod="unsigned integer"/>
        <Element Offset="2344" Vartype="Pointer" Bytesize="8" OffsetHex="00000928" DisplayMethod="unsigned integer"/>
        <Element Offset="2348" Vartype="Pointer" Bytesize="8" OffsetHex="0000092C" DisplayMethod="unsigned integer"/>
        <Element Offset="2352" Vartype="Pointer" Bytesize="8" OffsetHex="00000930" Description="Pointer to instance of KF2::KF_ObjectAnimationLODs" DisplayMethod="unsigned integer"/>
        <Element Offset="2356" Vartype="Pointer" Bytesize="8" OffsetHex="00000934" DisplayMethod="unsigned integer"/>
        <Element Offset="2360" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000938" DisplayMethod="hexadecimal"/>
        <Element Offset="2364" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000093C" DisplayMethod="unsigned integer"/>
        <Element Offset="2368" Vartype="Double" Bytesize="8" OffsetHex="00000940" DisplayMethod="unsigned integer"/>
        <Element Offset="2376" Vartype="Float" Bytesize="4" RLECount="12" OffsetHex="00000948" DisplayMethod="unsigned integer"/>
        <Element Offset="2424" Vartype="Pointer" Bytesize="8" OffsetHex="00000978" DisplayMethod="unsigned integer"/>
        <Element Offset="2428" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000097C" DisplayMethod="hexadecimal"/>
        <Element Offset="2432" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000980" DisplayMethod="unsigned integer"/>
        <Element Offset="2440" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000988" DisplayMethod="hexadecimal"/>
        <Element Offset="2444" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="0000098C" DisplayMethod="unsigned integer"/>
        <Element Offset="2460" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000099C" DisplayMethod="hexadecimal"/>
        <Element Offset="2472" Vartype="Float" Bytesize="4" OffsetHex="000009A8" DisplayMethod="unsigned integer"/>
        <Element Offset="2476" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009AC" DisplayMethod="hexadecimal"/>
        <Element Offset="2484" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000009B4" DisplayMethod="unsigned integer"/>
        <Element Offset="2486" Vartype="2 Bytes" Bytesize="2" OffsetHex="000009B6" DisplayMethod="unsigned integer"/>
        <Element Offset="2488" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000009B8" DisplayMethod="hexadecimal"/>
        <Element Offset="2504" Vartype="Float" Bytesize="4" OffsetHex="000009C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2508" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000009CC" DisplayMethod="hexadecimal"/>
        <Element Offset="2520" Vartype="Pointer" Bytesize="8" OffsetHex="000009D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2524" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="000009DC" DisplayMethod="hexadecimal"/>
        <Element Offset="2564" Vartype="Float" Bytesize="4" OffsetHex="00000A04" DisplayMethod="unsigned integer"/>
        <Element Offset="2568" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A08" DisplayMethod="hexadecimal"/>
        <Element Offset="2572" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2576" Vartype="Pointer" Bytesize="8" OffsetHex="00000A10" DisplayMethod="unsigned integer"/>
        <Element Offset="2580" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000A14" DisplayMethod="unsigned integer"/>
        <Element Offset="2592" Vartype="String" Bytesize="5" OffsetHex="00000A20" DisplayMethod="unsigned integer"/>
        <Element Offset="2597" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000A25" DisplayMethod="unsigned integer"/>
        <Element Offset="2600" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A28" DisplayMethod="unsigned integer"/>
        <Element Offset="2608" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A30" DisplayMethod="hexadecimal"/>
        <Element Offset="2612" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A34" DisplayMethod="unsigned integer"/>
        <Element Offset="2620" Vartype="Double" Bytesize="8" RLECount="5" OffsetHex="00000A3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2660" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000A64" DisplayMethod="unsigned integer"/>
        <Element Offset="2672" Vartype="Pointer" Bytesize="8" OffsetHex="00000A70" Description="Pointer to instance of X_LevelRuntimeRoom" DisplayMethod="unsigned integer"/>
        <Element Offset="2676" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A74" DisplayMethod="unsigned integer"/>
        <Element Offset="2680" Vartype="Float" Bytesize="4" OffsetHex="00000A78" DisplayMethod="unsigned integer"/>
        <Element Offset="2684" Vartype="Pointer" Bytesize="8" OffsetHex="00000A7C" DisplayMethod="unsigned integer"/>
        <Element Offset="2688" Vartype="Pointer" Bytesize="8" OffsetHex="00000A80" DisplayMethod="unsigned integer"/>
        <Element Offset="2692" Vartype="Double" Bytesize="8" OffsetHex="00000A84" DisplayMethod="unsigned integer"/>
        <Element Offset="2700" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000A8C" DisplayMethod="unsigned integer"/>
        <Element Offset="2708" Vartype="Pointer" Bytesize="8" OffsetHex="00000A94" Description="Pointer to instance of X_LevelRuntimeRoom" DisplayMethod="unsigned integer"/>
        <Element Offset="2712" Vartype="Float" Bytesize="4" OffsetHex="00000A98" DisplayMethod="unsigned integer"/>
        <Element Offset="2716" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000A9C" DisplayMethod="unsigned integer"/>
        <Element Offset="2720" Vartype="Pointer" Bytesize="8" OffsetHex="00000AA0" DisplayMethod="unsigned integer"/>
        <Element Offset="2724" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000AA4" DisplayMethod="unsigned integer"/>
        <Element Offset="2736" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AB0" DisplayMethod="hexadecimal"/>
        <Element Offset="2740" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000AB4" DisplayMethod="unsigned integer"/>
        <Element Offset="2764" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000ACC" DisplayMethod="hexadecimal"/>
        <Element Offset="2768" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000AD0" DisplayMethod="unsigned integer"/>
        <Element Offset="2776" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AD8" DisplayMethod="hexadecimal"/>
        <Element Offset="2780" Vartype="Pointer" Bytesize="8" OffsetHex="00000ADC" DisplayMethod="unsigned integer"/>
        <Element Offset="2784" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AE0" DisplayMethod="hexadecimal"/>
        <Element Offset="2788" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000AE4" DisplayMethod="unsigned integer"/>
        <Element Offset="2800" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AF0" DisplayMethod="hexadecimal"/>
        <Element Offset="2804" Vartype="Pointer" Bytesize="8" OffsetHex="00000AF4" DisplayMethod="unsigned integer"/>
        <Element Offset="2808" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AF8" DisplayMethod="hexadecimal"/>
        <Element Offset="2812" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AFC" DisplayMethod="unsigned integer"/>
        <Element Offset="2816" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B00" DisplayMethod="hexadecimal"/>
        <Element Offset="2820" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B04" DisplayMethod="unsigned integer"/>
        <Element Offset="2824" Vartype="Pointer" Bytesize="8" OffsetHex="00000B08" DisplayMethod="unsigned integer"/>
        <Element Offset="2828" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000B0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2840" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B18" DisplayMethod="hexadecimal"/>
        <Element Offset="2844" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B1C" DisplayMethod="unsigned integer"/>
        <Element Offset="2848" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B20" DisplayMethod="hexadecimal"/>
        <Element Offset="2852" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000B24" DisplayMethod="unsigned integer"/>
        <Element Offset="2864" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B30" DisplayMethod="hexadecimal"/>
        <Element Offset="2868" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B34" DisplayMethod="unsigned integer"/>
        <Element Offset="2872" Vartype="Double" Bytesize="8" OffsetHex="00000B38" DisplayMethod="unsigned integer"/>
        <Element Offset="2880" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000B40" DisplayMethod="hexadecimal"/>
        <Element Offset="2892" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2900" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B54" DisplayMethod="hexadecimal"/>
        <Element Offset="2904" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000B58" DisplayMethod="unsigned integer"/>
        <Element Offset="2912" Vartype="Pointer" Bytesize="8" OffsetHex="00000B60" DisplayMethod="unsigned integer"/>
        <Element Offset="2916" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000B64" DisplayMethod="unsigned integer"/>
        <Element Offset="2928" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000B70" DisplayMethod="hexadecimal"/>
        <Element Offset="2944" Vartype="Pointer" Bytesize="8" OffsetHex="00000B80" DisplayMethod="unsigned integer"/>
        <Element Offset="2948" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000B84" DisplayMethod="unsigned integer"/>
        <Element Offset="2972" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B9C" DisplayMethod="hexadecimal"/>
        <Element Offset="2980" Vartype="Pointer" Bytesize="8" OffsetHex="00000BA4" DisplayMethod="unsigned integer"/>
        <Element Offset="2984" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BA8" DisplayMethod="hexadecimal"/>
        <Element Offset="2988" Vartype="Pointer" Bytesize="8" OffsetHex="00000BAC" DisplayMethod="unsigned integer"/>
        <Element Offset="2992" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000BB0" DisplayMethod="hexadecimal"/>
        <Element Offset="3008" Vartype="Float" Bytesize="4" OffsetHex="00000BC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3012" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000BC4" DisplayMethod="hexadecimal"/>
        <Element Offset="3028" Vartype="Pointer" Bytesize="8" OffsetHex="00000BD4" DisplayMethod="unsigned integer"/>
        <Element Offset="3032" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BD8" DisplayMethod="unsigned integer"/>
        <Element Offset="3036" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BDC" DisplayMethod="hexadecimal"/>
        <Element Offset="3040" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000BE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3044" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000BE4" DisplayMethod="hexadecimal"/>
        <Element Offset="3052" Vartype="Pointer" Bytesize="8" OffsetHex="00000BEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3056" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000BF0" DisplayMethod="hexadecimal"/>
        <Element Offset="3092" Vartype="Pointer" Bytesize="8" OffsetHex="00000C14" DisplayMethod="unsigned integer"/>
        <Element Offset="3096" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C18" DisplayMethod="unsigned integer"/>
        <Element Offset="3108" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C24" DisplayMethod="hexadecimal"/>
        <Element Offset="3112" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C28" DisplayMethod="unsigned integer"/>
        <Element Offset="3124" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000C34" DisplayMethod="hexadecimal"/>
        <Element Offset="3164" Vartype="Float" Bytesize="4" OffsetHex="00000C5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3168" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C60" DisplayMethod="unsigned integer"/>
        <Element Offset="3172" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C64" DisplayMethod="hexadecimal"/>
        <Element Offset="3184" Vartype="String" Bytesize="5" OffsetHex="00000C70" DisplayMethod="unsigned integer"/>
        <Element Offset="3189" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000C75" DisplayMethod="unsigned integer"/>
        <Element Offset="3192" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C78" DisplayMethod="unsigned integer"/>
        <Element Offset="3196" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C7C" DisplayMethod="hexadecimal"/>
        <Element Offset="3200" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C80" DisplayMethod="unsigned integer"/>
        <Element Offset="3212" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C8C" DisplayMethod="hexadecimal"/>
        <Element Offset="3216" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C90" DisplayMethod="unsigned integer"/>
        <Element Offset="3228" Vartype="Pointer" Bytesize="8" OffsetHex="00000C9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3232" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000CA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3244" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CAC" DisplayMethod="hexadecimal"/>
        <Element Offset="3248" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3252" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CB4" DisplayMethod="hexadecimal"/>
        <Element Offset="3256" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3260" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CBC" DisplayMethod="hexadecimal"/>
        <Element Offset="3264" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3268" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CC4" DisplayMethod="hexadecimal"/>
        <Element Offset="3272" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3276" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000CCC" DisplayMethod="hexadecimal"/>
        <Element Offset="3296" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3300" Vartype="Float" Bytesize="4" OffsetHex="00000CE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3304" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000CE8" DisplayMethod="hexadecimal"/>
        <Element Offset="3336" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D08" DisplayMethod="unsigned integer"/>
        <Element Offset="3340" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D0C" DisplayMethod="hexadecimal"/>
        <Element Offset="3344" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000D10" DisplayMethod="unsigned integer"/>
        <Element Offset="3356" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D1C" DisplayMethod="hexadecimal"/>
        <Element Offset="3360" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000D20" DisplayMethod="unsigned integer"/>
        <Element Offset="3384" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D38" DisplayMethod="hexadecimal"/>
        <Element Offset="3388" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3396" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D44" DisplayMethod="hexadecimal"/>
        <Element Offset="3404" Vartype="Float" Bytesize="4" OffsetHex="00000D4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3408" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000D50" DisplayMethod="unsigned integer"/>
        <Element Offset="3420" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000D5C" DisplayMethod="hexadecimal"/>
        <Element Offset="3432" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D68" DisplayMethod="unsigned integer"/>
        <Element Offset="3436" Vartype="Float" Bytesize="4" OffsetHex="00000D6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3440" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D70" DisplayMethod="unsigned integer"/>
        <Element Offset="3444" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D74" DisplayMethod="hexadecimal"/>
        <Element Offset="3448" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000D78" DisplayMethod="unsigned integer"/>
        <Element Offset="3468" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D8C" DisplayMethod="hexadecimal"/>
        <Element Offset="3472" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000D90" DisplayMethod="unsigned integer"/>
        <Element Offset="3484" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D9C" DisplayMethod="hexadecimal"/>
        <Element Offset="3488" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3492" Vartype="Float" Bytesize="4" OffsetHex="00000DA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3496" Vartype="Double" Bytesize="8" OffsetHex="00000DA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3504" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DB0" DisplayMethod="hexadecimal"/>
        <Element Offset="3508" Vartype="Pointer" Bytesize="8" OffsetHex="00000DB4" Description="Pointer to instance of X_AudioImplementation" DisplayMethod="unsigned integer"/>
        <Element Offset="3512" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000DB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3524" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000DC4" DisplayMethod="hexadecimal"/>
        <Element Offset="3536" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000DD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3548" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DDC" DisplayMethod="hexadecimal"/>
        <Element Offset="3556" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3560" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3564" Vartype="Pointer" Bytesize="8" OffsetHex="00000DEC" Description="Pointer to instance of X_ProjectileImplementation" DisplayMethod="unsigned integer"/>
        <Element Offset="3568" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000DF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3584" Vartype="Pointer" Bytesize="8" OffsetHex="00000E00" DisplayMethod="unsigned integer"/>
        <Element Offset="3588" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E04" DisplayMethod="unsigned integer"/>
        <Element Offset="3592" Vartype="Pointer" Bytesize="8" OffsetHex="00000E08" DisplayMethod="unsigned integer"/>
        <Element Offset="3596" Vartype="Pointer" Bytesize="8" OffsetHex="00000E0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3600" Vartype="Double" Bytesize="8" OffsetHex="00000E10" DisplayMethod="unsigned integer"/>
        <Element Offset="3608" Vartype="Float" Bytesize="4" OffsetHex="00000E18" DisplayMethod="unsigned integer"/>
        <Element Offset="3612" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3624" Vartype="Pointer" Bytesize="8" OffsetHex="00000E28" DisplayMethod="unsigned integer"/>
        <Element Offset="3628" Vartype="Pointer" Bytesize="8" OffsetHex="00000E2C" Description="Pointer to instance of KF2::KF_ObjectAnimationLODs" DisplayMethod="unsigned integer"/>
        <Element Offset="3632" Vartype="Pointer" Bytesize="8" OffsetHex="00000E30" DisplayMethod="unsigned integer"/>
        <Element Offset="3636" Vartype="Pointer" Bytesize="8" OffsetHex="00000E34" DisplayMethod="unsigned integer"/>
        <Element Offset="3640" Vartype="Pointer" Bytesize="8" OffsetHex="00000E38" Description="Pointer to instance of KF2::KF_ObjectAnimationLODs" DisplayMethod="unsigned integer"/>
        <Element Offset="3644" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3648" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E40" DisplayMethod="hexadecimal"/>
        <Element Offset="3652" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E44" DisplayMethod="unsigned integer"/>
        <Element Offset="3656" Vartype="Double" Bytesize="8" OffsetHex="00000E48" DisplayMethod="unsigned integer"/>
        <Element Offset="3664" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000E50" DisplayMethod="unsigned integer"/>
        <Element Offset="3672" Vartype="Double" Bytesize="8" OffsetHex="00000E58" DisplayMethod="unsigned integer"/>
        <Element Offset="3680" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000E60" DisplayMethod="unsigned integer"/>
        <Element Offset="3688" Vartype="Double" Bytesize="8" OffsetHex="00000E68" DisplayMethod="unsigned integer"/>
        <Element Offset="3696" Vartype="Float" Bytesize="4" OffsetHex="00000E70" DisplayMethod="unsigned integer"/>
        <Element Offset="3700" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000E74" DisplayMethod="unsigned integer"/>
        <Element Offset="3704" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000E78" DisplayMethod="unsigned integer"/>
        <Element Offset="3712" Vartype="Pointer" Bytesize="8" OffsetHex="00000E80" DisplayMethod="unsigned integer"/>
        <Element Offset="3716" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E84" DisplayMethod="hexadecimal"/>
        <Element Offset="3720" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E88" DisplayMethod="unsigned integer"/>
        <Element Offset="3728" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E90" DisplayMethod="hexadecimal"/>
        <Element Offset="3732" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000E94" DisplayMethod="unsigned integer"/>
        <Element Offset="3748" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EA4" DisplayMethod="hexadecimal"/>
        <Element Offset="3760" Vartype="Float" Bytesize="4" OffsetHex="00000EB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3764" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000EB4" DisplayMethod="hexadecimal"/>
        <Element Offset="3776" Vartype="Pointer" Bytesize="8" OffsetHex="00000EC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3780" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000EC4" DisplayMethod="hexadecimal"/>
        <Element Offset="3784" Vartype="Float" Bytesize="4" OffsetHex="00000EC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3788" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000ECC" DisplayMethod="hexadecimal"/>
        <Element Offset="3804" Vartype="Pointer" Bytesize="8" OffsetHex="00000EDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3808" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000EE0" DisplayMethod="hexadecimal"/>
        <Element Offset="3824" Vartype="Byte" Bytesize="1" OffsetHex="00000EF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3825" Vartype="String" Bytesize="5" OffsetHex="00000EF1" DisplayMethod="unsigned integer"/>
        <Element Offset="3830" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="00000EF6" DisplayMethod="unsigned integer"/>
        <Element Offset="3832" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000EF8" DisplayMethod="hexadecimal"/>
        <Element Offset="3848" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000F08" DisplayMethod="unsigned integer"/>
        <Element Offset="3856" Vartype="Double" Bytesize="8" OffsetHex="00000F10" DisplayMethod="unsigned integer"/>
        <Element Offset="3864" Vartype="Float" Bytesize="4" RLECount="10" OffsetHex="00000F18" DisplayMethod="unsigned integer"/>
        <Element Offset="3904" Vartype="Double" Bytesize="8" OffsetHex="00000F40" DisplayMethod="unsigned integer"/>
        <Element Offset="3912" Vartype="Float" Bytesize="4" RLECount="22" OffsetHex="00000F48" DisplayMethod="unsigned integer"/>
        <Element Offset="4000" Vartype="Double" Bytesize="8" OffsetHex="00000FA0" DisplayMethod="unsigned integer"/>
        <Element Offset="4008" Vartype="Float" Bytesize="4" RLECount="17" OffsetHex="00000FA8" DisplayMethod="unsigned integer"/>
        <Element Offset="4076" Vartype="Double" Bytesize="8" OffsetHex="00000FEC" DisplayMethod="unsigned integer"/>
        <Element Offset="4084" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000FF4" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
  </Structures>
  <Comments>Version: Retail, 1.05</Comments>
</CheatTable>
