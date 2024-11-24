#include <windows.h>
#include "dllmain.h"

typedef BOOL (WINAPI  *CREATEPROCESS)(LPVOID,LPVOID,LPVOID,LPVOID,BOOL,DWORD,
                                      LPVOID,LPVOID,LPVOID,LPVOID);

typedef struct _LPCREATEPROCESS {
    CREATEPROCESS A;
    CREATEPROCESS W;
}LPCREATEPROCESS;
 LPCREATEPROCESS pCreateProcess;

extern "C" __declspec(dllexport) void InitCreateProcessHook(void* a, void * w)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    pCreateProcess.A = (CREATEPROCESS)a;
    pCreateProcess.W = (CREATEPROCESS)w;    
}

extern "C" __declspec(dllexport) BOOL WINAPI CreateProcessAHook(LPVOID a, LPVOID b, LPVOID c, LPVOID d, BOOL e,
                               DWORD f, LPVOID g, LPVOID h, LPVOID i, LPVOID j)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    BOOL err = pCreateProcess.A(a,b,c,d,e,f,g,h,i,j);
    return err;
}

extern "C" __declspec(dllexport) BOOL WINAPI CreateProcessWHook(LPVOID a, LPVOID b, LPVOID c, LPVOID d, BOOL e,
                               DWORD f, LPVOID g, LPVOID h, LPVOID i, LPVOID j)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    Critical(1);
    BOOL err = pCreateProcess.W(a,b,c,d,e,f,g,h,i,j);
    Critical(0);
    return err;
}
