#include lib\DirectX\Headers\D3D9.h.ahk
#include lib\DirectX\Headers\D3D9types.h.ahk

d3D9.result[0 . ""] := "D3DERR_OK"

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