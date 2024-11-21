#ifndef D3D_DDI_H
#define D3D_DDI_H
#include "d3dumddi.h"
extern void d3dddiSetOverride(HANDLE);
extern void d3dddiDeletePxShader(HANDLE);
HANDLE d3dddiCreatePxShader(const UINT*, UINT);
void d3dddiDeletePxShader(HANDLE hShader);
HRESULT APIENTRY d3dddiSetVertexShader(HANDLE);
HANDLE d3dddiCreateVxShader(const UINT*, UINT);
void d3dddiDeleteVxShader(HANDLE);
BOOL AreVerticesTransFormed();
#endif // D3D_DDI_H
