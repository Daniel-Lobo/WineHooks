#ifndef D3D12UTILS_H
#define D3D12UTILS_H

#include <shlwapi.h>
#include <string>
#include <fstream>
#include <vector>
#include "Dbug.h"
#include "Sync.h"
#include "d3d11_4.h"
#include <d3d12.h>
#include "d3d11on12.h"

extern HWND GetSwapChainWindowHandle(IDXGISwapChain *);
extern DWORD GetDXGISurfacePxFormat(DWORD);
extern DWORD SetDXGISurfacePxFormat(DXGI_FORMAT *, DWORD);
extern double D3D12GetMemoryUsage(IUnknown*, UINT);

struct D3D11HelperDvc {
    D3D11HelperDvc(){}
    HRESULT           __stdcall Init();
    void              __stdcall CSBlit(ID3D11Texture2D*,ID3D11Resource*);
    void              __stdcall SSAABlit(ID3D11Texture2D*, ID3D11Texture2D*);
    void              __stdcall DwnScaleBlit(ID3D11Resource*, ID3D11Resource*);
    void              __stdcall FSR(ID3D11Texture2D*,ID3D11Resource*);
    void              __stdcall Copy2Screen(ID3D11Texture2D*,ID3D11Texture2D*);
    void              __stdcall CleanUP();
    void              __stdcall InitResources(DXGI_FORMAT);
    void              __stdcall Reset(IDXGISwapChain*, IUnknown*);
    void              __stdcall ResetDevice(ID3D12Device*, IDXGISwapChain*, ID3D12CommandQueue*);
    ID3D11Texture2D * __stdcall AccquireTexture(ID3D12Resource*, UINT);
    void              __stdcall UnAccquireTexture(ID3D11Texture2D*);    
    ID3D12Resource  * __stdcall GetBuffer(IDXGISwapChain* SChain, DWORD index);
    HRESULT           __stdcall Present(IDXGISwapChain*, UINT, UINT);     
    ID3D11On12Device     * m_11on12          = nullptr;
    ID3D11Device         * m_Dvc             = nullptr;
    ID3D11DeviceContext  * m_Ctxt            = nullptr;
    ID3D11Buffer         * m_CSConstants     = nullptr;
    ID3D11ComputeShader  * m_DwnScl          = nullptr;
    ID3D11ComputeShader  * m_Bliter          = nullptr;
    ID3D11ComputeShader  * m_RCAS            = nullptr; // AMD's FSR Robust Contrast Adaptive Sharpening pass
    ID3D11ComputeShader  * m_EASU            = nullptr; // AMD's FSR Edge Adaptive Spatial Upsampling pass
    ID3D11ComputeShader  * m_SSAA            = nullptr; 
    ID3D11ComputeShader  * m_SSAAHQ          = nullptr; 
    ID3D11ComputeShader  * m_TXAAFix         = nullptr; 
    ID3D11SamplerState   * m_RCASSampler     = nullptr;
    ID3D11Texture2D      * m_Pass0Output     = nullptr;
    ID3D11Texture2D      * m_Pass1Output     = nullptr;
    ID3D11ShaderResourceView  * m_EASUInput  = nullptr; // EASU (and bliter) Input  = Proxy Backbuffer
    ID3D11UnorderedAccessView * m_EASUOutPut = nullptr; // EASU              OutPut = Subresource 0 of m_CSOutput
    ID3D11ShaderResourceView  * m_RCASInput  = nullptr; // RCAS Input               = Subresource 0 of m_CSOutput
    ID3D11UnorderedAccessView * m_RCASOutPut = nullptr; // RCAS (and bliter) OutPut = Subresource 1 of m_CSOutput
};

class CheckerBoard {
public:
    CheckerBoard(UINT color0=0xff00ff00, UINT color1=0xffffffff, UINT size=256, UINT block_count=16)
    {
        m_pattern           = new UINT[(size_t)size*size];
        UINT color, * pixel =           m_pattern;
        UINT pxl_per_block  =    size/block_count;

        for (UINT line=0; line<size; line++)
        {
            color = (line/pxl_per_block)%2 == 0 ? color0 : color1;
            for (UINT block=0; block<pxl_per_block; block++)
            {
                color = color == color1 ? color0 : color1;
                for (UINT pxl=0; pxl<pxl_per_block; pxl++)
                {
                    * pixel = color;
                    pixel++;
                }
            }
        }
    }    
    ~CheckerBoard(){
       if (m_pattern) delete [] m_pattern;
    }
    UINT * m_pattern = nullptr;
};

//================================================imports================================================//
#endif // D3D12UTILS_H
