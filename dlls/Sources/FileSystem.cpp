#include <windows.h>
#include "FileSystem.h"
#include <string>

WinFile::WinFile(const wchar_t * path)
{
    m_path  = new std::wstring(path);
    m_hfile = CreateFileW(path, GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
                          CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL);
    if (m_hfile == INVALID_HANDLE_VALUE)
    {
        std::wstring err(L"FAILED TO OPEN ");
        err.append(m_path->c_str());
        OutputDebugStringW(err.c_str());
    }
}

WinFile::WinFile(const wchar_t * path, BOOL)
{
    m_path  = new std::wstring(path);
    m_hfile = CreateFileW(path, GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
                          OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (m_hfile == INVALID_HANDLE_VALUE)
    {
        std::wstring err(L"FAILED TO OPEN ");
        err.append(m_path->c_str());
        OutputDebugStringW(err.c_str());
    }
}

LPVOID WinFile::read(DWORD sz)
{
    DWORD n;
    if (m_data) free(m_data);
    m_data  = malloc(sz);
    if (ReadFile(m_hfile, m_data, sz, &n, nullptr) == 0)
    {
        std::wstring err(L"FAILED TO READ ");
        err.append(m_path->c_str());
        err += L" " + std::to_wstring( (DWORD)GetLastError() );
        OutputDebugStringW(err.c_str());
    }
    return m_data;
}

DWORD WinFile::read(LPVOID pData, DWORD sz)
{
    DWORD n;
    return ReadFile(m_hfile, pData, sz, &n, nullptr);
}

DWORD WinFile::write(void * pData, SIZE_T sz)
{
    DWORD writen;
    BOOL s = WriteFile(m_hfile, pData, sz, &writen, NULL);
    if (!s)
    {
        std::wstring err(L"FAILED TO WRITE TO ");
        err.append(m_path->c_str());
        OutputDebugStringW(err.c_str());
    } return s;
}

WinFile::~WinFile()
{
    if (m_hfile != INVALID_HANDLE_VALUE) CloseHandle(m_hfile);
    if (m_path) delete m_path;
    if (m_data) free(m_data);
}
