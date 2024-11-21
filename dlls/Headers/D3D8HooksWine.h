#ifndef D3D8HOOKS_H
#define D3D8HOOKS_H
#include "collections.h"

typedef struct _VB8LOCK {
    DWORD VertexCount;
    DWORD VertexSize;
    LPVOID pData;
}VB8LOCK;

typedef struct _TEXTSWAP8_ENTRY {
     LPVOID pTexture;
     DWORD  ww;
     DWORD  hh;
     DWORD  type;
     DWORD  Format;
     LPVOID pData;
     DWORD  pitch;
     DWORD  bypp;
     BOOL   DXTn;
     LPVOID level0;
}TEXTSWAP8_ENTRY;

typedef struct _TEXTSWAP8_SURFACE {
      LPVOID pSurface;
      LPVOID ParentTexture;
      DWORD  ww;
      DWORD  hh;
      DWORD  type;
      DWORD  Format;
      LPVOID pData;
      DWORD  pitch;
      DWORD  bypp;
      BOOL   DXTn;
      LPVOID level0;
}TEXTSWAP8_SURFACE;

typedef struct _D3D8HOOKS_DATA8 {
    HRESULT (__stdcall *p_DrawPrimitive)(LPVOID, DWORD, DWORD, DWORD);
    HRESULT (__stdcall *p_DrawPrimitiveUP)(LPVOID, DWORD, DWORD, const void*, DWORD);
    HRESULT (__stdcall *p_DrawIndexedPrimitive)( IDirect3DDevice8*,D3DPRIMITIVETYPE, UINT, UINT, UINT, UINT);
    HRESULT (__stdcall *p_DrawIndexedPrimitiveUp)(IDirect3DDevice8*, D3DPRIMITIVETYPE, UINT, UINT, UINT,
                                                  CONST void*, D3DFORMAT, CONST void*, UINT);
    HRESULT (__stdcall *CreateVertexBuffer)(LPVOID, DWORD, DWORD, DWORD, DWORD, LPVOID*);
    HRESULT (__stdcall *SetStreamSource)(LPVOID, DWORD, IDirect3DVertexBuffer8*, DWORD);
    HRESULT (__stdcall *SetVertexShader)(LPVOID, DWORD);
    HRESULT (__stdcall *VB_lock)(LPVOID, UINT, UINT, BYTE**, DWORD);
    HRESULT (__stdcall *VB_Unlock)(LPVOID);
    HRESULT (__stdcall *MVB_lock)(LPVOID, UINT, UINT, BYTE**, DWORD);
    HRESULT (__stdcall *MVB_Unlock)(LPVOID);
    HRESULT (__stdcall *VB_GetDesc)(LPVOID, D3DVERTEXBUFFER_DESC*);
    POINTER_DICTIONARY * VbLocks;
    float  scale;
    DWORD  HD_X;
    BOOL   screenspace;
    IDirect3DVertexBuffer8 * current_vbuff;
    DWORD             stride;
    void         * pVertices;
    BOOL        HalfPxOffset;
    DWORD SingleCoreAffinity;
    POINTER_DICTIONARY * Render_targets;
    HRESULT (__stdcall *pIDirect3DDevice8_EndScene)(LPDIRECT3DDEVICE8);
    HRESULT (__stdcall *pIDirect3DDevice8_CreateTexture)(LPVOID,UINT,UINT,UINT,DWORD,DWORD,DWORD,LPVOID*);
    HRESULT (__stdcall *pIDirect3DDevice8_UpdateTexture)(LPVOID, LPVOID, LPVOID);
    HRESULT (__stdcall *pIDirect3DDevice8_CopyRects)(LPVOID, LPVOID,LPVOID,UINT,LPVOID,UINT);
    HRESULT (__stdcall *pIDirect3DDevice8_SetTexture)(LPVOID, DWORD, LPVOID);
    HRESULT (__stdcall *pIDirect3DTexture8_GetSurfaceLevel)(LPVOID, UINT, LPVOID*);
    HRESULT (__stdcall *pIDirect3DTexture8_LockRect)(LPVOID, UINT, D3DLOCKED_RECT*, CONST RECT*, DWORD);
    HRESULT (__stdcall *pIDirect3DTexture8_UnlockRect)(LPVOID, UINT);
    HRESULT (__stdcall *pIDirect3DTexture8_QueryInterface)(LPVOID, REFIID, LPVOID*);
    HRESULT (__stdcall *pIDirect3DTexture8_Release)(LPVOID);
    HRESULT (__stdcall *pIDirect3DMSurface8_LockRect)(LPVOID, D3DLOCKED_RECT*, CONST RECT*, DWORD);
    HRESULT (__stdcall *pIDirect3DMSurface8_UnlockRect)(LPVOID);
    HRESULT (__stdcall *pIDirect3DSurface8_Release)(LPVOID);
    HRESULT (__stdcall *pIDirect3D_Surface8_Release)(LPVOID);
    HRESULT (__stdcall *pTextureFound)(const char*, LPVOID);
    HRESULT (__stdcall *pDumpTexture) (LPVOID, DWORD);
    BOOL    ignore_release;
    BOOL    searching;
    LPVOID  CurrentTexture;
    POINTER_DICTIONARY *Textures;
    POINTER_DICTIONARY *Surfaces;
    POINTER_DICTIONARY *__Replacements;
    HRESULT (__stdcall *CreatePixelShader)(LPDIRECT3DDEVICE8, const DWORD, DWORD*);
    HRESULT (__stdcall *SetPixelShader)(LPDIRECT3DDEVICE8, DWORD);
    HRESULT (__stdcall *DeletePixelShader)(LPDIRECT3DDEVICE8, DWORD);
    VOID (__stdcall *pShaderFound)(DWORD, LPVOID, DWORD, DWORD);
    DWORD   Override;
    BOOL    ignore_creation;
    BOOL    SearchingShader;
    LPVOID  CurrentShader;
    POINTER_DICTIONARY *Shaders;
    POINTER_DICTIONARY *Overrides;
    POINTER_DICTIONARY *DDI_Overrides;
    DWORD  SDumpsSize;
    LPVOID SDumps;
} D3D8HOOKS_DATA8;
extern D3D8HOOKS_DATA8 * D3D8HooksData;

extern IDirect3DResource8 * GetContainer8(IDirect3DSurface8 * s, REFIID id);
#endif // D3D8HOOKS_H



