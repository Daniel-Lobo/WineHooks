;REMOTE SCRIPT START
logerr(IDirectSound.Hook("SetCooperativeLevel"))

global psi_ops_hwin
Gui, +hwndpsi_ops_hwin
gui, show, w1366 h768

Alt_CreateDevice(p1, p2, p3, p4, p5, p6, p7)
{
	if (p6)	dllcall("RtlMoveMemory", ptr, D3DPRESENT_PARAMETERS[], ptr, p6, int, D3DPRESENT_PARAMETERS.size())
	D3D9CleanUp(p6)	
	
	hwin                                := p4
	D3DPRESENT_PARAMETERS.hDeviceWindow := psi_ops_hwin
	p4                                  := psi_ops_hwin
		
	for k, v in D3DPRESENT_PARAMETERS
	logerr(k "->" v)
		
	if ! (r := dllcall(IDirect3D9.CreateDevice, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, D3DPRESENT_PARAMETERS[], uint, p7, uint))
	{
		D3D9_HOOKS.safe := (p5 & D3DCREATE_MULTITHREADED) ? 1: 0
		logerr("multithread " D3D9_HOOKS.safe)
		g_.pDevice9 := numget(p7+0, "ptr")		
		D3D9Setup()		
		dllcall("SendMessage", uint, hWin, uint, 0x5, uint, 0, uint, D3D9_HOOKS.W|(D3D9_HOOKS.H<<16)) 		
	}
	dllcall(g_.p.Critical, uint, 0)
	return r	
	return r
}

IDirectSound_SetCooperativeLevel(p1, p2, p3)
{
	return dllcall(IDirectSound.SetCooperativeLevel, uint, p1, uint, psi_ops_hwin, uint, p3)
}

