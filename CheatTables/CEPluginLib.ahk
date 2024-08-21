/*
    start: 1000000000
    stop:  1500000000
    or
    start: 9000000000
    stop:  9500000000    
*/


CEFuncs.Init()

class CELib_Process
{
    __new(Proc)
    {
        this.hProc := DllCall("OpenProcess", uint, 0x0438, uint, 0, uint, this.ProcID(Proc), ptr)  
        if (this.hProc = 0)       
        return ""    
    }
    
    __delete()
    {
        dllcall("CloseHandle", ptr, this.hProc)
    }
    
    ReadBytes(byref bytes, size, adress)
    {	
        dllcall("ReadProcessMemory", ptr, this.hProc, ptr, adress, ptr, &bytes, uint, size, "uint*", bytes_read:=0, uint)
        return bytes_read
    }
    
    read(DataType, Size, Addss)
    {
        dllcall("ReadProcessMemory", ptr, this.hProc, ptr, Addss, DataType "*", Value, uint, Size, "uint*", BytesRead:=0)
        return Value
    }
    
    Write(DataType, Size, Addss, Value)
    {
        dllcall("WriteProcessMemory", ptr, this.hProc, ptr, Addss, DataType "*", Value, uint, Size, "uint*", BytesWritten:=0)     
    }
    
    ProcID(Proc)
    {
        PROCENTRY32 =
        (LTRIM
        DWORD     dwSize;
        DWORD     tUsage;
        DWORD     ProcessID;
        ULONG_PTR DefaultHeapID;
        DWORD     ModuleID;
        DWORD     Threads;
        DWORD     ParentProcessID;
        LONG      PriClassBase;
        DWORD     Flags;
        CHAR      ExeFile[260];
        ) 
        PROCENTRY32        := struct(PROCENTRY32)  
        PROCENTRY32.dwSize := PROCENTRY32.size()  
        foo                := "Process32First"
        h                  := dllcall("CreateToolhelp32Snapshot", "uint", 0x00000002, uint, 0, ptr)
        success            := true
        
        while (success)
        {
            success := dllcall(foo, "Ptr", h, "Ptr", PROCENTRY32[])
            name    := strget(PROCENTRY32[] + PROCENTRY32.offset("ExeFile"), "CP0")
            foo     := "Process32Next"                    
            if (name = Proc)
            return this._ID := PROCENTRY32.ProcessID               
        }
    }
    VirtualQueryEx(base_address)
    {
        Varsetcapacity(MEMORY_BASIC_INFORMATION, (A_ptrsize=4)?28:48)
        success := dllcall("VirtualQueryEx", ptr, this.hProc, ptr, base_address, ptr, &MEMORY_BASIC_INFORMATION, uint, (A_ptrsize=4)?28:48, uint)
                      
        if not success
        return False            
        
        return {"BaseAdd"      : numget(MEMORY_BASIC_INFORMATION, 0, "ptr")
               ,"AllocProtect" : numget(MEMORY_BASIC_INFORMATION, 16, "uint")
               ,"Sz"           : numget(MEMORY_BASIC_INFORMATION, 24, "uint")
               ,"CrrntProtect" : numget(MEMORY_BASIC_INFORMATION, 36, "uint") }        
    }
    Pages(Min, Max)
    {
        pages  := []
        MemNfo := this.VirtualQueryEx(Min)
        while (Min<Max)
        {
            if (MemNfo.Sz=0)
                break
            pages.push( MemNfo )
            Min    := MemNfo.BaseAdd + MemNfo.Sz
            MemNfo := this.VirtualQueryEx(Min)              
        }	        
	    return pages           
    }
    Module(module)
    {
        dllcall("Psapi.dll\EnumProcessModulesEx", ptr, this.hProc, ptr, 0, uint, 0, "uint*", need, uint, 3), VarSetCapacity(pHModules, need)
        dllcall("Psapi.dll\EnumProcessModulesEx", ptr, this.hProc, ptr, &pHModules, uint, need, "uint*", need, uint, 3)
        VarSetCapacity(ModName, 1122) ; MAX_PATH in wchar_t characters. Realistic for any module name        
        loop, % need/A_ptrsize
        {
            idx  := A_index-1
            hMod := numget(&pHModules + idx*A_ptrsize "ptr")
            dllcall("Psapi.dll\GetModuleBaseNameW", ptr, this.hProc, ptr, hMod, ptr, &ModName, uint, 1122)
            if (strget(&ModName+0, "UTF-16") = module)
            {
                ModNfo := struct("LPVOID BaseOfDll; DWORD SizeOfImage; LPVOID EntryPoint;")
                dllcall("Psapi.dll\GetModuleInformation", ptr, this.hProc, ptr, hMod, ptr, ModNfo[], uint, ModNfo.size())                
                return {"Name" : module, "BaseAdd" : ModNfo.BaseOfDll, "Sz" : ModNfo.SizeOfImage}
            }
        }       
    }
    Scan(Bytes, Module="", MinAdd=0)
    {        
        if Module
        {
            Mdl := this.Module(Module)
            if not Mdl
            return "M " Module
            
            min := Mdl.BaseAdd
            max := min+Mdl.Sz
        } else {        
            varsetcapacity(SNfo, (A_ptrsize=4) ? 36 : 48)
            dllcall("GetSystemInfo", "ptr", &SNfo)
            dllcall("IsWow64Process", ptr, this.hProc, "uint*", IsWow64:=0)
            
            min := numget(SNfo, 8, "ptr")
            max := numget(SNfo, 8+A_ptrsize, "ptr")
            if (IsWow64 && max>0xffffffff)
            max := 0xffffffff
        }        
        str   := "Pages`n"             
        pages := this.Pages(min, max)
                       
        if not isobject(pages)
		return "P " 
	
        bytes := strsplit(bytes, " ")  
        size  := bytes.MaxIndex() 
        VarSetCapacity(buff, size)
        loop, % size
        {
            Numput("0x" bytes[A_index], &buff, A_index - 1, "uchar")
            FileOpen("*", "w").WriteLine( numget(&buff+A_index-1, "uchar") )   
        }
                    
        for k, v in pages
        {
            Varsetcapacity(pagemem, v.sz) 		
            r := this.ReadBytes(pagemem, v.sz, v.BaseAdd)                           
            s := dllcall("peixoto64.dll\sigscan", ptr, &pagemem, uint, v.sz, ptr, &buff, uint, size, ptr)                       
            Varsetcapacity(pagemem, 0)			
            if (s > 0)			
                return v.BaseAdd + s
        }	
     }
}

CETrainer_OnClose(form)
{
    dllcall(CEFuncs.f.object_destroy, ptr CETrainer.win)
    dllcall(CEFuncs.f.object_destroy, ptr CETrainer.memo)    
    return 1  
}

class CETrainer
{
    __init()
    {
       ; msgbox % dllcall("peixoto64.dll\CEPlugin_GetModuleNames", "str")
        for k, v in strsplit(dllcall("peixoto64.dll\CEPlugin_GetModuleNames", "str"), " ")
        {
            if (instr(v, "lua")=1)
            {
                h_lua                := dllcall("GetModuleHandleA", astr, v, ptr)
                this.lua_getglobal   := dllcall("GetProcAddress", ptr, h_lua, astr, "lua_getglobal", ptr)
                this.lua_pcallk      := dllcall("GetProcAddress", ptr, h_lua, astr, "lua_pcallk", ptr)
                this.lua_pushnumber  := dllcall("GetProcAddress", ptr, h_lua, astr, "lua_pushnumber", ptr)  ; always double              
                this.lua_isnumber    := dllcall("GetProcAddress", ptr, h_lua, astr, "lua_isnumber", ptr)
                this.lua_tonumberx   := dllcall("GetProcAddress", ptr, h_lua, astr, "lua_tonumberx", ptr)   ; always double    
                this.lua_pushstring  := dllcall("GetProcAddress", ptr, h_lua, astr, "lua_pushstring", ptr)                
                this.lua_isstring    := dllcall("GetProcAddress", ptr, h_lua, astr, "lua_isstring", ptr)
                this.lua_tolstring   := dllcall("GetProcAddress", ptr, h_lua, astr, "lua_tolstring", ptr)
                this.lua_settop      := dllcall("GetProcAddress", ptr, h_lua, astr, "lua_settop", ptr)
                this.lua_pop         := dllcall("GetProcAddress", ptr, h_lua, astr, "lua_pop", ptr)
                
                ;msgbox % h_lua " . " this.lua_getglobal " . " this.lua_pcallk " . " this.lua_pushnumber " . " this.lua_isnumber 
                ;s. " . " this.lua_tonumberx " . " this.lua_pushstring " . " this.lua_isstring " . " this.lua_tolstring  " . " this.lua_settop  "..."
            }
        } 
        return this       
    }
    Open(name)
    {
        this.Lua("openProcess", 0, [name])
    }
    Lua(func, rcount=0, args="")
    {
        L := dllcall(CEFuncs.f.GetLuaState, ptr)
        F := dllcall(this.lua_getglobal, ptr, L, astr, func, int)
        for k, v in args
        {
            if v is not number
            dllcall(this.lua_pushstring, ptr, L, astr, v)
            else dllcall(this.lua_pushnumber, ptr, L, double, v)
        }
        dllcall(this.lua_pcallk, ptr, L, uint, args.Length(), uint, rcount, uint, 0, ptr, 0)
        if (rcount)
        {
            ret := []
            loop %rcount%
            {
                if (dllcall(this.lua_isnumber, ptr, L, int, -1))
                    r := dllcall(this.lua_tonumberx, ptr, L, int, -1, int, 0, int)
                else if (dllcall(this.lua_isstring, ptr, L, int, -1))
                    r := dllcall(this.lua_tolstring, ptr, L, int, -1, str)
                ret.insert(r)
                dllcall(this.lua_pop, ptr, L, int, 1)
            }
        }
    }
    TrainerLoop(Proc, interval=30)
    {
        this.voice        := ComObjCreate("SAPI.SpVoice")	
        CETrainer.OnClose := RegisterCallback("CETrainer_OnClose", "F")
        this.proc_name    := Proc
        Loop
        {
            this.table_help := new CEEntry("Table Help")
            while (IsObject(this.p) = 0)
            {
                this.p := new CELib_Process(Proc)
                this.ShowHelp()
                sleep, %interval%   
            }
            
            this.reset()
            Loop
            {
                this.ShowHelp()
                this.OnLoop()
                
                sleep, %interval%                
                Process, exist, %Proc%
                if (errorlevel = 0)
                break
            }
            dllcall(CEFuncs.f.closeCE)
            ;dllcall("ExitProcess", uint, 0)
            exitapp
        }
    } 
    keyevent(key)
    {
        static state := {}
        state[key] ?: state[key] := getkeystate(key, "p") ? 1 : -1
        
        prv        := state[key]
        crr        := getkeystate(key, "p") ? 1 : -1
        state[key] := crr	
        return crr!=prv ? crr : 0	
    }
    ShowHelp()
    {
        if ! (this.table_help.Event(True))
        return

        size := StrSplit(CETrainer.help, "`n")[1]
        w    := StrSplit(size, "x")[1]
        h    := StrSplit(size, "x")[2]
        txt  := StrReplace(trim(CETrainer.help), size, "")
        txt  := StrReplace(txt, "`n", " `n")
                
        this.ShowText(w, h, A_scriptname, txt)            
    }
    ShowText(w, h, title, text)
    {
        CETrainer.win  := dllcall(CEFuncs.f.createform, ptr)
        CETrainer.memo := dllcall(CEFuncs.f.creatememo, ptr, CETrainer.win, ptr)
        dllcall(CEFuncs.f.control_setCaption, ptr, CETrainer.memo, astr, text)
        dllcall(CEFuncs.f.control_setCaption, ptr, CETrainer.win, astr, title)  
        dllcall(CEFuncs.f.control_setSize, ptr, CETrainer.win, int, w, int, h)
        dllcall(CEFuncs.f.control_setSize, ptr, CETrainer.memo, int, w-10, int, h-10)
        dllcall(CEFuncs.f.control_setPosition, ptr, CETrainer.memo, int, 5, uint, 5)                
        dllcall(CEFuncs.f.form_centerScreen, ptr, CETrainer.win)
        dllcall(CEFuncs.f.form_show, ptr, CETrainer.win)        
        dllcall(CEFuncs.f.form_OnClose, ptr, CETrainer.win, ptr, CETrainer.OnClose)  
    }
    Mono()
    {
        s:=
        (LTRIM
        "[ENABLE]
        {$lua}
        mono_initialize() 
        LaunchMonoDataCollector()               
        [DISABLE]        
        "
        )
        return dllcall(CEFuncs.f.AutoAssemble, astr, StrReplace(s, "?", this.proc_name), uint)      
    }
    Speak(t)
	{
		text :=
		(LTRIM
		"<speak version='1.0'
		xml:lang='en-US'>
		{}
		</speak>"
		)
		this.voice.Speak(StrReplace(text,"{}",t), 1)
	}
    PlaySound(e)
    {
        sound := e = 1 ? A_windir "\media\Windows Foreground.wav" : (e = 0) ? A_windir "\media\Windows Ding.wav" 
        :  A_windir "\media\Windows Critical Stop.wav" 	
        soundplay, % sound
    }
    UByte(addss){
        return this.p.read("uchar", 1, addss)
    }
    WriteUByte(addss, val){
        this.p.write("uchar", 1, addss, val)
    }
    Byte(addss){
        return this.p.read("char", 1, addss)
    }
    WriteByte(addss, val){
        this.p.write("char", 1, addss, val)
    }
    WriteShort(addss, val){
        this.p.write("Short", 2, addss, val)
    }
    Short(addss){
        return this.p.read("Short", 2, addss)
    }
    WriteUShort(addss, val) {
        this.p.write("UShort", 2, addss, val)
    }
    UShort(addss){
        return this.p.read("UShort", 2, addss)
    }
    WriteInt(addss, val){
        this.p.write("Int", 4, addss, val)
    }
    Int(addss){
        return this.p.read("Int", 4, addss)
    }
    WriteUInt(addss, val){
        this.p.write("uint", 4, addss, val)
    }
    Uint(addss){
        return this.p.read("Uint", 4, addss)
    }
    WriteFloat(addss, val){
        this.p.write("Float", 4, addss, val)
    }
    Float(addss){
        return this.p.read("Int", 4, addss)
    }
    WriteInt64(addss, val) {
        this.p.write("int64", 8, addss, val)
    }
    Int64(addss){
        return this.p.read("int64", 8, addss)
    }
    WriteUint64(addss, val){
        this.p.write("uint64", 8, addss, val)
    }
    UInt64(addss){
        return this.p.read("uint64", 8, addss)
    }
    WriteDouble(addss, val){
        this.p.write("Double", 8, addss, val)
    }
    Double(addss){
        return this.p.read("Int", 8, addss)
    }
}

class CEEntry 
{
    __New(entry) {
        this.entry      := dllcall(CEFuncs.f.getTableEntry, astr, entry, "ptr")  
        this.value_type := dllcall(CEFuncs.f.memrec_getType, ptr, this.entry, int)
        this.state      := dllcall(CEFuncs.f.memrec_isfrozen, ptr, this.entry, uint)        
    }    

    IsFrozen() {
        return dllcall(CEFuncs.f.memrec_isfrozen, ptr, this.entry, uint)
    }

    SetFrozen(state, nosound=False)
    {
        if (state = this.IsFrozen())
            return state ? False : True
        
        state ? dllcall(CEFuncs.f.memrec_freeze, ptr, this.entry, uint, state) 
        : dllcall(CEFuncs.f.memrec_Unfreeze, ptr, this.entry)
        this.state := state
        
        if not nosound
            CETrainer.PlaySound(state ? 1 : -1)  
        
        return state ? False : True
    }

    Toogle(txt)
    {
        state     := this.IsFrozen() ? 0 : 1
        new_state := this.SetFrozen(state, True) 
        return new_state ? txt " Deactivated" : txt " Activated"
    }
   
    Event(toggle="")
    {
        prv        := this.state
        crr        := dllcall(CEFuncs.f.memrec_isfrozen, ptr, this.entry, int)   
        this.state := crr      
        if (toggle)
        this.SetFrozen(0, True)
        e := crr && !prv ? 1 : prv && !crr ? -1 : 0
        if (e)
        CETrainer.PlaySound(e)    
        return e
    } 

    GetValue(size)
    {
        VarSetCapacity(val, size)
        dllcall(CEFuncs.f.memrec_getValue, ptr, this.entry, "ptr", &val, int, size)
        return strget(&val, "CP0")        
    }
    
    SetValue(val)
    {
        dllcall(CEFuncs.f.memrec_setValue, ptr, this.entry, astr, val)
    }
} 

class CEFuncs 
{
    Init() 
    {
        hPeixoto    := dllcall("GetModuleHandle", str, "peixoto64.dll", ptr)
        pGetCEFuncs := dllcall("GetProcAddress", ptr, hPeixoto, astr, "CEPlugin_GetCEFuncs", ptr)
       
        ExportedFunctions = 
        (LTRIM 
        void ShowMessage; 
        void RegisterFunction; 
        void UnregisterFunction;
        PULONG OpenedProcessID; 
        PHANDLE OpenedProcessHandle; 

        void GetMainWindowHandle; 
        void AutoAssemble;
        void Assembler; 
        void Disassembler; 
        void ChangeRegistersAtAddress; 
        void InjectDLL; 
        void FreezeMem; 
        void UnfreezeMem; 
        void FixMem; 
        void ProcessList; 
        void ReloadSettings; 
        void GetAddressFromPointer; 

        PVOID ReadProcessMemory;			
        PVOID WriteProcessMemory;			
        PVOID GetThreadContext;			//   ...
        PVOID SetThreadContext;			//   ...
        PVOID SuspendThread;				//   ...
        PVOID ResumeThread;				//   ...
        PVOID OpenProcess;				//   ...
        PVOID WaitForDebugEvent;			//   ...
        PVOID ContinueDebugEvent;			//   ...
        PVOID DebugActiveProcess;			//   ...
        PVOID StopDebugging;				//   ...
        PVOID StopRegisterChange;			//   ...
        PVOID VirtualProtect;				//   ...
        PVOID VirtualProtectEx;			//   ...
        PVOID VirtualQueryEx;				//   ...
        PVOID VirtualAllocEx;				//   ...
        PVOID CreateRemoteThread;			//   ...
        PVOID OpenThread;					//   ...
        PVOID GetPEProcess;				//   ...
        PVOID GetPEThread;				//   ...
        PVOID GetThreadsProcessOffset;	//   ...
        PVOID GetThreadListEntryOffset;	//   ...
        PVOID GetProcessnameOffset;		//   ...
        PVOID GetDebugportOffset;			//   ...
        PVOID GetPhysicalAddress;			//   ...
        PVOID ProtectMe;					//   ...
        PVOID GetCR4;						//   ...
        PVOID GetCR3;						//   ...
        PVOID SetCR3;						//   ...
        PVOID GetSDT;						//   ...
        PVOID GetSDTShadow;				//   ...
        PVOID setAlternateDebugMethod;	//   ...
        PVOID getAlternateDebugMethod;	//   ...
        PVOID DebugProcess;				//   ...
        PVOID ChangeRegOnBP;				//   ...
        PVOID RetrieveDebugData;			//   ...
        PVOID StartProcessWatch;			//   ...
        PVOID WaitForProcessListData;		//   ...
        PVOID GetProcessNameFromID;		//   ...
        PVOID GetProcessNameFromPEProcess;//   ...
        PVOID KernelOpenProcess;			//   ...
        PVOID KernelReadProcessMemory;	//   ...
        PVOID KernelWriteProcessMemory;	//   ...
        PVOID KernelVirtualAllocEx;		//   ...
        PVOID IsValidHandle;				//   ...
        PVOID GetIDTCurrentThread;		//   ...
        PVOID GetIDTs;					//   ...
        PVOID MakeWritable;				//   ...
        PVOID GetLoadedState;				//   ...
        PVOID DBKSuspendThread;			//   ...
        PVOID DBKResumeThread;			//   ...
        PVOID DBKSuspendProcess;			//   ...
        PVOID DBKResumeProcess;			//   ...
        PVOID KernelAlloc;				//   ...
        PVOID GetKProcAddress;			//   ...
        PVOID CreateToolhelp32Snapshot;	//   ...
        PVOID Process32First;          	//   ...
        PVOID Process32Next;           	//   ...
        PVOID Thread32First;           	//   ...
        PVOID Thread32Next;            	//   ...
        PVOID Module32First;           	//   ...
        PVOID Module32Next;            	//   ...
        PVOID Heap32ListFirst;         	//   ...
        PVOID Heap32ListNext;          	//   ...
                  
        PVOID mainform;
        PVOID memorybrowser; 

        PVOID sym_nameToAddress;
        PVOID sym_addressToName;
        PVOID sym_generateAPIHookScript;

        void loadDBK32;
        void loaddbvmifneeded;
        void previousOpcode;
        void nextOpcode;
        void disassembleEx;
        void loadModule;
        void aa_AddExtraCommand;
        void aa_RemoveExtraCommand;

        void createTableEntry;
        void getTableEntry;
        void memrec_setDescription;
        void memrec_getDescription;
        void memrec_getAddress;
        void memrec_setAddress;
        void memrec_getType;
        void memrec_setType;
        void memrec_getValue;
        void memrec_setValue;
        void memrec_getScript;
        void memrec_setScript;
        void memrec_isfrozen;
        void memrec_freeze;
        void memrec_unfreeze;
        void memrec_setColor;
        void memrec_appendtoentry;
        void memrec_delete;

        void getProcessIDFromProcessName;
        void openProcessEx;
        void debugProcessEx;
        void pause;
        void unpause;

        void debug_setBreakpoint;
        void debug_removeBreakpoint;
        void debug_continueFromBreakpoint;

        void closeCE;
        void hideAllCEWindows;
        void unhideMainCEwindow;
        void createForm;
        void form_centerScreen;
        void form_hide;
        void form_show;
        void form_onClose;

        void createPanel;
        void createGroupBox;
        void createButton;
        void createImage;
        void image_loadImageFromFile;
        void image_transparent;
        void image_stretch;

        void createLabel;
        void createEdit;
        void createMemo;
        void createTimer;
        void timer_setInterval;
        void timer_onTimer;
        void control_setCaption;
        void control_getCaption;
        void control_setPosition;
        void control_getX;
        void control_getY;
        void control_setSize;
        void control_getWidth;
        void control_getHeight;
        void control_setAlign;
        void control_onClick;

        void object_destroy;
        void messageDialog;
        void speedhack_setSpeed;  

        VOID ExecuteKernelCode;
        VOID UserdefinedInterruptHook;
        VOID GetLuaState;
        VOID MainThreadCall;	
        )
        str := "//   ..."
        stringreplace, ExportedFunctions, ExportedFunctions, %str%, ,All
        this.f   := struct(ExportedFunctions)
        this.f[] := dllcall(pGetCEFuncs, ptr)+8               
    } 
} 