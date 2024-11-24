#ifndef LAYERSCOMMON_H
#define LAYERSCOMMON_H
#include <windows.h>
#include <intrin.h>
#include <string.h>
#include "Sync.h"
#include "dllmain.h"
#include <ddraw.h>
#include <memory.h>
using std::to_string;
using std::string;

#define LAYER_PARSE_ERROR(hr) (std::string("FAILED: ")+std::to_string((UINT)hr)).c_str()
#define LAYER_OK "OK =)"

#define LAYER_LOGS
//#define LAYER_VERBOSE_LOGS

#ifndef LAYER_VERBOSE_LOGS
    #define LAYER_HR_CALL(call) HRESULT hr = call; if (FAILED(hr)) DBUG_WARN(LAYER_PARSE_ERROR(hr)) return hr;
#else
    #define LAYER_HR_CALL(call) HRESULT hr = call; if (FAILED(hr)) DBUG_WARN(LAYER_PARSE_ERROR(hr)) else DBUG_WARN(LAYER_OK) return hr;
#endif

#ifdef LAYER_LOGS
    #define LAYER_PROXY_CREATED    DBUG_WARN(std::to_string(g_.layer_objects_count->Increment()).c_str())
    #define LAYER_PROXY_DESTROYDED DBUG_WARN(std::to_string(g_.layer_objects_count->Decrement()).c_str())
    #ifdef _WIN64
        #define LAYER_LOG_CALL         DBUG_WARN(std::to_string((long long)__builtin_return_address(0)).c_str());
        #define LAYER_MEMBER_LOG_CALL   LAYER_LOG_CALL
    #else
        //#define LAYER_LOG_CALL         DBUG_WARN((string("Return adress=[") + to_string((long)__builtin_return_address(0)) + string("]")).c_str())
        #define LAYER_LOG_CALL         DBUG_WARN((string("Return adress=[") + to_string((long)__builtin_return_address(0)) + string("]")).c_str())
        #define LAYER_MEMBER_LOG_CALL  if (this == nullptr)  DBUG_WARN(std::to_string((long)__builtin_return_address(0)).c_str()) \
                                       else DBUG_WARN((string("this=[") + to_string((long)m_Imp) + "] Return adress=[" + std::to_string((long)__builtin_return_address(0))+ string("]")).c_str())
    #endif
#else
    #define LAYER_PROXY_CREATED
    #define LAYER_PROXY_DESTROYDED
    #define LAYER_LOG_CALL
    #define LAYER_MEMBER_LOG_CALL    
#endif

#define D3DSPD_IUNKNOWN   0x00000001L

typedef struct COMPtr {
    LPVOID Vtable;
    LPVOID COMObjct;
};

class IGetImp {
public:
    virtual unique_ptr<EZInterface>GetImp(GUID ID) = 0;
};

/* Objects that encapsulate objects that expose SetPrivateData or SetPrivateDataInterface inherit from this */
class PrivateDataObject /*:virtual public IGetImp*/ {
    public:
    virtual HRESULT STDMETHODCALLTYPE PrivateQueryInterface(REFIID, void**){
       return E_NOINTERFACE;
    }
    virtual ULONG STDMETHODCALLTYPE PrivateAddRef() {
       return m_refcount->Increment();
    }
    virtual ULONG STDMETHODCALLTYPE PrivateRelease(){
        ULONG newref = m_refcount->Decrement();
        if (newref == 0)
        {
            //LAYER_PROXY_DESTROYDED
            delete this; 
        }
        return newref;
    }    
    virtual ~PrivateDataObject(){  
        LAYER_PROXY_DESTROYDED
        delete m_refcount;
    }
    PrivateDataObject(IUnknown * i) {
        LAYER_PROXY_CREATED
        m_refcount = new SYNC::Atomic();
        m_IUnknown = i;
    }        
    /*virtual unique_ptr<EZInterface>GetImp(GUID ID) {
        return unique_ptr<EZInterface>(new EZInterface(ID, m_IUnknown));
    }*/
    SYNC::Atomic  * m_refcount = nullptr;
    IUnknown      * m_IUnknown = nullptr;
};

/* Objects that encapsulate objects which can have references retrived from other 
 * objects that expose SetPrivateData or SetPrivateDataInterface inherit from this */
class PrivateDataObjectParent /*: virtual public IGetImp*/ {
    public:
    virtual HRESULT STDMETHODCALLTYPE PrivateQueryInterface(REFIID, void**){
        return E_NOINTERFACE;
    }
    virtual ULONG STDMETHODCALLTYPE PrivateAddRef() {
       ULONG newref = m_refcount->Increment();       
       return newref;
    }
    virtual ULONG STDMETHODCALLTYPE PrivateRelease(){
        ULONG newref = m_refcount->Decrement();        
        if (newref == 0)
        {            
            delete this;
        }
        return newref;
    }
    virtual ~PrivateDataObjectParent(){     
        LAYER_PROXY_DESTROYDED
    }
    virtual ULONG STDMETHODCALLTYPE PublicAddRef()
    {
        PrivateAddRef();
        return m_IUnknown->AddRef();
    }
    virtual ULONG STDMETHODCALLTYPE PublicRelease()
    {
        ULONG iunknown_ref = m_IUnknown->Release(); 
        ULONG this_ref     = PrivateRelease();
        if      (this_ref == 0 && iunknown_ref > 0) DBUG_WARN("WARNING this_ref == 0, but iunknown_ref > 0")
        else if (this_ref > 0 && iunknown_ref == 0) DBUG_WARN((std::string("WARNING iunknown_ref == 0, but this_ref == ") +std:: to_string(this_ref)).c_str())
        DBUG_LOG(string("IUnknown_ref=" + std::to_string(iunknown_ref) + string(", this_ref=") + std::to_string(this_ref)).c_str())
        return iunknown_ref;
    }     
    PrivateDataObjectParent(IUnknown * i){
        LAYER_PROXY_CREATED
        m_IUnknown = i;
        m_refcount = new SYNC::Atomic();
        m_refcount->Set(1);        
    }
    virtual unique_ptr<EZInterface>GetImp(GUID ID) {
        return unique_ptr<EZInterface>(new EZInterface(ID, m_IUnknown));
    }
    SYNC::Atomic * m_refcount = nullptr;
    IUnknown     * m_IUnknown = nullptr;
};

#define PRIVATEDATAOBJECTIUNKNOWN virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void **ppvObj) ; \
virtual ULONG STDMETHODCALLTYPE AddRef() { return m_IUnknown->AddRef();  }\
virtual ULONG STDMETHODCALLTYPE Release(){ return m_IUnknown->Release(); }

#define PRIVATEDATAOBJECTPARENTIUNKNOWN virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void **ppvObj) ; \
virtual ULONG STDMETHODCALLTYPE AddRef() { return PrivateDataObjectParent::PublicAddRef();   }\
virtual ULONG STDMETHODCALLTYPE Release(){ return PrivateDataObjectParent::PublicRelease();  }

/* Objects that encapsulate objects which cannot have references retrived   
 * from any other object can implement AddRef and Release like this */
#define UNREFDOBJECTIUNKNOWN virtual HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void **ppvObj) ;                   \
virtual ULONG STDMETHODCALLTYPE AddRef() { m_ref->Increment(); return m_Imp->AddRef();                                       }\
virtual ULONG STDMETHODCALLTYPE Release(){ UINT ref = m_Imp->Release(); if (m_ref->Decrement() == 0) delete this; return ref;}
#define UNREFDOBJECTDEL(name) virtual ~name() {delete m_ref;}

#define COM_FOWARD_CALL(method, ...) {                        \
        LAYER_MEMBER_LOG_CALL                                 \
        EZInterface I(LAYER_GUID, m_Imp);                     \
        LAYER_THIS * i = (LAYER_THIS *)I.I();                 \
        if (i == nullptr) DBUG_WARN("QueryInterface FAILED"); \
        LAYER_HR_CALL(i->method(__VA_ARGS__))                 \
        }

#define COM_FOWARD_0(method) STDMETHOD(method)() COM_FOWARD_CALL(method,)
#define COM_FOWARD_1(method, type0) STDMETHOD(method)(type0 arg0) COM_FOWARD_CALL(method,arg0)
#define COM_FOWARD_2(method, type0, type1) STDMETHOD(method)(type0 arg0, type1 arg1) COM_FOWARD_CALL(method,arg0,arg1)
#define COM_FOWARD_3(method, type0, type1, type2) STDMETHOD(method)(type0 arg0, type1 arg1, type2 arg2) COM_FOWARD_CALL(method,arg0,arg1,arg2)
#define COM_FOWARD_4(method, type0, type1, type2, type3) STDMETHOD(method)(type0 arg0, type1 arg1, type2 arg2, type3 arg3) COM_FOWARD_CALL(method,arg0,arg1,arg2,arg3)
#define COM_FOWARD_5(method, type0, type1, type2, type3, type4) STDMETHOD(method)(type0 arg0, type1 arg1, type2 arg2, type3 arg3, type4 arg4) \
COM_FOWARD_CALL(method,arg0,arg1,arg2,arg3,arg4)

#define EXPAND(...) __VA_ARGS__
#define COM_FOWARD(...) EXPAND(COM_FOWARDARG_COUNT(__VA_ARGS__, 5, 4, 3, 2, 1, 0, 0, 0)(__VA_ARGS__))
#define COM_FOWARDARG_COUNT(a1, a2, a3, a4, a5, a6, a7, ...) COM_FOWARD_##a7


#define LAYER_GETIMP(Iterface, err) /*LAYER_LOG_CALL*/                  \
Iterface * imp = (Iterface*)EZInterface(IID_##Iterface, m_Imp).I();     \
if (imp == nullptr)  {DBUG_WARN("EZInterface::I() FAILED"); return err;}; 

#define LAYER_PUBLIC_GETIMP(ID, Class, Object) Object == nullptr ? nullptr : (ID*)dynamic_cast<Class*>(Object)->GetImp(IID_##ID).get()->I()

#define LAYER_COM_CALL(method, ...) {                         \
                                                              \
        EZInterface I(LAYER_GUID, _this->GetImp());           \
        LAYER_THIS * i = (LAYER_THIS *)I.I();                 \
        if (i == nullptr) DBUG_WARN("QueryInterface FAILED"); \
        LAYER_HR_CALL(i->method(__VA_ARGS__))                 \
        }
#ifdef LAYER_LOGS
    #define GET_COM_PTR(type, err) if (ptr == nullptr) {DBUG_WARN("nullptr") return err;} auto _this = (type*)ptr->COMObjct; \
    DBUG_WARN((STR("_this=[")+to_string((long)_this)+"]").c_str())
#else 
    #define GET_COM_PTR(type, err) if (ptr == nullptr) {DBUG_WARN("nullptr") return err;} auto _this = (type*)ptr->COMObjct;
#endif


#endif // LAYERSCOMMON_H
