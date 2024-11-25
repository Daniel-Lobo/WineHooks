exe=%2%
table=%1%
StringReplace, table, table, ..\cheats\, ,
loader=
(LTRIM
<?xml version="1.0" encoding="utf-8"?>
<CheatTable CheatEngineTableVersion="31">
  <CheatEntries/>
  <UserdefinedSymbols/>
  <LuaScript>fs  = require'lfs'
dir = lfs.currentdir()
pex = string.gsub(dir, "Cheats", "peixoto64.dll")
p   = loadPlugin(pex)
stringlist_add(getAutoAttachList(),"%exe%")
loadTable("%table%")
--[[print(pex)]]--
</LuaScript>
</CheatTable>
)
Filedelete, %A_mydocuments%\WineHooks\CheatTables\CheatEngine.ct
FileAppend, %loader%, %A_mydocuments%\WineHooks\CheatTables\CheatEngine.ct
run, %A_mydocuments%\WineHooks\CheatTables\CheatEngine.ct
