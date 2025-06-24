#include lib\DirectX\Headers\D3D9.h.ahk
#include lib\DirectX\Headers\D3D9types.h.ahk

d3D9.result[0 . ""] := "D3DERR_OK"

D3D9.IDirect3D9Ex.def :=
( 
"
    STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    STDMETHOD_(ULONG,Release)(THIS) PURE;
    STDMETHOD(RegisterSoftwareDevice)(THIS_ void* pInitializeFunction) PURE;
    STDMETHOD_(UINT, GetAdapterCount)(THIS) PURE;
    STDMETHOD(GetAdapterIdentifier)(THIS_ UINT Adapter,DWORD Flags,D3DADAPTER_IDENTIFIER9* pIdentifier) PURE;
    STDMETHOD_(UINT, GetAdapterModeCount)(THIS_ UINT Adapter,D3DFORMAT Format) PURE;
    STDMETHOD(EnumAdapterModes)(THIS_ UINT Adapter,D3DFORMAT Format,UINT Mode,D3DDISPLAYMODE* pMode) PURE;
    STDMETHOD(GetAdapterDisplayMode)(THIS_ UINT Adapter,D3DDISPLAYMODE* pMode) PURE;
    STDMETHOD(CheckDeviceType)(THIS_ UINT Adapter,D3DDEVTYPE DevType,D3DFORMAT AdapterFormat,D3DFORMAT BackBufferFormat,BOOL bWindowed) PURE;
    STDMETHOD(CheckDeviceFormat)(THIS_ UINT Adapter,D3DDEVTYPE DeviceType,D3DFORMAT AdapterFormat,DWORD Usage,D3DRESOURCETYPE RType,D3DFORMAT CheckFormat) PURE;
    STDMETHOD(CheckDeviceMultiSampleType)(THIS_ UINT Adapter,D3DDEVTYPE DeviceType,D3DFORMAT SurfaceFormat,BOOL Windowed,D3DMULTISAMPLE_TYPE MultiSampleType,DWORD* pQualityLevels) PURE;
    STDMETHOD(CheckDepthStencilMatch)(THIS_ UINT Adapter,D3DDEVTYPE DeviceType,D3DFORMAT AdapterFormat,D3DFORMAT RenderTargetFormat,D3DFORMAT DepthStencilFormat) PURE;
    STDMETHOD(CheckDeviceFormatConversion)(THIS_ UINT Adapter,D3DDEVTYPE DeviceType,D3DFORMAT SourceFormat,D3DFORMAT TargetFormat) PURE;
    STDMETHOD(GetDeviceCaps)(THIS_ UINT Adapter,D3DDEVTYPE DeviceType,D3DCAPS9* pCaps) PURE;
    STDMETHOD_(HMONITOR, GetAdapterMonitor)(THIS_ UINT Adapter) PURE;
    STDMETHOD(CreateDevice)(THIS_ UINT Adapter,D3DDEVTYPE DeviceType,HWND hFocusWindow,DWORD BehaviorFlags,D3DPRESENT_PARAMETERS* pPresentationParameters,IDirect3DDevice9** ppReturnedDeviceInterface) PURE;
    STDMETHOD_(UINT, GetAdapterModeCountEx)(THIS_ UINT Adapter,CONST D3DDISPLAYMODEFILTER* pFilter ) PURE;
    STDMETHOD(EnumAdapterModesEx)(THIS_ UINT Adapter,CONST D3DDISPLAYMODEFILTER* pFilter,UINT Mode,D3DDISPLAYMODEEX* pMode) PURE;
    STDMETHOD(GetAdapterDisplayModeEx)(THIS_ UINT Adapter,D3DDISPLAYMODEEX* pMode,D3DDISPLAYROTATION* pRotation) PURE;
    STDMETHOD(CreateDeviceEx)(THIS_ UINT Adapter,D3DDEVTYPE DeviceType,HWND hFocusWindow,DWORD BehaviorFlags,D3DPRESENT_PARAMETERS* pPresentationParameters,D3DDISPLAYMODEEX* pFullscreenDisplayMode,IDirect3DDevice9Ex** ppReturnedDeviceInterface) PURE;
    STDMETHOD(GetAdapterLUID)(THIS_ UINT Adapter,LUID * pLUID) PURE;
"
)

D3DPRESENT_PARAMETERS :=
(
"
  UINT                BackBufferWidth;
  UINT                BackBufferHeight;
  int                 BackBufferFormat;
  UINT                BackBufferCount;
  int                 MultiSampleType;
  DWORD               MultiSampleQuality;
  int                 SwapEffect;
  HWND                hDeviceWindow;
  BOOL                Windowed;
  BOOL                EnableAutoDepthStencil;
  int                 AutoDepthStencilFormat;
  DWORD               Flags;
  UINT                FullScreen_RefreshRateInHz;
  UINT                PresentationInterval;
" 
)

global D3DPRESENT_PARAMETERS := Struct(D3DPRESENT_PARAMETERS)
global D3DLOCKED_RECT := Struct("INT Pitch; uint pBits;")

D3DDISPLAYMODE :=
(
"
  UINT                Width;
  UINT                Height;
  UINT                RefreshRate;
  UINT                Format;  
" 
) 
D3DDISPLAYMODEEX :=
(
"
  UINT                Size;
  UINT                Width;
  UINT                Height;
  UINT                RefreshRate;
  UINT                Format;
  UINT                ScanLineOrdering;
" 
) 

global D3DDISPLAYMODE   := struct(D3DDISPLAYMODE)
global D3DDISPLAYMODEEX := struct(D3DDISPLAYMODEEX)
global D3DSURFACE_DESC  := struct("DWORD Format; DWORD Type; DWORD Usage; DWORD Pool; DWORD MultiSampleType; DWORD MultiSampleQuality; DWORD Width; DWORD Height")
global D3DVIEWPORT9     := struct("DWORD X; DWORD Y; DWORD Width; DWORD Height; float MinZ; float MaxZ;")
global D3D9_RECT        := struct("UINT X, Y, W, H;")