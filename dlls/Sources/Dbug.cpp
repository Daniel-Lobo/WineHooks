#include "Dbug.h"
#include <windows.h>
#include <string>
#include "dllmain.h"

void OutPutFuncDbgString(const char * func, const char * message)
{
    std::string msg(func);
    msg.append(": ");
    msg.append(message);
    OutputDebugStringA(msg.c_str());
}

