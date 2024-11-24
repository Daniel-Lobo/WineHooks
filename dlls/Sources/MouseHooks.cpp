#include <windows.h>
#include "sethooks.h"
#include "MouseHooks.h"
#include <tlhelp32.h>
#include <intrin.h>
#include <wchar.h>
#include "dllmain.h"
#include <windowsx.h>
#pragma intrinsic(_ReturnAddress)

MOUSEPARAMS MouseParams;

UINT WINAPI GetRawInputData_Hook(HRAWINPUT hRawInput, UINT uiCommand, LPVOID pData, PUINT pcbSize, UINT cbSizeHeader)
{
    UINT r = MouseParams.GetRawInputData_Trampoline(hRawInput, uiCommand, pData, pcbSize, cbSizeHeader);    
    return r;   
}

UINT WINAPI GetMessagePos_Hook()
{
    UINT pos = MouseParams.GetMessagePos_Trampoline();
    __int64 ret = (__int64)__builtin_return_address(0);
    if ((ret > MouseParams.MinAdd) && (ret < MouseParams.MaxAdd))  return pos;
    int x = GET_X_LPARAM(pos);
    int y = GET_Y_LPARAM(pos);
    y /= MouseParams.y_scale;
    x -= MouseParams.x_displacement;
    x /= MouseParams.y_scale;

    // x and y can be negative on multimonitorts, so this code won't work correctlly
    if       (x < 0)             { x = 0;            }
    else if  (x > MouseParams.w) { x = MouseParams.w;}
    if       (y < 0)             { y = 0;            }
    else if  (y > MouseParams.h) { y = MouseParams.h;}
    return (x & 0xffff) | ((y & 0xffff) << 16) ;
}

BOOL WINAPI GetMousePos_Hook(LPPOINT lpPoint)
{
    BOOL r = MouseParams.GetCursorPos_Trampoline(lpPoint);
    __int64 ret = (__int64)__builtin_return_address(0);
    if ((ret > MouseParams.MinAdd) && (ret < MouseParams.MaxAdd))
        return r;
    //return r;
    BOOL adjust  = 0;
    if(r)
    {
        lpPoint->y /= MouseParams.y_scale;
        lpPoint->x -= MouseParams.x_displacement;
        lpPoint->x /= MouseParams.y_scale;
    }
    if      (lpPoint->x<0)             {lpPoint->x=0; adjust=1;}
    else if (lpPoint->x>MouseParams.w) {lpPoint->x=MouseParams.w; adjust=1;}
    if      (lpPoint->y<0)             {lpPoint->y=0; adjust=1;}
    else if (lpPoint->y>MouseParams.h) {lpPoint->y=MouseParams.h; adjust=1;}
    /*
    if (adjust)
        MouseParams.SetCursorPos_Trampoline
            (lpPoint->x*MouseParams.y_scale+MouseParams.x_displacement,
             lpPoint->y*MouseParams.y_scale);
    */
    return r;
}

BOOL WINAPI SetMousePos_Hook(int x, int y)
{
    __int64 ret = (__int64)__builtin_return_address(0);
    if ((ret > MouseParams.MinAdd) && (ret < MouseParams.MaxAdd))
        return MouseParams.SetCursorPos_Trampoline(x, y);
    y *= MouseParams.y_scale;
    x *= MouseParams.y_scale;
    x += MouseParams.x_displacement;

    return MouseParams.SetCursorPos_Trampoline(x, y);
}

BOOL WINAPI PeekMessageW_Hook(LPMSG lpMsg, HWND hWnd, UINT Min, UINT Max, UINT wRemoveMsg)
{
    BOOL r = MouseParams.PeekMessageW_Trampoline(lpMsg, hWnd, Min, Max, wRemoveMsg);
    if ( (lpMsg->message>=0x0200) && (lpMsg->message<=0x0202))
    {
        BOOL adjust  = 0;
        lpMsg->pt.y /= MouseParams.y_scale;
        lpMsg->pt.x -= MouseParams.x_displacement;
        lpMsg->pt.x /= MouseParams.y_scale;
        if      (lpMsg->pt.x<0)             {lpMsg->pt.x=0; adjust=1;}
        else if (lpMsg->pt.x>MouseParams.w) {lpMsg->pt.x=MouseParams.w; adjust=1;}
        if      (lpMsg->pt.y<0)             {lpMsg->pt.y=0; adjust=1;}
        else if (lpMsg->pt.y>MouseParams.h) {lpMsg->pt.y=MouseParams.h; adjust=1;}
        lpMsg->lParam=lpMsg->pt.x|(lpMsg->pt.y << 16);
    }
    return r;
}

BOOL WINAPI PeekMessageA_Hook(LPMSG lpMsg, HWND hWnd, UINT Min, UINT Max, UINT wRemoveMsg)
{
    BOOL r = MouseParams.PeekMessageA_Trampoline(lpMsg, hWnd, Min, Max, wRemoveMsg);
    if ( (lpMsg->message>=0x0200) && (lpMsg->message<=0x0202))
    {
        BOOL adjust  = 0;
        lpMsg->pt.y /= MouseParams.y_scale;
        lpMsg->pt.x -= MouseParams.x_displacement;
        lpMsg->pt.x /= MouseParams.y_scale;
        if      (lpMsg->pt.x<0)             {lpMsg->pt.x=0; adjust=1;}
        else if (lpMsg->pt.x>MouseParams.w) {lpMsg->pt.x=MouseParams.w; adjust=1;}
        if      (lpMsg->pt.y<0)             {lpMsg->pt.y=0; adjust=1;}
        else if (lpMsg->pt.y>MouseParams.h) {lpMsg->pt.y=MouseParams.h; adjust=1;}
        lpMsg->lParam=lpMsg->pt.x|(lpMsg->pt.y << 16);
    }
    return r;
}

BOOL WINAPI GetMessageA_Hook(LPMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax)
{
    BOOL r = MouseParams.GetMessageA_Trampoline(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax);
    if ( (lpMsg->message>=0x0200) && (lpMsg->message<=0x0202))
    {
        BOOL adjust  = 0;
        lpMsg->pt.y /= MouseParams.y_scale;
        lpMsg->pt.x -= MouseParams.x_displacement;
        lpMsg->pt.x /= MouseParams.y_scale;
        if      (lpMsg->pt.x<0)             {lpMsg->pt.x=0; adjust=1;}
        else if (lpMsg->pt.x>MouseParams.w) {lpMsg->pt.x=MouseParams.w; adjust=1;}
        if      (lpMsg->pt.y<0)             {lpMsg->pt.y=0; adjust=1;}
        else if (lpMsg->pt.y>MouseParams.h) {lpMsg->pt.y=MouseParams.h; adjust=1;}        
        lpMsg->lParam = lpMsg->pt.x | (lpMsg->pt.y << 16);
    }
    return r;
}

BOOL WINAPI GetMessageW_Hook(LPMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax)
{
    BOOL r = MouseParams.GetMessageW_Trampoline(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax);
    if ( (lpMsg->message>=0x0200) && (lpMsg->message<=0x0202))
    {
        BOOL adjust  = 0;
        lpMsg->pt.y /= MouseParams.y_scale;
        lpMsg->pt.x -= MouseParams.x_displacement;
        lpMsg->pt.x /= MouseParams.y_scale;
        if      (lpMsg->pt.x<0)             {lpMsg->pt.x=0; adjust=1;}
        else if (lpMsg->pt.x>MouseParams.w) {lpMsg->pt.x=MouseParams.w; adjust=1;}
        if      (lpMsg->pt.y<0)             {lpMsg->pt.y=0; adjust=1;}
        else if (lpMsg->pt.y>MouseParams.h) {lpMsg->pt.y=MouseParams.h; adjust=1;}
        lpMsg->lParam = lpMsg->pt.x | (lpMsg->pt.y << 16);
    }
    return r;
}

extern "C" __declspec(dllexport)
void InitMouseHooks()
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    MouseParams.success                 = 1;
    MouseParams.x_displacement          = 0;
    MouseParams.scale                   = 1.f;
    MouseParams.y_scale                 = 1.f;

    MouseParams.GetCursorPos_Trampoline    = GetCursorPos;
    MouseParams.SetCursorPos_Trampoline    = SetCursorPos;    
    MouseParams.GetMessageA_Trampoline     = GetMessageA;
    MouseParams.GetMessageW_Trampoline     = GetMessageW;
    MouseParams.PeekMessageA_Trampoline    = PeekMessageA;
    MouseParams.PeekMessageW_Trampoline    = PeekMessageW;
    MouseParams.GetMessagePos_Trampoline   = GetMessagePos;
    MouseParams.GetRawInputData_Trampoline = GetRawInputData;

    /*
    MouseParams.success =
    sethook((void**)&MouseParams.GetCursorPos_Trampoline, GetMousePos_Hook);
    sethook((void**)&MouseParams.SetCursorPos_Trampoline, SetMousePos_Hook);    
    sethook((void**)&MouseParams.GetMessageW_Trampoline, GetMessageW_Hook);
    sethook((void**)&MouseParams.GetMessageA_Trampoline, GetMessageA_Hook);
    sethook((void**)&MouseParams.PeekMessageW_Trampoline, PeekMessageW_Hook);
    sethook((void**)&MouseParams.PeekMessageA_Trampoline, PeekMessageA_Hook);
    */
    HOOK((void**)&MouseParams.GetCursorPos_Trampoline, GetMousePos_Hook);
    HOOK((void**)&MouseParams.SetCursorPos_Trampoline, SetMousePos_Hook);
    HOOK((void**)&MouseParams.GetMessageW_Trampoline, GetMessageW_Hook);
    HOOK((void**)&MouseParams.GetMessageA_Trampoline, GetMessageA_Hook);
    HOOK((void**)&MouseParams.PeekMessageW_Trampoline, PeekMessageW_Hook);
    HOOK((void**)&MouseParams.PeekMessageA_Trampoline, PeekMessageA_Hook);
    HOOK((void**)&MouseParams.GetMessagePos_Trampoline, GetMessagePos_Hook); // outer wilds
    //HOOK((void**)&MouseParams.GetRawInputData_Trampoline, GetRawInputData_Hook);
}

extern "C" __declspec(dllexport)
DWORD SetMouseHooksParams(float scale, float y_scale,
                          DWORD x_displacement, DWORD w, DWORD h)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    wchar_t * mod;
    LoadLibraryA("DINPUT.dll");
    HANDLE hSnapshot;
    MODULEENTRY32W modentry = { 0 };
    hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, 0);
    modentry.dwSize = sizeof(MODULEENTRY32W);
    Module32FirstW(hSnapshot, &modentry);
    do
    {
       if ( (memcmp(modentry.szModule, L"DINPUT", 4)==0) ||
            (memcmp(modentry.szModule, L"dinput", 4)==0))
       {
            //MessageBoxW(NULL, modentry.szModule, L"DINPUT", NULL);
            MouseParams.MinAdd = (__int64)modentry.modBaseAddr;
            MouseParams.MaxAdd = (__int64)modentry.modBaseAddr+modentry.modBaseSize;
            break;
       }
    } while (Module32NextW(hSnapshot, &modentry));
    CloseHandle(hSnapshot);
    MouseParams.x_displacement = x_displacement;
    MouseParams.scale          = scale;
    MouseParams.y_scale        = y_scale;
    MouseParams.w              = w-1;
    MouseParams.h              = h-1;
    return  MouseParams.MinAdd;
}
