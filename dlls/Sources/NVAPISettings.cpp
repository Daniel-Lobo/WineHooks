#include <windows.h>
#include <string>
#include "dllmain.h"
#include "Dbug.h"
#include "nvapi.h"
#include "NvApiDriverSettings.h"

extern "C" __declspec(dllexport) DWORD __stdcall NVIDIA_Set(wchar_t * app, DWORD lvl)
{
	//return 0;
	#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	OutputDebugStringW((std::wstring(L"NVIDIA_Set") + L" " + app).c_str());
	NvAPI_Status status            = NVAPI_ERROR;
	NvDRSSessionHandle hSession    = nullptr;
	NvDRSProfileHandle hProfile    = nullptr;
	NvDRSProfileHandle hBase       = nullptr;	
	NVDRS_SETTING      Setting     = {};
	NVDRS_PROFILE      pInfo       = {NVDRS_PROFILE_VER};
	NVDRS_APPLICATION  App         = {NVDRS_APPLICATION_VER};

	wcscpy((wchar_t*)&pInfo.profileName, L"Peixoto");	
	wcscpy((wchar_t*)&App.appName, app);

    status = NvAPI_Initialize();
	if (status != NVAPI_OK)
	{
		DBUG_WARN("NvAPI_Initialize FAILED");
		return 1;
	}
	
	status = NvAPI_DRS_CreateSession(&hSession);
	if (status != NVAPI_OK)
	{
		DBUG_WARN("NvAPI_DRS_CreateSession FAILED");
		return 2;
	}

	if (lvl == 0)
	{
		status = NvAPI_DRS_CreateProfile(hSession, &pInfo, &hProfile);
		if (status != NVAPI_OK)
		{
			DBUG_WARN("NvAPI_DRS_CreateProfile FAILED");
			NvAPI_DRS_DestroySession(hSession);
			NvAPI_Unload();
			return 5;
		}
		else
		{
			status   = NvAPI_DRS_DeleteProfile(hSession, hProfile);
			hProfile = nullptr;
		}	

		status = NvAPI_DRS_SaveSettings(hSession);
		if (status != NVAPI_OK)
		{
			DBUG_WARN("NvAPI_DRS_SetSetting FAILED");
			return 6;
		}
	
		NvAPI_DRS_DestroySession(hSession);
		NvAPI_Unload();
		OutputDebugStringW((std::wstring(__FUNCTIONW__) + L" " + app + L" " + L" =)").c_str());
		DBUG_LOG("=|");
		return 0;
	}

	status = NvAPI_DRS_CreateProfile(hSession, &pInfo, &hProfile);
	if (status != NVAPI_OK)
	{
		DBUG_WARN("NvAPI_DRS_CreateProfile FAILED");
		return 7;
	}

	status = NvAPI_DRS_CreateApplication(hSession, hProfile, &App);
    if (status != NVAPI_OK)
	{
		DBUG_WARN("NvAPI_DRS_CreateApplication FAILED");
		return 8;
	}	

	Setting.version         = NVDRS_SETTING_VER;
	Setting.settingId       = AA_MODE_REPLAY_ID;
	Setting.settingId       = AA_BEHAVIOR_FLAGS_ID;
	Setting.u32CurrentValue = AA_BEHAVIOR_FLAGS_NONE;
	status = NvAPI_DRS_SetSetting(hSession, hProfile, &Setting);
	if (status != NVAPI_OK)
	{
		DBUG_WARN("NvAPI_DRS_SetSetting (AA_BEHAVIOR_FLAGS) FAILED");
		return 9;
	}

	Setting.settingId       = AA_MODE_REPLAY_ID;
	Setting.u32CurrentValue = AA_MODE_REPLAY_TRANSPARENCY_DEFAULT;
	status = NvAPI_DRS_SetSetting(hSession, hProfile, &Setting);
	if (status != NVAPI_OK)
	{
		DBUG_WARN("NvAPI_DRS_SetSetting (AA_MODE) FAILED");
		return 10;
	}

	Setting.settingId       = AA_MODE_SELECTOR_ID;
	Setting.u32CurrentValue = AA_MODE_SELECTOR_OVERRIDE;	
	status = NvAPI_DRS_SetSetting(hSession, hProfile, &Setting);
	if (status != NVAPI_OK)
	{
		DBUG_WARN("NvAPI_DRS_SetSetting (AA_MODE) FAILED");
		return 11;
	}
	Setting.settingId       = AA_MODE_METHOD_ID;
	Setting.u32CurrentValue = lvl==1 ? AA_MODE_METHOD_MULTISAMPLE_4X : AA_MODE_METHOD_MULTISAMPLE_8X;
	status = NvAPI_DRS_SetSetting(hSession, hProfile, &Setting);
	if (status != NVAPI_OK)
	{
		DBUG_WARN("NvAPI_DRS_SetSetting (AA_MODE_METHOD) FAILED");
		return 12;
	}
	Setting.settingId       = AA_MODE_ALPHATOCOVERAGE_ID;
	Setting.u32CurrentValue = AA_MODE_ALPHATOCOVERAGE_MODE_ON;
	status = NvAPI_DRS_SetSetting(hSession, hProfile, &Setting);
	if (status != NVAPI_OK)
	{
		DBUG_WARN("NvAPI_DRS_SetSetting (AA_MODE_ALPHATOCOVERAGE_ID) FAILED");
		return 13;
	}
	status = NvAPI_DRS_SaveSettings(hSession);
	if (status != NVAPI_OK)
	{
		DBUG_WARN("NvAPI_DRS_SetSetting FAILED");
		return 16;
	}
	NvAPI_DRS_DestroySession(hSession);
	NvAPI_Unload();
	OutputDebugStringW((std::wstring(__FUNCTIONW__) + L" " + app + L" " + L" =)").c_str());
	DBUG_LOG("=)");
	return 0;
}