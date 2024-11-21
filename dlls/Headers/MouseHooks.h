#ifndef MOUSEHOOKS_H
#define MOUSEHOOKS_H
#include <windows.h>

typedef struct {
    int   success;
    DWORD x_displacement;
    float scale;
    float y_scale;
    DWORD w;
    DWORD h;
    __int64 MinAdd;
    __int64 MaxAdd;
    BOOL (WINAPI * GetCursorPos_Trampoline)(LPPOINT);
    BOOL (WINAPI * SetCursorPos_Trampoline)(int, int);
    BOOL (WINAPI * GetMessageA_Trampoline)(LPMSG, HWND, UINT, UINT);
    BOOL (WINAPI * GetMessageW_Trampoline)(LPMSG, HWND, UINT, UINT);
    BOOL (WINAPI * PeekMessageA_Trampoline)(LPMSG, HWND, UINT, UINT, UINT);
    BOOL (WINAPI * PeekMessageW_Trampoline)(LPMSG, HWND, UINT, UINT, UINT);
    UINT (WINAPI * GetRawInputData_Trampoline)(HRAWINPUT, UINT, LPVOID, PUINT, UINT);
    DWORD (WINAPI * GetMessagePos_Trampoline)();
} MOUSEPARAMS;

extern "C" __declspec(dllexport)
void InitMouseHooks();

extern "C" __declspec(dllexport)
DWORD SetMouseHooksParams(float, float,DWORD, DWORD, DWORD);

#endif // MOUSEHOOKS_H

