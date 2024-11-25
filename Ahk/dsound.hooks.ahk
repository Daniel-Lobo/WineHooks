#include lib\DirectX\dsound.ahk
global DSND_HOOKS := struct("LPVOID DsCrt; LPVOID CrtSndBffr; LPVOID Release; LPVOID play; LPVOID GtCps; LPVOID Query; LPVOID StPpr; LPVOID GTPrp; LPVOID Spprt; DWORD f;")
global g_dsnd 
InitDSndHooks()

InitDSndHooks()
{
	g_dsnd       := parsecfg(g_.cfg.dsnd)
    g_dsnd.loger := new Loger(g_.cfg.injector_dir "\DSound.log")	  
	
    if not g_dsnd.e 
    return

    if (g_.cfg.console && GetKeyState("Q", "P"))
    DSND_HOOKS.f := 0x1    
		
	dllcall("Peixoto.dll\InitDSoundHooks", uint, DSND_HOOKS[])	
    return
}    
		
	