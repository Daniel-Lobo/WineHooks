;File automatically generated by CrappyCppHeaderParser.ahk (Copyright@ peixoto)

Global DXGI1_4 := {}
DXGI1_4.IID_IDXGIOutput4 := "{dc7dca35-2196-414d-9F53-617884032a60}"
DXGI1_4.IID_IDXGIFactory4 := "{1bc6ea02-ef36-464f-bf0c-21ca39e5168a}"
DXGI1_4.IID_IDXGIAdapter3 := "{645967A4-1392-4310-A798-8053CE3E93FD}"

DXGI1_4.IDXGIAdapter3 := {}
DXGI1_4.IDXGIAdapter3.name := "IDXGIAdapter3"
DXGI1_4.IDXGIAdapter3.def :=
( 
"
STDMETHOD(QueryInterface)(This,riid,ppvObject)	\
STDMETHOD(AddRef)(This)	\
STDMETHOD(Release)(This)	\
STDMETHOD(SetPrivateData)(This,Name,DataSize,pData)	\
STDMETHOD(SetPrivateDataInterface)(This,Name,pUnknown)	\
STDMETHOD(GetPrivateData)(This,Name,pDataSize,pData)	\
STDMETHOD(GetParent)(This,riid,ppParent)	\
STDMETHOD(EnumOutputs)(This,Output,ppOutput)	\
STDMETHOD(GetDesc)(This,pDesc)	\
STDMETHOD(CheckInterfaceSupport)(This,InterfaceName,pUMDVersion)	\
STDMETHOD(GetDesc1)(This,pDesc)	\
STDMETHOD(GetDesc2)(This,pDesc)	\
STDMETHOD(RegisterHardwareContentProtectionTeardownStatusEvent)(This,hEvent,pdwCookie)	\
STDMETHOD(UnregisterHardwareContentProtectionTeardownStatus)(This,dwCookie)	\
STDMETHOD(QueryVideoMemoryInfo)(This,NodeIndex,MemorySegmentGroup,pVideoMemoryInfo)	\
STDMETHOD(SetVideoMemoryReservation)(This,NodeIndex,MemorySegmentGroup,Reservation)	\
STDMETHOD(RegisterVideoMemoryBudgetChangeNotificationEvent)(This,hEvent,pdwCookie)	\
STDMETHOD(UnregisterVideoMemoryBudgetChangeNotification)(This,dwCookie)	\
"
)

DXGI1_4.IDXGIFactory4 := {}
DXGI1_4.IDXGIFactory4.name := "IDXGIFactory4"
DXGI1_4.IDXGIFactory4.def :=
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
"
)

DXGI1_4.IDXGIOutput4 := {}
DXGI1_4.IDXGIOutput4.name := "IDXGIOutput4"
DXGI1_4.IDXGIOutput4.def :=
( 
"
STDMETHOD(QueryInterface)(This,riid,ppvObject)	\
STDMETHOD(AddRef)(This)	\
STDMETHOD(Release)(This)	\
STDMETHOD(SetPrivateData)(This,Name,DataSize,pData)	\
STDMETHOD(SetPrivateDataInterface)(This,Name,pUnknown)	\
STDMETHOD(GetPrivateData)(This,Name,pDataSize,pData)	\
STDMETHOD(GetParent)(This,riid,ppParent)	\
STDMETHOD(GetDesc)(This,pDesc)	\
STDMETHOD(GetDisplayModeList)(This,EnumFormat,Flags,pNumModes,pDesc)	\
STDMETHOD(FindClosestMatchingMode)(This,pModeToMatch,pClosestMatch,pConcernedDevice)	\
STDMETHOD(WaitForVBlank)(This)	\
STDMETHOD(TakeOwnership)(This,pDevice,Exclusive)	\
STDMETHOD(ReleaseOwnership)(This)	\
STDMETHOD(GetGammaControlCapabilities)(This,pGammaCaps)	\
STDMETHOD(SetGammaControl)(This,pArray)	\
STDMETHOD(GetGammaControl)(This,pArray)	\
STDMETHOD(SetDisplaySurface)(This,pScanoutSurface)	\
STDMETHOD(GetDisplaySurfaceData)(This,pDestination)	\
STDMETHOD(GetFrameStatistics)(This,pStats)	\
STDMETHOD(GetDisplayModeList1)(This,EnumFormat,Flags,pNumModes,pDesc)	\
STDMETHOD(FindClosestMatchingMode1)(This,pModeToMatch,pClosestMatch,pConcernedDevice)	\
STDMETHOD(GetDisplaySurfaceData1)(This,pDestination)	\
STDMETHOD(DuplicateOutput)(This,pDevice,ppOutputDuplication)	\
STDMETHOD(SupportsOverlays)(This)	\
STDMETHOD(CheckOverlaySupport)(This,EnumFormat,pConcernedDevice,pFlags)	\
STDMETHOD(CheckOverlayColorSpaceSupport)(This,Format,ColorSpace,pConcernedDevice,pFlags)	\
"
)



Global DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_PRESENT := 0x1
Global DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_OVERLAY_PRESENT := 0x2
Global DXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG_PRESENT := 0x1
Global DXGI_MEMORY_SEGMENT_GROUP_NON_LOCAL := 1

DXGI1_4.err := {}
