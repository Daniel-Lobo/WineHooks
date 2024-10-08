if (g_.target_name = "LbaWin.exe")
{
	rotation   := 0x44bb12
	h_game     := Get_process_handle(g_.target_name)
	dead       := g_.deadzone*32767
	dead_minus := dead*(-1)
	factor := 1024/360
	g_.macros := []
	for k, v in strsplit(g_._macros, ",")
		g_.macros.push(new Sender(v))

	ls := new Sender("up")
	loop
	{
		if not (events  := XinputGetEvent())
			break
		
		(flags := read_process_memory(h_game, 0x42f098, "char")) &= ~ 0x20
		write_process_memory(h_game, 0x42f098 , "char", flags |  0x4) 
		
		angle   := XinputGetLeftStickAngle()
		angle   := 360-angle      ;Game angles increase counterclockwise
		angle   += 180            ;0 is twinsen facing south, not north 
		angle   += 45             ;45 degrees camera rotation
		(angle>360) ? angle-=360  ;keep everything in the 0-360 range
		
		if (XINPUT_GAMEPAD.sThumbLY>dead) or (XINPUT_GAMEPAD.sThumbLY<dead_minus) 
		or (XINPUT_GAMEPAD.sThumbLX<dead_minus) or (XINPUT_GAMEPAD.sThumbLX>dead)
		{		
			write_process_memory(h_game, rotation , "short", angle*factor) 
			;send {up down}
			ls._yes()
		} else if not XINPUT_GAMEPAD_DPAD_UP
		{
			;send {up up}
			ls._no()
		}
			
		for k, v in g_.macros 
		{
			if events[k] > 0
			v._yes()
			else if events[k] < 0
			v._no()
			else v._maybe()
		}	
		sleep, 15
	}
}

;REMOTE SCRIPT START
;#MaxHotkeysPerInterval 0xff
goto lba_continue
/*
~space::
	g_.cfg.sync := 0
return

~space UP::
	g_.cfg.sync := 1
return
*/

lba_continue:
#include %A_ScriptDir%\src\dsound.hooks.txt
global GENERIC_WRITE := 0x40000000

;dllcall("ddraw.dll\SetAppCompatData", uint, 12, uint, 0)
logerr("So far, so good")

LbaInitHook()
LbaInitHook()
{
	if (g_.cfg.target_name = "lbawin.exe")
	{
		loop, save\*.lba
		{
			fileread, data, save\%A_loopfilename%
			if instr(data, "Auto")
			{
				logerr(A_loopfilename ": " data)
				g_.autosave := "Save\" A_loopfilename
			}
		}
		logerr("CreateFile  Hook  : " InstallHook("LbaCreateFileA", pOpenFileA, "Kernel32.dll", "CreateFileA") " <- 0 means no error")
		logerr("CloseHandle Hook  : " InstallHook("LbaCloseHandle", pCloseHandle, "Kernel32.dll", "CloseHandle") " <- 0 means no error")	
		logerr("DeleteFile  Hook  : " InstallHook("LbaDeleteFile", pDeleteFile, "Kernel32.dll", "DeleteFileA")    " <- 0 means no error")
		g_.pDeleteFile              := pDeleteFile	
		g_.pCreateFile              := pOpenFileA
		g_.pCloseHandle             := pCloseHandle
		g_.hSaves                   := {}	
		D3DHOOKS_DATA.bltPrimary    := RegisterCallback("LbaBlt", "F")
		D3DHOOKS_DATA.UnLockPrimary := RegisterCallback("LbaUnlock", "F")
		
		if (g_.cfg.MCI)
		{	
			g_.s.SndNMsg := g_.p.SndNMsg 
			g_.s.msg     := dllcall("RegisterWindowMessageW", str, "Peixoto.MCI")
			g_.p.SndNMsg := RegisterCallBack("LbaSendMessage", "F")
		}		
	}
	else 
	{
		logerr(GetDirectSound())
		logErr(IDirectSoundBuffer.hook("SetFrequency"))
		InstallHook((g_.cfg.target_name="Lba2.exe") ? "Lba2GetDeviceState" : "AltGetDeviceState", p, "peixoto.dll", "DinputDeviceGetState")		
		g_.s.pDiGetState := p
	}
}

_LbaBlt(p1, p2, p3, p4, p5, p6){
	return Surface1Blt(p1, p2, p3, p4, p5, p6)
	if (getkeystate("space", "P")){
		g_.cfg.sync := 0
	} else {
		g_.cfg.sync := 1
	}
	return Surface1Blt(p1, p2, p3, p4, p5, p6)
}

LbaBlt(p1, p2, p3, p4, p5, p6)
{
	static called := False
	if (called)
	D3DHOOKS_DATA.bltPrimary := RegisterCallback("_LbaBlt", "F")
	called := True
	DDBlt(g_.primary, 0, 0, 0, 2, DDBLTFX[])
	return Surface1Blt(p1, p2, p3, p4, p5, p6)
}

LbaSendMessage(hwin, msg, wp, lp)
{
	if ( (msg = g_.s.msg) && (wp=8) )
	lp := g_.cfg.script_hwnd		
	return dllcall(g_.s.SndNMsg, uint, hwin, uint, msg, uint, wp, uint, lp)
}

IDirectSoundBuffer_SetFrequency(p1, p2)
{
	return
	return dllcall(IDirectSoundBuffer.SetFrequency, uint, p1, uint, p2)
}

LbaDeleteFile(p1)
{
	(strget(p1, "CP0") = g_.autosave) ? g_.autosave := ""
	return dllcall(g_.pDeleteFile, uint, p1)
}

LbaCreateFileA(p1, p2, p3, p4, p5, p6, p7)
{
	save := strget(p1, "CP0")		
	if instr(save, "Save\")
	{	
		i  := dllcall(g_.pCreateFile, uint, p1, uint, 0x80000000, uint, 0, uint, 0, uint, 3, uint, 0, uint, 0) 	
		sz := dllcall("GetFileSize", uint, i, uint, 0)
		dllcall(g_.pCloseHandle, uint, i)		
		
		if (g_.autosave and (p2=GENERIC_WRITE) and fileexist(save) 
		    and (save != g_.autosave) and (sz > 463) )
			save := g_.autosave				
		
		r := dllcall(g_.pCreateFile, astr, save, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7) 			
		(r > -1) ? g_.hSaves[r . ""] := {"n" : save , "sz" : sz} 
		return r
	}
	return dllcall(g_.pCreateFile, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7) 		
}

LbaCloseHandle(hwnd)
{
	static save_size := 457
	if not g_.autosave 
	{
		r    := dllcall(g_.pCloseHandle, uint, hwnd)
		file := g_.hSaves[hwnd . ""].n
		if instr(file, "Save\")
		{
			filecopy, %file%, autosave, 1
			fileread, data, autosave
			FileDelete, autosave
			if instr(data, "Auto")
				g_.autosave := file		
			g_.hSaves.remove(hwnd . "")
			return r
		}
		return r
	} 
	else if (g_.hSaves[hwnd . ""].n = g_.autosave) 
	{
		string_size := g_.hSaves[hwnd . ""].sz - 457 - 3
		string      := "Auto"
		extend      := string_size-4
		where := 1
		loop, %extend%
		{
			if where = 1
				string .= " " 	
			else string := " " string 
			where *= -1
		}	
		dummy:=0
		dllcall("SetFilePointer", uint, hwnd, uint, 1, uint, 0, uint, 0)
		dllcall("WriteFile", uint, hwnd, astr, string, uint, strlen(string), "uint*", dummy, uint, 0)	
	}
	g_.hSaves.remove(hwnd . "")
	return dllcall(g_.pCloseHandle, uint, hwnd)
}

AltIDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{

	D    := struct(DDSURFACEDESC)
	D[]  := pSurfaceDesc
	caps := D.ddsCaps.dwCaps
	r := IDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)		
	if (D.ddsCaps.dwCaps & DDSCAPS_PRIMARYSURFACE) 	
	{
		if !XinputGetState(1) and (g_.cfg.target_name="Lba2.exe")
		{
			for k, v in strsplit("01 00 00 00 01 00 00 00 FF 7F 00 00 55 55 00 00 FF 7F 00 00" 
								 . " 55 55 00 00 FF 7F 00 00 55 55 00 00 FF 7F 00 00 55 55 00"
								 . " 00 FF 7F 00 00 55 55 00 00 FF 7F 00 00 55 55", " ")
			{
				num := "0x" . v 
				numput(num,  0x004BA824+k-1, "char")
			}
		}		
	} DDBlt(g_.PRIMARY, 0, 0, 0, 2, DDBLTFX[])	
	return r
}

Lba2GetDeviceState(p1, p2, p3)
{
	static prev := 0
	;logerr("----------------------------------------")
	r := AltGetDeviceState(p1, p2, p3)
	
	if (p2=60)
	{
		DIJOYSTATE.lX  := 32767
		DIJOYSTATE.lY  := 32767	

		if (numget(0x4ccfe0+0, "short") = 0)
		{
			;dead        := 8191.75
			;dead_minus  := -8191.75	
				
			events := XinputGetEvent()
			if ( (angle := XinputGetLeftStickAngle()) = "")
			{
				XinputGetEvent()
				angle   := XinputGetLeftStickAngle()
			}
			if (angle != "")
			{
				cam_iso := numget(0x00478E54+0, "short")
				cam     := numget(0x47515c+0, "short")
					
				;Game angles increase counterclockwise
				angle   := 360-angle   
				;0 is twinsen facing south, not north 	
				angle   += 180      
				;Camera rotation	
				((cam_iso = 0) and (cam_iso != cam)) ? angle += 45 : angle -= (cam*360/4096)  
				(angle>360) ? angle-=360                                                                             
				(angle<0)   ? angle+=360   		
					
				if (XINPUT_GAMEPAD.sThumbLY>g_dnpt.dead) or (XINPUT_GAMEPAD.sThumbLY<g_dnpt.dead_m) 
				or (XINPUT_GAMEPAD.sThumbLX<g_dnpt.dead_m) or (XINPUT_GAMEPAD.sThumbLX>g_dnpt.dead)
				{	
					logerr(".............................")
					numput(angle*4096/360, 0x49A1EA+0, "uint")	
					send {up down}
					prev := 1
				} 
				else if (prev = 1)
				{
					send {up up}
					prev := 0
				}	
			}
			else if not prev
			{
				send {up up}
				prev := 0
			}
		}			
	}
	return r
}

AltGetDeviceState(p1, p2, p3)
{
	;printl(".............................")
	r := dllcall(g_.s.pDiGetState, uint, p1, uint, p2, uint, p3)
	if (p2=60)
	{
		;DIJOYSTATE.lZ  := (XINPUT_GAMEPAD.bLeftTrigger)  ? 0xffff : 32767		
		;DIJOYSTATE.lRZ := (XINPUT_GAMEPAD.bRightTrigger) ? 0xffff : 32767			
	}
	return r
}