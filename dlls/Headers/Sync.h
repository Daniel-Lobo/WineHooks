#ifndef SYNC_H
#define SYNC_H
#include <windows.h>
#include <mutex>
#include <string>
#include <memory>

using std::string;
using std::unique_ptr;

namespace SYNC {

class AtomicPtr {
public:
    AtomicPtr();
    LPVOID Get();
    LPVOID Set(LPVOID);
    protected:
    volatile LPVOID m_lock;
};

class Atomic {
public:
    Atomic();
    LONG Get();
    LONG Set(LONG);
    LONG Increment();
    LONG Decrement();
    protected:
    volatile LONG m_lock;
};

class AtomicFloat: public Atomic {
public:
    AtomicFloat(float f) {
        Set(f);
    }
    float Get(){
        LONG l = Atomic::Get();
        return *(float*)&l;
    }
    float Set(float f){
        LONG l = Atomic::Set(*(LONG*)&f);
        return *(float*)&l;
    }
    protected:
    volatile LONG m_lock;
};
class BaseLock {
public:
    BaseLock(){}
    ~BaseLock(){}
    virtual LONG  lock() PURE;
    virtual LONG  unlock() PURE;
};

class DummyLock {
public:
    LONG lock()  {return 0;}
    LONG unlock(){return 0;}
};

#define USE_MUTEX
#ifndef USE_MUTEX
class AtomicLock : Atomic, public DummyLock {
public:
    AtomicLock();
    ~AtomicLock();
    LONG  lock();
    LONG  unlock();
private:
    LONG  _lock(LONG);
    LONG  wait();
    LONG  unwait();
    DWORD    m_LockCount       = 0;
    Atomic * m_WaitingThreadsCount;
};
#else
class AtomicLock {
public:
    AtomicLock()  {m_mutex=new std::mutex();}
    ~AtomicLock() {delete m_mutex;          }
    void   lock() {m_mutex->lock();         }
    void unlock() {m_mutex->unlock();       }
    void cpy(void* dst, void* src, size_t sz)
    {
        lock();
        memcpy(dst, src, sz);
        unlock();
    }
private:
    std::mutex * m_mutex = nullptr;
};
#endif

class EasyLock{
public:
    EasyLock(AtomicLock * lock){m_lock=lock; lock->lock();}
    ~EasyLock(){m_lock->unlock();}
    AtomicLock * m_lock;
};

class WinEvent
{
    Atomic * m_ref = nullptr;
    HANDLE m_event = nullptr;
public:
    WinEvent(void*);
    WinEvent *       Get();
    void           Close();
    DWORD      Wait(DWORD);
    BOOL      IsSignaled();
    BOOL      Signal(BOOL);
};


} //Namespace Sync

#endif // SYNC_H
