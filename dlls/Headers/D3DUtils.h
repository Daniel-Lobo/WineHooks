#ifndef D3DUTILS
#define D3DUTILS

#include <memory>
#include <ddraw.h>
#include "DirectDraw.h"

unique_ptr<string>DDrawLoadSurface(DirectDrawSurface*, IUnknown**, const char*);
unique_ptr<string>DescribeDDSrfcPixelFormatA(DDPIXELFORMAT*);
unique_ptr<wstring>DescribeDDSrfcPixelFormat(DDPIXELFORMAT*);
unique_ptr<string>DDrawCreateSurfacefromSurface(DirectDrawSurface*, IUnknown**, DWORD, char*);
unique_ptr<wstring>DumpLockedDirectDrawSurface(DirectDrawSurface*, LPVOID, DWORD);


#endif // D3DUTILS

