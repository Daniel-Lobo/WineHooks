
;REMOTE SCRIPT START 
global g_oni_shader, g_oni_hshader
global g_oni_surfaceentry := struct("LPVOID pSurface; LPVOID ParentTexture; DWORD ww; DWORD hh; DWORD type; DWORD Format;")
global g_oni_correction   := round(640/512*10)/10
global g_oni_desk         := Desk() 
global g_oni_copysrc      := struct("DWORD x; DWORD y; DWORD w; DWORD h;")
global g_oni_copydst      := struct("DWORD x; DWORD y;")
global g_oni_flipsrc      := struct("DWORD x; DWORD y; DWORD w; DWORD h;")
global g_oni_flipsrc_m    := struct("DWORD x; DWORD y; DWORD w; DWORD h;")
global g_oni_flipdst      := struct("DWORD x; DWORD y; DWORD w; DWORD h;")
global g_oni_rttrect      := struct("DWORD x; DWORD y; DWORD w; DWORD h;")
global g_oni_src, g_oni_dst, g_oni_pntsize, g_oni_hwin, g_oni_ignorecopy
global g_oni_input, g_oni_room
global g_oni_ignorecopy :=0
logerr(IDirect3DDevice8.Hook("CopyRects"))
logerr(IDirect3DDevice8.Hook("Present", "OniPresent"))
D3D8_HOOKS.pIDirect3DDevice8_Present := IDirect3DDevice8.present
logerr(IDirect3DDevice8.UnHook("DrawIndexedPrimitive"))	
logerr(IDirect3DDevice8.Hook("DrawIndexedPrimitive"))
;g_dnpt.loger.log(IDirectInputDevice8A.Unhook("EnumObjects"))


if (g_.cfg.crashfix)
{
	path := g_.cfg.injector_dir "\Patches\Onimusha\room404b.xsd"
	name := "room404b.xsd"
	pK   := dllcall("VirtualAlloc", ptr, 0, ptr, (strlen(name)+1)*2, uint, 0x00003000, uint, 0x04, ptr)
	strput(name, pK, "UTF-16")
	strput(path, g_fhks.files._Insert(pK, (strlen(path)+1)*2, "UTF-16"))
}

;(g_fhks.pCreateFileW)?:InitFileHooks((g_.cfg.mods := (g_.cfg.crashfix) ? g_.cfg.injector_dir "\Patches\Onimusha" : "?"))

;printl("CreateFileW:  " . InstallHook("OniCreateFileW", pOpenFileW, "Kernel32.dll", "CreateFileW"))
;g_fhks.pCreateFileW := pOpenFileW
	

Alt_DrawIndexedPrimitive(p1, p2, p3, p4, p5, p6)
{
	v := struct(D3DVIEWPORT8)
	v.X      := 0
	v.Y      := 0
	v.Width  := G_HD.HD_w
	v.Height := G_HD.HD_h
	v.MinZ   := 0.0
	v.MaxZ   := 1.0
	;logerr("Viewport " dllcall(IDirect3dDevice8.SetViewport, uint, g_.pDevice8, uint, v[]))	
	
	t:=0, b:=0, f:= 0
	dllcall(IDirect3DDevice8.GetRenderState, uint, p1, uint, 15, "uint*", t)
	dllcall(IDirect3DDevice8.GetRenderState, uint, p1, uint, 25, "uint*", f)
	dllcall(IDirect3DDevice8.GetRenderState, uint, p1, uint, 27, "uint*", b)
	
	if t && f<7
	{
		dllcall(IDirect3DDevice8.SetRenderState, uint, p1, uint, 136, uint, 0)
		
		;(b=0)?D3DDDI_SetShaderOverride(g_oni_shader)	
		(b=0) ? dllcall(IDirect3DDevice8.SetPixelShader, uint, p1, uint g_oni_hshader)
		dllcall(IDirect3DDevice8.SetRenderState, uint, p1, uint, 15, uint, 0)
		;dllcall(IDirect3DDevice8.SetRenderState, uint, p1, uint, 27, uint, 1)
		dllcall(IDirect3DDevice8.DrawIndexedPrimitive, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)
		dllcall(IDirect3DDevice8.SetRenderState, uint, p1, uint, 15, uint, 1)
		dllcall(IDirect3DDevice8.SetRenderState, uint, p1, uint, 27, uint, b)
		;D3DDDI_RestoreShader()
		dllcall(IDirect3DDevice8.SetPixelShader, uint, p1, uint 0)
		return
	}
	return dllcall(IDirect3DDevice8.DrawIndexedPrimitive, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)	
}

Alt_CopyRects(p1, p2, p3, p4, p5, p6)
{
	;if g_oni_ignorecopy
		;return  dllcall(IDirect3DDevice8.CopyRects, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6)
	if (rs := FindSrfc8(p5))
		p5 := rs
	if (rd := FindSrfc8(p2))
		p2 := rd
	r  := dllcall(IDirect3DDevice8.CopyRects, uint, p1, uint, p2, uint, 0, uint, 0, uint, p5, uint, 0)	
	rs ? dllcall(dllcall(numget(numget(rs+0, "ptr")+A_PtrSize*2, "ptr"), uint, z), uint, rs)
	rd ? dllcall(dllcall(numget(numget(rd+0, "ptr")+A_PtrSize*2, "ptr"), uint, z), uint, rd)
	dllcall(IDirect3DDevice8.SetRenderState, uint, p1, uint, 26, uint, 1)
	dllcall(IDirect3DDevice8.SetRenderState, uint, p1, uint, 154, float, D3D8_HOOKS.scale*D3D8_HOOKS.scale)
	return 0
}

Alt_CreateDevice(p1, p2, p3, p4, p5, p6, p7)
{
	r := IDirect3D8_CreateDevice(p1, p2, p3, p4, p5, p6, p7)		
	
	D3D8_HOOKS.scale := (G_HD.HD_H*g_oni_correction)/480
	p             := D3DPRESENT_PARAMETERS	
	h             := G_HD.HD_h * g_oni_correction
	w             := h*4/3
	g_.Proxies.rt := new Proxie8(w, h, p.BackBufferFormat 
							    ,p.EnableAutoDepthStencil ?  p.AutoDepthStencilFormat : "")	
	
	g_.s.flip_src   := struct("float x, y, w, h;")
	g_.s.flip_src.x := 0.
	g_.s.flip_src.y := 16/480
	g_.s.flip_src.w := 1.
	g_.s.flip_src.h := 464/480

	g_.s.flip_srcb   := struct("float x, y, w, h;")
	g_.s.flip_srcb.x := 0.
	g_.s.flip_srcb.y := 32/480
	g_.s.flip_srcb.w := 1.
	g_.s.flip_srcb.h := 464/480
		
	code :=
	(
	"
		sampler s0 : register(s0);
		float4 main(float4 color: COLOR0, float4 color1: COLOR1, float2 tx : TEXCOORD0) : COLOR0
		{
			float4 c0 = tex2D(s0, tx);
			// As we also multiply alpha by 2, we make all alpha 0 or 1
			return c0*color*2;
		};
	"
	)
	g_oni_shader := D3DDDI_CreatePixelShader(code, "main")
	logerr(g_oni_shader)	
	
	code :=
	(
	"
	ps.1.1
	def c0, 2.,2.,2.,2.
    tex t0
    mul r1, t0, v0
    mul r0, r1, c0
	"
	)
	g_oni_hshader := D3D8CreatePixelShader(code, g_.pDevice8)
	return r	
}

AltCreateFileW(p1, p2, p3, p4, p5, p6, p7)
{
	
	static block = True
	file := strget(p1, "UTF-16")
	if instr(file, "image\movie") and block
	{
		if not instr(file, "E.mpg")
			stringreplace, file_e, file, .mpg, E.mpg
		
		block := False
		if fileexist(file_e)
			logerr(PlayFMVOnWindow(file_e, dllcall("GetForegroundWindow", uint), g_.cfg.FMV))
		else logerr(PlayFMVOnWindow(file, dllcall("GetForegroundWindow", uint), g_.cfg.FMV))
		block := True
		return -1
	}	
			  
	return dllcall(g_fhks.pCreateFileW, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7)	
	logerr("hfile " file " " h " " A_lasterror)	
	return h
}

Alt_Present(p1, p2, p3, p4, p5)
{
	static last = 0
	r := numget(0x7ae0bc+0, "uint") ? g_.s.flip_src[] : g_.s.flip_srcb[]
	SetTargets()
	s                := D3D8_HOOKS.scale
	D3D8_HOOKS.scale := 1	

	dllcall("peixoto.dll\_D3D8DrawRect", uint, p1, uint, g_.Proxies.rt.t, uint, G_HD.rct[], uint, G_HD.hS, uint, r)
	D3D8_HOOKS.scale := s
	SetTargets(g_.Proxies.rt)
	
	
	VBlank(p1) 
	return dllcall(IDirect3DDevice8.Present, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)				
}