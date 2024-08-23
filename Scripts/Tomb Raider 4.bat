@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %injector% -target "%target%" -script Scripts\Tomb4.ahk -#args setup ^
create_links -d3D 3 -compatlayer WinXP /hideBorder /!PSXAspect ^
-TextSwap path=d?\Games\TombRaider4\Textures;^
samples=4;thumbnail=256;next=];prev=[;^
dump=o;switch=i;color_switch=u ^
-controller ^
A=1;B=2;X=3;Y=4;^
LEFT_SHOULDER=5;^
RIGHT_SHOULDER=6;^
bLeftTrigger=7;^
bRightTrigger=8;^
start=9;back=10;^
LEFT_THUMB=11;^
RIGHT_THUMB=12;^
deadzone=0.25 ^  