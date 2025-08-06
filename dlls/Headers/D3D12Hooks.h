#ifndef D3D12HOOKS_H
#define D3D12HOOKS_H

#include <vector>
#include <windows.h>
#include <ddraw.h>
#include "Sync.h"
#include "dllmain.h"
#define A_CPU
#include <d3d12.h>
#include "D3D12Utils.h"
#include <dxgi1_2.h>
#include "ffx_a.h"
#include <d3d11.h>
#include <d3d10.h>
#include <d3d10_1.h>
#include <d3dcompiler.h>
#include <directxmath.h>

#define D3D12LOG(string) g_.loger.log(__FUNCTION__, string)
using std::string;
using std::to_string;

typedef struct SHADERCONSTANTS {
    DirectX::XMFLOAT4 Bltconsts;
    DirectX::XMUINT4  FSRConsts[4];
    DirectX::XMUINT4  RCASConsts[4];
} SHADERCONSTANTS;

class D3D12_HOOKS  {
public:
    void Init() {
        D3D12LOG( "INITIALIZING" );
        if (lock != nullptr)
        {
            D3D12LOG("ALREADY INITIALIZIED");
            return;
        }
        lock                       = new SYNC::AtomicLock();
        pSwapChainID               = (IID*)SwapChainID;   
        m_GetSystemMetrics         = GetSystemMetrics;
        m_SystemParametersInfoA    = SystemParametersInfoA;
        m_SystemParametersInfoW    = SystemParametersInfoW;
        m_EnumDisplaySettingsA     = EnumDisplaySettingsA;
        m_EnumDisplaySettingsW     = EnumDisplaySettingsW;
        m_EnumDisplaySettingsExA   = EnumDisplaySettingsExA;
        m_EnumDisplaySettingsExW   = EnumDisplaySettingsExW;
        m_ChangeDisplaySettingsExW = ChangeDisplaySettingsExW;
        m_ChangeDisplaySettingsW   = ChangeDisplaySettingsW;
        m_GetMonitorInfoW          = GetMonitorInfoW;
        m_GetMonitorInfoA          = GetMonitorInfoA;
        m_GetClientRect            = GetClientRect;
        m_GetWindowRect            = GetWindowRect;
        m_GetDeviceCaps            = GetDeviceCaps;
        m_SetWindowPos             = SetWindowPos;
        m_MoveWindow               = MoveWindow;
        m_ClipCursor               = ClipCursor;
        m_WW                     = new SYNC::Atomic();
        m_HH                     = new SYNC::Atomic();
        HD_X                     = new SYNC::Atomic();
        mScl                     = new SYNC::AtomicFloat(1.0);

        DEVMODEA Devmode =              {0};
        Devmode.dmSize   = sizeof(DEVMODEA);
        m_EnumDisplaySettingsA(nullptr, ENUM_CURRENT_SETTINGS, &Devmode);
        HD_W = Devmode.dmPelsWidth;
        HD_H = Devmode.dmPelsHeight;
        MaxW = Devmode.dmPelsWidth;
        MaxH = Devmode.dmPelsHeight;
        m_WW->Set(MaxW);
        m_HH->Set(MaxH);   

#ifdef _WIN64
        #define D3dcompiler_47 "D3DCompilers\\x64\\D3Dcompiler_47.dll"
        #define d3dx9_43       "D3DCompilers\\x64\\D3DX9_43.dll"
#else   
        #define D3dcompiler_47 "D3DCompilers\\x86\\D3Dcompiler_47.dll"
        #define d3dx9_43       "D3DCompilers\\x86\\D3DX9_43.dll"
#endif   
        string _D3dcompiler_47 = string(g_.Path()) + "\\" + D3dcompiler_47;
        string _d3dx9_43       = string(g_.Path()) + "\\" + d3dx9_43;

        GETPROCADDRESS(m_DirectDrawCreate, "DirectDrawCreate", "ddraw.dll");             
        GETPROCADDRESS(m_CreateDXGIFactory, "CreateDXGIFactory", "dxgi.dll");
        GETPROCADDRESS(m_CreateDXGIFactory1, "CreateDXGIFactory1", "dxgi.dll");
        GETPROCADDRESS(m_D3D10CreateDevice, "D3D10CreateDevice", "d3d10.dll");
        GETPROCADDRESS(m_D3D10CreateDvcAndSChain, "D3D10CreateDeviceAndSwapChain", "d3d10.dll");
        GETPROCADDRESS(m_D3D10CreateDvc1AndSChain, "D3D10CreateDeviceAndSwapChain1", "d3d10_1.dll");
        GETPROCADDRESS(m_D3D11CreateDevice, "D3D11CreateDevice", "d3d11.dll");
        GETPROCADDRESS(m_D3D11CreateDvcAndSChain, "D3D11CreateDeviceAndSwapChain", "d3d11.dll");
        GETPROCADDRESS(m_D3D11On12CreateDevice, "D3D11On12CreateDevice", "d3d11.dll");       
        GETPROCADDRESS(m_D3D12CreateDevice, "D3D12CreateDevice", "d3d12.dll");
        GETPROCADDRESS(m_D3D12GetDebugInterface, "D3D12GetDebugInterface", "d3d12.dll");
        if (LoadLibraryA("wined3d.dll") == nullptr)
        {
            D3D12LOG("Using System Compilers");
            GETPROCADDRESS(m_D3DReflect, "D3DReflect", "D3dcompiler_47.dll");
            GETPROCADDRESS(m_D3DDisassemble, "D3DDisassemble", "D3dcompiler_47.dll");
            GETPROCADDRESS(m_D3DCompile, "D3DCompile", "D3dcompiler_47.dll");
            GETPROCADDRESS(m_D3DXGetFVFVertexSize, "D3DXGetFVFVertexSize", "d3dx9_43.dll");
            GETPROCADDRESS(m_D3DXCreateBuffer, "D3DXCreateBuffer", "d3dx9_43.dll");
            GETPROCADDRESS(m_D3DXDisassembleShader, "D3DXDisassembleShader", "d3dx9_43.dll");  
        } else {
            D3D12LOG("Using MS Compilers");
            _GETPROCADDRESS(m_D3DReflect, "D3DReflect", _D3dcompiler_47.c_str());
            _GETPROCADDRESS(m_D3DDisassemble, "D3DDisassemble", _D3dcompiler_47.c_str());
            _GETPROCADDRESS(m_D3DCompile, "D3DCompile", _D3dcompiler_47.c_str());
            _GETPROCADDRESS(m_D3DXGetFVFVertexSize, "D3DXGetFVFVertexSize", _d3dx9_43.c_str());
            _GETPROCADDRESS(m_D3DXCreateBuffer, "D3DXCreateBuffer", _d3dx9_43.c_str()); 
            _GETPROCADDRESS(m_D3DXDisassembleShader, "D3DXDisassembleShader", _d3dx9_43.c_str());  
        }
        g_.loger.log(__FUNCTION__, (std::to_string(HD_W) + "x" + std::to_string(HD_H)).c_str() );
        g_.loger.log(__FUNCTION__, (std::to_string(sizeof(SHADERCONSTANTS)).c_str()));

        D3D_SHADER_MACRO EASU32[] = {"AMDFSR", "1", "SAMPLE_EASU", "1", "SAMPLE_SLOW_FALLBACK", "1", NULL, NULL};
        D3D_SHADER_MACRO RCAS32[] = {"AMDFSR", "1", "SAMPLE_RCAS", "1", "SAMPLE_SLOW_FALLBACK", "1", NULL, NULL};
        D3D_SHADER_MACRO EASU[] = {"AMDFSR", "1", "SAMPLE_EASU", "1", NULL, NULL};
        D3D_SHADER_MACRO RCAS[] = {"AMDFSR", "1", "SAMPLE_RCAS", "1", NULL, NULL};

        this->CompileDXBC("CS_5.0.hlsl", nullptr, "TXAAFIX", "cs_5_0", &m_TXAAFix);
        this->CompileDXBC("CS_5.0.hlsl", nullptr, "DownScaleBlt", "cs_5_0", &m_DwnScl);
        this->CompileDXBC("CS_5.0.hlsl", nullptr, "CSBlt", "cs_5_0", &m_CSBlt);
        this->CompileDXBC("CS_5.0.hlsl", AMDFSR==2 ? EASU32 : EASU, "FSR", "cs_5_0", &m_EASU);
        this->CompileDXBC("CS_5.0.hlsl", AMDFSR==2 ? RCAS32 : RCAS, "FSR", "cs_5_0", &m_RCAS); 
        this->CompileDXBC("CS_5.0.hlsl", nullptr, "SSAA", "cs_5_0", &m_SSAA);
        this->CompileDXBC("CS_5.0.hlsl", nullptr, "SSAAHQ", "cs_5_0", &m_SSAAHQ);
        this->CompileDXBC("HLSL_4.0.hlsl", nullptr, "BltPx", "ps_4_0", &m_PSBlt);
        this->CompileDXBC("HLSL_4.0.hlsl", nullptr, "VMirrorBltPx", "ps_4_0", &m_PSVMirrorBlt);
        this->CompileDXBC("HLSL_4.0.hlsl", nullptr, "BltVx", "vs_4_0", &m_VSBlt);
        this->CompileDXBC("HLSL_4.0.hlsl", nullptr, "SSAAx2", "ps_4_0", &m_PS_SSAA);
        this->CompileDXBC("HLSL_4.0.hlsl", nullptr, "SSAAx9", "ps_4_0", &m_PS_SSAAHQ);
    }
    void CompileDXBC(const char*, D3D_SHADER_MACRO*, const char*, const char*, ID3DBlob **);
    void SetReslimit(DWORD w, DWORD h);
    void Setup(DWORD, DWORD, char *);
    void ApplyCommonHooks(DWORD);
    void ApplyCommonDXGIHooks(IDXGISwapChain*, DWORD);
    //int        mHighestDisplayModeIndex = 0xffffffff;
    int        mHighestDisplayModeIndex = 0x7FFFFFFF;
    DWORD       HD_W                             = 0;
    DWORD       HD_H                             = 0;
    DWORD       MaxW                             = 0;
    DWORD       MaxH                             = 0;
    SHADERCONSTANTS                   m_ShaderConsts;
    /* Flags   */
    DWORD                 FORCE_DOUBLE_BUFFERING     = 0;
    DWORD                 USEINTEROP                 = 0;
    DWORD                 UPSCALE                    = 0;
    DWORD                 AMDFSR                     = 0;
    DWORD                 USEPROXIES                 = 0;
    DWORD                 HDPROXIES                  = 0;
    DWORD                 SSAA                       = 1;
    DWORD                 TXAAFIX                    = 0;
    DWORD                 FIXWINSIZE                 = 0;
    DWORD                 MOUSEHOOKS                 = 0;
    DWORD                 MOUSECLIP                  = 0;
    DWORD                 RESOLUTIONLIMIT            = 0;
    DWORD                 GAMMAFIX                   = 0;
    DWORD                 VSYNC                      = 0;
    DWORD                 DBUG                       = 0;
    DWORD                 DXVK                       = 0;
    DWORD                 DELAY_TEXTURE_RELEASES     = 0;
    DWORD                 TEXTURE_SWAP_ENABLED       = 0;
    DWORD                 TEXTURE_SWAP_TOGGLE_SEARCH = 0;
    DWORD                 TEXTURE_SWAP_NEXT          = 0;
    DWORD                 TEXTURE_SWAP_PREV          = 0;
    DWORD                 TEXTURE_SWAP_QUICK         = 0;
    DWORD                 TEXTURE_SWAP_DUMP          = 0;
    DWORD                 TEXTURE_SWAP_MANAGE        = 0;
    DWORD                 TEXTURE_SWAP_A8FIX         = 0;
    DWORD                 TEXTURE_SWAP_AUTODUMP      = 0;
    DWORD                 TEXTURE_FILTER             = 0;
    HWND                  D3DWINDOW                  = 0;
    DWORD                 D3DVERSION                 = 0;  
    /* GUID    */
    char        SwapChainID[17] = "PexD3D12SwpChain";
    IID                                *pSwapChainID;
    /* Objects */   
    D3D11HelperDvc                        D3D11DvcNT;
    /* Pointers */
    HWND                  hHiddenWin       = nullptr;
    IDXGIFactory2      * DXGIFactory2      = nullptr;
    ID3D12Device       * D3D12Device       = nullptr;
    ID3D12CommandQueue * D3D12CommandQueue = nullptr;
    IDXGISwapChain1    * DXGISwapChain1    = nullptr;
    SYNC::AtomicLock   * lock              = nullptr;    
    SYNC::Atomic       * m_WW              = nullptr;
    SYNC::Atomic       * m_HH              = nullptr;
    SYNC::Atomic       * HD_X              = nullptr;
    SYNC::AtomicFloat  * mScl              = nullptr;
    ID3DBlob           * m_CSBlt           = nullptr;
    ID3DBlob           * m_RCAS            = nullptr; // AMD's FSR Sharpening pass
    ID3DBlob           * m_EASU            = nullptr; // AMD's FSR Upsampling pass
    ID3DBlob           * m_PSBlt           = nullptr;
    ID3DBlob           * m_PSVMirrorBlt    = nullptr;
    ID3DBlob           * m_VSBlt           = nullptr;
    ID3DBlob           * m_SSAA            = nullptr;
    ID3DBlob           * m_SSAAHQ          = nullptr;
    ID3DBlob           * m_PS_SSAA         = nullptr;
    ID3DBlob           * m_PS_SSAAHQ       = nullptr;
    ID3DBlob           * m_DwnScl          = nullptr;
    ID3DBlob           * m_TXAAFix         = nullptr;
    /* Imports*/
    HRESULT (WINAPI *m_DirectDrawCreate)(GUID*, LPDIRECTDRAW*,IUnknown*);
    UINT    (WINAPI *m_D3DXGetFVFVertexSize)(DWORD);    
    HRESULT (WINAPI *m_D3DXCreateBuffer)(DWORD, ID3DBlob **);
    HRESULT (WINAPI *m_D3DXDisassembleShader)(const DWORD*, BOOL, LPCSTR, ID3DBlob **);
    HRESULT (WINAPI *m_D3DCompile)(LPCVOID, SIZE_T, LPCSTR, const D3D_SHADER_MACRO*,ID3DInclude*,
                                   LPCSTR, LPCSTR, UINT, UINT, ID3DBlob**, ID3DBlob**);    
    HRESULT (WINAPI *m_CreateDXGIFactory)(REFIID, void**);
    HRESULT (WINAPI *m_CreateDXGIFactory1)(REFIID, void**);
    HRESULT (WINAPI *m_D3DReflect)(LPCVOID, SIZE_T, REFIID, void ** );
    HRESULT (WINAPI *m_D3DDisassemble)(LPCVOID, SIZE_T, UINT, LPCSTR, ID3DBlob **);
    HRESULT (WINAPI *m_D3D10CreateDevice)(IDXGIAdapter*, D3D10_DRIVER_TYPE,HMODULE,UINT, UINT,ID3D10Device**);
    HRESULT (WINAPI *m_D3D10CreateDvcAndSChain)(IDXGIAdapter *, D3D10_DRIVER_TYPE, HMODULE, UINT,
                                              UINT, DXGI_SWAP_CHAIN_DESC*, IDXGISwapChain**, ID3D10Device**);
    HRESULT (WINAPI *m_D3D10CreateDvc1AndSChain)(IDXGIAdapter*, D3D10_DRIVER_TYPE, HMODULE, UINT, D3D10_FEATURE_LEVEL1,
                                               UINT, DXGI_SWAP_CHAIN_DESC*, IDXGISwapChain**, ID3D10Device1 **);
    HRESULT (WINAPI *m_D3D11CreateDevice)(IDXGIAdapter*, D3D_DRIVER_TYPE, HMODULE, UINT,const D3D_FEATURE_LEVEL*,
                                          UINT, UINT, ID3D11Device**, D3D_FEATURE_LEVEL*, ID3D11DeviceContext**);
    HRESULT (WINAPI *m_D3D11CreateDvcAndSChain) (IDXGIAdapter *, D3D_DRIVER_TYPE, HMODULE, UINT, const D3D_FEATURE_LEVEL*,
                                              UINT, UINT, const DXGI_SWAP_CHAIN_DESC*, IDXGISwapChain**,
                                              ID3D11Device**, D3D_FEATURE_LEVEL*, ID3D11DeviceContext**);
    HRESULT (WINAPI * m_D3D11On12CreateDevice)(IUnknown*, UINT, const D3D_FEATURE_LEVEL*, UINT, IUnknown*const*, UINT,
                                               UINT, ID3D11Device**, ID3D11DeviceContext**, D3D_FEATURE_LEVEL*);
    HRESULT (WINAPI *m_D3D12CreateDevice)(IUnknown*, D3D_FEATURE_LEVEL, REFIID, void**);
    HRESULT (WINAPI *m_D3D12GetDebugInterface)(REFIID, void**);
    /* WinPI Trampolines */  
    int     (__stdcall *m_GetSystemMetrics)(int) = nullptr;
    BOOL    (__stdcall *m_SystemParametersInfoA)(UINT, UINT,PVOID, UINT);
    BOOL    (__stdcall *m_SystemParametersInfoW)(UINT, UINT, PVOID, UINT);
    BOOL    (__stdcall *m_EnumDisplaySettingsA)(LPCSTR,DWORD,DEVMODEA*) = nullptr;
    BOOL    (__stdcall *m_EnumDisplaySettingsW)(LPCWSTR,DWORD,DEVMODEW*);
    BOOL    (__stdcall *m_EnumDisplaySettingsExA)(LPCSTR,DWORD,DEVMODEA*,DWORD);
    BOOL    (__stdcall *m_EnumDisplaySettingsExW)(LPCWSTR,DWORD,DEVMODEW*,DWORD);
    LONG    (__stdcall *m_ChangeDisplaySettingsExW)(LPCWSTR, DEVMODEW *, HWND,DWORD, LPVOID);
    LONG    (__stdcall *m_ChangeDisplaySettingsW)(DEVMODEW *, DWORD);
    BOOL    (__stdcall *m_GetMonitorInfoW)(HMONITOR, LPMONITORINFO);
    BOOL    (__stdcall *m_GetMonitorInfoA)(HMONITOR, LPMONITORINFO);
    BOOL    (__stdcall *m_GetClientRect)(HWND, RECT*);
    BOOL    (__stdcall *m_GetWindowRect)(HWND, RECT*);
    BOOL    (__stdcall *m_SetWindowPos)(HWND, HWND,int, int, int,int,UINT);
    BOOL    (__stdcall *m_MoveWindow)(HWND, int, int, int, int, BOOL);
    int     (__stdcall *m_GetDeviceCaps)(HDC hdc, int index);
    BOOL    (__stdcall *m_ClipCursor)(const RECT *);
    /* Common DXGI Trampolines */
    HRESULT (__stdcall * m_IDXGIOutputGetDisplayModeList)(IDXGIOutput*, DXGI_FORMAT, UINT, UINT*,DXGI_MODE_DESC*);
    HRESULT (__stdcall * m_IDXGISwapChainGetDesc)(IDXGISwapChain*, DXGI_SWAP_CHAIN_DESC*);
    HRESULT (__stdcall * m_IDXGISwapChainGetDesc1)(IDXGISwapChain1*, DXGI_SWAP_CHAIN_DESC1*);
    HRESULT (__stdcall * m_FindClosestMatchingMode)(IDXGIOutput*,const DXGI_MODE_DESC*,DXGI_MODE_DESC*,IUnknown*);
    /* D3D12 DXGI Trampolines */
    HRESULT (__thiscall *CreateSwapChain)(IDXGIFactory*,IUnknown *,DXGI_SWAP_CHAIN_DESC*,IDXGISwapChain**);
    HRESULT (__thiscall *CreateSwapChainForHwnd)(IDXGIFactory1*,IUnknown*,HWND,
    const DXGI_SWAP_CHAIN_DESC1*, const DXGI_SWAP_CHAIN_FULLSCREEN_DESC*,
    IDXGIOutput*, IDXGISwapChain1**);
    HRESULT (__thiscall *GetBuffer)(IDXGISwapChain*, UINT, REFIID,void**);
    HRESULT (__thiscall *Present)  (IDXGISwapChain *, UINT, UINT);
    HRESULT (__thiscall *Present1) (IDXGISwapChain1*, UINT, UINT, const DXGI_PRESENT_PARAMETERS*);
    HRESULT (__thiscall *ResizeBuffers)(IDXGISwapChain*,UINT,UINT,UINT,DXGI_FORMAT,UINT);
    HRESULT (__thiscall *ResizeTarget)(IDXGISwapChain*,const DXGI_MODE_DESC *)= nullptr;
    HANDLE  (__thiscall *GetFrameLatencyWaitableObject)(IDXGISwapChain2*);
    HRESULT (__thiscall *SetMaximumFrameLatency)(IDXGISwapChain2*, UINT);
    /* D3D11 Trampolines     */
    HRESULT (__stdcall * D3D11CreateSampler)(ID3D11Device *, const D3D11_SAMPLER_DESC*, ID3D11SamplerState**);
    /* D3D12 Trampolines     */
    void    (__stdcall * D3D12CreateSampler)(ID3D12Device *, const D3D12_SAMPLER_DESC*, D3D12_CPU_DESCRIPTOR_HANDLE);
};
extern D3D12_HOOKS g_d3d;

extern UINT D3D12GetBufferCount(IDXGISwapChain*);
extern void * D3D12WaitSwap(IDXGISwapChain*);
extern BOOL WINAPI D3D12ClipCursorHook(const RECT *);
extern "C" __declspec(dllexport) void __stdcall D3D12Config(char *, void*);

class LogWinSize{
public:
    LogWinSize(HWND hwin, char* caller)
    {
        m_message.clear();
        m_hwin = hwin;
        RECT r = {0};
        g_d3d.m_GetClientRect(hwin, &r);
        m_message.append((string(caller)+": ").c_str());
        m_message.append((to_string(r.right)+"x"+to_string(r.bottom)).c_str());
    }
    ~LogWinSize()
    {
        RECT r = {0};
        g_d3d.m_GetClientRect(m_hwin, &r);
        m_message.append((string(" -> ")+to_string(r.right)+"x"+to_string(r.bottom)).c_str());
        DBUG_WARN(m_message.c_str());
    }
    HWND           m_hwin;
    std::string m_message;
};

#endif // D3D12HOOKS_H
