#ifndef DLLMAIN
#define DLLMAIN
#include <iostream>
#include <string>
#include "EZString.h"
#include <windows.h>
#include "collections.h"
#include <shlwapi.h>
#include <string>
#include <fstream>
#include "Dbug.h"
#include <tlhelp32.h>
#include <winternl.h>
#include "Sync.h"
#include <psapi.h>
extern "C" {
#include "DDSurface.h"
}
#define MAX_LOGS 1000
//#define MAX_LOGS 10000000
//#define DEVBUILD

using std::wstring;
using std::to_wstring;

struct Loger {
    void Init(const char*);
    void dolog(const char* fn, const char* tx) {        
#ifndef DEVBUILD
        if (m_Count->Increment() >= MAX_LOGS) m_Count->Set(MAX_LOGS);
        else
#endif  // DEVBUILD  
        {
            //if (GetKeyState(0x51) == 0) return;
            //SYNC::EasyLock lock(m_lock);
            std::string OutPut(fn);
            OutPut.append(": ");
            OutPut.append(tx);
            OutPut.append("\n");
            DWORD count;
            //WriteConsoleA(m_hConsole, OutPut.c_str(), strlen(OutPut.c_str()), &count, nullptr);            
            m_Outfile.open(m_OutPut.c_str(), std::ios_base::out | std::ios_base::app);
            m_Outfile << fn << ": " << tx << "\n";
            m_Outfile.close();
        }      
    }
    void log(const char* fn, const char* tx) {
        if (m_Count->Increment() >= MAX_LOGS) m_Count->Set(MAX_LOGS);
        else dolog(fn, tx);
    }
    SYNC::Atomic*               m_Count;
    std::string                m_OutPut;
    std::ofstream             m_Outfile;
    HANDLE                   m_hConsole;
    DWORD                  m_Closed = 0;
    SYNC::AtomicLock * m_lock = nullptr;
};
struct WLoger  {
    void Init(const char*);
    void dolog(const wchar_t* fn, const wchar_t* tx) {
#ifndef DEVBUILD
        if (m_Count->Increment() >= MAX_LOGS) m_Count->Set(MAX_LOGS);
        else
#endif   // DEVBUILD  
        {     
            //SYNC::EasyLock lock(m_lock);
            std::wstring OutPut(fn);
            OutPut.append(L": ");
            OutPut.append(tx);
            OutPut.append(L"\n");
            //WriteConsoleW(m_hConsole, OutPut.c_str(), wcslen(OutPut.c_str()), &count, nullptr);
            m_Outfile.open(m_OutPut.c_str(), std::ios_base::out | std::ios_base::app);
            m_Outfile << fn << L": " << tx << L"\n";
            m_Outfile.close();
        }
    }
    void log(const wchar_t* fn, const wchar_t* tx) {
        if (m_Count->Increment() >= MAX_LOGS) m_Count->Set(MAX_LOGS);
        else dolog(fn, tx);
    }
    void dolog(const char* fn, const char* tx) {
#ifndef DEVBUILD
        if (m_Count->Increment() >= MAX_LOGS) m_Count->Set(MAX_LOGS);
        else
#endif  // DEVBUILD  
        {
            DWORD count;
            std::string OutPut(fn);
            OutPut.append(": ");
            OutPut.append(tx);
            OutPut.append("\n");
            //WriteConsoleA(m_hConsole, OutPut.c_str(), strlen(OutPut.c_str()), &count, nullptr);
            //m_OutfileA.open(m_OutPut.c_str(), std::ios_base::out | std::ios_base::app);
            //m_OutfileA << fn << ": " << tx << "\n";
            //m_OutfileA.close();
            std::wofstream  out;
            out.open(m_OutPut.c_str(), std::ios_base::out | std::ios_base::app);
            out << fn << ": " << tx << "\n";
            out.close();
        }
    }
    void log(const char* fn, const char* tx) {
        if (m_Count->Increment() > MAX_LOGS) m_Count->Decrement();
        else dolog(fn, tx);
    }
    SYNC::Atomic     * m_Count;
    std::wstring      m_OutPut;
    std::wofstream   m_Outfile;
    std::string      m_OutPutA;
    std::ofstream   m_OutfileA;
    HANDLE          m_hConsole;
    DWORD         m_Closed = 0;
    SYNC::AtomicLock* m_lock = nullptr;
};

struct DLLMAIN_COMMON_GLOBALS {
    void Init(HINSTANCE h){
        SYSTEM_INFO  nfo={};
        GetSystemInfo(&nfo);
        InitializeCriticalSection(&this->c_sec);
        QueryPerformanceCounter(&this->PerformanceCunter);
        this->modules             = new POINTER_DICTIONARY();
        this->m_LoadedModules     = new POINTER_DICTIONARY();
        this->m_lock              = new SYNC::AtomicLock();
        this->h_Peixoto           = h;
        this->PeixotoMsg          = RegisterWindowMessage(L"Peixoto");
        this->HighestCPUCoreIndex = nfo.dwNumberOfProcessors;
        OUTPUT_FUNC_DBG_STRING( (std::string("Found ")+std::to_string(nfo.dwNumberOfProcessors)+" CPU cores").c_str() );

        char     p[MAX_PATH];
        wchar_t wp[MAX_PATH];
#ifdef _WIN64
        GetModuleFileNameA(this->h_Peixoto, (LPCH)&p, MAX_PATH);
        GetModuleFileNameW(nullptr, (LPWCH)&wp, MAX_PATH);
#else
        GetModuleFileNameA(this->h_Peixoto, (LPCH)&p, MAX_PATH);
        GetModuleFileNameW(nullptr, (LPWCH)&wp, MAX_PATH);
#endif
        OUTPUT_FUNC_DBG_STRING(p);
        PathRemoveFileSpecA((LPCH)&p);
        path.clear();
        path.append(p);
        OUTPUT_FUNC_DBG_STRING(this->Path());        
        PathRemoveFileSpecW((LPWCH)&wp);
        wpath.clear();
        for (UINT i=0; i<wcslen(wp); i++)
            wp[i] = *_wcslwr(&wp[i]);
        OutputDebugStringW(wp);
        wpath.append(wp);
        OutputDebugStringW(wpath.c_str());

        this->loger.Init("\\error.log");
        layer_objects_count = new SYNC::Atomic();
        m_modcount          = new SYNC::Atomic();
        m_layer_call_count  = new SYNC::Atomic();
        m_QueryPerformanceCounter = QueryPerformanceCounter;

        m_Dumps = new TextureDumps();
    }
    std::string * FindTexture(UINT w, UINT h, UINT p, char * f, byte * pData) {
        return (std::string *) m_Dumps->Find(w, h, p, f, pData);
    }
    DWORD UpdateModCount();
    void ListGameModules();
    DWORD   IsGameModule(LPVOID);
    const char    * Path()    {return  path.c_str();}
    const wchar_t * ExePath() {return wpath.c_str();}
    const wchar_t * NextDmp()
    {
        UINT index        = 0;
        do
        {
            m_NextDmp.clear();
            m_NextDmp.append(m_BaseTexturePath);
            m_NextDmp.append((std::wstring(L"dump") + std::to_wstring(index) + L".dds").c_str());
            index++;
        } while (PathFileExistsW(m_NextDmp.c_str()));
        return m_NextDmp.c_str();
    }
    const char * NextDmpA()
    {
        size_t sz;
        const wchar_t * wfile = m_NextDmp.c_str();
        char * file           = new char[wcslen(wfile)]();
        wcstombs_s(&sz, file, wcslen(wfile)*sizeof(char), wfile, wcslen(wfile));
        m_NextDmpA.clear();
        m_NextDmpA.append(file);
        delete [] file;
        return m_NextDmpA.c_str();
    }
    void SetWin9xFlag(BOOL val) { m_Win9xFlag  = val; }
    BOOL GetWin9xFlag(void)     { return m_Win9xFlag; }
    Loger                               loger;
    HMODULE                         h_Peixoto;
    UINT                  HighestCPUCoreIndex;
    CRITICAL_SECTION                    c_sec;
    DWORD                          PeixotoMsg;
    LARGE_INTEGER           PerformanceCunter;
    POINTER_DICTIONARY              * modules;
    POINTER_DICTIONARY      * m_LoadedModules;
    SYNC::Atomic                 * m_modcount;
    SYNC::Atomic         * m_layer_call_count;
    std::string                          path;
    std::wstring                        wpath;
    std::wstring            m_BaseTexturePath;
    std::string  m_FallBackTextureReplacement;
    std::wstring                    m_NextDmp;
    std::string                    m_NextDmpA;
    SYNC::Atomic *        layer_objects_count;
    SYNC::AtomicLock *                 m_lock;
    BOOL (WINAPI * m_QueryPerformanceCounter)(LARGE_INTEGER*);
    TextureDumps *                   m_Dumps;
    BOOL                         m_Win9xFlag; /* Win9x Compat modes include the sigle core affinity shim, so no worries with thread safety */
    const IID * DInputbase              = (IID *) "DirectInputBase";
    const IID * DDrawSurfaceData        = (IID *) "DDrawSurfaceData";
    const IID * DDrawSurfacePassTrough  = (IID *) "DDSrfcPassTrough";
    const IID * DirectDrawPassTrough    = (IID *) "DDrawPassTrough";
    const IID * DDrawPalettePassTrough  = (IID *) "DDPallPassTrough";
    const IID * DDrawClipperPassTrough  = (IID *) "DDClipPassTrough";
    const IID * D3DDevicePassTrough     = (IID *) "D3DDvcPassTrough";
    const IID * D3D8SurfacePassTrough   = (IID *) "D3D8SrfcPassTrough";
    const IID * D3DRelplacementTexture  = (IID *) "D3D8TextureReplacement";
    const IID * D3D8ResourcePassTrough  = (IID *) "D3D8RsrcPassTrough";
    const IID * D3D8SwapChainPassTrough = (IID *) "D3D8SChnPassTrough";
    const IID * D3D8DevicePassTrough    = (IID *) "D3D8DevcPassTrough";
    const IID * D3D9SurfacePassTrough   = (IID *) "D3D9SrfcPassTrough";
    const IID * D3D9ResourcePassTrough  = (IID *) "D3D9RsrcPassTrough";
    const IID * D3D9SwapChainPassTrough = (IID *) "D3D9SChnPassTrough";
    const IID * D3D9DevicePassTrough    = (IID *) "D3D9DevcPassTrough";
    const IID * DXGISwapChainImp        = (IID *) "DXGISwapChainImp";
    const IID * D3D12ProxyBackbuffer    = (IID *) "D3D12ProxyBackBuffer";
    const IID * D3D11ProxyShader        = (IID *) "D3D11ProxyShader";
    const IID * D3D11ProxyTexture       = (IID *) "D3D11ProxyTexture";
    const IID * D3D11Weak               = (IID *) "D3D11WeakContainer";
    const IID * D3D12SwapChainQueue     = (IID *) "D3D12SChainQueue";    
    const IID * D3D11DepthStencil       = (IID *) "D3D11DepthStencil";
    const IID * D3D11Rendertargets[8]   = {(IID*)"D3D11_1stRTarget", (IID*)"D3D11_2ndRTarget", (IID*)"D3D11_3rdRTarget", (IID*)"D3D11_4thRTarget", 
                                           (IID*)"D3D11_5thRTarget", (IID*)"D3D11_6thRTarget", (IID*)"D3D11_7thRTarget", (IID*)"D3D11_8thRTarget" };
};
extern "C" DLLMAIN_COMMON_GLOBALS g_;
extern void WTOLOWER(wchar_t [], UINT);


class SYSDIRA {
public:
    SYSDIRA() {
        char dir[MAX_PATH];
        if (GetSystemDirectoryA(dir, MAX_PATH) == 0)
        {
            OutputDebugStringA((std::string(__FUNCTION__) + ": SYSDIRA failed").c_str());
        }       
        m_dir.clear();
        m_dir.append(dir);   
        OutputDebugStringA((std::string(__FUNCTION__) + ": System dir->" + dir).c_str());
    }
    std::string m_dir;
};

class SYSDIR{
public:
    SYSDIR(){
        wchar_t              dir[MAX_PATH];
        GetSystemDirectoryW(dir, MAX_PATH);
        WTOLOWER(dir, MAX_PATH);
        m_dir.clear();
        m_dir.append(dir);
        //OutputDebugStringW((wstring(__FUNCTIONW__)+L": System dir->"+dir).c_str());
    }
    wstring m_dir;
};
class WINDIR{
public:
    WINDIR(){
        wchar_t               dir[MAX_PATH];
        std::ignore = GetWindowsDirectoryW(dir, MAX_PATH);
        WTOLOWER(dir, MAX_PATH);
        m_dir.clear();
        m_dir.append(dir);
        //OutputDebugStringW((wstring(__FUNCTIONW__)+L": Windows dir->"+dir).c_str());
    }
    wstring m_dir;
};
class CURRENTDIR{
public:
    CURRENTDIR(){
        UINT size = GetCurrentDirectoryW(0, NULL);
        if (size)
        {
            wchar_t * dir = new wchar_t[size];
            GetCurrentDirectoryW(size, dir);
            WTOLOWER(dir, size);
            m_dir.clear();
            m_dir.append(dir);
            delete [] dir;
        }
        //OutputDebugStringW((wstring(__FUNCTIONW__)+L": Current dir->"+m_dir).c_str());
    }
    wstring m_dir;
};

class DllEnum {
public:
    void Next(){
        m_Continue = Module32Next(m_hSnapshot, &m_dll);
    }
    MODULEENTRY32 m_dll      = {sizeof(MODULEENTRY32)};
    HANDLE m_hSnapshot       = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, 0);
    BOOL m_Continue          = Module32First(m_hSnapshot, &m_dll);
};

class DllFromAdress{
public:
    DllFromAdress(LPVOID add){
        m_name.append(L"???");
        m_path.append(L"???");
        for (DllEnum enm; enm.m_Continue; enm.Next())
        {
            if (add>enm.m_dll.modBaseAddr &&
                add<enm.m_dll.modBaseAddr+enm.m_dll.modBaseSize)
            {
                m_name.clear();
                m_path.clear();
                WTOLOWER(enm.m_dll.szModule, wcslen(enm.m_dll.szModule));
                WTOLOWER(enm.m_dll.szExePath, wcslen(enm.m_dll.szExePath));
                m_name.append((wstring(enm.m_dll.szModule)+L"("+to_wstring((ULONG)enm.m_dll.modBaseAddr)+L"->"+
                               to_wstring((ULONG)enm.m_dll.modBaseAddr+enm.m_dll.modBaseSize)+L")").c_str());
                m_path.append(enm.m_dll.szExePath);

                break;
            }
        }
    }
    std::wstring m_name;
    std::wstring m_path;
};

class PerfCounter {
    LONGLONG m_Count = 0LL;    
public:
    PerfCounter() {
        QueryPerformanceCounter((LARGE_INTEGER*)&m_Count);
    }
    DWORD MS() {
        LONGLONG freq = 1LL;
        QueryPerformanceFrequency((LARGE_INTEGER*)&freq);
        return (m_Count * 1000) / freq;
    }
};

class EZInterface {
public:
    EZInterface(REFIID ID, IUnknown * I){
        if (nullptr != I)
        I->QueryInterface(ID, (void**)&i);
    }
    ~EZInterface(){
        if (nullptr != i) i->Release();
    }
    IUnknown * I(){
        return i;
    }
    IUnknown * i = nullptr;
};

class GUID2String {
public:
    GUID2String(REFIID riid) {
        StringFromGUID2(riid, (LPOLESTR)szGUID, 64);       
    }
    unique_ptr<ASCii> str() {        
        return unique_ptr<ASCii>(new ASCii((wchar_t*)szGUID));
    }
    wchar_t szGUID[64] = L"StringFromGUID2 FAILED";
};

#define CLAMP(f, min, max) f < min ? min : f > max ? max : f 

extern UINT GetMemoryUsage();
extern "C" __declspec(dllexport) void __stdcall SetProcAffinity(HANDLE hProc, int core);
extern "C" __declspec(dllexport) void __stdcall SetThreadAffinity(int);
extern "C" __declspec(dllexport) void RunScript(wchar_t * file);
extern "C" __declspec(dllexport) void Critical(DWORD);
extern LPVOID COMObjectID(IUnknown* I);
extern BOOL  CommonIsGameModule(LPVOID, POINTER_DICTIONARY *);
extern BOOL  COMMONIsGameModule(LPVOID, POINTER_DICTIONARY*);
extern DWORD IsNetCall(LPVOID);
extern std::unique_ptr<std::string> to_ascii(std::wstring&);

typedef BOOL (WINAPI * DllMainType)(HINSTANCE, DWORD, LPVOID);
extern  DllMainType FindModuleEntryPoint(HMODULE *, char *);
extern  void * GetProcAdd(char*, char*);
extern  void * GetSysDllProcAdd(char*, char*);

#define GETPROCADDRESS(Proc, procname, dll) Proc = (decltype(Proc)) GetProcAdd(procname, dll); \
if (Proc == nullptr) g_.loger.log(__FUNCTION__, "FAILED TO GET THE " procname " ENTRYPOINT ON " dll); \
else                 g_.loger.log(__FUNCTION__, "SUCCEEDED TO GET THE " procname " ENTRYPOINT ON " dll);

#define GETSYSDLLPROCADDRESS(Proc, procname, dll) Proc = (decltype(Proc)) GetSysDllProcAdd(procname, dll); \
if (Proc == nullptr) g_.loger.log(__FUNCTION__, "FAILED TO GET THE " procname " ENTRYPOINT ON " dll); \
else                 g_.loger.log(__FUNCTION__, "SUCCEEDED TO GET THE " procname " ENTRYPOINT ON " dll);
#endif // DLLMAIN

#define _GETPROCADDRESS(Proc, procname, dll) Proc = (decltype(Proc)) GetProcAdd(procname, dll); \
if (Proc == nullptr) g_.loger.log(__FUNCTION__, "FAILED TO GET THE " procname " ENTRYPOINT"); \
else                 g_.loger.log(__FUNCTION__, "SUCCEEDED TO GET THE " procname " ENTRYPOINT");

