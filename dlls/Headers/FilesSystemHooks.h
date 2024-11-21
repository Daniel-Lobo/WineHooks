#ifndef FILESSYSTEMHOOKS_H
#define FILESSYSTEMHOOKS_H
#include <windows.h>
#include <wchar.h>
#include "collections.h"
#include "Sync.h"
#include "shlobj.h"
#include <filesystem>
#include <memory>
#include <vector>
#include <map>
#include <regex>
#include <processenv.h>

using std::filesystem::path;
using std::filesystem::canonical;
using std::wstring;
using std::to_wstring;

typedef HFILE (WINAPI * OpenFile_Trampoline)
(LPCSTR lpFileName, LPOFSTRUCT lpReOpenBuff, UINT uStyle);

typedef BOOL (WINAPI * FindNextFileA_Trampoline)
(HANDLE             hFindFile,
 LPWIN32_FIND_DATAA lpFindFileData);

typedef HANDLE (WINAPI * FindFirstFileA_Trampoline)
(const char *       lpFileName,
 LPWIN32_FIND_DATAA lpFindFileData);

typedef HANDLE (WINAPI * FindFirstFileW_Trampoline)
(const wchar_t *    lpFileName,
 LPWIN32_FIND_DATAW lpFindFileData);

typedef HRESULT (WINAPI * SHGetKnownFolderPath_Trampoline)
(REFKNOWNFOLDERID rfid, DWORD dwFlags, HANDLE hToken, PWSTR *ppszPath);

typedef HRESULT (WINAPI * SHGetFolderPathA_Type)(HWND, int, HANDLE, DWORD, LPSTR  pszPath);
typedef HRESULT (WINAPI * SHGetFolderPathW_Type)(HWND, int, HANDLE, DWORD, LPWSTR  pszPath);
typedef BOOL    (WINAPI * SHGetSpecialFolderPathA_Type)(HWND, LPSTR, int, BOOL);
typedef BOOL    (WINAPI * SHGetSpecialFolderPathW_Type)(HWND, LPWSTR, int, BOOL);
typedef BOOL    (WINAPI * SHGetPathFromIDListW_Type)(PCIDLIST_ABSOLUTE pidl, LPWSTR pszPath);
typedef LSTATUS (WINAPI * RegQueryValueExA_Type)(HKEY, LPCSTR, LPDWORD,  LPDWORD, LPBYTE, LPDWORD);
typedef LSTATUS (WINAPI * RegQueryValueExW_Type)(HKEY, LPCWSTR, LPDWORD,  LPDWORD, LPBYTE, LPDWORD);

typedef HANDLE (WINAPI * CreateFileA_Trampoline)(
   const char *          lpFileName,
   DWORD                 dwDesiredAccess,
   DWORD                 dwShareMode,
   LPSECURITY_ATTRIBUTES lpSecurityAttributes,
   DWORD                 dwCreationDisposition,
   DWORD                 dwFlagsAndAttributes,
   HANDLE                hTemplateFile
);
typedef HANDLE (WINAPI * CreateFileW_Trampoline)(
   const wchar_t *       lpFileName,
   DWORD                 dwDesiredAccess,
   DWORD                 dwShareMode,
   LPSECURITY_ATTRIBUTES lpSecurityAttributes,
   DWORD                 dwCreationDisposition,
   DWORD                 dwFlagsAndAttributes,
   HANDLE                hTemplateFile
);

class EnvStringsParserA
{
    std::vector <std::string> m_keys;
    std::vector <std::string> m_vals;
public:
    void Append(char* v)
    {
        std::string var = v;
        size_t sep = var.find("=");
        if (sep == std::string::npos) return;
        //if (sep == strlen(v)-1) return; //__COMPAT_LAYER may be empty
        std::string key = var.substr(0, sep);
        std::string val = var.substr(sep + 1, std::string::npos);
        m_keys.push_back(key);
        m_vals.push_back(val);
    }
    EnvStringsParserA& Parse(char* env, WLoger* logger)
    {
        wchar_t end;
        do {
            if (logger != nullptr) logger->log(__FUNCTION__, env);
            Append(env);
            env += strlen(env) + 1;
            end = *env;
        } while (end != '\0');
        return *this;
    }
    char* Edit(char* new_val)
    {
        if (m_keys.size() == 0) return 0;
        char* key;
        char* val;
        auto new_env = std::vector <char>();
        for (UINT i = 0; i < m_keys.size(); i++)
        {
            key = (char*) m_keys[i].c_str();
            if (strcmpi(key, "LOCALAPPDATA") == 0 || strcmpi(key, "USERPROFILE") == 0 || strcmpi(key, "allusersprofile") == 0 ||
                strcmpi(key, "APPDATA") == 0)
            {
                m_vals[i] = std::string(new_val);
            }
            val = (char*) m_vals[i].c_str();
            for (char character = *key; character != L'\0'; character = *++key)
            {
                new_env.push_back(character);
            }
            new_env.push_back('=');
            for (char character = *val; character != L'\0'; character = *++val)
            {
                new_env.push_back(character);
            }
            new_env.push_back('\0');
        }
        new_env.push_back('\0');       
        char* n_env = new char[sizeof(char) * new_env.size()];
        memcpy(n_env, &new_env[0], sizeof(char) * new_env.size());
        return n_env;
    }
};

class EnvStringsParserW
{
    std::vector <wstring> m_keys;
    std::vector <wstring> m_vals;
public:
    void Append(wchar_t * v)
    {
        wstring var = v;
        size_t  sep = var.find(L"=");
        if (sep == std::string::npos) return;
        //if (sep == wcslen(v)-1) return; // __COMPAT_LAYER may be empty
        wstring key = var.substr(0, sep);
        wstring val = var.substr(sep+1, std::string::npos);
        m_keys.push_back(key);
        m_vals.push_back(val);
    }
    EnvStringsParserW &Parse(wchar_t * env, WLoger * logger)
    {
        wchar_t end;
        do {
            //if (logger != nullptr) logger->log(__FUNCTIONW__, env);
            Append(env);
            env += wcslen(env) + 1;
            end = *env;
        } while (end != L'\0');
        return *this;
    }
    wchar_t * Edit(wchar_t* new_val)
    {
        if (m_keys.size() == 0) return 0;
        wchar_t * key;
        wchar_t * val;
        auto new_env = std::vector <wchar_t>();
        for (UINT i = 0; i < m_keys.size(); i++)
        {
            key = (wchar_t *) m_keys[i].c_str();
            if (wcsicmp(key, L"LOCALAPPDATA") == 0 || wcsicmp(key, L"USERPROFILE") == 0 || wcsicmp(key, L"allusersprofile") == 0 ||
                wcsicmp(key, L"APPDATA") == 0)
            {
                m_vals[i] = wstring(new_val);
            }
            val = (wchar_t *) m_vals[i].c_str();                   
            for (wchar_t character = *key; character != L'\0'; character = *++key)
            {
                new_env.push_back(character);
            }   
            new_env.push_back(L'=');
            for (wchar_t character = *val; character != L'\0'; character = *++val)
            {
                new_env.push_back(character);
            }            
            new_env.push_back(L'\0');              
        }    
        new_env.push_back(L'\0');
        wchar_t * n_env = new wchar_t[sizeof(wchar_t) * new_env.size()];
        memcpy(n_env, &new_env[0], sizeof(wchar_t) * new_env.size());
        return n_env;
    }
};

extern std::unique_ptr<wstring> Canonical(wchar_t* );
extern std::unique_ptr<wstring> Canonical(wchar_t*, wchar_t*);

class FilesFinder {
public:
    FilesFinder(wchar_t * dir){
        m_hDir     = FindFirstFileW((std::wstring(dir) + L"\\*").c_str(), &m_FileData);
        m_Continue = m_hDir == INVALID_HANDLE_VALUE ? 0 : 1;
    }
    void Next() {
        ZeroMemory(&m_FileData, sizeof(WIN32_FIND_DATAW));
        m_Continue = FindNextFileW(m_hDir, &m_FileData);
    }
    ~FilesFinder() {
        FindClose(m_hDir);
    }
    WIN32_FIND_DATAW  m_FileData               = {};
    BOOL              m_Continue               =  1;
    HANDLE            m_hDir = INVALID_HANDLE_VALUE;
};

void FindFiles(wchar_t*, std::vector<std::wstring>&);

typedef struct _FS_HOOKS {
    wchar_t                       WPath[MAX_PATH];
    char                          APath[MAX_PATH];
    POINTER_DICTIONARY *                    files;
    POINTER_DICTIONARY *                  folders;
    POINTER_DICTIONARY *                     dlls;
    DWORD                            redirect_new;
    DWORD                                    dbug;
    WLoger                            m_fldsloger;
    WLoger                                m_loger;
    WLoger                             m_LinksLog;
    SYNC::AtomicLock *                       lock;
    wstring                           m_Canonical;
    wstring                     m_CanonicalParent;
    wstring                 m_CanonicalParentPrnt;
    wstring                         m_Canonical_S;
    wstring                   m_CanonicalParent_S;
    wstring               m_CanonicalParentPrnt_S;
    WORD                          m_ModsFlag  = 0;
    WORD                         m_LinksFlag  = 0;
    std::vector<std::wstring>             m_Links;
    HRESULT (WINAPI * m_SHGetFolderLocation)(HWND, int, HANDLE, DWORD, PIDLIST_ABSOLUTE *);
    HRESULT (WINAPI * m_shfolder_GetFolderPathA)(HWND, int, HANDLE, DWORD, LPSTR  pszPath);
    HRESULT (WINAPI * m_shfolder_GetFolderPathW)(HWND, int, HANDLE, DWORD, LPWSTR  pszPath);
    typedef HRESULT(WINAPI* SHGetFolderPathW_Type)(HWND, int, HANDLE, DWORD, LPWSTR  pszPath);
    LPCH     (WINAPI* m_GetEnvironmentStringsA)();
    wchar_t* (WINAPI* m_GetEnvironmentStringsW)();
    BOOL (WINAPI* m_FreeEnvironmentStringsA) (char[]);
    BOOL (WINAPI* m_FreeEnvironmentStringsW) (wchar_t[]);
    DWORD (WINAPI* m_GetEnvironmentVariableA) (LPCSTR, LPSTR, DWORD)   = GetEnvironmentVariableA;
    DWORD (WINAPI* m_GetEnvironmentVariableW) (LPCWSTR, LPWSTR, DWORD) = GetEnvironmentVariableW;    
    BOOL(WINAPI* m_MoveFileA)(LPCSTR, LPCSTR)         = MoveFileA;
    BOOL(WINAPI* m_MoveFileW)(LPCWSTR, LPCWSTR)       = MoveFileW;
    BOOL(WINAPI* m_CopyFileA)(LPCSTR, LPCSTR, BOOL)   = CopyFileA;
    BOOL(WINAPI* m_CopyFileW)(LPCWSTR, LPCWSTR, BOOL) = CopyFileW;
    FILE*(__cdecl*  m_fopen) (const char*    , const char*   );
    FILE*(__cdecl* m_wfopen) (const wchar_t* , const wchar_t*);
           
    BOOL CreateFileDir(wchar_t* file)
    {
        wchar_t drive[4], dir[MAX_PATH];        
        _wsplitpath(file, drive, dir, nullptr, nullptr);
        std::wstring folder(drive); folder += dir;
        if (GetFileAttributesW(folder.c_str()) != INVALID_FILE_ATTRIBUTES) return 1;
        if (ERROR_SUCCESS != SHCreateDirectory(nullptr, folder.c_str()))
        {
            //m_loger.dolog(__FUNCTIONW__, (std::wstring(L"CreateDirectoryW FAILED FOR: ") + folder.c_str()).c_str());
            return 0;
        } return 1;
    }
    void cleanup()
    {
        wchar_t * lnk;
        if (m_Links.size())
        {
            for (UINT i = 0; i < m_Links.size(); i++)
            {
                lnk = (wchar_t*) m_Links[i].c_str();
                //m_loger.dolog(__FUNCTIONW__, (std::wstring(L"DELETING: ") + lnk).c_str());
                DeleteFileW(lnk);
            }
        }
    }
    BOOL Replace(std::wstring& output, std::wstring& orig_string, wchar_t* replaced, wchar_t* replacement) 
    {
        SIZE_T pos = orig_string.find(replaced);
        output     = orig_string;
        if (pos == std::string::npos) return 0;

        output = orig_string;
        output.replace(pos, std::wstring(replaced).size(), replacement);
        return 1;
    }
    BOOL Link(std::wstring& link, wchar_t* canonical_path)
    {
        //m_loger.dolog(__FUNCTIONW__, (std::wstring(L"LINKING: ") + link.c_str() + L"\n" + canonical_path).c_str());
        return CreateSymbolicLinkW(link.c_str(), canonical_path, 0);        
    }
    std::unique_ptr<std::wstring> CreateLink(wchar_t* canonical_path)
    {
        std::wstring link;
        std::wstring path(canonical_path);
        if (Replace(link, path, (wchar_t* )m_Canonical.c_str(), (wchar_t*)m_Canonical_S.c_str()))
        {
            return std::unique_ptr<wstring>(new wstring(link));            
        }
        if (Replace(link, path, (wchar_t*)m_CanonicalParent.c_str(), (wchar_t*)m_CanonicalParent_S.c_str()))
        {
            return std::unique_ptr<wstring>(new wstring(link));            
        }
        if (Replace(link, path, (wchar_t*)m_CanonicalParentPrnt.c_str(), (wchar_t*)m_CanonicalParentPrnt_S.c_str()))
        {
             return std::unique_ptr<wstring>(nullptr);
        }
        return std::unique_ptr<wstring>(nullptr);
    }
    void CreateLinks(wchar_t * saves_path, wchar_t * saves_path_parent, wchar_t* saves_path_parent_parent, 
                     wchar_t * game_path, wchar_t * game_path_parent, wchar_t* game_path_parent_parent)
    {
        //m_loger.dolog(__FUNCTIONW__, L"ENUMERATING SAVES");
        std::wstring                link;
        std::wstring                save;        
                        
        std::vector<std::wstring> files_found;
        FindFiles(saves_path, files_found);
        if (files_found.size() == 0) return;
        for (UINT i = 0; i < files_found.size(); i++)
        {
            save = files_found[i];
            //m_loger.dolog(__FUNCTIONW__, save.c_str());
            Replace(link, save, saves_path_parent_parent, game_path_parent_parent);
            Replace(link, link, saves_path_parent, game_path_parent);
            Replace(link, link, saves_path, game_path);
            //m_loger.dolog(__FUNCTIONW__, link.c_str());
            CreateFileDir((wchar_t*)link.c_str());
            if (0 != CreateSymbolicLinkW(link.c_str(), save.c_str(), 0))
            {
                m_Links.push_back(std::wstring(link.c_str()));
                m_LinksLog.m_Outfile.open(m_LinksLog.m_OutPut.c_str(), std::ios_base::out | std::ios_base::app);
                m_LinksLog.m_Outfile << (wchar_t*)link.c_str() << L"\n";
                m_LinksLog.m_Outfile.close();
            }
            //else m_loger.dolog(__FUNCTIONW__, L"FAILED");                        
        }
    }
    void Init(char * path)
    {
        GETPROCADDRESS(m_SHGetFolderLocation,     "SHGetFolderLocation", "Shell32.dll" );
        GETPROCADDRESS(m_shfolder_GetFolderPathA, "SHGetFolderPathA",    "shfolder.dll");
        GETPROCADDRESS(m_shfolder_GetFolderPathW, "SHGetFolderPathW",    "shfolder.dll");
        GETPROCADDRESS(m_GetEnvironmentStringsA,  "GetEnvironmentStringsA", "Kernel32.dll");
        GETPROCADDRESS(m_GetEnvironmentStringsW,  "GetEnvironmentStringsW", "Kernel32.dll");
        GETPROCADDRESS(m_FreeEnvironmentStringsA, "FreeEnvironmentStringsA", "Kernel32.dll");
        GETPROCADDRESS(m_FreeEnvironmentStringsW, "FreeEnvironmentStringsW", "Kernel32.dll");
        
        m_fldsloger.Init("\\SpecialFolders.log");  DeleteFileW(m_fldsloger.m_OutPut.c_str());
        m_loger.Init("\\FileSystem.log");          DeleteFileW(m_loger.m_OutPut.c_str());   
        m_LinksLog.Init("\\SystemLinks.log");      DeleteFileW(m_LinksLog.m_OutPut.c_str());
        Canonical(L"C:/some\\\\path//whatever");   
        m_Canonical           = Canonical((wchar_t*)CURRENTDIR().m_dir.c_str()).get()->c_str();       
        m_CanonicalParent     = Canonical((wchar_t*)std::filesystem::path(m_Canonical).parent_path().wstring().c_str()).get()->c_str();
        m_CanonicalParentPrnt = Canonical((wchar_t*)std::filesystem::path(m_CanonicalParent).parent_path().wstring().c_str()).get()->c_str();
        //m_loger.dolog(__FUNCTIONW__, (wstring(L"Path                   : ") + CURRENTDIR().m_dir).c_str());
        //m_loger.dolog(__FUNCTIONW__, (wstring(L"Canonical              : ") + m_Canonical).c_str());
        //m_loger.dolog(__FUNCTIONW__, (wstring(L"Canonical parent       : ") + m_CanonicalParent).c_str());
        //m_loger.dolog(__FUNCTIONW__, (wstring(L"Canonical parent parent: ") + m_CanonicalParentPrnt).c_str());
        m_Canonical_S           = std::filesystem::path(path).wstring() + L"..\\Saves";   // so Canonical will remove the last backslash
        m_Canonical_S           = Canonical((wchar_t*)m_Canonical_S.c_str()).get()->c_str();
        m_CanonicalParent_S     = m_Canonical_S + L"\\.Saves";
        m_CanonicalParentPrnt_S = m_Canonical_S + L"\\..Saves";
        //m_loger.dolog(__FUNCTIONW__, (wstring(L"Saves Canonical              : ") + m_Canonical_S).c_str());
        //m_loger.dolog(__FUNCTIONW__, (wstring(L"Saves Canonical parent       : ") + m_CanonicalParent_S).c_str());
        //m_loger.dolog(__FUNCTIONW__, (wstring(L"Saves Canonical parent parent: ") + m_CanonicalParentPrnt_S).c_str());        
        //CreateLinks((wchar_t*)m_Canonical_S.c_str(), (wchar_t*)m_CanonicalParent_S.c_str(), (wchar_t*)m_CanonicalParentPrnt_S.c_str(), 
                    //(wchar_t*)m_Canonical.c_str(),   (wchar_t*)m_CanonicalParent.c_str(),   (wchar_t*)m_CanonicalParentPrnt.c_str());
        m_LinksFlag = 0;       
    }
}FS_HOOKS;
extern FS_HOOKS g_fs_hooks;

#endif // FILESSYSTEMHOOKS_H
