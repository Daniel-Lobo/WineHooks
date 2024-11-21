#include <windows.h>
#include "sethooks.h"
#include "GDI_Hooks.h"
#include "dllmain.h"

HFONT (WINAPI * CreateFontA_Trampoline)(int, int, int, int, int,
DWORD, DWORD, DWORD, DWORD, DWORD, DWORD, DWORD, DWORD, LPCSTR) = CreateFontA;

HFONT WINAPI CreateFontA_Hook(
        int    cHeight,
        int    cWidth,
        int    cEscapement,
        int    cOrientation,
        int    cWeight,
        DWORD  bItalic,
        DWORD  bUnderline,
        DWORD  bStrikeOut,
        DWORD  iCharSet,
        DWORD  iOutPrecision,
        DWORD  iClipPrecision,
        DWORD  iQuality,
        DWORD  iPitchAndFamily,
        LPCSTR pszFaceName)
{
    return CreateFontA_Trampoline(cHeight, cWidth, cEscapement, cOrientation,
                                  cWeight, bItalic, bUnderline, bStrikeOut,
                                  iCharSet, iOutPrecision, iClipPrecision, 3,
                                  iPitchAndFamily, pszFaceName);
}

extern "C" __declspec(dllexport)
void DisableFontAA()
{    
    sethook((void**)&CreateFontA_Trampoline, CreateFontA_Hook);
}

extern "C" __declspec(dllexport)
void GDISetHz(DWORD hz)
{
   DEVMODEA d;
   if (EnumDisplaySettingsA(NULL, ENUM_CURRENT_SETTINGS, &d))
   {
       d.dmDisplayFrequency = hz;
       ChangeDisplaySettingsA(&d, 0);
   }
}

GDIText::GDIText(const RECT * r, LPVOID p_data, const char * text, const char * caller)
{
    Init(r, p_data, nullptr, text, caller);
}

GDIText::GDIText(const RECT * r, LPVOID p_data, const wchar_t * text, const char * caller)
{
    Init(r, p_data, text, nullptr, caller);
}

void GDIText::Init(const RECT * r, LPVOID p_data, const wchar_t * tw,
                   const char * ta, const char * caller)
{
    if (caller == nullptr)        {g_.loger.dolog(__FUNCTION__, "null caller"); return;}
    if (r      == nullptr)        {g_.loger.dolog(caller, "null RECT");         return;}
    if (tw == NULL && ta == NULL) {g_.loger.dolog(caller, "null text");         return;}

    memcpy(&m_rect, r, sizeof(RECT));
    RECT R      = {};
    UINT Width  = r->right  - r->left;
    UINT Height = r->bottom - r->top;
    R.left   = 0;
    R.top    = 0;
    R.right  = Width;
    R.bottom = Height;

    HDC hDC       = CreateCompatibleDC(NULL);
    HBITMAP hBmp  = CreateCompatibleBitmap(hDC, Width, Height);
    SelectObject(hDC, hBmp       );
    SetBkMode   (hDC, TRANSPARENT);
    SetTextColor(hDC, 0x00ffffff );

    DPtoLP(hDC, (LPPOINT)&m_rect, 2);
    POINT p  = {0, tw==NULL?DrawTextA(hDC, ta, -1, &R, DT_NOCLIP):DrawTextW(hDC, tw, -1, &R, DT_NOCLIP)};
    LPtoDP(hDC, (LPPOINT)&p, 1);
    m_height = p.y;

    BITMAPINFO BMInfo = {sizeof(BMInfo.bmiHeader)};
    GetDIBits(hDC, hBmp, 0, 0, NULL, &BMInfo, DIB_RGB_COLORS);
    BMInfo.bmiHeader.biSize        = sizeof(BMInfo.bmiHeader);
    BMInfo.bmiHeader.biBitCount    = 32;
    BMInfo.bmiHeader.biCompression = BI_RGB;
    GetDIBits(hDC, hBmp, 0, BMInfo.bmiHeader.biHeight, p_data, &BMInfo, DIB_RGB_COLORS);
    DeleteObject(hDC);
    DeleteObject(hBmp);
}
