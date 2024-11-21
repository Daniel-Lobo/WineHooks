#ifndef DBUG_H
#define DBUG_H
#include <windows.h>

extern void OutPutFuncDbgString(const char *, const char *);
#define OUTPUT_FUNC_DBG_STRING(string) OutPutFuncDbgString(__FUNCTION__, string)
#define LOG_NOT_IMPLEMENTED() OutPutFuncDbgString(__FUNCTION__, "NOT IMPLEMENTED"); return E_NOTIMPL
#define DBUG_LOG(string)  g_.loger.log(__FUNCTION__, string);
#define DBUG_WARN(string) g_.loger.dolog(__FUNCTION__, string);
//#define DBUG_LOG(string) ;
//#define DBUG_WARN(string) ;
#define DBUG_HR(call, ...) if ( FAILED(call) ) {DBUG_WARN(#call " FAILED") __VA_ARGS__}
#define STR(s) *(std::unique_ptr<string>(new string(s)).get())
#endif // DBUG_H
