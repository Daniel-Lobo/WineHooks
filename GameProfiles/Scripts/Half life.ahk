;REMOTE SCRIPT START
d             := Desk()
GL_HOOKS.H    := 540
GL_HOOKS.W    := 540*d.w/d.h
gl.ExtHks["glBlitFrameBuffer"]    := registercallback("AltglBlitFramebuffer", "F")	
gl.ExtHks["glBlitFrameBufferARB"] := gl.ExtHks["glBlitFrameBuffer"]
gl.ExtHks["glBlitFrameBufferEXT"] := gl.ExtHks["glBlitFrameBuffer"]


AltglBlitFramebuffer(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
{
	;logerr(p1 " " p2 " " p3 " " p4 " " p5 " " p6 " " p7 " " p8 " " GL_HOOKS.scale)
	p1 *= GL_HOOKS.scale
	p2 *= GL_HOOKS.scale
	p3 *= GL_HOOKS.scale
	p4 *= GL_HOOKS.scale
	;p5 *= 1.5
	;p6 *= 1.5
	;p7 *= 1.5
	;p8 *= 1.5
	return dllcall(gl.p.glBlitFramebuffer
	, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint, p7, uint, p8, uint, p9, uint, p10)
}

AltSetWindowPos(p1, p2, p3, p4, p5, p6, p7)
{
	p7 &= ~ 0x0002
	r := dllcall(gl.p.user_SetWindowPos, ptr, p1, uint, p2, uint, 0, uint, 0, uint, GL_HOOKS.HD_W, uint, GL_HOOKS.HD_H, uint, p7)
	return r
}

