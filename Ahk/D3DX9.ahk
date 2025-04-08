#include lib\DirectX\Headers\D3DX9.ahk

global ID3DXBuffer:=0

class D3DX9 {

__new(dll = "d3dx9_43.dll")
{
	f := IsFunc("D3D9IsLinux") ? Func("D3D9IsLinux") : Func("D3D8IsLinux")
	if (f.call()){
		arch := A_PtrSize = 8 ? "x64" : "x86"
		dll  := g_.cfg.injector_dir . "\D3DCompilers\" . arch . "\d3dx9_43.dll" 
	}

	logerr(dll . " loaded")	
	this.h_dll := ""
	this.pD3DXLoadSurfaceFromFile := ""
	this.pD3DXCreateFont := ""
	
	h_dll := dllcall("GetModuleHandle", str, dll)
	h_dll ?: h_dll := dllcall("LoadLibraryW", str, dll)
	if not h_dll
		return ""		
	
	this.h_dll                     := h_dll
	this.D3DXDisassembleShader     := dllcall("GetProcAddress", uint, this.h_dll, astr, "D3DXDisassembleShader")
	this.D3DXAssembleShader        := dllcall("GetProcAddress", uint, this.h_dll, astr, "D3DXAssembleShader")
	this.pD3DXLoadSurfaceFromFile  := dllcall("GetProcAddress", uint, this.h_dll, astr, "D3DXLoadSurfaceFromFileW")
	this.pD3DXCreateFont           := dllcall("GetProcAddress", uint, this.h_dll, astr, "D3DXCreateFontW")
	this.D3DXCompileShader         := dllcall("GetProcAddress", uint, this.h_dll, astr, "D3DXCompileShader")
	this.D3DXCompileShaderFromFile := dllcall("GetProcAddress", uint, this.h_dll, astr, "D3DXCompileShaderFromFileA") 
	this.D3DXGetPixelShaderProfile := dllcall("GetProcAddress", uint, this.h_dll, astr, "D3DXGetPixelShaderProfile")
	this.D3DXCreateBuffer          := dllcall("GetProcAddress", uint, this.h_dll, astr, "D3DXCreateBuffer")
	this.D3DXCreateTextureFromFile := dllcall("GetProcAddress", uint, this.h_dll, astr, "D3DXCreateTextureFromFileW")
	this.rect                      := Struct("LONG left; LONG top; LONG right; LONG bottom;")
	this.POINT                     := Struct("LONG x; LONG y;")
}	

CreateTextureFromFile(pDevice, file, byref pTexture){
	return dllcall(this.D3DXCreateTextureFromFile
	,uint, pdevice, str, file, "uint*", pTexture)
}

LoadSurfaceFromFile(pSurface, file, filter = 1)
{	
	RETURN dllcall(this.pD3DXLoadSurfaceFromFile
		, uint, pSurface
		, uint, pDestPalette
		, uint, 0
		, str, file 
		, uint, 0
		, uint, filter
		, uint, ColorKey
		, uint, pSrcInfo, uint)
}

CreateFontW(pDevice, font = "Verdana", italic = False)
{
	pID3DXFont := 0
	r := dllcall(this.pD3DXCreateFont
		, uint, pDevice
		, int, 0
		, int, 0
		, int, 600
		, uint, 0
		, uint, italic
		, uint, 0
		, uint, 0
		, uint, 0
		, uint, 0
		, str, font
		, "uint*", pID3DXFont, uint)
		
	if r 
		return	r
		
	fnt := new ComInterfaceWrapper(d3DX9core.ID3DXFont, pID3DXFont, True)	
	return fnt
}

DrawText(byref fnt, txt, clr = 0xFFFFFFFF, rct = "")
{
	if not isobject(fnt)
		return
	if not rct
		rct := "0|0|640|480"
	rct_ := strsplit(rct, "|")
	this.rect.left := rct_[1]
	this.rect.top := rct_[2]
	this.rect.right := rct_[3]	
	this.rect.bottom := rct_[4]	
	
	r := dllcall(fnt.DrawTextW, uint, fnt.p
		, uint, 0
		, str,  txt
		, int, -1
		, uint, this.RECT[]
		, uint, 256
		, uint, clr
		, uint)
		
	return r 
}

HLSLtoDXBC(hlsl, main, byref blob)
{
	r := dllcall(this.D3DXCompileShader, astr, hlsl, uint, strlen(hlsl), uint, 0, uint, 0
									   , astr, main, astr, "ps_3_0", uint, 0, "ptr*", blob
									   , "uint*", err:=0, uint, 0, uint)
	if r 
	{
		_ptr := dllcall(numget(numget(err+0, "ptr")+A_PtrSize*3, "ptr"), uint, err)
		size := dllcall(numget(numget(err+0, "ptr")+A_PtrSize*4, "ptr"), uint, err)
		rr := strget(_ptr+0, size, "CP0")
		dllcall(numget(numget(err+0, "ptr")+A_PtrSize*2, "ptr"), uint, err)
		return "compilation failed " rr		
	}	
}

Asm2DXBC(asm, byref blob)
{
	r := dllcall(this.D3DXAssembleShader, astr, asm, uint, strlen(asm), uint, 0
	                                    , uint, 0, uint, 0, "ptr*", blob, "uint*"
										, err:=0, uint, 0, uint)
	if r 
	{
		_ptr := dllcall(numget(numget(err+0, "ptr")+A_PtrSize*3, "ptr"), uint, err)
		size := dllcall(numget(numget(err+0, "ptr")+A_PtrSize*4, "ptr"), uint, err)
		rr := strget(_ptr+0, size, "CP0")
		dllcall(numget(numget(err+0, "ptr")+A_PtrSize*2, "ptr"), uint, err)
		return "compilation failed " rr		
	}	
}

CompileShaderFromFile(pDevice, file, entrypoint, byref pShader)
{	
	pShader:=0, pError:=0 
	r := dllcall(this.D3DXCompileShaderFromFile
	, astr, file
	, uint, 0
	, uint, 0
	, astr, entrypoint
	, astr, "ps_3_0"
	, uint, 0
	, "uint*", pShaderBytecode
	, "uint*", pError
	, uint, 0, uint)	

	use := r ? pError : pShaderBytecode		
	_ptr := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*3, "ptr"), uint, use)
	size := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*4, "ptr"), uint, use)
	
	if r 
	{
		rr := strget(_ptr+0, size, "CP0")
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), uint, use)
		return "compilation failed " rr		
	}	
		
	else
	{
		r := dllcall(IDirect3DDevice9.CreatePixelShader, uint, pDevice, uint, _ptr, "uint*", pShader)
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), uint, use)
		return r 
	}	
}	

CompileShader(pDevice, byref Shader, entrypoint, byref pShader)
{	
	pShader:=0, pError:=0, pShaderByteCode:=0 
	r := dllcall(this.D3DXCompileShader
	, astr, Shader
	, UINT, strlen(Shader) 
	, uint, 0
	, uint, 0
	, astr, entrypoint
	, astr, "ps_3_0"
	, uint, 0
	, "uint*", pShaderByteCode
	, "uint*", pError
	, uint, 0, uint)

	use := r ? pError : pShaderBytecode		
	_ptr := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*3, "ptr"), uint, use)
	size := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*4, "ptr"), uint, use)
	
	if r 
	{
		rr := strget(_ptr+0, size, "CP0")
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), uint, use)
		return "compilation failed " rr		
	}	
		
	else
	{
		r := dllcall(IDirect3DDevice9.CreatePixelShader, uint, pDevice, uint, _ptr, "uint*", pShader)
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), uint, use)
		return r 
	}	
}	

AssembleShader(pDevice, byref Shader, byref pShader)
{	
	pShader:=0, pError:=0, pShaderByteCode:=0 
	printl("Assembling")
	r := dllcall(this.D3DXAssembleShader
	, astr, Shader
	, UINT, strlen(Shader) 
	, uint, 0
	, uint, 0
	, uint, 0
	, "uint*", pShaderBytecode
	, "uint*", pError
	, uint, 0, uint)

	use := r ? pError : pShaderBytecode		
	_ptr := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*3, "ptr"), uint, use)
	size := dllcall(numget(numget(use+0, "ptr")+A_PtrSize*4, "ptr"), uint, use)
	
	if r 
	{
		rr := strget(_ptr+0, size, "CP0")
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), uint, use)
		return "compilation failed " rr		
	}	
		
	else
	{
		r := dllcall(IDirect3DDevice9.CreatePixelShader, uint, pDevice, uint, _ptr, "uint*", pShader)
		dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), uint, use)
		return r 
	}		
}	

DisassembleShader(pShaderData)
{
	pBuffer := 0
	if (r := dllcall(this.D3DXDisassembleShader, uint, pShaderData, uint, 0, uint, 0, "uint*", pBuffer))
		return r
	
	_ptr := dllcall(numget(numget(pBuffer+0, "ptr")+A_PtrSize*3, "ptr"), uint, pBuffer)
	size := dllcall(numget(numget(pBuffer+0, "ptr")+A_PtrSize*4, "ptr"), uint, pBuffer)
	rr := strget(_ptr+0, size, "UTF-8")
	pBuffer ? dllcall(numget(numget(use+0, "ptr")+A_PtrSize*2, "ptr"), uint, pBuffer)
	return rr	
}


}
