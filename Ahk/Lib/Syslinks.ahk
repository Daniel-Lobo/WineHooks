class __Syslinks__
{
	__delete()
	{
		file  := fileopen(g_.injector_dir "\SystemLinks.log", "r")	
		while (l := file.ReadLine())	
		{
			line  := trim(line, "`r")
			line  := trim(line, "`n")
			line  := trim(line, "`r")			
			FileDelete, %line%
		}		
	}
}

class Syslinks
{
	__new(gdir, sdir)
	{
		this.gdir  := gdir
		this.sdir  := sdir
		this.links := {}
		
		this.log  := fileopen(g_.injector_dir "\file.log", "w")				
		this.log.write("Gamedir  " gdir "`n")
		this.log.write("Savesdir " sdir "`n")
		this.log.write("Files to create links for" "`n")		
		
		this.files := this.ListGameFiles(gdir)
		loop, Files, %sdir%\*.*, r
		{
			lnk := StrReplace(A_LoopFileFullPath, sdir, gdir)
			SplitPath, lnk, , OutDir,
			
			if (!Fileexist(OutDir))
			{
				this.log.write("Create dir : " OutDir "`n")
				FileCreateDir, % OutDir
			}
			this.log.write("Create link: " lnk "`n")
			this.log.write("For file   : " A_LoopFileFullPath "`n")			
			if (dllcall("CreateSymbolicLinkW", str, lnk, str, A_LoopFileFullPath, uint, 0, uint) )
				this.links[A_LoopFileFullPath] := lnk	
		}
		
		this.log.write("Game files:`n")			
		for k, v in this.files
			this.log.write(k "`n")	
	}
	ListGameFiles(gdir)
	{
		files := {}
		loop, Files, %gdir%\*.*, r
			files[A_LoopFileFullPath] := True
		return files
	}
	__delete()
	{
		for k, v in this.links
		{
			att := dllcall("GetFileAttributesW", str, v)
			if ( (att & 0x400) && (att>0) )
			{
				this.log.write(v " is shortcut `n")
				FileDelete, % v	
			}
			else 
			{
				this.log.write("deleting  :  " k "`n")
				FileDelete, % k	
			}				
		}
		
		for k, v in this.ListGameFiles(this.gdir)
		{
			if (! this.files[k] )
			{
				backup := StrReplace(k, this.gdir, this.sdir)
				SplitPath, backup, , OutDir,
				this.log.write("Created:  " k "`n")	
				this.log.write("Backup :  " backup "`n")	
				this.log.write("at     :  " OutDir "`n")
				if (!Fileexist(OutDir))
					FileCreateDir, % OutDir
				FileMove, % k, % backup
			}
		}
		this.log.close()	
		new __Syslinks__()
	}
}

if (instr(g_.svs, "links_cpp"))
Syslinks = __Syslinks__