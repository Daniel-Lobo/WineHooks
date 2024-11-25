#include lib\DirectX\Headers\d3d.h.ahk
#include lib\DirectX\Headers\d3dtypes.h.ahk

global D3DRENDERSTATE_TEXTUREHANDLE := 1

d3d.err[2147942487 . ""] := "D3DERR_INVALIDPARAMS"
d3d.err[0 . ""] := "D3DERR_OK"
d3d.err[2147500034 . ""] := "E_NOINTERFACE"

global D3D_D3DMATRIX := "float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24,"
. " float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44"

global D3DMATRIX := "float m11; float m12; float m13; float m14; float m21; float m22; float m23; float m24;"
. " float m31; float m32; float m33, float m34; float m41, float m42; float m43; float m44"

D3DMATRIX := Struct(D3DMATRIX)

global D3DVERTEXBUFFERDESC := Struct("DWORD dwSize; DWORD dwCaps; DWORD dwFVF; DWORD dwNumVertices;")
global D3DLVERTEX := Struct("float x, float y, float z, int color, int specular, float u, float v")

global D3DVIEWPORT := 
(
"
    DWORD       dwSize;
    DWORD       dwX;
    DWORD       dwY;            
    DWORD       dwWidth;
    DWORD       dwHeight;       
    Float    dvScaleX;       
    Float    dvScaleY;       
    Float    dvMaxX;         
    Float    dvMaxY;         
    Float    dvMinZ;
    Float    dvMaxZ; 
"
)
global D3DVIEWPORT2 := 
(
"
    DWORD       dwSize;
    DWORD       dwX;
    DWORD       dwY;
    DWORD       dwWidth;
    DWORD       dwHeight;
    Float    dvClipX;
    Float    dvClipY;
    Float    dvClipWidth;
    Float    dvClipHeight;
    Float    dvMinZ;
    Float    dvMaxZ; 
"
)
global D3DVIEWPORT7 := 
(
"
    DWORD       dwX;
    DWORD       dwY;
    DWORD       dwWidth;
    DWORD       dwHeight;
    float       dvMinZ;
    float       dvMaxZ;
"
)
global D3DVIEWPORT7 := Struct(D3DVIEWPORT7)
global D3DVIEWPORT2 := Struct(D3DVIEWPORT2)
global D3DVIEWPORT := Struct(D3DVIEWPORT)
global D3DEXECUTEBUFFERDESC := Struct("DWORD dwSize, DWORD dwFlags, DWORD dwCaps, DWORD dwBufferSize, ptr lpData")
global D3DEXECUTEDATA := 
(
"
    DWORD     dwSize;
    DWORD     dwVertexOffset;
    DWORD     dwVertexCount;
    DWORD     dwInstructionOffset;
    DWORD     dwInstructionLength;
    DWORD     dwHVertexOffset;
    DWORD     dsStatus[6];
"
)
D3DEXECUTEDATA := struct(D3DEXECUTEDATA)

/*
global D3DSTATUS := 
(
"
    DWORD   dwFlags;   
    DWORD   dwStatus; 
    RECT drExtent;
"
)
global D3DEXECUTEDATA := 
(
"
    DWORD     dwSize;
    DWORD     dwVertexOffset;
    DWORD     dwVertexCount;
    DWORD     dwInstructionOffset;
    DWORD     dwInstructionLength;
    DWORD     dwHVertexOffset;
    D3DSTATUS dsStatus;
"
)
D3DEXECUTEDATA := struct(D3DEXECUTEDATA)

global D3DTRANSFORMCAPS := "DWORD dwSize; DWORD dwCaps;" 
global D3DLIGHTINGCAPS  := "DWORD dwSize; DWORD dwCaps; DWORD dwLightingModel; DWORD dwNumLights;"
global D3DPRIMCAPS      :=
(
"
    DWORD dwSize;                
    DWORD dwMiscCaps;            
    DWORD dwRasterCaps;          
    DWORD dwZCmpCaps;           
    DWORD dwSrcBlendCaps;        
    DWORD dwDestBlendCaps;       
    DWORD dwAlphaCmpCaps;        
    DWORD dwShadeCaps;           
    DWORD dwTextureCaps;        
    DWORD dwTextureFilterCaps;   
    DWORD dwTextureBlendCaps;    
    DWORD dwTextureAddressCaps;  
    DWORD dwStippleWidth;        
    DWORD dwStippleHeight;       
"
) 
global D3DDEVICEDESC :=
(
"
DWORD            dwSize; 
DWORD            dwFlags; 
DWORD            dcmColorModel; 
DWORD            dwDevCaps; 
D3DTRANSFORMCAPS dtcTransformCaps; 
BOOL             bClipping; 
D3DLIGHTINGCAPS  dlcLightingCaps; 
D3DPRIMCAPS      dpcLineCaps; 
D3DPRIMCAPS      dpcTriCaps; 
DWORD            dwDeviceRenderBitDepth; 
DWORD            dwDeviceZBufferBitDepth; 
DWORD            dwMaxBufferSize; 
DWORD            dwMaxVertexCount; 
DWORD            dwMinTextureWidth; 
DWORD            dwMinTextureHeight;
DWORD            dwMaxTextureWidth; 
DWORD            dwMaxTextureHeight;
DWORD            dwMinStippleWidth; 
DWORD            dwMaxStippleWidth;
DWORD            dwMinStippleHeight; 
DWORD            dwMaxStippleHeight;
DWORD            dwMaxTextureRepeat;
DWORD            dwMaxTextureAspectRatio;
DWORD            dwMaxAnisotropy;
float            dvGuardBandLeft;
float            dvGuardBandTop;
float            dvGuardBandRight;
float            dvGuardBandBottom;
float            dvExtentsAdjust;
DWORD            dwStencilCaps;
DWORD            dwFVFCaps;
DWORD            dwTextureOpCaps;
WORD             wMaxTextureBlendStages;
WORD             wMaxSimultaneousTextures;
"
)
D3DDEVICEDESC    := struct(D3DDEVICEDESC)
D3DTRANSFORMCAPS := struct(D3DTRANSFORMCAPS)
D3DLIGHTINGCAPS  := struct(D3DLIGHTINGCAPS)
D3DLIGHTINGCAPS  := struct(D3DLIGHTINGCAPS)
*/