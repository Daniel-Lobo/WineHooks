#ifndef D3D11HOOKS_H
#define D3D11HOOKS_H
#include <windows.h>
#include <d3d11.h>
#include <d3d10_1.h>
#include <d3d10.h>

#include <dxgi.h>
#include "collections.h"
#include "Sync.h"
#include <string>
#include "Dbug.h"
#include "dllmain.h"
#include <vector>
#include <string>

#define D3D11FILTER_MIP_LINEAR 0x01
#define D3D11FILTER_MAG_LINEAR 0x05
#define D3D11FILTER_MIG_LINEAR 0x10
#define D3D11FILTER_COMPARISON 0x80
#define D3D11LOG(string) g_.loger.log(__FUNCTION__, string)
//#define D3D10_AND11_USE_DBUG_LAYER

typedef struct DXGI_SWAP_CHAIN_DESC_1 {
  UINT             Width;
  UINT             Height;
  DXGI_FORMAT      Format;
  BOOL             Stereo;
  DXGI_SAMPLE_DESC SampleDesc;
  DXGI_USAGE       BufferUsage;
  UINT             BufferCount;
  UINT             Scaling;
  DXGI_SWAP_EFFECT SwapEffect;
  UINT             AlphaMode;
  UINT             Flags;
} DXGI_SWAP_CHAIN_DESC_1;

struct D3D10Texture2DDesc {
    D3D10_TEXTURE2D_DESC m_desc = {};
    D3D10Texture2DDesc(ID3D10Texture2D * tx){if (tx) tx->GetDesc(&m_desc);}
};

struct D3D10DescribeTexture2D {
    std::string str;
    D3D10DescribeTexture2D(ID3D10Resource * tx){
        str.clear();
        if (tx == nullptr) {
            str.append("nullptr");
            return;
        }
        D3D10_RESOURCE_DIMENSION type = (D3D10_RESOURCE_DIMENSION)0;
        tx->GetType(&type);
        if (type != D3D10_RESOURCE_DIMENSION_TEXTURE2D) {
            str.append("NOT A TEXTURE2D");
            return;
        }
        ID3D10Texture2D * tx2d = (ID3D10Texture2D *)EZInterface(__uuidof(ID3D10Texture2D), tx).I();
        if (tx2d == nullptr) {
            str.append("EZInterface(__uuidof(ID3D10Texture2D) FAILED");
            return;
        }
        D3D10_TEXTURE2D_DESC desc;
        tx2d->GetDesc(&desc);
        str.append("Usage: ");
        str.append(std::to_string(desc.Usage));
    }
};

struct D3D10SRVDesc {
    D3D10_SHADER_RESOURCE_VIEW_DESC m_desc = {};
    D3D10SRVDesc(ID3D10ShaderResourceView * vw){if (vw) vw->GetDesc(&m_desc);}
};

struct D3D10RTVDesc {
    D3D10_RENDER_TARGET_VIEW_DESC m_desc = {};
    D3D10RTVDesc(ID3D10RenderTargetView * vw){if (vw) vw->GetDesc(&m_desc);}
};

struct D3D10DSVDesc {
    D3D10_DEPTH_STENCIL_VIEW_DESC m_desc = {};
    D3D10DSVDesc(ID3D10DepthStencilView * vw){if (vw) vw->GetDesc(&m_desc);}
};

struct D3D11Texture2DDesc {
    D3D11_TEXTURE2D_DESC m_desc = {};
    std::string str;
    D3D11Texture2DDesc(ID3D11Texture2D * tx){if (tx) tx->GetDesc(&m_desc);}
    const char * Describe(){
        str += "\nTexture 2D:";
        str += "\nMipLevels :" + std::to_string(m_desc.MipLevels);
        str += "\nArraySize :" + std::to_string(m_desc.ArraySize);
        return str.c_str();
    }
};

struct D3D11SRVDesc {
    D3D11_SHADER_RESOURCE_VIEW_DESC m_desc = {};
    std::string str;
    D3D11SRVDesc(ID3D11ShaderResourceView * vw){if (vw) vw->GetDesc(&m_desc);}
    const char * Describe(){
        str += "\nShader Resource View:";
        str += "\nViewDimension   :" + std::to_string(m_desc.ViewDimension);
        str += "\nMostDetailedMip :" + std::to_string(m_desc.Texture2DArray.MostDetailedMip);
        str += "\nFirstArraySlice :" + std::to_string(m_desc.Texture2DArray.FirstArraySlice);
        str += "\nArraySize       :" + std::to_string(m_desc.Texture2DArray.ArraySize);
        return str.c_str();
    }
};

struct D3D11RTVDesc {
    D3D11_RENDER_TARGET_VIEW_DESC m_desc = {};
    D3D11RTVDesc(ID3D11RenderTargetView * vw){if (vw) vw->GetDesc(&m_desc);}
};

struct D3D11DSVDesc {
    D3D11_DEPTH_STENCIL_VIEW_DESC m_desc = {};
    D3D11DSVDesc(ID3D11DepthStencilView * vw){if (vw) vw->GetDesc(&m_desc);}
};

struct D3D11UAVDesc {
    D3D11_UNORDERED_ACCESS_VIEW_DESC  m_desc = {};
    D3D11UAVDesc(ID3D11UnorderedAccessView* vw) {if (vw) vw->GetDesc(&m_desc);}
};


struct D3D11TexUnWrapp {
    union{ID3D11Texture2D * m_tx2d;   ID3D11Texture3D * m_tx3d;
          ID3D10Texture2D * m_tx2d10; ID3D10Texture3D * m_tx3d10 = nullptr;};
    union{D3D11_TEXTURE2D_DESC m_desc2d;
          D3D11_TEXTURE3D_DESC m_desc3d;
          D3D10_TEXTURE2D_DESC m_desc2d10;
          D3D10_TEXTURE3D_DESC m_desc3d10;};
    D3D11TexUnWrapp(ID3D11View *);
    D3D11TexUnWrapp(ID3D10View *);
    D3D11TexUnWrapp(IUnknown *);
    D3D11TexUnWrapp(IUnknown *, BOOL);
    ~D3D11TexUnWrapp(){ if(m_tx2d) m_tx2d->Release(); }
    D3D11_RESOURCE_DIMENSION Type();
    D3D10_RESOURCE_DIMENSION Type10();
    D3D11_TEXTURE2D_DESC    *Desc();
    D3D10_TEXTURE2D_DESC    *Desc10();
};

typedef struct _D3D11Text2AndView {
      ID3D11Texture2D          * Tex;
      ID3D11ShaderResourceView * View;
} D3D11Text2AndView;

typedef struct _D3D10Text2AndView {
      ID3D10Texture2D          * Tex;
      ID3D10ShaderResourceView * View;
} D3D10Text2AndView;

typedef struct _ID3D11_MAPPED {
    D3D11_MAPPED_SUBRESOURCE m;
    union{
        D3D11_TEXTURE2D_DESC d;
    };
    DWORD compressed;
}ID3D11_MAPPED;

typedef struct _ID3D10_MAPPED {
    D3D10_MAPPED_TEXTURE2D m;
    union{
        D3D10_TEXTURE2D_DESC d;
    };
    DWORD compressed;
}ID3D10_MAPPED;

struct C_D3D11_TEXTURE2D_DESC : public D3D11_TEXTURE2D_DESC {    
};

struct C_D3D10_TEXTURE2D_DESC : public D3D10_TEXTURE2D_DESC {    
};

typedef struct _ID3D11 {
    ID3D11Device           * pDev;
    ID3D11DeviceContext    * pContext;
    ID3D11DeviceContext    * pDefferedContext;
    IDXGISwapChain         * pSwapChain;
    LPVOID                 * pSwapChain1;
    IDXGIFactory           * pFactory;
    LPVOID                 * pFactory2;
} ID3D11;

typedef struct _ID3D10_1 {
    ID3D10Device     * pDvc;
    ID3D10Device1    * pDvc1;
    IDXGISwapChain   * SwapChain;
    LPVOID           * pSwapChain1;
    IDXGIFactory     * pFactory;
    LPVOID           * pFactory2;
} ID3D10_1;

struct D3D11_GLOBALS {
public:
    void Init() {
        BackBuffrerID  = new SYNC::AtomicPtr();
        PixelShader    = new SYNC::AtomicPtr();
        TextID         = new SYNC::AtomicPtr();
        lock           = new SYNC::AtomicLock();
        ProxyCount     = new SYNC::Atomic();
        vm_size = new SYNC::Atomic();
        MappedTextures = new POINTER_DICTIONARY();
        PxDumps        = new POINTER_DICTIONARY();
        PxReplacements = new POINTER_DICTIONARY();
        GETPROCADDRESS(m_D3D11CreateDevice, "D3D11CreateDevice", "d3d11.dll");
        GETPROCADDRESS(m_D3D10CreateDevice, "D3D10CreateDevice", "d3d10.dll");
        GETPROCADDRESS(m_DXGID3D10CreateDevice, "DXGID3D10CreateDevice", "dxgi.dll");
    }
    void SetWineFixPtrs(void * wine_create, void * wine_reg, void * wine_d3d11_reg){        
        m_WineDXGID3D10CreateDevice   = wine_create;
        m_WineDXGID3D10RegisterLayers = wine_reg;
        m_WineD3D11CoreRegisterLayers = (decltype(m_WineD3D11CoreRegisterLayers))wine_d3d11_reg;
    }
    void GetWineFixPtrs(void ** wine_create, void ** wine_reg, void** wine_d3d11_reg, void**dxgi_create){
        *wine_create    = m_WineDXGID3D10CreateDevice;
        *wine_reg       = m_WineDXGID3D10RegisterLayers;
        *wine_d3d11_reg = (void*)m_WineD3D11CoreRegisterLayers;
        *dxgi_create    = (void*)m_DXGID3D10CreateDevice;
    }
    LRESULT SendVMSize(HWND hWin, DWORD w, DWORD h) {
        if (vm_size->Get() == 1) return 0;
        vm_size->Set(1);
        LRESULT lr =SendMessage(hWin, WM_SIZE, 0, w | (h << 16));
        vm_size->Set(0);
        return lr;
    }
    RECT            BackBufferRect;
    DWORD    max_width, max_height;
    SYNC::Atomic*       ProxyCount;
    SYNC::Atomic*          vm_size;
    SYNC::AtomicPtr *BackBuffrerID;
    SYNC::AtomicPtr  * PixelShader;
    SYNC::AtomicPtr        *TextID;
    SYNC::AtomicLock         *lock;
    union {
        ID3D10VertexShader * m_D3D10VxBlt = nullptr;
        ID3D11VertexShader * m_VxBlt;
    };
    union {
        ID3D10PixelShader * m_D3D10PxBlt = nullptr;
        ID3D11PixelShader * m_PxBlt;
    };
    union {
        ID3D10PixelShader * m_D3D10VMirrorPxBlt = nullptr;
        ID3D11PixelShader * m_VMirrorPxBlt;
    };
    union {
        ID3D10ShaderResourceView * m_D3D10CheckBoardPattern = nullptr;
        ID3D11ShaderResourceView * m_CheckBoardPattern;
    }; 
    ID3D10PixelShader * m_SSAA               = nullptr;
    ID3D10PixelShader * m_SSAAHQ             = nullptr;
    POINTER_DICTIONARY                * MappedTextures;
    POINTER_DICTIONARY                       * PxDumps;
    POINTER_DICTIONARY                * PxReplacements;
    void * m_DXGID3D10CreateDevice           = nullptr;     
    void * m_WineDXGID3D10CreateDevice       = nullptr;  
    void  *m_WineDXGID3D10RegisterLayers     = nullptr;    
    HRESULT (WINAPI * m_WineD3D11CoreRegisterLayers)();     
    HRESULT (WINAPI * m_DXVkCreateDXGIFactory1) (REFIID, void **) = nullptr;
    HRESULT (WINAPI * m_DXVkD3D11CreateDeviceAndSwapChain) 
            (IDXGIAdapter *, D3D_DRIVER_TYPE, HMODULE, UINT, const D3D_FEATURE_LEVEL*, UINT, UINT, const DXGI_SWAP_CHAIN_DESC*,
            IDXGISwapChain**, ID3D11Device**, D3D_FEATURE_LEVEL*, ID3D11DeviceContext**) = nullptr;
    HRESULT (WINAPI * m_SystemCreateDXGIFactory1) (REFIID, void **) = nullptr;        
    HRESULT (WINAPI * m_D3D11CreateDevice)(IDXGIAdapter*, D3D_DRIVER_TYPE, HMODULE, UINT,const D3D_FEATURE_LEVEL*,
                                           UINT, UINT, ID3D11Device**, D3D_FEATURE_LEVEL*, ID3D11DeviceContext**);
    HRESULT (WINAPI *m_D3D10CreateDevice)(IDXGIAdapter*,D3D10_DRIVER_TYPE, HMODULE, UINT, UINT,ID3D10Device**);
    void (__stdcall * m_Draw)                         (ID3D11DeviceContext*, UINT, UINT);
    void (__stdcall * m_DrawAuto)                     (ID3D11DeviceContext*);    
    void (__stdcall * m_DrawIndexed)                  (ID3D11DeviceContext*, UINT, UINT, INT);
    void (__stdcall * m_DrawInstanced)                (ID3D11DeviceContext*, UINT, UINT, UINT, UINT);
    void (__stdcall * m_DrawInstancedIndirect)        (ID3D11DeviceContext*, ID3D11Buffer*, UINT);
    void (__stdcall * m_DrawIndexedInstanced)         (ID3D11DeviceContext*, UINT, UINT, UINT, INT, UINT);
    void (__stdcall * m_DrawIndexedInstancedIndirect) (ID3D11DeviceContext*, ID3D11Buffer*, UINT);
    void (__stdcall * m_RSSetViewports)               (ID3D11DeviceContext*, UINT,const D3D11_VIEWPORT*);
    void (__stdcall * m_OMSetRenderTargetsAndUAVs)    (ID3D11DeviceContext*, UINT, ID3D11RenderTargetView* const*,ID3D11DepthStencilView*,
                                                       UINT, UINT, ID3D11UnorderedAccessView* const*, const UINT*);
    void (__stdcall * m_ClearView)                    (ID3D11DeviceContext1*, ID3D11View*, const FLOAT [4], const D3D11_RECT*, UINT);
    void (__stdcall * m_D3D10DrawIndexed)             (ID3D10Device*, UINT, UINT, INT);        
    void (__stdcall * m_D3D10Draw)                    (ID3D10Device* ,UINT, UINT);
    void (__stdcall * m_D3D10DrawIndexedInstanced)    (ID3D10Device*, UINT, UINT, UINT, INT ,UINT);        
    void (__stdcall * m_D3D10DrawInstanced)           (ID3D10Device*, UINT, UINT, UINT, UINT);
    void (__stdcall * m_D3D10DrawAuto)                (ID3D10Device*);              
};

typedef struct _D3D11_HOOKS {     
    union {
    HRESULT (__stdcall * CreateSamplerState)(const D3D11_SAMPLER_DESC *,ID3D11SamplerState**);
    HRESULT (__stdcall * D3D10CreateSamplerState)(const D3D10_SAMPLER_DESC *,ID3D10SamplerState**);
    };
    DWORD aniso, point;
    DWORD W, H, WinW, WinH, HD_W, HD_H, ViewX;
    float scale;
    HRESULT (__stdcall * AHKSetup)(ID3D11Device*, DWORD, DWORD);
    HRESULT (__stdcall * CreateSwapChain)(IDXGIFactory*, IUnknown *, DXGI_SWAP_CHAIN_DESC *, IDXGISwapChain**ppSwapChain);
    HRESULT (__stdcall * CreateSwapChainForHwnd)(LPVOID/* IDXGIFactory2* */, IUnknown *, HWND, const DXGI_SWAP_CHAIN_DESC_1*,
    const LPVOID/* DXGI_SWAP_CHAIN_FULLSCREEN_DESC* */, IDXGIOutput*, LPVOID/* IDXGISwapChain1** */);
    HRESULT (__stdcall * IDXGISChainGetDesc)(IDXGISwapChain*, DXGI_SWAP_CHAIN_DESC*);
    HRESULT (__stdcall * IDXGISChainGetDesc1)(LPVOID, DXGI_SWAP_CHAIN_DESC_1*);
    HRESULT (__stdcall * GetBuffer)(IDXGISwapChain*, UINT, REFIID, void**);
    HRESULT (__stdcall * ResizeBuffers)(IDXGISwapChain*, UINT, UINT, UINT, DXGI_FORMAT,UINT);
    HRESULT (__stdcall * ResizeTarget)(IDXGISwapChain*, const DXGI_MODE_DESC *);
    HRESULT (__stdcall * GetDisplayModeList)(IDXGIOutput*, DXGI_FORMAT, UINT, UINT*,DXGI_MODE_DESC*);     
    union {
    void (__stdcall * RSSetViewports)(ID3D11DeviceContext *, UINT, const D3D11_VIEWPORT *);
    void (__stdcall * D3D10RSSetViewports)(ID3D10Device *, UINT, const D3D10_VIEWPORT *);
    };
    union {
    void (__stdcall * RSGetViewports)(ID3D11DeviceContext *, UINT*,  D3D11_VIEWPORT *);
    void (__stdcall * D3D10RSGetViewports)(ID3D10Device *, UINT*, const D3D10_VIEWPORT *);
    };    
    union{
        void (__stdcall * D3D10RSSetScissorRects)(ID3D10Device*,UINT,const D3D10_RECT *);
        void (__stdcall * RSSetScissorRects)(ID3D11DeviceContext*,UINT,const D3D11_RECT *);
    };    
    union{
        void (__stdcall * D3D10RSGetScissorRects)(ID3D10Device*, UINT*, D3D10_RECT *);
        void (__stdcall * RSGetScissorRects)(ID3D11DeviceContext*, UINT*, D3D11_RECT *);
    };     
    union{
        void (__stdcall * OMSetRenderTargets)(ID3D11DeviceContext*, UINT,
                                            ID3D11RenderTargetView * const *,
                                            ID3D11DepthStencilView *);
        void (__stdcall * D3D10OMSetRenderTargets)(ID3D10Device*, UINT,
                                            ID3D10RenderTargetView * const *,
                                            ID3D10DepthStencilView *);
    };    
    union{
        void (__stdcall * OMGetRenderTargets)(ID3D11DeviceContext*, UINT,
                                            ID3D11RenderTargetView **,
                                            ID3D11DepthStencilView **);
        void (__stdcall * D3D10OMGetRenderTargets)(ID3D10Device*, UINT,
                                            ID3D10RenderTargetView **,
                                            ID3D10DepthStencilView **);
    };     
    union{
        void (__stdcall * ClearDepthStencilView)(ID3D11DeviceContext*,
                                                ID3D11DepthStencilView *,
                                                UINT, FLOAT,UINT8);
        void (__stdcall * D3D10ClearDepthStencilView)(ID3D10Device*,
                                                    ID3D10DepthStencilView*,
                                                    UINT, FLOAT, UINT8);
    };     
    union{
        void (__stdcall * ClearRenderTargetView)(ID3D11DeviceContext*,
                                                ID3D11RenderTargetView *,
                                                const FLOAT [4]);
        void (__stdcall * D3D10ClearRenderTargetView)(ID3D10Device*,
                                                    ID3D10RenderTargetView*,
                                                    FLOAT);
    };     
    void (__stdcall * DiscardResource)(IUnknown*, ID3D11Resource *);
    void (__stdcall * DiscardView)(IUnknown*, ID3D11View  *);
    union{
        void (__stdcall * PSSetSamplers)(ID3D11DeviceContext*, UINT, UINT,
                                        ID3D11SamplerState *const *);
        void (__stdcall * D3D10PSSetSamplers)(ID3D10Device*, UINT, UINT,
                                            ID3D10SamplerState *const *);
    };
    union{
    HRESULT (__stdcall * CreatePixelShader)(ID3D11Device*, const void*,
                                            SIZE_T, ID3D11ClassLinkage *,
                                            ID3D11PixelShader  **);
    HRESULT (__stdcall * D3D10CreatePixelShader)(ID3D10Device*, const void*,
                                                SIZE_T, ID3D10PixelShader  **);
    };
    union{
    HRESULT (__stdcall * PxShaderRelease)(ID3D11PixelShader  *);
    HRESULT (__stdcall * D3D10PxShaderRelease)(ID3D10PixelShader  *);
    };     
    union{
        void (__stdcall * PSSetShader)(ID3D11DeviceContext*,  ID3D11PixelShader*,
                                        ID3D11ClassInstance * const *ppClassInstances,
                                        UINT);
        void (__stdcall * D3D10PSSetShader)(ID3D10Device*,  ID3D10PixelShader*);
    };
    POINTER_DICTIONARY * Shaders;
    ID3DBlob           * PxBlob;
    union{ID3D11PixelShader * CurrentPxReplacement; ID3D10PixelShader * CurrentPxReplacement10;};
    union{ID3D11PixelShader * CurrentPxShader; ID3D10PixelShader * CurrentPxShader10;};    
    HRESULT (__stdcall * IDXGISwapChain_Present)(IDXGISwapChain *, UINT, UINT);
    HRESULT (__stdcall * IDXGISwapChain_Present_Callback)(IDXGISwapChain *, UINT, UINT);
    union {
        LPVOID UNUSED0;
        //ID3D11Device             * dev;
        //ID3D10Device             * pDvc;
    };
    LPVOID UNUSED1; //ID3D11DeviceContext      * pContext;
    LPVOID UNUSED2; //union{ID3D11VertexShader * Bltvx;  ID3D10VertexShader * Bltvx10;};
    LPVOID UNUSED3; //union{ID3D11PixelShader  * Bltpx;  ID3D10PixelShader  * Bltpx10;};
    LPVOID UNUSED4; //union{ID3D11PixelShader  * Textpx; ID3D10PixelShader  * Textpx10;};
    LPVOID UNUSED5; //union{ID3D11Texture2D    * Texttx; ID3D10Texture2D    * Texttx10;};
    LPVOID UNUSED6; //union{ID3D11ShaderResourceView * Textvw; ID3D10ShaderResourceView * Textvw10;};
    LPCTSTR                    Text;
    LPCTSTR                    dump;
    DWORD                       clr;
#ifdef _WIN64
    DWORD pad3;
#endif    
    union {
        void (__stdcall * ResolveSubresource)(ID3D11DeviceContext*, ID3D11Resource*, UINT,
                                            ID3D11Resource *, UINT, DXGI_FORMAT);
        void (__stdcall * D3D10ResolveSubresource)(ID3D10Device*, ID3D10Resource*, UINT,
                                                    ID3D10Resource *, UINT, DXGI_FORMAT);
    };     
    union {
        void (__stdcall * CopyResource)(ID3D11DeviceContext*, ID3D11Resource *, ID3D11Resource *);
        void (__stdcall * D3D10CopyResource)(ID3D10Device*, ID3D10Resource *, ID3D10Resource *);
    };     
    union {
    void (__stdcall * CopySubresourceRegion)(ID3D11DeviceContext* ctx,ID3D11Resource *,UINT,
                                            UINT,UINT,UINT,ID3D11Resource *,UINT,
                                            const D3D11_BOX*);
    void (__stdcall * D3D10CopySubresourceRegion)(ID3D10Device*,  ID3D10Resource*, UINT,
                                                UINT, UINT, UINT,ID3D10Resource*, UINT,
                                                const D3D10_BOX *);
    };
    union {
    void (__stdcall * UpdateSubresource)(ID3D11DeviceContext*, ID3D11Resource*,UINT,
                                        const D3D11_BOX*, const void*, UINT, UINT);
    void (__stdcall * D3D10UpdateSubresource)(ID3D10Device*, ID3D10Resource*, UINT,
                                            const D3D10_BOX*, const void*, UINT, UINT);
    };
    HRESULT (__stdcall * ReadFromSubresource)(LPVOID, void*, UINT, UINT, ID3D11Resource *,
                                            UINT, const D3D11_BOX *);
    union{
    HRESULT (__stdcall *Map)(ID3D11DeviceContext*, ID3D11Resource*, UINT, D3D11_MAP, UINT,
                            D3D11_MAPPED_SUBRESOURCE*);
    HRESULT (__stdcall *D3D10Map)(ID3D10Texture2D *, UINT, D3D10_MAP, UINT, D3D10_MAPPED_TEXTURE2D *);
    };
    union{
    void    (__stdcall *Unmap)(ID3D11DeviceContext*, ID3D11Resource*, UINT);
    void    (__stdcall *D3D10Unmap)(ID3D10Texture2D *, UINT);
    };
    union {
    HRESULT (__stdcall * ImPSSetShaderResources)(ID3D11DeviceContext*,
                                                UINT, UINT,
                                                ID3D11ShaderResourceView * const *);
    void (__stdcall * D3D10PSSetShaderResources)(ID3D10Device*, UINT, UINT,
                                                ID3D10ShaderResourceView * const *);
    };
    union {
    HRESULT (__stdcall * CreateTexture2D)(ID3D11Device *,
                                        const D3D11_TEXTURE2D_DESC *,
                                        const D3D11_SUBRESOURCE_DATA *,
                                        ID3D11Texture2D **);
    HRESULT (__stdcall * D3D10CreateTexture2D)(ID3D10Device *,
                                        const D3D10_TEXTURE2D_DESC *,
                                        const D3D10_SUBRESOURCE_DATA *,
                                        ID3D10Texture2D**);
    };
    union {
    HRESULT (__stdcall * ReleaseTexture2D)(ID3D11Texture2D *);
    HRESULT (__stdcall * D3D10ReleaseTexture2D)(ID3D10Texture2D *);
    };
    union {
    HRESULT (__stdcall * CreateShaderResourceView)(ID3D11Device *,
                                                    ID3D11Resource *,
                                                    D3D11_SHADER_RESOURCE_VIEW_DESC *,
                                                    ID3D11ShaderResourceView **);
    HRESULT (__stdcall * D3D10CreateShaderResourceView)(ID3D10Device *,
                                                    ID3D10Resource *,
                                                    D3D10_SHADER_RESOURCE_VIEW_DESC *,
                                                    ID3D10ShaderResourceView **);
    };
    union {
    HRESULT (__stdcall * ReleaseShaderResourceView)(ID3D11ShaderResourceView *);
    HRESULT (__stdcall * D3D10ReleaseShaderResourceView)(ID3D10ShaderResourceView *);
    };
    RECT text_rect;
    RECT image_rect;
    BOOL Searching;
#ifdef _WIN64
    DWORD pad6;
#endif
    union{ID3D11Texture2D * current_view; ID3D10Texture2D * current_view10;};
    POINTER_DICTIONARY * textures;
    POINTER_DICTIONARY * replacements;
    POINTER_DICTIONARY * paths;
    DWORD autodmp;
} D3D11_HOOKS;

//================================FUCTIONS================================//
extern "C" __declspec(dllexport) void D3D11CreateShaders(IDXGISwapChain *);
ID3D11Device * D3D11DvcFromSChain(IDXGISwapChain *);
ID3D11Device * D3D11GetDevice(ID3D11DeviceChild *);
extern "C" __declspec(dllexport)
ID3D11ShaderResourceView * D3D11CreateTexture2D(ID3D11Device *, DWORD, DWORD, DXGI_FORMAT fmt);

extern LPVOID D3D11TextureIDFromView(ID3D11View * v);

extern "C" __declspec(dllexport) HRESULT __stdcall ReleasePixelShader11Hook(ID3D11PixelShader *pPxShader);

extern "C" __declspec(dllexport)
ID3D11Texture2D * D3D11LoadTexture(ID3D11Device * d, char * file);

HRESULT __stdcall D3D11DumpTexture(IUnknown *, LPCWSTR, DWORD);

void D3D10FindTexture2D(ID3D10_MAPPED *, ID3D10Resource *, BOOL);

void D3D11ReplaceTexture(ID3D11Resource * r);

DWORD D3D11DumpShader(void);

UINT D3D11ViewType(ID3D11View *, IUnknown**);

ID3D11DeviceContext * D3D11Cntxt(ID3D11Device * d);

extern "C" BOOL IsD3D11Device(IUnknown * i);

extern "C" ID3D10Device * GetD3D10Device(IUnknown * i);

void D3D10Present(IDXGISwapChain *, UINT, UINT);

HRESULT D3D11WriteOnSurface(ID3D11Device *, ID3D11Texture2D *, wchar_t *, DWORD);

void D3D11Blit(IDXGISwapChain *, ID3D11Resource *, ID3D11RenderTargetView *, RECT *, RECT*);
void D3D11Blit(IDXGISwapChain *, ID3D11ShaderResourceView *, ID3D11RenderTargetView *, RECT *, RECT*);
void D3D11VMirrorBlit(IDXGISwapChain *, ID3D11ShaderResourceView *, ID3D11RenderTargetView *, RECT *, RECT*);
void D3D11RenderText(IDXGISwapChain *, const wchar_t *, RECT *);

void __stdcall D3D10PSSetShaderResourcesRef(ID3D10Device*, UINT, UINT,
                                            ID3D10ShaderResourceView * const *);

extern "C" __declspec(dllexport) ID3D10Device * D3D10DvcFromSChain(IDXGISwapChain * );
extern "C" __declspec(dllexport)
ID3D10ShaderResourceView * D3D10CreateTexture2D(ID3D10Device *, DWORD, DWORD, DXGI_FORMAT);
extern "C" __declspec(dllexport)
ID3D10Texture2D * D3D10CreateSysTexture(ID3D10Device *, UINT, UINT);
extern "C" __declspec(dllexport)
ID3D10Texture2D * D3D10LoadTexture(ID3D10Device * , char *);

LPVOID * D3D10TextureID(ID3D10Texture2D * r);
LPVOID * D3D10TextureID(ID3D10Resource * r);
LPVOID D3D10GetViewResourceID(ID3D10ShaderResourceView * vw);
LPVOID D3D10TextureIDFromView(ID3D10View * v);
HRESULT __stdcall D3D10DumpTexture(ID3D10Device *, IUnknown *, LPCWSTR, DWORD);
ID3D10Resource * D3D10GetResource(ID3D10View * );
ID3D10Device * D3D10GetDevice(ID3D10DeviceChild *);
void D3D10Blit(IDXGISwapChain *, ID3D10Resource *, ID3D10PixelShader *, ID3D10RenderTargetView *, RECT *, RECT*);
void D3D10Blit(IDXGISwapChain *, ID3D10ShaderResourceView *, ID3D10RenderTargetView *, RECT *, RECT*);
void D3D10VMirrorBlit(IDXGISwapChain *, ID3D10ShaderResourceView *, ID3D10RenderTargetView *, RECT *, RECT*);
void D3D10RenderText(IDXGISwapChain *, const wchar_t *, RECT *);
char * __stdcall D3D11LoadWine(char *, char *, char*, UINT);
ID3D11PixelShader * D3D11FixAndCompileDXBCShader(BYTE *, UINT, string *, float, ID3D11Device *);
ID3D10PixelShader * D3D10FixAndCompileDXBCShader(BYTE * , UINT, string *, float, ID3D10Device *);
ID3D10Resource * D3D10ShrinkTexture2D(ID3D10Resource *);

//============================HOOKS=========================================//

void __stdcall D3D11DrawHook(ID3D11DeviceContext*, UINT, UINT);
void __stdcall D3D11DrawIndexedHook(ID3D11DeviceContext*, UINT, UINT, INT);
void __stdcall D3D11DrawAutoHook(ID3D11DeviceContext*);
void __stdcall D3D11DrawInstancedHook(ID3D11DeviceContext*, UINT, UINT, UINT, UINT);
void __stdcall D3D11DrawInstancedIndirectHook(ID3D11DeviceContext*, ID3D11Buffer*, UINT);
void __stdcall D3D11DrawIndexedInstancedHook(ID3D11DeviceContext*, UINT, UINT, UINT, INT, UINT);
void __stdcall D3D11DrawIndexedInstancedIndirectHook(ID3D11DeviceContext*, ID3D11Buffer*, UINT);
void __stdcall D3D11RSSetViewportsHook (ID3D11DeviceContext*, UINT, D3D11_VIEWPORT*);
extern "C" __declspec(dllexport) void __stdcall OMSetRenderTargetsAndUnorderedAccessViewsHook(ID3D11DeviceContext*, UINT, ID3D11RenderTargetView* const*,  ID3D11DepthStencilView*,
                                                             UINT, UINT, ID3D11UnorderedAccessView* const*, const UINT*);
void __stdcall D3D11ClearViewHook(ID3D11DeviceContext1*, ID3D11View *, const FLOAT Color[4], const D3D11_RECT *, UINT);
                                                         
void __stdcall D3D10DrawAutoHook(ID3D10Device*);
void __stdcall D3D10DrawIndexedHook(ID3D10Device*, UINT, UINT, INT);
void __stdcall D3D10DrawHook(ID3D10Device*, UINT , UINT);
void __stdcall D3D10DrawInstancedHook(ID3D10Device*, UINT, UINT, UINT, UINT);
void __stdcall D3D10DrawIndexedInstancedHook(ID3D10Device*, UINT, UINT, UINT, INT, UINT);

//========================VARIABLES=========================================//

extern D3D11_HOOKS   * D3D11_Hooks;
extern D3D11_GLOBALS  D3D11Globals;

//=================================Classes=================================//

class ID3D11Weak : public virtual IUnknown {
public:
    virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID, void**)
    {
        return E_NOINTERFACE;
    }
    virtual ULONG STDMETHODCALLTYPE AddRef(void)
    {
        m_ref += 1;        
        return m_ref;
    }
    virtual ULONG STDMETHODCALLTYPE Release(void)
    {
        m_ref    -= 1;
        ULONG ref = m_ref;        
        if (m_ref == 0) delete this;
        return ref;
    }
    virtual ~ID3D11Weak(){}
    ID3D11Weak(IUnknown * ptr){m_weak=ptr;}
    ULONG       m_ref = 0;
    IUnknown * m_weak = nullptr;
};

class ID3D11ProxyTexture : public virtual IUnknown {
public:
    virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID, void**)
    {
        return E_NOINTERFACE;
    }
    virtual ULONG STDMETHODCALLTYPE AddRef()
    {
        m_ref += 1;
        return m_ref;
    }
    virtual ULONG STDMETHODCALLTYPE Release()
    {
        m_ref    -= 1;
        ULONG ref = m_ref;        
        if (m_ref == 0) delete this;
        return ref;
    }
    virtual ID3D11ShaderResourceView *
    SRV(ID3D11DeviceContext * c, ID3D11ShaderResourceView * view, ID3D11Resource * rs)
    {
        //return nullptr;
        ID3D11ShaderResourceView * proxy_view = nullptr;
        D3D11TexUnWrapp               proxy_tx(m_proxy);
        D3D11TexUnWrapp                          tx(rs);
        D3D11SRVDesc                    view_desc(view);

        /* For a replacement texture loaded from disk, MipLevels might be different */
        view_desc.m_desc.Texture2D.MipLevels = proxy_tx.Desc()->MipLevels;

        if (proxy_tx.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("PROXY IS NOT A 2D TEXTURE");
            return nullptr;
        }
        else if (tx.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("RESOURCE NOT NOT A 2D TEXTURE");
            return nullptr;
        }
        if (tx.Desc()->Format != proxy_tx.Desc()->Format)
        {
            view_desc.m_desc.Format = proxy_tx.Desc()->Format;
        }
        if (D3D11GetDevice(c)->CreateShaderResourceView(proxy_tx.m_tx2d, &view_desc.m_desc, &proxy_view) != 0)
        {
            DBUG_WARN("CreateShaderResourceView FAILED");
            return nullptr;
        }
        //proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11ProxyTexture, (IUnknown*)view);
        //proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11Weak, (IUnknown*)new ID3D11Weak(view));
        RecordViewDesc(*(DWORD*)"SRVW", &view_desc.m_desc);
        return proxy_view;
    }
    virtual ID3D11RenderTargetView *
    RTV(ID3D11DeviceContext * c, ID3D11RenderTargetView * view, ID3D11Resource * rs)
    {
        m_Istarget                            = 1;
        ID3D11RenderTargetView * proxy_view   = nullptr;
        D3D11TexUnWrapp       proxy_tx(m_proxy10);
        D3D11TexUnWrapp                    tx(rs);
        D3D11RTVDesc                    view_desc(view);

        if (proxy_tx.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("PROXY IS NOT A 2D TEXTURE");
            return nullptr;
        }
        else if (tx.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("RESOURCE NOT NOT A 2D TEXTURE");
            return nullptr;
        }
        if (tx.Desc()->Format != proxy_tx.Desc()->Format)
        {
            view_desc.m_desc.Format = proxy_tx.Desc()->Format;
        }
        if (D3D11GetDevice(c)->CreateRenderTargetView(proxy_tx.m_tx2d, &view_desc.m_desc, &proxy_view) != 0)
        {
            DBUG_WARN("CreateShaderResourceView FAILED");
            return nullptr;
        }
        //proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11ProxyTexture, (IUnknown*)view);
        //proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11Weak, (IUnknown*)new ID3D11Weak(view));
        RecordViewDesc(*(DWORD*)"RTVW", &view_desc.m_desc);
        return proxy_view;
    }
    virtual ID3D11DepthStencilView *
    DSV(ID3D11DeviceContext * c, ID3D11DepthStencilView * view, ID3D11Resource * rs)
    {
        m_Istarget                            = 1;
        ID3D11DepthStencilView * proxy_view   = nullptr;
        D3D11TexUnWrapp             proxy_tx(m_proxy10);
        D3D11TexUnWrapp                          tx(rs);
        D3D11DSVDesc                    view_desc(view);

        if (proxy_tx.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("PROXY IS NOT A 2D TEXTURE");
            return nullptr;
        }
        else if (tx.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("RESOURCE NOT NOT A 2D TEXTURE");
            return nullptr;
        }
        if (tx.Desc()->Format != proxy_tx.Desc()->Format)
        {
            view_desc.m_desc.Format = proxy_tx.Desc()->Format;
        }
        if (D3D11GetDevice(c)->CreateDepthStencilView(proxy_tx.m_tx2d, &view_desc.m_desc, &proxy_view) != 0)
        {
            DBUG_WARN("CreateShaderResourceView FAILED");
            return nullptr;
        }
        //proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11ProxyTexture, (IUnknown*)view);
        //proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11Weak, (IUnknown*)new ID3D11Weak(view));
        RecordViewDesc(*(DWORD*)"DSVW", &view_desc.m_desc);
        return proxy_view;
    }
    virtual ID3D11UnorderedAccessView*
    UAV(ID3D11DeviceContext* c, ID3D11UnorderedAccessView* view, ID3D11Resource* rs)
    {
        ID3D11UnorderedAccessView* proxy_view = nullptr;
        D3D11TexUnWrapp               proxy_tx(m_proxy);
        D3D11TexUnWrapp                          tx(rs);
        D3D11UAVDesc                    view_desc(view);

        if (proxy_tx.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("PROXY IS NOT A 2D TEXTURE");
            return nullptr;
        }
        else if (tx.Type() != D3D11_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("RESOURCE IS NOT A 2D TEXTURE");
            return nullptr;
        }
        if (tx.Desc()->Format != proxy_tx.Desc()->Format)
        {
            view_desc.m_desc.Format = proxy_tx.Desc()->Format;
        }
        if (D3D11GetDevice(c)->CreateUnorderedAccessView(proxy_tx.m_tx2d, &view_desc.m_desc, &proxy_view) != 0)
        {
            DBUG_WARN("CreateUnorderedAccessView FAILED");
            return nullptr;
        }
        //proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11ProxyTexture, (IUnknown*)view);
        //proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11Weak, (IUnknown*)new ID3D11Weak(view));
        return proxy_view;
    }
    virtual ID3D11View * View(ID3D11Device * d)
    {
        D3D11TexUnWrapp  proxy_tx(m_proxy);
        if (m_lastviewType == *(DWORD*)"SRVW")
        {
            ID3D11ShaderResourceView * proxy_view = nullptr;
            if (d->CreateShaderResourceView(proxy_tx.m_tx2d, &m_lastSRVDesc, &proxy_view) != 0)
            {
                DBUG_WARN("CreateShaderResourceView FAILED");
                return nullptr;
            }
            return proxy_view;
        }
        else if (m_lastviewType == *(DWORD*)"RTVW")
        {
            ID3D11RenderTargetView * proxy_view = nullptr;
            if (d->CreateRenderTargetView(proxy_tx.m_tx2d, &m_lastRTVDesc, &proxy_view) != 0)
            {
                DBUG_WARN("CreateRendertargetView FAILED");
                return nullptr;
            }
            return proxy_view;
        }
        else if  (m_lastviewType == *(DWORD*)"DSVW")
        {
            ID3D11DepthStencilView * proxy_view = nullptr;
            if (d->CreateDepthStencilView(proxy_tx.m_tx2d, &m_lastDSVDesc, &proxy_view) != 0)
            {
                DBUG_WARN("CreateDepthStencilView FAILED");
                return nullptr;
            }
            return proxy_view;
        }       
        else
        {
            DBUG_WARN("UNKNOWN VIEW TYPE");
            return nullptr;
        }
    }
    virtual ID3D10ShaderResourceView *
    SRV10(ID3D10Device * d, ID3D10ShaderResourceView * view, ID3D10Resource * rs)
    {
        ID3D10ShaderResourceView * proxy_view = nullptr;
        D3D11TexUnWrapp       proxy_tx(m_proxy10, TRUE);
        D3D11TexUnWrapp                    tx(rs, TRUE);
        D3D10SRVDesc                    view_desc(view);

        /* For a replacement texture loaded from disk, MipLevels might be different */
        view_desc.m_desc.Texture2D.MipLevels = proxy_tx.Desc10()->MipLevels;

        if (proxy_tx.Type10() != D3D10_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("PROXY IS NOT A 2D TEXTURE");
            return nullptr;
        }
        else if (tx.Type10() != D3D10_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("RESOURCE NOT NOT A 2D TEXTURE");
            return nullptr;
        }        
        if (tx.Desc10()->Format != proxy_tx.Desc10()->Format)
        {
            view_desc.m_desc.Format = proxy_tx.Desc10()->Format;
        }
        if (d->CreateShaderResourceView(proxy_tx.m_tx2d10, &view_desc.m_desc, &proxy_view) != 0)
        {
            DBUG_WARN("CreateShaderResourceView FAILED");
            return nullptr;
        }
        view->SetPrivateDataInterface((GUID&)g_.D3D11ProxyTexture, (IUnknown*)proxy_view);
        proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11Weak, (IUnknown*)new ID3D11Weak(view));
        proxy_view->Release();
        return proxy_view;
    }
    virtual ID3D10RenderTargetView *
    RTV10(ID3D10Device * d, ID3D10RenderTargetView * view, ID3D10Resource * rs)
    {
        m_Istarget                            = 1;
        ID3D10RenderTargetView * proxy_view   = nullptr;
        D3D11TexUnWrapp       proxy_tx(m_proxy10, TRUE);
        D3D11TexUnWrapp                    tx(rs, TRUE);
        D3D10RTVDesc                    view_desc(view);

        if (proxy_tx.Type10() != D3D10_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("PROXY IS NOT A 2D TEXTURE");
            return nullptr;
        }
        else if (tx.Type10()  != D3D10_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("RESOURCE NOT NOT A 2D TEXTURE");
            return nullptr;
        }
        if (tx.Desc10()->Format != proxy_tx.Desc10()->Format)
        {
            view_desc.m_desc.Format = proxy_tx.Desc10()->Format;
        }
        if (d->CreateRenderTargetView(proxy_tx.m_tx2d10, &view_desc.m_desc, &proxy_view) != 0)
        {
            DBUG_WARN("CreateShaderResourceView FAILED");
            return nullptr;
        }
        view->SetPrivateDataInterface((GUID&)g_.D3D11ProxyTexture, (IUnknown*)proxy_view);
        proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11Weak, (IUnknown*)new ID3D11Weak(view));
        proxy_view->Release();
        return proxy_view;
    }
    virtual ID3D10DepthStencilView *
    DSV10(ID3D10Device * d, ID3D10DepthStencilView * view, ID3D10Resource * rs)
    {
        m_Istarget                            = 1;
        ID3D10DepthStencilView * proxy_view   = nullptr;
        D3D11TexUnWrapp       proxy_tx(m_proxy10, TRUE);
        D3D11TexUnWrapp                    tx(rs, TRUE);
        D3D10DSVDesc                    view_desc(view);

        if (proxy_tx.Type10() != D3D10_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("PROXY IS NOT A 2D TEXTURE");
            return nullptr;
        }
        else if (tx.Type10()  != D3D10_RESOURCE_DIMENSION_TEXTURE2D)
        {
            DBUG_WARN("RESOURCE NOT NOT A 2D TEXTURE");
            return nullptr;
        }
        if (tx.Desc10()->Format != proxy_tx.Desc10()->Format)
        {
            view_desc.m_desc.Format = proxy_tx.Desc10()->Format;
        }
        if (d->CreateDepthStencilView(proxy_tx.m_tx2d10, &view_desc.m_desc, &proxy_view) != 0)
        {
            DBUG_WARN("CreateShaderResourceView FAILED");
            return nullptr;
        }
        view->SetPrivateDataInterface((GUID&)g_.D3D11ProxyTexture, (IUnknown*)proxy_view);
        proxy_view->SetPrivateDataInterface((GUID&)g_.D3D11Weak, (IUnknown*)new ID3D11Weak(view));
        proxy_view->Release();
        return proxy_view;
    }    
    virtual void RecordViewDesc(DWORD type, void* desc)
    {
        if (type == *(DWORD*)"SRVW")
        {
            m_lastviewType = type;
            memccpy(&m_lastSRVDesc, desc, sizeof(m_lastSRVDesc), sizeof(D3D11_SHADER_RESOURCE_VIEW_DESC));
        }
        else if (type == *(DWORD*)"RTVW")
        {
            m_lastviewType = type;
            memccpy(&m_lastRTVDesc, desc, sizeof(m_lastRTVDesc), sizeof(D3D11_RENDER_TARGET_VIEW_DESC));    
        }
        else if (type == *(DWORD*)"DSVW")
        {
            m_lastviewType = type;
            memccpy(&m_lastDSVDesc, desc, sizeof(m_lastDSVDesc), sizeof(D3D11_DEPTH_STENCIL_VIEW_DESC));
        }
        else DBUG_WARN((char*)(string("UNHANTED VIEW TYPE: ") + to_string(type)).c_str());
    }
    virtual ~ID3D11ProxyTexture() {
        D3D11Globals.ProxyCount->Decrement(); UINT href = 1; if (m_proxy) href = m_proxy->Release();       
        //DBUG_WARN((to_string(D3D11Globals.ProxyCount->Get()) + " " + to_string(href)).c_str());
    }
    ID3D11ProxyTexture(ID3D11Resource * proxy){m_proxy = proxy; D3D11Globals.ProxyCount->Increment();}
    ID3D11ProxyTexture(ID3D10Resource * proxy){m_proxy10 = proxy;}
    BOOL               m_Istarget     = 0;
    ULONG              m_ref          = 0;
    DWORD              m_lastviewType = 0;
    union {
        D3D11_SHADER_RESOURCE_VIEW_DESC m_lastSRVDesc = {};
        D3D11_RENDER_TARGET_VIEW_DESC   m_lastRTVDesc;
        D3D11_DEPTH_STENCIL_VIEW_DESC   m_lastDSVDesc;
    };
    union {ID3D11Resource * m_proxy = nullptr; ID3D10Resource * m_proxy10;};
};

class D3D11Texture2DRTView {
    public:
    ID3D11RenderTargetView * m_VW = nullptr;
    D3D11Texture2DRTView(ID3D11Resource *);
    ~D3D11Texture2DRTView(){if (m_VW) m_VW->Release();}
};

class D3D11Texture2DView {
    public:
    ID3D11ShaderResourceView * m_VW = nullptr;
    D3D11Texture2DView(ID3D11Resource *);
    ~D3D11Texture2DView(){if (m_VW) m_VW->Release();}
};

class D3D10Texture2DView {
    public:
    ID3D10ShaderResourceView * m_VW = nullptr;
    D3D10Texture2DView(ID3D10Resource *);
    ~D3D10Texture2DView(){if (m_VW) m_VW->Release();}
};

class D3D11Bliter {
public:
    float                    m_blndfactor[4] = {};
    UINT                     m_Blndmask      =  0;
    UINT                     m_stencilref    =  0;
    ID3D11BlendState         * m_bld    = nullptr;
    RECT                     m_scr[8]   = {{ 0 }};
    D3D11_VIEWPORT           m_vws[8]   = {{ 0 }};
    ID3D11SamplerState       * m_smplr  = nullptr;
    ID3D11RasterizerState    * m_rstr   = nullptr;
    ID3D11Buffer             * m_prms   = nullptr;
    ID3D11Buffer             * m_CB0    = nullptr;
    ID3D11Device             * m_Dvc    = nullptr;
    IDXGISwapChain           * m_sc     = nullptr;
    ID3D11ShaderResourceView * m_srv    = nullptr;
    ID3D11RenderTargetView   * m_rtv[8] = {0,0,0,0,0,0,0,0};
    ID3D11DepthStencilView   * m_dsv    = nullptr;
    ID3D11PixelShader        * m_px     = nullptr;
    ID3D11VertexShader       * m_vx     = nullptr;
    ID3D11InputLayout        * m_il     = nullptr;
    D3D_PRIMITIVE_TOPOLOGY     m_pt     = (D3D_PRIMITIVE_TOPOLOGY)0;
    void SetStates();
    D3D11Bliter(ID3D11Device *, IDXGISwapChain *);
    ~D3D11Bliter();
    ID3D11RenderTargetView * GetRTV();
    void UpdateRects(RECT*, RECT *, ID3D11RenderTargetView * );
    HRESULT Blt(ID3D11PixelShader*, ID3D11VertexShader*,
                ID3D11ShaderResourceView*, ID3D11RenderTargetView*, RECT*, RECT*);
    HRESULT Blt(ID3D11PixelShader*, ID3D11VertexShader*,
                ID3D11Resource*, ID3D11RenderTargetView*, RECT*, RECT*);
};

class D3D10Bliter {
public:
    RECT                       m_scr[8]   = {{ 0 }};
    D3D10_VIEWPORT             m_vws[8]   = {{ 0 }};
    float                      m_blndfactor[4] = {};
    UINT                       m_Blndmask      =  0;
    UINT                       m_stencilref    =  0;
    ID3D10BlendState           * m_bld    = nullptr;
    ID3D10RasterizerState      * m_rstr   = nullptr;
    ID3D10SamplerState         * m_smplr  = nullptr;
    ID3D10DepthStencilState    * m_dps    = nullptr;
    ID3D10Buffer               * m_CB0    = nullptr;
    ID3D10Buffer               * m_prms   = nullptr;
    ID3D10Device               * m_Dvc    = nullptr;
    IDXGISwapChain             * m_sc     = nullptr;
    ID3D10ShaderResourceView   * m_srv    = nullptr;
    ID3D10RenderTargetView     * m_rtv[8] =      {};
    ID3D10DepthStencilView     * m_dsv =    nullptr;
    ID3D10PixelShader          * m_px  =    nullptr;
    ID3D10VertexShader         * m_vx  =    nullptr;
    ID3D10InputLayout          * m_il  =    nullptr;
    D3D_PRIMITIVE_TOPOLOGY       m_pt  = (D3D_PRIMITIVE_TOPOLOGY)0;
    void SetStates();
    D3D10Bliter(IUnknown *, IDXGISwapChain *);
    ~D3D10Bliter();
    ID3D10RenderTargetView * GetRTV();
    void UpdateRects(RECT*, RECT *, ID3D10RenderTargetView * );
    HRESULT Blt(ID3D10PixelShader*, ID3D10VertexShader*,
                ID3D10ShaderResourceView*, ID3D10RenderTargetView*, RECT*, RECT*);
    HRESULT Blt(ID3D10PixelShader*, ID3D10VertexShader*,
                ID3D10Resource*, ID3D10RenderTargetView*, RECT*, RECT*);
};

struct D3D11Bytecode {
public:
    BYTE * m_Bytecode             = nullptr;
    SIZE_T m_sz                   = NULL;
    ID3DBlob *     m_blob         = nullptr;
    IUnknown * m_Disabled         = nullptr;
    int        m_IsVPosShader     = -1;
    int        m_IsLoadShader     = -1;
    int        m_ResInfo          = -1;
    union {
    ID3D11PixelShader * m_replace = nullptr;
    ID3D10PixelShader * m_replace10;
    };
    std::wstring        m_name;
    D3D11Bytecode(SIZE_T sz, BYTE * Bytecode){
        m_sz = sz;
        m_Bytecode = new BYTE[sz]();
        memcpy(m_Bytecode, Bytecode, sz);
        m_name.clear();
        m_name.append(L"Not dumped");
    }
    D3D11Bytecode(SIZE_T sz, BYTE * Bytecode, wchar_t * name){
        m_name.clear();
        m_name.append(name);
        m_sz = sz;
        m_Bytecode = new BYTE[sz]();
        memcpy(m_Bytecode, Bytecode, sz);
    }
    ~D3D11Bytecode(){
        if (m_Bytecode) delete[] m_Bytecode;
        if (m_blob)     m_blob->Release();
        if (m_replace)  m_replace->Release();
    }
    void Fix(ID3D11Device * pDvc, ID3D11PixelShader * original)
    {
        //return;
        IsVPostShader();       
        if ((m_IsVPosShader  == 1) || (m_IsLoadShader == 1) || (m_ResInfo == 1))
        {           
            std::string code = (char*)m_blob->GetBufferPointer();                   
            auto px = D3D11FixAndCompileDXBCShader(m_Bytecode, m_sz, &code, g_d3d.mScl->Get()*g_d3d.SSAA, pDvc);
            if (px != nullptr)
            {                
                Replace(original, px);
            }
        }
    }
    void Fix10(ID3D10Device * pDvc, ID3D10PixelShader * original)
    {
        IsVPostShader();       
        if ((m_IsVPosShader  == 1) || (m_IsLoadShader == 1) || (m_ResInfo == 1))
        {           
            std::string code = (char*)m_blob->GetBufferPointer();                   
            auto px = D3D10FixAndCompileDXBCShader(m_Bytecode, m_sz, &code, g_d3d.mScl->Get()*g_d3d.SSAA, pDvc);
            if (px != nullptr)
            {                
                Replace10(original, px);
            }
        }
    }
    void Reset(ID3D11PixelShader * p)
    {
        if (m_replace == nullptr) return;        
        m_replace->Release();
        m_replace        = nullptr;
        ID3D11Device * d = nullptr;
        p->GetDevice(&d);
        if (nullptr == d)
        {            
            DBUG_WARN("ID3D11PixelShader::GetDevice FAILED")
            return;
        }
        Fix(d, p);
        d->Release();              
    }
    void Replace(ID3D11PixelShader * original, ID3D11PixelShader * replacement)
    {        
        if (S_OK != original->SetPrivateDataInterface((GUID&)g_.D3D11ProxyShader, replacement))
        {
            DBUG_WARN("SetPrivateDataInterface FAILED")
            return;
        }
        m_replace = replacement;
    }
    void Replace10(ID3D10PixelShader * original, ID3D10PixelShader * replacement)
    {        
        if (S_OK != original->SetPrivateDataInterface((GUID&)g_.D3D11ProxyShader, replacement))
        {
            DBUG_WARN("SetPrivateDataInterface FAILED")
            return;
        }
        m_replace10 = replacement;
    }
    int operator==(const D3D11Bytecode*c){
        if (m_sz != c->m_sz)
        return 0;
        return memcmp(m_Bytecode, c->m_Bytecode, m_sz) == 0 ? 1:0;
    }
    void set(IUnknown * d){
        if (m_Disabled) D3D11_Hooks->PxShaderRelease((ID3D11PixelShader*)m_Disabled);
        m_Disabled = d;
    }
    HRESULT Disassemble(){
        if (m_blob != nullptr) return 0;
        return g_d3d.m_D3DDisassemble(m_Bytecode, m_sz, 0, "", &m_blob);
    }
    int IsVPostShader(){
        if (m_IsVPosShader >-1) return m_IsVPosShader;
        Disassemble();
        std::string shader_asm( (char*)m_blob->GetBufferPointer() );
        std::string asm_instructions = shader_asm.substr(shader_asm.find("ps_"), std::string::npos);
        m_IsVPosShader =
            asm_instructions.find(", position") != std::string::npos && asm_instructions.find("dcl_input_ps_siv") != std::string::npos ? 1 : 0;
        m_IsLoadShader = asm_instructions.find("ld")      != std::string::npos ? 1 : 0;
        m_ResInfo      = asm_instructions.find("resinfo") != std::string::npos ? 1 : 0;
        return m_IsVPosShader;
    }
};

class D3D11DeviceFromSwapShain
{
public:
    D3D11DeviceFromSwapShain(IDXGISwapChain * sc)
    {
        if (sc->GetDevice(__uuidof(IDXGIDevice), (void**)&m_DXGIDevice))
        {
            DBUG_WARN("::GetDevice FAILED");
        }
        else {
            if (m_DXGIDevice->QueryInterface(__uuidof(ID3D11Device), (void**)&m_D3D11Device))
            {
                DBUG_WARN("IDXGIDevice::QueryInterface FAILED");
            }
        }
    }
    ~D3D11DeviceFromSwapShain(){
        if (m_DXGIDevice)   m_DXGIDevice->Release();
        if (m_D3D11Device) m_D3D11Device->Release();
    }
    IDXGIDevice  * m_DXGIDevice  = nullptr;
    ID3D11Device * m_D3D11Device = nullptr;
};

class D3D11ResourceType {
    public:
    D3D11ResourceType(ID3D11Resource * r)
    {
        m_err_string.clear();
        if (r == nullptr) m_err_string.append("ID3D11Resource Type: nullptr");
        else
        {
            D3D11_RESOURCE_DIMENSION d;
            r->GetType(&d);
            if      (d == 0) m_err_string.append("D3D11_RESOURCE_DIMENSION_UNKNOWN");
            else if (d == 1) m_err_string.append("D3D11_RESOURCE_DIMENSION_BUFFER");
            else if (d == 2) m_err_string.append("D3D11_RESOURCE_DIMENSION_TEXTURE1D");
            else if (d == 3) m_err_string.append("D3D11_RESOURCE_DIMENSION_TEXTURE2D");
            else if (d == 4) m_err_string.append("D3D11_RESOURCE_DIMENSION_TEXTURE3D");
        }
    }
    const char* Type(){
        return m_err_string.c_str();
    }
    std::string m_err_string;
};

class D3D11DeviceFromChild {
public:
    D3D11DeviceFromChild(ID3D11DeviceChild * Child){
        if (Child == nullptr) {
            DBUG_WARN("NULL ID3D11DeviceChild")            
        } else Child->GetDevice(&m_Dvc);
    }
    ~D3D11DeviceFromChild(){
        if (m_Dvc) m_Dvc->Release();
    }
    ID3D11Device * Dvc() {return m_Dvc;}
private:
    ID3D11Device * m_Dvc = nullptr;
};

ID3D11ProxyTexture * D3D11GetProxy(ID3D11DeviceChild *);
ID3D11ProxyTexture * D3D11GetProxy(ID3D11DeviceChild *, const char *);
ID3D11Resource * D3D11GetResource(ID3D11View *);
extern "C" __declspec(dllexport) HRESULT D3D11Resize(IDXGISwapChain*);

ID3D10Resource * D3D10GetResource(ID3D10View *);
ID3D11ProxyTexture * D3D10GetProxy(ID3D10DeviceChild *);
ID3D11ProxyTexture * D3D10GetProxy(ID3D10DeviceChild *, const char *);
ID3D10Device * D3D10GetDevice(ID3D10DeviceChild *);
#endif
