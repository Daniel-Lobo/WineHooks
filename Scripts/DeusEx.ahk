;REMOTE SCRIPT START

InitDeusExHooks()
InitDeusExHooks()
{
	if g_.cfg.fovfix
	{
		g_.desktop := desk()		
		if (g_.cfg.target_name = "DeusEx.exe" or g_.cfg.target_name = "Rune.exe") 
		{
			fov := FOV(FOV(75, "3:4"), g_.desktop.w ":" g_.desktop.h) 
			Logerr("Desktop resolution is " g_.desktop.w "x" g_.desktop.h)
			Logerr("Optimal fov is " fov)
				
			iniwrite, %fov%, user.ini, Engine.PlayerPawn, DesiredFOV
			iniwrite, %fov%, user.ini, Engine.PlayerPawn, DefaultFOV
			path := g_.cfg.Path "cfg\user.ini"
			if Fileexist(path)
			{
				iniwrite, %fov%, %path%, Engine.PlayerPawn, DesiredFOV
			    iniwrite, %fov%, %path%, Engine.PlayerPawn, DefaultFOV
			}
		} 
		else if (g_.cfg.target_name = "Unreal.exe") 
		{
			fov := FOV(FOV(90, "3:4"), g_.desktop.w ":" g_.desktop.h) 
			Logerr("Desktop resolution is " g_.desktop.w "x" g_.desktop.h)
			Logerr("Optimal fov is " fov)			
			iniwrite, %fov%, user.ini, Engine.PlayerPawn, MainFOV	
			path := g_.cfg.Path "cfg\user.ini"
			if Fileexist(path)
			{
				iniwrite, %fov%, %path%, Engine.PlayerPawn, DesiredFOV
			    iniwrite, %fov%, %path%, Engine.PlayerPawn, DefaultFOV
			}	
		}
	}	
}