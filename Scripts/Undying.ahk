;REMOTE SCRIPT START
g_.s.lck                    := D3DHOOKS_DATA.LockPrimary
g_.s.unlck                  := D3DHOOKS_DATA.UnLockPrimary
D3DHOOKS_DATA.LockPrimary   := IDirectDrawSurface7.Lock
D3DHOOKS_DATA.UnLockPrimary := IDirectDrawSurface7.UnLock

Alt_SetDisplayMode(p1, p2, p3, p4, p5, p6)
{
	D3DHOOKS_DATA.LockPrimary   := g_.s.lck 
    D3DHOOKS_DATA.UnLockPrimary := g_.s.unlck  
	return IDirectDraw7_SetDisplayMode(p1, p2, p3, p4, p5, p6)
}

