#include "httplib.h"
#include <windows.h>
#include "EZString.h"
#include "Sync.h"
#include "dllmain.h"

HRESULT __stdcall Serve(LPVOID RequestHandler)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
    SetProcAffinity(nullptr, 1);
    httplib::Server svr;   
    auto lock = new SYNC::AtomicLock();
    svr.set_pre_routing_handler([lock, RequestHandler](const auto& req, auto& res) {         
        const wchar_t * (__stdcall * handler)(const char*) = (decltype(handler))RequestHandler;
        //lock->lock();
        auto reply = handler(req.path.c_str());  
        //lock->unlock();     
        res.set_content(ASCii((wchar_t*) reply).str(), "text/html");
        return httplib::Server::HandlerResponse::Handled;    
        return httplib::Server::HandlerResponse::Unhandled;
    });
    bool listening = svr.listen("127.0.0.1", 5000);
    std::cout << listening << std::endl;
    return listening;   
}