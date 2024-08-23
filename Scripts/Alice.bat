set injector=..\Injector.exe %~3%
set target=%~1
set script=scripts\Alice.ahk
start %injector% -target "%target%" -script %script% -d3D -1 ^
-TextSwap samples=4;thumbnail=256;path=d?\games\Alice\Textures;^
next=[;prev=];dump=home;switch=end;color_switch=del