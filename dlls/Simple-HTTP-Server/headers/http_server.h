#pragma once
// C++ Libraries
#include <winsock2.h>
#include <unordered_map>
/* Link with Ws2_32.lib - more info..
    Break down of syntax:
    - "comment" - The comment is a pragma directive which can take several arguments.
        We use it to pass lib. 
    - "lib" tells the linker to add a library to the list of libraries to link against.
    - "Ws2_32.lib" is a Windows library for winsock which contains networking functionality
        like 'WSAStartup', 'socket', 'bind', 'listen', 'accept', and others.

    Why add this directive?
        We avoid having to add it when we are compiling on the command line like so:
            g+++ -o program.exe program.cpp /link Ws2_32.lib
        By adding it as a directive internally inside the script.
*/
#pragma comment(lib, "Ws2_32.lib")
// Custom 
#include "utils.h"
#include "log.h"

struct ServerConfig {
    enum AddressFamilies { IPv4 = AF_INET, IPv6 = AF_INET6 };
    enum SocketType { STREAM = SOCK_STREAM, DGRAM = SOCK_DGRAM, RAW = SOCK_RAW, RDM = SOCK_RDM, SEQPACKET = SOCK_SEQPACKET};
    int PORT = 8080;
    int socAF = AddressFamilies::IPv4;
    int socType = SocketType::STREAM;
};

class Server {
public:
    Server(ServerConfig);
    ~Server(){};
private:
    int m_Addrlen;
    sockaddr_in m_Address;
    SOCKET m_ServerFD;
    WSADATA m_wsaData;
    std::string m_StaticDir;
    ServerConfig m_Config;
public:
    /// @brief Defines the static directory for the web app files to exist in.
    /// @param Path the path of the static directory. 
    void setStaticDirectory(std::string);
    void close(std::string reason = "");
    void _listen();
    void (__stdcall *GetHandler)(SOCKET, const char*, const char*)  = nullptr;
    void (__stdcall *PostHandler)(SOCKET, const char*, const char*, const char*) = nullptr;
    BOOL bound = FALSE;
private:
    /// @brief Determine the content type based on the file extension.
    /// @param path path to file.
    /// @return content type.
    std::string getContentType(const std::string& path);
    std::string createHttpResponse(const std::string& body, const std::string& contentType);
    std::string handleGetRequest(const std::string& path, const std::unordered_map<std::string, std::string>& queryParams);
    std::string handlePostRequest(const std::string& path, const std::string& body);
    std::unordered_map<std::string, std::string> parseQueryParams(const std::string& query);
};