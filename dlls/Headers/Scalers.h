#ifndef SCALERS_H
#define SCALERS_H
#include <windows.h>
#ifndef _WIN64
#include "D3DHooks.h"
extern void scale_and_displace(XYZRHW *, DWORD, DWORD);
extern void scale_displace_and_fixcoords(XYZRHW *, DWORD, DWORD);
extern void scale_and_displace_indexed(XYZRHW *, XYZRHW *, WORD *, DWORD, DWORD);
extern void scale_displace_and_fixcoords_indexed(XYZRHW *, XYZRHW *, WORD *, DWORD, DWORD);
#endif //_WIN64
#endif // SCALERS_H
