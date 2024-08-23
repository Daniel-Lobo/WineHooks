@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %injector% -target "%target%" -compatlayer WinXPSp2 /!PSXAspect ^
-d3D 2 /singlecore -script scripts\Tomb3.ahk create_links ^
-#args setup ^
-controller ^
A=1;B=2;X=3;Y=4;^
LEFT_SHOULDER=5;^
RIGHT_SHOULDER=6;^
bLeftTrigger=7;^
bRightTrigger=8;^
start=9;back=10;^
LEFT_THUMB=11;^
RIGHT_THUMB=12; ^
-TextSwap ^
"path=d?\Games\TombRaider3(Gold)\Textures;samples=4;thumbnail=256;next=];prev=[;dump=p;switch=i;color_switch=o;nopopins=false"  