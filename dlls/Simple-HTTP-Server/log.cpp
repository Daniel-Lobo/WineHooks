#include "headers/log.h"

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
     std::cout << msg << std::endl;
}