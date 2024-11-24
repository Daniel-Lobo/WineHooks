#include <windows.h>
#include "d3d8.h"
#include "collections.h"
#include "D3D8Hooks.h"
#include <string>
#include <vector>
#include "dllmain.h"
//#include "D3D_DDI.h"
#include "GDI_Hooks.h"
#include <directxmath.h>

#include "D3D12Hooks.h"
extern "C" {
#include "DDSurface.h"
}

D3D8HOOKS_DATA8 * D3D8HooksData ;
DWORD GetD3D8SurfacePxFormat(DWORD fmt)
{
    if      (fmt == D3DFMT_A8R8G8B8) return *(DWORD*) "A8RGB";
    else if (fmt == D3DFMT_X8R8G8B8) return *(DWORD*) "X8RGB";
    else if (fmt == D3DFMT_X1R5G5B5) return *(DWORD*) "X1RGB";
    else if (fmt == D3DFMT_A1R5G5B5) return *(DWORD*) "A1RGB";
    else if (fmt == D3DFMT_A4R4G4B4) return *(DWORD*) "A4RGB";
    else if (fmt == D3DFMT_R5G6B5)   return *(DWORD*) "RG6B";
    else if (fmt == *(DWORD*)"DXT1") return *(DWORD*) "DXT1";
    else if (fmt == *(DWORD*)"DXT2") return *(DWORD*) "DXT2";
    else if (fmt == *(DWORD*)"DXT3") return *(DWORD*) "DXT3";
    else if (fmt == *(DWORD*)"DXT4") return *(DWORD*) "DXT4";
    else if (fmt == *(DWORD*)"DXT5") return *(DWORD*) "DXT5";
    return *(DWORD*) "?????";
}

extern "C" __declspec(dllexport) HRESULT __stdcall D3D8Replacetexture(IDirect3DBaseTexture8* tex, IDirect3DBaseTexture8* rep)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT hr = tex->SetPrivateData((const GUID&)g_.D3DRelplacementTexture, (void**)rep, sizeof(IUnknown*), D3DSPD_IUNKNOWN);
    if (hr != S_OK)
    {
        DBUG_WARN("SetPrivateData failed");
    }   
    rep->Release();
    return hr;
}

extern "C" __declspec(dllexport) HRESULT __stdcall D3D8ReplaceRTTexture(IDirect3DBaseTexture8* tex, IDirect3DBaseTexture8* rep)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)   
    HRESULT hr = tex->SetPrivateData((const GUID&)g_.D3DRelplacementTexture, (void**)rep, sizeof(IUnknown*), D3DSPD_IUNKNOWN);
    if (hr != S_OK)
    {
        DBUG_WARN("SetPrivateData failed");
    }   
    hr = rep->SetPrivateData((const GUID&)g_.D3DRelplacementTexture, (void**)tex, sizeof(IUnknown*), 0);
    if (hr != S_OK)
    {
        DBUG_WARN("SetPrivateData failed");
    }   
    rep->Release();   
    return hr;
}

extern "C" __declspec(dllexport) IDirect3DBaseTexture8 * D3D8GetBasetexture(IDirect3DBaseTexture8* tex)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (tex == nullptr) return nullptr;
    IDirect3DBaseTexture8* rep = nullptr;
    DWORD                 size = sizeof(IUnknown*);
    if (tex->GetPrivateData((const GUID&)g_.D3DRelplacementTexture, (void**)&rep, &size) == S_OK)
    {
        rep->Release();
        return rep;
    }
    return tex;
}

extern "C" __declspec(dllexport) IDirect3DBaseTexture8 * __stdcall D3D8GetSDTexture(IDirect3DBaseTexture8* rep)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (rep == nullptr) return nullptr;
    IDirect3DBaseTexture8* tex = nullptr;
    DWORD                 size = sizeof(IUnknown*);
    if (rep->GetPrivateData((const GUID&)g_.D3DRelplacementTexture, (void**)&tex, &size) == S_OK)
    {
        return tex;
    }
    return nullptr;
}

extern "C" __declspec(dllexport) IDirect3DBaseTexture8 * D3D8GetReplacement(IDirect3DBaseTexture8* tex)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)   
    IDirect3DBaseTexture8* rep = nullptr;
    DWORD                 size = sizeof(IUnknown*);
    if (tex->GetPrivateData((const GUID&)g_.D3DRelplacementTexture, (void**)&rep, &size) == S_OK)
    {
        rep->Release();       
        return rep;
    }
    return nullptr;
}

extern "C" __declspec(dllexport) void D3D8FreeReplacement(IDirect3DBaseTexture8* tex)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    tex->FreePrivateData((const GUID&)g_.D3DRelplacementTexture);
}

extern "C" __declspec(dllexport) DWORD InitD3D8HooksData(D3D8HOOKS_DATA8 * hooksdata, DWORD flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3D8HooksData = hooksdata;
    g_d3d.Init();
    if (flags)
    {
        g_d3d.Setup((flags & 0xffff0000) >> 16, flags & 0xffff, "D3D8");       
        g_d3d.ApplyCommonHooks(0);
    }
    return 1;
}

extern "C" __declspec(dllexport) void D3D8HDSetUP(DWORD w, DWORD h)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_d3d.Setup(w, h, "D3D8");
}


extern "C" __declspec(dllexport) IDirect3DResource8 * GetContainer8(IDirect3DSurface8 * s, REFIID id)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirect3DResource8 * container = 0;
    if ( s->GetContainer(id, (void **)&container) == 0)
    {
       container->Release();
       return container;
    }
    return 0;
}

extern "C" __declspec(dllexport) IDirect3DResource8 * GetContainer8S(IDirect3DSurface8 * s, char * id)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirect3DResource8 * r = 0;
    if      (*(DWORD*)id == *(DWORD*)"TX2D" )
    r = GetContainer8(s, IID_IDirect3DTexture8);
    else if (*(DWORD*)id == *(DWORD*)"CUBE" )
    r = GetContainer8(s, IID_IDirect3DCubeTexture8);
    if (r)
    {
        r->AddRef();
        return r;
    }
    return 0;
}

extern "C" __declspec(dllexport) UINT GetFaceAndLevel8(IDirect3DSurface8 * s)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirect3DCubeTexture8 * t   =
            (IDirect3DCubeTexture8 *) GetContainer8(s, IID_IDirect3DCubeTexture8);
    if (!t)
    {
        return 0;
    }
    IDirect3DSurface8 * srfc = 0;
    for (DWORD i=0; i<8; i++)
    {
        for (DWORD ii=0; ii<t->GetLevelCount(); ii++)
        {
            if ( (t->GetCubeMapSurface((D3DCUBEMAP_FACES)i, ii, &srfc)) == 0 )
            srfc->Release();
            if (srfc == s)
            {
                return (UINT) i|(ii<<4) ;
            }
        }
    }
    return 0;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE CreateVertexBuffer8Hook(LPVOID device, DWORD Length, DWORD Usage,
                                                  DWORD FVF, DWORD Pool, LPVOID* ppVertexBuffer)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (FVF & 0x4)
        return D3D8HooksData->CreateVertexBuffer(device, Length, 0, FVF, 1, ppVertexBuffer);
    return D3D8HooksData->CreateVertexBuffer(device, Length, Usage, FVF, Pool, ppVertexBuffer);
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE Vb8LockHook(IDirect3DVertexBuffer8* Vb,
                                      UINT OffsetToLock, UINT SizeToLock,
                                      BYTE** ppbData, DWORD Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT r = D3D8HooksData->VB_lock(Vb, OffsetToLock, SizeToLock, ppbData, Flags);
    if (r) return r;

    if (D3D8HooksData->VbLocks->Value(Vb))  DBUG_WARN("2ND LOCK");
    if (! (Flags & D3DLOCK_DISCARD)      )  DBUG_WARN("BAD LOCK");

    D3DVERTEXBUFFER_DESC Desc;
    Vb->GetDesc(&Desc);
    if (!(Desc.FVF) || !(Desc.FVF & D3DFVF_XYZRHW)) return r;

    VB8LOCK * lck = (VB8LOCK *)
            VirtualAlloc(NULL,sizeof(VB8LOCK),0x1000|0x2000,PAGE_READWRITE);

    lck->pData       = *ppbData;    
    lck->VertexSize  = g_d3d.m_D3DXGetFVFVertexSize(Desc.FVF);
    lck->VertexCount = (SizeToLock>0) ?
                SizeToLock/lck->VertexSize : Desc.Size/lck->VertexSize;
    D3D8HooksData->VbLocks->insert(Vb, lck);
    return r;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE Vb8UnLockHook(IDirect3DVertexBuffer8* Vb)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    VB8LOCK * lck = (VB8LOCK *) D3D8HooksData->VbLocks->Value(Vb);
    if (! lck) return D3D8HooksData->VB_Unlock(Vb);

    DirectX::XMFLOAT4 * pVertice = (DirectX::XMFLOAT4 *) lck->pData;
    for (DWORD i=0; i<lck->VertexCount; i++)
    {
        pVertice = (DirectX::XMFLOAT4 *) ( (DWORD)lck->pData+lck->VertexSize*i);
        pVertice->x *= D3D8HooksData->scale;
        pVertice->y *= D3D8HooksData->scale;
    }
    D3D8HooksData->VbLocks->remove(Vb);
    return D3D8HooksData->VB_Unlock(Vb);
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE SetVertexShader8Hook(LPVOID device, DWORD Handle)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    if ( (err = D3D8HooksData->SetVertexShader(device, Handle)) ) return err;
    DWORD f = Handle & 0xf;
    if ( (f == 1) || (f == 3) || (f == 5) || (f == 7) || (f == 9) )
         D3D8HooksData->screenspace = 0;
    else D3D8HooksData->screenspace = (Handle & 0x04) ? 1 : 0;
    return err;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE SetStreamSource8Hook(LPVOID device, DWORD index,
                                               IDirect3DVertexBuffer8* src, DWORD stride)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    if ( (err = D3D8HooksData->SetStreamSource(device, index, src, stride)) ) return err;
    if (index == 0)
    {
        D3D8HooksData->current_vbuff = src;
        D3D8HooksData->stride        = stride;
    }
    return err;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE DrawPrimitiveUp8Hook(LPVOID device, DWORD PrimitiveType,
                                               DWORD PrimitiveCount,
                                               const void * pVertexStreamZeroData,
                                               DWORD stride)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (pVertexStreamZeroData == nullptr) return D3DERR_DRIVERINVALIDCALL;
    D3D8HooksData->current_vbuff = 0;
    if (!D3D8HooksData->screenspace)
        return D3D8HooksData->p_DrawPrimitiveUP(device, PrimitiveType, PrimitiveCount,
                                                pVertexStreamZeroData, stride);

    if (pVertexStreamZeroData == NULL) return D3DERR_INVALIDCALL;
    DWORD vertex_count, size = stride-sizeof(float)*2;
    DirectX::XMFLOAT4 * pVertice, * src_vertex;

    if      (PrimitiveType >= 5) vertex_count = 3 + (PrimitiveCount-1);
    else if (PrimitiveType == 4) vertex_count = PrimitiveCount*3;
    else if (PrimitiveType == 1) vertex_count = PrimitiveCount;

    void * pVertices      = D3D8HooksData->pVertices;
    /*
    void * pVertexStreamZeroData = (void*)((DWORD)pVertexStreamZeroData+sizeof(float)*2);
    pVertice              = (DirectX::XMFLOAT4*)pVertices;

    if (D3D8HooksData->HalfPxOffset)
    {
        for (int i=0; i<vertex_count; i++)
        {
            memcpy(&pVertice->z, (void*)((DWORD)pVertexStreamZeroData), size);
            src_vertex            = (DirectX::XMFLOAT4*)((DWORD)pVertexStreamZeroData-sizeof(__int64));
            pVertice->x           = src_vertex->x*D3D8HooksData->scale;
            pVertice->y           = src_vertex->y*D3D8HooksData->scale;
            pVertice->x          -= 0.5;
            pVertice->y          -= 0.5;
            pVertice              = (DirectX::XMFLOAT4*)((DWORD)pVertice+stride);
            pVertexStreamZeroData = (void*)((DWORD)pVertexStreamZeroData+stride);
        }
    } else
    {
        for (int i=0; i<vertex_count; i++)
        {
            memcpy(&pVertice->z, (void*)((DWORD)pVertexStreamZeroData), size);
            src_vertex            = (DirectX::XMFLOAT4*)((DWORD)pVertexStreamZeroData-sizeof(__int64));
            pVertice->x           = src_vertex->x*D3D8HooksData->scale;
            pVertice->y           = src_vertex->y*D3D8HooksData->scale;
            pVertice              = (DirectX::XMFLOAT4*)((DWORD)pVertice+stride);
            pVertexStreamZeroData = (void*)((DWORD)pVertexStreamZeroData+stride);
        }
    }
    */   
    pVertice        = (DirectX::XMFLOAT4*)D3D8HooksData->pVertices;
    src_vertex      = (DirectX::XMFLOAT4*)pVertexStreamZeroData;
    OutputDebugStringA(std::to_string(D3D8HooksData->scale).c_str());
    for (int i=0; i<vertex_count; i++)
    {
        memcpy(&pVertice->x, src_vertex, stride);        
        pVertice->x           *= D3D8HooksData->scale;
        pVertice->y           *= D3D8HooksData->scale;       
        pVertice              = (DirectX::XMFLOAT4*)((DWORD)pVertice   + stride);
        src_vertex            = (DirectX::XMFLOAT4*)((DWORD)src_vertex + stride);
    }
    return D3D8HooksData->p_DrawPrimitiveUP(device, PrimitiveType, PrimitiveCount,
                                           pVertexStreamZeroData, stride);
    HRESULT err = D3D8HooksData->p_DrawPrimitiveUP(device, PrimitiveType, PrimitiveCount,
                                                    D3D8HooksData->pVertices, stride);
    return err;
}

// Cleaner implementation, but makes shadows in onimusha disapear
extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE DrawPrimitive8Hook(LPVOID device, DWORD PrimitiveType,
                                             DWORD StartVertex, DWORD PrimitiveCount)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (!(D3D8HooksData->screenspace))
        return D3D8HooksData->p_DrawPrimitive(device, PrimitiveType, StartVertex, PrimitiveCount);

    IDirect3DVertexBuffer8 * buff = D3D8HooksData->current_vbuff;
    BYTE * pVertexStreamZeroData;
    buff->Lock(StartVertex*D3D8HooksData->stride, PrimitiveCount*D3D8HooksData->stride,
               &pVertexStreamZeroData, D3DLOCK_READONLY);

    HRESULT err =  DrawPrimitiveUp8Hook(device, PrimitiveType, PrimitiveCount,
                                        pVertexStreamZeroData, D3D8HooksData->stride);
    buff->Unlock();
    D3D8HooksData->SetStreamSource(device, 0, buff, D3D8HooksData->stride);
    D3D8HooksData->current_vbuff = buff;
    return err;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
DrawIndexedPrimitiveUP8Hook(IDirect3DDevice8* dvc, D3DPRIMITIVETYPE PrimitiveType, UINT MinIndex, UINT NumVertices,
                            UINT PrimitiveCount, CONST void* pIndexData, D3DFORMAT IndexDataFormat,
                            CONST void* pVertexStreamZeroData, UINT VertexStreamZeroStride)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return 0;
    return D3D8HooksData->p_DrawIndexedPrimitiveUp(dvc, PrimitiveType, MinIndex, NumVertices, PrimitiveCount,
                                                   pIndexData, IndexDataFormat, pVertexStreamZeroData,
                                                   VertexStreamZeroStride);
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
DrawIndexedPrimitive8Hook(IDirect3DDevice8* dvc,  D3DPRIMITIVETYPE Type, UINT MinIndex,
                          UINT NumVertices,  UINT StartIndex,  UINT PrimitiveCount)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (dvc ==  nullptr || NumVertices == 0 || PrimitiveCount == 0) return D3DERR_INVALIDCALL;

    IDirect3DVertexBuffer8 * vextex_buff = nullptr;
    IDirect3DIndexBuffer8  * index_buff  = nullptr;
    D3DINDEXBUFFER_DESC  index_desc;
    D3DVERTEXBUFFER_DESC vb_Dsc;
    UINT  vextex_buff_stride, index_size, index_buff_lock_size;
    DWORD vertex_count, base_vertex_index;
    if      (Type >= 5) vertex_count = 3 + (PrimitiveCount-1);
    else if (Type == 4) vertex_count = PrimitiveCount*3;
    else if (Type == 1) vertex_count = PrimitiveCount;
    BYTE* index_data, *vertex_data;
    ZeroMemory(&index_desc, sizeof(D3DINDEXBUFFER_DESC));

    dvc->GetStreamSource(0, &vextex_buff, &vextex_buff_stride);
    if (vextex_buff == nullptr)
    {
        DBUG_WARN("Failed to get the Vertex buffer");
        return D3DERR_INVALIDCALL;
    }

    ZeroMemory(&vb_Dsc, sizeof(D3DVERTEXBUFFER_DESC));
    vextex_buff->GetDesc(&vb_Dsc);
    if (!vextex_buff_stride) vextex_buff_stride = g_d3d.m_D3DXGetFVFVertexSize(vb_Dsc.FVF);
    if (!(vb_Dsc.FVF & D3DFVF_XYZRHW)) /* Project Eden */
    {
        vextex_buff->Release();
        return D3D8HooksData->p_DrawIndexedPrimitive(dvc, Type, MinIndex, NumVertices, StartIndex, PrimitiveCount);
    }

    dvc->GetIndices(&index_buff, (UINT*)&base_vertex_index);
    if (index_buff == 0)
    {
        DBUG_WARN("Failed to get the Index buffer");
        vextex_buff->Release();
        return D3DERR_INVALIDCALL;
    }

    index_buff->GetDesc(&index_desc);
    index_size           = index_desc.Format == D3DFMT_INDEX16 ? 2 : 4;
    index_buff_lock_size = index_size*vertex_count;
    if (index_buff->Lock((StartIndex)*index_size, index_buff_lock_size, &index_data, D3DLOCK_READONLY))
        DBUG_WARN("No idx lock");

    if (index_size == 2)
    {
        WORD index0 = *(WORD*) index_data;
        DWORD start = vextex_buff_stride*MinIndex+base_vertex_index;
        if (vextex_buff->Lock(start, vb_Dsc.Size-start, &vertex_data, D3DLOCK_READONLY))
            DBUG_WARN("No lock");

        DirectX::XMFLOAT4 * vertice = ( DirectX::XMFLOAT4*)((DWORD)vertex_data);
        DirectX::XMFLOAT4 * scaled_vertice = (DirectX::XMFLOAT4*) D3D8HooksData->pVertices;

        for (DWORD i=0; i<vertex_count; i++)
        {
            index0  = (DWORD) *(WORD*) index_data;
            vertice = (DirectX::XMFLOAT4*)((DWORD)vertex_data + vextex_buff_stride*index0);

            memcpy(scaled_vertice, vertice, vextex_buff_stride);
            scaled_vertice->x *= D3D8HooksData->scale;
            scaled_vertice->y *= D3D8HooksData->scale;

            index_data     = (BYTE*) ((DWORD)index_data+2);
            scaled_vertice = (DirectX::XMFLOAT4*) ((DWORD)scaled_vertice+vextex_buff_stride);
        }
    }
    else
    {
        DWORD index0 = *(DWORD*) index_data;
        DWORD start = vextex_buff_stride*MinIndex+base_vertex_index;
        if (vextex_buff->Lock(start, vb_Dsc.Size-start, &vertex_data, D3DLOCK_READONLY))
            DBUG_WARN("No lock");

        DirectX::XMFLOAT4 * vertice = ( DirectX::XMFLOAT4*)((DWORD)vertex_data);
        DirectX::XMFLOAT4 * scaled_vertice = (DirectX::XMFLOAT4*) D3D8HooksData->pVertices;

        for (DWORD i=0; i<vertex_count; i++)
        {
            index0  = (DWORD) *(WORD*) index_data;
            vertice = (DirectX::XMFLOAT4*)((DWORD)vertex_data + vextex_buff_stride*index0);

            memcpy(scaled_vertice, vertice, vextex_buff_stride);
            scaled_vertice->x *= D3D8HooksData->scale;
            scaled_vertice->y *= D3D8HooksData->scale;

            index_data     = (BYTE*) ((DWORD)index_data+4);
            scaled_vertice = (DirectX::XMFLOAT4*) ((DWORD)scaled_vertice+vextex_buff_stride);
        }
    }

    vextex_buff->Unlock();
    index_buff->Unlock();
    HRESULT err = D3D8HooksData->p_DrawPrimitiveUP(dvc, Type, PrimitiveCount,
                                                   D3D8HooksData->pVertices, vextex_buff_stride);
    dvc->SetStreamSource(0, vextex_buff, vextex_buff_stride);
    vextex_buff->Release();
    index_buff->Release();
    return err;
}

extern "C" __declspec(dllexport)
HRESULT __D3D8DrawRect(LPDIRECT3DDEVICE8 d, LPDIRECT3DTEXTURE8 texture, RECT * rect, DWORD pix, float src[4], D3DTEXTUREFILTERTYPE filter)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    DWORD               stride  = 0, blend = 0, atest = 0, z = 0, cull = 0;
    DWORD               tindex  = 0, ttff  = 0, fog   = 0, curr_filter = 0;
    DWORD                   vx  = 0, px    = 0;
    IDirect3DBaseTexture8 * tx  = NULL;
    IDirect3DVertexBuffer8 *vb  = NULL;   

    d->GetStreamSource(0, &vb, (UINT*)&stride);
    d->GetVertexShader(&vx);
    d->GetPixelShader(&px);
    d->GetTexture(0, &tx);
    d->GetRenderState(D3DRS_ALPHABLENDENABLE, &blend);
    d->GetRenderState(D3DRS_ALPHATESTENABLE, &atest);
    d->GetRenderState(D3DRS_ZENABLE, &z);
    d->GetRenderState(D3DRS_FOGENABLE, &fog);
    d->GetRenderState(D3DRS_CULLMODE, &cull);
    d->GetTextureStageState(0, D3DTSS_TEXCOORDINDEX, &tindex);
    d->GetTextureStageState(0, D3DTSS_TEXTURETRANSFORMFLAGS, &ttff);
    d->GetTextureStageState(0, D3DTSS_TEXTURETRANSFORMFLAGS, &ttff);
    d->GetTextureStageState(0, D3DTSS_MINFILTER, &curr_filter);

    d->SetVertexShader(D3DFVF_XYZRHW | D3DFVF_TEX1);
    D3D8HooksData->SetPixelShader(d, pix);
    if (D3D8HooksData->pIDirect3DDevice8_SetTexture) D3D8HooksData->pIDirect3DDevice8_SetTexture(d, 0, texture);
    else d->SetTexture(0, texture);
    d->SetRenderState(D3DRS_FOGENABLE, 0);
    d->SetRenderState(D3DRS_ALPHABLENDENABLE, 0);
    d->SetRenderState(D3DRS_ALPHATESTENABLE, 0);
    d->SetRenderState(D3DRS_ZENABLE, 0);
    d->SetRenderState(D3DRS_CULLMODE, 1);
    d->SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
    d->SetTextureStageState(0, D3DTSS_TEXTURETRANSFORMFLAGS, 0);
    d->SetTextureStageState(0, D3DTSS_MINFILTER, filter);

    struct xyzwuv {float x, y, z, w, u, v;};
    xyzwuv vertex[4] = {
            (float)rect->left -0.5, (float)rect->top-0.5,    0., 1., 0., 0.,
            (float)rect->right-0.5, (float)rect->top-0.5,    0., 1., 1., 0.,
            (float)rect->right-0.5, (float)rect->bottom-0.5, 0., 1., 1., 1.,
            (float)rect->left -0.5, (float)rect->bottom-0.5, 0., 1., 0., 1.,
    };

    if (src != nullptr)
    {
        vertex[0].u = src[0];
        vertex[0].v = src[1];
        vertex[1].u = src[2];
        vertex[1].v = src[1];
        vertex[2].u = src[2];
        vertex[2].v = src[3];
        vertex[3].u = src[0];
        vertex[3].v = src[3];
    }

    BOOL end = d->BeginScene() ? 0 : 1;
    D3D8HooksData->p_DrawPrimitiveUP(d, D3DPT_TRIANGLEFAN, 2, &vertex, 24);
    if (end) D3D8HooksData->pIDirect3DDevice8_EndScene(d);

    d->SetVertexShader(vx);
    D3D8HooksData->SetPixelShader(d, px);
    d->SetTexture(0, tx);
    d->SetStreamSource(0, vb, stride);
    d->SetRenderState(D3DRS_ALPHABLENDENABLE, blend);
    d->SetRenderState(D3DRS_ALPHATESTENABLE, atest);
    d->SetRenderState(D3DRS_FOGENABLE, fog);
    d->SetRenderState(D3DRS_ZENABLE, z);
    d->SetRenderState(D3DRS_CULLMODE, cull);
    d->SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, tindex);
    d->SetTextureStageState(0, D3DTSS_TEXTURETRANSFORMFLAGS, ttff);
    d->SetTextureStageState(0, D3DTSS_MINFILTER, curr_filter);

    if (tx != NULL)
    {
        D3D8HooksData->ignore_release = 1;
        tx->Release();
        D3D8HooksData->ignore_release = 0;
    }
    if (vb != NULL) vb->Release();
    return 0;
}

extern "C" __declspec(dllexport)
HRESULT _D3D8DrawRect(LPDIRECT3DDEVICE8 d, LPDIRECT3DTEXTURE8 texture, RECT * rect, DWORD pix, float src[4]){
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return __D3D8DrawRect(d, texture, rect, pix, src,  D3DTEXF_NONE);
}

extern "C" __declspec(dllexport) void _D3D8Write(IDirect3DDevice8* dvc, DWORD px, char * text, RECT * r)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    IDirect3DTexture8 * tx = nullptr;
    D3DLOCKED_RECT             lrect;
    DWORD   Width = r->right-r->left;
    DWORD  Height = r->bottom-r->top;

    if (dvc->CreateTexture(Width, Height, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_MANAGED, &tx))
    return DBUG_WARN("IDirect3DDevice8::CreateTexture FAILED");

    if (tx->LockRect(0, &lrect, NULL, 0))
    return DBUG_WARN("IDirect3DTexture8::LockRect FAILED");

    GDIText gdi(r, lrect.pBits, text, __FUNCTION__);
    tx->UnlockRect(0);
    float uv[4] = {0.,1.,1.,1-((float)gdi.m_height/Height)};
    _D3D8DrawRect(dvc, tx, (RECT*)gdi.AlignTop(), px, uv);
    tx->Release();
}

extern "C" __declspec(dllexport) DWORD D3D8GetmaxPrimitiveCount(LPDIRECT3D8 D3D)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    D3DCAPS8 caps;
    ZeroMemory(&caps, sizeof(D3DCAPS8));
    D3D->GetDeviceCaps(0, D3DDEVTYPE_HAL, &caps);
    return caps.MaxPrimitiveCount;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
CreatePixelShader8Hook(LPDIRECT3DDEVICE8 dev, const DWORD func, DWORD* pHwnd)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT           err;
    DWORD         pShader;
    int                 i;
    DWORD size        = 0;
    LPVOID ShaderData = NULL;

    err = D3D8HooksData->CreatePixelShader(dev, func, pHwnd);
    if ( (err != D3D_OK) || (D3D8HooksData->ignore_creation == TRUE) ) return err;

    D3D8HooksData->Shaders->insert_disposable((LPVOID)*pHwnd, (LPVOID)*pHwnd);
    if (D3D8HooksData->SDumpsSize == 0) return err;

    pShader = *pHwnd;
    if (dev->GetPixelShaderFunction(pShader, NULL, &size))
    {
        return err;
    }

    ShaderData = malloc(size);
    if (dev->GetPixelShaderFunction(pShader, ShaderData, &size))
    {
        free(ShaderData);
        return err;
    }

    LPVOID dump  = *((LPVOID*)D3D8HooksData->SDumps);
    for (i=0; i<D3D8HooksData->SDumpsSize; i++)
    {
        if (*(DWORD*)dump == size)
        {
            if (! memcmp((LPVOID*)((DWORD)dump+4), ShaderData, size) )
            {
                D3D8HooksData->pShaderFound(i+1, (LPVOID)*pHwnd, size, *(DWORD*)dump);
                break;
            }
        }
        dump = *((LPVOID*)((DWORD)D3D8HooksData->SDumps+4*(i+1)));
    }
    free(ShaderData);
    return err;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
DeletePixelShader8Hook(LPDIRECT3DDEVICE8 dev, DWORD pHwnd)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    if ( (err=D3D8HooksData->DeletePixelShader(dev, pHwnd)) == D3D_OK )
    {
        D3D8HooksData->Shaders->discard((LPVOID)pHwnd);       
        /*
        HANDLE ddi_override = D3D8HooksData->DDI_Overrides->Value((LPVOID)pHwnd);
        if (ddi_override)
        {
            D3D8HooksData->DDI_Overrides->discard((LPVOID)pHwnd);
            d3dddiDeletePxShader(ddi_override);
        }
        
        else */ D3D8HooksData->Overrides->discard((LPVOID)pHwnd);
    }
    return err;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
SetPixelShader8Hook(LPDIRECT3DDEVICE8 dev, DWORD Hwnd)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT    err                 = 0;
    DWORD override                 = 0;
    //d3dddiSetOverride(nullptr);
    if (D3D8HooksData->SearchingShader && ((LPVOID)Hwnd == D3D8HooksData->CurrentShader))
        err = D3D8HooksData->SetPixelShader(dev, D3D8HooksData->Override);
    else if ( (override = (DWORD)D3D8HooksData->Overrides->Value((LPVOID)Hwnd)) )
        err = D3D8HooksData->SetPixelShader(dev, override);
    else if ( (override = (DWORD)D3D8HooksData->DDI_Overrides->Value((LPVOID)Hwnd)) )
    {
        //d3dddiSetOverride((HANDLE)override);
        err = D3D8HooksData->SetPixelShader(dev, Hwnd);
    }
    else
        err = D3D8HooksData->SetPixelShader(dev, Hwnd);
    return err;
}

/*
HRESULT STDMETHODCALLTYPE
OniSetTexture8(LPVOID device, DWORD stage, LPVOID texture)
{
    HRESULT err;
    LPVOID replace;
    D3D8HooksData->ignore_release = TRUE;
    if (D3D8HooksData->searching && (texture == D3D8HooksData->CurrentTexture))
        err = D3D8HooksData->pIDirect3DDevice8_SetTexture(device, stage, 0);
    else
    {
        if (replace = D3D8HooksData->Replacements->Value(texture))
            err = D3D8HooksData->pIDirect3DDevice8_SetTexture(device, stage, replace);
        else err = D3D8HooksData->pIDirect3DDevice8_SetTexture(device, stage, texture);
    }
    D3D8HooksData->ignore_release = FALSE;
    return err;
}
*/

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
CreateTexture8Hook(LPVOID device, UINT ww, UINT hh, UINT lvls, DWORD Usage,
                   DWORD Format, DWORD Pool, LPVOID* ppTexture)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (D3D8HooksData->SingleCoreAffinity)      SetThreadAffinity(-1);
    HRESULT err = D3D8HooksData->pIDirect3DDevice8_CreateTexture(device, ww, hh, lvls, Usage,
                                                                 Format, Pool, ppTexture);
    if (err) return err;

    if  (!( (Usage & (DWORD)D3DUSAGE_DEPTHSTENCIL) || (Usage & (DWORD)D3DUSAGE_RENDERTARGET)
          ||(Usage & (DWORD)D3DUSAGE_DYNAMIC) ))
    {
        TEXTSWAP8_ENTRY * t = (TEXTSWAP8_ENTRY *)
                VirtualAlloc(NULL, sizeof(TEXTSWAP8_ENTRY), 0x1000|0x2000, PAGE_READWRITE);
        ZeroMemory(t, sizeof(TEXTSWAP8_ENTRY));
        t->pTexture = *ppTexture;
        t->ww       = ww;
        t->hh       = hh;
        t->Format   = Format;
        t->type     = Usage & (DWORD)D3DUSAGE_DYNAMIC ? 4 : Pool;
        t->pData = NULL;
        t->pitch = 0;
        if ((Format & 0x000000FF) == 68)
        {
            t->DXTn = (Format & 0xFF000000) == 0x31000000 ? 1 : 2;
        }
        D3D8HooksData->Textures->insert(t->pTexture, t);
    } return err;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
SetTexture8Hook(LPVOID device, DWORD stage, LPVOID texture)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT    err;
    LPVOID replace;
    D3D8HooksData->ignore_release = TRUE;

    /* D3D8 doesn't initialize g_d3d, but using just this field is safe */
    /*
    if (g_d3d.DBUG)
    {
        SHORT down = GetKeyState(VK_SHIFT) & 0x8000 ;
        if (down)
            return D3D8HooksData->pIDirect3DDevice8_SetTexture(device, stage, texture);
    }
    */

    if (D3D8HooksData->searching && (texture == D3D8HooksData->CurrentTexture))
        err = D3D8HooksData->pIDirect3DDevice8_SetTexture(device, stage, 0);
    else
    {
        /*
        if (replace = D3D8HooksData->Replacements->Value(texture))
            err = D3D8HooksData->pIDirect3DDevice8_SetTexture(device, stage, replace);
        else err = D3D8HooksData->pIDirect3DDevice8_SetTexture(device, stage, texture);
        */
       err = D3D8HooksData->pIDirect3DDevice8_SetTexture(device, stage, (void*)D3D8GetBasetexture((IDirect3DBaseTexture8*)texture));
    }
    D3D8HooksData->ignore_release = FALSE;
    return err;
}

/*
HRESULT STDMETHODCALLTYPE
OldReleaseTexture8Hook(LPVOID texture)
{
    LPDIRECT3DTEXTURE8 replace;
    if (!D3D8HooksData->ignore_release)
    {
        if (D3D8HooksData->Textures->Value(texture))
            D3D8HooksData->Textures->remove(texture);
        if (replace = (LPDIRECT3DTEXTURE8) D3D8HooksData->Replacements->Value(texture))
        {
            D3D8HooksData->Replacements->discard(texture);
            D3D8HooksData->pIDirect3DTexture8_Release(replace);
        }
    }
    return D3D8HooksData->pIDirect3DTexture8_Release(texture);
}
*/


void RemoveTexture(LPVOID tx)
{
    D3D8HooksData->Textures->remove(tx);
    /*
    LPVOID rep = D3D8HooksData->Replacements->Value(tx);
    if (rep)
    {
        D3D8HooksData->Replacements->discard(tx);
        D3D8HooksData->pIDirect3DTexture8_Release(rep);
    }
    */
}

/*
void RemoveTexture(LPVOID tx)
{
    D3D8HooksData->Textures->remove(tx);
    LPVOID rep = D3D8HooksData->Replacements->Value(tx);
    if (rep)
    {
        D3D8HooksData->Replacements->discard(tx);
        D3D8HooksData->pIDirect3DTexture8_Release(rep);
    }
}
*/

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
ReleaseTexture8Hook(LPVOID texture)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (D3D8HooksData->SingleCoreAffinity)     SetThreadAffinity(-1);
    HRESULT ref = D3D8HooksData->pIDirect3DTexture8_Release(texture);
    if (ref == 0)
    {
        TEXTSWAP8_ENTRY * t = (TEXTSWAP8_ENTRY *) D3D8HooksData->Textures->Value(texture);
        if (t) 
        {   
            D3D8HooksData->Surfaces->remove(t->level0);
            RemoveTexture(texture);
        }
    }
    return ref;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
LockTexture8RectHook(LPVOID texture, UINT Level, D3DLOCKED_RECT* pLockedRect,
                     CONST RECT* pRect, DWORD Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    err = D3D8HooksData->pIDirect3DTexture8_LockRect(texture,Level,pLockedRect,pRect,Flags);
    TEXTSWAP8_ENTRY * t = (TEXTSWAP8_ENTRY *)D3D8HooksData->Textures->Value(texture);
    if (!t) return err;

    if ( (err == 0) && (Level == 0) && (pRect == NULL) )
    {
        t->pData = pLockedRect->pBits;
        t->pitch = pLockedRect->Pitch;
    } else {
        t->pData = nullptr;
        t->pitch = 0;
    }
    return err;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
LockTexture8RectHookCheck(LPVOID texture, UINT Level, D3DLOCKED_RECT* pLockedRect,
                          CONST RECT* pRect, DWORD Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    LPVOID rep;
    /*
    if ( (rep = D3D8HooksData->Replacements->Value(texture)) != 0 )
    {
        D3D8HooksData->pIDirect3DTexture8_Release(rep);
        D3D8HooksData->Replacements->discard(texture);
    }
    */
    D3D8FreeReplacement((IDirect3DBaseTexture8*)texture);
    return LockTexture8RectHook(texture, Level, pLockedRect, pRect, Flags);
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
UnLockTexture8RectHook(LPVOID texture, DWORD level)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (level > 0) return D3D8HooksData->pIDirect3DTexture8_UnlockRect(texture, level);
    TEXTSWAP8_ENTRY * t = (TEXTSWAP8_ENTRY *)D3D8HooksData->Textures->Value(texture);
    if (t)
    {
        DWORD fmt = GetD3D8SurfacePxFormat(t->Format);
        std::string * s
                = g_.FindTexture(t->ww, t->hh, t->pitch, (char*)&fmt, (byte*)t->pData);
        if (s)
        {
            DBUG_WARN(s->c_str());
            D3D8HooksData->pTextureFound(s->c_str(), texture);
        } else if (D3D8HooksData->pDumpTexture)
        {
            t->pData  = NULL;
            t->pitch  = 0;
            HRESULT r = D3D8HooksData->pIDirect3DTexture8_UnlockRect(texture, level);
            D3D8HooksData->pDumpTexture(texture, t->Format);
            return r;
        }
        t->pData = NULL;
        t->pitch = 0;
    }
    return D3D8HooksData->pIDirect3DTexture8_UnlockRect(texture, level);
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
UpdateTexture8Hook(IDirect3DDevice8 * dvc, IDirect3DBaseTexture8* src, IDirect3DBaseTexture8* dst)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT r = D3D8HooksData->pIDirect3DDevice8_UpdateTexture(dvc, src, dst);
    if (r) return r;
    /*
    IDirect3DTexture8 * rep    = (IDirect3DTexture8 *) D3D8HooksData->Replacements->Value(src);
    if (rep == nullptr) return r;

    IDirect3DTexture8 * oldrep = (IDirect3DTexture8 *) D3D8HooksData->Replacements->Value(dst);
    if (oldrep)
    {
        D3D8HooksData->Replacements->discard((LPVOID)dst);
        oldrep->Release();
    }
    rep->AddRef();
    D3D8HooksData->Replacements->insert_disposable(dst, rep);
    */
    D3D8FreeReplacement(dst);
    IDirect3DBaseTexture8 * rep = D3D8GetReplacement(src); 
    if (rep == nullptr) return r;
    D3D8Replacetexture(dst, rep);
    return r;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
GetSurfaceLevel8Hook(LPVOID pTexture, UINT level, LPVOID* ppSurface)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (D3D8HooksData->SingleCoreAffinity)      SetThreadAffinity(-1);
    HRESULT err ;
    err = D3D8HooksData->pIDirect3DTexture8_GetSurfaceLevel(pTexture,level,ppSurface);
    if( (err == 0) && (level == 0) )
    {
        TEXTSWAP8_ENTRY * t = (TEXTSWAP8_ENTRY *)D3D8HooksData->Textures->Value(pTexture);
        if (t)
        {
            t->level0 = *ppSurface;
            TEXTSWAP8_SURFACE* s =
                    (TEXTSWAP8_SURFACE*) VirtualAlloc(NULL,sizeof(TEXTSWAP8_SURFACE),
                                                      0x1000|0x2000, PAGE_READWRITE);
            ZeroMemory(s, sizeof(TEXTSWAP8_SURFACE));
            s->pSurface      = *ppSurface;
            s->ParentTexture = t->pTexture;
            s->ww            = t->ww;
            s->hh            = t->hh;
            s->Format        = t->Format;
            s->type          = t->type;
            s->pData         = NULL;
            s->pitch         = 0;
            s->DXTn          = t->DXTn;
            D3D8HooksData->Surfaces->insert(s->pSurface, s);
        }
    }
    return err;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
OldReleaseSurface8Hook(LPVOID pSurface)
{
    D3D8HooksData->Surfaces->remove(pSurface);
    return D3D8HooksData->pIDirect3DSurface8_Release(pSurface);
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
ReleaseSurface8Hook(LPVOID pSurface)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    if (D3D8HooksData->SingleCoreAffinity)      SetThreadAffinity(-1);
    IDirect3DResource8 * ParentTexture =
            GetContainer8((IDirect3DSurface8 *)pSurface, IID_IDirect3DTexture8);
    if (ParentTexture == NULL)
        ParentTexture =
                GetContainer8((IDirect3DSurface8 *)pSurface, IID_IDirect3DCubeTexture8);
    if (ParentTexture) ParentTexture->AddRef();

    HRESULT ref = D3D8HooksData->pIDirect3DSurface8_Release(pSurface);
    if (ref == 0)
    {
        TEXTSWAP8_SURFACE * s = (TEXTSWAP8_SURFACE *)D3D8HooksData->Surfaces->Value(pSurface);
        if (s) RemoveTexture(s->ParentTexture);
        D3D8HooksData->Surfaces->remove(pSurface);
        IDirect3DSurface8 * rep =
                (IDirect3DSurface8 *)D3D8HooksData->Render_targets->Value(pSurface);
        if (rep)
        {
            D3D8HooksData->pIDirect3DSurface8_Release(rep);
            D3D8HooksData->Render_targets->discard(s);
        }
    }
    if (ParentTexture) ReleaseTexture8Hook(ParentTexture);
    return ref;
}


extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
LockManagedSurface8RectHook(LPVOID surface, D3DLOCKED_RECT* pLockedRect,
                            CONST RECT* pRect, DWORD Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    err = D3D8HooksData->pIDirect3DSurface8_LockRect(surface,pLockedRect,pRect,Flags);
    if ( (err == 0) && (pRect == NULL) )
    {
        TEXTSWAP8_SURFACE * s =
                (TEXTSWAP8_SURFACE *)D3D8HooksData->Surfaces->Value(surface);
        if ( !s )
            return err;

        s->pData = pLockedRect->pBits;
        s->pitch = pLockedRect->Pitch;
        return err;
    }
    return err;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
LockSurface8RectHook(LPVOID surface, D3DLOCKED_RECT* pLockedRect,
                            CONST RECT* pRect, DWORD Flags)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HRESULT err;
    err = D3D8HooksData->pIDirect3DSurface8_LockRect(surface,pLockedRect,pRect,Flags);
    if ( (err == 0) && (pRect == NULL) )
    {
        TEXTSWAP8_SURFACE * s =
                (TEXTSWAP8_SURFACE *)D3D8HooksData->Surfaces->Value(surface);
        if ( !s )
            return err;

        s->pData = pLockedRect->pBits;
        s->pitch = pLockedRect->Pitch;
        return err;
    }
    return err;
}

extern "C" __declspec(dllexport) HRESULT STDMETHODCALLTYPE
UnLockSurface8RectHook(LPVOID surface)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    TEXTSWAP8_SURFACE * t=
            (TEXTSWAP8_SURFACE *)D3D8HooksData->Surfaces->Value(surface);
    if (t)
    {
        DWORD fmt = GetD3D8SurfacePxFormat(t->Format);
        std::string * s
                = g_.FindTexture(t->ww, t->hh, t->pitch, (char*)&fmt, (byte*)t->pData);
        if (s)
        {
            DBUG_WARN(s->c_str());
            D3D8HooksData->pTextureFound(s->c_str(), t->ParentTexture);
        } else if (D3D8HooksData->pDumpTexture)
        {
            t->pData  = NULL;
            t->pitch  = 0;
            HRESULT r = D3D8HooksData->pIDirect3DSurface8_UnlockRect(surface);
            D3D8HooksData->pDumpTexture(t->ParentTexture, t->Format);
            return r;
        }
        t->pData = NULL;
        t->pitch = 0;
    }
    return D3D8HooksData->pIDirect3DSurface8_UnlockRect(surface);
}


extern "C" __declspec(dllexport) void CopyRects8Check(IDirect3DSurface8* SRC, IDirect3DSurface8* DST)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    TEXTSWAP8_SURFACE * src =
            (TEXTSWAP8_SURFACE *)D3D8HooksData->Surfaces->Value(SRC);

    if (src)
    {
        /*
        IDirect3DTexture8 * rep = (IDirect3DTexture8 *)D3D8HooksData->Replacements->Value(src->ParentTexture);
        if (rep == nullptr) return;

        IDirect3DTexture8 * dst = (IDirect3DTexture8 *)GetContainer8(DST, IID_IDirect3DTexture8);
        if (dst)
        {
            IDirect3DTexture8 * oldrep = (IDirect3DTexture8 *) D3D8HooksData->Replacements->Value(dst);
            if (oldrep)
            {
                D3D8HooksData->Replacements->discard((LPVOID)dst);
                oldrep->Release();
            }
            rep->AddRef();
            D3D8HooksData->Replacements->insert_disposable(dst, rep);
        }
        */
        IDirect3DTexture8 * dst = (IDirect3DTexture8 *)GetContainer8(DST, IID_IDirect3DTexture8);
        if (dst)
        {
            D3D8FreeReplacement(dst);
            IDirect3DBaseTexture8 * rep = D3D8GetReplacement((IDirect3DBaseTexture8*)src->ParentTexture); 
            if (rep == nullptr) return;
            D3D8Replacetexture(dst, rep);
        }
    }
}
