#include lib\DirectX\Headers\dshow.h.ahk

dshow.IID_IGraphBuilder           := "{56a868a9-0ad4-11ce-b03a-0020af0ba770}"
dshow.CLSID_FilterGraph           := "{E436EBB3-524F-11CE-9F53-0020AF0BA770}"
dshow.IID_IDDrawExclModeVideo     := "{153ACC21-D83B-11d1-82BF-00A0C9696C8F}"
dshow.IID_IDvdGraphBuilder        := "{FCC152B6-F372-11d0-8E00-00C04FD7C08B}"
dshow.CLSID_OverlayMixer          := "{CD8743A1-3736-11d0-9E69-00C04FD7C15B}"
dshow.IID_IBaseFilter             := "{56a86895-0ad4-11ce-b03a-0020af0ba770}"
dshow.CLSID_VideoMixingRenderer   := "{B87BEB7B-8D29-423f-AE4D-6582C10175AC}"
dshow.CLSID_VideoMixingRenderer9  := "{51b4abf3-748f-4e3b-a276-c828330e926a}"
dshow.IID_IVMRWindowlessControl9  := "{8f537d09-f85e-4414-b23b-502e54c79927}"
dshow.IID_IVMRFiltercfg9       := "{5a804648-4f66-4867-9c43-4f5c822cf1b8}"
dshow.IID_IVMRFiltercfg        := "{9e5530c5-7034-48b4-bb46-0b8a6efc8e36}"
dshow.IID_IVMRWindowlessControl   := "{0eb1088c-4dcd-46f0-878f-39dae86a51b7}"

dshow.IVMRWindowlessControl9 := {}
dshow.IVMRWindowlessControl9.name := "IVMRWindowlessControl9"
dshow.IVMRWindowlessControl9.def :=
(
"

STDMETHOD(QueryInterface);
STDMETHOD(AddRef);
STDMETHOD(Release);
STDMETHOD(GetNativeVideoSize);
STDMETHOD(GetMinIdealVideoSize);
STDMETHOD(GetMaxIdealVideoSize);
STDMETHOD(SetVideoPosition);
STDMETHOD(GetVideoPosition);
STDMETHOD(GetAspectRatioMode);
STDMETHOD(SetAspectRatioMode);
STDMETHOD(SetVideoClippingWindow);
STDMETHOD(RepaintVideo);
STDMETHOD(DisplayModeChanged);
STDMETHOD(GetCurrentImage);
STDMETHOD(SetBorderColor);
STDMETHOD(GetBorderColor);        
"
)

dshow.IVMRFiltercfg9 := {}
dshow.IVMRFiltercfg9.name := "IVMRFiltercfg9"
dshow.IVMRFiltercfg9.def :=
(
"

STDMETHOD(QueryInterface);
STDMETHOD(AddRef);
STDMETHOD(Release);
STDMETHOD(SetImageCompositor);
STDMETHOD(SetNumberOfStreams);
STDMETHOD(GetNumberOfStreams);
STDMETHOD(SetRenderingPrefs);
STDMETHOD(GetRenderingPrefs);
STDMETHOD(SetRenderingMode);
STDMETHOD(GetRenderingMode);       
"
)         

dshow.IGraphBuilder := {}
dshow.IGraphBuilder.name := "IGraphBuilder"
dshow.IGraphBuilder.def :=
( 
"
STDMETHOD(QueryInterface)(This,riid,ppvObject)
STDMETHOD(AddRef)(This)
STDMETHOD(Release)(This)
STDMETHOD(AddFilter) (This)	
STDMETHOD(RemoveFilter) (This)	
STDMETHOD(EnumFilters)(This) 	
STDMETHOD(FindFilterByName) (This)	
STDMETHOD(ConnectDirect) (This)
STDMETHOD(Reconnect) (This)	
STDMETHOD(Disconnect) (This)
STDMETHOD(SetDefaultSyncSource) (This)
STDMETHOD(Connect) (This)
STDMETHOD(Render)(This) 	
STDMETHOD(RenderFile) (This)
STDMETHOD(AddSourceFilterv (This)
STDMETHOD(SetLogFile) (This)
STDMETHOD(Abort) (This)		
STDMETHOD(ShouldOperationContinue)(This)
"
)

dshow.IBaseFilter := {}
dshow.IBaseFilter.name := "IBaseFilter"
dshow.IBaseFilter.def :=
(
"
STDMETHOD(QueryInterface)
STDMETHOD(AddRef)
STDMETHOD(Release)
STDMETHOD(GetClassID)
STDMETHOD(Stop)
STDMETHOD(Pause)
STDMETHOD(Run)
STDMETHOD(GetState)
STDMETHOD(SetSyncSource)
STDMETHOD(GetSyncSource)
STDMETHOD(EnumPins)
STDMETHOD(FindPin)
STDMETHOD(QueryFilterInfo)
STDMETHOD(JoinFilterGraph)
STDMETHOD(QueryVendorInfo) 
"
)

dshow.IDDrawExclModeVideo := {}
dshow.IDDrawExclModeVideo.name := "IDDrawExclModeVideo"
dshow.IDDrawExclModeVideo.def :=
(
"
STDMETHOD(QueryInterface)
STDMETHOD(AddRef) 
STDMETHOD(Release)
STDMETHOD(SetDDrawObject)
STDMETHOD(GetDDrawObject)
STDMETHOD(SetDDrawSurface) 
STDMETHOD(GetDDrawSurface) 
STDMETHOD(SetDrawParameters)
STDMETHOD(GetNativeVideoProps) 
STDMETHOD(SetCallbackInterface) 
"
)

dshow.IEnumPins := {}
dshow.IEnumPins.name := "IEnumPins"
dshow.IEnumPins.def :=
(
"
STDMETHOD(QueryInterface)
STDMETHOD(AddRef) 
STDMETHOD(Release)
STDMETHOD(Next)
STDMETHOD(Skip)
STDMETHOD(Reset) 
STDMETHOD(Clone) 
"
)

dshow.IPin := {}
dshow.IPin.name := "IPin"
dshow.IPin.def :=
(
"
STDMETHOD(QueryInterface)
STDMETHOD(AddRef) 
STDMETHOD(Release)
STDMETHOD(Connect)
STDMETHOD(ReceiveConnection)
STDMETHOD(Disconnect)
STDMETHOD(ConnectedTo) 
STDMETHOD(ConnectionMediaType) 
STDMETHOD(QueryPinInfo)
STDMETHOD(QueryDirection)
STDMETHOD(QueryId) 
STDMETHOD(QueryAccept) 
STDMETHOD(EnumMediaTypes)
STDMETHOD(QueryInternalConnections) 
STDMETHOD(EndOfStream) 
STDMETHOD(BeginFlush)
STDMETHOD(EndFlush) 
STDMETHOD(NewSegment)
"
)