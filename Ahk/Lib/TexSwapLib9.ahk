global g_tswap9 := {}

Global DDSD_CAPS        := 0x00000001
Global DDSD_HEIGHT      := 0x00000002
Global DDSD_PITCH       := 0x00000008
Global DDSD_PIXELFORMAT := 0x00001000
Global DDSD_WIDTH       := 0x00000004

_TS9Init()
{
	logerr(IDirect3DDevice9.dllHook("CreateTexture", "CreateTexture9Hook"))
	logerr(IDirect3DDevice9.dllHook("SetTexture", "SetTexture9Hook"))
	logerr(IDirect3DTexture9.dllHook("Release", "ReleaseTexture9Hook"))
	logerr(IDirect3DSurface9.dllHook("Release", "ReleaseSurface9Hook"))	
	logerr(IDirect3DDevice9.dllHook("UpdateSurface", "UpdateSurface9Hook"))	
	
	D3D9_HOOKS.pIDirect3DDevice9_CreateTexture := IDirect3DDevice9.CreateTexture
	D3D9_HOOKS.pIDirect3DDevice9_SetTexture    := IDirect3DDevice9.SetTexture
	D3D9_HOOKS.pIDirect3DTexture9_Release      := IDirect3DTexture9.Release
	D3D9_HOOKS.pIDirect3DSurface9_Release      := IDirect3DSurface9.Release	
	D3D9_HOOKS.UpdtSrfc                        := IDirect3DDevice9.UpdateSurface
	
	g_tswap9.textures        := new Collection()
	D3D9_HOOKS.Textures      := g_tswap9.textures.pc 
	g_tswap9.Replacements    := new Collection()
	D3D9_HOOKS.Replacements  := g_tswap9.Replacements.pc 
	g_tswap9.Surfaces        := new Collection()
	D3D9_HOOKS.Surfaces      := g_tswap9.Surfaces.pc 
	g_tswap9.paths           := new Collection()
	D3D9_HOOKS.Paths         := g_tswap9.paths.pc
}

TS9Init(byref cfg)
{
	g_tswap9      := parsecfg(cfg)
	g_tswap9.srch := False
	g_tswap9.path := g_.cfg.path g_tswap9.path
	if ! g_tswap9.path
	return
	if (g_.cfg.common_path)
		g_tswap9.path := g_.cfg.Mydocs "\WineHooks\Games\Textures" 
	for k, v in ["Dumps", "Replacements"] 
	{
		if not fileexist(g_tswap9.path "\" v) 
		{
			path := g_tswap9.path
			FileCreateDir, %path%\%v%
		}
	}
	D3D9_HOOKS.dyntxts := g_tswap9.l
	g_tswap9.entry     := struct("LPVOID pTexture; DWORD ww; DWORD hh; DWORD type; DWORD format; LPVOID pData;"
	. " DWORD pitch; DWORD bypp; BOOL DXT; LPVOID level0; BOOL warn; LPVOID hwnd")
	
	dllcall("peixoto.dll\SetSampleCount", uint, g_tswap9.s)
	dllcall("peixoto.dll\SetTexturePaths", str, g_tswap9.path "/dumps/", astr, g_.cfg.MyDocs "\WineHooks\checkerboard.dds")
	if fileexist((comp := g_tswap9.path "\Dumps\dump._dds"))
		LoadCompiledDumpCollection(comp, lst := [])
	else LoadDumpCollection(g_tswap9.path "\Dumps", lst := [])
		
	g_tswap9.dumps := []	
	D3D9_HOOKS.pTextureFound := RegisterCallback("TextSwap9LoadReplacement", "F")	
	D3D9_HOOKS.autodmp       := g_tswap9.a
	_TS9Init()	
	return
	logerr(IDirect3DDevice9.dllHook("UpdateTexture", "UpdateTexture9Hook"))	
	;logerr(IDirect3DDevice9.dllHook("UpdateSurface", "UpdateSurface9Hook"))	
	logerr(IDirect3DMTexture9.dllHook("GetSurfaceLevel", "GetSurfaceLevel9Hook"))	
	logerr(IDirect3DMTexture9.dllHook("LockRect", "LockTexture9RectHook"))
	logerr(IDirect3DMTexture9.dllHook("UnLockRect", "UnLockTexture9RectHook"))
	logerr(IDirect3DMSurface9.dllHook("LockRect", "LockManagedSurface9RectHook"))
	logerr(IDirect3DMSurface9.dllHook("UnLockRect", "UnLockManagedSurface9RectHook"))
	
	D3D9_HOOKS.pIDirect3DDevice9_UpdateTexture     := IDirect3DDevice9.UpdateTexture	
	;D3D9_HOOKS.UpdtSrfc                            := IDirect3DDevice9.UpdateSurface
	D3D9_HOOKS.pIDirect3DMTexture9_GetSurfaceLevel := IDirect3DMTexture9.GetSurfaceLevel	
	D3D9_HOOKS.pIDirect3DMTexture9_LockRect        := IDirect3DMTexture9.LockRect
	D3D9_HOOKS.pIDirect3DMTexture9_UnLockRect      := IDirect3DMTexture9.UnLockRect 
	D3D9_HOOKS.pIDirect3DMSurface9_LockRect        := IDirect3DMSurface9.LockRect
	D3D9_HOOKS.pIDirect3DMSurface9_UnLockRect      := IDirect3DMSurface9.UnLockRect 		
}

TextSwap9LoadReplacement(index, pOriginal)
{
	printl("Found " index " " pOriginal)		
	if (tex := D3D9LoadManagedTexture(g_.pDevice9, g_tswap9.dumps[index].replacement))
	{
		dllcall(g_.p_Critical, uint, 1)
		if (old := g_tswap9.Replacements.value(pOriginal))
			dllcall(IDirect3DTexture9.release, uint, old)
		g_tswap9.Replacements._add(pOriginal, tex)
		dllcall(g_.p_Critical, uint, 0)
	}	
	return 		
}

BrowseTextures9(pDevice)
{
	static idx :=0, _type := ["Video memory", "Managed", "System memory (don't dump)", "Scratch (don't dump)", "Dynamic"]
	
	(idx >= g_tswap9.textures.Count()) ? idx := 0 : (idx < 0 )
	?idx := g_tswap9.textures.Count() - 1
	
	fnc := getkeystate(g_tswap9.q, "p") ? "getkeystate" : "keyevent"
	e   := g_tswap9.entry
	if ! (e[] := g_tswap9.textures.ValueAt(idx))
	return	
	
	dump := 0	
	if %fnc%(g_tswap9.n, "p") 
	idx += 1
	else if %fnc%(g_tswap9.p, "p") 
	idx -= 1
	else if keyevent(g_tswap9.d)
	{
		dump := 1
		n    := 0
		file := "dump" n ".dds"
		while fileexist(g_tswap9.path "\dumps\" file) 
		{
			n += 1
			file := "dump" n ".dds" 			
		}		
		D3D9_HOOKS.dump := g_tswap9.path "\dumps\" file		
	}
	keyevent(g_tswap9.c) ? D3D9_HOOKS.color := CicleColor(D3D9_HOOKS.color)
	
	tx     := e.pTexture
	fmt    := D3D9GetPixelFormat(e.format)
	count  := g_tswap9.textures.Count()
	DXT    := e.DXT
	draw   := (e.type < 2)
	warn   := (e.warn) ? "Can't dump. Activate search before the texture is loaded`n" : _type[e.type+1] "`n"
	level0 := (e.level0) ? "Level0: OK" : "Level0: NO"	
			
	D3D9_HOOKS.Currentexture9 := e.pTexture
	D3D9_HOOKS.t              := e.pTexture
	D3D9_HOOKS.tex            := "D3D9 - "  g_tswap9.Replacements.count() " replacements`n"
	. "Texture " idx "/" count " - " e.format " " fmt "(" DXT ")"  e.ww "x" e.hh "`n" warn . level0 ", active surfaces: " . count "`n" e.ww "x" e.hh 
	. "`nReplacement: " g_tswap9.Replacements.Value(e.pTexture)	
	return ((e.type = 2) || (e.type = 3)) ? 3 : dump+1 	
}