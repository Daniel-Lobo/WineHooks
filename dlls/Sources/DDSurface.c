#include <windows.h>
#include <math.h>
#include <ddraw.h>
#include "DDSurface.h"
#include <winbase.h>
//#include "D3DHooks.h"
#pragma intrinsic(memcpy)

BOOL RectCoversEntireSurface(RECT* r, UINT w, UINT h) {
    if (r == NULL) return TRUE;
    return r->left == 0 && r->top == 0 && r->right == w && r->bottom == h ? TRUE : FALSE;
}

BOOL __inline CompareTextAndCompiledDumps(DWORD t_ww, DWORD t_hh, DWORD t_Pitch, LPVOID t_pData,
                                          DUMP * dump)
{
    DWORD i, jump = t_hh/dump->samples;
    for (i=0; i<dump->samples; i++)
    {
#ifdef _WIN64
        if (memcmp((LPVOID) ((LONG64)dump->pData + dump->ww * dump->bypp * i),
                   (LPVOID) ((LONG64)t_pData + t_Pitch * jump * i)
                   , dump->ww * dump->bypp) != 0)
                return FALSE;
#else
        if (memcmp((LPVOID) ((DWORD)dump->pData + dump->ww * dump->bypp * i),
                   (LPVOID) ((DWORD)t_pData + t_Pitch * jump * i)
                   , dump->ww * dump->bypp) != 0)
                return FALSE;
#endif
    } return TRUE;
}

BOOL __inline CompareTextAndDump(DWORD t_ww, DWORD t_hh, DWORD t_Pitch, LPVOID t_pData,
                                 DUMP * dump, DWORD samples)
{
    DWORD i, jump = t_hh/samples;
    for (i=0; i<samples; i++)
    {
#ifdef _WIN64
        if (memcmp((LPVOID) ((LONG64)dump->pData + dump->ww * dump->bypp * jump * i),
                   (LPVOID) ((LONG64)t_pData + t_Pitch * jump * i)
                   , dump->ww * dump->bypp) != 0)
                return FALSE;
#else
        if (memcmp((LPVOID) ((DWORD)dump->pData + dump->ww * dump->bypp * jump * i),
                   (LPVOID) ((DWORD)t_pData + t_Pitch * jump * i)
                   , dump->ww * dump->bypp) != 0)
                return FALSE;
#endif
    } return TRUE;

}

__declspec(dllexport)
int FindTextureInCollection(DWORD t_ww, DWORD t_hh, DWORD t_bpp, DWORD t_Pitch, LPVOID t_pData,
                            LPVOID dumps, DWORD dumps_size, DWORD samples, BOOL lazy_check)
{
    DWORD i, t_bypp = t_bpp/8;
    DUMP * texture_dump = (DUMP*)dumps;
    for (i=0; i<dumps_size; i++)
    {
        if ( (texture_dump->found && lazy_check) ||
             (texture_dump->ww != t_ww) ||
             (texture_dump->hh != t_hh) ||
             (texture_dump->bypp != t_bypp) )
        {
            texture_dump++;
            continue;
        }

        if (texture_dump->isOptimized) {

           if (CompareTextAndCompiledDumps(
                       t_ww, t_hh, t_Pitch, t_pData, texture_dump))
               return i+1;

        } else {
           if (CompareTextAndDump(
                       t_ww, t_hh, t_Pitch, t_pData, texture_dump, samples))
               return i+1;
        }
        texture_dump++;
    }
    return 0;
}

BOOL __inline CompareDXTnTextAndCompiledDump(DWORD t_ww, DWORD t_hh, DWORD t_Pitch, LPVOID t_pData,
                                             DUMP * dump, DWORD bytes_per_rowblock)
{
    DWORD i, jump = t_hh/dump->samples;
    for (i=0; i<dump->samples; i++)
    {
#ifdef _WIN64
        if (memcmp((LPVOID) ((LONG64)dump->pData + bytes_per_rowblock *  i),
                   (LPVOID) ((LONG64)t_pData + t_Pitch * jump * i),
                   bytes_per_rowblock) != 0)
                return FALSE;
#else
        if (memcmp((LPVOID) ((DWORD)dump->pData + bytes_per_rowblock *  i),
                   (LPVOID) ((DWORD)t_pData + t_Pitch * jump * i),
                   bytes_per_rowblock) != 0)
                return FALSE;
#endif
    } return TRUE;
}

BOOL __inline CompareDXTnTextAndDump(DWORD t_ww, DWORD t_hh, DWORD t_Pitch, LPVOID t_pData,
                                     DUMP * dump, DWORD samples, DWORD bytes_per_rowblock)
{
    DWORD i, jump = t_hh/samples;
    for (i=0; i<samples; i++)
    {
#ifdef _WIN64
        if (memcmp((LPVOID) ((LONG64)dump->pData + bytes_per_rowblock * jump * i),
                   (LPVOID) ((LONG64)t_pData + t_Pitch * jump * i),
                   bytes_per_rowblock) != 0)
                return FALSE;
#else
        if (memcmp((LPVOID) ((DWORD)dump->pData + bytes_per_rowblock * jump * i),
                   (LPVOID) ((DWORD)t_pData + t_Pitch * jump * i),
                   bytes_per_rowblock) != 0)
                return FALSE;
#endif
    } return TRUE;
}

__declspec(dllexport)
int FindDXTnTextureInCollection(DWORD t_ww, DWORD t_hh, DWORD t_bpp, DWORD t_Pitch, LPVOID t_pData,
                                LPVOID dumps, DWORD dumps_size, DWORD samples, BOOL lazy_check)
{
    DWORD i, t_bypp = t_bpp;
    DUMP * texture_dump = (DUMP*)dumps;
    DWORD n_bytes = (t_ww/4) * (8 + 8*texture_dump->bypp);
    for (i=0; i<dumps_size; i++)
    {
        if ( (texture_dump->found && lazy_check) ||
             (texture_dump->ww != t_ww) ||
             (texture_dump->hh != t_hh) ||
             (texture_dump->bypp != t_bypp) )
        {
            texture_dump++;
            continue;
        }
        if (texture_dump->isOptimized) {
            if (CompareDXTnTextAndCompiledDump(
                           t_ww, (t_hh + 3)/4, t_Pitch, t_pData, texture_dump, n_bytes))
                   return i+1;
        } else {
        if (CompareDXTnTextAndDump(
                       t_ww, (t_hh + 3)/4, t_Pitch, t_pData, texture_dump, samples, n_bytes))
               return i+1;
        }
        texture_dump++;
    }
    return 0;
}

__declspec(dllexport) void ChangeGl24BitTextureIndianes(int n_pixels, void * pData)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    typedef struct  {
        BYTE r; BYTE g; BYTE b;
    }_pixel_24;
    BYTE r, b;
    _pixel_24 * pixel = pData;
    while (n_pixels--)
    {
         b = pixel->b;
         r = pixel->r;
         pixel->r = b;
         pixel->b = r;
         pixel++;
    }
}

void A4R4G4B4_2_A8R8G8B8(void * pSurface, int pitch, int ww, int hh, void * file_data)
{
    WORD * pixel_16;
    typedef struct  {
        BYTE b; BYTE g; BYTE r; BYTE a;
    }_pixel_32;
    _pixel_32 * pixel_32;

    pixel_16 = file_data;
    pixel_32 = (_pixel_32*) pSurface;
    while (hh--)
    {
        while (ww--)
        {
            pixel_32->a = ((*pixel_16 & 0xf000) >> 12) + ((*pixel_16 & 0xf000) >> 8);
            pixel_32->r = ((*pixel_16 & 0x0f00) >> 8) + ((*pixel_16 & 0x0f00) >> 4);
            pixel_32->g = ((*pixel_16 & 0x00f0)) + ((*pixel_16 & 0x00f0) >> 4);
            pixel_32->b = ((*pixel_16 & 0x000f) << 4) + ((*pixel_16 & 0x000f));
            pixel_32 ++;
            pixel_16 ++;
        } pixel_32 += pitch - ww*2;
    }
}

void deinterlace(unsigned int pSurface, unsigned int pitch, unsigned int hh)
{
    int i;
    int h = hh/2;
    int pitch2 = pitch * 2;
    while (h--)
    {
        memcpy( (void*) (pSurface + pitch), (void*)(pSurface), pitch);
        pSurface += pitch2;
    }
}

__declspec(dllexport) 
DWORD LoadData2Surface(void* pSurface, HANDLE hFile,
                       unsigned int pitch, unsigned int ww, unsigned int hh, int bybp)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    int i, sz = ww * bybp;
    DWORD byres_read = 0;
    for(i = 0; i < hh; i++)
    {
#ifdef _WIN64
        if ( !ReadFile(hFile, (void*) ( (LONGLONG)pSurface + (pitch * i) ),
                sz, &byres_read, NULL)  )
            return GetLastError();
#else
        if ( !ReadFile(hFile, (void*) ( (DWORD)pSurface + (pitch * i) ),
                sz, &byres_read, NULL)  )
            return GetLastError();
#endif
        byres_read = 0;
    } return 0;
}

__declspec(dllexport) 
void copyData2Surface(unsigned int pSurface, unsigned int pData,
                      unsigned int pitch, unsigned int ww, unsigned int hh, int bybp)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    int i, sz = ww * bybp;
    for(i = 0; i < hh; i++)
        memcpy( (void*) (pSurface + pitch * i), (void*)(pData + sz * i), sz);
}

__declspec(dllexport) 
void surfaceCopy(unsigned int pSource, unsigned int Spitch, unsigned int shh,
                 unsigned int pDest, unsigned int Dpitch, unsigned int dhh)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    int i;

    if ( dhh < shh )
        return;

    for(i = 0; i < shh; i++)
        memcpy( (void*)(pDest + Dpitch * i), (void*) (pSource + Spitch * i), Spitch);
}

void CPU_vMirror(unsigned int pSource, unsigned int Spitch, unsigned int shh,
                 unsigned int pDest, unsigned int Dpitch, int sz)
{
    int i;
    for(i = 0; i < shh; i++)
        memcpy( (void*)(pDest + Dpitch * i), (void*) (pSource + Spitch * (shh - i)), sz);
}

__declspec(dllexport)  DWORD Pal2RGB(BYTE * pSrcData, DWORD pSrcPitch, DWORD * Palette,
                                    DWORD * pDstData, DWORD pDstPitch, DWORD ww, DWORD hh,
                                    RECT * rect)
{

    DWORD * dst, temp;
    BYTE * src;
    int w, h;
    if (rect != NULL)
    {
        hh = rect->bottom-rect->top;
        ww = rect->right-rect->left;
        //return hh;
    }
    for (h=0; h<hh; h++)
    {
        src = (BYTE *)((DWORD)pSrcData + pSrcPitch*h);
        dst = (DWORD*)((DWORD)pDstData + pDstPitch*h);
        for(w=0; w<ww; w++)
        {
            temp = Palette[*src];
            *dst = (temp & 0xFF000000) | ((temp & 0xFF0000) >> 16)
                   | (temp & 0x00FF00) | ((temp & 0x0000FF) << 16);
            src++;
            dst++;
        }
    }
    return w;
}


__declspec(dllexport)
void GetDDSFileFormat(DDS_HEADER * h, char * fmt)
{
    DWORD RG6B[3]                  = {0xF800, 0x07e0, 0x001F};
    DWORD X1RGB[3]                 = {0x00007C00, 0x000003E0, 0x0000001F};
    DWORD A1RGB[4]                 = {0x00007C00, 0x000003E0, 0x0000001F, 0x00008000};
    DWORD A4RGB[4]                 = {0x0f00, 0x00f0, 0x000f, 0xf000};
    DWORD A8RGB[4]                 = {0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000};
    DWORD A8BGR[4]                 = {0x000000FF, 0x0000FF00, 0x00FF0000, 0xFF000000};
    DWORD X8RGB[3]                 = {0x00FF0000, 0x0000FF00, 0x000000FF};
    //DWORD RBG[3]                   = {0x00FF0000, 0x0000FF00, 0x000000FF};
    DWORD V8U8[4]                  = {0xFF, 0xFF00, 0, 0};

    if ( (h->ddspf.dwFlags & DDPF_FOURCC) )
    {
        memcpy((void*)fmt, (void*)&h->ddspf.dwFourCC, sizeof(char)*4);
        fmt[4] = 0;
        return;
    }

    if ( !(h->ddspf.dwFlags & DDPF_RGB) )
    {
         strcpy_s(fmt, sizeof(char)*20, "Unsupported format");
         return;
    }

    if (h->ddspf.dwRGBBitCount == 32)
    {
        if (h->ddspf.dwFlags & DDPF_ALPHAPIXELS)
        {
            if (!memcmp(&h->ddspf.dwRBitMask, &A8RGB, sizeof(A8RGB)))
            {
                strcpy_s(fmt, sizeof(char)*6, "A8RGB");
                return;
            }
            else if (!memcmp(&h->ddspf.dwRBitMask, &A8BGR, sizeof(A8BGR)))
            {
                strcpy_s(fmt, sizeof(char)*6, "A8BGR");
                return;
            }
        }
        else
        {
            //return;
            if (!memcmp(&h->ddspf.dwRBitMask, X8RGB, sizeof(X8RGB)))
            {
                strcpy_s(fmt, sizeof(char)*6, "X8RGB");
                return;
            }
        }
    }
    else if (h->ddspf.dwRGBBitCount == 16)
    {
        if (h->ddspf.dwFlags & DDPF_ALPHAPIXELS)
        {
            if (!memcmp(&h->ddspf.dwRBitMask, A1RGB, sizeof(A1RGB)))
            {
                strcpy_s(fmt, sizeof(char)*6, "A1RGB");
                return;
            }
            else if (!memcmp(&h->ddspf.dwRBitMask, A4RGB, sizeof(A4RGB)))
            {
                strcpy_s(fmt, sizeof(char)*6, "A4RGB");
                return;
            }
        } else
        {
            if (!memcmp(&h->ddspf.dwRBitMask, X1RGB, sizeof(X1RGB)))
            {
                strcpy_s(fmt, sizeof(char)*6, "X1RGB");
                return;
            }
            else if (!memcmp(&h->ddspf.dwRBitMask, RG6B, sizeof(RG6B)))
            {
                strcpy_s(fmt, sizeof(char)*6, "RG6B");
                return;
            }
        }
    }
    if (h->ddspf.dwRGBBitCount == 24)
    {
        if (!memcmp(&h->ddspf.dwRBitMask, X8RGB, sizeof(X8RGB)))
        {
            strcpy_s(fmt, sizeof(char)*4, "RGB");
            return;
        }
    }
    strcpy_s(fmt, sizeof(char)*20, "Unsupported format");
    return;
}

__declspec(dllexport)
DWORD DumpDDS(wchar_t * file, char * fmt, DWORD ww, DWORD hh, LPVOID pData, DWORD pitch)
{
    DDS_HEADER        dds;
    HANDLE            hFile;
    DWORD             magic=0x20534444, writen, n_bytes, hlines, i;
    BOOL              b;
    DWORD             bytes_per_pixel;

    ZeroMemory(&dds, sizeof(DDS_HEADER));
    dds.ddspf.dwSize = sizeof(DDS_PIXELFORMAT);

    if ( *(DWORD*)fmt == *(DWORD*)"RG6B" )
    {
        DWORD RG6B[4]             = {0xF800, 0x07e0, 0x001F, 0};
        dds.ddspf.dwFlags         = DDPF_RGB;
        dds.ddspf.dwRGBBitCount   = 16;
        memcpy(&dds.ddspf.dwRBitMask, RG6B, sizeof(DWORD)*4);

    } else if ( *(DWORD*)fmt == *(DWORD*) "X1RGB" )
    {
        DWORD X1RGB[4]            = {0x00007C00, 0x000003E0, 0x0000001F, 0};
        dds.ddspf.dwFlags         = DDPF_RGB;
        dds.ddspf.dwRGBBitCount   = 16;
        memcpy(&dds.ddspf.dwRBitMask, X1RGB, sizeof(DWORD)*4);

    } else if (  *(DWORD*)fmt == *(DWORD*) "A1RGB" )
    {
        DWORD A1RGB[4]            = {0x00007C00, 0x000003E0, 0x0000001F, 0x00008000};
        dds.ddspf.dwFlags         = DDPF_RGB | DDPF_ALPHAPIXELS;
        dds.ddspf.dwRGBBitCount   = 16;
        memcpy(&dds.ddspf.dwRBitMask, A1RGB, sizeof(DWORD)*4);

    } else if (  *(DWORD*)fmt == *(DWORD*) "A4RGB")
    {
        DWORD A4RGB[4]            = {0x0f00, 0x00f0, 0x000f, 0xf000};
        dds.ddspf.dwFlags         = DDPF_RGB | DDPF_ALPHAPIXELS;
        dds.ddspf.dwRGBBitCount   = 16;
        memcpy(&dds.ddspf.dwRBitMask, A4RGB, sizeof(DWORD)*4);

    } else if (  *(DWORD*)fmt == *(DWORD*) "A8RGB" )
    {
        DWORD A8RGB[4]            = {0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000};
        dds.ddspf.dwFlags         = DDPF_RGB | DDPF_ALPHAPIXELS;
        dds.ddspf.dwRGBBitCount   = 32;
        memcpy(&dds.ddspf.dwRBitMask, A8RGB, sizeof(DWORD)*4);

    } else if (  *(DWORD*)fmt == *(DWORD*) "A8BGR" )
    {
        DWORD A8BGR[4]            = {0x000000FF, 0x0000FF00, 0x00FF0000, 0xFF000000};
        dds.ddspf.dwFlags         = DDPF_RGB | DDPF_ALPHAPIXELS;
        dds.ddspf.dwRGBBitCount   = 32;
        memcpy(&dds.ddspf.dwRBitMask, A8BGR, sizeof(DWORD)*4);

    } else if (  *(DWORD*)fmt == *(DWORD*) "X8RGB")
    {
        DWORD X8RGB[4]            = {0x00FF0000, 0x0000FF00, 0x000000FF, 0};
        dds.ddspf.dwFlags         = DDPF_RGB;
        dds.ddspf.dwRGBBitCount   = 32;
        memcpy(&dds.ddspf.dwRBitMask, X8RGB, sizeof(DWORD)*4);

    }  else if (  *(DWORD*)fmt == *(DWORD*) "V8U8")
    {
        DWORD V8U8[4]                 = {0xFF, 0xFF00, 0, 0};
        dds.ddspf.dwFlags             = DDPF_BUMPDUDV;
        dds.ddspf.dwRGBBitCount       = 16;
        memcpy(&dds.ddspf.dwRBitMask, V8U8, sizeof(DWORD)*4);

    } else if (  *(DWORD*)fmt == *(DWORD*) "RGB")
    {
        DWORD _RGB[4]                 = {0xFF0000, 0xFF00, 0xFF, 0};
        dds.ddspf.dwFlags             = DDPF_RGB;
        dds.ddspf.dwRGBBitCount       = 24;
        memcpy(&dds.ddspf.dwRBitMask, _RGB, sizeof(DWORD)*4);

    } else if (  *(char*)fmt == *(char*) "D")
    {
        dds.ddspf.dwFlags             = DDPF_FOURCC;
        dds.ddspf.dwFourCC            = *(DWORD*)fmt;
    } else
    {
        OutputDebugStringA("UNKNOWN FORMAT");
        return 1;
    }
    OutputDebugStringA("So far so good");

    if (dds.ddspf.dwRGBBitCount) bytes_per_pixel = dds.ddspf.dwRGBBitCount/8;
    dds.dwWidth            = ww;
    dds.dwHeight           = hh;
    dds.dwSize             = sizeof(DDS_HEADER);
    dds.dwCaps             = DDSCAPS_TEXTURE;
    if (*(DWORD*)fmt == *(DWORD*) "DXT1")
    {
       OutputDebugStringA("DXT1");
       //dds.dwPitchOrLinearSize = ww*2;
       dds.dwPitchOrLinearSize = ww/4 * hh/4 * 8;
    }
    else if ( *(char*)fmt == *(char*) "D")
    {
       OutputDebugStringA("DXTn");
       //dds.dwPitchOrLinearSize = ww*4;
       dds.dwPitchOrLinearSize = ww/4 * hh/4 * 16;
    }
    else
    {
       OutputDebugStringA("RGB");
       dds.dwPitchOrLinearSize = ww * bytes_per_pixel;
    }

    dds.dwFlags = DDSD_HEIGHT | DDSD_WIDTH | DDSD_PIXELFORMAT | DDSD_CAPS;
    if ( *(char*)fmt == *(char*) "D")  dds.dwFlags |= DDSD_LINEARSIZE;
    else                               dds.dwFlags |= DDSD_PITCH;


    hFile = CreateFileW(file, GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
                        CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE) return 2;

    b = WriteFile(hFile, &magic, 4, &writen, NULL);
    if ( !b  )
    {
        CloseHandle(hFile);
        return 3;
    }

    b = WriteFile(hFile, &dds, sizeof(dds), &writen, NULL);
    if ( !b  )
    {
        CloseHandle(hFile);
        return 4;
    }

    if (*(DWORD*)fmt == *(DWORD*) "DXT1")
    {
        n_bytes = (dds.dwWidth/4) * 8;
        hlines  = (dds.dwHeight + 3) / 4;
        for (i=0; i<hlines; i++)
        {
            #ifdef _WIN64
                WriteFile(hFile, (UINT64)pData+pitch*i, n_bytes, &writen, NULL);
            #else
                WriteFile(hFile, (DWORD)pData+pitch*i, n_bytes, &writen, NULL);
            #endif
        }
    }
    else if (*(char*)fmt == *(char*) "D")
    {
        n_bytes = (dds.dwWidth/4) * 16;
        hlines  = (dds.dwHeight + 3) / 4;
        for (i=0; i<hlines; i++)
        {
            #ifdef _WIN64
                WriteFile(hFile, (DWORD)pData+pitch*i, n_bytes, &writen, NULL);
            #else
                WriteFile(hFile, (DWORD)pData+pitch*i, n_bytes, &writen, NULL);
            #endif
        }
    }
    else
    {
        n_bytes = dds.dwWidth * bytes_per_pixel;
        hlines  = dds.dwHeight;
        for (i=0; i<hlines; i++)
        {
            #ifdef _WIN64
               WriteFile(hFile, (UINT64)pData+pitch*i, n_bytes, &writen, NULL);
            #else
                WriteFile(hFile, (DWORD)pData+pitch*i, n_bytes, &writen, NULL);
            #endif
        }
    }

    CloseHandle(hFile);
    return 0;
}

DWORD GetClrFormat(char * fmt, PIXEL_FORMAT * px)
{
    if (*(DWORD*)fmt == *(DWORD*) "RG6B")
    {
        px->Red_Mask   = 0xF800;
        px->Green_Mask = 0x07E0;
        px->Blue_Mask  = 0x001f;

        px->Red_Shift   = 11;
        px->Green_Shift = 5;
        px->Blue_Shift  = 0;

        px->Red_Bits   = 31;
        px->Green_Bits = 63;
        px->Blue_Bits  = 31;
    }
    else if (*(DWORD*)fmt == *(DWORD*) "X1RGB")
    {
        px->Red_Mask   = 0x00007C00;
        px->Green_Mask = 0x000003E0;
        px->Blue_Mask  = 0x0000001F;

        px->Red_Shift   = 10;
        px->Green_Shift = 5;
        px->Blue_Shift  = 0;

        px->Red_Bits   = 31;
        px->Green_Bits = 31;
        px->Blue_Bits  = 31;
    }
    else if (*(DWORD*)fmt == *(DWORD*) "X8RGB")
    {
        px->Red_Mask   = 0x00ff0000;
        px->Green_Mask = 0x0000ff00;
        px->Blue_Mask  = 0x000000ff;

        px->Red_Shift   = 16;
        px->Green_Shift = 8;
        px->Blue_Shift  = 0;

        px->Red_Bits   = 255;
        px->Green_Bits = 255;
        px->Blue_Bits  = 255;
    }
    else if (*(DWORD*)fmt == *(DWORD*) "A8RGB")
    {
        px->Red_Mask   = 0x00ff0000;
        px->Green_Mask = 0x0000ff00;
        px->Blue_Mask  = 0x000000ff;
        px->Alpha_Mask = 0xff000000;

        px->Red_Shift   = 16;
        px->Green_Shift = 8;
        px->Blue_Shift  = 0;
        px->Alpha_Shift = 24;

        px->Red_Bits   = 255;
        px->Green_Bits = 255;
        px->Blue_Bits  = 255;
        px->Alpha_Bits  = 255;
    }
    else if (*(DWORD*)fmt == *(DWORD*) "A4RGB")
    {
        px->Red_Mask   = 0x00000f00;
        px->Green_Mask = 0x000000f0;
        px->Blue_Mask  = 0x0000000f;
        px->Alpha_Mask = 0x0000f000;

        px->Red_Shift   = 8;
        px->Green_Shift = 4;
        px->Blue_Shift  = 0;
        px->Alpha_Shift = 12;

        px->Red_Bits   = 15;
        px->Green_Bits = 15;
        px->Blue_Bits  = 15;
        px->Alpha_Bits = 15;
    }
}

__declspec(dllexport)
DWORD Clr2clr(char * in, char * out, DWORD clr)
{
    if (clr == 0) return 0;
    DWORD red, green, blue, alpha, src_alpha;
    PIXEL_FORMAT pxin, pxout;
    GetClrFormat(in, &pxin);
    GetClrFormat(out, &pxout);
    if   (*(BYTE*)in == *(BYTE*)"A") src_alpha = 1;
    else                             src_alpha = 0;

    if (src_alpha)
    alpha = ((clr & pxin.Alpha_Mask) >> pxin.Alpha_Shift)/pxin.Alpha_Bits;
    red   = ((clr & pxin.Red_Mask) >> pxin.Red_Shift)/pxin.Red_Bits;
    green = ((clr & pxin.Green_Mask) >> pxin.Green_Shift)/pxin.Green_Bits;
    blue  = ((clr & pxin.Blue_Mask) >> pxin.Blue_Shift)/pxin.Blue_Bits;


    if (! src_alpha)
    alpha = *(DWORD*)out == *(DWORD*) "A8RGB" ? 0xFF << 24 : 0;
    else
    alpha = (alpha * pxout.Alpha_Bits) << pxout.Alpha_Shift;
    red   = (red * pxout.Red_Bits) << pxout.Red_Shift;
    green = (green * pxout.Green_Bits) << pxout.Green_Shift;
    blue  = (blue * pxout.Blue_Bits) << pxout.Blue_Shift;

    return red | blue | green | alpha;
}
