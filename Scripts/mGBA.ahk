;REMOTE SCRIPT START
g_.s.xBRz := False
Alt_wglMakeCurrent(hDC, Ctxt)
{
	r   := wglMakeCurrent(hDC, Ctxt)	
	xbr := new Program( fileopen(g_.cfg.injector_dir "\shaders\xBRz.glsl", "r").read() )
	if (xbr.p)
	{
		logerr("g_.proxies.xBRz = " xbr.p)
		g_.proxies      := {}
		g_.proxies.xBRz := xbr
	}
	return r
}

Alt_wglSwapBuffers(p1)
{
	Keyevent("Q") ? g_.s.xBRz := (g_.s.xBRz = 3/2) ? 10/9 : (g_.s.xBRz = 10/9) ? False : 3/2
	
	if (g_.s.xBRz)
	{
		hDC        := dllcall("Opengl32.dll\wglGetCurrentDC", ptr)
		hwin       := dllcall("WindowFromDC", ptr, hDC)
		CLIENT     := struct("DWORD x, y, w, h;")
		dllcall("GetClientRect", ptr, hwin, ptr, CLIENT[])
		GL_HOOKS.W := CLIENT.W-CLIENT.X
		GL_HOOKS.H := CLIENT.H-CLIENT.Y		
		
		dllcall(gl.p.glClear, uint, GL_COLOR_BUFFER_BIT)
		r := struct("UINT x, y,w, h")
		r.x := GL_HOOKS.W-GL_HOOKS.H*g_.s.xBRz
		r.x /= 2
		r.w := GL_HOOKS.H*g_.s.xBRz + r.x
		r.h := GL_HOOKS.H		
		
		g_tswap.gl_entry[] := g_tswap.GLTextures.valueat(0)
		dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, g_tswap.gl_entry.pTexture)	
		dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_WIDTH, "uint*", w:=0)
		dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_HEIGHT, "uint*", h:=0)

		dllcall(gl.p.glViewport, int, 0, int, 0, int, GL_HOOKS.W, int, GL_HOOKS.h)	
		g_.proxies.xBRz.v()
		g_.proxies.xBRz._f2("OutputSize", GL_HOOKS.W, GL_HOOKS.H)
		g_.proxies.xBRz._f2("InputSize", w, h)
		g_.proxies.xBRz._f2("TextureSize", w, h)		
		dllcall(gl.p.glUseProgram, uint, g_.proxies.xBRz.p)			
		dllcall("peixoto.dll\GlDrawRect", ptr, r[], uint, 0)
	}
	return dllcall(gl.p.wglSwapBuffers, ptr, p1)
}