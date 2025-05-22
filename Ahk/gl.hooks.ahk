#include  lib\DirectX\Headers\GL.h.ahk
#include  lib\DirectX\Headers\glcoreARB.h.ahk
#include  lib\DirectX\Headers\wglEXT.h.ahk
#include  lib\DirectX\Headers\glEXT.h.ahk
global GL_HOOKS  :=
(
"
// HD
DWORD W, H, HD_W, HD_H, HD_X, ViewX;
float scale, wide, aspect;
DWORD vw_x, vw_y, vw_w, vw_h;
DWORD scsr_x, scsr_y, scsr_w, scsr_h;
LPVOID SwapBuffers;
LPVOID wglSwapBuffers;
LPVOID wglSwapLayerBuffers;
LPVOID glViewport;
LPVOID glScissor;
LPVOID glBindFramebuffer;
LPVOID glBlitFramebuffer;
LPVOID glGetIntegerv;
LPVOID glDeleteRenderbuffers;
LPVOID glRenderbufferStorageMultisample;
LPVOID glRenderbufferStorage;
LPVOID RndrBffrs; 
LPVOID glTexImage2DMultisample;
LPVOID MSTexts;
// Shader
LPVOID glShaderSource;
LPVOID glCompileShader;
LPVOID glGetShaderiv;
LPVOID glGetShaderInfoLog;
LPVOID glDeleteShader;
LPVOID glCreateShader;
LPVOID glCreateProgram;
LPVOID glAttachShader;
LPVOID glGetProgramiv;
LPVOID glGetProgramInfoLog;
LPVOID glDeleteProgram;
LPVOID glDetachShader;
LPVOID glLinkProgram;
// Draw
LPVOID glGenVertexArrays;
LPVOID glBindVertexArray;
LPVOID glDeleteVertexArrays;
LPVOID glGenBuffers;
LPVOID glBindBuffer;
LPVOID glDeleteBuffers;
LPVOID glBufferData;
LPVOID glEnableVertexAttribArray;
LPVOID glDrawArrays;
LPVOID glDisableVertexAttribArray;
LPVOID glVertexAttribPointer;
// Textures
LPVOID glDeleteTextures;
LPVOID glBindTexture_trampoline; 
LPVOID glTexParameterf; 
LPVOID glTexImage2D_trampoline;
LPVOID glTexSubImage2D_trampoline;
LPVOID glCompressedTexImage2D;
LPVOID glGetTexImage;
LPVOID TextFnd;
LPVOID DumpText;
LPVOID BuffFnd;
float max_aniso; 
BOOL seach;
BOOL prtl;
DWORD current_thumb;
DWORD current_texture; 
DWORD current_buff;
DWORD pad0;
LPVOID textdict;
LPVOID buffdict;
//Filtering
DWORD FLTR;
DWORD pad1;
LPVOID glSamplerParameteri;
LPVOID glTexParameteri;
LPVOID SetPixelFormat;
"
)
GL_HOOKS := struct(GL_HOOKS)
#include lib\TexSwapLibGL.ahk

GetOpenGlDriverName()
{
	return "Opengl32.dll"	
}

gl.p := {}
GlDllHook(fnc) 
{
	callback      := isfunc("Alt_" fnc) ? "Alt_" fnc : fnc
	hook          := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, fnc "_Hook", ptr)
	r             := AltInstallHook(hook, (t := gl.p[fnc]))
	gl.p[fnc]     := t
	GL_HOOKS[fnc] := Registercallback(callback, "F")
	r ? logerr("Failed to hook " fnc " " . r) : logerr("Succeeded to hook " fnc)	
	return r
}	
	
InstallGlHook(function, GDI=False) 
{
	static gl_dll := GetOpenGlDriverName()
	static err := ["Failed to load the helper library" 
	, "Failed to register the callback for the hook function"
	, "Failed to load the specified libray with lasterror = 126"
	, "Failed to load the specified libray"
	, "Failed to get the adress of the function to be hooked"]
	r := InstallHook(isfunc("Alt_" function) ? "Alt_" function : function, pfunction, GDI ? "Gdi32.dll" : gl_dll , function)
	gl.p[function] := pfunction + 0
	r ? logerr("Failed to hook " function " " . err[r] ? err[r] : "detours error " r) : logerr("Succeeded to hook " function)
	return r
}	
g_.pGetGlPxFrmt := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GetGlPixelFormat", ptr)
g_.p.DrawRect   := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GlDrawRect", ptr)
g_.p.GlCmplPgrm := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GlCompileShaders", ptr)
g_.p.GlUnlock   := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GlUnlock", ptr)
g_.p.Gllock     := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GlLock", ptr)

global g_HD := {}
InitGLHooks()
InitGLHooks()
{
	g_.cfg.IsLinux := FileExist(GetSystemDir() "\wined3d.dll") ? true : false
	d              := Desk()
	GL_HOOKS.H     := d.h
    GL_HOOKS.W     := d.w
	GL_HOOKS.HD_W  := d.w
    GL_HOOKS.HD_H  := d.h
	if (g_.cfg.RLMT)
	{
		d := strsplit(["640x480", "800x600", "1024x768", "960x540", "1280x720", "1366x768", "1600x900", "1920x1080", "2560x1440", "3840x2160"][g_.cfg.RLMT], "x" )	
		GL_HOOKS.W    := d[1]
		GL_HOOKS.H    := d[2]
	}	
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"	
	f   := 0x0
	(g_.cfg.HD)     ? f |= 0xf
	(g_.cfg.WHKS)   ? dllcall(dll "\D3D12Config", astr, "FIXWINSIZE", ptr, 1)
	(g_.cfg.MCLP)   ? dllcall(dll "\D3D12Config", astr, "MOUSECLIP" , str, g_.cfg.MCLP)
	if (g_.cfg.MSAA)
		dllcall(dll "\InitGl", ptr, A_scripthwnd)
	if (g_.cfg.MHKS)
	{
		dllcall(dll "\D3D12Config", astr, "MOUSEHOOKS", ptr, 1)
		dllcall(dll "\InitMouseHooks")			
	} 
	dllcall(dll "\InitGlHooks", ptr, GL_HOOKS[], uint, f) 	
    dllcall(dll "\GlDisplayModeChanged", uint, GL_HOOKS.W, uint, GL_HOOKS.H, astr, "InitGLHooks()")
	SetupGl(GL_HOOKS.w, GL_HOOKS.h, "InitGLHooks") ;Games that don't change display mode (the swapper, k route zero), untested.
			
	dllcall("SetLastError", uint, 0)
	printl("Acquiring OpenGl and GDI Pointers")
	h_gl32 := dllcall("LoadLibraryW", str, GetOpenGlDriverName(), ptr)
	for k, v in strsplit("glMatrixMode glLoadIdentity glLoadMatrixf glOrtho glGetFloatv glGetIntegerv glViewport glGenTextures glBindTexture"
	. " glDisable glEnable glGetBooleanv glColor3f glRectf glRasterPos2f glGenLists glDeleteLists glListBase glCallLists wglUseFontBitmapsW"
	. " glVertex2f glBegin glEnd glGetError glTexCoord2f glGetIntegerv glGetTexImage glTexParameteri glTexParameterf glGetString glPixelStorei"
	. " wglMakeCurrent wglGetProcAddress glScissor glFrustum glTexImage2D glReadBuffer glDrawBuffer glFlush glClear glClearColor glDrawBuffer"
	. " glDrawArrays glDrawElements glGetTexLevelParameteriv glIsTexture glTexSubImage2D glGetTexImage glBlendFunc glBlendEquation" 
	. " glGetTexParameteriv wglSwapLayerBuffers glCopyTexImage2D glCopyTexSubImage2D wglGetCurrentContext glDrawPixels glBitmap", " ") {
		gl.p[v] := dllcall("GetProcAddress", ptr, h_gl32, astr, v, ptr)	
		printl(v " address: " gl.p[v] " error " A_lasterror )
	}
	GL_HOOKS.glBindTexture_trampoline   := gl.p.glBindTexture
	GL_HOOKS.glTexParameteri_trampoline := gl.p.glTexParameteri 
	GL_HOOKS.glTexImage2D_trampoline    := gl.p.glTexImage2D 
	GL_HOOKS.glTexSubImage2D_trampoline := gl.p.glTexSubImage2D
	GL_HOOKS.glGetIntegerv              := gl.p.glGetIntegerv
	GL_HOOKS.glGetTexImage              := gl.p.glGetTexImage

	h_gdil32 := dllcall("LoadLibraryW", str, "Gdi32.dll", ptr)
	for k, v in strsplit("SelectObject GetStockObject SetPixelFormat", " ") {
		gl.p[v] := dllcall("GetProcAddress", ptr, h_gdil32, astr, v, ptr)
		printl(v " address: " gl.p[v] " error " A_lasterror)
	}

	if (g_.cfg.MSAA)
	{
		SetPixelFormatHook := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "SetPixelFormatHook", ptr)
		logerr("SetPixelFormatHook Hook: " AltInstallHook(SetPixelFormatHook, (trampoline := gl.p.SetPixelFormat)))
		gl.p.SetPixelFormat     := trampoline
		GL_HOOKS.SetPixelFormat := trampoline
	}

	InstallGlHook("wglCreateContext")
	InstallGlHook("wglMakeCurrent")
	
	if (parsecfg(g_.cfg.TextSwap).e or g_.cfg.HD)
	{
		InstallGlHook("wglGetProcAddress")
		InstallGlHook("wglSwapBuffers") 
		InstallGlHook("SwapBuffers", True)
		InstallGlHook("wglSwapLayerBuffers")
	} 
		
	gl._Model := struct("float m11; float m12; float m13; float m14; float m21; float m22; float m23; float m24;"
					   . " float m31; float m32; float m33; float m34; float m41; float m42; float m43; float m44")
	gl._Projection  := struct(gl._Model)
	gl._ProjectionB := struct(gl._Model)
	gl._viewport    := struct("int x; int y; int w; int h")

	if (parsecfg(g_.cfg.TextSwap).e)
		InitTextSwapHooksGl(g_.cfg.TextSwap)

	if g_.cfg.HD
	{
		if (!parsecfg(g_.cfg.TextSwap).e)
		{
			InitTextSwapHooksGl(g_.cfg.TextSwap)
			GL_HOOKS.pDumps    := 0
		}		
				
		g_HD.RndrBffrs     := new Collection()
		GL_HOOKS.RndrBffrs := g_HD.RndrBffrs.pc
		g_HD.MSTexts       := new Collection()
		GL_HOOKS.MSTexts   := g_HD.MSTexts.pc
		
		g_HD.up        := instr(g_.cfg.HD, "up")        ? True : False
		g_HD.wide      := instr(g_.cfg.HD, "wide")      ? True : False
		g_HD.nofov     := instr(g_.cfg.HD, "nofov")     ? True : False
		g_HD.nostretch := instr(g_.cfg.HD, "nostretch") ? True : False
		logerr("ChangeDisplaySettingsW Hook  :" InstallHook("ChangeDisplaySettingsW", pChangeDisplaySettingsW, "User32.dll", "ChangeDisplaySettingsW"))
		logerr("ChangeDisplaySettingsExW Hook:" InstallHook("ChangeDisplaySettingsExW", pCDSExW, "User32.dll", "ChangeDisplaySettingsExW"))
		logerr("ChangeDisplaySettingsA Hook  :" InstallHook("ChangeDisplaySettingsA", pChangeDisplaySettingsA, "User32.dll", "ChangeDisplaySettingsA") )
		logerr("GetDC Hook                   :" InstallHook(Isfunc("AltGetDC")?"AltGetDC":"GetDC", pGetDC, "User32.dll", "GetDC"))
		gl.p.user_ChangeDisplaySettingsW   := pChangeDisplaySettingsW
		gl.p.user_ChangeDisplaySettingsExW := pCDSExW
		gl.p.user_ChangeDisplaySettingsA   := pChangeDisplaySettingsA		
		gl.p.user_GetDC                    := pGetDC
		if (g_.cfg.WHKS)
		{
			Mov := Isfunc(Alt_ := "AltMoveWindow") ? Alt_ : "MoveWindow"
			logerr("MoveWindow Hook          :" InstallHook(Mov, pMoveWindow:=0, "User32.dll", "MoveWindow") " <- 0 means no error")
			gl.p.user_MoveWindow := pMoveWindow	
		}		
					
		if (A_ptrsize=8)
		{
			GlDllHook("glViewport")
			GlDllHook("glScissor")	
		} else {	
			InstallGlHook("glViewport")
			InstallGlHook("glScissor")	
		}
		InstallGlHook("glGetTexLevelParameteriv")
		InstallGlHook("glGetTexImage")		
		InstallGlHook("glCopyTexImage2D")
		InstallGlHook("glCopyTexSubImage2D")
		
		GL_HOOKS.scale := 1	
		GL_HOOKS.ViewX := 0	
		if g_HD.wide
		{
			InstallGlHook("glMatrixMode")
			InstallGlHook("glLoadMatrixf")
			InstallGlHook("glFrustum")
			(g_HD.nostretch) ? InstallGlHook("glOrtho")
		}
		if (g_HD.up or g_.cfg.SSAA)
		{
			InstallGlHook("glDrawBuffer")
			InstallGlHook("glReadBuffer")
		} 
		if (!g_HD.up) 
		{
			InstallGlHook("glReadPixels") 
			InstallGlHook("glDrawPixels")
			InstallGlHook("glBitmap")
		}							
		
		logerr("glGetIntegerv Hook: " AltInstallHook(dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glGetIntegerv_Hook", ptr), (t := gl.p.glGetIntegerv)))
		gl.p.glGetIntegerv     := t		
		GL_HOOKS.glGetIntegerv := gl.p.glGetIntegerv
	}	
	
	if g_.cfg.FLTR
	{	
		logerr("glTexParameteri Hook: " AltInstallHook(dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glTexParameteri_Hook", ptr), (t := gl.p.glTexParameteri)))
		gl.p.glTexParameteri     := t
		GL_HOOKS.glTexParameteri := t
		GL_HOOKS.FLTR            := g_.cfg.FLTR
	}
		
	l_glBindTexture          := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glBindTexture_Hook", ptr)
	l_glDeleteTextures       := registercallback("glDeleteTextures", "F")
	l_glTexImage2D           := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glTexImage2D_Hook", ptr)
	l_glTexSubImage2D        := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glTexSubImage2D_Hook", ptr)
	l_glCompressedTexImage2D := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glCompressedTexImage2D_Hook", ptr)
	l_glBindBuffer           := registercallback("glBindBuffer", "F")
	l_glDrawBufferRegion     := registercallback("glDrawBufferRegion", "F")
	l_glReadBufferRegion     := registercallback("glReadBufferRegion", "F")
	
	gl.ExtHks := {}	
	if (parsecfg(g_.cfg.TextSwap).e or g_.cfg.HD)
	{	
		gl.ExtHks["glBindTexture"]             := l_glBindTexture
		gl.ExtHks["glBindTextureEXT"]          := l_glBindTexture
	    gl.ExtHks["glDeleteTexturesEXT"]       := l_glDeleteTextures
		gl.ExtHks["glDeleteTextures"]          := l_glDeleteTextures
		gl.ExtHks["glTexImage2DEXT"]           := l_glTexImage2D
		gl.ExtHks["glTexImage2D"]              := l_glTexImage2D
		gl.ExtHks["glTexSubImage2D"]           := l_glTexSubImage2D	
		gl.ExtHks["glTexSubImage2DEXT"]        := l_glTexSubImage2D
		gl.ExtHks["glTexSubImage2DARB"]        := l_glTexSubImage2D
		gl.ExtHks["glCompressedTexImage2D"]    := l_glCompressedTexImage2D	
		gl.ExtHks["glCompressedTexImage2DEXT"] := l_glCompressedTexImage2D
		gl.ExtHks["glCompressedTexImage2DARB"] := l_glCompressedTexImage2D
		gl.ExtHks["glBindBuffer"]              := l_glBindBuffer
		gl.ExtHks["glBindBufferARB"]           := l_glBindBuffer
		gl.ExtHks["glBindBufferEXT"]           := l_glBindBuffer		
	}	
	if g_.cfg.HD
	{
		gl.ExtHks["glBindFrameBuffer"]                   := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glBindFramebuffer_Hook", ptr)
		GL_HOOKS.glBindFrameBuffer                       := RegisterCallback("glBindFramebuffer", "F")		
		gl.ExtHks["glBindFrameBuffer"]                   := registercallback("glBindFrameBuffer", "F")	
		gl.ExtHks["glBindFrameBufferARB"]                := gl.ExtHks["glBindFrameBuffer"]
		gl.ExtHks["glBindFrameBufferEXT"]                := gl.ExtHks["glBindFrameBuffer"]
		gl.ExtHks["glBlitFrameBuffer"]                   := registercallback("glBlitFrameBuffer", "F")	
		gl.ExtHks["glBlitFrameBufferARB"]                := gl.ExtHks["glBlitFrameBuffer"]
		gl.ExtHks["glBlitFrameBufferEXT"]                := gl.ExtHks["glBlitFrameBuffer"]
		gl.ExtHks["glDeleteRenderbuffers"]               := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glDeleteRenderbuffers_Hook", ptr)
		gl.ExtHks["glRenderbufferStorage"]               := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glRenderbufferStorage_Hook", ptr)
		gl.ExtHks["glRenderbufferStorageMultisample"]    := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glRenderbufferStorageMultisample_Hook", ptr)
		gl.ExtHks["glDeleteRenderbuffersEXT"]            := gl.ExtHks["glDeleteRenderbuffers"]
		gl.ExtHks["glRenderbufferStorageEXT"]            := gl.ExtHks["glRenderbufferStorage"]
		gl.ExtHks["glRenderbufferStorageMultisampleEXT"] := gl.ExtHks["glRenderbufferStorageMultisample"] 
		gl.ExtHks["glTexImage2DMultisample"]             := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "glTexImage2DMultisample_Hook", ptr)
		gl.ExtHks["glTexImage2DMultisampleEXT"]          := gl.ExtHks["glTexImage2DMultisample"] 		
		gl.ExtHks["glTexImage2DMultisampleARB"]          := gl.ExtHks["glTexImage2DMultisample"] 
		gl.ExtHks["glDrawBufferRegion"]                  := l_glDrawBufferRegion
		gl.ExtHks["glDrawBufferRegionEXT"]               := l_glDrawBufferRegion
		gl.ExtHks["glDrawBufferRegionARB"]               := l_glDrawBufferRegion
		gl.ExtHks["glReadBufferRegion"]                  := l_glReadBufferRegion
		gl.ExtHks["glReadBufferRegionEXT"]               := l_glReadBufferRegion
		gl.ExtHks["glReadBufferRegionARB"]               := l_glReadBufferRegion
	}	
	if g_.cfg.FLTR
	{
		gl.ExtHks["glSamplerParameteri"]    := dllcall("GetProcAddress", ptr,  g_.h_PeixotoDll, astr, "glSamplerParameteri_Hook", ptr)	
		gl.ExtHks["glSamplerParameteriARB"] := gl.ExtHks["glSamplerParameteri"]
		gl.ExtHks["glSamplerParameteriEXT"] := gl.ExtHks["glSamplerParameteri"]
	}
	;logerr("OutputDebugStringA " InstallHook("GlOutputDebugStringA", p, "Kernel32.dll", "OutputDebugStringA"))
}

GlOutputDebugStringA(p1)
{
	logerr(strget(p1+0, "Cp0") " " D3D11_HOOKS.flags[3])
}

GLSwap()
{	
	if (g_tswap.e)
	{
		if keyevent(g_tswap.sw)
			GL_HOOKS.seach := (g_tswap.search := (g_tswap.search) & True ? False : TSwapCreateProgs())
		(g_tswap.search) & True ? BrowseTexturesGl()
	}		
		
	if g_HD.up
	{	
		;return glBlt(g_.proxies.fb.fb, 0, 0, 0, GL_HOOKS.W, GL_HOOKS.H, GL_HOOKS.HD_X, 0, GL_HOOKS.HD_W-GL_HOOKS.HD_X, GL_HOOKS.HD_H, 0)		
		
		dllcall(gl.p.glGetIntegerv, uint, GL_VIEWPORT, ptr, gl._viewport[])
		dllcall(gl.p.glGetIntegerv, uint, GL_DRAW_FRAMEBUFFER_BINDING, "uint*", cb:=0) 
		dllcall(gl.p.glGetIntegerv, uint, GL_READ_FRAMEBUFFER_BINDING, "uint*", cr:=0) 		
		dllcall(gl.p.glGetIntegerv, uint, GL_CURRENT_PROGRAM, "uint*", cp:=0)	
		dllcall(gl.p.glGetIntegerv, uint, GL_ACTIVE_TEXTURE, "uint*", at:=0)
		dllcall(gl.p.glActiveTexture, uint, GL_TEXTURE0)
		dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D, "uint*", ct:=0)
						
		dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, 0)	
		dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, g_.proxies.fb.t.t)
		dllcall(gl.p.glViewport, uint, 0, uint, 0, uint, GL_HOOKS.HD_W, uint, GL_HOOKS.HD_H)
		dllcall(gl.p.glScissor, uint, 0, uint, 0, uint, GL_HOOKS.HD_W, uint, GL_HOOKS.HD_H)				
		
		g_.proxies.xBRz.v()
		g_.proxies.xBRz._f2("OutputSize", GL_HOOKS.HD_W, GL_HOOKS.HD_H)
		g_.proxies.xBRz._f2("InputSize", GL_HOOKS.W, GL_HOOKS.H)
		g_.proxies.xBRz._f2("TextureSize", GL_HOOKS.W, GL_HOOKS.H)		
		dllcall(gl.p.glUseProgram, uint, g_.proxies.xBRz.p)			
		dllcall(g_.p.DrawRect, ptr, g_.proxies.r[], uint, 0)			
		
		dllcall(gl.p.glViewport, uint, gl._viewport.x, uint, gl._viewport.y, uint, gl._viewport.w, uint, gl._viewport.h)
		dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, cb)
		dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, cr)
		dllcall(gl.p.glUseProgram, uint, cp)
		dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, ct)
		dllcall(gl.p.glActiveTexture, uint, at)		

		/* Another workaround that should preferably be removed when possible
		 */
		dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, g_.proxies.FB.FB)					
	} else if (g_.cfg.SSAA = 2)
	{
		s := ceil(GL_HOOKS.HD_H/GL_HOOKS.H) * g_.cfg.SSAA
		glBlt(g_.proxies.fbHD.fb, 0, 0, 0, GL_HOOKS.W*s, GL_HOOKS.H*s, GL_HOOKS.HD_X, 0, GL_HOOKS.HD_W-GL_HOOKS.HD_X, GL_HOOKS.HD_H, 0)		
	} else if (g_.cfg.SSAA = 4)
	{
		s := ceil(GL_HOOKS.HD_H/GL_HOOKS.H) * g_.cfg.SSAA
		glBlt(g_.proxies.fbHD.fb, g_.proxies.fbHlf.fb, 0, 0, GL_HOOKS.W*s, GL_HOOKS.H*s, 0, 0, GL_HOOKS.W*s/2, GL_HOOKS.H*s/2, 0)	
		glBlt(g_.proxies.fbHlf.fb, 0, 0, 0, GL_HOOKS.W*s/2, GL_HOOKS.H*s/2, GL_HOOKS.HD_X, 0, GL_HOOKS.HD_W-GL_HOOKS.HD_X, GL_HOOKS.HD_H, 0)
	}
}

wglSwapLayerBuffers(p1, p2)
{
	GLSwap()
	return dllcall(gl.p.wglSwapBuffers, ptr, p1)
}

SwapBuffers(hDC)
{
	GLSwap()	
	return dllcall(gl.p.SwapBuffers, ptr, hDC)
}

wglSwapBuffers(p1)
{
	GLSwap()
	return dllcall(gl.p.wglSwapBuffers, ptr, p1)
}

Prxs(p)
{	
	logerr("Creating proxies " p)
	if ! dllcall(gl.p.wglGetCurrentContext, ptr)
	return logerr("No context")
	
	dllcall(gl.p.glGetIntegerv, uint, GL_DRAW_FRAMEBUFFER_BINDING, "uint*", cb:=0) 
	dllcall(gl.p.glGetFramebufferAttachmentParameteriv, uint, GL_DRAW_FRAMEBUFFER, uint, GL_DEPTH 
	                                                  , uint, GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE, "uint*", d:=0)
	dllcall(gl.p.glGetFramebufferAttachmentParameteriv, uint, GL_DRAW_FRAMEBUFFER, uint, GL_STENCIL
	                                                  , uint, GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE, "uint*", s:=0)
	dllcall(gl.p.glGetFramebufferAttachmentParameteriv, uint, GL_DRAW_FRAMEBUFFER, uint, GL_STENCIL
	                                                  , uint, GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE, "uint*", t:=0)												  
	f          := t = GL_FLOAT ? 1 : 0												   
	fmt        := {"16\0\0" : "Z16X", "24\0\0" : "Z24X8", "24\8\0" : "Z24X8", "32\0\0" : "Z32X"}[d "\" s "\" f]	
	logerr("Depth\Stencil:" d "\" s ":" t " " fmt " " g_.proxies.zfrmt " " GL_HOOKS.W " " GL_HOOKS.H " " dllcall(gl.p.wglGetCurrentContext, ptr) " " cb)	
	if g_.cfg.HD
	{
		g_HD.Sclr  := struct("LPVOID ww, hh, DWORD step[4]; DWORD xOffset; DWORD x, y, w, h; DWORD dx, dy, dw, dh; LPVOID src, dst;")
		g_HD.SREct := struct("DWORD x, y, w, h")
		g_HD.DREct := struct("DWORD x, y, w, h")
		g_HD.SREct[] := g_HD.Sclr.src
		g_HD.DREct[] := g_HD.Sclr.dst
		g_.proxies := {}
		g_.proxies.r   := struct("DWORD x, y, w, h;")	
		g_.proxies.r.x := GL_HOOKS.HD_X
		g_.proxies.r.y := GL_HOOKS.HD_H
		g_.proxies.r.w := GL_HOOKS.HD_W-GL_HOOKS.HD_X
		g_.proxies.r.h := 0
		g_.proxies.FB            := new FBO(GL_HOOKS.W, GL_HOOKS.H, "", fmt)
		g_.proxies.BufferRegion  := new FBO(GL_HOOKS.W, GL_HOOKS.H, "", fmt)
		fileread, s, % g_.cfg.injector_dir "\shaders\xBRz.glsl"
		g_.proxies.xBRz := new Program(s)							
		if g_HD.up
		{
			dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, g_.proxies.FB.FB)	
			dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, g_.proxies.FB.FB)		
		} else if g_.cfg.SSAA
		{			
			s := ceil(GL_HOOKS.HD_H/GL_HOOKS.h) * g_.cfg.SSAA
			g_.proxies.FBHD  := new FBO(GL_HOOKS.W*s, GL_HOOKS.H*s, "", fmt)
			if (g_.cfg.SSAA = 4)
			g_.proxies.FBhlf := new FBO(GL_HOOKS.W*s/2, GL_HOOKS.H*s/2, "", fmt)			
			dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, g_.proxies.FBHD.FB)
			dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, g_.proxies.FBHD.FB)	
			GL_HOOKS.scale := ceil(GL_HOOKS.HD_H/GL_HOOKS.h) *  g_.cfg.SSAA
			GL_HOOKS.ViewX := 0	
			dllcall("peixoto.dll\Scaler", uint, GL_HOOKS.w, uint, GL_HOOKS.h, uint, GL_HOOKS.W*s
	                                    , uint, GL_HOOKS.H*s, uint, 0, uint, g_HD.Sclr[]) 			
		} else 
			dllcall("peixoto.dll\Scaler", uint, GL_HOOKS.w, uint, GL_HOOKS.h, uint, GL_HOOKS.HD_W-GL_HOOKS.HD_X*2
	                                    , uint, GL_HOOKS.HD_H, uint, GL_HOOKS.HD_X, uint, g_HD.Sclr[]) 		
	}	
}

glLog(source, type, id, severity, length, message, userParam)
{
	if instr(strget(message, "CP0"), "static_draw")
		return
	logerr("glError:")
	logerr("source  : " source)
	logerr("type    : " type)
	logerr("id      : " id)
	logerr("severity: " severity)
	logerr("message:  " strget(message, "CP0"))
}

wglMakeCurrent(hDC, Ctxt)
{
	r := dllcall(gl.p.wglMakeCurrent, uint, hDC, uint, Ctxt)
	if (Ctxt = 0) || (r = 0)
		return r
	dllcall("SetLastError", uint, 0)
	for k, v in strsplit("glGenFramebuffers glDeleteFramebuffers glBindFramebuffer glFramebufferTexture2D glBlitFramebuffer glUseProgram glActiveTexture"
	. " glShaderSource glCompileShader glGetShaderiv glGetShaderInfoLog glDeleteShader glCreateShader glCreateProgram glAttachShader"
    . " glGetProgramiv glGetProgramInfoLog glDeleteProgram glDetachShader glLinkProgram glGenVertexArrays glBindVertexArray glDeleteVertexArrays glGenBuffers"
    . " glDeleteBuffers glBindBuffer glBufferData glEnableVertexAttribArray glDrawArrays glDisableVertexAttribArray glVertexAttribPointer glUseProgram"
	. " glUniform4f glUniform2f glGetUniformLocation glGetFramebufferAttachmentParameteriv glDebugMessageCallback glIsTexture glDrawBuffers" 
	. " glGenerateMipmap glCompressedTexImage2D glGenSamplers glDeleteSamplers glBindSampler glSamplerParameteri glGenRenderbuffers glRenderbufferStorage"
	. " glRenderbufferStorageMultisample glBindRenderbuffer glGetRenderbufferParameteriv glDeleteRenderbuffers glTexImage2DMultisample"
	. " glDrawBufferRegion glReadBufferRegion glGetCompressedTextureImage glGetCompressedTexImage glCheckFramebufferStatus", " ")
	{
		gl.p[v]     := dllcall(gl.p.wglGetProcAddress, astr, v, ptr)
		GL_HOOKS[v] := gl.p[v]
		printl(v " address: " gl.p[v] " error " A_lasterror " <- 0 Means no error")
	}
	GL_HOOKS.glTexSubImage2D_trampoline := gl.p.glTexSubImage2D 
	GL_HOOKS.glCompressedTexImage2D     := gl.p.glCompressedTexImage2D 
		
	;dllcall(gl.p.glDebugMessageCallback, uint, RegisterCallback("glLog"))	
    ;dllcall(gl.p.glEnable, uint, GL_DEBUG_OUTPUT)
    ;dllcall(gl.p.glEnable, uint, GL_DEBUG_OUTPUT_SYNCHRONOUS)	
	
	if (g_.cfg.HD)
	{
		if g_.cfg.SSAA
		{
			GL_HOOKS.scale := GL_HOOKS.HD_H/GL_HOOKS.h
			GL_HOOKS.scale := ceil(GL_HOOKS.scale) *  g_.cfg.SSAA
			GL_HOOKS.ViewX := 0
		}
		glViewport(0, 0, GL_HOOKS.W, GL_HOOKS.H)
	}
	
	if (g_.gl.ctxt != Ctxt)
	{
		g_.proxies   := ""
		g_tswap.xbrz := ""
		g_tswap.fb   := ""
		Prxs("wglMakeCurrent()")		
	}
	g_.gl.ctxt := Ctxt
	;dllcall(gl.p.glEnable, int, GL_MULTISAMPLE)
	return r	
}

wglCreateContext(hDC) 
{
	static local_rect := struct("int x, int y, int w, int h")	
	g_.gl_hDC := hDC	
	
	hWin   := dllcall("User32.dll\WindowFromDC", uint, hDC)
	dllcall("User32.dll\GetClientRect", ptr, hWin, ptr, local_rect[])
	g_.res := {"w" : local_rect.w, "h" : local_rect.h}		
	hglrc  := dllcall(gl.p.wglCreateContext, ptr, hDC)
	
	return hglrc
}

wglGetProcAddress(ext)
{
	r := dllcall(gl.p.wglGetProcAddress, ptr, ext, ptr)
	;logerr("Requesting extension " strget(ext+0, "CP0"))		
	
	ex := strget(ext+0, "CP0")
	if gl.ExtHks[ex]
	{
		;logerr("Requesting extension " strget(ext+0, "CP0"))	
		StringCaseSense, ON
		StringReplace, ex, ex, EXT, ,
		StringReplace, ex, ex, ARB, ,
		StringCaseSense, OFF		
		(gl.p[ex]) ?: gl.p[ex] := r
		return gl.ExtHks[ex]
	}
	return r 
}

SetupGl(p2, p3, f="")
{
    res := (g_HD.width and g_HD.height) & True
    ? {"w" : g_HD.width, "h" : g_HD.height} : Desk()
    GL_HOOKS.HD_W   := res.w
    GL_HOOKS.HD_H   := res.h
    GL_HOOKS.H      := p3
    GL_HOOKS.W      := p2
    GL_HOOKS.scale  := GL_HOOKS.HD_H/GL_HOOKS.h
    GL_HOOKS.wide   := GL_HOOKS.HD_W/GL_HOOKS.W
    GL_HOOKS.HD_X   := (GL_HOOKS.HD_W - p2*GL_HOOKS.scale)/2
    GL_HOOKS.ViewX  := GL_HOOKS.HD_X
    GL_HOOKS.aspect := (GL_HOOKS.HD_W/GL_HOOKS.HD_H)/(GL_HOOKS.W/GL_HOOKS.H)
	if g_HD.up 
	{
		GL_HOOKS.scale := 1
		GL_HOOKS.ViewX := 0
	}		
    logerr("`nResolution\Viewport - from: " f)
    logerr("Requested                 : " GL_HOOKS.W " x " GL_HOOKS.H)
    logerr("Real                      : " GL_HOOKS.HD_W " x " GL_HOOKS.HD_H)
    logerr("Correction                : " GL_HOOKS.scale)
    logerr("Viewport width correction : " GL_HOOKS.ViewX)
	/* Belzebub Calls ChangeDisplaymode after the context was created
	 */
	Prxs("SetupGl()")
	dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
	dllcall(dll "\GlDisplayModeChanged", uint, GL_HOOKS.W, uint, GL_HOOKS.H, astr, f)	
}

glDrawBuffer(p1)
{
	if (p1 = GL_BACK || p1 = GL_FRONT_LEFT)
	p1 := GL_COLOR_ATTACHMENT0
	dllcall(gl.p.glDrawBuffer, uint, p1)	
}

glReadBuffer(p1)
{
	if (p1 = GL_BACK || p1 = GL_FRONT_LEFT)
	p1 := GL_COLOR_ATTACHMENT0
	dllcall(gl.p.glReadBuffer, uint, p1)	
}

glCopyTexSubImage2D(p1, p2, p3, p4, p5, p6, p7, p8)
{
	; Basic implementation for NyxQuest
	p5 := p5 << 32 >> 32
	p6 := p6 << 32 >> 32
	p7 := p7 << 32 >> 32
	p8 := p8 << 32 >> 32
	dllcall(gl.p.glCopyTexImage2D, uint, p1, uint, p2, uint, GL_RGBA
	                             , int, p5*GL_HOOKS.scale+GL_HOOKS.ViewX, int, p6*GL_HOOKS.scale
	                             , int, p7*GL_HOOKS.scale, int, p8*GL_HOOKS.scale, uint, 0)
}

glCopyTexImage2D(p1, p2, p3, p4, p5, p6, p7, p8)
{
	; Blood fresh supply
	p5 := p5 << 32 >> 32
	p4 := p4 << 32 >> 32	
	dllcall(gl.p.glCopyTexImage2D, uint, p1, uint, p2, uint, p3 
								 , int, p4*GL_HOOKS.scale, int, p5*GL_HOOKS.scale
								 , int, p6*GL_HOOKS.scale, int, p7*GL_HOOKS.scale, uint, p8)
}

glGetTexLevelParameteriv(p1, p2, p3, p4)
{
	dllcall(gl.p.glGetTexLevelParameteriv, uint, p1, uint, p2, uint, p3, uint, p4)
	if (p2 = 0)
	{
		if (p3=GL_TEXTURE_WIDTH)
		{
			dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D, "uint*", tx:=0)
			if (g_tswap.gl_entry[] := g_tswap.GLTextures.value(tx))
				numput(g_tswap.gl_entry.dwWidth, p4+0)
		} else if (p3=GL_TEXTURE_HEIGHT) {
			dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D, "uint*", tx:=0)
			if (g_tswap.gl_entry[] := g_tswap.GLTextures.value(tx))
				numput(g_tswap.gl_entry.dwHeight, p4+0)
		}
	}
}

glGetTexImage(p1, p2, p3, p4, p5)
{
	dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D, "uint*", tx:=0)
	if (g_tswap.gl_entry[] := g_tswap.GLTextures.value(tx))
	{
		e := g_tswap.gl_entry
		dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_WIDTH, "uint*", w:=0)  
		dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_HEIGHT, "uint*", h:=0)
		if ((w!=e.dwWidth) || (h!=e.dwHeight))	
		{
			dllcall(gl.p.glGetIntegerv, uint, GL_DRAW_FRAMEBUFFER_BINDING, "uint*", db:=0)
			big   := new FBO(1, 1)
			dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, big.FB)
			dllcall(gl.p.glFramebufferTexture2D, uint, GL_DRAW_FRAMEBUFFER, uint, GL_COLOR_ATTACHMENT0, uint, GL_TEXTURE_2D, uint, tx, uint, p2) 
			small := new FBO(w, h)
			dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, small.t.t)
			dllcall(gl.p.glTexImage2D, uint, GL_TEXTURE_2D, uint, 0, uint, e.ifrmt, uint, e.dwWidth, uint, e.dwHeight
														  , uint, 0, uint, e.format, uint, e.chnnls, uint, 0)
			glblt(big.FB, small.FB, 0, 0, w, h, 0, 0, e.dwWidth, e.dwHeight, 0)
			dllcall(gl.p.glGetTexImage, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)	
			dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, tx)	
			dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, db)
			return
		}
	} dllcall(gl.p.glGetTexImage, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5)	
}

glBindFramebuffer(p1, p2)
{
	dllcall(gl.p.glBindFramebuffer, uint, p1, uint, p2)
	if g_HD.up
	{
		if (!p2)
		{
			p2 := g_.proxies.FB.FB
		}
		dllcall(gl.p.glBindFramebuffer, uint, p1, uint, p2)
		return
	}
	else 
	{
		GL_HOOKS.scale := GL_HOOKS.HD_H/GL_HOOKS.h
		GL_HOOKS.ViewX := p2 ? 0 : GL_HOOKS.HD_X						
		if g_.cfg.SSAA
		{
			GL_HOOKS.scale := ceil(GL_HOOKS.scale) *  g_.cfg.SSAA
			GL_HOOKS.ViewX := 0
		}
		glViewPort(GL_HOOKS.vw_x, GL_HOOKS.vw_y, GL_HOOKS.vw_w, GL_HOOKS.vw_h)
		glScissor(GL_HOOKS.scsr_x, GL_HOOKS.scsr_y, GL_HOOKS.scsr_w, GL_HOOKS.scsr_h)
			
		if (p2)
		{
			for k, v in [GL_COLOR_ATTACHMENT0, GL_COLOR_ATTACHMENT1, GL_COLOR_ATTACHMENT2, GL_DEPTH_ATTACHMENT]
			{
				dllcall(gl.p.glGetFramebufferAttachmentParameteriv, uint, p1, uint, v
																  , uint, GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE, "uint*", t:=0)
																  
				dllcall(gl.p.glGetFramebufferAttachmentParameteriv, uint, p1, uint, v
																  , uint, GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME, "uint*", n:=0)													  
				if (t = GL_TEXTURE)
				{
					if (g_tswap.gl_entry[] := g_tswap.GLTextures.value(n))
					{
						e := g_tswap.gl_entry	
						dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_RECTANGLE, "uint*", rc:=0) 
						dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D, "uint*", tx:=0)
						
						dllcall(gl.p.glGetError)
						dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, n)
						if dllcall(gl.p.glGetError, uint)
						{
							dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_RECTANGLE, uint, n)
							dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_RECTANGLE, uint, 0, uint, GL_TEXTURE_WIDTH, "uint*", w:=0)  
							dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_RECTANGLE, uint, 0, uint, GL_TEXTURE_HEIGHT, "uint*", h:=0)	
							if (w && h && (w=e.dwWidth) && (h=e.dwHeight) && (GL_HOOKS.scale!=1))	
							{
								dllcall(gl.p.glTexImage2D, uint, GL_TEXTURE_RECTANGLE, uint, 0, uint, e.ifrmt, uint, e.dwWidth*GL_HOOKS.scale, uint, e.dwHeight*GL_HOOKS.scale
														 , uint, 0, uint, e.format, uint, e.chnnls, uint, 0)
								dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_RECTANGLE, uint, 0, uint, GL_TEXTURE_WIDTH, "uint*", ww:=0)  
								dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_RECTANGLE, uint, 0, uint, GL_TEXTURE_HEIGHT, "uint*", hh:=0)		
								logerr("RTex " w " " h " " ww " " hh " " GL_HOOKS.scale)						 
							}			
						} else{
							dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_WIDTH, "uint*", w:=0)  
							dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_HEIGHT, "uint*", h:=0)
							if (w && h && (w=e.dwWidth) && (h=e.dwHeight) && (GL_HOOKS.scale!=1))	
							{
								dllcall(gl.p.glTexImage2D, uint, GL_TEXTURE_2D, uint, 0, uint, e.ifrmt, uint, e.dwWidth*GL_HOOKS.scale, uint, e.dwHeight*GL_HOOKS.scale
														 , uint, 0, uint, e.format, uint, e.chnnls, uint, 0)
								dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_WIDTH, "uint*", ww:=0)  
								dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_HEIGHT, "uint*", hh:=0)		
								logerr("Tex " w " " h " " ww " " hh " " GL_HOOKS.scale " Fb " p2)						 
							}	
						}						
																	
						dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, tx)	
						dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_RECTANGLE, uint, rc)	
					} else if (g_tswap.gl_entry[] := g_HD.MSTexts.value(n))	
					{ 
						continue
						e := g_tswap.gl_entry	
						dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D_MULTISAMPLE, "uint*", tx:=0)
						dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D_MULTISAMPLE, uint, n)
						dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D_MULTISAMPLE, uint, 0, uint, GL_TEXTURE_WIDTH, "uint*", w:=0)  
						dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D_MULTISAMPLE, uint, 0, uint, GL_TEXTURE_HEIGHT, "uint*", h:=0)
						
						if (w && h && (w=e.dwWidth) && (h=e.dwHeight) && (GL_HOOKS.scale!=1))	
						{
							dllcall(gl.p.glTexImage2DMultisample, uint, GL_TEXTURE_2D_MULTISAMPLE, uint, e.chnnls, uint, e.ifrmt
							, uint, e.dwWidth*GL_HOOKS.scale, uint, e.dwHeight*GL_HOOKS.scale, uint, 1)
							dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D_MULTISAMPLE, uint, 0, uint, GL_TEXTURE_WIDTH, "uint*", ww:=0)  
							dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D_MULTISAMPLE, uint, 0, uint, GL_TEXTURE_HEIGHT, "uint*", hh:=0)		
							logerr("MSTex " w " " h " " ww " " hh " " GL_HOOKS.scale)						 
						}												
						dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D_MULTISAMPLE, uint, tx)	
					}
				}
				else if (t = GL_RENDERBUFFER)
				{	
					if ! (g_tswap.gl_entry[] := g_HD.RndrBffrs.value(n))
					continue			
					
					e := g_tswap.gl_entry
					
					dllcall(gl.p.glGetIntegerv, uint, GL_RENDERBUFFER_BINDING, "uint*", rb:=0)	
					dllcall(gl.p.glBindRenderbuffer, uint, GL_RENDERBUFFER, uint, n)	
					dllcall(gl.p.glGetRenderbufferParameteriv, uint, GL_RENDERBUFFER, uint, GL_RENDERBUFFER_WIDTH, "uint*", w:=0)	
					dllcall(gl.p.glGetRenderbufferParameteriv, uint, GL_RENDERBUFFER, uint, GL_RENDERBUFFER_HEIGHT, "uint*", h:=0)

					if (w && h && (w=e.dwWidth) && (h=e.dwHeight) && (GL_HOOKS.scale!=1))	
					{
						dllcall(gl.p.glRenderbufferStorageMultisample, uint, GL_RENDERBUFFER, uint, e.chnnls, uint, e.ifrmt
						, uint, e.dwWidth*GL_HOOKS.scale, uint, e.dwHeight*GL_HOOKS.scale)	
						logerr("RB " w " " h " " e.dwWidth*GL_HOOKS.scale " " e.dwHeight*GL_HOOKS.scale " " GL_HOOKS.scale)			
					}												
					dllcall(gl.p.glBindRenderbuffer, uint, GL_RENDERBUFFER, uint, rb)						
					;return
				}								
			}	
		} 
		else if g_.cfg.SSAA
		{
			dllcall(gl.p.glBindFramebuffer, uint, p1, uint, g_.proxies.FBHD.FB)
		}				
	} 
}

ChangeDisplaySettingsA(p1, p2)
{
	if !p1
	return dllcall(gl.p.user_ChangeDisplaySettingsA, uint, p1, uint, p2)
	SetupGl(numget(p1+108, "int"), numget(p1+112, "int"), "ChangeDisplaySettingsA")	
}

ChangeDisplaySettingsW(p1, p2)
{
	if !p1
	return dllcall(gl.p.user_ChangeDisplaySettingsW, uint, p1, uint, p2)
	SetupGl(numget(p1+172, "int"), numget(p1+176, "int"), "ChangeDisplaySettingsW")	
}

ChangeDisplaySettingsExW(p1, p2, p3, p4, p5)
{ 	
	logerr("************************************")
	r := GetDesktopResolution()
	w := (rw := numget(p2+172, "int")) ? rw : r.w
	h := (rh := numget(p2+176, "int")) ? rh : r.h
	SetupGl(w, h, "ChangeDisplaySettingsExW")
	numput(GL_HOOKS.HD_W, p2+172, "int")
	numput(GL_HOOKS.HD_H, p2+176, "int")	
}

GetDC(hwin)
{
	if hwin 
	{
		dll := A_ptrsize = 4 ? "peixoto.dll" : "peixoto64.dll"
		if (!g_.cfg.WHKS)
		dllcall(dll "\D3D12ResizeGameWindow", ptr, hwin) 
		dllcall(dll "\D3D12Config", astr, "HWND", ptr, hwin)
	}
	return dllcall(gl.p.user_GetDC, ptr, hwin)	
}

MoveWindow(p1, p2, p3, p4, p5, p6)
{
	r := dllcall(gl.p.user_MoveWindow, ptr, p1, uint, 0, uint, 0, uint, GL_HOOKS.HD_W, uint, GL_HOOKS.HD_H, uint, p6)
	dllcall("SendMessage", ptr, p1, uint, 0x5, ptr, 0, ptr, GL_HOOKS.W|(GL_HOOKS.H<<16)) 
	return r
}

glFrustum(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
{
	ww := getdoubleGl(p1, p2),	w := getdoubleGl(p3, p4) 
	hh := getdoubleGl(p5, p6),	h := getdoubleGl(p7, p8) 
	if g_HD.nofov 
	{
		hh /= GL_HOOKS.aspect
		h  /= GL_HOOKS.aspect 
	} else {
		ww *= GL_HOOKS.aspect 
		w  *= GL_HOOKS.aspect 
	}		
	dllcall(gl.p.glFrustum, "Double", ww, "Double", w, "Double", hh, "Double", h, uint, p9, uint, p10, uint, p11, uint, p12)
	return 
}

glOrtho(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
{
	left   := getdoubleGl(p1, p2) - GL_HOOKS.ViewX/GL_HOOKS.scale
	right  := getdoubleGl(p3, p4) + GL_HOOKS.ViewX/GL_HOOKS.scale
	bottom := getdoubleGl(p5, p6) 
	top    := getdoubleGl(p7, p8) 
	dllcall(gl.p.glOrtho, "Double", left, "Double", right, "Double", bottom, "Double", top, uint, p9, uint, p10, uint, p11, uint, p12)
	return 
}

glLoadMatrixf(pMatrix)
{
	if (g_.gl_matrixmode = GL_PROJECTION)
	{
		gl._ProjectionB[] := pMatrix
		if g_HD.nofov 
		{
			gl._ProjectionB.m22 *= GL_HOOKS.aspect			
		} else {
			gl._ProjectionB.m11 /= GL_HOOKS.aspect							
		}		
	}
	dllcall(gl.p.glLoadMatrixf, "ptr", pMatrix)	
}

glMatrixMode(mode)
{
	g_.gl_matrixmode := mode
	dllcall(gl.p.glMatrixMode, uint, mode)
	return
}

glAdjustScreenCoors(byref x, byref y, byref w, byref h)
{
	(x > 0x7FFFFFFF) ? x := -(~x) - 1
	(y > 0x7FFFFFFF) ? y := -(~y) - 1
	
	h *= GL_HOOKS.scale
	y *= GL_HOOKS.scale
	
	if (g_HD.wide)
	{
		w *= GL_HOOKS.wide
		x *= GL_HOOKS.wide
	} else {
		w *= GL_HOOKS.scale
		x *= GL_HOOKS.scale
		dllcall(gl.p.glGetIntegerv, uint, GL_DRAW_FRAMEBUFFER_BINDING, "uint*", b:=0)
		if (!b)
		x += GL_HOOKS.ViewX 
	}		
}

glViewport(x, y, w, h)
{
	GL_HOOKS.vw_x := x, GL_HOOKS.vw_y := y, GL_HOOKS.vw_w := w, GL_HOOKS.vw_h := h	
	glAdjustScreenCoors(x,  y,  w,  h)
	dllcall(gl.p.glViewport, int, x, int, y, int, w, int, h)		
	return
}

glScissor(x, y, w, h)
{
	GL_HOOKS.scsr_x := x, GL_HOOKS.scsr_y := y, GL_HOOKS.scsr_w := w, GL_HOOKS.scsr_h := h
	glAdjustScreenCoors(x,  y,  w,  h)
	dllcall(gl.p.glScissor, int, x, int, y, int, w, int, h)	
	return 	
}

getdoubleGl(p1, p2)
{
	VarSetCapacity(var, 8)
	numput(p1, &var+0,  "uint")
	numput(p2, &var+4, "uint")
	return numget(&var+0, "double")
}

glBlitFramebuffer(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
{
	SCISSOR := struct("DWORD x, y, w, h")
	dllcall(gl.p.glGetIntegerv, uint, GL_SCISSOR_BOX, ptr, SCISSOR[])	
	p1 *= GL_HOOKS.scale
	p2 *= GL_HOOKS.scale
	p3 *= GL_HOOKS.scale
	p4 *= GL_HOOKS.scale
	p5 *= GL_HOOKS.scale
	p6 *= GL_HOOKS.scale
	p7 *= GL_HOOKS.scale
	p8 *= GL_HOOKS.scale
	;dllcall(gl.p.glScissor, int, p5+GL_HOOKS.ViewX, int, p6, int, p7+GL_HOOKS.ViewX, int, p8)	
    dllcall(gl.p.glBlitFramebuffer, int, p1, int, p2, int, p3, int, p4, int, p5+GL_HOOKS.ViewX, int, p6, int, p7+GL_HOOKS.ViewX, int, p8, int, p9, int, p10)
    ;dllcall(gl.p.glScissor, uint, SCISSOR.x, uint, SCISSOR.y, uint,  SCISSOR.w, uint, SCISSOR.h)
}

glReadBufferRegion(r, x, y, w, h)
{
	; Basic implementation for severance  
	
	dllcall(gl.p.glGetIntegerv, uint, GL_DRAW_FRAMEBUFFER_BINDING, "uint*", db:=0)
	dllcall(gl.p.glGetIntegerv, uint, GL_READ_FRAMEBUFFER_BINDING, "uint*", rb:=0)	

	dllcall("peixoto.dll\_Scale", uint, x, uint, y, uint, w+x, uint, h+y, uint, g_HD.Sclr[])
	g_HD.SREct[] := g_HD.Sclr.src
	g_HD.DREct[] := g_HD.Sclr.dst
	
	glBlt(db, g_.proxies.BufferRegion.FB, g_HD.DRect.x, g_HD.DRect.y, g_HD.DRect.w, g_HD.DRect.h, x, y, w, h, 0, GL_NEAREST)
			
	dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, db)
	dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, rb)
}

glDrawBufferRegion(r, x, y, w, h, xDest, yDest)
{
	; Basic implementation for severance  

	dllcall(gl.p.glGetIntegerv, uint, GL_DRAW_FRAMEBUFFER_BINDING, "uint*", db:=0)
	dllcall(gl.p.glGetIntegerv, uint, GL_READ_FRAMEBUFFER_BINDING, "uint*", rb:=0)

	dllcall("peixoto.dll\_Scale", uint, x, uint, y, uint, w+x, uint, h+y, uint, g_HD.Sclr[])
	g_HD.SREct[] := g_HD.Sclr.src
	g_HD.DREct[] := g_HD.Sclr.dst

	glBlt(g_.proxies.BufferRegion.FB, db, x, y, w, h, g_HD.DRect.x, g_HD.DRect.y, g_HD.DRect.w, g_HD.DRect.h, 0, GL_NEAREST)
	
	dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, db)
	dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, rb)	
}

glReadPixels(x, y, w, h, fmt, t, pData)
{
	rb := 0
	dllcall(gl.p.glGetIntegerv, uint, GL_READ_FRAMEBUFFER_BINDING, "uint*", rb)	
	dllcall("peixoto.dll\_Scale", uint, x, uint, y, uint, w+x, uint, h+y, uint, g_HD.Sclr[])
	g_HD.SREct[] := g_HD.Sclr.src
	g_HD.DREct[] := g_HD.Sclr.dst
	z := ( (fmt = GL_DEPTH_COMPONENT) or (fmt = GL_DEPTH_STENCIL) ) ?  1  : 0
	;logerr(x " " y " " w " " h " " g_HD.DRect.x " " g_HD.DRect.y " " g_HD.DRect.w " " g_HD.DRect.h)
	if (rb = 0) 
		glBlt(0, g_.proxies.FB.FB, g_HD.DRect.x, g_HD.DRect.y, g_HD.DRect.w, g_HD.DRect.h, x, y, w+x, h+y, z)	
	else if (rb = g_.proxies.FBHD.FB)
		glBlt(g_.proxies.FBHD.FB, g_.proxies.FB.FB, g_HD.DRect.x, g_HD.DRect.y, g_HD.DRect.w, g_HD.DRect.h, x, y, w+x, h+y, z)	
	else {
        logerr("glReadPixels: Framebuffer not handled")
        if (z)
            logerr("glReadPixels: Z Framebuffer not handled")
        rbuff := new FBO(w, h)		
        glBlt(rb, rbuff.FB
        , x*GL_HOOKS.scale
        , y*GL_HOOKS.scale
        , (x+w)*GL_HOOKS.scale
        , (y+h)*GL_HOOKS.scale
        , 0, 0, w, h, z)	
        dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, rbuff.FB)
        dllcall(gl.p.glReadPixels, uint, x, uint, y, uint, w, uint, h, uint, fmt, uint, t, uint, pData)	
        dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, rb)
        return
		return dllcall(gl.p.glReadPixels, uint, x, uint, y, uint, w, uint, h, uint, fmt, uint, t, uint, pData)	
		return
	}
	dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, g_.proxies.FB.FB)
	dllcall(gl.p.glReadPixels, uint, x, uint, y, uint, w, uint, h, uint, fmt, uint, t, uint, pData)	
	dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, rb)
	return
}

glDrawPixels(w, h, fmt, _type_, p_data)
{
	; Basic implementation for severance and Oddworld stranger's wrath 
    ; works only with draws on the default frame buffer    

	dllcall(gl.p.glGetIntegerv, uint, GL_DRAW_FRAMEBUFFER_BINDING, "uint*", db:=0)
	dllcall(gl.p.glGetIntegerv, uint, GL_READ_FRAMEBUFFER_BINDING, "uint*", rb:=0)	

	; The raster position respects viewport offsets 	 
	s  := g_.cfg.SSAA ? ceil(GL_HOOKS.HD_H/GL_HOOKS.H) * g_.cfg.SSAA  : GL_HOOKS.HD_H/GL_HOOKS.H
	x  := g_.cfg.SSAA ? 0: GL_HOOKS.HD_X
	ww := GL_HOOKS.w+GL_HOOKS.ViewX
	hh := GL_HOOKS.h
	_w := GL_HOOKS.w*s + x
	_h := GL_HOOKS.h*s 
	proxy := new FBO(ww, hh)
	
	glBlt(db, proxy.FB, x, 0, _w, _h, GL_HOOKS.ViewX, 0, ww, GL_HOOKS.h, 0, GL_NEAREST)	        
	dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, proxy.FB)				
	dllcall(gl.p.glDrawPixels, uint, w, uint, h, uint, fmt, uint, _type_, ptr, p_data) 	
	glBlt(proxy.FB, db, GL_HOOKS.ViewX, 0, ww, GL_HOOKS.h, x, 0, _w, _h, 0, GL_NEAREST)	 			  

	proxy := ""
	dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, db)
	dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, rb)	
}

glBitmap(p1, p2, p3, p4, p5, p6, p7)
{
	; Basic implementation for severance and Oddworld stranger's wrath 
    ; works only with draws on the default frame buffer    

	dllcall(gl.p.glGetIntegerv, uint, GL_DRAW_FRAMEBUFFER_BINDING, "uint*", db:=0)
	dllcall(gl.p.glGetIntegerv, uint, GL_READ_FRAMEBUFFER_BINDING, "uint*", rb:=0)	

	; The raster position respects viewport offsets    
	s  := g_.cfg.SSAA ? ceil(GL_HOOKS.HD_H/GL_HOOKS.H) * g_.cfg.SSAA  : GL_HOOKS.HD_H/GL_HOOKS.H
	x  := g_.cfg.SSAA ? 0: GL_HOOKS.HD_X
	ww := GL_HOOKS.w+GL_HOOKS.ViewX
	hh := GL_HOOKS.h
	_w := GL_HOOKS.w*s + x
	_h := GL_HOOKS.h*s 
	proxy := new FBO(ww, hh)
	
	glBlt(db, proxy.FB, x, 0, _w-x, _h, GL_HOOKS.ViewX, 0, ww, GL_HOOKS.h, 0, GL_NEAREST)	      
	dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, proxy.FB)				
	dllcall(gl.p.glBitmap, ptr, p1, ptr, p2, uint, p3, uint, p4, uint, p5, uint, p6, ptr, p7) 	
	glBlt(proxy.FB, db, GL_HOOKS.ViewX, 0, ww, GL_HOOKS.h, x, 0, _w-x, _h, 0, GL_NEAREST)

	proxy := ""
	dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, db)
	dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, rb)	
}

glBlt(s, d, sx, sy, sw, sh, dx, dy, dw, dh, z, f="")
{
	dllcall(gl.p.glGetIntegerv, uint, GL_DRAW_FRAMEBUFFER_BINDING, "uint*", db:=0)
	dllcall(gl.p.glGetIntegerv, uint, GL_READ_FRAMEBUFFER_BINDING, "uint*", rb:=0)
	dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, d)
	dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, s)	
	dllcall(gl.p.glGetIntegerv, uint, 0x0C11, "int*", Scissor:=0) 
	dllcall(gl.p.glDisable, int, 0x0C11) ;	
	
	msk  := z ? GL_DEPTH_BUFFER_BIT : GL_COLOR_BUFFER_BIT
	fltr := z ? GL_NEAREST : GL_LINEAR
	f         ? fltr := f 
	dllcall(gl.p.glBlitFramebuffer, uint, sx, uint, sy, uint, sw, uint, sh, uint, dx, uint, dy, uint, dw, uint, dh
	, uint, msk, uint, fltr)
								  
	dllcall(gl.p.glBindFramebuffer, uint, GL_DRAW_FRAMEBUFFER, uint, db)
	dllcall(gl.p.glBindFramebuffer, uint, GL_READ_FRAMEBUFFER, uint, rb)	
	if (Scissor = GL_TRUE)
	dllcall(gl.p.glEnable, int, 0x0C11)	
}

class BindText
{
	__new(tx){
		dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D, "uint*", t := 0)	
		dllcall(gl.p.glGetIntegerv, uint, GL_PIXEL_UNPACK_BUFFER_BINDING, "uint*", b := 0)	
		(gl.p.glBindBuffer) ? dllcall(gl.p.glBindBuffer, uint, GL_PIXEL_UNPACK_BUFFER, uint, 0)
		this.t  := t
		this.b  := b
		dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, tx)
	}
	size(){
		dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_WIDTH, "uint*", w:=0)  
		dllcall(gl.p.glGetTexLevelParameteriv, uint, GL_TEXTURE_2D, uint, 0, uint, GL_TEXTURE_HEIGHT, "uint*", h:=0)
		return {"w" : w, "h" : h}
	}
	__delete(){
		dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, this.t)
		(gl.p.glBindbuffer) ? dllcall(gl.p.glBindBuffer, uint, GL_PIXEL_UNPACK_BUFFER, uint, this.b)	
	}
}		

class TextGen
{
	__new(m="")
	{
		dllcall(gl.p.glGetIntegerv, uint, GL_TEXTURE_BINDING_2D, "uint*", t := 0)	
		dllcall(gl.p.glGetIntegerv, uint, GL_PIXEL_UNPACK_BUFFER_BINDING, "uint*", b := 0)	
		(gl.p.glBindBuffer) ? dllcall(gl.p.glBindBuffer, uint, GL_PIXEL_UNPACK_BUFFER, uint, 0)
		
		if (g_.cfg.IsLinux = false)
		{
			tx := 9000
			while dllcall(gl.p.glIsTexture, uint, tx, uchar)
				tx -= 1
			
			dllcall(gl.p.glGetError)
			dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, tx)
			tex_created := dllcall(gl.p.glGetError, uint) ? false : true
		} else tex_created := false
		if (!tex_created)		
		{
			dllcall(gl.p.glGenTextures, uint, 1, "uint*", tx)
			dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, tx)
		}
		dllcall(gl.p.glTexParameteri, uint, GL_TEXTURE_2D, uint, GL_TEXTURE_MIN_FILTER, uint, m ? GL_NEAREST_MIPMAP_NEAREST : GL_NEAREST)
		dllcall(gl.p.glTexParameteri, uint, GL_TEXTURE_2D, uint, GL_TEXTURE_MAG_FILTER, uint, GL_NEAREST)
		dllcall(gl.p.glTexParameteri, uint, GL_TEXTURE_2D, uint, GL_TEXTURE_WRAP_S, uint, GL_CLAMP_TO_EDGE)
		dllcall(gl.p.glTexParameteri, uint, GL_TEXTURE_2D, uint, GL_TEXTURE_WRAP_T, uint, GL_CLAMP_TO_EDGE)		
		this.t  := t
		this.b  := b
		this.tx := tx
	} 
	__delete()
	{
		dllcall(gl.p.glBindTexture, uint, GL_TEXTURE_2D, uint, this.t)
		(gl.p.glBindbuffer) ? dllcall(gl.p.glBindBuffer, uint, GL_PIXEL_UNPACK_BUFFER, uint, this.b)	
	}
}

class glText 
{
	__new(w, h, m="", fmt="")
	{
		this.t := (t := new TextGen(m)).tx	
		if (!fmt)
		{
			fmt       := GL_RGBA8
			chnnls    := GL_RGBA
			data_type := GL_UNSIGNED_BYTE
		} else if instr(fmt, "s")
		{
			data_type := {"Z24S8" : GL_UNSIGNED_INT, "Z32S8" : GL_UNSIGNED_INT}[fmt]
			fmt       := {"Z24S8" : GL_DEPTH24_STENCIL8, "Z32S8" : GL_DEPTH32F_STENCIL8}[fmt]
			chnnls    := GL_DEPTH_STENCIL			
		}
		else 
		{
			data_type := {"Z16X" : GL_UNSIGNED_SHORT, "Z24X8" : GL_UNSIGNED_INT, "Z32X" : GL_UNSIGNED_INT, "Z32F" : GL_FLOAT}[fmt]
			fmt       := {"Z16X" : GL_DEPTH_COMPONENT16, "Z24X8" : GL_DEPTH_COMPONENT24, "Z32X" : GL_DEPTH_COMPONENT32, "Z32F" : GL_DEPTH_COMPONENT32F}[fmt]
			chnnls    := GL_DEPTH_COMPONENT
		}
		dllcall(gl.p.glGetError)
		dllcall(gl.p.glTexImage2D, uint, GL_TEXTURE_2D, uint, 0, uint, fmt, uint, w, uint, h
								, uint, 0, uint, chnnls, uint, data_type, uint, 0)	
		if (dllcall(gl.p.glGetError, uint) != 0){
			logerr("glTexImage2D Error: " dllcall(gl.p.glGetError, uint))
		}
	}

	__delete() {
		dllcall(gl.p.glDeleteTextures, uint, 1, "uint*", this.t)	
	}
}

class FBO 
{
	__NEW(w, h, m="", z=False)
	{
		FB:=0, crrnt_bff:=0
		dllcall(gl.p.glGetIntegerv, uint, GL_FRAMEBUFFER_BINDING, "uint*", crrnt_bff) 	
		
		dllcall(gl.p.glGenFramebuffers, uint, 1, "uint*", FB:=90)
		logerr("FB " fb)
		this.FB := FB
		dllcall(gl.p.glBindFramebuffer, uint, GL_FRAMEBUFFER, uint, FB)
		
		this.t := new glText(w, h, m)	
		dllcall(gl.p.glFramebufferTexture2D, uint, GL_FRAMEBUFFER, uint, GL_COLOR_ATTACHMENT0, uint, GL_TEXTURE_2D, uint, this.t.t, uint, 0)	
		
		status := dllcall(gl.p.glCheckFramebufferStatus, uint, GL_FRAMEBUFFER)
		logerr("FB Status: " status)
		logerr("z " z)
		if z {		
			this.z := new glText(w, h, ,z)	
			dllcall(gl.p.glFramebufferTexture2D, uint, GL_FRAMEBUFFER, uint, GL_DEPTH_ATTACHMENT, uint, GL_TEXTURE_2D, uint, this.z.t, uint, 0)
			instr(z, "s") ? dllcall(gl.p.glFramebufferTexture2D, uint, GL_FRAMEBUFFER, uint, GL_STENCIL_ATTACHMENT, uint, GL_TEXTURE_2D, uint, this.z.t, uint, 0)
		}	
		status := dllcall(gl.p.glCheckFramebufferStatus, uint, GL_FRAMEBUFFER)
		logerr("FB Status: " status)
		dllcall(gl.p.glBindFramebuffer, uint, GL_FRAMEBUFFER, uint, crrnt_bff)
	}

	__Delete()
	{
		;logerr("Deleting FBO")
		this.t := ""
		this.z := ""
		dllcall(gl.p.glDeleteFramebuffers, uint, 1, "uint*", this.FB)	
	}
}

class Program
{
	__new(ps, vs="")
	{
		if (!vs)
		vs :=
		(
		"
		#version 130
		uniform vec4 ViewPort;
		in vec3 vin;
		in vec2 coords;
		out vec2 crds;
		void main()
		{
		gl_Position.x = (vin.x/(ViewPort.z/2.)-1.0);
		gl_Position.y = (vin.y/(ViewPort.w/-2.)+1.0); 
		gl_Position.z = 0.0;
		gl_Position.w = 1.0;
		crds = coords; 	    
		}
		"
		)	
		this.vw := struct("DWORD x, y, w, h")
		this.p := dllcall(g_.p.GlCmplPgrm, astr, ps, astr, vs, "ptr*", err := 0)
		logerr("program " this.p " " errorlevel)
		if err
			this.err := strget(err, "CP0")	
	}

	v()
	{
		dllcall(gl.p.glGetIntegerv, uint, GL_VIEWPORT, uint, this.vw[])
		this._f4("ViewPort", this.vw.x, this.vw.y, this.vw.w, this.vw.h)
	}

	f(n)
	{
		l := dllcall(gl.p.glGetUniformLocation, uint, this.p, astr, n)
		dllcall(gl.p.glGetIntegerv, uint, GL_CURRENT_PROGRAM, "uint*", p:=0)
		dllcall(gl.p.glUseProgram, uint, this.p)
		this.pv := p
		return l
	}

	_f2(n, v1, v2=0)
	{
		l := this.f(n)
		dllcall(gl.p.glUniform2f, uint, l, float, v1, float, v2)
		dllcall(gl.p.glUseProgram, uint, this.pv)
	}

	_f4(n, v1, v2=0, v3=0, v4=0)
	{
		l := this.f(n)
		dllcall(gl.p.glUniform4f, uint, l, float, v1, float, v2, float, v3, float, v4)
		dllcall(gl.p.glUseProgram, uint, this.pv)
	}

	__delete(){
		dllcall(gl.p.glDeleteProgram, uint, this.p)
	}
}