#include "headers/http_server.h"

// PUBLIC

Server::Server(ServerConfig config) : m_Config(config) {
    /* Struct from winsock to hold information about Windows Sockets
        What is the function, WSAStartup?
        It is a function that initializes the Winsock library. 
        This function must be called before any other Winsock functions 
        can be used. It is responsible for setting up the necessary data 
        structures and preparing the network stack for use.

        First Arg(WinSock Version): 
        MAKEWORD is a macro that combines two single-byte values 
        into a single WORD (a 16-bit value). 
        MAKEWORD(2, 2): This macro call constructs a version number for Winsock. 
        The first 2 is the major version number, and the second 2 is the minor 
        version number. So, MAKEWORD(2, 2) represents version 2.2 of the Winsock API.

        Second Arg(struct):
        &wsaData: A pointer to the WSADATA structure that will receive information 
        about the Winsock implementation.
    */
    if(WSAStartup(MAKEWORD(2,2), &m_wsaData) != 0){
        Error("WSA initialization failed.");
    }

    /* Socket explained..
        - SOCKET is a type integer enum  to describe the type of socket returned.
        
        - socket function creates a new socket and returns a descriptor 
        (a SOCKET type in Winsock) that can be used to reference the socket 
        in subsequent network operations. 
        
        - AF_INET is an address family that specifies the type of addresses 
        that the socket can communicate with. AF_INET stands for IPv4 
        (Internet Protocol version 4). This means the socket will use IPv4 addresses.
        
        - SOCK_STREAM is a type of socket that provides sequenced, reliable, two-way, 
        connection-based byte streams. This type of socket uses the Transmission Control 
        Protocol (TCP), which ensures data is delivered in order and without errors. 

        The third parameter, protocol, specifies the protocol to be used with the socket. 
        When the protocol is set to 0, the system chooses the default protocol for the 
        given socket type. For SOCK_STREAM, the default protocol is TCP.
    */
    m_ServerFD = socket(config.socAF, config.socType, 0);
    if (m_ServerFD == INVALID_SOCKET){
        close("Socket creation failed.");
    }

    /* Address Struct
    
        - sockaddr_in structure is used to specify an address for the socket in 
        the Internet domain (IPv4). This structure is defined in the <winsock2.h> 
        header and contains several fields.

        - int addrlen = sizeof(address); - This line initializes the variable addrlen 
        to the size of the sockaddr_in structure. This is often used when calling 
        functions that require the size of the address structure.

        - address.sin_family = AF_INET; 
            sin_family: This field specifies the address family.
            AF_INET: This constant indicates that the address family is IPv4.

        - address.sin_addr.S_un.S_addr = INADDR_ANY;
            - sin_addr: This field is a structure within the sockaddr_in structure that 
            contains the IP address of the socket.
            - S_un.S_addr: This is the specific field within sin_addr where the IP address 
            is stored in network byte order.
            - INADDR_ANY: This constant allows the socket to be bound to all available 
            interfaces. It means that the socket will accept connections from any network 
            interface on the machine. 

        - address.sin_port = htons(PORT);
            - sin_port: This field specifies the port number for the socket. It must be in 
            network byte order.
            - htons(PORT): The htons (host-to-network short) function converts the port 
            number from host byte order to network byte order. Network byte order is 
            big-endian, while host byte order can be either big-endian or little-endian, 
            depending on the architecture.

    */
    m_Addrlen = sizeof(m_Address);
    m_Address.sin_family = AF_INET;
    m_Address.sin_addr.S_un.S_addr = INADDR_ANY;
    m_Address.sin_port = htons(config.PORT); // port num

    if(bind(m_ServerFD, (struct  sockaddr*)&m_Address, m_Addrlen) == SOCKET_ERROR)
    {
        close("Bind failed.");
    };
    bound = TRUE;

    if (listen(m_ServerFD, 3) == SOCKET_ERROR){
        close("Listen failed.");
    }

    Info("Server is listening on port " + std::to_string(config.PORT));

}

void Server::setStaticDirectory(std::string path){
    m_StaticDir = path;
}

std::string ParseArgs(std::unordered_map<std::string, std::string>& queryParams){
    // Convert the map to a string in the format key=value&key=value
    std::string args = "";
    for (const auto& param : queryParams) {
        args += param.first + "=" + param.second + "&";
    }
    return args;
}

std::string GetPostBody(std::vector<std::string> lines, char buffer[20480]){
    int content_length = 0;
    for (const auto& line : lines) {
        std::string lower_line = toLower(line); // force to lower case to ensure no case sensitive issues
        if (lower_line.find("content-length:") != std::string::npos) {
            std::vector<std::string> parts = split(line, ' ');
            if (parts.size() == 2) {
                content_length = std::stoi(parts[1]);
            }
        }
    }

    if (content_length > 0) {
        size_t header_end = std::string(buffer).find("\r\n\r\n");
        if (header_end != std::string::npos) {
            std::string body(buffer + header_end + 4, content_length);  
            return body;          
        } else {
            std::string dummy = "";
            return dummy;
        }
    }
}

void Server::_listen(){
    std::string utl = "http://localhost:" + std::to_string(m_Config.PORT);
    if (bound) 
    ShellExecuteA(NULL, "open", utl.c_str(), NULL, NULL, SW_SHOWNORMAL);
    // For now, just keep the server running indefinitely
    while (true) {
         // Accept incoming connection.
        SOCKET client_fd = accept(m_ServerFD, (struct sockaddr*)&m_Address, &m_Addrlen);
        if (client_fd == INVALID_SOCKET) {
            close("Accept failed.");
            return;
        }        

        // Read the HTTP request from the client.
        char buffer[20480] = {0};
        int bytes_received = recv(client_fd, buffer, sizeof(buffer) - 1, 0);
        if (bytes_received < 0) {
            Error("Receive failed.");
        } else {

            // Split the request into lines.
            std::vector<std::string> lines = split(buffer, '\n');
            if (lines.size() > 0) {
                // Parse the request line.
                std::vector<std::string> request_line = split(lines[0], ' ');
                if (request_line.size() == 3) {
                    std::string method = request_line[0];
                    std::string full_path = request_line[1];
                    std::string http_version = request_line[2];
                    std::string path = full_path;
                    std::string response = "";

                    // Query parser
                    std::unordered_map<std::string, std::string> queryParams;
                    size_t query_start = full_path.find("?");
                    if (query_start != std::string::npos) {
                        path = full_path.substr(0, query_start);
                        std::string query_string = full_path.substr(query_start + 1);
                        queryParams = parseQueryParams(query_string);
                    }

                    Info("Method: " + method);
                    Info("Path: " + path);
                    Info("HTTP Version: " + http_version);

                    try
                    {
                        if (method == "GET") {
                            response = ""; 
                            GetHandler(client_fd, path.c_str(), ParseArgs(queryParams).c_str());
                        } else if (method == "POST") {
                            response = ""; 
                            PostHandler(client_fd, path.c_str(), ParseArgs(queryParams).c_str(), GetPostBody(lines, buffer).c_str());
                            /*
                            // Find Content-Length header
                            int content_length = 0;
                            for (const auto& line : lines) {
                                std::string lower_line = toLower(line); // force to lower case to ensure no case sensitive issues
                                if (lower_line.find("content-length:") != std::string::npos) {
                                    std::vector<std::string> parts = split(line, ' ');
                                    if (parts.size() == 2) {
                                        content_length = std::stoi(parts[1]);
                                    }
                                }
                            }

                            if (content_length > 0) {
                                size_t header_end = std::string(buffer).find("\r\n\r\n");
                                if (header_end != std::string::npos) {
                                    std::string body(buffer + header_end + 4, content_length);
                                    response = handlePostRequest(path, body);
                                } else {
                                    Error("Failed to find end of headers.");
                                    response = createHttpResponse("400 Bad Request", "text/plain");
                                }
                                    
                            } else {
                                Error("Content-Length is 0 or not found.");
                                response = createHttpResponse("400 Bad Request", "text/plain");
                            }
                            */

                        } else {
                            std::string body = "<html><body><h1>405 Method Not Allowed</h1></body></html>";
                            response = createHttpResponse(body, "text/html");
                        }
                    }
                    catch(const std::exception& e)
                    {
                        std::cerr << e.what() << '\n';
                    }
                    
                    if(response != ""){
                        int bytes_sent = send(client_fd, response.c_str(), response.size(), 0);
                        if (bytes_sent < 0) {
                            Error("Send failed.");
                        }
                    }
                }
                
            }
        }

        // Close the client connection
        closesocket(client_fd);
    }
    close();
}

void Server::close(std::string reason){
    if (reason != ""){
        Error(reason.c_str());
    }
    if (m_ServerFD != INVALID_SOCKET){
        closesocket(m_ServerFD);
    }
    WSACleanup();
}

// PRIVATE

std::string Server::getContentType(const std::string& path) {
    if (path.find(".html") != std::string::npos) {
        return "text/html";
    } else if (path.find(".css") != std::string::npos) {
        return "text/css";
    } else if (path.find(".js") != std::string::npos) {
        return "application/javascript";
    } else if (path.find(".jpg") != std::string::npos) {
        return "image/jpeg";
    } else if (path.find(".png") != std::string::npos) {
        return "image/png";
    } else {
        return "text/plain";
    }
}

std::string Server::createHttpResponse(const std::string& body, const std::string& contentType) {
    std::string response;
    response += "HTTP/1.1 200 OK\r\n";
    response += "Content-Type: " + contentType + "\r\n";
    response += "Content-Length: " + std::to_string(body.size()) + "\r\n";
    response += "\r\n";
    response += body;
    return response;
}

std::string Server::handleGetRequest(const std::string& path, const std::unordered_map<std::string, std::string>& queryParams) {
    std::string staticDir = "./";
    std::string filePath = staticDir + path;

    // Read file content if it exists
    std::string fileContent = readFile(filePath);
    if (!fileContent.empty()) {
        std::string contentType = getContentType(path);
        return createHttpResponse(fileContent, contentType);
    } else if (path == "/") {
        std::string indexFileContent = readFile(staticDir + "/index.html");
        if (indexFileContent.empty()){
            throw std::runtime_error("Could not find index.html @ /public - it is required for home path, /");
        }
        return createHttpResponse(indexFileContent, "text/html");
    } 
    else if (path == "/echo") {
        std::string body = "<html><body><h1>Query Parameters:</h1><ul>";
        for (const auto& param : queryParams) {
            body += "<li>" + param.first + ": " + param.second + "</li>";
        }
        body += "</ul></body></html>";
        return createHttpResponse(body, "text/html");
    } 
    else if (path == "/welcome") {
        std::string body = "<html><body><h1>Welcome to my server!</h1></body></html>";
        return createHttpResponse(body, "text/html");
    } else {
        std::string body = "<html><body><h1>404 Not Found</h1></body></html>";
        return createHttpResponse(body, "text/html");
    }
}

std::string Server::handlePostRequest(const std::string& path, const std::string& body) {
    // Simple echo back for demonstration
    std::string responseBody = "Received POST data:\n" + body;
    return createHttpResponse(responseBody, "application/json");
}

std::unordered_map<std::string, std::string> Server::parseQueryParams(const std::string& query) {
    std::unordered_map<std::string, std::string> params;
    std::vector<std::string> pairs = split(query, '&');
    for (const std::string& pair : pairs) {
        std::vector<std::string> keyValue = split(pair, '=');
        if (keyValue.size() == 2) {
            params[keyValue[0]] = keyValue[1];
        }
    }
    return params;
}
