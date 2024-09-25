<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>18</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
alloc(hp, 128)
label(hp_ret)
label(hp2)
label(hp_ret2)

hp:
  mov [esp+14],eax
  push eax
  mov ax, 3ef
  mov [edx+22],ax
  pop eax
  cmp [edx+22],cx
jmp hp_ret

hp2:
  mov eax,[tombati.exe+5EE6C]
  mov cx, 3ef
  mov [eax+22],cx
  movsx ecx,word ptr [eax+22]
jmp hp_ret2

tombati.exe+E0BE:
  jmp hp
  nop
  nop
  nop
hp_ret:

tombati.exe+1DD19:
  jmp hp2
  db 90 90 90 90
hp_ret2:

//tombati.exe+27B8C:
  //db 90 90 90 90 90

[disable]
tombati.exe+E0BE:
  mov [esp+14],eax
  cmp [edx+22],cx

tombati.exe+1DD19:
  mov eax,[tombati.exe+5EE6C]
  movsx ecx,word ptr [eax+22]

//tombati.exe+27B8C:
  //add word ptr [esi+22],-05

dealloc(*)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>19</ID>
      <Description>"B - inf Bullets"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
tombati.exe+274CC:
  nop


[disable]
tombati.exe+274CC:
  dec ecx


</AssemblerScript>
    </CheatEntry>
  </CheatEntries>
  <UserdefinedSymbols/>
  <Comments>Version: tombati</Comments>
</CheatTable>
