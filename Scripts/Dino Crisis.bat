@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %injector% -target "%target%" -d3D 3 /HD /32bit ^
/console /hideborder -FMVscale 1.0 wide ManageTextures macros controllerA ^
-args "2231325" -script "scripts\dino crisis.ahk" /singlecore ^
-TextSwap samples=4;thumbnail=256;path=d?\games\DinoCrisis\Textures;quick=shift;^
next=[;prev=];dump=home;switch=end;color_switch=del;nopopins ^ 