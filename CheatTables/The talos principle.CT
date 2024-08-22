<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="42">
  <CheatEntries>
    <CheatEntry>
      <ID>2</ID>
      <Description>"Auto"</Description>
      <VariableType>Auto Assembler Script</VariableType>
      <AssemblerScript>[enable]
aobscanmodule(clip, Talos.exe, 39 1D *  *  *  * 41 0F 45 DD 44 39 25)
alloc(clip_offset, 16, clip)
registersymbol(clip)
registersymbol(clip_offset)

clip_offset:
  Readmem(clip+2, 4)

[disable]
dealloc(*)
unregistersymbol(*)
</AssemblerScript>
      <CheatEntries>
        <CheatEntry>
          <ID>5</ID>
          <Description>"Auto - cheats"</Description>
          <ShowAsSigned>0</ShowAsSigned>
          <VariableType>4 Bytes</VariableType>
          <Address>[clip_offset]+clip-2</Address>
          <CheatEntries>
            <CheatEntry>
              <ID>6</ID>
              <Description>"N - No clip"</Description>
              <ShowAsSigned>0</ShowAsSigned>
              <VariableType>4 Bytes</VariableType>
              <Address>[clip_offset]+clip+6</Address>
            </CheatEntry>
          </CheatEntries>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
    <CheatEntry>
      <ID>7</ID>
      <Description>"Left Overs"</Description>
      <Options moHideChildren="1"/>
      <GroupHeader>1</GroupHeader>
      <CheatEntries>
        <CheatEntry>
          <ID>0</ID>
          <Description>"cheats"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>Talos.exe+1DB82C0</Address>
        </CheatEntry>
        <CheatEntry>
          <ID>1</ID>
          <Description>"ghost"</Description>
          <VariableType>4 Bytes</VariableType>
          <Address>Talos.exe+1DB82C8</Address>
        </CheatEntry>
      </CheatEntries>
    </CheatEntry>
  </CheatEntries>
  <CheatCodes>
    <CodeEntry>
      <Description>cheats</Description>
      <AddressString>Talos.exe+81FF89</AddressString>
      <Before>
        <Byte>00</Byte>
        <Byte>85</Byte>
        <Byte>C0</Byte>
        <Byte>75</Byte>
        <Byte>0C</Byte>
      </Before>
      <Actual>
        <Byte>8B</Byte>
        <Byte>05</Byte>
        <Byte>31</Byte>
        <Byte>83</Byte>
        <Byte>59</Byte>
        <Byte>01</Byte>
      </Actual>
      <After>
        <Byte>48</Byte>
        <Byte>83</Byte>
        <Byte>C4</Byte>
        <Byte>20</Byte>
        <Byte>5B</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>clip</Description>
      <AddressString>Talos.exe+8B467F</AddressString>
      <Before>
        <Byte>F6</Byte>
        <Byte>FF</Byte>
        <Byte>41</Byte>
        <Byte>8B</Byte>
        <Byte>DC</Byte>
      </Before>
      <Actual>
        <Byte>39</Byte>
        <Byte>1D</Byte>
        <Byte>43</Byte>
        <Byte>3C</Byte>
        <Byte>50</Byte>
        <Byte>01</Byte>
      </Actual>
      <After>
        <Byte>41</Byte>
        <Byte>0F</Byte>
        <Byte>45</Byte>
        <Byte>DD</Byte>
        <Byte>44</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Change of mov [Talos.exe+1DB82C8],eax</Description>
      <AddressString>Talos.exe+81FF48</AddressString>
      <Before>
        <Byte>05</Byte>
        <Byte>84</Byte>
        <Byte>83</Byte>
        <Byte>59</Byte>
        <Byte>01</Byte>
      </Before>
      <Actual>
        <Byte>89</Byte>
        <Byte>05</Byte>
        <Byte>7A</Byte>
        <Byte>83</Byte>
        <Byte>59</Byte>
        <Byte>01</Byte>
      </Actual>
      <After>
        <Byte>48</Byte>
        <Byte>83</Byte>
        <Byte>C4</Byte>
        <Byte>20</Byte>
        <Byte>5B</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Change of je Talos.exe+8B4695</Description>
      <AddressString>Talos.exe+8B4690</AddressString>
      <Before>
        <Byte>25</Byte>
        <Byte>3C</Byte>
        <Byte>3C</Byte>
        <Byte>50</Byte>
        <Byte>01</Byte>
      </Before>
      <Actual>
        <Byte>74</Byte>
        <Byte>03</Byte>
      </Actual>
      <After>
        <Byte>83</Byte>
        <Byte>CB</Byte>
        <Byte>02</Byte>
        <Byte>44</Byte>
        <Byte>39</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Change of je Talos.exe+8B46A1</Description>
      <AddressString>Talos.exe+8B469C</AddressString>
      <Before>
        <Byte>25</Byte>
        <Byte>3C</Byte>
        <Byte>3C</Byte>
        <Byte>50</Byte>
        <Byte>01</Byte>
      </Before>
      <Actual>
        <Byte>74</Byte>
        <Byte>03</Byte>
      </Actual>
      <After>
        <Byte>83</Byte>
        <Byte>CB</Byte>
        <Byte>40</Byte>
        <Byte>44</Byte>
        <Byte>39</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Change of je Talos.exe+8B46AD</Description>
      <AddressString>Talos.exe+8B46A8</AddressString>
      <Before>
        <Byte>25</Byte>
        <Byte>50</Byte>
        <Byte>3C</Byte>
        <Byte>50</Byte>
        <Byte>01</Byte>
      </Before>
      <Actual>
        <Byte>74</Byte>
        <Byte>03</Byte>
      </Actual>
      <After>
        <Byte>83</Byte>
        <Byte>CB</Byte>
        <Byte>04</Byte>
        <Byte>44</Byte>
        <Byte>39</Byte>
      </After>
    </CodeEntry>
    <CodeEntry>
      <Description>Change of je Talos.exe+8B46BA</Description>
      <AddressString>Talos.exe+8B46B4</AddressString>
      <Before>
        <Byte>25</Byte>
        <Byte>48</Byte>
        <Byte>3C</Byte>
        <Byte>50</Byte>
        <Byte>01</Byte>
      </Before>
      <Actual>
        <Byte>74</Byte>
        <Byte>04</Byte>
      </Actual>
      <After>
        <Byte>0F</Byte>
        <Byte>BA</Byte>
        <Byte>EB</Byte>
        <Byte>08</Byte>
        <Byte>44</Byte>
      </After>
    </CodeEntry>
  </CheatCodes>
  <UserdefinedSymbols/>
  <Comments>cht_bEnableCheats = 3
cht_bGhost = 1 
</Comments>
</CheatTable>
