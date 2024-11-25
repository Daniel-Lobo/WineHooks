#include lib\memlib.ahk

if (A_ptrsize = 4)
{
	g_.pCreateProcessA := dllcall("GetProcAddress", ptr, dllcall("GetModuleHandle", str, "Kernel32.dll", ptr), astr, "CreateProcessA")
	g_.pCreateProcessW := dllcall("GetProcAddress", ptr, dllcall("GetModuleHandle", str, "Kernel32.dll", ptr), astr, "CreateProcessW")
	logerr("CreateProcessA Hook: " AltInstallHook(dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "CreateProcessAHook"), pCA := g_.pCreateProcessA))
	logerr("CreateProcessW Hook: " AltInstallHook(dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "CreateProcessWHook"), pCW := g_.pCreateProcessW))
	g_.pCreateProcessA := pCA
	g_.pCreateProcessW := pCW
	dllcall("Peixoto.dll\InitCreateProcessHook", uint, RegisterCallback("CreateProcessA_hook", "F", ,0), uint, RegisterCallback("CreateProcessA_hook", "F", ,1))	
	logerr("ShellExecuteA Hook  :" InstallHook("ShellExecuteA", pSEA, "Shell32.dll", "ShellExecuteA")) 
	g_.p.ShellExecA := pSEA
	logerr("ShellExecuteExW Hook  :" InstallHook("ShellExecuteExW", pSEW, "Shell32.dll", "ShellExecuteExW")) 
	g_.p.ShellExecExW := pSEW
} else {
	logerr("CreateProcessA Hook: " InstallHook("CreateProcessA_hook", pCA:=0, "Kernel32.dll", "CreateProcessA", "F", 0))
	logerr("CreateProcessW Hook: " InstallHook("CreateProcessA_hook", pCW:=0, "Kernel32.dll", "CreateProcessW", "F", 1))
	g_.pCreateProcessA := pCA
	g_.pCreateProcessW := pCW
}

ShellExecuteA(p1, p2, p3, p4, p5, p6)
{
	if (instr(strget(p3+0, "CP0"), ".exe"))
	{
		varsetcapacity(SECURITY_ATTRIBUTES, 8 + A_ptrsize)
		varsetcapacity(THREAD_SECURITY_ATTRIBUTES, 8 + A_ptrsize)
		varsetcapacity(PROCESS_INFORMATION, 8 + A_ptrsize * 2) 	
		varsetcapacity(STARTUPINFO, 9*4 + 2*2 + 7*A_ptrsize) 
		numput(9*4 + 2*2 + 7*A_ptrsize, STARTUPINFO, 0 , "uint")	    
				
		r := dllcall("CreateProcessA", ptr, p3, ptr, p4, Ptr, &SECURITY_ATTRIBUTES, Ptr, &THREAD_SECURITY_ATTRIBUTES    	
									 , uint, 0, uint, 0, Ptr, 0, ptr, p5, Ptr, &STARTUPINFO, Ptr, &PROCESS_INFORMATION) 
		if (r)
		return 33	
	}
	return dllcall(g_.p.ShellExecA, ptr, p1, ptr, p2, ptr, p3, ptr, p4, ptr, p5, uint, p6)
}

ShellExecuteExW(p1)
{
	info   := struct("DWORD Size; ULONG Mask; HWND hwnd; LPCWSTR Verb; LPCWSTR File; LPCWSTR Params; LPCSTR Dir;")
	info[] := p1
	logerr("ShellExecuteExW " info.File)
	if (instr(info.File, ".exe") && info.Params = "") ; Whithout the params check GOW doesn't start
	{
		varsetcapacity(SECURITY_ATTRIBUTES, 8 + A_ptrsize)
		varsetcapacity(THREAD_SECURITY_ATTRIBUTES, 8 + A_ptrsize)
		varsetcapacity(PROCESS_INFORMATION, 8 + A_ptrsize * 2) 	
		varsetcapacity(STARTUPINFO, 9*4 + 2*2 + 7*A_ptrsize) 
		numput(9*4 + 2*2 + 7*A_ptrsize, STARTUPINFO, 0 , "uint")	    
		
		; Basic implementation for cracked half life's launcher - revloader.exe, doesn't handle arguments or directory		
		r := dllcall("CreateProcessA", astr, info.File, ptr, 0, Ptr, &SECURITY_ATTRIBUTES, Ptr, &THREAD_SECURITY_ATTRIBUTES    	
									 , uint, 0, uint, 0, Ptr, 0, ptr, 0, Ptr, &STARTUPINFO, Ptr, &PROCESS_INFORMATION) 
		logerr("ShellExecuteExW " info.File " " info.Params " " info.Dir " " r " " A_lasterror)							 
		if (r)
		return 33
	}
	return dllcall(g_.p.ShellExecExW, ptr, p1, ptr, p2, ptr, p3, ptr, p4, ptr, p5, uint, p6)
}

CreateProcessA_hook(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
{	
	encode := A_eventinfo ? "UTF-16" : "CP0"
	
	args  := strget(p2+0, encode)
	if (p1)
		trgt := strget(p1+0, encode)	
	else
	{
		trgt  := ""		
		quote := False
		for k, v in strsplit(args)
		{
			if (v = """")
			{
				if quote
				break
				else quote := True
			}
			if ( (v = A_space) && (!quote) )
			break	
			trgt .= v
		}
	}
	
	p := g_.target_dir 
	StringReplace, trgt, trgt, .\ ,%p%		

	if ! instr(trgt, ":")
	trgt := A_workingdir "\" trgt
	t    := strget(p1+0, encode)	
		
	StringToSend := trgt
	SizeInBytes  := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0) 

	; If the child is 64 bit it will never be resumed, because injection will fail
	; This freezes TR reboot waiting for it's crash handler
	;if (Is64Bit(trgt) and A_ptrsize=4)
		;return dllcall(g_.pCreateProcessW, ptr, p1, ptr, p2, ptr, p3, ptr, p4, uint, p5, uint, p6
		                                 ;, ptr, p7, ptr, p8, ptr, p9, ptr, p10)			
	
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)
	dllcall("SendMessageW", ptr, g_.cfg.script_hwnd, uint, 0x4a, uint, 0, ptr, &CopyDataStruct) 		
	
	logerr("CreateProcess " " lpApplicationName:" strget(p1, encode) " lpCommandLine:" strget(p2,  encode) " trgt: " trgt " args: " args)	
	if (A_eventinfo)	
	{
		if (p1)
		r := dllcall(g_.pCreateProcessW, str, t, str, args, ptr, p3, ptr, p4, uint, 1, uint, p6|(CREATE_SUSPENDED := 0x00000004)
		                               , ptr, p7, ptr, p8, ptr, p9, ptr, p10)	
		else 
		r := dllcall(g_.pCreateProcessW, ptr, 0, str, args, ptr, p3, ptr, p4, uint, 1, uint, p6|(CREATE_SUSPENDED := 0x00000004)
		                               , ptr, p7, ptr, p8, ptr, p9, ptr, p10)						
	} else {
		if (p1)
		r := dllcall(g_.pCreateProcessA, astr, t, astr, args, ptr, p3, ptr, p4, uint, 1, uint, p6|(CREATE_SUSPENDED := 0x00000004)
		                               , ptr, p7, ptr, p8, ptr, p9, ptr, p10)	
		else 
		r := dllcall(g_.pCreateProcessA, ptr, 0, astr, args, ptr, p3, ptr, p4, uint, 1, uint, p6|(CREATE_SUSPENDED := 0x00000004)
		                               , ptr, p7, ptr, p8, ptr, p9, ptr, p10)		
	}	
	if !r
	return r		
				
	g_.hChildProcess                 := numget(p10+0, 0, "ptr")
	g_.hChildProcessId               := numget(p10+0, A_ptrsize*2, "ptr")
	g_.hChildProcessThread           := numget(p10+0, A_ptrsize, "ptr")
	g_.ChildProcessThreadID          := numget(p10+0, (A_ptrsize*2)+4, "ptr")	
	
	dllcall("SendMessageW", ptr, g_.cfg.script_hwnd, uint, dllcall("RegisterWindowMessageW", str, "Peixoto.Hwnd")
	, uint, g_.ChildProcessThreadID, uint, g_.hChildProcessId) 
	return r
}

Is64Bit(trgt)
{
	r := dllcall("GetBinaryType", astr, trgt, "uint*", btype)	
	if (btype = 6)
		return true
}