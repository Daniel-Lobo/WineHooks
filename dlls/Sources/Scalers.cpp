#include <windows.h>
#include "collections.h"
#ifndef _WIN64
#include "D3DHooks.h"
#endif
#include <stdio.h>

typedef struct __SCALER {
    POINTER_DICTIONARY * w;
    POINTER_DICTIONARY * h;
    DWORD  StepXSrc, StepXDst, StepYSrc, StepYDst;
    DWORD  xOffset;
    RECT   src, dst;
    RECT * pSrc, * pDst;
}SCALER;

extern "C" __declspec(dllexport)
DWORD Scaler(DWORD src_w, DWORD src_h, DWORD dst_w, DWORD dst_h,
             DWORD x, SCALER * s)
{
    if (s->w == NULL)
    {
        s->w = new POINTER_DICTIONARY();
        s->h = new POINTER_DICTIONARY();
        s->pSrc = &s->src;
        s->pDst = &s->dst;
    }

    DWORD count = s->w->Count();
    for (DWORD i=0; i<count; i++)
        s->w->discard(s->w->KeyAt(0));
    count = s->h->Count();
    for (DWORD i=0; i<count; i++)
        s->h->discard(s->h->KeyAt(0));
    s->xOffset = x;

    DWORD MCD         = 0;
    DWORD divident    = dst_w;
    DWORD divisor     = src_w;
    DWORD remainder   = divident % divisor;
    while(remainder != 0)
    {
        divident  = divisor;
        divisor   = remainder;
        remainder = divident % divisor;
    }
    MCD          = divisor;
    s->StepXSrc  = src_w/MCD;
    s->StepXDst  = dst_w/MCD;
    for(DWORD i=1; i<=MCD; i++)
        s->w->insert_disposable((LPVOID)(s->StepXSrc*i), (LPVOID)(s->StepXDst*i));

    divident    = dst_h;
    divisor     = src_h;
    remainder   = divident % divisor;
    while(remainder != 0)
    {
        divident  = divisor;
        divisor   = remainder;
        remainder = divident % divisor;
    }
    MCD          = divisor;
    s->StepYSrc  = src_h/MCD;
    s->StepYDst  = dst_h/MCD;
    for(DWORD i=1; i<=MCD; i++)
        s->h->insert_disposable((LPVOID)(s->StepYSrc*i), (LPVOID)(s->StepYDst*i));
    return MCD ;
}

#ifndef _WIN64
extern "C" __declspec(dllexport)
DWORD Scale(RECT * r, SCALER * s)
{
    DWORD x, y, w, h;
    if (!r)
    {
        s->pSrc       = 0;
        s->dst.left   = (LONG)D3DHooksData->displacement;
        s->dst.right  = (LONG)D3DHooksData->W-s->dst.left;
        s->dst.top    = 0;
        s->dst.bottom = (LONG)D3DHooksData->H;
        return 0;
    }
    s->pSrc = &s->src;

    x = r->left/s->StepXSrc;
    if(x == 0)
    {
        s->src.left = 0;
        s->dst.left = 0;
    } else{
        s->src.left = (DWORD) s->w->KeyAt(x-1);
        s->dst.left = (DWORD) s->w->ValueAt(x-1);
    }
    s->dst.left+=s->xOffset;

    w = r->right/s->StepXSrc;
    if(w == 0)
    {
        s->src.right = (DWORD) s->StepXSrc;
        s->dst.right = (DWORD) s->StepXDst;
    }
    else if(w == s->w->Count())
    {
        s->src.right = (DWORD) s->w->KeyAt(w-1);
        s->dst.right = (DWORD) s->w->ValueAt(w-1);
    } else {
        s->src.right = (DWORD) s->w->KeyAt(w);
        s->dst.right = (DWORD) s->w->ValueAt(w);
    }
    s->dst.right+=s->xOffset;

    y = r->top/s->StepYSrc;
    if(y == 0)
    {
        s->src.top = 0;
        s->dst.top = 0;
    } else{
        s->src.top = (DWORD) s->h->KeyAt(y-1);
        s->dst.top = (DWORD) s->h->ValueAt(y-1);
    }

    h = r->bottom/s->StepYSrc;
    if(h == 0)
    {
        s->src.bottom = (DWORD) s->StepYSrc;
        s->dst.bottom = (DWORD) s->StepYDst;
    }
    else if(h == s->h->Count())
    {
        s->src.bottom = (DWORD) s->h->KeyAt(h-1);
        s->dst.bottom = (DWORD) s->h->ValueAt(h-1);
    } else {
        s->src.bottom = (DWORD) s->h->KeyAt(h);
        s->dst.bottom = (DWORD) s->h->ValueAt(h);
    }
    return 1;
}

extern "C"
{
    void scale_and_displace(XYZRHW *vtx, DWORD n, DWORD stride)
    {
        for (DWORD i=0; i<n; i++)
        {
            vtx->x *= D3DHooksData->scale_delta;
            vtx->y *= D3DHooksData->scale_delta;
            vtx->x += D3DHooksData->displacement;
            vtx     = (XYZRHW*)((DWORD)vtx+stride);
        }
    }

    void scale_displace_and_fixcoords(XYZRHW *vtx, DWORD n, DWORD stride)
    {
        for (DWORD i=0; i<n; i++)
        {
            vtx->x *= D3DHooksData->scale_delta;
            vtx->y *= D3DHooksData->scale_delta;
            vtx->x += D3DHooksData->displacement;
            vtx->x -= 0.5;
            vtx->y -= 0.5;
            vtx     = (XYZRHW*)((DWORD)vtx+stride);
        }
    }

    void scale_and_displace_indexed(XYZRHW *vtx, XYZRHW *ivtx, WORD * pIndex, DWORD n,
                                    DWORD stride)
    {
        for(DWORD i = 0; i < n; i++)
        {
            memcpy(vtx, (void*)((DWORD)ivtx+*pIndex*stride), stride);
            vtx->x *= D3DHooksData->scale_delta;
            vtx->y *= D3DHooksData->scale_delta;
            vtx->x += D3DHooksData->displacement;
            vtx = (XYZRHW*)((DWORD)vtx+stride);
            pIndex ++;
        }
    }

    void scale_displace_and_fixcoords_indexed(XYZRHW *vtx, XYZRHW *ivtx, WORD * pIndex,
                                              DWORD n, DWORD stride)
    {
        for(DWORD i = 0; i < n; i++)
        {
            memcpy(vtx, (void*)((DWORD)ivtx+*pIndex*stride), stride);
            vtx->x *= D3DHooksData->scale_delta;
            vtx->y *= D3DHooksData->scale_delta;
            vtx->x += D3DHooksData->displacement;
            vtx->x -= 0.5;
            vtx->y -= 0.5;
            vtx = (XYZRHW*)((DWORD)vtx+stride);
            pIndex ++;
        }
    }
}
#endif

extern "C" __declspec(dllexport)
RECT * ScaleX(RECT* r, float s)
{
    static RECT rct;
    if (r == NULL) return NULL;
    rct.left   = r->left * s;
    rct.top    = r->top * s;
    rct.right  = r->right * s;
    rct.bottom = r->bottom * s;
    return &rct;
}

extern "C" __declspec(dllexport)
DWORD _Scale(DWORD left, DWORD top, DWORD right, DWORD bottom, SCALER * s)
{
    DWORD x, y, w, h;
    s->pSrc = &s->src;

    x = left/s->StepXSrc;
    if(x == 0)
    {
        s->src.left = 0;
        s->dst.left = 0;
    } else{
        s->src.left = (DWORD) s->w->KeyAt(x-1);
        s->dst.left = (DWORD) s->w->ValueAt(x-1);
    }
    s->dst.left+=s->xOffset;

    w = right/s->StepXSrc;
    if(w == 0)
    {
        s->src.right = (DWORD) s->StepXSrc;
        s->dst.right = (DWORD) s->StepXDst;
    }
    else if(w == s->w->Count())
    {
        s->src.right = (DWORD) s->w->KeyAt(w-1);
        s->dst.right = (DWORD) s->w->ValueAt(w-1);
    } else {
        s->src.right = (DWORD) s->w->KeyAt(w);
        s->dst.right = (DWORD) s->w->ValueAt(w);
    }
    s->dst.right+=s->xOffset;

    y = top/s->StepYSrc;
    if(y == 0)
    {
        s->src.top = 0;
        s->dst.top = 0;
    } else{
        s->src.top = (DWORD) s->h->KeyAt(y-1);
        s->dst.top = (DWORD) s->h->ValueAt(y-1);
    }

    h = bottom/s->StepYSrc;
    if(h == 0)
    {
        s->src.bottom = (DWORD) s->StepYSrc;
        s->dst.bottom = (DWORD) s->StepYDst;
    }
    else if(h == s->h->Count())
    {
        s->src.bottom = (DWORD) s->h->KeyAt(h-1);
        s->dst.bottom = (DWORD) s->h->ValueAt(h-1);
    } else {
        s->src.bottom = (DWORD) s->h->KeyAt(h);
        s->dst.bottom = (DWORD) s->h->ValueAt(h);
    }
    return 1;
}


#define LINEAR_FROM_POINTS(x0, y0, x1, y1) (y0*x1 - y1*x0)/(x1-x0);
#define ANGULAR_FROM_LINEAR(x0, y0, b) ((y0-b)/x0)
#define PERPENDICULAR(a) (-1./a)

extern "C" __declspec(dllexport)
float Line2Rect(float x0, float y0, float x1, float y1, float rect[16])
{
    float b  = LINEAR_FROM_POINTS(x0, y0, x1, y1);
    float a  = ANGULAR_FROM_LINEAR(x0, y0, b);
    float ap = PERPENDICULAR(a);
    char log[200];
    snprintf(log, sizeof(log), "%s%f%s%f"," Lnr ", b, " Angular ", a);
    OutputDebugStringA(log);
    return b;
}
