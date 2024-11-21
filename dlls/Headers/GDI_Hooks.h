#ifndef GDI_HOOKS_H
#define GDI_HOOKS_H
#include <windows.h>

class GDIText {
public:
    GDIText(const RECT*, LPVOID, const char*, const char *);
    GDIText(const RECT*, LPVOID, const wchar_t*, const char *);
    void Init(const RECT*, LPVOID, const wchar_t*, const char *, const char *);
    const RECT * AlignTop(){
        memcpy(&m_fixed_rect, &m_rect, sizeof(RECT));
        m_fixed_rect.bottom = m_fixed_rect.top + m_height;
        return &m_fixed_rect;
    }
    DWORD   m_height = 0;
private:
    RECT m_rect       = {};
    RECT m_fixed_rect = {};
};
#endif // GDI_HOOKS_H
