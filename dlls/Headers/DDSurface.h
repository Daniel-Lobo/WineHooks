#ifndef DDSURFACE
#define DDSURFACE
#include <windows.h>
#ifdef __cplusplus
#include "collections.h"
#endif

__declspec(dllexport) DWORD Pal2RGB(BYTE *, DWORD, DWORD *, DWORD *, DWORD, DWORD, DWORD, RECT *);

__declspec(dllexport)
extern int FindTextureInCollection(DWORD , DWORD , DWORD , DWORD , LPVOID,
                                   LPVOID, DWORD , DWORD , BOOL );
__declspec(dllexport)
extern int FindDXTnTextureInCollection(DWORD , DWORD , DWORD , DWORD , LPVOID,
                                       LPVOID, DWORD , DWORD , BOOL );

extern DWORD LoadData2Surface(void*, HANDLE, unsigned int, unsigned int, unsigned int, int);
__declspec(dllexport)
extern DWORD DumpDDS(wchar_t *, char *, DWORD, DWORD, LPVOID, DWORD);

extern BOOL RectCoversEntireSurface(RECT*, UINT, UINT);

typedef struct {
    DWORD ww;
    DWORD hh;
    DWORD bypp;
    LPVOID pData;
    DWORD samples;
    BOOL  isOptimized;
    BOOL  found;
} DUMP;

typedef struct _DDS_PIXELFORMAT {
  DWORD dwSize;
  DWORD dwFlags;
  DWORD dwFourCC;
  DWORD dwRGBBitCount;
  DWORD dwRBitMask;
  DWORD dwGBitMask;
  DWORD dwBBitMask;
  DWORD dwABitMask;
} DDS_PIXELFORMAT;

typedef struct _DDS_HEADER{
  DWORD           dwSize;
  DWORD           dwFlags;
  DWORD           dwHeight;
  DWORD           dwWidth;
  DWORD           dwPitchOrLinearSize;
  DWORD           dwDepth;
  DWORD           dwMipMapCount;
  DWORD           dwReserved1[11];
  DDS_PIXELFORMAT ddspf;
  DWORD           dwCaps;
  DWORD           dwCaps2;
  DWORD           dwCaps3;
  DWORD           dwCaps4;
  DWORD           dwReserved2;
} DDS_HEADER;

typedef struct _PIXEL_FORMAT{
  DWORD           Red_Mask;
  DWORD           Green_Mask;
  DWORD           Blue_Mask;
  DWORD           Alpha_Mask;
  DWORD           Red_Shift;
  DWORD           Green_Shift;
  DWORD           Blue_Shift;
  DWORD           Alpha_Shift;
  DWORD           Red_Bits;
  DWORD           Green_Bits;
  DWORD           Blue_Bits;
  DWORD           Alpha_Bits;
} PIXEL_FORMAT;

__declspec(dllexport)
void GetDDSFileFormat(DDS_HEADER *, char *);


#ifdef __cplusplus
struct COMPILED_DUMP {
    char    path[510] = {};
    DWORD     offset, size;
};

class TextureDumps {
    public:
    TextureDumps(){m_Dumps = new POINTER_DICTIONARY();}
    UINT                       AppendDump(char *);   
    UINT                LoadDumps(char *, char *);
    UINT                         IsDump(char *  );
    LPVOID Find(UINT, UINT, UINT, char *, byte *);
    DWORD GetType(char* fmt)
    {
        for (UINT i=0; i<15; i++)
        {
            if (*(DWORD*)fmt == *(DWORD*)m_formats[i])
            {
                return i<3 ? *(DWORD*)"RGB32" : i<4 ? *(DWORD*)"DXT1"
                : i<8 ? *(DWORD*)"DXTn" : i<14 ? *(DWORD*) "RGB16"
                : *(DWORD*) "RGB24";
            }
        }
        return 0;
    }
    UINT                 m_sample_count =       4;
    POINTER_DICTIONARY        * m_Dumps = nullptr;
    static constexpr char * m_formats[15] =
    {"A8BGR", "A8RGB", "X8RGB",                            /* RGB32 [<3]  */
     "DXT1",                                               /* DXT1  [<4]  */
     "DXT2", "DXT3", "DXT4", "DXT5",                       /* DXTn  [<8]  */
     "X1RGB", "A1RGB", "A4RGB", "RG6B", "L6V5U5", "V8U8",  /* RGB16 [<14] */
     "RGB"};
};

interface TextureDump;
class   TextureDump32;
class   TextureDump16;
class TextureDumpDXT1;
class TextureDumpDXTn;

#endif

#endif // DDSURFACE

