#include "headers/log.h"
#include <windows.h>

void Error(const char* msg){
    std::cerr << "[ERROR] " << msg << std::endl;
}

void Warn(const char* msg){
    std::cout << "[WARNING] " << msg << std::endl;
}

void Info(const char* msg){
     std::cout << msg << std::endl;
}

void Info(std::string msg){
    msg += "\n";   
    std::string msg2 = "HTTP_SERVER: " + msg;
    WriteConsoleA(GetStdHandle(STD_OUTPUT_HANDLE), msg2.c_str(), msg2.length(), NULL, NULL);
    std::cout << msg << std::endl;
}