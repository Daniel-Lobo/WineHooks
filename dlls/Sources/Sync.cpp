#include <windows.h>
#include "Sync.h"
#include <string>
#include <memory>
#include "dllmain.h"

using std::string;
using std::to_string;
using std::unique_ptr;

SYNC::AtomicPtr::AtomicPtr(){
    Set(0);
}

LPVOID SYNC::AtomicPtr::Get(){
#ifdef _WIN64
    return (LPVOID)InterlockedExchangeAdd64((LONGLONG*)&m_lock, 0);
#else
    return (LPVOID)InterlockedExchangeAdd((LONG*)&m_lock, 0);
#endif
}

LPVOID SYNC::AtomicPtr::Set(LPVOID v){
#ifdef _WIN64
    return (LPVOID)InterlockedExchange64((LONGLONG*)&m_lock, (LONGLONG)v);
#else
    return (LPVOID)InterlockedExchange((LONG*)&m_lock, (LONG)v);
#endif
}

SYNC::Atomic::Atomic(){
    Set(0);
}

LONG SYNC::Atomic::Get(){
    return InterlockedExchangeAdd(&m_lock, 0);
}

LONG SYNC::Atomic::Set(LONG v){
    return InterlockedExchange(&m_lock, v);
}

LONG SYNC::Atomic::Increment(){
    return InterlockedIncrement(&m_lock);
}

LONG SYNC::Atomic::Decrement(){
    return InterlockedDecrement(&m_lock);
}

SYNC::WinEvent::WinEvent(void* l)
{
    m_ref   = new SYNC::Atomic();
    m_event = CreateEventA(nullptr, TRUE, FALSE, nullptr);
    m_ref->Set(1);
    if (m_event == nullptr)
    {
        WLoger* L = (WLoger*)l;
        L->dolog(__FUNCTION__, "CreateEventA FAILED");
    }
}

SYNC::WinEvent* SYNC::WinEvent::Get()
{
    m_ref->Increment();
    ResetEvent(m_event);
    return this;
}

void SYNC::WinEvent::Close()
{
    if (m_ref->Decrement() == 0)
    {
        if (nullptr != m_event) CloseHandle(m_event);
        if (nullptr != m_ref)   delete m_ref;
        delete this;
    }
}

DWORD SYNC::WinEvent::Wait(DWORD timeout)
{
    return WaitForSingleObject(m_event, timeout);
}

BOOL SYNC::WinEvent::IsSignaled()
{
    return  WaitForSingleObject(m_event, 0) == WAIT_OBJECT_0 ? TRUE : FALSE;
}

BOOL SYNC::WinEvent::Signal(BOOL state)
{
    return state == TRUE ? SetEvent(m_event) : ResetEvent(m_event);
}

#ifndef USE_MUTEX
SYNC::AtomicLock::AtomicLock(){
    m_WaitingThreadsCount = new Atomic();
}

SYNC::AtomicLock::~AtomicLock(){
    delete m_WaitingThreadsCount;
}

LONG SYNC::AtomicLock::wait(){
    return m_WaitingThreadsCount->Increment();
}

LONG SYNC::AtomicLock::unwait(){
    return m_WaitingThreadsCount->Decrement();
}

LONG SYNC::AtomicLock::_lock(LONG ID)
{
    Set(ID);
    m_LockCount += 1;    
    return ID;
}

LONG SYNC::AtomicLock::lock()
{
    wait();
    LONG ID    = GetCurrentThreadId();
    LONG owner = Get();
    if (!owner)
    {
        if (unwait() > 0) return lock();
        return _lock(ID);
    } else if (owner == (LONG)ID)
    {
        unwait();
        return _lock(ID);
    } else
    {
        while     (owner) owner = Get();
        if (unwait() > 0) return lock();
        return _lock(ID);
    }
    return ID;
}

LONG SYNC::AtomicLock::unlock()
{
    m_LockCount -= 1;
    if (m_LockCount == 0) Set(0);
    return 0;
}
#endif