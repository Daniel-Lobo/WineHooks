#include <string>
#include "TextureScalers.h"
#include <d3d9.h>
#include "FileSystem.h"
#include "xbrz.h"
extern "C" {
#include "DDSurface.h"
}

XBRZ::XBRZ()
{
    init();
}

void XBRZ::init()
{
    D3DPRESENT_PARAMETERS              p;
    HRESULT                           hr;
    err("Success");

    m_hwin = CreateWindow(L"STATIC", L"", WS_POPUP | WS_DISABLED, 0, 0, 1, 1, NULL, NULL, GetModuleHandle(NULL), NULL);
    if (m_hwin == nullptr)
    {
         return err("CreateWindow Failed");
    }
    ShowWindow(m_hwin, SW_HIDE);

    HMODULE hD3DX9 = LoadLibrary(L"d3dx9_43.dll");
    if (hD3DX9 == nullptr)
    {
         return err("Failed to load d3dx9_43.dll");
    }
    SrfcFromFile = (D3DX9SrfcFromFile)GetProcAddress(hD3DX9, "D3DXLoadSurfaceFromFileW");
    if (SrfcFromFile == nullptr)
    {
         return err("GetProcAddress(\"D3DXLoadSurfaceFromFile\") failed");
    }
    SrfcFromSrfc = (D3DX9SrfcFromSrfc)GetProcAddress(hD3DX9, "D3DXLoadSurfaceFromSurface");
    if (SrfcFromSrfc == nullptr)
    {
         return err("GetProcAddress(\"D3DXLoadSurfaceFromSurface\") failed");
    }
    SaveSrfc = (D3DX9SaveSrfc)GetProcAddress(hD3DX9, "D3DXSaveSurfaceToFileW");
    if (SaveSrfc == nullptr)
    {
         return err("GetProcAddress(\"D3DXSaveSurfaceToFile\") failed");
    }
    SaveTexture = (D3DX9SaveTexture)GetProcAddress(hD3DX9, "D3DXSaveTextureToFileW");
    if (SaveSrfc == nullptr)
    {
         return err("GetProcAddress(\"D3DXSaveSurfaceToFile\") failed");
    }
    IDirect3D9 * d3d = Direct3DCreate9(D3D_SDK_VERSION);
    if (d3d == nullptr)
    {
        return err("Direct3DCreate9 failed");
    }
    ZeroMemory(&p, sizeof(D3DPRESENT_PARAMETERS));
    p.BackBufferCount        = 1;
    p.BackBufferFormat       = D3DFMT_UNKNOWN;
    p.BackBufferHeight       = 1;
    p.BackBufferWidth        = 1;
    p.EnableAutoDepthStencil = FALSE;
    p.MultiSampleType        = D3DMULTISAMPLE_NONE;
    p.MultiSampleQuality     = 0;
    p.Windowed               = TRUE;
    p.SwapEffect             = D3DSWAPEFFECT_COPY;
    p.hDeviceWindow          = m_hwin;
    p.FullScreen_RefreshRateInHz = 0;
    p.PresentationInterval   = D3DPRESENT_INTERVAL_DEFAULT;

    hr = d3d->CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, nullptr, D3DCREATE_HARDWARE_VERTEXPROCESSING, &p, &m_d3d9);
    if (hr)
    {
        return err("Direct3D9::CreateDevice failed");
    }
    d3d->Release();
}

void XBRZ::upscale(const wchar_t * src, const wchar_t * dst, UINT scale, UINT rgb_output)
{
    OutputDebugStringW( (std::wstring(L"Upscaling ") + src + L" to " + dst).c_str() );
    char                         fmt[128];
    D3DFORMAT             in_fmt, out_fmt;
    xbrz::ColorFormat                cfmt;
    IDirect3DSurface9 * SD      = nullptr;
    IDirect3DSurface9 * HD      = nullptr;
    IDirect3DSurface9 * OutputS = nullptr;
    IDirect3DSurface9 * next    = nullptr;
    IDirect3DTexture9 * Output  = nullptr;
    HRESULT                            hr;
    D3DLOCKED_RECT         dstrct, srcrct;
    xbrz::ScalerCfg                   cfg;
    DWORD                         lvl = 0;

    HANDLE in = CreateFileW(src, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (in == INVALID_HANDLE_VALUE)  return err("CreateFileW failed");

    DDS_HEADER_AND_MAGIC hdds;
    BOOL success = ReadFile(in, &hdds, sizeof(DDS_HEADER), nullptr, nullptr);
    if (success == FALSE) return err("ReadFile failed");

    GetDDSFileFormat((DDS_HEADER*)&hdds.size, fmt);
    OutputDebugStringA( (std::string("Source file: ") + fmt + " " + std::to_string(hdds.width) + "x" +
                         std::to_string(hdds.height) ).c_str() );
    CloseHandle(in);

    in_fmt  = D3DFMT_A8R8G8B8;
    cfmt    = xbrz::ColorFormat::ARGB;
    DWORD FMT = *(DWORD*)fmt;
    if ( (FMT == *(DWORD*) "A8RGB") || (FMT == *(DWORD*) "A8BGR") || (FMT == *(DWORD*) "A4RGB") ||
         (FMT == *(DWORD*) "DXT2")  || (FMT == *(DWORD*) "DXT3")  || (FMT == *(DWORD*) "DXT4")  ||
         (FMT == *(DWORD*) "DXT5"))  out_fmt = rgb_output ? D3DFMT_A8R8G8B8 : D3DFMT_DXT5;
    else if ( (FMT == *(DWORD*) "X1RGB") || (FMT == *(DWORD*) "X8RGB") || (FMT == *(DWORD*) "A1RGB") ||
              (FMT == *(DWORD*) "RG8B")  || (FMT == *(DWORD*) "RG6B")  || (FMT == *(DWORD*) "DXT1"))
        out_fmt = rgb_output ? D3DFMT_X8R8G8B8 : D3DFMT_DXT1;
    else return err( (char*)(std::string("Format ") + fmt + " Not supported").c_str() );

    hr = m_d3d9->CreateOffscreenPlainSurface(hdds.width, hdds.height, in_fmt, D3DPOOL_SCRATCH, &SD, nullptr);
    if (hr)
    {
        err("Failed to create input surface");
        goto XBRZ_upscale_cleanup;
    }
    hr = m_d3d9->CreateOffscreenPlainSurface(hdds.width*scale, hdds.height*scale, in_fmt, D3DPOOL_SCRATCH, &HD, nullptr);
    if (hr)
    {
        err("Failed to create RGB surface");
        goto XBRZ_upscale_cleanup;
    }
    hr = m_d3d9->CreateTexture(hdds.width*scale, hdds.height*scale, 0, 0, out_fmt, D3DPOOL_SYSTEMMEM, &Output, nullptr);
    if (hr)
    {
        err("Failed to create Output texture");
        goto XBRZ_upscale_cleanup;
    }
    hr = SrfcFromFile(SD, nullptr, nullptr, src, nullptr, (1 << 0) /*D3DX_FILTER_NONE*/, 0, nullptr);
    if (hr)
    {
        err("Failed load surface");
        goto XBRZ_upscale_cleanup;
    }
    hr = SD->LockRect(&srcrct, nullptr, 0);
    if (hr)
    {
        err("Failed lock surface");
        goto XBRZ_upscale_cleanup;
    }
    hr = HD->LockRect(&dstrct, nullptr, 0);
    if (hr)
    {
        err("Failed lock surface");
        goto XBRZ_upscale_cleanup;
    }
    xbrz::scale(scale, (const uint32_t*)srcrct.pBits, (uint32_t*)dstrct.pBits, hdds.width, hdds.height, cfmt, cfg);
    SD->UnlockRect();
    HD->UnlockRect();
    hr = Output->GetSurfaceLevel(0, &OutputS);
    if (hr)
    {
        err("IDirect3DTexture9::GetSurfaceLevel failed");
        goto XBRZ_upscale_cleanup;
    }
    hr = SrfcFromSrfc(OutputS, nullptr, nullptr, HD, nullptr, nullptr, (1 << 0) /*D3DX_FILTER_NONE*/, 0);
    if (hr)
    {
        err("SrfcFromSrfc failed");
        goto XBRZ_upscale_cleanup;
    }
   
    OutputS->AddRef();
    while (Output->GetSurfaceLevel(lvl, &next) == 0)
    {
        SrfcFromSrfc(next, nullptr, nullptr, OutputS, nullptr, nullptr, (2 << 0) /*D3DX_FILTER_POINT*/, 0);
        OutputS->Release();
        OutputS = next;
        lvl += 1;
    }
    SaveTexture(dst, 4 /*D3DXIFF_DDS*/, Output, nullptr);

    XBRZ_upscale_cleanup:
    if (SD)     SD->Release();
    if (HD)     HD->Release();
    if (Output) Output->Release();
    if (OutputS) OutputS->Release();
    return;
}

LPVOID XBRZ::LoadDDS(const wchar_t * src, void ** pData, UINT * W, UINT * H)
{
    OutputDebugStringW( (std::wstring(L"Loading ") + src).c_str() );
    IDirect3DSurface9 * SD = nullptr;
    HRESULT                       hr;
    LPVOID             mem = nullptr;
    D3DLOCKED_RECT               rct;

    HANDLE in = CreateFileW(src, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (in == INVALID_HANDLE_VALUE)
    {
         err("CreateFileW failed");
         return 0;
    }

    DDS_HEADER_AND_MAGIC hdds;
    BOOL success = ReadFile(in, &hdds, sizeof(DDS_HEADER), nullptr, nullptr);
    if (success == FALSE)
    {
         err("ReadFile failed");
         return 0;
    }
    CloseHandle(in);

    hr = m_d3d9->CreateOffscreenPlainSurface(hdds.width, hdds.height, D3DFMT_A8B8G8R8, D3DPOOL_SCRATCH, &SD, nullptr);
    if (hr)
    {
        err("Failed to create input surface");
        goto XBRZ_LoadDDS_cleanup;
    }
    hr = SrfcFromFile(SD, nullptr, nullptr, src, nullptr, (1 << 0) /*D3DX_FILTER_NONE*/, 0, nullptr);
    if (hr)
    {
        err("Failed load surface");
        goto XBRZ_LoadDDS_cleanup;
    }
    if (SD->LockRect(&rct, nullptr, D3DLOCK_READONLY) == 0)
    {
        if (rct.Pitch != hdds.width*4)
        {
            err("BAD PITCH");
            SD->UnlockRect();
            goto XBRZ_LoadDDS_cleanup;
        }
        mem = malloc(rct.Pitch*hdds.height);
        *pData = mem;
        memcpy(mem, rct.pBits, rct.Pitch*hdds.height);
    }
    *W = hdds.width;
    *H = hdds.height;
    XBRZ_LoadDDS_cleanup:
    if (SD) SD->Release();
    return mem;
}

void XBRZ::SaveDDS(const wchar_t * file, UINT w, UINT h, BYTE* blue, BYTE* green, BYTE* red, BYTE* alpha)
{
    OutputDebugStringW( (std::wstring(L"Saving ") + file).c_str() );
    IDirect3DSurface9 * RGBSurface = nullptr;    
    HRESULT                               hr;
    D3DLOCKED_RECT                       rct;
    UINT                            line = 0;
    UINT                           pixel = 0;
    BYTE * a = 0;
    BYTE * b = 0;
    BYTE * g = 0;
    BYTE * r = 0;
    DWORD * pPixel = 0;

    hr = m_d3d9->CreateOffscreenPlainSurface(w, h, D3DFMT_A8R8G8B8, D3DPOOL_SCRATCH, &RGBSurface, nullptr);
    if (hr)
    {
        err("Failed to create input surface");
        goto XBRZ_SaveDDS_cleanup;
    }
    if (RGBSurface->LockRect(&rct, nullptr, 0))
    {
        err("SaveSrfc");
        goto XBRZ_SaveDDS_cleanup;
    }

    pPixel = (DWORD*)rct.pBits;
    /* The numpy slice that orininated these pointer are of dtype  uint8
     * However, numpy (or the compiler ?) seem to be padding those bytes
     * with a DWORD alignment. Attention to this workarround as it may
     * break in the future
     */
    a = (BYTE*) alpha;
    b = (BYTE*)blue;
    g = (BYTE*)green;
    r = (BYTE*)red;

    for (line=0; line<h; line++)    {

        for (pixel=0; pixel<w; pixel++)
        {
            *pPixel = (0xff000000 | *r<<16| *g<<8 | *b) ; //D3DFMT_A8B8G8R8
            pPixel += 1;
            a      += 1;
            b      += 1;
            g      += 1;
            r      += 1;
        }
    }
    RGBSurface->UnlockRect();
    hr = SaveSrfc(file, 4 /*D3DXIFF_DDS*/, RGBSurface, nullptr, nullptr);
    if (hr)
    {
        err("SaveSrfc");
        goto XBRZ_SaveDDS_cleanup;
    }

    XBRZ_SaveDDS_cleanup:
    if (RGBSurface) RGBSurface->Release();
}

extern "C" __declspec(dllexport) void __stdcall xBRzfree(void * p)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    free(p);
}

extern "C" __declspec(dllexport) const char* __stdcall xBRzUPscale(XBRZ * pxBRz, const wchar_t * src, const wchar_t * dst, UINT scale, UINT rgb)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    pxBRz->upscale(src, dst, scale, rgb);
    return pxBRz->m_err.c_str();
}

extern "C" __declspec(dllexport) const char* __stdcall xBRzCreate(XBRZ ** ppxBRz)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    XBRZ * pxBRz = new XBRZ();
    * ppxBRz = pxBRz;
    OutputDebugStringA( pxBRz->m_err.c_str() );
    return pxBRz->m_err.c_str();
}

extern "C" __declspec(dllexport) 
const char * __stdcall SaveDDS(XBRZ * pxBRz, const wchar_t * file, UINT w, UINT h, BYTE* alpha, BYTE* blue, BYTE* green, BYTE* red)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    pxBRz->SaveDDS(file, w, h, alpha, blue, green, red);
    return pxBRz->m_err.c_str();
}

extern "C" __declspec(dllexport) const char * __stdcall DDSToBGRA(XBRZ * pxBRz, const wchar_t *file, void ** pData, UINT * W, UINT * H)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    pxBRz->LoadDDS(file, pData, W, H);
    return pxBRz->m_err.c_str();
}
