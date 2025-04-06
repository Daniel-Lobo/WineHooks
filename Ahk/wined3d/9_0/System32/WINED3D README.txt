===WineD3D for Windows For 64 bit Applications===
DirectX 1-11 to OpenGL wrapper.
THIS IS FOR 64 BIT APPS ON 64 BIT WINDOWS ONLY!
FOR 32 BIT APPS ON 32 OR 64 BIT WINDOWS, USE THE REGULAR WINED3D FOR WINDOWS!

==What is it good for?==
WineD3D for Windows can be very useful to get old games to work properly on newer systems, especially Windows 8 and newer since they lack 16 bit screen modes.

==System requirements==
Microsoft Windows XP or newer (x64); Windows RT is not supported
OpenGL compatible video card and driver

==Instructions==
For DirectX 8 games:
copy d3d8.dll and wined3d.dll in the game's executable directory

For DirectX 9 games:
copy d3d9.dll and wined3d.dll in the game's executable directory

For DirectX 10 games:
copy d3d10.dll, d3d10core.dll, d3d10_1.dll and wined3d.dll in the game's executable directory

For DirectX 11 games:
copy d3d11.dll, dxgi.dll and wined3d.dll in the game's executable directory

For DirectX<=7 games:
copy ddraw.dll, and wined3d.dll in the game's executable directory

Warning:
Do NOT copy any of these files into Windows\System32, Windows\SysWoW64 or any path included in the PATH environment variable or Windows will no longer work!

==Limitations==
WineD3D is far from perfect, and many games will not work.
Also, keep in mind that sometimes you must be a bit creative to get old games to work. PCGamingWiki is a pretty good source of information.

==Source code?==
You can get the build scripts I use from here: https://github.com/adolfintel/wined3d4win

