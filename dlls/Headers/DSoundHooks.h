#ifndef DSOUNDHOOKS_H
#define DSOUNDHOOKS_H
#include <windows.h>
#include "ms_dsound.h"
#include "eax.h"
#include "collections.h"
#include "Dbug.h"
#include "dllmain.h"

#define DSND_LOG(string)   DSoundGlobals.m_loger.log(__FUNCTION__, string);
#define DSND_WARN(string)  DSoundGlobals.m_loger.dolog(__FUNCTION__, string);
//#define DSND_WARN DSND_LOG
#define DSND_HR(call, ...) if ( FAILED(call) ) {DSND_WARN(#call " FAILED") __VA_ARGS__}
#undef DBUG_WARN
#define DBUG_WARN DSND_WARN

typedef HRESULT (WINAPI *DSndCreate8Type)(LPCGUID, LPDIRECTSOUND8 *, LPUNKNOWN);

typedef struct {
    HRESULT (WINAPI *DirectSoundCreate)(LPCGUID, LPDIRECTSOUND *, LPUNKNOWN);
    HRESULT (STDMETHODCALLTYPE * CreateSoundBuffer)(IDirectSound *, LPCDSBUFFERDESC, void* ,void*);
    HRESULT (STDMETHODCALLTYPE * ReleaseSoundBuffer)(IDirectSoundBuffer *);
    HRESULT (STDMETHODCALLTYPE * Play)(IDirectSoundBuffer*, DWORD, DWORD, DWORD);
    HRESULT (STDMETHODCALLTYPE * GetCaps)(IDirectSound *,  LPDSCAPS);
    HRESULT (STDMETHODCALLTYPE * QueryInterface)(IUnknown*, REFIID, void **);
    HRESULT (STDMETHODCALLTYPE * SetProp) (IKsPropertySet*, REFGUID, ULONG, LPVOID, ULONG, LPVOID, ULONG);
    HRESULT (STDMETHODCALLTYPE * GetProp) (IKsPropertySet*, REFGUID, ULONG, LPVOID, ULONG, LPVOID, ULONG, PULONG);
    HRESULT (STDMETHODCALLTYPE * QuerySupport) (IKsPropertySet*, REFGUID, ULONG, PULONG);
    DWORD Flags;
} DSOUND_HOOKS;

struct DSOUNDGLOBALS {
    HRESULT (WINAPI * m_DirectSoundCreate)  (LPGUID, LPDIRECTSOUND*, LPUNKNOWN);
    HRESULT (WINAPI * m_DirectSoundCreate8) (LPCGUID, LPDIRECTSOUND8*, LPUNKNOWN);
    HRESULT (WINAPI * m_DllGetClassObject)  (REFCLSID rclsid, REFIID, LPVOID*) = nullptr;
    DWORD               S3DS;
    DWORD        TruePlayPos;
    DWORD          Stuterfix;
    GUID   EAX_10_listenerID;
    GUID      EAX_10_voiceID;
    GUID   EAX_20_listenerID;
    GUID      EAX_20_voiceID;
    GUID   EAX_30_listenerID;
    GUID      EAX_30_voiceID;
    GUID   EAX_40_listenerID;
    GUID      EAX_40_voiceID;
    GUID PROPID_DSoundDevice;    
    WLoger           m_loger;
    void Init();
};

extern DSOUNDGLOBALS DSoundGlobals;
extern const char* DSndGetErrString(DWORD, DWORD);
extern const char* DSndGetFlagsString(DWORD);
extern float DSBufferDescMillisecods(DSBUFFERDESC*);

extern float linear_2_cdb(float);
extern float cdb_to_linear(float cdb);

struct DSoundStuterFix {
    DSoundStuterFix(){
        m_modules = new POINTER_DICTIONARY();
        m_threads = new POINTER_DICTIONARY();
        EnumThreads();
        EnumProcModules();
        SetAffinity();
        while (m_threads->Count()) m_threads->discard(m_threads->KeyAt(0));
        while (m_modules->Count()) m_modules->discard(m_modules->KeyAt(0));
        delete m_modules;
        delete m_threads;
    }
    void SetAffinity(){
        HANDLE hThread  = nullptr;
        DWORD      mask = 0;
        DWORD  ThreadID = 0;
        LPVOID ThredAdd = nullptr;
        for (UINT i=0; i<m_threads->Count(); i++)
        {
            ThreadID = (DWORD)m_threads->ValueAt(i);
            hThread   = OpenThread(THREAD_QUERY_INFORMATION|THREAD_SET_INFORMATION, 0, ThreadID);
            if (hThread == nullptr)
            {
                OUTPUT_FUNC_DBG_STRING("OpenThread failed");
                continue;
            }
            ThredAdd = GetThreadStartAddress(hThread);
            if (ThredAdd == nullptr)
            {
                OUTPUT_FUNC_DBG_STRING("GetThreadStartAddress failed");
                CloseHandle(hThread);
                continue;
            }
            if (IsDSoundThread(ThredAdd))
            {
                for (UINT i=0; i<g_.HighestCPUCoreIndex; i++)
                mask |= 1<<i;
                if (SetThreadAffinityMask(hThread, mask)==0)
                OUTPUT_FUNC_DBG_STRING("SetThreadAffinityMask failed");
                else  OUTPUT_FUNC_DBG_STRING("=)");
            }
            CloseHandle(hThread);
        }
    }
    DWORD IsDSoundThread(LPVOID ThredAdd)
    {
        LPVOID min_add, max_add;
        for (UINT i=0; i<m_modules->Count(); i++)
        {
            min_add = m_modules->KeyAt(i);
            max_add = m_modules->ValueAt(i);
            if ( (ThredAdd>min_add) && (ThredAdd<max_add) )
            return 1;
        }
        return 0;
    }
    void EnumThreads(){
        HANDLE        hThreadSnap = INVALID_HANDLE_VALUE;
        THREADENTRY32 te32;

        hThreadSnap = CreateToolhelp32Snapshot( TH32CS_SNAPTHREAD, 0 );
        if( hThreadSnap == INVALID_HANDLE_VALUE )
        {
            OUTPUT_FUNC_DBG_STRING("CreateToolhelp32Snapshot FAILED");
            return;
        }
        te32.dwSize = sizeof(THREADENTRY32 );
        if( !Thread32First( hThreadSnap, &te32 ) )
        {
            OUTPUT_FUNC_DBG_STRING( "Thread32First" );
            CloseHandle( hThreadSnap );
            return;
        }
        do
        {
            if( te32.th32OwnerProcessID == GetCurrentProcessId () )
            {
                m_threads->insert_disposable((LPVOID)te32.th32ThreadID, (LPVOID)te32.th32ThreadID);
            }
        } while( Thread32Next(hThreadSnap, &te32 ) );
        CloseHandle( hThreadSnap );
        return;
    }
    void EnumProcModules(){
        HANDLE hSnapshot;
        MODULEENTRY32W modentry = { 0 };
        hSnapshot               = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, 0);
        modentry.dwSize         = sizeof(MODULEENTRY32W);
        Module32FirstW(hSnapshot, &modentry);

        do
        {
            if ( (memcmp(modentry.szModule, L"dsound", 4)==0) ||
                 (memcmp(modentry.szModule, L"DSOUND", 4)==0) ||
                 (memcmp(modentry.szModule, L"Dsound", 4)==0))
            {
                //OutputDebugStringW(modentry.szModule);
                m_modules->insert_disposable(modentry.modBaseAddr, modentry.modBaseAddr+modentry.modBaseSize);
            }
        } while ( Module32NextW(hSnapshot, &modentry) );
        CloseHandle(hSnapshot);
    }
    LPVOID GetThreadStartAddress(HANDLE hThread)  {
        typedef NTSTATUS (WINAPI *NTQUERYINFOMATIONTHREAD)(HANDLE, LONG, PVOID, ULONG, PULONG);
        NTSTATUS ntStatus;
        DWORD    dwThreadStartAddr = 0;
        NTQUERYINFOMATIONTHREAD NtQueryInformationThread
                = (NTQUERYINFOMATIONTHREAD) GetProcAddress(GetModuleHandleA("ntdll.dll"), "NtQueryInformationThread");
        if (NtQueryInformationThread == nullptr)
        {
            OUTPUT_FUNC_DBG_STRING("GetProcAddress FAILED");
            return 0;
        }
        ntStatus = NtQueryInformationThread(hThread, 9, &dwThreadStartAddr, sizeof(DWORD), NULL);
        if(ntStatus != S_OK)
        {
            OUTPUT_FUNC_DBG_STRING("NtQueryInformationThread FAILED");
            return 0;
        }
        return (LPVOID)dwThreadStartAddr;
    }
    POINTER_DICTIONARY * m_modules;
    POINTER_DICTIONARY * m_threads;
};
#endif // DSOUNDHOOKS_H
