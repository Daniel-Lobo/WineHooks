@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %injector% -target "%target%" -d3D 3 -script "scripts\Resident Evil 3.ahk" ^
/singlecore -textsize 1024 -compatlayer WinXPSP2 -dshow ^
-TextSwap samples=4;thumbnail=256;path=d?\games\ResidentEvil3\Textures;quick=shift;^
next=PgUP;prev=PgDn;dump=home;switch=del;color_switch=ins ^
-controller ^
A=1;B=2;X=3;Y=4;^
LEFT_SHOULDER=5;^
RIGHT_SHOULDER=6;^
bLeftTrigger=3;^
bRightTrigger=8;^
start=8;back=9;^
LEFT_THUMB=10;^
RIGHT_THUMB=11; 