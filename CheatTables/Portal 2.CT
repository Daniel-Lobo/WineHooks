<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>6</ID>
      <Description>"P - Portals (almost) anywhere"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscanmodule(portals_anywhere, server.dll, 83 7A 30 00 74 * C7 85 18 FF FF FF 00 00 00 00)
aobscanmodule(portals_anywhere2, server.dll, 83 78 30 00 0F 85 * * * * D9 07)
aobscanmodule(portals_anywhere3, server.dll, 83 79 30 00 74 0A C7 86 44 05 00 00 00 00 00 00)
registersymbol(portals_anywhere)
registersymbol(portals_anywhere2)
registersymbol(portals_anywhere3)


portals_anywhere:
  db 83 7A 30 01

//portals_anywhere2:
  //db 83 7A 30 01

//portals_anywhere3:
  //db 83 7A 30 01


[disable]
portals_anywhere:
  db 83 7A 30 00
//portals_anywhere2:
  //db 83 7A 30 00
//portals_anywhere3:
  //db 83 7A 30 00
unregistersymbol(portals_anywhere)
unregistersymbol(portals_anywhere2)
unregistersymbol(portals_anywhere3)
</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>9</ID>
      <Description>"H - inf HP"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
//alloc(hit_new_code, 68)
aobscanmodule(hit, server.dll, 8B 86 F0 FD FF FF 8B 90 E0 02 00 00 8D 8E F0 FD FF FF 56 FF D2 89 3E 5F 5E 5D C2 04 00)
registersymbol(hit)
//label(hit_ret)

hit+15:
  nop
  nop

[disable]
hit+15:
  mov [esi],edi
//dealloc(*)
unregistersymbol(hit)

</AssemblerScript>
    </CheatEntry>
    <CheatEntry>
      <ID>7</ID>
      <Description>"Left overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>5</ID>
          <Description>"Portals"</Description>
          <VariableType>Byte</VariableType>
          <Address>client.dll+92BEA8</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>4</ID>
          <Description>"Cheats"</Description>
          <VariableType>Byte</VariableType>
          <Address>engine.dll+666280</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>8</ID>
          <Description>"God"</Description>
          <ShowAsHex>1</ShowAsHex>
          <VariableType>Byte</VariableType>
          <Address>server.dll+87CFAE</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <CheatCodes>
    <CodeEntry>
      <Description>Code :mov [edi+ecx*2+00000432],ax</Description>
      <AddressString>nvd3dum.dll+11D1D9D</AddressString>
      <Before>
        <Byte>57</Byte>
        <Byte>32</Byte>
        <Byte>04</Byte>
        <Byte>00</Byte>
        <Byte>00</Byte>
      </Before>
      <Actual>
        <Byte>66</Byte>
        <Byte>89</Byte>
        <Byte>84</Byte>
        <Byte>4F</Byte>
        <Byte>32</Byte>
        <Byte>04</Byte>
        <Byte>00</Byte>
        <Byte>00</Byte>
      </Actual>
      <After>
        <Byte>B8</Byte>
        <Byte>FF</Byte>
        <Byte>FF</Byte>
        <Byte>00</Byte>
        <Byte>00</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Code :cmp dword ptr [edx+30],00</Description>
      <AddressString>server.dll+137FA9</AddressString>
      <Before>
        <Byte>15</Byte>
        <Byte>24</Byte>
        <Byte>C3</Byte>
        <Byte>10</Byte>
        <Byte>69</Byte>
      </Before>
      <Actual>
        <Byte>83</Byte>
        <Byte>7A</Byte>
        <Byte>30</Byte>
        <Byte>00</Byte>
      </Actual>
      <After>
        <Byte>74</Byte>
        <Byte>0C</Byte>
        <Byte>C7</Byte>
        <Byte>85</Byte>
        <Byte>18</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Code :cmp dword ptr [eax+30],00</Description>
      <AddressString>server.dll+269068</AddressString>
      <Before>
        <Byte>A1</Byte>
        <Byte>24</Byte>
        <Byte>C3</Byte>
        <Byte>10</Byte>
        <Byte>69</Byte>
      </Before>
      <Actual>
        <Byte>83</Byte>
        <Byte>78</Byte>
        <Byte>30</Byte>
        <Byte>00</Byte>
      </Actual>
      <After>
        <Byte>0F</Byte>
        <Byte>85</Byte>
        <Byte>B8</Byte>
        <Byte>00</Byte>
        <Byte>00</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Code :cmp dword ptr [ecx+30],00</Description>
      <AddressString>server.dll+1173C</AddressString>
      <Before>
        <Byte>0D</Byte>
        <Byte>24</Byte>
        <Byte>C3</Byte>
        <Byte>10</Byte>
        <Byte>69</Byte>
      </Before>
      <Actual>
        <Byte>83</Byte>
        <Byte>79</Byte>
        <Byte>30</Byte>
        <Byte>00</Byte>
      </Actual>
      <After>
        <Byte>74</Byte>
        <Byte>0A</Byte>
        <Byte>C7</Byte>
        <Byte>86</Byte>
        <Byte>44</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Change of mov edx,[eax+00000084]</Description>
      <AddressString>server.dll+2BBCA9</AddressString>
      <Before>
        <Byte>8D</Byte>
        <Byte>71</Byte>
        <Byte>69</Byte>
        <Byte>8B</Byte>
        <Byte>01</Byte>
      </Before>
      <Actual>
        <Byte>8B</Byte>
        <Byte>90</Byte>
        <Byte>84</Byte>
        <Byte>00</Byte>
        <Byte>00</Byte>
        <Byte>00</Byte>
      </Actual>
      <After>
        <Byte>56</Byte>
        <Byte>FF</Byte>
        <Byte>D2</Byte>
        <Byte>80</Byte>
        <Byte>BE</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Change of mov [edx],ecx</Description>
      <AddressString>client.dll+EF7AC</AddressString>
      <Before>
        <Byte>48</Byte>
        <Byte>08</Byte>
        <Byte>8B</Byte>
        <Byte>55</Byte>
        <Byte>10</Byte>
      </Before>
      <Actual>
        <Byte>89</Byte>
        <Byte>0A</Byte>
      </Actual>
      <After>
        <Byte>5D</Byte>
        <Byte>C3</Byte>
        <Byte>55</Byte>
        <Byte>8B</Byte>
        <Byte>EC</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Code :mov [esi],edi</Description>
      <AddressString>server.dll+79D9B</AddressString>
      <Before>
        <Byte>FF</Byte>
        <Byte>FF</Byte>
        <Byte>56</Byte>
        <Byte>FF</Byte>
        <Byte>D2</Byte>
      </Before>
      <Actual>
        <Byte>89</Byte>
        <Byte>3E</Byte>
      </Actual>
      <After>
        <Byte>5F</Byte>
        <Byte>5E</Byte>
        <Byte>5D</Byte>
        <Byte>C2</Byte>
        <Byte>04</Byte>
      </After>
    </CodeEntry>
  </CheatCodes>
  <UserdefinedSymbols/>
</CheatTable>
