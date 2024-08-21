<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>7</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>4</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(player_hit)
aobscanmodule(player_hit, "GameAssembly.dll", 89 42 08 BA ** ** ** ** 48 8B 0D ** ** ** ** E8 ** ** ** **)
registersymbol(read_hp)
aobscanmodule(read_hp, "GameAssembly.dll", 89 42 08 0F 28 7C 24 40 0F 28 74 24 50 48 8B 5C 24 78 44 0F 28 44 24 30)

player_hit:
  nop
  nop
  nop

[disable]
player_hit:
  mov [rdx+08],eax
unregistersymbol(player_hit)
unregistersymbol(read_hp)
</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>6</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(enemy_hit)
aobscanmodule(enemy_hit, "GameAssembly.dll", 2B F8 89 7B 18 F3 41 0F 10 B4 24 90 00 00 00 48 8B 05 ** ** ** ** F6 ** ** ** ** 00 04)

enemy_hit:
  sub edi,edi

[disable]
enemy_hit:
  sub edi,eax
unregistersymbol(enemy_hit)
</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>3</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
registersymbol(fire)
aobscanmodule(fire, "GameAssembly.dll", FF 49 44 48 8B 05 ** ** ** ** F6 80 33 01 00 00 04 74 ** 83 B8 E0 00 00 00 00)

fire:
  nop
  nop
  nop

[disable]
fire:
  dec [rcx+44]
unregistersymbol(fire)
</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: Steam\Goldberg, 1.0
HP:       4 bytes. Starts at 100
Enemy HP: 4 bytes. 1st enemy is 35, 1st boss 200
Bullets:  4 bytes. Same value shown in the inventory
</Comments>
</CheatTable>
