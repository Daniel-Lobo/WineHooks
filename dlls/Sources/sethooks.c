/* Copyright Daniel Lobo, aka Peixoto:  
 * dabo.loniel@gmail.com
 */

#include <windows.h>
#include "MinHook.h"
#include <d3d11.h>
#include <d3d11_1.h>
#include <d3d12.h>
#include <dxgi1_3.h>
#include <d3d9.h>

__declspec(dllexport) void DisableHook(LPVOID func)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    MH_DisableHook(func);
}

__declspec(dllexport) int sethook(void** ppFunctionToHook, PVOID pDetour)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    int err;
    void * pFunctionToHook = * ppFunctionToHook;
    if (err = MH_CreateHook(pFunctionToHook, pDetour, ppFunctionToHook) != MH_OK) return err;
    if (err = MH_EnableHook(pFunctionToHook)!= MH_OK) return err;
    return 0;
}

__declspec(dllexport) int unhook(void** ppPointer, PVOID pDetour)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    LONG err;
    void * pFunctionToHook = * ppPointer;
    if (err = MH_DisableHook(pFunctionToHook) != MH_OK) return err;
    if (err = MH_RemoveHook(pFunctionToHook) != MH_OK) return err;
    return 0;
}

__declspec(dllexport) int ReleaseAllHooks(LONG* err) {
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return 0;
}

#define HOOKMEMBER(Interface, Member)                                      \
int Hook_##Interface##_##Member(void*v, void**pTrampoline, void*Hook)      \
{                                                                          \
    Interface * i = (Interface *) v;                                       \
    * pTrampoline = i->lpVtbl->Member;                                     \
    sethook(pTrampoline, Hook);                                            \
}
HOOKMEMBER(IDirect3DDevice9, ProcessVertices)
HOOKMEMBER(ID3D11Device, CreateSamplerState)
HOOKMEMBER(IDXGISwapChain, ResizeTarget)
HOOKMEMBER(IDXGISwapChain, ResizeBuffers)
HOOKMEMBER(IDXGISwapChain, GetBuffer) 
HOOKMEMBER(IDXGISwapChain, GetDesc)
HOOKMEMBER(IDXGISwapChain1, GetDesc1)
HOOKMEMBER(IDXGIOutput, GetDisplayModeList)
HOOKMEMBER(IDXGIOutput, FindClosestMatchingMode)
HOOKMEMBER(ID3D11DeviceContext, DrawAuto)
HOOKMEMBER(ID3D11DeviceContext, Draw)
HOOKMEMBER(ID3D11DeviceContext, DrawIndexed)
HOOKMEMBER(ID3D11DeviceContext, DrawInstanced)
HOOKMEMBER(ID3D11DeviceContext, DrawInstancedIndirect)
HOOKMEMBER(ID3D11DeviceContext, DrawIndexedInstanced)
HOOKMEMBER(ID3D11DeviceContext, DrawIndexedInstancedIndirect)
HOOKMEMBER(ID3D11DeviceContext, RSSetViewports)
HOOKMEMBER(ID3D11DeviceContext, OMSetRenderTargetsAndUnorderedAccessViews)
HOOKMEMBER(ID3D11DeviceContext, PSGetShaderResources)
HOOKMEMBER(ID3D11DeviceContext1, ClearView)
HOOKMEMBER(ID3D10Device, DrawAuto)
HOOKMEMBER(ID3D10Device, Draw)
HOOKMEMBER(ID3D10Device, DrawInstanced)
HOOKMEMBER(ID3D10Device, DrawIndexed)
HOOKMEMBER(ID3D10Device, DrawIndexedInstanced)
HOOKMEMBER(ID3D10Device, CopySubresourceRegion)
HOOKMEMBER(ID3D10Device, CreateShaderResourceView)
HOOKMEMBER(ID3D10Device, UpdateSubresource)
HOOKMEMBER(ID3D10Device, PSSetShaderResources)
HOOKMEMBER(ID3D10Device, CreateTexture2D)
HOOKMEMBER(ID3D10Device, PSSetShader)
HOOKMEMBER(ID3D10Device, CopyResource)
HOOKMEMBER(ID3D10Device, ResolveSubresource)
HOOKMEMBER(ID3D10Device, OMSetRenderTargets)
HOOKMEMBER(ID3D10Device, OMGetRenderTargets)
HOOKMEMBER(ID3D10Device, ClearDepthStencilView)
HOOKMEMBER(ID3D10Device, ClearRenderTargetView)
HOOKMEMBER(ID3D10Device, CreatePixelShader)
HOOKMEMBER(ID3D10Texture2D, Release)
HOOKMEMBER(ID3D10Texture2D, Map)
HOOKMEMBER(ID3D10Texture2D, Unmap)
HOOKMEMBER(ID3D10ShaderResourceView, Release)
HOOKMEMBER(ID3D10PixelShader, Release)

#define GETMEMBERADD(Interface, method, pInterface)     \
void * Interface##_##method##_Add(void*pInterface)      \
{                                                       \
   Interface * i = (Interface *) pInterface;            \
   return (LPVOID) i->lpVtbl->method;                   \
}

GETMEMBERADD(IDXGIFactory2, CreateSwapChain, pInterface)
GETMEMBERADD(IDXGIFactory2, CreateSwapChainForHwnd, pInterface)
GETMEMBERADD(IDXGISwapChain, GetBuffer, pInterface)
GETMEMBERADD(IDXGISwapChain, Present, pInterface)
GETMEMBERADD(IDXGISwapChain1, Present1, pInterface)
GETMEMBERADD(IDXGISwapChain, ResizeTarget, pInterface)
GETMEMBERADD(IDXGISwapChain, ResizeBuffers, pInterface)
GETMEMBERADD(IDXGISwapChain2, GetFrameLatencyWaitableObject, pInterface)
GETMEMBERADD(IDXGISwapChain2, SetMaximumFrameLatency, pInterface)
GETMEMBERADD(IDXGISwapChain, GetDesc, pInterface)
GETMEMBERADD(ID3D12Device, CreateSampler, pInterface)
GETMEMBERADD(ID3D10Device, CopySubresourceRegion, pInterface)
GETMEMBERADD(ID3D10Device, CreateShaderResourceView, pInterface)
GETMEMBERADD(ID3D10Device, UpdateSubresource, pInterface)
GETMEMBERADD(ID3D10Device, PSSetShaderResources, pInterface)
GETMEMBERADD(ID3D10Device, CreateTexture2D, pInterface)
GETMEMBERADD(ID3D10Device, PSSetShader, pInterface)
GETMEMBERADD(ID3D10Device, CopyResource, pInterface)
GETMEMBERADD(ID3D10Device, ResolveSubresource, pInterface)
GETMEMBERADD(ID3D10Device, OMSetRenderTargets, pInterface)
GETMEMBERADD(ID3D10Device, OMGetRenderTargets, pInterface)
GETMEMBERADD(ID3D10Device, ClearDepthStencilView, pInterface)
GETMEMBERADD(ID3D10Device, ClearRenderTargetView, pInterface)
GETMEMBERADD(ID3D10Device, CreatePixelShader, pInterface)
GETMEMBERADD(ID3D10Texture2D, Release, pInterface)
GETMEMBERADD(ID3D10Texture2D, Map, pInterface)
GETMEMBERADD(ID3D10Texture2D, Unmap, pInterface)
GETMEMBERADD(ID3D10ShaderResourceView, Release, pInterface)
GETMEMBERADD(ID3D10PixelShader, Release, pInterface)