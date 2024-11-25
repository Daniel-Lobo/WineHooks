#include lib\DirectX\Headers\d3D8.h.ahk
#include lib\DirectX\Headers\d3D8types.h.ahk

d3D8.result[0 . ""] := "D3DERR_OK"

global D3DPRESENT_PARAMETERS :=
(
"
    UINT                    BackBufferWidth;
    UINT                    BackBufferHeight;
    UINT                    BackBufferFormat;
    UINT                    BackBufferCount;

    UINT                    MultiSampleType;
    UINT                    SwapEffect;
    DWORD                   hDeviceWindow;
    BOOL                    Windowed;
    BOOL                    EnableAutoDepthStencil;
    UINT                    AutoDepthStencilFormat;
    DWORD                   Flags;

    UINT                    FullScreen_RefreshRateInHz;
    UINT                    FullScreen_PresentationInterval;
"
)
D3DPRESENT_PARAMETERS := struct(D3DPRESENT_PARAMETERS)

global D3DDISPLAYMODE       := struct("UINT Width; UINT Height; UINT RefreshRate; uint Format;")
global D3D8LOCKED_RECT      := struct("INT Pitch; uint pBits;")
global D3D8_RECT            := struct("uint left; uint top; uint right; uint bottom;")
global D3DVIEWPORT8         := struct("DWORD X; int Y; DWORD Width; DWORD Height; float MinZ; float MaxZ;")
global D3DVERTEXBUFFER_DESC := struct("DWORD Format; DWORD Type; DWORD Usage; DWORD Pool; UINT Size; DWORD FVF;")
global D3DSURFACE_DESC      := struct("DWORD Format; DWORD Type; DWORD Usage; DWORD Pool; UINT Size; DWORD MultiSampleType; DWORD Width; DWORD Height")
   
   



