#persistent
#include lib\memlib.ahk

goto continuescript
silent0:
silent1:
silent2:
silent3:
silent4:
silent5:
silent6:
silent7:
silent8:
silent9:
return

Kbrd:
	for k, v in g_k2k.ks
	{
		if ( (evnt := keyevent(v.k)) = 1 )
		{
			;msgbox yes
			v.o._yes()
		}
		else if (evnt = -1)
		{
			;msgbox no  %evnt%
			v.o._No()
		}
		else v.o._maybe()
	}
return	

GPad:
    events := XinputGetEvent(1, J2K.dz)
    if not events
		return
	if (J2K.m)
	{
		if (events[J2K.m] > 0) 
		J2K._A := J2K.X
		if (events[J2K.m] < 0)
		J2K._A := J2K.A
	}
	for k, v in J2K._A
	{
		if events[k] > 0
		v._yes()
		else if events[k] < 0
		v._no()
		else v._maybe()
	}
	(J2K.rs=2 && J2K.spd) ? XinputSetMousePos(J2K.dz, J2K.spd)
	if g_k2k.ks.Length()
	goto Kbrd
return

GPadB:
    events := XinputGetEvent(1, J2K.dz)
    if not events
		return		
	if (J2K.m)
	{
		if (events[J2K.m] > 0)
		{			
			J2K._A  := J2K.X
			J2K._B  := J2K.Y
			for k, v in J2K._A
			{
				J2K._A[k].s := J2K.A[k].s
				J2K._B[k].s := J2K.B[k].s
			}
		}
		if (events[J2K.m] < 0)
		{
			J2K._B  := J2K.B
			J2K._A  := J2K.A
			for k, v in J2K._A
			{
				J2K._A[k].s := J2K.X[k].s
				J2K._B[k].s := J2K.Y[k].s
			}
		}
	}
	for k, v in J2K._A
	{
		u := J2K._B[k]
		if (events[k] > 0)
		{
			v._yes()
			u._yes()
		}else  if (events[k] < 0) 
		{
			v._no()
			u._no()
		}else 
		{
			v._maybe()
			u._maybe()
		}
	}
	(J2K.rs=2 && J2K.spd) ? XinputSetMousePos(J2K.dz, J2K.spd)
	if g_k2k.ks.Length()
	goto Kbrd
return

Desk()
{
	r := strsplit(g_.DSR ? g_.DSR : g_.dsk, "x")
	return {"w" : r[1], "h" : r[2]}	
}

GetDesktopResolution()
{
	r := {"w" : dllcall("GetSystemMetrics", uint,0) , "h" : dllcall("GetSystemMetrics", uint,1)}
	res := res.w "x" res.h 
	if instr(g_.resolutions_list, res) 
		return r			 
	
	;lRect := struct("LONG left; LONG top; LONG right; LONG bottom;")
	hDesktop := dllcall("User32.dll\GetDesktopWindow", uint)
    dllcall("GetWindowRect", uint, hDesktop, uint, lRect[])  
	r := {"w" : lRect.right, "h" : lrect.bottom}
	dllcall("ReleaseDC", uint, 0, uint, hDesktop)
	return r	
}

FOV(oldfov, ratio)
{
	ratio := strsplit(ratio, ":")
	oldfov *= 0.01745329252 / 2
	return 2 * (ATan(tan(oldfov) * ratio[1]/ratio[2]) * 57.29578)
}

print(msg = "")
{
	static hnd
	if not hnd
	{
		DllCall("AllocConsole")
		hnd := DllCall("GetStdHandle", "int", -11)
	}
	return dllcall("WriteConsole", "int", hnd , "ptr", &msg, "int", strlen(msg), uint, 0, ptr, 0)
}

IsExtendedKey(key)
{
	for k, v in strsplit("INS DEL HOME END PGUP PGDN up down left right", " ")
	{
		if (key = v)
		return 1
	}
}

keydown(vk, sc)
{
	dllcall("keybd_event", uchar, vk, uchar, sc, uint, 0, uint, 0)
}

keyup(vk, sc)
{
	dllcall("keybd_event", uchar, vk, uchar, sc, uint, 0x0002, uint, 0)
}

mousedown(vk, sc)
{
	dllcall("mouse_event", uint, vk, uint, 0, uint, 0, uint, 0, uint, 0)		
}

mouseup(vk, sc)
{
	dllcall("mouse_event", uint, sc, uint, 0, uint, 0, uint, 0, uint, 0)
}

continuescript:
global g_ := Parsecfg()

global g_k2k := {}
k2k          := Parsecfg(g_.k2K)

g_k2k.ks := []
for k, v in strsplit("t0 t1 r0 r1 s0 s1 s2 s3 s4 s5", " ") 
{
	if ! k2k[v . "e"]
	continue	

	snd := k2k[v . "v"]		
	o   := {}
	o.k := k2k[v . "k"]
	
	if instr(v, "t")
	{
		if instr(snd, "Button") || instr(snd, "Wheel")
		continue	
		o.o := new Toggle(k2k[v . "v"])
	} 
	else if instr(v, "r")
	{
		if instr(snd, "Wheel")
		continue
		else if instr(snd, "Button")
		o.o := new MRepeat(k2k[v . "v"])
		else 
		o.o := new Repeat(k2k[v . "v"])	
	}
	else if instr(v, "s")
	{
		if instr(snd, "Button") || instr(snd, "Wheel")
		o.o := new MSender(k2k[v . "v"])
		else 
		o.o := new Sender(k2k[v . "v"])	
	}
	g_k2k.ks.push(o)
	
	lbl  := "silent" k
	hkey := o.k
	if (hkey)
	Hotkey, % hkey, % lbl, on
}

global J2K := Parsecfg(g_.J2K)
J2K.dz += 0.0
if J2K.A and J2K.u
{
	mds    := strsplit(J2K.mds, ",")
    J2K.dz += 0.0
    if (not J2K.dz)J2K.dz := 0.25
	J2K.A  := InitKeys(J2K.A, mds)
    J2K._A := J2K.A
    J2K.X  := InitKeys(J2K.X, mds)
    if J2K.B
    {
		mds    := strsplit("00000000000000000000")
        J2K.Y  := InitKeys(J2K.Y, mds)
        J2K.B  := InitKeys(J2K.B, mds)
        J2K._B := J2K.B
        settimer, GPadB, 15
    }
    else settimer, GPad, 15
} else if g_k2k.ks.Length()
	settimer, Kbrd, 15

class Sender {
    __new(key) {
        this.k  := key
		this.vk := GetKeyVK(key)
		this.sc := GetKeySC(key)
		this.s  := 0
		this.f  := IsExtendedKey(key)
    }
	_maybe(){
		if (this.s)
		dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.f, uint, 0)	
	}
    _yes(){
		this.s := 1
        dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.f, uint, 0)		
    }
    _No() {
		this.s := 0
		if (this.f)
			dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, 0x0003, uint, 0)
		else dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, 0x0002, uint, 0)
    }
}

class Tap extends Sender {
    __new(key) {
        this.k  := key
		this.vk := GetKeyVK(key)
		this.sc := GetKeySC(key)
		this.s  := 0
		this.f  := IsExtendedKey(key)
    }
	_maybe(){
		return
	}
    _yes(){
		this.s := 1
        dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.f, uint, 0)		
    }
    _No() {
		this.s := 0
		if (this.f)
			dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, 0x0003, uint, 0)
		else dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, 0x0002, uint, 0)
    }
}

class Repeat {
    __new(key) {
        this.s  := 0
		this.t  := 0
		this.vk := GetKeyVK(key)
		this.sc := GetKeySC(key)
		this.f  := IsExtendedKey(key)
    }
	_maybe(){
		if ! (this.s)
		return
		else if (A_tickCount-this.t >= 200)
		{
			this.s *= -1
			this.t := A_tickCount
			if (this.s = -1)				
			dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.f | 0x0002, uint, 0)				
		} 
		if (this.s > 0)
		dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.f, uint, 0)				
	}
    _yes(){
		this.s := 1
		this.t := A_tickCount
		dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.f, uint, 0)		
    }
    _No() {
        this.s := 0
		if (this.f)
			dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, 0x0003, uint, 0)
		else dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, 0x0002, uint, 0)
    }
}

class Toggle {
    __new(key) {
		this.s  := -1
        this.k  := key
		this.vk := GetKeyVK(key)
		this.sc := GetKeySC(key)
		this.f  := IsExtendedKey(key)
    }
	_maybe(){
		if (this.s = 1)
		dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.f, uint, 0)	
	}
    _yes(){
		this.s *= -1
		if (this.s > 0)
			dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, this.f, uint, 0)
		else 
		{
			if (this.f)
				dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, 0x0003, uint, 0)
			else dllcall("keybd_event", uchar, this.vk, uchar, this.sc, uint, 0x0002, uint, 0)
		}
    }
    _No() {       
    }
}

class MSender {
    __new(key) {
		this.d   := 0
		this.fUp := 0
        if (key = "LButton")
		{
			this.fDn := 0x2
			this.fUp := 0x4
		} 
		else if (key = "RButton")
		{
			this.fDn := 0x8
			this.fUp := 0x10
		}
		else if (key = "MButton")
		{
			this.fDn := 0x20
			this.fUp := 0x40
		}
		else if (key = "WheelDown")
		{
			this.fDn := 0x0800
			this.d   := -120
		}
		else if (key = "Wheelup")
		{
			this.fDn := 0x0800
			this.d   := 120
		}
		this.s  := 0
    }
	_maybe(){
		if (this.s) && (this.fUp)
		dllcall("mouse_event", uint, this.fDn, uint, 0, uint, 0, uint, this.d, uint, 0)		
	}
    _yes(){
		this.s := 1
        dllcall("mouse_event", uint, this.fDn, uint, 0, uint, 0, uint, this.d, uint, 0)		
    }
    _No() {
		this.s := 0
        dllcall("mouse_event", uint, this.fUp, uint, 0, uint, 0, uint, this.d, uint, 0)	
    }
}

class MRepeat {
    __new(key) {
		this.d   := 0
		this.fUp := 0
        if (key = "LButton")
		{
			this.fDn := 0x2
			this.fUp := 0x4
		} 
		else if (key = "RButton")
		{
			this.fDn := 0x8
			this.fUp := 0x10
		}
		else if (key = "MButton")
		{
			this.fDn := 0x20
			this.fUp := 0x40
		}		
		this.s  := 0
    }
	_maybe(){
		if ! (this.s)
		return
		else if (A_tickCount-this.t >= 200)
		{
			this.s *= -1
			this.t := A_tickCount
			if (this.s = -1)				
			dllcall("mouse_event", uint, this.fUp, uint, 0, uint, 0, uint, this.d, uint, 0)					
		} 
		if (this.s > 0)
		dllcall("mouse_event", uint, this.fDn, uint, 0, uint, 0, uint, this.d, uint, 0)					
	}
    _yes(){
		this.s := 1
		this.t := A_tickCount
		dllcall("mouse_event", uint, this.fDn, uint, 0, uint, 0, uint, this.d, uint, 0)		
    }
    _No() {
        this.s := 0
		dllcall("mouse_event", uint, this.fUp, uint, 0, uint, 0, uint, this.d, uint, 0)	
    }
}
	
InitKeys(Obj, modes)
{
    str := Obj
    Obj := []
    for k, v in StrSplit(str, ",")
	{		
		if (!v)
		{
			Obj.Insert(1)
			continue
		}
		m := modes[k]	
		if instr(v, "Button") or instr(v, "Wheel")	
		{
			if (m = 2) && instr(v, "Button")
				Obj.Insert(new MRepeat(v))
			else if (m = 0)
				Obj.Insert(new MSender(v))
			else Obj.Insert(1)
		} else
		{
			if (m = 2)
				Obj.Insert(new Repeat(v))
			else if (m = 4)
				Obj.Insert(new Tap(v))
			else if (m = 1)
				Obj.Insert(new Toggle(v))
			else if (m = 0)
				Obj.Insert(new Sender(v))
			else Obj.Insert(1)
		}
	}
    return Obj
}

Parsecfg(item = "")
{
    if not item
    {
        cfg         := strsplit(A_ScriptOptions, "^")
        globals     := {}
        globals.cfg := {}
        for k, v in cfg
        {
            Key := SubStr(v, 1, 1)
            _Key := SubStr(v, 2, strlen(v)-1)
            if _Key is number
            continue
            if (Key = "-") 
			globals.cfg[SubStr(v, 2, strlen(v)-1)] := cfg[k + 1]
            else if (Key = "/") 
			globals.cfg[SubStr(v, 2, strlen(v)-1)] := True
        }
        return globals.cfg
    } else  {
        cfg := {}
        for k, v in strsplit(item, ";")
        {
            split := strsplit(v, "=")
            key := split[1]
            val := split[2]
            if not split[2]
            {
                continue
            }
            (val = "True") ? val := True
            (val = "False") ? val := False
            cfg[key] := val
        }
        return cfg
    }
}

keyevent(key)
{
	static state := {}
	if ! state[key]
	{
		state[key] := getkeystate(key, "p") ? 1 : -1
		return
	}
	
	event    := 0
	newstate := getkeystate(key, "p") ? 1 : -1
	if (newstate != state[key])
	{
		event := newstate
	}		
	state[key] := newstate	
	return event	
}