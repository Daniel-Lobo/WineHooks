<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>11</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>3</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(inf_hp, 512)
registersymbol(inf_hp)
label(inf_hp_ret_point)

inf_hp:
  db 00 00 00 00 /*  store hp for research */
  push [ecx+14]
  pop [inf_hp]

  push [ecx+14]
  pop [ecx+10]
  fcomp dword ptr [ecx+10]
  fnstsw ax
jmp inf_hp_ret_point

00420B5A:
    jmp inf_hp+4
inf_hp_ret_point:

[disable]
00420B5A:
fcomp dword ptr [ecx+10]
fnstsw ax
dealloc(inf_hp)



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>10</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(easy_kills, 512)
label(easy_kills_ret_point)

easy_kills:
  mov [eax+68], (float)10.0
  fld dword ptr [eax+68]
  fsub dword ptr [esp+6C]
jmp easy_kills_ret_point

0047575E:
jmp easy_kills
  nop
  nop
easy_kills_ret_point:

[disable]
0047575E:
fld dword ptr [eax+68]
fsub dword ptr [esp+6C]
dealloc(easy_kills)



</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>5</ID>
      <Description>"R - inf Rage "</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(inf_rage, 512)
label(inf_rage_ret_point)

inf_rage:
  push [eax+28]
  pop [eax+24]
  fld dword ptr [eax+24]
  mov edx,[esi-08]
jmp inf_rage_ret_point

0053D1A3:
  jmp inf_rage
  nop
inf_rage_ret_point:

[disable]
0053D1A3:
fld dword ptr [eax+24]
mov edx,[esi-08]
dealloc(inf_rage)




</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>9</ID>
      <Description>"U - level UP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(maxhealth)
alloc(maxhealth, 512)
label(return_point)
label(original_code)

maxhealth:
  db 00 00 00 00     /*Flag to level up only once*/
  db 00 00 00 00
  cmp [maxhealth], 00
  mov [maxhealth], 01
  push 0
  pop  [eax+28]
  push 0
  pop  [eax+24]
  ja original_code

  push [eax+2c]
  pop  [eax+28]
  push [eax+2c]
  pop  [eax+24]

original_code:
  fld dword ptr [eax+0C]
  fdiv dword ptr [eax+14]
jmp return_point

0053A9E5:
  jmp maxhealth+8
  nop
return_point:

[disable]
0053A9E5:
fld dword ptr [eax+0C]
fdiv dword ptr [eax+14]
dealloc(maxhealth)



</AssemblerScript>
      <Hotkeys>
        <Hotkey>
          <Action>Toggle Activation</Action>
          <Keys/>
          <ID>0</ID>
        </Hotkey>
      </Hotkeys>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Structures StructVersion="2">
    <Structure Name="unnamed structure" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000000" DisplayMethod="unsigned integer"/>
        <Element Offset="16" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000010" DisplayMethod="unsigned integer"/>
        <Element Offset="24" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000018" DisplayMethod="unsigned integer"/>
        <Element Offset="40" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000028" DisplayMethod="unsigned integer"/>
        <Element Offset="44" Vartype="Pointer" Bytesize="8" OffsetHex="0000002C" Description="Pointer to instance of Creature" DisplayMethod="unsigned integer"/>
        <Element Offset="48" Vartype="Pointer" Bytesize="8" OffsetHex="00000030" Description="Pointer to instance of kain::KainState" DisplayMethod="unsigned integer"/>
        <Element Offset="52" Vartype="Pointer" Bytesize="8" OffsetHex="00000034" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="Pointer" Bytesize="8" OffsetHex="00000038" DisplayMethod="unsigned integer"/>
        <Element Offset="60" Vartype="Pointer" Bytesize="8" OffsetHex="0000003C" DisplayMethod="unsigned integer"/>
        <Element Offset="64" Vartype="Pointer" Bytesize="8" OffsetHex="00000040" DisplayMethod="unsigned integer"/>
        <Element Offset="68" Vartype="Pointer" Bytesize="8" OffsetHex="00000044" DisplayMethod="unsigned integer"/>
        <Element Offset="72" Vartype="Pointer" Bytesize="8" OffsetHex="00000048" DisplayMethod="unsigned integer"/>
        <Element Offset="76" Vartype="Pointer" Bytesize="8" OffsetHex="0000004C" DisplayMethod="unsigned integer"/>
        <Element Offset="80" Vartype="Pointer" Bytesize="8" OffsetHex="00000050" DisplayMethod="unsigned integer"/>
        <Element Offset="84" Vartype="Pointer" Bytesize="8" OffsetHex="00000054" Description="Pointer to instance of goe::OSHeapAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="88" Vartype="Pointer" Bytesize="8" OffsetHex="00000058" DisplayMethod="unsigned integer"/>
        <Element Offset="92" Vartype="Pointer" Bytesize="8" OffsetHex="0000005C" Description="Pointer to instance of goe::OSHeapAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="96" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000060" DisplayMethod="unsigned integer"/>
        <Element Offset="100" Vartype="Float" Bytesize="4" OffsetHex="00000064" DisplayMethod="unsigned integer"/>
        <Element Offset="104" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000068" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="Pointer" Bytesize="8" OffsetHex="0000006C" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Pointer" Bytesize="8" OffsetHex="00000070" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="Pointer" Bytesize="8" OffsetHex="00000078" DisplayMethod="unsigned integer"/>
        <Element Offset="124" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000007C" DisplayMethod="unsigned integer"/>
        <Element Offset="128" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000080" DisplayMethod="unsigned integer"/>
        <Element Offset="144" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000090" DisplayMethod="unsigned integer"/>
        <Element Offset="148" Vartype="Pointer" Bytesize="8" OffsetHex="00000094" DisplayMethod="unsigned integer"/>
        <Element Offset="152" Vartype="Float" Bytesize="4" OffsetHex="00000098" DisplayMethod="unsigned integer"/>
        <Element Offset="156" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000009C" DisplayMethod="unsigned integer"/>
        <Element Offset="164" Vartype="Pointer" Bytesize="8" OffsetHex="000000A4" DisplayMethod="unsigned integer"/>
        <Element Offset="168" Vartype="Double" Bytesize="8" OffsetHex="000000A8" DisplayMethod="unsigned integer"/>
        <Element Offset="176" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000B0" DisplayMethod="unsigned integer"/>
        <Element Offset="180" Vartype="Pointer" Bytesize="8" OffsetHex="000000B4" DisplayMethod="unsigned integer"/>
        <Element Offset="184" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000B8" DisplayMethod="unsigned integer"/>
        <Element Offset="188" Vartype="Double" Bytesize="8" OffsetHex="000000BC" DisplayMethod="unsigned integer"/>
        <Element Offset="196" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000000C4" DisplayMethod="unsigned integer"/>
        <Element Offset="208" Vartype="Double" Bytesize="8" OffsetHex="000000D0" DisplayMethod="unsigned integer"/>
        <Element Offset="216" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000D8" DisplayMethod="unsigned integer"/>
        <Element Offset="220" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000DC" DisplayMethod="hexadecimal"/>
        <Element Offset="224" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000000E0" DisplayMethod="unsigned integer"/>
        <Element Offset="240" Vartype="Pointer" Bytesize="8" OffsetHex="000000F0" DisplayMethod="unsigned integer"/>
        <Element Offset="244" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000F4" DisplayMethod="unsigned integer"/>
        <Element Offset="252" Vartype="Pointer" Bytesize="8" OffsetHex="000000FC" DisplayMethod="unsigned integer"/>
        <Element Offset="256" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000100" DisplayMethod="unsigned integer"/>
        <Element Offset="260" Vartype="Pointer" Bytesize="8" OffsetHex="00000104" Description="Pointer to instance of Creature" DisplayMethod="unsigned integer"/>
        <Element Offset="264" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000108" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="Pointer" Bytesize="8" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="Pointer" Bytesize="8" OffsetHex="00000110" Description="Pointer to instance of Scamerasetup" DisplayMethod="unsigned integer"/>
        <Element Offset="276" Vartype="Pointer" Bytesize="8" OffsetHex="00000114" DisplayMethod="unsigned integer"/>
        <Element Offset="280" Vartype="Float" Bytesize="4" OffsetHex="00000118" DisplayMethod="unsigned integer"/>
        <Element Offset="284" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000011C" DisplayMethod="unsigned integer"/>
        <Element Offset="292" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000124" DisplayMethod="unsigned integer"/>
        <Element Offset="300" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000012C" DisplayMethod="unsigned integer"/>
        <Element Offset="304" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000130" DisplayMethod="unsigned integer"/>
        <Element Offset="320" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000140" DisplayMethod="unsigned integer"/>
        <Element Offset="324" Vartype="Pointer" Bytesize="8" OffsetHex="00000144" DisplayMethod="unsigned integer"/>
        <Element Offset="328" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000148" DisplayMethod="unsigned integer"/>
        <Element Offset="332" Vartype="Pointer" Bytesize="8" OffsetHex="0000014C" Description="Pointer to instance of Scamerasetup" DisplayMethod="unsigned integer"/>
        <Element Offset="336" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000150" DisplayMethod="unsigned integer"/>
        <Element Offset="340" Vartype="Pointer" Bytesize="8" OffsetHex="00000154" DisplayMethod="unsigned integer"/>
        <Element Offset="344" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000158" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="Pointer" Bytesize="8" OffsetHex="0000015C" Description="Pointer to instance of Sgamecamera" DisplayMethod="unsigned integer"/>
        <Element Offset="352" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000160" DisplayMethod="unsigned integer"/>
        <Element Offset="356" Vartype="Pointer" Bytesize="8" OffsetHex="00000164" DisplayMethod="unsigned integer"/>
        <Element Offset="360" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000168" DisplayMethod="unsigned integer"/>
        <Element Offset="364" Vartype="Pointer" Bytesize="8" OffsetHex="0000016C" Description="Pointer to instance of goe::Handle&lt;goe::ScriptObject&gt;" DisplayMethod="unsigned integer"/>
        <Element Offset="368" Vartype="Pointer" Bytesize="8" OffsetHex="00000170" Description="Pointer to instance of goe::ScriptType" DisplayMethod="unsigned integer"/>
        <Element Offset="372" Vartype="Pointer" Bytesize="8" OffsetHex="00000174" DisplayMethod="unsigned integer"/>
        <Element Offset="376" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000178" DisplayMethod="unsigned integer"/>
        <Element Offset="392" Vartype="Pointer" Bytesize="8" OffsetHex="00000188" DisplayMethod="unsigned integer"/>
        <Element Offset="396" Vartype="Pointer" Bytesize="8" OffsetHex="0000018C" Description="Pointer to instance of Scamerasetup" DisplayMethod="unsigned integer"/>
        <Element Offset="400" Vartype="Pointer" Bytesize="8" OffsetHex="00000190" DisplayMethod="unsigned integer"/>
        <Element Offset="404" Vartype="Pointer" Bytesize="8" OffsetHex="00000194" Description="Pointer to instance of CameraSetup" DisplayMethod="unsigned integer"/>
        <Element Offset="408" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000198" DisplayMethod="unsigned integer"/>
        <Element Offset="412" Vartype="Pointer" Bytesize="8" OffsetHex="0000019C" DisplayMethod="unsigned integer"/>
        <Element Offset="416" Vartype="Pointer" Bytesize="8" OffsetHex="000001A0" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="Float" Bytesize="4" OffsetHex="000001A4" DisplayMethod="unsigned integer"/>
        <Element Offset="424" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001A8" DisplayMethod="unsigned integer"/>
        <Element Offset="428" Vartype="Pointer" Bytesize="8" OffsetHex="000001AC" DisplayMethod="unsigned integer"/>
        <Element Offset="432" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001B0" DisplayMethod="unsigned integer"/>
        <Element Offset="436" Vartype="Pointer" Bytesize="8" OffsetHex="000001B4" Description="Pointer to instance of Scamerasetup" DisplayMethod="unsigned integer"/>
        <Element Offset="440" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001B8" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="Pointer" Bytesize="8" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="448" Vartype="Pointer" Bytesize="8" OffsetHex="000001C0" DisplayMethod="unsigned integer"/>
        <Element Offset="452" Vartype="Float" Bytesize="4" OffsetHex="000001C4" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001C8" DisplayMethod="unsigned integer"/>
        <Element Offset="460" Vartype="Pointer" Bytesize="8" OffsetHex="000001CC" DisplayMethod="unsigned integer"/>
        <Element Offset="464" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001D0" DisplayMethod="unsigned integer"/>
        <Element Offset="468" Vartype="Pointer" Bytesize="8" OffsetHex="000001D4" Description="Pointer to instance of Ssoundscript" DisplayMethod="unsigned integer"/>
        <Element Offset="472" Vartype="Float" Bytesize="4" OffsetHex="000001D8" DisplayMethod="unsigned integer"/>
        <Element Offset="476" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001DC" DisplayMethod="unsigned integer"/>
        <Element Offset="484" Vartype="Pointer" Bytesize="8" OffsetHex="000001E4" DisplayMethod="unsigned integer"/>
        <Element Offset="488" Vartype="Pointer" Bytesize="8" OffsetHex="000001E8" Description="Pointer to instance of GameParticleEffect" DisplayMethod="unsigned integer"/>
        <Element Offset="492" Vartype="Pointer" Bytesize="8" OffsetHex="000001EC" Description="Pointer to instance of goe::ParticleType" DisplayMethod="unsigned integer"/>
        <Element Offset="496" Vartype="Double" Bytesize="8" OffsetHex="000001F0" DisplayMethod="unsigned integer"/>
        <Element Offset="504" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001F8" DisplayMethod="unsigned integer"/>
        <Element Offset="508" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000001FC" DisplayMethod="unsigned integer"/>
        <Element Offset="520" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000208" DisplayMethod="unsigned integer"/>
        <Element Offset="524" Vartype="Pointer" Bytesize="8" OffsetHex="0000020C" DisplayMethod="unsigned integer"/>
        <Element Offset="528" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000210" DisplayMethod="unsigned integer"/>
        <Element Offset="532" Vartype="Double" Bytesize="8" OffsetHex="00000214" DisplayMethod="unsigned integer"/>
        <Element Offset="540" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000021C" DisplayMethod="unsigned integer"/>
        <Element Offset="544" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000220" DisplayMethod="unsigned integer"/>
        <Element Offset="556" Vartype="4 Bytes" Bytesize="4" RLECount="12" OffsetHex="0000022C" DisplayMethod="unsigned integer"/>
        <Element Offset="604" Vartype="Pointer" Bytesize="8" OffsetHex="0000025C" DisplayMethod="unsigned integer"/>
        <Element Offset="608" Vartype="Pointer" Bytesize="8" OffsetHex="00000260" DisplayMethod="unsigned integer"/>
        <Element Offset="612" Vartype="Pointer" Bytesize="8" OffsetHex="00000264" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="616" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="00000268" DisplayMethod="unsigned integer"/>
        <Element Offset="644" Vartype="Pointer" Bytesize="8" OffsetHex="00000284" DisplayMethod="unsigned integer"/>
        <Element Offset="648" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000288" DisplayMethod="unsigned integer"/>
        <Element Offset="660" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000294" DisplayMethod="unsigned integer"/>
        <Element Offset="668" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="0000029C" DisplayMethod="unsigned integer"/>
        <Element Offset="720" Vartype="Float" Bytesize="4" OffsetHex="000002D0" DisplayMethod="unsigned integer"/>
        <Element Offset="724" Vartype="Pointer" Bytesize="8" OffsetHex="000002D4" DisplayMethod="unsigned integer"/>
        <Element Offset="728" Vartype="Float" Bytesize="4" OffsetHex="000002D8" DisplayMethod="unsigned integer"/>
        <Element Offset="732" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000002DC" DisplayMethod="unsigned integer"/>
        <Element Offset="740" Vartype="Double" Bytesize="8" OffsetHex="000002E4" DisplayMethod="unsigned integer"/>
        <Element Offset="748" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000002EC" DisplayMethod="unsigned integer"/>
        <Element Offset="760" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000002F8" DisplayMethod="unsigned integer"/>
        <Element Offset="772" Vartype="Double" Bytesize="8" OffsetHex="00000304" DisplayMethod="unsigned integer"/>
        <Element Offset="780" Vartype="Float" Bytesize="4" OffsetHex="0000030C" DisplayMethod="unsigned integer"/>
        <Element Offset="784" Vartype="Double" Bytesize="8" OffsetHex="00000310" DisplayMethod="unsigned integer"/>
        <Element Offset="792" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000318" DisplayMethod="unsigned integer"/>
        <Element Offset="808" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000328" DisplayMethod="unsigned integer"/>
        <Element Offset="828" Vartype="Double" Bytesize="8" OffsetHex="0000033C" DisplayMethod="unsigned integer"/>
        <Element Offset="836" Vartype="4 Bytes" Bytesize="4" RLECount="10" OffsetHex="00000344" DisplayMethod="unsigned integer"/>
        <Element Offset="876" Vartype="Pointer" Bytesize="8" OffsetHex="0000036C" DisplayMethod="unsigned integer"/>
        <Element Offset="880" Vartype="Pointer" Bytesize="8" OffsetHex="00000370" DisplayMethod="unsigned integer"/>
        <Element Offset="884" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000374" DisplayMethod="unsigned integer"/>
        <Element Offset="912" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000390" DisplayMethod="unsigned integer"/>
        <Element Offset="924" Vartype="Double" Bytesize="8" OffsetHex="0000039C" DisplayMethod="unsigned integer"/>
        <Element Offset="932" Vartype="Float" Bytesize="4" OffsetHex="000003A4" DisplayMethod="unsigned integer"/>
        <Element Offset="936" Vartype="4 Bytes" Bytesize="4" RLECount="14" OffsetHex="000003A8" DisplayMethod="unsigned integer"/>
        <Element Offset="992" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="000003E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1008" Vartype="Pointer" Bytesize="8" OffsetHex="000003F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1012" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000003F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1020" Vartype="Pointer" Bytesize="8" OffsetHex="000003FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1024" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000400" DisplayMethod="unsigned integer"/>
        <Element Offset="1036" Vartype="Float" Bytesize="4" OffsetHex="0000040C" DisplayMethod="unsigned integer"/>
        <Element Offset="1040" Vartype="Pointer" Bytesize="8" OffsetHex="00000410" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="1044" Vartype="Pointer" Bytesize="8" OffsetHex="00000414" DisplayMethod="unsigned integer"/>
        <Element Offset="1048" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000418" DisplayMethod="unsigned integer"/>
        <Element Offset="1052" Vartype="Pointer" Bytesize="8" OffsetHex="0000041C" Description="Pointer to instance of GameParticleEffect" DisplayMethod="unsigned integer"/>
        <Element Offset="1056" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000420" DisplayMethod="unsigned integer"/>
        <Element Offset="1060" Vartype="Float" Bytesize="4" OffsetHex="00000424" DisplayMethod="unsigned integer"/>
        <Element Offset="1064" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000428" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="Pointer" Bytesize="8" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1072" Vartype="Pointer" Bytesize="8" OffsetHex="00000430" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="1076" Vartype="Pointer" Bytesize="8" OffsetHex="00000434" DisplayMethod="unsigned integer"/>
        <Element Offset="1080" Vartype="Pointer" Bytesize="8" OffsetHex="00000438" Description="Pointer to instance of Ssoundscript" DisplayMethod="unsigned integer"/>
        <Element Offset="1084" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000043C" DisplayMethod="unsigned integer"/>
        <Element Offset="1096" Vartype="Pointer" Bytesize="8" OffsetHex="00000448" Description="Pointer to instance of Ssoundscript" DisplayMethod="unsigned integer"/>
        <Element Offset="1100" Vartype="Pointer" Bytesize="8" OffsetHex="0000044C" DisplayMethod="unsigned integer"/>
        <Element Offset="1104" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000450" DisplayMethod="unsigned integer"/>
        <Element Offset="1108" Vartype="Pointer" Bytesize="8" OffsetHex="00000454" DisplayMethod="unsigned integer"/>
        <Element Offset="1112" Vartype="Pointer" Bytesize="8" OffsetHex="00000458" DisplayMethod="unsigned integer"/>
        <Element Offset="1116" Vartype="Pointer" Bytesize="8" OffsetHex="0000045C" DisplayMethod="unsigned integer"/>
        <Element Offset="1120" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000460" DisplayMethod="unsigned integer"/>
        <Element Offset="1124" Vartype="Pointer" Bytesize="8" OffsetHex="00000464" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="1128" Vartype="Pointer" Bytesize="8" OffsetHex="00000468" DisplayMethod="unsigned integer"/>
        <Element Offset="1132" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000046C" DisplayMethod="unsigned integer"/>
        <Element Offset="1140" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000474" DisplayMethod="unsigned integer"/>
        <Element Offset="1148" Vartype="Byte" Bytesize="1" OffsetHex="0000047C" DisplayMethod="unsigned integer"/>
        <Element Offset="1149" Vartype="String" Bytesize="4" OffsetHex="0000047D" DisplayMethod="unsigned integer"/>
        <Element Offset="1153" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000481" DisplayMethod="unsigned integer"/>
        <Element Offset="1156" Vartype="String" Bytesize="4" OffsetHex="00000484" DisplayMethod="unsigned integer"/>
        <Element Offset="1160" Vartype="Byte" Bytesize="1" OffsetHex="00000488" DisplayMethod="unsigned integer"/>
        <Element Offset="1161" Vartype="String" Bytesize="6" OffsetHex="00000489" DisplayMethod="unsigned integer"/>
        <Element Offset="1167" Vartype="2 Bytes" Bytesize="2" OffsetHex="0000048F" DisplayMethod="unsigned integer"/>
        <Element Offset="1169" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000491" DisplayMethod="unsigned integer"/>
        <Element Offset="1172" Vartype="Float" Bytesize="4" RLECount="8" OffsetHex="00000494" DisplayMethod="unsigned integer"/>
        <Element Offset="1204" Vartype="Byte" Bytesize="1" OffsetHex="000004B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1205" Vartype="String" Bytesize="7" OffsetHex="000004B5" DisplayMethod="unsigned integer"/>
        <Element Offset="1212" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="000004BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1228" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000004CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1232" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000004D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1240" Vartype="String" Bytesize="4" OffsetHex="000004D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1244" Vartype="Byte" Bytesize="1" OffsetHex="000004DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1245" Vartype="String" Bytesize="4" OffsetHex="000004DD" DisplayMethod="unsigned integer"/>
        <Element Offset="1249" Vartype="Byte" Bytesize="1" RLECount="9" OffsetHex="000004E1" DisplayMethod="unsigned integer"/>
        <Element Offset="1258" Vartype="2 Bytes" Bytesize="2" OffsetHex="000004EA" DisplayMethod="unsigned integer"/>
        <Element Offset="1260" Vartype="Float" Bytesize="4" OffsetHex="000004EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1264" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1268" Vartype="Float" Bytesize="4" OffsetHex="000004F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1272" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000004F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1276" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000004FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1284" Vartype="Double" Bytesize="8" OffsetHex="00000504" DisplayMethod="unsigned integer"/>
        <Element Offset="1292" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="0000050C" DisplayMethod="unsigned integer"/>
        <Element Offset="1316" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000524" DisplayMethod="unsigned integer"/>
        <Element Offset="1320" Vartype="Double" Bytesize="8" OffsetHex="00000528" DisplayMethod="unsigned integer"/>
        <Element Offset="1328" Vartype="Float" Bytesize="4" OffsetHex="00000530" DisplayMethod="unsigned integer"/>
        <Element Offset="1332" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000534" DisplayMethod="unsigned integer"/>
        <Element Offset="1336" Vartype="Double" Bytesize="8" OffsetHex="00000538" DisplayMethod="unsigned integer"/>
        <Element Offset="1344" Vartype="String" Bytesize="4" OffsetHex="00000540" DisplayMethod="unsigned integer"/>
        <Element Offset="1348" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000544" DisplayMethod="unsigned integer"/>
        <Element Offset="1372" Vartype="Byte" Bytesize="1" OffsetHex="0000055C" DisplayMethod="unsigned integer"/>
        <Element Offset="1373" Vartype="String" Bytesize="4" OffsetHex="0000055D" DisplayMethod="unsigned integer"/>
        <Element Offset="1377" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000561" DisplayMethod="unsigned integer"/>
        <Element Offset="1380" Vartype="Float" Bytesize="4" OffsetHex="00000564" DisplayMethod="unsigned integer"/>
        <Element Offset="1384" Vartype="Byte" Bytesize="1" RLECount="5" OffsetHex="00000568" DisplayMethod="unsigned integer"/>
        <Element Offset="1389" Vartype="String" Bytesize="4" OffsetHex="0000056D" DisplayMethod="unsigned integer"/>
        <Element Offset="1393" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000571" DisplayMethod="unsigned integer"/>
        <Element Offset="1396" Vartype="Pointer" Bytesize="8" OffsetHex="00000574" DisplayMethod="unsigned integer"/>
        <Element Offset="1400" Vartype="Pointer" Bytesize="8" OffsetHex="00000578" DisplayMethod="unsigned integer"/>
        <Element Offset="1404" Vartype="Double" Bytesize="8" OffsetHex="0000057C" DisplayMethod="unsigned integer"/>
        <Element Offset="1412" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000584" DisplayMethod="unsigned integer"/>
        <Element Offset="1416" Vartype="Float" Bytesize="4" RLECount="5" OffsetHex="00000588" DisplayMethod="unsigned integer"/>
        <Element Offset="1436" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000059C" DisplayMethod="unsigned integer"/>
        <Element Offset="1444" Vartype="Pointer" Bytesize="8" OffsetHex="000005A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1448" Vartype="Pointer" Bytesize="8" OffsetHex="000005A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1452" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000005AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1464" Vartype="Double" Bytesize="8" OffsetHex="000005B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1472" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000005C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1480" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1484" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000005CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1488" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1492" Vartype="Pointer" Bytesize="8" OffsetHex="000005D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1496" Vartype="Pointer" Bytesize="8" OffsetHex="000005D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1500" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1504" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000005E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1512" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1516" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000005EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1528" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000005F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1536" Vartype="Double" Bytesize="8" OffsetHex="00000600" DisplayMethod="unsigned integer"/>
        <Element Offset="1544" Vartype="Pointer" Bytesize="8" OffsetHex="00000608" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="1548" Vartype="Pointer" Bytesize="8" OffsetHex="0000060C" DisplayMethod="unsigned integer"/>
        <Element Offset="1552" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000610" DisplayMethod="unsigned integer"/>
        <Element Offset="1556" Vartype="Pointer" Bytesize="8" OffsetHex="00000614" DisplayMethod="unsigned integer"/>
        <Element Offset="1560" Vartype="Pointer" Bytesize="8" OffsetHex="00000618" DisplayMethod="unsigned integer"/>
        <Element Offset="1564" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000061C" DisplayMethod="unsigned integer"/>
        <Element Offset="1576" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000628" DisplayMethod="unsigned integer"/>
        <Element Offset="1584" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000630" DisplayMethod="unsigned integer"/>
        <Element Offset="1588" Vartype="Double" Bytesize="8" OffsetHex="00000634" DisplayMethod="unsigned integer"/>
        <Element Offset="1596" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000063C" DisplayMethod="unsigned integer"/>
        <Element Offset="1604" Vartype="Pointer" Bytesize="8" OffsetHex="00000644" Description="Pointer to instance of goe::Cell" DisplayMethod="unsigned integer"/>
        <Element Offset="1608" Vartype="Pointer" Bytesize="8" OffsetHex="00000648" DisplayMethod="unsigned integer"/>
        <Element Offset="1612" Vartype="Double" Bytesize="8" OffsetHex="0000064C" DisplayMethod="unsigned integer"/>
        <Element Offset="1620" Vartype="Float" Bytesize="4" OffsetHex="00000654" DisplayMethod="unsigned integer"/>
        <Element Offset="1624" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000658" DisplayMethod="unsigned integer"/>
        <Element Offset="1628" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="0000065C" DisplayMethod="unsigned integer"/>
        <Element Offset="1640" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000668" DisplayMethod="unsigned integer"/>
        <Element Offset="1648" Vartype="Double" Bytesize="8" OffsetHex="00000670" DisplayMethod="unsigned integer"/>
        <Element Offset="1656" Vartype="Pointer" Bytesize="8" OffsetHex="00000678" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="1660" Vartype="Pointer" Bytesize="8" OffsetHex="0000067C" DisplayMethod="unsigned integer"/>
        <Element Offset="1664" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000680" DisplayMethod="unsigned integer"/>
        <Element Offset="1668" Vartype="Pointer" Bytesize="8" OffsetHex="00000684" DisplayMethod="unsigned integer"/>
        <Element Offset="1672" Vartype="Pointer" Bytesize="8" OffsetHex="00000688" DisplayMethod="unsigned integer"/>
        <Element Offset="1676" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000068C" DisplayMethod="unsigned integer"/>
        <Element Offset="1684" Vartype="Pointer" Bytesize="8" OffsetHex="00000694" DisplayMethod="unsigned integer"/>
        <Element Offset="1688" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000698" DisplayMethod="unsigned integer"/>
        <Element Offset="1696" Vartype="Double" Bytesize="8" OffsetHex="000006A0" DisplayMethod="unsigned integer"/>
        <Element Offset="1704" Vartype="Float" Bytesize="4" OffsetHex="000006A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1708" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000006AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1716" Vartype="Pointer" Bytesize="8" OffsetHex="000006B4" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1720" Vartype="Pointer" Bytesize="8" OffsetHex="000006B8" Description="Pointer to instance of goe::OmniLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1724" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1728" Vartype="Double" Bytesize="8" OffsetHex="000006C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1736" Vartype="String" Bytesize="4" OffsetHex="000006C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1740" Vartype="Float" Bytesize="4" OffsetHex="000006CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1744" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1748" Vartype="Pointer" Bytesize="8" OffsetHex="000006D4" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1752" Vartype="Pointer" Bytesize="8" OffsetHex="000006D8" Description="Pointer to instance of goe::OmniLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1756" Vartype="Float" Bytesize="4" OffsetHex="000006DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1760" Vartype="Double" Bytesize="8" OffsetHex="000006E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1768" Vartype="Byte" Bytesize="1" OffsetHex="000006E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1769" Vartype="String" Bytesize="7" OffsetHex="000006E9" DisplayMethod="unsigned integer"/>
        <Element Offset="1776" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1780" Vartype="Pointer" Bytesize="8" OffsetHex="000006F4" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1784" Vartype="Pointer" Bytesize="8" OffsetHex="000006F8" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1788" Vartype="Float" Bytesize="4" OffsetHex="000006FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1792" Vartype="Double" Bytesize="8" OffsetHex="00000700" DisplayMethod="unsigned integer"/>
        <Element Offset="1800" Vartype="Float" Bytesize="4" OffsetHex="00000708" DisplayMethod="unsigned integer"/>
        <Element Offset="1804" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="0000070C" DisplayMethod="unsigned integer"/>
        <Element Offset="1808" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000710" DisplayMethod="unsigned integer"/>
        <Element Offset="1812" Vartype="Pointer" Bytesize="8" OffsetHex="00000714" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1816" Vartype="Pointer" Bytesize="8" OffsetHex="00000718" Description="Pointer to instance of goe::OmniLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1820" Vartype="Float" Bytesize="4" OffsetHex="0000071C" DisplayMethod="unsigned integer"/>
        <Element Offset="1824" Vartype="Double" Bytesize="8" OffsetHex="00000720" DisplayMethod="unsigned integer"/>
        <Element Offset="1832" Vartype="String" Bytesize="4" OffsetHex="00000728" DisplayMethod="unsigned integer"/>
        <Element Offset="1836" Vartype="Float" Bytesize="4" OffsetHex="0000072C" DisplayMethod="unsigned integer"/>
        <Element Offset="1840" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000730" DisplayMethod="unsigned integer"/>
        <Element Offset="1844" Vartype="Pointer" Bytesize="8" OffsetHex="00000734" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1848" Vartype="Pointer" Bytesize="8" OffsetHex="00000738" Description="Pointer to instance of goe::OmniLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1852" Vartype="Float" Bytesize="4" OffsetHex="0000073C" DisplayMethod="unsigned integer"/>
        <Element Offset="1856" Vartype="Double" Bytesize="8" OffsetHex="00000740" DisplayMethod="unsigned integer"/>
        <Element Offset="1864" Vartype="Float" Bytesize="4" OffsetHex="00000748" DisplayMethod="unsigned integer"/>
        <Element Offset="1868" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="0000074C" DisplayMethod="unsigned integer"/>
        <Element Offset="1871" Vartype="2 Bytes" Bytesize="2" OffsetHex="0000074F" DisplayMethod="unsigned integer"/>
        <Element Offset="1873" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000751" DisplayMethod="unsigned integer"/>
        <Element Offset="1876" Vartype="Pointer" Bytesize="8" OffsetHex="00000754" DisplayMethod="unsigned integer"/>
        <Element Offset="1880" Vartype="Pointer" Bytesize="8" OffsetHex="00000758" DisplayMethod="unsigned integer"/>
        <Element Offset="1884" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000075C" DisplayMethod="unsigned integer"/>
        <Element Offset="1896" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000768" DisplayMethod="unsigned integer"/>
        <Element Offset="1904" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000770" DisplayMethod="unsigned integer"/>
        <Element Offset="1908" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000774" DisplayMethod="unsigned integer"/>
        <Element Offset="1912" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000778" DisplayMethod="unsigned integer"/>
        <Element Offset="1920" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000780" DisplayMethod="unsigned integer"/>
        <Element Offset="1924" Vartype="Pointer" Bytesize="8" OffsetHex="00000784" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="Pointer" Bytesize="8" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1932" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000078C" DisplayMethod="unsigned integer"/>
        <Element Offset="1936" Vartype="Double" Bytesize="8" OffsetHex="00000790" DisplayMethod="unsigned integer"/>
        <Element Offset="1944" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000798" DisplayMethod="unsigned integer"/>
        <Element Offset="1948" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="0000079C" DisplayMethod="unsigned integer"/>
        <Element Offset="1960" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000007A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1968" Vartype="Double" Bytesize="8" OffsetHex="000007B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1976" Vartype="Pointer" Bytesize="8" OffsetHex="000007B8" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="1980" Vartype="Pointer" Bytesize="8" OffsetHex="000007BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1984" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1988" Vartype="Pointer" Bytesize="8" OffsetHex="000007C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1992" Vartype="Pointer" Bytesize="8" OffsetHex="000007C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1996" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000007CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2008" Vartype="Float" Bytesize="4" OffsetHex="000007D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2012" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000007DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000007E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2024" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000007E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2036" Vartype="Pointer" Bytesize="8" OffsetHex="000007F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2040" Vartype="Pointer" Bytesize="8" OffsetHex="000007F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2044" Vartype="Pointer" Bytesize="8" OffsetHex="000007FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2048" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000800" DisplayMethod="unsigned integer"/>
        <Element Offset="2064" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000810" DisplayMethod="unsigned integer"/>
        <Element Offset="2076" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000081C" DisplayMethod="unsigned integer"/>
        <Element Offset="2084" Vartype="Pointer" Bytesize="8" OffsetHex="00000824" DisplayMethod="unsigned integer"/>
        <Element Offset="2088" Vartype="Pointer" Bytesize="8" OffsetHex="00000828" DisplayMethod="unsigned integer"/>
        <Element Offset="2092" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="0000082C" DisplayMethod="unsigned integer"/>
        <Element Offset="2108" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000083C" DisplayMethod="unsigned integer"/>
        <Element Offset="2116" Vartype="Double" Bytesize="8" OffsetHex="00000844" DisplayMethod="unsigned integer"/>
        <Element Offset="2124" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="0000084C" DisplayMethod="unsigned integer"/>
        <Element Offset="2152" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000868" DisplayMethod="unsigned integer"/>
        <Element Offset="2172" Vartype="Double" Bytesize="8" OffsetHex="0000087C" DisplayMethod="unsigned integer"/>
        <Element Offset="2180" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000884" DisplayMethod="unsigned integer"/>
        <Element Offset="2204" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000089C" DisplayMethod="unsigned integer"/>
        <Element Offset="2212" Vartype="Double" Bytesize="8" OffsetHex="000008A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2220" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="000008AC" DisplayMethod="unsigned integer"/>
        <Element Offset="2248" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000008C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2268" Vartype="Double" Bytesize="8" OffsetHex="000008DC" DisplayMethod="unsigned integer"/>
        <Element Offset="2276" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000008E4" DisplayMethod="unsigned integer"/>
        <Element Offset="2300" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2308" Vartype="Double" Bytesize="8" OffsetHex="00000904" DisplayMethod="unsigned integer"/>
        <Element Offset="2316" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="0000090C" DisplayMethod="unsigned integer"/>
        <Element Offset="2344" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000928" DisplayMethod="unsigned integer"/>
        <Element Offset="2364" Vartype="Double" Bytesize="8" OffsetHex="0000093C" DisplayMethod="unsigned integer"/>
        <Element Offset="2372" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000944" DisplayMethod="unsigned integer"/>
        <Element Offset="2396" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000095C" DisplayMethod="unsigned integer"/>
        <Element Offset="2404" Vartype="Double" Bytesize="8" OffsetHex="00000964" DisplayMethod="unsigned integer"/>
        <Element Offset="2412" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="0000096C" DisplayMethod="unsigned integer"/>
        <Element Offset="2440" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000988" DisplayMethod="unsigned integer"/>
        <Element Offset="2460" Vartype="Double" Bytesize="8" OffsetHex="0000099C" DisplayMethod="unsigned integer"/>
        <Element Offset="2468" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000009A4" DisplayMethod="unsigned integer"/>
        <Element Offset="2492" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009BC" DisplayMethod="unsigned integer"/>
        <Element Offset="2500" Vartype="Double" Bytesize="8" OffsetHex="000009C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2508" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="000009CC" DisplayMethod="unsigned integer"/>
        <Element Offset="2536" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000009E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2556" Vartype="Double" Bytesize="8" OffsetHex="000009FC" DisplayMethod="unsigned integer"/>
        <Element Offset="2564" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000A04" DisplayMethod="unsigned integer"/>
        <Element Offset="2588" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A1C" DisplayMethod="unsigned integer"/>
        <Element Offset="2596" Vartype="Double" Bytesize="8" OffsetHex="00000A24" DisplayMethod="unsigned integer"/>
        <Element Offset="2604" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000A2C" DisplayMethod="unsigned integer"/>
        <Element Offset="2632" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000A48" DisplayMethod="unsigned integer"/>
        <Element Offset="2652" Vartype="Double" Bytesize="8" OffsetHex="00000A5C" DisplayMethod="unsigned integer"/>
        <Element Offset="2660" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000A64" DisplayMethod="unsigned integer"/>
        <Element Offset="2684" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A7C" DisplayMethod="unsigned integer"/>
        <Element Offset="2692" Vartype="Double" Bytesize="8" OffsetHex="00000A84" DisplayMethod="unsigned integer"/>
        <Element Offset="2700" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000A8C" DisplayMethod="unsigned integer"/>
        <Element Offset="2728" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000AA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2748" Vartype="Double" Bytesize="8" OffsetHex="00000ABC" DisplayMethod="unsigned integer"/>
        <Element Offset="2756" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000AC4" DisplayMethod="unsigned integer"/>
        <Element Offset="2780" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000ADC" DisplayMethod="unsigned integer"/>
        <Element Offset="2788" Vartype="Double" Bytesize="8" OffsetHex="00000AE4" DisplayMethod="unsigned integer"/>
        <Element Offset="2796" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000AEC" DisplayMethod="unsigned integer"/>
        <Element Offset="2824" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000B08" DisplayMethod="unsigned integer"/>
        <Element Offset="2844" Vartype="Double" Bytesize="8" OffsetHex="00000B1C" DisplayMethod="unsigned integer"/>
        <Element Offset="2852" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000B24" DisplayMethod="unsigned integer"/>
        <Element Offset="2876" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B3C" DisplayMethod="unsigned integer"/>
        <Element Offset="2884" Vartype="Double" Bytesize="8" OffsetHex="00000B44" DisplayMethod="unsigned integer"/>
        <Element Offset="2892" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000B4C" DisplayMethod="unsigned integer"/>
        <Element Offset="2920" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000B68" DisplayMethod="unsigned integer"/>
        <Element Offset="2940" Vartype="Double" Bytesize="8" OffsetHex="00000B7C" DisplayMethod="unsigned integer"/>
        <Element Offset="2948" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000B84" DisplayMethod="unsigned integer"/>
        <Element Offset="2972" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B9C" DisplayMethod="unsigned integer"/>
        <Element Offset="2980" Vartype="Double" Bytesize="8" OffsetHex="00000BA4" DisplayMethod="unsigned integer"/>
        <Element Offset="2988" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000BAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3016" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000BC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3036" Vartype="Double" Bytesize="8" OffsetHex="00000BDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3044" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000BE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3068" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000BFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3076" Vartype="Double" Bytesize="8" OffsetHex="00000C04" DisplayMethod="unsigned integer"/>
        <Element Offset="3084" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000C0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3112" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000C28" DisplayMethod="unsigned integer"/>
        <Element Offset="3132" Vartype="Double" Bytesize="8" OffsetHex="00000C3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3140" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000C44" DisplayMethod="unsigned integer"/>
        <Element Offset="3164" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3172" Vartype="Double" Bytesize="8" OffsetHex="00000C64" DisplayMethod="unsigned integer"/>
        <Element Offset="3180" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000C6C" DisplayMethod="unsigned integer"/>
        <Element Offset="3208" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000C88" DisplayMethod="unsigned integer"/>
        <Element Offset="3228" Vartype="Double" Bytesize="8" OffsetHex="00000C9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3236" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000CA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3260" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000CBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3268" Vartype="Double" Bytesize="8" OffsetHex="00000CC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3276" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000CCC" DisplayMethod="unsigned integer"/>
        <Element Offset="3304" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000CE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3324" Vartype="Double" Bytesize="8" OffsetHex="00000CFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3332" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000D04" DisplayMethod="unsigned integer"/>
        <Element Offset="3356" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3364" Vartype="Double" Bytesize="8" OffsetHex="00000D24" DisplayMethod="unsigned integer"/>
        <Element Offset="3372" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000D2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3400" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000D48" DisplayMethod="unsigned integer"/>
        <Element Offset="3420" Vartype="Double" Bytesize="8" OffsetHex="00000D5C" DisplayMethod="unsigned integer"/>
        <Element Offset="3428" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000D64" DisplayMethod="unsigned integer"/>
        <Element Offset="3452" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3460" Vartype="Double" Bytesize="8" OffsetHex="00000D84" DisplayMethod="unsigned integer"/>
        <Element Offset="3468" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000D8C" DisplayMethod="unsigned integer"/>
        <Element Offset="3496" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000DA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3516" Vartype="Double" Bytesize="8" OffsetHex="00000DBC" DisplayMethod="unsigned integer"/>
        <Element Offset="3524" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000DC4" DisplayMethod="unsigned integer"/>
        <Element Offset="3548" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3556" Vartype="Double" Bytesize="8" OffsetHex="00000DE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3564" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000DEC" DisplayMethod="unsigned integer"/>
        <Element Offset="3592" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000E08" DisplayMethod="unsigned integer"/>
        <Element Offset="3612" Vartype="Double" Bytesize="8" OffsetHex="00000E1C" DisplayMethod="unsigned integer"/>
        <Element Offset="3620" Vartype="Byte" Bytesize="1" OffsetHex="00000E24" DisplayMethod="unsigned integer"/>
        <Element Offset="3621" Vartype="String" Bytesize="4" OffsetHex="00000E25" DisplayMethod="unsigned integer"/>
        <Element Offset="3625" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E29" DisplayMethod="unsigned integer"/>
        <Element Offset="3628" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000E2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3644" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3652" Vartype="Double" Bytesize="8" OffsetHex="00000E44" DisplayMethod="unsigned integer"/>
        <Element Offset="3660" Vartype="Byte" Bytesize="1" OffsetHex="00000E4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3661" Vartype="String" Bytesize="4" OffsetHex="00000E4D" DisplayMethod="unsigned integer"/>
        <Element Offset="3665" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E51" DisplayMethod="unsigned integer"/>
        <Element Offset="3668" Vartype="Float" Bytesize="4" RLECount="5" OffsetHex="00000E54" DisplayMethod="unsigned integer"/>
        <Element Offset="3688" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000E68" DisplayMethod="unsigned integer"/>
        <Element Offset="3708" Vartype="Double" Bytesize="8" OffsetHex="00000E7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3716" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000E84" DisplayMethod="unsigned integer"/>
        <Element Offset="3740" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E9C" DisplayMethod="unsigned integer"/>
        <Element Offset="3748" Vartype="Double" Bytesize="8" OffsetHex="00000EA4" DisplayMethod="unsigned integer"/>
        <Element Offset="3756" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000EAC" DisplayMethod="unsigned integer"/>
        <Element Offset="3784" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000EC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3804" Vartype="Double" Bytesize="8" OffsetHex="00000EDC" DisplayMethod="unsigned integer"/>
        <Element Offset="3812" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000EE4" DisplayMethod="unsigned integer"/>
        <Element Offset="3836" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000EFC" DisplayMethod="unsigned integer"/>
        <Element Offset="3840" Vartype="Float" Bytesize="4" OffsetHex="00000F00" DisplayMethod="unsigned integer"/>
        <Element Offset="3844" Vartype="Double" Bytesize="8" OffsetHex="00000F04" DisplayMethod="unsigned integer"/>
        <Element Offset="3852" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000F0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3880" Vartype="String" Bytesize="4" OffsetHex="00000F28" DisplayMethod="unsigned integer"/>
        <Element Offset="3884" Vartype="Float" Bytesize="4" OffsetHex="00000F2C" DisplayMethod="unsigned integer"/>
        <Element Offset="3888" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F30" DisplayMethod="unsigned integer"/>
        <Element Offset="3900" Vartype="Double" Bytesize="8" OffsetHex="00000F3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3908" Vartype="Float" Bytesize="4" OffsetHex="00000F44" DisplayMethod="unsigned integer"/>
        <Element Offset="3912" Vartype="String" Bytesize="4" OffsetHex="00000F48" DisplayMethod="unsigned integer"/>
        <Element Offset="3916" Vartype="Float" Bytesize="4" RLECount="9" OffsetHex="00000F4C" DisplayMethod="unsigned integer"/>
        <Element Offset="3952" Vartype="String" Bytesize="4" OffsetHex="00000F70" DisplayMethod="unsigned integer"/>
        <Element Offset="3956" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000F74" DisplayMethod="unsigned integer"/>
        <Element Offset="3984" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F90" DisplayMethod="unsigned integer"/>
        <Element Offset="3996" Vartype="Double" Bytesize="8" OffsetHex="00000F9C" DisplayMethod="unsigned integer"/>
        <Element Offset="4004" Vartype="Float" Bytesize="4" RLECount="9" OffsetHex="00000FA4" DisplayMethod="unsigned integer"/>
        <Element Offset="4040" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000FC8" DisplayMethod="unsigned integer"/>
        <Element Offset="4044" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000FCC" DisplayMethod="unsigned integer"/>
        <Element Offset="4068" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000FE4" DisplayMethod="unsigned integer"/>
        <Element Offset="4072" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000FE8" DisplayMethod="unsigned integer"/>
        <Element Offset="4080" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000FF0" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
    <Structure Name="unnamed structure 2" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
      <Elements>
        <Element Offset="0" Vartype="Pointer" Bytesize="8" OffsetHex="00000000" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="4" Vartype="Pointer" Bytesize="8" OffsetHex="00000004" DisplayMethod="unsigned integer"/>
        <Element Offset="8" Vartype="Pointer" Bytesize="8" OffsetHex="00000008" Description="Pointer to instance of kain::KainState" DisplayMethod="unsigned integer"/>
        <Element Offset="12" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="0000000C" DisplayMethod="unsigned integer"/>
        <Element Offset="28" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000001C" DisplayMethod="unsigned integer"/>
        <Element Offset="36" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000024" DisplayMethod="unsigned integer"/>
        <Element Offset="52" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000034" DisplayMethod="unsigned integer"/>
        <Element Offset="56" Vartype="Pointer" Bytesize="8" OffsetHex="00000038" Description="Pointer to instance of Creature" DisplayMethod="unsigned integer"/>
        <Element Offset="60" Vartype="Pointer" Bytesize="8" OffsetHex="0000003C" Description="Pointer to instance of kain::KainState" DisplayMethod="unsigned integer"/>
        <Element Offset="64" Vartype="Pointer" Bytesize="8" OffsetHex="00000040" DisplayMethod="unsigned integer"/>
        <Element Offset="68" Vartype="Pointer" Bytesize="8" OffsetHex="00000044" DisplayMethod="unsigned integer"/>
        <Element Offset="72" Vartype="Pointer" Bytesize="8" OffsetHex="00000048" DisplayMethod="unsigned integer"/>
        <Element Offset="76" Vartype="Pointer" Bytesize="8" OffsetHex="0000004C" DisplayMethod="unsigned integer"/>
        <Element Offset="80" Vartype="Pointer" Bytesize="8" OffsetHex="00000050" DisplayMethod="unsigned integer"/>
        <Element Offset="84" Vartype="Pointer" Bytesize="8" OffsetHex="00000054" DisplayMethod="unsigned integer"/>
        <Element Offset="88" Vartype="Pointer" Bytesize="8" OffsetHex="00000058" DisplayMethod="unsigned integer"/>
        <Element Offset="92" Vartype="Pointer" Bytesize="8" OffsetHex="0000005C" DisplayMethod="unsigned integer"/>
        <Element Offset="96" Vartype="Pointer" Bytesize="8" OffsetHex="00000060" Description="Pointer to instance of goe::OSHeapAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="100" Vartype="Pointer" Bytesize="8" OffsetHex="00000064" DisplayMethod="unsigned integer"/>
        <Element Offset="104" Vartype="Pointer" Bytesize="8" OffsetHex="00000068" Description="Pointer to instance of goe::OSHeapAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="108" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000006C" DisplayMethod="unsigned integer"/>
        <Element Offset="112" Vartype="Float" Bytesize="4" OffsetHex="00000070" DisplayMethod="unsigned integer"/>
        <Element Offset="116" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000074" DisplayMethod="unsigned integer"/>
        <Element Offset="120" Vartype="Pointer" Bytesize="8" OffsetHex="00000078" DisplayMethod="unsigned integer"/>
        <Element Offset="124" Vartype="Pointer" Bytesize="8" OffsetHex="0000007C" DisplayMethod="unsigned integer"/>
        <Element Offset="128" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000080" DisplayMethod="unsigned integer"/>
        <Element Offset="132" Vartype="Pointer" Bytesize="8" OffsetHex="00000084" DisplayMethod="unsigned integer"/>
        <Element Offset="136" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000088" DisplayMethod="unsigned integer"/>
        <Element Offset="140" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="0000008C" DisplayMethod="unsigned integer"/>
        <Element Offset="156" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000009C" DisplayMethod="unsigned integer"/>
        <Element Offset="160" Vartype="Pointer" Bytesize="8" OffsetHex="000000A0" DisplayMethod="unsigned integer"/>
        <Element Offset="164" Vartype="Float" Bytesize="4" OffsetHex="000000A4" DisplayMethod="unsigned integer"/>
        <Element Offset="168" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000000A8" DisplayMethod="unsigned integer"/>
        <Element Offset="176" Vartype="Pointer" Bytesize="8" OffsetHex="000000B0" DisplayMethod="unsigned integer"/>
        <Element Offset="180" Vartype="Double" Bytesize="8" OffsetHex="000000B4" DisplayMethod="unsigned integer"/>
        <Element Offset="188" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000BC" DisplayMethod="unsigned integer"/>
        <Element Offset="192" Vartype="Pointer" Bytesize="8" OffsetHex="000000C0" DisplayMethod="unsigned integer"/>
        <Element Offset="196" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000C4" DisplayMethod="unsigned integer"/>
        <Element Offset="200" Vartype="Double" Bytesize="8" OffsetHex="000000C8" DisplayMethod="unsigned integer"/>
        <Element Offset="208" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000000D0" DisplayMethod="unsigned integer"/>
        <Element Offset="220" Vartype="Double" Bytesize="8" OffsetHex="000000DC" DisplayMethod="unsigned integer"/>
        <Element Offset="228" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000E4" DisplayMethod="unsigned integer"/>
        <Element Offset="232" Vartype="4 Bytes" Bytesize="4" OffsetHex="000000E8" DisplayMethod="hexadecimal"/>
        <Element Offset="236" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000000EC" DisplayMethod="unsigned integer"/>
        <Element Offset="252" Vartype="Pointer" Bytesize="8" OffsetHex="000000FC" DisplayMethod="unsigned integer"/>
        <Element Offset="256" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000100" DisplayMethod="unsigned integer"/>
        <Element Offset="264" Vartype="Pointer" Bytesize="8" OffsetHex="00000108" DisplayMethod="unsigned integer"/>
        <Element Offset="268" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000010C" DisplayMethod="unsigned integer"/>
        <Element Offset="272" Vartype="Pointer" Bytesize="8" OffsetHex="00000110" Description="Pointer to instance of Creature" DisplayMethod="unsigned integer"/>
        <Element Offset="276" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000114" DisplayMethod="unsigned integer"/>
        <Element Offset="280" Vartype="Pointer" Bytesize="8" OffsetHex="00000118" DisplayMethod="unsigned integer"/>
        <Element Offset="284" Vartype="Pointer" Bytesize="8" OffsetHex="0000011C" Description="Pointer to instance of Scamerasetup" DisplayMethod="unsigned integer"/>
        <Element Offset="288" Vartype="Pointer" Bytesize="8" OffsetHex="00000120" DisplayMethod="unsigned integer"/>
        <Element Offset="292" Vartype="Float" Bytesize="4" OffsetHex="00000124" DisplayMethod="unsigned integer"/>
        <Element Offset="296" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000128" DisplayMethod="unsigned integer"/>
        <Element Offset="304" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000130" DisplayMethod="unsigned integer"/>
        <Element Offset="312" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000138" DisplayMethod="unsigned integer"/>
        <Element Offset="316" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="0000013C" DisplayMethod="unsigned integer"/>
        <Element Offset="332" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000014C" DisplayMethod="unsigned integer"/>
        <Element Offset="336" Vartype="Pointer" Bytesize="8" OffsetHex="00000150" DisplayMethod="unsigned integer"/>
        <Element Offset="340" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000154" DisplayMethod="unsigned integer"/>
        <Element Offset="344" Vartype="Pointer" Bytesize="8" OffsetHex="00000158" Description="Pointer to instance of Scamerasetup" DisplayMethod="unsigned integer"/>
        <Element Offset="348" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000015C" DisplayMethod="unsigned integer"/>
        <Element Offset="352" Vartype="Pointer" Bytesize="8" OffsetHex="00000160" DisplayMethod="unsigned integer"/>
        <Element Offset="356" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000164" DisplayMethod="unsigned integer"/>
        <Element Offset="360" Vartype="Pointer" Bytesize="8" OffsetHex="00000168" Description="Pointer to instance of Sgamecamera" DisplayMethod="unsigned integer"/>
        <Element Offset="364" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000016C" DisplayMethod="unsigned integer"/>
        <Element Offset="368" Vartype="Pointer" Bytesize="8" OffsetHex="00000170" DisplayMethod="unsigned integer"/>
        <Element Offset="372" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000174" DisplayMethod="unsigned integer"/>
        <Element Offset="376" Vartype="Pointer" Bytesize="8" OffsetHex="00000178" Description="Pointer to instance of goe::Handle&lt;goe::ScriptObject&gt;" DisplayMethod="unsigned integer"/>
        <Element Offset="380" Vartype="Pointer" Bytesize="8" OffsetHex="0000017C" Description="Pointer to instance of goe::ScriptType" DisplayMethod="unsigned integer"/>
        <Element Offset="384" Vartype="Pointer" Bytesize="8" OffsetHex="00000180" DisplayMethod="unsigned integer"/>
        <Element Offset="388" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="00000184" DisplayMethod="unsigned integer"/>
        <Element Offset="404" Vartype="Pointer" Bytesize="8" OffsetHex="00000194" DisplayMethod="unsigned integer"/>
        <Element Offset="408" Vartype="Pointer" Bytesize="8" OffsetHex="00000198" Description="Pointer to instance of Scamerasetup" DisplayMethod="unsigned integer"/>
        <Element Offset="412" Vartype="Pointer" Bytesize="8" OffsetHex="0000019C" DisplayMethod="unsigned integer"/>
        <Element Offset="416" Vartype="Pointer" Bytesize="8" OffsetHex="000001A0" Description="Pointer to instance of CameraSetup" DisplayMethod="unsigned integer"/>
        <Element Offset="420" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001A4" DisplayMethod="unsigned integer"/>
        <Element Offset="424" Vartype="Pointer" Bytesize="8" OffsetHex="000001A8" DisplayMethod="unsigned integer"/>
        <Element Offset="428" Vartype="Pointer" Bytesize="8" OffsetHex="000001AC" DisplayMethod="unsigned integer"/>
        <Element Offset="432" Vartype="Float" Bytesize="4" OffsetHex="000001B0" DisplayMethod="unsigned integer"/>
        <Element Offset="436" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001B4" DisplayMethod="unsigned integer"/>
        <Element Offset="440" Vartype="Pointer" Bytesize="8" OffsetHex="000001B8" DisplayMethod="unsigned integer"/>
        <Element Offset="444" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001BC" DisplayMethod="unsigned integer"/>
        <Element Offset="448" Vartype="Pointer" Bytesize="8" OffsetHex="000001C0" Description="Pointer to instance of Scamerasetup" DisplayMethod="unsigned integer"/>
        <Element Offset="452" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001C4" DisplayMethod="unsigned integer"/>
        <Element Offset="456" Vartype="Pointer" Bytesize="8" OffsetHex="000001C8" DisplayMethod="unsigned integer"/>
        <Element Offset="460" Vartype="Pointer" Bytesize="8" OffsetHex="000001CC" DisplayMethod="unsigned integer"/>
        <Element Offset="464" Vartype="Float" Bytesize="4" OffsetHex="000001D0" DisplayMethod="unsigned integer"/>
        <Element Offset="468" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001D4" DisplayMethod="unsigned integer"/>
        <Element Offset="472" Vartype="Pointer" Bytesize="8" OffsetHex="000001D8" DisplayMethod="unsigned integer"/>
        <Element Offset="476" Vartype="4 Bytes" Bytesize="4" OffsetHex="000001DC" DisplayMethod="unsigned integer"/>
        <Element Offset="480" Vartype="Pointer" Bytesize="8" OffsetHex="000001E0" Description="Pointer to instance of Ssoundscript" DisplayMethod="unsigned integer"/>
        <Element Offset="484" Vartype="Pointer" Bytesize="8" OffsetHex="000001E4" DisplayMethod="unsigned integer"/>
        <Element Offset="488" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000001E8" DisplayMethod="unsigned integer"/>
        <Element Offset="496" Vartype="Pointer" Bytesize="8" OffsetHex="000001F0" DisplayMethod="unsigned integer"/>
        <Element Offset="500" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="000001F4" DisplayMethod="unsigned integer"/>
        <Element Offset="536" Vartype="Pointer" Bytesize="8" OffsetHex="00000218" Description="Pointer to instance of Effect_111xxxxxxxxxxxxxxxx1xxxxx11xx" DisplayMethod="unsigned integer"/>
        <Element Offset="540" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000021C" DisplayMethod="unsigned integer"/>
        <Element Offset="548" Vartype="Pointer" Bytesize="8" OffsetHex="00000224" DisplayMethod="unsigned integer"/>
        <Element Offset="552" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000228" DisplayMethod="unsigned integer"/>
        <Element Offset="560" Vartype="Pointer" Bytesize="8" OffsetHex="00000230" DisplayMethod="unsigned integer"/>
        <Element Offset="564" Vartype="Pointer" Bytesize="8" OffsetHex="00000234" Description="Pointer to instance of GameParticleEffect" DisplayMethod="unsigned integer"/>
        <Element Offset="568" Vartype="Pointer" Bytesize="8" OffsetHex="00000238" Description="Pointer to instance of goe::ParticleType" DisplayMethod="unsigned integer"/>
        <Element Offset="572" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000023C" DisplayMethod="unsigned integer"/>
        <Element Offset="576" Vartype="Pointer" Bytesize="8" OffsetHex="00000240" Description="Pointer to instance of goe::CollisionModel" DisplayMethod="unsigned integer"/>
        <Element Offset="580" Vartype="Float" Bytesize="4" OffsetHex="00000244" DisplayMethod="unsigned integer"/>
        <Element Offset="584" Vartype="Pointer" Bytesize="8" OffsetHex="00000248" DisplayMethod="unsigned integer"/>
        <Element Offset="588" Vartype="Pointer" Bytesize="8" OffsetHex="0000024C" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="592" Vartype="Pointer" Bytesize="8" OffsetHex="00000250" DisplayMethod="unsigned integer"/>
        <Element Offset="596" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="00000254" DisplayMethod="unsigned integer"/>
        <Element Offset="628" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000274" DisplayMethod="unsigned integer"/>
        <Element Offset="636" Vartype="4 Bytes" Bytesize="4" RLECount="8" OffsetHex="0000027C" DisplayMethod="unsigned integer"/>
        <Element Offset="668" Vartype="Double" Bytesize="8" OffsetHex="0000029C" DisplayMethod="unsigned integer"/>
        <Element Offset="676" Vartype="4 Bytes" Bytesize="4" OffsetHex="000002A4" DisplayMethod="unsigned integer"/>
        <Element Offset="680" Vartype="Pointer" Bytesize="8" OffsetHex="000002A8" DisplayMethod="unsigned integer"/>
        <Element Offset="684" Vartype="Pointer" Bytesize="8" OffsetHex="000002AC" DisplayMethod="unsigned integer"/>
        <Element Offset="688" Vartype="Pointer" Bytesize="8" OffsetHex="000002B0" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="692" Vartype="4 Bytes" Bytesize="4" RLECount="7" OffsetHex="000002B4" DisplayMethod="unsigned integer"/>
        <Element Offset="720" Vartype="Pointer" Bytesize="8" OffsetHex="000002D0" DisplayMethod="unsigned integer"/>
        <Element Offset="724" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000002D4" DisplayMethod="unsigned integer"/>
        <Element Offset="736" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000002E0" DisplayMethod="unsigned integer"/>
        <Element Offset="744" Vartype="4 Bytes" Bytesize="4" RLECount="13" OffsetHex="000002E8" DisplayMethod="unsigned integer"/>
        <Element Offset="796" Vartype="Float" Bytesize="4" OffsetHex="0000031C" DisplayMethod="unsigned integer"/>
        <Element Offset="800" Vartype="Pointer" Bytesize="8" OffsetHex="00000320" DisplayMethod="unsigned integer"/>
        <Element Offset="804" Vartype="Float" Bytesize="4" OffsetHex="00000324" DisplayMethod="unsigned integer"/>
        <Element Offset="808" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000328" DisplayMethod="unsigned integer"/>
        <Element Offset="816" Vartype="Double" Bytesize="8" OffsetHex="00000330" DisplayMethod="unsigned integer"/>
        <Element Offset="824" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000338" DisplayMethod="unsigned integer"/>
        <Element Offset="836" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000344" DisplayMethod="unsigned integer"/>
        <Element Offset="844" Vartype="Double" Bytesize="8" OffsetHex="0000034C" DisplayMethod="unsigned integer"/>
        <Element Offset="852" Vartype="Float" Bytesize="4" RLECount="5" OffsetHex="00000354" DisplayMethod="unsigned integer"/>
        <Element Offset="872" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000368" DisplayMethod="unsigned integer"/>
        <Element Offset="880" Vartype="Float" Bytesize="4" RLECount="8" OffsetHex="00000370" DisplayMethod="unsigned integer"/>
        <Element Offset="912" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="00000390" DisplayMethod="unsigned integer"/>
        <Element Offset="948" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000003B4" DisplayMethod="unsigned integer"/>
        <Element Offset="972" Vartype="4 Bytes" Bytesize="4" OffsetHex="000003CC" DisplayMethod="hexadecimal"/>
        <Element Offset="976" Vartype="Float" Bytesize="4" RLECount="9" OffsetHex="000003D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1012" Vartype="4 Bytes" Bytesize="4" RLECount="14" OffsetHex="000003F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1068" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="0000042C" DisplayMethod="unsigned integer"/>
        <Element Offset="1084" Vartype="Pointer" Bytesize="8" OffsetHex="0000043C" DisplayMethod="unsigned integer"/>
        <Element Offset="1088" Vartype="Double" Bytesize="8" OffsetHex="00000440" DisplayMethod="unsigned integer"/>
        <Element Offset="1096" Vartype="Pointer" Bytesize="8" OffsetHex="00000448" DisplayMethod="unsigned integer"/>
        <Element Offset="1100" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="0000044C" DisplayMethod="unsigned integer"/>
        <Element Offset="1112" Vartype="Float" Bytesize="4" OffsetHex="00000458" DisplayMethod="unsigned integer"/>
        <Element Offset="1116" Vartype="Pointer" Bytesize="8" OffsetHex="0000045C" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="1120" Vartype="Pointer" Bytesize="8" OffsetHex="00000460" DisplayMethod="unsigned integer"/>
        <Element Offset="1124" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000464" DisplayMethod="unsigned integer"/>
        <Element Offset="1128" Vartype="Pointer" Bytesize="8" OffsetHex="00000468" Description="Pointer to instance of GameParticleEffect" DisplayMethod="unsigned integer"/>
        <Element Offset="1132" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="0000046C" DisplayMethod="unsigned integer"/>
        <Element Offset="1140" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000474" DisplayMethod="unsigned integer"/>
        <Element Offset="1144" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000478" DisplayMethod="unsigned integer"/>
        <Element Offset="1152" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000480" DisplayMethod="unsigned integer"/>
        <Element Offset="1156" Vartype="Float" Bytesize="4" OffsetHex="00000484" DisplayMethod="unsigned integer"/>
        <Element Offset="1160" Vartype="Byte" Bytesize="1" RLECount="8" OffsetHex="00000488" DisplayMethod="unsigned integer"/>
        <Element Offset="1168" Vartype="Float" Bytesize="4" RLECount="11" OffsetHex="00000490" DisplayMethod="unsigned integer"/>
        <Element Offset="1212" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000004BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1216" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="000004C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1232" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000004D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1236" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000004D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1248" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000004E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1252" Vartype="Float" Bytesize="4" OffsetHex="000004E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1256" Vartype="Byte" Bytesize="1" OffsetHex="000004E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1257" Vartype="String" Bytesize="7" OffsetHex="000004E9" DisplayMethod="unsigned integer"/>
        <Element Offset="1264" Vartype="Float" Bytesize="4" OffsetHex="000004F0" DisplayMethod="unsigned integer"/>
        <Element Offset="1268" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1272" Vartype="Float" Bytesize="4" OffsetHex="000004F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1276" Vartype="4 Bytes" Bytesize="4" OffsetHex="000004FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1280" Vartype="Float" Bytesize="4" OffsetHex="00000500" DisplayMethod="unsigned integer"/>
        <Element Offset="1284" Vartype="String" Bytesize="4" OffsetHex="00000504" DisplayMethod="unsigned integer"/>
        <Element Offset="1288" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000508" DisplayMethod="unsigned integer"/>
        <Element Offset="1312" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000520" DisplayMethod="unsigned integer"/>
        <Element Offset="1316" Vartype="Float" Bytesize="4" OffsetHex="00000524" DisplayMethod="unsigned integer"/>
        <Element Offset="1320" Vartype="String" Bytesize="5" OffsetHex="00000528" DisplayMethod="unsigned integer"/>
        <Element Offset="1325" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="0000052D" DisplayMethod="unsigned integer"/>
        <Element Offset="1328" Vartype="Float" Bytesize="4" OffsetHex="00000530" DisplayMethod="unsigned integer"/>
        <Element Offset="1332" Vartype="String" Bytesize="7" OffsetHex="00000534" DisplayMethod="unsigned integer"/>
        <Element Offset="1339" Vartype="Byte" Bytesize="1" OffsetHex="0000053B" DisplayMethod="unsigned integer"/>
        <Element Offset="1340" Vartype="Float" Bytesize="4" RLECount="14" OffsetHex="0000053C" DisplayMethod="unsigned integer"/>
        <Element Offset="1396" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000574" DisplayMethod="unsigned integer"/>
        <Element Offset="1400" Vartype="Pointer" Bytesize="8" OffsetHex="00000578" DisplayMethod="unsigned integer"/>
        <Element Offset="1404" Vartype="Pointer" Bytesize="8" OffsetHex="0000057C" DisplayMethod="unsigned integer"/>
        <Element Offset="1408" Vartype="Float" Bytesize="4" OffsetHex="00000580" DisplayMethod="unsigned integer"/>
        <Element Offset="1412" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000584" DisplayMethod="unsigned integer"/>
        <Element Offset="1416" Vartype="String" Bytesize="5" OffsetHex="00000588" DisplayMethod="unsigned integer"/>
        <Element Offset="1421" Vartype="Byte" Bytesize="1" OffsetHex="0000058D" DisplayMethod="unsigned integer"/>
        <Element Offset="1422" Vartype="2 Bytes" Bytesize="2" OffsetHex="0000058E" DisplayMethod="unsigned integer"/>
        <Element Offset="1424" Vartype="Float" Bytesize="4" OffsetHex="00000590" DisplayMethod="unsigned integer"/>
        <Element Offset="1428" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000594" DisplayMethod="unsigned integer"/>
        <Element Offset="1432" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000598" DisplayMethod="unsigned integer"/>
        <Element Offset="1444" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1448" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000005A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1460" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1464" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000005B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1476" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005C4" DisplayMethod="unsigned integer"/>
        <Element Offset="1480" Vartype="Float" Bytesize="4" OffsetHex="000005C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1484" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1488" Vartype="Float" Bytesize="4" OffsetHex="000005D0" DisplayMethod="unsigned integer"/>
        <Element Offset="1492" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1496" Vartype="Float" Bytesize="4" OffsetHex="000005D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1500" Vartype="Byte" Bytesize="1" RLECount="2" OffsetHex="000005DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1502" Vartype="2 Bytes" Bytesize="2" OffsetHex="000005DE" DisplayMethod="unsigned integer"/>
        <Element Offset="1504" Vartype="Float" Bytesize="4" OffsetHex="000005E0" DisplayMethod="unsigned integer"/>
        <Element Offset="1508" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005E4" DisplayMethod="unsigned integer"/>
        <Element Offset="1512" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000005E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1524" Vartype="4 Bytes" Bytesize="4" OffsetHex="000005F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1528" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000005F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1540" Vartype="Double" Bytesize="8" OffsetHex="00000604" DisplayMethod="unsigned integer"/>
        <Element Offset="1548" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000060C" DisplayMethod="unsigned integer"/>
        <Element Offset="1556" Vartype="Double" Bytesize="8" OffsetHex="00000614" DisplayMethod="unsigned integer"/>
        <Element Offset="1564" Vartype="Pointer" Bytesize="8" OffsetHex="0000061C" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="1568" Vartype="Pointer" Bytesize="8" OffsetHex="00000620" DisplayMethod="unsigned integer"/>
        <Element Offset="1572" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000624" DisplayMethod="unsigned integer"/>
        <Element Offset="1576" Vartype="Pointer" Bytesize="8" OffsetHex="00000628" DisplayMethod="unsigned integer"/>
        <Element Offset="1580" Vartype="Pointer" Bytesize="8" OffsetHex="0000062C" DisplayMethod="unsigned integer"/>
        <Element Offset="1584" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000630" DisplayMethod="unsigned integer"/>
        <Element Offset="1592" Vartype="Pointer" Bytesize="8" OffsetHex="00000638" DisplayMethod="unsigned integer"/>
        <Element Offset="1596" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="0000063C" DisplayMethod="unsigned integer"/>
        <Element Offset="1604" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000644" DisplayMethod="unsigned integer"/>
        <Element Offset="1620" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000654" DisplayMethod="unsigned integer"/>
        <Element Offset="1624" Vartype="Pointer" Bytesize="8" OffsetHex="00000658" DisplayMethod="unsigned integer"/>
        <Element Offset="1628" Vartype="Pointer" Bytesize="8" OffsetHex="0000065C" DisplayMethod="unsigned integer"/>
        <Element Offset="1632" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000660" DisplayMethod="unsigned integer"/>
        <Element Offset="1656" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000678" DisplayMethod="unsigned integer"/>
        <Element Offset="1664" Vartype="Pointer" Bytesize="8" OffsetHex="00000680" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1668" Vartype="Pointer" Bytesize="8" OffsetHex="00000684" Description="Pointer to instance of goe::OmniLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1672" Vartype="Float" Bytesize="4" OffsetHex="00000688" DisplayMethod="unsigned integer"/>
        <Element Offset="1676" Vartype="Double" Bytesize="8" OffsetHex="0000068C" DisplayMethod="unsigned integer"/>
        <Element Offset="1684" Vartype="Byte" Bytesize="1" OffsetHex="00000694" DisplayMethod="unsigned integer"/>
        <Element Offset="1685" Vartype="String" Bytesize="7" OffsetHex="00000695" DisplayMethod="unsigned integer"/>
        <Element Offset="1692" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000069C" DisplayMethod="unsigned integer"/>
        <Element Offset="1696" Vartype="Pointer" Bytesize="8" OffsetHex="000006A0" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1700" Vartype="Pointer" Bytesize="8" OffsetHex="000006A4" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1704" Vartype="Float" Bytesize="4" OffsetHex="000006A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1708" Vartype="Double" Bytesize="8" OffsetHex="000006AC" DisplayMethod="unsigned integer"/>
        <Element Offset="1716" Vartype="Float" Bytesize="4" OffsetHex="000006B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1720" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000006B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1724" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006BC" DisplayMethod="unsigned integer"/>
        <Element Offset="1728" Vartype="Pointer" Bytesize="8" OffsetHex="000006C0" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1732" Vartype="Pointer" Bytesize="8" OffsetHex="000006C4" Description="Pointer to instance of goe::OmniLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1736" Vartype="Float" Bytesize="4" OffsetHex="000006C8" DisplayMethod="unsigned integer"/>
        <Element Offset="1740" Vartype="Double" Bytesize="8" OffsetHex="000006CC" DisplayMethod="unsigned integer"/>
        <Element Offset="1748" Vartype="String" Bytesize="4" OffsetHex="000006D4" DisplayMethod="unsigned integer"/>
        <Element Offset="1752" Vartype="Float" Bytesize="4" OffsetHex="000006D8" DisplayMethod="unsigned integer"/>
        <Element Offset="1756" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006DC" DisplayMethod="unsigned integer"/>
        <Element Offset="1760" Vartype="Pointer" Bytesize="8" OffsetHex="000006E0" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1764" Vartype="Pointer" Bytesize="8" OffsetHex="000006E4" Description="Pointer to instance of goe::OmniLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1768" Vartype="Float" Bytesize="4" OffsetHex="000006E8" DisplayMethod="unsigned integer"/>
        <Element Offset="1772" Vartype="Double" Bytesize="8" OffsetHex="000006EC" DisplayMethod="unsigned integer"/>
        <Element Offset="1780" Vartype="Float" Bytesize="4" OffsetHex="000006F4" DisplayMethod="unsigned integer"/>
        <Element Offset="1784" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="000006F8" DisplayMethod="unsigned integer"/>
        <Element Offset="1788" Vartype="4 Bytes" Bytesize="4" OffsetHex="000006FC" DisplayMethod="unsigned integer"/>
        <Element Offset="1792" Vartype="Pointer" Bytesize="8" OffsetHex="00000700" Description="Pointer to instance of goe::SpotLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1796" Vartype="Pointer" Bytesize="8" OffsetHex="00000704" Description="Pointer to instance of goe::OmniLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1800" Vartype="Pointer" Bytesize="8" OffsetHex="00000708" Description="Pointer to instance of goe::OmniLight" DisplayMethod="unsigned integer"/>
        <Element Offset="1804" Vartype="Double" Bytesize="8" OffsetHex="0000070C" DisplayMethod="unsigned integer"/>
        <Element Offset="1812" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000714" DisplayMethod="unsigned integer"/>
        <Element Offset="1820" Vartype="4 Bytes" Bytesize="4" RLECount="9" OffsetHex="0000071C" DisplayMethod="unsigned integer"/>
        <Element Offset="1856" Vartype="Pointer" Bytesize="8" OffsetHex="00000740" DisplayMethod="unsigned integer"/>
        <Element Offset="1860" Vartype="Pointer" Bytesize="8" OffsetHex="00000744" DisplayMethod="unsigned integer"/>
        <Element Offset="1864" Vartype="Double" Bytesize="8" OffsetHex="00000748" DisplayMethod="unsigned integer"/>
        <Element Offset="1872" Vartype="Float" Bytesize="4" OffsetHex="00000750" DisplayMethod="unsigned integer"/>
        <Element Offset="1876" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000754" DisplayMethod="unsigned integer"/>
        <Element Offset="1880" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000758" DisplayMethod="unsigned integer"/>
        <Element Offset="1892" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000764" DisplayMethod="unsigned integer"/>
        <Element Offset="1900" Vartype="Double" Bytesize="8" OffsetHex="0000076C" DisplayMethod="unsigned integer"/>
        <Element Offset="1908" Vartype="Pointer" Bytesize="8" OffsetHex="00000774" Description="Pointer to instance of goe::FixedAllocator" DisplayMethod="unsigned integer"/>
        <Element Offset="1912" Vartype="Pointer" Bytesize="8" OffsetHex="00000778" DisplayMethod="unsigned integer"/>
        <Element Offset="1916" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000077C" DisplayMethod="unsigned integer"/>
        <Element Offset="1920" Vartype="Pointer" Bytesize="8" OffsetHex="00000780" DisplayMethod="unsigned integer"/>
        <Element Offset="1924" Vartype="Pointer" Bytesize="8" OffsetHex="00000784" DisplayMethod="unsigned integer"/>
        <Element Offset="1928" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000788" DisplayMethod="unsigned integer"/>
        <Element Offset="1940" Vartype="Double" Bytesize="8" OffsetHex="00000794" DisplayMethod="unsigned integer"/>
        <Element Offset="1948" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="0000079C" DisplayMethod="unsigned integer"/>
        <Element Offset="1956" Vartype="Pointer" Bytesize="8" OffsetHex="000007A4" DisplayMethod="unsigned integer"/>
        <Element Offset="1960" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000007A8" DisplayMethod="unsigned integer"/>
        <Element Offset="1968" Vartype="Pointer" Bytesize="8" OffsetHex="000007B0" DisplayMethod="unsigned integer"/>
        <Element Offset="1972" Vartype="Pointer" Bytesize="8" OffsetHex="000007B4" DisplayMethod="unsigned integer"/>
        <Element Offset="1976" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="000007B8" DisplayMethod="unsigned integer"/>
        <Element Offset="1984" Vartype="4 Bytes" Bytesize="4" OffsetHex="000007C0" DisplayMethod="unsigned integer"/>
        <Element Offset="1988" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="000007C4" DisplayMethod="unsigned integer"/>
        <Element Offset="2000" Vartype="4 Bytes" Bytesize="4" RLECount="4" OffsetHex="000007D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2016" Vartype="Double" Bytesize="8" OffsetHex="000007E0" DisplayMethod="unsigned integer"/>
        <Element Offset="2024" Vartype="Pointer" Bytesize="8" OffsetHex="000007E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2028" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="000007EC" DisplayMethod="unsigned integer"/>
        <Element Offset="2040" Vartype="Double" Bytesize="8" OffsetHex="000007F8" DisplayMethod="unsigned integer"/>
        <Element Offset="2048" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000800" DisplayMethod="unsigned integer"/>
        <Element Offset="2060" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000080C" DisplayMethod="unsigned integer"/>
        <Element Offset="2064" Vartype="Pointer" Bytesize="8" OffsetHex="00000810" DisplayMethod="unsigned integer"/>
        <Element Offset="2068" Vartype="Pointer" Bytesize="8" OffsetHex="00000814" DisplayMethod="unsigned integer"/>
        <Element Offset="2072" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000818" DisplayMethod="unsigned integer"/>
        <Element Offset="2092" Vartype="Double" Bytesize="8" OffsetHex="0000082C" DisplayMethod="unsigned integer"/>
        <Element Offset="2100" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000834" DisplayMethod="unsigned integer"/>
        <Element Offset="2112" Vartype="Float" Bytesize="4" RLECount="3" OffsetHex="00000840" DisplayMethod="unsigned integer"/>
        <Element Offset="2124" Vartype="4 Bytes" Bytesize="4" OffsetHex="0000084C" DisplayMethod="unsigned integer"/>
        <Element Offset="2128" Vartype="Pointer" Bytesize="8" OffsetHex="00000850" DisplayMethod="unsigned integer"/>
        <Element Offset="2132" Vartype="Pointer" Bytesize="8" OffsetHex="00000854" DisplayMethod="unsigned integer"/>
        <Element Offset="2136" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000858" DisplayMethod="unsigned integer"/>
        <Element Offset="2164" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000874" DisplayMethod="unsigned integer"/>
        <Element Offset="2184" Vartype="Double" Bytesize="8" OffsetHex="00000888" DisplayMethod="unsigned integer"/>
        <Element Offset="2192" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000890" DisplayMethod="unsigned integer"/>
        <Element Offset="2216" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000008A8" DisplayMethod="unsigned integer"/>
        <Element Offset="2224" Vartype="Double" Bytesize="8" OffsetHex="000008B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2232" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="000008B8" DisplayMethod="unsigned integer"/>
        <Element Offset="2260" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000008D4" DisplayMethod="unsigned integer"/>
        <Element Offset="2280" Vartype="Double" Bytesize="8" OffsetHex="000008E8" DisplayMethod="unsigned integer"/>
        <Element Offset="2288" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000008F0" DisplayMethod="unsigned integer"/>
        <Element Offset="2312" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000908" DisplayMethod="unsigned integer"/>
        <Element Offset="2320" Vartype="Double" Bytesize="8" OffsetHex="00000910" DisplayMethod="unsigned integer"/>
        <Element Offset="2328" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000918" DisplayMethod="unsigned integer"/>
        <Element Offset="2356" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000934" DisplayMethod="unsigned integer"/>
        <Element Offset="2376" Vartype="Double" Bytesize="8" OffsetHex="00000948" DisplayMethod="unsigned integer"/>
        <Element Offset="2384" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000950" DisplayMethod="unsigned integer"/>
        <Element Offset="2408" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000968" DisplayMethod="unsigned integer"/>
        <Element Offset="2416" Vartype="Double" Bytesize="8" OffsetHex="00000970" DisplayMethod="unsigned integer"/>
        <Element Offset="2424" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000978" DisplayMethod="unsigned integer"/>
        <Element Offset="2452" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000994" DisplayMethod="unsigned integer"/>
        <Element Offset="2472" Vartype="Double" Bytesize="8" OffsetHex="000009A8" DisplayMethod="unsigned integer"/>
        <Element Offset="2480" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="000009B0" DisplayMethod="unsigned integer"/>
        <Element Offset="2504" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="000009C8" DisplayMethod="unsigned integer"/>
        <Element Offset="2512" Vartype="Double" Bytesize="8" OffsetHex="000009D0" DisplayMethod="unsigned integer"/>
        <Element Offset="2520" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="000009D8" DisplayMethod="unsigned integer"/>
        <Element Offset="2548" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="000009F4" DisplayMethod="unsigned integer"/>
        <Element Offset="2568" Vartype="Double" Bytesize="8" OffsetHex="00000A08" DisplayMethod="unsigned integer"/>
        <Element Offset="2576" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000A10" DisplayMethod="unsigned integer"/>
        <Element Offset="2600" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A28" DisplayMethod="unsigned integer"/>
        <Element Offset="2608" Vartype="Double" Bytesize="8" OffsetHex="00000A30" DisplayMethod="unsigned integer"/>
        <Element Offset="2616" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000A38" DisplayMethod="unsigned integer"/>
        <Element Offset="2644" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000A54" DisplayMethod="unsigned integer"/>
        <Element Offset="2664" Vartype="Double" Bytesize="8" OffsetHex="00000A68" DisplayMethod="unsigned integer"/>
        <Element Offset="2672" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000A70" DisplayMethod="unsigned integer"/>
        <Element Offset="2696" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000A88" DisplayMethod="unsigned integer"/>
        <Element Offset="2704" Vartype="Double" Bytesize="8" OffsetHex="00000A90" DisplayMethod="unsigned integer"/>
        <Element Offset="2712" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000A98" DisplayMethod="unsigned integer"/>
        <Element Offset="2740" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000AB4" DisplayMethod="unsigned integer"/>
        <Element Offset="2760" Vartype="Double" Bytesize="8" OffsetHex="00000AC8" DisplayMethod="unsigned integer"/>
        <Element Offset="2768" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000AD0" DisplayMethod="unsigned integer"/>
        <Element Offset="2792" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000AE8" DisplayMethod="unsigned integer"/>
        <Element Offset="2800" Vartype="Double" Bytesize="8" OffsetHex="00000AF0" DisplayMethod="unsigned integer"/>
        <Element Offset="2808" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000AF8" DisplayMethod="unsigned integer"/>
        <Element Offset="2836" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000B14" DisplayMethod="unsigned integer"/>
        <Element Offset="2856" Vartype="Double" Bytesize="8" OffsetHex="00000B28" DisplayMethod="unsigned integer"/>
        <Element Offset="2864" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000B30" DisplayMethod="unsigned integer"/>
        <Element Offset="2888" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000B48" DisplayMethod="unsigned integer"/>
        <Element Offset="2896" Vartype="Double" Bytesize="8" OffsetHex="00000B50" DisplayMethod="unsigned integer"/>
        <Element Offset="2904" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000B58" DisplayMethod="unsigned integer"/>
        <Element Offset="2932" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000B74" DisplayMethod="unsigned integer"/>
        <Element Offset="2952" Vartype="Double" Bytesize="8" OffsetHex="00000B88" DisplayMethod="unsigned integer"/>
        <Element Offset="2960" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000B90" DisplayMethod="unsigned integer"/>
        <Element Offset="2984" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000BA8" DisplayMethod="unsigned integer"/>
        <Element Offset="2992" Vartype="Double" Bytesize="8" OffsetHex="00000BB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3000" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000BB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3028" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000BD4" DisplayMethod="unsigned integer"/>
        <Element Offset="3048" Vartype="Double" Bytesize="8" OffsetHex="00000BE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3056" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000BF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3080" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C08" DisplayMethod="unsigned integer"/>
        <Element Offset="3088" Vartype="Double" Bytesize="8" OffsetHex="00000C10" DisplayMethod="unsigned integer"/>
        <Element Offset="3096" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000C18" DisplayMethod="unsigned integer"/>
        <Element Offset="3124" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000C34" DisplayMethod="unsigned integer"/>
        <Element Offset="3144" Vartype="Double" Bytesize="8" OffsetHex="00000C48" DisplayMethod="unsigned integer"/>
        <Element Offset="3152" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000C50" DisplayMethod="unsigned integer"/>
        <Element Offset="3176" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000C68" DisplayMethod="unsigned integer"/>
        <Element Offset="3184" Vartype="Double" Bytesize="8" OffsetHex="00000C70" DisplayMethod="unsigned integer"/>
        <Element Offset="3192" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000C78" DisplayMethod="unsigned integer"/>
        <Element Offset="3220" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000C94" DisplayMethod="unsigned integer"/>
        <Element Offset="3240" Vartype="Double" Bytesize="8" OffsetHex="00000CA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3248" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000CB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3272" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000CC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3280" Vartype="Double" Bytesize="8" OffsetHex="00000CD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3288" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000CD8" DisplayMethod="unsigned integer"/>
        <Element Offset="3316" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000CF4" DisplayMethod="unsigned integer"/>
        <Element Offset="3336" Vartype="Double" Bytesize="8" OffsetHex="00000D08" DisplayMethod="unsigned integer"/>
        <Element Offset="3344" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000D10" DisplayMethod="unsigned integer"/>
        <Element Offset="3368" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D28" DisplayMethod="unsigned integer"/>
        <Element Offset="3376" Vartype="Double" Bytesize="8" OffsetHex="00000D30" DisplayMethod="unsigned integer"/>
        <Element Offset="3384" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000D38" DisplayMethod="unsigned integer"/>
        <Element Offset="3412" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000D54" DisplayMethod="unsigned integer"/>
        <Element Offset="3432" Vartype="Double" Bytesize="8" OffsetHex="00000D68" DisplayMethod="unsigned integer"/>
        <Element Offset="3440" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000D70" DisplayMethod="unsigned integer"/>
        <Element Offset="3464" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000D88" DisplayMethod="unsigned integer"/>
        <Element Offset="3472" Vartype="Double" Bytesize="8" OffsetHex="00000D90" DisplayMethod="unsigned integer"/>
        <Element Offset="3480" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000D98" DisplayMethod="unsigned integer"/>
        <Element Offset="3508" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000DB4" DisplayMethod="unsigned integer"/>
        <Element Offset="3528" Vartype="Double" Bytesize="8" OffsetHex="00000DC8" DisplayMethod="unsigned integer"/>
        <Element Offset="3536" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000DD0" DisplayMethod="unsigned integer"/>
        <Element Offset="3560" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000DE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3568" Vartype="Double" Bytesize="8" OffsetHex="00000DF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3576" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000DF8" DisplayMethod="unsigned integer"/>
        <Element Offset="3604" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000E14" DisplayMethod="unsigned integer"/>
        <Element Offset="3624" Vartype="Double" Bytesize="8" OffsetHex="00000E28" DisplayMethod="unsigned integer"/>
        <Element Offset="3632" Vartype="Byte" Bytesize="1" OffsetHex="00000E30" DisplayMethod="unsigned integer"/>
        <Element Offset="3633" Vartype="String" Bytesize="4" OffsetHex="00000E31" DisplayMethod="unsigned integer"/>
        <Element Offset="3637" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E35" DisplayMethod="unsigned integer"/>
        <Element Offset="3640" Vartype="Float" Bytesize="4" RLECount="4" OffsetHex="00000E38" DisplayMethod="unsigned integer"/>
        <Element Offset="3656" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000E48" DisplayMethod="unsigned integer"/>
        <Element Offset="3664" Vartype="Double" Bytesize="8" OffsetHex="00000E50" DisplayMethod="unsigned integer"/>
        <Element Offset="3672" Vartype="Byte" Bytesize="1" OffsetHex="00000E58" DisplayMethod="unsigned integer"/>
        <Element Offset="3673" Vartype="String" Bytesize="4" OffsetHex="00000E59" DisplayMethod="unsigned integer"/>
        <Element Offset="3677" Vartype="Byte" Bytesize="1" RLECount="3" OffsetHex="00000E5D" DisplayMethod="unsigned integer"/>
        <Element Offset="3680" Vartype="Float" Bytesize="4" RLECount="5" OffsetHex="00000E60" DisplayMethod="unsigned integer"/>
        <Element Offset="3700" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000E74" DisplayMethod="unsigned integer"/>
        <Element Offset="3720" Vartype="Double" Bytesize="8" OffsetHex="00000E88" DisplayMethod="unsigned integer"/>
        <Element Offset="3728" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000E90" DisplayMethod="unsigned integer"/>
        <Element Offset="3752" Vartype="4 Bytes" Bytesize="4" RLECount="2" OffsetHex="00000EA8" DisplayMethod="unsigned integer"/>
        <Element Offset="3760" Vartype="Double" Bytesize="8" OffsetHex="00000EB0" DisplayMethod="unsigned integer"/>
        <Element Offset="3768" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000EB8" DisplayMethod="unsigned integer"/>
        <Element Offset="3796" Vartype="4 Bytes" Bytesize="4" RLECount="5" OffsetHex="00000ED4" DisplayMethod="unsigned integer"/>
        <Element Offset="3816" Vartype="Double" Bytesize="8" OffsetHex="00000EE8" DisplayMethod="unsigned integer"/>
        <Element Offset="3824" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000EF0" DisplayMethod="unsigned integer"/>
        <Element Offset="3848" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000F08" DisplayMethod="unsigned integer"/>
        <Element Offset="3852" Vartype="Float" Bytesize="4" OffsetHex="00000F0C" DisplayMethod="unsigned integer"/>
        <Element Offset="3856" Vartype="Double" Bytesize="8" OffsetHex="00000F10" DisplayMethod="unsigned integer"/>
        <Element Offset="3864" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000F18" DisplayMethod="unsigned integer"/>
        <Element Offset="3892" Vartype="String" Bytesize="4" OffsetHex="00000F34" DisplayMethod="unsigned integer"/>
        <Element Offset="3896" Vartype="Float" Bytesize="4" OffsetHex="00000F38" DisplayMethod="unsigned integer"/>
        <Element Offset="3900" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F3C" DisplayMethod="unsigned integer"/>
        <Element Offset="3912" Vartype="Double" Bytesize="8" OffsetHex="00000F48" DisplayMethod="unsigned integer"/>
        <Element Offset="3920" Vartype="Float" Bytesize="4" OffsetHex="00000F50" DisplayMethod="unsigned integer"/>
        <Element Offset="3924" Vartype="String" Bytesize="4" OffsetHex="00000F54" DisplayMethod="unsigned integer"/>
        <Element Offset="3928" Vartype="Float" Bytesize="4" RLECount="9" OffsetHex="00000F58" DisplayMethod="unsigned integer"/>
        <Element Offset="3964" Vartype="String" Bytesize="4" OffsetHex="00000F7C" DisplayMethod="unsigned integer"/>
        <Element Offset="3968" Vartype="Float" Bytesize="4" RLECount="7" OffsetHex="00000F80" DisplayMethod="unsigned integer"/>
        <Element Offset="3996" Vartype="4 Bytes" Bytesize="4" RLECount="3" OffsetHex="00000F9C" DisplayMethod="unsigned integer"/>
        <Element Offset="4008" Vartype="Double" Bytesize="8" OffsetHex="00000FA8" DisplayMethod="unsigned integer"/>
        <Element Offset="4016" Vartype="Float" Bytesize="4" RLECount="9" OffsetHex="00000FB0" DisplayMethod="unsigned integer"/>
        <Element Offset="4052" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000FD4" DisplayMethod="unsigned integer"/>
        <Element Offset="4056" Vartype="Float" Bytesize="4" RLECount="6" OffsetHex="00000FD8" DisplayMethod="unsigned integer"/>
        <Element Offset="4080" Vartype="Byte" Bytesize="1" RLECount="4" OffsetHex="00000FF0" DisplayMethod="unsigned integer"/>
        <Element Offset="4084" Vartype="Float" Bytesize="4" RLECount="2" OffsetHex="00000FF4" DisplayMethod="unsigned integer"/>
        <Element Offset="4092" Vartype="4 Bytes" Bytesize="4" OffsetHex="00000FFC" DisplayMethod="unsigned integer"/>
      </Elements>
    </Structure>
  </Structures>
  <Comments>Version, Retail, 1.02, probably works with GOG and Steam as well
</Comments>
</CheatTable>
