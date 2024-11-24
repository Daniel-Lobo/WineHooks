#include <windows.h>
#include "MinHook.h"
#include "MouseHooks.h"
#include <tlhelp32.h>
#include "collections.h"
#include <tlhelp32.h>
#include "dllmain.h"
#include "sethooks.h"
#include <shlwapi.h>
#include "Dbug.h"
#include "Proxydll.h"
#include <string.h>
#include <psapi.h>
#include <locale>
#include <codecvt>
#include <string>
#include "FilesSystemHooks.h"
#include <memory>
#include <string>

#include "D3D12Hooks.h"

UINT GetMemoryUsage()
{
    MEMORYSTATUS mem = {sizeof(MEMORYSTATUS)};
    GlobalMemoryStatus(&mem);
    return mem.dwMemoryLoad;
}

std::unique_ptr<std::string> to_ascii(std::wstring& wstr)
{
    wchar_t* wchar = (wchar_t*)wstr.c_str();
    std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
    std::string output = converter.to_bytes(wchar);
    return std::unique_ptr<std::string>(new std::string(output.c_str()));
}

void WTOLOWER(wchar_t wstring[], UINT size){
    for (UINT i=0; i<size; i++){
        wstring[i] = towlower(wstring[i]);
    }
}

DLLMAIN_COMMON_GLOBALS  g_;
void Loger::Init(const char * path)
{
     m_OutPut.append(g_.Path());
     m_OutPut.append(path);
     OUTPUT_FUNC_DBG_STRING(m_OutPut.c_str());
     m_hConsole = GetStdHandle(-11);
     m_Count    = new SYNC::Atomic();
     m_lock     = new SYNC::AtomicLock();
}

void WLoger::Init(const char* path)
{
    std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
    std::wstring dir  = converter.from_bytes(std::string(g_.Path()));
    std::wstring file = converter.from_bytes(std::string(path));
    m_OutPut.append(dir.c_str());
    m_OutPut.append(file.c_str());
    OutputDebugStringW(m_OutPut.c_str());
    m_hConsole = GetStdHandle(-11);
    m_Count = new SYNC::Atomic();
    m_lock  = new SYNC::AtomicLock();
}

DWORD DLLMAIN_COMMON_GLOBALS::UpdateModCount()
{
    HMODULE m[1]  = {};
    DWORD   count =  0;
    if (EnumProcessModules(GetCurrentProcess(), m, sizeof(m), &count) == 0)
    {
        DBUG_WARN("EnumProcessModules FAILED");
        return 1;
    }    
    if (count == g_.m_modcount->Get()) return 0;
    g_.m_modcount->Set(count);
    return count;
}

void DLLMAIN_COMMON_GLOBALS::ListGameModules()
{
    OutputDebugStringW(L"\nListing modules");
    WINDIR       windir;
    SYSDIR       sysdir;
    CURRENTDIR     cdir;
    std::wstring   path;
    std::wstring   name;
#ifdef _WIN64
    std::wstring   pex(L"peixoto64.dll");
    std::wstring   ahk(L"autohotkey64.dll");
    std::wstring   wine(L"wined3d.dll");
    std::wstring   dxvk_d3d9(L"d3d9.dll");
    std::wstring   dxvk_d3d8(L"d3d8.dll");
    std::wstring   winedxgi(L"dxgi.dll");
#else
    std::wstring   pex(L"peixoto.dll");
    std::wstring   ahk(L"autohotkey.dll");
    std::wstring   wine(L"wined3d.dll");
    std::wstring   dxvk_d3d9(L"d3d9.dll");
    std::wstring   dxvk_d3d8(L"d3d8.dll");
    std::wstring   winedxgi(L"dxgi.dll");
#endif
    std::wstring   net(L"clr.dll"); //untested
    for (DllEnum enm; enm.m_Continue; enm.Next())
    {
        WTOLOWER(enm.m_dll.szExePath, MAX_PATH);
        WTOLOWER(enm.m_dll.szModule, MAX_PATH);
        path = enm.m_dll.szExePath;
        name = enm.m_dll.szModule;
        /* Unecessary: net calls are excluded because the ret add is allocated memory for JIT compilation anyway */
        if (FALSE) // (name == net) 
        {
            OutputDebugStringW((std::wstring(enm.m_dll.szExePath) + L"[" + std::to_wstring((ULONG)enm.m_dll.modBaseAddr) + L":" +
                                std::to_wstring((ULONG)enm.m_dll.modBaseAddr + enm.m_dll.modBaseSize) + L"]").c_str());
            continue;
        }        
        if (path.find(windir.m_dir) != std::string::npos || name == pex || name == ahk || name == wine || name == winedxgi ||
        (name == dxvk_d3d9 && g_d3d.DXVK == 9) || (name == dxvk_d3d9 && g_d3d.DXVK == 8) || (name == dxvk_d3d9 && g_d3d.DXVK == 9))
        {
            this->m_lock->lock();
            this->m_LoadedModules->insert_disposable(enm.m_dll.modBaseAddr, enm.m_dll.modBaseAddr+enm.m_dll.modBaseSize);
            this->m_lock->unlock();
        }
        else OutputDebugStringW((std::wstring(enm.m_dll.szExePath)+L"["+std::to_wstring((ULONG)enm.m_dll.modBaseAddr)+L":"+
                                 std::to_wstring((ULONG)enm.m_dll.modBaseAddr+enm.m_dll.modBaseSize)+L"]").c_str());
    }
}

DWORD DLLMAIN_COMMON_GLOBALS::IsGameModule(LPVOID ret_add)
{    
    if (UpdateModCount()) ListGameModules();

    LPVOID min, max;
    this->m_lock->lock();
    {
        for (UINT i=0; i<this->m_LoadedModules->Count(); i++)
        {
            min = this->m_LoadedModules->KeyAt(i);
            max = this->m_LoadedModules->ValueAt(i);

            if ((ret_add > min) && (ret_add < max))
            {
                this->m_lock->unlock();
                //OutputDebugStringW((std::wstring(__FUNCTIONW__) + L" " + DllFromAdress(ret_add).m_name + L"SYSTEM").c_str());
                return 0;
            }
        }
    }    
    this->m_lock->unlock();
    //OutputDebugStringW((std::wstring(__FUNCTIONW__) + L" " + DllFromAdress(ret_add).m_name + L"GAME").c_str());
    return 1;
}

LPVOID COMObjectID(IUnknown* I)
{
    IUnknown* ID = nullptr;
    if (I == nullptr) return ID;
    if (I->QueryInterface(__uuidof(IUnknown), (void**)&ID) == 0) ID->Release();
    return ID;
}

void __stdcall SetProcAffinity(HANDLE hProc, int core)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    UINT mask = 0;
    hProc     = OpenProcess(PROCESS_SET_INFORMATION, 0, GetCurrentProcessId());

    if (hProc == nullptr)
        return DBUG_WARN("OpenProcess FAILED");

    if (core == 0)
    {
        for (UINT i=0; i<g_.HighestCPUCoreIndex; i++)
        mask |= 1<<i;
    }
    else if (core < 0)
    {
        mask = 1<<(g_.HighestCPUCoreIndex-1);
    }

    if (SetProcessAffinityMask(hProc, mask) == 0)
        DBUG_WARN((std::string("SetProcessAffinityMask FAILED: ")+std::to_string((DWORD)GetLastError())).c_str());
    if (hProc)
        CloseHandle(hProc);
}

void __stdcall SetThreadAffinity(int mask)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (mask == 0)
    {
        return;
    }
    if (mask == -1)    mask = 1<<(g_.HighestCPUCoreIndex-1);
    if (SetThreadAffinityMask(GetCurrentThread(), mask)) DBUG_WARN("SUCCESS")
    else                                                 DBUG_WARN("FAILED")
}

DWORD IsNetCall(LPVOID ret_adress)
{
    MEMORY_BASIC_INFORMATION       mem_nfo;
    wchar_t                  wmod[MAX_PATH];
    VirtualQuery(ret_adress, &mem_nfo, sizeof(MEMORY_BASIC_INFORMATION));

    return GetModuleFileNameW((HMODULE)mem_nfo.AllocationBase, wmod, MAX_PATH);
}

BOOL COMMONIsGameModule(LPVOID add, POINTER_DICTIONARY * )
{
    return g_.IsGameModule(add);
}

BOOL CommonIsGameModule(LPVOID add, POINTER_DICTIONARY *)
{
    return g_.IsGameModule(add);    
}

void * GetProcAdd(char * proc, char* dll)
{
    LPVOID add    = nullptr;
    HMODULE hMod  = LoadLibraryA(dll);
    if (hMod) add = GetProcAddress(hMod, proc);
    return add;
}

void* GetSysDllProcAdd(char* proc, char* dll)
{
    auto sys = SYSDIRA(); 
    sys.m_dir.append("\\");
    sys.m_dir.append(dll);
    LPVOID add    = nullptr;
    HMODULE hMod  = LoadLibraryA(sys.m_dir.c_str());
    if (hMod) add = GetProcAddress(hMod, proc);
    return add;
}

BOOL APIENTRY DllMain (HMODULE hInstance, DWORD fwdReason, LPVOID)
{
    switch(fwdReason)
    {
    case DLL_PROCESS_ATTACH:
    {             
        MH_Initialize();
        g_.Init(hInstance);
#ifndef _WIN64
        //ProxyDllInit(hInstance);
#endif
        break;
    }
    case DLL_THREAD_ATTACH:
        break;
    case DLL_PROCESS_DETACH:
    {
        MH_Uninitialize();
        g_fs_hooks.cleanup();
        break;
    }
    case DLL_THREAD_DETACH:
        break;
    }
    return(TRUE);
}

/* Called from CreateProcessWHook and D3D9IniHooks - AHK. Probably useless on both */
void Critical(DWORD state)
{
    state?EnterCriticalSection(&g_.c_sec):LeaveCriticalSection(&g_.c_sec);
}

extern "C" void __stdcall SetWin9xFlag(BOOL val) {
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__))  
    g_.SetWin9xFlag(val);
}

DWORD WINAPI TimeGetTimeHook()
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)  
    __int64 Count, Freq;
    QueryPerformanceFrequency((LARGE_INTEGER*)&Freq);
    QueryPerformanceCounter((LARGE_INTEGER*)&Count);
    double milliseconds = ((double)Count/(double)Freq) * 1000.;
    return (DWORD)milliseconds;
}

DWORD WINAPI TimeGetTimeHookZero()
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    __int64 Count, Freq;
    QueryPerformanceFrequency((LARGE_INTEGER*)&Freq);
    QueryPerformanceCounter((LARGE_INTEGER*)&Count);
    double milliseconds = ((double)(Count-g_.PerformanceCunter.QuadPart)/(double)Freq) * 1000.;
    return (DWORD)milliseconds;
}

double WINAPI TimeGetTimeF()
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    __int64 Count, Freq;
    QueryPerformanceFrequency((LARGE_INTEGER*)&Freq);
    QueryPerformanceCounter((LARGE_INTEGER*)&Count);
    double milliseconds = ((double)Count/(double)Freq) * 1000.;
    return milliseconds;
}

BOOL WINAPI QueryPerformanceCounterHook(LARGE_INTEGER *lpCount)
{
    BOOL r = g_.m_QueryPerformanceCounter(lpCount);
    if (r)
    {
        LARGE_INTEGER count = *lpCount;
        count.QuadPart      = count.QuadPart - g_.PerformanceCunter.QuadPart;
        *lpCount = count;
    }
    return r;
}

void HookQueryPerformanceCounter()
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HOOK(&g_.m_QueryPerformanceCounter, QueryPerformanceCounterHook);
}

ULONG __stdcall GetLayerObjectsCount() {
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return (ULONG)g_.layer_objects_count->Get();
}

void RunScript(wchar_t * file)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    typedef HANDLE (__cdecl *pahkdll)  (wchar_t* script, wchar_t* p1, wchar_t* p2);
    typedef BOOL   (__cdecl *pahkReady)(void);

    HINSTANCE handle = GetModuleHandle(L"AutoHotkey.dll");
    if (!handle)  return;

    pahkReady ahkReady = (pahkReady)GetProcAddress(handle, "ahkReady");
    pahkdll ahkdll     = (pahkdll)GetProcAddress(handle, "ahkdll");
    if (ahkdll == nullptr)
    {
        DBUG_WARN("GetProcAddress Failed");
        return;
    }

    ahkdll((wchar_t*)L"",(wchar_t*)L"",(wchar_t*)L"");
    while (!ahkReady())
    Sleep(10);

    ahkdll(file, (wchar_t*)L"",  (wchar_t*)L"");
    return;
}

DllMainType FindModuleEntryPoint(HMODULE * module, char * module_name)
{
    *module = GetModuleHandleA(module_name);
    if (*module == nullptr) return (DllMainType)1;

    PIMAGE_DOS_HEADER dosHeader = (PIMAGE_DOS_HEADER) *module;
    if (IMAGE_DOS_SIGNATURE != dosHeader->e_magic)
    {
        return (DllMainType)2;
    }
    PIMAGE_NT_HEADERS64 ntHeaders = (PIMAGE_NT_HEADERS64) ( (UINT64)dosHeader + dosHeader->e_lfanew );
    if (IMAGE_NT_SIGNATURE != ntHeaders->Signature)
    {
        return (DllMainType)3;
    }

    return (DllMainType) ((UINT64) dosHeader + (UINT64)ntHeaders->OptionalHeader.AddressOfEntryPoint);
}

PIMAGE_NT_HEADERS GetImageNtHeaders(HMODULE module)
{
    PIMAGE_DOS_HEADER dosHeader = reinterpret_cast<PIMAGE_DOS_HEADER>(module);
    if (IMAGE_DOS_SIGNATURE != dosHeader->e_magic)
    {
        return nullptr;
    }

    PIMAGE_NT_HEADERS ntHeaders = reinterpret_cast<PIMAGE_NT_HEADERS>(
        reinterpret_cast<char*>(dosHeader) + dosHeader->e_lfanew);
    if (IMAGE_NT_SIGNATURE != ntHeaders->Signature)
    {
        return nullptr;
    }

    return ntHeaders;
}

FARPROC* FindProcAddressInIat(HMODULE module, const char* importedModuleName, const char* procName)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (!module || !importedModuleName || !procName)
    {
        return (FARPROC*)1;
    }

    PIMAGE_NT_HEADERS ntHeaders = GetImageNtHeaders(module);
    if (!ntHeaders)
    {
        return (FARPROC*)2;
    }

    char* moduleBase                    = reinterpret_cast<char*>(module);
    PIMAGE_IMPORT_DESCRIPTOR importDesc = reinterpret_cast<PIMAGE_IMPORT_DESCRIPTOR>
    (moduleBase+ntHeaders->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress);

    for (PIMAGE_IMPORT_DESCRIPTOR desc = importDesc; 0 != desc->Characteristics && 0xFFFF != desc->Name; ++desc)
    {
        if (0 != _stricmp(moduleBase + desc->Name, importedModuleName))
        {
            continue;
        }

        auto thunk     = reinterpret_cast<PIMAGE_THUNK_DATA>(moduleBase + desc->FirstThunk);
        auto origThunk = reinterpret_cast<PIMAGE_THUNK_DATA>(moduleBase + desc->OriginalFirstThunk);
        while (0 != thunk->u1.AddressOfData && 0 != origThunk->u1.AddressOfData)
        {
            auto origImport = reinterpret_cast<PIMAGE_IMPORT_BY_NAME>(moduleBase + origThunk->u1.AddressOfData);

            if (0 == strcmp((const char*)origImport->Name, procName))
            {
                return reinterpret_cast<FARPROC*>(&thunk->u1.Function);
            }
            ++thunk;
            ++origThunk;
        }
        break;
    }
    return (FARPROC*)3;
}

void HookIatFunction(HMODULE module, const char* importedModuleName, const char* funcName, void* newFuncPtr)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    FARPROC* func = FindProcAddressInIat(module, importedModuleName, funcName);
    if (func)
    {
        DWORD oldProtect = 0;
        VirtualProtect(func, sizeof(func), PAGE_READWRITE, &oldProtect);
        *func = (FARPROC)newFuncPtr;
        DWORD dummy = 0;
        VirtualProtect(func, sizeof(func), oldProtect, &dummy);
    }
}
