#include "headers/http_server.h"
#include "headers/log.h"

void parseCommandArgs(ServerConfig& config, int& argc, char* argv[]){
     // Custom port - command line
    if(argc > 1){
        if (std::string(argv[1]) == "-p"){
            config.PORT = std::atoi(argv[2]);
            if (config.PORT == 0){
                Warn("Not a valid port, defaulting back to 8080.");
                config.PORT = 8080;
            }
        }
    }
}

int main(int argc, char* argv[]){
    // Define server configuration and parse command args
    ServerConfig config;
    parseCommandArgs(config, argc, argv);

    // Create server, set static dir and listen for requests
    Server* server = new Server(config);
    server->setStaticDirectory("./public"); 
    server->_listen();
}