#include <windows.h>
#include <shlobj.h>
#include <Shlwapi.h>
#include <wchar.h>
#include <Psapi.h>
#include <string>
#include "sethooks.h"
#include "Dbug.h"
#include "dllmain.h"
#include "MinHook.h"
#include "dllmain.h"
#include "cepluginsdk.h"
#pragma comment(lib, "Shell32")

struct _CHEATENGINE {
    ExportedFunctions   CEFuncs;
    int                 id;
} CE;

typedef HANDLE (WINAPI * CreateFileWType)
(LPCWSTR, DWORD, DWORD, LPSECURITY_ATTRIBUTES, DWORD, DWORD,HANDLE);
CreateFileWType CEPlugin_pCreateFileW;

extern "C" __declspec(dllexport) void * CEPlugin_GetCEFuncs(void)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return (void *)&CE.CEFuncs;
}

BOOL CEPlugin_LaunchScript(wchar_t * script, DWORD param)
{
    typedef UINT (*pAHKDLL)   (wchar_t* script, const wchar_t* p1, wchar_t* p2);
    typedef BOOL (*pAHKEXEC)  (wchar_t* script);
    typedef BOOL (*pAHKREADY) (void);
    typedef BOOL (*pAHKTETDLL)(wchar_t* script,wchar_t*, wchar_t*);
    HINSTANCE hAHK     = GetModuleHandleA("AutoHotKey64.dll");
    if (!hAHK)
    {
         MessageBox(0, L"Failed to load AHK dll", L"", MB_OK);
         return FALSE;
    }

    pAHKTETDLL ahktextdll  = (pAHKTETDLL)GetProcAddress(hAHK, "ahktextdll");
    pAHKEXEC       ahkExec = (pAHKEXEC)GetProcAddress(hAHK, "ahkExec");
    pAHKDLL         ahkdll = (pAHKDLL)GetProcAddress(hAHK, "ahkdll");
    pAHKREADY     ahkReady = (pAHKREADY)GetProcAddress(hAHK, "ahkReady");

    ahkdll(L"", L"", L"");
    while (!ahkReady())  Sleep(10);
    ahkdll(script, std::to_wstring(param).c_str(), L"");
    return TRUE;
}

HANDLE  CEPlugin_CreateFileWHook(LPCWSTR FName, DWORD Access, DWORD Share,
                         LPSECURITY_ATTRIBUTES Sec, DWORD Disposition, DWORD Flags,
                         HANDLE Template)
{
    HANDLE h = CEPlugin_pCreateFileW(FName, Access, Share, Sec, Disposition, Flags, Template);
    if (h == INVALID_HANDLE_VALUE) return h;

    std::wstring File(FName);
    if (File.find(L".ct") != std::string::npos ||
        File.find(L".CT") != std::string::npos)
    {
        File.append(L".ahk");
        if (PathFileExistsW( File.c_str() ) == 0)
        {
            return h;
            wchar_t ahk_script[MAX_PATH];
            GetModuleFileName(GetModuleHandle(L"peixoto64.dll"), (LPWCH)&ahk_script, MAX_PATH);
            PathRemoveFileSpec((LPWCH)&ahk_script);
            File.clear();
            File.append(ahk_script);
            File.append(L"/Cheats/CEPluginLib.ahk");
        }
        MH_DisableHook(&CreateFileW);
        OutputDebugStringW( File.c_str() );
        CEPlugin_LaunchScript( (wchar_t*) File.c_str(), 0 );
        //MH_EnableHook(&CreateFileW);
    }
    return h;
}

extern "C" __declspec(dllexport) BOOL __stdcall CEPlugin_InitializePlugin(PExportedFunctions ef, int pluginid)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)

    int err; wchar_t path[MAX_PATH];
    GetModuleFileName(GetModuleHandle(L"peixoto64.dll"), (LPWCH)&path, MAX_PATH);
    PathRemoveFileSpec((LPWCH)&path);

    std::wstring ahk(path);  ahk.append(L"\\AutoHotkey64.dll");
    HANDLE hAhk = LoadLibraryW(ahk.c_str());
    OutputDebugStringW( ahk.c_str() );

    CE.CEFuncs=*ef;
    CEPlugin_pCreateFileW = CreateFileW;
    sethook((void**)&CEPlugin_pCreateFileW, CEPlugin_CreateFileWHook);
    OutputDebugStringW( (std::wstring(L"Loadlibrary ")   +
                         std::to_wstring((LONGLONG)hAhk) +
                         L"CE funcs: ").c_str() );
    return TRUE;
}

extern "C" __declspec(dllexport) BOOL __stdcall CEPlugin_GetVersion(PPluginVersion pv, int sizeofpluginversion)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    pv->version           = 1;
    pv->pluginname        = "Peixoto's AHK Plugin";
    return TRUE;
}

extern "C" __declspec(dllexport) BOOL __stdcall CEPlugin_DisablePlugin(void)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return TRUE;
}

extern "C" __declspec(dllexport) const wchar_t* __stdcall CEPlugin_GetModuleNames()
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    static std::wstring modules;
    modules.clear();
    for (DllEnum enm; enm.m_Continue; enm.Next())
    {
        modules += enm.m_dll.szModule;
        modules += L" ";
    }
    return modules.c_str();           
}
