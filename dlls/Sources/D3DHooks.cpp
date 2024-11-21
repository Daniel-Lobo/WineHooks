#include <windows.h>
#include "collections.h"
#include <ddraw.h>
//#include <d3d.h>

#include "D3D12Hooks.h"
#include "D3DHooks.h"
#include "dllmain.h"
#include "Sync.h"
#include <memory>
#include <string>
#include "Dbug.h"
#include <tlhelp32.h>
extern "C"{
#include "Scalers.h"
}

DWORD                     lastcore;
D3DHOOKS_DATA       * D3DHooksData;
POINTER_DICTIONARY         * locks;
D3DGLOBALS              D3DGlobals;

void D3DGLOBALS::InsertSurface(DirectDrawSurface* srfc) {
    if (0 == g_d3d.TEXTURE_SWAP_ENABLED) return;
    this->Surfaces.push_back(srfc);
};

void D3DGLOBALS::RemoveSurface(DirectDrawSurface* srfc) {
    if (0 == g_d3d.TEXTURE_SWAP_ENABLED) return;
    if (0 == this->Surfaces.size())      return;
    for (auto it = this->Surfaces.begin(); it != this->Surfaces.end(); it++) {
        if (*it == srfc) {
            this->Surfaces.erase(it);
            break;
        }
    }
    this->AdjustIndex();
};

void D3DGLOBALS::InsertHandle(D3DTEXTUREHANDLE handle, DirectDrawSurface* srfc) {
    if (this->Handles.count(handle) == 1) this->Handles.erase(handle);
    this->Handles[handle] = srfc;
}
void D3DGLOBALS::RemoveHandle(D3DTEXTUREHANDLE handle) {
    if (this->Handles.count(handle) == 1) this->Handles.erase(handle);
}

void DDrawDisplayModeChanged(UINT w, UINT h)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d.Setup(w, h, "ddraw");
}

HRESULT InitD3DHooksData(D3DHOOKS_DATA * dat)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d.Init();
    g_d3d.ApplyCommonHooks(0);

    D3DHooksData = dat;
    locks        = new POINTER_DICTIONARY();     

    SYSTEM_INFO nfo;
    GetSystemInfo(&nfo);
    lastcore = 1<<(nfo.dwNumberOfProcessors-1);
    OUTPUT_FUNC_DBG_STRING( (std::string("Found ")+std::to_string(nfo.dwNumberOfProcessors)+" Processors").c_str() );
    return sizeof(D3DHOOKS_DATA);
}

HRESULT STDMETHODCALLTYPE FlipHook(LPVOID p1, LPVOID p2, LPVOID p3)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDLOCK();
    return D3DHooksData->Flip(p1, p2, p3);
}

HRESULT STDMETHODCALLTYPE LockSurfaceHook(LPVOID pSurf, LPVOID p2, LPVOID p3,
                                          LPVOID p4, LPVOID p5)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    //DBUG_WARN((STR("LOCK HOOK: this=[") + to_string((long)pSurf) + "]").c_str())
    DDSCAPS2   caps2;
    D3DHooksData->GetDDSCaps(pSurf, &caps2);
    if ( (caps2.dwCaps & DDSCAPS_PRIMARYSURFACE) ||
         (caps2.dwCaps & DDSCAPS_3DDEVICE)       ||
         (caps2.dwCaps & DDSCAPS_FLIP)           ||
         (caps2.dwCaps & DDSCAPS_ZBUFFER))
    {
         if (caps2.dwCaps & DDSCAPS_PRIMARYSURFACE)
         {
             if (p2) memcpy(D3DHooksData->_LockedRect, p2, sizeof(RECT));
             else {
                 D3DHooksData->_LockedRect->left    = 0;
                 D3DHooksData->_LockedRect->top     = 0;
                 D3DHooksData->_LockedRect->right   = D3DHooksData->Rqstd_w;
                 D3DHooksData->_LockedRect->bottom  = D3DHooksData->Rqstd_h;
             }
         } else if (caps2.dwCaps & DDSCAPS_3DDEVICE) {
             if (p2) memcpy(D3DHooksData->LockedRect, p2, sizeof(RECT));
             else {
                 D3DHooksData->LockedRect->left    = 0;
                 D3DHooksData->LockedRect->top     = 0;
                 D3DHooksData->LockedRect->right   = D3DHooksData->Rqstd_w;
                 D3DHooksData->LockedRect->bottom  = D3DHooksData->Rqstd_h;
            }
         }
         DDLOCK();
         return D3DHooksData->LockPrimary(pSurf, p2, p3, p4, p5);
    }
    return D3DHooksData->LockSurface(pSurf, p2, p3, p4, p5);
}

HRESULT STDMETHODCALLTYPE UnLockSurfaceHook(LPVOID pSurf, LPVOID p2)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDSCAPS2   caps2;
    //DBUG_WARN((STR("UNLOCK HOOK: this=[") + to_string((long)pSurf) + "]").c_str())
    D3DHooksData->GetDDSCaps(pSurf, &caps2);
    if ( (caps2.dwCaps & DDSCAPS_PRIMARYSURFACE)||
         (caps2.dwCaps & DDSCAPS_3DDEVICE)      ||
         (caps2.dwCaps & DDSCAPS_FLIP)          ||
         (caps2.dwCaps & DDSCAPS_ZBUFFER))
    {
        //DDLOCK()
        return D3DHooksData->UnLockPrimary(pSurf, p2);
    }
    return D3DHooksData->UnLockSurface(pSurf, p2);
}

HRESULT STDMETHODCALLTYPE UnLockSurface4Hook(LPVOID pSurf, LPVOID p2)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    //DBUG_WARN((STR("UNLOCK4 HOOK: this=[") + to_string((long)pSurf) + "]").c_str())
    DDSCAPS2   caps2;
    D3DHooksData->GetDDSCaps(pSurf, &caps2);
    if ( (caps2.dwCaps & DDSCAPS_PRIMARYSURFACE)||
         (caps2.dwCaps & DDSCAPS_3DDEVICE)      ||
         (caps2.dwCaps & DDSCAPS_FLIP)          ||
         (caps2.dwCaps & DDSCAPS_ZBUFFER))
    {
        //DDLOCK()
        return D3DHooksData->UnLockPrimary4(pSurf, p2);
    }
    return D3DHooksData->UnLockSurface4(pSurf, p2);
}

HRESULT STDMETHODCALLTYPE SurfaceBltHook(LPVOID pSurf, LPVOID p2, LPVOID p3,
                                          LPVOID p4, LPVOID p5, LPVOID p6)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDSCAPS2   caps2;
    DDSCAPS2 srccaps;
    D3DHooksData->GetDDSCaps(pSurf, &caps2);
    D3DHooksData->GetDDSCaps(p3, &srccaps);
    if ( (caps2.dwCaps & DDSCAPS_PRIMARYSURFACE)   ||
         (caps2.dwCaps & DDSCAPS_3DDEVICE)         ||
         (caps2.dwCaps & DDSCAPS_FLIP)             ||
         (caps2.dwCaps & DDSCAPS_ZBUFFER)          ||
         (srccaps.dwCaps & DDSCAPS_PRIMARYSURFACE) ||
         (srccaps.dwCaps & DDSCAPS_FLIP))
    {
         DDLOCK()
         return D3DHooksData->BltPrimary(pSurf, p2, p3, p4, p5, p6);
    }
    return D3DHooksData->BltSurface(pSurf, p2, p3, p4, p5, p6);
}

HRESULT STDMETHODCALLTYPE SurfaceBltFastHook(LPVOID pSurf, LPVOID p2, LPVOID p3,
                                              LPVOID p4, LPVOID p5, LPVOID p6)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDSCAPS2   caps2;
    DDSCAPS2 srccaps;
    D3DHooksData->GetDDSCaps(pSurf, &caps2);
    D3DHooksData->GetDDSCaps(p4, &srccaps);
    if ( (caps2.dwCaps & DDSCAPS_PRIMARYSURFACE)   ||
         (caps2.dwCaps & DDSCAPS_3DDEVICE)         ||
         (caps2.dwCaps & DDSCAPS_FLIP)             ||
         (srccaps.dwCaps & DDSCAPS_FLIP)           ||
         (srccaps.dwCaps & DDSCAPS_PRIMARYSURFACE) ||
         (srccaps.dwCaps & DDSCAPS_3DDEVICE))
    {
         return D3DHooksData->BltFastPrimary(pSurf, p2, p3, p4, p5, p6);
    }
    return D3DHooksData->BltFastSurface(pSurf, p2, p3, p4, p5, p6);
}

HRESULT STDMETHODCALLTYPE SurfaceGetDCHook(LPVOID pSurf, LPVOID DC)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDSCAPS2   caps2;
    D3DHooksData->GetDDSCaps(pSurf, &caps2);
    if ( (caps2.dwCaps & DDSCAPS_PRIMARYSURFACE) ||
         (caps2.dwCaps & DDSCAPS_3DDEVICE)       ||
         (caps2.dwCaps & DDSCAPS_FLIP))
    {
        return D3DHooksData->GetDCPrimary(pSurf, DC);
    }
    return D3DHooksData->GetDCSurface(pSurf, DC);
}

HRESULT STDMETHODCALLTYPE SurfaceReleaseDCHook(LPVOID pSurf, LPVOID DC)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DDSCAPS2   caps2;
    D3DHooksData->GetDDSCaps(pSurf, &caps2);
    if ( (caps2.dwCaps & DDSCAPS_PRIMARYSURFACE) ||
         (caps2.dwCaps & DDSCAPS_3DDEVICE)       ||
         (caps2.dwCaps & DDSCAPS_FLIP))
    {
        return D3DHooksData->ReleaseDCPrimary(pSurf, DC);
    }
    return D3DHooksData->ReleaseDCSurface(pSurf, DC);
}

DWORD ManagerGetCaps4(LPVOID srfc, BOOL c2)
{
    IDirectDrawSurface4 * s = (IDirectDrawSurface4 *)srfc;
    DDSCAPS2 cps;
    s->GetCaps(&cps);
    return c2 ? cps.dwCaps2 : cps.dwCaps;
}

HRESULT STDMETHODCALLTYPE
ManagerLock4(LPVOID Surf4, LPRECT rect, LPVOID desc, DWORD flags, HANDLE hEvent)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID sysmem_surf4;
    if ( (sysmem_surf4 = D3DHooksData->Manager_sysmem_surfaces->Value(Surf4)) )
        return D3DHooksData->D_Lock(sysmem_surf4, rect, desc, flags, hEvent);
    return D3DHooksData->Manager_Lock(Surf4, rect, desc, flags, hEvent);
}

HRESULT STDMETHODCALLTYPE
ManagerUnLock4(LPVOID Surf4, LPRECT rect)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LPVOID sysmem_surf4;
    if ( sysmem_surf4 = D3DHooksData->Manager_sysmem_surfaces->Value(Surf4) )
    {
        HRESULT hr = D3DHooksData->D_UnLock(sysmem_surf4, rect);
        IDirectDrawSurface4 * s = (IDirectDrawSurface4 *)Surf4;
        if ( ManagerGetCaps4((LPVOID)s, TRUE) & DDSCAPS2_HINTDYNAMIC)
            D3DHooksData->Manager_Blt(s, (DWORD)rect, sysmem_surf4, 0, 0, 0);
        else s->Blt(rect, (IDirectDrawSurface4 *)sysmem_surf4, 0, 0, 0);
        return hr;
    }
    return D3DHooksData->Manager_UnLock(Surf4, rect);
}

HRESULT STDMETHODCALLTYPE
SrfcQueryHook(LPVOID s, REFIID id, LPVOID* t)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if ( IsEqualGUID(id, IID_IDirect3DTexture2) ||
         IsEqualGUID(id, IID_IDirect3DTexture))
        return D3DHooksData->QueryTexture(s, id, t);
    else if (IsEqualGUID(id, IID_IDirect3DHALDevice))
        return D3DHooksData->QueryDevice(s, id, t);
    else
    {
        IDirectDrawSurface * s1;
        if (D3DHooksData->QuerySurface(s, IID_IDirectDrawSurface, (void**)&s1) == 0)
        {
            DDSCAPS c;
            s1->GetCaps(&c);
            s1->Release();
            if ( (c.dwCaps & DDSCAPS_PRIMARYSURFACE) ||
                 (c.dwCaps & DDSCAPS_FLIP)           ||
                 (c.dwCaps & DDSCAPS_ZBUFFER))
                return D3DHooksData->QueryPrimary(s, id, t);
        }
        return D3DHooksData->QuerySurface(s, id, t);
    }
}

HRESULT STDMETHODCALLTYPE DDFromSurface(IDirectDrawSurface * s1)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirectDraw         * dd;
    IUnknown            * Unknown;
    IDirectDrawSurface2 * s2;

    if (S_OK != D3DHooksData->QuerySurface(s1, IID_IDirectDrawSurface2, (void**)&s2))
    return 0;

    s2->Release();
    if (S_OK != s2->GetDDInterface((void**)&Unknown))
    {
        DBUG_WARN("IDirectDrawSurface2::GetDDInterface FAILED")
        return 0;
    }

    Unknown->Release();
    if (S_OK != Unknown->QueryInterface(IID_IDirectDraw, (void**)&dd))
    {
        DBUG_WARN("Unknown->QueryInterface(IID_IDirectDraw) FAILED")
        return 0;
    }

    dd->Release();
    return (HRESULT)dd;
}

/* D3DUtils::WriteOnSurface depende on this using the pointers on the objects vtables, no hooks */
HRESULT STDMETHODCALLTYPE DDFromTexture(IUnknown* t1) 
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirectDraw         * dd;
    IUnknown            * Unknown;
    IDirectDrawSurface2 * s2;

    if (S_OK != t1->QueryInterface(IID_IDirectDrawSurface2, (void**)&s2))
    return 0;

    s2->Release();
    if (S_OK != s2->GetDDInterface((void**)&Unknown))
    return 0;

    Unknown->Release();
    if (S_OK != Unknown->QueryInterface(IID_IDirectDraw, (void**)&dd))
    return 0;

    dd->Release();  // dangerous on dd7;
    return (HRESULT)dd;
}
