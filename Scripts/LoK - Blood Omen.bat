@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %injector% -target "%target%" -script "Scripts\Kain.ahk" ^
/upScale /ddraw /8bitColorfix -compatlayer win98 ^
-controller ^
A=1;B=2;X=3;Y=4;^
LEFT_SHOULDER=6;^
RIGHT_SHOULDER=8;^
bLeftTrigger=7;^
bRightTrigger=inf_items;^
back=10;^
start=9;^
LEFT_THUMB=health;^
RIGHT_THUMB=magic; ^
-FMVscale 1.0 ^   ::increase this value to make the FMVs bigger, use
                  ::MonitorHeight/480 for the bigger size possible 

::Cheats:
::Health    -> Refills Kain blood
::Magic     -> Refills Kain magic
::inf_items -> When you use an item, its amount remains the same

