#include <windows.h>
#include <math.h>
#include <winbase.h>
//#include "D3DHooks.h"
#include "dllmain.h"
#include <regex>
extern "C" {
#include "DDSurface.h"
}

interface TextureDump {
    virtual std::string * Match(UINT, UINT, UINT, byte *)           PURE;
    virtual UINT bytesperpixel()                                    PURE;
    virtual TextureDump * Load(DWORD, DDS_HEADER *, char *, HANDLE) PURE;    
    virtual TextureDump * SetData(LPVOID, DWORD, char*)             PURE;
    virtual UINT CheckPath(char *)                                  PURE;
};

class TextureDump32: virtual public TextureDump{
public:
    virtual std::string * Match(UINT samples, UINT offset, UINT w, byte * pData)
    {
         //DBUG_WARN((std::string("Serching ")+m_replacement+" "+std::to_string(bytesperpixel())).c_str());         
         UINT dump_pitch = bytesperpixel()*w;
         byte * data     = m_data;
         for(UINT i=0; i<samples; i++)
         {
             if (memcmp(data, pData, dump_pitch) != 0) return nullptr;
             data  += dump_pitch;
             pData += offset;
         }
         DBUG_WARN((std::string("Match ")+m_replacement).c_str());
         return &m_replacement;
    }
    virtual UINT bytesperpixel(){return 4;}
    virtual TextureDump * Load(DWORD s, DDS_HEADER * d, char * f, HANDLE hFile)
    {
        DWORD    r, i, pitch;
        byte          * data;
        pitch  = d->dwWidth*bytesperpixel();
        m_data = (byte*)malloc(pitch*s);
        data   = m_data;
        for(i=0; i<s; i++)
        {
            if (ReadFile(hFile, data, pitch, &r, nullptr)==0)                                        DBUG_WARN("ReadFile FAILED");
            if (SetFilePointer(hFile, ((d->dwHeight/s)-1)*pitch, NULL, 1)==INVALID_SET_FILE_POINTER) DBUG_WARN("SetFilePointer FAILED");
            data += pitch;
        }
        ProcessPath(f);
        return dynamic_cast<TextureDump*>(this);
    }
    virtual void ProcessPath(char * f)
    {
        m_replacement = std::regex_replace(std::string(f), std::regex("\\\\Dumps\\\\"), "\\Replacements\\");        
        DBUG_LOG( (std::string("Replacement: ")+m_replacement).c_str() );
    }
    virtual TextureDump * SetData(LPVOID pData, DWORD sz, char * file)
    {
       m_data = (byte*)malloc(sz);
       memcpy(m_data, pData,  sz);
       ProcessPath(file);
       return dynamic_cast<TextureDump*>(this);
    }
    virtual UINT CheckPath(char * path){
        std::string this_dump =
                std::regex_replace(m_replacement, std::regex("\\\\Replacements\\\\"), "\\Dumps\\");
        return this_dump.compare(std::string(path));
    }
    std::string              m_replacement;    
    byte                * m_data = nullptr;
};

class TextureDump16: virtual public TextureDump32{
    virtual UINT bytesperpixel() {return 2;}
};
class TextureDump24: virtual public TextureDump32{
    virtual UINT bytesperpixel() {return 3;}
};
class TextureDumpDXT1: virtual public TextureDump{
    virtual std::string * Match(UINT samples, UINT offset, UINT w, byte * pData)
    {
        //DBUG_WARN((std::string("Serching ")+m_replacement+" "+std::to_string(bytesperpixel())).c_str());
        UINT bytes_per_row_block = bytesperpixel()*w/4;
        byte * data     = m_data;
        for(UINT i=0; i<samples; i++)
        {
            if (memcmp(data, pData, bytes_per_row_block) != 0) return nullptr;
            data  += bytes_per_row_block;
            pData += offset;
        }
        DBUG_WARN("Match");
        return &m_replacement;
    }
    virtual UINT bytesperpixel() {return 8;} /* On DXTn this is the number of bytes per 4x4 block*/
    virtual TextureDump * Load(DWORD s, DDS_HEADER * d, char * f, HANDLE hFile)
    {
        DWORD r;
        DWORD w = (d->dwWidth +3)/4; /* 4x4 pixel blocks */
        DWORD h = (d->dwHeight+3)/4; /* 4x4 pixel blocks*/
        DWORD bytes_per_row_block = w * bytesperpixel(); // bytesperpixel() = bytes_per_block
        m_data = (byte*) malloc(bytes_per_row_block * s);
        byte* data   = m_data;
        for(UINT i=0; i<s; i++)
        {
            if (ReadFile(hFile, data, bytes_per_row_block, &r, nullptr)==0)                              DBUG_WARN("ReadFile FAILED");
            if (SetFilePointer(hFile, ((h/s)-1)*bytes_per_row_block, NULL, 1)==INVALID_SET_FILE_POINTER) DBUG_WARN("SetFilePointer FAILED");
            data += bytes_per_row_block;
        }
        ProcessPath(f);
        return dynamic_cast<TextureDump*>(this);
    }
    virtual void ProcessPath(char * f)
    {
        m_replacement = std::regex_replace(std::string(f), std::regex("\\\\Dumps\\\\"), "\\Replacements\\");
        DBUG_LOG( (std::string("Replacement: ")+m_replacement).c_str() );
    }
    virtual TextureDump * SetData(LPVOID pData, DWORD sz, char * file)
    {
       m_data = (byte*)malloc(sz);
       memcpy(m_data, pData,  sz);
       ProcessPath(file);
       return dynamic_cast<TextureDump*>(this);
    }
    virtual UINT CheckPath(char * path){
        std::string this_dump =
                std::regex_replace(m_replacement, std::regex("\\\\Replacements\\\\"), "\\Dumps\\");
        return this_dump.compare(std::string(path));
    }
    std::string              m_replacement;
    byte                * m_data = nullptr;
};
class TextureDumpDXTn: virtual public TextureDumpDXT1{
    virtual UINT bytesperpixel() {return 16;}
};

LPVOID TextureDumps::Find(UINT w, UINT h, UINT p, char * f, byte * pData)
{
    static std::wstring test = L"test";

    POINTER_DICTIONARY * fmts_collection = (POINTER_DICTIONARY*)m_Dumps->Value((LPVOID)*(DWORD*)f);
    if (fmts_collection == nullptr) return nullptr;

    POINTER_DICTIONARY * collection = (POINTER_DICTIONARY*) fmts_collection->Value((LPVOID)(h|(w<<16)));
    if (collection      == nullptr) return nullptr;

    UINT count = collection->Count();
    if (count           == 0)       return nullptr;

    if (0 == GetType(f)) {
        DBUG_LOG("BAD FORMAT");
        return nullptr;
    }

    TextureDump  *   d  = nullptr;
    LPVOID       ret    = nullptr;
    UINT        offset  = p*h/m_sample_count;
    if (*(byte*)"D" == *(byte*)f)
    {
        /* For DXTn we can ignore the pitch because pixel blocks are 64 bit aligned */
        if (*(DWORD*)f == *(DWORD*)"DXT1") offset = ((w+3)/4) * 8  * ((h+3)/4)/m_sample_count;
        else                               offset = ((w+3)/4) * 16 * ((h+3)/4)/m_sample_count;
    }
    for (UINT i=0; i<count; i++)
    {       
        d = (TextureDump*)collection->ValueAt(i);
        if (d)
        {            
            ret = d->Match(m_sample_count, offset, w, pData);           
            if (ret) return ret;
        } else {
            DBUG_WARN((std::string("No dump on: ")+std::to_string(i)).c_str());
        }
    }
    return nullptr;
}

UINT TextureDumps::AppendDump(char * file)
{
    POINTER_DICTIONARY   * frmts = nullptr;
    POINTER_DICTIONARY   * sizes = nullptr;
    DDS_HEADER                  DDS_Header;
    HANDLE   hFile =  INVALID_HANDLE_VALUE;
    DWORD                       Succss = 0;
    char                           fmt[20];
    DWORD                 res, magic, read;
    UINT                          type = 0;

    DBUG_LOG((std::string("Loading dump: ")+file).c_str());
    hFile = CreateFileA(file, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
                        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE)
    {
        DBUG_LOG("CreateFileW FAILED");
        return 1;
    }

    Succss = ReadFile(hFile, &magic, 4, &read, NULL);
    if ( (!Succss) || (magic != 0x20534444) )
    {
        CloseHandle(hFile); DBUG_LOG("BADFILE");
        return 2;
    }
    Succss = ReadFile(hFile, &DDS_Header, sizeof(DDS_HEADER), &read, NULL);
    if (!Succss)
    {
        CloseHandle(hFile); DBUG_LOG("ReadFile FAILED");
        return 3;
    }

    GetDDSFileFormat(&DDS_Header, fmt);
    DBUG_LOG((std::string("PIXEL FORMAT: ")+fmt).c_str());
    type = GetType(fmt);
    if (!type)
    {
        CloseHandle(hFile); DBUG_LOG((std::string("BAD FORMAT: ")+file).c_str());
        return 4;
    }

    frmts     = (POINTER_DICTIONARY*)m_Dumps->Value((LPVOID)*(DWORD*)fmt);
    if (frmts == nullptr)
    {
        DBUG_LOG((std::string("CREATING SUBCOLLECTION FOR FORMAT: ")+fmt).c_str());
        frmts = new POINTER_DICTIONARY();
        m_Dumps->insert((LPVOID)*(DWORD*)fmt, frmts);
    }
    res       = DDS_Header.dwHeight | (DDS_Header.dwWidth << 16);
    sizes     = (POINTER_DICTIONARY*)frmts->Value((LPVOID)res);
    if (sizes == nullptr)
    {
        DBUG_LOG((std::string("CREATING SUBCOLLECION FOR SIZE: ")+std::to_string(res)+ " "+
                  std::to_string(DDS_Header.dwWidth)+"x"+std::to_string(DDS_Header.dwWidth)+
                  " on format: "+fmt).c_str());
        sizes = new POINTER_DICTIONARY();
        frmts->insert((LPVOID)res, sizes);
    }
    TextureDump * dmp;
    if       (type==*(DWORD*)"RGB32") dmp = dynamic_cast<TextureDump*>(new TextureDump32());
    else if  (type==*(DWORD*)"DXT1")  dmp = dynamic_cast<TextureDump*>(new TextureDumpDXT1());
    else if  (type==*(DWORD*)"DXTn")  dmp = dynamic_cast<TextureDump*>(new TextureDumpDXTn());
    else if  (type==*(DWORD*)"RGB16") dmp = dynamic_cast<TextureDump*>(new TextureDump16());
    else                              dmp = dynamic_cast<TextureDump*>(new TextureDump24());
    sizes->insert_disposable((LPVOID)dmp, dmp->Load(m_sample_count, &DDS_Header, file, hFile));
    DBUG_LOG((std::to_string((UINT)dmp)+ " " +std::string(fmt)+" "+
              std::to_string(DDS_Header.dwWidth)+"x"+std::to_string(DDS_Header.dwWidth)+
              " size: "+std::to_string(sizes->Count())).c_str());
    CloseHandle(hFile);
    return 0;
}

UINT TextureDumps::LoadDumps(char * f, char * dir)
{
    POINTER_DICTIONARY     * frmts = nullptr;
    POINTER_DICTIONARY     * sizes = nullptr;
    DWORD  Succss     =                    0;
    DWORD  read_count =                    0;
    HANDLE hFile      = INVALID_HANDLE_VALUE;
    UINT dump_count   =                    0;    
    UINT res          =                    0;
    COMPILED_DUMP * dumps         =  nullptr;
    UINT                                   i;
    DDS_HEADER                           dds;
    byte *                         pDumpData;
    char                             fmt[20];
    UINT                            type = 0;

    hFile = CreateFileA(f, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
                        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE)
    {
        DBUG_LOG("CreateFileW FAILED");
        return 1;
    }
    Succss = ReadFile(hFile, &dump_count, sizeof(WORD), &read_count, NULL);
    if (!Succss)
    {
        CloseHandle(hFile); DBUG_LOG("ReadFile FAILED 1");
        return 2;
    } DBUG_LOG((std::to_string(dump_count)+" Dumps").c_str());
    if (dump_count < 1)
    {
        CloseHandle(hFile); DBUG_LOG("BAD COUNT");
        return 3;
    }
    Succss = ReadFile(hFile, &m_sample_count, sizeof(WORD), &read_count, NULL);
    if (!Succss)
    {
        CloseHandle(hFile); DBUG_LOG("ReadFile FAILED 2");
        return 4;
    } DBUG_LOG((std::to_string(m_sample_count)+" Samples").c_str());
    dumps = new COMPILED_DUMP[dump_count];    
    for (i=0; i<dump_count; i++)
    {
        ReadFile(hFile, &dumps[i].path,   510          , &read_count, NULL);
        ReadFile(hFile, &dumps[i].offset, sizeof(DWORD), &read_count, NULL);
        ReadFile(hFile, &dumps[i].size,   sizeof(DWORD), &read_count, NULL);
        dumps[i].size -= (sizeof(DDS_HEADER)+4);
        DBUG_LOG((std::string(dumps[i].path)+" - size/offset: "+
                  std::to_string(dumps[i].size)+"/"+std::to_string(dumps[i].offset)).c_str());
    }    
    for (i=0; i<dump_count; i++)
    {
        SetFilePointer(hFile, dumps[i].offset+4, NULL, FILE_BEGIN);
        ReadFile(hFile, &dds, sizeof(DDS_HEADER), &read_count, NULL);
        GetDDSFileFormat(&dds, fmt);
        DBUG_LOG((std::string("DUMP ")+std::to_string(i)+" PIXEL FORMAT: " +fmt).c_str());
        type = GetType(fmt);
        if (!type)
        {
            DBUG_LOG((std::string("BAD PIXEL FORMAT ")).c_str());
            continue;
        }
        frmts     = (POINTER_DICTIONARY*)m_Dumps->Value((LPVOID)*(DWORD*)fmt);
        if (frmts == nullptr)
        {
            DBUG_LOG((std::string("CREATING SUBCOLLECTION FOR FORMAT: ")+fmt).c_str());
            frmts = new POINTER_DICTIONARY();
            m_Dumps->insert((LPVOID)*(DWORD*)fmt, frmts);
        }
        res       = dds.dwHeight | (dds.dwWidth << 16);
        sizes     = (POINTER_DICTIONARY*)frmts->Value((LPVOID)res);
        if (sizes == nullptr)
        {
            DBUG_LOG((std::string("CREATING SUBCOLLECION FOR SIZE: ")+std::to_string(res)+ " "+
                      std::to_string(dds.dwWidth)+"x"+std::to_string(dds.dwWidth)+
                      " on format: "+fmt).c_str());
            sizes = new POINTER_DICTIONARY();
            frmts->insert((LPVOID)res, sizes);
        }
        pDumpData = new byte[dumps[i].size];
        ReadFile(hFile, pDumpData, dumps[i].size, &read_count, NULL);
        TextureDump * dmp;
        if       (type==*(DWORD*)"RGB32") dmp = dynamic_cast<TextureDump*>(new TextureDump32());
        else if  (type==*(DWORD*)"DXT1")  dmp = dynamic_cast<TextureDump*>(new TextureDumpDXT1());
        else if  (type==*(DWORD*)"DXTn")  dmp = dynamic_cast<TextureDump*>(new TextureDumpDXTn());
        else if  (type==*(DWORD*)"RGB16") dmp = dynamic_cast<TextureDump*>(new TextureDump16());
        else                              dmp = dynamic_cast<TextureDump*>(new TextureDump24());
        sizes->insert_disposable((LPVOID)dmp, dmp->SetData(pDumpData, dumps[i].size,
                                                          (char*)(std::string(dir)+"\\"+dumps[i].path).c_str()));
        delete [] pDumpData;
    }
    delete [] dumps;
    return 0;
}

UINT TextureDumps::IsDump(char * path)
{
    POINTER_DICTIONARY   * fmt, * size;
    UINT                    i, ii, iii;
    TextureDump *                    d;

    if (m_Dumps->count == 0) return 0;

    for (i=0; i<m_Dumps->count; i++)
    {
        fmt = (POINTER_DICTIONARY  *) m_Dumps->ValueAt(i);
        if (fmt->count)
        {
            for (ii=0; ii<fmt->count; ii++)
            {
                size = (POINTER_DICTIONARY  *) fmt->ValueAt(ii);
                if (size->count)
                {
                     for (iii=0; iii<size->count; iii++)
                     {
                        d = (TextureDump*)size->ValueAt(iii);
                        if (d->CheckPath(path)== 0) return 1;
                     }
                }
            }
        }
    }
    return 0;
}

UINT __stdcall AppendDump(char * f)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return g_.m_Dumps->AppendDump(f);
}

UINT __stdcall LoadDumps(char * f, char * d)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return g_.m_Dumps->LoadDumps(f, d);
}

UINT __stdcall SetSampleCount(UINT c)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_.m_Dumps->m_sample_count = c;
    return g_.m_Dumps->m_sample_count;
}

UINT __stdcall SetTexturePaths(wchar_t * base, char * checkboard)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    g_.m_BaseTexturePath.clear();
    g_.m_BaseTexturePath.append(base);
    g_.m_FallBackTextureReplacement.clear();
    g_.m_FallBackTextureReplacement.append(checkboard);
    OutputDebugStringW(L"TextSwap Paths:");
    OutputDebugStringW( g_.m_BaseTexturePath.c_str() );
    OutputDebugStringA( g_.m_FallBackTextureReplacement.c_str() );
    return 0;
}

UINT IsDump(char * path)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    return g_.m_Dumps->IsDump(path);
}
