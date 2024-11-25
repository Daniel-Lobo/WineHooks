class dshow_h_parser extends CppWrapper {

_1stpass()
	{
		fileappend,	% this.filename ".h: Pass1 - " 
		. "Removing comments and spliting preprocessor directives/code`n", *
		contents := regexreplace(this.rawcontent, "\\`r`n") ; join lines			
		loop, parse, contents, `n
			{
				;remove comment blocks
				token := trim(A_loopfield)
				if instr(token, "//") = 1
					continue
				if instr(token, "/*") 
					in_comment := 1
			
				if instr(A_loopfield, "*/")
				{
					in_comment := 0	
					/*
					; my cause problems in directx 10 and beyond =========================
					if instr(token, "/*") {
					while (instr(token, "/")  or instr(token, "*"))
						token := regexreplace(regexreplace(token, "s).*/"), "s)/\*.*")
					} 
					stringreplace, token, token, /, ,1
					stringreplace, token, token, \, ,1
					stringreplace, token, token, *, ,1
					this.code .= token . "`n" 
					; ====================================================================	
					*/					
					continue					
				}				
				if in_comment = 1
					continue
					
				;remove single line comments
				if instr(token, "//") = 1
					continue				
								
				;preprocessor
				if instr(token, "#") = 1
				{
					this.preproc .= A_loopfield . "`n"
					continue
				}						
				this.code .= A_loopfield . "`n"
			}	
		this._1stpass_code := this.code		
	}

_5thpass()
{
	this.interfaces := {}		
	fileappend,	% this.filename ".h: Alt Pass5 - Retriving COM inerfaces definitions`n", *	
	contents := this.preproc
	loop, parse, contents, "`n"
	{
		for k, v in this.GUIDs
		{
			interface := v[1]
			stringreplace, interface, interface, IID_, ,
			if not errorlevel
			this.interfaces[interface] ?: this.interfaces[interface] := [interface, "`n""`n"]
			if instr(A_loopfield, " " interface) 
			{
				method := RegExReplace(A_loopfield, "#define " interface "_")
				stringreplace, method, method, (, )(
				method := "STDMETHOD(" trim(strsplit(method, " ")[1])
				
				;fileappend, method found for interface %interface%`n, *
				(method = "STDMETHOD(#define") ?: this.interfaces[interface][2] .= method "`n"
			}
		}
	}		
	for k, v in this.interfaces
		fileappend, % "`n" k "`n" v[2] "...`n", *	
}

_6thpass()
{
	fileappend,	% this.filename ".h: Pass6 - Retriving Constants definitions`n", *
	preproc := this.preproc
	loop, parse, preproc, "`n"
		{
			if instr(A_Loopfield, "#define") and instr(A_Loopfield, "(")
			{
				field := strsplit(A_Loopfield, "(")
				val := field[2]
				stringreplace, val, val, ), ,
				stringreplace, val, val, `n, ,
				stringreplace, val, val, `r, ,
				if not instr(val, "0x")
					stringreplace, val, val, f, ,
				val := trim(val)
				val := val + 0
				if val is number 
				{
					const := field[1]
					if instr(const, " ")
						continue
					stringreplace, const, const, #define, ,
					const := trim(const)
					fileappend, % A_Loopfield "`n", *
					fileappend, % field[1] "`n", *
					this.constants[const] := val
				}
			}			
		}	
}

process_interfaces() {	
return
}

patch() {
	this.filename := "dshow"		
}

}


#include HeaderParser.ahk

;dshow := new dshow_h_parser("C:\Program Files\Microsoft SDKs\Windows\v7.1A\Include\control.h")
;dshow.save("dshow.h.ahk")




