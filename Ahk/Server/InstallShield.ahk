version=%1%
setup=setupv%version%.exe 
runwait, ..\injector.exe src\injector.txt -f InstallShield\InstallShield.ini, ..\
process, Wait, %setup%
process, Waitclose, %setup%
run Server.exe 