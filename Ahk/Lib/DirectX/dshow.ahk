#include lib\DirectX\Headers\_dshow.ahk

global IGraphBuilder, IVideoWindow, IMediaControl, IBasicVideo, IMediaEvent
GetDirectShow()
{
	pVidwin:=0, pMediaCtrl:=0, pMediaEvent:=0, pBasicVideo:=0
	GUIDFromString := "GUID_FromString"
	pIGraphBuilder := ComObjCreate(dshow.CLSID_FilterGraph, dshow.IID_IGraphBuilder)
	if not pIGraphBuilder
		return "Failed to create the IGraphBuilder interface"
	IGraphBuilder := new ComInterfaceWrapper(dshow.IGraphBuilder, pIGraphBuilder, True)	
	
	%GUIDFromString%(idd_VideoWindow, dshow.IID_IVideoWindow)
	r := dllcall(IGraphBuilder.QueryInterface, uint, pIGraphBuilder, uint, &idd_VideoWindow, "uint*", pVidwin)
	if r 
		return "Failed to create the IVideoWindow interface"
	IVideoWindow := new ComInterfaceWrapper(dshow.IVideoWindow, pVidwin, True)	
	
	%GUIDFromString%(idd_IMediaControl, dshow.IID_IMediaControl)
	if dllcall(IGraphBuilder.QueryInterface, uint, IGraphBuilder.p, uint, &idd_IMediaControl, "uint*", pMediaCtrl)
		return "Failed to create the IMediaControl interface"
	IMediaControl := new ComInterfaceWrapper(dshow.IMediaControl, pMediaCtrl, True)	
	
	%GUIDFromString%(idd_IMediaEvent, dshow.IID_IMediaEvent)
	if dllcall(IGraphBuilder.QueryInterface, uint, IGraphBuilder.p, uint, &idd_IMediaEvent, "uint*", pMediaEvent)
		return "Failed to create the IMediaEvent interface"
	IMediaEvent := new ComInterfaceWrapper(dshow.IMediaEvent, pMediaEvent, True)	
	
	%GUIDFromString%(idd_IBasicVideo, dshow.IID_IBasicVideo)
	if dllcall(IMediaControl.QueryInterface, uint, IMediaControl.p, uint, &idd_IBasicVideo, "uint*", pBasicVideo)
		return "Failed to create the IBasicVideo interface"
	IBasicVideo := new ComInterfaceWrapper(dshow.IBasicVideo, pBasicVideo, True)		
	
	return "Succedeed to create the DirectShow interfaces"
}	

PlayFMV(file, scale=False)
{
	;mix :=  ComObjCreate("{CD8743A1-3736-11d0-9E69-00C04FD7C15B}"  , dshow.IID_IBaseFilter)
	
	pVidwin:=0, pMediaCtrl:=0, pMediaEvent:=0, pBasicVideo:=0
	GUIDFromString := "GUID_FromString"
	if ! (pIGraphBuilder := ComObjCreate(dshow.CLSID_FilterGraph, dshow.IID_IGraphBuilder))
		return "Failed to create the IGraphBuilder interface"
	GraphBuilder := new ComInterfaceWrapper(dshow.IGraphBuilder, pIGraphBuilder, True)
	;msgbox % dllcall(GraphBuilder.AddFilter, uint, GraphBuilder.p, uint, mix, str, "Overlay Mixer")	
	
	
	%GUIDFromString%(idd_VideoWindow, dshow.IID_IVideoWindow)
	r := dllcall(GraphBuilder.QueryInterface, uint, pIGraphBuilder, uint, &idd_VideoWindow, "uint*", pVidwin)
	if r 
		return "Failed to create the IVideoWindow interface"
	VideoWindow := new ComInterfaceWrapper(dshow.IVideoWindow, pVidwin, True)	
	
	%GUIDFromString%(idd_IMediaControl, dshow.IID_IMediaControl)
	if dllcall(GraphBuilder.QueryInterface, uint, GraphBuilder.p, uint, &idd_IMediaControl, "uint*", pMediaCtrl)
		return "Failed to create the IMediaControl interface"
	MediaControl := new ComInterfaceWrapper(dshow.IMediaControl, pMediaCtrl, True)	
	
	%GUIDFromString%(idd_IMediaEvent, dshow.IID_IMediaEvent)
	if dllcall(GraphBuilder.QueryInterface, uint, GraphBuilder.p, uint, &idd_IMediaEvent, "uint*", pIMediaEvent)
		return "Failed to create the IMediaEvent interface"
	MediaEvent := new ComInterfaceWrapper(dshow.IMediaEvent, pIMediaEvent, True)

	%GUIDFromString%(idd_IBasicVideo, dshow.IID_IBasicVideo)
	if dllcall(MediaControl.QueryInterface, uint, MediaControl.p, uint, &idd_IBasicVideo, "uint*", pBasicVideo)
		return "Failed to create the IBasicVideo interface"
	BasicVideo := new ComInterfaceWrapper(dshow.IBasicVideo, pBasicVideo, True)		
		
	if dllcall(GraphBuilder.RenderFile, uint, GraphBuilder.p, str, file, uint, 0)
		return "FMV playback failed, most likely missing the correct codec"
	r := dllcall(VideoWindow.get_Caption, uint, VideoWindow.p, "uint*", Caption , uint) 
	wincap := strget(caption, "UTF-16")
	dllcall(VideoWindow.SetWindowForeground, uint, VideoWindow.p, int, -1)
	dllcall(VideoWindow.put_Visible, uint, VideoWindow.p, int, -1)
	while (hidden = 0)
	{
		sleep, 10
		dllcall(VideoWindow.get_Visible, uint, VideoWindow.p, "int*", hidden)
	}
	
	if dllcall(VideoWindow.put_FullScreenMode, uint, VideoWindow.p, int, -1)
	{
		VarSetCapacity(local_rect, 32)
		hDesktop := dllcall("User32.dll\GetDesktopWindow", uint)
		dllcall("GetWindowRect", uint, hDesktop, uint, &local_rect)  
		dllcall("ReleaseDC", uint, 0, uint, hDesktop)
		winget, winid, ID, %wincap%		
		s := dllcall("GetWindowLong", uint, winid, int, -16, uint)
		s &= ~(0x00C00000 | 0x00040000)
		dllcall("SetWindowLong", uint, hWin, int, -16, uint, s)
		dllcall("SetWindowPos", uint, winid, int, 0, uint, 0, uint, 0, uint, numget(&local_rect+8, "int"), uint, numget(&local_rect+12, "int"), uint, 0x0454)
	}
	
	dllcall(BasicVideo.get_SourceWidth, uint, BasicVideo.p, "int*", w) 
	dllcall(BasicVideo.get_SourceHeight, uint, BasicVideo.p, "int*", h) 
	wingetpos, , , ww, wh, %wincap%	
	DllCall("oleaut32\SysFreeString", "ptr", caption)
	
	if (scale)
	{
		dllcall(BasicVideo.put_DestinationHeight, uint, pBasicVideo, "uint", wh)	
		dllcall(BasicVideo.put_DestinationWidth, uint, pBasicVideo, "uint", wh*w/h)	
		dllcall(BasicVideo.put_DestinationLeft, uint, pBasicVideo, "uint", 0)	
		dllcall(BasicVideo.put_DestinationTop, uint, pBasicVideo, "uint", 0)
	} else {
		dllcall(BasicVideo.put_DestinationHeight, uint, pBasicVideo, "uint", h)	
		dllcall(BasicVideo.put_DestinationWidth, uint, pBasicVideo, "uint", w)	
		dllcall(BasicVideo.put_DestinationLeft, uint, pBasicVideo, "uint", (ww-w)/2)	
		dllcall(BasicVideo.put_DestinationTop, uint, pBasicVideo, "uint", (wh-h)/2)
	}
	
	dllcall(MediaControl.Run, uint, MediaControl.p)
	while ! (event=0x0001)
	{
		dllcall(MediaEvent.GetEvent, uint, MediaEvent.p, "uint*", event, "uint*", p1, "uint*", p2, uint, 15)
		if getkeystate("esc", "P") or ( getkeystate("Alt", "P") and  getkeystate("Tab", "P") )
			break 			
		;XinputGetState(1) 
		;if XINPUT_GAMEPAD_BACK
			;break
	}	
	return file " playback successful"	
}

PlayFMVOnWindow(file, hWin, scale=False)
{
	pIGraphBuilder:=0, pBaseFilter:=0, pFiltercfg9:=0, pWindowlessControl9:=0, pMediaCtrl:=0, pIMediaEvent:=0
	vw:=0, vh:=0, aw:=0, ah:=0, event:=0, p1:=0, p2:=0
	
	GUIDFromString := "GUID_FromString"
	if ! (pIGraphBuilder := ComObjCreate(dshow.CLSID_FilterGraph, dshow.IID_IGraphBuilder))
		return "Failed to create the IGraphBuilder interface"
	GraphBuilder := new ComInterfaceWrapper(dshow.IGraphBuilder, pIGraphBuilder, True)	
	
	if ! (pBaseFilter := ComObjCreate(dshow.CLSID_VideoMixingRenderer9, dshow.IID_IBaseFilter))
		return "Failed to create the IGraphBuilder interface"
	BaseFilter := new ComInterfaceWrapper(dshow.IBaseFilter, pBaseFilter, True)	
	if dllcall(GraphBuilder.AddFilter, uint, pIGraphBuilder, uint, pBaseFilter, str, "VMR9")
		return "Failed to add the Mixer filter"
	
	%GUIDFromString%(idd_Filtercfg9, dshow.IID_IVMRFiltercfg9)
	r := dllcall(BaseFilter.QueryInterface, uint, pBaseFilter, uint, &idd_Filtercfg9, "uint*", pFiltercfg9)
	if r 
		return "Failed to create the VMRFiltercfg9 interface"
	VMRFiltercfg9 := new ComInterfaceWrapper(dshow.IVMRFiltercfg9, pFiltercfg9, True)	
	if dllcall(VMRFiltercfg9.SetRenderingMode, uint, pFiltercfg9, uint, 0x00000002) 
		return "Failed to set windowless mode"
	
	%GUIDFromString%(idd_WindowlessControl9, dshow.IID_IVMRWindowlessControl9)
	r := dllcall(BaseFilter.QueryInterface, uint, pBaseFilter, uint, &idd_WindowlessControl9, "uint*", pWindowlessControl9, uint)
	if r 
		return "Failed to create the WindowlessControl9 interface" r dshow.err[r . ""]
	WindowlessControl9 := new ComInterfaceWrapper(dshow.IVMRWindowlessControl9, pWindowlessControl9, True)
	if dllcall(WindowlessControl9.SetVideoClippingWindow, uint, pWindowlessControl9, uint, hWin) 
		return "Failed to set the target window"
	
	%GUIDFromString%(idd_IMediaControl, dshow.IID_IMediaControl)
	if dllcall(GraphBuilder.QueryInterface, uint, GraphBuilder.p, uint, &idd_IMediaControl, "uint*", pMediaCtrl)
		return "Failed to create the IMediaControl interface"
	MediaControl := new ComInterfaceWrapper(dshow.IMediaControl, pMediaCtrl, True)	
	
	%GUIDFromString%(idd_IMediaEvent, dshow.IID_IMediaEvent)
	if dllcall(GraphBuilder.QueryInterface, uint, GraphBuilder.p, uint, &idd_IMediaEvent, "uint*", pIMediaEvent)
		return "Failed to create the IMediaEvent interface"
	MediaEvent := new ComInterfaceWrapper(dshow.IMediaEvent, pIMediaEvent, True)
	
	if dllcall(GraphBuilder.RenderFile, uint, GraphBuilder.p, str, file, uint, 0)
		return "FMV playback failed, most likely missing the correct codec"
	
	client_rect := struct("DWORD x; DWORD y; DWORD w; DWORD h;")
	src_rect    := struct("DWORD x; DWORD y; DWORD w; DWORD h;")
	dst_rect    := struct("DWORD x; DWORD y; DWORD w; DWORD h;")
	dllcall(WindowlessControl9.GetNativeVideoSize, uint, pWindowlessControl9, "uint*", vw, "uint*", vh, "uint*", aw, "uint*", ah)
	;printl("vid size " vw "x" vh " " aw " " ah)	
	src_rect.w := vw
	src_rect.h := vh
	dllcall("GetClientRect", uint, hWin, uint, client_rect[])
	if (scale)
	{
		s := client_rect.h/src_rect.h
		dst_rect.y := 0
		dst_rect.h := src_rect.h*s
		dst_rect.w := src_rect.w*s
		dst_rect.x := (client_rect.w-dst_rect.w)/2
		dst_rect.w += dst_rect.x
	} else {	
		dst_rect.x := (client_rect.w-src_rect.w)/2
		dst_rect.y := (client_rect.h-src_rect.h)/2	
		dst_rect.w += dst_rect.x + src_rect.w
		dst_rect.h += dst_rect.y + src_rect.h	
	}	
	dllcall(WindowlessControl9.SetVideoPosition, uint, pWindowlessControl9, uint, src_rect[], uint, dst_rect[])
		
	client_rect.w +=1, client_rect.h += 1
	brush := dllcall("CreateSolidBrush", uint, 0xff000000, uint)
	wdc   := dllcall("GetDC", uint, hWin, uint)
	dllcall("FillRect", uint, wdc, uint, client_rect[], uint, brush) 
	dllcall("DeleteObject", uint, brush)
	dllcall("DeleteObject", uint, wdc)
	
	dllcall(MediaControl.Run, uint, MediaControl.p)
	while ! (event=0x0001)
	{
		dllcall(MediaEvent.GetEvent, uint, MediaEvent.p, "uint*", event, "uint*", p1, "uint*", p2, uint, 15)
		if getkeystate("esc", "P") or ( getkeystate("Alt", "P") and  getkeystate("Tab", "P") )
			break 			
		XinputGetState(1) 
		if XINPUT_GAMEPAD_BACK
			break
	}
	
	;logerr("stop" dllcall(MediaControl.stop, uint, MediaControl.p))
	brush := dllcall("CreateSolidBrush", uint, 0xff000000, uint)
	wdc   := dllcall("GetDC", uint, hWin, uint)
	dllcall("FillRect", uint, wdc, uint, client_rect[], uint, brush) 
	dllcall("DeleteObject", uint, brush)
	dllcall("DeleteObject", uint, wdc)
	return file " playback successfull"	
}