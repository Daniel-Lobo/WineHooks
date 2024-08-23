@echo off
set target=%~1
set injector=..\Injector.exe %~3%
set textures=%~2%\Tomb2Fix\textures
start %injector% -target "%target%" -script "Scripts\Tomb2.ahk" /!PSXAspect ^
-compatlayer WinXPSp2 -d3D 2 /singlecore create_links deinterlace -FMV_scale 1.0 ^
/hideBorder -#args setup macros /dshow ^
controller ^
A=1;B=2;X=3;Y=4;^
LEFT_SHOULDER=5;^
RIGHT_SHOULDER=6;^
bLeftTrigger=7;^
bRightTrigger=8;^
start=9;back=10;^
LEFT_THUMB=11;^
RIGHT_THUMB=12; ^
-TextSwap "path=%Textures%;samples=4;thumbnail=256;next=];prev=[;dump=p;switch=i;color_switch=o;nopopins=false"  