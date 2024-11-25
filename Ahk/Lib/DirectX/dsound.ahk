#include lib\DirectX\Headers\_dsound.h.ahk
;#include <GUI>

global IDirectSound:=0, IDirectSoundBuffer:=0, IDirectSound8:=0, IDirectSoundBuffer8:=0, IKsPropertySet:=0,IDirectSound3DBuffer:=0
global _DSBUFFERDESC := struct(DSBUFFERDESC)

LoadWAV(file_, formatcheck = True, fcs = False) 
{ 		
	plock:=0, plocksize:=0
	file := FileOpen(file_, "r")
	VarSetCapacity(data, file.Length)
	file.RawRead(data, file.Length)
	file.close()
	
	loop, % file.Length
	{
		if strget(&data + A_index, 3, "CP0") = "fmt" 
		{
			index := A_index + 8
			break
		}	
	}	
		
	if not index
		return "File format must be .wav (PCM)"
	
	wav := struct(WAVEFORMATEX)
	dllcall("RtlMoveMemory", ptr, wav[], ptr, &data + index, int, sizeof(WAVEFORMATEX))	
	
	if 	wav.wFormatTag = 1
		wav.wFormatTag := WAVE_FORMAT_PCM	
	else 
		if formatcheck 
			return "WAV file must be on PCM format"	
		
	loop, % file.Length
	{
		if strget(&data + A_index, 4,"CP0") = "data" 
		{
			index := A_index
			break
		}	
	}
		
	data_size := numget(&data + index + 4, "int")	
	VarSetCapacity(wave_data, data_size)
	dllcall("RtlMoveMemory", ptr, &wave_data, ptr, &data + index + 8, int, data_size)		
		
	(D := struct(DSBUFFERDESC8)).dwSize := sizeof(DSBUFFERDESC8)
	D.dwFlags       := DSBCAPS_CTRLVOLUME | DSBCAPS_CTRLPOSITIONNOTIFY | DSBCAPS_LOCSOFTWARE 
	D.dwFlags       := DSBCAPS_CTRLFX
	D.dwBufferBytes := data_size
	D.lpwfxFormat   := wav[] 
	fcs ? D.dwFlags |= (DSBCAPS_STICKYFOCUS | DSBCAPS_GLOBALFOCUS )
	
	buff := 0	
	r := dllcall(IDirectSound8.CreateSoundBuffer, uint, IDirectSound8.p, uint, D[], "uint*", buff, uint, 0, uint)
	if r		
		return r  " CreateSoundBuffer " dsound.err[r . ""]
		
	sndbuff := new ComInterfaceWrapper(dsound.IDirectSoundBuffer, buff, True) 
	r := dllcall(sndbuff.Lock, uint, sndbuff.p, uint, 0, uint, data_size, "uint*", plock
							 , "uint*", plocksize, uint, 0, uint, 0, uint, DSBLOCK_ENTIREBUFFER, uint)
	if r		
		return r  " Lock " dsound.err[r . ""]
	
	dllcall("RtlMoveMemory", ptr, plock, ptr, &wave_data, int, data_size)
	
	r := dllcall(sndbuff.UnLock, uint, sndbuff.p, uint, plock, int, data_size, uint, 0, uint, 0, uint)
	if r		
		return r  " Unlock " dsound.err[r . ""]
	
	wav := ""
	wave_data := ""	
	return sndbuff			
}	

LoadRAWSoundData(byref PMEM, file_)
{
	file := FileOpen(file_, "r")	
	file.RawRead(WAV_FILE_HEADER[], WAV_FILE_HEADER.size())	
	
	PMEM := dllcall("VirtualAlloc", uint, 0, uint, WAV_FILE_HEADER.Subchunk2Size, Int, 0x00001000 ;| 0x00002000
								  , uint, 0x04 )
	
	file.RawRead(PMEM+0, WAV_FILE_HEADER.Subchunk2Size)		
	file.close()	
	return WAV_FILE_HEADER.Subchunk2Size
}	

DumpSndBuffer(pSndBuff, locksize, file)
{
	plock:=0, plocksize:=0, size:=0, writen:=0
	r := dllcall(IDirectSoundBuffer.GetFormat, uint, pSndBuff, uint, 0, uint, 0, "uint*", size, uint)
	print("GetBufferSize " r "-" dsound.err[r . ""] "size: "  size "`n")
	
	varsetcapacity(wave_format, size)
	r := dllcall(IDirectSoundBuffer.GetFormat, uint, pSndBuff, uint, &wave_format, uint, size, "uint*", writen, uint)
	print("GetBufferFormat " r "-" dsound.err[r . ""] "`n")
	
	WAVEFORMATEX[] := &wave_format			
	r := dllcall(IDirectSoundBuffer.Lock, uint, pSndBuff, uint, 0, uint, locksize, "uint*", plock
							            , "uint*", plocksize, uint, 0, uint, 0, uint, DSBLOCK_ENTIREBUFFER, uint)
	print("Lock " r "-" dsound.err[r . ""] "`n")
		
	WAV_FILE_HEADER.ChunkID       := 1179011410
	WAV_FILE_HEADER.ChunkSize     := plocksize + WAV_FILE_HEADER.size() - 8
	WAV_FILE_HEADER.Format        := 1163280727
	WAV_FILE_HEADER.Subchunk1ID   := 544501094
	WAV_FILE_HEADER.Subchunk1Size := 16
	WAV_FILE_HEADER.AudioFormat   := 1
	WAV_FILE_HEADER.NumChannels   := WAVEFORMATEX.nChannels
	WAV_FILE_HEADER.SampleRate    := WAVEFORMATEX.nSamplesPerSec
	WAV_FILE_HEADER.ByteRate      := WAVEFORMATEX.nAvgBytesPerSec
	WAV_FILE_HEADER.BlockAlign    := WAVEFORMATEX.nBlockAlign
	WAV_FILE_HEADER.BitsPerSample := WAVEFORMATEX.wBitsPerSample      
	WAV_FILE_HEADER.Subchunk2ID   := 1635017060
	WAV_FILE_HEADER.Subchunk2Size := plocksize
			
	f := FileOpen(file, "w")
	f.RawWrite(WAV_FILE_HEADER[], WAV_FILE_HEADER.size())
	f.RawWrite(plock+0, plocksize)
	f.close()	
	
	r := dllcall(IDirectSoundBuffer.UnLock, uint, pSndBuff, uint, plock, int, data_size, uint, 0, uint, 0, uint)
	print("dump UnLock " r "-" dsound.err[r . ""] "`n")
}	

GetDirectSound(hwin = "")
{	
	dllcall("Ole32.dll\CoInitialize", ptr, 0)
	DS:=0, pPrim:=0, pSndbuff:=0
	if ! (DSCreate := dllcall("GetProcAddress", "int", dllcall("LoadLibrary", "str", "dsound.dll"), "astr", "DirectSoundCreate"))
		return "Failed to load or get the entrypoint(dsound.dll) " A_lasterror	
	
	r := dllcall(DSCreate, uint, 0, "uint*", DS, uint, 0, Uint) 
	if r
		return "Failed to create the IDirectSound interface " r  " - " dsound.err[r . ""]	
	else IDirectSound := new ComInterfaceWrapper(dsound.IDirectSound, DS, True)		
			
	r :=  dllcall(IDirectSound.SetCooperativeLevel, uint, IDirectSound.p, uint, hwin ? hwin : A_scripthwnd, uint, DSSCL_NORMAL, uint)	
	if r
		return "Failed to set the DirectSound cooperative level " r  " - " dsound.err[r . ""]	
	
	DSBUFFERDESC.dwSize        := sizeof(DSBUFFERDESC)
	DSBUFFERDESC.dwFlags       := DSBCAPS_PRIMARYBUFFER 
	DSBUFFERDESC.dwBufferBytes := 0 
	DSBUFFERDESC.lpwfxFormat   := 0 	
	
	r := dllcall(IDirectSound.CreateSoundBuffer, uint, IDirectSound.p, uint, DSBUFFERDESC[], "uint*", pPrim, uint, 0, uint)
	if r
		return "Failed to create the IDirectSoundBuffer interface " r  " - " dsound.err[r . ""]	
		
	DSBUFFERDESC.dwSize        := sizeof(DSBUFFERDESC)
	DSBUFFERDESC.dwFlags       := DSBCAPS_CTRLVOLUME | DSBCAPS_CTRLPOSITIONNOTIFY | DSBCAPS_LOCSOFTWARE | DSBCAPS_CTRL3D
	DSBUFFERDESC.dwBufferBytes := 33396048
	DSBUFFERDESC.lpwfxFormat   := WAVEFORMATEX[] 
	
	WAVEFORMATEX.wFormatTag      := 1
	WAVEFORMATEX.nChannels       := 2
	WAVEFORMATEX.nSamplesPerSec  := 44100
	WAVEFORMATEX.nAvgBytesPerSec := 176400
	WAVEFORMATEX.nBlockAlign     := 4
	WAVEFORMATEX.wBitsPerSample  := 16
	WAVEFORMATEX.cbSize          := 0
	
	r := dllcall(IDirectSound.CreateSoundBuffer, uint, IDirectSound.p, uint, DSBUFFERDESC[], "uint*", pSndbuff, uint, 0, uint)
	if r
		return "Failed to create the IDirectSoundBuffer interface " r  " - " dsound.err[r . ""]	
	IDirectSoundBuffer := new ComInterfaceWrapper(dsound.IDirectSoundBuffer, pSndbuff, True) 
		
	GUID_FromString(iid, dsound.IID_IKsPropertySet)
	r := dllcall(IDirectSoundBuffer.QueryInterface, uint, IDirectSoundBuffer.p, uint, &iid, "uint*", pIKs:=0)
	if r
		return "Failed to create the IKsPropertySet interface " r  " - " dsound.IID_IKsPropertySet " " dsound.err[r . ""]	
	IKsPropertySet := new ComInterfaceWrapper(dsound.IKsPropertySet, pIKs, True)  
	
	GUID_FromString(iid, dsound.IID_IDirectSound3DBuffer)
	r := dllcall(IDirectSoundBuffer.QueryInterface, uint, IDirectSoundBuffer.p, uint, &iid, "uint*", p3D:=0)
	if r
		return "Failed to create the IDirectSound3DBuffer interface " r  " - " dsound.IID_IKsPropertySet " " dsound.err[r . ""]	
	IDirectSound3DBuffer := new ComInterfaceWrapper(dsound.IDirectSound3DBuffer, p3D, True) 	
	
	return "Succeeded to create the DirectSound interfaces"
}

GetDirectSound8(hwin = "")
{
	dllcall("Ole32.dll\CoInitialize", ptr, 0)
	DS:=0, pPrim:=0
	if ! (DSCreate := dllcall("GetProcAddress", "int", dllcall("LoadLibrary", "str", "dsound.dll"), "astr", "DirectSoundCreate8"))
		return "Failed to load or get the entrypoint(dsound.dll) " A_lasterror	
		
	r := dllcall(DSCreate, uint, 0, "uint*", DS, uint, 0, Uint) 
	if r
		return "Failed to create the IDirectSound8 interface " r  " - " dsound.err[r . ""]	
	else IDirectSound8 := new ComInterfaceWrapper(dsound.IDirectSound8, DS, True)
		
	r :=  dllcall(IDirectSound8.SetCooperativeLevel, uint, IDirectSound8.p, uint, hwin ? hwin : A_scripthwnd, uint, DSSCL_PRIORITY, uint)	
	if r
		return "Failed to set the DirectSound cooperative level " r  " - " dsound.err[r . ""]	
	
	DSBUFFERDESC8.dwSize        := sizeof(DSBUFFERDESC8)
	DSBUFFERDESC8.dwFlags       := DSBCAPS_PRIMARYBUFFER 
	DSBUFFERDESC8.dwBufferBytes := 0 
	DSBUFFERDESC8.lpwfxFormat   := 0 
		
	r := dllcall(IDirectSound8.CreateSoundBuffer, uint, IDirectSound8.p, uint, DSBUFFERDESC8[], "uint*", pPrim, uint, 0, uint)
	if r
		return "Failed to create the IDirectSoundBuffer8 interface " r  " - " dsound.err[r . ""]	
	else IDirectSoundBuffer8 := new ComInterfaceWrapper(dsound.IDirectSoundBuffer8, pPrim, True) 	
			
	return "Succeeded to create the DirectSound8 interfaces"
}