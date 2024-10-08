;REMOTE SCRIPT START
resume()
TR1_Init()
return
TR1_Init()
{
	r           := Desk()
	g_.s.aspect := r.w/r.h
	g_.s.scl    := r.h/384
	
	if g_.cfg.target_name = "tombati.exe"
	{
		redirectcall(0x41e045, "TATIAmmoDisplay", "F Cdecl") 
		redirectcall(0x41d5f9, "TATIStats", "F Cdecl") 
		redirectcall(0x41d703, "TATIStats", "F Cdecl") 
		redirectcall(0x41d76b, "TATIStats", "F Cdecl")
		redirectcall(0x41d7b4, "TATIStats", "F Cdecl")
		redirectcall(0x41d7fb, "TATIStats", "F Cdecl")
		redirectcall(0x41DD85, "TATIHealth", "F Cdecl") 
		redirectcall(0x41DF0C, "TATIHealth", "F Cdecl") 
		redirectcall(0x41DDD7, "TATIAir", "F Cdecl") 
				
		p := new Prtct(0x41f99a, 5)
		numput(0xb8, 0x41f99a, 0, "char")
		numput(0x01, 0x41f99a, 1, "uint")
		
		w := 384*g_.s.aspect
		p := new Prtct(0x408a28, 9)		
		numput(w, 0x408a28, 7, "ushort")
		
		p := new Prtct(0x407c43, 10)
		numput(w, 0x407c43, 6, "uint")
	} else {
		redirectcall(0x41dd45, "TUBAmmoDisplay", "F Cdecl")
		redirectcall(0x41d359, "TUBStats", "F Cdecl") 
		redirectcall(0x41d463, "TUBStats", "F Cdecl") 
		redirectcall(0x41d4cb, "TUBStats", "F Cdecl") 
		redirectcall(0x41d514, "TUBStats", "F Cdecl") 
		redirectcall(0x41d55b, "TUBStats", "F Cdecl")
		redirectcall(0x41DA85, "TATIHealth", "F Cdecl") 
		redirectcall(0x41DC0C, "TATIHealth", "F Cdecl")
		redirectcall(0x41DAD7, "TATIAir", "F Cdecl") 
	
		p := new Prtct(0x41f5ea, 5)
		numput(0xb8, 0x41f5ea, 0, "char")
		numput(0x01, 0x41f5ea, 1, "uint")
		
		w := 384*g_.s.aspect
		p := new Prtct(0x408a35, 9)		
		numput(w, 0x408a35, 7, "ushort")
		
		p := new Prtct(0x407c50, 10)
		numput(w, 0x407c50, 6, "uint")
	}
}

TATIAir(a)
{
	static ctxt := 0, hh := 0, ww := 0, frame := 0
	if (g_.gl.ctxt != ctxt)
	{
		p :=
		(LTRIM
		"
		#version 330 
		layout(origin_upper_left, pixel_center_integer) in vec4 gl_FragCoord;
		uniform vec4 clr;
		uniform vec2 vpos;
		void main()
		{
			float norm_pos = (gl_FragCoord.y-vpos.x)/(vpos.y-vpos.x);
			float norm_clr = (1-abs(norm_pos-0.5))*0.7;
			gl_FragColor   = clr*norm_clr;
		}
		"
		)
		hh            := Desk().h	
		ww	          := Desk().w		
		g_.s.a_shader := new Program(p)	
		g_.s.a_rct    := struct("DWORD x, y, w, h")
		g_.s.a_rct.y  := hh/90
		g_.s.a_rct.h  := g_.s.a_rct.y*3
		ctxt := g_.gl.ctxt
		logerr("Air shader: " g_.s.a_shader.err)		
	}
	dllcall(gl.p.glGetIntegerv, uint, GL_CURRENT_PROGRAM, "uint*", p:=0)	
	dllcall(gl.p.glUseProgram, uint, g_.s.a_shader.p)	
	
	g_.s.a_rct.x := ww-(g_.s.a_rct.y*31)
	g_.s.a_rct.w := ww-g_.s.a_rct.y	
	g_.s.a_shader.v()
	
	g_.s.a_shader._f2("vpos", g_.s.h_rct.y, g_.s.h_rct.h)
	g_.s.a_shader._f4("clr", 0.25, 0.25, 0.25, 1)				
	dllcall(g_.p.DrawRect, uint, g_.s.a_rct[], uint, 0)		
	
	g_.s.a_rct.w := g_.s.a_rct.x + g_.s.a_rct.y*30*a/100
	g_.s.a_shader._f4("clr", 0.2, 0.8, 1.0, 1)
	if (a <= 20)
	{
		frame += 1
		frame > 15 ? frame := -15
		if (frame <= 0)
			g_.s.a_rct.w := g_.s.a_rct.x 			
	} 
	dllcall(g_.p.DrawRect, uint, g_.s.a_rct[], uint, 0)	
	dllcall(gl.p.glUseProgram, uint, p)	
	return
}

TATIHealth(h)
{
	static ctxt := 0, hh := 0, frame := 0
	if (g_.gl.ctxt != ctxt)
	{
		p :=
		(LTRIM
		"
		#version 330 
		layout(origin_upper_left, pixel_center_integer) in vec4 gl_FragCoord;
		uniform vec4 clr;
		uniform vec2 vpos;
		void main()
		{
			float norm_pos = (gl_FragCoord.y-vpos.x)/(vpos.y-vpos.x);
			float norm_clr = (1-abs(norm_pos-0.5))*0.7;
			gl_FragColor   = clr*norm_clr;
		}
		"
		)
		hh            := Desk().h		           
		g_.s.h_shader := new Program(p)	
		g_.s.h_rct    := struct("DWORD x, y, w, h")
		g_.s.h_rct.y := hh/90
		g_.s.h_rct.h := g_.s.h_rct.y*3
		ctxt := g_.gl.ctxt
		logerr("Health shader: " g_.s.h_shader.err)		
	}
	dllcall(gl.p.glGetIntegerv, uint, GL_CURRENT_PROGRAM, "uint*", p:=0)	
	dllcall(gl.p.glUseProgram, uint, g_.s.h_shader.p)	
	
	g_.s.h_rct.x := g_.s.h_rct.y
	g_.s.h_rct.w := g_.s.h_rct.y*31	
	g_.s.h_shader.v()
	
	g_.s.h_shader._f2("vpos", g_.s.h_rct.y, g_.s.h_rct.h)
	g_.s.h_shader._f4("clr", 0.25, 0.25, 0.25, 1)				
	dllcall(g_.p.DrawRect, uint, g_.s.h_rct[], uint, 0)		
	
	g_.s.h_rct.w := g_.s.h_rct.x + g_.s.h_rct.y*30*h/100
	g_.s.h_shader._f4("clr", 0.640, 0.468, 0.281, 1)
	if (h <= 20)
	{
		frame += 1
		frame > 15 ? frame := -15
		if (frame <= 0)
			g_.s.a_rct.w := g_.s.a_rct.x 			
	} 
	dllcall(g_.p.DrawRect, uint, g_.s.h_rct[], uint, 0)	
	dllcall(gl.p.glUseProgram, uint, p)	
	return
}

TATIAmmoDisplay(x, y, a3, txt)
{
	(x > 0x7FFFFFFF) ? x := -(~x) - 1
	(y > 0x7FFFFFFF) ? y := -(~y) - 1
	p := new Prtct(0x43980f, 5)		
	numput(0x10000*g_.s.scl, 0x43980f, 1, "uint")
	r := dllcall(0x439780, int, x*g_.s.scl, int, y*g_.s.scl, uint, a3, uint, txt, "Cdecl")
	numput(0x10000, 0x43980f, 1, "uint")
	return r
}

TATIStats(x, y, a3, txt)
{
	(x > 0x7FFFFFFF) ? x := -(~x) - 1
	p := new Prtct(0x43980f, 5)		
	numput(0x10000*g_.s.scl, 0x43980f, 1, "uint")
	r := dllcall(0x439780, uint, x, int, y*g_.s.scl, uint, a3, uint, txt, "Cdecl")
	numput(0x10000, 0x43980f, 1, "uint")
	return r
}

TUBAmmoDisplay(x, y, a3, txt)
{
	(x > 0x7FFFFFFF) ? x := -(~x) - 1
	(y > 0x7FFFFFFF) ? y := -(~y) - 1
	p := new Prtct(0x43915f, 5)		
	numput(0x10000*g_.s.scl, 0x43915f, 1, "uint")
	r := dllcall(0x4390D0, int, x*g_.s.scl, int, y*g_.s.scl, uint, a3, uint, txt, "Cdecl")
	numput(0x10000, 0x43915f, 1, "uint")
	return r
}

TUBStats(x, y, a3, txt)
{
	(x > 0x7FFFFFFF) ? x := -(~x) - 1
	p := new Prtct(0x43915f, 5)		
	numput(0x10000*g_.s.scl, 0x43915f, 1, "uint")
	r := dllcall(0x4390D0, uint, x, int, y*g_.s.scl, uint, a3, uint, txt, "Cdecl")
	numput(0x10000, 0x43915f, 1, "uint")
	return r
}

