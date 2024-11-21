#ifndef WINMM_HOOKS_H
#define WINMM_HOOKS_H

struct MCINOTIFICATION{
    HANDLE hEvent;
    HWND  hWin;
    DWORD Aborted;
    HWND  hWinA;
    IDirectSoundBuffer * SB;
};

typedef MMRESULT (__stdcall * mixerGetLineInfoAType)(HMIXEROBJ, LPMIXERLINE, DWORD);
typedef MMRESULT (__stdcall * mixerGetLineControlsAType)(HMIXEROBJ, LPMIXERLINECONTROLSA, DWORD);
typedef MMRESULT (__stdcall * mixerSetControlDetailsAType)(HMIXEROBJ, LPMIXERCONTROLDETAILS, DWORD);
typedef MMRESULT (__stdcall * mixerGetControlDetailsAType)(HMIXEROBJ,  LPMIXERCONTROLDETAILS, DWORD);

#endif // WINMM_HOOKS_H
