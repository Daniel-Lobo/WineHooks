#include lib\DirectX\Headers\DXGI.h.ahk
#include lib\DirectX\Headers\DXGIType.h.ahk
#include lib\DirectX\Headers\DXGIFormat.h.ahk
#include lib\DirectX\Headers\DXGI1_2.h.ahk

DXGI.IDXGISwapChain1 := {}
DXGI.IDXGISwapChain1.name := "IDXGISwapChain1"
DXGI.IDXGISwapChain1.def := 
( 
"
STDMETHOD(GetBackgroundColor)(This)
STDMETHOD(GetCoreWindow)(This)
STDMETHOD(GetDesc1)(This)
STDMETHOD(GetFullscreenDesc)(This)
STDMETHOD(GetHwnd)(This)
STDMETHOD(GetRestrictToOutput)(This)
STDMETHOD(GetRotation)(This)
STDMETHOD(IsTemporaryMonoSupported)(This)
STDMETHOD(Present1)(This)
STDMETHOD(SetBackgroundColor)(This)
STDMETHOD(SetRotation)(This)
"
)
DXGI.IDXGISwapChain1.def := DXGI.IDXGISwapChain.def "`n" DXGI.IDXGISwapChain1.def

DXGI.IDXGIFactory2 := {}
DXGI.IDXGIFactory2.name := "IDXGIFactory2"
DXGI.IDXGIFactory2.def := 
( 
"
STDMETHOD(IsWindowedStereoEnabled)
STDMETHOD(CreateSwapChainForHwnd)
vSTDMETHOD(CreateSwapChainForCoreWindow)
STDMETHOD(GetSharedResourceAdapterLuid)
STDMETHOD(RegisterOcclusionStatusWindow)
STDMETHOD(RegisterStereoStatusEvent)
STDMETHOD(UnregisterStereoStatus)
STDMETHOD(RegisterStereoStatusWindow)
STDMETHOD(RegisterOcclusionStatusEvent)
STDMETHOD(UnregisterOcclusionStatus)
STDMETHOD(CreateSwapChainForComposition)
"
)
DXGI.IDXGIFactory2.def := DXGI.IDXGIFactory1.def "`n" DXGI.IDXGIFactory2.def  


global DXGI_RATIONAL := "UINT Numerator; UINT Denominator;"
global DXGI_MODE_DESC :=
(
"
  UINT          Width;
  UINT          Height;
  DXGI_RATIONAL RefreshRate;
  UINT          Format;
  UINT          ScanlineOrdering;
  UINT          Scaling;
"
) 
global DXGI_SAMPLE_DESC := "UINT Count; UINT Quality;"
global DXGI_SWAP_CHAIN_DESC := 
(
"
  DXGI_MODE_DESC   BufferDesc;
  DXGI_SAMPLE_DESC SampleDesc;
  UINT             BufferUsage;
  UINT             BufferCount;
  HWND             OutputWindow;
  BOOL             Windowed;
  UINT             SwapEffect;
  UINT             Flags;
"
)
global DXGI_SWAP_CHAIN_DESC1 := struct("UINT Width; UINT Height; UINT Format; BOOL Stereo; DXGI_SAMPLE_DESC SampleDesc;"
. " UINT BufferUsage; UINT BufferCount; UINT Scaling; UINT SwapEffect; UINT AlphaMode; UINT Flags;")

DXGI_SWAP_CHAIN_DESC := struct(DXGI_SWAP_CHAIN_DESC)
DXGI_RATIONAL        := struct(DXGI_RATIONAL)
DXGI_MODE_DESC       := struct(DXGI_MODE_DESC)
DXGI_SAMPLE_DESC     := struct(DXGI_SAMPLE_DESC)

global DXGI_PRESENT_PARAMETERS := struct("UINT DirtyRectsCount; LPVOID pDirtyRects; LPVOID pScrollRect; LPVOID pScrollOffset;")


