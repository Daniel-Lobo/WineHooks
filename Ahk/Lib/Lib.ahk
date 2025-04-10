#include lib\GUID.ahk
#include lib\DDSFile.ahk

Class ComInterfaceWrapper
{
	__New(byref definition, ppIface, D3D8 = False)
	{
		this.Adds    := {}
		this.offsets := {}
		n            := 0
		def          := definition.def
		loop, parse, def, `n 
		{
			if instr(A_loopfield , "STDMETHOD")
			{				
				method := trim(strsplit(A_loopfield, "(")[2])
				method := strsplit(method, ")")[1]
				if instr(method, ",")
				{
					stringsplit, method_, method,`, 
					method := trim(method_2)
				}
				this.offsets[method] := n * A_ptrsize
				n += 1							
			}	
		}		
			
		pIface := D3D8 ? ppIface : numget(ppIface+0, "ptr")
		if pIface 
		{
			Vtbl := numget(pIface + 0, "Ptr")			
			for k, v in this.offsets
			{
				value        := numget(Vtbl + v, "Ptr")
				this[k]      := value	
				this.Adds[k] := value
			}
		}
			
		this.dwSize        := n*A_ptrsize			
		this.pVTbl         := Vtbl					
		this.p             := pIface	
		this.def           := def
		this.name          := definition.name
		this.released      := False
		this.Hooks         := {}
		this.Mthds         := {}
		this.Hooked        := {}
	}
		
	Hook(Method, hook = "", options = "F", EventInfo="")
	{
		if this.Hooked[Method]
			return this.name "::" Method " is already hooked"	
		
		if not this.pVTbl
			return "Failed to hook " this.name "::" Method " - The interface pointer is not valid"	
						
		hook ?:	hook := isfunc("Alt_" Method) ? "Alt_" Method : isfunc("Alt" this.name "_" Method) 
		? "Alt" this.name "_" Method : this.name "_" Method 
		pHook := registerCallback(hook, options, ,EventInfo)
		if not pHook
			return "Failed to hook " this.name "::" Method " - could not create callback"
		
		pInterface_Vtbl    := this.pVTbl
		pHooked            := numget(pInterface_Vtbl + this.offsets[Method], "Ptr")	
		this.Mthds[Method] := pHooked
		r                  := dllcall(ComInterfaceWrapper.sethooks, "Ptr*", pHooked, "Ptr", pHook)	
		this[Method]       := pHooked
		
		if r
			return "Failed to hook " this.name "::" Method " - detours error " r 
		else 
		{
				this.Hooked[Method] := True
				this.hooks[hook]    := pHook
		}			
		return "Succeeded to hook " this.name "::" Method 
	}	
	
	dllHook(Method, hook, dll = "peixoto.dll")
	{
		if this.Hooked[Method]
			return this.name "::" Method " is already hooked"	
		
		if not this.pVTbl
			return "Failed to hook " this.name "::" Method " - The interface pointer is not valid"							
						
		pHook := dllcall("GetProcAddress", ptr, dllcall("GetModuleHandle", str, dll, ptr), astr, hook, ptr)
		if not pHook
			return "Failed to hook " this.name "::" Method " - could not create callback"
		
		pInterface_Vtbl    := this.pVTbl
		pHooked            := numget(pInterface_Vtbl + this.offsets[Method], "Ptr")	
		this.Mthds[Method] := pHooked
		r                  := dllcall(ComInterfaceWrapper.sethooks, "Ptr*", pHooked, "Ptr", pHook)	
		this[Method]       := pHooked
		
		if r
			return "Failed to hook " this.name "::" Method " - detours error " r
		else 
		{
			this.Hooked[Method] := "dll"
			this.hooks[hook]    := pHook
		}			
		return "Succeeded to hook " this.name "::" Method 
	}

	PatchVtable(method, EventInfo="", HookFunc="")
	{
		table       := this.pVTbl
		target      := table+this.offsets[method]
		if ! (hook := RegisterCallback(HookFunc ? HookFunc :Isfunc("Alt_" Method) ? "Alt_" Method : isfunc("Alt" this.name "_" Method) 
		? "Alt" this.name "_" Method : this.name "_" Method , "F",,EventInfo))
			return "Failed to hook " this.name "::" Method " - could not create callback"
		if ! isobject(p := new Prtct(target, A_ptrsize))
			return "Failed to hook " this.name "::" Method " - VirtualProtect failed"
		numput(hook, table+this.offsets[method], "ptr")
		return "Succeeded to hook " this.name "::" Method 
	}
	
	PatchVtableWithDll(method, hook, dll = "peixoto.dll")
	{
		table  := this.pVTbl
		target := table+this.offsets[method]
		p      := new Prtct(target, A_ptrsize)
		if not (hook := dllcall("GetProcAddress", ptr, dllcall("GetModuleHandle", str, dll, ptr), astr, hook, ptr))
			return "Failed to hook " this.name "::" Method " - could not create callback"
		if ! isobject(p := new Prtct(target, A_ptrsize))
			return "Failed to hook " this.name "::" Method " - VirtualProtect failed"
		numput(hook, table+this.offsets[method], "ptr")
		;dllcall("VirtualProtect", uint, target, uint, 4, uint, old_protect, "uint*", _protect) 	
		return "Succeeded to hook " this.name "::" Method 
	}
	
	__delete()	
	{		
		if not this.released
			dllcall(this.release, uint, this.p, uint)
	}

	__release()
	{	
		this.released := True
		r := dllcall(this.Release, uint, this.p, uint) 
		return r
	}	
		
	UnHook(Method, hook = "")
	{
		logerr("unhook " ComInterfaceWrapper._unhook)
		if not this.Hooked[Method]
			return "Method " Method " is not hooked yet"				
			
		if not hook	
			hook := this.name "_" Method
			
		r := dllcall(ComInterfaceWrapper._unhook, "Ptr*", this.Mthds[Method], "Ptr", this.hooks[hook])	
		if r
			return "Failed to unhook " this.name "::" Method " - detours error " r
		else 
		{
			if not this.Hooked[Method] = "dll"
				DllCall("GlobalFree", "Ptr", this.hooks[hook], "Ptr")
			this.hooks.remove(hook)	
			this.Hooked.remove(Method) 
		}
	    return "Succeeded to unhook " this.name "::" Method 	
	}

	Compare(interfaces)
	{
		r=
		for method, adress in this.adds
		{
			reimp=			
			for k, i in interfaces
			{
				if (i.adds[method] != adress)
					reimp .= i.name "[" i.adds[method] "], "
			}
			if (reimp)
				r .= Trim(this.name "::" method "[" adress "] reimplement in " reimp "`n", ",")
		}
		return Trim(r, "`n")
	}
}

class Memory {
	__new(sz) {
		this.p := dllcall("VirtualAlloc", ptr, 0, ptr, sz, uint, 0x00001000, uint, 0x04) 	
	}
	__delete() {
		dllcall("VirtualFree", ptr, this.p, ptr, 0x00008000, uint, 0x04) 	
	}
}

Class Prtct{
	__new(a, s)
	{
		if !dllcall("VirtualProtect", uint, a, uint, s, uint, 0x04, "uint*", o:=0)
		return 
		this.a := a
		this.s := s
		this.o := o	
	}
	__delete()
	{
		dllcall("VirtualProtect", uint, this.a, uint, this.s, uint, this.o, "uint*", o:=0)
	}
}

Class Collection {

__new(ThreadSafe=False) 
{
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	hdll := dllcall("GetModuleHandle", str, dll, ptr)
	this.pc     := dllcall(dllcall("GetProcAddress", ptr, hdll, astr, "PointerCollectionCreate", ptr), ptr)
	this.vtbl   := struct("LPVOID insert; LPVOID insert_disposable; LPVOID remove; LPVOID discard; LPVOID Value; LPVOID Key; LPVOID ValueAt; LPVOID KeyAt; LPVOID Count")
	this.vtbl[] := numget(this.pc+0, "ptr")
	this.size := 0		
}

_add(key, data){
	return (this.size := dllcall(this.vtbl.Insert_disposable, ptr, this.pc, ptr, key, ptr, data, uint))
}

_Insert(key, memsize)
{
	pData := dllcall("VirtualAlloc", ptr, 0, ptr, memsize, uint, 0x00001000 | 0x00002000, uint, 0x04, ptr)
	dllcall("RtlZeroMemory", ptr, pData, uint, memsize)  							   
								   
	this.size := dllcall(this.vtbl.insert, ptr, this.pc, ptr, key, ptr, pData, uint)
	return pData	
}

PutStr(key, s){
	Strput(s, this._insert(key, strlen(s)+1)+0, "CP0")
}

GetStr(key){
	return Strget(this.value(key)+0, "CP0")
}

Value(key) {
	return dllcall(this.vtbl.Value, ptr, this.pc, ptr, key, ptr)
}

Key(value) {
	return dllcall(this.vtbl.Key, ptr, this.pc, ptr, value, ptr)
}

ValueAt(index) {
	return dllcall(this.vtbl.ValueAt, ptr, this.pc, ptr, index, ptr)
}

KeyAt(index) {
	return dllcall(this.vtbl.KeyAt, ptr, this.pc, ptr, index, ptr)
}

Remove(key) {
	return (this.size := dllcall(this.vtbl.Remove, ptr, this.pc, ptr, key, uint))
}

Discard(key) {
	return (this.size := dllcall(this.vtbl.Discard, ptr, this.pc, ptr, key, uint))
}

Count(){
	return dllcall(this.vtbl.Count, ptr, this.pc)
}
}

keyevent(key, dummy="")
{
	static state := {}
	state[key] ?: state[key] := getkeystate(key, "p") ? 1 :-1
	
	event := False
	newstate := getkeystate(key, "p") ? 1 :-1
	if ( (newstate = 1) and (state[key] = -1)  )
		event := True			
	state[key] := newstate	
	return event	
}	

StringFromIID(pIID)
{	
	dllcall("Ole32.dll\StringFromIID", uint, pIID, "uint*", GUID)
	rtn := StrGet(GUID)  
	dllcall("Ole32.dll\CoTaskMemFree", uint, GUID) 
	return rtn
}	

zeromem(struct){
	varsetcapacity(struct[], struct.size(), 0)	
}
	
newmem(struct){
	VarSetCapacity(st, struct.size(), 0)
	struct[] := &st
}

class Loger 
{
	__new(logpath, maxlogs=1000)
	{
		this.f     := logpath		
		this.hnd   := DllCall("GetStdHandle", "int", -11, ptr)
		this.count := 0
		this.max   := maxlogs
		FileDelete, % logpath
	}
	err(msg)
	{
		fileAppend, %msg%`n, % this.f 
		dllcall("WriteConsole", "ptr", this.hnd, "ptr", &msg, "int", strlen(msg), uint, 0, ptr, 0)
	}
	log(msg)
	{
		if (this.count > this.max)		
		return		
		this.count += 1
		return this.err(msg)
	}
}

logErr(msg){
	static file="", call="", maxlogs = 10
	call += 1
	if not file
	{
		file := strsplit(msg, "|")[1]
		maxlogs := strsplit(msg, "|")[2]
		filedelete, %file%
		return
	} 
	if (call < maxlogs + 2)
		fileAppend, %msg%`n, %file% 	
	printl(msg)
}

Ciclecolor(c)
{
	static clrs := [0x00000000, 0x00FFFFFF, 0x00ff0000, 0x0000ff00, 0x000000ff, 0x00ffff00, 0x00ff00ff
				   ,0x0000ffff, 0x00000000]
	for k, v in clrs
	{
		if (c = v)
		{
			c := clrs[k+1]
			break
		}
	}return c
}	
	
print(msg = "")
{
	static hnd=""
	if ! hnd
	{
		VarSetCapacity(name, 260)
		dllcall("GetModuleFileNameA", ptr, 0, "ptr", &name, int, 260)
		name := strget(&name+0, "CP0")
		splitpath, name, fname
		if !isfunc("CreateProcessA_hook") ;instr(fname, "AutoHotkey")
			DllCall("AllocConsole")
		else DllCall("AttachConsole", uint, (ATTACH_PARENT_PROCESS := -1))
		hnd := DllCall("GetStdHandle", "int", -11, ptr)
	}		
    return dllcall("WriteConsole", "ptr", hnd , "ptr", &msg, "int", strlen(msg), uint, 0, ptr, 0)
}

printl(msg = "") {	
	return msg ? print(msg . "`n") : (g_.cfg.console) ?: DllCall("FreeConsole") 	
}	

Parsecfg(item = "")
{
	if not item
	{
		cfg  := strsplit(g_cmdstring, "^")	
		globals := {}
		globals.cfg := {}
		
		for k, v in cfg
		{
			Key := SubStr(v, 1, 1)
			_Key := SubStr(v, 2, strlen(v)-1)
			if _Key is number
				continue								
			if (Key = "-") 
				globals.cfg[SubStr(v, 2, strlen(v)-1)] := cfg[k + 1]	
			else if (Key = "/")
				globals.cfg[SubStr(v, 2, strlen(v)-1)] := True
		}
		return globals	
	} else {
		cfg := {}
		for k, v in strsplit(item, ";")
		{
			split := strsplit(v, "=")
			key := split[1]
			val := split[2]
			if not split[2]
			{
				;cfg[key] := True
				continue
			}
			(val = "True") ? val := True
			(val = "False") ? val := False
			cfg[key] := val			
		}
		return cfg
	}	
}	

resume()  
{
	if (hThread := dllcall("OpenThread", uint, 0x0002, uint, 0, uint, g_MainThreadID, ptr))
	{
		dllcall("ResumeThread", "ptr", hThread, "uint")
		dllcall("CloseHandle", ptr, hThread)
	} else {
		dllcall("ddraw.dll\ProxyResume")
	}
	dllcall("SendMessageW", uint, g_.cfg.script_hwnd, uint, dllcall("RegisterWindowMessageW", str, "Peixoto.Thread"), uint, 0, uint, 0) 	
}

GetDesktopResolution()
{
	if g_.cfg.DSR
	{
		res := strsplit(g_.cfg.DSR, "x")
		return  {"w" : res[1], "h" : res[2]}
	}
	r := {"w" : dllcall("GetSystemMetrics", uint, 0) , "h" : dllcall("GetSystemMetrics", uint, 1)}
	res := r.w "x" r.h 
	if ( r.w/r.h < 1.33	)
	{
		res := strsplit(g_.cfg.max_4x3_res, "x")
		r := {"w" : res[1], "h" : res[2]}
	}
	return r
}

Desk()
{
	r := strsplit(g_.cfg.DSR ? g_.cfg.DSR : g_.cfg.dsk, "x")
	return {"w" : r[1], "h" : r[2]}	
}

CreateLinksCollection(links)
{
	target_dir := g_.cfg.path
	FileCreateDir, %target_dir%
	for k, v in  links {		
		printl("Simbolic link : " v "-> " target_dir v " Succes= " dllcall("CreateSymbolicLinkW", str, A_workingdir "\" v
		, str, target_dir v, uint, 0, uint) " code= " A_lasterror " "  )
	}
}

FOV(oldfov, ratio)
{
	ratio := strsplit(ratio, ":")
	oldfov *= 0.01745329252 / 2
	return 2 * (ATan(tan(oldfov) * ratio[1]/ratio[2]) * 57.29578)
}

Matrix2String(pMatrix)
{
	D3DMATRIX[] := pMatrix
	str := 	D3DMATRIX.m11 " " D3DMATRIX.m12 " " D3DMATRIX.m13 " " D3DMATRIX.m14 "`n"
	str .= 	D3DMATRIX.m21 " " D3DMATRIX.m22 " " D3DMATRIX.m23 " " D3DMATRIX.m24 "`n"
	str .= 	D3DMATRIX.m31 " " D3DMATRIX.m32 " " D3DMATRIX.m33 " " D3DMATRIX.m34 "`n"
	str .= 	D3DMATRIX.m41 " " D3DMATRIX.m42 " " D3DMATRIX.m43 " " D3DMATRIX.m44 "`n"
	return str	
}

ProcessD3DShader(code, w=0, h=0, tw=1, th=1)
{
	c := ""
	w ? c .= "`n#define w " w "."
	h ? c .= "`n#define h " h "."
	c .= "`n#define tw 1./" tw "."
	c .= "`n#define th 1./" th "."
	return c . "`n" code
}

GetSystemDir(){
	VarSetCapacity(SysDir, 261)
	DllCall("GetSystemDirectoryW", Str, SysDir, UInt, 261)
	return SysDir
}

class Comptr {
	__new(ptr, obj=""){
		this.p   := ptr
		this.obj := obj
	}
	__delete(){
		if (this.obj)
		dllcall(this.obj.release, prt, this.p)
		else dllcall(numget(numget(this.p+0, "ptr")+A_PtrSize*2, "ptr"), prt, this.p) 
	}
}
Release(o){
	return dllcall(numget(numget(o+0, "ptr")+A_PtrSize*2, "ptr"), uint, o)	
}
AddRef(o){
	return dllcall(numget(numget(o+0, "ptr")+A_PtrSize*1, "ptr"), uint, o)	
}
global GUID := "DWORD Data1; WORD  Data2;  WORD  Data3;  BYTE  Data4[8]"