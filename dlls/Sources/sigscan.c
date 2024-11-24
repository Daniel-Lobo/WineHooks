#include <windows.h>

__declspec(dllexport) void* sigscan(BYTE* mempage_add, UINT size, void* signature,
                                    UINT sigsize)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    BYTE * page_add;
    for (UINT i=0; i<=size-sigsize ; i++)
    {
        page_add = mempage_add + i;
        if (memcmp((void*) page_add, signature, sigsize)== 0)
        return i;
    };
    return 0;
}


unsigned int sigscan64(void* base, DWORD size, void* signature, DWORD sigsize, HANDLE hProcess)
{
    void * buff = malloc(sigsize);
    DWORD i = 0;
    void * page_add;
    SIZE_T read;
    for (i = 0; i <= size - sigsize; i++)
    {
       page_add = (void*)((DWORD)base+1);
       if (ReadProcessMemory(hProcess, page_add, &buff, sigsize, &read))
           continue;
       if (memcmp((void*) &buff, signature, sigsize)== 0)
       {
           free(buff) ;
           return i;
       }
    }
    free(buff);
    return 0;
}

