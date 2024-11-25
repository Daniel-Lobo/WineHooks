Class IniFast 
{
  ; Constructor returns "" if file does not exists	
__New(file, chars = "`r`n", orfans = "<<<orfans>>>", _join=".")	
	{
		if ! fileexist(file)
			return 
		this.orfans := orfans
		this.file := file
		FileRead, filecontents, %file%
		this.contents := filecontents
		this.sections := []
		current_section := 0	
		current_section_name := ""		

		loop, parse, filecontents, % chars
		{
			if this.isSectionName(A_loopfield)
			{
		    	this.sections.insert({})
				current_section += 1
				current_section_name := A_loopfield
				this.sections[current_section][current_section_name] := []
				continue
			}
			if A_loopfield 
			{
				if (current_section_name = "")
				{
					this.sections.insert({})
					current_section += 1
					current_section_name := "[" orfans "]"
					this.sections[current_section][current_section_name] := []
				}	
				this.sections[current_section][current_section_name].insert(A_loopfield)
			}
					
		}
			
		for k, v in this.sections
		{
			for key, value in v	
				{	
					if value[value.maxindex()] != " "
						value.insert(" ")
				}	
		}			
			
	}	
	
isKey(search_key, sections = "", comment_chars = "", orfans = False)	
{
	if not comment_chars
		comment_chars := ["#"]
	if not sections
		sections := this.listSections(orfans)
	for idx, section in sections
		for i, key in this.listKeys(section, comment_chars)
			if (key = search_key)
				return True
	return False		
}	

listSections(orfans = False)
{
	allsecs := []
	for k, v in this.sections 
	{	
		for key, value in v	
		{	
			if not ( (key = "[" this.orfans "]") and (orfans = false) )
			{
				stringreplace, key, key, ], , 1
				stringreplace, key, key, [, , 0
				allsecs.insert(key)
			}
		}	
	}
	return allsecs	
}

listKeys(target_section="", comment_chars="#")
{
	if ! target_section 
		target_section := this.orfans
	keys := []
	comments := ""
	in_sec := False
	for index, section_name in this.sections
	{
		for section_, key_value_pars in section_name		
		{
			if not section_ = "[" target_section "]"
				continue
			else in_sec := True			
			for index_, value_ in key_value_pars
			{
				if not instr(value_, "=")
					continue
				for kk, vv in comment_chars
				{
					if this.stringStartsWith(value_, vv)
	     				continue 2  
				}	
				stringsplit, par, value_, = 
				keys.insert(par1)
			}	
			if in_sec	
				break
		}	
	}
		
	return keys
}

show_()
{
	for k, v in this.sections
	{
		for key, value in v		
		{
			fileappend, % key "`n", *	 
			for key_, value_ in value
				fileappend, % "-" value_ "`n", *	 
		}	
	}
}	

read(key, target_section = "")
{
	if ! target_section 
		target_section := this.orfans
	
	for index, section_name in this.sections
	{
		for section_, key_value_pars in section_name		
		{
			if not section_ = "[" target_section "]"
				continue
			for index_, value_ in key_value_pars
			{
				par1 := strsplit(value_, "=")[1]
				stringreplace, par2, value_, %par1%=
				;stringsplit, par, value_, = 
				if (par1 = key)
					return trim(par2) 
			}	
		}	
	}
	return		
}	

isTrue(key, target_section = "", default_ = False)
{
	if (this.read(key, target_section) = "True")
		return True
	return default_
}	

newSection(key, value, target_section)
{
	this.sections.insert({})
	this.sections[this.sections.MaxIndex()]["[" target_section "]"] := [key "=" value, " "]
	return this.edit(key, value, target_section)
}

newKey(key, value, target_section)
{	
	for index, section_name in this.sections
	{
		for section_, key_value_pars in section_name		
		{
			if not section_ = "[" target_section "]"
				continue
			else
			{
	    		this.sections[index][section_][this.sections[index][section_].maxindex()] := key "="
	 			this.sections[index][section_].insert(" ")
			}
		}	
	}
	return this.edit(key, value, target_section)
}

editsection(target_section, new_section)
{
	for k, v in this.sections 
	{	
		for key, value in v	
		{	
			if ( (key = "[" target_section "]")  )
			{
				this.sections.insert({})
				this.sections[this.sections.MaxIndex()]["[" new_section "]"] := value
				this.sections.remove(k)
			}
		}	
	}
	return new_section
}

edit(key, value, target_section = "")
{
	if ! target_section 
		target_section := this.orfans
	
	section_found := false
	key_found := false
	
	for index, section_name in this.sections
	{
		for section_, key_value_pars in section_name		
		{
			if not section_ = "[" target_section "]"
				continue
			else section_found := True
			for index_, value_ in key_value_pars
			{
				stringsplit, par, value_, = 
				if (par1 = key)
	 			{
	    			this.sections[index][section_][index_] := key "=" value
	 				key_found := True
				}	
			}	
		}	
	}
	if (section_found = false)
		return this.newSection(key, value, target_section)
	if (key_found = false)
		return this.newKey(key, value, target_section)
	return		
}	
	
save()
{
	string := ""
	for k, v in this.sections
	{
		for key, value in v		
		{
			if not key = "[" this.orfans "]"
				string .= key "`r`n" 
			for key_, value_ in value
						string .= value_ "`r`n" 	 
		}	
		string := Rtrim(string, omitchars = " `r`n")
	}	
	string := Ltrim(string, omitchars = "`r`n")
	filedelete, % this.file	
	fileappend, % string, % this.file 
	return 0
}
	
isSectionName(string)
	{
		
		if this.stringEndsWith(string, "]") and this.stringStartsWith(string, "[")
			return True			
		return false
		
	}
	
stringEndsWith(string, char_)
	{
		if InStr(string, char_ , StartingPos = 0) = Strlen(string) 
			return True
		return False		
	}	
	
stringStartsWith(string, char_)
	{
		if InStr(string, char_ , StartingPos = 1) = 1
			return True
		return false		
	}		
}

Class Ini extends IniFast {
}