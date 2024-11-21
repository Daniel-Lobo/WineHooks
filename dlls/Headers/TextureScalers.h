#ifndef TEXTURESCALERS_H
#define TEXTURESCALERS_H

#include <d3d9.h>
#include <string>
extern "C" {
#include "DDSurface.h"
}

struct DDS_HEADER_AND_MAGIC
{
    char            magic[4];
    uint32_t        size;
    uint32_t        flags;
    uint32_t        height;
    uint32_t        width;
    uint32_t        pitchOrLinearSize;
    uint32_t        depth; // only if DDS_HEADER_FLAGS_VOLUME is set in flags
    uint32_t        mipMapCount;
    uint32_t        reserved1[11];
    DDS_PIXELFORMAT ddspf;
    uint32_t        caps;
    uint32_t        caps2;
    uint32_t        caps3;
    uint32_t        caps4;
    uint32_t        reserved2;
};

typedef HRESULT (__stdcall *D3DX9SrfcFromFile)(LPDIRECT3DSURFACE9,const PALETTEENTRY*, const RECT*,
                                               LPCTSTR, const RECT*,DWORD, D3DCOLOR, LPVOID);
typedef HRESULT (__stdcall *D3DX9SrfcFromSrfc)(LPDIRECT3DSURFACE9,const PALETTEENTRY*,const RECT*,
                                               LPDIRECT3DSURFACE9,PALETTEENTRY*, const RECT*,DWORD,D3DCOLOR);
typedef HRESULT (__stdcall *D3DX9SaveSrfc)    (LPCTSTR, UINT, LPDIRECT3DSURFACE9,
                                               const PALETTEENTRY *, const RECT *);
typedef HRESULT (__stdcall *D3DX9SaveTexture) (LPCTSTR, UINT, LPDIRECT3DBASETEXTURE9,
                                               const PALETTEENTRY *);



class XBRZ {
public:
    XBRZ(void);
    void init(void);
    void err(char * err) {m_err.clear(); m_err.append(err);}
    void upscale(const wchar_t *, const wchar_t *, UINT, UINT);
    LPVOID LoadDDS(const wchar_t *, void **, UINT *, UINT *);
    void SaveDDS(const wchar_t *, UINT, UINT, BYTE*, BYTE*, BYTE*, BYTE*);
    std::string              m_err;
    HWND                    m_hwin = nullptr;
    IDirect3DDevice9      * m_d3d9 = nullptr;
    D3DX9SrfcFromFile SrfcFromFile = nullptr;
    D3DX9SrfcFromSrfc SrfcFromSrfc = nullptr;
    D3DX9SaveSrfc     SaveSrfc     = nullptr;
    D3DX9SaveTexture  SaveTexture  = nullptr;
};

#endif // TEXTURESCALERS_H
