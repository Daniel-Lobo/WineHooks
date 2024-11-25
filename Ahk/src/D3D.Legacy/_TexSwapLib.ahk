global g_tswap := {}

TSwapInit(byref cfg)
{
	InitTextSwapcfg(cfg)	
	logErr(IDirect3DTexture2.hook("Release"))
	logErr(IDirect3DTexture2.hook("Load"))
	logErr(IDirect3DDevice3.dllhook("SetTexture", "SetTexture3Hook"))
	logErr(IDirectDrawSurface4.hook("Release"))
	D3DHOOKS_DATA.IDirect3DDevice3_SetTexture := IDirect3DDevice3.SetTexture 
	g_tswap.TQueryIface                       := IDirect3DTexture2.QueryInterface
	g_tswap.A8Fix                             := ""	
			
	if ! (g_.cfg.HD or g_.cfg.32bit)
	{
		logerr(IDirectDrawSurface4.dllHook("Lock", "LockSurfaceHook"))
		logerr(IDirectDrawSurface.dllHook("UnLock", "UnLockHook"))
		logerr(IDirectDrawSurface4.dllHook("UnLock", "UnLockSurface4Hook"))	
					
		D3DHOOKS_DATA.LockPrimary     := IDirectDrawSurface4.Lock
		D3DHOOKS_DATA.UnLockPrimary   := IDirectDrawSurface.UnLock
		D3DHOOKS_DATA.UnLockPrimary4  := IDirectDrawSurface4.UnLock
		IDirectDrawSurface.Lock       := IDirectDrawSurface4.Lock
		
		logerr(IDirectDrawSurface4.dllHook("Blt", "SurfaceBltHook"))
		D3DHOOKS_DATA.BltPrimary      := IDirectDrawSurface4.Blt
		IDirectDrawSurface.blt        := IDirectDrawSurface4.blt
		
		logerr(IDirectDrawSurface.dllHook("QueryInterface", "SrfcQueryHook"))
		D3DHOOKS_DATA.QueryPrimary := IDirectDrawSurface.QueryInterface
		D3DHOOKS_DATA.QuerySurface := IDirectDrawSurface.QueryInterface
		D3DHOOKS_DATA.QueryDevice  := RegisterCallback("Dvc1Query", "F")
		IDirectDrawSurface4.QueryInterface := IDirectDrawSurface.QueryInterface	
	} 
	D3DHOOKS_DATA.LockSurface                  := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "Lock4Hook")
	D3DHOOKS_DATA.UnLockSurface4               := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "UnLock4Hook")	
	
	D3DHOOKS_DATA.UnLockSurface                    := IDirectDrawSurface.Unlock	
	D3DHOOKS_DATA.BltSurface                       := RegisterCallback("TexSwapBlt", "F")
	D3DHOOKS_DATA.QueryTexture                     := RegisterCallback("IDirectDrawSurface4_QueryInterface")	
	D3DHOOKS_DATA.SwapBack                         := RegisterCallback("SwapBack", "F")			
	D3DHOOKS_DATA.Surface_Found                    := RegisterCallback("SurfaceFound", "F")
	D3DHOOKS_DATA.IDirect3DTexture2_QueryInterface := IDirect3DTexture2.QueryInterface
	D3DHOOKS_DATA.Samples                          := g_tswap.s
	D3DHOOKS_DATA.Lock                             := IDirectDrawSurface4.Lock
	D3DHOOKS_DATA.UnLock                           := IDirectDrawSurface4.UnLock
	D3DHOOKS_DATA.GetDDSCaps                       := IDirectDrawSurface.GetCaps	

	logErr(IDirect3DTexture2.hook("GetHandle"))
	logErr(IDirect3DDevice2.dllhook("SetRenderState", "SetRenderState2Hook"))
	g_tswap.swap := IDirect3DDevice2.SwapTextureHandles
	g_tswap.load := func("LoadTexture2")
	g_tswap.TQueryIface := IDirect3DTexture2.QueryInterface
	
	D3DHOOKS_DATA.IDirect3DDevice2_SetRenderState    := IDirect3DDevice2.SetRenderState	
	D3DHOOKS_DATA.IDirectDrawSurface_QueryInterface  := IDirectDrawSurface.QueryInterface
	D3DHOOKS_DATA.IDirect3DTexture2_QueryInterface   := IDirect3DTexture2.QueryInterface
	D3DHOOKS_DATA.IDirect3DTexture_QueryInterface    := IDirect3DTexture.QueryInterface
	
	logErr(IDirect3DTexture.hook("Load"))
	logErr(IDirect3DTexture.hook("GetHandle"))
	logErr(IDirect3DTexture.hook("Release"))
	if g_.cfg.HD
	{
		f := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "IDirect3DDevice_ExecuteHook")
		h := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "TsExecute")
		AltInstallHook(h, (t := f))
		D3DHOOKS_DATA.TsExecute := t
	} else {
		logerr(IDirect3DDevice.DllHook("Execute", "TsExecute"))
		D3DHOOKS_DATA.TsExecute := IDirect3DDevice.Execute	
	}    
}

InitTextSwapHooks7(byref cfg)
{
	InitTextSwapcfg(cfg)
	logErr(IDirectDrawSurface7.hook("Release"))
	logerr(IDirect3DDevice7.Hook("Load"))	
	logErr(IDirect3DDevice7.dllhook("SetTexture", (g_tswap.A8Fix) ? "AltSetTexture7Hook" : "SetTexture7Hook"))	
	g_tswap.A8Fix := ""		
	
	if ! (g_.cfg.HD or g_.cfg.32bit)
	{
		logErr(IDirectDrawSurface7.dllhook("Lock", "Lock4Hook"))
		logErr(IDirectDrawSurface7.dllhook("Unlock", "UnLock4Hook"))
		logerr(IDirectDrawSurface7.Hook("Blt", "TxSwapBlt7"))
	} else {
		D3DHOOKS_DATA.LockSurface    := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "Lock4Hook")
		D3DHOOKS_DATA.UnLockSurface4 := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "UnLock4Hook")
		D3DHOOKS_DATA.BltSurface     := RegisterCallback("TxSwapBlt7", "F")
	}
	
	D3DHOOKS_DATA.IDirect3DDevice7_SetTexture        := IDirect3DDevice7.SetTexture 
	D3DHOOKS_DATA.Surface_Found                      := RegisterCallback("Surface7Found", "F")
	D3DHOOKS_DATA.IDirectDrawSurface_QueryInterface  := IDirectDrawSurface7.QueryInterface	
	D3DHOOKS_DATA.Samples                            := g_tswap.s
	D3DHOOKS_DATA.GetDDSCaps                         := IDirectDrawSurface7.GetCaps
	D3DHOOKS_DATA.Lock                               := IDirectDrawSurface7.Lock
	D3DHOOKS_DATA.UnLock                             := IDirectDrawSurface7.UnLock	
}

InitTextSwapcfg(byref cfg)
{
	static iid, iid7, iidu
	g_tswap        := parsecfg(cfg)
	if not g_tswap.path
		return
	g_tswap.path := g_.cfg.path g_tswap.path
    if (g_.cfg.common_path)
        g_tswap.path := g_.cfg.Mydocs "\Games\Peixoto\Textures" 
	for k, v in ["Dumps", "Replacements"] 
	{
		if not fileexist(g_tswap.path "\" v) 
		{
			path := g_tswap.path
			FileCreateDir, %path%\%v%
		}
	}
	(g_tswap.a)    ? D3DHOOKS_DATA.DmpAndAppend := RegisterCallback(g_.cfg.d3d=7 ? "DumpAndAppend7" : "DumpAndAppend", "F") 	
	(g_tswap.dly)  ? g_tswap.dly                := []	
    (g_tswap.v)    ? D3DHOOKS_DATA.vid_check    := 1	
	GUID_FromString(iid, ddraw.IID_IDirectDrawSurface)
	GUID_FromString(iid7, ddraw.IID_IDirectDrawSurface7)
	GUID_FromString(iidu, "{00000000-0000-0000-C000-000000000046}")
	g_tswap.idd_surface   := &iid	
	g_tswap.iid_u         := &iidu
	g_tswap.iid7          := &iid7	
	g_tswap.FindTexture   := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "FindTextureInCollection")		
	g_tswap.dsc           := struct(ddSurfaceDesc2)	
	g_tswap.RECT          := struct(RECT)
	g_tswap.RECT.top      := 0		
	g_tswap.RECT.bottom   := g_tswap.sz	
	g_tswap.GetTextureID  := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GetTextureID")	
	g_tswap.GetTexture2ID := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GetTexture2ID")	
	g_tswap.GetSurface4ID := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GetSurface4ID")
	g_tswap.GetSurfaceID  := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "GetSurfaceID")	
	;g_tswap.lock          := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "_LockHook")
	g_tswap.Unlock        := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "UnLockHook")
	;g_tswap.lock4         := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "_Lock4Hook")
	g_tswap.Unlock4       := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "UnLock4Hook")
	g_tswap.lock          := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "Lock_Hook")	
	g_tswap.lock4         := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "Lock4_Hook")
	g_tswap.f             := struct("Float[4]")
	g_tswap.xBRr          := struct("UINT x, y, w, h;")
	
	g_tswap.master       := new Collection()
	g_tswap.textures     := new Collection()
	g_tswap.found        := new Collection()	
	g_tswap.replacements := new Collection()
	g_tswap.hTex         := new Collection()
	D3DHOOKS_DATA.textures     := g_tswap.textures.pc
	D3DHOOKS_DATA.found        := g_tswap.found.pc
	D3DHOOKS_DATA.replacements := g_tswap.replacements.pc
	D3DHOOKS_DATA.hTex         := g_tswap.hTex.pc	
			
	dllcall("peixoto.dll\SetSampleCount", uint, g_tswap.s)
	if fileexist((comp := g_tswap.path "\Dumps\dump._dds"))
		LoadCompiledDumpCollection(comp, lst := [])
	else LoadDumpCollection(g_tswap.path "\Dumps", lst := [])		
	g_tswap.dumps := []	
}

TextSwapCheck(byref i, byref s)
{
	static index        := 0
	g_tswap.RECT.left   := D3DHOOKS_DATA.HD_X
	g_tswap.RECT.right  := g_tswap.sz+D3DHOOKS_DATA.HD_X
		
	_func := getkeystate(g_tswap.q) ? "getkeystate" : "keyevent"
	%_func%(g_tswap.n) ? index += 1 : %_func%(g_tswap.p) ? index -= 1
		
	(index >= g_tswap.textures.Count()) ? index := 0 
	: (index < 0 ) ? index := g_tswap.textures.Count()-1
	i := index
	
	s .= " Texture " index+1 "/"  g_tswap.textures.size " master: " g_tswap.master.size "`n" 
	s .= "ID : " dllcall(g_tswap.GetTexture2ID, uint, g_tswap.textures.ValueAt(index)) "`n" 
	s .= g_tswap.hTex.size " handles`n"
	s .= g_tswap.replacements.size " replacements`n"
	s .= g_tswap.found.count() " matches`n"
	
	if keyevent(g_tswap.d)
	return 1
}

DscrdTx(t, i)
{
	g_tswap.replacements.Discard(t)
	g_tswap.textures.discard(i)	
	g_tswap.found.remove(i)
	g_tswap.hTex.discard(t)
}

TxtCk(t)
{
	if dllcall(g_tswap.TQueryIface, uint, t, uint, g_tswap.idd_surface, "uint*", surf:=0)
	return
	VarSetCapacity(ck, 8, 0)
	if dllcall(IDirectDrawSurface.GetColorKey, uint, surf, uint, DDCKEY_SRCBLT, "uint", &ck)
	return
	(Dsc := struct(DDSURFACEDESC)).dwSize  :=  DDSURFACEDESC.size()	
	dllcall(IDirectDrawSurface.GetSurfaceDesc, uint, surf, uint, Dsc[])	
	_ck := {"k" : &ck, "f" : GetPixelFormat(Dsc)}
	dllcall(IDirectDrawSurface.Release, uint, surf)
	return _ck		
}


/* ========================================================================
 * ========================================================================
 */
 
TSwapDvc1_2Created()
{
	/* Not unhooking this is a possible source of trouble since the 
	 * IDirectDrawSurface4::QueryInterface hook calls swap and at 
	 * that point there is a g_.Device2 but IDirect3DTexture::GetHandle
	 * was not called yet. This hook remains to add entries to the 
	 * master collection, but that can be made in the
	 * IDirect3DTexture::GetHandle hook - note: Turok 1 and 2 need
	 * the hook on IDirectDrawSurface4::QueryInterface, or there won't
	 * be no textures in the collection
	 */
	;D3DHOOKS_DATA.QueryTexture    := IDirectDrawSurface4.QueryInterface
	
	D3DHOOKS_DATA.Lock            := IDirectDrawSurface.Lock
	D3DHOOKS_DATA.UnLock          := IDirectDrawSurface.UnLock
	D3DHOOKS_DATA.UnLockSurface4  := IDirectDrawSurface4.Unlock		
	if (g_tswap.v)
	{	
		D3DHOOKS_DATA.LockSurface     := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "LockHook")
		D3DHOOKS_DATA.UnLockSurface   := dllcall("GetProcAddress", ptr, g_.h_PeixotoDll, astr, "UnLockHook") 
	}
	if (g_.Device2)
	{
		g_tswap.swap := IDirect3DDevice2.SwapTextureHandles
		g_tswap.load := func("LoadTexture2")
		g_tswap.TQueryIface := IDirect3DTexture2.QueryInterface
	} else {
		g_tswap.swap                  := IDirect3DDevice.SwapTextureHandles
		g_tswap.load                  := func("LoadTexture")
		g_tswap.TQueryIface           := IDirect3DTexture.QueryInterface
	}	
}

IsMip(cps)
{
	return dllcall("peixoto.dll\GetDDSurfaceLevel", ptr, tx)
}

DumpAndAppend(SS, tx)
{
	if dllcall("peixoto.dll\GetDDSurfaceLevel", ptr, tx)
	return		
	
	D        := struct(DDSURFACEDESC2)
	D.dwSize := DDSURFACEDESC.size()
	r        := dllcall(IDirectDrawSurface.GetSurfaceDesc, uint, SS, ptr, D[])
	fmt      := GetPixelFormat(D)
	
	n := 0
	file := "dump" n ".dds"
	while (fileexist(g_tswap.path "\dumps\" file) or IsDump(g_tswap.dumps, file))
	{
		n += 1
		file := "dump" n ".dds"
	}
	dumpSurface(SS, g_tswap.path "\dumps\" file)	
	dllcall("peixoto.dll\AppendDump", astr, g_tswap.path "\dumps\" file)
}

Swap(pTex, index)
{
	d    := (g_.Device) ? g_.Device : g_.Device2
	surf := 0 
	_ck  := TxtCk(pTex)
	if fileexist(index)
	{
		if (rep := g_tswap.load.(dllcall(g_.p.DDFrmTx, uint, pTex), d, index, _ck))
		{
			d ? logerr("Swapedd " dllcall(g_tswap.swap, uint, d, uint, rep, uint, pTex, uint))
			g_tswap.replacements._add(pTex, rep)
		} 		
	} else if fileexist(f:=g_.cfg.MyDocs "\Games\checkerboard.dds")
	{
		if (rep := g_tswap.load.(dllcall(g_.p.DDFrmTx, uint, pTex), d, f, _ck))
		{
			d ? logerr("Swapedd " dllcall(g_tswap.swap, uint, d, uint, rep, uint, pTex, uint))
			g_tswap.replacements._add(pTex, rep)
		} 		
	}
}

SwapBack(_id)
{
	g_tswap.found.remove(_id)
	tex     := g_tswap.textures.value(_id)
	if (rep := g_tswap.replacements.value(tex))
	{
		g_tswap.replacements.Discard(tex)
		d := (g_.Device) ? g_.Device : g_.Device2
		d ? logerr("Swaped back " dllcall(g_tswap.swap, uint, d, uint, rep, uint, Tex))
		(g_.Device) ? dllcall(IDirect3DTexture.Release, uint, rep) : dllcall(IDirect3DTexture2.Release, uint, rep)
	}
}

SurfaceFound(p1, p2)
{
	if (tex := g_tswap.textures.value(p1)) 
	{
		logerr("Surf found and text known")		
		Swap(tex, strget(p2+0, "CP0"))
	} else logerr("Surf found")			
	g_tswap.found.putstr(p1, strget(p2+0, "CP0"))  
} 
 
TexSwapCheck(sS, sID="", dID="", ck="")
{
	Swapback(dID)  ; fixes TR3, probably causes no trouble as the dest textures is being modified anyway			
	;if (g_.Device3) 
	;return AltTexSwapCheck4(SS, sID, dID, ck)	; Breaks dino crisis	
	if (sys := GetSurfaceCaps(SS) & DDSCAPS_SYSTEMMEMORY)
	{
		g_tswap.ck         := ck
		g_tswap.dsc.dwSize := DDSURFACEDESC.size()	
		dllcall(g_tswap.lock, uint, SS, uint, 0, uint, g_tswap.dsc[], uint, 0, uint, 0)
		dllcall(g_tswap.Unlock, uint, SS, uint, 0)		
	}
	if (dump := g_tswap.found.getstr(sID))
	{			
		if (t := g_tswap.textures.value(dID))
		{
			Swap(t, dump)				
			Logerr("Swapped " ck " ID: " dID)
		} 	
		else 
		{
			logerr("found " ck " ID: " dID)				
		}
		g_tswap.found.putstr(dID, dump) 	
	} else if (g_tswap.a) 
		DumpAndAppend(SS, dID)			
	
	g_tswap.found.remove(sID)	
	g_tswap.ck := ""
	return sys	
}

AltTexSwapCheck4(SS, sID="", dID="", ck="")
{
	cps := GetSurfaceCaps4(SS)	
	if (sys := cps & DDSCAPS_SYSTEMMEMORY)
	{
		g_tswap.ck         := ck
		g_tswap.dsc.dwSize := DDSURFACEDESC2.size()
		dllcall(g_tswap.lock4, uint, SS, uint, 0, uint, g_tswap.dsc[], uint, 0, uint, 0)
		dllcall(g_tswap.Unlock4, uint, SS, uint, 0)		
	}
	if (dump :=  g_tswap.found.getstr(sID))
	{	
		if (t := g_tswap.textures.value(dID))
		{
			Logerr("Swapped " ck " ID: " dID)			
			Swap(t, dump) 			
		}
		else 
		{
			logerr("found " ck " ID: " dID)		
		}			
		g_tswap.found.putstr(dID, dump) 	
	} else if (g_tswap.a)
		DumpAndAppend(SS, dID)	
		
	g_tswap.found.remove(sID)
	g_tswap.ck := ""
	return sys
}
  
IDirect3DTexture_GetHandle(p1, p2, p3)
{
	if ! (r := dllcall(IDirect3DTexture.GetHandle, uint, p1, uint, p2, uint, p3, uint))
	{
		if (_id := dllcall(g_tswap.GetTextureID, uint, p1))
		{	
			if (dump := g_tswap.found.getstr(_id)) 
			{
				Swap(p1, dump) 					
			} 
			/* If these collections are updated before the swap, replacements are 
			 * never released on Resident evil 1
			 */
			g_tswap.textures._add(_id, p1) 	
			g_tswap.hTex._add(p1, numget(p3+0, "prt"))		
		}				
	} return r
}

IDirect3DTexture2_GetHandle(p1, p2, p3)
{
	if ! (r := dllcall(IDirect3DTexture2.GetHandle, uint, p1, uint, p2, uint, p3, uint))
	{
		if (_id := dllcall(g_tswap.GetTexture2ID, uint, p1))
		{
			if (dump := g_tswap.found.getstr(_id)) 
			{
				Logerr("GetHandle swap, id:	" _id)						
				Swap(p1, dump) 		
			} 
			g_tswap.textures._add(_id, p1)
			g_tswap.hTex._add(p1, numget(p3+0, "ptr"))	
		}				
	} return r
} 

IDirectDrawSurface4_QueryInterface(p1, p2, p3)
{
	if (r := dllcall(IDirectDrawSurface4.QueryInterface, uint, p1, uint, p2, uint, p3))
	return r
	/* Fixes textures and master collections ever growing in TR3. Breaks TR4 (thus the g_.Device2 check)
	 * other D3D2 games not checked
	 */
	if (g_.Device2 && (GetSurfaceCaps4(p1) & DDSCAPS_SYSTEMMEMORY)) 
	return r	
   
	if (StringFromIID(p2) = d3d.IID_IDirect3DTexture2)
	{
		if (_id := dllcall(g_tswap.GetTexture2ID, uint, (tex:=numget(p3+0, "ptr"))))
		{
			if (dump := g_tswap.found.getstr(_id)) 
			{
				; No handle yet on Direct3D2, trouble?				
				Swap(tex, dump)
			}
			g_tswap.textures._add(_id, tex) ;Breaks TR3
			g_tswap.master._add(tex, _id)
			g_tswap.master._add(_id, _id)
		}
	}
	return r	
}
 
IDirect3DTexture_Load(p1, p2)
{
	if ! (r := dllcall(IDirect3DTexture.Load, uint, p1, uint, p2))
	{		
		dllcall(IDirect3DTexture.QueryInterface, uint, p2, uint, g_tswap.idd_surface, "uint*", surf := 0)
		? : dllcall(IDirectDrawSurface.release, uint, Surf)		
		sID := dllcall(g_tswap.GetTextureID, uint, p2)
		dID := dllcall(g_tswap.GetTextureID, uint, p1)
		SwapBack(dID)	
		TexSwapCheck(surf, sID, dID, "Load")		
	}		
} 

IDirect3DTexture2_Load(p1, p2)
{
	if ! (r := dllcall(IDirect3DTexture2.Load, uint, p1, uint, p2))
	{		
		dllcall(IDirect3DTexture2.QueryInterface, uint, p2, uint, g_tswap.idd_surface, "uint*", surf := 0)
		? : dllcall(IDirectDrawSurface.release, uint, Surf)		
		sID := dllcall(g_tswap.GetTexture2ID, uint, p2)
		dID := dllcall(g_tswap.GetTexture2ID, uint, p1)
		SwapBack(dID)	
		TexSwapCheck(surf, sID, dID, "Load")		
	}		
}

TexSwapBlt(p1, p2, p3, p4, p5, p6)
{
	if (r := dllcall(IDirectDrawSurface.blt, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint))
	return r	
	
	SwapBack(dstID := dllcall(g_tswap.GetSurfaceID, uint, p1))
	
	if !p2 and !p4
	TexSwapCheck(p3, dllcall(g_tswap.GetSurfaceID, uint, p3), dstID, "Blit")	
	return r	
} 

LooseTexture(_id)
{
	if (g_tswap.master.key(_id))
	return
	t := g_tswap.textures.value(_id)	
	r := g_tswap.replacements.value(t)
	r ? logerr("Release rep " dllcall(numget(numget(r+0, "ptr")+8, "ptr"), uint, r))
	g_tswap.replacements.Discard(t)
	g_tswap.textures.discard(_id)	
	g_tswap.found.remove(_id)
	g_tswap.hTex.discard(t)
}

IDirect3DTexture_Release(p1)
{	
	if (isobject(g_tswap.dly))
	{
		dllcall(IDirect3DTexture.addref, uint, p1)
		g_tswap.dly.push(p1)
	}		
	
	dllcall(IDirect3DTexture.QueryInterface, uint, p1, uint, g_tswap.idd_surface, "uint*", s := 0)
	? : dllcall(IDirectDrawSurface4.release, uint, s)  
	
	if (GetSurfaceCaps4(s) & DDSCAPS_PRIMARYSURFACE)
	return dllcall(IDirect3DTexture.release, uint, p1)	
	
	dllcall(IDirectDrawSurface4.QueryInterface, uint, s, uint, g_tswap.iid_u, "uint*", i := 0)
	? : dllcall(IDirectDrawSurface4.release, uint, i)
	
	r := dllcall(IDirect3DTexture.release, uint, p1)
	;Uselles at the time, since IDirect3DTexture pointers are not in the master collection
	g_tswap.master.discard(p1) 
	LooseTexture(i)		
	return r
}

IDirect3DTexture2_Release(p1)
{
	dllcall(IDirect3DTexture2.QueryInterface, uint, p1, uint, g_tswap.idd_surface, "uint*", s := 0)
	? : dllcall(IDirectDrawSurface4.release, uint, s)  
	
	if (GetSurfaceCaps4(s) & DDSCAPS_PRIMARYSURFACE)
	return dllcall(IDirect3DTexture2.release, uint, p1)
	
	dllcall(IDirectDrawSurface4.QueryInterface, uint, s, uint, g_tswap.iid_u, "uint*", i := 0)
	? : dllcall(IDirectDrawSurface4.release, uint, i)
	
	r := dllcall(IDirect3DTexture2.release, uint, p1)
	g_tswap.master.discard(p1)
	LooseTexture(i)			
	return r
}

IDirectDrawSurface4_Release(s)
{		
	if (GetSurfaceCaps4(s) & DDSCAPS_PRIMARYSURFACE)
	return dllcall(IDirectDrawSurface4.release, uint, s)	
	
	dllcall(IDirectDrawSurface4.QueryInterface, uint, s, uint, g_tswap.iid_u, "uint*", i := 0)
	? : dllcall(IDirectDrawSurface4.release, uint, i)
			
	r := dllcall(IDirectDrawSurface4.release, uint, s)
	if (r = 0)
	{
		g_tswap.master.discard(i)
		LooseTexture(i)		
	}
	return r		
}

BrowseTextures(pBackbuffer, clr = 0x00000000)
{
	pSurface := 0
	str      := "Direct3D1 "
	if TextSwapCheck(index, str)
	{
		n    := 0
		file := "dump" n ".dds"
		while (fileexist(g_tswap.path "\dumps\" file) or IsDump(g_tswap.dumps, file))
		{
			n    += 1
			file := "dump" n ".dds"
		}
		dllcall(IDirect3DTexture.QueryInterface, uint, g_tswap.textures.ValueAt(index), uint, g_tswap.idd_surface, "uint*", pSurface, uint)
		dumpSurface(pSurface, g_tswap.path "\dumps\" file)		
		soundplay, *64
	}
	D3DHOOKS_DATA.curent_texture := g_tswap.hTex.Value(g_tswap.textures.ValueAt(index))
	pSurface ?: dllcall(IDirect3DTexture.QueryInterface, uint, g_tswap.textures.ValueAt(index), uint, g_tswap.idd_surface, "uint*", pSurface, uint)	
			
	blt := dllcall(IDirectDrawSurface.Blt, uint, pBackbuffer, uint, g_tswap.RECT[]
	                                     , uint, pSurface, uint, 0, uint, 0, uint, 0, uint)	
	
	pSurface ? dllcall(IDirectDrawSurface.release, uint, pSurface)    
	writeOnSurface(pBackbuffer, str, clr, D3DHOOKS_DATA.HD_X, g_tswap.sz) 
} 

BrowseTextures2(pBackbuffer, clr = 0x00000000)
{
	pSurface := 0
	str      := "Direct3D2 "
	if TextSwapCheck(index, str)
	{
		n    := 0
		file := "dump" n ".dds"
		while (fileexist(g_tswap.path "\dumps\" file) or IsDump(g_tswap.dumps, file))
		{
			n    += 1
			file := "dump" n ".dds"
		}
		dllcall(IDirect3DTexture2.QueryInterface, uint, g_tswap.textures.ValueAt(index), uint, g_tswap.idd_surface, "uint*", pSurface, uint)
		dumpSurface(pSurface, g_tswap.path "\dumps\" file)		
		soundplay, *64
	}
	D3DHOOKS_DATA.curent_texture := g_tswap.hTex.Value(g_tswap.textures.ValueAt(index))
	pSurface ?: dllcall(IDirect3DTexture2.QueryInterface, uint, g_tswap.textures.ValueAt(index), uint, g_tswap.idd_surface, "uint*", pSurface, uint)	
			
	blt := dllcall(IDirectDrawSurface.Blt, uint, pBackbuffer, uint, g_tswap.RECT[]
	                                     , uint, pSurface, uint, 0, uint, 0, uint, 0, uint)		
	pSurface ? dllcall(IDirectDrawSurface.release, uint, pSurface)	   
	writeOnSurface(pBackbuffer, str, clr, D3DHOOKS_DATA.HD_X, g_tswap.sz) 
}

BrowseDevice3Textures2(pBackbuffer, clr = 0x00FFFFFF)
{
	pSurface := 0
	str      := "Direct3D3: "
	if TextSwapCheck(index, str)
	{
		n    := 0
		file := "dump" n ".dds"
		while (fileexist(g_tswap.path "\dumps\" file) or IsDump(g_tswap.dumps, file))
		{
			n    += 1
			file := "dump" n ".dds"
		}
		dllcall(IDirect3DTexture2.QueryInterface, uint, g_tswap.textures.ValueAt(index), uint, g_tswap.idd_surface, "uint*", pSurface, uint)	
		dumpSurface(pSurface, g_tswap.path "\dumps\" file)	
		dllcall(IDirectDrawSurface.release, uint, pSurface)		
		soundplay, *64
	}
	D3DHOOKS_DATA.curent_texture := g_tswap.textures.ValueAt(index)
    str                          .= GetSfc4MemType(D3DHOOKS_DATA.curent_texture)    
	DEVICE3_RECT.Texture         := D3DHOOKS_DATA.curent_texture
	DEVICE3_RECT.Device3         := g_.Device3 
	D3DHOOKS_DATA.ignore_release := True
	dllcall(g_.Dev3_DrawRect, uint, DEVICE3_RECT[], uint, g_tswap.RECT[], float, 0, uint)
	D3DHOOKS_DATA.ignore_release := False
	writeOnSurface(pBackbuffer, str, clr, D3DHOOKS_DATA.HD_X, g_tswap.sz)
	return
}


/* ========================================================================
 * ============================ Direct3D 7 ================================
 */

BrowseTextures7(pBB, clr = 0x00000000)
{
	if TextSwapCheck(index, str := "Direct3D7: ")
	{
		n := 0
		file := "dump" n ".dds"
		while (fileexist(g_tswap.path "\dumps\" file)or IsDump(g_tswap.dumps, file))
		{
			n += 1
			file := "dump" n ".dds"
		}
		dllcall(IDirectDrawSurface7.QueryInterface, uint, g_tswap.textures.KeyAt(index), uint, g_tswap.idd_surface, "uint*", pS, uint)	
		dumpSurface(pS, g_tswap.path "\dumps\" file)	
		dllcall(IDirectDrawSurface.release, uint, pS)		
		soundplay, *64
	}
	
	s                            := g_tswap.textures.KeyAt(index)
	D3DHOOKS_DATA.curent_texture := s
	m   := S7Mem(s)
	str .= strsplit("`nSystem memory-`nManaged-`nVideo Memory", "-")[m+1] " " GetSrfcPxFmt7(s)	
	WriteOnSurface(pBB, str m, clr, 0, g_tswap.sz)
	if (m=1)
	{
		DEVICE3_RECT.Texture         := s
		DEVICE3_RECT.Device3         := g_.Dev7
		D3DHOOKS_DATA.ignore_release := True
		dllcall(g_.Dev7_DrawRect, uint, DEVICE3_RECT[], uint, g_tswap.RECT[], float, 0, uint)
		D3DHOOKS_DATA.ignore_release := False	
	}	
	else dllcall(IDirectDrawSurface7.blt, uint, pBB, uint, g_tswap.RECT[], uint, s, uint, 0, uint, 0, uint, 0)	
}

SwapBack7(s)
{
	g_tswap.found.remove(s)
	if (r := g_tswap.replacements.Value(s))
	{
		g_tswap.replacements.discard(s)
		logerr("Release : " dllcall(IDirectDrawSurface7.Release, uint, r))
	}
}

Swap7(s, i)
{
	logerr("add " s)
	g_tswap.found.putstr(s, i)
	if ! S7Mem(s)
	return 
	if ! (f := g_tswap.found.getstr(s))
	return 
	if ! fileexist(f)
	f := g_.cfg.MyDocs "\Games\checkerboard.dds"
	if ! (r := LoadSurface7(f, s))
	return 
	g_tswap.replacements._add(s, r)
	g_tswap.textures.discard(r)	
}

DumpAndAppend7(s7, dummy)
{
	if !g_tswap.textures.value(s7)
	return
	
	D        := struct(DDSURFACEDESC2)
	D.dwSize := DDSURFACEDESC2.size()
	r        := dllcall(IDirectDrawSurface7.GetSurfaceDesc, uint, s7, ptr, D[])
	fmt      := GetPixelFormat(D)
	
	n := 0
	file := "dump" n ".dds"
	while (fileexist(g_tswap.path "\dumps\" file) or IsDump(g_tswap.dumps, file))
	{
		n += 1
		file := "dump" n ".dds"
	}
	dllcall(IDirectDrawSurface7.QueryInterface, uint, s7, uint, g_tswap.idd_surface, "uint*", pS:=0, uint)	
	dumpSurface(pS, g_tswap.path "\dumps\" file)	
	dllcall("peixoto.dll\AppendDump", astr, g_tswap.path "\dumps\" file)
	dllcall(IDirectDrawSurface.release, uint, pS)	
}

Ts7Check(dst, src)
{
	if S7Mem(src)
	return
	
	if (!g_tswap.textures.value(dst))
	return	
	g_tswap.dsc.dwSize := DDSURFACEDESC2.size()
	dllcall(g_tswap.lock4, uint, src, uint, 0, uint, g_tswap.dsc[], uint, 0, uint, 0)
	dllcall(g_tswap.Unlock4, uint, src, uint, 0)
	if (dump := g_tswap.found.getstr(src))
	{
		logerr("Swap")		
		Swap7(dst, dump)	
	} else if (g_tswap.a) 
		DumpAndAppend7(src, false)	
}

TxSwapBlt7(p1, p2, p3, p4, p5, p6)
{
	if (r := dllcall(IDirectDrawSurface7.blt, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint))
	return r
	SwapBack7(p1)
	if ! (p2 || p4) && p3
	Ts7Check(p1, p3)	
}

IDirect3DDevice7_load(p1, p2, p3, p4, p5, p6)
{
	if (r := dllcall(IDirect3DDevice7.load, uint, p1, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6))
	return r
	SwapBack7(p2)
	if ! (p3 || p5) && p4
	Ts7Check(p2, p4)		
}

IDirectDrawSurface7_Release(s)
{
	if (r := dllcall(IDirectDrawSurface7.Release, uint, s))
	return r
	g_tswap.textures.discard(s)	
	SwapBack7(s)
	return r	
}

Surface7Found(_id, index)
{
	if dllcall(IDirectDrawSurface7.QueryInterface, uint, _id, uint, g_tswap.iid7, "uint*", s7 := 0)
	return
	dllcall(IDirectDrawSurface7.release, uint, s7)	
	Swap7(s7, strget(index+0, "CP0"))		
}