#include lib\DirectX\Headers\_D3D9.h.ahk
global IDirect3D9:=0, IDirect3DDevice9:=0, IDirect3DPixelShader9:=0, IDirect3DVertexBuffer9:=0
global IDirect3DTexture9:=0, IDirect3DMTexture9:=0, IDirect3DSurface9:=0, IDirect3DMSurface9:=0 
global IDirect3DSwapChain9:=0, ISrfc9:=0, IZbuff9:=0, IDirect3DCubeTexture9:=0, IDirect3DCubeFace9:=0
globaL IDirect3DStateBlock9:=0

D3D9SetPixelFormat(s)
{
	if instr(s, "DX")
	return FourCC(s)
	f := {"A8RGB" : D3DFMT_A8R8G8B8, "X8RGB" : D3DFMT_X8R8G8B8, "RG6B"  : D3DFMT_R5G6B5
	     ,"X1RGB" : D3DFMT_X1R5G5B5, "A1RGB" : D3DFMT_A1R5G5B5, "A4RGB" : D3DFMT_A4R4G4B4}	       
	return f[s]
}

D3D9GetPixelFormat(fmt)
{
	f := {D3DFMT_A8R8G8B8 "": "A8RGB", D3DFMT_X8R8G8B8 "": "X8RGB", D3DFMT_A4R4G4B4 "": "A4RGB"
	     ,D3DFMT_X1R5G5B5 "": "X1RGB", D3DFMT_A1R5G5B5 "": "A1RGB", D3DFMT_R5G6B5   "": "RG6B"
		 ,D3DFMT_D24X8 "": "D24X8", D3DFMT_D24S8 "": "D24S8", D3DFMT_D16 "": "D16X0"}
	loop, 5
	f[FourCC("DXT" A_index) ""] := "DXT" A_index			 
	return f[fmt . ""]
}

GetDirect3D9Ex(h_win){
	dll                    := A_PtrSize == 8 ? "peixoto64.dll" : "peixoto.dll"
	r                      := dllcall(dll "\CreateD3D9Interfaces", ptr, A_ScriptHwnd, ptr)
	err                    := NumGet(r+0, Type = "ptr")
	err_str                := StrGet(err, ,"CP0") 
	IDirect3D9             := new ComInterfaceWrapper(D3D9.IDirect3D9,             NumGet(r+A_PtrSize,    Type = "ptr"), True)
	IDirect3D9Ex           := new ComInterfaceWrapper(D3D9.IDirect3D9Ex,           NumGet(r+A_PtrSize*2,  Type = "ptr"), True)  
	IDirect3DDevice9       := new ComInterfaceWrapper(D3D9.IDirect3DDevice9,       NumGet(r+A_PtrSize*3,  Type = "ptr"), True)   
	IDirect3DDevice9Ex     := new ComInterfaceWrapper(D3D9.IDirect3DDevice9Ex,     NumGet(r+A_PtrSize*4,  Type = "ptr"), True)     
	IDirect3DSwapChain9    := new ComInterfaceWrapper(D3D9.IDirect3DSwapChain9,    NumGet(r+A_PtrSize*5,  Type = "ptr"), True)
	IDirect3DSurface9      := new ComInterfaceWrapper(D3D9.IDirect3DSurface9,      NumGet(r+A_PtrSize*6,  Type = "ptr"), True)
	IDirect3DTexture9      := new ComInterfaceWrapper(D3D9.IDirect3DTexture9,      NumGet(r+A_PtrSize*7,  Type = "ptr"), True)
	IDirect3DCubeFace9     := new ComInterfaceWrapper(D3D9.IDirect3DSurface9,      NumGet(r+A_PtrSize*8,  Type = "ptr"), True)
	IDirect3DCubeTexture9  := new ComInterfaceWrapper(D3D9.IDirect3DCubeTexture9,  NumGet(r+A_PtrSize*9,  Type = "ptr"), True)
	IDirect3DVertexBuffer9 := new ComInterfaceWrapper(D3D9.IDirect3DVertexBuffer9, NumGet(r+A_PtrSize*10, Type = "ptr"), True)
	IDirect3DPixelShader9  := new ComInterfaceWrapper(D3D9.IDirect3DPixelShader9 , NumGet(r+A_PtrSize*11, Type = "ptr"), True)
	IDirect3DStateBlock9   := new ComInterfaceWrapper(D3D9.IDirect3DStateBlock9,   NumGet(r+A_PtrSize*12, Type = "ptr"), True)
	for k, n in [IDirect3D9, IDirect3D9Ex, IDirect3DDevice9, IDirect3DDevice9Ex
	            , IDirect3DSwapChain9, IDirect3DSurface9, IDirect3DTexture9
	            , IDirect3DCubeFace9, IDirect3DCubeTexture9, IDirect3DVertexBuffer9
	            , IDirect3DPixelShader9, IDirect3DStateBlock9]
	{
		if not IsObject(n) {
			msgbox, % "Failed to create " k " interface: " err_str
		}
	}
	;msgbox % err_str " " IDirect3D9.p
	return err_str " " IDirect3D9.p
	;exitapp 
}


GetDirect3D9(h_win = "", windowed = True, refresh = 60, ww = 640, hh = 480
			,pixelformat = "A8RGB", dll = "d3dx9_43.dll")
{
	return GetDirect3D9Ex(h_win)

	VarSetCapacity(SysDir, 261)
	DllCall("GetSystemDirectoryW", Str, SysDir, UInt, 261)
	
	hModule           := dllcall("LoadLibraryW", str, SysDir "\D3D9.dll")
	hModule           := dllcall("LoadLibraryW", str, "d3d9.dll")
	Direct3DCreate9   := dllcall("GetProcAddress", uint, hModule, astr, "Direct3DCreate9")
	Direct3DCreate9Ex := dllcall("GetProcAddress", uint, hModule, astr, "Direct3DCreate9Ex")
	
	if ( (! hModule) or (! Direct3DCreate9) or (! Direct3DCreate9Ex))
		return "Failed to get the entry point of the Direct3DCreate9 procedure or get the handle to d3D9.dll " A_lasterror
	
	p_D3D9 := dllcall(g_.pD3D9Create, uint, D3D_SDK_VERSION)
	if not p_D3D9
		return "Failed to create the IDirect3D9 interface " r " - " D3D9.result[r . ""]		
	IDirect3D9 := new ComInterfaceWrapper(D3D9.IDirect3D9, p_D3D9, True)
	
	/*
	r := dllcall(g_.pD3D9CreateEx, uint, D3D_SDK_VERSION, "ptr*", p_D3D9Ex:=0, uint)
	logerr("IDirect3D9Ex: " errorlevel " " Direct3DCreate9Ex " " p_D3D9Ex " " r  ":" D3D9.err[r . ""])		
	if r
		return "Failed to create the IDirect3D9Ex Interface " r " - " D3D9.err[r . ""]	
	IDirect3D9Ex := new ComInterfaceWrapper(D3D9.IDirect3D9Ex, p_D3D9Ex, True)

	GUID_FromString(idd_d3d9, D3D9.IID_IDirect3D9)
	r := dllcall(IDirect3D9Ex.QueryInterface, uint, IDirect3D9Ex.p, uint, &idd_d3d9, "ptr*", p_D3D9 := 0, uint)
	logerr("IDirect3D9: " p_D3D9 " " r  ":" D3D9.err[r . ""] "`n")	
	if r
		return "Failed to create the IDirect3D9 Interface " r " - " D3D9.err[r . ""]	
	else IDirect3D9 := new ComInterfaceWrapper(D3D9.IDirect3D9, p_D3D9, True)
	*/
					
	if ! h_win
		h_win := A_scripthwnd ;ui_GetHidenWindowHandle()
	
	VarSetCapacity(p_d3D9Dev, 4)
	ZeroMem(D3DPRESENT_PARAMETERS)
    D3DPRESENT_PARAMETERS.Windowed         := windowed  
	D3DPRESENT_PARAMETERS.RefreshRateInHz  := refresh
	D3DPRESENT_PARAMETERS.BackBufferWidth  := ww
	D3DPRESENT_PARAMETERS.BackBufferHeight := hh
	D3DPRESENT_PARAMETERS.SwapEffect       := 1
    D3DPRESENT_PARAMETERS.hDeviceWindow    := h_win
	D3DPRESENT_PARAMETERS.Flags            := (D3DPRESENT_LOCKABLE_BACKBUFFER := 0x00000001)
	D3DPRESENT_PARAMETERS.BackBufferFormat := D3D9SetPixelFormat(pixelformat)
	D3DPRESENT_PARAMETERS.EnableAutoDepthStencil := 1
	D3DPRESENT_PARAMETERS.AutoDepthStencilFormat := 75
	D3D_DISPLAYMODEX                  := struct("UINT Size; UINT Width; UINT Height; UINT RefreshRate; UINT Format; UINT ScanLineOrdering;")
	D3D_DISPLAYMODEX.size             := D3D_DISPLAYMODEX.size()
	D3D_DISPLAYMODEX.Width            := 640
	D3D_DISPLAYMODEX.Width            := 480
	D3D_DISPLAYMODEX.RefreshRate      := 60
	D3D_DISPLAYMODEX.Format           := 21
	D3D_DISPLAYMODEX.ScanLineOrdering := 1	
	logerr(D3D_DISPLAYMODEX.size " " IDirect3D9Ex.CreateDeviceEx)
	r := dllcall(IDirect3D9.CreateDevice, ptr, IDirect3D9.p
									    , uint, 0 ;D3DADAPTER_DEFAULT
									    , uint, 1 ;D3DDEVTYPE_HAL
									    , uint, h_win
									    , uint, D3DCREATE_HARDWARE_VERTEXPROCESSING
									    , ptr, D3DPRESENT_PARAMETERS[]
										;, ptr, D3D_DISPLAYMODEX[]
									    , "ptr*", pD3D9Dev:=0, uint)  
	if (r > 0)
		return "Failed to create the IDirect3DDevice9 interface " r " - " D3D9.result[r . ""]			
	IDirect3DDevice9 := new ComInterfaceWrapper(D3D9.IDirect3DDevice9, pD3D9Dev, True)
	
	if (r := dllcall(IDirect3DDevice9.CreateStateBlock, ptr, IDirect3dDevice9.p, uint, 1, "ptr*", sb:=0))
	return "Failed to create the IDirect3DStateBlock9 interface " r " - " D3D9.result[r . ""]	
	IDirect3DStateBlock9 := new ComInterfaceWrapper(D3D9.IDirect3DStateBlock9, SB, True)
	
	if (r := dllcall(IDirect3DDevice9.GetSwapChain, ptr, pD3D9Dev, uint, 0, "ptr*", pp:=0))
	return 	"Failed to accquire the defalt swapchain " r D3D9.err[r . ""] 
	IDirect3DSwapChain9 := new ComInterfaceWrapper(D3D9.IDirect3DSwapChain9, pp, True)	
	
	if (r := dllcall(IDirect3DDevice9.GetBackBuffer, ptr, pD3D9Dev, uint, 0, uint, 0, uint, 0, "ptr*", bb:=0))
		return 	"Failed to accquire the defalt framebuffer " r D3D9.err[r . ""] 
	IDirect3DSurface9 := new ComInterfaceWrapper(D3D9.IDirect3DSurface9, bb, True)
			
	if (r := dllcall(IDirect3DDevice9.CreateCubeTexture, ptr, IDirect3DDevice9.p, uint, 16, uint, 1, uint, 1, uint
	                                                   , D3D9SetPixelFormat("A8RGB"), uint, 0, "ptr*", cb:=0, uint, 0))
		return "Failed to create cube texture " r D3D9.err[r . ""] 											   
	IDirect3DCubeTexture9 := new ComInterfaceWrapper(D3D9.IDirect3DCubeTexture9, cb, True)
	
	if (r := dllcall(IDirect3DCubeTexture9.GetCubeMapSurface, ptr, cb, uint, 0, uint, 0, "ptr*", cbf:=0))
		return "Failed to get cube texture face " r D3D9.err[r . ""] 	
	IDirect3DCubeFace9 := new ComInterfaceWrapper(D3D9.IDirect3DSurface9, cbf, True)
	
	D3DX9.__new(dll)
	shader := "float4 PixelShaderFunction(float4 color: COLOR0) : COLOR0`n"  
	       . "{`nreturn float4(0,0,0,0);`n};"
	
	r := D3DX9.CompileShader(IDirect3DDevice9.p, shader, "PixelShaderFunction", pShader:=0)
	if (r != 0)
		return "Failed to create the IDirect3DPixelShader9 interface " r " - " D3D9.result[r . ""]	
	IDirect3DPixelShader9 := new ComInterfaceWrapper(D3D9.IDirect3DPixelShader9, pShader, True)
	
	r := dllcall(IDirect3DDevice9.CreateVertexBuffer, ptr, IDirect3DDevice9.p, uint, 20, uint, 0
												    , uint, D3DFVF_XYZRHW | D3DFVF_DIFFUSE
										            , uint, 0, "ptr*", pVbuffer:=0, uint, 0)
	if (r != 0)
		return "Failed to create the IDirect3DVertexBuffer9 interface " r " - " D3D9.result[r . ""]
	IDirect3DVertexBuffer9 :=  new ComInterfaceWrapper(D3D9.IDirect3DVertexBuffer9, pVbuffer, True)
	
	r := dllcall(IDirect3DDevice9.CreateTexture, ptr, IDirect3Ddevice9.p, uint, 256, uint, 256, uint, 1
											   , uint, 0x00000200 ;D3DUSAGE_DYNAMIC 
					                           , uint, D3D9SetPixelFormat(pixelformat), uint, 0  
					                           , "ptr*", p_text9:=0, uint, 0, uint)				
	if (r != 0)
		return "Failed to create the IDirect3DTexture9 interface " r " - " D3D9.result[r . ""]
	IDirect3DTexture9 := new ComInterfaceWrapper(D3D9.IDirect3DTexture9, p_text9, True)	
	return "Succeeded to create the Direct3D9 interfaces"	
}

D3D9LoadTexture(pDevice, file)
{
	static pLoadData2Surface
	pLoadData2Surface ?: pLoadData2Surface := dllcall("GetProcAddress", uint, dllcall("GetModuleHandle", str, "peixoto.dll", uint)
													 , astr, "LoadData2Surface", uint)

	if not (pixelformat := OpenDDS(file, hFile))
	{
		return print("Unknown pixelformat")
	}
	if (r := dllcall(IDirect3DDevice9.CreateTexture, uint, pDevice, uint, DDS_HEADER.dwWidth, uint, DDS_HEADER.dwHeight, uint, 1
	                                               , uint, 0, uint, D3D9SetPixelFormat(pixelformat), uint, 0, "uint*", pTexture, uint, 0)!= 0)
		return printl("Failed to create video memory texture " r " " D3D9.err[r . ""])

	if (r := dllcall(IDirect3DTexture9.GetSurfaceLevel, uint, pTexture, uint, 0, "uint*", pSurface) != 0)
		return printl("Failed to create video memory surface " r " - " D3D9.result[r . ""])	
			
	if (r := dllcall(IDirect3DDevice9.CreateTexture, uint,pDevice, uint, DDS_HEADER.dwWidth, uint,  DDS_HEADER.dwHeight, uint, 1
	                                               , uint, 0, uint, D3D9SetPixelFormat(pixelformat), uint, 2, "uint*", pSTexture, uint, 0)!= 0)
		return printl("Failed to create system memory texture " r " " D3D9.err[r . ""])
	if (r := dllcall(IDirect3DTexture9.GetSurfaceLevel, uint, pSTexture, uint, 0, "uint*", pSSurface)!= 0)
		return printl("Failed to create system memory surface " r " - " D3D9.result[r . ""])	
	
	if (r := dllcall(IDirect3DSurface9.LockRect, uint, pSSurface, uint, D3DLOCKED_RECT[], uint, 0, uint, 0)!= 0)
		return printl("Failed to lock system memory texture " r " " D3D9.err[r . ""])
	else 
	{
		bytesperpixel := instr(pixelformat, "8") ? 4 : 2
		dllcall(pLoadData2Surface, uint, D3DLOCKED_RECT.pBits, uint, hFile, uint, D3DLOCKED_RECT.pitch, uint, DDS_HEADER.dwWidth
	                             , uint, DDS_HEADER.dwHeight, uint, bytesperpixel)
		dllcall(IDirect3DSurface9.UnLockRect, uint, pSSurface)
	}
	if (r := dllcall(IDirect3DDevice9.UpdateSurface, uint, pDevice, uint, pSSurface, uint, 0, uint, pSurface, uint, 0)!= 0)
		return printl("Failed to copy data from system to video texture " r " " D3D9.err[r . ""])
	dllcall(IDirect3DTexture9.release, uint, pSTexture)
	dllcall(IDirect3DSurface9.release, uint, pSSurface)
	return pTexture		
}

D3D9LoadManagedTexture(pDevice, file)
{
	static pLoadData2Surface:=0
	pTexture                :=0
	pSurface                :=0
	pLoadData2Surface ?: pLoadData2Surface := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "LoadData2Surface", uint)

	if not (pixelformat := OpenDDS(file, hFile))
	{
		return print("Unknown pixelformat")
	}
	if (r := dllcall(IDirect3DDevice9.CreateTexture, uint, pDevice, uint, DDS_HEADER.dwWidth, uint, DDS_HEADER.dwHeight, uint, 1
	                                               , uint, 0, uint, D3D9SetPixelFormat(pixelformat), uint, 1, "uint*", pTexture, uint, 0)!= 0)
		return printl("Failed to create managed texture " r " " D3D9.err[r . ""])

	if (r := dllcall(IDirect3DTexture9.LockRect, uint, pTexture, uint, 0, uint, D3DLOCKED_RECT[], uint, 0, uint, 0)!= 0)
		return printl("Failed to lock system memory texture " r " " D3D8.err[r . ""])	
	else 
	{
		bytesperpixel := instr(pixelformat, "8") ? 4 : 2
		dllcall(pLoadData2Surface, uint, D3DLOCKED_RECT.pBits, uint, hFile, uint, D3DLOCKED_RECT.pitch, uint, DDS_HEADER.dwWidth
	                             , uint, DDS_HEADER.dwHeight, uint, bytesperpixel)		
		dllcall(IDirect3DTexture9.UnLockRect, uint, pTexture, uint, 0)
	}	
	return pTexture		
}

class Proxie9 {

__new(w, h, f, zf="", m=0)
{
	u := m ? 0:1
	r := dllcall(IDirect3DDevice9.CreateTexture, uint, g_.pDevice9, uint, w, uint, h, uint, 1
	                                           , uint, u, uint, f, uint, m, "uint*", t:=0, uint, 0, uint)
	Logerr("Proxie: color buffer:         " r " " D3D9.err[r . ""] " " w "x" h " " D3D9GetPixelFormat(f))
	if (r)
	return r	
	r := dllcall(IDirect3DTexture9.GetSurfaceLevel, uint, t, uint, 0, "uint*", s:=0)
	Logerr("Proxie: color buffer level 0: " r D3D9.err[r . ""])	
	if (r)
	return r
	this.t  := t
	this.s  := s
	this.zs := 0
	if zf
	{
		r := dllcall(IDirect3DDevice9.CreateTexture, uint, g_.pDevice9, uint, w, uint, h, uint, 1
	                                               , uint, 2, uint, zf, uint, 0, "uint*", t:=0, uint, 0)
		Logerr("Proxie: z buffer:             " r " " D3D9.err[r . ""])
		if (r)
		return r	
		r := dllcall(IDirect3DTexture9.GetSurfaceLevel, uint, t, uint, 0, "uint*", s:=0)
		Logerr("Proxie: z buffer level 0:     " r D3D9.err[r . ""])	
		if (r)
		return r
		this.zt := t
		this.zs := s		
	}		
}
Set()
{
	logerr("set target " dllcall(IDirect3DDevice9.SetRenderTarget, uint, g_.pDevice9, uint, 0, uint, this.s) " " this.s)
	dllcall(IDirect3DDevice9.SetDepthStencilSurface, uint, g_.pDevice9, uint, this.zs)	
}	
__delete()
{
	(this.t)?logerr("Release " dllcall(numget(numget(this.t+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.t))
	(this.s)?logerr("Release " dllcall(numget(numget(this.s+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.s))
	(this.zt)?logerr("Release " dllcall(numget(numget(this.zt+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.zt))
	(this.zs)?logerr("Release " dllcall(numget(numget(this.zs+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.zs))	
}
}

class SProxie9 {

__new(w, h, f, aa, q, zf="", d=0, m=0)
{	
	r := dllcall(IDirect3DDevice9.CreateRenderTarget, uint, g_.pDevice9, uint, w, uint, h, uint, f, uint, aa
	                                                , uint, q, uint, 0, "uint*", s:=0, uint, 0)
	this.s  := s												
	this.zs := 0	
	if zf
	{
		r := dllcall(IDirect3DDevice9.CreateDepthStencilSurface, uint, g_.pDevice9, uint, w, uint, h, uint, zf
	                                               , uint, aa, uint, q, uint, d, "uint*", s:=0, uint, 0)
		Logerr("Proxie: z buffer:             " r " " w " x " h " " D3D9GetPixelFormat(zf) " " D3D9.err[r . ""])
		if (r)
		return r					
		this.zs := s		
	}		
}
Set()
{
	logerr("set target " dllcall(IDirect3DDevice9.SetRenderTarget, uint, g_.pDevice9, uint, 0, uint, this.s) " " this.s)
	logerr("set Z " dllcall(IDirect3DDevice9.SetDepthStencilSurface, uint, g_.pDevice9, uint, this.zs))	 
}
__delete()
{
	(this.zs)?logerr("Release " dllcall(numget(numget(this.zs+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.zs))
	(this.s)?logerr("Release " dllcall(numget(numget(this.s+0, "ptr")+A_PtrSize*2, "ptr"), uint, this.s))
}
}

ReleaseDirect3D9()
{
	return 
	IDirect3DStateBlock9.__release()
	IDirect3DSwapChain9.__release()
	IDirect3DPixelShader9.__release()
	IDirect3DVertexBuffer9.__release()
	IDirect3DSurface9.__release()
	IDirect3DTexture9.__release()	
	IDirect3DCubeTexture9.__release()
	IDirect3DCubeFace9.__release()
	logerr("D3D9Device Release " IDirect3DDevice9.__release())
	logerr("D3D9 Release " IDirect3D9.__release())
	;logerr("D3D9 Release " IDirect3D9Ex.__release())
}
