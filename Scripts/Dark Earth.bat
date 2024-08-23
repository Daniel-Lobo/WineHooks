@echo off
set target=%~1
set injector=..\Injector.exe %~3%
start %injector% -target "%target%" -script "Scripts\Dark Earth.ahk" ^
-mods ? -compatlayer win95 /no_argv0 /ddraw /upScale /controller ^
-args "%~1-1 32K" ^
-FMVscale 1.0

