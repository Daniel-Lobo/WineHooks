<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>12</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>9</ID>
      <Description>"Auto - Core.dll+33EAA"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(new_mem, 512)
registersymbol(inf_hp_flag)
registersymbol(inf_magic_flag)
registersymbol(easy_kill_flag)
label(inf_hp_flag)
label(easy_kill_flag)
label(inf_magic_flag)
label(player)
label(enemy)
label(ammo)
label(orig_code)
label(ret_point)

new_mem:
inf_hp_flag:
  db 00 00 00 00
easy_kill_flag:
  db 00 00 00 00
inf_magic_flag:
  db 00 00 00 00

player:
  cmp [edi+8], 12
  jne ammo
  cmp [edi+c], 12
  jne ammo
  cmp [inf_hp_flag], 00
  // we if don't jmp to exit, easy kill will kill player as
  // [edi+8] == [edi+c] for enemies as well
  je orig_code
  mov eax, 64
  mov [edi],eax
  mov edi,eax
  mov eax,[esp+14]
jmp ret_point

ammo:
  cmp [edi+28], 0
  jne enemy
  cmp [edi+2c], 0
  jne enemy
  cmp [inf_magic_flag], 00
  je orig_code
  add eax, 1
  mov [edi],eax
  mov edi,eax
  mov eax,[esp+14]
jmp ret_point

enemy:
  cmp [edi+2c], 201 //exclude New\save\load game screen data
  jne orig_code
  push eax
  mov eax, [edi+8]
  cmp eax, [edi+c]
  pop eax
  jne orig_code
  cmp [easy_kill_flag], 00
  je orig_code
  mov eax, 00
  mov [edi],eax
  mov edi,eax
  mov eax,[esp+14]
jmp ret_point

orig_code:
  mov [edi],eax
  mov edi,eax
  mov eax,[esp+14]
jmp ret_point

Core.dll+33EAA:
  jmp player
  nop
  nop
  nop
ret_point:

[disable]
Core.dll+33EAA:
  mov [edi],eax
  mov edi,eax
  mov eax,[esp+14]
unregistersymbol(inf_hp_flag)
dealloc(new_mem)

</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>10</ID>
          <Description>"H - inf HP"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
inf_hp_flag:
  db 00 00 00 01

[disable]
inf_hp_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>13</ID>
          <Description>"K - easy Kills"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
easy_kill_flag:
  db 00 00 00 01

[disable]
easy_kill_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>11</ID>
          <Description>"M - inf Magic (ter'angreal)"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
inf_magic_flag:
  db 00 00 00 01

[disable]
inf_magic_flag:
  db 00 00 00 00

</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Structures StructVersion="2">
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="16" Vartype="Pointer" Bytesize="8" OffsetHex="00000010" DisplayMethod="unsigned integer"/>
        <Element Offset="20" Vartype="Pointer" Bytesize="8" OffsetHex="00000014" DisplayMethod="unsigned integer"/>
        <Element Offset="24" Vartype="Pointer" Bytesize="8" OffsetHex="00000018" DisplayMethod="unsigned integer"/>
        <Element Offset="28" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="0000001C" DisplayMethod="unsigned integer"/>
        <Element Offset="52" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000034" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="Double" Bytesize="8" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="64" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000040" DisplayMethod="unsigned integer"/>
        <Element Offset="72" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000048" DisplayMethod="unsigned integer"/>
        <Element Offset="92" Vartype="Pointer" Bytesize="8" OffsetHex="0000005C" DisplayMethod="unsigned integer"/>
        <Element Offset="96" Vartype="Pointer" Bytesize="8" OffsetHex="00000060" DisplayMethod="unsigned integer"/>
        <Element Offset="100" Vartype="Pointer" Bytesize="8" OffsetHex="00000064" DisplayMethod="unsigned integer"/>
        <Element Offset="104" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000068" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="Pointer" Bytesize="8" OffsetHex="0000006C" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Pointer" Bytesize="8" OffsetHex="00000070" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="132" Vartype="Pointer" Bytesize="8" OffsetHex="00000084" DisplayMethod="unsigned integer"/>
        <Element Offset="136" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000088" DisplayMethod="hexadecimal"/>
        <Element Offset="140" Vartype="Pointer" Bytesize="8" OffsetHex="0000008C" DisplayMethod="unsigned integer"/>
        <Element Offset="144" Vartype="Pointer" Bytesize="8" OffsetHex="00000090" DisplayMethod="unsigned integer"/>
        <Element Offset="148" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000094" DisplayMethod="unsigned integer"/>
        <Element Offset="168" Vartype="Double" Bytesize="8" OffsetHex="000000A8" DisplayMethod="unsigned integer"/>
        <Element Offset="176" Vartype="Pointer" Bytesize="8" OffsetHex="000000B0" DisplayMethod="unsigned integer"/>
        <Element Offset="180" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000B4" DisplayMethod="unsigned integer"/>
        <Element Offset="184" Vartype="Pointer" Bytesize="8" OffsetHex="000000B8" DisplayMethod="unsigned integer"/>
        <Element Offset="188" Vartype="Pointer" Bytesize="8" OffsetHex="000000BC" DisplayMethod="unsigned integer"/>
        <Element Offset="192" Vartype="Pointer" Bytesize="8" OffsetHex="000000C0" DisplayMethod="unsigned integer"/>
        <Element Offset="196" Vartype="Pointer" Bytesize="8" OffsetHex="000000C4" DisplayMethod="unsigned integer"/>
        <Element Offset="200" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000C8" DisplayMethod="unsigned integer"/>
        <Element Offset="204" Vartype="Pointer" Bytesize="8" OffsetHex="000000CC" DisplayMethod="unsigned integer"/>
        <Element Offset="208" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000D0" DisplayMethod="unsigned integer"/>
        <Element Offset="216" Vartype="Pointer" Bytesize="8" OffsetHex="000000D8" DisplayMethod="unsigned integer"/>
        <Element Offset="220" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000DC" DisplayMethod="unsigned integer"/>
        <Element Offset="224" Vartype="Pointer" Bytesize="8" OffsetHex="000000E0" DisplayMethod="unsigned integer"/>
        <Element Offset="228" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000000E4" DisplayMethod="unsigned integer"/>
        <Element Offset="248" Vartype="Pointer" Bytesize="8" OffsetHex="000000F8" DisplayMethod="unsigned integer"/>
        <Element Offset="252" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000FC" DisplayMethod="unsigned integer"/>
        <Element Offset="260" Vartype="Pointer" Bytesize="8" OffsetHex="00000104" DisplayMethod="unsigned integer"/>
        <Element Offset="264" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000108" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000010C" DisplayMethod="hexadecimal"/>
        <Element Offset="272" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000110" DisplayMethod="unsigned integer"/>
        <Element Offset="276" Vartype="Pointer" Bytesize="8" OffsetHex="00000114" DisplayMethod="unsigned integer"/>
        <Element Offset="280" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000118" DisplayMethod="unsigned integer"/>
        <Element Offset="284" Vartype="Pointer" Bytesize="8" OffsetHex="0000011C" DisplayMethod="unsigned integer"/>
        <Element Offset="288" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000120" DisplayMethod="unsigned integer"/>
        <Element Offset="296" Vartype="Pointer" Bytesize="8" OffsetHex="00000128" DisplayMethod="unsigned integer"/>
        <Element Offset="300" Vartype="Pointer" Bytesize="8" OffsetHex="0000012C" DisplayMethod="unsigned integer"/>
        <Element Offset="304" Vartype="Pointer" Bytesize="8" OffsetHex="00000130" DisplayMethod="unsigned integer"/>
        <Element Offset="308" Vartype="Pointer" Bytesize="8" OffsetHex="00000134" DisplayMethod="unsigned integer"/>
        <Element Offset="312" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000138" DisplayMethod="hexadecimal"/>
        <Element Offset="316" Vartype="Pointer" Bytesize="8" OffsetHex="0000013C" DisplayMethod="unsigned integer"/>
        <Element Offset="320" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000140" DisplayMethod="hexadecimal"/>
        <Element Offset="324" Vartype="Pointer" Bytesize="8" OffsetHex="00000144" DisplayMethod="unsigned integer"/>
        <Element Offset="328" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000148" DisplayMethod="unsigned integer"/>
        <Element Offset="336" Vartype="Double" Bytesize="8" OffsetHex="00000150" DisplayMethod="unsigned integer"/>
        <Element Offset="344" Vartype="Pointer" Bytesize="8" OffsetHex="00000158" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="0000015C" DisplayMethod="unsigned integer"/>
        <Element Offset="364" Vartype="Pointer" Bytesize="8" OffsetHex="0000016C" DisplayMethod="unsigned integer"/>
        <Element Offset="368" Vartype="Pointer" Bytesize="8" OffsetHex="00000170" DisplayMethod="unsigned integer"/>
        <Element Offset="372" Vartype="Pointer" Bytesize="8" OffsetHex="00000174" DisplayMethod="unsigned integer"/>
        <Element Offset="376" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000178" DisplayMethod="hexadecimal"/>
        <Element Offset="380" Vartype="Pointer" Bytesize="8" OffsetHex="0000017C" DisplayMethod="unsigned integer"/>
        <Element Offset="384" Vartype="Pointer" Bytesize="8" OffsetHex="00000180" DisplayMethod="unsigned integer"/>
        <Element Offset="388" Vartype="Pointer" Bytesize="8" OffsetHex="00000184" DisplayMethod="unsigned integer"/>
        <Element Offset="392" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000188" DisplayMethod="unsigned integer"/>
        <Element Offset="396" Vartype="Pointer" Bytesize="8" OffsetHex="0000018C" DisplayMethod="unsigned integer"/>
        <Element Offset="400" Vartype="Pointer" Bytesize="8" OffsetHex="00000190" DisplayMethod="unsigned integer"/>
        <Element Offset="404" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000194" DisplayMethod="unsigned integer"/>
        <Element Offset="408" Vartype="Pointer" Bytesize="8" OffsetHex="00000198" DisplayMethod="unsigned integer"/>
        <Element Offset="412" Vartype="Pointer" Bytesize="8" OffsetHex="0000019C" DisplayMethod="unsigned integer"/>
        <Element Offset="416" Vartype="Pointer" Bytesize="8" OffsetHex="000001A0" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000001A4" DisplayMethod="unsigned integer"/>
        <Element Offset="432" Vartype="Pointer" Bytesize="8" OffsetHex="000001B0" DisplayMethod="unsigned integer"/>
        <Element Offset="436" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001B4" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="Pointer" Bytesize="8" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="448" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001C0" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001C8" DisplayMethod="hexadecimal"/>
        <Element Offset="460" Vartype="Pointer" Bytesize="8" OffsetHex="000001CC" DisplayMethod="unsigned integer"/>
        <Element Offset="464" Vartype="Pointer" Bytesize="8" OffsetHex="000001D0" DisplayMethod="unsigned integer"/>
        <Element Offset="468" Vartype="Pointer" Bytesize="8" OffsetHex="000001D4" DisplayMethod="unsigned integer"/>
        <Element Offset="472" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001D8" DisplayMethod="unsigned integer"/>
        <Element Offset="480" Vartype="Pointer" Bytesize="8" OffsetHex="000001E0" DisplayMethod="unsigned integer"/>
        <Element Offset="484" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000001E4" DisplayMethod="unsigned integer"/>
        <Element Offset="500" Vartype="Pointer" Bytesize="8" OffsetHex="000001F4" DisplayMethod="unsigned integer"/>
        <Element Offset="504" Vartype="Pointer" Bytesize="8" OffsetHex="000001F8" DisplayMethod="unsigned integer"/>
        <Element Offset="508" Vartype="Pointer" Bytesize="8" OffsetHex="000001FC" DisplayMethod="unsigned integer"/>
        <Element Offset="512" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000200" DisplayMethod="unsigned integer"/>
        <Element Offset="516" Vartype="Pointer" Bytesize="8" OffsetHex="00000204" DisplayMethod="unsigned integer"/>
        <Element Offset="520" Vartype="Pointer" Bytesize="8" OffsetHex="00000208" DisplayMethod="unsigned integer"/>
        <Element Offset="524" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000020C" DisplayMethod="unsigned integer"/>
        <Element Offset="528" Vartype="Pointer" Bytesize="8" OffsetHex="00000210" DisplayMethod="unsigned integer"/>
        <Element Offset="532" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000214" DisplayMethod="unsigned integer"/>
        <Element Offset="536" Vartype="Pointer" Bytesize="8" OffsetHex="00000218" DisplayMethod="unsigned integer"/>
        <Element Offset="540" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000021C" DisplayMethod="unsigned integer"/>
        <Element Offset="544" Vartype="Pointer" Bytesize="8" OffsetHex="00000220" DisplayMethod="unsigned integer"/>
        <Element Offset="548" Vartype="Pointer" Bytesize="8" OffsetHex="00000224" DisplayMethod="unsigned integer"/>
        <Element Offset="552" Vartype="Pointer" Bytesize="8" OffsetHex="00000228" DisplayMethod="unsigned integer"/>
        <Element Offset="556" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000022C" DisplayMethod="unsigned integer"/>
        <Element Offset="560" Vartype="Pointer" Bytesize="8" OffsetHex="00000230" DisplayMethod="unsigned integer"/>
        <Element Offset="564" Vartype="Pointer" Bytesize="8" OffsetHex="00000234" DisplayMethod="unsigned integer"/>
        <Element Offset="568" Vartype="Pointer" Bytesize="8" OffsetHex="00000238" DisplayMethod="unsigned integer"/>
        <Element Offset="572" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000023C" DisplayMethod="unsigned integer"/>
        <Element Offset="576" Vartype="Pointer" Bytesize="8" OffsetHex="00000240" DisplayMethod="unsigned integer"/>
        <Element Offset="580" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000244" DisplayMethod="unsigned integer"/>
        <Element Offset="588" Vartype="Pointer" Bytesize="8" OffsetHex="0000024C" DisplayMethod="unsigned integer"/>
        <Element Offset="592" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000250" DisplayMethod="hexadecimal"/>
        <Element Offset="596" Vartype="Pointer" Bytesize="8" OffsetHex="00000254" DisplayMethod="unsigned integer"/>
        <Element Offset="600" Vartype="Pointer" Bytesize="8" OffsetHex="00000258" DisplayMethod="unsigned integer"/>
        <Element Offset="604" Vartype="Pointer" Bytesize="8" OffsetHex="0000025C" DisplayMethod="unsigned integer"/>
        <Element Offset="608" Vartype="Pointer" Bytesize="8" OffsetHex="00000260" DisplayMethod="unsigned integer"/>
        <Element Offset="612" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000264" DisplayMethod="unsigned integer"/>
        <Element Offset="624" Vartype="Pointer" Bytesize="8" OffsetHex="00000270" DisplayMethod="unsigned integer"/>
        <Element Offset="628" Vartype="Pointer" Bytesize="8" OffsetHex="00000274" DisplayMethod="unsigned integer"/>
        <Element Offset="632" Vartype="Pointer" Bytesize="8" OffsetHex="00000278" DisplayMethod="unsigned integer"/>
        <Element Offset="636" Vartype="Pointer" Bytesize="8" OffsetHex="0000027C" DisplayMethod="unsigned integer"/>
        <Element Offset="640" Vartype="Pointer" Bytesize="8" OffsetHex="00000280" DisplayMethod="unsigned integer"/>
        <Element Offset="644" Vartype="Pointer" Bytesize="8" OffsetHex="00000284" DisplayMethod="unsigned integer"/>
        <Element Offset="648" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000288" DisplayMethod="unsigned integer"/>
        <Element Offset="656" Vartype="Pointer" Bytesize="8" OffsetHex="00000290" DisplayMethod="unsigned integer"/>
        <Element Offset="660" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000294" DisplayMethod="unsigned integer"/>
        <Element Offset="668" Vartype="Pointer" Bytesize="8" OffsetHex="0000029C" DisplayMethod="unsigned integer"/>
        <Element Offset="672" Vartype="Pointer" Bytesize="8" OffsetHex="000002A0" DisplayMethod="unsigned integer"/>
        <Element Offset="676" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000002A4" DisplayMethod="unsigned integer"/>
        <Element Offset="688" Vartype="Pointer" Bytesize="8" OffsetHex="000002B0" DisplayMethod="unsigned integer"/>
        <Element Offset="692" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000002B4" DisplayMethod="unsigned integer"/>
        <Element Offset="700" Vartype="Pointer" Bytesize="8" OffsetHex="000002BC" DisplayMethod="unsigned integer"/>
        <Element Offset="704" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002C0" DisplayMethod="unsigned integer"/>
        <Element Offset="708" Vartype="Pointer" Bytesize="8" OffsetHex="000002C4" DisplayMethod="unsigned integer"/>
        <Element Offset="712" Vartype="Pointer" Bytesize="8" OffsetHex="000002C8" DisplayMethod="unsigned integer"/>
        <Element Offset="716" Vartype="Pointer" Bytesize="8" OffsetHex="000002CC" DisplayMethod="unsigned integer"/>
        <Element Offset="720" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002D0" DisplayMethod="hexadecimal"/>
        <Element Offset="724" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002D4" DisplayMethod="unsigned integer"/>
        <Element Offset="728" Vartype="Pointer" Bytesize="8" OffsetHex="000002D8" DisplayMethod="unsigned integer"/>
        <Element Offset="732" Vartype="Pointer" Bytesize="8" OffsetHex="000002DC" DisplayMethod="unsigned integer"/>
        <Element Offset="736" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000002E0" DisplayMethod="hexadecimal"/>
        <Element Offset="744" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002E8" DisplayMethod="unsigned integer"/>
        <Element Offset="748" Vartype="Pointer" Bytesize="8" OffsetHex="000002EC" DisplayMethod="unsigned integer"/>
        <Element Offset="752" Vartype="Pointer" Bytesize="8" OffsetHex="000002F0" DisplayMethod="unsigned integer"/>
        <Element Offset="756" Vartype="Pointer" Bytesize="8" OffsetHex="000002F4" DisplayMethod="unsigned integer"/>
        <Element Offset="760" Vartype="Pointer" Bytesize="8" OffsetHex="000002F8" DisplayMethod="unsigned integer"/>
        <Element Offset="764" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000002FC" DisplayMethod="unsigned integer"/>
        <Element Offset="772" Vartype="Pointer" Bytesize="8" OffsetHex="00000304" DisplayMethod="unsigned integer"/>
        <Element Offset="776" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000308" DisplayMethod="unsigned integer"/>
        <Element Offset="780" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000030C" DisplayMethod="hexadecimal"/>
        <Element Offset="784" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000310" DisplayMethod="unsigned integer"/>
        <Element Offset="788" Vartype="Pointer" Bytesize="8" OffsetHex="00000314" DisplayMethod="unsigned integer"/>
        <Element Offset="792" Vartype="Pointer" Bytesize="8" OffsetHex="00000318" DisplayMethod="unsigned integer"/>
        <Element Offset="796" Vartype="Pointer" Bytesize="8" OffsetHex="0000031C" DisplayMethod="unsigned integer"/>
        <Element Offset="800" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000320" DisplayMethod="unsigned integer"/>
        <Element Offset="808" Vartype="Pointer" Bytesize="8" OffsetHex="00000328" DisplayMethod="unsigned integer"/>
        <Element Offset="812" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000032C" DisplayMethod="unsigned integer"/>
        <Element Offset="824" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000338" DisplayMethod="hexadecimal"/>
        <Element Offset="828" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000033C" DisplayMethod="unsigned integer"/>
        <Element Offset="832" Vartype="Pointer" Bytesize="8" OffsetHex="00000340" DisplayMethod="unsigned integer"/>
        <Element Offset="836" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000344" DisplayMethod="unsigned integer"/>
        <Element Offset="840" Vartype="Pointer" Bytesize="8" OffsetHex="00000348" DisplayMethod="unsigned integer"/>
        <Element Offset="844" Vartype="Pointer" Bytesize="8" OffsetHex="0000034C" DisplayMethod="unsigned integer"/>
        <Element Offset="848" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000350" DisplayMethod="unsigned integer"/>
        <Element Offset="852" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000354" DisplayMethod="hexadecimal"/>
        <Element Offset="856" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000358" DisplayMethod="unsigned integer"/>
        <Element Offset="860" Vartype="Pointer" Bytesize="8" OffsetHex="0000035C" DisplayMethod="unsigned integer"/>
        <Element Offset="864" Vartype="Pointer" Bytesize="8" OffsetHex="00000360" DisplayMethod="unsigned integer"/>
        <Element Offset="868" Vartype="Pointer" Bytesize="8" OffsetHex="00000364" DisplayMethod="unsigned integer"/>
        <Element Offset="872" Vartype="Pointer" Bytesize="8" OffsetHex="00000368" DisplayMethod="unsigned integer"/>
        <Element Offset="876" Vartype="Pointer" Bytesize="8" OffsetHex="0000036C" DisplayMethod="unsigned integer"/>
        <Element Offset="880" Vartype="Pointer" Bytesize="8" OffsetHex="00000370" DisplayMethod="unsigned integer"/>
        <Element Offset="884" Vartype="Pointer" Bytesize="8" OffsetHex="00000374" DisplayMethod="unsigned integer"/>
        <Element Offset="888" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000378" DisplayMethod="unsigned integer"/>
        <Element Offset="896" Vartype="Pointer" Bytesize="8" OffsetHex="00000380" DisplayMethod="unsigned integer"/>
        <Element Offset="900" Vartype="Pointer" Bytesize="8" OffsetHex="00000384" DisplayMethod="unsigned integer"/>
        <Element Offset="904" Vartype="Pointer" Bytesize="8" OffsetHex="00000388" DisplayMethod="unsigned integer"/>
        <Element Offset="908" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000038C" DisplayMethod="unsigned integer"/>
        <Element Offset="912" Vartype="Pointer" Bytesize="8" OffsetHex="00000390" DisplayMethod="unsigned integer"/>
        <Element Offset="916" Vartype="Pointer" Bytesize="8" OffsetHex="00000394" DisplayMethod="unsigned integer"/>
        <Element Offset="920" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000398" DisplayMethod="unsigned integer"/>
        <Element Offset="924" Vartype="Pointer" Bytesize="8" OffsetHex="0000039C" DisplayMethod="unsigned integer"/>
        <Element Offset="928" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003A0" DisplayMethod="unsigned integer"/>
        <Element Offset="932" Vartype="Pointer" Bytesize="8" OffsetHex="000003A4" DisplayMethod="unsigned integer"/>
        <Element Offset="936" Vartype="Pointer" Bytesize="8" OffsetHex="000003A8" DisplayMethod="unsigned integer"/>
        <Element Offset="940" Vartype="Pointer" Bytesize="8" OffsetHex="000003AC" DisplayMethod="unsigned integer"/>
        <Element Offset="944" Vartype="Pointer" Bytesize="8" OffsetHex="000003B0" DisplayMethod="unsigned integer"/>
        <Element Offset="948" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003B4" DisplayMethod="hexadecimal"/>
        <Element Offset="952" Vartype="Pointer" Bytesize="8" OffsetHex="000003B8" DisplayMethod="unsigned integer"/>
        <Element Offset="956" Vartype="Pointer" Bytesize="8" OffsetHex="000003BC" DisplayMethod="unsigned integer"/>
        <Element Offset="960" Vartype="Pointer" Bytesize="8" OffsetHex="000003C0" DisplayMethod="unsigned integer"/>
        <Element Offset="964" Vartype="Pointer" Bytesize="8" OffsetHex="000003C4" DisplayMethod="unsigned integer"/>
        <Element Offset="968" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003C8" DisplayMethod="unsigned integer"/>
        <Element Offset="976" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003D0" DisplayMethod="hexadecimal"/>
        <Element Offset="980" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003D4" DisplayMethod="unsigned integer"/>
        <Element Offset="984" Vartype="Pointer" Bytesize="8" OffsetHex="000003D8" DisplayMethod="unsigned integer"/>
        <Element Offset="988" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003DC" DisplayMethod="unsigned integer"/>
        <Element Offset="996" Vartype="Pointer" Bytesize="8" OffsetHex="000003E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1000" Vartype="Pointer" Bytesize="8" OffsetHex="000003E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1004" Vartype="Unicode String" Bytesize="8" OffsetHex="000003EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1012" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003F4" DisplayMethod="hexadecimal"/>
        <Element Offset="1016" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1024" Vartype="Pointer" Bytesize="8" OffsetHex="00000400" DisplayMethod="unsigned integer"/>
        <Element Offset="1028" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000404" DisplayMethod="unsigned integer"/>
        <Element Offset="1040" Vartype="Pointer" Bytesize="8" OffsetHex="00000410" DisplayMethod="unsigned integer"/>
        <Element Offset="1044" Vartype="Pointer" Bytesize="8" OffsetHex="00000414" DisplayMethod="unsigned integer"/>
        <Element Offset="1048" Vartype="Pointer" Bytesize="8" OffsetHex="00000418" DisplayMethod="unsigned integer"/>
        <Element Offset="1052" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000041C" DisplayMethod="unsigned integer"/>
        <Element Offset="1056" Vartype="Pointer" Bytesize="8" OffsetHex="00000420" DisplayMethod="unsigned integer"/>
        <Element Offset="1060" Vartype="Pointer" Bytesize="8" OffsetHex="00000424" DisplayMethod="unsigned integer"/>
        <Element Offset="1064" Vartype="Pointer" Bytesize="8" OffsetHex="00000428" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="Pointer" Bytesize="8" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000430" DisplayMethod="unsigned integer"/>
        <Element Offset="1076" Vartype="Pointer" Bytesize="8" OffsetHex="00000434" DisplayMethod="unsigned integer"/>
        <Element Offset="1080" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000438" DisplayMethod="unsigned integer"/>
        <Element Offset="1088" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000440" DisplayMethod="hexadecimal"/>
        <Element Offset="1092" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000444" DisplayMethod="unsigned integer"/>
        <Element Offset="1096" Vartype="Pointer" Bytesize="8" OffsetHex="00000448" DisplayMethod="unsigned integer"/>
        <Element Offset="1100" Vartype="Pointer" Bytesize="8" OffsetHex="0000044C" DisplayMethod="unsigned integer"/>
        <Element Offset="1104" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000450" DisplayMethod="unsigned integer"/>
        <Element Offset="1108" Vartype="Pointer" Bytesize="8" OffsetHex="00000454" DisplayMethod="unsigned integer"/>
        <Element Offset="1112" Vartype="Pointer" Bytesize="8" OffsetHex="00000458" DisplayMethod="unsigned integer"/>
        <Element Offset="1116" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000045C" DisplayMethod="unsigned integer"/>
        <Element Offset="1120" Vartype="Pointer" Bytesize="8" OffsetHex="00000460" DisplayMethod="unsigned integer"/>
        <Element Offset="1124" Vartype="Pointer" Bytesize="8" OffsetHex="00000464" DisplayMethod="unsigned integer"/>
        <Element Offset="1128" Vartype="Pointer" Bytesize="8" OffsetHex="00000468" DisplayMethod="unsigned integer"/>
        <Element Offset="1132" Vartype="Pointer" Bytesize="8" OffsetHex="0000046C" DisplayMethod="unsigned integer"/>
        <Element Offset="1136" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000470" DisplayMethod="hexadecimal"/>
        <Element Offset="1140" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000474" DisplayMethod="unsigned integer"/>
        <Element Offset="1144" Vartype="Pointer" Bytesize="8" OffsetHex="00000478" DisplayMethod="unsigned integer"/>
        <Element Offset="1148" Vartype="Pointer" Bytesize="8" OffsetHex="0000047C" DisplayMethod="unsigned integer"/>
        <Element Offset="1152" Vartype="Pointer" Bytesize="8" OffsetHex="00000480" DisplayMethod="unsigned integer"/>
        <Element Offset="1156" Vartype="Pointer" Bytesize="8" OffsetHex="00000484" DisplayMethod="unsigned integer"/>
        <Element Offset="1160" Vartype="Pointer" Bytesize="8" OffsetHex="00000488" DisplayMethod="unsigned integer"/>
        <Element Offset="1164" Vartype="Pointer" Bytesize="8" OffsetHex="0000048C" DisplayMethod="unsigned integer"/>
        <Element Offset="1168" Vartype="Pointer" Bytesize="8" OffsetHex="00000490" DisplayMethod="unsigned integer"/>
        <Element Offset="1172" Vartype="Pointer" Bytesize="8" OffsetHex="00000494" DisplayMethod="unsigned integer"/>
        <Element Offset="1176" Vartype="Pointer" Bytesize="8" OffsetHex="00000498" DisplayMethod="unsigned integer"/>
        <Element Offset="1180" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000049C" DisplayMethod="unsigned integer"/>
        <Element Offset="1184" Vartype="Pointer" Bytesize="8" OffsetHex="000004A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1188" Vartype="Pointer" Bytesize="8" OffsetHex="000004A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1192" Vartype="Pointer" Bytesize="8" OffsetHex="000004A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1196" Vartype="Pointer" Bytesize="8" OffsetHex="000004AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1200" Vartype="Pointer" Bytesize="8" OffsetHex="000004B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1204" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1208" Vartype="Pointer" Bytesize="8" OffsetHex="000004B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1212" Vartype="Pointer" Bytesize="8" OffsetHex="000004BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1216" Vartype="Pointer" Bytesize="8" OffsetHex="000004C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1220" Vartype="Pointer" Bytesize="8" OffsetHex="000004C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1224" Vartype="Pointer" Bytesize="8" OffsetHex="000004C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1228" Vartype="Pointer" Bytesize="8" OffsetHex="000004CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1232" Vartype="Pointer" Bytesize="8" OffsetHex="000004D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1236" Vartype="Pointer" Bytesize="8" OffsetHex="000004D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1240" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1244" Vartype="Pointer" Bytesize="8" OffsetHex="000004DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1248" Vartype="Pointer" Bytesize="8" OffsetHex="000004E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1252" Vartype="Pointer" Bytesize="8" OffsetHex="000004E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1256" Vartype="Pointer" Bytesize="8" OffsetHex="000004E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1260" Vartype="Pointer" Bytesize="8" OffsetHex="000004EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1264" Vartype="Pointer" Bytesize="8" OffsetHex="000004F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1268" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000004F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1280" Vartype="Pointer" Bytesize="8" OffsetHex="00000500" DisplayMethod="unsigned integer"/>
        <Element Offset="1284" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000504" DisplayMethod="unsigned integer"/>
        <Element Offset="1296" Vartype="Pointer" Bytesize="8" OffsetHex="00000510" DisplayMethod="unsigned integer"/>
        <Element Offset="1300" Vartype="Pointer" Bytesize="8" OffsetHex="00000514" DisplayMethod="unsigned integer"/>
        <Element Offset="1304" Vartype="Pointer" Bytesize="8" OffsetHex="00000518" DisplayMethod="unsigned integer"/>
        <Element Offset="1308" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000051C" DisplayMethod="unsigned integer"/>
        <Element Offset="1312" Vartype="Pointer" Bytesize="8" OffsetHex="00000520" DisplayMethod="unsigned integer"/>
        <Element Offset="1316" Vartype="Pointer" Bytesize="8" OffsetHex="00000524" DisplayMethod="unsigned integer"/>
        <Element Offset="1320" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000528" DisplayMethod="unsigned integer"/>
        <Element Offset="1332" Vartype="Pointer" Bytesize="8" OffsetHex="00000534" DisplayMethod="unsigned integer"/>
        <Element Offset="1336" Vartype="Pointer" Bytesize="8" OffsetHex="00000538" DisplayMethod="unsigned integer"/>
        <Element Offset="1340" Vartype="Pointer" Bytesize="8" OffsetHex="0000053C" DisplayMethod="unsigned integer"/>
        <Element Offset="1344" Vartype="Pointer" Bytesize="8" OffsetHex="00000540" Description="Pointer to instance of Object" DisplayMethod="unsigned integer"/>
        <Element Offset="1348" Vartype="Pointer" Bytesize="8" OffsetHex="00000544" DisplayMethod="unsigned integer"/>
        <Element Offset="1352" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000548" DisplayMethod="unsigned integer"/>
        <Element Offset="1360" Vartype="Pointer" Bytesize="8" OffsetHex="00000550" DisplayMethod="unsigned integer"/>
        <Element Offset="1364" Vartype="Pointer" Bytesize="8" OffsetHex="00000554" DisplayMethod="unsigned integer"/>
        <Element Offset="1368" Vartype="Pointer" Bytesize="8" OffsetHex="00000558" DisplayMethod="unsigned integer"/>
        <Element Offset="1372" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000055C" DisplayMethod="unsigned integer"/>
        <Element Offset="1380" Vartype="Pointer" Bytesize="8" OffsetHex="00000564" DisplayMethod="unsigned integer"/>
        <Element Offset="1384" Vartype="Pointer" Bytesize="8" OffsetHex="00000568" Description="Pointer to instance of Object" DisplayMethod="unsigned integer"/>
        <Element Offset="1388" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000056C" DisplayMethod="unsigned integer"/>
        <Element Offset="1396" Vartype="Pointer" Bytesize="8" OffsetHex="00000574" DisplayMethod="unsigned integer"/>
        <Element Offset="1400" Vartype="Pointer" Bytesize="8" OffsetHex="00000578" DisplayMethod="unsigned integer"/>
        <Element Offset="1404" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000057C" DisplayMethod="unsigned integer"/>
        <Element Offset="1408" Vartype="Pointer" Bytesize="8" OffsetHex="00000580" DisplayMethod="unsigned integer"/>
        <Element Offset="1412" Vartype="Pointer" Bytesize="8" OffsetHex="00000584" DisplayMethod="unsigned integer"/>
        <Element Offset="1416" Vartype="Pointer" Bytesize="8" OffsetHex="00000588" Description="Pointer to instance of Object" DisplayMethod="unsigned integer"/>
        <Element Offset="1420" Vartype="Pointer" Bytesize="8" OffsetHex="0000058C" DisplayMethod="unsigned integer"/>
        <Element Offset="1424" Vartype="Pointer" Bytesize="8" OffsetHex="00000590" DisplayMethod="unsigned integer"/>
        <Element Offset="1428" Vartype="Pointer" Bytesize="8" OffsetHex="00000594" DisplayMethod="unsigned integer"/>
        <Element Offset="1432" Vartype="Pointer" Bytesize="8" OffsetHex="00000598" DisplayMethod="unsigned integer"/>
        <Element Offset="1436" Vartype="Pointer" Bytesize="8" OffsetHex="0000059C" DisplayMethod="unsigned integer"/>
        <Element Offset="1440" Vartype="Pointer" Bytesize="8" OffsetHex="000005A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1444" Vartype="Pointer" Bytesize="8" OffsetHex="000005A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1448" Vartype="Pointer" Bytesize="8" OffsetHex="000005A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1452" Vartype="Pointer" Bytesize="8" OffsetHex="000005AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1456" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1460" Vartype="Pointer" Bytesize="8" OffsetHex="000005B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1464" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000005B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1472" Vartype="Pointer" Bytesize="8" OffsetHex="000005C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1476" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005C4" DisplayMethod="hexadecimal"/>
        <Element Offset="1480" Vartype="Pointer" Bytesize="8" OffsetHex="000005C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1484" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005CC" DisplayMethod="hexadecimal"/>
        <Element Offset="1488" Vartype="Pointer" Bytesize="8" OffsetHex="000005D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1492" Vartype="Pointer" Bytesize="8" OffsetHex="000005D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1496" Vartype="Pointer" Bytesize="8" OffsetHex="000005D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1500" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1504" Vartype="Pointer" Bytesize="8" OffsetHex="000005E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1508" Vartype="Pointer" Bytesize="8" OffsetHex="000005E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1512" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000005E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1520" Vartype="Pointer" Bytesize="8" OffsetHex="000005F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1524" Vartype="Pointer" Bytesize="8" OffsetHex="000005F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1528" Vartype="Pointer" Bytesize="8" OffsetHex="000005F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1532" Vartype="Pointer" Bytesize="8" OffsetHex="000005FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1536" Vartype="Pointer" Bytesize="8" OffsetHex="00000600" DisplayMethod="unsigned integer"/>
        <Element Offset="1540" Vartype="Pointer" Bytesize="8" OffsetHex="00000604" DisplayMethod="unsigned integer"/>
        <Element Offset="1544" Vartype="Pointer" Bytesize="8" OffsetHex="00000608" DisplayMethod="unsigned integer"/>
        <Element Offset="1548" Vartype="Pointer" Bytesize="8" OffsetHex="0000060C" DisplayMethod="unsigned integer"/>
        <Element Offset="1552" Vartype="Pointer" Bytesize="8" OffsetHex="00000610" DisplayMethod="unsigned integer"/>
        <Element Offset="1556" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000614" DisplayMethod="unsigned integer"/>
        <Element Offset="1568" Vartype="Pointer" Bytesize="8" OffsetHex="00000620" DisplayMethod="unsigned integer"/>
        <Element Offset="1572" Vartype="Pointer" Bytesize="8" OffsetHex="00000624" DisplayMethod="unsigned integer"/>
        <Element Offset="1576" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000628" DisplayMethod="unsigned integer"/>
        <Element Offset="1580" Vartype="Pointer" Bytesize="8" OffsetHex="0000062C" DisplayMethod="unsigned integer"/>
        <Element Offset="1584" Vartype="Pointer" Bytesize="8" OffsetHex="00000630" DisplayMethod="unsigned integer"/>
        <Element Offset="1588" Vartype="Pointer" Bytesize="8" OffsetHex="00000634" DisplayMethod="unsigned integer"/>
        <Element Offset="1592" Vartype="Pointer" Bytesize="8" OffsetHex="00000638" DisplayMethod="unsigned integer"/>
        <Element Offset="1596" Vartype="Pointer" Bytesize="8" OffsetHex="0000063C" DisplayMethod="unsigned integer"/>
        <Element Offset="1600" Vartype="Pointer" Bytesize="8" OffsetHex="00000640" Description="Pointer to instance of Func" DisplayMethod="unsigned integer"/>
        <Element Offset="1604" Vartype="Pointer" Bytesize="8" OffsetHex="00000644" DisplayMethod="unsigned integer"/>
        <Element Offset="1608" Vartype="Pointer" Bytesize="8" OffsetHex="00000648" DisplayMethod="unsigned integer"/>
        <Element Offset="1612" Vartype="Pointer" Bytesize="8" OffsetHex="0000064C" Description="Pointer to instance of Func" DisplayMethod="unsigned integer"/>
        <Element Offset="1616" Vartype="Pointer" Bytesize="8" OffsetHex="00000650" DisplayMethod="unsigned integer"/>
        <Element Offset="1620" Vartype="Pointer" Bytesize="8" OffsetHex="00000654" DisplayMethod="unsigned integer"/>
        <Element Offset="1624" Vartype="Pointer" Bytesize="8" OffsetHex="00000658" DisplayMethod="unsigned integer"/>
        <Element Offset="1628" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000065C" DisplayMethod="unsigned integer"/>
        <Element Offset="1632" Vartype="Pointer" Bytesize="8" OffsetHex="00000660" DisplayMethod="unsigned integer"/>
        <Element Offset="1636" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000664" DisplayMethod="hexadecimal"/>
        <Element Offset="1640" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000668" DisplayMethod="unsigned integer"/>
        <Element Offset="1644" Vartype="Pointer" Bytesize="8" OffsetHex="0000066C" Description="Pointer to instance of Object" DisplayMethod="unsigned integer"/>
        <Element Offset="1648" Vartype="Pointer" Bytesize="8" OffsetHex="00000670" DisplayMethod="unsigned integer"/>
        <Element Offset="1652" Vartype="Pointer" Bytesize="8" OffsetHex="00000674" Description="Pointer to instance of Func" DisplayMethod="unsigned integer"/>
        <Element Offset="1656" Vartype="Pointer" Bytesize="8" OffsetHex="00000678" DisplayMethod="unsigned integer"/>
        <Element Offset="1660" Vartype="Pointer" Bytesize="8" OffsetHex="0000067C" DisplayMethod="unsigned integer"/>
        <Element Offset="1664" Vartype="Pointer" Bytesize="8" OffsetHex="00000680" DisplayMethod="unsigned integer"/>
        <Element Offset="1668" Vartype="Pointer" Bytesize="8" OffsetHex="00000684" DisplayMethod="unsigned integer"/>
        <Element Offset="1672" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000688" DisplayMethod="unsigned integer"/>
        <Element Offset="1680" Vartype="Pointer" Bytesize="8" OffsetHex="00000690" DisplayMethod="unsigned integer"/>
        <Element Offset="1684" Vartype="Pointer" Bytesize="8" OffsetHex="00000694" DisplayMethod="unsigned integer"/>
        <Element Offset="1688" Vartype="Pointer" Bytesize="8" OffsetHex="00000698" DisplayMethod="unsigned integer"/>
        <Element Offset="1692" Vartype="Pointer" Bytesize="8" OffsetHex="0000069C" DisplayMethod="unsigned integer"/>
        <Element Offset="1696" Vartype="Pointer" Bytesize="8" OffsetHex="000006A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1700" Vartype="Pointer" Bytesize="8" OffsetHex="000006A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1704" Vartype="Pointer" Bytesize="8" OffsetHex="000006A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1708" Vartype="Pointer" Bytesize="8" OffsetHex="000006AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1712" Vartype="Pointer" Bytesize="8" OffsetHex="000006B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1716" Vartype="Pointer" Bytesize="8" OffsetHex="000006B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1720" Vartype="Pointer" Bytesize="8" OffsetHex="000006B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1724" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1728" Vartype="Pointer" Bytesize="8" OffsetHex="000006C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1732" Vartype="Pointer" Bytesize="8" OffsetHex="000006C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1736" Vartype="Pointer" Bytesize="8" OffsetHex="000006C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1740" Vartype="Pointer" Bytesize="8" OffsetHex="000006CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1744" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1748" Vartype="Pointer" Bytesize="8" OffsetHex="000006D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1752" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1756" Vartype="Pointer" Bytesize="8" OffsetHex="000006DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1760" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1764" Vartype="Pointer" Bytesize="8" OffsetHex="000006E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1768" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000006E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1780" Vartype="Pointer" Bytesize="8" OffsetHex="000006F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1784" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1788" Vartype="Pointer" Bytesize="8" OffsetHex="000006FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1792" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000700" DisplayMethod="unsigned integer"/>
        <Element Offset="1796" Vartype="Pointer" Bytesize="8" OffsetHex="00000704" DisplayMethod="unsigned integer"/>
        <Element Offset="1800" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000708" DisplayMethod="unsigned integer"/>
        <Element Offset="1804" Vartype="Pointer" Bytesize="8" OffsetHex="0000070C" DisplayMethod="unsigned integer"/>
        <Element Offset="1808" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000710" DisplayMethod="unsigned integer"/>
        <Element Offset="1812" Vartype="Pointer" Bytesize="8" OffsetHex="00000714" DisplayMethod="unsigned integer"/>
        <Element Offset="1816" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000718" DisplayMethod="unsigned integer"/>
        <Element Offset="1824" Vartype="Pointer" Bytesize="8" OffsetHex="00000720" DisplayMethod="unsigned integer"/>
        <Element Offset="1828" Vartype="Pointer" Bytesize="8" OffsetHex="00000724" DisplayMethod="unsigned integer"/>
        <Element Offset="1832" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000728" DisplayMethod="unsigned integer"/>
        <Element Offset="1836" Vartype="Pointer" Bytesize="8" OffsetHex="0000072C" DisplayMethod="unsigned integer"/>
        <Element Offset="1840" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000730" DisplayMethod="unsigned integer"/>
        <Element Offset="1844" Vartype="Pointer" Bytesize="8" OffsetHex="00000734" DisplayMethod="unsigned integer"/>
        <Element Offset="1848" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000738" DisplayMethod="unsigned integer"/>
        <Element Offset="1852" Vartype="Pointer" Bytesize="8" OffsetHex="0000073C" DisplayMethod="unsigned integer"/>
        <Element Offset="1856" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000740" DisplayMethod="unsigned integer"/>
        <Element Offset="1860" Vartype="Pointer" Bytesize="8" OffsetHex="00000744" DisplayMethod="unsigned integer"/>
        <Element Offset="1864" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000748" DisplayMethod="unsigned integer"/>
        <Element Offset="1868" Vartype="Pointer" Bytesize="8" OffsetHex="0000074C" DisplayMethod="unsigned integer"/>
        <Element Offset="1872" Vartype="Pointer" Bytesize="8" OffsetHex="00000750" DisplayMethod="unsigned integer"/>
        <Element Offset="1876" Vartype="Pointer" Bytesize="8" OffsetHex="00000754" DisplayMethod="unsigned integer"/>
        <Element Offset="1880" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000758" DisplayMethod="unsigned integer"/>
        <Element Offset="1888" Vartype="Pointer" Bytesize="8" OffsetHex="00000760" DisplayMethod="unsigned integer"/>
        <Element Offset="1892" Vartype="Pointer" Bytesize="8" OffsetHex="00000764" DisplayMethod="unsigned integer"/>
        <Element Offset="1896" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000768" DisplayMethod="unsigned integer"/>
        <Element Offset="1900" Vartype="Pointer" Bytesize="8" OffsetHex="0000076C" DisplayMethod="unsigned integer"/>
        <Element Offset="1904" Vartype="Pointer" Bytesize="8" OffsetHex="00000770" DisplayMethod="unsigned integer"/>
        <Element Offset="1908" Vartype="Pointer" Bytesize="8" OffsetHex="00000774" DisplayMethod="unsigned integer"/>
        <Element Offset="1912" Vartype="Pointer" Bytesize="8" OffsetHex="00000778" DisplayMethod="unsigned integer"/>
        <Element Offset="1916" Vartype="Pointer" Bytesize="8" OffsetHex="0000077C" Description="Pointer to instance of Object" DisplayMethod="unsigned integer"/>
        <Element Offset="1920" Vartype="Pointer" Bytesize="8" OffsetHex="00000780" DisplayMethod="unsigned integer"/>
        <Element Offset="1924" Vartype="Pointer" Bytesize="8" OffsetHex="00000784" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1932" Vartype="Pointer" Bytesize="8" OffsetHex="0000078C" DisplayMethod="unsigned integer"/>
        <Element Offset="1936" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000790" DisplayMethod="unsigned integer"/>
        <Element Offset="1940" Vartype="Pointer" Bytesize="8" OffsetHex="00000794" DisplayMethod="unsigned integer"/>
        <Element Offset="1944" Vartype="Pointer" Bytesize="8" OffsetHex="00000798" DisplayMethod="unsigned integer"/>
        <Element Offset="1948" Vartype="Pointer" Bytesize="8" OffsetHex="0000079C" Description="Pointer to instance of Object" DisplayMethod="unsigned integer"/>
        <Element Offset="1952" Vartype="Pointer" Bytesize="8" OffsetHex="000007A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1956" Vartype="Pointer" Bytesize="8" OffsetHex="000007A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1960" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1964" Vartype="Pointer" Bytesize="8" OffsetHex="000007AC" Description="Pointer to instance of Object" DisplayMethod="unsigned integer"/>
        <Element Offset="1968" Vartype="Pointer" Bytesize="8" OffsetHex="000007B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1972" Vartype="Pointer" Bytesize="8" OffsetHex="000007B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1976" Vartype="Pointer" Bytesize="8" OffsetHex="000007B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1980" Vartype="Pointer" Bytesize="8" OffsetHex="000007BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1984" Vartype="Pointer" Bytesize="8" OffsetHex="000007C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1988" Vartype="Pointer" Bytesize="8" OffsetHex="000007C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1992" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000007C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2000" Vartype="Pointer" Bytesize="8" OffsetHex="000007D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2004" Vartype="Pointer" Bytesize="8" OffsetHex="000007D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2008" Vartype="Pointer" Bytesize="8" OffsetHex="000007D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2012" Vartype="Pointer" Bytesize="8" OffsetHex="000007DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="Pointer" Bytesize="8" OffsetHex="000007E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2020" Vartype="Pointer" Bytesize="8" OffsetHex="000007E4" Description="Pointer to instance of ExprOpFunc" DisplayMethod="unsigned integer"/>
        <Element Offset="2024" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000007E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2032" Vartype="Pointer" Bytesize="8" OffsetHex="000007F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2036" Vartype="Pointer" Bytesize="8" OffsetHex="000007F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2040" Vartype="Pointer" Bytesize="8" OffsetHex="000007F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2044" Vartype="Pointer" Bytesize="8" OffsetHex="000007FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2048" Vartype="Pointer" Bytesize="8" OffsetHex="00000800" DisplayMethod="unsigned integer"/>
        <Element Offset="2052" Vartype="Pointer" Bytesize="8" OffsetHex="00000804" Description="Pointer to instance of ExprOpFunc" DisplayMethod="unsigned integer"/>
        <Element Offset="2056" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000808" DisplayMethod="unsigned integer"/>
        <Element Offset="2064" Vartype="Pointer" Bytesize="8" OffsetHex="00000810" DisplayMethod="unsigned integer"/>
        <Element Offset="2068" Vartype="Pointer" Bytesize="8" OffsetHex="00000814" DisplayMethod="unsigned integer"/>
        <Element Offset="2072" Vartype="Pointer" Bytesize="8" OffsetHex="00000818" DisplayMethod="unsigned integer"/>
        <Element Offset="2076" Vartype="Pointer" Bytesize="8" OffsetHex="0000081C" DisplayMethod="unsigned integer"/>
        <Element Offset="2080" Vartype="Pointer" Bytesize="8" OffsetHex="00000820" DisplayMethod="unsigned integer"/>
        <Element Offset="2084" Vartype="Pointer" Bytesize="8" OffsetHex="00000824" DisplayMethod="unsigned integer"/>
        <Element Offset="2088" Vartype="Pointer" Bytesize="8" OffsetHex="00000828" DisplayMethod="unsigned integer"/>
        <Element Offset="2092" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000082C" DisplayMethod="unsigned integer"/>
        <Element Offset="2100" Vartype="Pointer" Bytesize="8" OffsetHex="00000834" DisplayMethod="unsigned integer"/>
        <Element Offset="2104" Vartype="Pointer" Bytesize="8" OffsetHex="00000838" DisplayMethod="unsigned integer"/>
        <Element Offset="2108" Vartype="Pointer" Bytesize="8" OffsetHex="0000083C" DisplayMethod="unsigned integer"/>
        <Element Offset="2112" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000840" DisplayMethod="unsigned integer"/>
        <Element Offset="2132" Vartype="Pointer" Bytesize="8" OffsetHex="00000854" DisplayMethod="unsigned integer"/>
        <Element Offset="2136" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000858" DisplayMethod="unsigned integer"/>
        <Element Offset="2148" Vartype="Pointer" Bytesize="8" OffsetHex="00000864" DisplayMethod="unsigned integer"/>
        <Element Offset="2152" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000868" DisplayMethod="unsigned integer"/>
        <Element Offset="2160" Vartype="Pointer" Bytesize="8" OffsetHex="00000870" DisplayMethod="unsigned integer"/>
        <Element Offset="2164" Vartype="Pointer" Bytesize="8" OffsetHex="00000874" DisplayMethod="unsigned integer"/>
        <Element Offset="2168" Vartype="Pointer" Bytesize="8" OffsetHex="00000878" DisplayMethod="unsigned integer"/>
        <Element Offset="2172" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000087C" DisplayMethod="unsigned integer"/>
        <Element Offset="2176" Vartype="Pointer" Bytesize="8" OffsetHex="00000880" DisplayMethod="unsigned integer"/>
        <Element Offset="2180" Vartype="Pointer" Bytesize="8" OffsetHex="00000884" DisplayMethod="unsigned integer"/>
        <Element Offset="2184" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000888" DisplayMethod="unsigned integer"/>
        <Element Offset="2192" Vartype="Pointer" Bytesize="8" OffsetHex="00000890" DisplayMethod="unsigned integer"/>
        <Element Offset="2196" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000894" DisplayMethod="unsigned integer"/>
        <Element Offset="2200" Vartype="Pointer" Bytesize="8" OffsetHex="00000898" DisplayMethod="unsigned integer"/>
        <Element Offset="2204" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000089C" DisplayMethod="unsigned integer"/>
        <Element Offset="2208" Vartype="Pointer" Bytesize="8" OffsetHex="000008A0" DisplayMethod="unsigned integer"/>
        <Element Offset="2212" Vartype="Pointer" Bytesize="8" OffsetHex="000008A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2216" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008A8" DisplayMethod="unsigned integer"/>
        <Element Offset="2224" Vartype="Pointer" Bytesize="8" OffsetHex="000008B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2228" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008B4" DisplayMethod="unsigned integer"/>
        <Element Offset="2232" Vartype="Pointer" Bytesize="8" OffsetHex="000008B8" DisplayMethod="unsigned integer"/>
        <Element Offset="2236" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000008BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2252" Vartype="Pointer" Bytesize="8" OffsetHex="000008CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2256" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2260" Vartype="Pointer" Bytesize="8" OffsetHex="000008D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2264" Vartype="Pointer" Bytesize="8" OffsetHex="000008D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2268" Vartype="Pointer" Bytesize="8" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2272" Vartype="Pointer" Bytesize="8" OffsetHex="000008E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2276" Vartype="Pointer" Bytesize="8" OffsetHex="000008E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2280" Vartype="Pointer" Bytesize="8" OffsetHex="000008E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2284" Vartype="Pointer" Bytesize="8" OffsetHex="000008EC" DisplayMethod="unsigned integer"/>
        <Element Offset="2288" Vartype="Pointer" Bytesize="8" OffsetHex="000008F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2292" Vartype="4 Bytes" Bytesize="4" OffsetHex="000008F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2296" Vartype="Pointer" Bytesize="8" OffsetHex="000008F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2300" Vartype="Pointer" Bytesize="8" OffsetHex="000008FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2304" Vartype="Pointer" Bytesize="8" OffsetHex="00000900" DisplayMethod="unsigned integer"/>
        <Element Offset="2308" Vartype="Pointer" Bytesize="8" OffsetHex="00000904" DisplayMethod="unsigned integer"/>
        <Element Offset="2312" Vartype="Pointer" Bytesize="8" OffsetHex="00000908" DisplayMethod="unsigned integer"/>
        <Element Offset="2316" Vartype="Pointer" Bytesize="8" OffsetHex="0000090C" DisplayMethod="unsigned integer"/>
        <Element Offset="2320" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000910" DisplayMethod="unsigned integer"/>
        <Element Offset="2328" Vartype="Pointer" Bytesize="8" OffsetHex="00000918" DisplayMethod="unsigned integer"/>
        <Element Offset="2332" Vartype="Pointer" Bytesize="8" OffsetHex="0000091C" DisplayMethod="unsigned integer"/>
        <Element Offset="2336" Vartype="Pointer" Bytesize="8" OffsetHex="00000920" DisplayMethod="unsigned integer"/>
        <Element Offset="2340" Vartype="Pointer" Bytesize="8" OffsetHex="00000924" DisplayMethod="unsigned integer"/>
        <Element Offset="2344" Vartype="Pointer" Bytesize="8" OffsetHex="00000928" DisplayMethod="unsigned integer"/>
        <Element Offset="2348" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000092C" DisplayMethod="unsigned integer"/>
        <Element Offset="2352" Vartype="Pointer" Bytesize="8" OffsetHex="00000930" DisplayMethod="unsigned integer"/>
        <Element Offset="2356" Vartype="Pointer" Bytesize="8" OffsetHex="00000934" DisplayMethod="unsigned integer"/>
        <Element Offset="2360" Vartype="Pointer" Bytesize="8" OffsetHex="00000938" DisplayMethod="unsigned integer"/>
        <Element Offset="2364" Vartype="Pointer" Bytesize="8" OffsetHex="0000093C" DisplayMethod="unsigned integer"/>
        <Element Offset="2368" Vartype="Pointer" Bytesize="8" OffsetHex="00000940" DisplayMethod="unsigned integer"/>
        <Element Offset="2372" Vartype="Pointer" Bytesize="8" OffsetHex="00000944" DisplayMethod="unsigned integer"/>
        <Element Offset="2376" Vartype="Pointer" Bytesize="8" OffsetHex="00000948" DisplayMethod="unsigned integer"/>
        <Element Offset="2380" Vartype="Pointer" Bytesize="8" OffsetHex="0000094C" DisplayMethod="unsigned integer"/>
        <Element Offset="2384" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000950" DisplayMethod="unsigned integer"/>
        <Element Offset="2388" Vartype="Pointer" Bytesize="8" OffsetHex="00000954" DisplayMethod="unsigned integer"/>
        <Element Offset="2392" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000958" DisplayMethod="unsigned integer"/>
        <Element Offset="2396" Vartype="Pointer" Bytesize="8" OffsetHex="0000095C" DisplayMethod="unsigned integer"/>
        <Element Offset="2400" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000960" DisplayMethod="unsigned integer"/>
        <Element Offset="2424" Vartype="Pointer" Bytesize="8" OffsetHex="00000978" DisplayMethod="unsigned integer"/>
        <Element Offset="2428" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000097C" DisplayMethod="unsigned integer"/>
        <Element Offset="2432" Vartype="Pointer" Bytesize="8" OffsetHex="00000980" DisplayMethod="unsigned integer"/>
        <Element Offset="2436" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000984" DisplayMethod="unsigned integer"/>
        <Element Offset="2440" Vartype="Pointer" Bytesize="8" OffsetHex="00000988" DisplayMethod="unsigned integer"/>
        <Element Offset="2444" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000098C" DisplayMethod="unsigned integer"/>
        <Element Offset="2448" Vartype="Pointer" Bytesize="8" OffsetHex="00000990" DisplayMethod="unsigned integer"/>
        <Element Offset="2452" Vartype="Pointer" Bytesize="8" OffsetHex="00000994" DisplayMethod="unsigned integer"/>
        <Element Offset="2456" Vartype="Pointer" Bytesize="8" OffsetHex="00000998" DisplayMethod="unsigned integer"/>
        <Element Offset="2460" Vartype="Pointer" Bytesize="8" OffsetHex="0000099C" DisplayMethod="unsigned integer"/>
        <Element Offset="2464" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009A0" DisplayMethod="unsigned integer"/>
        <Element Offset="2468" Vartype="Pointer" Bytesize="8" OffsetHex="000009A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2472" Vartype="Pointer" Bytesize="8" OffsetHex="000009A8" DisplayMethod="unsigned integer"/>
        <Element Offset="2476" Vartype="Pointer" Bytesize="8" OffsetHex="000009AC" DisplayMethod="unsigned integer"/>
        <Element Offset="2480" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2484" Vartype="Pointer" Bytesize="8" OffsetHex="000009B4" DisplayMethod="unsigned integer"/>
        <Element Offset="2488" Vartype="Pointer" Bytesize="8" OffsetHex="000009B8" DisplayMethod="unsigned integer"/>
        <Element Offset="2492" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000009BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2508" Vartype="Pointer" Bytesize="8" OffsetHex="000009CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2512" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2516" Vartype="Unicode String" Bytesize="8" OffsetHex="000009D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2524" Vartype="Unicode String" Bytesize="4" OffsetHex="000009DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2528" Vartype="4 Bytes" Bytesize="4" OffsetHex="000009E0" DisplayMethod="hexadecimal"/>
        <Element Offset="2532" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2540" Vartype="Pointer" Bytesize="8" OffsetHex="000009EC" DisplayMethod="unsigned integer"/>
        <Element Offset="2544" Vartype="Pointer" Bytesize="8" OffsetHex="000009F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2548" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="000009F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2572" Vartype="Pointer" Bytesize="8" OffsetHex="00000A0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2576" Vartype="Pointer" Bytesize="8" OffsetHex="00000A10" DisplayMethod="unsigned integer"/>
        <Element Offset="2580" Vartype="Pointer" Bytesize="8" OffsetHex="00000A14" DisplayMethod="unsigned integer"/>
        <Element Offset="2584" Vartype="Pointer" Bytesize="8" OffsetHex="00000A18" Description="Pointer to instance of ExprOpFunc" DisplayMethod="unsigned integer"/>
        <Element Offset="2588" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000A1C" DisplayMethod="unsigned integer"/>
        <Element Offset="2604" Vartype="Pointer" Bytesize="8" OffsetHex="00000A2C" DisplayMethod="unsigned integer"/>
        <Element Offset="2608" Vartype="Pointer" Bytesize="8" OffsetHex="00000A30" DisplayMethod="unsigned integer"/>
        <Element Offset="2612" Vartype="Pointer" Bytesize="8" OffsetHex="00000A34" DisplayMethod="unsigned integer"/>
        <Element Offset="2616" Vartype="Pointer" Bytesize="8" OffsetHex="00000A38" Description="Pointer to instance of ExprOpFunc" DisplayMethod="unsigned integer"/>
        <Element Offset="2620" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000A3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2636" Vartype="Pointer" Bytesize="8" OffsetHex="00000A4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2640" Vartype="Pointer" Bytesize="8" OffsetHex="00000A50" DisplayMethod="unsigned integer"/>
        <Element Offset="2644" Vartype="Pointer" Bytesize="8" OffsetHex="00000A54" DisplayMethod="unsigned integer"/>
        <Element Offset="2648" Vartype="Pointer" Bytesize="8" OffsetHex="00000A58" Description="Pointer to instance of ExprOpFunc" DisplayMethod="unsigned integer"/>
        <Element Offset="2652" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000A5C" DisplayMethod="unsigned integer"/>
        <Element Offset="2668" Vartype="Pointer" Bytesize="8" OffsetHex="00000A6C" DisplayMethod="unsigned integer"/>
        <Element Offset="2672" Vartype="Pointer" Bytesize="8" OffsetHex="00000A70" DisplayMethod="unsigned integer"/>
        <Element Offset="2676" Vartype="Pointer" Bytesize="8" OffsetHex="00000A74" DisplayMethod="unsigned integer"/>
        <Element Offset="2680" Vartype="Pointer" Bytesize="8" OffsetHex="00000A78" DisplayMethod="unsigned integer"/>
        <Element Offset="2684" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000A7C" DisplayMethod="unsigned integer"/>
        <Element Offset="2700" Vartype="Pointer" Bytesize="8" OffsetHex="00000A8C" Description="Pointer to instance of Func" DisplayMethod="unsigned integer"/>
        <Element Offset="2704" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000A90" DisplayMethod="unsigned integer"/>
        <Element Offset="2716" Vartype="Pointer" Bytesize="8" OffsetHex="00000A9C" DisplayMethod="unsigned integer"/>
        <Element Offset="2720" Vartype="Pointer" Bytesize="8" OffsetHex="00000AA0" DisplayMethod="unsigned integer"/>
        <Element Offset="2724" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AA4" DisplayMethod="unsigned integer"/>
        <Element Offset="2728" Vartype="Pointer" Bytesize="8" OffsetHex="00000AA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2732" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000AAC" DisplayMethod="unsigned integer"/>
        <Element Offset="2740" Vartype="Pointer" Bytesize="8" OffsetHex="00000AB4" DisplayMethod="unsigned integer"/>
        <Element Offset="2744" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AB8" DisplayMethod="unsigned integer"/>
        <Element Offset="2748" Vartype="Pointer" Bytesize="8" OffsetHex="00000ABC" DisplayMethod="unsigned integer"/>
        <Element Offset="2752" Vartype="Pointer" Bytesize="8" OffsetHex="00000AC0" DisplayMethod="unsigned integer"/>
        <Element Offset="2756" Vartype="Pointer" Bytesize="8" OffsetHex="00000AC4" DisplayMethod="unsigned integer"/>
        <Element Offset="2760" Vartype="Pointer" Bytesize="8" OffsetHex="00000AC8" DisplayMethod="unsigned integer"/>
        <Element Offset="2764" Vartype="Pointer" Bytesize="8" OffsetHex="00000ACC" DisplayMethod="unsigned integer"/>
        <Element Offset="2768" Vartype="Pointer" Bytesize="8" OffsetHex="00000AD0" DisplayMethod="unsigned integer"/>
        <Element Offset="2772" Vartype="Pointer" Bytesize="8" OffsetHex="00000AD4" DisplayMethod="unsigned integer"/>
        <Element Offset="2776" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AD8" DisplayMethod="unsigned integer"/>
        <Element Offset="2780" Vartype="Pointer" Bytesize="8" OffsetHex="00000ADC" DisplayMethod="unsigned integer"/>
        <Element Offset="2784" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000AE0" DisplayMethod="unsigned integer"/>
        <Element Offset="2788" Vartype="Pointer" Bytesize="8" OffsetHex="00000AE4" DisplayMethod="unsigned integer"/>
        <Element Offset="2792" Vartype="Pointer" Bytesize="8" OffsetHex="00000AE8" Description="Pointer to instance of ExprOpFunc" DisplayMethod="unsigned integer"/>
        <Element Offset="2796" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000AEC" DisplayMethod="unsigned integer"/>
        <Element Offset="2812" Vartype="Pointer" Bytesize="8" OffsetHex="00000AFC" DisplayMethod="unsigned integer"/>
        <Element Offset="2816" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B00" DisplayMethod="unsigned integer"/>
        <Element Offset="2820" Vartype="Pointer" Bytesize="8" OffsetHex="00000B04" DisplayMethod="unsigned integer"/>
        <Element Offset="2824" Vartype="Pointer" Bytesize="8" OffsetHex="00000B08" DisplayMethod="unsigned integer"/>
        <Element Offset="2828" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000B0C" DisplayMethod="unsigned integer"/>
        <Element Offset="2844" Vartype="Pointer" Bytesize="8" OffsetHex="00000B1C" DisplayMethod="unsigned integer"/>
        <Element Offset="2848" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B20" DisplayMethod="unsigned integer"/>
        <Element Offset="2852" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B24" DisplayMethod="hexadecimal"/>
        <Element Offset="2856" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000B28" DisplayMethod="unsigned integer"/>
        <Element Offset="2876" Vartype="Pointer" Bytesize="8" OffsetHex="00000B3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2880" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B40" DisplayMethod="unsigned integer"/>
        <Element Offset="2884" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B44" DisplayMethod="hexadecimal"/>
        <Element Offset="2888" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000B48" DisplayMethod="unsigned integer"/>
        <Element Offset="2892" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000B4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2896" Vartype="Pointer" Bytesize="8" OffsetHex="00000B50" DisplayMethod="unsigned integer"/>
        <Element Offset="2900" Vartype="Pointer" Bytesize="8" OffsetHex="00000B54" DisplayMethod="unsigned integer"/>
        <Element Offset="2904" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000B58" DisplayMethod="unsigned integer"/>
        <Element Offset="2940" Vartype="Pointer" Bytesize="8" OffsetHex="00000B7C" DisplayMethod="unsigned integer"/>
        <Element Offset="2944" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000B80" DisplayMethod="unsigned integer"/>
        <Element Offset="2947" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000B83" DisplayMethod="unsigned integer"/>
        <Element Offset="2949" Vartype="Byte" Bytesize="1" RLECount="7" OffsetHex="00000B85" DisplayMethod="unsigned integer"/>
        <Element Offset="2956" Vartype="Pointer" Bytesize="8" OffsetHex="00000B8C" DisplayMethod="unsigned integer"/>
        <Element Offset="2960" Vartype="Pointer" Bytesize="8" OffsetHex="00000B90" DisplayMethod="unsigned integer"/>
        <Element Offset="2964" Vartype="Pointer" Bytesize="8" OffsetHex="00000B94" DisplayMethod="unsigned integer"/>
        <Element Offset="2968" Vartype="Pointer" Bytesize="8" OffsetHex="00000B98" DisplayMethod="unsigned integer"/>
        <Element Offset="2972" Vartype="Pointer" Bytesize="8" OffsetHex="00000B9C" DisplayMethod="unsigned integer"/>
        <Element Offset="2976" Vartype="Double" Bytesize="8" OffsetHex="00000BA0" DisplayMethod="unsigned integer"/>
        <Element Offset="2984" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000BA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2996" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000BB4" DisplayMethod="hexadecimal"/>
        <Element Offset="3000" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000BB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3008" Vartype="Double" Bytesize="8" OffsetHex="00000BC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3016" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="00000BC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3068" Vartype="Pointer" Bytesize="8" OffsetHex="00000BFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3072" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C00" DisplayMethod="unsigned integer"/>
        <Element Offset="3076" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C04" DisplayMethod="hexadecimal"/>
        <Element Offset="3080" Vartype="Double" Bytesize="8" OffsetHex="00000C08" DisplayMethod="unsigned integer"/>
        <Element Offset="3088" Vartype="Pointer" Bytesize="8" OffsetHex="00000C10" DisplayMethod="unsigned integer"/>
        <Element Offset="3092" Vartype="Pointer" Bytesize="8" OffsetHex="00000C14" DisplayMethod="unsigned integer"/>
        <Element Offset="3096" Vartype="Pointer" Bytesize="8" OffsetHex="00000C18" DisplayMethod="unsigned integer"/>
        <Element Offset="3100" Vartype="Pointer" Bytesize="8" OffsetHex="00000C1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3104" Vartype="Pointer" Bytesize="8" OffsetHex="00000C20" DisplayMethod="unsigned integer"/>
        <Element Offset="3108" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C24" DisplayMethod="unsigned integer"/>
        <Element Offset="3112" Vartype="Pointer" Bytesize="8" OffsetHex="00000C28" DisplayMethod="unsigned integer"/>
        <Element Offset="3116" Vartype="Pointer" Bytesize="8" OffsetHex="00000C2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3120" Vartype="Double" Bytesize="8" OffsetHex="00000C30" DisplayMethod="unsigned integer"/>
        <Element Offset="3128" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000C38" DisplayMethod="unsigned integer"/>
        <Element Offset="3140" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C44" DisplayMethod="hexadecimal"/>
        <Element Offset="3144" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C48" DisplayMethod="unsigned integer"/>
        <Element Offset="3152" Vartype="Double" Bytesize="8" OffsetHex="00000C50" DisplayMethod="unsigned integer"/>
        <Element Offset="3160" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="00000C58" DisplayMethod="unsigned integer"/>
        <Element Offset="3212" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C8C" DisplayMethod="hexadecimal"/>
        <Element Offset="3216" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C90" DisplayMethod="unsigned integer"/>
        <Element Offset="3220" Vartype="Pointer" Bytesize="8" OffsetHex="00000C94" DisplayMethod="unsigned integer"/>
        <Element Offset="3224" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000C98" DisplayMethod="unsigned integer"/>
        <Element Offset="3228" Vartype="Pointer" Bytesize="8" OffsetHex="00000C9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3232" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3236" Vartype="Double" Bytesize="8" OffsetHex="00000CA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3244" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000CAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3256" Vartype="Pointer" Bytesize="8" OffsetHex="00000CB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3260" Vartype="Pointer" Bytesize="8" OffsetHex="00000CBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3264" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000CC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3272" Vartype="Pointer" Bytesize="8" OffsetHex="00000CC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3276" Vartype="Pointer" Bytesize="8" OffsetHex="00000CCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3280" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000CD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3288" Vartype="Pointer" Bytesize="8" OffsetHex="00000CD8" DisplayMethod="unsigned integer"/>
        <Element Offset="3292" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3296" Vartype="Pointer" Bytesize="8" OffsetHex="00000CE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3300" Vartype="Pointer" Bytesize="8" OffsetHex="00000CE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3304" Vartype="Pointer" Bytesize="8" OffsetHex="00000CE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3308" Vartype="Pointer" Bytesize="8" OffsetHex="00000CEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3312" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3316" Vartype="Pointer" Bytesize="8" OffsetHex="00000CF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3320" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000CF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3324" Vartype="Pointer" Bytesize="8" OffsetHex="00000CFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3328" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D00" DisplayMethod="unsigned integer"/>
        <Element Offset="3332" Vartype="Pointer" Bytesize="8" OffsetHex="00000D04" DisplayMethod="unsigned integer"/>
        <Element Offset="3336" Vartype="Pointer" Bytesize="8" OffsetHex="00000D08" DisplayMethod="unsigned integer"/>
        <Element Offset="3340" Vartype="Pointer" Bytesize="8" OffsetHex="00000D0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3344" Vartype="Pointer" Bytesize="8" OffsetHex="00000D10" DisplayMethod="unsigned integer"/>
        <Element Offset="3348" Vartype="Pointer" Bytesize="8" OffsetHex="00000D14" DisplayMethod="unsigned integer"/>
        <Element Offset="3352" Vartype="Pointer" Bytesize="8" OffsetHex="00000D18" DisplayMethod="unsigned integer"/>
        <Element Offset="3356" Vartype="Pointer" Bytesize="8" OffsetHex="00000D1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3360" Vartype="Pointer" Bytesize="8" OffsetHex="00000D20" DisplayMethod="unsigned integer"/>
        <Element Offset="3364" Vartype="Pointer" Bytesize="8" OffsetHex="00000D24" DisplayMethod="unsigned integer"/>
        <Element Offset="3368" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D28" DisplayMethod="unsigned integer"/>
        <Element Offset="3372" Vartype="Pointer" Bytesize="8" OffsetHex="00000D2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3376" Vartype="Pointer" Bytesize="8" OffsetHex="00000D30" DisplayMethod="unsigned integer"/>
        <Element Offset="3380" Vartype="Pointer" Bytesize="8" OffsetHex="00000D34" DisplayMethod="unsigned integer"/>
        <Element Offset="3384" Vartype="Pointer" Bytesize="8" OffsetHex="00000D38" DisplayMethod="unsigned integer"/>
        <Element Offset="3388" Vartype="Pointer" Bytesize="8" OffsetHex="00000D3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3392" Vartype="Pointer" Bytesize="8" OffsetHex="00000D40" DisplayMethod="unsigned integer"/>
        <Element Offset="3396" Vartype="Pointer" Bytesize="8" OffsetHex="00000D44" DisplayMethod="unsigned integer"/>
        <Element Offset="3400" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D48" DisplayMethod="unsigned integer"/>
        <Element Offset="3404" Vartype="Pointer" Bytesize="8" OffsetHex="00000D4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3408" Vartype="Pointer" Bytesize="8" OffsetHex="00000D50" DisplayMethod="unsigned integer"/>
        <Element Offset="3412" Vartype="Pointer" Bytesize="8" OffsetHex="00000D54" DisplayMethod="unsigned integer"/>
        <Element Offset="3416" Vartype="Pointer" Bytesize="8" OffsetHex="00000D58" DisplayMethod="unsigned integer"/>
        <Element Offset="3420" Vartype="Pointer" Bytesize="8" OffsetHex="00000D5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3424" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D60" DisplayMethod="unsigned integer"/>
        <Element Offset="3432" Vartype="Pointer" Bytesize="8" OffsetHex="00000D68" DisplayMethod="unsigned integer"/>
        <Element Offset="3436" Vartype="Pointer" Bytesize="8" OffsetHex="00000D6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3440" Vartype="Pointer" Bytesize="8" OffsetHex="00000D70" DisplayMethod="unsigned integer"/>
        <Element Offset="3444" Vartype="Pointer" Bytesize="8" OffsetHex="00000D74" DisplayMethod="unsigned integer"/>
        <Element Offset="3448" Vartype="Pointer" Bytesize="8" OffsetHex="00000D78" DisplayMethod="unsigned integer"/>
        <Element Offset="3452" Vartype="Pointer" Bytesize="8" OffsetHex="00000D7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3456" Vartype="Pointer" Bytesize="8" OffsetHex="00000D80" DisplayMethod="unsigned integer"/>
        <Element Offset="3460" Vartype="Pointer" Bytesize="8" OffsetHex="00000D84" DisplayMethod="unsigned integer"/>
        <Element Offset="3464" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000D88" DisplayMethod="unsigned integer"/>
        <Element Offset="3468" Vartype="Pointer" Bytesize="8" OffsetHex="00000D8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3472" Vartype="Pointer" Bytesize="8" OffsetHex="00000D90" DisplayMethod="unsigned integer"/>
        <Element Offset="3476" Vartype="Pointer" Bytesize="8" OffsetHex="00000D94" DisplayMethod="unsigned integer"/>
        <Element Offset="3480" Vartype="Pointer" Bytesize="8" OffsetHex="00000D98" DisplayMethod="unsigned integer"/>
        <Element Offset="3484" Vartype="Pointer" Bytesize="8" OffsetHex="00000D9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3488" Vartype="Pointer" Bytesize="8" OffsetHex="00000DA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3492" Vartype="Pointer" Bytesize="8" OffsetHex="00000DA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3496" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3500" Vartype="Pointer" Bytesize="8" OffsetHex="00000DAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3504" Vartype="Pointer" Bytesize="8" OffsetHex="00000DB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3508" Vartype="Pointer" Bytesize="8" OffsetHex="00000DB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3512" Vartype="Pointer" Bytesize="8" OffsetHex="00000DB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3516" Vartype="Pointer" Bytesize="8" OffsetHex="00000DBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3520" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DC0" DisplayMethod="unsigned integer"/>
        <Element Offset="3524" Vartype="Pointer" Bytesize="8" OffsetHex="00000DC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3528" Vartype="Pointer" Bytesize="8" OffsetHex="00000DC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3532" Vartype="Pointer" Bytesize="8" OffsetHex="00000DCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3536" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3540" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD4" DisplayMethod="unsigned integer"/>
        <Element Offset="3544" Vartype="Pointer" Bytesize="8" OffsetHex="00000DD8" DisplayMethod="unsigned integer"/>
        <Element Offset="3548" Vartype="Pointer" Bytesize="8" OffsetHex="00000DDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3552" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3556" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3560" Vartype="Pointer" Bytesize="8" OffsetHex="00000DE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3564" Vartype="Pointer" Bytesize="8" OffsetHex="00000DEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3568" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3572" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000DF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3576" Vartype="Pointer" Bytesize="8" OffsetHex="00000DF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3580" Vartype="Pointer" Bytesize="8" OffsetHex="00000DFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3584" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000E00" DisplayMethod="unsigned integer"/>
        <Element Offset="3596" Vartype="Pointer" Bytesize="8" OffsetHex="00000E0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3600" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E10" DisplayMethod="unsigned integer"/>
        <Element Offset="3604" Vartype="Pointer" Bytesize="8" OffsetHex="00000E14" DisplayMethod="unsigned integer"/>
        <Element Offset="3608" Vartype="Pointer" Bytesize="8" OffsetHex="00000E18" DisplayMethod="unsigned integer"/>
        <Element Offset="3612" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000E1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3636" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000E34" DisplayMethod="unsigned integer"/>
        <Element Offset="3640" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E38" DisplayMethod="unsigned integer"/>
        <Element Offset="3644" Vartype="Pointer" Bytesize="8" OffsetHex="00000E3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3648" Vartype="Pointer" Bytesize="8" OffsetHex="00000E40" DisplayMethod="unsigned integer"/>
        <Element Offset="3652" Vartype="Byte" Bytesize="1" OffsetHex="00000E44" DisplayMethod="unsigned integer"/>
        <Element Offset="3653" Vartype="String" Bytesize="4" OffsetHex="00000E45" DisplayMethod="unsigned integer"/>
        <Element Offset="3657" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E49" DisplayMethod="unsigned integer"/>
        <Element Offset="3660" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3668" Vartype="Pointer" Bytesize="8" OffsetHex="00000E54" DisplayMethod="unsigned integer"/>
        <Element Offset="3672" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E58" DisplayMethod="unsigned integer"/>
        <Element Offset="3676" Vartype="Pointer" Bytesize="8" OffsetHex="00000E5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3680" Vartype="Pointer" Bytesize="8" OffsetHex="00000E60" DisplayMethod="unsigned integer"/>
        <Element Offset="3684" Vartype="Pointer" Bytesize="8" OffsetHex="00000E64" DisplayMethod="unsigned integer"/>
        <Element Offset="3688" Vartype="Pointer" Bytesize="8" OffsetHex="00000E68" DisplayMethod="unsigned integer"/>
        <Element Offset="3692" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3700" Vartype="Pointer" Bytesize="8" OffsetHex="00000E74" DisplayMethod="unsigned integer"/>
        <Element Offset="3704" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000E78" DisplayMethod="unsigned integer"/>
        <Element Offset="3708" Vartype="Pointer" Bytesize="8" OffsetHex="00000E7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3712" Vartype="Pointer" Bytesize="8" OffsetHex="00000E80" DisplayMethod="unsigned integer"/>
        <Element Offset="3716" Vartype="Pointer" Bytesize="8" OffsetHex="00000E84" DisplayMethod="unsigned integer"/>
        <Element Offset="3720" Vartype="Pointer" Bytesize="8" OffsetHex="00000E88" DisplayMethod="unsigned integer"/>
        <Element Offset="3724" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3732" Vartype="Pointer" Bytesize="8" OffsetHex="00000E94" DisplayMethod="unsigned integer"/>
        <Element Offset="3736" Vartype="Pointer" Bytesize="8" OffsetHex="00000E98" DisplayMethod="unsigned integer"/>
        <Element Offset="3740" Vartype="Pointer" Bytesize="8" OffsetHex="00000E9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3744" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EA0" DisplayMethod="unsigned integer"/>
        <Element Offset="3752" Vartype="Pointer" Bytesize="8" OffsetHex="00000EA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3756" Vartype="Pointer" Bytesize="8" OffsetHex="00000EAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3760" Vartype="Pointer" Bytesize="8" OffsetHex="00000EB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3764" Vartype="Pointer" Bytesize="8" OffsetHex="00000EB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3768" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000EB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3784" Vartype="Pointer" Bytesize="8" OffsetHex="00000EC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3788" Vartype="Pointer" Bytesize="8" OffsetHex="00000ECC" DisplayMethod="unsigned integer"/>
        <Element Offset="3792" Vartype="Pointer" Bytesize="8" OffsetHex="00000ED0" DisplayMethod="unsigned integer"/>
        <Element Offset="3796" Vartype="Pointer" Bytesize="8" OffsetHex="00000ED4" DisplayMethod="unsigned integer"/>
        <Element Offset="3800" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000ED8" DisplayMethod="unsigned integer"/>
        <Element Offset="3804" Vartype="Pointer" Bytesize="8" OffsetHex="00000EDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3808" Vartype="4 Bytes" Bytesize="4" RLECount="6" OffsetHex="00000EE0" DisplayMethod="unsigned integer"/>
        <Element Offset="3832" Vartype="Pointer" Bytesize="8" OffsetHex="00000EF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3836" Vartype="Pointer" Bytesize="8" OffsetHex="00000EFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3840" Vartype="Pointer" Bytesize="8" OffsetHex="00000F00" DisplayMethod="unsigned integer"/>
        <Element Offset="3844" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F04" DisplayMethod="unsigned integer"/>
        <Element Offset="3848" Vartype="Pointer" Bytesize="8" OffsetHex="00000F08" DisplayMethod="unsigned integer"/>
        <Element Offset="3852" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000F0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3855" Vartype="2 Bytes" Bytesize="2" OffsetHex="00000F0F" DisplayMethod="unsigned integer"/>
        <Element Offset="3857" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000F11" DisplayMethod="unsigned integer"/>
        <Element Offset="3860" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F14" DisplayMethod="unsigned integer"/>
        <Element Offset="3864" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F18" DisplayMethod="hexadecimal"/>
        <Element Offset="3868" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3876" Vartype="Pointer" Bytesize="8" OffsetHex="00000F24" DisplayMethod="unsigned integer"/>
        <Element Offset="3880" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F28" DisplayMethod="unsigned integer"/>
        <Element Offset="3884" Vartype="Pointer" Bytesize="8" OffsetHex="00000F2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3888" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F30" DisplayMethod="unsigned integer"/>
        <Element Offset="3892" Vartype="Pointer" Bytesize="8" OffsetHex="00000F34" DisplayMethod="unsigned integer"/>
        <Element Offset="3896" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F38" DisplayMethod="unsigned integer"/>
        <Element Offset="3900" Vartype="Pointer" Bytesize="8" OffsetHex="00000F3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3904" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F40" DisplayMethod="unsigned integer"/>
        <Element Offset="3908" Vartype="Pointer" Bytesize="8" OffsetHex="00000F44" DisplayMethod="unsigned integer"/>
        <Element Offset="3912" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F48" DisplayMethod="unsigned integer"/>
        <Element Offset="3916" Vartype="Pointer" Bytesize="8" OffsetHex="00000F4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3920" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000F50" DisplayMethod="unsigned integer"/>
        <Element Offset="3928" Vartype="Pointer" Bytesize="8" OffsetHex="00000F58" DisplayMethod="unsigned integer"/>
        <Element Offset="3932" Vartype="Pointer" Bytesize="8" OffsetHex="00000F5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3936" Vartype="Pointer" Bytesize="8" OffsetHex="00000F60" DisplayMethod="unsigned integer"/>
        <Element Offset="3940" Vartype="Pointer" Bytesize="8" OffsetHex="00000F64" DisplayMethod="unsigned integer"/>
        <Element Offset="3944" Vartype="Double" Bytesize="8" OffsetHex="00000F68" DisplayMethod="unsigned integer"/>
        <Element Offset="3952" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000F70" DisplayMethod="unsigned integer"/>
        <Element Offset="3972" Vartype="Pointer" Bytesize="8" OffsetHex="00000F84" DisplayMethod="unsigned integer"/>
        <Element Offset="3976" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F88" DisplayMethod="unsigned integer"/>
        <Element Offset="3980" Vartype="Pointer" Bytesize="8" OffsetHex="00000F8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3984" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F90" DisplayMethod="unsigned integer"/>
        <Element Offset="3988" Vartype="String" Bytesize="4" OffsetHex="00000F94" DisplayMethod="unsigned integer"/>
        <Element Offset="3992" Vartype="Pointer" Bytesize="8" OffsetHex="00000F98" DisplayMethod="unsigned integer"/>
        <Element Offset="3996" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F9C" DisplayMethod="unsigned integer"/>
        <Element Offset="4000" Vartype="Pointer" Bytesize="8" OffsetHex="00000FA0" DisplayMethod="unsigned integer"/>
        <Element Offset="4004" Vartype="Pointer" Bytesize="8" OffsetHex="00000FA4" DisplayMethod="unsigned integer"/>
        <Element Offset="4008" Vartype="Pointer" Bytesize="8" OffsetHex="00000FA8" DisplayMethod="unsigned integer"/>
        <Element Offset="4012" Vartype="Pointer" Bytesize="8" OffsetHex="00000FAC" DisplayMethod="unsigned integer"/>
        <Element Offset="4016" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FB0" DisplayMethod="unsigned integer"/>
        <Element Offset="4020" Vartype="Pointer" Bytesize="8" OffsetHex="00000FB4" DisplayMethod="unsigned integer"/>
        <Element Offset="4024" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000FB8" DisplayMethod="unsigned integer"/>
        <Element Offset="4040" Vartype="Pointer" Bytesize="8" OffsetHex="00000FC8" DisplayMethod="unsigned integer"/>
        <Element Offset="4044" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000FCC" DisplayMethod="unsigned integer"/>
        <Element Offset="4084" Vartype="Pointer" Bytesize="8" OffsetHex="00000FF4" DisplayMethod="unsigned integer"/>
        <Element Offset="4088" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000FF8" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
  </Structures>
  <Comments>Version: Retail, 333-310
</Comments>
</CheatTable>
