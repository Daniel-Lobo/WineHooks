#include lib\DirectX\Headers\_D3D11.ahk
#include lib\DirectX\Headers\_DXGI.ahk

global ID3D10Blob
global ID3D10Device, ID3D10Device1, ID3D10Texture2D, ID3D10ShaderResourceView, ID3D10PixelShader
global ID3D11Device, ID3D11DeviceContext, ID3D11ImDeviceContext1, ID3D11ImDeviceContext, ID3D11Buffer, ID3D11Texture2D, pDXGIBackBuffer
global ID3D11ComputeShader, ID3D11PixelShader, ID3D11VShader, ID3D11ShaderResourceView   
global IDXGISwapChain, IDXGISwapChain1, IDXGIFactory, IDXGIFactory2, IDXGIOutput
global ID3D11Device3

D3D11Shader()
{
	c :=
	(
	"
	sampler   s0;
	texture2D t0;
	float4 Vx(uint VertexID: SV_VertexID) : SV_POSITION {
		return 0;
	}
	float4 Px(float2 coords0 : TEXCOORD0) : SV_TARGET	{
		return t0.Sample(s0, coords0);
	}
	"
	)	
	return c	
}

GetDirect3D10()
{
	dll    := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	ID3D10 := struct("LPVOID pDvc; LPVOID pDvc1; LPVOID pSwapChain; LPVOID pSwapChain1; LPVOID pFactory; LPVOID pFactory2;")
	if (r  := dllcall(dll "\GetDirect3D10", ptr, A_scripthwnd, "ptr", ID3D10[], "ptr*", feature_level:=0) )
		return "Failed to create the Direct3D 10 interfaces " r
	logerr("GetDirect3D10 " r " " ErrorLevel)
	
	ID3D10Device    := new ComInterfaceWrapper(D3D10.ID3D10Device, ID3D10.pDvc, True)
	IDXGISwapChain  := new ComInterfaceWrapper(DXGI.IDXGISwapChain, ID3D10.pSwapChain, True)
	IDXGISwapChain1 := new ComInterfaceWrapper(DXGI1_2.IDXGISwapChain1, ID3D10.pSwapChain1, True)
	IDXGIFactory    := new ComInterfaceWrapper(DXGI.IDXGIFactory, ID3D10.pFactory, True)
	IDXGIFactory2	:= new ComInterfaceWrapper(DXGI1_2.IDXGIFactory2, ID3D10.pFactory2, True)
	
	r := dllcall(IDXGISwapChain.GetContainingOutput, ptr, IDXGISwapChain.p, "ptr*", out:=0)
	if r 	
		logerr( "Failed to accuire the IDXGIOutput interface")
	else IDXGIOutput := new ComInterfaceWrapper(DXGI.IDXGIOutput, out, True)
	
	D3D11_HOOKS.CreateTex2D   := ID3D10Device.CreateTexture2D
	D3D11_HOOKS.CreateResView := ID3D10Device.CreateShaderResourceView 
	if ! isobject(t := new D3D10Texture(ID3D10Device.p, (1<<16)|1))
		return "Failed to create the ID3D11Texture2D and ID3D11ShaderResourceView interfaces"
	logerr("Texture " t.t " "  t.v)
	ID3D10Texture2D          := new ComInterfaceWrapper(D3D10.ID3D10Texture2D, t.t, True)
	ID3D10ShaderResourceView := new ComInterfaceWrapper(D3D10.ID3D10ShaderResourceView, t.v, True)
	sys := dllcall(dll "\D3D10CreateSysTexture", ptr, ID3D10Device.p, uint, 1, uint, 1, ptr)
	ID3D10SysTexture2D := new ComInterfaceWrapper(D3D10.ID3D10Texture2D, sys, True)
	logerr("&&&&&& " ID3D10SysTexture2D.map " " ID3D10Texture2D.map)
	
	r := CompileShader10(pShader, ID3D10Device.p, D3D11Shader(), "Px", "ps_4_0")
	if r	
		return "Failed to create the ID3D10PixelShader interface`n" r
	else ID3D10PixelShader := new ComInterfaceWrapper(D3D10.ID3D10PixelShader, pShader, True)
	
	dir:= g_.cfg.injector_dir	
	fileread, fmt, %dir%\DXGIFormats.txt
	DXGI.frmts := {}
	loop, parse, fmt, `n`r
	{
		f := strsplit(A_loopfield, "=")	
		ff := f[1]
		stringreplace, ff, ff , DXGI_FORMAT_, ,
		DXGI.frmts[trim(f[2])] := trim(ff)
	}
	return "Succeded to create the Direct3D10.1 device " ID3D10.pDvc " " ID3D10.pSwapChain
}

GetDirect3D11()
{
	static feature_levels := {"0x9100" : "D3D_FEATURE_LEVEL_9_1"
    , "37376" : "D3D_FEATURE_LEVEL_9_2"
    , "37632" : "D3D_FEATURE_LEVEL_9_3"
    , "40960" : "D3D_FEATURE_LEVEL_10_0"
    , "41216" : "D3D_FEATURE_LEVEL_10_1"
    , "45056" : "D3D_FEATURE_LEVEL_11_0"
    , "45312" : "D3D_FEATURE_LEVEL_11_1"}
	
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	ID3D11 := struct("LPVOID pDev; LPVOID pIContext; LPVOID pContext; LPVOID pSwapChain; LPVOID pSwapChain1; LPVOID pFactory; LPVOID pFactory2;")
	r := dllcall(dll "\GetDirect3D11", ptr, A_scripthwnd, "ptr", ID3D11[], "ptr*", feature_level:=0)
	if ( r )
		return "Failed to create the Direct3D 11 interfaces " r
	
	ID3D11Device            := new ComInterfaceWrapper(D3D11.ID3D11Device, ID3D11.pDev, True)
	ID3D11Device.level      := feature_levels[feature_level . ""] 
	ID3D11ImDeviceContext   := new ComInterfaceWrapper(D3D11.ID3D11DeviceContext, ID3D11.pIContext, True)
	ID3D11DeviceContext     := new ComInterfaceWrapper(D3D11.ID3D11DeviceContext, ID3D11.pContext, True)	
	IDXGISwapChain          := new ComInterfaceWrapper(DXGI.IDXGISwapChain, ID3D11.pSwapChain, True)
	IDXGISwapChain1         := new ComInterfaceWrapper(DXGI1_2.IDXGISwapChain1, ID3D11.pSwapChain1, True)
	IDXGIFactory	        := new ComInterfaceWrapper(DXGI.IDXGIFactory, ID3D11.pFactory, True)
	IDXGIFactory2	        := new ComInterfaceWrapper(DXGI1_2.IDXGIFactory2, ID3D11.pFactory2, True)
	
	/*
	r := dllcall(IDXGISwapChain.GetContainingOutput, ptr, IDXGISwapChain.p, "ptr*", out:=0, uint)
	if r 	
		logerr( "Failed to accuire the IDXGIOutput interface")
	else IDXGIOutput := new ComInterfaceWrapper(DXGI.IDXGIOutput, out, True)
	*/	
	out := dllcall(dll "\D3D11GetDeviceOutput", ptr, ID3D11Device.p, ptr)
	if !out 	
		logerr( "Failed to accuire the IDXGIOutput interface")
	else IDXGIOutput := new ComInterfaceWrapper(DXGI.IDXGIOutput, out, True)
	
	
	GUID_FromString(IID, D3D11_1.IID_ID3D11DeviceContext1)
	r := dllcall(ID3D11ImDeviceContext.QueryInterface, ptr, ID3D11ImDeviceContext.p, ptr, &IID, "ptr*", Ctx1:=0)
	if r 	
		logerr( "Failed to query the ID3D11DeviceContext1 interface" )
	else ID3D11ImDeviceContext1 := new ComInterfaceWrapper(D3D11_1.ID3D11DeviceContext1, Ctx1, True)	
	
	GUID_FromString(IID, D3D11_3.IID_ID3D11Device3)
	r := dllcall(ID3D11Device.QueryInterface, ptr, ID3D11Device.p, ptr, &IID, "ptr*", Dev3:=0)
	if r 	
		logerr("Failed to query the ID3D11Device3 interface")
	ID3D11Device3 := new ComInterfaceWrapper(D3D11_3.ID3D11Device3, Dev3, True)	
		
	D3D11_HOOKS.CreateTex2D   := ID3D11Device.CreateTexture2D
	D3D11_HOOKS.CreateResView := ID3D11Device.CreateShaderResourceView 
	if ! isobject(t := new D3D11Texture(ID3D11Device.p, (1<<16)|1))
		return "Failed to create the ID3D11Texture2D and ID3D11ShaderResourceView interfaces"	
	logerr("Texture " t.t " "  t.v)
	ID3D11Texture2D          := new ComInterfaceWrapper(D3D11.ID3D11Texture2D, t.t, True)
	ID3D11ShaderResourceView := new ComInterfaceWrapper(D3D11.ID3D11ShaderResourceView, t.v, True)
			
	r := CreateVertexBuffer11(pBuffer, 32) 
	if r 
		return "Failed to create the ID3D11Buffer interface"	
	else ID3D11Buffer := new ComInterfaceWrapper(D3D11.ID3D11Buffer, pBuffer, True)		
	
	shaderCode := "[numthreads(32, 24, 1)]`n"
	. "void CSMain( uint3 dispatchThreadID : SV_DispatchThreadID )`n"
	. "{return;}"	
    r := CompileShader11(pShader, ID3D11Device.p, shaderCode, "CSMain", "cs_4_1")
	if r	
		return "Failed to create the ID3D11ComputeShader interface`n" r
	else ID3D11ComputeShader := new ComInterfaceWrapper(D3D11.ID3D11ComputeShader, pShader, True)		
	
	r := CompileShader11(pShader, ID3D11Device.p, D3D11Shader(), "Px", "ps_4_1")
	if r	
		return "Failed to create the ID3D11PixelShader interface`n" r
	else ID3D11PixelShader := new ComInterfaceWrapper(D3D11.ID3D11PixelShader, pShader, True)
		
	r := CompileShader11(pShader, ID3D11Device.p, D3D11Shader(), "Vx", "vs_4_1")
	if r	
		return "Failed to create the ID3D11VertexShader interface`n" r
	else ID3D11VertexShader := new ComInterfaceWrapper(D3D11.ID3D11VertexShader, pShader, True)	
	
	dir:= g_.cfg.injector_dir	
	fileread, fmt, %dir%\DXGIFormats.txt
	DXGI.frmts := {}
	loop, parse, fmt, `n`r
	{
		f := strsplit(A_loopfield, "=")	
		ff := f[1]
		stringreplace, ff, ff , DXGI_FORMAT_, ,
		DXGI.frmts[trim(f[2])] := trim(ff)
	}
		
	return "Succeded to create the Direct3D11 device with feature level " ID3D11Device.level 
}	

Class D3D11Texture {
__new(d, res)
{
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"	
	this.v := dllcall(dll "\D3D11CreateTexture2D", ptr, d, uint, (res>>16) & 0xffff, uint, res & 0xffff, uint, 0, ptr) 
	this.t := dllcall(dll "\D3D11GetTexture2D", ptr, this.v, ptr) 
}
__delete()
{
	(this.t) ? Logerr("Releasing Texture " dllcall(ID3D11Texture2D.Release, ptr, this.t))
	(this.v) ? Logerr("Releasing ResView " dllcall(ID3D11ShaderResourceView.Release, ptr, this.v))
}
}

Class D3D10Texture {
__new(d, res)
{
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"		
	this.v := dllcall(dll "\D3D10CreateTexture2D", ptr, d, uint, (res>>16) & 0xffff, uint, res & 0xffff, uint, 0, ptr) 
	this.t := dllcall(dll "\D3D10GetTexture2D", ptr, this.v, ptr) 
}
__delete()
{
	(this.t) ? Logerr("Releasing Texture " dllcall(ID3D10Texture2D.Release, ptr, this.t))
	(this.v) ? Logerr("Releasing ResView " dllcall(ID3D10ShaderResourceView.Release, ptr, this.v))
}
}

CreateVertexBuffer11(byref pBuffer, size, pData = 0)
{
	D3D11_USAGE_DEFAULT            := 0 
	D3D11_BUFFER_DESC.ByteWidth    := size
	D3D11_BUFFER_DESC.Usage        := D3D11_USAGE_DEFAULT	
	D3D11_BUFFER_DESC.BindFlags    := D3D11_BIND_VERTEX_BUFFER   
	D3D11_SUBRESOURCE_DATA.pSysMem := pData		
			
	return dllcall(ID3D11Device.CreateBuffer, uint, ID3D11Device.p, ptr, D3D11_BUFFER_DESC[]
	, ptr, (pData > 0) & True ? D3D11_SUBRESOURCE_DATA[] : 0, "ptr*", pBuffer:=0, uint) 
}	

CompileShaderFromFile11(byref pShader, pDevice, file, entrypoint = "main", pTarget  = "cs_4_1")
{
	hdll               := dllcall("GetModuleHandle", "str", "d3dx11_43.dll")
	hdll ?: hdll       := dllcall("LoadLibraryW", "str", "d3dx11_43.dll")
	D3DCompileFromFile := dllcall("GetProcAddress", uint, hdll, astr, "D3DX11CompileFromFileW") 
	
	r := dllcall(D3DCompileFromFile, str, file, uint, 0, uint, 0, wstr, entrypoint, wstr, pTarget 
	                               , uint, 0, uint, 0, "ptr*", pShader:=0, "ptr*", pError:=0, uint)	
	
	use := r ? pError : pShader		
	_ptr := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*3, "ptr"), ptr, use)
	size := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*4, "ptr"), ptr, use)
	
	if r 
	{
		rr := strget(_ptr+0, size, "CP0")
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), ptr, use)
		return rr		
	}			
				
	else
	{
		r := dllcall(ID3D11Device.CreateComputeShader, ptr, pDevice, uint, _ptr, ptr, size, uint, 0, "ptr*", pShader)
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), ptr, use)
		return r 
	}	
}

CompileShader10(byref pShader, pDevice, ShaderCode, entrypoint, pTarget)
{
	hdll         := dllcall("GetModuleHandle", "str", "d3dx11_43.dll", "ptr")
	hdll ?: hdll := dllcall("LoadLibraryW", "str", "d3dx11_43.dll", "ptr")
	D3DCompile   := dllcall("GetProcAddress", ptr, hdll, astr, "D3DX11CompileFromMemory", "ptr") 
	
	r := dllcall(D3DCompile, astr, ShaderCode, ptr, strlen(ShaderCode), ptr, 0, ptr, 0, ptr, 0
	                       , astr, entrypoint, astr, pTarget, uint, 0, uint, 0, ptr, 0
						   , "ptr*", pShader:=0, "ptr*", pError:=0, uint, 0, uint)
	logerr("D3D 10 Compile shader " r)	
	
	use := r ? pError : pShader		
	_ptr := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*3, "ptr"), ptr, use, "ptr")
	size := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*4, "ptr"), ptr, use, "ptr")
	
	if r 
	{
		rr := strget(_ptr+0, size, "CP0")
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), ptr, use)
		return rr		
	}	
		
	else
	{
		if instr(pTarget, "ps")
			r := dllcall(ID3D10Device.CreatePixelShader, ptr, pDevice, ptr, _ptr, ptr, size, "ptr*", pShader)
		else if instr(pTarget, "vs")
			r := dllcall(ID3D10Device.CreateVertexShader, ptr, pDevice, ptr, _ptr, ptr, size, "ptr*", pShader)
		logerr("D3D 10 Create shader " r " " errorlevel)
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), ptr, use)				
		return r 
	}	
}

CompileShader11(byref pShader, pDevice, ShaderCode, entrypoint, pTarget)
{
	hdll         := dllcall("GetModuleHandle", "str", "d3dx11_43.dll", "ptr")
	hdll ?: hdll := dllcall("LoadLibraryW", "str", "d3dx11_43.dll", "ptr")
	D3DCompile   := dllcall("GetProcAddress", ptr, hdll, astr, "D3DX11CompileFromMemory", "ptr") 
	
	r := dllcall(D3DCompile, astr, ShaderCode, ptr, strlen(ShaderCode), ptr, 0, ptr, 0, ptr, 0
	                       , astr, entrypoint, astr, pTarget, uint, 0, uint, 0, ptr, 0
						   , "ptr*", pShader:=0, "ptr*", pError:=0, uint, 0, uint)	
	
	use := r ? pError : pShader		
	_ptr := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*3, "ptr"), ptr, use, "ptr")
	size := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*4, "ptr"), ptr, use, "ptr")
	
	if r 
	{
		rr := strget(_ptr+0, size, "CP0")
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), ptr, use)
		return rr		
	}	
		
	else
	{
		if instr(pTarget, "cs")
			r := dllcall(ID3D11Device.CreateComputeShader, ptr, pDevice, ptr, _ptr, ptr, size, ptr, 0, "ptr*", pShader, ptr)
		else if instr(pTarget, "ps")
			r := dllcall(ID3D11Device.CreatePixelShader, ptr, pDevice, ptr, _ptr, ptr, size, ptr, 0, "ptr*", pShader, ptr)
		else if instr(pTarget, "vs")
			r := dllcall(ID3D11Device.CreateVertexShader, ptr, pDevice, ptr, _ptr, ptr, size, ptr, 0, "ptr*", pShader, ptr)
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), ptr, use)	
		return r 
	}	
}	

_D3D11Compile(byref blob, hlsl, prfl, entry="main")
{
	if (r := D3D11Compile(blob, hlsl, prfl, entry="main"))
	return r
	blob  := {"p"  : dllcall(numget(numget(blob+0, "ptr")+A_PtrSize*3, "ptr"), ptr, blob, "ptr")
	         ,"sz" : dllcall(numget(numget(blob+0, "ptr")+A_PtrSize*4, "ptr"), ptr, blob, "ptr")}	
}

D3D11Compile(byref pShader, hlsl, prfl, entry="main")
{
	hdll         := dllcall("GetModuleHandle", "str", "d3dx11_43.dll", "ptr")
	hdll ?: hdll := dllcall("LoadLibraryW", "str", "d3dx11_43.dll", "ptr")
	D3DCompile   := dllcall("GetProcAddress", ptr, hdll, astr, "D3DX11CompileFromMemory", "ptr") 
	r            := dllcall(D3DCompile, astr, hlsl, ptr, strlen(hlsl), ptr, 0, ptr, 0, ptr, 0, astr, "main"
		                   , astr, prfl, uint, 0, uint, 0, ptr, 0, "ptr*", pShader:=0, "ptr*", pError:=0
						   , uint, 0, uint)	
		
	use  := r ? pError : pShader		
	_ptr := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*3, "ptr"), ptr, use, "ptr")
	size := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*4, "ptr"), ptr, use, "ptr")
		
	if r 
	{
		rr := strget(_ptr+0, size, "CP0")
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), ptr, use)
		return rr		
	} 		
}

D3D11Disasemble(BC, sz, byref code)
{
	hdll         := dllcall("LoadLibrary", str, "D3dcompiler_47.dll", ptr) 
    Disassemble  := dllcall("GetProcAddress", ptr, hdll, astr, "D3DDisassemble", "ptr") 
    
	dllcall(Disassemble, ptr, BC, ptr, sz, uint, 0, uint, 0, "ptr*", blob:=0)
	
	if (!blob)
	return true
	
	_ptr := dllcall(numget(numget(blob+0, "ptr")+A_PtrSize*3, "ptr"), ptr, blob, "ptr")
	size := dllcall(numget(numget(blob+0, "ptr")+A_PtrSize*4, "ptr"), ptr, blob, "ptr")
	code := strget(_ptr+0, size, "CP0")
	dllcall(numget(numget(blob+0, "ptr")+A_PtrSize*2, "ptr"), ptr, blob)	
}