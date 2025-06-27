global g_pswap9 := {}

PS9LdDmps(d)
{
	n := g_pswap9.dumps.Length() + 1
	loop, %d%\*.bin, 0, 0
	{
		f := fileopen(A_loopfilefullpath, "r")
		p := dllcall("VirtualAlloc", uint, 0, uint, f.Length+4, "Int", 0x1000, uint, (PAGE_READWRITE := 0x04)) 	
		printl("file " A_loopfilename " " g_pswap9[A_loopfilename] " " f.Length)
		
		numput(f.Length, p+0, "uint")
		f.RawRead(p+4, f.Length)
		
		if fileexist( (file := strsplit(A_loopfilefullpath, ".bin")[1] ".hlsl") )
		{
			fileread, code, %file%		
			g_pswap9.dumps[n] := {"p" : p, "mode" : "hlsl", "code" : code} 
			r := D3DX9.HLSLtoDXBC(code, "main", blob)
			if (r)
				logerr("Compilation failed " r)
			else 
			{
				logerr("HLSL shader OK =) " n ", blob:" blob ", count: " g_pswap9.Blobs._add(n, blob) )				
			}
		}
		else if fileexist( (file := strsplit(A_loopfilefullpath, ".bin")[1] ".txt") )  
		{
			fileread, code, %file%		
			g_pswap9.dumps[n] := {"p" : p, "mode" : "Asm", "code" : code} 
			r := D3DX9.Asm2DXBC(code, blob)
			if (r)
				logerr(r)
			else 
			{
				logerr("Asm shader OK =)")
				g_pswap9.Blobs._add(n, blob) 
			}
		} 
		else g_pswap9.dumps[n] := {"p" : p, "mode" : ""}
		n += 1
		f.close()		
	}	
	logerr(g_pswap9.Blobs.Count() " Shaders " IsObject(g_pswap9.Blobs) " " IsObject(g_pswap9.shaders))
}

_PS9Init()
{
	logerr(IDirect3DDevice9.dllHook("CreatePixelShader", "CreatePixelShader9Hook"))
	logerr(IDirect3DDevice9.dllHook("SetPixelShader", (g_pswap9.dev) ? "SetPixelShader9HookD" : "SetPixelShader9Hook"))
	logerr(IDirect3DPixelShader9.dllHook("Release", "ReleasePixelShader9Hook"))
	
	D3D9_HOOKS.CreatePixelShader       := IDirect3DDevice9.CreatePixelShader
	D3D9_HOOKS.SetPixelShader          := IDirect3DDevice9.SetPixelShader	
	D3D9_HOOKS.Release                 := IDirect3DPixelShader9.release
	
	g_pswap9.shaders       := new Collection()
	D3D9_HOOKS.Shaders     := g_pswap9.shaders.pc
	g_pswap9.Overrides     := new Collection()
	D3D9_HOOKS.Overrides   := g_pswap9.Overrides.pc	
	g_pswap9.Blobs         := new Collection()
	D3D9_HOOKS.Blobs       := g_pswap9.Blobs.pc	
}

PS9Init(byref cfg)
{
	g_pswap9           := parsecfg(cfg)
	g_pswap9.code      := "sampler s0 : register(s0);`nfloat4 main(float2 tex: TEXCOORD0) : COLOR0`n{`nreturn tex2D(s0, tex);`n};"
	g_pswap9.code      := "sampler s0 : register(s0);`nfloat4 main(float2 tex: TEXCOORD0) : COLOR0`n{`nreturn 0;`n};"
	D3D9_HOOKS.enabled := 1
	
	g_pswap9.user_path := g_.cfg.path "pixelshaders"
	if ! fileexist(g_pswap9.user_path) 
	{	
		path := g_pswap9.user_path
		FileCreateDir, %path%
	}	
	
	name           := g_.cfg.target_name
	StringLower, name, name
	name           := strsplit(name, ".exe")[1]
	g_pswap9.path  := g_.cfg.injector_dir "\patches\" name
	logerr("Shader dumps Path: " g_pswap9.path " " g_pswap9.user_path)
		
	_PS9Init()
	g_pswap9.dumps := []	
	PS9LdDmps(g_pswap9.path)
	PS9LdDmps(g_pswap9.user_path)
	n := g_pswap9.dumps.Length()
	
	D3D9_HOOKS.SDumpsSize := n
	D3D9_HOOKS.Sdumps     := dllcall("VirtualAlloc", uint, 0, uint, n*4, "Int", 0x1000, uint, (PAGE_READWRITE := 0x04))
	for k, v in g_pswap9.dumps
	{
		numput(v.p, D3D9_HOOKS.Sdumps + (k-1)*4, "uint")		
	}
	D3D9_HOOKS.pShaderFound := RegisterCallback("d3D9ShaderFound", "f")		
}

D3D9ShaderFound(index, Original, sz, szb)
{
	logerr("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
	if (g_pswap9.dumps[index].mode = "Asm") 
	{
		err := D3DX9.AssembleShader(g_.pDevice9, g_pswap9.dumps[index].code, pShader)
		if ! err		
			g_pswap9.Overrides._add(Original, pShader)	
		printl("Shader substitution: " err "`n" g_pswap9.dumps[index].code)	
	}
	else if (g_pswap9.dumps[index].mode = "hlsl") 
	{
		err := D3DX9.CompileShader(g_.pDevice9, g_pswap9.dumps[index].code, "main", pShader)
		if ! err
			g_pswap9.Overrides._add(Original, pShader)
		printl("Shader hlsl substitution: " err "`n" g_pswap9.dumps[index].code)	
	}		
}

BrowseShaders9(pDevice)
{
	static i = 0
		
	fn := getkeystate(g_pswap9.q, "p") ? "getkeystate" : "keyevent"
	if ! ( c := g_pswap9.shaders.ValueAt(i))
	return
	
	D3D9_HOOKS.CurrentSelectedShader := c
			
	if %fn%(g_pswap9.n, "p") 
	{
		i += 1
		if (i >= g_pswap9.shaders.Count())
			i := 0 
	}
	else if %fn%(g_pswap9.p, "p") 
	{
		i -= 1
		if (i < 0)  
			i := g_pswap9.shaders.Count() - 1	
	}		
	else if keyevent(g_pswap9.d)
	{
		n     := 0
		file  := g_pswap9.path "\dump" n ".bin"
		ufile := g_pswap9.user_path "\dump" n ".bin"
		while fileexist(file) or fileexist(ufile)
		{
			n     += 1
			file  := g_pswap9.path "\dump" n ".bin"	
			ufile := g_pswap9.user_path "\dump" n ".bin"	
		}
		D3D9_HOOKS.SPath := ufile
		stringreplace, ufile, ufile, .bin, .txt
		D3D9_HOOKS.StxtPath := ufile
		return 5
		
		f := FileOpen(ufile, "w")
		f.RawWrite(&d, sz)
		f.close()
		
		code := D3DX9.DisassembleShader(&d)
		logerr("Disassembled")
		stringreplace, ufile, ufile, .bin, .txt
		if not fileexist(ufile)
			fileappend, % code, % ufile
	}
	return 4
	D3DX9.DrawText(g_.D3D9Font, "shader " i "/" g_pswap9.shaders.Count() " " current 
	, 0xFFFF0000,"0|0|255|255")	
}