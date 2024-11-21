#ifndef SETHOOKS
#define SETHOOKS
#ifdef __cplusplus
extern "C" int sethook(void**, PVOID);
extern "C" int unhook(void**, PVOID);
#else
int sethook(void**, PVOID);
#endif

#define HOOK(Func, Hook) if (sethook((void**)Func, Hook)) {g_.loger.log(__FUNCTION__, "FAILED TO HOOK " #Hook);} \
else g_.loger.log(__FUNCTION__, "SUCCEEDED TO HOOK " #Hook);

#define LOGHOOK(interface, member, pInterface, trampoline, hook)                  \
    if (Hook_##interface##_##member((void*)pInterface, (void**)trampoline, (void*)hook))    \
        g_.loger.log(__FUNCTION__, "FAILED TO HOOK ::" #interface "::" #member);  \
    else                                                                          \
        g_.loger.log(__FUNCTION__, "SUCCEEDED TO HOOK " #interface "::" #member);

#ifdef __cplusplus
#define EXTERNHOOKMEMBER(Interface, Member) extern "C" int Hook_##Interface##_##Member(void* v, void** pTrampoline, void* Hook);
EXTERNHOOKMEMBER(IDirect3DDevice9, ProcessVertices)
EXTERNHOOKMEMBER(ID3D11Device, CreateSamplerState)
EXTERNHOOKMEMBER(IDXGISwapChain, GetDesc)
EXTERNHOOKMEMBER(IDXGISwapChain1, GetDesc1)
EXTERNHOOKMEMBER(IDXGIOutput, GetDisplayModeList)
EXTERNHOOKMEMBER(IDXGIOutput, FindClosestMatchingMode)
EXTERNHOOKMEMBER(ID3D11DeviceContext, DrawAuto)
EXTERNHOOKMEMBER(ID3D11DeviceContext, Draw)
EXTERNHOOKMEMBER(ID3D11DeviceContext, DrawIndexed)
EXTERNHOOKMEMBER(ID3D11DeviceContext, DrawIndexedInstanced)
EXTERNHOOKMEMBER(ID3D11DeviceContext, DrawInstanced)
EXTERNHOOKMEMBER(ID3D11DeviceContext, DrawInstancedIndirect)
EXTERNHOOKMEMBER(ID3D11DeviceContext, DrawIndexedInstancedIndirect)
EXTERNHOOKMEMBER(ID3D11DeviceContext, RSSetViewports)
EXTERNHOOKMEMBER(ID3D11DeviceContext, OMSetRenderTargetsAndUnorderedAccessViews)
EXTERNHOOKMEMBER(ID3D11DeviceContext1, ClearView)
EXTERNHOOKMEMBER(ID3D10Device, DrawAuto)
EXTERNHOOKMEMBER(ID3D10Device, Draw)
EXTERNHOOKMEMBER(ID3D10Device, DrawIndexed)
EXTERNHOOKMEMBER(ID3D10Device, DrawInstanced)
EXTERNHOOKMEMBER(ID3D10Device, DrawIndexedInstanced)

#define EXTERNGETMEMBERADD(Interface, method, pInterface) extern "C" void* Interface_method_Add(void* pInterface);
EXTERNGETMEMBERADD(IDXGIFactory2, CreateSwapChain, pInterface)
EXTERNGETMEMBERADD(IDXGIFactory2, CreateSwapChainForHwnd, pInterface)
EXTERNGETMEMBERADD(IDXGISwapChain, GetBuffer, pInterface)
EXTERNGETMEMBERADD(IDXGISwapChain, Present, pInterface)
EXTERNGETMEMBERADD(IDXGISwapChain1, Present1, pInterface)
EXTERNGETMEMBERADD(IDXGISwapChain, ResizeBuffers, pInterface)
EXTERNGETMEMBERADD(IDXGISwapChain, ResizeTarget, pInterface)
EXTERNGETMEMBERADD(IDXGISwapChain2, GetFrameLatencyWaitableObject, pInterface)
EXTERNGETMEMBERADD(IDXGISwapChain2, SetMaximumFrameLatency, pInterface)
EXTERNGETMEMBERADD(IDXGISwapChain, GetDesc, pInterface)
EXTERNGETMEMBERADD(ID3D12Device, CreateSampler, pInterface)
#endif


#endif // SETHOOKS

