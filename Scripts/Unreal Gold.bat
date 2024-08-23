@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %injector% -target "%target%" -d3D -1 /singlecore /HD ^
fovfx -compatlayer WinXPSp2 -script Scripts\DeusEx.ahk ^
-!TextSwap samples=4;thumbnail=256;path=d?\Games\Unreal\Textures;^
next=p;prev=o;dump=home;switch=u;color_switch=c;quick=shift