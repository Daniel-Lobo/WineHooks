global DDS_PIXELFORMAT := "DWORD dwSize; DWORD dwFlags; DWORD dwFourCC; DWORD dwRGBBitCount; DWORD dwRBitMask; "
.  "DWORD dwGBitMask; DWORD dwBBitMask; DWORD dwABitMask;"

global DDS_HEADER := struct("DWORD dwSize; DWORD  dwFlags; DWORD dwHeight; DWORD dwWidth; DWORD dwPitchOrLinearSize; "
.  "DWORD dwDepth; DWORD dwMipMapCount; DWORD dwReserved1[11]; DDS_PIXELFORMAT ddspf; DWORD dwCaps; DWORD dwCaps2; "
.  "DWORD dwCaps3; DWORD dwCaps4; DWORD dwReserved2;")

DDS_PIXELFORMAT         := struct(DDS_PIXELFORMAT)
global DDPF_RGB         := 0x00000040
global DDPF_ALPHAPIXELS := 0x00000001
global DDPF_BUMPDUDV    := 0x00080000
global BITMAPINFOHEADER := "DWORD biSize, LONG biWidth, LONG biHeight, DWORD biPlanesAndbiBitCount, DWORD biCompression,"
. " DWORD biSizeImage, LONG biXPelsPerMeter, LONG biYPelsPerMeter, DWORD biClrUsed, DWORD biClrImportant"
BITMAPINFOHEADER := struct(BITMAPINFOHEADER)
global BITMAPFILEHEADER := struct("WORD bfType; DWORD bfSize; WORD bfReserved1; WORD bfReserved2; DWORD bfOffBits;")

SetFilePixelFormat(format = "RG6B")
{
	if (format = "RG6B") 	{
			DDS_PIXELFORMAT.dwFlags := DDPF_RGB 
			DDS_PIXELFORMAT.dwSize := DDS_PIXELFORMAT.size()	
			DDS_PIXELFORMAT.dwRGBBitCount := 16
			DDS_PIXELFORMAT.dwRBitMask := 0xF800
			DDS_PIXELFORMAT.dwGBitMask := 0x07e0
			DDS_PIXELFORMAT.dwBBitMask := 0x001F
			DDS_PIXELFORMAT.dwABitMask := 0					
		}
	else if (format = "RGB") 	{
			DDS_PIXELFORMAT.dwFlags := DDPF_RGB 
			DDS_PIXELFORMAT.dwSize := DDS_PIXELFORMAT.size()	
			DDS_PIXELFORMAT.dwRGBBitCount := 24
			DDS_PIXELFORMAT.dwRBitMask := 0x00FF0000
			DDS_PIXELFORMAT.dwGBitMask := 0x0000FF00
			DDS_PIXELFORMAT.dwBBitMask := 0x000000FF
			DDS_PIXELFORMAT.dwABitMask := 0		
		}		
	else if (format = "X1RGB") 	{
			DDS_PIXELFORMAT.dwFlags := DDPF_RGB 
			DDS_PIXELFORMAT.dwSize := DDS_PIXELFORMAT.size()	
			DDS_PIXELFORMAT.dwRGBBitCount := 16
			DDS_PIXELFORMAT.dwRBitMask := 0x00007C00  
			DDS_PIXELFORMAT.dwGBitMask := 0x000003E0
			DDS_PIXELFORMAT.dwBBitMask := 0x0000001F
			DDS_PIXELFORMAT.dwABitMask := 0	
		}	
			
	else if (format = "A1RGB") 	{
			DDS_PIXELFORMAT.dwFlags := DDPF_RGB | DDPF_ALPHAPIXELS
			DDS_PIXELFORMAT.dwSize := DDS_PIXELFORMAT.size()	
			DDS_PIXELFORMAT.dwRGBBitCount := 16
			DDS_PIXELFORMAT.dwRBitMask := 0x00007C00  
			DDS_PIXELFORMAT.dwGBitMask := 0x000003E0
			DDS_PIXELFORMAT.dwBBitMask := 0x0000001F
			DDS_PIXELFORMAT.dwABitMask := 0x00008000
		}	

	else if (format = "A4RGB") 	{
			DDS_PIXELFORMAT.dwFlags := DDPF_RGB | DDPF_ALPHAPIXELS
			DDS_PIXELFORMAT.dwSize := DDS_PIXELFORMAT.size()	
			DDS_PIXELFORMAT.dwRGBBitCount := 16
			DDS_PIXELFORMAT.dwRBitMask := 0xf00 
			DDS_PIXELFORMAT.dwGBitMask := 0xf0
			DDS_PIXELFORMAT.dwBBitMask := 0xf
			DDS_PIXELFORMAT.dwABitMask := 0xf000
		}
		
	else if (format = "A8RGB")	{	
			DDS_PIXELFORMAT.dwFlags := DDPF_RGB | DDPF_ALPHAPIXELS
			DDS_PIXELFORMAT.dwSize := DDS_PIXELFORMAT.size("ddpfPixelFormat")	
			DDS_PIXELFORMAT.dwRGBBitCount := 32
			DDS_PIXELFORMAT.dwRBitMask := 0x00FF0000
			DDS_PIXELFORMAT.dwGBitMask := 0x0000FF00
			DDS_PIXELFORMAT.dwBBitMask := 0x000000FF
			DDS_PIXELFORMAT.dwABitMask := 0xFF000000
		}	
	else if (format = "X8RGB")	{	
			DDS_PIXELFORMAT.dwFlags := DDPF_RGB 
			DDS_PIXELFORMAT.dwSize := DDS_PIXELFORMAT.size("ddpfPixelFormat")	
			DDS_PIXELFORMAT.dwRGBBitCount := 32
			DDS_PIXELFORMAT.dwRBitMask := 0x00FF0000
			DDS_PIXELFORMAT.dwGBitMask := 0x0000FF00
			DDS_PIXELFORMAT.dwBBitMask := 0x000000FF
			DDS_PIXELFORMAT.dwABitMask := 0
		}	
	else if (format = "A8BGR")	{	
			DDS_PIXELFORMAT.dwFlags := DDPF_RGB | DDPF_ALPHAPIXELS
			DDS_PIXELFORMAT.dwSize := DDS_PIXELFORMAT.size("ddpfPixelFormat")	
			DDS_PIXELFORMAT.dwRGBBitCount := 32
			DDS_PIXELFORMAT.dwRBitMask := 0x000000FF 
			DDS_PIXELFORMAT.dwGBitMask := 0x0000FF00
			DDS_PIXELFORMAT.dwBBitMask := 0x00FF0000
			DDS_PIXELFORMAT.dwABitMask := 0xFF000000
		}

	else if (format = "V8U8")	{	
			DDS_PIXELFORMAT.dwFlags := 0x80000
			DDS_PIXELFORMAT.dwSize := DDS_PIXELFORMAT.size("ddpfPixelFormat")	
			DDS_PIXELFORMAT.dwFourCC := 16
			DDS_PIXELFORMAT.dwRBitMask := 0xFF
			DDS_PIXELFORMAT.dwGBitMask := 0xFF00
			DDS_PIXELFORMAT.dwBBitMask := 0
			DDS_PIXELFORMAT.dwABitMask := 0			
		}
		
	else if instr(format, "D"){		
		DDS_PIXELFORMAT.dwFlags := 0x4
		DDS_PIXELFORMAT.dwSize := DDS_PIXELFORMAT.size("ddpfPixelFormat")	
		DDS_PIXELFORMAT.dwFourCC := FourCC(format)					
	}	
}	

GetFilePixelFormat(byref fileHeader)
{
	FMT := "_Unsupported format_"
	dllcall(g_.p.GetDDSFilePxFmt, ptr, FileHeader[], astr, FMT) 
	return FMT	
}

LoadDDS(file, byref pData)
{	
	hFile := dllcall("CreateFileW", str, file, uint, 0x80000000, uint, 0, uint, 0, uint, 3, uint, 0x80, uint, 0)
	dllcall("GetFileSizeEx", uint, hFile, "int64*", size)
	VarSetCapacity(pData, size)
	dllcall("ReadFile", uint, hFile, uint, &pData, uint, size, "uint*", read_, uint, 0)	
	
	dllcall("RtlMoveMemory", ptr, DDS_HEADER[], ptr, &pData + 4, int, DDS_HEADER.size())	
	pixelformat := getFilePixelFormat(DDS_HEADER)
	printl("Pixelformat: " pixelformat "  " DDS_HEADER.dwWidth "x" DDS_HEADER.dwHeight)	
	dllcall("CloseHandle", uint, hFile)		
	return pixelformat	
}

OpenDDS(file, byref hFile)
{	
	size:=0, signature:=0,
	hFile := dllcall("CreateFileW", str, file, uint, 0x80000000, uint, 0x00000001, uint, 0, uint, 3, uint, 0x80, uint, 0) 
	(hFile=-1)?	logerr("error " A_lasterror " opening file " file)
	dllcall("GetFileSizeEx", uint, hFile, "int64*", size)
	dllcall("ReadFile", uint, hFile, "uint*", signature, uint, 4, "uint*", (rd:=0), uint, 0)	
	dllcall("ReadFile", uint, hFile, uint, DDS_HEADER[], uint, DDS_HEADER.size(), "uint*", (rd:=0), uint, 0)	
	
	pixelformat := GetFilePixelFormat(DDS_HEADER)
	printl("Pixelformat: " pixelformat "  " DDS_HEADER.dwWidth "x" DDS_HEADER.dwHeight)	
	return pixelformat	
}

LoadDumpCollection(dir, byref lst)
{
	FileGetAttrib, att, %dir%
	if not instr(att, "D")
	return 
	
	loop, %dir%\*.dds, 0, 0
	{
		LoadSingleDump(A_LoopFileFullPath, A_LoopFileName)						
	}	
}	

LoadSingleDump(path, name)
{
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	dllcall(dll "\AppendDump", astr, path)			
}

LoadCompiledDumpCollection(file, byref lst)
{
	SplitPath, file, , dir
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	dllcall(dll "\LoadDumps", astr, file, astr, dir)	
}

IsDump(o, f)
{
	return 
	return dllcall("peixoto.dll\IsDump", astr, f)	
}

FourCC(code)
{
	if code is not number 
	{
		VarSetCapacity(format, 4)
		strput(code, &format, 4, "CP0")	
		return numget(&format+0, "uint")
	} else {
		VarSetCapacity(format, 4)
		numput(code, &format, "uint")
		return strget(&format, 4, "CP0")
	}
}

/*
class DDSDump
{	
	__delete() {
		dllcall("VirtualFree", uint, this.data, uint, 0, uint, (MEM_RELEASE := 0x8000) )
	}
}

AppendDumps(pObject, dumps, position)
{
	dump   := struct("DWORD ww; DWORD hh; DWORD bypp; LPVOID pData; DWORD samples; BOOL isOptimized; BOOL found")
	dump[] := pObject.pDumpArray + position * dump.size()
	for k, v in dumps
	{
		dump.ww          := v.w
		dump.hh          := v.h
		dump.bypp        := v.bypp
		dump.pData       := v.data
		dump.samples     := v.samples
		dump.isOptimized := v.optimized
		dump.found       := v.found
		dump[]           += dump.size()
	}
	return dump.size()
}

MakeDumpStructArray(byref pObject)
{
	static dump := struct("DWORD ww; DWORD hh; DWORD bypp; LPVOID pData; DWORD samples; BOOL isOptimized; BOOL found")
	pObject.pDumpArray ? dllcall("VirtualFree", ptr, pObject.pDumpArray, uint, 0, uint, (MEM_RELEASE := 0x8000) )
	pObject.pDumpArray := dllcall("VirtualAlloc", ptr, 0, ptr, dump.size() * 200000 ; 5.6 MG, 60000 RGB, 70000 DXT1, 70000 DXT2-5
									            , uint, 0x00001000 | 0x00002000
								                , uint, (PAGE_READWRITE := 0x04), ptr )	
	dllcall("RtlZeroMemory", uint, pObject.pDumpArray, uint, dump.size() * pObject.dumps._MaxIndex())											
	dump[] := pObject.pDumpArray		
	for k, v in pObject.dumps
	{
		dump.ww          := v.w
		dump.hh          := v.h
		dump.bypp        := v.bypp
		dump.pData       := v.data
		dump.samples     := v.samples
		dump.isOptimized := v.optimized
		dump.found       := v.found
		dump[]           += dump.size()
	}	
}	


LoadTextureDumps(path = "")
{
	g_tswap.dumps := []
	if not path
	path := g_tswap.path
	
	if fileexist(path "\Dumps\dump._dds")		
		loadCompiledDumpCollection(g_tswap.path "\Dumps\dump._dds", g_tswap.dumps)
	else 
		loadDumpCollection(g_tswap.path "\Dumps", g_tswap.dumps)	
				
	for kk, vv in g_tswap.dumps 
	vv.replacement := fileexist( (rep := path "\Replacements\" vv.fname) ) ? rep : 0
				
	makeDumpStructArray(g_tswap)	
}

CompareSurfaceData(byref dump, byref desc, samples = 8, optimized = False)
{
	static RtlCompareMemory := dllcall("GetProcAddress", uint, dllcall("GetModuleHandle", str, "ntdll.dll"), astr, "RtlCompareMemory")
	
	if ( (desc.dwWidth != dump.w) or (desc.dwHeight != dump.h) 
	      or ((desc.lPitch/desc.dwWidth) != dump.bypp) )
		return False	
		
	jump := round(desc.dwHeight/samples)	
	
	if not optimized {	
	loop, %samples%
		{		
			if dllcall(RtlCompareMemory, "uint", dump.data + dump.w * dump.bypp * jump * (A_index - 1)
								       , "uint", desc.lpSurface + desc.lPitch * jump * (A_index - 1)
									   , "uint", dump.w * dump.bypp, uint) < dump.w * dump.bypp								   
				return False				
		}		
	}
	else {
		loop, %samples%
		{	
			if dllcall(RtlCompareMemory, "uint", dump.data + dump.w * dump.bypp * (A_index - 1)
								       , "uint", desc.lpSurface + desc.lPitch * jump * (A_index - 1)
									   , "uint", dump.w * dump.bypp, uint) < dump.w * dump.bypp								   
				return False				
		}		
	}	
	return true		
}

ChangeIndianess24(n_pixels, pdata){
	return dllcall("Peixoto.dll\ChangeGl24BitTextureIndianes", int, n_pixels, uint, pdata)	
}	
*/