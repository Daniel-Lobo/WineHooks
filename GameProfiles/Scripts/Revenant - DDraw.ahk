h_game := Get_process_handle((g_.rnm) ? "_revenant.exe" : "revenant.exe")

if (h_game)
{
	if (read_process_memory(h_game, 0x4a6115, "uchar") = 0x74)
		write_process_memory(h_game, 0x4a6115, "uchar", 0xEB)
}

;REMOTE SCRIPT START
iniread, soft, revenant.ini, Options, Software3D
g_.s.soft := (soft="Yes" or g_.s.soft=1) ? True :False
logerr(IDirect3DDevice3.Hook("GetClipStatus"))

		
AltIDirect3D3_CreateDevice(p1, p2, p3, p4, p5)
{
	r := IDirect3D3_CreateDevice(p1, p2, p3, p4, p5)
	g_.rtrgt := ""
	return r
}
	
