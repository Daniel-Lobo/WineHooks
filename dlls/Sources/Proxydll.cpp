#include <windows.h>
#include "Dbug.h"
#include <shlwapi.h>
#include <string>
#include "Sync.h"

struct  {
    BOOL    Initalized;
    HMODULE hProxy;
    SYNC::Atomic * lock;
    // COM
    LPVOID Dll_GetClassObject;
    LPVOID DllRegisterServer;
    LPVOID DllUnregisterServer;
    LPVOID Dll_CanUnloadNow;
    // dinput.dll
    LPVOID DirectInputCreateA;
    LPVOID DirectInputCreateEx;
    LPVOID DirectInputCreateW;       
    // ddraw.dll
    LPVOID AcquireDDThreadLock;
    LPVOID CompleteCreateSysmemSurface;
    LPVOID D3DParseUnknownCommand;
    LPVOID DDGetAttachedSurfaceLcl;
    LPVOID DDInternalLock;
    LPVOID DDInternalUnlock;
    LPVOID DSoundHelp;
    LPVOID DirectDrawCreate;
    LPVOID DirectDrawCreateClipper;
    LPVOID DirectDrawCreateEx;
    LPVOID DirectDrawEnumerateA;
    LPVOID DirectDrawEnumerateW;
    LPVOID DirectDrawEnumerateExA;
    LPVOID DirectDrawEnumerateExW;
    LPVOID GetDDSurfaceLocal;
    LPVOID GetOLEThunkData;
    LPVOID GetSurfaceFromDC;
    LPVOID RegisterSpecialCase;
    LPVOID ReleaseDDThreadLock;
    LPVOID SetAppCompatData;
}PROXYEXPORTS;

void ProxyInitImports()
{
    if (PROXYEXPORTS.Initalized)    return;
    PROXYEXPORTS.Initalized         = TRUE;
    PROXYEXPORTS.lock = new SYNC::Atomic();
    PROXYEXPORTS.lock->Set(1);

    char   name[MAX_PATH];
    char windir[MAX_PATH];
    std::string   dllpath;
    HMODULE      hRealDll;

    GetEnvironmentVariableA("WINDIR", windir, MAX_PATH);
    GetModuleFileNameA(PROXYEXPORTS.hProxy, name, MAX_PATH);

    dllpath.append(windir);
    dllpath.append("\\SysWOW64\\");
    dllpath.append(PathFindFileNameA(name));
    OUTPUT_FUNC_DBG_STRING( dllpath.c_str() );

    if   ( std::string( PathFindFileNameA(name) ) == std::string("DDRAW.dll") )
    {
        OUTPUT_FUNC_DBG_STRING( dllpath.c_str() );
        hRealDll = LoadLibraryA( dllpath.c_str() );
        if (hRealDll == nullptr) OUTPUT_FUNC_DBG_STRING("....");
        PROXYEXPORTS.AcquireDDThreadLock  = GetProcAddress(hRealDll, "AcquireDDThreadLock");;
        PROXYEXPORTS.CompleteCreateSysmemSurface  = GetProcAddress(hRealDll, "CompleteCreateSysmemSurface");;
        PROXYEXPORTS.D3DParseUnknownCommand  = GetProcAddress(hRealDll, "D3DParseUnknownCommand");;
        PROXYEXPORTS.DDGetAttachedSurfaceLcl  = GetProcAddress(hRealDll, "DDGetAttachedSurfaceLcl");;
        PROXYEXPORTS.DDInternalLock  = GetProcAddress(hRealDll, "DDInternalLock");;
        PROXYEXPORTS.DDInternalUnlock  = GetProcAddress(hRealDll, "DDInternalUnlock");;
        PROXYEXPORTS.DSoundHelp  = GetProcAddress(hRealDll, "DSoundHelp");;
        PROXYEXPORTS.DirectDrawCreate  = GetProcAddress(hRealDll, "DirectDrawCreate");;
        PROXYEXPORTS.DirectDrawCreateClipper  = GetProcAddress(hRealDll, "DirectDrawCreateClipper");;
        PROXYEXPORTS.DirectDrawCreateEx  = GetProcAddress(hRealDll, "DirectDrawCreateEx");;
        PROXYEXPORTS.DirectDrawEnumerateA  = GetProcAddress(hRealDll, "DirectDrawEnumerateA");;
        PROXYEXPORTS.DirectDrawEnumerateW  = GetProcAddress(hRealDll, "DirectDrawEnumerateW");;
        PROXYEXPORTS.DirectDrawEnumerateExA  = GetProcAddress(hRealDll, "DirectDrawEnumerateExA");;
        PROXYEXPORTS.DirectDrawEnumerateExW  = GetProcAddress(hRealDll, "DirectDrawEnumerateExW");;
        PROXYEXPORTS.GetDDSurfaceLocal  = GetProcAddress(hRealDll, "GetDDSurfaceLocal");;
        PROXYEXPORTS.GetOLEThunkData  = GetProcAddress(hRealDll, "GetOLEThunkData");;
        PROXYEXPORTS.GetSurfaceFromDC  = GetProcAddress(hRealDll, "GetSurfaceFromDC");;
        PROXYEXPORTS.RegisterSpecialCase  = GetProcAddress(hRealDll, "RegisterSpecialCase");;
        PROXYEXPORTS.ReleaseDDThreadLock  = GetProcAddress(hRealDll, "ReleaseDDThreadLock");;
        PROXYEXPORTS.SetAppCompatData  = GetProcAddress(hRealDll, "SetAppCompatData");;

    }
    else if ( std::string( PathFindFileNameA(name) ) == std::string("DINPUT.dll") )
    {
        OUTPUT_FUNC_DBG_STRING( dllpath.c_str() );
        hRealDll = LoadLibraryA( dllpath.c_str() );
        PROXYEXPORTS.DirectInputCreateA  = GetProcAddress(hRealDll, "DirectInputCreateA");
        PROXYEXPORTS.DirectInputCreateW  = GetProcAddress(hRealDll, "DirectInputCreateW");
        PROXYEXPORTS.DirectInputCreateEx = GetProcAddress(hRealDll, "DirectInputCreateEx");
    }
    PROXYEXPORTS.Dll_CanUnloadNow    = GetProcAddress(hRealDll, "DllCanUnloadNow");
    PROXYEXPORTS.Dll_GetClassObject  = GetProcAddress(hRealDll, "DllGetClassObject");
    PROXYEXPORTS.DllRegisterServer   = GetProcAddress(hRealDll, "DllRegisterServer");
    PROXYEXPORTS.DllUnregisterServer = GetProcAddress(hRealDll, "DllUnregisterServer");
}

void __stdcall ProxyResume()
{
     #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
     PROXYEXPORTS.lock->Set(0);
}

__declspec(dllexport) __attribute__ ((naked)) void DirectDrawCreate()
{
     #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
     ProxyInitImports();
     LPTSTR env_var[100];
     if (GetEnvironmentVariableA("Peixoto.HWND", (LPSTR)env_var, 100))
     {
         if (GetModuleHandleA("peixoto.dll") == nullptr)
         {
             UINT hwnd  = RegisterWindowMessageA("Peixoto.Hwnd");
             SendNotifyMessage(HWND_BROADCAST, hwnd, 0, GetCurrentProcessId());
             while (PROXYEXPORTS.lock->Get()) Sleep(500);
         }
     }
     __asm__ volatile("jmp *%0" : "=r" (PROXYEXPORTS.DirectDrawCreate));
}

__declspec(dllexport) __attribute__ ((naked)) void DirectInputCreateEx()
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    ProxyInitImports();
    LPTSTR env_var[100];
    if (GetEnvironmentVariableA("Peixoto.HWND", (LPSTR)env_var, 100))
    {
        if (GetModuleHandleA("peixoto.dll") == nullptr)
        {
            UINT hwnd = RegisterWindowMessageA("Peixoto.Hwnd");
            SendNotifyMessage(HWND_BROADCAST, hwnd, 0, GetCurrentProcessId());
            while (PROXYEXPORTS.lock->Get()) Sleep(500);
        }
    }
    __asm__ volatile("jmp *%0" : "=r" (PROXYEXPORTS.DirectInputCreateEx));
}

#define PROXYEXPORT(procName) \
extern "C" __declspec(dllexport) __attribute__ ((naked))  void procName() \
{ \
    ProxyInitImports(); \
    OUTPUT_FUNC_DBG_STRING( "OK" ); \
    if (PROXYEXPORTS.procName == nullptr) OUTPUT_FUNC_DBG_STRING( "FUBAR" ); \
    __asm__ ("jmp *%0" : "=r" (PROXYEXPORTS.procName)); \
};

// COM
PROXYEXPORT(Dll_CanUnloadNow)
#pragma comment(linker, "/EXPORT:DllCanUnloadNow=_Dll_CanUnloadNow")
PROXYEXPORT(Dll_GetClassObject)
#pragma comment(linker, "/EXPORT:DllGetClassObject=_Dll_GetClassObject")
PROXYEXPORT(DllRegisterServer)
#pragma comment(linker, "/EXPORT:DllRegisterServer=_DllRegisterServer")
PROXYEXPORT(DllUnregisterServer)
#pragma comment(linker, "/EXPORT:DllUnregisterServer=_DllUnregisterServer")

// dinput.dll
PROXYEXPORT(DirectInputCreateA)
#pragma comment(linker, "/EXPORT:DirectInputCreateA=_DirectInputCreateA")
PROXYEXPORT(DirectInputCreateW)
#pragma comment(linker, "/EXPORT:DirectInputCreateW=_DirectInputCreateW")
//PROXYEXPORT(DirectInputCreateEx)
//#pragma comment(linker, "/EXPORT:DirectInputCreateEx=_DirectInputCreateEx")

// ddraw.dll
PROXYEXPORT(AcquireDDThreadLock)
#pragma comment(linker, "/EXPORT:AcquireDDThreadLock=_AcquireDDThreadLock")
PROXYEXPORT(CompleteCreateSysmemSurface)
#pragma comment(linker, "/EXPORT:CompleteCreateSysmemSurface=_CompleteCreateSysmemSurface")
PROXYEXPORT(D3DParseUnknownCommand)
#pragma comment(linker, "/EXPORT:D3DParseUnknownCommand=_D3DParseUnknownCommand")
PROXYEXPORT(DDGetAttachedSurfaceLcl)
#pragma comment(linker, "/EXPORT:DDGetAttachedSurfaceLcl=_DDGetAttachedSurfaceLcl")
PROXYEXPORT(DDInternalLock)
#pragma comment(linker, "/EXPORT:DDInternalLock=_DDInternalLock")
PROXYEXPORT(DDInternalUnlock)
#pragma comment(linker, "/EXPORT:DDInternalUnlock=_DDInternalUnlock")
PROXYEXPORT(DSoundHelp)
#pragma comment(linker, "/EXPORT:DSoundHelp=_DSoundHelp")
//PROXYEXPORT(DirectDrawCreate)
//#pragma comment(linker, "/EXPORT:DirectDrawCreate=_DirectDrawCreate")
PROXYEXPORT(DirectDrawCreateClipper)
#pragma comment(linker, "/EXPORT:DirectDrawCreateClipper=_DirectDrawCreateClipper")
PROXYEXPORT(DirectDrawCreateEx)
#pragma comment(linker, "/EXPORT:DirectDrawCreateEx=_DirectDrawCreateEx")
PROXYEXPORT(DirectDrawEnumerateA)
#pragma comment(linker, "/EXPORT:DirectDrawEnumerateA=_DirectDrawEnumerateA")
PROXYEXPORT(DirectDrawEnumerateW)
#pragma comment(linker, "/EXPORT:DirectDrawEnumerateW=_DirectDrawEnumerateW")
PROXYEXPORT(DirectDrawEnumerateExA)
#pragma comment(linker, "/EXPORT:DirectDrawEnumerateExA=_DirectDrawEnumerateExA")
PROXYEXPORT(DirectDrawEnumerateExW)
#pragma comment(linker, "/EXPORT:DirectDrawEnumerateExW=_DirectDrawEnumerateExW")
PROXYEXPORT(GetDDSurfaceLocal)
#pragma comment(linker, "/EXPORT:GetDDSurfaceLocal=_GetDDSurfaceLocal")
PROXYEXPORT(GetOLEThunkData)
#pragma comment(linker, "/EXPORT:GetOLEThunkData=_GetOLEThunkData")
PROXYEXPORT(GetSurfaceFromDC)
#pragma comment(linker, "/EXPORT:GetSurfaceFromDC=_GetSurfaceFromDC")
PROXYEXPORT(RegisterSpecialCase)
#pragma comment(linker, "/EXPORT:RegisterSpecialCase=_RegisterSpecialCase")
PROXYEXPORT(ReleaseDDThreadLock)
#pragma comment(linker, "/EXPORT:ReleaseDDThreadLock=_ReleaseDDThreadLock")
PROXYEXPORT(SetAppCompatData)
#pragma comment(linker, "/EXPORT:SetAppCompatData=_SetAppCompatData")


void ProxyDllInit(HMODULE hMod)
{
    PROXYEXPORTS.Initalized = FALSE;
    PROXYEXPORTS.hProxy     = hMod;
}
