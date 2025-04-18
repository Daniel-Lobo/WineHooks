/* Copyright Daniel Lobo, aka Peixoto:
 * dabo.loniel@gmail.com
 */
 
/* 
SafeCallback(callback, options)
{
	
	;0   - E8 ????????           - call [Acquire mutex]
	;+5  - 8F 05 ????????        - pop  [return_add]
	;+11 - E8 ????????           - call [Callback]
	;+16 - 89 05 ????????        - mov  [return_val],eax
	;+22 - E8 ????????           - call [Release mutex]
	;+27 - FF 35 ????????        - push [return_add]
	;+33 - A1 ????????           - mov eax, [return_val]
	;+38 - C3                    - ret 
		
	hdll := dllcall("GetModuleHandle", str, "Peixoto.dll")
	pLockThread := dllcall("GetProcAddress", uint, hdll, astr, "AcquireMutex")
	pUnLockThread := dllcall("GetProcAddress", uint, hdll, astr, "ReleaseMutex")
	;msgbox % pLockThread hdll
	
	pMem := dllcall("VirtualAlloc", uint, 0, uint, 50, int, (MEM_COMMIT := 0x00001000) 
								  , uint, (PAGE_EXECUTE_READWRITE := 0x40))
								  
	VarSetCapacity(call_1, A_Ptrsize)	
	VarSetCapacity(call_2, A_Ptrsize)
	VarSetCapacity(call_3, A_Ptrsize)
	VarSetCapacity(ret_add, A_Ptrsize)	
	VarSetCapacity(ret_val, A_Ptrsize)	
								  
	clbck := RegisterCallback(callback, options)
	numput(pLockThread - (pMem + 5), &call_1+0, "ptr")
	numput(clbck - (pMem + 16), &call_2+0, "ptr")	
	numput(pUnLockThread - (pMem + 27), &call_3+0, "ptr")	
	numput(pMem + 39, &ret_add+0, "ptr")
	numput(pMem + 43, &ret_val+0, "ptr")
	
	numput(0xE8, pMem+0, "uchar"), pMem += 1
	loop, % A_Ptrsize
		numput(numget(&call_1+ A_index-1, "uchar"), pMem + A_index-1)
	pMem -= 1
	
	numput(0x8f, pMem+5, "uchar"), numput(0x05, pMem+6, "uchar"), pMem += 7
	loop, % A_Ptrsize
		numput(numget(&ret_add+ A_index-1, "uchar"), pMem + A_index-1)
	pMem -= 7
	
	numput(0xE8, pMem+11, "uchar"), pMem += 12
	loop, % A_Ptrsize
		numput(numget(&call_2+ A_index-1, "uchar"), pMem + A_index-1)	
	pMem -= 12
	
	numput(0x89, pMem+16, "uchar"), numput(0x05, pMem+17, "uchar"), pMem += 18
	loop, % A_Ptrsize
		numput(numget(&ret_val+ A_index-1, "uchar"), pMem + A_index-1)
	pMem -= 18
	
	numput(0xE8, pMem+22, "uchar"), pMem += 23
	loop, % A_Ptrsize
		numput(numget(&call_3+ A_index-1, "uchar"), pMem + A_index-1)
	pMem -= 23
	
	numput(0xFF, pMem+27, "uchar"), numput(0x35, pMem+28, "uchar"), pMem += 29
	loop, % A_Ptrsize
		numput(numget(&ret_add+ A_index-1, "uchar"), pMem + A_index-1)	
	pMem -= 29
	
	numput(0xA1, pMem+33, "uchar"), pMem += 34
	loop, % A_Ptrsize
		numput(numget(&ret_val+ A_index-1, "uchar"), pMem + A_index-1)	
	pMem -= 34
	
	numput(0xC3, pMem+38, "uchar")	
	return pMem
}
*/

InstallHook(hook_function_name, byref function2hook, dll = "", function2hook_name = ""
           ,callback_options = "F", event_info = "") 
{
	/*Errors
		1: Failed to get the adress of the dll or sethook function (Unlikelly) 
		2: Failed to register the callback for the hook function
		3: Failed to load the specified libray with lasterror = 126 (the especified module
		could not be found(remember that module names are case sensitive)
		4: Failed to load the specified libray with another error code
		5: Failed to get the adress of the function to be hooked (these names are also case sensitive) 
		
		6: detour error calling DetourAttach ERROR_INVALID_HANDLE: "The ppPointer parameter is 
		null or points to a null pointer".  if you are getting the pointer to the funtion to be
		detoured yourself, you are most likely not getting a valid pointer
		8: detour error calling DetourAttach or DetourUpdateThread ERROR_NOT_ENOUGH_MEMORY 
		9: detour error calling DetourAttach ERROR_INVALID_BLOCK: "The function referenced is too 
		small to be detoured". 
		13: detour error calling DetourTransactionCommit ERROR_INVALID_DATA: "Target function was changed
		by third party between steps of the transaction".
		4317: detour error calling DetourTransactionBegin(Most Likely), DetourAttach or 
		DetourTransactionCommit: ERROR_INVALID_OPERATION: "A pending transaction alredy exists". 
		Probably a previous call to sethook did not complete and let a transaction opened.
	*/
	
	static hdtrs = "", sethooks = ""
	if not hdtrs 
		{
			hdtrs  := dllcall("GetModuleHandle", "str", A_Ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll", ptr)
			sethooks := dllcall("GetProcAddress", "ptr", hdtrs, "astr", "sethook", ptr)			
		}	
	
	if not hdtrs  or not sethooks
		return 1	
	
	if hook_function_name is Number	
		hook_function := hook_function_name
	else hook_function := registercallback(hook_function_name, callback_options, "", event_info)
	if not hook_function
		return 2
			
	if ! (dll = "")
		{
			hdll := dllcall("LoadLibrary", str, dll, ptr)
			if not hdll 
				{
					if (A_lasterror = 126)
						return 3
					else return 4
				}			
				function2hook := dllcall("GetProcAddress", "ptr", hdll, "astr", function2hook_name, "ptr")
				
			if not function2hook 
				return 5									
		}	
		
	return dllcall(sethooks, "Ptr*", function2hook, "Ptr", hook_function, int)		
}	

AltInstallHook(hook, byref original)
{
	
	static hdtrs = "", sethooks = ""
	if not hdtrs 
	{
		hdtrs  := dllcall("GetModuleHandle", "str", A_Ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll", ptr)
		sethooks := dllcall("GetProcAddress", "ptr", hdtrs, "astr", "sethook", ptr)				
	}	
	
	if not hdtrs or not sethooks
		return 1	
	
	return dllcall(sethooks, "Ptr*", original, "Ptr", hook)		
}

UnHook(Original, Trampoline)
{
	static hdtrs = "", unhook = ""
	if not hdtrs 
	{
		hdtrs  := dllcall("GetModuleHandle", "str", "peixoto.dll")
		unhook := dllcall("GetProcAddress", "int", hdtrs , "astr", "unhook")			
	}	
	
	if not hdtrs or not unhook
		return 11	
	
	return dllcall(unhook, "Ptr*", Original, "Ptr", Trampoline)	
}
  
InstallComHook(pInterface, byref pHooked, hook_name, offset, release = True)
{
	/*Errors
		1: Failed to get the adress of the dll or sethook function (Unlikelly) 
		2: Failed to register the callback for the hook function		
		6: detour error calling DetourAttach ERROR_INVALID_HANDLE: "The ppPointer parameter is 
		null or points to a null pointer".  if you are getting the pointer to the funtion to be
		detoured yourself, you are most likely not getting a valid pointer
		8: detour error calling DetourAttach or DetourUpdateThread ERROR_NOT_ENOUGH_MEMORY 
		9: detour error calling DetourAttach ERROR_INVALID_BLOCK: "The function referenced is too 
		small to be detoured". 
		13: detour error calling DetourTransactionCommit ERROR_INVALID_DATA: "Target function was changed
		by third party between steps of the transaction".
		4317: detour error calling DetourTransactionBegin(Most Likely), DetourAttach or 
		DetourTransactionCommit: ERROR_INVALID_OPERATION: "A pending transaction alredy exists". 
		Probably a previous call to sethook did not complete and let a transaction opened.
	*/
	
	static hdtrs = "", sethooks = ""
	if not hdtrs 
		{
			hdtrs  := dllcall("GetModuleHandle", "str", "peixoto.dll")
			sethooks := dllcall("GetProcAddress", "int", hdtrs , "astr", "sethook")			
		}	
	
	if not hdtrs  or not sethooks
		return 1	
	
	pInterface_Vtbl := numget(pInterface+0, "Ptr")
	pHooked := numget(pInterface_Vtbl + offset, "Ptr")
		
	pHook := registerCallback(hook_name)
	if not pHook
		return 2
	
	if release
		dllcall(numget(pInterface_Vtbl + 8), "Ptr", pInterface)	; release the interface
	
	return dllcall(sethooks, "Ptr*", pHooked , "Ptr", pHook)	
}

ReleaseHooks()
{
	/*  Unhooking never realy failed with me so it's hard to say how error handling will behave,
		maybe the app will just crash. In anycase, if it fails but doesn't crash the function
		should return [index of the operation that failed, error] if it fails before calling the
		dll function the index is -2	
		
		Errors:
		-1:(index) No hook was set before trying to release them	
		-2:(index) Failed to get the adress of the intruder dll or reload function (Unlikelly) 		
		
		6: detour error calling DetourDetach ERROR_INVALID_HANDLE: "The ppPointer parameter is 
		null or points to a null pointer".  Unlikely because the dll stores the pointer of 
		sucessful operations
		8: detour error calling DetourDetach or DetourUpdateThread ERROR_NOT_ENOUGH_MEMORY 
		9: detour error calling DetourDetach ERROR_INVALID_BLOCK: "The function referenced is too 
		small to be detoured". 
		13: detour error calling DetourTransactionCommit ERROR_INVALID_DATA: "Target function was changed
		by third party between steps of the transaction".
		4317: detour error calling DetourTransactionBegin(Most Likely), DetourDetach or 
		DetourTransactionCommit: ERROR_INVALID_OPERATION: "A pending transaction alredy exists". 
		Probably a previous call to sethook did not complete and let a transaction opened.
	*/			
	static hdll = "", release = ""
	if not hdll 
		{
			hdll  := dllcall("GetModuleHandle", "str", "peixoto.dll")
			release := dllcall("GetProcAddress", "int", hdll, "astr", "ReleaseAllHooks")				
		}
		
	if not hdll or not release
		return [-2, 0]
		
	varsetcapacity(err, 4, 0)
	index := dllcall(release, "int*", &err)	
	return [index, numget(err, 0, "int")]		
}

RedirectCall(_add, _func, options = "F")
{
	callBack := RegisterCallback(_func, options)
	VarSetCapacity(offset, 4)
	numput(callBack - (_add + 5), &offset+0, "int")	
	
	;printl("callBack " callBack " " callBack - (_add + 5))	
	old_protect := 0, dummy := 0
	if not dllcall("VirtualProtect", uint, _add, uint, 4, uint, (PAGE_READWRITE := 0x04), "uint*", old_protect)
		return
	loop, 4
		numput(numget(&offset + A_index - 1, "uchar"), _add + A_index, "uchar")		
	dllcall("VirtualProtect", uint, _add, uint, 4, uint, old_protect, "uint*", dummy)	
	return callBack
}	

RedirectCallD(_add, _func, options = "F")
{
	callBack := RegisterCallback(_func, options)
	VarSetCapacity(offset, 4)
	numput(callBack - (_add + 5), &offset+0, "int")	
	
	static hdtrs = "", sethooks = ""
	if not hdtrs 
		{
			hdtrs  := dllcall("GetModuleHandle", "str", "peixoto.dll")
			sethooks := dllcall("GetProcAddress", "int", hdtrs , "astr", "sethook")			
		}	
	
	if not hdtrs  or not sethooks
		return 1		
		
	return dllcall(sethooks, "Ptr*", _add, "Ptr", callBack)	
}	

/*
getModulePath(exe = "")
{
	A_isDll ? hModule := A_ModuleHandle : hModule := dllcall("GetModuleHandle", uint, 0)
	exe ? hModule := dllcall("GetModuleHandle", uint, 0)
	VarSetCapacity(buff, 260 * 2)
	size := dllcall("GetModuleFileName", uint, hModule, ptr, &buff, int, 260 * 2)	
	return strget(&buff, "UTF-16")	
}	
	
getModuleName(exe = True)
{
	path := getModulePath(exe)
	splitpath, path, filename
	return filename
}	

ahkHookGetScript(resource = "", module = "")
{
	if ( (not A_iscompiled) and (not module) )
	{
		fileread, script, %A_scriptfullpath%
		return script
	}	
	
	resource ? resource := ">AUTOHOTKEY SCRIPT<"
	
	if module 
	{
		splitpath, module, , , ext,
		if (ext = "ahk")
		{
			fileread, script, %module%
			return script
		}
		else hModule := dllcall("LoadLibraryW", str, module)	
	}			
	else hModule := dllcall("GetModuleHandle", uint,  0)	
	
	HRSRC := dllcall("FindResourceW", uint, hModule, str, resource, ptr, 10)
	if ( (HRSRC = 0) and (resource = ">AUTOHOTKEY SCRIPT<") )
		return ahkHookGetScript(">AHK WITH ICON<")	
	
	hResource := dllcall("LoadResource", uint, hModule, uint, HRSRC)
	DataSize := DllCall("SizeofResource", ptr, hModule, ptr, HRSRC, uint)
	pResData := dllcall("LockResource", uint, hResource, ptr)
	return strget(pResData, DataSize, "UTF-8")		
}	
*/