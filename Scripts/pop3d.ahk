;REMOTE SCRIPT START

PatBlt(p1, p2, p3, p4, p5, p6)
{
	d := desk()      
	return dllcall(g_.WnAPI.PatBlt, uint, p1, uint, 0, uint, 0, uint, d.w, uint, d.h, uint, p6)
}

AltBitBltHook(p1, p2, p3, p4, p5, p6, p7, p8, p9)
{
	d        := desk()
	x_offset := 1/2 * (d.w - 640)
	y_offset := 1/2 * (d.h - 480)
	return dllcall(g_.WnAPI.Bitblt, uint, p1, uint, p2+x_offset, uint, p3+y_offset, uint, p4, uint, p5, uint, p6, uint, p7, uint, p8, uint, p9)			
}