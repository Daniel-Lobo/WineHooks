#include <directxmath.h>
#include <intrin.h>
#include <vector>
#define DIRECT3D_VERSION 0x700
#include <ddraw.h>
//#include <d3d.h>
#include "D3DHooks.h"

#include "D3D12Hooks.h"
#include <string>
#include "Dbug.h"
#include "dllmain.h"
#include <memory>
#include <stdint.h>
extern "C" {
#include "Scalers.h"
#include "DDSurface.h"
}

void LogDDSrfacePxFormat(IUnknown * i)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD fmt = GetDDSrfacePxFormat(i);
    DBUG_WARN((char*)&fmt);
}

DWORD GetDDSrfacePxFormat(IUnknown * i)
{
    IDirectDrawSurface * s =                nullptr;
    DDSURFACEDESC        d = {sizeof(DDSURFACEDESC)};
    if (D3DHooksData->QuerySurface((LPVOID)i, IID_IDirectDrawSurface, (LPVOID*)&s))
    {
        DBUG_WARN("D3DHooksData->QuerySurface(IID_IDirectDrawSurface) FAILED");
        return 0;
    }
    if (s->GetSurfaceDesc(&d))
    {
        DBUG_WARN("::GetSuraceDesc FAILED");
        return 0;
    }

    if (d.ddpfPixelFormat.dwFlags & DDPF_FOURCC)
    {
        if      (d.ddpfPixelFormat.dwFourCC == MAKEFOURCC('D','X','T','1')) return *(DWORD*) "DXT1";
        else if (d.ddpfPixelFormat.dwFourCC == MAKEFOURCC('D','X','T','2')) return *(DWORD*) "DXT2";
        else if (d.ddpfPixelFormat.dwFourCC == MAKEFOURCC('D','X','T','3')) return *(DWORD*) "DXT3";
        else if (d.ddpfPixelFormat.dwFourCC == MAKEFOURCC('D','X','T','4')) return *(DWORD*) "DXT4";
        else if (d.ddpfPixelFormat.dwFourCC == MAKEFOURCC('D','X','T','5')) return *(DWORD*) "DXT5";
    }
    else if (d.ddpfPixelFormat.dwRGBBitCount == 32)
    {
        if (d.ddpfPixelFormat.dwFlags & DDPF_RGB)
        {
            if (d.ddpfPixelFormat.dwRBitMask == 0x00FF0000)
                return d.ddpfPixelFormat.dwFlags & DDPF_ALPHAPIXELS ? *(DWORD*) "A8RGB" : *(DWORD*) "X8RGB";
            if (d.ddpfPixelFormat.dwRBitMask == 0x000000FF)
                return d.ddpfPixelFormat.dwFlags & DDPF_ALPHAPIXELS ? *(DWORD*) "A8BGR" : *(DWORD*) "X8BGR";
        } else if (d.ddpfPixelFormat.dwFlags & DDPF_BUMPDUDV)
            return d.ddpfPixelFormat.dwFlags & DDPF_BUMPLUMINANCE ? *(DWORD*) "L6V5U5" : *(DWORD*) "V8U8";
    } else if(d.ddpfPixelFormat.dwRGBBitCount == 16)
    {
        if (d.ddpfPixelFormat.dwFlags & DDPF_RGB)
        {
             if      (d.ddpfPixelFormat.dwRBitMask == 0xF800)     return *(DWORD*) "RG6B";
             else if (d.ddpfPixelFormat.dwRBitMask == 0xf00)      return *(DWORD*) "A4RGB";
             else if (d.ddpfPixelFormat.dwRBitMask == 0x00007C00)
                 return d.ddpfPixelFormat.dwFlags & DDPF_ALPHAPIXELS ? *(DWORD*) "A1RGB" : *(DWORD*) "X1RGB";
        }
    }
    else if(d.ddpfPixelFormat.dwRGBBitCount == 8)
    {
        return d.ddpfPixelFormat.dwFlags & (DDPF_RGB | DDPF_PALETTEINDEXED8) ? *(DWORD*) "PAL8" :
        d.ddpfPixelFormat.dwFlags & DDPF_ALPHA ? *(DWORD*) "_A8_" : *(DWORD*) "?????";
    }
    return *(DWORD*) "?????";
}

BOOL SetDDSurfacePixelFormat(DDPIXELFORMAT * DDPixelformat, char * format)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (DDPixelformat == NULL) return 1;
    if (*(BYTE*)format == *(BYTE*)"D")
    {
        DDPixelformat->dwFlags  = DDPF_FOURCC;
        DDPixelformat->dwFourCC = *(DWORD*) format;
    }
    if ( strcmp(format, "A8") == 0 )
    {
        DWORD A8[4]                    = {0, 0, 0, 0xFF};
        DDPixelformat->dwFlags         = DDPF_ALPHA;
        DDPixelformat->dwRGBBitCount   = 8;
        memcpy(&DDPixelformat->dwRBitMask, A8, sizeof(DWORD)*4);
        return 0;
    }else if ( strcmp(format, "RG6B") == 0 )
    {
        DWORD RG6B[4]                  = {0xF800, 0x07e0, 0x001F, 0};
        DDPixelformat->dwFlags         = DDPF_RGB;
        DDPixelformat->dwRGBBitCount  = 16;
        memcpy(&DDPixelformat->dwRBitMask, RG6B, sizeof(DWORD)*4);
        return 0;
    } else if ( strcmp(format, "X1RGB") == 0 )
    {
        DWORD X1RGB[4]                 = {0x00007C00, 0x000003E0, 0x0000001F, 0};
        DDPixelformat->dwFlags         = DDPF_RGB;
        DDPixelformat->dwRGBBitCount   = 16;
        memcpy(&DDPixelformat->dwRBitMask, X1RGB, sizeof(DWORD)*4);
        return 0;
    } else if ( strcmp(format, "A1RGB") == 0 )
    {
        DWORD A1RGB[4]                 = {0x00007C00, 0x000003E0, 0x0000001F, 0x00008000};
        DDPixelformat->dwFlags         = DDPF_RGB | DDPF_ALPHAPIXELS;
        DDPixelformat->dwRGBBitCount   = 16;
        memcpy(&DDPixelformat->dwRBitMask, A1RGB, sizeof(DWORD)*4);
        return 0;
    } else if ( strcmp(format, "A4RGB") == 0 )
    {
        DWORD A4RGB[4]                 = {0x0f00, 0x00f0, 0x000f, 0xf000};
        DDPixelformat->dwFlags         = DDPF_RGB | DDPF_ALPHAPIXELS;
        DDPixelformat->dwRGBBitCount   = 16;
        memcpy(&DDPixelformat->dwRBitMask, A4RGB, sizeof(DWORD)*4);
        return 0;
    } else if ( strcmp(format, "A8RGB") == 0 )
    {
        DWORD A8RGB[4]                 = {0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000};
        DDPixelformat->dwFlags         = DDPF_RGB | DDPF_ALPHAPIXELS;
        DDPixelformat->dwRGBBitCount   = 32;
        memcpy(&DDPixelformat->dwRBitMask, A8RGB, sizeof(DWORD)*4);
        return 0;
    } else if ( strcmp(format, "X8RGB") == 0 )
    {
        DWORD X8RGB[4]                 = {0x00FF0000, 0x0000FF00, 0x000000FF, 0};
        DDPixelformat->dwFlags         = DDPF_RGB;
        DDPixelformat->dwRGBBitCount   = 32;
        memcpy(&DDPixelformat->dwRBitMask, X8RGB, sizeof(DWORD)*4);
        return 0;
    } else if ( strcmp(format, "V8U8") == 0 )
    {
        DWORD V8U8[4]                  = {0xFF, 0xFF00, 0, 0};
        DDPixelformat->dwFlags         = DDPF_BUMPDUDV;
        DDPixelformat->dwRGBBitCount   = 16;
        memcpy(&DDPixelformat->dwRBitMask, V8U8, sizeof(DWORD)*4);
        return 0;
    } else if ( strcmp(format, "PAL8") == 0 )
    {
        DWORD PAL8[4]                  = {0, 0, 0, 0};
        DDPixelformat->dwFlags         = DDPF_RGB | DDPF_PALETTEINDEXED8;
        DDPixelformat->dwRGBBitCount   = 8;
        memcpy(&DDPixelformat->dwRBitMask, PAL8, sizeof(DWORD)*4);
        return 0;
    }
    return TRUE;
}

typedef HRESULT (STDMETHODCALLTYPE * _CREATESURFACE)(LPVOID, LPVOID, LPVOID, LPVOID);
HRESULT CreateSurfaceHook(LPVOID p1, DDSURFACEDESC * OrigDesc, LPVOID p3, LPVOID p4,
                          _CREATESURFACE createsurface, D3DHOOKS_DATA * cfg,
                          DWORD * err)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (OrigDesc == NULL) return 0;
    DDSURFACEDESC2 DESC;
    DDSURFACEDESC *Desc = (DDSURFACEDESC*)&DESC;
    memcpy(Desc, OrigDesc, OrigDesc->dwSize);

    DWORD caps = (DWORD)Desc->ddsCaps.dwCaps;
    if (caps & DDSCAPS_ZBUFFER)
    {
        if (Desc->dwSize == sizeof(DDSURFACEDESC2))
        {
            DDSURFACEDESC2 * D2 = (DDSURFACEDESC2 *)Desc;
            D3DHooksData->zmask = D2->ddpfPixelFormat.dwGBitMask;
        } else {
            if     (Desc->dwZBufferBitDepth==16) D3DHooksData->zmask = 0xffff;
            else if(Desc->dwZBufferBitDepth==24) D3DHooksData->zmask = 0xffffff00;
            else if(Desc->dwZBufferBitDepth==32) D3DHooksData->zmask = 0xffffffff;
        }
    }
    if (caps & DDSCAPS_PRIMARYSURFACE)
    {
        if (cfg->NEFS)
        {
            Desc->dwFlags &= ~ DDSD_BACKBUFFERCOUNT;
            if (caps & DDSCAPS_COMPLEX)
                Desc->ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;
        }
    }
    if ((cfg->_32Bit) && !(Desc->dwFlags & DDSD_PIXELFORMAT)
        && ! (caps & DDSCAPS_PRIMARYSURFACE)
        && ! (caps & DDSCAPS_ZBUFFER) )
    {
            char * format;
            if      (cfg->Requested_Depth == 16) format = "RG6B";
            else if (cfg->Requested_Depth == 8)  format = "PAL8";
            else                                 format = "X8RGB";
            SetDDSurfacePixelFormat((DDPIXELFORMAT *)&Desc->ddpfPixelFormat, format);
            Desc->dwFlags |= DDSD_PIXELFORMAT;
            if (!(Desc->ddsCaps.dwCaps & DDSCAPS_TEXTURE)   &&
                !(Desc->ddsCaps.dwCaps & DDSCAPS_RESERVED2) &&
                !(Desc->ddpfPixelFormat.dwRGBBitCount == 8) )
            {
                if (Desc->ddsCaps.dwCaps == DDSCAPS_SYSTEMMEMORY)
                Desc->ddsCaps.dwCaps |= DDSCAPS_OFFSCREENPLAIN;
            }
    }
    if ((cfg->_32Bit) && (Desc->ddpfPixelFormat.dwRGBBitCount == 8))
        Desc->ddsCaps.dwCaps = DDSCAPS_SYSTEMMEMORY | DDSCAPS_OFFSCREENPLAIN;
    if      (caps & DDSCAPS_PRIMARYSURFACE) *err = 1;
    else if (caps & DDSCAPS_TEXTURE)        *err = 3;
    else if (caps & DDSCAPS_ZBUFFER)        *err = 2;
    HRESULT   r = createsurface(p1, Desc, p3, p4);
    if (r) return createsurface(p1, OrigDesc, p3, p4);
    return r;
}

HRESULT IDirectDrawGetCapsHook(LPVOID dd, LPVOID DriverCaps, LPVOID HELCaps)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    typedef HRESULT (__stdcall * DDGetCapsType)(LPVOID, LPVOID, LPVOID);
    DDGetCapsType getcps = D3DHooksData->IDirectDraw_GetCaps;
    HRESULT hr = getcps(dd, DriverCaps, HELCaps);
    if (hr) return 0;

    DDCAPS * cps = (DDCAPS*)DriverCaps;
    cps->dwVidMemTotal = 32*1024*1024;
    cps->dwVidMemFree  = 16*1024*1024;
    return hr;
}

HRESULT STDMETHODCALLTYPE GetAttachedSurfaceHook(LPVOID srfc, DWORD cps, DWORD att)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDLOCK();
    LPVOID ret = _ReturnAddress();
    if (g_.IsGameModule(ret) == 0)
    {
        DBUG_WARN("SYS_CALL");
        return D3DHooksData->IDDSrfcGetAttachedSrfc(srfc, cps, att);
    }
    return D3DHooksData->AHK_IDDSrfcGetAttachedSrfc(srfc, cps, att);
}

HRESULT STDMETHODCALLTYPE GetAttachedSurface4Hook(LPVOID srfc, DWORD cps, DWORD att)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDLOCK();
    LPVOID ret = _ReturnAddress();
    if (g_.IsGameModule(ret) == 0)
    {
        DBUG_WARN("SYS_CALL");
        return D3DHooksData->IDDSrfc4GetAttachedSrfc(srfc, cps, att);
    }
    return D3DHooksData->AHK_IDDSrfc4GetAttachedSrfc(srfc, cps, att);
}

HRESULT GetDDSurfaceLevel(IUnknown * i)
{
    /* Currently only returns zero for the top level or a value bigger then zero for all others */
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirectDrawSurface4 * s4           = nullptr;
    IUnknown            * private_data = nullptr;
    DWORD              private_data_sz = sizeof(IUnknown*);

    if (D3DHooksData->QuerySurface((LPVOID)i, IID_IDirectDrawSurface4, (LPVOID*)&s4))
    {
        DBUG_WARN("D3DHooksData->QuerySurface(IID_IDirectDrawSurface4) FAILED");
        return 0;
    }
    HRESULT hr = s4->GetPrivateData((GUID &)g_.DDrawSurfaceData, &private_data, &private_data_sz);
    //s4->FreePrivateData((GUID &)g_.DDrawSurfaceData);
    if (s4)           s4->Release();
    if (private_data) private_data->Release();
    return hr;
}

HRESULT DDSurfaceAttachData(LPVOID * i)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirectDrawSurface4 * s4 = nullptr;
    IUnknown            * s  = (IUnknown*) i;

    if (D3DHooksData->QuerySurface((LPVOID)s, IID_IDirectDrawSurface4, (LPVOID*)&s4))
    {
        DBUG_WARN("D3DHooksData->QuerySurface(IID_IDirectDrawSurface4) FAILED");
        return 0;
    }
    if (s4->SetPrivateData((GUID &)g_.DDrawSurfaceData, dynamic_cast<IUnknown*>(new DDrawSurfaceData(s)),
                           sizeof(IUnknown*), DDSPD_IUNKNOWNPOINTER))
    {
        DBUG_WARN("SetPrivateData FAILED ");
        return 0;
    }
    s4->Release();
    return 0;
}

DWORD GetSurface4ID(LPVOID surf4)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDSCAPS2 cp2;
    D3DHooksData->GetDDSCaps(surf4, &cp2);
    if (cp2.dwCaps2 & DDSCAPS2_HINTDYNAMIC)
    return 0;

    DWORD   ID = 0;
    IUnknown * IID;
    if (S_OK != D3DHooksData->pIDirectDrawSurface_QueryInterface(surf4, (GUID*)&IID_IUnknown, (LPVOID*)&IID))
    return 0;

    ID = (DWORD)IID;
    IID->Release();
    return ID;
}

DWORD GetTexture2ID(LPVOID surf4)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (surf4 == 0)
    return 0;

    DWORD ID   = 0;
    IUnknown * IID;
    if (S_OK != D3DHooksData->pIDirect3DTexture2_QueryInterface(surf4, (GUID*)&IID_IUnknown, (LPVOID*)&IID))
    return 0;

    ID =(DWORD)IID;
    IID->Release();
    return ID;
}

DWORD GetTextureID(LPVOID surf4)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (surf4 == 0)
    return 0;

    DWORD   ID = 0;
    IUnknown * IID;
    if (S_OK != D3DHooksData->pIDirect3DTexture_QueryInterface(surf4, (GUID*)&IID_IUnknown, (LPVOID*)&IID))
    return 0;

    ID =(DWORD)IID;
    IID->Release();
    return ID;
}

HRESULT STDMETHODCALLTYPE _Lock4Hook(LPVOID surf4, LPRECT rect, DDSURFACEDESC2* desc,
                                     DWORD flags, HANDLE hwnd)
{
    #pragma comment(linker, "/EXPORT:" "Lock4_Hook" "=" __FUNCDNAME__)
    HRESULT err = D3DHooksData->IDirectDrawSurace_Lock(surf4, rect, (LPVOID)desc, flags, hwnd);
    DWORD ID    = GetSurface4ID(surf4);
    LPVOID tex  = D3DHooksData->textures->Value((LPVOID)ID);
    D3DHooksData->found->discard((LPVOID)ID);
    if ( D3DHooksData->replacements->Value(tex) )
    {
        IUnknown * IID = (IUnknown *) tex;
        IID->AddRef();  IID->Release();
    }
    if ( !(err) && !(rect) && (ID) )
    {
        DDSURFACEDESC2 * lock = (DDSURFACEDESC2 *)
                                 VirtualAlloc(NULL, sizeof(DDSURFACEDESC2),0x1000|0x2000,PAGE_READWRITE);
        lock->dwFlags                           = (DWORD)ID;
        lock->dwHeight                          = desc->dwHeight;
        lock->dwWidth                           = desc->dwWidth;
        lock->lPitch                            = desc->lPitch;
        lock->lpSurface                         = desc->lpSurface;
        lock->ddpfPixelFormat.dwRGBBitCount     = desc->ddpfPixelFormat.dwRGBBitCount;
        lock->ddpfPixelFormat.dwFlags           = desc->ddpfPixelFormat.dwFlags;
        lock->ddpfPixelFormat.dwFourCC          = desc->ddpfPixelFormat.dwFourCC;
        lock->ddpfPixelFormat.dwRBitMask        = desc->ddpfPixelFormat.dwRBitMask;
        lock->ddpfPixelFormat.dwGBitMask        = desc->ddpfPixelFormat.dwGBitMask;
        lock->ddpfPixelFormat.dwBBitMask        = desc->ddpfPixelFormat.dwBBitMask;
        lock->ddpfPixelFormat.dwRGBAlphaBitMask = desc->ddpfPixelFormat.dwRGBAlphaBitMask;
        locks->insert(surf4, lock);
    }
    return err;
}

HRESULT STDMETHODCALLTYPE Lock4Hook(LPVOID surf4, LPRECT rect, DDSURFACEDESC2* desc,
                                    DWORD flags, HANDLE hwnd)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDSCAPS2 c2 = {0,0,0,0};
    D3DHooksData->GetDDSCaps(surf4, &c2);
    DWORD managed  = ((c2.dwCaps2 & DDSCAPS2_TEXTUREMANAGE) || (c2.dwCaps2 & DDSCAPS2_D3DTEXTUREMANAGE));
    DWORD sys      = ((c2.dwCaps & DDSCAPS_SYSTEMMEMORY) && (!managed));
    DWORD vid      = ((c2.dwCaps & DDSCAPS_VIDEOMEMORY)  && (!D3DHooksData->check_vid_mem_locks));
    if (sys || vid)
    {
        DWORD ID    = GetSurface4ID(surf4);
        LPVOID tex  = D3DHooksData->textures->Value((LPVOID)ID);
        D3DHooksData->found->discard((LPVOID)ID);
        D3DHooksData->found->discard((LPVOID)surf4);
        if ( D3DHooksData->replacements->Value(tex) )
        {
            IUnknown * IID = (IUnknown *) tex;
            IID->AddRef();  IID->Release();
        }
        return D3DHooksData->IDirectDrawSurace_Lock(surf4, rect, (LPVOID)desc, flags, hwnd);
    }
    return _Lock4Hook(surf4, rect, desc, flags, hwnd);
}

HRESULT STDMETHODCALLTYPE UnLock4Hook(LPVOID surf4, LPRECT rect)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDSCAPS2   caps2;
    DDSURFACEDESC2 * lock;
    if ( (lock = (DDSURFACEDESC2*)locks->Value(surf4)) )
    {
        DWORD fmt = GetDDSrfacePxFormat((IUnknown*)surf4);
        std::string * s
                = g_.FindTexture(lock->dwWidth, lock->dwHeight, lock->lPitch, (char*)&fmt, (byte*)lock->lpSurface);
        if (s)
        {
            DBUG_WARN(s->c_str());
            D3DHooksData->Surface_Found((LPVOID)lock->dwFlags, (DWORD)s->c_str());
        } else if (D3DHooksData->DumpAndAppend)
        {
            HRESULT hr = D3DHooksData->IDirectDrawSurace_UnLock(surf4, rect);
            D3DHooksData->GetDDSCaps(surf4, &caps2);
            DWORD managed = ((caps2.dwCaps2 & DDSCAPS2_TEXTUREMANAGE)  ||
                             (caps2.dwCaps2 & DDSCAPS2_D3DTEXTUREMANAGE));
            if ((caps2.dwCaps & DDSCAPS_VIDEOMEMORY) || managed)
                D3DHooksData->DumpAndAppend((IUnknown*)surf4, (IUnknown*)surf4);
            locks->remove(surf4);
            return hr;
        }
        locks->remove(surf4);
    }
    return D3DHooksData->IDirectDrawSurace_UnLock(surf4, rect);
}

DWORD GetSurfaceID(LPVOID surf2)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD caps;
    D3DHooksData->GetDDSCaps(surf2, &caps);

    DWORD   ID = 0;
    IUnknown * IID;
    if (D3DHooksData->pIDirectDrawSurface_QueryInterface(surf2, (GUID*)&IID_IUnknown, (LPVOID*)&IID))
    return 0;

    ID =(DWORD)IID;
    IID->Release();
    return ID;
}

HRESULT STDMETHODCALLTYPE _LockHook(LPVOID surf2, LPRECT rect, DDSURFACEDESC2* desc,
                                    DWORD flags, HANDLE hwnd)
{
    #pragma comment(linker, "/EXPORT:" "Lock_Hook" "=" __FUNCDNAME__)
    HRESULT err;
    if (err = D3DHooksData->IDirectDrawSurace_Lock(surf2, rect, desc, flags, hwnd))
    return err;
    DWORD ID    = GetSurfaceID(surf2);
    D3DHooksData->SwapBack(ID);
    if ( !(err) && !(rect) && (ID) )
    {
        DDSURFACEDESC2 * lock = (DDSURFACEDESC2 *)
                                 VirtualAlloc(NULL, sizeof(DDSURFACEDESC2) ,0x1000|0x2000,PAGE_READWRITE);
        lock->dwFlags                           = (DWORD)ID;
        lock->dwHeight                          = desc->dwHeight;
        lock->dwWidth                           = desc->dwWidth;
        lock->lPitch                            = desc->lPitch;
        lock->lpSurface                         = desc->lpSurface;
        lock->ddpfPixelFormat.dwRGBBitCount     = desc->ddpfPixelFormat.dwRGBBitCount;
        lock->ddpfPixelFormat.dwFlags           = desc->ddpfPixelFormat.dwFlags;
        lock->ddpfPixelFormat.dwFourCC          = desc->ddpfPixelFormat.dwFourCC;
        lock->ddpfPixelFormat.dwRBitMask        = desc->ddpfPixelFormat.dwRBitMask;
        lock->ddpfPixelFormat.dwGBitMask        = desc->ddpfPixelFormat.dwGBitMask;
        lock->ddpfPixelFormat.dwBBitMask        = desc->ddpfPixelFormat.dwBBitMask;
        lock->ddpfPixelFormat.dwRGBAlphaBitMask = desc->ddpfPixelFormat.dwRGBAlphaBitMask;
        locks->insert(surf2, lock);
    }
    return err;
}

HRESULT STDMETHODCALLTYPE LockHook(LPVOID surf2, LPRECT rect, DDSURFACEDESC2* desc,
                                   DWORD flags, HANDLE hwnd)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD cps;
    D3DHooksData->GetDDSCaps(surf2, &cps);
    if ( cps & DDSCAPS_SYSTEMMEMORY )
    {
        DWORD ID    = GetSurfaceID(surf2);
        D3DHooksData->SwapBack(ID);
        return D3DHooksData->IDirectDrawSurace_Lock(surf2, rect, desc, flags, hwnd);
    }
    return _LockHook(surf2, rect, desc, flags, hwnd);
}

HRESULT STDMETHODCALLTYPE UnLockHook(LPVOID surf2, LPRECT rect)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDSURFACEDESC2 * lock;
    if ( (lock = (DDSURFACEDESC2*)locks->Value(surf2)) )
    {
       DWORD fmt = GetDDSrfacePxFormat((IUnknown*)surf2);
       std::string * s
               = g_.FindTexture(lock->dwWidth, lock->dwHeight, lock->lPitch, (char*)&fmt, (byte*)lock->lpSurface);
       if (s)
       {
           DBUG_WARN(s->c_str());
           D3DHooksData->Surface_Found((LPVOID)lock->dwFlags, (DWORD)s->c_str());
       }
       locks->remove(surf2);
    }
    return D3DHooksData->IDirectDrawSurace_UnLock(surf2, rect);
}

class HANDLESWAP1 {
public:
    HANDLESWAP1(LPVOID dev, D3DTEXTUREHANDLE handle)
    {
        if (g_d3d.DBUG)
        {
            SHORT down = 0; //GetKeyState(VK_SHIFT) & 0x8000 ;
            if (down)
            {
                m_dev = (IDirect3DDevice *) dev;
                m_tex = (IDirect3DTexture *) D3DHooksData->hTex->Key((LPVOID)handle);
                m_rep = (IDirect3DTexture *) D3DHooksData->replacements->Value(m_tex);
                Swap();
            }
        }
    }
    ~HANDLESWAP1(){
        if (m_dev && m_tex && m_rep)
            m_dev->SwapTextureHandles(m_tex, m_rep);
    }
    void Swap() {
        if (m_dev && m_tex && m_rep)
            m_dev->SwapTextureHandles(m_rep, m_tex);
    }
    IDirect3DDevice  * m_dev = nullptr;
    IDirect3DTexture * m_tex = nullptr;
    IDirect3DTexture * m_rep = nullptr;
};

HRESULT STDMETHODCALLTYPE IDirect3DDevice_ExecuteHook(LPVOID dev, LPVOID buff,
                                                      DWORD dummy, LPVOID dummyb)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    //auto view_scaler = std::unique_ptr<D3DViewportScaler>( new D3DViewportScaler((IDirect3DViewport*)dummy) );
    XYZRHW                     *v;
    D3DINSTRUCTION * pInstruction;
    D3DEXECUTEDATA           eData = {sizeof(D3DEXECUTEDATA)      };
    D3DEXECUTEBUFFERDESC eBuffDesc = {sizeof(D3DEXECUTEBUFFERDESC)};
    IDirect3DExecuteBuffer * eBuff = (IDirect3DExecuteBuffer*) buff;

    if (IDirect3DExecuteBuffer_GetExecuteData(eBuff, &eData)) DBUG_WARN( "=========" );
    IDirect3DExecuteBuffer_Lock(eBuff, &eBuffDesc);

    pInstruction = (D3DINSTRUCTION*) ((DWORD)eBuffDesc.lpData + eData.dwInstructionOffset);
    while (pInstruction->bOpcode != D3DOP_EXIT)
    {
        if (pInstruction->bOpcode == D3DOP_STATETRANSFORM)
        {
            IDirect3DExecuteBuffer_Unlock(eBuff);
            return D3DHooksData->Execute(dev, (DWORD)buff, dummy, dummyb);
        } else if (pInstruction->bOpcode == D3DOP_PROCESSVERTICES)
        {
            D3DPROCESSVERTICES * pV =
                    (D3DPROCESSVERTICES *) ((DWORD)pInstruction +4 );
            if ( (pV->dwFlags & D3DPROCESSVERTICES_TRANSFORM)     ||
                 (pV->dwFlags & D3DPROCESSVERTICES_TRANSFORMLIGHT))
            {
                IDirect3DExecuteBuffer_Unlock(eBuff);
                return D3DHooksData->Execute(dev, (DWORD)buff, dummy, dummyb);
            }

        }
        pInstruction = (D3DINSTRUCTION*)
                ((DWORD)pInstruction + pInstruction->bSize * pInstruction->wCount);
        pInstruction = (D3DINSTRUCTION*)((DWORD)pInstruction + 4);
    }
    DWORD nvertex = eData.dwVertexCount;
    if (nvertex == 0) /*workarround for dark vengeance where dwVertexCount == 0;*/
        nvertex = (eData.dwInstructionOffset-eData.dwVertexOffset)/sizeof(TLVERTEX);
    v = (XYZRHW *) ((DWORD)eBuffDesc.lpData + eData.dwVertexOffset);
    scale_and_displace(v, nvertex, sizeof(TLVERTEX));
    IDirect3DExecuteBuffer_Unlock(eBuff);
    return D3DHooksData->Execute(dev, (DWORD)buff, dummy, dummyb);
}

HRESULT STDMETHODCALLTYPE TsExecute(LPVOID dev, LPVOID buff,  DWORD dummy, LPVOID dummyb)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirect3DExecuteBuffer * eBuff = (IDirect3DExecuteBuffer *) buff;
    D3DINSTRUCTION         * pInstruction;
    D3DEXECUTEDATA           eData = {sizeof(D3DEXECUTEDATA)      };
    D3DEXECUTEBUFFERDESC eBuffDesc = {sizeof(D3DEXECUTEBUFFERDESC)};
    struct d3dstate {DWORD State, Value;};
    d3dstate   * s = nullptr;
    std::vector<HANDLESWAP1*> Swap;

    eBuff->GetExecuteData(&eData);
    eBuff->Lock(&eBuffDesc);
    pInstruction = (D3DINSTRUCTION*) ((DWORD)eBuffDesc.lpData + eData.dwInstructionOffset);
    while (pInstruction->bOpcode != D3DOP_EXIT)
    {
        if (pInstruction->bOpcode == 8)
        {
            s = (d3dstate*) ((DWORD)pInstruction+4);
            for (DWORD i=1; i<=pInstruction->wCount; i++)
            {
                if ((s->State == 1) && s->Value)
                {
                    Swap.push_back(new HANDLESWAP1(dev, s->Value));
                    if (D3DHooksData->search_enabled && s->Value == D3DHooksData->current_texture)
                    {
                        s->Value = 0;
                    }
                }
                s = (d3dstate*) ((DWORD)s+pInstruction->bSize);
            }
        }
        pInstruction = (D3DINSTRUCTION*)((DWORD)pInstruction + pInstruction->bSize * pInstruction->wCount);
        pInstruction = (D3DINSTRUCTION*)((DWORD)pInstruction + 4);
    }

    eBuff->Unlock();
    HRESULT hr = D3DHooksData->TswapExecute(dev, (DWORD)buff, dummy, dummyb);
    if (Swap.size())
    {
        HANDLESWAP1 * swap = nullptr;
        for(UINT i=0; i<Swap.size(); i++)
        {
            swap = Swap[i];
            if (swap) delete swap;
        }
    } Swap.clear();
    return hr;
}

class HANDLESWAP2 {
public:
    HANDLESWAP2(LPVOID dev)
    {
        if (g_d3d.DBUG)
        {
            SHORT down = 0; // GetKeyState(VK_SHIFT) & 0x8000;
            if (down)
            {
                D3DTEXTUREHANDLE handle = NULL;
                m_dev = (IDirect3DDevice2 *) dev;
                if (m_dev) {
                    m_dev->GetRenderState(D3DRENDERSTATE_TEXTUREHANDLE, &handle);
                }
                m_tex = (IDirect3DTexture2 *) D3DHooksData->hTex->Key((LPVOID)handle);
                m_rep = (IDirect3DTexture2 *) D3DHooksData->replacements->Value(m_tex);
                Swap();
            }
        }
    }
    ~HANDLESWAP2(){
        if (m_dev && m_tex && m_rep)
            m_dev->SwapTextureHandles(m_tex, m_rep);
    }
    void Swap() {
        if (m_dev && m_tex && m_rep)
            m_dev->SwapTextureHandles(m_rep, m_tex);
    }
    IDirect3DDevice2  * m_dev = nullptr;
    IDirect3DTexture2 * m_tex = nullptr;
    IDirect3DTexture2 * m_rep = nullptr;
};

HRESULT STDMETHODCALLTYPE DrawPrimitive2Hook(LPVOID pIDirect3DDevice2, DWORD dptPrimitiveType,
                                             DWORD dvtVertexType, LPVOID lpvVertices,
                                             DWORD dwVertexCount, DWORD dwFlags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HANDLESWAP2 swap((LPVOID)pIDirect3DDevice2);

    if (dptPrimitiveType == 1) DBUG_WARN("POINTS=======================================");
    XYZRHW * vertice = (XYZRHW *)lpvVertices;
    HRESULT hr;
    if (dvtVertexType == D3DVT_TLVERTEX)
    {
        if (D3DHooksData->fix_screencoords == TRUE) scale_displace_and_fixcoords(vertice, dwVertexCount, sizeof(TLVERTEX));
        else                                        scale_and_displace(vertice, dwVertexCount, sizeof(TLVERTEX));
        if (D3DHooksData->callback)
        {
           if (D3DHooksData->vertexTransformCallback2(pIDirect3DDevice2, dwVertexCount, lpvVertices))
           return 0;
        }
    }
    hr = D3DHooksData->pIDirect3DDevice2_DrawPrimitive(pIDirect3DDevice2, dptPrimitiveType,
                                                       dvtVertexType, lpvVertices,
                                                       dwVertexCount, dwFlags);
    return hr;
}

HRESULT STDMETHODCALLTYPE DrawIndexedPrimitive2Hook(LPVOID pIDirect3DDevice2,
                                                    DWORD d3dptPrimitiveType,
                                                    DWORD dwVertexType, LPVOID lpvVertices,
                                                    DWORD dwVertexCount, LPWORD lpwIndices,
                                                    DWORD dwIndexCount, DWORD dwFlags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HANDLESWAP2 swap((LPVOID)pIDirect3DDevice2);

    HRESULT hr;
    XYZRHW * vertice = (XYZRHW *)lpvVertices;
    WORD   * pIndex;
    if (dwVertexType == D3DVT_TLVERTEX)
    {
        vertice = (XYZRHW*)D3DHooksData->vextex_data;
        pIndex  = lpwIndices;
        if (D3DHooksData->fix_screencoords == TRUE) scale_displace_and_fixcoords_indexed(vertice, (XYZRHW*)lpvVertices, pIndex,
                                                                                         dwIndexCount, sizeof(TLVERTEX));
        else scale_and_displace_indexed(vertice, (XYZRHW*)lpvVertices, pIndex, dwIndexCount, sizeof(TLVERTEX));

        hr = D3DHooksData->pIDirect3DDevice2_DrawPrimitive(pIDirect3DDevice2, d3dptPrimitiveType, dwVertexType,
                                                           D3DHooksData->vextex_data, dwIndexCount, dwFlags);
        return hr;
    }
    hr = D3DHooksData->pIDirect3DDevice3_DrawIndexedPrimitive(
                pIDirect3DDevice2, d3dptPrimitiveType, dwVertexType, lpvVertices,
                dwVertexCount, lpwIndices, dwIndexCount, dwFlags);
    return hr;
}

HRESULT STDMETHODCALLTYPE SetRenderState2Hook(LPVOID dev, DWORD state, DWORD value)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (state != 1)
    return D3DHooksData->pIDirect3DDevice2_SetRenderState(dev, state, value);
    if (D3DHooksData->search_enabled & (value==D3DHooksData->current_texture))
    {
        return D3DHooksData->pIDirect3DDevice2_SetRenderState(dev, state, 0);
    }
    return D3DHooksData->pIDirect3DDevice2_SetRenderState(dev, state, value);
}

HRESULT STDMETHODCALLTYPE DrawPrimitive3Hook(LPVOID pIDirect3DDevice3, DWORD dptPrimitiveType,
                                             DWORD dwVertexTypeDesc, LPVOID lpvVertices,
                                             DWORD dwVertexCount, DWORD dwFlags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr;
    XYZRHW * vertice  = (XYZRHW*)lpvVertices;
    unsigned int size = sizeof(float)*4;
    if (dwVertexTypeDesc & D3DFVF_DIFFUSE)  size += sizeof(DWORD);
    if (dwVertexTypeDesc & D3DFVF_SPECULAR) size += sizeof(DWORD);
    size += ((dwVertexTypeDesc & D3DFVF_TEXCOUNT_MASK)>>D3DFVF_TEXCOUNT_SHIFT) * 8;

    if (dwVertexTypeDesc & D3DFVF_XYZRHW)
    {
        memcpy(D3DHooksData->vextex_data, lpvVertices, size * dwVertexCount);
        vertice = (XYZRHW*)D3DHooksData->vextex_data;
        if (D3DHooksData->fix_screencoords == TRUE) scale_displace_and_fixcoords(vertice, dwVertexCount, size);
        else                                        scale_and_displace(vertice, dwVertexCount, size);
        if (D3DHooksData->callback)
        {
            if (D3DHooksData->vertexTransformCallback3(pIDirect3DDevice3, size, dwVertexCount,
                                                       D3DHooksData->vextex_data)) return 0;
        }
        hr = D3DHooksData->D3D3DrawPrimitive(pIDirect3DDevice3, dptPrimitiveType,
                                             dwVertexTypeDesc,
                                             D3DHooksData->vextex_data,
                                             dwVertexCount, dwFlags);
        return hr;
    }
    hr = D3DHooksData->D3D3DrawPrimitive(pIDirect3DDevice3, dptPrimitiveType,
                                         dwVertexTypeDesc, lpvVertices,
                                         dwVertexCount, dwFlags);
    return hr;
}

HRESULT STDMETHODCALLTYPE DrawIndexedPrimitive3Hook(LPVOID pIDirect3DDevice3,
                                                    DWORD d3dptPrimitiveType,
                                                    DWORD dwVertexTypeDesc, LPVOID lpvVertices,
                                                    DWORD dwVertexCount, LPWORD lpwIndices,
                                                    DWORD dwIndexCount, DWORD dwFlags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (D3DHooksData->DelayRTUpdates == 2)
    {
        D3DHooksData->UPdateRT();
        D3DHooksData->DelayRTUpdates = 1;
    }
    HRESULT       hr;
    XYZRHW * vertice;
    WORD    * pIndex;
    DWORD  size = sizeof(float)*4;
    if (dwVertexTypeDesc & D3DFVF_DIFFUSE)  size += sizeof(DWORD);
    if (dwVertexTypeDesc & D3DFVF_SPECULAR) size += sizeof(DWORD);
    size += ((dwVertexTypeDesc & D3DFVF_TEXCOUNT_MASK)>>D3DFVF_TEXCOUNT_SHIFT) * 8;

    if (dwVertexTypeDesc & D3DFVF_XYZRHW)
    {
        vertice = (XYZRHW*)D3DHooksData->vextex_data;
        pIndex  = lpwIndices;
        if (D3DHooksData->fix_screencoords == TRUE) scale_displace_and_fixcoords_indexed(vertice, (XYZRHW*)lpvVertices, pIndex,
                                                                                         dwIndexCount, size);
        else                                        scale_and_displace_indexed(vertice, (XYZRHW*)lpvVertices, pIndex,
                                                                               dwIndexCount, size);

        hr = D3DHooksData->D3D3DrawPrimitive(pIDirect3DDevice3, d3dptPrimitiveType,
                                             dwVertexTypeDesc, D3DHooksData->vextex_data,
                                             dwIndexCount, dwFlags);
        return hr;
    }
    hr = D3DHooksData->D3D3DrawIndexedPrimitive(pIDirect3DDevice3, d3dptPrimitiveType,
                                                dwVertexTypeDesc, lpvVertices,
                                                dwVertexCount, lpwIndices, dwIndexCount,
                                                dwFlags);
    return hr;
}

HRESULT STDMETHODCALLTYPE DrawPrimitive3VBHook(LPVOID device3, DWORD d3dptPrimitiveType,
                                               LPVOID lpd3dVertexBuffer, DWORD dwStartVertex,
                                               DWORD dwNumVertices, DWORD dwFlags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    unsigned int size;
    HRESULT        hr;
    XYZRHW  * vertice;
    XYZRHW      * vtc;
    D3DVERTEXBUFFERDESC vBuffDesc = {sizeof(vBuffDesc)};
    if (D3DHooksData->pIDirect3DVertexBuffer_GetDesc(lpd3dVertexBuffer, &vBuffDesc)) DBUG_WARN("No desc");
    if (vBuffDesc.dwFVF & D3DFVF_XYZRHW)
    {
        size = sizeof(float)*4;
        if (vBuffDesc.dwFVF & D3DFVF_DIFFUSE)  size += 4;
        if (vBuffDesc.dwFVF & D3DFVF_SPECULAR) size += 4 ;
        size += ((vBuffDesc.dwFVF & D3DFVF_TEXCOUNT_MASK)>>D3DFVF_TEXCOUNT_SHIFT) * 8;

        D3DHooksData->pIDirect3DVertexBuffer_Lock(
                    lpd3dVertexBuffer, DDLOCK_READONLY,(LPVOID*)&vertice, NULL);

        memcpy(D3DHooksData->vextex_data,
              (LPVOID)((DWORD)vertice+dwStartVertex*size),dwNumVertices*size);

        vtc = (XYZRHW*)D3DHooksData->vextex_data;
        if (D3DHooksData->fix_screencoords == TRUE) scale_displace_and_fixcoords(vtc, dwNumVertices, size);
        else                                        scale_and_displace(vtc, dwNumVertices, size);

        hr = D3DHooksData->D3D3DrawPrimitive(device3, d3dptPrimitiveType,
                                             vBuffDesc.dwFVF, D3DHooksData->vextex_data, dwNumVertices, 0);
        D3DHooksData->pIDirect3DVertexBuffer_UnLock(lpd3dVertexBuffer);
    } else hr = D3DHooksData->pIDirect3DDevice3_DrawPrimitiveVB(device3, d3dptPrimitiveType,
                                                                lpd3dVertexBuffer, dwStartVertex,
                                                                dwNumVertices, dwFlags);
    return hr;
}

HRESULT STDMETHODCALLTYPE
DrawIndexedPrimitive3VBHook(LPVOID device3, DWORD d3dptPrimitiveType,
                            LPVOID lpd3dVertexBuffer,  LPWORD lpwIndices,
                            DWORD dwIndexCount, DWORD dwFlags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT        hr;
    DWORD        size;
    WORD     * pIndex;
    XYZRHW  * vertice;
    LPVOID bufferdata;
    D3DVERTEXBUFFERDESC vBuffDesc = {sizeof(vBuffDesc)};
    D3DHooksData->pIDirect3DVertexBuffer_GetDesc(lpd3dVertexBuffer, &vBuffDesc);
    if (vBuffDesc.dwFVF & D3DFVF_XYZRHW)
    {
        size = sizeof(float)*4;
        if (vBuffDesc.dwFVF & D3DFVF_DIFFUSE)  size += 4;
        if (vBuffDesc.dwFVF & D3DFVF_SPECULAR) size += 4 ;
        size += ((vBuffDesc.dwFVF & D3DFVF_TEXCOUNT_MASK)>>D3DFVF_TEXCOUNT_SHIFT) * 8;
        D3DHooksData->pIDirect3DVertexBuffer_Lock(lpd3dVertexBuffer, DDLOCK_READONLY, &bufferdata, NULL);

        vertice = (XYZRHW*) D3DHooksData->vextex_data;
        pIndex  = lpwIndices;
        if (D3DHooksData->fix_screencoords == TRUE) scale_displace_and_fixcoords_indexed(vertice, (XYZRHW*)bufferdata, pIndex,
                                                                                         dwIndexCount, size);
        else                                        scale_and_displace_indexed(vertice, (XYZRHW*)bufferdata, pIndex,
                                                                               dwIndexCount, size);
        hr = D3DHooksData->D3D3DrawPrimitive(device3, d3dptPrimitiveType, vBuffDesc.dwFVF, D3DHooksData->vextex_data,
                                             dwIndexCount, dwFlags);
        D3DHooksData->pIDirect3DVertexBuffer_UnLock(lpd3dVertexBuffer);
        return hr;
    } return D3DHooksData->pIDirect3DDevice3_DrawIndexedPrimitiveVB(device3, d3dptPrimitiveType,
                                                                   lpd3dVertexBuffer,
                                                                   lpwIndices,
                                                                   dwIndexCount, dwFlags);
}

HRESULT STDMETHODCALLTYPE
TransformVertices3Hook(LPVOID viewport, LPVOID p2, LPVOID p3, LPVOID p4, LPVOID p5)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    VIEWPORT3 view = {sizeof(view)};
    D3DHooksData->GetView(viewport, &view);
    D3DHooksData->SetView(viewport, D3DHooksData->VW3);
    HRESULT r = D3DHooksData->pIDirect3DViewport3_TransformVertices(viewport, p2, p3, p4, p5);
    D3DHooksData->SetView(viewport, &view);
    return r;
}

__declspec(dllexport)
HRESULT IDirect3DDevice3_Clear(DEVICE3_RECT * dev3rect, RECT rects[2])
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    VIEWPORT3 current_view, new_view;
    void * viewport = NULL;

    ZeroMemory(&current_view, sizeof(current_view));
    ZeroMemory(&new_view, sizeof(new_view));
    current_view.dwSize = sizeof(current_view);
    new_view.dwSize     = sizeof(new_view);

    if (dev3rect->Device3 == NULL) return 0;
    if (dev3rect->GetCurrentViewport(dev3rect->Device3, &viewport)) return 1;
    if (dev3rect->GetView(viewport, &current_view)) return 2;

    new_view.dwX           = rects[0].left;
    new_view.dwY           = rects[0].top;
    new_view.dwWidth       = rects[0].right-rects[0].left;
    new_view.dwHeight      = rects[0].bottom-rects[0].top;
    new_view.dvClipX       = (float)rects[0].left;
    new_view.dvClipY       = (float)rects[0].top;
    new_view.dvClipWidth   = (float)(rects[0].right-rects[1].left);
    new_view.dvClipHeight  = (float)(rects[0].bottom-rects[1].top);
    new_view.dvMinZ        = 0.f;
    new_view.dvMaxZ        = 1.f;
    if (dev3rect->SetView(viewport, &new_view)) return 3;
    if (dev3rect->ClearView(viewport, 1, &rects[0], 0x00000001, 0., 0, 0)) return 4;

    new_view.dwX           = rects[1].left;
    new_view.dwY           = rects[1].top;
    new_view.dwWidth       = rects[1].right-rects[1].left;
    new_view.dwHeight      = rects[1].bottom-rects[1].top;
    new_view.dvClipX       = (float)rects[1].left;
    new_view.dvClipY       = (float)rects[1].top;
    new_view.dvClipWidth   = (float)(rects[1].right-rects[1].left);
    new_view.dvClipHeight  = (float)(rects[1].bottom-rects[1].top);
    new_view.dvMinZ        = 0.f;
    new_view.dvMaxZ        = 1.f;
    if (dev3rect->SetView(viewport, &new_view)) return 5;
    if (dev3rect->ClearView(viewport, 1, &rects[1], 0x00000001, 0., 0, 0)) return 6;

    if (dev3rect->SetView(viewport, &current_view)) return 7;
    if (dev3rect->ReleaseViewport(viewport)) return 8;
    return 0;
}

HRESULT __stdcall IDirect3DDevice3_DrawRectWithFlags(DEVICE3_RECT * dev3rect, RECT * dst_rect, RECT * src_rect, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT        r;
    BOOL           endscene    = TRUE;
    BOOL           restorewiew = FALSE;
    DEVICE3_STATES states;
    VIEWPORT3      current_view, new_view;
    BOOL           filter = flags & 3;
    BOOL           ckey   = flags & 1;
       
    void *         viewport = NULL;

    TLVERTEX rect[4] =
    {
        {0,     0.0f,  0.1f, 1.0f, (int32_t)0xffffffff, 0, 0.f, 0.f},
        {256.f, 0.0f,  0.1f, 1.0f, (int32_t)0xffffffff, 0, 1.f, 0.f},
        {0.0f,  256.f, 0.1f, 1.0f, (int32_t)0xffffffff, 0, 0.f, 1.f},
        {256.f, 256.f, 0.1f, 1.0f, (int32_t)0xffffffff, 0, 1.f, 1.f}
    };

    if (src_rect)
    {
        rect[0].u = (float)src_rect->left/(float)D3DHooksData->Rqstd_w;
        rect[0].v = (float)src_rect->top/(float)D3DHooksData->Rqstd_h;
        rect[1].u = (float)src_rect->right/(float)D3DHooksData->Rqstd_w;
        rect[1].v = (float)src_rect->top/(float)D3DHooksData->Rqstd_h;
        rect[2].u = (float)src_rect->left/(float)D3DHooksData->Rqstd_w;
        rect[2].v = (float)src_rect->bottom/(float)D3DHooksData->Rqstd_h;
        rect[3].u = (float)src_rect->right/(float)D3DHooksData->Rqstd_w;
        rect[3].v = (float)src_rect->bottom/(float)D3DHooksData->Rqstd_h;
    }
    ZeroMemory(&states, sizeof(states));
    ZeroMemory(&current_view, sizeof(current_view));
    ZeroMemory(&new_view, sizeof(new_view));
    current_view.dwSize = sizeof(current_view);
    new_view.dwSize     = sizeof(new_view);

    states.zbuff      = 0;
    states.zwrite     = 0;
    states.ablend     = 0;
    states.clr_op     = 0;
    states.clr_op1    = 0;
    states.clr_arg    = 0;
    states.alpha_op   = 0;
    states.alpha_op1  = 0;
    states.alpha_arg  = 0;
    states.fogenabled = 0;
    states.cullmode   = 0;
    states.clrkey     = 0;
    states.Texture    = 0;
    states.magfilter  = 1;
    states.minfilter  = 1;

    rect[0].x = (float)dst_rect->left -0.5f; rect[0].y = (float)dst_rect->top-0.5f;
    rect[1].x = (float)dst_rect->right-0.5f; rect[1].y = (float)dst_rect->top-0.5f;
    rect[2].x = (float)dst_rect->left -0.5f; rect[2].y = (float)dst_rect->bottom-0.5f;
    rect[3].x = (float)dst_rect->right-0.5f; rect[3].y = (float)dst_rect->bottom-0.5f;

    //Get and set viewport
    if (dev3rect->GetCurrentViewport(dev3rect->Device3, &viewport))
    {
        r = 1;
        goto IDirect3DDevice3_DrawRect_CleanUp;
    }
    if (dev3rect->GetView(viewport, &current_view))
    {
        r = 2;
        goto IDirect3DDevice3_DrawRect_CleanUp;
    }
    new_view.dwX           = dst_rect->left;
    new_view.dwY           = dst_rect->top;
    new_view.dwWidth       = dst_rect->right-dst_rect->left;
    new_view.dwHeight      = dst_rect->bottom-dst_rect->top;
    new_view.dvClipX       = (float)dst_rect->left;
    new_view.dvClipY       = (float)dst_rect->top;
    new_view.dvClipWidth   = (float)(dst_rect->right-dst_rect->left);
    new_view.dvClipHeight  = (float)(dst_rect->bottom-dst_rect->top);
    new_view.dvMinZ        = 0.f;
    new_view.dvMaxZ        = 1.f;
    if (r = dev3rect->SetView(viewport, &new_view))
    {
        r = 3;
        goto IDirect3DDevice3_DrawRect_CleanUp;
    }
    restorewiew = TRUE;

    //Get RenderStates
    dev3rect->GetRenderState(dev3rect->Device3, D3DRENDERSTATE_ZENABLE, &states.zbuff);
    dev3rect->GetRenderState(dev3rect->Device3, D3DRENDERSTATE_ZWRITEENABLE, &states.zwrite);
    dev3rect->GetRenderState(dev3rect->Device3, D3DRENDERSTATE_ALPHABLENDENABLE, &states.ablend);
    dev3rect->GetRenderState(dev3rect->Device3, D3DRENDERSTATE_FOGENABLE, &states.fogenabled);
    dev3rect->GetRenderState(dev3rect->Device3, D3DRENDERSTATE_CULLMODE, &states.cullmode);
    dev3rect->GetRenderState(dev3rect->Device3, D3DRENDERSTATE_COLORKEYENABLE, &states.clrkey);
    dev3rect->GetTexture(dev3rect->Device3, 0, &states.Texture);

    //Get Blend Operations
    dev3rect->GetTextureStageState(dev3rect->Device3, 0, D3DTSS_COLOROP, &states.clr_op);
    dev3rect->GetTextureStageState(dev3rect->Device3, 1, D3DTSS_COLOROP, &states.clr_op1);
    dev3rect->GetTextureStageState(dev3rect->Device3, 0, D3DTSS_COLORARG1, &states.clr_arg);
    dev3rect->GetTextureStageState(dev3rect->Device3, 0, D3DTSS_ALPHAOP, &states.alpha_op);
    dev3rect->GetTextureStageState(dev3rect->Device3, 1, D3DTSS_ALPHAOP, &states.alpha_op1);
    dev3rect->GetTextureStageState(dev3rect->Device3, 0, D3DTSS_ALPHAARG1, &states.alpha_arg);
    dev3rect->GetTextureStageState(dev3rect->Device3, 0, D3DTSS_MAGFILTER, &states.magfilter);
    dev3rect->GetTextureStageState(dev3rect->Device3, 0, D3DTSS_MINFILTER, &states.minfilter);

    //Set RenderStates
    if (states.zbuff)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_ZENABLE, 0);
    if (states.zwrite)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_ZWRITEENABLE, 0);
    if (states.ablend)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_ALPHABLENDENABLE, 0);
    if (states.fogenabled)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_FOGENABLE, 0);
    if (states.cullmode > 1)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_CULLMODE, 1);
    dev3rect->SetTexture(dev3rect->Device3, 0, dev3rect->Texture);
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_COLORKEYENABLE, ckey ? 1 : 0);

    //Set Blend Operations
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_COLOROP, D3DTOP_SELECTARG1);
    dev3rect->SetTextureStageState(dev3rect->Device3, 1, D3DTSS_COLOROP, D3DTOP_DISABLE);
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_COLORARG1, dev3rect->Texture ? D3DTA_TEXTURE : D3DTA_DIFFUSE);
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG1);
    dev3rect->SetTextureStageState(dev3rect->Device3, 1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
    
    //dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_MAGFILTER, filter ? D3DTFG_LINEAR : D3DTFG_POINT); // crash and too much blur why ?
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_MINFILTER, filter ? D3DTFN_ANISOTROPIC : D3DTFN_POINT);
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_MAXANISOTROPY, 16);

    //Drawing
    endscene = dev3rect->BeginScene(dev3rect->Device3) ? 0 : 1;
    if (dev3rect->DrawPrimitive(dev3rect->Device3, D3DPT_TRIANGLESTRIP,
                                D3DFVF_XYZRHW | D3DFVF_DIFFUSE | D3DFVF_SPECULAR | D3DFVF_TEX1,
                                rect, 4, D3DDP_DONOTCLIP | D3DDP_DONOTLIGHT))
    {
        if (endscene)dev3rect->EndScene(dev3rect->Device3);
        r = 4;
        goto IDirect3DDevice3_DrawRect_CleanUp;

    }
    if (endscene)
    {
        if (dev3rect->EndScene(dev3rect->Device3))
        {
            r = 5;
            goto IDirect3DDevice3_DrawRect_CleanUp;
        }
    }

    //CleanUP
    IDirect3DDevice3_DrawRect_CleanUp:
    dev3rect->RenderTarget = NULL;
    dev3rect->Texture      = NULL;
    if (restorewiew)     dev3rect->SetView(viewport, &current_view);
    if (viewport)        dev3rect->ReleaseViewport(viewport);
    dev3rect->SetTexture(dev3rect->Device3, 0, states.Texture);
    if (states.Texture != NULL) dev3rect->ReleaseTexture(states.Texture);

    //if (states.zbuff)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_ZENABLE, states.zbuff);
    //if (states.zwrite)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_ZWRITEENABLE, states.zwrite);
    //if (states.ablend)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_ALPHABLENDENABLE, states.ablend);
    //if (states.clrkey)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_COLORKEYENABLE, states.clrkey);
    //if (states.fogenabled)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_FOGENABLE, states.fogenabled);
    //if (states.cullmode)
    dev3rect->SetRenderState(dev3rect->Device3, D3DRENDERSTATE_CULLMODE, states.cullmode);
   
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_MAGFILTER, states.magfilter);
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_MINFILTER, states.minfilter);
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_COLOROP, states.clr_op);
    dev3rect->SetTextureStageState(dev3rect->Device3, 1, D3DTSS_COLOROP, states.clr_op1);
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_COLORARG1, states.clr_arg);
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_ALPHAOP, states.alpha_op);
    dev3rect->SetTextureStageState(dev3rect->Device3, 1, D3DTSS_ALPHAOP, states.alpha_op1);
    dev3rect->SetTextureStageState(dev3rect->Device3, 0, D3DTSS_ALPHAARG1, states.alpha_arg);   
    return r;
}

HRESULT __stdcall IDirect3DDevice3_DrawRect(DEVICE3_RECT * dev3rect, RECT * dst_rect, RECT * src_rect)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return IDirect3DDevice3_DrawRectWithFlags(dev3rect, dst_rect, src_rect, 0);
}

HRESULT STDMETHODCALLTYPE SetTexture3Hook(LPVOID pIDirect3DDevice3, DWORD stage, DWORD texture)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__) 
    HRESULT err;
    /*
    if (g_d3d.DBUG)
    {
       SHORT down = GetKeyState(VK_SHIFT) & 0x8000 ;
       if (down) {
           return D3DHooksData->pIDirect3DDevice3_SetTexture(pIDirect3DDevice3, stage, texture);
       }
    }
    */
    D3DHooksData->ignore_release = TRUE;
    if (! texture)
    { 
       err = D3DHooksData->pIDirect3DDevice3_SetTexture(pIDirect3DDevice3, stage, texture);
       D3DHooksData->ignore_release = FALSE;
       return err;
    }
    if (D3DHooksData->search_enabled & (texture==D3DHooksData->current_texture))
    {
       err = D3DHooksData->pIDirect3DDevice3_SetTexture(pIDirect3DDevice3, stage, 0);
       D3DHooksData->ignore_release = FALSE;
       return err;
    }
    DWORD replacement = 0;
    replacement = (DWORD)D3DHooksData->replacements->Value((LPVOID)texture);
    if (replacement)
    {
       err = D3DHooksData->pIDirect3DDevice3_SetTexture(pIDirect3DDevice3, stage, replacement);
       D3DHooksData->ignore_release = FALSE;
       return err;
    }
    err = D3DHooksData->pIDirect3DDevice3_SetTexture(pIDirect3DDevice3, stage, texture);
    D3DHooksData->ignore_release = FALSE;
    return err;
}

IDirectDrawSurface7 * GetDDSurface7Replacement(IDirectDrawSurface7 * s7)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return (IDirectDrawSurface7*)D3DHooksData->replacements->Value((LPVOID)s7);
}

void SetDDSurface7Replacement(IDirectDrawSurface7 * s7, IDirectDrawSurface7 * r7)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3DHooksData->replacements->insert_disposable((LPVOID)s7, (LPVOID)r7);
}

HRESULT ReplaceA8DDrawSurface7(IDirectDrawSurface7 * s7)
{
    IDirectDrawSurface7 * r7  = nullptr;
    IDirectDraw7        * dd7 = nullptr;
    IDirectDraw         * dd1 = nullptr;
    DDSURFACEDESC2       sdsc = {};
    DDSURFACEDESC2       rdsc = {};
    HRESULT               err = 0;
    DWORD A8RGB[4]            = {0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000};

    if (s7 == nullptr)
    {
        DBUG_WARN("nullptr");
        goto ReplacePAL8DDrawSurface7_cleanup;
    }
    if (s7->GetDDInterface((LPVOID*)&dd1))
    {
        DBUG_WARN("IDirectDrawSurface7::GetDDInterface FAILED");
        goto ReplacePAL8DDrawSurface7_cleanup;
    }
    if (dd1->QueryInterface(IID_IDirectDraw7, (LPVOID*)&dd7))
    {
        DBUG_WARN("IDirectDraw::QueryInterface(IID_IDirectDraw7) FAILED");
        goto ReplacePAL8DDrawSurface7_cleanup;
    }
    sdsc.dwSize = sizeof(DDSURFACEDESC2);
    if (s7->GetSurfaceDesc(&sdsc))
    {
        DBUG_WARN("IDirectDrawSurface7::GetSurfaceDesc() FAILED");
        goto ReplacePAL8DDrawSurface7_cleanup;
    }
    rdsc.dwSize          = sizeof(DDSURFACEDESC2);
    rdsc.dwFlags         = DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT;
    rdsc.ddsCaps.dwCaps  = DDSCAPS_TEXTURE;
    rdsc.ddsCaps.dwCaps2 = DDSCAPS2_TEXTUREMANAGE;
    rdsc.dwWidth         = sdsc.dwWidth;
    rdsc.dwHeight        = sdsc.dwHeight;
    
    rdsc.ddpfPixelFormat.dwFlags         = DDPF_RGB | DDPF_ALPHAPIXELS;
    rdsc.ddpfPixelFormat.dwRGBBitCount   = 32;
    memcpy(&rdsc.ddpfPixelFormat.dwRBitMask, A8RGB, sizeof(DWORD)*4);
    if (dd7->CreateSurface(&rdsc, &r7, nullptr))
    {
        DBUG_WARN("IDirectDraw7::CreateSurface() FAILED");
        goto ReplacePAL8DDrawSurface7_cleanup;
    }

    ZeroMemory(&rdsc, sizeof(DDSURFACEDESC2));
    ZeroMemory(&sdsc, sizeof(DDSURFACEDESC2));
    if (r7->Lock(nullptr, &rdsc, DDLOCK_WRITEONLY, nullptr))
    {
        DBUG_WARN("IDirectDrawSurface7::Lock() FAIED");
        goto ReplacePAL8DDrawSurface7_cleanup;
    }
    if (s7->Lock(nullptr, &sdsc, DDLOCK_WRITEONLY, nullptr))
    {
        r7->Unlock(nullptr);
        DBUG_WARN("IDirectDrawSurface7::Lock() FAIED");
        goto ReplacePAL8DDrawSurface7_cleanup;
    }
    UINT pixel, line;
    DWORD     * rgba;
    BYTE     * alpha;
    for (line=0; line<rdsc.dwWidth; line++)
    {
         for (pixel=0; pixel<rdsc.dwHeight; pixel++)
         {
             rgba   = (DWORD*)(DWORD)((DWORD)rdsc.lpSurface + (DWORD)rdsc.lPitch*line);
             rgba  += pixel;
             alpha  = (BYTE*)(DWORD)((DWORD)sdsc.lpSurface + (DWORD)sdsc.lPitch*line);
             alpha += pixel;
             *rgba  = 0x00ffffff | (*alpha<<24);
         }
    }
    s7->Unlock(nullptr);
    r7->Unlock(nullptr);
    SetDDSurface7Replacement(s7, r7);

    ReplacePAL8DDrawSurface7_cleanup:
    if (dd1) dd1->Release();
    if (dd7) dd7->Release();
    return err;
}

HRESULT STDMETHODCALLTYPE DrawPrimitive7Hook(LPVOID pIDirect3DDevice7, DWORD dptPrimitiveType,
                                             DWORD dwVertexTypeDesc, LPVOID lpvVertices,
                                             DWORD dwVertexCount, DWORD dwFlags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr;
    XYZRHW * vertice  = (XYZRHW*)lpvVertices;
    unsigned int size = sizeof(float)*4;
    if (dwVertexTypeDesc & D3DFVF_DIFFUSE) size += sizeof(DWORD);
    if (dwVertexTypeDesc & D3DFVF_SPECULAR) size += sizeof(DWORD);
    size += ((dwVertexTypeDesc & D3DFVF_TEXCOUNT_MASK)>>D3DFVF_TEXCOUNT_SHIFT) * 8;

    if (dwVertexTypeDesc & D3DFVF_XYZRHW)
    {
        memcpy(D3DHooksData->vextex_data, lpvVertices, size * dwVertexCount);
        vertice = (XYZRHW*)D3DHooksData->vextex_data;
        if (D3DHooksData->fix_screencoords == TRUE)  scale_displace_and_fixcoords(vertice, dwVertexCount, size);
        else                                         scale_and_displace(vertice, dwVertexCount, size);
        hr = D3DHooksData->pIDirect3DDevice7_DrawPrimitive(pIDirect3DDevice7, dptPrimitiveType,
                                                           dwVertexTypeDesc,
                                                           D3DHooksData->vextex_data,
                                                           dwVertexCount, dwFlags);
        return hr;
    }
    hr = D3DHooksData->pIDirect3DDevice7_DrawPrimitive(pIDirect3DDevice7, dptPrimitiveType,
                                                       dwVertexTypeDesc, lpvVertices, dwVertexCount,
                                                       dwFlags);
    return hr;
}

HRESULT STDMETHODCALLTYPE DrawPrimitive7VBHook(LPVOID device7, LPVOID d3dptPrimitiveType,
                                               LPVOID lpd3dVertexBuffer, DWORD dwStartVertex,
                                               DWORD dwNumVertices, DWORD dwFlags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    unsigned int size;
    HRESULT hr;
    XYZRHW * vertice, * vtc;
    D3DVERTEXBUFFERDESC vBuffDesc = {sizeof(vBuffDesc)};
    D3DHooksData->pIDirect3DVertexBuffer7_GetVertexBufferDesc(lpd3dVertexBuffer, &vBuffDesc);
    if (vBuffDesc.dwFVF & D3DFVF_XYZRHW)
    {
        size = sizeof(float)*4;
        if (vBuffDesc.dwFVF & D3DFVF_DIFFUSE)  size += 4;
        if (vBuffDesc.dwFVF & D3DFVF_SPECULAR) size += 4 ;
        size += ((vBuffDesc.dwFVF & D3DFVF_TEXCOUNT_MASK)>>D3DFVF_TEXCOUNT_SHIFT) * 8;
        D3DHooksData->pIDirect3DVertexBuffer7_Lock(lpd3dVertexBuffer, DDLOCK_READONLY, &vertice, NULL);

        memcpy(D3DHooksData->vextex_data,
              (LPVOID)((DWORD)vertice+dwStartVertex*size),dwNumVertices*size);
        D3DHooksData->pIDirect3DVertexBuffer7_UnLock(lpd3dVertexBuffer);
        vtc = (XYZRHW*)D3DHooksData->vextex_data;
        if (D3DHooksData->fix_screencoords == TRUE) scale_displace_and_fixcoords(vtc, dwNumVertices, size);
        else                                        scale_and_displace(vtc, dwNumVertices, size);
        hr = D3DHooksData->pIDirect3DDevice7_DrawPrimitive(device7, (DWORD)d3dptPrimitiveType,
                                                           vBuffDesc.dwFVF, vtc, dwNumVertices, 0);
    } else hr = D3DHooksData->pIDirect3DDevice7_DrawPrimitiveVB(device7, d3dptPrimitiveType,
                                                                lpd3dVertexBuffer, dwStartVertex,
                                                                dwNumVertices, dwFlags);
    return hr;
}

HRESULT STDMETHODCALLTYPE
DrawIndexedPrimitive7VBHook(LPVOID dvc7, DWORD PrmType, LPVOID VertexBuffer,
                            DWORD StartVertex, DWORD NumVertices, LPWORD Indices,
                            DWORD IndexCount, DWORD Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT        hr;
    LPVOID bufferdata;
    WORD     * pIndex;
    XYZRHW  * vertice;
    D3DVERTEXBUFFERDESC vBuffDesc = {sizeof(vBuffDesc)};
    D3DHooksData->pIDirect3DVertexBuffer7_GetVertexBufferDesc(VertexBuffer, &vBuffDesc);
    if (vBuffDesc.dwFVF & D3DFVF_XYZRHW)
    {
        DWORD size = sizeof(float)*4;
        if (vBuffDesc.dwFVF & D3DFVF_DIFFUSE)  size += 4;
        if (vBuffDesc.dwFVF & D3DFVF_SPECULAR) size += 4 ;
        size += ((vBuffDesc.dwFVF & D3DFVF_TEXCOUNT_MASK)>>D3DFVF_TEXCOUNT_SHIFT) * 8;
        D3DHooksData->pIDirect3DVertexBuffer_Lock(VertexBuffer, DDLOCK_READONLY, &bufferdata, NULL);

        vertice = (XYZRHW*) D3DHooksData->vextex_data;
        pIndex  = Indices;
        bufferdata = (XYZRHW*) ( (DWORD) bufferdata + StartVertex*size);
        if (D3DHooksData->fix_screencoords == TRUE) scale_displace_and_fixcoords_indexed(vertice, (XYZRHW*)bufferdata,
                                                                                         Indices, IndexCount, size);
        else                                        scale_and_displace_indexed(vertice, (XYZRHW*)bufferdata, pIndex,
                                                                               IndexCount, size);
        hr = D3DHooksData->D3D3DrawPrimitive(dvc7, PrmType,  vBuffDesc.dwFVF, D3DHooksData->vextex_data, IndexCount, Flags);
        D3DHooksData->pIDirect3DVertexBuffer_UnLock(VertexBuffer);
        return hr;
    }
    return D3DHooksData->pIDirect3DDevice7_DrawIndexedPrimitiveVB(dvc7, PrmType, VertexBuffer, StartVertex,
                                                                 NumVertices, Indices, IndexCount, Flags);
}


HRESULT IDirect3DDevice7_DrawRectWithFlags(DEVICE7_RECT * d7, RECT * dst, RECT * src, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT        r;
    BOOL           endscene    = TRUE;
    BOOL           restorewiew = FALSE;
    DEVICE3_STATES states;
    VIEWPORT7      current_view, new_view;

    DWORD filter = flags & 3;
    DWORD ckey   = flags & 1;

    TLVERTEX rect[4] =
    {
        {0,     0.0f,  0.1f, 1.0f, (int)0xffffffff, 0, 0.f, 0.f},
        {256.f, 0.0f,  0.1f, 1.0f, (int)0xffffffff, 0, 1.f, 0.f},
        {0.0f,  256.f, 0.1f, 1.0f, (int)0xffffffff, 0, 0.f, 1.f},
        {256.f, 256.f, 0.1f, 1.0f, (int)0xffffffff, 0, 1.f, 1.f}
    };

    if (src)
    {
        rect[0].u = (float)src->left/(float)D3DHooksData->Rqstd_w;
        rect[0].v = (float)src->top/(float)D3DHooksData->Rqstd_h;
        rect[1].u = (float)src->right/(float)D3DHooksData->Rqstd_w;
        rect[1].v = (float)src->top/(float)D3DHooksData->Rqstd_h;
        rect[2].u = (float)src->left/(float)D3DHooksData->Rqstd_w;
        rect[2].v = (float)src->bottom/(float)D3DHooksData->Rqstd_h;
        rect[3].u = (float)src->right/(float)D3DHooksData->Rqstd_w;
        rect[3].v = (float)src->bottom/(float)D3DHooksData->Rqstd_h;
    }

    ZeroMemory(&states, sizeof(states));
    ZeroMemory(&current_view, sizeof(current_view));
    ZeroMemory(&new_view, sizeof(new_view));

    states.coordindex = 0;
    states.zbuff      = 0;
    states.zwrite     = 0;
    states.ablend     = 0;
    states.clr_op     = 0;
    states.clr_op1    = 0;
    states.clr_arg    = 0;
    states.alpha_op   = 0;
    states.alpha_op1  = 0;
    states.alpha_arg  = 0;
    states.fogenabled = 0;
    states.cullmode   = 0;
    states.clrkey     = 0;
    states.Texture    = 0;
    states.magfilter  = 1;
    states.minfilter  = 1;

    rect[0].x = (float)dst->left -0.5f; rect[0].y = (float)dst->top-0.5f;
    rect[1].x = (float)dst->right-0.5f; rect[1].y = (float)dst->top-0.5f;
    rect[2].x = (float)dst->left -0.5f; rect[2].y = (float)dst->bottom-0.5f;
    rect[3].x = (float)dst->right-0.5f; rect[3].y = (float)dst->bottom-0.5f;

    //Get and set viewport
    if (d7->GetView(d7->Device7, &current_view))
    {
        r = 1;
        goto IDirect3DDevice7_DrawRect_CleanUp;
    }

    new_view.dwX           = dst->left;
    new_view.dwY           = dst->top;
    new_view.dwWidth       = dst->right-dst->left;
    new_view.dwHeight      = dst->bottom-dst->top;
    new_view.dvMinZ        = 0.f;
    new_view.dvMaxZ        = 1.f;
    if (r = d7->SetView(d7->Device7, &new_view))
    {
        r = 3;
        goto IDirect3DDevice7_DrawRect_CleanUp;
    }
    restorewiew = TRUE;

    //Get RenderStates
    d7->GetRenderState(d7->Device7, D3DRENDERSTATE_ZENABLE, &states.zbuff);
    d7->GetRenderState(d7->Device7, D3DRENDERSTATE_ZWRITEENABLE, &states.zwrite);
    d7->GetRenderState(d7->Device7, D3DRENDERSTATE_ALPHABLENDENABLE, &states.ablend);
    d7->GetRenderState(d7->Device7, D3DRENDERSTATE_FOGENABLE, &states.fogenabled);
    d7->GetRenderState(d7->Device7, D3DRENDERSTATE_CULLMODE, &states.cullmode);
    d7->GetRenderState(d7->Device7, D3DRENDERSTATE_COLORKEYENABLE, &states.clrkey);
    d7->GetTexture(d7->Device7, 0, &states.Texture);

    //Get Blend Operations
    d7->GetTextureStageState(d7->Device7, 0, D3DTSS_TEXCOORDINDEX, &states.coordindex);
    d7->GetTextureStageState(d7->Device7, 0, D3DTSS_COLOROP, &states.clr_op);
    d7->GetTextureStageState(d7->Device7, 1, D3DTSS_COLOROP, &states.clr_op1);
    d7->GetTextureStageState(d7->Device7, 0, D3DTSS_COLORARG1, &states.clr_arg);
    d7->GetTextureStageState(d7->Device7, 0, D3DTSS_ALPHAOP, &states.alpha_op);
    d7->GetTextureStageState(d7->Device7, 1, D3DTSS_ALPHAOP, &states.alpha_op1);
    d7->GetTextureStageState(d7->Device7, 0, D3DTSS_ALPHAARG1, &states.alpha_arg);
    d7->GetTextureStageState(d7->Device7, 0, D3DTSS_MAGFILTER, &states.magfilter);
    d7->GetTextureStageState(d7->Device7, 0, D3DTSS_MINFILTER, &states.minfilter);

    //Set RenderStates
    if (states.zbuff)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_ZENABLE, 0);
    if (states.zwrite)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_ZWRITEENABLE, 0);
    if (states.ablend)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_ALPHABLENDENABLE, 0);
    if (states.fogenabled)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_FOGENABLE, 0);
    if (states.cullmode > 1)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_CULLMODE, 1);
    d7->SetTexture(d7->Device7, 0, d7->Texture);
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_COLORKEYENABLE, ckey ? 1 : 0);

    //Set Blend Operations
    if (states.coordindex)
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_TEXCOORDINDEX, 0);
    //if (states.magfilter > 1)
    d7->SetTextureStageState(d7->Device7, 0, 16, 1);
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_COLOROP, D3DTOP_SELECTARG1);
    d7->SetTextureStageState(d7->Device7, 1, D3DTSS_COLOROP, D3DTOP_DISABLE);
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG1);
    d7->SetTextureStageState(d7->Device7, 1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);

    //d7->SetTextureStageState(d7->Device7, 0, D3DTSS_MAGFILTER, filter ? D3DTFG_LINEAR : D3DTFG_POINT); // crash and too much blur why ?
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_MINFILTER, filter ? D3DTFN_LINEAR : D3DTFN_ANISOTROPIC);

    //Drawing
    endscene = d7->BeginScene(d7->Device7) ? 0 : 1;
    if (d7->DrawPrimitive(d7->Device7, D3DPT_TRIANGLESTRIP,
                                D3DFVF_XYZRHW | D3DFVF_DIFFUSE | D3DFVF_SPECULAR | D3DFVF_TEX1,
                                rect, 4, D3DDP_DONOTCLIP | D3DDP_DONOTLIGHT))
    {
        if (endscene)d7->EndScene(d7->Device7);
        r = 4;
        goto IDirect3DDevice7_DrawRect_CleanUp;

    }
    if (endscene)
    {
        if (d7->EndScene(d7->Device7))
        {
            r = 5;
            goto IDirect3DDevice7_DrawRect_CleanUp;
        }
    }

    //CleanUP
    IDirect3DDevice7_DrawRect_CleanUp:
    d7->RenderTarget = NULL;
    d7->Texture      = NULL;
    if (restorewiew)     d7->SetView(d7->Device7, &current_view);
    d7->SetTexture(d7->Device7, 0, states.Texture);
    if (states.Texture != NULL) d7->ReleaseTexture(states.Texture);

    //if (states.zbuff)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_ZENABLE, states.zbuff);
    //if (states.zwrite)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_ZWRITEENABLE, states.zwrite);
    //if (states.ablend)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_ALPHABLENDENABLE, states.ablend);
    //if (states.clrkey)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_COLORKEYENABLE, states.clrkey);
    //if (states.fogenabled)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_FOGENABLE, states.fogenabled);
    //if (states.cullmode)
    d7->SetRenderState(d7->Device7, D3DRENDERSTATE_CULLMODE, states.cullmode);

    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_MAGFILTER, states.magfilter);
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_MINFILTER, states.minfilter);

    if (states.coordindex)
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_TEXCOORDINDEX, states.coordindex);    
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_COLOROP, states.clr_op);
    d7->SetTextureStageState(d7->Device7, 1, D3DTSS_COLOROP, states.clr_op1);
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_COLORARG1, states.clr_arg);
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_ALPHAOP, states.alpha_op);
    d7->SetTextureStageState(d7->Device7, 1, D3DTSS_ALPHAOP, states.alpha_op1);
    d7->SetTextureStageState(d7->Device7, 0, D3DTSS_ALPHAARG1, states.alpha_arg);
    return r;
}

HRESULT __stdcall IDirect3DDevice7_DrawRect(DEVICE7_RECT * d7, RECT * dst, RECT * src)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return IDirect3DDevice7_DrawRectWithFlags(d7, dst, src, 0);
}

HRESULT STDMETHODCALLTYPE SetTexture7Hook(LPVOID pD3DDvc7, DWORD stage, DWORD tx)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    /*
    if (g_d3d.DBUG)
    {
        SHORT down = GetKeyState(VK_SHIFT) & 0x8000 ;
        if (down) {
            return D3DHooksData->Direct3DDevice7_SetTexture(pD3DDvc7, stage, tx);
        }
    }
    */
    if (D3DHooksData->search_enabled && (tx == D3DHooksData->current_texture))
    {
        err = D3DHooksData->Direct3DDevice7_SetTexture(pD3DDvc7, stage, 0);
        return err;
    }
    DWORD rep = 0;
    rep = (DWORD)D3DHooksData->replacements->Value((LPVOID)tx);
    if (rep)
    {
        err = D3DHooksData->Direct3DDevice7_SetTexture(pD3DDvc7, stage, rep);
        return err;
    }
    return D3DHooksData->Direct3DDevice7_SetTexture(pD3DDvc7, stage, tx);
}

HRESULT STDMETHODCALLTYPE AltSetTexture7Hook(LPVOID pD3DDvc7, DWORD stage, DWORD tx)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)    
    if (tx == 0) return D3DHooksData->Direct3DDevice7_SetTexture(pD3DDvc7, stage, tx);
    if (GetDDSrfacePxFormat((IUnknown*)tx) == *(DWORD*) "_A8_")
    {
        if (GetDDSurface7Replacement((IDirectDrawSurface7*)tx) == nullptr)
            ReplaceA8DDrawSurface7((IDirectDrawSurface7*)tx);
    }
    return SetTexture7Hook(pD3DDvc7, stage, tx);
}
