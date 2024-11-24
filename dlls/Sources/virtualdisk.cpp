#include <windows.h>
#define WINVER _WIN32_WINNT_WIN7
#include <windows.h>
#include <initguid.h>
#include <virtdisk.h>
#include "aviriff.h"
//#pragma comment(lib, "virtdisk.lib")

typedef DWORD (WINAPI * OpenVirtualDiskType)(PVIRTUAL_STORAGE_TYPE,
        PCWSTR,  VIRTUAL_DISK_ACCESS_MASK,  OPEN_VIRTUAL_DISK_FLAG,
        POPEN_VIRTUAL_DISK_PARAMETERS, PHANDLE);

typedef DWORD (WINAPI * AttachVirtualDiskType)( HANDLE,
        PSECURITY_DESCRIPTOR, ATTACH_VIRTUAL_DISK_FLAG,
        ULONG, PATTACH_VIRTUAL_DISK_PARAMETERS, LPOVERLAPPED);

extern "C" __declspec(dllexport) HRESULT __stdcall MountISO(wchar_t * path)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    HMODULE hVirtdisk = LoadLibrary(L"VirtDisk.dll");
    if ( hVirtdisk == nullptr)
    {
        OutputDebugStringA("Failed to load virtdisk.dll");
        return 0;
    }
    OpenVirtualDiskType OpenVirtualDisk
            = (OpenVirtualDiskType)GetProcAddress(hVirtdisk, "OpenVirtualDisk");
    AttachVirtualDiskType AttachVirtualDisk
            = (AttachVirtualDiskType)GetProcAddress(hVirtdisk, "AttachVirtualDisk");

    if ( (OpenVirtualDisk == NULL) || (AttachVirtualDisk == NULL) )
    {
        OutputDebugStringA("Failed to get virtdisk.dll pointers");
        return 0;
    }

    OPEN_VIRTUAL_DISK_PARAMETERS openParameters;
    openParameters.Version = OPEN_VIRTUAL_DISK_VERSION_1;
    openParameters.Version1.RWDepth = OPEN_VIRTUAL_DISK_RW_DEPTH_DEFAULT;

    VIRTUAL_STORAGE_TYPE storageType;
    storageType.DeviceId = VIRTUAL_STORAGE_TYPE_DEVICE_ISO;
    storageType.VendorId = VIRTUAL_STORAGE_TYPE_VENDOR_UNKNOWN ;

    ATTACH_VIRTUAL_DISK_PARAMETERS attachParameters;
    attachParameters.Version = ATTACH_VIRTUAL_DISK_VERSION_1;

    HANDLE vhdHandle;

    if (OpenVirtualDisk(&storageType, path,
            VIRTUAL_DISK_ACCESS_SURFACE_RO, OPEN_VIRTUAL_DISK_FLAG_NONE,
            nullptr, &vhdHandle) != ERROR_SUCCESS) {
        return GetLastError();
    }

    // Warning: AttachVirtualDisk requires elevation
    if (AttachVirtualDisk(vhdHandle, nullptr,
                          ATTACH_VIRTUAL_DISK_FLAG_READ_ONLY|ATTACH_VIRTUAL_DISK_FLAG_NO_DRIVE_LETTER,
            0, nullptr, 0) != ERROR_SUCCESS) {
        return 2;
    }
    return 3;
}

