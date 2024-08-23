;REMOTE SCRIPT START 
loop,HKLM,SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList,1,1
{
    if(a_loopRegName="ProfileImagePath"){
		regRead,rProf
    if(inStr(rProf,a_userName))
        stringReplace,SID,a_loopRegSubKey,SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\,,
    }
}
if (instr(g_.cfg.s_FMVfix, "Registry"))
{
	path := g_.cfg.target 
	regwrite, REG_DWORD, HKU, %SID%\SOFTWARE\Microsoft\Direct3D\Shims\EnableOverlays, %path%, 1  
} else {
	RegDelete, HKU, %SID%\SOFTWARE\Microsoft\Direct3D\Shims\EnableOverlays,%path%
	GetDirectShow()
	logerr(IMediaControl.Hook("Run"))
	logerr(IMediaEvent.Hook("GetEvent"))
}

AltIMediaControl_Run(p1)
{	
	GUID_FromString(idd_VideoWindow, dshow.IID_IVideoWindow)
	r := dllcall(IMediaControl.QueryInterface, uint, p1, uint, &idd_VideoWindow, "uint*", pVidwin)
	if r 
		logerr("Failed to create the IVideoWindow interface")
	else logerr("Create the IVideoWindow interface" r)
	VideoWindow := new ComInterfaceWrapper(dshow.IVideoWindow, pVidwin, True)
		
	GUID_FromString(idd_IMediaEvent, dshow.IID_IMediaEvent)
	if dllcall(IMediaControl.QueryInterface, uint, p1, uint, &idd_IMediaEvent, "uint*", pIMediaEvent)
		return "Failed to create the IMediaEvent interface"
	MediaEvent := new ComInterfaceWrapper(dshow.IMediaEvent, pIMediaEvent, True)
	
	dllcall(VideoWindow.SetWindowForeground, uint, VideoWindow.p, int, -1)
	dllcall(VideoWindow.HideCursor, uint, VideoWindow.p, int, -1)
	dllcall(VideoWindow.put_Visible, uint, VideoWindow.p, int, -1)
	while (hidden = 0)
	{
		sleep, 10
		dllcall(VideoWindow.get_Visible, uint, VideoWindow.p, "int*", hidden)
	}	
	cursorhidden := 0
	dllcall(VideoWindow.HideCursor, uint, VideoWindow.p, int, -1)
	while (cursorhidden != -1)
	{
		sleep, 10 
		;setformat, integer, hex
		dllcall(VideoWindow.HideCursor, uint, VideoWindow.p, int, -1, uint)
		dllcall(VideoWindow.IsCursorHidden, uint, VideoWindow.p, "int*", cursorhidden)
	}		
	winget, hwin, id, %wincap%	
	logerr("fullscreen " dllcall(VideoWindow.put_FullScreenMode, uint, VideoWindow.p, int, -1)	)
		
	dllcall(VideoWindow.HideCursor, uint, VideoWindow.p, int, -1)
	dllcall(IMediaControl.Run, uint, p1)	
	while ! (event=0x0001)
	{
		dllcall(IMediaEvent.GetEvent, uint, MediaEvent.p, "uint*", event, "uint*", p1, "uint*", p2, uint, 15)
		if getkeystate("esc", "P") 
			break			
		;XinputGetState(1) 
		;if XINPUT_GAMEPAD_BACK
			;break
	}	
	dllcall(VideoWindow.put_Visible, uint, VideoWindow.p, uint, 0)
	winget, hwin, id, EDEN FMV WINDOW
	logerr("Set ForegroundWindow" dllcall("user32.dll\SetForegroundWindow", uint, hwin))
}	

IMediaEvent_GetEvent(p1, p2, p3, p4, p5)
{
	r := dllcall(IMediaEvent.GetEvent, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
	numput(0x0001, p2+0. "Uint")
	return r
}