;REMOTE SCRIPT START

global pRegSetValueExA, pWinExec
logerr("RegSetValueExA Hook: " InstallHook("RegSetValueExA", pRegSetValueExA, "Advapi32.dll", "RegSetValueExA"))
logerr("WinExecA Hook: " InstallHook("WinExec", pWinExec, "Kernel32.dll", "WinExec"))

RegSetValueExA(hKey, lpValueName, reserved, dwType, lpData, cbData)
{
	r := dllcall(pRegSetValueExA, uint, hKey, uint, lpValueName, uint, reserved, uint, dwType, uint, lpData, uint, cbData)
	if (dwType=1)
	{
		string := strget(lpData+0, "CP0")
		Logerr("Got string: " string)
		if instr(string, "Windows")
		return r	
		else if (instr(string, g_.cfg.tempdir))
		{
			string := StrReplace(string, g_.cfg.tempdir, g_.cfg.drive "\")
		}
		else if (string = "c:")
		{
			string := g_.cfg.drive
		}		
		else if (string = "c:\")
		{
			string := g_.cfg.drive "\"	
		}
		Logerr("Changed to: " string)		
		return dllcall(pRegSetValueExA, uint, hKey, uint, lpValueName, uint, reserved, uint, dwType, astr, string, uint, strlen(string)+1)
	}
	return r
}

WinExec(p1, p2)
{
	Logerr("WinExec: " strget(p1+0, "CP0"))
	varsetcapacity(SECURITY_ATTRIBUTES, 8 + A_ptrsize)
	varsetcapacity(THREAD_SECURITY_ATTRIBUTES, 8 + A_ptrsize)
	varsetcapacity(PROCESS_INFORMATION, 8 + A_ptrsize * 2) 	
	varsetcapacity(STARTUPINFO, 9*4 + 2*2 + 7*A_ptrsize) 
	numput(9*4 + 2*2 + 7*A_ptrsize, STARTUPINFO, 0 , "uint")	    
   			
	r := dllcall("CreateProcessA", uint, p1, uint, 0, Ptr, &SECURITY_ATTRIBUTES, Ptr, &THREAD_SECURITY_ATTRIBUTES    	
	                             , uint, 0, uint, 0, Ptr, 0, uint, 0, Ptr, &STARTUPINFO, Ptr, &PROCESS_INFORMATION)    
	  
	if (r = 0)
	return dllcall(pWinExec, uint, p1, uint, p2)	

	proc_id :=numget(PROCESS_INFORMATION, A_ptrsize*2, "UInt")
	WinWait, AHK_PID %PROC_ID%, ,2
	sleep, 2
}	