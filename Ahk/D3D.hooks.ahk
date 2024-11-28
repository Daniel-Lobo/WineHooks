global D3DHOOKS_DATA :=
(
"
// Config, used to change flags used to create surfaces
BOOL HD; BOOL 32Bit; BOOL NEFS; DWORD HD_W; DWORD HD_H; DWORD D; BOOL Safe;
// D3D hooks and data used to scale vertices
// DDraw hooks and data used to emulate blts
// and locks on Flip,RT and primary surfaces
DWORD zmsk;
DWORD D3D7Draw;
DWORD execute;
DWORD DrawPrimitive3;
DWORD DrawIPrimitive3;
DWORD p_DrawPrimitive;
DWORD p_DrawPrimitiveVB;
DWORD p_DrawIndexedPrimitive;
DWORD p_DrawIndexedPrimitiveVB;
DWORD p_GetVertexBufferDesc;
DWORD p_LockVertexBuffer;
DWORD p_UnLockVertexBuffer;
DWORD p_TransformVertices;
DWORD p_GetView;
DWORD p_SetView;
LPVOID QueryPrimary;
LPVOID QuerySurface;
LPVOID QueryTexture;
LPVOID QueryDevice;
LPVOID Flip;
LPVOID LockPrimary;
LPVOID UnLockPrimary;  
LPVOID UnLockPrimary4;
LPVOID LockSurface;
LPVOID UnLockSurface;
LPVOID UnLockSurface4;
LPVOID BltPrimary;
LPVOID BltSurface;
LPVOID BltFastPrimary;
LPVOID BltFastSurface;
LPVOID GetDCPrim;
LPVOID GetDCSrfc;
LPVOID RelDCPrim;
LPVOID RelDCSrfc;
LPVOID vertex_data;
DWORD  Delay;
LPVOID UpdateRT;
float scale;
BOOL  displace;
float HD_X;
BOOL  vert_displace;
float vert_displacement;
BOOL  callback;
uint  pCallback;
BOOL  fix_screencoords;
DWORD    w;
DWORD    h;
LPVOID   Rct;
LPVOID   _Rct;
LPVOID   VW2;
// NEFS
LPVOID GtAttSrfc;
LPVOID AHKGtAttSrfc;
LPVOID GtAttSrfc4;
LPVOID AHKGtAttSrfc4;
// Texture swap
LPVOID IDirect3DDevice2_SetRenderState;
LPVOID ID3DDevice2_SetRenderState_Callback;
LPVOID IDirect3DDevice3_SetTexture;
LPVOID ID3DDevice3_SetTexture_Callback;
LPVOID IDirect3DDevice7_SetTexture;
LPVOID ID3DDevice7_SetTexture_Callback;
LPVOID Lock;
LPVOID UnLock;
LPVOID UnLock4;
LPVOID Surface_Found;
LPVOID SwapBack;
LPVOID textures; 
LPVOID found;
LPVOID replacements;
LPVOID hTex;
BOOL   search_enabled;
DWORD  curent_texture;
BOOL   ignore_release;
DWORD  vid_check;
LPVOID IDirectDrawSurface_QueryInterface;
LPVOID IDirect3DTexture_QueryInterface;
LPVOID IDirect3DTexture2_QueryInterface;
LPVOID GetDDSCaps;
LPVOID SrfcGtDsc;
LPVOID TsExecute;
BOOL   Chck;
LPVOID DDGtCps;
LPVOID DmpAndAppend;
// Manage IDirectDrawSurface4 locks
LPVOID Manager_Lock, DLock; LPVOID Manager_UnLock, DUnLock; LPVOID Manager_Blt; LPVOID sysmem_surfaces;
LPVOID LooseSurface;
"
)
D3DHOOKS_DATA := struct(D3DHOOKS_DATA)
#include lib\DirectX\ddraw.ahk
#include lib\HDHooks.ahk
#include lib\_TexSwapLib.ahk
#include lib\TextureManager.ahk
#include LayerTextSwap.ahk

global DEVICE3_RECT :=
(
"
DWORD Device3;
DWORD RenderTarget;
DWORD BeginScene;
DWORD EndScene;
DWORD GetCurrentViewport;
DWORD ReleaseViewport;
DWORD GetView;
DWORD SetView;
DWORD ClearView;
DWORD DrawPrimitive;
DWORD SetRenderState;
DWORD GetRenderState;
DWORD SetTexture;
DWORD GetTexture;
DWORD SetTextureStageState;
DWORD GetTextureStageState;
DWORD ReleaseTexture;
LPVOID Texture;
"
)
global DEVICE2_RECT := struct("LPVOID Device2; LPVOID BeginScene; LPVOID EndScene; LPVOID DrawPrimitive; LPVOID SetRenderState; LPVOID GetRenderState; DWORD Text")

DirectDrawCreate_hook(p1, p2, p3)
{
	static dd=	
	if (g_.cfg.D3D = "3") 
		g_.proxies := {} ;move to SetupPrxs	

	if (dd) 
	{
		dllcall(IDirectDraw.release, uint, dd) 
		dd := 0
	}		
	
	if (r := dllcall(g_.p.DirectDrawCreate, uint, p1, uint, p2, uint, p3))
	return r
		
	if (g_.cfg.layer)
	{
		DD := dllcall("Peixoto\WrappDDrawObject", ptr, numget(p2+0, "ptr"), ptr)
		numput(DD,p2+0, ptr)
	}

	if (g_.cfg.D3D = "7") 
	{
		return r
	}
	
	dd := numget(p2+0, "ptr")	
	dllcall(IDirectDraw.addref, uint, dd)
	SetUPShaders()	
	return r
}

DDCreateEx_hook(p1, p2, p3, p4)
{
	static dd7=
	g_.proxies := {}
	
	if (dd7) 
	{
		dllcall(IDirectDraw7.release, uint, dd7) 
		dd7 := 0
	}
	
	if (r := dllcall(g_.p.DDCreateEx, uint, p1, uint, p2, uint, p3, uint, p4))
	return r
    
    if (g_.cfg.layer)
	{
		DD := dllcall("Peixoto\WrappDDraw7Object", ptr, numget(p2+0, "ptr"), ptr)
		numput(DD,p2+0, ptr)
	}	
	
	dd7 := numget(p2+0, "ptr")	
	dllcall(IDirectDraw7.addref, uint, dd7)	
	SetUPShaders()	
	return r
}

D3DDDI_SetShaderOverride(p){
	return
}
D3DDDI_RestoreShader(){
	return
}
D3DDDI_Init(){
	return
}

InstallCreateSurfaceHook()
{
	logErr(IDirectDraw4.Hook("CreateSurface"))
	logerr(IDirectDraw2.Hook("CreateSurface"))
	return logerr(IDirectDraw.Hook("CreateSurface"))	
}

InstallSetCoopLevelHooks()
{
	logErr(IDirectDraw.Hook("SetCooperativeLevel", IsFunc("AltSetCooperativeLevel") ? "AltSetCooperativeLevel" : "IDirectDraw_SetCooperativeLevel", , 1))
	logErr(IDirectDraw2.Hook("SetCooperativeLevel", IsFunc("AltSetCooperativeLevel") ? "AltSetCooperativeLevel" : "IDirectDraw_SetCooperativeLevel", , 2))
	logErr(IDirectDraw4.Hook("SetCooperativeLevel", IsFunc("AltSetCooperativeLevel") ? "AltSetCooperativeLevel" : "IDirectDraw_SetCooperativeLevel", , 3))	
}

InitD3DHook()
InitD3DHook()
{	
	;g_.cfg.layer:=true
	D3DDDI_Init() 	
	/*
	"SetAppCompatData" exported function from ddraw.dll. It is only called from AcGenral.dll, under the compatibility DXPrimaryEmulation in Microsoft ACT.
	Parameters for DXPrimaryEmulation not documented anywhere. I found them only with a debugger.
	Possible parameters:
	1. -LockEmulation
	2. -BltEmulation
	3. -ForceLockNoWindow
	4. -ForceBltNoWindow
	5. -LockColorkey:
	6. -FullscreenWithDWM
	7. -DisableLockEmulation
	8. -EnableOverlays
	9. -DisableSurfaceLocks
	10. -RedirectPrimarySurfBlts
	11. -StripBorderStyle
	12. -DisableMaxWindowedMode 
	second paramenter is zero for all except LockColorkey
	*/	
	(g_.cfg.DMWM) ? (dllcall("ddraw.dll\SetAppCompatData", uint, 12, uint, 0), g_.cfg.DMWM:="")
	;dllcall("ddraw.dll\SetAppCompatData", uint, 7, uint, 0)
	;dllcall("ddraw.dll\SetAppCompatData", uint, 9, uint, 0)
	;dllcall("ddraw.dll\SetAppCompatData", uint, 3, uint, 0)
	;dllcall("ddraw.dll\SetAppCompatData", uint, 1, uint, 0)
	;dllcall("ddraw.dll\SetAppCompatData", uint, 6, uint, 0)

	g_.DDrawPath      := A_WinDir "\System32\ddraw.dll"
	VarSetCapacity(DDPath, 261)
	DllCall("GetModuleFileNameA", uint, DllCall("LoadLibraryW", str, "ddraw.dll"), uint, &DDPath, uint, 261)
	logerr("DDraw.dll : " StrGet(&DDPath, "CP0")), DDPath := ""
	
	if (g_.cfg.D3D = "7") 
	{
		logerr("DirectDrawCreateEX Hook: " InstallHook(isfunc("AltDDCreateEx") ? "AltDDCreateEx" : "DDCreateEx_hook", pDDCreateEx, "ddraw.dll", "DirectDrawCreateEx"))
		g_.p.DDCreateEx := pDDCreateEx
		if (!(g_.cfg.layeroff or g_.cfg.ver) and g_.cfg.force_dd1_hooks){
			logerr("DirectDrawCreate Hook: " InstallHook(isfunc("AltDDrawCreate") ? "AltDDrawCreate" : "DirectDrawCreate_hook", pDirectDrawCreate, "ddraw.dll", "DirectDrawCreate"))
			g_.p.DirectDrawCreate := pDirectDrawCreate
		}
	} else {
		logerr("DirectDrawCreate Hook: " InstallHook(isfunc("AltDDrawCreate") ? "AltDDrawCreate" : "DirectDrawCreate_hook", pDirectDrawCreate, "ddraw.dll", "DirectDrawCreate"))
		g_.p.DirectDrawCreate := pDirectDrawCreate
	}		
		
	if ((!g_.cfg.wineoff) or (IsLinux := dllcall("LoadLibraryW", str, "wined3d.dll")))
	{
		g_.cfg.winedd   := True
		g_.cfg.layeroff := false
		if (!IsLinux)
		{
			dllcall("LoadLibraryW", str,  g_.cfg.injector_dir . "\wined3d\"  g_.cfg.wine "\x32\wined3d.dll")
			h_wineddraw            := dllcall("LoadLibraryW", str, g_.cfg.injector_dir . "\wined3d\" . g_.cfg.wine . "\x32\ddraw.dll")
			g_.p.DDCreateEx        := dllcall("GetProcAddress", ptr, h_wineddraw, astr, "DirectDrawCreateEx")
			g_.p.DirectDrawCreate  := dllcall("GetProcAddress", ptr, h_wineddraw, astr, "DirectDrawCreate")
		}
		logerr("InitWineHooks " strget(dllcall("peixoto.dll\InitWineHoooks", wstr, "", ptr)+0, "UTF-8"))
	}
	
	g_.p.SetDDSPxFmt           := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "SetDDSurfacePixelFormat", uint)
	g_.p.GetDDSPxFmt           := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "GetDDSPixelFormat", uint)
	g_.p.Scale                 := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "Scale")
	g_.p.ScaleX                := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "ScaleX")
	g_.p.Pal2RGB               := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "Pal2RGB")
	g_.p.c2c                   := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "Clr2clr")
	g_.p.D3D3Clear             := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "IDirect3DDevice3_Clear")
	g_.p.Dev2_DrawRect         := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "IDirect3DDevice2_DrawRect")
	g_.p.Dev3_DrawRect         := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "IDirect3DDevice3_DrawRect")
	g_.p.Dev3_DrawRctWithFlags := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "IDirect3DDevice3_DrawRectWithFlags")
	g_.p.DDFrmSrfc             := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "DDFromSurface")
	g_.p.DDFrmTx               := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "DDFromTexture")
	g_.p.GetSurfaceID          := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GetSurfaceID")
	g_.p.CreateSrfc            := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "CreateSurfaceHook")
	g_.p.DDSSrfcAttchDat       := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "DDSurfaceAttachData")	
	g_.p.ddiCreatePx           := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "d3dddiCreatePxShader")
	g_.p.ddiDeletePx           := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "d3dddiDeletePxShader")	
	g_.p.ddiSetOvrrd           := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "d3dddiSetOverride")	
	(g_.cfg.MHKS)              ? dllcall("Peixoto.dll\InitMouseHooks")
	(g_.cfg.DisableFontAA)     ? (dllcall("Peixoto.dll\DisableFontAA"), g_.cfg.DisableFontAA := "")
    ;dllcall("Peixoto.dll\NVIDIA_Set", wstr, g_.cfg.target, uint, g_.cfg.NVAA:=2)
	logerr(g_.p.Dev3_DrawRctWithFlags "============================================")

    g_.cfg.layer := (g_.cfg.layeroff or g_.cfg.ver) ? False : True	
	if (g_.cfg.layer)
	{
        LayerInitTextSwap(g_.cfg.TextSwap, g_.cfg.mngr)        
    }

	D3DHOOKS_DATA.HD       := (g_.cfg.HD)    ? 1 : 0
	D3DHOOKS_DATA.32Bit    := (g_.cfg.32bit) ? 1 : 0
	D3DHOOKS_DATA.NEFS     := (g_.cfg.NEFS)  ? 1 : 0
	D3DHOOKS_DATA.Delay    := g_.cfg.dly 
	D3DHOOKS_DATA.Safe     := g_.cfg.safe
	D3DHOOKS_DATA.UpdateRT := RegisterCallback("Surface1UpDateRTC", "F")
	dllcall(dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "InitD3DHooksData"), uint, D3DHOOKS_DATA[])
	if (g_.cfg.console)
	dllcall("peixoto.dll\D3D12Config", astr, "DBUG", uint, 1)
	g_.cfg.FLTR := ""
	if (g_.cfg.FLTR)
	dllcall("peixoto.dll\D3D12Config", astr, "TEXTURE.FILTER", uint, g_.cfg.winedd ? 2 : 1)
	g_.dbg := {"frm" : 0}
	
	g_.palette := dllcall("VirtualAlloc", ptr, 0, ptr, 1024, uint, 0x3000, uint, 0x04, ptr)	
	if g_.cfg.D3D != "7"
	   g_.cfg.D3D := "3"	   
	
	if (g_.cfg.D3D = "3")
	{
		logErr(GetDirectDraw())
		logerr(GetDirect3D())				
        logerr(IDirect3DDevice.compare([IDirect3DDevice2]))	
		
		if g_.cfg.GAVM 
		{
			logerr(IDirectDraw2.Hook("GetAvailableVidMem"))
			logerr(IDirectDraw4.Hook("GetAvailableVidMem"))
			;logerr(IDirectDraw4.dllHook("GetCaps", "IDirectDrawGetCapsHook"))
			;D3DHOOKS_DATA.DDGtCps := IDirectDraw4.GetCaps 
		}
		
		if g_.cfg.DDRefcountfix 
		logerr(IDirectDraw.Hook("Release"))	
		g_.cfg.DDRefcountfix := ""
		
		InstallCreateSurfaceHook()				
		logErr(IDirectDrawSurface.Hook("restore"))
		logErr(IDirect3DDevice.Hook("EndScene"))
		logErr(IDirect3DDevice3.Hook("EndScene")) ;<- Avoid infinite recursion if BrowseDevice3Textures2 is called from IDirect3DDevice_EndScene 		
		logErr(IDirect3D3.Hook("CreateDevice"))
		logErr(IDirect3D2.Hook("CreateDevice"))			
		
		if (g_.cfg.HD) 
			InitHDHooks3() 
		else if (g_.cfg.32bit || g_.cfg.SXTY) 
		{ 
			logErr(IDirectDraw.hook("SetDisplayMode"))
			logErr(IDirectDraw2.hook("SetDisplayMode"))
			logErr(IDirectDraw4.hook("SetDisplayMode"))
			(g_.cfg.32bit) ? SetupPrxs4()
		}			
		;(g_.cfg.TextSwap ) ? TSwapInit(g_.cfg.TextSwap)
		(parsecfg(g_.cfg.TextSwap).e) ? TSwapInit(g_.cfg.TextSwap)
		
		(g_.cfg.mngr)      ? InitMngr()
		if g_.cfg.WSTL or g_.cfg.32bit or g_.cfg.NEFS or g_.cfg.HD
			InstallSetCoopLevelHooks()			
		if ( (g_.cfg.NEFS || g_.cfg.SSAA) && g_.cfg.HD)
		{
			/*
			if (g_.cfg.safe)
			{
				logerr(IDirectDrawSurface.dllHook("Flip", "FlipHook"))
				D3DHOOKS_DATA.flip := RegisterCallback("IDirectDrawSurface_Flip", "F")
			}				
			else 
			*/
			logerr(IDirectDrawSurface.Hook("flip"))
			;logerr(IDirectDrawSurface4.Hook("GetAttachedSurface"))
			;logerr(IDirectDrawSurface.Hook("GetAttachedSurface"))
            if (!g_.cfg.layer) {
                logerr(IDirectDrawSurface4.PatchVtable("EnumAttachedSurfaces"))				
                logerr(IDirectDrawSurface.PatchVtable("EnumAttachedSurfaces"))
            } else {
                logerr(IDirectDrawSurface4.Hook("EnumAttachedSurfaces"))				
                logerr(IDirectDrawSurface.Hook("EnumAttachedSurfaces"))
            }	
			
            if (!g_.cfg.layer) {
                logerr(IDirectDrawSurface4.dllHook("GetAttachedSurface", "GetAttachedSurface4Hook"))
                logerr(IDirectDrawSurface.dllHook("GetAttachedSurface", "GetAttachedSurfaceHook"))
            } else {
                logerr(IDirectDrawSurface4.Hook("GetAttachedSurface", IsFunc(a:="AltIDirectDrawSurface4_GetAttachedSurface")?a:"IDirectDrawSurface4_GetAttachedSurface"))
                logerr(IDirectDrawSurface.Hook("GetAttachedSurface", IsFunc(a:="AltIDirectDrawSurface_GetAttachedSurface")?a:"IDirectDrawSurface_GetAttachedSurface"))
            }
			D3DHOOKS_DATA.GtAttSrfc4    := IDirectDrawSurface4.GetAttachedSurface
			D3DHOOKS_DATA.GtAttSrfc     := IDirectDrawSurface.GetAttachedSurface
			D3DHOOKS_DATA.AHKGtAttSrfc4 := RegisterCallback(IsFunc(a:="AltIDirectDrawSurface4_GetAttachedSurface")?a:"IDirectDrawSurface4_GetAttachedSurface", "F")
			D3DHOOKS_DATA.AHKGtAttSrfc  := RegisterCallback(IsFunc(a:="AltIDirectDrawSurface_GetAttachedSurface")?a:"IDirectDrawSurface_GetAttachedSurface", "F")
		} else if (g_.cfg.SYNC)
			logerr(IDirectDrawSurface.Hook("flip"))
	}
	else if (g_.cfg.D3D = "7")
	{
		logErr(GetDirectDraw())
		logerr(GetDirect3D())
		logErr(GetDirect3D7())		
		logErr(IDirectDraw7.Hook("CreateSurface"))
		logErr(IDirect3D7.Hook("CreateDevice"))
		logErr(IDirect3DDevice7.Hook("EndScene"))
		(g_.cfg.HD) ? InitHDHooks7() : (g_.cfg.32bit) ? (logErr(IDirectDraw7.hook("SetDisplayMode")), SetupPrxs7(0))
		if (g_.cfg.FHAL && !g_.cfg.HD)
			logErr(IDirect3D7.Hook("CreateVertexBuffer"))
		if (parsecfg(g_.cfg.TextSwap).e)		
			InitTextSwapHooks7(g_.cfg.TextSwap)
		if g_.cfg.WSTL or g_.cfg.32bit or g_.cfg.NEFS or g_.cfg.HD
			logErr(IDirectDraw7.Hook("SetCooperativeLevel", IsFunc("AltSetCooperativeLevel") ? "AltSetCooperativeLevel" :"IDirectDraw_SetCooperativeLevel", , 4))
		if ((g_.cfg.NEFS || g_.cfg.SSAA) && g_.cfg.HD)
		{
			logerr(IDirectDrawSurface7.Hook("flip"))
			logerr(IDirectDrawSurface7.Hook("GetAttachedSurface"))
			logerr(IDirectDrawSurface7.Hook("EnumAttachedSurfaces"))
		}	
	}

	if g_.cfg.gamma and g_.cfg.os_version > 6.1 
	{
		hDC := DllCall("GetDC", "Uint", 0)
		DllCall("GetDeviceGammaRamp", "Uint", hDC, "Uint", (g_.gamma_ramp := struct("BYTE clrs[1536]"))[]) 
		DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
		logErr(IDirectDrawGammaControl.hook("SetGammaRamp"))	
	}
	
	/*
	g_.BCode := {}
	fileread, shader, % g_.cfg.injector_dir "\Shaders\xBRz.fx"
	fileread, shadera, % g_.cfg.injector_dir "\Shaders\xBRLv3.fx"
	g_.BCode.xbr   := D3DDDI_CmplBCode(shader, "main_fragment")	
	g_.BCode.xbra  := D3DDDI_CmplBCode("#define USEALPHA 1`n" shader, "main")
	g_.BCode.fmvs  := D3DDDI_CmplBCode(G_D3DDDI.shader_code, "LineDoubling")
	g_.BCode.lnr   := D3DDDI_CmplBCode(G_D3DDDI.shader_code, "Linear")
	g_.BCode.MIE   := D3DDDI_CmplBCode(G_D3DDDI.shader_code, "MaskIfEqual")	
	g_.BCode.DIE   := D3DDDI_CmplBCode(G_D3DDDI.shader_code, "DiscardIfEqual")	
	g_.BCode.clr   := D3DDDI_CmplBCode(G_D3DDDI.shader_code, "Clear")	
	g_.BCode.ckey  := D3DDDI_CmplBCode(G_D3DDDI.shader_code, "ckey")
	*/

	/* With all hooks in place, initiate the Render to texture structures
	 */

	DEVICE3_RECT := struct(DEVICE3_RECT)
	DEVICE3_RECT.RenderTarget := 0
	DEVICE3_RECT.BeginScene             := IDirect3DDevice3.BeginScene
	DEVICE3_RECT.EndScene               := IDirect3DDevice3.EndScene
	DEVICE3_RECT.GetCurrentViewport     := IDirect3DDevice3.GetCurrentViewport
	DEVICE3_RECT.ReleaseViewport        := IDirect3DViewPort3.Release
	DEVICE3_RECT.GetView                := IDirect3DViewPort3.GetViewport2
	DEVICE3_RECT.SetView                := IDirect3DViewPort3.SetViewport2
	DEVICE3_RECT.ClearView              := IDirect3DViewPort3.Clear2
	DEVICE3_RECT.DrawPrimitive          := IDirect3DDevice3.DrawPrimitive
	DEVICE3_RECT.SetRenderState         := IDirect3DDevice3.SetRenderState
	DEVICE3_RECT.GetRenderState         := IDirect3DDevice3.GetRenderState
	DEVICE3_RECT.SetTexture             := IDirect3DDevice3.SetTexture
	DEVICE3_RECT.GetTexture             := IDirect3DDevice3.GetTexture
	DEVICE3_RECT.SetTextureStageState   := IDirect3DDevice3.SetTextureStageState
	DEVICE3_RECT.GetTextureStageState   := IDirect3DDevice3.GetTextureStageState
	DEVICE3_RECT.ReleaseTexture         := IDirect3DTexture2.Release
	g_.Dev3_DrawRect := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "IDirect3DDevice3_DrawRect")	
	
	DEVICE2_RECT.BeginScene      := IDirect3DDevice2.BeginScene
	DEVICE2_RECT.EndScene        := IDirect3DDevice2.EndScene 
	DEVICE2_RECT.DrawPrimitive   := IDirect3DDevice2.DrawPrimitive
	DEVICE2_RECT.SetRenderState  := IDirect3DDevice2.SetRenderState
	DEVICE2_RECT.GetRenderState  := IDirect3DDevice2.GetRenderState
	g_.Dev2_DrawRect := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "IDirect3DDevice2_DrawRect")		
}

if (g_.cfg.D3D = "7")
{
	DEVICE3_RECT.BeginScene             := IDirect3DDevice7.BeginScene
	DEVICE3_RECT.EndScene               := IDirect3DDevice7.EndScene
	DEVICE3_RECT.GetView                := IDirect3DDevice7.GetViewport
	DEVICE3_RECT.SetView                := IDirect3DDevice7.SetViewport
	DEVICE3_RECT.DrawPrimitive          := IDirect3DDevice7.DrawPrimitive
	DEVICE3_RECT.SetRenderState         := IDirect3DDevice7.SetRenderState
	DEVICE3_RECT.GetRenderState         := IDirect3DDevice7.GetRenderState
	DEVICE3_RECT.SetTexture             := IDirect3DDevice7.SetTexture
	DEVICE3_RECT.GetTexture             := IDirect3DDevice7.GetTexture
	DEVICE3_RECT.SetTextureStageState   := IDirect3DDevice7.SetTextureStageState
	DEVICE3_RECT.GetTextureStageState   := IDirect3DDevice7.GetTextureStageState
	DEVICE3_RECT.ReleaseTexture         := IDirectDrawSurface7.Release
	g_.Dev7_DrawRect         := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "IDirect3DDevice7_DrawRect")	
	g_.Dev7_DrawRctWithFlags := dllcall("GetProcAddress", uint, g_.h_PeixotoDll, astr, "IDirect3DDevice7_DrawRectWithFlags")	
}

IDirectDrawGammaControl_SetGammaRamp(p1, p2, p3)
{
	hDC := DllCall("GetDC", "Uint", 0, uint)
	DllCall("SetDeviceGammaRamp", "Uint", hDC, "Uint", p3) 
	DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
	return 0
}

__IDirectDraw_SetCooperativeLevel(p1, p2, p3, iface)
{
	funcs := [IDirectDraw.SetCooperativeLevel, IDirectDraw2.SetCooperativeLevel
	         ,IDirectDraw4.SetCooperativeLevel, IDirectDraw7.SetCooperativeLevel]
	return dllcall(funcs[iface], uint, p1, uint, p2, uint, p3)
}

IDirectDraw_SetCooperativeLevel(p1, p2, p3)
{
	if (r := __IDirectDraw_SetCooperativeLevel(p1, p2, (g_.cfg.NEFS) ? DDSCL_NORMAL : p3, A_eventinfo))
	return r
	g_.hwin    := p2
	g_.fllscrn := (p3 & DDSCL_FULLSCREEN)
	if g_.cfg.WSTL
		(g_.fllscrn) ? HideBorder(p2) : ShowBorder(p2)
	dllcall("peixoto.dll\D3D12Config64", str, "HWND", ptr, g_.hwin)
	return r
}

HideBorder(hWin)
{
	s := dllcall("GetWindowLong", uint, hWin, int, -16, uint)
	s &= ~(0x00C00000 | 0x00040000)
	g_.win_style := dllcall("SetWindowLong", uint, hWin, int, -16, uint, s)
	dllcall("SetWindowPos", uint, hWin, int, 0, uint, 0, uint, 0, uint, 0, uint, 0, uint, 0x0637)	
}

ShowBorder(hWin) 
{
	if ! (g_.win_style)
		return
	s := dllcall("GetWindowLong", uint, hWin, int, -16, uint)
	s |= 0x00C00000
	dllcall("SetWindowLong", uint, hWin, int, -16, uint, s)
	dllcall("SetWindowPos", uint, hWin, int, 0, uint, 0, uint, 0, uint, 0, uint, 0, uint, 0x0637)	
}

UpdateGameWin(DD)
{
	(desc:= struct(DDSURFACEDESC)).dwSize  :=  DDSURFACEDESC.size()
	dllcall(IDirectDraw.GetDisplayMode, uint, DD, uint, desc[])
	HideBorder(g_.hwin), dllcall("SetForegroundWindow", uint,  g_.hwin), hwin := g_.hwin 	
	if ! dllcall("SetWindowPos", uint, g_.hwin, int, 0, uint, 0, uint, 0, uint, desc.dwWidth, uint, desc.dwHeight, uint, 0x0454)
	logerr("Failed to resize window " A_lasterror)	
}

UpdateGameWin7(dd7)
{
	if (!g_.fllscrn)
	return	
	(desc:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
	dllcall(IDirectDraw7.GetDisplayMode, uint, dd7, uint, desc[])
	HideBorder(g_.hwin), dllcall("SetForegroundWindow", uint,  g_.hwin), hwin := g_.hwin 	
	if ! dllcall("SetWindowPos", uint, g_.hwin, int, 0, uint, 0, uint, 0, uint, desc.dwWidth, uint, desc.dwHeight, uint, 0x0454)
	logerr("Failed to resize window " A_lasterror)	
}

SetClipper7(p, dd7)
{
	dllcall(IDirectDraw7.CreateClipper, uint, dd7, uint, 0, "ptr*", clpr, uint, 0, uint)
	dllcall(IDirectDrawClipper.SetHwnd, uint, clpr, uint, 0, uint, g_.hwin, uint)
	dllcall(IDirectDrawSurface7.SetClipper, uint, p, ptr, clpr, uint)
	dllcall(IDirectDrawClipper.Release, uint, clpr)
	Process, Priority, , H
}

SetClipper(p, Ifc)
{
	Ifcs := [IDirectDrawSurface, IDirectDrawSurface4]
	clpr := 0
	dllcall(IDirectDraw.CreateClipper, uint, dllcall(g_.p.DDFrmSrfc, uint, p), uint, 0, "ptr*", clpr, uint, 0, uint)
	dllcall(IDirectDrawClipper.SetHwnd, uint, clpr, uint, 0, uint, g_.hwin, uint)
	dllcall(Ifcs[Ifc].SetClipper, uint, p, ptr, clpr, uint)
	dllcall(IDirectDrawClipper.Release, uint, clpr)
	Process, Priority, , H
}

IDirectDraw_Release(p1)
{
	return dllcall(IDirectDraw.Release, uint, p1, uint)-1		
}

flip()
{
	D               := g_.proxies.dev
	g_.proxies.dev  := g_.proxies.prim
	g_.proxies.prim := D	
}

SSAA(byref sz, dd, fmt)
{
	if !g_.cfg.SSAA or !g_.cfg.HD 
	return
	w := D3DHOOKS_DATA.W
	h := D3DHOOKS_DATA.H
	d := D3DHOOKS_DATA.D 
	SetupHD(w, h) 
	D3DHOOKS_DATA.scale := ceil(D3DHOOKS_DATA.scale) * g_.cfg.SSAA
	w	:= D3DHOOKS_DATA.W * D3DHOOKS_DATA.scale 
	h	:= D3DHOOKS_DATA.H * D3DHOOKS_DATA.scale 
	D3DHOOKS_DATA.HD_X  := 0
	rect.left    := 0
	rect.top     := 0
	rect.right   := w-1
	rect.bottom  := h-1
	hRECT.left   := 0
	hRECT.top    := 0
	hRECT.right  := w/2
	hRECT.bottom := h/2
	sz := (w <<16) |h	
	
	logerr("SSAA Setup")
	logerr("W " D3DHOOKS_DATA.W)
	logerr("H " D3DHOOKS_DATA.H)
	logerr("RECT")
	for k, v in rect
		logerr(k " " v)
	
	g_.proxies.prms[7] := D3DHOOKS_DATA.w*D3DHOOKS_DATA.scale
	g_.proxies.prms[8] := D3DHOOKS_DATA.h*D3DHOOKS_DATA.scale
	g_.proxies.prms[5] := 1/g_.proxies.prms[7]
	g_.proxies.prms[6] := 1/g_.proxies.prms[8]
	g_.proxies.prms[11] := g_.proxies.prms[7]/2
	g_.proxies.prms[12] := g_.proxies.prms[8]/2
	g_.proxies.prms[9]  := 1/g_.proxies.prms[11]
	g_.proxies.prms[10] := 1/g_.proxies.prms[12]
	dllcall("peixoto.dll\Scaler", uint, D3DHOOKS_DATA.w, uint, D3DHOOKS_DATA.h, uint, w, uint, h, uint, 0, uint, g_HD.Sclr[]) 	
	if (g_.cfg.SSAA = 4)
	g_.proxies.hlf := (g_.cfg.d3d = 7) ? new Surface7(dd, fmt, ((w/2)<<16 | h/2)) : new Surface(dd, fmt, ((w/2)<<16 | h/2))	

	primary_sz          :=  (_RECT.right + _RECT.left) << 16 | (_RECT.bottom + _RECT.top)
	;primary_sz          := (W) << 16 | (H)	
	g_.proxies.filtered := (g_.cfg.d3d = 7) ? new Surface7(dd, fmt, primary_sz) : new Surface(dd, fmt, primary_sz)
}

NEFS(s, byref D, byref DD, byref sz, byref fmt, byref sys)
{
	DD             := dllcall(g_.p.DDFrmSrfc, uint, s)	
	D              := struct(DDSURFACEDESC2)
	D.dwSize       := DDSURFACEDESC.size()		
	dllcall(IDirectDraw.GetDisplayMode, uint, DD, uint, D[])
	fmt            := (g_.cfg.32bit) ? "X8RGB" : GetPixelFormat(D)
	sys            := fmt = "PAL8"   ? 1 : 0
	sz             := (g_.cfg.HD) ? (D3DHOOKS_DATA.HD_W <<16) | D3DHOOKS_DATA.HD_H
	               :  (D.dwWidth<<16) | D.dwHeight
	SSAA(sz, dd, fmt)		
}

NEFS7(s, byref D, byref dd7, byref sz, byref fmt, byref sys)
{
	dllcall(IDirectDrawSurface7.GetDDInterface, uint, s, "Uint*", dd7:=0)
	D              := struct(DDSURFACEDESC2)
	D.dwSize       := DDSURFACEDESC2.size()		
	dllcall(IDirectDraw7.GetDisplayMode, uint, dd7, uint, D[])
	fmt            := (g_.cfg.32bit) ? "X8RGB" : GetPixelFormat(D)
	sys            := fmt = "PAL8"   ? 1 : 0
	sz             := (g_.cfg.HD) ? (D3DHOOKS_DATA.HD_W <<16) | D3DHOOKS_DATA.HD_H
	               :  (D.dwWidth<<16) | D.dwHeight
	SSAA(sz, dd7, fmt)			   
	dd7 ? dllcall(IDirectDraw7.release, uint, dd7)			   
}


/* ========================================================================
 * =============================DIRECTX 1-6================================
 */
 
/* ========================================================================
 * =============================DirectDraw=================================
 */
 

IDirectDraw2_GetAvailableVidMem(p1, p2, p3, p4)
{
	total:=0, free:=0
	if !(r := dllcall(IDirectDraw2.GetAvailableVidMem, uint, p1, uint, p2, "uint*", total, "uint*", free))
	{
		if (total > 0x7fffffff)
		{
			total >>= 1
			free  >>= 1
		}
		p3 ? numput(total, p3+0, "uint")
		p4 ? numput(free, p4+0, "uint")
	}
	return r
}

IDirectDraw4_GetAvailableVidMem(p1, p2, p3, p4)
{
	total:=0, free:=0
	if !(r := dllcall(IDirectDraw4.GetAvailableVidMem, uint, p1, uint, p2, "uint*", total, "uint*", free))
	{
		if (total > 0x7fffffff)
		{
			total >>= 1
			free  >>= 1
		}
		p3 ? numput(total, p3+0, "uint")
		p4 ? numput(free, p4+0, "uint")
	}
	return r
} 
 
IDirectDraw_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{
	DDSURFACEDESC[] := pSurfaceDesc	
	if r := dllcall(g_.p.CreateSrfc, uint, pIDirectDraw, uint, DDSURFACEDESC[], uint, ppSurface, uint, pIUnknown
	                               , uint, IDirectDraw.CreateSurface, uint, D3DHOOKS_DATA[], "uint*", p:=0)
	return r						   
		
	if (p=1)
	{
		g_.proxies.flp := ""
		g_.rtrgt   := ""
		g_.device  := ""
		g_.device2 := ""
		g_.device3 := ""
		g_.primary := numget(ppSurface+0, "uint")
		(g_.cfg.HD or  g_.cfg.NEFS) ? UpdateGameWin(dllcall(g_.p.DDFrmSrfc, uint, g_.primary))	
		(g_.cfg.NEFS) ? SetClipper(g_.primary, 1)
		dllcall(IDirectDrawSurface.blt, uint, g_.primary, uint, 0, uint, 0, uint, 0, uint, DDBLT_COLORFILL, uint, DDBLTFX[], uint)
		if (g_.cfg.HD or g_.cfg.32bit)
		{
			SetupPrxs4(dllcall(g_.p.DDFrmSrfc, uint, g_.primary))	
		} 
	} else dllcall(g_.p.DDSSrfcAttchDat, ptr, numget(ppSurface+0, "ptr"))		
	return r
}

IDirectDraw2_CreateSurface(pIDirectDraw, pSurfaceDesc, ppSurface, pIUnknown)
{
	DDSURFACEDESC[] := pSurfaceDesc
	if r := dllcall(g_.p.CreateSrfc, uint, pIDirectDraw, uint, DDSURFACEDESC[], uint, ppSurface, uint, pIUnknown
	                               , uint, IDirectDraw2.CreateSurface, uint, D3DHOOKS_DATA[], "uint*", p:=0)
	return r	
		
	if (p=1)
	{
		g_.proxies.flp := ""
		g_.rtrgt   := ""
		g_.device  := ""
		g_.device2 := ""
		g_.device3 := ""
		g_.primary := numget(ppSurface+0, "uint")
		(g_.cfg.HD or  g_.cfg.NEFS) ? UpdateGameWin(dllcall(g_.p.DDFrmSrfc, uint, g_.primary))	
		(g_.cfg.NEFS) ? SetClipper(g_.primary, 1)
		dllcall(IDirectDrawSurface.blt, uint, g_.primary, uint, 0, uint, 0, uint, 0, uint, DDBLT_COLORFILL, uint, DDBLTFX[], uint)
		if (g_.cfg.HD or g_.cfg.32bit)
		{
			SetupPrxs4(dllcall(g_.p.DDFrmSrfc, uint, g_.primary))	
		} 
	} else dllcall(g_.p.DDSSrfcAttchDat, ptr, numget(ppSurface+0, "ptr"))		
	return r
}
 
IDirectDraw4_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown)
{
	DDSURFACEDESC2[] := pSurfaceDesc
	if r := dllcall(g_.p.CreateSrfc, uint, pIDirectDraw4, uint, DDSURFACEDESC2[], uint, ppSurface, uint, pIUnknown
	                               , uint, IDirectDraw4.CreateSurface, uint, D3DHOOKS_DATA[], "uint*", p:=0)
	return r	
	
	if (p=1)
	{
		g_.proxies.flp := ""
		g_.rtrgt   := ""
		g_.device  := ""
		g_.device2 := ""
		g_.device3 := ""
		g_.pIDirectDraw4 := pIDirectDraw4
		g_.primary4      := numget(ppSurface+0, "uint")
		(g_.cfg.HD or  g_.cfg.NEFS) ? UpdateGameWin(dllcall(g_.p.DDFrmSrfc, uint, g_.primary4))
		(g_.cfg.NEFS)               ? SetClipper(g_.primary4, 2)		
		printl("IDirectDraw4_CreateSurface" r  ":" ddraw.err[r . ""])		
		if (g_.cfg.HD or g_.cfg.32bit)
		{
			SetupPrxs4(dllcall(g_.p.DDFrmSrfc, uint, g_.primary4))					
		} 
	} else dllcall(g_.p.DDSSrfcAttchDat, ptr, numget(ppSurface+0, "ptr"))	
	return r
} 

IDirectDraw_GetDisplayMode(p1, p2)
{
	if ( (r := dllcall(IDirectDraw.GetDisplayMode, uint, p1, uint, p2)) = 0 )
	{
		DDSURFACEDESC[] := p2
		(g_.cfg.32bit) ? SetPixelFormat(DDSURFACEDESC)
		if (g_.cfg.HD) && D3DHOOKS_DATA.D
		{
			DDSURFACEDESC.dwWidth  := D3DHOOKS_DATA.w
			DDSURFACEDESC.dwHeight := D3DHOOKS_DATA.h
			DDSURFACEDESC.lPitch   := D3DHOOKS_DATA.w * D3DHOOKS_DATA.D/4
		}		
	} return r
}

IDirectDraw4_GetDisplayMode(p1, p2)
{
	if ( (r := dllcall(IDirectDraw4.GetDisplayMode, uint, p1, uint, p2)) = 0 )
	{
		DDSURFACEDESC2[] := p2
		(g_.cfg.32bit) ? SetPixelFormat(DDSURFACEDESC2)
		if (g_.cfg.HD) && D3DHOOKS_DATA.D
		{
			DDSURFACEDESC2.dwWidth  := D3DHOOKS_DATA.w
			DDSURFACEDESC2.dwHeight := D3DHOOKS_DATA.h
			DDSURFACEDESC2.lPitch   := D3DHOOKS_DATA.w * D3DHOOKS_DATA.D/4
		}		
	} return r
}

/* ========================================================================
 * =============================Surfaces===================================
 */
 
IDirectDrawSurface_AddAttachedSurface(p1, p2)
{
	if (GetSurfaceCaps(p2) & DDSCAPS_ZBUFFER)
	{	
		g_.proxies.z := new zprx(p1, p2)
		p2           := g_.proxies.z.Surface
	}
	return dllcall(IDirectDrawSurface.AddAttachedSurface, uint, p1, uint, p2)
}

IDirectDrawSurface_GetSurfaceDesc(p1, p2)
{
	if (r := dllcall(IDirectDrawSurface.GetSurfaceDesc, uint, p1, uint, p2))
	return r
	caps := GetSurfaceCaps(p1)
	
	if ((caps & DDSCAPS_PRIMARYSURFACE) || (caps & DDSCAPS_FLIP))
	{
		(desc:= struct(DDSURFACEDESC)).dwSize  :=  DDSURFACEDESC.size()
		if ! dllcall(IDirectDrawSurface.GetSurfaceDesc, uint, g_.proxies.dev.surface, uint, desc[])
		{
			DDSURFACEDESC[] := p2
			(g_.cfg.32bit) ? SetPixelFormat(DDSURFACEDESC)
			DDSURFACEDESC.dwWidth  := desc.dwWidth
			DDSURFACEDESC.dwHeight := desc.dwHeight 
			DDSURFACEDESC.lPitch   := desc.lPitch ;*2			
		}
	} return r	
}

IDirectDrawSurface4_GetSurfaceDesc(p1, p2)
{
	if (r := dllcall(IDirectDrawSurface4.GetSurfaceDesc, uint, p1, uint, p2))
	return r
	
	caps := GetSurfaceCaps4(p1)	
	if ((caps & DDSCAPS_PRIMARYSURFACE) || (caps & DDSCAPS_FLIP))
	{
		(desc:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
		if ! dllcall(IDirectDrawSurface4.GetSurfaceDesc, uint, g_.proxies.dev.surface4, uint, desc[])
		{
			DDSURFACEDESC2[] := p2
			(g_.cfg.32bit) ? SetPixelFormat(DDSURFACEDESC2)
			if (g_.cfg.HD) 
			{
				DDSURFACEDESC2.dwWidth  := desc.dwWidth
				DDSURFACEDESC2.dwHeight := desc.dwHeight
				DDSURFACEDESC2.lPitch   := desc.lPitch
			}
		}
	}
	return r
}

IDirectDrawSurface_GetPixelFormat(p1, p2)
{
	if (caps := GetSurfaceCaps(p1)) & DDSCAPS_PRIMARYSURFACE  
	or (caps & DDSCAPS_3DDEVICE) or (caps & DDSCAPS_FLIP) 
		return dllcall("peixoto.dll\SetDDSurfacePixelFormat", uint, p2, astr, (D3DHOOKS_DATA.D=16) ? "RG6B" : (D3DHOOKS_DATA.D=8) ? "PAL8" : "X8RGB")
	return dllcall(IDirectDrawSurface.GetPixelFormat, uint, p1, uint, p2)	
}

IDirectDrawSurface_Restore(p1)
{
	if (GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE) 
	{
		for k, v in g_.proxies
			v.check()			
	}
	return dllcall(IDirectDrawSurface.Restore, uint, p1)
}

IDirectDrawSurface_GetAttachedSurface(p1, p2, p3)
{
	if !(p2&&p3&&p1)
	return DDERR_INVALIDPARAM	
	if ( GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE )
	{
		NEFS(p1, D, DD, sz, fmt, sys)		
		g_.proxies.flp := new Surface(DD, fmt, sz, sys)
		g_.proxies.flp.Attach((f:=new Surface(DD, fmt, sz, sys)).surface)	
		numput(g_.proxies.flp.surface, p3+0, "uint")
		dllcall(IDirectDrawSurface.addref, uint, g_.proxies.flp.surface) 		
		return 0
	} 
	else if (numget(p2+0, "uint") & DDSCAPS_ZBUFFER)
	{
		; return now or brake nocturne and TR2
		;return dllcall(IDirectDrawSurface.GetAttachedSurface, uint, p1, uint, p2, uint, p3)
		if (g_.proxies.z)
		{
			GUID_FromString(iid, ddraw.IID_IDirectDrawSurface)
			if (dllcall(IDirectDrawSurface.QueryInterface, ptr, g_.proxies.z.id, ptr, &iid, ptr, p3) = 0)
			return 0
		}
	}
	return dllcall(IDirectDrawSurface.GetAttachedSurface, uint, p1, uint, p2, uint, p3)
}

IDirectDrawSurface4_GetAttachedSurface(p1, p2, p3)
{
	if ( GetSurfaceCaps4(p1) & DDSCAPS_PRIMARYSURFACE )
	{
		if (!isobject(g_.proxies.flp))
		{
			NEFS(p1, D, DD, sz, fmt, sys)	
			g_.proxies.flp := new Surface(DD, fmt, sz, sys)
			g_.proxies.flp.Attach((f:=new Surface(DD, fmt, sz, sys)).surface)	
		}
		numput(g_.proxies.flp.surface4, p3+0, "uint")
		dllcall(IDirectDrawSurface.addref, uint, g_.proxies.flp.surface) 	
		return 0		
	} 
	else if (numget(p2+0, "uint") & DDSCAPS_ZBUFFER)
	{
		; return now or brake TR5
		;return dllcall(IDirectDrawSurface4.GetAttachedSurface, uint, p1, uint, p2, uint, p3)
		if (g_.proxies.z)
		{
			GUID_FromString(iid, ddraw.IID_IDirectDrawSurface4)
			if (dllcall(IDirectDrawSurface.QueryInterface, ptr, g_.proxies.z.id, ptr, &iid, ptr, p3) = 0)
			return 0
		}
	}
	r := dllcall(IDirectDrawSurface4.GetAttachedSurface, uint, p1, uint, p2, uint, p3)	
	return r
}

SrfEnum(p1, p2, p3)
{
	static s
	if p1
	{
		s := p1
		return 0 ;DDENUMRET_CANCEL 
	}
	return s	
}

IDirectDrawSurface_EnumAttachedSurfaces(p1, p2, p3)
{
	if ( GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE )
	{
		NEFS(p1, D, DD, sz, fmt, sys)	
		D.ddsCaps.dwCaps := DDSCAPS_BACKBUFFER | DDSCAPS_FLIP | DDSCAPS_3DDEVICE		
		if (g_.cfg.HD)
		{
			D.dwWidth  := D3DHOOKS_DATA.W
			D.dwHeight := D3DHOOKS_DATA.H
		}
		if (g_.cfg.32bit)
			SetPixelFormat(D)		
		if (g_.cfg.NEFS || g_.cfg.SSAA)
		{
			g_.proxies.flp := new Surface(DD, fmt, sz, sys)
			g_.proxies.flp.Attach((f:=new Surface(DD, fmt, sz, sys)).surface)	
			dllcall(IDirectDrawSurface.addref, uint, g_.proxies.flp.surface) 
			dllcall(p3, uint, g_.proxies.flp.surface, uint, D[], uint, p2)
		}
		else
		{
			if dllcall(IDirectDrawSurface.GetAttachedSurface, uint, p1, uint, DDSCAPS_BACKBUFFER, "uint*", f:=0)
			{
				c := RegisterCallback("SrfEnum")
				dllcall(IDirectDrawSurface.EnumAttachedSurfaces, uint, p1, uint, p2, uint, c)
				DllCall("GlobalFree", "Ptr", c, "Ptr")
				f := SrfEnum(0,0,0)	
			}
			dllcall(p3, uint, f, uint, D[], uint, p2)
		}			
		return					
	}
	return dllcall(IDirectDrawSurface.EnumAttachedSurfaces, uint, p1, uint, p2, uint, p3)
}

IDirectDrawSurface4_EnumAttachedSurfaces(p1, p2, p3)
{
	if ( GetSurfaceCaps4(p1) & DDSCAPS_PRIMARYSURFACE )
	{
		NEFS(p1, D, DD, sz, fmt, sys)	
		D.dwSize         := DDSURFACEDESC2.size()		
		D.ddsCaps.dwCaps := DDSCAPS_BACKBUFFER | DDSCAPS_FLIP | DDSCAPS_3DDEVICE		
		if (g_.cfg.HD)
		{
			D.dwWidth  := D3DHOOKS_DATA.W
			D.dwHeight := D3DHOOKS_DATA.H
		}
		if (g_.cfg.32bit)
			SetPixelFormat(D)		
		if (g_.cfg.NEFS || g_.cfg.SSAA)
		{
			g_.proxies.flp := new Surface(DD, fmt, sz, sys)
			g_.proxies.flp.Attach((f:=new Surface(DD, fmt, sz, sys)).surface)	
			dllcall(IDirectDrawSurface.addref, uint, g_.proxies.flp.surface) 
			dllcall(p3, uint, g_.proxies.flp.surface4, uint, D[], uint, p2)
		}
		else
		{
			if dllcall(IDirectDrawSurface4.GetAttachedSurface, uint, p1, uint, DDSCAPS_BACKBUFFER, "uint*", f:=0)
			{
				c := RegisterCallback("SrfEnum")
				dllcall(IDirectDrawSurface4.EnumAttachedSurfaces, uint, p1, uint, p2, uint, c)
				DllCall("GlobalFree", "Ptr", c, "Ptr")
				f := SrfEnum(0,0,0)				
			}
			dllcall(p3, uint, f, uint, D[], uint, p2)
		}			
		return			
	}
	return dllcall(IDirectDrawSurface4.EnumAttachedSurfaces, uint, p1, uint, p2, uint, p3)
}

DDWait(s, f="")
{
	if ! (g_.cfg.SYNC || f)
	return
	
	d := dllcall(g_.p.DDFrmSrfc, uint, s)
	dllcall(IDirectDraw.WaitForVerticalBlank, uint, d, uint, 1, uint, 0)
	if (g_.cfg.SYNC = 2)
	{
		dllcall(IDirectDraw.WaitForVerticalBlank, uint, d, uint, 4, uint, 0)
		dllcall(IDirectDraw.WaitForVerticalBlank, uint, d, uint, 1, uint, 0)
	}	
}

IDirectDrawSurface_flip(p1, p2, p3)
{    
	if (isobject(g_tswap.dly))
	{
		while (g_tswap.dly.length())
		{
			dllcall(IDirect3DTexture.Release, ptr, g_tswap.dly.Remove(1))
		}		
	}
	if ! (g_.rtrgt)
	{		
		flip()
		g_.Device3 ? dllcall(IDirect3DDevice3.SetRenderTarget, uint, g_.Device3, uint, g_.proxies.dev.surface4)
		: g_.Device2 ? dllcall(IDirect3DDevice2.SetRenderTarget, uint, g_.Device2, uint, g_.proxies.dev.surface)
		DDWait(p1, p2&DDFLIP_WAIT)
		Surface1UpDatePrim(p1, g_.proxies.skp := 0)
		return 0 ; TODO: Some error checking here
	}
	else if (D3DHOOKS_DATA.Delay = 2)
	{
		Surface1UpDateRT(0, g_.cfg.cpy)
		D3DHOOKS_DATA.Delay := 1
	}
    ; drakan SSAA shadow glich: g_.proxies.d3d.draw()
	if (g_.cfg.SSAA){	
		dvc := new D3DDevice(dllcall(g_.p.DDFrmSrfc, ptr,  g_.proxies.filtered.surface))		
		if (g_.cfg.SSAA=4)	
		{			
			D3DBlt(g_.proxies.hlf, hRECT[], g_.proxies.flp, 0, 3, DDBLTFX[], dvc)
			D3DBlt({"surface" : g_.proxies.filtered.surface, "surface4" :  g_.proxies.filtered.surface4}, _RECT[], g_.proxies.hlf, 0, 3, DDBLTFX[], dvc)				
		} else {				
			D3DBlt({"surface" : g_.proxies.filtered.surface, "surface4" :  g_.proxies.filtered.surface4}, _RECT[], g_.proxies.flp, 0, g_.cfg.SSAA=1?0:3 g, DDBLTFX[], dvc)			
		}
		DDWait(p1, p2&DDFLIP_WAIT)	
		dllcall(IDirectdrawSurface.blt, uint, p1, uint, _RECT[], uint, g_.proxies.filtered.surface4, uint, _RECT[], uint, 0, uint, DDBLTFX[], uint)				
		return
	}
	else if (g_.cfg.NEFS)
	{
		DDWait(p1, p2&DDFLIP_WAIT)
		r := dllcall(IDirectdrawSurface.blt, uint, p1, uint, 0, uint, g_.rtrgt, uint, 0, uint, 0, uint, DDBLTFX[], uint)
		dllcall(IDirectDrawSurface.flip, uint, g_.rtrgt, uint, 0, uint, 0)			
		return r
	} 
	DDWait(p1, p2&DDFLIP_WAIT)    
	r := dllcall(IDirectDrawSurface.flip, uint, p1, uint, p2, uint, p3)	
	return r								  
}

/* ========================================================================
 * =============================Palettes===================================
 */

IDirectDrawSurface_GetPalette(p1, p2)
{
	if (GetSurfaceCaps(p1) & DDSCAPS_PRIMARYSURFACE)
    p1 := g_.proxies.prim.surface
	return dllcall(IDirectDrawSurface.GetPalette, uint, p1, uint, p2)	
}

IDirectDrawSurface_SetPalette(p1, p2)
{
	if ( (caps := GetSurfaceCaps(p1)) & DDSCAPS_PRIMARYSURFACE  )
    {
        if (!g_cfg.layer)
        {
            logerr(IDirectDrawSurface.PatchVtableWithDll("lock", "LockSurfaceHook"))
            logerr(IDirectDrawSurface.PatchVtableWithDll("Unlock", "UnLockSurfaceHook"))
        }
		
		p1              := g_.proxies.prim.surface
		g_.proxies.pltt := p2	

		dllcall(IDirectDrawPalette.GetCaps, uint, p2, "uint*", cps:=0)	
		(cps & DDPCAPS_ALLOW256) 
		? logerr("Get entries " DllCall(IDirectDrawPalette.GetEntries, ptr, p2, uint, 0, uint, 0, uint, 256, ptr, g_.palette)) 
		: logerr("Get entries " DllCall(IDirectDrawPalette.GetEntries, ptr, p2, uint, 1, uint, 0, uint, 255, ptr, g_.palette))		
	} return 0 ;dllcall(IDirectDrawSurface.SetPalette, uint, p1, uint, p2) ;breaks mageslayer and jedi knight
	return 0
}

IDirectDrawPalette_SetEntries(p1, p2, p3, p4, p5)
{
	if (p1 = g_.proxies.pltt)
	{
		cps:=0
		dllcall("RtlMoveMemory", ptr, g_.palette+(p3)*4, ptr, p5, int, (p4)*4)
		dllcall(IDirectDrawPalette.GetCaps, uint, p1, "uint*", cps)
		if ! (cps & DDPCAPS_ALLOW256)
		{
			numput(0, g_.palette+0, "uint")
			numput(0xffffffff, g_.palette+1020, "uint")
		}
		Surface1UpDatePrim((g_.cfg.d3d=7) ? g_.primary7 : g_.primary, 0)
	} ;else return dllcall(IDirectDrawPalette.SetEntries, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
	return dllcall(IDirectDrawPalette.SetEntries, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)
	return 0
}

IDirectDrawPalette_GetEntries(p1, p2, p3, p4, p5)
{
	;if (p1 = g_.proxies.pltt)
	;dllcall("RtlMoveMemory", ptr, p5, ptr, g_.palette+(p3)*4, int, (p4)*4)	
	;else 
	return dllcall(IDirectDrawPalette.GetEntries, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)	
}

/* ========================================================================
 * =============================Devices====================================
 */

Dvc1Query(p1, p2, p3)
{
	if ! (r := dllcall(IDirectDrawSurface.QueryInterface, uint, p1, uint, p2, uint, p3))
	{
		g_.rtrgt       := p1
		g_.device      := numget(p3+0, "ptr")
		
		if (parsecfg(g_.cfg.TextSwap).e)		
		{		
			;fixes forsaken, but breaks mageslayer
			;IDirectDrawSurface4.UnHook("Release")
			TSwapDvc1_2Created()
		}
	}
	return r	
}

IDirect3D2_CreateDevice(p1, p2, p3, p4)
{
	STATIC H
	r := dllcall(IDirect3D2.CreateDevice, uint, p1, uint, p2, uint, p3, uint, p4)
	if (r)
	{
		logerr("IDirect3D2::CreateDevice failed " r d3d.err[r . ""])
		return r
	}
	g_.rtrgt   := p3
	g_.device  := "" ; die by the sword, may break others	
	g_.Device2 := numget(p4+0, "Ptr")
	if (parsecfg(g_.cfg.TextSwap).e)	
	{
		TSwapDvc1_2Created()
	}	
	if (g_.proxies.dev)
		dllcall(IDirectdrawSurface.blt, uint, g_.proxies.dev.Surface, uint, 0, uint, 0, uint, 0
									  , uint, DDBLT_COLORFILL, uint, g_HD.DDBLTFX[], uint)
	return r	
}

IDirect3D3_CreateDevice(p1, p2, p3, p4, p5)
{
	STATIC H=
	r := dllcall(IDirect3D3.CreateDevice, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint)
	g_.rtrgt   := p3
	g_.Device3 := numget(p4+0, "Ptr")
	Logerr("IDirect3DDevice3 " r " " d3d.err[r . ""])	
	if (parsecfg(g_.cfg.TextSwap).e)	
	{
		g_tswap.load := func("LoadTexture2")
		if !(H)
		{
			logerr(IDirect3DTexture.unhook("Release"))
			H := true
		}
	}
	if (g_.proxies.dev)
		dllcall(IDirectdrawSurface4.blt, uint, g_.proxies.dev.Surface4, uint, 0, uint, 0, uint, 0
									   , uint, DDBLT_COLORFILL, uint, g_HD.DDBLTFX[], uint)
									   
	return r	
}
 
IDirect3DDevice_EndScene(p1)
{
	r := dllcall(IDirect3DDevice.EndScene, uint, p1)
	TSwapBrowseSurfaces()	
	D3DHOOKS_DATA.Chck := 0
	if (!g_tswap.e || g_.device3)	
	return r		
	
	static clr := 0x00ffffff		
	keyevent(g_tswap.c)  ? clr := cicleColor(clr)
	keyevent(g_tswap.sw) ? D3DHOOKS_DATA.search_enabled := (D3DHOOKS_DATA.search_enabled) & True ? False : True
		
	(D3DHOOKS_DATA.search_enabled) & True ? (g_.device) ? BrowseTextures(g_.rtrgt, clr)	
	: (g_.device2) ? BrowseTextures2(g_.rtrgt, clr)		
	return r
}
  
IDirect3DDevice3_EndScene(p1)
{
	r := dllcall(IDirect3DDevice3.EndScene, uint, p1)
	TSwapBrowseSurfaces()	
	D3DHOOKS_DATA.Chck := 0	
	if ( !g_tswap.e || !g_.device3)	
	return r		
	
	static clr := 0x00ffffff			
	keyevent(g_tswap.c)  ?	clr := cicleColor(clr)
	keyevent(g_tswap.sw) ? D3DHOOKS_DATA.search_enabled := (D3DHOOKS_DATA.search_enabled) & True ? False : True
		
	(D3DHOOKS_DATA.search_enabled) & True ? BrowseDevice3Textures2(g_.rtrgt, clr)		 
	return r
}

IDirect3DDevice3_BeginScene(p1)
{
	if (D3DHOOKS_DATA.Delay = 2)
	{
		Surface1UpDateRT(0, g_.cfg.cpy)
		D3DHOOKS_DATA.Delay := 1
	}
	return dllcall(IDirect3DDevice3.BeginScene, uint, p1)
}

IDirect3DDevice2_BeginScene(p1)
{
	if (D3DHOOKS_DATA.Delay = 2)
	{
		Surface1UpDateRT(0, g_.cfg.cpy)
		D3DHOOKS_DATA.Delay := 1
	}
	return dllcall(IDirect3DDevice2.BeginScene, uint, p1)
}

IDirect3DDevice2_SetRenderTarget(p1, p2, p3)
{
	r := dllcall(IDirect3DDevice2.SetRenderTarget, uint, p1, uint, p2, uint, p3)
	if (r = 0)
		g_.rtrgt := p2
	return r
}

/* ========================================================================
 * =============================DirectX 7 =================================
 */
 
IDirectDrawSurface7_AddAttachedSurface(p1, p2)
{
	if (GetSurfaceCaps7(p2) & DDSCAPS_ZBUFFER)
	{
		g_.proxies.z := new zprx7(p1, p2)
		p2           := (g_.proxies.z.Surface7) ? g_.proxies.z.Surface7 : g_.proxies.z.Surface
	}
	return dllcall(IDirectDrawSurface7.AddAttachedSurface, uint, p1, uint, p2)
} 
 
IDirectDraw7_GetDisplayMode(p1, p2)
{
	if ( (r := dllcall(IDirectDraw7.GetDisplayMode, uint, p1, uint, p2)) = 0 )
	{
		DDSURFACEDESC2[] := p2
		(g_.cfg.32bit) ? SetPixelFormat(DDSURFACEDESC2)
		if (g_.cfg.HD) && D3DHOOKS_DATA.D
		{
			DDSURFACEDESC2.dwWidth  := D3DHOOKS_DATA.w
			DDSURFACEDESC2.dwHeight := D3DHOOKS_DATA.h
			DDSURFACEDESC2.lPitch   := D3DHOOKS_DATA.w * D3DHOOKS_DATA.D/4
		}		
	} return r
} 

IDirectDraw7_CreateSurface(p1, p2, p3, p4)
{
	if r := dllcall(g_.p.CreateSrfc, uint, p1, uint, p2, uint, p3, uint, p4, uint, IDirectDraw7.CreateSurface, uint, D3DHOOKS_DATA[], "uint*", p:=0)
	return r	
	
	if (p=1)
	{
		g_.proxies.flp := ""
		g_.Dev7     := ""
		g_.rtrgt    := ""
		g_.primary7 := numget(p3+0, "uint")
		(g_.cfg.HD or  g_.cfg.NEFS) ? UpdateGameWin7(p1)
		(g_.cfg.NEFS) ? SetClipper7(g_.primary7, p1)
		if g_.cfg.HD or g_.cfg.32bit
		{
			logerr("Setup proxies")
			SetupPrxs7(p1, g_.primary7)					
		}	
	}else if ( (p=3) && parsecfg(g_.cfg.TextSwap).e )	
		g_tswap.textures._add(s:=numget(p3+0, "uint"), s)	
	return r
}

IDirectDrawSurface7_GetPixelFormat(p1, p2)
{
	if (caps := GetSurfaceCaps7(p1)) & DDSCAPS_PRIMARYSURFACE  
	or (caps & DDSCAPS_3DDEVICE) or (caps & DDSCAPS_FLIP) 
		return dllcall("peixoto.dll\SetDDSurfacePixelFormat", uint, p2, astr, (D3DHOOKS_DATA.D=16) ? "RG6B" : (D3DHOOKS_DATA.D=8) ? "PAL8" : "X8RGB")
	return dllcall(IDirectDrawSurface7.GetPixelFormat, uint, p1, uint, p2)	
}

IDirectDrawSurface7_GetSurfaceDesc(p1, p2)
{
	if (r := dllcall(IDirectDrawSurface7.GetSurfaceDesc, uint, p1, uint, p2))
	return r
	caps := GetSurfaceCaps7(p1)
	if (caps & DDSCAPS_FLIP) or (caps & DDSCAPS_PRIMARYSURFACE)
	{
		(desc:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
		if ! dllcall(IDirectDrawSurface7.GetSurfaceDesc, uint, g_.proxies.dev.surface7, uint, desc[])
		{
			DDSURFACEDESC2[] := p2
			(g_.cfg.32bit) ? SetPixelFormat(DDSURFACEDESC2)
			if (g_.cfg.HD) 
			{
				DDSURFACEDESC2.dwWidth  := desc.dwWidth
				DDSURFACEDESC2.dwHeight := desc.dwHeight
				DDSURFACEDESC2.lPitch   := desc.lPitch
			}
		}
	}
	return r
}

IDirectDrawSurface7_GetAttachedSurface(p1, p2, p3)
{
	if ( GetSurfaceCaps7(p1) & DDSCAPS_PRIMARYSURFACE )
	{		
		NEFS7(p1, D, dd7, sz, fmt, sys)	
		g_.proxies.flp := new Surface7(dd7, fmt, sz, sys)
		g_.proxies.flp.Attach((f:=new Surface7(dd7, fmt, sz, sys)).surface)	
		dllcall(IDirectDrawSurface7.addref, uint, g_.proxies.flp.surface7) 
		
		(g_.cfg.32bit)   ? SetPixelFormat(D)
		D.ddsCaps.dwCaps := DDSCAPS_BACKBUFFER | DDSCAPS_FLIP | DDSCAPS_3DDEVICE
		numput(g_.proxies.flp.surface7, p3+0, "uint")
		return 		
	}
	return dllcall(IDirectDrawSurface7.GetAttachedSurface, uint, p1, uint, p2, uint, p3)
}

IDirectDrawSurface7_EnumAttachedSurfaces(p1, p2, p3)
{
	if ( GetSurfaceCaps7(p1) & DDSCAPS_PRIMARYSURFACE )
	{
		NEFS7(p1, D, dd7, sz, fmt, sys)	
		D.ddsCaps.dwCaps := DDSCAPS_BACKBUFFER | DDSCAPS_FLIP | DDSCAPS_3DDEVICE
		
		if (g_.cfg.HD)
		{
			D.dwWidth  := D3DHOOKS_DATA.W
			D.dwHeight := D3DHOOKS_DATA.H
		}
		if (g_.cfg.32bit)
			SetPixelFormat(D)
		
		if (g_.cfg.NEFS || g_.cfg.SSAA)
		{
			g_.proxies.flp := new Surface7(dd7, fmt, sz, sys)
			g_.proxies.flp.Attach((f:=new Surface7(dd7, fmt, sz, sys)).surface)	
			dllcall(IDirectDrawSurface7.addref, uint, g_.proxies.flp.surface7) 
			dllcall(p3, uint, g_.proxies.flp.surface7, uint, D[], uint, p2)
		}		
		else
		{
			if dllcall(IDirectDrawSurface7.GetAttachedSurface, uint, p1, uint, DDSCAPS_BACKBUFFER, "uint*", f:=0)
			{
				c := RegisterCallback("SrfEnum")
				dllcall(IDirectDrawSurface7.EnumAttachedSurfaces, uint, p1, uint, p2, uint, c)
				DllCall("GlobalFree", "Ptr", c, "Ptr")
				f := SrfEnum(0,0,0)				
			}
			dllcall(p3, uint, f, uint, D[], uint, p2)
		}			
		return 		
	}
	return dllcall(IDirectDrawSurface7.EnumAttachedSurfaces, uint, p1, uint, p2, uint, p3)
}

IDirectDrawSurface7_flip(p1, p2, p3)
{
	if ! (g_.rtrgt)
	{
		flip()
		Surface1UpDatePrim(p1, 0)
		return 0 ; TODO: Some error checking here
	}
	else if (D3DHOOKS_DATA.Delay = 2)
	{
		Surface1UpDateRT(0, g_.cfg.cpy)
		D3DHOOKS_DATA.Delay := 1
	}
	if (g_.cfg.SSAA){	
		;dvc := new D3DDevice7(dllcall(g_.p.DDFrmSrfc, ptr, g_.proxies.filtered.surface))	
		dvc := g_.proxies.D3DZ	
		if (g_.cfg.SSAA=4)	
		{			
			D3DBlt(g_.proxies.hlf, hRECT[], g_.proxies.flp, 0, 3, DDBLTFX[], dvc)
			D3DBlt({"surface" : g_.proxies.filtered.surface, "surface7" : g_.proxies.filtered.surface7}, _RECT[], g_.proxies.hlf, 0, 3, DDBLTFX[], dvc)				
		} else {				
			D3DBlt({"surface" : g_.proxies.filtered.surface, "surface7" : g_.proxies.filtered.surface7}, _RECT[], g_.proxies.flp, 0, g_.cfg.SSAA=1?0:3 g, DDBLTFX[], dvc)							
		}
		DDWait(p1, p2&DDFLIP_WAIT)	
		dllcall(IDirectdrawSurface7.blt, uint, p1, uint, _RECT[], uint, g_.proxies.filtered.surface7, uint, _RECT[], uint, 0, uint, DDBLTFX[], uint)				
		return
	}	
	else if g_.cfg.NEFS
	{
		DDWait(p1, p2&DDFLIP_WAIT)		
		r := dllcall(IDirectdrawSurface7.blt, uint, p1, uint, 0, uint, g_.rtrgt, uint, 0, uint, 0, uint, g_HD.DDBLTFX[], uint)
		dllcall(IDirectdrawSurface7.flip, uint, g_.rtrgt, uint, p2, uint, p3)		
		return r
	}	
	DDWait(p1, p2&DDFLIP_WAIT)		
	r := dllcall(IDirectdrawSurface7.flip, uint, p1, uint, p2, uint, p3)	
	return							  
}

IDirect3DDevice7_BeginScene(p1)
{
	if (D3DHOOKS_DATA.Delay = 2)
	{
		Surface1UpDateRT(0, g_.cfg.cpy)
		D3DHOOKS_DATA.Delay := 1
	}
	return dllcall(IDirect3DDevice7.BeginScene, uint, p1)
}

IDirect3DDevice7_EndScene(p1)
{
	r := dllcall(IDirect3DDevice7.EndScene, uint, p1)   
	TSwapBrowseSurfaces()	 
	if (!g_tswap.e)
		return r		
		
	static clr := 0x00ffffff			
	keyevent(g_tswap.c)  ? clr := cicleColor(clr)
	keyevent(g_tswap.sw) ? D3DHOOKS_DATA.search_enabled := (D3DHOOKS_DATA.search_enabled) & True ? False : True	
	(D3DHOOKS_DATA.search_enabled) & True ? BrowseTextures7(g_.rtrgt, clr)	
	return r
}

IDirect3D7_CreateDevice(p1, p2, p3, p4)
{
	if (g_.cfg.FHAL)
	{
		GUID_FromString(iid,d3d.IID_IDirect3DHALDevice)
		p2 := &iid
	}		
	r := dllcall(IDirect3D7.CreateDevice, uint, p1, uint, p2, uint, p3, uint, p4)
	if (r = 0)
	{
		g_.Dev7  := numget(p4+0, "ptr")
		g_.rtrgt := p3
	}	
	logerr("device " r " " d3d.err[r . ""])
	return r	
}