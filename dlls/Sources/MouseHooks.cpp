#include <windows.h>
#include "sethooks.h"
#include "MouseHooks.h"
#include <tlhelp32.h>
#include <intrin.h>
#include <wchar.h>
#include <stdio.h>
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


/* ---------------------------------------------------------------------------
   Cursor scaling.

   HD mode renders the game at the resolution limit and upscales the frame to
   the desktop size, so everything the game draws grows by mScl. The mouse
   cursor does not. The game builds it with CreateIconIndirect and shows it
   with SetCursor, and Windows composites it at desktop resolution, outside
   the upscaled frame. At a 2x scale the cursor ends up half the apparent size
   of the interface it points at.

   SetCursor is the single funnel every displayed cursor passes through, so it
   is hooked here and handed a nearest-neighbour enlarged copy. Nearest
   neighbour is deliberate: the factor is an integer in every case that
   matters, and it keeps the cursor art crisp rather than smearing it.

   There is no cache keyed on HCURSOR. Gates of Hell allocates a fresh cursor
   object for every cursor change and never reuses a handle, so such a cache
   fills with dead entries within seconds and then stops scaling anything.
   Copies are made per change instead, and freed only after CURSOR_RETIRE_DEPTH
   further changes have gone by. The delay matters: DestroyCursor on the cursor
   currently on screen is undefined, and SetCursor does not necessarily take
   effect immediately when the pointer is outside the calling thread's windows.
   A copy is never eligible until it has been replaced, which alone is enough;
   the depth is slack against that reasoning being wrong somewhere. At 64 it
   costs about a megabyte and 64 user handles.
   --------------------------------------------------------------------------*/

static int   CursorScale     = 0;
static BOOL  CursorHooksReady = FALSE;
static int   CursorBuilt     = 0;
static CRITICAL_SECTION CursorLock;

#define CURSOR_RETIRE_DEPTH 64

static HCURSOR LastSrc    = NULL;   /* what the game last asked for */
static HCURSOR LastScaled = NULL;   /* the copy currently on screen */
static HCURSOR Retire[CURSOR_RETIRE_DEPTH];  /* freed once this far behind */
static int     RetirePos  = 0;

static HCURSOR (WINAPI * SetCursor_Trampoline)(HCURSOR) = SetCursor;

static void CursorLog(const char * what, HCURSOR h, int a, int b)
{
    char buf[160];
    snprintf(buf, sizeof(buf), "%s cursor %p (%d,%d)", what, (void*)h, a, b);
    g_.loger.log(__FUNCTION__, buf);
}

/* 1bpp masks carry no alpha, so StretchBlt is exact here. COLORONCOLOR is
   nearest neighbour: it replicates rows and columns rather than blending. */
static HBITMAP ScaleMaskBitmap(HBITMAP src, int w, int h, int mul)
{
    HDC     screen = GetDC(NULL);
    HDC     sdc    = CreateCompatibleDC(screen);
    HDC     ddc    = CreateCompatibleDC(screen);
    HBITMAP dst    = CreateBitmap(w * mul, h * mul, 1, 1, NULL);
    if (dst != NULL)
    {
        HGDIOBJ olds = SelectObject(sdc, src);
        HGDIOBJ oldd = SelectObject(ddc, dst);
        SetStretchBltMode(ddc, COLORONCOLOR);
        StretchBlt(ddc, 0, 0, w * mul, h * mul, sdc, 0, 0, w, h, SRCCOPY);
        SelectObject(sdc, olds);
        SelectObject(ddc, oldd);
    }
    DeleteDC(sdc);
    DeleteDC(ddc);
    ReleaseDC(NULL, screen);
    return dst;
}

/* The colour bitmap carries the alpha channel, and a GDI blit through a
   device-dependent bitmap discards it. Read the pixels out as a 32bpp DIB,
   replicate them by hand, and write them into a DIB section so every byte
   including alpha survives. Rows stay bottom-up on both sides. */
static HBITMAP ScaleColorBitmap(HBITMAP src, int w, int h, int mul)
{
    HDC        screen = GetDC(NULL);
    BITMAPINFO bi;
    ZeroMemory(&bi, sizeof(bi));
    bi.bmiHeader.biSize        = sizeof(BITMAPINFOHEADER);
    bi.bmiHeader.biWidth       = w;
    bi.bmiHeader.biHeight      = h;
    bi.bmiHeader.biPlanes      = 1;
    bi.bmiHeader.biBitCount    = 32;
    bi.bmiHeader.biCompression = BI_RGB;

    DWORD * spx = (DWORD*)HeapAlloc(GetProcessHeap(), 0, (SIZE_T)w * h * 4);
    if (spx == NULL)
    {
        ReleaseDC(NULL, screen);
        return NULL;
    }
    if (GetDIBits(screen, src, 0, h, spx, &bi, DIB_RGB_COLORS) == 0)
    {
        HeapFree(GetProcessHeap(), 0, spx);
        ReleaseDC(NULL, screen);
        return NULL;
    }

    BITMAPINFO bo = bi;
    bo.bmiHeader.biWidth  = w * mul;
    bo.bmiHeader.biHeight = h * mul;

    DWORD * dpx = NULL;
    HBITMAP dst = CreateDIBSection(screen, &bo, DIB_RGB_COLORS, (void**)&dpx, NULL, 0);
    if (dst != NULL && dpx != NULL)
    {
        int dw = w * mul;
        int dh = h * mul;
        for (int y = 0; y < dh; y++)
            for (int x = 0; x < dw; x++)
                dpx[(size_t)y * dw + x] = spx[(size_t)(y / mul) * w + (x / mul)];
    }

    HeapFree(GetProcessHeap(), 0, spx);
    ReleaseDC(NULL, screen);
    return dst;
}

static HCURSOR MakeScaledCursor(HCURSOR src, int mul)
{
    ICONINFO ii;
    if (GetIconInfo((HICON)src, &ii) == 0) return NULL;

    BITMAP  bm;
    HBITMAP nmask  = NULL;
    HBITMAP ncolor = NULL;
    HCURSOR out    = NULL;

    ZeroMemory(&bm, sizeof(bm));

    if (ii.hbmColor != NULL)
    {
        /* Colour cursor: hbmMask is a 1bpp AND mask of the same dimensions. */
        if (GetObject(ii.hbmColor, sizeof(bm), &bm) != 0 && bm.bmWidth > 0)
        {
            ncolor = ScaleColorBitmap(ii.hbmColor, bm.bmWidth, bm.bmHeight, mul);
            nmask  = ScaleMaskBitmap (ii.hbmMask,  bm.bmWidth, bm.bmHeight, mul);
            if (ncolor == NULL)
                CursorLog("failed to scale colour plane of", src, bm.bmWidth, bm.bmHeight);
        }
    }
    else
    {
        /* Monochrome cursor: hbmMask holds the AND mask stacked over the XOR
           mask, so it is twice the cursor height. Scaling it whole is right. */
        if (GetObject(ii.hbmMask, sizeof(bm), &bm) != 0 && bm.bmWidth > 0)
            nmask = ScaleMaskBitmap(ii.hbmMask, bm.bmWidth, bm.bmHeight, mul);
    }

    if (nmask != NULL && (ncolor != NULL || ii.hbmColor == NULL))
    {
        ICONINFO no;
        no.fIcon    = FALSE;
        no.xHotspot = ii.xHotspot * mul;
        no.yHotspot = ii.yHotspot * mul;
        no.hbmMask  = nmask;
        no.hbmColor = ncolor;
        out = (HCURSOR)CreateIconIndirect(&no);
        if (out == NULL)
            CursorLog("CreateIconIndirect rejected", src, bm.bmWidth * mul, bm.bmHeight * mul);
    }

    /* CreateIconIndirect copies the bitmaps, and GetIconInfo handed us copies
       of its own. Everything here is ours to release. */
    if (nmask       != NULL) DeleteObject(nmask);
    if (ncolor      != NULL) DeleteObject(ncolor);
    if (ii.hbmMask  != NULL) DeleteObject(ii.hbmMask);
    if (ii.hbmColor != NULL) DeleteObject(ii.hbmColor);
    return out;
}

static HCURSOR WINAPI SetCursor_Hook(HCURSOR h)
{
    if (h == NULL || CursorScale < 2)
        return SetCursor_Trampoline(h);

    EnterCriticalSection(&CursorLock);

    /* Our own copy handed back, or the same source as last time. Neither needs
       a new copy, and the repeat case is the common one: the game re-sets the
       same cursor many times between actual changes. */
    if (h == LastScaled)
    {
        LeaveCriticalSection(&CursorLock);
        return SetCursor_Trampoline(h);
    }
    if (h == LastSrc && LastScaled != NULL)
    {
        HCURSOR use = LastScaled;
        LeaveCriticalSection(&CursorLock);
        return SetCursor_Trampoline(use);
    }

    HCURSOR scaled = MakeScaledCursor(h, CursorScale);
    if (scaled == NULL)
    {
        LeaveCriticalSection(&CursorLock);
        return SetCursor_Trampoline(h);
    }

    if (CursorBuilt < 8)
        CursorLog("scaled", h, CursorScale, CursorBuilt);
    else if (CursorBuilt == 8)
        g_.loger.log(__FUNCTION__, "scaling further cursors without logging each");
    CursorBuilt++;

    /* Push the copy being replaced onto the ring and free whatever falls off
       the far end. A copy only enters the ring once it is no longer the one
       being set, and it survives CURSOR_RETIRE_DEPTH further changes after
       that, so it cannot be what is on screen when it is freed. */
    HCURSOR kill    = Retire[RetirePos];
    Retire[RetirePos] = LastScaled;
    RetirePos       = (RetirePos + 1) % CURSOR_RETIRE_DEPTH;
    LastScaled      = scaled;
    LastSrc         = h;

    HCURSOR prev = SetCursor_Trampoline(scaled);

    if (kill != NULL) DestroyCursor(kill);

    LeaveCriticalSection(&CursorLock);
    return prev;
}

/* Called from D3D12_HOOKS::Setup whenever the upscale factor is established,
   so the cursor tracks the frame across resolution changes. Installs the hook
   on first use. */
extern "C" __declspec(dllexport)
void SetCursorScale(float scale)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    int mul = (int)(scale + 0.5f);
    if (mul < 1) mul = 1;

    if (!CursorHooksReady)
    {
        InitializeCriticalSection(&CursorLock);
        CursorHooksReady = TRUE;
        SetCursor_Trampoline = SetCursor;
        HOOK((void**)&SetCursor_Trampoline, SetCursor_Hook);
    }

    EnterCriticalSection(&CursorLock);
    if (mul != CursorScale)
    {
        char buf[96];
        snprintf(buf, sizeof(buf), "cursor scale %d -> %d", CursorScale, mul);
        g_.loger.log(__FUNCTION__, buf);
        CursorScale = mul;
        /* Copies already handed out stay valid; the next change rebuilds at
           the new factor and retires them on the normal schedule. */
        LastSrc = NULL;
    }
    LeaveCriticalSection(&CursorLock);
}
