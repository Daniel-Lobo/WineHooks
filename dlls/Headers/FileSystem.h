#ifndef FILESYSTEM_H
#define FILESYSTEM_H
#include <windows.h>
#include <string>

class WinFile {
public:
    WinFile(const wchar_t *);
    WinFile(const wchar_t *, BOOL);
    ~WinFile();
    DWORD  write(void *, SIZE_T sz);
    DWORD  read(LPVOID pData, DWORD sz);
    LPVOID read(DWORD sz);
private:
    LPVOID m_data         = nullptr;
    HANDLE m_hfile        = INVALID_HANDLE_VALUE;
    std::wstring * m_path = NULL;
};

#endif // FILESYSTEM_H
