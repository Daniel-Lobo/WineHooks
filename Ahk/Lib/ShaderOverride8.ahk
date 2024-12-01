global g_pswap8 := {}

PS8LdDmps(d)
{
	n := g_pswap8.dumps.Length() + 1
	loop, %d%\*.bin, 0, 0
	{
		f  := fileopen(A_loopfilefullpath, "r")
		p  := dllcall("VirtualAlloc", uint, 0, uint, f.Length+4, "int", 0x00001000, uint, 0x04) 
		
		printl("File: " A_loopfilename " " g_pswap8[A_loopfilename] " " f.Length)
		numput(f.Length, p+0, "uint")
		f.RawRead(p+4, f.Length)		
		
		if fileexist( (file := strsplit(A_loopfilefullpath, ".bin")[1] ".txt") )  
		{
			fileread, code, %file%	
			stringreplace, code, code, ps_1_, ps.1.			
			g_pswap8.dumps[n] := {"p" : p, "mode" : "Asm", "code" : code} 
		} 			
		else g_pswap8.dumps[n] := {"p" : p, "mode" : g_pswap8[A_loopfilename]}
		n += 1
		f.close()		
	}
	return n
}

PS8Init(byref cfg)
{
	g_pswap8       := parsecfg(cfg)
	g_pswap8.rct   := struct("DWORD x, y, w, h")
	g_pswap8.rct.x := 0
	g_pswap8.rct.w := 384
	g_pswap8.rct.y := 16
	g_pswap8.rct.h := 80
	
	g_pswap8.user_path := g_.cfg.path "pixelshaders"
	if ! fileexist(g_pswap8.user_path) 
	{	
		path := g_pswap8.user_path
		FileCreateDir, %path%
	}	
		
	name           := strsplit(g_.cfg.target_name, ".exe")[1]
	g_pswap8.path  := g_.cfg.injector_dir "\patches\" name
	printl("Shader dumps Path: " g_pswap8.path " " g_pswap8.user_path)
		
	g_pswap8.dumps := []
	PS8LdDmps(g_pswap8.path)
	PS8LdDmps(g_pswap8.user_path)
	n := g_pswap8.dumps.Length()
	
	D3D8_HOOKS.ShaderDumpsSize := n
	D3D8_HOOKS.ShaderDumps     := dllcall("VirtualAlloc", uint, 0, uint, n*4, "int", 0x00001000, uint, (PAGE_READWRITE := 0x04))
	for k, v in g_pswap8.dumps
	{
		numput(v.p, D3D8_HOOKS.ShaderDumps + (k-1)*4, "uint")
		logerr("Data ptr " v.p " " numget(v.p , "uint"))		
	}	
	
	logerr(IDirect3DDevice8.dllHook("CreatePixelShader", "CreatePixelShader8Hook"))
	logerr(IDirect3DDevice8.dllHook("DeletePixelShader", "DeletePixelShader8Hook"))	
	logerr(IDirect3DDevice8.dllHook("SetPixelShader", "SetPixelShader8Hook"))		
	
	D3D8_HOOKS.pShaderFound        := RegisterCallback("D3D8ShaderFound", "f")
	D3D8_HOOKS.CreatePixelShader   := IDirect3DDevice8.CreatePixelShader
	D3D8_HOOKS.DeletePixelShader   := IDirect3DDevice8.DeletePixelShader
	D3D8_HOOKS.SetPixelShader      := IDirect3DDevice8.SetPixelShader
		
	g_pswap8.shaders               := new Collection()
	D3D8_HOOKS.Shaders             := g_pswap8.shaders.pc
	g_pswap8.Overrides             := new Collection()
	D3D8_HOOKS.Overrides           := g_pswap8.Overrides.pc
	g_pswap8.DDI_Overrides         := new Collection()
	D3D8_HOOKS.DDI_Overrides       := g_pswap8.DDI_Overrides.pc	
	return
}

D3D8ShaderFound(index, Original, sz, szb)
{
	if (g_pswap8.dumps[index].mode = "Asm") 
	{
		h := D3D8CreatePixelShader(g_pswap8.dumps[index].code, g_.pDevice8)	
		if h is number	
			g_pswap8.Overrides._add(Original, h)
		logerr("Shader substitution: " h "`n" g_pswap8.dumps[index].code )					
	}	
}

GetShdr8Fnc(pDev, hS, byref Dt)
{
	if ! dllcall(IDirect3DDevice8.GetPixelShaderFunction, uint, pDev, uint, hS, uint, 0, "uint*", s := 0) 
	{
		VarSetCapacity(Dt, s)
		dllcall(IDirect3DDevice8.GetPixelShaderFunction, uint, pDev, uint, hS, uint, &Dt, "uint*", s)
		return s		
	} 
	return 0	
}

BrowseShaders8(pD, clr)
{
	static code = "", indx = 0, update = True
		
	if (indx >= g_pswap8.shaders.Count())
	indx := 0	
	else if (indx < 0 )
	indx := g_pswap8.shaders.Count() - 1
	
	_func := getkeystate(g_pswap8.q, "p") ? "getkeystate" : "keyevent"
	if not ( c := g_pswap8.shaders.ValueAt(indx))
	{
		if (g_pswap8.shaders.count() = 0)
		{
			dllcall(IDirect3DDevice8.GetPixelShader, uint, g_.pDevice8, "uint*", ps:=0)
			dllcall(IDirect3DDevice8.SetPixelShader, uint, g_.pDevice8, uint, 0)
			dllcall("peixoto.dll\_D3D8Write", uint, pD, uint, g_tswap8.shader, astr, "No pixel shaders`n", uint, g_pswap8.rct[])
			dllcall(IDirect3DDevice8.SetPixelShader, uint, g_.pDevice8, uint, ps)		
		}
		return
	}	
	
	D3D8_HOOKS.Current := c
	if update
	{
		if GetShdr8Fnc(pD, c, Dt)
		code      := D3DX9.DisassembleShader(&Dt)
		else code := ""
		update    := False
	}
	if %_func%(g_pswap8.n, "p") 
	{
		update := True
		indx   += 1
	}	
	else if %_func%(g_pswap8.p, "p") 
	{
		update := true
		indx   -= 1
	}	
	else if keyevent(g_pswap8.d)
	{
		s     := GetShdr8Fnc(pD, c, Dt)
		code  := D3DX9.DisassembleShader(&Dt)
		n     := 0
		file  := g_pswap8.path "\dump" n ".bin"
		ufile := g_pswap8.user_path "\dump" n ".bin"
		while fileexist(file) or fileexist(ufile)
		{
			n     += 1
			file  := g_pswap8.path "\dump" n ".bin"	
			ufile := g_pswap8.user_path "\dump" n ".bin"	
		}
		f := FileOpen(ufile, "w")		
		f.RawWrite(&Dt, s)
		f.close()
		
		stringreplace, ufile, ufile, .bin, .txt
		if not fileexist(ufile)
			fileappend, % code, % ufile		
	}
	dllcall(IDirect3DDevice8.GetPixelShader, uint, g_.pDevice8, "uint*", ps:=0)
	dllcall(IDirect3DDevice8.SetPixelShader, uint, g_.pDevice8, uint, 0)
	dllcall("peixoto.dll\_D3D8Write", uint, pD, uint, g_tswap8.shader, astr, indx "/" g_pswap8.shaders.count() "shaders`n" code, uint, g_pswap8.rct[])
	dllcall(IDirect3DDevice8.SetPixelShader, uint, g_.pDevice8, uint, ps)
	return
}