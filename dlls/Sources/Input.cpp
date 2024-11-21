#include <windows.h>

UINT SendKey(WORD wScan, BOOL Release)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    INPUT Key;
    Key.type       = INPUT_KEYBOARD;
    Key.ki.wVk     = 0;
    Key.ki.wScan   = wScan;
    Key.ki.dwFlags = Release ? KEYEVENTF_SCANCODE | KEYEVENTF_KEYUP : KEYEVENTF_SCANCODE;
    return SendInput(1, &Key, sizeof(INPUT));
}

int GetEvent(UINT key) {
    if (key == 0) return 0;
    SHORT state      = GetAsyncKeyState(key);
    SHORT IsDown     = (state & 0x8000);
    SHORT WasPressed = (state & 0x0001);
    if      (IsDown  && (WasPressed)) {return  1;}
    else if (!IsDown && (WasPressed)) {return -1;}
}
