<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>11</ID>
      <Description>"Table Help"</Description>
      <GroupHeader>1</GroupHeader>
    </CheatEntry>
    <CheatEntry>
      <ID>15</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Dragon.rfl+85EB8:
  nop
  nop
  nop


[disable]
Dragon.rfl+85EB8:
mov [esi+04],edx







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>18</ID>
      <Description>"K - easy Kills"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Dragon.rfl+119473:
sub ecx,ecx

[disable]
Dragon.rfl+119473:
sub ecx,eax







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>21</ID>
      <Description>"M - inf Magic"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
Dragon.rfl+6099C:
  nop
  nop
  nop
  nop
  nop
  nop

[disable]
// Magic
Dragon.rfl+6099C:
  mov [ebp+0000018E],ecx









</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>22</ID>
      <Description>"B - inf dragon Breath"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(dragon, 512)
label(dragon_retpoint)

dragon:
  fstp st(0)
  //fstp dword ptr [eax+00000696]
  mov byte ptr [eax+00000696], c8
jmp dragon_retpoint

Dragon.rfl+4A842:
  jmp dragon
  nop
dragon_retpoint:

[disable]
// breath
Dragon.rfl+4A842:
  fstp dword ptr [eax+00000696]
dealloc(*)







</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>19</ID>
      <Description>"Auto - Dragon.rfl+831EC"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(flags, 512)
label(elixirs_flag)
label(arrows_flag)
registersymbol(arrows_flag)
registersymbol(elixirs_flag)
label(elixirs)
label(elixirs_retpoint)
label(arrows)
label(finish)

flags:
elixirs_flag:
  db 00 00 00 00
arrows_flag:
  db 00 00 00 00

elixirs:
  cmp [edi+c], 0
  je arrows
  cmp [elixirs_flag], 00
  je finish
  mov [edi+2A],eax
jmp elixirs_retpoint

arrows:
  cmp [arrows_flag], 00
  je finish
  mov [edi+2A],eax
jmp elixirs_retpoint

finish:
  sub eax,ecx
  mov [edi+2A],eax
jmp elixirs_retpoint

Dragon.rfl+831EC:
  jmp elixirs
elixirs_retpoint:

[disable]
//arrows, health elixirs
Dragon.rfl+831EC:
  sub eax,ecx
  mov [edi+2A],eax

  fstp dword ptr [eax+00000696]
dealloc(*)







</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>20</ID>
          <Description>"U - Unbreakable weapons and inf arrows"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
arrows_flag:
  db 00 00 00 01

Dragon.rfl+E3B19:
  nop
  nop
  nop

Dragon.rfl+B4D32:
  nop
  nop
  nop

[disable]
// Bow durability
Dragon.rfl+B4D32:
  mov [ebx+08],ecx

// durability
Dragon.rfl+E3B19:
  mov [esi+08],eax

arrows_flag:
  db 00 00 00 00











</AssemblerScript>
        </CheatEntry>
        <CheatEntry>
          <ID>24</ID>
          <Description>"P - inf Potions"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
elixirs_flag:
  db 00 00 00 01

Dragon.rfl+8116D:
  nop
  nop
  nop

[disable]
// Invisibility potions
Dragon.rfl+8116D:
  mov [ecx+2A],esi

elixirs_flag:
  db 00 00 00 00











</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>23</ID>
      <Description>"Left overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>17</ID>
          <Description>"Power up"</Description>
          <VariableType>Auto Assembler Script</VariableType>
          <AssemblerScript>[enable]
alloc(dragon, 512)
label(dragon_retpoint)

Dragon.rfl+E3B19:
  nop
  nop
  nop

Dragon.rfl+B4D32:
  nop
  nop
  nop

Dragon.rfl+831EC:
  nop
  nop

Dragon.rfl+6099C:
  nop
  nop
  nop
  nop
  nop
  nop

Dragon.rfl+8116D:
  nop
  nop
  nop

dragon:
  fstp st(0)
  //fstp dword ptr [eax+00000696]
  mov byte ptr [eax+00000696], c8
jmp dragon_retpoint

Dragon.rfl+4A842:
  jmp dragon
  nop
dragon_retpoint:

[disable]
// Bow durability
Dragon.rfl+B4D32:
  mov [ebx+08],ecx

// durability
Dragon.rfl+E3B19:
  mov [esi+08],eax

//arrows, health elixirs
Dragon.rfl+831EC:
  sub eax,ecx

// Magic
Dragon.rfl+6099C:
  mov [ebp+0000018E],ecx

// Invisibility potions
Dragon.rfl+8116D:
  mov [ecx+2A],esi

// breath
Dragon.rfl+4A842:
  fstp dword ptr [eax+00000696]
dealloc(*)







</AssemblerScript>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: 377/477, with AIO patch: https://www.moddb.com/games/drakan-order-of-the-flame/downloads/drakan-aio-unofficial-patch
HP, player and enemies: 4 bytes. Encrypted
Weapons durability:     4 bytes. Encrypted
Weapons Magic:          4 bytes. Encrypted
Invisibility potions:   4 bytes. Encrypted
Arrows:                 4 bytes. Code shared with health elixirs. Values is the same seen on the HUD\Inventory
Dragon breath:          float.   100
</Comments>
</CheatTable>
