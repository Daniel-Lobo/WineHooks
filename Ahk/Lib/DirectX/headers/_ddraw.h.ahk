#include lib\DirectX\Headers\ddraw.h.ahk
;#include <DirectX\headers\d3d.h>
;#include <DirectX\headers\d3dtypes.h>

ddraw.err[2147942487 . ""] := "DDERR_INVALIDPARAMS"
ddraw.err[0 . ""] := "DDERR_OK"
ddraw.err[2147500034 . ""] := "E_NOINTERFACE"

global DDCOLORKEY := "DWORD dwColorSpaceLowValue, DWORD dwColorSpaceHighValue"
global DDPIXELFORMAT =
(
" 
    DWORD       dwSize;
    DWORD       dwFlags;
    DWORD       dwFourCC;
        {
        DWORD   dwRGBBitCount;
        DWORD   dwYUVBitCount;
        DWORD   dwZBufferBitDepth;
        DWORD   dwAlphaBitDepth;
        DWORD   dwLuminanceBitCount;
        DWORD   dwBumpBitCount;
        DWORD   dwPrivateFormatBitCount;
    };
        {
        DWORD   dwRBitMask;
        DWORD   dwYBitMask;
        DWORD   dwStencilBitDepth;
        DWORD   dwLuminanceBitMask;
        DWORD   dwBumpDuBitMask;
        DWORD   dwOperations;
    };
        {
        DWORD   dwGBitMask;
        DWORD   dwUBitMask;
        DWORD   dwZBitMask;
        DWORD   dwBumpDvBitMask;
        struct        {
            WORD    wFlipMSTypes;
            WORD    wBltMSTypes;
        };
    };
        {
        DWORD   dwBBitMask;
        DWORD   dwVBitMask;
        DWORD   dwStencilBitMask;
        DWORD   dwBumpLuminanceBitMask;
    };
        {
        DWORD   dwRGBAlphaBitMask;
        DWORD   dwYUVAlphaBitMask;
        DWORD   dwLuminanceAlphaBitMask;
        DWORD   dwRGBZBitMask;
        DWORD   dwYUVZBitMask;
    };
"
)

global DDSCAPS := "DWORD dwCaps;"    
global DDSURFACEDESC :=
(
"
    DWORD               dwSize;                 
    DWORD               dwFlags;                
    DWORD               dwHeight;               
    DWORD               dwWidth;               
    {
        LONG            lPitch;                 
        DWORD           dwLinearSize;          
    };
    DWORD               dwBackBufferCount;      
    {
        DWORD           dwMipMapCount;          
        DWORD           dwZBufferBitDepth;      
        DWORD           dwRefreshRate;          
    };
    DWORD               dwAlphaBitDepth;       
    DWORD               dwReserved;             
    LPVOID              lpSurface;             
    DDCOLORKEY          ddckCKDestOverlay;      
    DDCOLORKEY          ddckCKDestBlt;          
    DDCOLORKEY          ddckCKSrcOverlay;       
    DDCOLORKEY          ddckCKSrcBlt;          
    DDPIXELFORMAT       ddpfPixelFormat;
    DDSCAPS             ddsCaps; 
"    
)    

global DDSCAPS2 := "DWORD dwCaps, DWORD dwCaps2, DWORD dwCaps3, {DWORD dwCaps4, DWORD dwVolumeDepth}"
global DDSURFACEDESC2 :=
(
" 
    DWORD               dwSize;
    DWORD               dwFlags;
    DWORD               dwHeight;
    DWORD               dwWidth;
        {
        LONG            lPitch;
        DWORD           dwLinearSize;
    };
        {
        DWORD           dwBackBufferCount;
        DWORD           dwDepth;
    };
        {
        DWORD           dwMipMapCount;
        DWORD           dwRefreshRate;
        DWORD           dwSrcVBHandle;
    };
    DWORD               dwAlphaBitDepth;
    DWORD               dwReserved;
    LPDWORD              lpSurface;
        {
        DDCOLORKEY      ddckCKDestOverlay;
        DWORD           dwEmptyFaceColor;
    };
    DDCOLORKEY          ddckCKDestBlt;
    DDCOLORKEY          ddckCKSrcOverlay;
    DDCOLORKEY          ddckCKSrcBlt;
        {
        DDPIXELFORMAT   ddpfPixelFormat;
        DWORD           dwFVF;
    };
    DDSCAPS2            ddsCaps;
    DWORD               dwTextureStage;
"
)

DDSURFACEDESC := Struct(DDSURFACEDESC)
DDSCAPS := Struct(DDSCAPS)

DDSURFACEDESC2 := Struct(DDSURFACEDESC2)
DDPIXELFORMAT := Struct(DDPIXELFORMAT)

global DDBLTFX :=
(
"
  DWORD      dwSize;
  DWORD      dwDDFX;
  DWORD      dwROP;
  DWORD      dwDDROP;
  DWORD      dwRotationAngle;
  DWORD      dwZBufferOpCode;
  DWORD      dwZBufferLow;
  DWORD      dwZBufferHigh;
  DWORD      dwZBufferBaseDest;
  DWORD      dwZDestConstBitDepth;
  {
    DWORD               dwZDestConst;
    LPDWORD lpDDSZBufferDest;
  };
  DWORD      dwZSrcConstBitDepth;
  {
    DWORD               dwZSrcConst;
    LPDWORD  lpDDSZBufferSrc;
  }
  DWORD      dwAlphaEdgeBlendBitDepth;
  DWORD      dwAlphaEdgeBlend;
  DWORD      dwReserved;
  DWORD      dwAlphaDestConstBitDepth;
  {
    DWORD               dwAlphaDestConst;
    LPDWORD  lpDDSAlphaDest;
  };
  DWORD      dwAlphaSrcConstBitDepth;
  {
    DWORD               dwAlphaSrcConst;
    LPDWORD  lpDDSAlphaSrc;
  };
  {
    DWORD               dwFillColor;
    DWORD               dwFillDepth;
    DWORD               dwFillPixel;
    LPDWORD  lpDDSPattern;
  };
  DDCOLORKEY ddckDestColorkey;
  DDCOLORKEY ddckSrcColorkey;
"
)
DDBLTFX := Struct(DDBLTFX)
global RECT := Struct("LONG left; LONG top; LONG right; LONG bottom;")
global hRECT := Struct("LONG left; LONG top; LONG right; LONG bottom;")
global _RECT := Struct("LONG left; LONG top; LONG right; LONG bottom;")
global POINT := Struct("LONG x; LONG y;")
global DDBLTBATCH := Struct("ptr lprDest; ptr lpDDSSrc; ptr lprSrc; DWORD dwFlags; ptr lpDDBltFx;")

global DDRAWI_DIRECTDRAW_LCL :=
(
"
DWORD lpDDMore; 
ptr lpGbl; 
DWORD dwUnused0; 
DWORD dwLocalFlags; 
DWORD dwLocalRefCnt; 
DWORD dwProcessId; 
ptr pUnkOuter; 
DWORD dwObsolete1; 
ULONG_PTR hWnd; 
ULONG_PTR hDC; 
DWORD dwErrorMode; 
ptr lpPrimary; 
ptr lpCB; 
DWORD dwPreferredMode; 
HINSTANCE hD3DInstance; 
ptr pD3DIUnknown; 
ptr lpDDCB; 
DWORD hDDVxd; 
DWORD dwAppHackFlags; 
ptr hFocusWnd; 
DWORD dwHotTracking; 
DWORD dwIMEState; 
ptr hWndPopup; 
ptr hDD; 
ptr hGammaCalibrator; 
ptr lpGammaCalibrator; 
"
)
DDRAWI_DIRECTDRAW_LCL := struct(DDRAWI_DIRECTDRAW_LCL)
global DDRAWI_DIRECTDRAW_INT := struct("ptr lpVtbl; ptr lpLcl; ptr lpLink; DWORD dwIntRefCnt;")

/*
global DDCAPS :=
(
"
    DWORD       dwSize;                
    DWORD       dwCaps;                 
    DWORD       dwCaps2;               
    DWORD       dwCKeyCaps;             
    DWORD       dwFXCaps;              
    DWORD       dwFXAlphaCaps;         
    DWORD       dwPalCaps;             
    DWORD       dwSVCaps;               
    DWORD       dwAlphaBltConstBitDepths;       
    DWORD       dwAlphaBltPixelBitDepths;       
    DWORD       dwAlphaBltSurfaceBitDepths;    
    DWORD       dwAlphaOverlayConstBitDepths;  
    DWORD       dwAlphaOverlayPixelBitDepths;   
    DWORD       dwAlphaOverlaySurfaceBitDepths; 
    DWORD       dwZBufferBitDepths;             
    DWORD       dwVidMemTotal;          
    DWORD       dwVidMemFree;          
    DWORD       dwMaxVisibleOverlays;  
    DWORD       dwCurrVisibleOverlays;  
    DWORD       dwNumFourCCCodes;       
    DWORD       dwAlignBoundarySrc;    
    DWORD       dwAlignSizeSrc;         
    DWORD       dwAlignBoundaryDest;    
    DWORD       dwAlignSizeDest;        
    DWORD       dwAlignStrideAlign;    
    DWORD       dwRops[8];   
    DWORD       ddsCaps;               
    DWORD       dwMinOverlayStretch;   
    DWORD       dwMaxOverlayStretch;    
    DWORD       dwMinLiveVideoStretch;  
    DWORD       dwMaxLiveVideoStretch; 
    DWORD       dwMinHwCodecStretch;    
    DWORD       dwMaxHwCodecStretch;    
    DWORD       dwReserved1;            
    DWORD       dwReserved2;            
    DWORD       dwReserved3;  
"    
)
global DDCAPS_HAWRDWARE := struct(DDCAPS)
global DDCAPS_HEL       := struct(DDCAPS)
DDCAPS_HAWRDWARE.dwSize := DDCAPS_HAWRDWARE.size()
DDCAPS_HEL.dwSize       := DDCAPS_HEL.size()
*/

/*
global ISURFACE7_VTBL :=
( 
"
    void QueryInterface;
    void AddRef;
    void Release;
    void AddAttachedSurface;
    void AddOverlayDirtyRect;
    void Blt;
    void BltBatch;
    void BltFast;
    void DeleteAttachedSurface;
    void EnumAttachedSurfaces;
    void EnumOverlayZOrders;
    void Flip;
    void GetAttachedSurface;
    void GetBltStatus;
    void GetCaps;
    void GetClipper;
    void GetColorKey;
    void GetDC;
    void GetFlipStatus;
    void GetOverlayPosition;
    void GetPalette;
    void GetPixelFormat;
    void GetSurfaceDesc;
    void Initialize;
    void IsLost;
    void Lock;
    void ReleaseDC;
    void Restore;
    void SetClipper;
    void SetColorKey;
    void SetOverlayPosition;
    void SetPalette;
    void Unlock;
    void UpdateOverlay;
    void UpdateOverlayDisplay;
    void UpdateOverlayZOrder;
    void GetDDInterface;
    void PageLock;
    void PageUnlock;
    void SetSurfaceDesc;
    void SetPrivateData;
    void GetPrivateData;
    void FreePrivateData;
    void GetUniquenessValue;
    void ChangeUniquenessValue;
    void SetPriority;
    void GetPriority;
    void SetLOD;
    void GetLOD;
"
)
ISURFACE7_VTBL   := struct(ISURFACE7_VTBL)
global ISURFACE4_VTBL   := struct(ISURFACE7_VTBL)
global ISURFACE2_VTBL   := struct(ISURFACE7_VTBL)
global ISURFACE_VTBL    := struct(ISURFACE7_VTBL)
*/