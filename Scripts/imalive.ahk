;REMOTE SCRIPT START

/*
global pSetPixelShader, g_iama_current_index
logerr("SetPixelShaderHook:  " . InstallHook("SetPixelShader9Hook", pSetPixelShader, "peixoto.dll", "SetPixelShader9HookD"))

Alt_EndScene(p1)
{
	IAmAliveBrowseShaders9(p1)
	return IDirect3DDevice9_EndScene(p1)
}

IAmAliveBrowseShaders9(pDevice)
{
	static currentindex = 0
	dllcall(g_.p_Critical, uint, 1)
	
	if (currentindex >= g_pswap9.shaders.Count())
		currentindex := 0	
	else if (currentindex < 0 )
		currentindex := g_pswap9.shaders.Count() - 1
	
	g_iama_current_index := currentindex
	
	_func := getkeystate("shift", "p") ? "getkeystate" : "keyevent"
	if not ( CurrentSelectedShader := g_pswap9.shaders.ValueAt(currentindex))
		return
	
	if %_func%("<", "p") 
		currentindex += 10
	else if %_func%(">", "p") 
		currentindex -= 10	
		
	d3DX9.DrawText(g_.d3D9Font, "shader " currentindex "/" g_pswap9.shaders.Count() " " current 
	, 0xFFFF0000,"0|255|255|555")
	dllcall(g_.p_Critical, uint, 0)
}

SetPixelShader9Hook(p1, p2)
{
	loop, 10
	{
		if ( p2 = g_pswap9.shaders.ValueAt(g_iama_current_index+A_index-1) )
		{
			p2 := 0	
			break
		}
	}	
	return dllcall(pSetPixelShader, uint, p1, uint, p2)
}
*/

InitImAliveHook()
/*
InitImAliveHook()
{
	for k, v in g_pswap9.dumps
	{
		if ( g_.cfg.textfix and ( instr(v.code, "bAlphaTest") or instr(v.code, "sHOMLight") ) )
		{
			v.mode := "hlsl"
			v.code := g_pswap9.code
		}			
		if g_.cfg.blur and instr(v.code, "sMedBlur")
		{
			v.mode := "hlsl"
			v.code := g_pswap9.code
		}	
		if instr(v.code, "bBloom")
		{
			if g_.cfg.dessat
			{
				start  := instr(v.code, "if b0")
				length := instr(v.code, "endif", ,start) + 5 - start
				rep    := SubStr(v.code, start, length) 
				string := v.code
				stringreplace, string, string, %rep%, ,
				logerr(string "->" rep)
				v.code := string
			}
			if g_.cfg.noise
			{
				start  := instr(v.code, "if b2")
				_else  := instr(v.code, "else", ,start)
				length := instr(v.code, "endif", ,_else) + 5 - start
				rep    := SubStr(v.code, start, length) 
				string := v.code
				stringreplace, string, string, %rep% ,mov oC0`, r0,
				logerr(string "->" rep)
				v.code := string
			}
		}
	}
}
*/

InitImAliveHook()
{
	for k, v in g_pswap9.dumps
	{
		if ( g_.cfg.textfix and ( instr(v.code, "bAlphaTest") or instr(v.code, "sHOMLight") ) )
		{
			logerr("..." D3DX9.HLSLtoDXBC(g_pswap9.code, "main", blob) )
			g_pswap9.Blobs._add(k, blob) 
			v.mode := "hlsl"
			v.code := g_pswap9.code
		}			
		if g_.cfg.blur and instr(v.code, "sMedBlur")
		{
			logerr("---" D3DX9.HLSLtoDXBC(g_pswap9.code, "main", blob) )
			g_pswap9.Blobs._add(k, blob) 
			v.mode := "hlsl"
			v.code := g_pswap9.code
		}	
		if instr(v.code, "bBloom")
		{
			if g_.cfg.dessat
			{
				start  := instr(v.code, "if b0")
				length := instr(v.code, "endif", ,start) + 5 - start
				rep    := SubStr(v.code, start, length) 
				string := v.code
				stringreplace, string, string, %rep%, ,
				;logerr(string "->" rep)
				v.code := string
				
				logerr("***" D3DX9.Asm2DXBC(string, blob) string)
				g_pswap9.Blobs._add(k, blob) 
			}
			if g_.cfg.noise
			{
				start  := instr(v.code, "if b2")
				_else  := instr(v.code, "else", ,start)
				length := instr(v.code, "endif", ,_else) + 5 - start
				rep    := SubStr(v.code, start, length) 
				string := v.code
				stringreplace, string, string, %rep% ,mov oC0`, r0,
				;logerr(string "->" rep)
				v.code := string
					
				logerr("@@@" D3DX9.Asm2DXBC(string, blob) string)
				g_pswap9.Blobs._add(k, blob) 
			}
		}
	}
}