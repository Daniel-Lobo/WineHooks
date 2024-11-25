global g_tswap8 := {}

_TS8Init()
{
	logerr(IDirect3DDevice8.dllHook("CreateTexture", "CreateTexture8Hook"))
	logerr(IDirect3DDevice8.dllHook("SetTexture", "SetTexture8Hook"))
	logerr(IDirect3DTexture8.dllHook("Release", "ReleaseTexture8Hook"))
	logerr(IDirect3DTexture8.dllHook("GetSurfaceLevel", "GetSurfaceLevel8Hook"))
	logerr(IDirect3DSurface8.dllHook("Release", "ReleaseSurface8Hook"))
	D3D8_HOOKS.pIDirect3DDevice8_CreateTexture    := IDirect3DDevice8.CreateTexture
	D3D8_HOOKS.pIDirect3DDevice8_SetTexture       := IDirect3DDevice8.SetTexture
	D3D8_HOOKS.pIDirect3DTexture8_Release         := IDirect3DTexture8.Release
	D3D8_HOOKS.pIDirect3DTexture8_GetSurfaceLevel := IDirect3DTexture8.GetSurfaceLevel 
	D3D8_HOOKS.pIDirect3DSurface8_Release         := IDirect3DSurface8.Release 	
	
	g_tswap8.textures            := new Collection()
	D3D8_HOOKS.Textures          := g_tswap8.textures.pc 
	g_tswap8.Replacements        := new Collection()
	D3D8_HOOKS.Replacements      := g_tswap8.Replacements.pc
	g_tswap8.Surfaces            := new Collection()
	D3D8_HOOKS.Surfaces          := g_tswap8.Surfaces.pc 	
}

TS8Init(byref cfg)
{
	g_tswap8         := parsecfg(cfg)
	g_tswap8.srch    := False
	g_tswap8.f_rct   := struct("LONG x, y, w, h;")
	g_tswap8.t_rct   := struct("LONG x, y, w, h;")
	g_tswap8.t_rct.h := g_tswap8.sz
	g_tswap8.t_rct.w := g_tswap8.sz 
	g_tswap8.f_rct.y := g_tswap8.t_rct.h + 10
	g_tswap8.f_rct.h := g_tswap8.f_rct.y + g_tswap8.sz
	g_tswap8.f_rct.w := g_tswap8.sz 
		
	if not g_tswap8.path
	return
	
	g_tswap8.path := g_.cfg.path g_tswap8.path
	if (g_.cfg.common_path)
		g_tswap8.path := g_.cfg.Mydocs "\WineHooks\Games\Textures" 
	for k, v in ["Dumps", "Replacements"] 
	{
		if not fileexist(g_tswap8.path "\" v) 
		{
			path := g_tswap8.path
			FileCreateDir, %path%\%v%
		}
	}
	
	g_tswap8.entry   := struct("LPVOID pTexture; DWORD ww; DWORD hh; DWORD type; DWORD format; LPVOID pData; DWORD pitch; DWORD bypp; BOOL DXT; LPVOID Level0")
	g_tswap8.s_entry := struct("LPVOID pSrfc; LPVOID Prnt; DWORD ww; DWORD hh; DWORD type; DWORD Frmt;")
	
	dllcall("peixoto.dll\SetSampleCount", uint, g_tswap8.s)
	if fileexist((comp := g_tswap8.path "\Dumps\dump._dds"))
	LoadCompiledDumpCollection(comp, lst := [])
	else LoadDumpCollection(g_tswap8.path "\Dumps", lst := [])			
	g_tswap8.dumps              := []	
	D3D8_HOOKS.pTextureFound    := RegisterCallback("TextSwap8LoadReplacement", "F")
	D3D8_HOOKS.Samples          := g_tswap8.s	
	if (g_tswap8.a)
		D3D8_HOOKS.pDumpTexture := RegisterCallback("AutoDump8", "F")
	
	D3D8_HOOKS.pIDirect3DSurface8_LockRect     := IDirect3DSurface8.LockRect
	D3D8_HOOKS.pIDirect3DSurface8_UnLockRect   := IDirect3DSurface8.UnLockRect 
	IDirect3DSurface8.LockRect                 := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, str, "LockSurface8RectHook")
	IDirect3DSurface8.UnLockRect               := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, str, "UnLockSurface8RectHook")
	
	logerr(IDirect3DTexture8.dllHook("LockRect", "LockTexture8RectHook"))
	logerr(IDirect3DTexture8.dllHook("UnLockRect", "UnLockTexture8RectHook"))	
	D3D8_HOOKS.pIDirect3DTexture8_LockRect    := IDirect3DTexture8.LockRect
	D3D8_HOOKS.pIDirect3DTexture8_UnLockRect  := IDirect3DTexture8.UnLockRect 
	
	logerr(IDirect3DDevice8.dllHook("UpdateTexture", "UpdateTexture8Hook"))
	D3D8_HOOKS.pIDirect3DDevice8_UpdateTexture := IDirect3DDevice8.UpdateTexture 
	
	_TS8Init()		
}

BrowseTextures8(pDevice, clr)
{
	static currentindex:=0, _type:=0 
	_type ?: _type := ["Video memory", "Managed", "System memory (don't dump)", "Scratch", "Dynamic"]
	
	if (currentindex >= g_tswap8.textures.Count())
		currentindex := 0	
	else if (currentindex < 0 )
		currentindex := g_tswap8.textures.Count() - 1
	
	_func := getkeystate(g_tswap8.q) ? "getkeystate" : "keyevent"
	if not (g_tswap8.entry[] := g_tswap8.textures.ValueAt(currentindex))
	return	
			
	if %_func%(g_tswap8.n) 
	currentindex += 1
	else if %_func%(g_tswap8.p) 
	currentindex -= 1
	else if keyevent(g_tswap8.d)
	{
		n := 0
		file := "dump" n ".dds"
		while (fileexist(g_tswap8.path "\dumps\" file) or IsDump(g_tswap8.dumps, file))
		{
			n += 1
			file := "dump" n ".dds" 			
		}
		LOGERR("dumping " file " - " DumpTexture8(g_tswap8.entry.pTexture, g_tswap8.entry.format, g_tswap8.path "\dumps\" file))
	}
	
	vs     := 0
	ps     := 0
	level0 := (g_tswap8.entry.level0) ? "Level0: OK" : "Level0: NO"		
	dllcall(IDirect3DDevice8.GetVertexShader, uint, pDevice, "uint*", vs)
	dllcall(IDirect3DDevice8.SetVertexShader, uint, pDevice, uint, 0x104)
	dllcall(IDirect3DDevice8.GetPixelShader, uint, pDevice, "uint*", ps)
	dllcall(IDirect3DDevice8.SetPixelShader, uint, pDevice, uint, g_tswap8.shader)	
	D3D8_HOOKS.Currentexture8 := g_tswap8.entry.pTexture
	D3D8_HOOKS.searching      := False
	dllcall("peixoto.dll\_D3D8DrawRect", uint, pDevice, uint, g_tswap8.entry.pTexture, uint, g_tswap8.t_rct[], uint, g_tswap8.shader, uint, 0)
	dllcall(IDirect3DDevice8.SetPixelShader, uint, pDevice, uint, 0)
	dllcall("peixoto.dll\_D3D8Write", uint, pDevice, uint, g_tswap8.shader, astr
	, "D3D8, texture " currentindex "/" g_tswap8.textures.Count() " - " D3D8GetPixelFormat(g_tswap8.entry.format) "(" g_tswap8.entry.DXT ")`n" 
	. _type[g_tswap8.entry.type+1] "`n"  
	.  level0 ", active surfaces: " g_tswap8.Surfaces.count(), uint, g_tswap8.t_rct[])
	D3D8_HOOKS.searching      := True
	dllcall(IDirect3DDevice8.SetPixelShader, uint, pDevice, uint, ps)
	dllcall(IDirect3DDevice8.SetVertexShader, uint, pDevice, uint, vs)
}

TextSwap8LoadReplacement(index, pOiginal)
{
	fileexist(f:=strget(index+0, "CP0")) ?: f := g_.cfg.MyDocs "\WineHooks\checkerboard.dds"	
	if (tex := D3D8LoadManagedTexture(g_.pDevice8, f))
	{
		;;if (old := g_tswap8.Replacements.value(pOiginal))
			;printl("Releasing IDirect3DTexture8 " dllcall(IDirect3DTexture8.release, uint, old))
		;g_tswap8.Replacements._add(pOiginal, tex)
		dllcall("peixoto.dll\D3D8Replacetexture", ptr, pOiginal, ptr, tex)
	}			
}


AutoDump8(t, fmt)
{
	n    := 0
	file := "dump" n ".dds"
	while (fileexist(g_tswap8.path "\dumps\" file) or IsDump("", file))
	{
		n += 1
		file := "dump" n ".dds"
	}
	LOGERR("dumping " g_tswap8.path "\dumps\" file " - " DumpTexture8(t, fmt, g_tswap8.path "\dumps\" file))
	dllcall("peixoto.dll\AppendDump", astr, g_tswap8.path "\dumps\" file)
}

DumpTexture8(texture, format, file)
{
	d := struct(D3DSURFACE_DESC)
	dllcall(IDirect3DTexture8.GetLevelDesc, ptr, texture, uint, 0, ptr, d[])
	
	if (er := dllcall(IDirect3DTexture8.GetSurfaceLevel, uint, texture, uint, 0, "uint*", pTargetSurface))
		return LOGERR("Failed to get the target texture level 0 " er " " D3D8.err[er . ""])
	
	if (d.Pool = 0)
	{
		if dllcall(IDirect3DDevice8.CreateImageSurface, uint, g_.pDevice8, uint, d.width, uint, d.height, uint, format, "uint*", sys:=0)
			return LOGERR("IDirect3DDevice8::CreateImageSurface FAILED") 
		
		if dllcall(IDirect3DDevice8.CopyRects, ptr, g_.pDevice8, ptr, pTargetSurface, ptr, 0, uint, 0, ptr, sys, ptr, 0)
			return LOGERR("IDirect3DDevice8::CopyRects FAILED")
		
		dllcall(IDirect3DSurface8.release, uint, pTargetSurface)	
		pTargetSurface := sys		
		s := new ComInterfaceWrapper(D3D8.IDirect3DSurface8, pTargetSurface, True)		
	} else s :=	IDirect3DSurface8
		
	if not (pixelformat := D3D8GetPixelFormat(format))
		return LOGERR("Unsupported format " pixelformat) 
	
	lrect := struct("UINT pitch; UINT pbytes;")
	if (er := dllcall(s.LockRect, uint, pTargetSurface, ptr, lrect[], uint, 0, uint, 0) )
		return LOGERR("Failed to lock system surface for dumping" er " " D3D8.err[er . ""])	
	
	logerr("DumpDDS " dllcall("peixoto.dll\DumpDDS", str, file, astr, pixelformat, uint, d.width, uint, d.height, uint, lrect.pbytes, uint, lrect.pitch))
	dllcall(s.UnLockRect, uint, pTargetSurface, uint, 0)	
	dllcall(s.release, uint, pTargetSurface)	
	return d.width "x" d.height " " pixelformat " " lrect.pbytes " " lrect.pitch " " d.Pool
}