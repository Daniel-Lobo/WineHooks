@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %Injector% -target "%target%" -d3D 2 /HD /32bit /singlecore ^
-script "Scripts\Resident Evil 2.ahk" -gamespeed 1.0 -compatlayer "WIN95 HIGHDPIAWARE" ^
-#compatlayer "WINXPSP2 HIGHDPIAWARE" /hideBorder -controller ^
A=1;B=2;X=3;Y=4;^
LEFT_SHOULDER=5;^
RIGHT_SHOULDER=6;^
bLeftTrigger=3;^
bRightTrigger=8;^
start=8;back=9;^
LEFT_THUMB=10;^
RIGHT_THUMB=11; ^
-TextSwap path=d?\Games\ResidentEvil2\Textures;^
samples=4;thumbnail=256;next=pgup;prev=pgdn;^
dump=home;switch=end;color_switch=del;nopopins=true ^
-dshow 1.0x 