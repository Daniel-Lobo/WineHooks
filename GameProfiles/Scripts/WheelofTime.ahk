OnMessage(dllcall("RegisterWindowMessageW", str, "Peixoto.WoT.PlayFMV"), "PlayFMV")
dllcall("LoadLibraryW", str, g_.injector_dir "\vlc\libvlccore.dll")
dllcall("LoadLibraryW", str, g_.injector_dir "\vlc\libvlc.dll")
PlayFMV(wP, lParam, msg, hwnd)
{
	VarSetCapacity(file, lParam, 0)
	VarSetCapacity(rect, 32, 0)			
	h_game := Get_process_handle(g_.target_name)
	res    := desk()
	numput(res.w, &rect+4, "uint")
	numput(res.h, &rect+12, "uint")
	dllcall("ReadProcessMemory", ptr, h_game, ptr, wP, ptr, &file, uint, lParam, "uint*", NumberOfBytesRead:=0)
	file_name := strget(&file, "UTF-16")
	win       := WinExist("Wheel of Time")	
	WinHide, Wheel of Time
	dllcall("peixoto.dll\VlcPlay", astr, file_name, astr) 	
	WinShow, Wheel of Time
	return
}

;REMOTE SCRIPT START
dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlccore.dll")
dllcall("LoadLibraryW", str, g_.cfg.injector_dir "\vlc\libvlc.dll")
#include %A_ScriptDir%\src\dsound.hooks.txt
logerr(GetDirectSound())
Logerr(IDirectSound.Hook("CreateSoundBuffer"))
logerr(IDirectSoundBuffer.Hook("Release"))
g_.s.snd_bffrs := {}		

IDirectSound_CreateSoundBuffer(p1, p2, p3, p4)
{
	DSBUFFERDESC[]:= p2
	DSBUFFERDESC.dwFlags |= DSBCAPS_CTRLVOLUME
	r := dllcall(IDirectSound.CreateSoundBuffer, uint, p1, uint, p2, uint, p3, uint, p4)
	if (r = 0)
	{
		DSBUFFERDESC[]:= p2
		if !(DSBUFFERDESC.dwFlags & DSBCAPS_PRIMARYBUFFER)
			g_.s.snd_bffrs[numget(p3+0, "ptr")] := True
	}
	return r
}

IDirectSoundBuffer_Release(p1)
{
	r = dllcall(IDirectSoundBuffer.Release, ptr, p1)
	if (r = 0)
		g_.s.snd_bffrs[p1] := ""
	return r	
}

AltCreateFileW(p1, p2, p3, p4, p5, p6, p7)
{
	static block   := 1 
	file           := strget(p1, "UTF-16")
	if instr(file, ".mov") ;and !  instr(FILE, "intro")
	{
		Winclose, Curtain 
	}		
	
	if instr(file, ".mov") and block
	{
		logerr("Skiped " file)
		block := false
		err   := 1
		/*
		msg   := dllcall("RegisterWindowMessageW", str, "Peixoto.WoT.PlayFMV")		
		dllcall("SendMessage", int, -1, uint, msg, uint, p1, uint, 2*(StrLen(file)+1))		
		block := true
		sleep, 2000
		WinShow, Wheel of Time
		return -1		
		*/

		for k, v in g_.s.snd_bffrs 
			logerr("Mute buffer " dllcall(IDirectSoundBuffer.setvolume, ptr, k, int, -10000))					
		while (err)
		{
			r    := dllcall("peixoto.dll\VlcDDrawPlay", ptr, 0, ptr, g_.proxies.FMVr[], astr, file, astr) 
			err  := ErrorLevel
			code := strsplit(r, "failed")[2]
			logerr("Vlc " r "..." code " " ddraw.err[code . ""] errorlevel)			
		}	
		for k, v in g_.s.snd_bffrs		
			logerr("Unmute buffer " dllcall(IDirectSoundBuffer.setvolume, ptr, k, int, 0))	
						
		block := true
		return -1					
	}	
	r := dllcall(g_fhks.pCreateFileW, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)		
	return r
}

