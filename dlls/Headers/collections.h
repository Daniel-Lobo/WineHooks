#ifndef COLLECTIONS_H
#define COLLECTIONS_H
#include <windows.h>
#pragma once

class POINTER_DICTIONARY {
    public:
    DWORD     count;
    LPVOID *  keys;
    LPVOID *  values;
    //std::map<LPVOID, LPVOID> m_map;
    LPVOID m_map;

    POINTER_DICTIONARY(void);
    virtual DWORD STDMETHODCALLTYPE insert(LPVOID key, LPVOID value);
    virtual DWORD STDMETHODCALLTYPE insert_disposable(LPVOID key, LPVOID value);
    virtual DWORD STDMETHODCALLTYPE remove(LPVOID key);
    virtual DWORD STDMETHODCALLTYPE discard(LPVOID key);
    virtual LPVOID STDMETHODCALLTYPE Value(LPVOID key);
    virtual LPVOID STDMETHODCALLTYPE Key(LPVOID value);
    virtual LPVOID STDMETHODCALLTYPE ValueAt(size_t index);
    virtual LPVOID STDMETHODCALLTYPE KeyAt(size_t index);
    virtual DWORD STDMETHODCALLTYPE Count();
    virtual LPVOID STDMETHODCALLTYPE Data(LPVOID key, DWORD size);
    virtual ~POINTER_DICTIONARY(void);
};

#endif // COLLECTIONS_H

