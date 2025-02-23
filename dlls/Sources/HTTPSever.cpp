#include "httplib.h"
#include <windows.h>
#include "EZString.h"
#include "Sync.h"
#include "dllmain.h"
#include "headers/http_server.h"

/*
extern "C" __declspec(dllexport) HRESULT __stdcall Serve(LPVOID RequestHandler)
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
*/

class PexHTTPServer: public Server{
public:
    PexHTTPServer(ServerConfig config) : Server(config) {};
};

extern "C" __declspec(dllexport) void __stdcall Serve(LPVOID GETHandler, LPVOID PostHandler)
{
    /*
    ServerConfig config;
    config.PORT = 5000;  

    
    auto server = new PexHTTPServer(config);
    server->GetHandler  = decltype(server->GetHandler)(GETHandler);
    server->PostHandler = decltype(server->PostHandler)(PostHandler);
    server->setStaticDirectory("..\\"); 
    server->_listen();
    */

    
    ServerConfig config;
    PexHTTPServer * server = nullptr;
    for (int i = 3000; i < 8000; i++) {    
        config.PORT = i;
        server = new PexHTTPServer(config);
        if (server->bound == FALSE){
            delete server;      
            server = nullptr;      
            continue;
        }
        break;;
    }
    if (server == nullptr){
        MessageBoxA(NULL, "Could not find a port on localhost", "", MB_ICONERROR|MB_OK);
        ExitProcess(1);
    }
    server->GetHandler  = decltype(server->GetHandler)(GETHandler);
    server->PostHandler = decltype(server->PostHandler)(PostHandler);
    server->setStaticDirectory("..\\"); 
    server->_listen();
    delete server;    
    
}
    
