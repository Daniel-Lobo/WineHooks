#include <windows.h>
#include <string.h>
#include <memory.h>
#include <vector>
#include "EZString.h"
using std::string;
using std::wstring;
using std::to_string;
using std::to_wstring;
using std::unique_ptr;
using std::vector;

unique_ptr<vector<string>>SplitrString(char * str, char * delimiter)
{
    auto split   = new vector<string>();
    string src   = str;
    string delim = delimiter;
    size_t start = 0;
    size_t end   = src.find(delimiter);
    if (end == std::string::npos)
    {
        split->push_back(src);
        return unique_ptr<vector<string>>(split);
    }
    while (end != std::string::npos)
    {        
        split->push_back(src.substr(start, end - start));
        start = end + delim.length();
        end   = src.find(delim, start);
    }
    if (start <= src.length())
        split->push_back(src.substr(start, src.length() - start));
    return unique_ptr<vector<string>>(split);   
}

unique_ptr<string> ReplaceAll(char * str, char * from, char * to)
{
    string* result = new string();
    string src   = str;     
    string delim = from;
    size_t start = 0;
    size_t end   = src.find(from);
    if (end == std::string::npos)
    {        
        *result += src;
        return unique_ptr<string>(result);
    }
    while (end != std::string::npos)
    {        
        *result += src.substr(start, end - start) + to;     
        start = end + delim.length();
        end   = src.find(delim, start);  
    }
    if (start <= src.length())
    {
        *result += src.substr(start, src.length() - start);
    }
    return unique_ptr<string>(result);
}

