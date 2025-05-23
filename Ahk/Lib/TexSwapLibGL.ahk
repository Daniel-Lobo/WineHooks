global g_tswap := {}
 
InitTextSwapHooksGl(byref cfg)
{
	g_tswap       := parsecfg(cfg)
	g_tswap.path  := g_.cfg.path g_tswap.path
	p             := g_tswap.path
	for k, v in ["Dumps", "Replacements"] 
	{		
		if ! p
			break
		if ! fileexist(p "\" v)
			FileCreateDir, %p%\%v%			
	}
	
	entry =
	(Trim
	UINT pTexture;
	UINT pReplace;
	DWORD  format;
	DWORD  chnnls;
	DWORD  ifrmt;
	DWORD  dwWidth;
	DWORD  dwHeight;
	DWORD  lPitch;
	DWORD  algn;
	DWORD  pad;
	LPVOID lpSurface;
	)
	g_tswap.gl_entry := struct(entry)	
	
	g_tswap.curent_color      := [1., 1., 1.]	
	g_tswap.GLTextures        := new Collection()
	g_tswap.GLIndexedTextures := []
	g_tswap.current_texture   := ""
	g_tswap.current_buffer    := 0
	InstallGlHook("glDeleteTextures")
		
	glBindTexture_Hook   := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glBindTexture_Hook", ptr)
	glTexImage2D_Hook    := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glTexImage2D_Hook", ptr)
	glTexSubImage2D_Hook := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glTexSubImage2D_Hook", ptr)
	glTexParameteri_Hook := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glTexParameteri_Hook", ptr)
			
	logerr("glBindTexture Hook: " AltInstallHook(glBindTexture_Hook, (trampoline := gl.p.glBindTexture)))
	logerr("glTexImage2D  Hook: " AltInstallHook(glTexImage2D_Hook, (tramptex2D := gl.p.glTexImage2D)))
	logerr("glTexSubImage2D  Hook: " AltInstallHook(glTexSubImage2D_Hook, (tramptexS2D := gl.p.glTexSubImage2D)))	
	gl.p.glBindTexture                         := trampoline
	gl.p.glTexImage2D                          := tramptex2D
	gl.p.glTexSubImage2D                       := tramptexS2D	
	GL_HOOKS.glBindTexture_trampoline          := gl.p.glBindTexture
	GL_HOOKS.glTexParameteri_trampoline        := gl.p.glTexParameteri 
	GL_HOOKS.glTexImage2D_trampoline           := gl.p.glTexImage2D 
	GL_HOOKS.textdict                          := g_tswap.GLTextures.pc
	GL_HOOKS.glGetFloatv                       := gl.p.glGetFloatv 
	GL_HOOKS.glTexParameterf                   := gl.p.glTexParameterf 
	GL_HOOKS.TextFnd                           := RegisterCallback("GlTextureFound", "F")	
	if (g_tswap.k)
	GL_HOOKS.prtl                              := True
	if (g_tswap.a)
	GL_HOOKS.DumpText                          := RegisterCallback("GlDumpTexture", "F")	
	
	g_tswap.rect      := struct("UINT x, y, w, h;")
	g_tswap.rect.x    := 0
	g_tswap.rect.y    := 0
	g_tswap.rect.w    := g_tswap.sz
	g_tswap.rect.h    := g_tswap.sz
	g_tswap._rect     := struct("UINT x, y, w, h;")
	g_tswap._rect.x   := 0
	g_tswap._rect.y   := g_tswap.sz
	g_tswap._rect.w   := g_tswap.sz
	g_tswap._rect.h   := g_tswap.sz*2
	g_tswap.color     := 0x00ffffff
	LoadTextureDumpsGl()	
}

LoadTextureDumpsGl(path = "")
{
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	dllcall(dll "\SetSampleCount", uint, g_TSwap.s)
	dllcall(dll "\SetTexturePaths", str, g_TSwap.path "/dumps/", astr, g_.cfg.MyDocs "\Games\checkerboard.dds")
	if fileexist((comp := g_TSwap.path "\Dumps\dump._dds"))
		LoadCompiledDumpCollection(comp, lst := [])
	else LoadDumpCollection(g_TSwap.path "\Dumps", lst := [])	
	if (g_.cfg.console)
	dllcall(dll "\D3D12Config", astr, "DBUG", uint, 1)
}

TSwapCreateProgs()
{
	dllcall(gl.p.glGetIntegerv, uint, GL_VIEWPORT, ptr, gl._viewport[])
	p_shader :=
	(
	"
	#version 110 
	uniform sampler2D t;
	in vec2 crds;
	//out vec4 color;
	void main()
	{
	  gl_FragColor = texture2D(t, crds);
	}
	"
	)
	g_tswap.Program := new Program(p_shader)	
	p_shader :=
	(
	"
	#version 120 
	uniform sampler2D t;
	in vec2 crds;	
	void main()
	{
	  gl_FragColor = texture2D(t, vec2(crds.x, 1-crds.y));
	  gl_FragColor.a = 1.;
	}
	"
	)
	g_tswap._Program  := new Program(p_shader)	
	g_tswap.info      := new glText(g_tswap.sz, g_tswap.sz)	
	return True
}

BrowseTexturesGl()
{
	static currentindex := 1
	current_texture     := 0	
	_func := getkeystate(g_tswap.q) ? "getkeystate" : "keyevent"
	
	if %_func%(g_tswap.n) 
		currentindex += 1
	else if %_func%(g_tswap.p) 
		currentindex -= 1
	else if keyevent(g_tswap.d)
	{
		n := 0
		file := "dump" n ".dds"
		while fileexist(g_tswap.path "\dumps\" file) {
			n += 1
			file := "dump" n ".dds"
		} 
		if (g_tswap.gl_entry[] := g_tswap.GLTextures.valueat(currentindex))
			dumpGlTexture(g_tswap.gl_entry, g_tswap.path "\dumps\" file)		
	}	

	if (currentindex >= g_tswap.GLTextures.count())
		currentindex := 0
	
	if (currentindex < 0 )
		currentindex := g_tswap.GLTextures.count()-1
	
	if (g_tswap.gl_entry[] := g_tswap.GLTextures.valueat(currentindex))
	{
		GL_HOOKS.current_thumb := g_tswap.gl_entry.pTexture		
		dllcall(gl.p.glGetIntegerv, uint, GL_CURRENT_PROGRAM, "uint*", p:=0)	
		dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D, "uint*", t:=0)
		dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, g_tswap.gl_entry.pTexture)			
		;dllcall(gl.p.glUseProgram, uint, g_tswap.Program.p)
		;g_tswap.Program.v()
		dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_WIDTH, "uint*", w:=0)
		dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_HEIGHT, "uint*", h:=0)		
		dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
		dllcall(dll "\GlDrawRect", ptr, g_tswap.rect[], uint, 0)
		
		info := "Texture " currentindex "\" g_tswap.GLTextures.count() " names:" g_tswap.gl_entry.pTexture "|" g_tswap.gl_entry.pReplace "`n" 
		. w "(" g_tswap.gl_entry.algn ":" g_tswap.gl_entry.lPitch ") x " h "`n"		
		. "channels: " g_tswap.gl_entry.chnnls " " gl.constant[g_tswap.gl_entry.chnnls ""] "`n"
		. "data format: " g_tswap.gl_entry.format " " gl.constant[g_tswap.gl_entry.format ""] "-> " GetPixelFormatGl(g_tswap.gl_entry) "`n" 		
		. "internal format: " g_tswap.gl_entry.ifrmt "`n"		
		. g_HD.RndrBffrs.count() " RenderBuffers`n" 
		. g_HD.MSTexts.count() " Multisampled Textures"

		;dllcall(gl.p.glUseProgram, uint, g_tswap._Program.p)
		;g_tswap._Program.v()	
		dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, g_tswap.info.t)		
		r := dllcall(dll "\GlWriteOnTexture", uint, g_tswap.info.t, wstr, info, uint, g_tswap._rect.y, ptr) 		
		dllcall(dll "\GlDrawRect", ptr, r, uint, 0)
		dllcall(gl.p.glUseProgram, uint, p)	
		dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, t)			
	} 	
}

GlDumpTexture(t)
{
	n := 0
	file := "dump" n ".dds"
	while fileexist(g_tswap.path "\dumps\" file) {
		n += 1
		file := "dump" n ".dds"
	} 
	g_tswap.gl_entry[] := t
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	dumpGlTexture(g_tswap.gl_entry, g_tswap.path "\dumps\" file)	
	dllcall(dll "\AppendDump", astr, g_tswap.path "\dumps\" file)
}

DumpGlDXTnTexture(tx, file, fmt)
{
	bytes_per_block := fmt = "DXT1" ? 8 : 16
	block_count     := ceil(tx.dwWidth/4) * ceil(tx.dwHeight/4)
	memsize         := bytes_per_block * block_count
	pdata           := dllcall("VirtualAlloc", uint, 0, uint, memsize, "Int", 0x00001000, uint, (PAGE_READWRITE := 0x04), ptr)	
	logerr(file ": " fmt " " tx.dwWidth "x" tx.dwHeight " " memsize " " bytes_per_block " " block_count " " pdata)

	dllcall(gl.p.glGetIntegerv, uint, GL_PIXEL_PACK_BUFFER_BINDING, "uint*", b:=0)
	dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D, "uint*", t:=0)
	dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, tx.pTexture)	
	dllcall(gl.p.glBindBuffer, uint, GL_PIXEL_PACK_BUFFER, uint, 0)		
	dllcall(gl.p.glGetCompressedTexImage, uint, GL_TEXTURE_2D, uint, 0, ptr, pdata)	
	dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, t)	
	dllcall(gl.p.glBindBuffer, uint, GL_PIXEL_PACK_BUFFER, uint, b)	

	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	dllcall(dll "\DumpDDS", str, file, astr, fmt, uint, tx.dwWidth, uint, tx.dwHeight, ptr, pdata, uint, bytes_per_block * tx.dwWidth/4) 	
	dllcall("VirtualFree", uint, pdata, uint, 0, uint, (MEM_RELEASE := 0x8000) )
}

DumpGlTexture(byref texture, file)
{
	printl("chnnls: " texture.chnnls " " gl.constant[texture.chnnls ""] "  format: " texture.format " " gl.constant[texture.format ""] "-> " getPixelFormatGl(texture))
	printl(file " " texture.dwWidth "x" texture.dwHeight " " texture.ifrmt)
	current_texture := 0	
	pixelformat	    := GetPixelFormatGl(texture)
	LOGERR("DUMPING " file " " texture.dwWidth "x" texture.dwHeight " " pixelformat)
	if (pixelformat = "Unsupported format")
	return logerr("Bad format " texture.chnnls " " texture.format " " texture.ifrmt)
	else if instr(pixelformat, "DXT")
	return DumpGlDXTnTexture(texture, file, pixelformat) 
	else if (pixelformat = "A8BGR") or (pixelformat = "A8RGB") or (pixelformat = "X8RGB") 
	memsize := 4 * texture.dwWidth * texture.dwHeight
	else if (pixelformat = "BGR") 
	memsize := 3 * texture.dwWidth * texture.dwHeight ;dumpAsBitmapGl(texture, file) ;	
	else memsize := 2 * texture.dwWidth * texture.dwHeight 
		
	pdata := dllcall("VirtualAlloc", uint, 0, uint, memsize, "Int", 0x00001000 ;| 0x00002000
								   , uint, (PAGE_READWRITE := 0x04), ptr)		
	
	dllcall(gl.p.glGetIntegerv, uint, GL_PIXEL_PACK_BUFFER_BINDING, "uint*", b:=0)
	dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D, "uint*", current_texture)
	dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, texture.pTexture)	
	dllcall(gl.p.glBindBuffer, uint, GL_PIXEL_PACK_BUFFER, uint, 0)			
	LOGERR("DUMPING 1")					   
	dllcall(gl.p.glGetTexImage, uint, GL_TEXTURE_2D, uint, 0, uint, texture.format, uint, texture.chnnls, ptr, pdata)
	LOGERR("DUMPING 2")		
	dllcall(gl.p.glBindBuffer, uint, GL_PIXEL_PACK_BUFFER, uint, b)	
	dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, current_texture)
	
	if (pixelformat = "BGR") 
	pixelformat := "RGB"
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	dllcall(dll "\DumpDDS", str, file, astr, pixelformat, uint, texture.dwWidth, uint, texture.dwHeight, ptr, pdata, uint, memsize / texture.dwHeight) 	
	dllcall("VirtualFree", uint, pdata, uint, 0, uint, (MEM_RELEASE := 0x8000) )
	LOGERR("DUMPED")
	return	
}

LoadTextureGl(file_)
{		
	file := FileOpen(file_, "r")
	VarSetCapacity(data, file.Length)
	file.RawRead(data, file.Length)
	file.close()	
	dllcall("RtlMoveMemory", ptr, DDS_HEADER[], ptr, &data + 4, int, DDS_HEADER.size())	
	
	pixelformat := GetFilePixelFormat(DDS_HEADER)
	printl("loading " file_ " PixelFormat " pixelformat)
		
	if (pixelformat = "A8BGR")
	{
		cnnls := GL_UNSIGNED_BYTE
		fmt   := GL_RGBA
		ifmt  := GL_RGBA8
		bpp   := 4
	}
	else if (pixelformat = "A8RGB")
	{	
		cnnls := GL_UNSIGNED_INT_8_8_8_8_REV
		fmt   := GL_BGRA
		ifmt  := GL_RGBA8
		bpp   := 4	
	}
	else if (pixelformat = "A1RGB")
	{	
		cnnls := GL_UNSIGNED_SHORT_5_5_5_1
		fmt   := GL_RGBA
		ifmt  := GL_RGBA8
		bpp   := 2	
	}
	else if (pixelformat = "RGB")
	{	
		cnnls := GL_UNSIGNED_BYTE
		fmt   := GL_BGR
		ifmt  := GL_RGB8
		bpp   := 3	
	} 
	else if (pixelformat = "DXT1")
	fmt := GL_COMPRESSED_RGBA_S3TC_DXT1_EXT	
	else if (pixelformat = "DXT3")
	fmt := GL_COMPRESSED_RGBA_S3TC_DXT3_EXT	
	else if (pixelformat = "DXT5")
	fmt := GL_COMPRESSED_RGBA_S3TC_DXT5_EXT	
	
	dllcall(gl.p.glGetTexParameteriv, uint, GL_TEXTURE_2D, uint, GL_TEXTURE_MAG_FILTER,  "uint*", fltr:=0)	
	TX   := (t := new TextGen(DDS_HEADER.dwMipMapCount)).tx	
	w    := DDS_HEADER.dwWidth
	h    := DDS_HEADER.dwHeight 
	ofst := 0
	if instr(pixelformat, "DXT")
	{
		blck := (pixelformat = "DXT1") ?  8 : 16
		loop, % DDS_HEADER.dwMipMapCount+1 
		{
			sz := blck * ceil(w/4) * ceil(h/4)
			dllcall(gl.p.glCompressedTexImage2D, uint, GL_TEXTURE_2D, uint, A_index-1, uint, fmt, uint, w, uint, h
			                                   , uint, 0, uint, sz, ptr, &data + 4 + DDS_HEADER.size() + ofst)
			ofst += sz	
			w /= 2
			h /= 2		
			w < 1 ? w := 1		
			h < 1 ? h := 1		
		}
	} else {
		loop, % DDS_HEADER.dwMipMapCount+1 
		{
			dllcall(gl.p.glTexImage2D, uint, GL_TEXTURE_2D, uint, A_index-1, uint, ifmt, uint, w, uint, h
									 , uint, 0, uint, fmt, uint, cnnls, ptr, &data + 4 + DDS_HEADER.size() + ofst)
			ofst += h*w*bpp						 
			w /= 2
			h /= 2		
			w < 1 ? w := 1		
			h < 1 ? h := 1	
		}
	}
	dllcall(gl.p.glTexParameterf, uint, GL_TEXTURE_2D, uint, GL_TEXTURE_MAX_ANISOTROPY_EXT, float, 16.)	
	(g_.cfg.FLTR) ? dllcall(gl.p.glTexParameteri, uint, GL_TEXTURE_2D, uint, GL_TEXTURE_MAG_FILTER, uint, g_.cfg.FLTR)
	: fltr        ? dllcall(gl.p.glTexParameteri, uint, GL_TEXTURE_2D, uint, GL_TEXTURE_MAG_FILTER, uint, fltr)
	return TX							 
}	

GetPixelFormatGl(byref texture)
{	
	frmt := "Unsupported format"
	dllcall(g_.pGetGlPxFrmt, uint, texture.format, uint, texture.chnnls, int, texture.ifrmt, astr, frmt)
	return frmt
	if (texture.chnnls = GL_UNSIGNED_BYTE) and (texture.format = GL_RGBA)
		return "A8BGR"
	else if (texture.chnnls = GL_UNSIGNED_INT_8_8_8_8_REV) and (texture.format = GL_BGRA)
		return "A8RGB"
	else if (texture.chnnls = GL_UNSIGNED_BYTE) and (texture.format = GL_RGB)
		return "BGR"
	else if (texture.chnnls = GL_UNSIGNED_SHORT_1_5_5_5_REV) ;and (texture.format = GL_RGB)
		return "X1RGB"
	else if (texture.chnnls = GL_UNSIGNED_SHORT_5_5_5_1) 
		return "A1RGB"
	else return "Unsupported format"
}	

GlTextureFound(i, tex)
{
	logerr("Found " (file := strget(i+0, "CP0")))	
	if (!fileexist(file)) 
		file :=  g_.cfg.MyDocs "/Games/checkerboard.dds"
	
	g_tswap.gl_entry[]        := tex
	g_tswap.gl_entry.pReplace := LoadTextureGl(file)	
}

glBindBuffer(p1, p2)
{
	if (p1 = GL_PIXEL_UNPACK_BUFFER)
	{
		GL_HOOKS.current_buff := g_tswap.current_buffer := p2
		logerr("bind buffer " p1)
	}
	dllcall(gl.p.glBindBuffer, uint, p1, uint, p2)
}	

glBindTexture(p1, p2)
{
	g_tswap.current_texture := p2 
	if ! (g_tswap.gl_entry[] := g_tswap.GLTextures.value(p2))
	{
		g_tswap.gl_entry[] := g_tswap.GLTextures._Insert(p2, g_tswap.gl_entry.size())		
		g_tswap.gl_entry.pTexture := p2	
		g_tswap.gl_entry.pReplace := p2				
	}  
	if (p2 = g_tswap.current_thumb)
		return dllcall(gl.p.glBindTexture, uint, p1, uint, 0)
	dllcall(gl.p.glBindTexture, uint, p1, uint, g_tswap.gl_entry.pReplace)
}	

glDeleteTextures(p1, p2)
{	
	loop, % p1
	{
		pTexture := numget(p2+(A_Index-1)*4, "uint")
		if (g_tswap.gl_entry[] := g_tswap.GLTextures.value(pTexture))
		{
			if (g_tswap.gl_entry.pReplace != g_tswap.gl_entry.pTexture)
			{
				;logerr("delete " g_tswap.gl_entry.pReplace)
				rep := g_tswap.gl_entry.pReplace
				dllcall(gl.p.glDeleteTextures, uint, 1, "uint*", rep)
			}
			(pTexture = GL_HOOKS.current_thumb) ? GL_HOOKS.current_thumb := 0
			g_tswap.GLTextures.Remove(pTexture)
		}
	}
	return dllcall(gl.p.glDeleteTextures, uint, p1, uint, p2)	
}