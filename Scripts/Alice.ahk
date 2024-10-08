(g_.custom_fov) ? user_fov := g_.f
h_alice := get_process_handle("Alice.exe")
if (g_.args = "-RunningFromAlice2")
	goto fovfix

fovfix():
	;g_resx := read_process_memory(h_alice, 0x00AA65EC, "int")
	;g_resy := read_process_memory(h_alice, 0x00AA65F0, "int")
	desk := Desk()
	g_resx := desk.w
	g_resy := desk.h
	while not g_resx
	{
		g_resx := read_process_memory(h_alice, 0x00AA65EC, "int")
		g_resy := read_process_memory(h_alice, 0x00AA65F0, "int")
		sleep, 200
	}	
	v_fov := tFOV(90., [3, 4])
	h_fov := (user_fov) ? user_fov : tFOV(v_fov, [g_resx, g_resy])
	print("`n" g_resx "x" g_resy " " h_fov " " g_.f "`n")	
	if g_fov
		h_fov := g_fov
	correction := h_fov - 90
		
	setformat, integer, hex
			
	code := "68 " memlib_Number2String(correction, "float")
	code .= "D8 04 24 "
	code .= "83 C4 04 "
	code .= "D9 1D D0 3A 2F 30	"
	
	codeb := "B9 " memlib_Number2String(h_fov, "float", False)
	codeb .= "89 0D D0 3A 2F 30"	
					
	hack := new CodeCave(h_alice, 0x300270cc, memlib_String2Bytearray(code))
	hackb := new CodeCave(h_alice, 0x30027054, memlib_String2Bytearray(codeb))	
	
		
fovLoop():
	while not read_process_memory(h_alice, 0x300270cc, "int")
		sleep, 200

	Loop
	{
		if not get_process_ID("Alice.exe")
			exitapp
		hack._enable()
		hackb._enable()		
		;if ( (g_resx != read_process_memory(h_alice, 0x00AA65EC, "int")) or (g_resy != read_process_memory(h_alice, 0x00AA65F0, "int")) )
			;break				  
		sleep, 200
	} goto fovfix()
return

fovfix:
	g_resx := read_process_memory(h_alice, 0x011C02CC, "int")
	g_resy := read_process_memory(h_alice, 0x011C02D0, "int")
	while not g_resx
		{
			g_resx := read_process_memory(h_alice, 0x011C02CC, "int")
			g_resy := read_process_memory(h_alice, 0x011C02D0, "int")
			sleep, 200
		}
	print("`n" g_resx " " g_resy)
	v_fov := tFOV(90., [3, 4])
	h_fov := user_fov ? user_fov : tFOV(v_fov, [g_resx, g_resy])
	if g_fov
		h_fov := g_fov
	correction := h_fov - 90   
	v_scale :=  tFOV(h_fov, [g_resy, g_resx])
				
	setformat, integer, hex
		
	code := "68 " memlib_Number2String(correction, "float")
	code .= "D8 04 24 "
	code .= "83 C4 04 "
	code .= "D9 1D 5C 57 31 30"	
		
	hack := new CodeCave(h_alice, 0x3002684b, memlib_String2Bytearray(code))

	while not read_process_memory(h_alice, 0x3002684b, "int")
		sleep, 200

	Loop
		{
			if not get_process_ID("Alice.exe")
				exitapp
			hack._enable()	
			write_process_memory(h_alice, 0x30315760, "float", v_scale)
			write_process_memory(h_alice, 0x30037C60, "array", [0x90, 0x90, 0x90, 0x90, 0x90])
			write_process_memory(h_alice, 0x30026857, "array", [0x90, 0x90, 0x90, 0x90, 0x90, 0x90])
			if ( (g_resx != read_process_memory(h_alice, 0x011C02CC, "int")) or (g_resy != read_process_memory(h_alice, 0x011C02D0, "int")) )
				break	
			sleep, 200
		} goto fovfix	
return

tFOV(oldfov, ratio)
{
	oldfov *= 0.01745329252 / 2
	return 2 * (ATan(tan(oldfov) * ratio[1]/ratio[2]) * 57.29578)
}

;REMOTE SCRIPT START

logerr("CreateProcessW Hook: " InstallHook("CreateProcessW", pCreateProcessW, "Kernel32.dll", "CreateProcessW") " <- 0 means no error")
CreateProcessW(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
{
	dllcall("Kernel32\ExitProcess", uint, 0)	
}	

Alt_glLoadMatrixf(pMatrix)
{
	if (g_.gl_matrixmode = GL_PROJECTION)
	{
		gl._ProjectionB[] := pMatrix
		if (gl._ProjectionB.m22  > 3) or (gl._Projection.m11 > 4) 
			g_HD.nofov := False			
		else g_HD.nofov := True	
	}
	return glLoadMatrixf(pMatrix)
}