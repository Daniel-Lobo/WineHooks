#ifndef STRING_HEADER
#define STRING_HEADER
#include <string>
#include <sstream>
#include <locale> 
#include <codecvt>
#include <vector>
#include <memory>

class ASCii
{
public:
	ASCii(wchar_t* unicode_string)
	{
		std::wstring_convert<std::codecvt_utf8<wchar_t>, wchar_t> converter;
		ASCii_string = converter.to_bytes(unicode_string);
	}
	const char* str()
	{
		return ASCii_string.c_str();
	}
	std::string ASCii_string;
};

class HEXString
{
public:
	HEXString(WORD number)  { s << std::hex << number; }
	HEXString(DWORD number) { s << std::hex << number; }
	std::wostringstream s;		
};

class HEXStringA
{
public:
	HEXStringA(WORD number) { s << std::hex << number; }
	HEXStringA(DWORD number) { s << std::hex << number; }
	std::ostringstream s;
};

extern std::unique_ptr<std::vector<std::string>>SplitrString(char *, char *);
extern std::unique_ptr<std::string> ReplaceAll(char *, char *, char *);
#endif // STRINGS_HEADER
