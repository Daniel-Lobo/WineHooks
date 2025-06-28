#include <intrin.h>
#include <windows.h>
#include "sethooks.h"
#include <string>
#include <sstream>
#include "Dbug.h"
#include "sethooks.h"
#include "Sync.h"
#include "D3D12Hooks.h"
#include "MouseHooks.h"
#include <vector>
#include <math.h>
#define A_CPU

#include "ffx_fsr1.h"
#include <d3d12.h>
#include <dxgi1_2.h>
#include <cstdio>
#include <_mingw.h>

D3D12_HOOKS g_d3d;
void D3D12_HOOKS::Setup(DWORD w, DWORD h, char * Caller)
{
    m_WW->Set(w);
    m_HH->Set(h);
    mScl->Set((float)HD_H/(float)h);
    HD_X->Set((float)(HD_W - m_WW->Get()*mScl->Get())/2.f);
    m_ShaderConsts.Bltconsts.x = mScl->Get(); 
    m_ShaderConsts.Bltconsts.y = m_ShaderConsts.Bltconsts.x * (float)g_d3d.SSAA;
    FsrEasuCon(reinterpret_cast<AU1*>(&m_ShaderConsts.FSRConsts[0]), reinterpret_cast<AU1*>(&m_ShaderConsts.FSRConsts[1]),
               reinterpret_cast<AU1*>(&m_ShaderConsts.FSRConsts[2]), reinterpret_cast<AU1*>(&m_ShaderConsts.FSRConsts[3]),
               w, h, w, h, w*mScl->Get(), HD_H);
    FsrRcasCon(reinterpret_cast<AU1*>(&m_ShaderConsts.RCASConsts[0]), 0.0);
    D3D12LOG((std::string(Caller) + " Requested mode    : " + std::to_string(w) + "x" +  std::to_string(h)).c_str());
    D3D12LOG((std::string(Caller) + " Scale             : " + std::to_string(mScl->Get())).c_str());
    D3D12LOG((std::string(Caller) + " Viewport XOffset  : " + std::to_string(HD_X->Get())).c_str());    
    if (g_d3d.MOUSEHOOKS)
       SetMouseHooksParams(HD_W/m_WW->Get(), mScl->Get(), HD_X->Get(), m_WW->Get(), m_WW->Get());
    if (g_d3d.MOUSECLIP) D3D12ClipCursorHook(nullptr);
}

void D3D12_HOOKS::CompileDXBC(const char* srcfile, D3D_SHADER_MACRO * defs, const char* entrypoint, const char* target, ID3DBlob ** bytecode)
{
    /*
    if (m_D3DCompile == nullptr) {DBUG_LOG("nullptr"); return;}    
    std::stringstream StrStream;
    std::string src(g_.Path());
    src.append("/Shaders/");
    src.append(srcfile);
    DBUG_LOG(src.c_str());
    std::ifstream in_file(src.c_str(), std::ios::in);    
    string line;
    while (getline(in_file, line))
    {
        StrStream << line << "\n";
    };
    in_file.close();

    ID3DBlob * err = nullptr;
    if (m_D3DCompile(StrStream.str().c_str(), StrStream.str().capacity(), src.c_str(), defs,
                     D3D_COMPILE_STANDARD_FILE_INCLUDE, entrypoint, target, 0, 0, bytecode, &err))
    {
        DBUG_LOG((src + " Compilation FAILED\n" + (char*)err->GetBufferPointer()).c_str());
        err->Release();
    }
    else DBUG_LOG((src + "\\" + entrypoint + " OK").c_str());
    */
   
    if (m_D3DCompile == nullptr) {DBUG_LOG("nullptr"); return;}   
    std::string src(g_.Path());
    src.append("/Shaders/");
    src.append(srcfile);
    FILE* fp = std::fopen(src.c_str(), "r");  
    if (fp == nullptr)
    {
        DBUG_WARN((std::string("Could not open: ") + srcfile).c_str());
        return;
    }
    std::wstring source;
    wint_t  w;
    while ((w = std::fgetwc(fp)) != WEOF)
        source.append(1, static_cast<wchar_t>(w));
    std::fclose(fp);

    auto ascii = ASCii((wchar_t*)source.c_str());
    ID3DBlob * err = nullptr;
    if (m_D3DCompile(ascii.str(), ascii.ASCii_string.capacity(), src.c_str(), defs,
                    D3D_COMPILE_STANDARD_FILE_INCLUDE, entrypoint, target, 0, 0, bytecode, &err))
    {
        DBUG_LOG((src + " Compilation FAILED\n" + (char*)err->GetBufferPointer()).c_str());
        err->Release();
    }
    else DBUG_LOG((src + "\\" + entrypoint + " OK").c_str());
}

void D3D12_HOOKS::SetReslimit(DWORD w, DWORD h)
{
    if (m_EnumDisplaySettingsA == nullptr)  return D3D12LOG("NOT INITIALIZED");

    D3D12LOG("ENUMERATING");
    DEVMODEA d               =              {0};
    d.dmSize                 = sizeof(DEVMODEA);
    mHighestDisplayModeIndex = 0;
    while (m_EnumDisplaySettingsA(nullptr, mHighestDisplayModeIndex, &d))
    {
        if (d.dmPelsWidth <= 640 && w <= 640)
        {            
            d.dmPelsWidth  = w;
            d.dmPelsHeight = h;            
        }
        
        if (d.dmPelsWidth == 720)
        {
            if (d.dmPelsHeight == 480)
            {
                d.dmPelsHeight = 540;
                d.dmPelsWidth  = 960;
            } else if (d.dmPelsHeight == 576)
            {
                d.dmPelsHeight = 540;
                d.dmPelsWidth  = 960;
            }
        }
        if ((d.dmPelsWidth == w) && (d.dmPelsHeight == h))
        {
            mHighestDisplayModeIndex += 1;
            while (m_EnumDisplaySettingsA(nullptr, mHighestDisplayModeIndex, &d))
            {
                if (d.dmPelsWidth <= 640 && w <= 640)
                {            
                    d.dmPelsWidth  = w;
                    d.dmPelsHeight = h;            
                }
                if ((d.dmPelsWidth != w) || (d.dmPelsHeight != h))
                {
                    mHighestDisplayModeIndex -= 1;
                    m_EnumDisplaySettingsA(nullptr, mHighestDisplayModeIndex, &d);
                    MaxW = w;
                    MaxH = h;
                    m_WW->Set(MaxW);
                    m_HH->Set(MaxH);
                    return D3D12LOG( (std::string("MODE ") + std::to_string(mHighestDisplayModeIndex) + ": " + std::to_string(MaxW) + "x" + std::to_string(MaxH)).c_str());
                }
                mHighestDisplayModeIndex += 1;
            }
        }
        mHighestDisplayModeIndex += 1;
    }
}

extern "C" __declspec(dllexport) void __stdcall D3D12Config(char * option, void* value)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    std::string Option(option);
    if      (Option == "USEINTEROP")               g_d3d.USEINTEROP                 = (DWORD)value;
    if      (Option == "UPSCALE")                  g_d3d.UPSCALE                    = (DWORD)value;
    else if (Option == "AMDFSR")                   g_d3d.AMDFSR                     = (DWORD)value;
    else if (Option == "USEPROXIES")               g_d3d.USEPROXIES                 = (DWORD)value;
    else if (Option == "HDPROXIES")                g_d3d.HDPROXIES                  = (DWORD)value;
    else if (Option == "SSAA")                     g_d3d.SSAA                       = 2;
    else if (Option == "SSAAHQ")                   g_d3d.SSAA                       = 3;
    else if (Option == "TXAAFIX")                  g_d3d.TXAAFIX                    = (DWORD)value;
    else if (Option == "FIXWINSIZE")               g_d3d.FIXWINSIZE                 = (DWORD)value;
    else if (Option == "MOUSEHOOKS")               g_d3d.MOUSEHOOKS                 = (DWORD)value;
    else if (Option == "MOUSECLIP")                g_d3d.MOUSECLIP                  = *(DWORD*)value;
    else if (Option == "RESLMT")                   g_d3d.RESOLUTIONLIMIT            = (DWORD)value;
    else if (Option == "GAMMA")                    g_d3d.GAMMAFIX                   = (DWORD)value;
    else if (Option == "VSNC")                     g_d3d.VSYNC                      = (DWORD)value;
    else if (Option == "DBUG")                     g_d3d.DBUG                       = (DWORD)value;
    else if (Option == "DXVK")                     g_d3d.DXVK                       = (DWORD)value;
    else if (Option == "HWND")                     g_d3d.D3DWINDOW                  = (HWND)value;
    else if (Option == "DOUBLEBUFF")               g_d3d.FORCE_DOUBLE_BUFFERING     = (DWORD)value;
    else if (Option == "DELAYRELEASE")             g_d3d.DELAY_TEXTURE_RELEASES     = (DWORD)value;
    else if (Option == "TEXTSWAP")                 g_d3d.TEXTURE_SWAP_ENABLED       = (DWORD)value;
    else if (Option == "TEXT-SWAP.TOGGLE-SEARCH")  g_d3d.TEXTURE_SWAP_TOGGLE_SEARCH = (DWORD)value; 
    else if (Option == "TEXT-SWAP.NEXT")           g_d3d.TEXTURE_SWAP_NEXT          = (DWORD)value;
    else if (Option == "TEXT-SWAP.PREV")           g_d3d.TEXTURE_SWAP_PREV          = (DWORD)value;
    else if (Option == "TEXT-SWAP.QUICK")          g_d3d.TEXTURE_SWAP_QUICK         = (DWORD)value;
    else if (Option == "TEXT-SWAP.DUMP")           g_d3d.TEXTURE_SWAP_DUMP          = (DWORD)value;
    else if (Option == "TEXT-SWAP.MANAGE")         g_d3d.TEXTURE_SWAP_MANAGE        = (DWORD)value;  
    else if (Option == "TEXT-SWAP.A8FIX")          g_d3d.TEXTURE_SWAP_A8FIX         = (DWORD)value;
    else if (Option == "TEXT-SWAP.AUTO")           g_d3d.TEXTURE_SWAP_AUTODUMP      = (DWORD)value; 
    else if (Option == "TEXTURE.FILTER")           g_d3d.TEXTURE_FILTER             = (DWORD)value == 2 ? *(DWORD*)"WINE" : *(DWORD*)"TRUE";  
    else if (Option == "D3D.VERSION")              g_d3d.D3DVERSION                 = (DWORD)value;
}

extern "C" __declspec(dllexport) void __stdcall D3D12Config64(char * option, LPVOID value)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    std::string Option(option);
    if (Option == "HWND")       g_d3d.D3DWINDOW         = (HWND) value;
}

BOOL WINAPI D3D12ClipCursorHook(const RECT *lpRect)
{
    RECT r;
    if      (g_d3d.MOUSECLIP == *(DWORD*)"CLIP")
        r = {g_d3d.HD_X->Get(), 0, (LONG)(g_d3d.HD_H-g_d3d.HD_X->Get()), (LONG)g_d3d.HD_H};
    else if (g_d3d.MOUSECLIP == *(DWORD*)"FREE")
        r = {0, 0, g_d3d.m_WW->Get(), g_d3d.m_HH->Get()};
    return g_d3d.m_ClipCursor(&r);
}

int __stdcall D3D12GetSystemMetricsHook(int nIndex)
{
    LPVOID ret        = __builtin_return_address(0);
    BOOL IsGameModule = COMMONIsGameModule(ret, g_.modules);
    if (IsGameModule)
    {
        if      (nIndex == SM_CXVIRTUALSCREEN || nIndex == SM_CXSCREEN  /*|| nIndex == SM_CXFULLSCREEN*/) return g_d3d.m_WW->Get();
        else if (nIndex == SM_CYVIRTUALSCREEN || nIndex == SM_CYSCREEN  /*|| nIndex == SM_CYFULLSCREEN*/) return g_d3d.m_HH->Get();
    }
    return g_d3d.m_GetSystemMetrics(nIndex);
}

int __stdcall D3D12GetDeviceCapsHook(HDC hdc, int index)
{
    LPVOID ret        = __builtin_return_address(0);
    BOOL IsGameModule = COMMONIsGameModule(ret, g_.modules);
    int r             = g_d3d.m_GetDeviceCaps(hdc, index);
    if (r && IsGameModule)
    {
        if      (index == 8)  return g_d3d.m_WW->Get();
        else if (index == 10) return g_d3d.m_HH->Get();
    }
    return r;
}

BOOL __stdcall D3D12SystemParametersInfoWHook(UINT uiAction, UINT uiParam, PVOID pvParam, UINT fWinIni)
{
    LPVOID ret        = __builtin_return_address(0);
    BOOL IsGameModule = COMMONIsGameModule(ret, g_.modules);
    BOOL r            = g_d3d.m_SystemParametersInfoW(uiAction, uiParam, pvParam, fWinIni);
    if (r && IsGameModule && uiAction == SPI_GETWORKAREA)
    {
        RECT* R = (RECT *)pvParam;
        R->left   = 0;
        R->top    = 0;
        R->right  = g_d3d.m_WW->Get();
        R->bottom = g_d3d.m_HH->Get();
    } return r;
}

BOOL __stdcall D3D12GetMonitorInfoWHook(HMONITOR hMonitor, LPMONITORINFO lpmi)
{
    LPVOID ret        = __builtin_return_address(0);
    BOOL IsGameModule = COMMONIsGameModule(ret, g_.modules);
    BOOL r            = g_d3d.m_GetMonitorInfoW(hMonitor, lpmi);
    if (r == 0) return 0;
    if (IsGameModule && lpmi)
    {
        lpmi->rcMonitor.bottom =  g_d3d.m_HH->Get();
        lpmi->rcMonitor.right  =  g_d3d.m_WW->Get();
        lpmi->rcWork.bottom    =  g_d3d.m_HH->Get();
        lpmi->rcWork.right     =  g_d3d.m_WW->Get();
    }
    return r;
}

BOOL __stdcall D3D12GetMonitorInfoAHook(HMONITOR hMonitor, LPMONITORINFO lpmi)
{
    LPVOID ret        = __builtin_return_address(0);
    BOOL IsGameModule = COMMONIsGameModule(ret, g_.modules);
    BOOL r            = g_d3d.m_GetMonitorInfoA(hMonitor, lpmi);
    if (r == 0) return 0;
    if (IsGameModule && lpmi)
    {
        lpmi->rcMonitor.bottom =  g_d3d.m_HH->Get();
        lpmi->rcMonitor.right  =  g_d3d.m_WW->Get();
        lpmi->rcWork.bottom    =  g_d3d.m_HH->Get();
        lpmi->rcWork.right     =  g_d3d.m_WW->Get();
    }
    return r;
}

BOOL __stdcall D3D12EnumDisplaySettingsAHook(LPCSTR DeviceName, DWORD iModeNum, DEVMODEA *DevMode)
{
    if (COMMONIsGameModule(__builtin_return_address(0), g_.modules) == 0)
    return g_d3d.m_EnumDisplaySettingsA(DeviceName, iModeNum, DevMode);

    if ((int)iModeNum > g_d3d.mHighestDisplayModeIndex)
    return 0;

    if ( !g_d3d.m_EnumDisplaySettingsA(DeviceName, iModeNum, DevMode) ) return 0;
    if ( (iModeNum == ENUM_CURRENT_SETTINGS) || (iModeNum == ENUM_REGISTRY_SETTINGS) )
    {
        DevMode->dmPelsWidth  = g_d3d.m_WW->Get();
        DevMode->dmPelsHeight = g_d3d.m_HH->Get();
    } else if (DevMode->dmPelsWidth == 720)
    {
        if (DevMode->dmPelsHeight == 480)
        {
            DevMode->dmPelsHeight = 540;
            DevMode->dmPelsWidth  = 960;
        } else if (DevMode->dmPelsHeight == 576)
        {
            DevMode->dmPelsHeight = 540;
            DevMode->dmPelsWidth  = 960;
        }
    }
    return 1;
}

BOOL __stdcall D3D12EnumDisplaySettingsWHook(const wchar_t* DeviceName, DWORD iModeNum, DEVMODEW *DevMode)
{
    if (COMMONIsGameModule(__builtin_return_address(0), g_.modules) == 0)
    return g_d3d.m_EnumDisplaySettingsW(DeviceName, iModeNum, DevMode);

    if ((int)iModeNum > g_d3d.mHighestDisplayModeIndex)
    return 0;

    if ( !g_d3d.m_EnumDisplaySettingsW(DeviceName, iModeNum, DevMode) ) return 0;
    if ( (iModeNum == ENUM_CURRENT_SETTINGS) || (iModeNum == ENUM_REGISTRY_SETTINGS) )
    {
        DevMode->dmPelsWidth  = g_d3d.m_WW->Get();
        DevMode->dmPelsHeight = g_d3d.m_HH->Get();
    } else if (DevMode->dmPelsWidth == 720)
    {
        if (DevMode->dmPelsHeight == 480)
        {
            DevMode->dmPelsHeight = 540;
            DevMode->dmPelsWidth  = 960;
        } else if (DevMode->dmPelsHeight == 576)
        {
            DevMode->dmPelsHeight = 540;
            DevMode->dmPelsWidth  = 960;
        }
    }
    return 1;
}

BOOL __stdcall D3D12EnumDisplaySettingsExWHook(const wchar_t* lpszDeviceName,DWORD iModeNum, DEVMODEW *lpDevMode,
                                               DWORD dwFlags)
{
    if (CommonIsGameModule(__builtin_return_address(0), g_.modules) == 0)
    return g_d3d.m_EnumDisplaySettingsExW(lpszDeviceName, iModeNum, lpDevMode, dwFlags);

    if ((int)iModeNum > g_d3d.mHighestDisplayModeIndex)
    return 0;

    if ( !g_d3d.m_EnumDisplaySettingsExW(lpszDeviceName, iModeNum, lpDevMode, dwFlags) ) return 0;
    if ( (iModeNum == ENUM_CURRENT_SETTINGS) || (iModeNum == ENUM_REGISTRY_SETTINGS) )
    {
        lpDevMode->dmPelsWidth  = g_d3d.m_WW->Get();
        lpDevMode->dmPelsHeight = g_d3d.m_HH->Get();
    } else if (lpDevMode->dmPelsWidth == 720)
    {
        if (lpDevMode->dmPelsHeight == 480)
        {
            lpDevMode->dmPelsHeight = 540;
            lpDevMode->dmPelsWidth  = 960;
        } else if (lpDevMode->dmPelsHeight == 576)
        {
            lpDevMode->dmPelsHeight = 540;
            lpDevMode->dmPelsWidth  = 960;
        }
    }
    return 1;
}

LONG __stdcall D3D12ChangeDisplaySettingsExWHook(LPCWSTR dvc, DEVMODEW * mode, HWND hwnd,
                                                 DWORD flags, LPVOID lParam)
{
    if (CommonIsGameModule(__builtin_return_address(0), g_.modules) == 0)
    return g_d3d.m_ChangeDisplaySettingsExW(dvc, mode, hwnd, flags, lParam);

    if (mode == nullptr) g_d3d.Setup(g_d3d.MaxW, g_d3d.MaxH, (char*)__FUNCTION__);
    else                 g_d3d.Setup(mode->dmPelsWidth, mode->dmPelsHeight, (char*)__FUNCTION__);
    return DISP_CHANGE_SUCCESSFUL;
}

LONG __stdcall D3D12ChangeDisplaySettingsWHook(DEVMODEW *mode,DWORD flags)
{
    if (CommonIsGameModule(__builtin_return_address(0), g_.modules) == 0)
    return g_d3d.m_ChangeDisplaySettingsW(mode, flags);

    if (mode == nullptr) g_d3d.Setup(g_d3d.MaxW, g_d3d.MaxH, (char*)__FUNCTION__);
    else                 g_d3d.Setup(mode->dmPelsWidth, mode->dmPelsHeight, (char*)__FUNCTION__);
    return DISP_CHANGE_SUCCESSFUL;
}

void D3D12FixRect(HWND hwin, RECT * r)
{
    if ((g_d3d.D3DWINDOW == hwin) ||
        (r->left == 0 && r->top == 0 && r->right == g_d3d.HD_W && r->bottom == g_d3d.HD_H))
    {
        r->left   = 0;
        r->top    = 0;
        r->right  = g_d3d.m_WW->Get();
        r->bottom = g_d3d.m_HH->Get();
    }
}

extern "C" __declspec(dllexport) BOOL D3D12IsWindowFullscreen(HWND hWnd)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    RECT r;
    g_d3d.m_GetClientRect(hWnd, &r);
    if (r.left == 0 && r.top == 0 && r.right == g_d3d.HD_W && r.bottom == g_d3d.HD_H)
    return 1;
    return 0;
}

extern "C" __declspec(dllexport) BOOL __stdcall
D3D12GetClientRectHook(HWND hWnd, RECT * rct)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__) /* So AHK can hook it*/
    if (CommonIsGameModule(__builtin_return_address(0), g_.modules) == 0)
    return g_d3d.m_GetClientRect(hWnd, rct);

    BOOL r = g_d3d.m_GetClientRect(hWnd, rct);
    if (r) D3D12FixRect(hWnd, rct);
    return r;
}

BOOL __stdcall
D3D12GetWindowRectHook(HWND hWnd, RECT * rct)
{
    if (CommonIsGameModule(__builtin_return_address(0), g_.modules) == 0)
    return g_d3d.m_GetWindowRect(hWnd, rct);

    BOOL r = g_d3d.m_GetWindowRect(hWnd, rct);
    if (r) D3D12FixRect(hWnd, rct);
    return r;
}

BOOL __stdcall
D3D12SetWindowPosHook(HWND hWnd, HWND hWndInsertAfter, int  X, int  Y, int cx, int  cy, UINT uFlags)
{
    LogWinSize winsz(hWnd, (char*)__FUNCTION__);
    /* OpenGl games need the g_d3d.D3DWINDOW check: uxtheme.dll resizes the gl window */
    if (CommonIsGameModule(__builtin_return_address(0), g_.modules) == 0 && hWnd != g_d3d.D3DWINDOW)
        return g_d3d.m_SetWindowPos(hWnd, hWndInsertAfter, X, Y, cx, cy, uFlags);
    BOOL s = g_d3d.m_SetWindowPos(hWnd, hWndInsertAfter, X, Y, g_d3d.HD_W, g_d3d.HD_H, uFlags);
    if (s && 0==((uFlags & SWP_NOSIZE) || (uFlags & SWP_NOMOVE))) SendMessageA(hWnd, WM_SIZE, 0, cx|(cy<<16)); /* untested, but fixes dex */
    return s;
}

extern "C" __declspec(dllexport) HRESULT __stdcall D3D12DXGISwapChainGetDescHook(IDXGISwapChain * sc, DXGI_SWAP_CHAIN_DESC *pDesc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = g_d3d.m_IDXGISwapChainGetDesc(sc, pDesc);
    if (hr)                                                    return hr;
    if (CommonIsGameModule(__builtin_return_address(0), g_.modules) == 0) return hr;
    pDesc->BufferDesc.Width  = g_d3d.m_WW->Get();
    pDesc->BufferDesc.Height = g_d3d.m_HH->Get();
    return 0;
}

extern "C" __declspec(dllexport) HRESULT __stdcall D3D12DXGISwapChainGetDesc1Hook(IDXGISwapChain1 * sc, DXGI_SWAP_CHAIN_DESC1 *pDesc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = g_d3d.m_IDXGISwapChainGetDesc1(sc, pDesc);
    if (hr)                                                    return hr;
    if (CommonIsGameModule(__builtin_return_address(0), g_.modules) == 0) return hr;
    pDesc->Width  = g_d3d.m_WW->Get();
    pDesc->Height = g_d3d.m_HH->Get();
    return 0;
}

DWORD __stdcall D3D12GetModes(IDXGIOutput1 * out, DXGI_FORMAT fmt, UINT f,
                              UINT * count, UINT * full_count,
                              std::vector<DXGI_MODE_DESC>*pmodes)
{
    UINT i, ii, w, h;

    if (g_d3d.m_IDXGIOutputGetDisplayModeList(out, fmt, f, full_count, nullptr)       != 0) return 1;
    pmodes->resize(*full_count);
    if (g_d3d.m_IDXGIOutputGetDisplayModeList(out, fmt, f, full_count, &(*pmodes)[0]) != 0) return 2;
    *count = *full_count;
    for (i=0; i<*full_count; i++)
    {
        w = (*pmodes)[i].Width;
        h = (*pmodes)[i].Height;

        if (w == 640 && g_d3d.MaxH == 360)  {
            h = 360;
        } else if (w == 720) {
            if (h == 480) {
                h = 540;
                w = 960;
            } else if (h == 576){
                h = 540;
                w = 960;
            }
        }
        D3D12LOG( (std::string("MODE ")+std::to_string(i)+ ": "+
                   std::to_string(w)+"x"+std::to_string(h)).c_str());
        if ((w == g_d3d.MaxW) && (h  == g_d3d.MaxH))
        {
            for (ii=i+1; ii<*full_count; ii++)
            {
                w = (*pmodes)[ii].Width;
                h = (*pmodes)[ii].Height;
                if (w == 640 && g_d3d.MaxH == 360) {
                    h = 360;
                }
                else if (w == 720) {
                    if (h == 480) {
                        h = 540;
                        w = 960;
                    }
                    else if (h == 576) {
                        h = 540;
                        w = 960;
                    }
                }
                if ((w != g_d3d.MaxW) || (h  != g_d3d.MaxH))
                {
                    D3D12LOG( (std::string("FOUND MODE ")+std::to_string(ii)+ ": "+
                               std::to_string(w)+"x"+std::to_string(h)).c_str());
                    *count = ii;
                    return 0;
                }
            }
        }
    }
    return 0;
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D12GetDisplayModeListHook(IDXGIOutput1 * out, DXGI_FORMAT fmt, UINT flags, UINT *pCount, DXGI_MODE_DESC *pDesc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D12LOG("=====");
    OUTPUT_FUNC_DBG_STRING("====");
    if (COMMONIsGameModule(__builtin_return_address(0), g_.modules) == 0)
    {
        OUTPUT_FUNC_DBG_STRING("=(=(=(=(=(=(=(=(=(=(=(=(");
        return g_d3d.m_IDXGIOutputGetDisplayModeList(out, fmt, flags, pCount, pDesc);
    }
    
    UINT count      = 0;
    UINT full_count = 0;
    std::vector<DXGI_MODE_DESC>Modes;
    if (pDesc == nullptr)
    {
        if (D3D12GetModes(out, fmt, flags, &count, &full_count, &Modes))
        {
            D3D12LOG("FAILED TO GET THE MODES COUNT");
            return g_d3d.m_IDXGIOutputGetDisplayModeList(out, fmt, flags, pCount, pDesc);
        }
        D3D12LOG( (std::string("RETURNING COUNT=")+std::to_string(count)).c_str() );
        *pCount = count;
    } else
    {
        if (D3D12GetModes(out, fmt, flags, &count, &full_count, &Modes))
        {
            D3D12LOG("FAILED TO ENUMERATE MODES");
            return g_d3d.m_IDXGIOutputGetDisplayModeList(out, fmt, flags, pCount, pDesc);
        }
        if (pCount == nullptr)
        {
            D3D12LOG("nullptr");
            return 0x887A0001; //DXGI_ERROR_INVALID_CALL;
        }
        if (*pCount != count)
        {
            D3D12LOG("WRONG COUNT");
            //return 0x887A0001; //DXGI_ERROR_INVALID_CALL;
        }
        D3D12LOG( (std::string("RETURNING ")+std::to_string(count)+" Modes").c_str() );
        memcpy(pDesc, &Modes[0], sizeof(DXGI_MODE_DESC)*count);
        DXGI_MODE_DESC* curr_mode = pDesc;
        for (int i = 0; i < count; i++)
        {
            if (curr_mode->Width == 640 && g_d3d.MaxH == 360)
            {
                curr_mode->Height = g_d3d.MaxH;
            }
            if (curr_mode->Width == 720)
            {
                if (curr_mode->Height == 480)
                {
                    curr_mode->Height = 540;
                    curr_mode->Width = 960;
                }
                else if (curr_mode->Height == 576)
                {
                    curr_mode->Height = 540;
                    curr_mode->Width = 960;
                }
            }
            curr_mode++;
        }
    }
    return 0;
}

HRESULT __stdcall
D3D12FindClosestMatchingModeHook(IDXGIOutput * out, const DXGI_MODE_DESC * mode, DXGI_MODE_DESC * found, IUnknown * pDvc)
{
    if (mode == nullptr) return DXGI_ERROR_INVALID_CALL;
    DBUG_WARN((std::to_string(mode->Width)+" x "+std::to_string(mode->Height)).c_str());
    DXGI_MODE_DESC newmode;
    memcpy(&newmode, mode, sizeof(DXGI_MODE_DESC));
    if (newmode.Width == 0)  newmode.Width  = g_d3d.m_WW->Get();
    if (newmode.Height == 0) newmode.Height = g_d3d.m_HH->Get();
    return g_d3d.m_FindClosestMatchingMode(out, &newmode, found, pDvc);
}

void D3D12_HOOKS::ApplyCommonHooks(DWORD flags)
{
    if (flags & 0xf)
    {
        HOOK(&m_ChangeDisplaySettingsExW, (void*)D3D12ChangeDisplaySettingsExWHook);
        HOOK(&m_ChangeDisplaySettingsW, (void*)D3D12ChangeDisplaySettingsWHook);
    }
    HOOK(&m_GetSystemMetrics, (void*)D3D12GetSystemMetricsHook);
    HOOK(&m_SystemParametersInfoW, (void*)D3D12SystemParametersInfoWHook);
    /*HOOK(&m_EnumDisplaySettingsExA, D3D12EnumDisplaySettingsExAHook);*/
    HOOK(&m_EnumDisplaySettingsExW, (void*)D3D12EnumDisplaySettingsExWHook);
    HOOK(&m_EnumDisplaySettingsA, (void*)D3D12EnumDisplaySettingsAHook); /* breaks lok defiance widescreen*/
    HOOK(&m_EnumDisplaySettingsW, (void*)D3D12EnumDisplaySettingsWHook);
    HOOK(&m_GetMonitorInfoW, (void*)D3D12GetMonitorInfoWHook);
    HOOK(&m_GetMonitorInfoA, (void*)D3D12GetMonitorInfoAHook);
    HOOK(&m_GetDeviceCaps, (void*)D3D12GetDeviceCapsHook);
    HOOK(&m_GetClientRect, (void*)D3D12GetClientRectHook);
    HOOK(&m_GetWindowRect, (void*)D3D12GetWindowRectHook);
    if (g_d3d.FIXWINSIZE)
    {
        HOOK(&g_d3d.m_SetWindowPos, (void*)D3D12SetWindowPosHook);
    }
    if (g_d3d.MOUSECLIP)
    {
        HOOK(&g_d3d.m_ClipCursor, (void*)D3D12ClipCursorHook);
    }
}

extern "C" __declspec(dllexport) IDXGIOutput * __stdcall D3D12GetSwapChainOutput(IDXGISwapChain * sc)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDXGIAdapter * adapter = nullptr;
    IDXGIOutput  * out     = nullptr;
    IDXGIDevice  * DXGIDvc = nullptr;
    if (sc->GetContainingOutput(&out) == 0) return out;
    if (sc->GetDevice(__uuidof(IDXGIDevice), (void**)&DXGIDvc))
    {
        D3D12LOG("GetDevice Failed");
        return 0;
    }
    if (DXGIDvc->GetAdapter(&adapter))
    {
        D3D12LOG("GetAdapter Failed");
        DXGIDvc->Release();
        return 0;
    }
    if (adapter->EnumOutputs(0, &out) > 0)
    {
        D3D12LOG("EnumOutputs Failed");
    }
    DXGIDvc->Release();
    adapter->Release();
    return out;
}

void D3D12_HOOKS::ApplyCommonDXGIHooks(IDXGISwapChain* sc,  DWORD hook)
{
    LOGHOOK(IDXGISwapChain, GetDesc, sc, &m_IDXGISwapChainGetDesc, D3D12DXGISwapChainGetDescHook)
    IDXGISwapChain1 * sc1 = nullptr;
    if (sc->QueryInterface(__uuidof(IDXGISwapChain1), (void**)&sc1) == 0)
    {
        LOGHOOK(IDXGISwapChain1, GetDesc1, sc1, &m_IDXGISwapChainGetDesc1, D3D12DXGISwapChainGetDesc1Hook)
        sc1->Release();
    } else D3D12LOG("QueryInterface(__uuidof(IDXGISwapChain1)... FAILED");
    IDXGIOutput * out = D3D12GetSwapChainOutput(sc) ;
    {
        if (out == nullptr) D3D12LOG("D3D12GetSwapChainOutput FAILED");
        else
        {
            LOGHOOK(IDXGIOutput, GetDisplayModeList, out, &m_IDXGIOutputGetDisplayModeList, D3D12GetDisplayModeListHook)
            LOGHOOK(IDXGIOutput, FindClosestMatchingMode, out, &m_FindClosestMatchingMode, D3D12FindClosestMatchingModeHook)
            out->Release();
        }
    }
}

#ifdef _WIN64
BOOL D3D12IsSwapChainWaitable(IDXGISwapChain* SChain)
{
    IDXGISwapChain1 * Schain1;
    if (SChain->QueryInterface(__uuidof(IDXGISwapChain1), (void**)&Schain1))
    {
        D3D12LOG("IDXGISwapChain::QueryInterface(__uuidof(IDXGISwapChain1) FAILED");
        return 0;
    }
    DXGI_SWAP_CHAIN_DESC1 Desc = {};
    Schain1->GetDesc1(&Desc);
    Schain1->Release();
    return Desc.Flags & DXGI_SWAP_CHAIN_FLAG_FRAME_LATENCY_WAITABLE_OBJECT;
}

UINT D3D12GetBufferCount(IDXGISwapChain* SChain)
{
    if (D3D12IsSwapChainWaitable(SChain) == 0)
    {
        DXGI_SWAP_CHAIN_DESC desc;
        if (g_d3d.m_IDXGISwapChainGetDesc(SChain, &desc))
        {
             D3D12LOG("IDXGISwapChain::GetDesc FAILED");
        } return desc.BufferCount;
    }
    return 1;
}

void * D3D12WaitSwap(IDXGISwapChain* SChain)
{
    if (!D3D12IsSwapChainWaitable(SChain)) return 0;
    IDXGISwapChain3 * Schain3;
    if (SChain->QueryInterface(__uuidof(IDXGISwapChain3), (void**)&Schain3))
    {
        D3D12LOG("IDXGISwapChain::QueryInterface(__uuidof(IDXGISwapChain3) FAILED");
        return 0;
    }

    HANDLE h = g_d3d.GetFrameLatencyWaitableObject(Schain3);
    if (h)
    {
        WaitForSingleObject(h, INFINITE);
        CloseHandle(h);
    }
    Schain3->Release();
    return h;
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D12CreateSwapChainForHwndHook(IDXGIFactory2 * Factory, IUnknown *pDevice, HWND hWnd, DXGI_SWAP_CHAIN_DESC1 *pDesc,
                                const DXGI_SWAP_CHAIN_FULLSCREEN_DESC *pFullscreenDesc,
                                IDXGIOutput *pRestrictToOutput, IDXGISwapChain1 **ppSwapChain)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D12LOG("...");

    g_d3d.lock->lock();
    g_d3d.lock->unlock();

    if (pDesc == nullptr)   return DXGI_ERROR_INVALID_CALL;
    g_d3d.Setup(pDesc->Width, pDesc->Height, (char*)__FUNCTION__);

    DXGI_SWAP_CHAIN_DESC1 newdesc;
    memcpy(&newdesc, pDesc, sizeof(DXGI_SWAP_CHAIN_DESC1));    
    if (g_d3d.UPSCALE)
    {
        newdesc.Width  = g_d3d.HD_W;
        newdesc.Height = g_d3d.HD_H;
    }
    HRESULT hr = g_d3d.CreateSwapChainForHwnd(Factory, pDevice, hWnd, &newdesc, pFullscreenDesc, pRestrictToOutput, ppSwapChain);
    if (hr == 0) g_d3d.D3D11DvcNT.Reset(*ppSwapChain, pDevice);
    return hr;
}

extern "C" __declspec(dllexport) HRESULT __thiscall
D3D12CreateSwapChainHook(IDXGIFactory*Factory,IUnknown*pDevice,DXGI_SWAP_CHAIN_DESC*pDesc,IDXGISwapChain**ppSwapChain)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d.lock->lock();
    g_d3d.lock->unlock();

    if (pDesc == nullptr || pDevice==nullptr || ppSwapChain==nullptr)   return DXGI_ERROR_INVALID_CALL;
    g_d3d.Setup(pDesc->BufferDesc.Width, pDesc->BufferDesc.Height, (char*)__FUNCTION__);

    DXGI_SWAP_CHAIN_DESC newdesc;
    memcpy(&newdesc, pDesc, sizeof(DXGI_SWAP_CHAIN_DESC));
    newdesc.Flags &= ~DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;
    if (g_d3d.UPSCALE)
    {
        newdesc.BufferDesc.Width  = g_d3d.HD_W;
        newdesc.BufferDesc.Height = g_d3d.HD_H;
    }

    HRESULT hr = g_d3d.CreateSwapChain((IDXGIFactory2 *)Factory, pDevice, &newdesc, ppSwapChain);
    if (hr == 0) g_d3d.D3D11DvcNT.Reset(*ppSwapChain, pDevice);
    else D3D12LOG("CreateSwapChain FAILED");    
    return hr;
}

HRESULT __stdcall
D3D12ResizeBuffersHook(IDXGISwapChain* SChain,UINT Count, UINT w, UINT h, DXGI_FORMAT fmt, UINT flags)
{
    if (CommonIsGameModule(__builtin_return_address(0), g_.modules) == 0)
    return g_d3d.ResizeBuffers((IDXGISwapChain2*)SChain, Count, w, h, fmt, flags);
    HRESULT hr;
    if (g_d3d.UPSCALE)
    {
        if (w == 0) w = g_d3d.m_WW->Get();
        if (h == 0) h = g_d3d.m_HH->Get();
    }
    g_d3d.Setup(w, h, (char*)__FUNCTION__);
    if (g_d3d.UPSCALE) hr = g_d3d.ResizeBuffers((IDXGISwapChain2*)SChain, Count, g_d3d.HD_W, g_d3d.HD_H, fmt, flags);
    else               hr = g_d3d.ResizeBuffers((IDXGISwapChain2*)SChain, Count, w, h, fmt, flags);
    if (SUCCEEDED(hr)) g_d3d.D3D11DvcNT.Reset(SChain, nullptr);
    else D3D12LOG("ResizeBuffers FAILED");
    return hr;
}

HANDLE __stdcall D3D12GetFrameLatencyWaitableObjectHook(IDXGISwapChain2*)
{
    return 0;
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D12GetBufferHook(IDXGISwapChain* SChain, UINT index, REFIID riid, void ** ppSurface)
{
    D3D12LOG("---");    
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D12LOG(std::to_string(index).c_str());
    ID3D12Device   * Dvc   = nullptr;
    ID3D12Resource * pBB   = nullptr;
    ID3D12Resource * proxy = nullptr;
    D3D12_RESOURCE_DESC D  = {};                     

    if      (riid == __uuidof(ID3D12Resource))  DBUG_WARN("ID3D12Resource")
    else if (riid == __uuidof(ID3D11Texture2D)) DBUG_WARN("ID3D11Texture2D")
    else if (riid == __uuidof(IDXGISurface))    DBUG_WARN("IDXGISurface")
    else                                        DBUG_WARN("Bad riid");
    if (g_d3d.GetBuffer((IDXGISwapChain2*)SChain, index, __uuidof(ID3D12Resource), (void**)&pBB))
    {
        D3D12LOG("IDXGISwapChain::GetBuffer() FAILED");
        goto D3D12GetBufferHook_Failed;
    }
    if (pBB->GetDevice(__uuidof(ID3D12Device), (void**)&Dvc))
    {
        D3D12LOG("BackBufffer12::GetDevice() FAILED");
        goto D3D12GetBufferHook_Failed;
    }
    D      = pBB->GetDesc();    
    proxy  = g_d3d.D3D11DvcNT.GetBuffer(SChain, index);
    if (proxy == nullptr)
    {
        D3D12LOG("CreateSharedSurface FAILED");
        goto D3D12GetBufferHook_Failed;
    }
    if (proxy->QueryInterface(riid, ppSurface))
    {
        D3D12LOG("QueryInterface FAILED");
        goto D3D12GetBufferHook_Failed;
    }
    if (proxy->SetPrivateDataInterface((GUID &)g_d3d.pSwapChainID, SChain) == 0)
    {
        if (Dvc)   Dvc->Release();
        if (pBB)   pBB->Release();
        if (proxy) proxy->Release();
        return 0;
    };
    DBUG_WARN("All good");
    D3D12GetBufferHook_Failed:
    if (Dvc)   Dvc->Release();
    if (pBB)   pBB->Release();
    if (proxy) proxy->Release();
    return g_d3d.GetBuffer((IDXGISwapChain2*)SChain, index, riid, ppSurface);
}

HRESULT __stdcall D3D12SetMaximumFrameLatencyHook(IDXGISwapChain2* s, UINT l)
{
    D3D12LOG(std::to_string(l).c_str());
    return g_d3d.SetMaximumFrameLatency(s, l);
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D12PresentHook(IDXGISwapChain* SChain, UINT SyncInterval, UINT Flags)
{
    //return g_d3d.Present(SChain, SyncInterval, Flags);
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d.D3D11DvcNT.Present(SChain, SyncInterval, Flags);
    return 0;
}

extern "C" __declspec(dllexport) HRESULT __stdcall
D3D12Present1Hook(IDXGISwapChain1* SChain, UINT Sync, UINT Flags, const DXGI_PRESENT_PARAMETERS *pParams)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D12LOG("...");
    return g_d3d.Present1((IDXGISwapChain2*)SChain, Sync, Flags, pParams);
}

void __stdcall
D3D12CreateSamplerHook(ID3D12Device * dvc, const D3D12_SAMPLER_DESC* D, D3D12_CPU_DESCRIPTOR_HANDLE h)
{
    if (D)
    {
        D3D12_SAMPLER_DESC newdesc;
        memcpy(&newdesc, D, sizeof(D3D12_SAMPLER_DESC));
        newdesc.MipLODBias = log2f(g_d3d.mScl->Get()) * -1;        
        return g_d3d.D3D12CreateSampler(dvc, &newdesc, h);
    }
    return g_d3d.D3D12CreateSampler(dvc, D, h);
}

extern "C" __declspec(dllexport) void __stdcall D3D12Init()
{
    return ;
    /*
    #define D3D12INITFAILED(e) {err.append(e);goto D3D12InitFailed;}
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)

    g_d3d.Init();
    g_d3d.lock->lock();
    std::string                        err;
    IDXGIFactory1  * DXGIFactory1 = nullptr;
    ID3D12Resource * D3D12BBuff   = nullptr;
    DXGI_SWAP_CHAIN_DESC1 SCDesc  = {};

    ID3D12Debug* debugController;
    if (SUCCEEDED(g_d3d.m_D3D12GetDebugInterface(IID_PPV_ARGS(&debugController))))
    {
        //debugController->EnableDebugLayer();
    }    

    if (!(g_d3d.m_D3D12CreateDevice && g_d3d.m_CreateDXGIFactory1))
    D3D12INITFAILED("GetProcAddress(D3D12CreateDevice) FAILED");

    if (g_d3d.D3D11DvcNT.Init())
    D3D12INITFAILED("D3D11HelperDevice.Init() FAILED");

    if (g_d3d.m_D3D12CreateDevice(NULL, D3D_FEATURE_LEVEL_11_0, _uuidof(ID3D12Device), (void**)&g_d3d.D3D12Device))
    D3D12INITFAILED("D3D12CreateDevice FAILED");

    D3D12_COMMAND_QUEUE_DESC qdesc;
    qdesc.Type     = D3D12_COMMAND_LIST_TYPE_DIRECT;
    qdesc.Priority = D3D12_COMMAND_QUEUE_PRIORITY_NORMAL;
    qdesc.Flags    = D3D12_COMMAND_QUEUE_FLAG_NONE;
    qdesc.NodeMask = 0;
    if (g_d3d.D3D12Device->CreateCommandQueue(&qdesc, __uuidof(ID3D12CommandQueue), (void**)&g_d3d.D3D12CommandQueue))
    D3D12INITFAILED("CreateCommandQueue FAILED");

    g_d3d.hHiddenWin = CreateWindow(L"STATIC", L"PEX.D3D12", WS_POPUP | WS_DISABLED, 0, 0,
                                         1, 1, NULL, NULL, GetModuleHandle(NULL), NULL);
    if (g_d3d.hHiddenWin == NULL) D3D12INITFAILED("CREATEWINDOW FAILED");
    ShowWindow(g_d3d.hHiddenWin, SW_HIDE);

    if (g_d3d.m_CreateDXGIFactory1(__uuidof(IDXGIFactory1), (void**)&DXGIFactory1))
    D3D12INITFAILED("CreateDXGIFactory1 FAILED");

    if (DXGIFactory1->QueryInterface(__uuidof(IDXGIFactory2), (void**)&g_d3d.DXGIFactory2))
    D3D12INITFAILED("DXGIFactory1::QueryInterface(__uuidof(IDXGIFactory2)) FAILED");

    SCDesc.Width              = 1;
    SCDesc.Height             = 1;
    SCDesc.Format             = DXGI_FORMAT_B8G8R8A8_UNORM;
    SCDesc.SampleDesc.Count   = 1;
    SCDesc.SampleDesc.Quality = 0;
    SCDesc.BufferUsage        = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    SCDesc.BufferCount        = 2;
    SCDesc.Scaling            = DXGI_SCALING_STRETCH;
    SCDesc.SwapEffect         = DXGI_SWAP_EFFECT_FLIP_DISCARD;
    SCDesc.AlphaMode          = DXGI_ALPHA_MODE_IGNORE;
    SCDesc.Flags              = DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH|DXGI_SWAP_CHAIN_FLAG_FRAME_LATENCY_WAITABLE_OBJECT;

    if (g_d3d.DXGIFactory2->CreateSwapChainForHwnd(
                (IUnknown*)g_d3d.D3D12CommandQueue,g_d3d.hHiddenWin,&SCDesc,nullptr,nullptr,&g_d3d.DXGISwapChain1))
    D3D12INITFAILED("CreateSwapChainForHwnd FAILED");

    IDXGISwapChain2 * SwapChain2 = reinterpret_cast<IDXGISwapChain2*>(g_d3d.DXGISwapChain1);
    g_d3d.CreateSwapChain        = (decltype(g_d3d.CreateSwapChain))IDXGIFactory2_CreateSwapChain_Add(g_d3d.DXGIFactory2);
    g_d3d.CreateSwapChainForHwnd = (decltype(g_d3d.CreateSwapChainForHwnd))IDXGIFactory2_CreateSwapChainForHwnd_Add(g_d3d.DXGIFactory2);
    g_d3d.GetBuffer              = (decltype(g_d3d.GetBuffer))IDXGISwapChain_GetBuffer_Add(g_d3d.DXGISwapChain1);
    g_d3d.Present                = (decltype(g_d3d.Present))IDXGISwapChain_Present_Add(g_d3d.DXGISwapChain1);
    g_d3d.Present1               = (decltype(g_d3d.Present1))IDXGISwapChain1_Present1_Add(g_d3d.DXGISwapChain1);
    g_d3d.ResizeBuffers          = (decltype(g_d3d.ResizeBuffers))IDXGISwapChain_ResizeBuffers_Add(g_d3d.DXGISwapChain1);
    g_d3d.ResizeTarget           = (decltype(g_d3d.ResizeTarget))IDXGISwapChain_ResizeTarget_Add(g_d3d.DXGISwapChain1);
    g_d3d.GetFrameLatencyWaitableObject = (decltype(g_d3d.GetFrameLatencyWaitableObject))
            IDXGISwapChain2_GetFrameLatencyWaitableObject_Add(SwapChain2);
    g_d3d.SetMaximumFrameLatency        = (decltype(g_d3d.SetMaximumFrameLatency))
            IDXGISwapChain2_SetMaximumFrameLatency_Add(SwapChain2);
    g_d3d.m_IDXGISwapChainGetDesc       = (decltype(g_d3d.m_IDXGISwapChainGetDesc))
            IDXGISwapChain_GetDesc_Add(g_d3d.DXGISwapChain1);
    g_d3d.D3D12CreateSampler = (decltype(g_d3d.D3D12CreateSampler)) ID3D12Device_CreateSampler_Add(g_d3d.D3D12Device);
    if (g_d3d.USEINTEROP)
    {
        HOOK((void**)&g_d3d.CreateSwapChainForHwnd, D3D12CreateSwapChainForHwndHook);
        HOOK((void**)&g_d3d.CreateSwapChain, D3D12CreateSwapChainHook);
        HOOK((void**)&g_d3d.GetBuffer, D3D12GetBufferHook);
        HOOK((void**)&g_d3d.Present, D3D12PresentHook);
        HOOK((void**)&g_d3d.Present1, D3D12Present1Hook);
        HOOK((void**)&g_d3d.ResizeBuffers, D3D12ResizeBuffersHook);        
    }
    if (g_d3d.UPSCALE)
    {
        if (g_d3d.RESOLUTIONLIMIT)
        {
            DWORD max_w = (g_d3d.RESOLUTIONLIMIT & 0xffff0000)>>16;
            DWORD max_h = g_d3d.RESOLUTIONLIMIT & 0xffff;
            g_d3d.SetReslimit(max_w, max_h);
        }
        g_d3d.ApplyCommonHooks(0xf);
        g_d3d.ApplyCommonDXGIHooks(g_d3d.DXGISwapChain1, 1);
        if (g_d3d.MOUSEHOOKS) InitMouseHooks();
    }
    if (g_d3d.AMDFSR)
    {
        HOOK((void**)&g_d3d.D3D12CreateSampler, D3D12CreateSamplerHook);
    }

    err.append("Success");
    D3D12InitFailed:
    D3D12LOG(err.c_str());
    if (DXGIFactory1) DXGIFactory1->Release();
    if (D3D12BBuff)     D3D12BBuff->Release();
    g_d3d.lock->unlock();
    */
}
#endif
