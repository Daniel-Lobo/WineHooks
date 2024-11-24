#include <windows.h>
#include <string>
#include <ddraw.h>
#include "LibVlcPlayer.h"
#include "Dbug.h"
#include "D3D12Hooks.h"
//#include <XAudio2.h>

#define INIT_LIBVLC_PFTN(func, func_name, err_code)            \
func = (decltype(func)) GetProcAddress(hVlc, func_name); \
if (func == nullptr) return err_code;

struct {
    void   (cdecl * libvlc_video_unlock_cb) (void *, void *, void *const *);
    void * (cdecl * libvlc_video_lock_cb)   (void *, void **);
    void   (cdecl * libvlc_display)         (void *, void *);

    LPVOID (cdecl * libvlc_new)                     (int, const char *const *);
    LPVOID (cdecl * libvlc_media_new_path)          (LPVOID, const char *path);   
    int    (cdecl * libvlc_parse_media)             (LPVOID);
    UINT   (cdecl * libvlc_media_tracks_get)        (LPVOID, LPVOID);    
    void   (cdecl * libvlc_media_tracks_release)    (LPVOID,UINT);
    LPVOID (cdecl * libvlc_media_player_from_media) (LPVOID);    
    void   (cdecl * libvlc_video_set_format)        (LPVOID, const char *,UINT, UINT, UINT);
    void   (cdecl * libvlc_video_set_callbacks)     (LPVOID, LPVOID, LPVOID, LPVOID, void *);
    void   (cdecl * libvlc_set_fullscreen)          (LPVOID, BOOL);
    void   (cdecl * libvlc_media_player_play)       (LPVOID);
    BOOL   (cdecl * libvlc_media_player_is_playing) (LPVOID);   
    void   (cdecl * libvlc_media_player_stop)       (LPVOID);
    void   (cdecl * libvlc_media_release)           (LPVOID);
    void   (cdecl * libvlc_player_release)          (LPVOID);
    void   (cdecl * libvlc_release)                 (LPVOID);    
    int Init()
    {
        HMODULE hVlc = GetModuleHandleA("libvlc.dll");             if (hVlc == nullptr) return 1;

        INIT_LIBVLC_PFTN(libvlc_new,                     "libvlc_new",                         2)
        INIT_LIBVLC_PFTN(libvlc_media_new_path,          "libvlc_media_new_path",              3)
        INIT_LIBVLC_PFTN(libvlc_parse_media,             "libvlc_media_parse",                 4)
        INIT_LIBVLC_PFTN(libvlc_media_tracks_get,        "libvlc_media_tracks_get",            5)
        INIT_LIBVLC_PFTN(libvlc_media_tracks_release,    "libvlc_media_tracks_release",        6)
        INIT_LIBVLC_PFTN(libvlc_media_player_from_media, "libvlc_media_player_new_from_media", 7)
        INIT_LIBVLC_PFTN(libvlc_video_set_format,        "libvlc_video_set_format",            8)
        INIT_LIBVLC_PFTN(libvlc_video_set_callbacks,     "libvlc_video_set_callbacks",         9)
        INIT_LIBVLC_PFTN(libvlc_set_fullscreen,          "libvlc_set_fullscreen",             10)
        INIT_LIBVLC_PFTN(libvlc_media_player_play,       "libvlc_media_player_play",          11)
        INIT_LIBVLC_PFTN(libvlc_media_player_is_playing, "libvlc_media_player_is_playing",    12)
        INIT_LIBVLC_PFTN(libvlc_media_player_stop,       "libvlc_media_player_stop",          13)
        INIT_LIBVLC_PFTN(libvlc_media_release,           "libvlc_media_release",              14)
        INIT_LIBVLC_PFTN(libvlc_player_release,          "libvlc_media_player_release",       15)
        INIT_LIBVLC_PFTN(libvlc_release,                 "libvlc_release",                    16)   
        return 0;
    }
} LibVlc;


typedef struct LIBVLC_DDRAW_OUTPUT {
    RECT                                     r;
    IDirectDrawSurface     *   BRG   = nullptr;
    IDirectDrawSurface     *   RGB   = nullptr;
    IDirectDrawSurface2    * target  = nullptr;
    //IXAudio2               * IXAudio = nullptr;
    //IXAudio2MasteringVoice * Master  = nullptr;
    //IXAudio2SourceVoice    * voice   = nullptr;
    ~LIBVLC_DDRAW_OUTPUT(){
        OUTPUT_FUNC_DBG_STRING("================");
        if (target) target->Release();
        if (BRG)    BRG->Release();
        if (RGB)    RGB->Release();
    }
} LIBVLC_DDRAW_OUTPUT;

UINT VlcDDrawPlayer_InitXAudio(LIBVLC_DDRAW_OUTPUT * output)
{
    HMODULE hXAudio   = LoadLibraryA("XAudio2_8.dll");
    if (hXAudio      == nullptr) return 1;

    //XAudioCreate      = (XAUDIOCREATE) GetProcAddress(hXAudio, "XAudio2Create");
    //if (XAudioCreate == nullptr) return 2;

    //if (XAudioCreate(&output->IXAudio, 0, XAUDIO2_DEFAULT_PROCESSOR))
    //return 3;

    //if (output->IXAudio->CreateMasteringVoice(&output->Master, XAUDIO2_DEFAULT_CHANNELS, XAUDIO2_DEFAULT_SAMPLERATE, 0, NULL, NULL))
    //return 4;

    WAVEFORMATEX wf;
    wf.wFormatTag      = WAVE_FORMAT_PCM;
    wf.nChannels       = 2;
    wf.nSamplesPerSec  = 44100;
    wf.nAvgBytesPerSec = 44100*2*2;
    wf.nBlockAlign     = 4;
    wf.wBitsPerSample  = 16;
    wf.cbSize          = 0;
    //if (output->IXAudio->CreateSourceVoice(&output->voice, &wf, 2., 0, 0, 0))
    //return 5;

    return 0;
}

void * cdecl VlcDDrawPlayer_Vidlock(void *data, void **p_pixels)
{
    LIBVLC_DDRAW_OUTPUT * out =  (LIBVLC_DDRAW_OUTPUT*) data;
    DDSURFACEDESC                                          d;
    d.dwSize                         = sizeof(DDSURFACEDESC);
    if (out->BRG->Lock(nullptr, &d, DDLOCK_WRITEONLY, 0))
    OUTPUT_FUNC_DBG_STRING("IDirectDrawSurface::lock Failed");
    else *p_pixels = d.lpSurface;
    return NULL;
}

void cdecl VlcDDrawPlayer_VidUnlock(void *data, void *id, void * const *)
{
    LIBVLC_DDRAW_OUTPUT * out =  (LIBVLC_DDRAW_OUTPUT*) data;
    if (out->BRG->Unlock(nullptr))
    OUTPUT_FUNC_DBG_STRING("IDirectDrawSurface::Unlock Failed");

    DDBLTFX                  fx;
    fx.dwSize = sizeof(DDBLTFX);

    if (out->RGB->Blt(nullptr, out->BRG, nullptr, DDBLT_WAIT, &fx))
    {
         OUTPUT_FUNC_DBG_STRING("Blit to video failed");
         return;
    }
    if (out->target->Blt(&out->r, (IDirectDrawSurface2*)out->RGB, nullptr, DDBLT_WAIT, &fx))
    {
        OUTPUT_FUNC_DBG_STRING("Blit to screen failed");
        return;
    }
}

void cdecl VlcDDrawPlayer_display(void *data, void *)
{
    OUTPUT_FUNC_DBG_STRING("===================");
    return;
}

UINT VlcDDrawPlayer_InitDDraw(LIBVLC_DDRAW_OUTPUT * output, DWORD w, DWORD h)
{
    if (output->target == nullptr) return 0;
    IDirectDrawSurface2 * target;
    if (output->target->QueryInterface(IID_IDirectDrawSurface2, (LPVOID*)&target))
    {
        output->target = nullptr;
        return 1;
    }

    output->target        = target;
    IDirectDraw *  ddraw7 = nullptr;
    IDirectDraw *  ddraw  = nullptr;
    if (output->target->GetDDInterface((LPVOID*)&ddraw7))
    return 2;

    if (ddraw7->QueryInterface(IID_IDirectDraw, (void**)&ddraw))
    {
        ddraw7->Release();
        return 3;
    }ddraw7->Release();

    HRESULT         hr;
    DDSURFACEDESC desc;
    desc.dwSize                        = sizeof(DDSURFACEDESC);
    desc.dwFlags                       = DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT| DDSD_PIXELFORMAT;
    desc.dwHeight                      = h;
    desc.dwWidth                       = w;
    desc.ddpfPixelFormat.dwSize        = sizeof(DDPIXELFORMAT);
    desc.ddpfPixelFormat.dwRGBBitCount = 32;
    desc.ddpfPixelFormat.dwFlags       = DDPF_RGB;
    DWORD X8RGB[4]                     = {0x00FF0000, 0x0000FF00, 0x000000FF, 0};
    DWORD X8BRG[4]                     = {0x000000ff, 0x0000FF00, 0x00FF0000, 0};

    desc.ddsCaps.dwCaps                = DDSCAPS_SYSTEMMEMORY | DDSCAPS_OFFSCREENPLAIN;
    memcpy(&desc.ddpfPixelFormat.dwRBitMask, X8RGB, sizeof(DWORD)*4);
    hr = ddraw->CreateSurface(&desc, &output->BRG, nullptr);
    if (hr)
    {
        ddraw->Release();
        return hr;
    }

    desc.ddsCaps.dwCaps                = DDSCAPS_VIDEOMEMORY | DDSCAPS_OFFSCREENPLAIN;
    memcpy(&desc.ddpfPixelFormat.dwRBitMask, X8RGB, sizeof(DWORD)*4);
    if (ddraw->CreateSurface(&desc, &output->RGB, nullptr))
    {
        ddraw->Release();
        return 5;
    }
    return 0;
}

extern "C" __declspec(dllexport) const char * __stdcall VlcDDrawPlay(IDirectDrawSurface2 * Prim, RECT* r, char * file)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    static std::string err;
    err.clear();

    LIBVLC_DDRAW_OUTPUT           output;
    LPVOID libvlc              = nullptr;
    LPVOID libvlcMedia         = nullptr;
    LPVOID libvlcPlayer        = nullptr;
    libvlc_media_track_t    ** track, *t;
    UINT  width = 0, height = 0, ntracks;
    UINT InitDDraw                   = 0;
    UINT w = 0;
    UINT h = 0;
    DWORD prev_state = 0;
    DWORD new_state  = 0;

    output.target = Prim;
    memcpy(&output.r, r, sizeof(RECT));

    int init = LibVlc.Init();
    if (init > 0)
    {
        err.append("libvlc initialization failed ");
        err.append( std::to_string(init) );
        return err.c_str();
        //goto VlcDDrawPlayCleanUp;
    }

    char const *vlc_argv[] =  {"--no-audio"};
    int vlc_argc = sizeof(vlc_argv) / sizeof(*vlc_argv);
    libvlc       = LibVlc.libvlc_new(0, 0);
    if (libvlc == nullptr)
    {
        err.append("libvlc_new failed ");
        goto VlcDDrawPlayCleanUp;
    }

    libvlcMedia = LibVlc.libvlc_media_new_path(libvlc, file);
    if (libvlcMedia == nullptr)
    {
        err.append("libvlc_media_new_path failed ");
        goto VlcDDrawPlayCleanUp;
    }

    if (LibVlc.libvlc_parse_media(libvlcMedia) == -1)
    {
        err.append("libvlc_parse_media failed ");
        goto VlcDDrawPlayCleanUp;
    }

    ntracks = LibVlc.libvlc_media_tracks_get(libvlcMedia, &track);
    if (ntracks == 0)
    {
        err.append("libvlc_media_tracks_get failed ");
        goto VlcDDrawPlayCleanUp;
    }

    if (ntracks)
    {
        t = *track;
        for (UINT i=0; i<ntracks; i++)
        {
            if (t->i_type == 1 /*libvlc_track_video*/)
            {
                width  = t->video->i_width;
                height = t->video->i_height;
                OUTPUT_FUNC_DBG_STRING( (std::string("Found ")
                                         + std::to_string(width) + " x " + std::to_string(height)
                                         + " " + t->i_original_fourcc + " Video track").c_str() );
            }
            else if (t->i_type == libvlc_track_audio)
                OUTPUT_FUNC_DBG_STRING( (std::string("Found ") + std::to_string(t->audio->i_channels)
                                         + " channels " + std::to_string(t->audio->i_rate)
                                         + " KHz audio track").c_str() );
            else
                OUTPUT_FUNC_DBG_STRING( (std::string("Found ") + std::to_string(t->i_type) + " id track").c_str() );
            t++;
        }
        LibVlc.libvlc_media_tracks_release(track, ntracks);
    }
    if ( ! (width && height) )
    {
        err.append("No video tracks");
        goto VlcDDrawPlayCleanUp;
    }

    InitDDraw = VlcDDrawPlayer_InitDDraw(&output, width, height);
    if (InitDDraw)
    {
        err.append("VlcDDrawPlayer DirectDraw initialization failed");
        err.append( std::to_string(InitDDraw) );
        goto VlcDDrawPlayCleanUp;
    }

    w = g_d3d.m_WW->Get();
    h = g_d3d.m_HH->Get();
    g_d3d.Setup(g_d3d.HD_W, g_d3d.HD_H, __FUNCTION__);
    libvlcPlayer = LibVlc.libvlc_media_player_from_media(libvlcMedia);
    if (libvlcPlayer == nullptr)
    {
        err.append("libvlc_media_player_from_media failed ");
        goto VlcDDrawPlayCleanUp;
    }
    if (Prim)
    {
        LibVlc.libvlc_video_set_callbacks(libvlcPlayer, VlcDDrawPlayer_Vidlock, VlcDDrawPlayer_VidUnlock, nullptr, &output);
        LibVlc.libvlc_video_set_format(libvlcPlayer, "RV32", width, height, width*4);
    }
    else LibVlc.libvlc_set_fullscreen(libvlcPlayer, 1);
    LibVlc.libvlc_media_player_play(libvlcPlayer);

    prev_state = GetAsyncKeyState(VK_ESCAPE) & 0x0001;
    new_state  = 0;
    Sleep(150);
    while(LibVlc.libvlc_media_player_is_playing(libvlcPlayer))
    {
        Sleep(15);
        new_state = GetAsyncKeyState(VK_ESCAPE) & 0x0001;
        if ( new_state && new_state != prev_state)
        {
            LibVlc.libvlc_media_player_stop(libvlcPlayer);
            g_d3d.Setup(w, h, __FUNCTION__);
            break;
        }
        prev_state = new_state;
    }
    g_d3d.Setup(w, h, __FUNCTION__);

    err.append("Success ");
    err.append(file);
    err.append(" ");
    err.append( std::to_string( (int) ntracks) );
    err.append(" tracks");

    VlcDDrawPlayCleanUp:
    if (libvlcMedia)  LibVlc.libvlc_media_release(libvlcMedia);
    if (libvlcPlayer) LibVlc.libvlc_player_release(libvlcPlayer);
    if (libvlc)       LibVlc.libvlc_release(libvlc);
    return err.c_str();
}

extern "C" __declspec(dllexport) const char* __stdcall VlcPlay(char* file)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    static std::string err;
    err.clear();
    OUTPUT_FUNC_DBG_STRING((std::string("Playing ") + file).c_str());

    LPVOID libvlc                     = nullptr;
    LPVOID libvlcMedia                = nullptr;
    LPVOID libvlcPlayer               = nullptr;
    libvlc_media_track_t** track, * t = nullptr;
    UINT width       = 0;
    UINT height      = 0;
    UINT track_count = 0;   
    DWORD prev_state = 0;
    DWORD new_state  = 0;
    HWND h_VlcWin    = nullptr;   

    int init = LibVlc.Init();
    if (init > 0)
    {
        err.append("libvlc initialization failed ");
        err.append(std::to_string(init));
        return err.c_str();
        goto VlcPlayCleanUp;
    }
    OUTPUT_FUNC_DBG_STRING("LibVlc POITERS INITIALIZED");
    
    libvlc = LibVlc.libvlc_new(0, 0);
    if (libvlc == nullptr)
    {
        err.append("libvlc_new failed ");
        goto VlcPlayCleanUp;
    }
    OUTPUT_FUNC_DBG_STRING("LibVlc OBJECT CREATED");

    libvlcMedia = LibVlc.libvlc_media_new_path(libvlc, file);
    if (libvlcMedia == nullptr)
    {
        err.append("libvlc_media_new_path failed ");
        goto VlcPlayCleanUp;
    }
    OUTPUT_FUNC_DBG_STRING("libvlcMedia OBJECT CREATED");

    if (LibVlc.libvlc_parse_media(libvlcMedia) == -1)
    {
        err.append("libvlc_parse_media failed ");
        goto VlcPlayCleanUp;
    }
    OUTPUT_FUNC_DBG_STRING("MEDIA PARSED");

    track_count = LibVlc.libvlc_media_tracks_get(libvlcMedia, &track);
    if (track_count == 0)
    {
        err.append("libvlc_media_tracks_get failed ");
        goto VlcPlayCleanUp;
    }
    OUTPUT_FUNC_DBG_STRING("libvlc_media_tracks_get OK");

    if (track_count)
    {
        t = *track;
        for (UINT i = 0; i < track_count; i++)
        {
            if (t->i_type == 1 /*libvlc_track_video*/)
            {
                width = t->video->i_width;
                height = t->video->i_height;
                OUTPUT_FUNC_DBG_STRING((std::string("Found ")
                    + std::to_string(width) + " x " + std::to_string(height)
                    + " " + t->i_original_fourcc + " Video track").c_str());
            }
            else if (t->i_type == libvlc_track_audio)
                OUTPUT_FUNC_DBG_STRING((std::string("Found ") + std::to_string(t->audio->i_channels)
                    + " channels " + std::to_string(t->audio->i_rate)
                    + " KHz audio track").c_str());
            else
                OUTPUT_FUNC_DBG_STRING((std::string("Found ") + std::to_string(t->i_type) + " id track").c_str());
            t++;
        }
        LibVlc.libvlc_media_tracks_release(track, track_count);
    }
    else {
        err.append("No video tracks");
        OUTPUT_FUNC_DBG_STRING("NO TRACKS");
        goto VlcPlayCleanUp;
    }

    if (!(width && height))
    {
        err.append("No video tracks");
        OUTPUT_FUNC_DBG_STRING("NO TRACKS");
        goto VlcPlayCleanUp;
    }
      
    libvlcPlayer = LibVlc.libvlc_media_player_from_media(libvlcMedia);
    if (libvlcPlayer == nullptr)
    {
        err.append("libvlc_media_player_from_media failed ");
        goto VlcPlayCleanUp;
    }
    OUTPUT_FUNC_DBG_STRING("MEDIA PLAYER CREATED");

    LibVlc.libvlc_set_fullscreen(libvlcPlayer, 1);
    LibVlc.libvlc_media_player_play(libvlcPlayer);
    OUTPUT_FUNC_DBG_STRING("PLAYNG");

    prev_state = GetAsyncKeyState(VK_ESCAPE) & 0x0001;
    new_state  = 0;
    h_VlcWin   = nullptr;    
    
    Sleep(150);
    while (LibVlc.libvlc_media_player_is_playing(libvlcPlayer))
    {
         
        Sleep(15);
        new_state = GetAsyncKeyState(VK_ESCAPE) & 0x0001;
        if (new_state && new_state != prev_state)
        {
            LibVlc.libvlc_media_player_stop(libvlcPlayer);           
            break;
        }
        prev_state = new_state;
    }   

    OUTPUT_FUNC_DBG_STRING("FINISHED");
    err.append("Success ");
    err.append(file);
    err.append(" ");
    err.append(std::to_string((int)track_count));
    err.append(" tracks");

VlcPlayCleanUp:
    if (libvlcMedia)  LibVlc.libvlc_media_release(libvlcMedia);
    if (libvlcPlayer) LibVlc.libvlc_player_release(libvlcPlayer);
    if (libvlc)       LibVlc.libvlc_release(libvlc);
    return err.c_str();
}
