#include <windows.h>
#include "sethooks.h"
#include <wchar.h>
#include <shlobj.h>
#include <knownfolders.h>
#include "collections.h"
#include <shlwapi.h>
#include "dllmain.h"
#include <memory>
#include "FilesSystemHooks.h"
#include "Sync.h"
#include "Dbug.h"
#include <tlhelp32.h>
#include <intrin.h>
#include <filesystem>
#include <string>
#include <pathcch.h>
#include <processenv.h>

//#undef DBUG_LOG
//#undef DBUG_WARN
//#define DBUG_LOG(string)  g_fs_hooks.m_loger.log(__FUNCTION__, string);
//#define DBUG_WARN(string) g_fs_hooks.m_loger.dolog(__FUNCTION__, string);
#define DBUG_WLOG(string)  //g_fs_hooks.m_loger.log(__FUNCTIONW__, string);
#define DBUG_WWARN(string) //g_fs_hooks.m_loger.dolog(__FUNCTIONW__, string);
#define LOG_GAME_CALL      g_fs_hooks.m_fldsloger.log(__FUNCTION__, "GAME");
#define LOG_SYSTEM_CALL    g_fs_hooks.m_fldsloger.log(__FUNCTION__, "SYSTEM");
//#define LOG_GAME_CALL    
#define LOG_SYSTEM_CALL   

using std::wstring;

OpenFile_Trampoline                          pOpenFile;
FindNextFileA_Trampoline                pFindNextFileA;
FindFirstFileA_Trampoline              pFindFirstFileA;
FindFirstFileW_Trampoline              pFindFirstFileW;
SHGetKnownFolderPath_Trampoline      pSHGetKnownFolder;
CreateFileA_Trampoline                    pCreateFileA;
CreateFileW_Trampoline                    pCreateFileW;
SHGetFolderPathA_Type                pSHGetFolderPathA;
SHGetFolderPathW_Type                pSHGetFolderPathW;
SHGetSpecialFolderPathA_Type  pSHGetSpecialFolderPathA;
SHGetSpecialFolderPathW_Type  pSHGetSpecialFolderPathW;
SHGetPathFromIDListW_Type        pSHGetPathFromIDListW;
RegQueryValueExA_Type                pRegQueryValueExA;
RegQueryValueExW_Type                pRegQueryValueExW;

FS_HOOKS g_fs_hooks;

void FindFiles(wchar_t* dir, std::vector<std::wstring>& files_found)
{
    DBUG_WWARN(dir);    
    for (auto files = FilesFinder(dir); files.m_Continue; files.Next())
    {
        if (wcscmp(files.m_FileData.cFileName, L".") == 0 || wcscmp(files.m_FileData.cFileName, L"..") == 0)
        continue;

        wstring full_name(dir);
        full_name     += L"\\";
        full_name     += files.m_FileData.cFileName;
        wchar_t* name = (wchar_t*)full_name.c_str();
        DBUG_WWARN(name);
        if  (files.m_FileData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) FindFiles(name, files_found);
        else files_found.push_back(wstring(name));
    }
}

char * ANSIPath(const wchar_t * file)
{
    char * afile = new char[MAX_PATH]();
    size_t sz;
    wcstombs_s(&sz, afile, MAX_PATH, file, wcslen(file));
    /* Caller must delete this */
    return afile;
}

wchar_t * UnicodePath(const char * file)
{
    wchar_t * wfile = new wchar_t[MAX_PATH]();
    size_t sz;
    mbstowcs_s(&sz, wfile, MAX_PATH, file, strlen(file));
    /* Caller must delete this */
    return wfile;
}

#ifdef _WIN64
BOOL __thiscall ISteamUser_GetUserDataFolder_Hook(LPVOID ISteamUser, char *pchBuffer, int cubBuffer )
{
    OUTPUT_FUNC_DBG_STRING("================================================");
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (cubBuffer < strlen(g_fs_hooks.APath)+sizeof(char)) return false;
    memcpy(pchBuffer, g_fs_hooks.APath, strlen(g_fs_hooks.APath)+sizeof(char));
    return 1;
}
#endif

BOOL IsGameModule(LPVOID add)
{
    return g_.IsGameModule(add);    
}

LSTATUS WINAPI
RegQueryValueExW_Hook(HKEY hKey, LPCWSTR ValueName, LPDWORD Reserved, LPDWORD Type, LPBYTE Data, LPDWORD cbData)
{
    DWORD sz    = 0;
    DWORD type  = 0;
    if (Type)   type = *Type;
    if (cbData) sz   = *cbData;

    LPVOID ret  = __builtin_return_address(0);
    LSTATUS  r  = pRegQueryValueExW(hKey, ValueName, Reserved, Type, Data, cbData);
    if (r != ERROR_SUCCESS || IsGameModule(ret) == 0 || Data == nullptr || type != REG_SZ) return r;

    std::wstring ValName(ValueName);
    std::wstring Personal(L"Personal");
    if (ValName == Personal && sz >= strlen(g_fs_hooks.APath))
    {
        memcpy(Data, g_fs_hooks.WPath, (wcslen(g_fs_hooks.WPath)+1)   *sizeof(wchar_t));
        if (cbData != nullptr) *cbData = (wcslen(g_fs_hooks.WPath)+1) *sizeof(wchar_t);
    }
    return r;
}

LSTATUS WINAPI
RegQueryValueExA_Hook(HKEY hKey, LPCSTR ValueName, LPDWORD Reserved, LPDWORD Type, LPBYTE Data, LPDWORD cbData)
{
    DWORD sz    = 0;
    DWORD type  = 0;
    if (Type)   type = *Type;
    if (cbData) sz   = *cbData;

    LPVOID ret  = __builtin_return_address(0);
    LSTATUS  r  = pRegQueryValueExA(hKey, ValueName, Reserved, Type, Data, cbData);
    if (r != ERROR_SUCCESS || IsGameModule(ret) == 0 || Data == nullptr || type != REG_SZ) return r;

    std::string ValName(ValueName);
    std::string Personal("Personal");
    if (ValName == Personal && sz >= strlen(g_fs_hooks.APath))
    {        
        memcpy(Data, g_fs_hooks.APath, strlen(g_fs_hooks.APath)+sizeof(char));
        if (cbData != nullptr) *cbData = strlen(g_fs_hooks.APath)+sizeof(char);
    }
    return r;
}

HRESULT WINAPI SHGetFolderLocation_Hook(HWND h, int csidl, HANDLE hT, DWORD f, PIDLIST_ABSOLUTE *ppidl)
{
    if (csidl == CSIDL_MYDOCUMENTS // LoK Defiance
        && ppidl && IsGameModule(__builtin_return_address(0)))
    {
        LOG_GAME_CALL;
        HRESULT hr = SHParseDisplayName(g_fs_hooks.WPath, nullptr, ppidl, 0, 0);
        if (hr != S_OK)
        {
            g_fs_hooks.m_fldsloger.log(__FUNCTION__, (std::string("SHParseDisplayName FAILED: ") + std::to_string((UINT)hr)).c_str());
            OutputDebugStringW(g_fs_hooks.WPath);
            return g_fs_hooks.m_SHGetFolderLocation(h, csidl, hT, f, ppidl);
        } return S_OK;
    }
    LOG_SYSTEM_CALL
    return g_fs_hooks.m_SHGetFolderLocation(h, csidl, hT, f, ppidl);
}

BOOL WINAPI SHGetPathFromIDListW_Hook(PCIDLIST_ABSOLUTE pidl, LPWSTR pszPath)
{
    g_fs_hooks.m_fldsloger.log(__FUNCTION__, ":");
    LPVOID ret = __builtin_return_address(0);
    BOOL r     = pSHGetPathFromIDListW(pidl, pszPath);
    if (r == 0 || IsGameModule(ret) == 0)    return r;

    wcscpy(pszPath, g_fs_hooks.WPath);
    return r;
}

HRESULT WINAPI SHGetFolderPathW_Hook(HWND hwnd, int csidl, HANDLE hToken, DWORD dwFlags, LPWSTR pszPath)
{
    LPVOID ret = __builtin_return_address(0);
    HRESULT hr = pSHGetFolderPathW(hwnd, csidl, hToken, dwFlags, pszPath);
    if (hr == S_OK && IsGameModule(ret))
    {
        LOG_GAME_CALL  // frezes TR reboot
        if (csidl & CSIDL_APPDATA          ||
            csidl & CSIDL_LOCAL_APPDATA    ||
            csidl & CSIDL_COMMON_APPDATA   ||
            csidl & CSIDL_MYDOCUMENTS      ||
            csidl & CSIDL_COMMON_DOCUMENTS)
        {
            wcscpy(pszPath, g_fs_hooks.WPath);                
            return hr;
        }
    }
    LOG_SYSTEM_CALL
    return hr;
}

HRESULT WINAPI SHGetFolderPathA_Hook(HWND hwnd, int csidl, HANDLE hToken, DWORD dwFlags, LPSTR pszPath)
{
    LPVOID ret = __builtin_return_address(0);
    HRESULT hr = pSHGetFolderPathA(hwnd, csidl, hToken, dwFlags, pszPath);
    if (hr == S_OK && IsGameModule(ret))
    {
        LOG_GAME_CALL
        if (csidl & CSIDL_APPDATA ||
            csidl & CSIDL_LOCAL_APPDATA ||
            csidl & CSIDL_COMMON_APPDATA ||
            csidl & CSIDL_PERSONAL ||
            csidl & CSIDL_COMMON_DOCUMENTS)
        {
            strcpy(pszPath, g_fs_hooks.APath);
            return hr;
        }
    }
    LOG_SYSTEM_CALL
    return hr;
}

BOOL WINAPI SHGetSpecialFolderPathA_Hook(HWND hwnd, LPSTR pszPath, int csidl, BOOL fCreate)
{
    LPVOID ret = __builtin_return_address(0);
    BOOL hr    = pSHGetSpecialFolderPathA(hwnd, pszPath, csidl, fCreate);
    if (hr == TRUE && IsGameModule(ret))
    {
        LOG_GAME_CALL
        if (csidl == CSIDL_APPDATA ||
            csidl == CSIDL_LOCAL_APPDATA ||
            csidl == CSIDL_COMMON_APPDATA ||
            csidl == CSIDL_MYDOCUMENTS)
        {
            strcpy(pszPath, g_fs_hooks.APath);
            return hr;
        }
    }
    LOG_SYSTEM_CALL
    return hr;
}

BOOL WINAPI SHGetSpecialFolderPathW_Hook(HWND hwnd, LPWSTR pszPath, int csidl, BOOL fCreate)
{
    LPVOID ret = __builtin_return_address(0);
    BOOL hr    = pSHGetSpecialFolderPathW(hwnd, pszPath, csidl, fCreate);
    if (hr == TRUE && IsGameModule(ret))
    {
        LOG_GAME_CALL
        if (csidl == CSIDL_APPDATA ||
            csidl == CSIDL_LOCAL_APPDATA ||
            csidl == CSIDL_COMMON_APPDATA ||
            csidl == CSIDL_MYDOCUMENTS)
        {
            wcscpy(pszPath, g_fs_hooks.WPath);
            return hr;
        }
    } 
    LOG_SYSTEM_CALL
    return hr;
}

HRESULT WINAPI SHGetKnownFolder_Hook(REFKNOWNFOLDERID rfid, DWORD dwFlags, HANDLE hToken, PWSTR* ppszPath)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID ret = __builtin_return_address(0);
    if (IsGameModule(ret) == 0)
    {
        LOG_SYSTEM_CALL
        return pSHGetKnownFolder(rfid, dwFlags, hToken, ppszPath);
    }
    LOG_GAME_CALL
    if (IsEqualGUID(rfid, FOLDERID_LocalAppData)   ||
        IsEqualGUID(rfid, FOLDERID_SavedGames)     ||  // wolfenstain tno
        IsEqualGUID(rfid, FOLDERID_RoamingAppData) ||
        IsEqualGUID(rfid, FOLDERID_ProgramData)    ||
        IsEqualGUID(rfid, FOLDERID_Documents)      ||
        IsEqualGUID(rfid, FOLDERID_LocalAppDataLow))   // Death's door
    {
        if (ppszPath)
        {
            PWSTR path = (PWSTR)CoTaskMemAlloc(sizeof(wchar_t) * (wcslen(g_fs_hooks.WPath)+1));
            //PWSTR path = (PWSTR)CoTaskMemAlloc(sizeof(wchar_t) * MAX_PATH);
            if (path == 0)
            {
                DBUG_WARN("CoTaskMemAlloc FAILED");
                return pSHGetKnownFolder(rfid, dwFlags, hToken, ppszPath);
            }
            wcscpy(path, g_fs_hooks.WPath);
            //if (wcsncpy_s(path, MAX_PATH, g_fs_hooks.WPath, wcslen(g_fs_hooks.WPath)) != 0)  DBUG_WARN("wcsncpy_s FAILED");
            *ppszPath = path;
            return 0;
        }
        return E_INVALIDARG;
    }
    LOG_SYSTEM_CALL
    return pSHGetKnownFolder(rfid, dwFlags, hToken, ppszPath);
};

LPCH WINAPI GetEnvironmentStringsA_Hook()
{
    LPVOID ret = __builtin_return_address(0);
    if (IsGameModule(ret) == 0)
    {
        LOG_SYSTEM_CALL
        return g_fs_hooks.m_GetEnvironmentStringsA();
    }
    LOG_GAME_CALL
    char* env    = g_fs_hooks.m_GetEnvironmentStringsA();
    char* mewenv = EnvStringsParserA().Parse(env, nullptr).Edit(g_fs_hooks.APath);
    g_fs_hooks.m_FreeEnvironmentStringsA(env);
    return mewenv;
}

LPWCH WINAPI GetEnvironmentStringsW_Hook()
{
    LPVOID ret = __builtin_return_address(0);
    if (IsGameModule(ret) == 0)
    {
        LOG_SYSTEM_CALL
        return g_fs_hooks.m_GetEnvironmentStringsW();
    }
    LOG_GAME_CALL
    wchar_t * env    = g_fs_hooks.m_GetEnvironmentStringsW();
    wchar_t * mewenv = EnvStringsParserW().Parse(env, nullptr).Edit(g_fs_hooks.WPath);
    g_fs_hooks.m_FreeEnvironmentStringsW(env);
    return mewenv;
}

BOOL WINAPI FreeEnvironmentStringsA_Hook(char penv[])
{
    LPVOID ret = __builtin_return_address(0);
    if (IsGameModule(ret) == 0)
    {
        LOG_SYSTEM_CALL
        return g_fs_hooks.m_FreeEnvironmentStringsA(penv);        
    }
    LOG_GAME_CALL
    delete[] penv;
    return 1;
}

BOOL WINAPI FreeEnvironmentStringsW_Hook(wchar_t penv[])
{
    LPVOID ret = __builtin_return_address(0);
    if (IsGameModule(ret) == 0)
    {
        LOG_SYSTEM_CALL
        return g_fs_hooks.m_FreeEnvironmentStringsW(penv);        
    }
    LOG_GAME_CALL
    delete[] penv;
    return 1;
}

DWORD WINAPI GetEnvironmentVariableA_Hook(LPCSTR lpName, LPSTR lpBuffer, DWORD nSize)
{
    LPVOID ret = __builtin_return_address(0);
    HRESULT hr = g_fs_hooks.m_GetEnvironmentVariableA(lpName, lpBuffer, nSize);    
    if (hr == 0 || IsGameModule(ret) == 0)
    {
        LOG_SYSTEM_CALL
        return hr;
    }    
    g_fs_hooks.m_fldsloger.log(__FUNCTION__, "GAME");
    if (strcmpi(lpName, "LOCALAPPDATA") == 0 || strcmpi(lpName, "USERPROFILE") == 0 || strcmpi(lpName, "allusersprofile") == 0)
    {
        LOG_GAME_CALL
        if (nSize < strlen(g_fs_hooks.APath) + 1)
        {
            g_fs_hooks.m_fldsloger.log(__FUNCTION__, "RETURNIG SIZE");
            return strlen(g_fs_hooks.APath);
        }
        else 
        {
            g_fs_hooks.m_fldsloger.log(__FUNCTION__, "RETURNIG SRINNG");
            strncpy(lpBuffer, g_fs_hooks.APath, nSize);
            return strlen(g_fs_hooks.APath);
        }
    }    
    return hr;
}

DWORD WINAPI GetEnvironmentVariableW_Hook(LPCWSTR lpName, LPWSTR lpBuffer, DWORD nSize)
{
    LPVOID ret = __builtin_return_address(0);
    HRESULT hr = g_fs_hooks.m_GetEnvironmentVariableW(lpName, lpBuffer, nSize);    
    if (hr == 0 || IsGameModule(ret) == 0)
    {
        LOG_SYSTEM_CALL // crashes deaths's door
        return hr;
    }      
    if (wcsicmp(lpName, L"LOCALAPPDATA") == 0 || wcsicmp(lpName, L"USERPROFILE") == 0 || wcsicmp(lpName, L"allusersprofile") == 0)
    {
        LOG_GAME_CALL
        if (nSize < wcslen(g_fs_hooks.WPath) + 1)
        {
            g_fs_hooks.m_fldsloger.log(__FUNCTION__, "RETURNIG SIZE");
            return wcslen(g_fs_hooks.WPath);
        }
        else
        {
            g_fs_hooks.m_fldsloger.log(__FUNCTION__, "RETURNIG SRINNG");
            wcsncpy(lpBuffer, g_fs_hooks.WPath, nSize);
            return wcslen(g_fs_hooks.WPath);
        }
    }
    return hr;
}

std::unique_ptr<wstring> Canonical(wchar_t* caller, wchar_t * p)
{
    if (caller != nullptr)
    {
        DBUG_WWARN(caller);
        DBUG_WWARN(p);
    }
    if (p == nullptr)    return std::unique_ptr<wstring>(nullptr); wstring Path(p);
    if (Path.size() < 3) return std::unique_ptr<wstring>(nullptr);
    if (PathIsRelativeW(p))
    {
        Path = CURRENTDIR().m_dir + L"/" + p;       
    }
    wchar_t* path = (wchar_t*)Path.c_str();    

    wstring canon;
    canon.resize(wcslen(path));
    UINT ii       = 0;
    for (UINT i = 0; i < wcslen(path)-1; i++) 
    {
        if (path[i] == L"\\"[0] && path[i+1] == L"\\"[0])
        {
            canon[ii] = L"\\"[0];
            ii -= 1;
        }   
        else if (path[i] == L"/"[0] )
        {
            canon[ii] = L"\\"[0];
            if (path[i + 1] == L"/"[0]) ii -= 1;
        }        
        else canon[ii] = (wchar_t)towlower(path[i]);
        ii++;
    }
    UINT i              = wcslen(path)-1;
    canon[ii]           = towlower(path[i]);
#ifdef _WIN64
    canon[ii + 1LL]     = L"\0"[0];
#else 
    canon[ii + 1L]      = L"\0"[0];
#endif

    wchar_t w_canon[MAX_PATH];
    PathCchCanonicalize(w_canon, MAX_PATH, canon.c_str());
    
    if (caller != nullptr)
    {
       DBUG_WWARN((wstring(w_canon) + L" " + std::to_wstring(wcslen(w_canon))).c_str());
    }
    return std::unique_ptr<wstring>(new wstring(w_canon));
}

std::unique_ptr<wstring> Canonical(wchar_t* p) {
    return Canonical(nullptr, p);
}

class NewPath
{
public:
    NewPath() {};
    BOOL Gen(wchar_t* caller, wchar_t* old_path)
    {
        auto canon = Canonical(caller, old_path);
        if (canon.get() == nullptr)
        {
            DBUG_WWARN((wchar_t*)(std::wstring(L"FAILED TO CANONIZE: ") + old_path).c_str());
            return 0;
        }
        auto new_path = g_fs_hooks.CreateLink((wchar_t*)canon.get()->c_str());       
        m_Link        = canon.get()->c_str();
        m_Newpath     = new_path.get()->c_str();
        return 1;
    }
    BOOL Link()
    {
        if (0 == g_fs_hooks.Link(m_Link, (wchar_t*)m_Newpath.c_str()))
        {
            DBUG_WWARN((wchar_t*)(std::wstring(L"FAILED TO LINK  ") + m_Link).c_str());
            return 0;
        }
        return 1;
    }
    std::wstring m_Link;
    std::wstring m_Newpath;
};

BOOL WINAPI __MoveFileW_Hook(LPCWSTR FileName, LPCWSTR NewFileName, LPVOID ret_add)
{
    if (IsGameModule(ret_add) == 0 || GetFileAttributesW(NewFileName) != INVALID_FILE_ATTRIBUTES)
        return g_fs_hooks.m_MoveFileW(FileName, NewFileName);

    auto new_path = NewPath();
    if (0 == new_path.Gen(L"__MoveFileW_Hook", (wchar_t*)NewFileName))
    {
        DBUG_WWARN((wchar_t*)(std::wstring(L"NewPath::Gen() FAILED ") + NewFileName).c_str());
        return g_fs_hooks.m_MoveFileW(FileName, NewFileName);
    }
    if (0 == g_fs_hooks.CreateFileDir((wchar_t*)new_path.m_Newpath.c_str()))
    {
        DBUG_WWARN((wchar_t*)(std::wstring(L"FS_HOOKS::CreateFileDir FAILED ") + NewFileName).c_str());
        return g_fs_hooks.m_MoveFileW(FileName, NewFileName);
    }
    BOOL s = g_fs_hooks.m_MoveFileW(FileName, new_path.m_Newpath.c_str());
    if (s == 0)
    {
        DBUG_WWARN((wchar_t*)(std::wstring(L"CopyFileW FAILED ") + NewFileName).c_str());
        return g_fs_hooks.m_MoveFileW(FileName, NewFileName);
    }
    if (0 == new_path.Link())
    {
        DBUG_WWARN((wchar_t*)(std::wstring(L"NewPath::Link FAILED ") + NewFileName).c_str());
        return g_fs_hooks.m_MoveFileW(FileName, NewFileName);
    }

    g_fs_hooks.lock->lock();
    g_fs_hooks.m_Links.push_back(std::wstring(new_path.m_Link.c_str()));
    g_fs_hooks.lock->unlock();
    g_fs_hooks.m_LinksLog.m_Outfile.open(g_fs_hooks.m_LinksLog.m_OutPut.c_str(), std::ios_base::out | std::ios_base::app);
    g_fs_hooks.m_LinksLog.m_Outfile << (wchar_t*)new_path.m_Link.c_str() << L"\n";
    g_fs_hooks.m_LinksLog.m_Outfile.close();
    return s;
}

BOOL WINAPI MoveFileA_Hook(LPCSTR FileName, LPCSTR NewFileName)
{
    LPVOID ret = __builtin_return_address(0);
    std::unique_ptr<wchar_t[]>       FileNameW(UnicodePath(FileName));
    std::unique_ptr<wchar_t[]> NewFileNameW(UnicodePath(NewFileName));
    return __MoveFileW_Hook(FileNameW.get(), NewFileNameW.get(), ret);
}

BOOL WINAPI MoveFileW_Hook(LPCWSTR FileName, LPCWSTR NewFileName)
{
    LPVOID ret = __builtin_return_address(0);
    return __MoveFileW_Hook(FileName, NewFileName, ret);
}

BOOL WINAPI __CopyFileW_Hook(LPCWSTR FileName, LPCWSTR NewFileName, BOOL fail, LPVOID ret_add)
{
    if (IsGameModule(ret_add) == 0 || GetFileAttributesW(NewFileName) != INVALID_FILE_ATTRIBUTES)
        return g_fs_hooks.m_CopyFileW(FileName, NewFileName, fail);

    auto new_path = NewPath();
    if (0 == new_path.Gen(L"__CopyFileW_Hook", (wchar_t*)NewFileName))
    {
        DBUG_WWARN((wchar_t*)(std::wstring(L"NewPath::Gen() FAILED ") + NewFileName).c_str());
        return g_fs_hooks.m_CopyFileW(FileName, NewFileName, fail);
    }
    if (0 == g_fs_hooks.CreateFileDir((wchar_t*)new_path.m_Newpath.c_str()))
    {
        DBUG_WWARN((wchar_t*)(std::wstring(L"FS_HOOKS::CreateFileDir FAILED ") + NewFileName).c_str());
        return g_fs_hooks.m_CopyFileW(FileName, NewFileName, fail);
    }
    BOOL s = g_fs_hooks.m_CopyFileW(FileName, new_path.m_Newpath.c_str(), fail);
    if (s == 0)
    {
        DBUG_WWARN((wchar_t*)(std::wstring(L"CopyFileW FAILED ") + new_path.m_Newpath.c_str()).c_str());
        return g_fs_hooks.m_CopyFileW(FileName, NewFileName, fail);
    }
    if (0 == new_path.Link())
    {
        DBUG_WWARN((wchar_t*)(std::wstring(L"NewPath::Link FAILED ") + NewFileName).c_str());
        return g_fs_hooks.m_CopyFileW(FileName, NewFileName, fail);
    }

    g_fs_hooks.lock->lock();
    g_fs_hooks.m_Links.push_back(std::wstring(new_path.m_Link.c_str()));
    g_fs_hooks.lock->unlock();
    g_fs_hooks.m_LinksLog.m_Outfile.open(g_fs_hooks.m_LinksLog.m_OutPut.c_str(), std::ios_base::out | std::ios_base::app);
    g_fs_hooks.m_LinksLog.m_Outfile << (wchar_t*)new_path.m_Link.c_str() << L"\n";
    g_fs_hooks.m_LinksLog.m_Outfile.close();
    return s;
}

BOOL WINAPI CopyFileA_Hook(LPCSTR FileName, LPCSTR NewFileName, BOOL fail)
{
    LPVOID ret = __builtin_return_address(0);
    std::unique_ptr<wchar_t[]>       FileNameW(UnicodePath(FileName));
    std::unique_ptr<wchar_t[]> NewFileNameW(UnicodePath(NewFileName));
    return __CopyFileW_Hook(FileNameW.get(), NewFileNameW.get(), fail, ret);
}

BOOL WINAPI CopyFileW_Hook(LPCWSTR FileName, LPCWSTR NewFileName, BOOL fail)
{
    LPVOID ret = __builtin_return_address(0);
    return __CopyFileW_Hook(FileName, NewFileName, fail, ret);
}

const wchar_t * FileReplacement(const wchar_t * original_path)
{
    std::wstring   file_name;
    const wchar_t* wfname;
    wchar_t fname[_MAX_FNAME + _MAX_EXT + 1];
    wchar_t   ext[_MAX_EXT + 1];
    _wsplitpath(original_path, nullptr, nullptr, fname, ext);
    file_name.clear();
    file_name += fname;
    file_name += ext;

    for (UINT c = 0; c < file_name.length(); c++)
    {
        file_name[c] = tolower(file_name[c]);
    }
    wfname = file_name.c_str();
    wchar_t* name;
    for (UINT i = 0; i < g_fs_hooks.files->Count(); i++)
    {
        name = (wchar_t*)g_fs_hooks.files->KeyAt(i);
        if (wcscmp(name, wfname) == 0)
        {
            return (const wchar_t*) g_fs_hooks.files->ValueAt(i);
        }
    }
    return original_path;
}

HANDLE WINAPI __CreateFileW_Hook(wchar_t * lpFileName,  DWORD dwDesiredAccess,
        DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes,
        DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes,
        HANDLE hTemplateFile, LPVOID retadd)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (g_fs_hooks.m_ModsFlag)
    {
        return pCreateFileW(FileReplacement(lpFileName), dwDesiredAccess, dwShareMode, lpSecurityAttributes,
                            dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);            
    }
    if (g_fs_hooks.m_LinksFlag)
    {
        BOOL exists = GetFileAttributesW(lpFileName) != INVALID_FILE_ATTRIBUTES;       
        if (IsGameModule(retadd) && exists == 0)
        {
            if (dwCreationDisposition & CREATE_NEW || dwCreationDisposition & CREATE_ALWAYS)
            {
                auto new_path = NewPath();
                if (0 == new_path.Gen(L"__CreateFileW_Hook", lpFileName))
                {
                    DBUG_WWARN((wchar_t*)(std::wstring(L"NewPath::Gen() FAILED ") + lpFileName).c_str());
                    return pCreateFileW(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
                }
                if (0 == g_fs_hooks.CreateFileDir((wchar_t*)new_path.m_Newpath.c_str()))
                {
                    DBUG_WWARN((wchar_t*)(std::wstring(L"FS_HOOKS::CreateFileDir FAILED ") + lpFileName).c_str());
                    return pCreateFileW(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
                }
                HANDLE h = 
                    pCreateFileW((wchar_t*)new_path.m_Newpath.c_str(),dwDesiredAccess,dwShareMode,lpSecurityAttributes,dwCreationDisposition,dwFlagsAndAttributes,hTemplateFile);
                if (h == INVALID_HANDLE_VALUE)
                {
                    DBUG_WWARN((wchar_t*)(std::wstring(L"CreateFileW FAILED ") + lpFileName).c_str());
                    return pCreateFileW(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
                }
                if (0 == new_path.Link())
                {
                    DBUG_WWARN((wchar_t*)(std::wstring(L"NewPath::Link FAILED ") + lpFileName).c_str());
                    return pCreateFileW(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
                }
                
                g_fs_hooks.lock->lock();
                g_fs_hooks.m_Links.push_back(std::wstring(new_path.m_Link.c_str()));
                g_fs_hooks.lock->unlock();
                g_fs_hooks.m_LinksLog.m_Outfile.open(g_fs_hooks.m_LinksLog.m_OutPut.c_str(), std::ios_base::out | std::ios_base::app);
                g_fs_hooks.m_LinksLog.m_Outfile << (wchar_t*)new_path.m_Link.c_str() << L"\n";
                g_fs_hooks.m_LinksLog.m_Outfile.close();
                return h;
            }
        }
    }
    return pCreateFileW(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes,
                        dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
}

HANDLE WINAPI CreateFileA_Hook(char * lpFileName,  DWORD dwDesiredAccess,
        DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes,
        DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes,
        HANDLE hTemplateFile)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID ret = __builtin_return_address(0);
    std::unique_ptr<wchar_t[]> wfile(UnicodePath(lpFileName));
    return __CreateFileW_Hook(wfile.get(), dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile, ret);
}

HANDLE WINAPI CreateFileW_Hook(wchar_t* lpFileName, DWORD dwDesiredAccess,
    DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes,
    DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes,
    HANDLE hTemplateFile)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID ret = __builtin_return_address(0);
    return __CreateFileW_Hook(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile, ret);
}

FILE * __cdecl wfopenhook(const wchar_t* f, const wchar_t* m)
{
    if (g_fs_hooks.m_ModsFlag) return g_fs_hooks.m_wfopen(FileReplacement(f), m);
    return g_fs_hooks.m_wfopen(f, m);
}

FILE * __cdecl fopenhook(const char* f, const char* m)
{
    std::unique_ptr<wchar_t[]> wfile(UnicodePath(f));
    std::unique_ptr<wchar_t[]> wmode(UnicodePath(m));
    //return g_fs_hooks.m_fopen(f, m);
    return wfopenhook(wfile.get(), wmode.get());
}

HANDLE WINAPI FindFirstFileW_Hook(const wchar_t * lpFileName, LPWIN32_FIND_DATAW lpFindFileData)
{
    return pFindFirstFileW(lpFileName, lpFindFileData);
}

HANDLE WINAPI FindFirstFileA_Hook(const char * lpFileName, LPWIN32_FIND_DATAA lpFindFileData)
{
    std::unique_ptr<wchar_t[]> wfile(UnicodePath(lpFileName));
    WIN32_FIND_DATAW fdata;
    HANDLE hFile = FindFirstFileW_Hook(wfile.get(), &fdata);
    if (hFile == INVALID_HANDLE_VALUE ) return hFile;

    size_t sz;

    lpFindFileData->dwFileAttributes   = fdata.dwFileAttributes;
    lpFindFileData->ftCreationTime     = fdata.ftCreationTime;
    lpFindFileData->ftLastAccessTime   = fdata.ftLastAccessTime;
    lpFindFileData->ftLastWriteTime    = fdata.ftLastWriteTime;
    lpFindFileData->nFileSizeHigh      = fdata.nFileSizeHigh;
    lpFindFileData->nFileSizeLow       = fdata.nFileSizeLow;
    lpFindFileData->dwReserved0        = fdata.dwReserved0;
    lpFindFileData->dwReserved1        = fdata.dwReserved1;
    wcstombs_s(&sz, lpFindFileData->cFileName, MAX_PATH, fdata.cFileName, MAX_PATH);
    wcstombs_s(&sz, lpFindFileData->cAlternateFileName, 14, fdata.cAlternateFileName, 14);

    return hFile;
}

/* Resident Evil 2 needs this */
BOOL WINAPI FindNextFileA_Hook(HANDLE hFindFile, LPWIN32_FIND_DATAA lpFindFileData)
{
    WIN32_FIND_DATAW fdata;
    BOOL success = FindNextFileW(hFindFile, &fdata);
    if (!success) return success;

    size_t sz;

    lpFindFileData->dwFileAttributes   = fdata.dwFileAttributes;
    lpFindFileData->ftCreationTime     = fdata.ftCreationTime;
    lpFindFileData->ftLastAccessTime   = fdata.ftLastAccessTime;
    lpFindFileData->ftLastWriteTime    = fdata.ftLastWriteTime;
    lpFindFileData->nFileSizeHigh      = fdata.nFileSizeHigh;
    lpFindFileData->nFileSizeLow       = fdata.nFileSizeLow;
    lpFindFileData->dwReserved0        = fdata.dwReserved0;
    lpFindFileData->dwReserved1        = fdata.dwReserved1;
    wcstombs_s(&sz, lpFindFileData->cFileName, MAX_PATH, fdata.cFileName, MAX_PATH);
    wcstombs_s(&sz, lpFindFileData->cAlternateFileName, 14, fdata.cAlternateFileName, 14);
    return success;
}

void __stdcall FileHooksInsertFile(const wchar_t* name, const wchar_t* path)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    wchar_t* key = new wchar_t[wcslen(name) + 1];
    wchar_t* val = new wchar_t[wcslen(path) + 1];
    wcscpy(key, name);
    wcscpy(val, path);
    WTOLOWER(key, wcslen(key));
    WTOLOWER(val, wcslen(val));
    g_fs_hooks.files->insert_disposable(key, val);
    DBUG_WWARN((std::wstring(L"Inserted: ") + key + L" " + val).c_str())
    return;
}

extern "C" __declspec(dllexport)
HRESULT InitFileHooks(wchar_t * wpath, char * path, LPVOID paths,
                      LPVOID dirs, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    OutputDebugStringA("----------------------------");
    g_fs_hooks.dlls        = new POINTER_DICTIONARY();
    g_fs_hooks.lock        = new SYNC::AtomicLock();
    g_fs_hooks.dbug        = flags & 0x1000;
    g_fs_hooks.m_ModsFlag  = flags & 0x10;
    g_fs_hooks.m_LinksFlag = flags & 0x100;
    g_fs_hooks.Init(path);    

    //auto envparserA = EnvStringsParserA().Parse(g_fs_hooks.m_GetEnvironmentStringsA(), &g_fs_hooks.m_fldsloger);
    //EnvStringsParserA().Parse((char*)envparserA.Edit(path), &g_fs_hooks.m_fldsloger);

    //auto envparserW = EnvStringsParserW().Parse(g_fs_hooks.m_GetEnvironmentStringsW(), &g_fs_hooks.m_fldsloger);
    //EnvStringsParserW().Parse((wchar_t*)envparserW.Edit(wpath), &g_fs_hooks.m_fldsloger);

    if (flags & 0x01)
    {
        wcsncpy(g_fs_hooks.WPath, wpath, wcslen(wpath));
        strncpy(g_fs_hooks.APath, path, strlen(path));       
        OutputDebugStringA("----------------------------");

        HMODULE hShel;
        if (! (hShel = GetModuleHandle(L"Shell32.dll")) )
        {
            OutputDebugStringA("No handle");
            return 1;
        }
        HMODULE hAdvapi;
        if (! (hAdvapi = GetModuleHandle(L"Advapi32.dll")) )
        {
            OutputDebugStringA("No Advapi32 handle");
            return 1;
        }

        pSHGetKnownFolder = (SHGetKnownFolderPath_Trampoline)
                GetProcAddress(hShel, "SHGetKnownFolderPath");

        pSHGetFolderPathA = (SHGetFolderPathA_Type)
                GetProcAddress(hShel, "SHGetFolderPathA");

        pSHGetFolderPathW = (SHGetFolderPathW_Type)
                GetProcAddress(hShel, "SHGetFolderPathW");

        pSHGetSpecialFolderPathA = (SHGetSpecialFolderPathA_Type)
                GetProcAddress(hShel, "SHGetSpecialFolderPathA");

        pSHGetSpecialFolderPathW = (SHGetSpecialFolderPathW_Type)
                GetProcAddress(hShel, "SHGetSpecialFolderPathW");

        pSHGetPathFromIDListW = (SHGetPathFromIDListW_Type)
                GetProcAddress(hShel, "SHGetPathFromIDListW");

        pRegQueryValueExA = (RegQueryValueExA_Type)
                GetProcAddress(hAdvapi, "RegQueryValueExA");

        pRegQueryValueExW = (RegQueryValueExW_Type)
                GetProcAddress(hAdvapi, "RegQueryValueExW");
        /*
        sethook((void**)&pSHGetKnownFolder, SHGetKnownFolder_Hook);
        sethook((void**)&pSHGetFolderPathA, SHGetFolderPathA_Hook);
        sethook((void**)&pSHGetFolderPathW, SHGetFolderPathW_Hook);
        sethook((void**)&pSHGetSpecialFolderPathA, SHGetSpecialFolderPathA_Hook);
        sethook((void**)&pSHGetSpecialFolderPathW, SHGetSpecialFolderPathW_Hook);
        */
        HOOK((void**)&pSHGetKnownFolder, SHGetKnownFolder_Hook);
        HOOK((void**)&pSHGetFolderPathA, SHGetFolderPathA_Hook);
        HOOK((void**)&pSHGetFolderPathW, SHGetFolderPathW_Hook);
        HOOK((void**)&pSHGetSpecialFolderPathA, SHGetSpecialFolderPathA_Hook);
        HOOK((void**)&pSHGetSpecialFolderPathW, SHGetSpecialFolderPathW_Hook);
        HOOK(&g_fs_hooks.m_SHGetFolderLocation, SHGetFolderLocation_Hook);
        HOOK(&g_fs_hooks.m_GetEnvironmentVariableA, GetEnvironmentVariableA_Hook);
        HOOK(&g_fs_hooks.m_GetEnvironmentVariableW, GetEnvironmentVariableW_Hook);
        HOOK(&g_fs_hooks.m_GetEnvironmentStringsA, GetEnvironmentStringsA_Hook);
        HOOK(&g_fs_hooks.m_GetEnvironmentStringsW, GetEnvironmentStringsW_Hook);
        HOOK(&g_fs_hooks.m_FreeEnvironmentStringsA, FreeEnvironmentStringsA_Hook);
        HOOK(&g_fs_hooks.m_FreeEnvironmentStringsW, FreeEnvironmentStringsW_Hook);
        //HOOK(&g_fs_hooks.m_shfolder_GetFolderPathW, SHGetFolderPathW_Hook)
        //HOOK(&g_fs_hooks.m_shfolder_GetFolderPathA, SHGetFolderPathA_Hook)        
#ifndef _WIN64
        sethook((void**)&pRegQueryValueExA, RegQueryValueExA_Hook);  //Soul reaver 2, blood omen 2
#endif
    }
    if (g_fs_hooks.m_ModsFlag || g_fs_hooks.m_LinksFlag)
    {
        g_fs_hooks.files  = (POINTER_DICTIONARY*) paths;
        HMODULE hKernel32 = GetModuleHandle(L"Kernel32.dll");
        if (hKernel32 == nullptr)
        {
            OutputDebugStringA("No hKernel32 handle");
            return 1;
        }

        pCreateFileA = (CreateFileA_Trampoline)
                GetProcAddress(hKernel32, "CreateFileA");

        pCreateFileW = (CreateFileW_Trampoline)
                GetProcAddress(hKernel32, "CreateFileW");

        HMODULE hmsvcrt = GetModuleHandle(L"msvcrt.dll");
        if (hmsvcrt != nullptr)
        {
            g_fs_hooks.m_wfopen = (decltype(g_fs_hooks.m_wfopen))GetProcAddress(hmsvcrt, "_wfopen");
            g_fs_hooks.m_fopen  = (decltype(g_fs_hooks.m_fopen)) GetProcAddress(hmsvcrt, "fopen");
            HOOK((void**)&g_fs_hooks.m_wfopen, wfopenhook);
            HOOK((void**)&g_fs_hooks.m_fopen, fopenhook);
        }

        HOOK((void**)&pCreateFileA, CreateFileA_Hook);
        HOOK((void**)&pCreateFileW, CreateFileW_Hook);        
        if (g_fs_hooks.m_LinksFlag)
        {
            HOOK(&g_fs_hooks.m_CopyFileW, CopyFileW_Hook)
            HOOK(&g_fs_hooks.m_CopyFileA, CopyFileA_Hook)
            HOOK(&g_fs_hooks.m_MoveFileW, MoveFileW_Hook)
            HOOK(&g_fs_hooks.m_MoveFileA, MoveFileA_Hook)
        }
    }   
    return 0;
}
