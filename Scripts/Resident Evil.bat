@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %Injector% -target "%target%" ^
-script "Scripts\Resident Evil.ahk" -d3D 1 /HD /32bit -frametime 40.0 ^
dsound create_links -compatlayer win95 -args /blaster ^
-controller ^
A=1;B=2;X=3;Y=4;^
LEFT_SHOULDER=5;^
RIGHT_SHOULDER=6;^
bLeftTrigger=3;^
bRightTrigger=8;^
start=8;back=9;^
LEFT_THUMB=10;^
RIGHT_THUMB=11; ^
-TextSwap samples=4;thumbnail=256;path=d?\Games\ResidentEvil\Textures;^
next=pgup;prev=pgdn;dump=home;switch=end;color_switch=del;nopopins