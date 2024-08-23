;REMOTE SCRIPT START
;RegWrite, REG_DWORD, HKLM, SOFTWARE\WOW6432Node\CAPCOM\RESIDENT EVIL, Display Driver, 3 

isobject(IDirectSoundBuffer) ? logerr(IDirectSoundBuffer.PatchVtable("Play"))
IDirectSoundBuffer_Play(p1, p2, p3, p4)
{
	if (p4 & DSBPLAY_LOOPING)
	{
		(D := struct(DSBCAPS)).dwSize := DSBCAPS.size()
		dllcall(IDirectSoundBuffer.GetCaps, uint, p1, uint, D[])
		printl("sndbuffersize " D.dwBufferBytes)
		if (D.dwBufferBytes > 60000)
			return 0
	}
	r := dllcall(IDirectSoundBuffer.Play, uint, p1, uint, p2, uint, p3, uint, p4)
	return r
}