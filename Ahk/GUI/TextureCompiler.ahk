#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#include ..\
#include lib\_Struct.ahk

DDS_PIXELFORMAT := "DWORD dwSize; DWORD dwFlags; DWORD dwFourCC; DWORD dwRGBBitCount; DWORD dwRBitMask; "
.  "DWORD dwGBitMask; DWORD dwBBitMask; DWORD dwABitMask;"

global DDS_HEADER := new _Struct("DWORD dwSize; DWORD  dwFlags; DWORD dwHeight; DWORD dwWidth; DWORD dwPitchOrLinearSize; "
.  "DWORD dwDepth; DWORD dwMipMapCount; DWORD dwReserved1[11]; DDS_PIXELFORMAT ddspf; DWORD dwCaps; DWORD dwCaps2; "
.  "DWORD dwCaps3; DWORD dwCaps4; DWORD dwReserved2;")

dllcall("AllocConsole")
print(msg){
    FileOpen("*", "w").write(msg "`n")
}
print("====================================")

GetFilesList(dir, dump, byref samples)
{
	files := []
    print(dir)
	loop, %dir%\*.dds, 0, 0
	{
        print(A_LoopFileFullPath)
		FileGetSize, sz, %A_loopfilefullpath%
		files.insert( {"f" : A_loopfilename, "l" : sz} )
	}	
	return files
}

GetHeaderFromFile(f, samples)
{
	file := FileOpen(f, "r") 
	VarSetCapacity(data, DDS_HEADER.size()+4, 0)
	file.RawRead(data, DDS_HEADER.size()+4)		
	dllcall("RtlMoveMemory", ptr, DDS_HEADER[], ptr, &data + 4, int, DDS_HEADER.size())
	
	data_sz := file.Length - DDS_HEADER.size() - 4
	data_sz *= samples/DDS_HEADER.dwHeight
		
	if (DDS_HEADER.ddspf.dwFlags & 4) 
	{
		data_sz           := file.Length - DDS_HEADER.size() - 4
		data_rows_count   := DDS_HEADER.dwHeight/4
		pitch             := data_sz/data_rows_count	
		data_sz           := pitch*samples
	}
		
	file.close()
	return data_sz 
}

GetDataFromFile(f, samples, byRef RetData)
{
	file := FileOpen(f, "r") 
	VarSetCapacity(data, file.Length, 0)
	file.RawRead(data, file.Length)
		
	dllcall("RtlMoveMemory", ptr, DDS_HEADER[], ptr, &data + 4, int, DDS_HEADER.size())
	offset := &data + DDS_HEADER.size() + 4	
		
	if (DDS_HEADER.ddspf.dwFlags & 4) ; DDPF_FOURCC
	{
		data_sz           := file.Length - DDS_HEADER.size() - 4
		data_rows_count   := DDS_HEADER.dwHeight/4
		pitch             := data_sz/data_rows_count		
		jump              := round(data_rows_count/samples)
		sz                := VarSetCapacity(RetData, pitch*samples)		
		loop, %samples%
		{
			dllcall("RtlMoveMemory", ptr, &RetData + pitch * (A_index - 1)
			                       , ptr, offset + (pitch * (A_index - 1) * jump), uint, pitch)
		}				
	}		
	else 
	{		
		data_sz := file.Length - DDS_HEADER.size() - 4
		pitch   := data_sz/DDS_HEADER.dwHeight		
		jump    := round(DDS_HEADER.dwHeight/samples)
		sz      := VarSetCapacity(RetData, pitch*samples)		
		loop, %samples%
		{
			dllcall("RtlMoveMemory", ptr, &RetData + pitch * (A_index - 1)
			                       , ptr, offset + (pitch * (A_index - 1) * jump), uint, pitch)
		}				
	}	
	file.close()
	return sz
}

CompileTextureDumps(dir, outfile, samples = 4)
{
	CoordMode, Mouse, screen
	MouseGetPos, x, y
	Progress, b x%x% y%y% h19 ZH10
	
	files       := GetFilesList(dir, outfile "._dds", samples)		
	dump        := fileopen("temp._dds", "w")
	header_size := (510 + 8) * files._MaxIndex()  
	sum         := 4 + header_size	
	offsets     := []
	
	dump.writeUshort(files._MaxIndex())
	dump.writeUshort(samples)
	for k, v in files
	{	
		offsets.insert(sum)
		VarSetCapacity(fname, 510, 0)
		strput(v.f, &fname, 255, "UTF-8")
		dump.rawwrite(&fname, 510)	
		
		data_sz := GetHeaderFromFile(dir v.f, samples)		
		size    := DDS_HEADER.size() + 4 + data_sz
		
		dump.writeUint(sum)
		dump.writeUint(size)
		sum += size		
	}
			    
	for k, v in files
	{		
		p := k/files._MaxIndex() * 100
		Progress, % p
		dump.seek(offsets[k])
		sz := GetDataFromFile(dir v.f, samples, pData)
		dump.writeint(5)	
		dump.rawwrite(DDS_HEADER[], DDS_HEADER.size())	
		dump.rawwrite(&pData, sz)		
	}
	dump.close()	   
	filecopy, temp._dds, %dir%%outfile%._dds, 1
    FileDelete, temp._dds
	Progress, off
	MsgBox, 64,,Done!	
}

path=%1%\Dumps
print(path)
CompileTextureDumps(path, "\dump", 4)
