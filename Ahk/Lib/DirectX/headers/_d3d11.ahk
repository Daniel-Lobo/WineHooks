global D3D11_QUERY_EVENT              := 0
global D3D11_COUNTER_TYPE_FLOAT32     := 0
global D3D11_DEVICE_CONTEXT_IMMEDIATE := 0
global D3D11_FEATURE_THREADING        := 0
global D3D11_LOGIC_OP_CLEAR           := 0
#include lib\DirectX\Headers\D3D10.h.ahk
#include lib\DirectX\Headers\D3D11.h.ahk
#include lib\DirectX\Headers\D3DCommon.h.ahk
#include lib\DirectX\Headers\D3D11_3.h.ahk 
#include lib\DirectX\Headers\D3D11_1.h.ahk 

D3D11.err[2147942487 . ""] := "E_INVALIDARGS"

D3D11_BUFFER_DESC :=
(
"
  UINT        ByteWidth;
  UINT        Usage;
  UINT        BindFlags;
  UINT        CPUAccessFlags;
  UINT        MiscFlags;
  UINT        StructureByteStride;
"
)

D3D11_SUBRESOURCE_DATA :=
(
"
  ptr        pSysMem;
  UINT       SysMemPitch;
  UINT       SysMemSlicePitch;
"
)

D3D11_BUFFEREX_SRV :=
(
"
  UINT FirstElement;
  UINT NumElements;
  UINT Flags;
"
)

D3D11_SHADER_RESOURCE_VIEW_DESC :=
(
"
  int                     Format;
  int                     ViewDimension;
  D3D11_BUFFEREX_SRV      BufferEx;  
"  
)

D3D11_BUFFER_UAV :=
(
" 
  UINT FirstElement;
  UINT NumElements;
  UINT Flags;
"
)

D3D11_UNORDERED_ACCESS_VIEW_DESC :=
(
"
  int                   Format;
  int                   ViewDimension;
  D3D11_BUFFER_UAV      Buffer;
"
)

global D3D11_BUFFER_DESC := Struct(D3D11_BUFFER_DESC)
global D3D11_SUBRESOURCE_DATA := Struct(D3D11_SUBRESOURCE_DATA)
global D3D11_SHADER_RESOURCE_VIEW_DESC := Struct(D3D11_SHADER_RESOURCE_VIEW_DESC)
global D3D11_BUFFEREX_SRV := Struct(D3D11_BUFFEREX_SRV)
global D3D11_UNORDERED_ACCESS_VIEW_DESC := Struct(D3D11_UNORDERED_ACCESS_VIEW_DESC)
global D3D11_BUFFER_UAV := Struct(D3D11_BUFFER_UAV)

D3D11_INPUT_ELEMENT_DESC := 
(
"
  LPCSTR   SemanticName;
  UINT     SemanticIndex;
  UINT     Format;
  UINT     InputSlot;
  UINT     AlignedByteOffset;
  UINT     InputSlotClass;
  UINT     InstanceDataStepRate
"
) 
global D3D11_INPUT_ELEMENT_DESC := struct(D3D11_INPUT_ELEMENT_DESC)

global D3D11_RENDER_TARGET_VIEW_DESC :=
(
"
  uint         Format;
  uint         ViewDimension;
  uint         Subresource; 
"
)
D3D11_RENDER_TARGET_VIEW_DESC := struct(D3D11_RENDER_TARGET_VIEW_DESC)
global D3D11_TEXTURE2D_DESC :=
(
"
  UINT             Width;
  UINT             Height;
  UINT             MipLevels;
  UINT             ArraySize;
  UINT             Format;
  UINT             SampleDesc;
  UINT             Usage;
  UINT             BindFlags;
  UINT             CPUAccessFlags;
  UINT             MiscFlags;
"
)
D3D11_TEXTURE2D_DESC := struct(D3D11_TEXTURE2D_DESC)


