;File automatically generated by CrappyCppHeaderParser.ahk (Copyright@ peixoto)

Global DXGI1_5 := {}
DXGI1_5.IID_IDXGISwapChain4 := "{3D585D5A-BD4A-489E-B1F4-3DBCB6452FFB}"
DXGI1_5.IID_IDXGIDevice4 := "{95B4F95F-D8DA-4CA4-9EE6-3B76D5968A10}"
DXGI1_5.IID_IDXGIFactory5 := "{7632e1f5-ee65-4dca-87fd-84cd75f8838d}"

DXGI1_5.IDXGIDevice4 := {}
DXGI1_5.IDXGIDevice4.name := "IDXGIDevice4"
DXGI1_5.IDXGIDevice4.def :=
( 
"
STDMETHOD(QueryInterface)(This,riid,ppvObject)	\
STDMETHOD(AddRef)(This)	\
STDMETHOD(Release)(This)	\
STDMETHOD(SetPrivateData)(This,Name,DataSize,pData)	\
STDMETHOD(SetPrivateDataInterface)(This,Name,pUnknown)	\
STDMETHOD(GetPrivateData)(This,Name,pDataSize,pData)	\
STDMETHOD(GetParent)(This,riid,ppParent)	\
STDMETHOD(GetAdapter)(This,pAdapter)	\
STDMETHOD(CreateSurface)(This,pDesc,NumSurfaces,Usage,pSharedResource,ppSurface)	\
STDMETHOD(QueryResourceResidency)(This,ppResources,pResidencyStatus,NumResources)	\
STDMETHOD(SetGPUThreadPriority)(This,Priority)	\
STDMETHOD(GetGPUThreadPriority)(This,pPriority)	\
STDMETHOD(SetMaximumFrameLatency)(This,MaxLatency)	\
STDMETHOD(GetMaximumFrameLatency)(This,pMaxLatency)	\
STDMETHOD(OfferResources)(This,NumResources,ppResources,Priority)	\
STDMETHOD(ReclaimResources)(This,NumResources,ppResources,pDiscarded)	\
STDMETHOD(EnqueueSetEvent)(This,hEvent)	\
STDMETHOD(Trim)(This)	\
STDMETHOD(OfferResources1)(This,NumResources,ppResources,Priority,Flags)	\
STDMETHOD(ReclaimResources1)(This,NumResources,ppResources,pResults)	\
"
)

DXGI1_5.IDXGIFactory5 := {}
DXGI1_5.IDXGIFactory5.name := "IDXGIFactory5"
DXGI1_5.IDXGIFactory5.def :=
( 
"
STDMETHOD(QueryInterface)(This,riid,ppvObject)	\
STDMETHOD(AddRef)(This)	\
STDMETHOD(Release)(This)	\
STDMETHOD(SetPrivateData)(This,Name,DataSize,pData)	\
STDMETHOD(SetPrivateDataInterface)(This,Name,pUnknown)	\
STDMETHOD(GetPrivateData)(This,Name,pDataSize,pData)	\
STDMETHOD(GetParent)(This,riid,ppParent)	\
STDMETHOD(EnumAdapters)(This,Adapter,ppAdapter)	\
STDMETHOD(MakeWindowAssociation)(This,WindowHandle,Flags)	\
STDMETHOD(GetWindowAssociation)(This,pWindowHandle)	\
STDMETHOD(CreateSwapChain)(This,pDevice,pDesc,ppSwapChain)	\
STDMETHOD(CreateSoftwareAdapter)(This,Module,ppAdapter)	\
STDMETHOD(EnumAdapters1)(This,Adapter,ppAdapter)	\
STDMETHOD(IsCurrent)(This)	\
STDMETHOD(IsWindowedStereoEnabled)(This)	\
STDMETHOD(CreateSwapChainForHwnd)(This,pDevice,hWnd,pDesc,pFullscreenDesc,pRestrictToOutput,ppSwapChain)	\
STDMETHOD(CreateSwapChainForCoreWindow)(This,pDevice,pWindow,pDesc,pRestrictToOutput,ppSwapChain)	\
STDMETHOD(GetSharedResourceAdapterLuid)(This,hResource,pLuid)	\
STDMETHOD(RegisterStereoStatusWindow)(This,WindowHandle,wMsg,pdwCookie)	\
STDMETHOD(RegisterStereoStatusEvent)(This,hEvent,pdwCookie)	\
STDMETHOD(UnregisterStereoStatus)(This,dwCookie)	\
STDMETHOD(RegisterOcclusionStatusWindow)(This,WindowHandle,wMsg,pdwCookie)	\
STDMETHOD(RegisterOcclusionStatusEvent)(This,hEvent,pdwCookie)	\
STDMETHOD(UnregisterOcclusionStatus)(This,dwCookie)	\
STDMETHOD(CreateSwapChainForComposition)(This,pDevice,pDesc,pRestrictToOutput,ppSwapChain)	\
STDMETHOD(GetCreationFlags)(This)	\
STDMETHOD(EnumAdapterByLuid)(This,AdapterLuid,riid,ppvAdapter)	\
STDMETHOD(EnumWarpAdapter)(This,riid,ppvAdapter)	\
STDMETHOD(CheckFeatureSupport)(This,Feature,pFeatureSupportData,FeatureSupportDataSize)	\
"
)

DXGI1_5.IDXGISwapChain4 := {}
DXGI1_5.IDXGISwapChain4.name := "IDXGISwapChain4"
DXGI1_5.IDXGISwapChain4.def :=
( 
"
STDMETHOD(QueryInterface)(This,riid,ppvObject)	\
STDMETHOD(AddRef)(This)	\
STDMETHOD(Release)(This)	\
STDMETHOD(SetPrivateData)(This,Name,DataSize,pData)	\
STDMETHOD(SetPrivateDataInterface)(This,Name,pUnknown)	\
STDMETHOD(GetPrivateData)(This,Name,pDataSize,pData)	\
STDMETHOD(GetParent)(This,riid,ppParent)	\
STDMETHOD(GetDevice)(This,riid,ppDevice)	\
STDMETHOD(Present)(This,SyncInterval,Flags)	\
STDMETHOD(GetBuffer)(This,Buffer,riid,ppSurface)	\
STDMETHOD(SetFullscreenState)(This,Fullscreen,pTarget)	\
STDMETHOD(GetFullscreenState)(This,pFullscreen,ppTarget)	\
STDMETHOD(GetDesc)(This,pDesc)	\
STDMETHOD(ResizeBuffers)(This,BufferCount,Width,Height,NewFormat,SwapChainFlags)	\
STDMETHOD(ResizeTarget)(This,pNewTargetParameters)	\
STDMETHOD(GetContainingOutput)(This,ppOutput)	\
STDMETHOD(GetFrameStatistics)(This,pStats)	\
STDMETHOD(GetLastPresentCount)(This,pLastPresentCount)	\
STDMETHOD(GetDesc1)(This,pDesc)	\
STDMETHOD(GetFullscreenDesc)(This,pDesc)	\
STDMETHOD(GetHwnd)(This,pHwnd)	\
STDMETHOD(GetCoreWindow)(This,refiid,ppUnk)	\
STDMETHOD(Present1)(This,SyncInterval,PresentFlags,pPresentParameters)	\
STDMETHOD(IsTemporaryMonoSupported)(This)	\
STDMETHOD(GetRestrictToOutput)(This,ppRestrictToOutput)	\
STDMETHOD(SetBackgroundColor)(This,pColor)	\
STDMETHOD(GetBackgroundColor)(This,pColor)	\
STDMETHOD(SetRotation)(This,Rotation)	\
STDMETHOD(GetRotation)(This,pRotation)	\
STDMETHOD(SetSourceSize)(This,Width,Height)	\
STDMETHOD(GetSourceSize)(This,pWidth,pHeight)	\
STDMETHOD(SetMaximumFrameLatency)(This,MaxLatency)	\
STDMETHOD(GetMaximumFrameLatency)(This,pMaxLatency)	\
STDMETHOD(GetFrameLatencyWaitableObject)(This)	\
STDMETHOD(SetMatrixTransform)(This,pMatrix)	\
STDMETHOD(GetMatrixTransform)(This,pMatrix)	\
STDMETHOD(GetCurrentBackBufferIndex)(This)	\
STDMETHOD(CheckColorSpaceSupport)(This,ColorSpace,pColorSpaceSupport)	\
STDMETHOD(SetColorSpace1)(This,ColorSpace)	\
STDMETHOD(ResizeBuffers1)(This,BufferCount,Width,Height,Format,SwapChainFlags,pCreationNodeMask,ppPresentQueue)	\
STDMETHOD(SetHDRMetaData)(This,Type,Size,pMetaData)	\
"
)



Global DXGI_OUTDUPL_COMPOSITED_UI_CAPTURE_ONLY := 1
Global DXGI_HDR_METADATA_TYPE_HDR10 := 1
Global DXGI_OFFER_RESOURCE_FLAG_ALLOW_DECOMMIT := 0x1
Global DXGI_RECLAIM_RESOURCE_RESULT_DISCARDED := 1
Global DXGI_RECLAIM_RESOURCE_RESULT_NOT_COMMITTED := 2

DXGI1_5.err := {}

