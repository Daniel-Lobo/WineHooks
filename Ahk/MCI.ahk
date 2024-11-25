if (parsecfg(g_.cfg.WNMM).MCI)
{
    g_.MCILoger  := new Loger(g_.cfg.injector_dir "\WinMM.log")	  

    g_.MCILoger.log("mciSendCommand hook " . InstallHook(IsFunc("AltMCISndComdA") ? "AltMCISndComdA" : "MCISndComdA", pMCISndComdA, "Winmm.dll", "mciSendCommandA"))
    g_.pMCISndComdA := pMCISndComdA

    g_.MCILoger.log("mciSendString hook " . InstallHook(IsFunc("AltMciSendStringA") ? "AltMciSendStringA" : "MciSendStringA", pMciSendStringA, "Winmm.dll", "mciSendStringA"))
    g_.pMciSendStringA := pMciSendStringA

    g_.MCILoger.log("auxOutSetVolume hook " . InstallHook(IsFunc("AltAUXSetVol") ? "AltAUXSetVol" : "AUXSetVol", pAUXSetVol, "Winmm.dll", "auxSetVolume"))
    g_.pAUXSetVol := pAUXSetVol

    g_.MCILoger.log("auxOutGetVolume hook " . InstallHook(IsFunc("AltAUXGetVol") ? "AltAUXGetVol" : "AUXGetVol", pAUXGetVol, "Winmm.dll", "auxGetVolume"))
    g_.pAUXGetVol := pAUXGetVol

    g_.MCILoger.log("auxGetNumDevs hook " . InstallHook(IsFunc("AltAUXGetDevs") ? "AltAUXGetDevs" : "AUXGetDevs", pAUXGetDevs, "Winmm.dll", "auxGetNumDevs"))
    g_.pAUXGetDevs := pAUXGetDevs

    g_.MCILoger.log("auxGetDevCaps hook " . InstallHook(IsFunc("AltAUXGetCaps") ? "AltAUXGetCaps" : "AUXGetCaps", pAUXGetCaps, "Winmm.dll", "auxGetDevCapsA"))
    g_.pAUXGetCaps := pAUXGetCaps

    g_.p.SndMsg  := dllcall("GetProcAddress", uint, dllcall("GetModuleHandleA", astr, "User32.dll", uint), astr, "SendMessageW")		
    g_.p.SndNMsg := dllcall("GetProcAddress", uint, dllcall("GetModuleHandleA", astr, "User32.dll", uint), astr, "SendNotifyMessageW")	
    
    dllcall("Peixoto.dll\InitWinMMHooks", uint, g_.cfg.script_hwnd, uint, 0)
}

MCISndComdA(p1, p2, p3, p4)
{
    /* MCI_MODE_NOT_READY              524
     * MCI_MODE_STOP                   525
     * MCI_MODE_PLAY                   526
     * MCI_MODE_RECORD                 527
     * MCI_MODE_SEEK                   528
     * MCI_MODE_PAUSE                  529
     * MCI_MODE_OPEN                   530
     */
    
    static hEvent, stts := 525, track := 1, lnth:=0, msg:=0, ntf:=0, seek:=0
    , PLAY_PARMS, OPEN_PARMS, STATUS_PARMS, GENERIC_PARMS, tf := 0, wait:=0
    , hook="MCISndComdA: "
    
    if (wait)
    {
        /* If a new command arrives before a play command finishes processing
         * wait for it, or else, autohotkey doesn't call the message handler
         */
        while (! dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 9, uint, 0))
            continue
        wait := 0
    }
	
    if (p2=0x803){              ; Open ===================================================================================================
        OPEN_PARMS    := struct("LONG dwCallback; DWORD wDeviceID; LPCSTR lpstrDeviceType; LPCSTR lpstrElementName; LPCSTR lpstrAlias")
        PLAY_PARMS    := struct("DWORD_PTR dwCallback; DWORD dwFrom; DWORD dwTo")
        STATUS_PARMS  := struct("LONG dwCallback; LPVOID dwReturn; DWORD dwItem; DWORD dwTrack")
        GENERIC_PARMS := struct("LONG dwCallback;")
        msg  := dllcall("RegisterWindowMessageW", str, "Peixoto.MCI")
        stts := stts             ; Opening doesn't change the status
        dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 1, uint, 0)
        OPEN_PARMS[]         := p4
        OPEN_PARMS.wDeviceID := 1
        lnth   := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 103, uint, 0)
        hEvent := dllcall("OpenEventW", uint, 0x00100000, uint, 0, str, "Peixoto.MCI")
        g_.MCILoger.log(hook "MCI_OPEN " lnth " tracks, sync: " hEvent)
        return 0
        return dllcall(g_.pMCISndComdA , uint, p1, uint, p2, uint, p3 | 512 , uint, p4)
    }else if (p2=0x80D) {        ; Set ====================================================================================================
        if !(p3 & 0x400)
        return g_.MCILoger.log(hook "MCI_SET can only set the time format")
        if seek
        {
            if (tf=10 && numget(p4+4, "uint")=0)
            seek := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 120, uint, seek&0xff)
        }
        tf := numget(p4+4, "uint")
        if ! (tf = 0 || tf = 10)
        return logerr(hook "MCI_SET time format " tf " not supported")
        g_.MCILoger.log(hook "MCI_SET time format " tf)
        return 0    
    }else if (p2=0x806) {        ; Play ===================================================================================================
        if (!p3)
		return 273               ; MCIERR_MISSING_PARAMETER
        stts             := 526
        PLAY_PARMS[]     := p4        
        (p3 & 0x1) ? ntf := PLAY_PARMS.dwCallback
               
        if (p3 & 0x04)
		from := PLAY_PARMS.dwFrom
        else if (seek)
       	from := seek
        else
        from := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 102, uint, 0)
        to   := (p3 & 0x08) ? (PLAY_PARMS.dwTo) : lnth
        seek := 0
        
        dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 6, uint, from) 
        dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 7, uint, to)   
        if (tf = 0)
        dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 3, uint, 0)   
        ; Ask notification if PLAY_PARMS.dwCallback is not zero even without the MCI_NOTIFY fllag
        dllcall(g_.p.SndNMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 8, uint, PLAY_PARMS.dwCallback) 
        wait := 1     
        g_.MCILoger.log(hook "MCI_PLAY from " from " to " to ", seek " seek " callback " PLAY_PARMS.dwCallback)   
        return 0 
    }else if (p2=0x0808) {      ; Stop ====================================================================================================
        ;stts            := 525
        g_.MCILoger.log(hook "MCI_STOP")   
        GENERIC_PARMS[] := p4
        dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 4, uint, (p3 & 1) ? GENERIC_PARMS.dwCallback : 0)        
        return
    }else if (p2=0x809) {      ; Pause ====================================================================================================
        stts            := 529        
        GENERIC_PARMS[] := p4  
        g_.MCILoger.log(hook "MCI_PAUSE")   
        dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 4, uint, (p3 & 1) ? GENERIC_PARMS.dwCallback : 0)     
        return    
    }else if (p2=0x814) {      ; Status ====================================================================================================
        STATUS_PARMS[] := p4
        if (p3 & 0x100){       ; STATUS_PARMS.dwItem contains the status to return =========================================================
            i := STATUS_PARMS.dwItem
            if (p3 & 0x10)     ; Return status for track:  STATUS_PARMS.dwTrack  ===========================================================
            {
                if (i = 1)     ; Track lenth
                {
                    if (tf = 0)
                         r := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 110, uint, STATUS_PARMS.dwTrack)
                   	else r := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 11, uint, STATUS_PARMS.dwTrack)
                    STATUS_PARMS.dwReturn := r
                    g_.MCILoger.log(hook "MCI_STATUS: Track[" STATUS_PARMS.dwTrack "] lenth " r)  
                    return
                }
                else if (i = 2) ; Track position, only handled for milisseconds
                {
                    if (tf = 0)
                    {
                        r := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 120, uint, STATUS_PARMS.dwTrack)
                        STATUS_PARMS.dwReturn := r
                        g_.MCILoger.log(hook "MCI_STATUS: Track[" STATUS_PARMS.dwTrack "] position " r)  
                        return
                    }
                    g_.MCILoger.log(hook "MCI_STATUS: Track[" STATUS_PARMS.dwTrack "] position (unimplemented tf)")  
                }                
            }                  ; Return status for disk:
            if (i = 1)         ; Disk Lenght
				r := lnth
            else if (i = 2)    ; Disk Position
				r := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 102, uint, 0)
            else if (i = 3)    ; Number of tracks
				r := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 103, uint, 0) 
            else if (i = 4){   ; Disk Mode
                if (stts = 526)
                {
                    if dllcall("WaitForSingleObject", uint, hEvent, uint, 0)
                    stts := 526
                    else
                    stts := 525    
                }
                r := stts
            }
            else if (i = 5)    ; Media Present
				r := 1
            else if (i = 7)    ; Ready
				r := 1
            STATUS_PARMS.dwReturn := r
            disk_what := ["Lenght", "Position", "Track count", "Mode", "Present", "Ready"][r]
            g_.MCILoger.log(hook "MCI_STATUS: Disk " disk_what ", " r)  
        } else g_.MCILoger.log(hook "MCI_STATUS: Unsupported " p3 " " p4)  
        return 0
    }else if (p2=0x0804) {     ; Close =====================================================================================================
        stts := stts           ; Closing doesn't change the status
        g_.MCILoger.log(hook "MCI_CLOSE")  
        if ! p3 & 2
        dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 9, uint, 1)
        return
    }else if (p2=0x0807) {     ; Seek ======================================================================================================
        if (stts = 526)
		;return logerr("Can't seek while playing") ;return now breaks asghan
        g_.MCILoger.log(hook "Can't seek while playing")
        else if (p3<>0x08)
		return g_.MCILoger.log(hook "Can only seek to")
        seek := numget(p4+4, "uint")
        g_.MCILoger.log(hook "MCI_SEEK " seek)
        return
    }
    g_.MCILoger.log(hook "MCI command " p2 " not supported ")
    return 0
    return dllcall(g_.pMCISndComdA , uint, p1, uint, p2, uint, p3, uint, p4)
}

MciSendStringA(p1, p2, p3, p4)
{
	static stts := "stopped", track := 1, lnth:=0, msg:=0, ntf:=0, seek:=0, tf="milliseconds"
	cmd := strget(p1+0, "CP0")   
    if instr(cmd, "open")
	{
		msg  := dllcall("RegisterWindowMessageW", str, "Peixoto.MCI")
		stts := stts
		dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 1, uint, 0)
        hEvent := dllcall("OpenEventW", uint, 0x00100000, uint, 0, str, "Peixoto.MCI")
		return 0		
	} 
	else if instr(cmd, "play")
	{
		stts := "play"
		from := strsplit(strsplit(cmd, "from ")[2], " ")[1] + 0
		to   := strsplit(strsplit(cmd, "to ")[2], " ")[1] + 0
		
        dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 6, uint, from) 
        dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 7, uint, to)         
        dllcall(g_.p.SndNMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 8, uint, 0)		
	}
	else if instr(cmd, "stop")
	{
		stts := "stopped"
		dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 4, uint, 0)	
	}
	else if instr(cmd, "status")
	{
		if instr(cmd, "mode")
		{
			if (stts = "play")
			{
				if dllcall("WaitForSingleObject", uint, hEvent, uint, 0)
                stts := "play"
                else
                stts := "stopped"  
			}
			strput(stts, p2+0, "CP0")
		}	
		else if instr(cmd, "position")
        {
            p := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 102, uint, 1)
            strput(p, p2+0, "CP0")
        }
        else if instr(cmd, "length track")
        {
            t := strsplit(cmd, "length track ")[2]   
            if (tf = "milliseconds")
                 l := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 110, uint, t)
            else l := dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 11, uint, t)  
            if (p2)
            strput(l, p2+0, "CP0") 
        }
	}
    else if instr(cmd, "set")
    {
        if instr(cmd, "time format") 
        {
            tf := strsplit(cmd, "time format ")[2]                
        }
    }
	else if instr(cmd, "volume")	
		dllcall(g_.p.SndMsg, uint, g_.cfg.script_hwnd, uint, msg, uint, 3000, uint, trim(strsplit(cmd, "to ")[2]) + 0)			
}

AUXSetVol(p1, p2)
{
	dllcall("SendNotifyMessageW", uint, g_.cfg.script_hwnd, uint, dllcall("RegisterWindowMessageW", str, "Peixoto.MCI"), uint, 1000, uint, p2)
}

AUXGetVol(p1, p2)
{
    v := dllcall("SendMessageW", uint, g_.cfg.script_hwnd, uint, dllcall("RegisterWindowMessageW", str, "Peixoto.MCI"), uint, 2000, uint, p2)
    numput(v, p2+0, "ushort") 
}

AUXGetDevs(){
	return 1
}

AUXGetCaps(p1, p2, p3){
	;cps := struct("WORD wMid; WORD wPid; DWORD vDriverVersion; char szPname[32]; WORD wTechnology; WORD wReserved1; DWORD dwSupport")
	numput(1, p2+40, "ushort")
	numput(0x0002, p2+44, "uint")
	;cps[] := p2
	;cps.wTechnology := 1
	;cps.dwSupport := 1
	return
}