;REMOTE SCRIPT START
;#include %A_ScriptDir%\src\dsound.hooks.txt
;logerr(GetDirectSound())
;logerr(GetDirectSound8())	
;Logerr(IDirectSound.Hook("CreateSoundBuffer"))
logerr(IDirect3DMSurface8.UnHook("LockRect"))		
logerr(IDirect3DMSurface8.UnHook("UnLockRect"))	

IDirectSound_CreateSoundBuffer(p1, p2, p3, p4)
{
	static  ctrl_3d_flag
	DSBUFFERDESC[] := p2
	
	if (DSBUFFERDESC.dwFlags & DSBCAPS_PRIMARYBUFFER)
		ctrl_3d_flag := DSBUFFERDESC.dwFlags & DSBCAPS_CTRL3D
	else 
	{
		if (ctrl_3d_flag)
		DSBUFFERDESC.dwFlags |=   DSBCAPS_CTRL3D
        else             
		DSBUFFERDESC.dwFlags &= ~ DSBCAPS_CTRL3D
	}	
	return dllcall(IDirectSound.CreateSoundBuffer, uint, p1, uint, p2, uint, p3, uint, p4)
}
