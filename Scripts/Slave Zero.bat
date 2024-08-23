@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %injector% -target "%target%" /ManageTextures /gamma /hideborder /32bit ^
-d3D 3 /HD -!TextSwap samples=4;thumbnail=256;path=d?\Games\d3d_SlaveZero\Textures;quick=shift;^
next=[;prev=];dump=home;switch=end;color_switch=del;nopopins=true 
