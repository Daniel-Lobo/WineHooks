@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %injector% -target "%target%" /ManageTextures -script Scripts\Shogo.ahk -d3D 3 /HD /32bit /hideBorder ^
-args "-windowtitle Shogo -rez shogo.rez -rez sound.rez -rez custom\WidescreenPatch.rez -rez ShogoP.rez +multiplayer 0 +EnableOptSurf 1 +EnableMultiTex 1" ^
-!TextSwap samples=4;thumbnail=256;path=d?\games\Shogo\Textures;quick=shift;^
next=[;prev=];dump=home;switch=end;color_switch=del;nopopins=true ^
/#cheats




