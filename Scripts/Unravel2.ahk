;REMOTE SCRIPT START
InstallHook("TerminateProcess", p, "Kernel32.dll" , "TerminateProcess")

TerminateProcess(p1, p2)
{
    return
}