;REMOTE SCRIPT START
g_.s.e2patch        := parsecfg(g_.cfg.e2patch)
g_.s.e2patch_string := FileOpen("e2patch.ini", "r").read(  )
for k, v in g_.s.e2patch
	g_.s.e2patch_string := RegExReplace(g_.s.e2patch_string, k " = [0-1]", k " = " v) 
FileOpen("e2patch.ini", "w").write( trim(g_.s.e2patch_string) )
