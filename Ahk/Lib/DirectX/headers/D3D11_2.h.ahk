;File automatically generated by CrappyCppHeaderParser.ahk (Copyright@ peixoto)

Global D3D11_2 := {}
D3D11_2.IID_ID3D11Device2 := "{9d06dffa-d1e5-4d07-83a8-1bb123f2f841}"

D3D11_2.ID3D11Device2 := {}
D3D11_2.ID3D11Device2.name := "ID3D11Device2"
D3D11_2.ID3D11Device2.def :=
( 
"
STDMETHOD(QueryInterface)(This,riid,ppvObject)	\
STDMETHOD(AddRef)(This)	\
STDMETHOD(Release)(This)	\
STDMETHOD(CreateBuffer)(This,pDesc,pInitialData,ppBuffer)	\
STDMETHOD(CreateTexture1D)(This,pDesc,pInitialData,ppTexture1D)	\
STDMETHOD(CreateTexture2D)(This,pDesc,pInitialData,ppTexture2D)	\
STDMETHOD(CreateTexture3D)(This,pDesc,pInitialData,ppTexture3D)	\
STDMETHOD(CreateShaderResourceView)(This,pResource,pDesc,ppSRView)	\
STDMETHOD(CreateUnorderedAccessView)(This,pResource,pDesc,ppUAView)	\
STDMETHOD(CreateRenderTargetView)(This,pResource,pDesc,ppRTView)	\
STDMETHOD(CreateDepthStencilView)(This,pResource,pDesc,ppDepthStencilView)	\
STDMETHOD(CreateInputLayout)(This,pInputElementDescs,NumElements,pShaderBytecodeWithInputSignature,BytecodeLength,ppInputLayout)	\
STDMETHOD(CreateVertexShader)(This,pShaderBytecode,BytecodeLength,pClassLinkage,ppVertexShader)	\
STDMETHOD(CreateGeometryShader)(This,pShaderBytecode,BytecodeLength,pClassLinkage,ppGeometryShader)	\
STDMETHOD(CreateGeometryShaderWithStreamOutput)(This,pShaderBytecode,BytecodeLength,pSODeclaration,NumEntries,pBufferStrides,NumStrides,RasterizedStream,pClassLinkage,ppGeometryShader)	\
STDMETHOD(CreatePixelShader)(This,pShaderBytecode,BytecodeLength,pClassLinkage,ppPixelShader)	\
STDMETHOD(CreateHullShader)(This,pShaderBytecode,BytecodeLength,pClassLinkage,ppHullShader)	\
STDMETHOD(CreateDomainShader)(This,pShaderBytecode,BytecodeLength,pClassLinkage,ppDomainShader)	\
STDMETHOD(CreateComputeShader)(This,pShaderBytecode,BytecodeLength,pClassLinkage,ppComputeShader)	\
STDMETHOD(CreateClassLinkage)(This,ppLinkage)	\
STDMETHOD(CreateBlendState)(This,pBlendStateDesc,ppBlendState)	\
STDMETHOD(CreateDepthStencilState)(This,pDepthStencilDesc,ppDepthStencilState)	\
STDMETHOD(CreateRasterizerState)(This,pRasterizerDesc,ppRasterizerState)	\
STDMETHOD(CreateSamplerState)(This,pSamplerDesc,ppSamplerState)	\
STDMETHOD(CreateQuery)(This,pQueryDesc,ppQuery)	\
STDMETHOD(CreatePredicate)(This,pPredicateDesc,ppPredicate)	\
STDMETHOD(CreateCounter)(This,pCounterDesc,ppCounter)	\
STDMETHOD(CreateDeferredContext)(This,ContextFlags,ppDeferredContext)	\
STDMETHOD(OpenSharedResource)(This,hResource,ReturnedInterface,ppResource)	\
STDMETHOD(CheckFormatSupport)(This,Format,pFormatSupport)	\
STDMETHOD(CheckMultisampleQualityLevels)(This,Format,SampleCount,pNumQualityLevels)	\
STDMETHOD(CheckCounterInfo)(This,pCounterInfo)	\
STDMETHOD(CheckCounter)(This,pDesc,pType,pActiveCounters,szName,pNameLength,szUnits,pUnitsLength,szDescription,pDescriptionLength)	\
STDMETHOD(CheckFeatureSupport)(This,Feature,pFeatureSupportData,FeatureSupportDataSize)	\
STDMETHOD(GetPrivateData)(This,guid,pDataSize,pData)	\
STDMETHOD(SetPrivateData)(This,guid,DataSize,pData)	\
STDMETHOD(SetPrivateDataInterface)(This,guid,pData)	\
STDMETHOD(GetFeatureLevel)(This)	\
STDMETHOD(GetCreationFlags)(This)	\
STDMETHOD(GetDeviceRemovedReason)(This)	\
STDMETHOD(GetImmediateContext)(This,ppImmediateContext)	\
STDMETHOD(SetExceptionMode)(This,RaiseFlags)	\
STDMETHOD(GetExceptionMode)(This)	\
STDMETHOD(GetImmediateContext1)(This,ppImmediateContext)	\
STDMETHOD(CreateDeferredContext1)(This,ContextFlags,ppDeferredContext)	\
STDMETHOD(CreateBlendState1)(This,pBlendStateDesc,ppBlendState)	\
STDMETHOD(CreateRasterizerState1)(This,pRasterizerDesc,ppRasterizerState)	\
STDMETHOD(CreateDeviceContextState)(This,Flags,pFeatureLevels,FeatureLevels,SDKVersion,EmulatedInterface,pChosenFeatureLevel,ppContextState)	\
STDMETHOD(OpenSharedResource1)(This,hResource,returnedInterface,ppResource)	\
STDMETHOD(OpenSharedResourceByName)(This,lpName,dwDesiredAccess,returnedInterface,ppResource)	\
STDMETHOD(GetImmediateContext2)(This,ppImmediateContext)	\
STDMETHOD(CreateDeferredContext2)(This,ContextFlags,ppDeferredContext)	\
STDMETHOD(GetResourceTiling)(This,pTiledResource,pNumTilesForEntireResource,pPackedMipDesc,pStandardTileShapeForNonPackedMips,pNumSubresourceTilings,FirstSubresourceTilingToGet,pSubresourceTilingsForNonPackedMips)	\
STDMETHOD(CheckMultisampleQualityLevels1)(This,Format,SampleCount,Flags,pNumQualityLevels)	\
"
)



Global D3D11_PACKED_TILE := 4294967295
Global D3D11_TILE_MAPPING_NO_OVERWRITE := 0x1
Global D3D11_TILE_RANGE_NULL := 0x1
Global D3D11_TILE_RANGE_SKIP := 0x2
Global D3D11_TILE_RANGE_REUSE_SINGLE_TILE := 0x4
Global D3D11_CHECK_MULTISAMPLE_QUALITY_LEVELS_TILED_RESOURCE := 0x1
Global D3D11_TILE_COPY_NO_OVERWRITE := 0x1
Global D3D11_TILE_COPY_LINEAR_BUFFER_TO_SWIZZLED_TILED_RESOURCE := 0x2
Global D3D11_TILE_COPY_SWIZZLED_TILED_RESOURCE_TO_LINEAR_BUFFER := 0x4

D3D11_2.err := {}
