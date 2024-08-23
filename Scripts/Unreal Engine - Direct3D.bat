@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %injector% -target "%target%" -d3D 7 /gamma /singlecore /HD ^
fovfx -compatlayer WinXPSp2 -script Scripts\DeusEx.ahk
