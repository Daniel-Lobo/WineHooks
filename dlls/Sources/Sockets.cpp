#include <winsock2.h>
#include <ws2tcpip.h>
#include <vector>
#include "dllmain.h"
#include "sethooks.h"
#include <string>
#include <assert.h>

using std::to_string;
using std::string;


const int32_t COSAC_IV = 512;
const int32_t COSAC_KEY = 512;

class CLegacyCipher
{
public:
	CLegacyCipher()
	{
		BufIV = NULL;
		BufKey = NULL;
		EncryptCounter = 0;
		DecryptCounter = 0;
	}
	~CLegacyCipher()
	{
		if (BufIV != NULL)
			delete[] BufIV;
		if (BufKey != NULL)
			delete[] BufKey;
	}
	void GenerateIV(int32_t P, int32_t G)
	{
		if (BufIV != NULL)
			delete[] BufIV;
		BufIV = new uint8_t[COSAC_IV];
		int16_t K = COSAC_IV / 2;
		uint8_t* pBufPKey = (uint8_t*)&P;
		uint8_t* pBufGKey = (uint8_t*)&G;
		for (int i = 0; i < K; i++)
		{
			BufIV[i + 0] = pBufPKey[0];
			BufIV[i + K] = pBufGKey[0];
			pBufPKey[0] = (int8_t)((pBufPKey[1] + (int8_t)(pBufPKey[0] * pBufPKey[2])) * pBufPKey[0] + pBufPKey[3]);
			pBufGKey[0] = (int8_t)((pBufGKey[1] - (int8_t)(pBufGKey[0] * pBufGKey[2])) * pBufGKey[0] + pBufGKey[3]);
		}
	}
	void Encrypt(uint8_t* pBuf, int32_t Length)
	{
		assert(pBuf != NULL);
		assert(Length > 0);
		int16_t K = COSAC_IV / 2;
		for (int32_t i = 0; i < Length; i++)
		{
			if (BufIV != NULL)
			{
				pBuf[i] ^= (int8_t)(BufIV[(int8_t)(EncryptCounter & 0xFF) + 0]);
				pBuf[i] ^= (int8_t)(BufIV[(int8_t)(EncryptCounter >> 8) + K]);
			}
			pBuf[i] = (int8_t)(pBuf[i] >> 4 | pBuf[i] << 4);
			pBuf[i] ^= (int8_t)0x55;
			EncryptCounter++;
		}
	}
	void Decrypt(uint8_t* pBuf, int32_t Length)
	{
		assert(pBuf != NULL);
		assert(Length > 0);
		int16_t K = COSAC_IV / 2;
		if (BufKey != NULL)
			K = COSAC_KEY / 2;
		for (int32_t i = 0; i < Length; i++)
		{
			pBuf[i] ^= (int8_t)0x55;
			pBuf[i] = (int8_t)(pBuf[i] >> 4 | pBuf[i] << 4);
			if (BufIV != NULL)
			{
				pBuf[i] ^= (int8_t)(BufIV[(int8_t)(DecryptCounter & 0xFF) + 0]);
				pBuf[i] ^= (int8_t)(BufIV[(int8_t)(DecryptCounter >> 8) + K]);
			}
			DecryptCounter++;
		}
	}
	void ResetCounters()
	{
		DecryptCounter = 0;
		EncryptCounter = 0;
	}
	uint8_t* BufIV;
	uint8_t* BufKey;
	uint16_t EncryptCounter;
	uint16_t DecryptCounter;
};

extern "C" __declspec(dllexport) SOCKET* InitClientSocket(char * HOST, char * PORT)
{
	#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	INT failed = -1;
	ADDRINFOA* result = nullptr;
	ADDRINFOA hints;
	ZeroMemory(&hints, sizeof(hints));
	hints.ai_family   = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_protocol = IPPROTO_TCP;

	failed = getaddrinfo(HOST, PORT, &hints, &result);
	if (failed)
	{
		OutputDebugStringA("getaddrinfo failed:");
		WSACleanup();
		return 0;
	}
	return 0;
}

extern "C" __declspec(dllexport) BYTE* TowDecrypt(PBYTE data, int len);
extern "C" __declspec(dllexport) BYTE* TowLegDecrypt(PBYTE data, int len);
int WINAPI tow_recv_hook(SOCKET s, char* buff, int size, int flags);

typedef struct TOWHOOKS {
	int (WINAPI * m_recv)(SOCKET, char*, int, int) = nullptr;
	void Init() {
		GETPROCADDRESS(m_recv, "recv", "Ws2_32.dll");
		HOOK(&m_recv, tow_recv_hook);
	}
};

TOWHOOKS TowHooks;

char* FilterMssg(SOCKET s)
{
	char msg[4096];
	int byte_count =  TowHooks.m_recv(s, msg, sizeof(msg), MSG_PEEK);
	if (byte_count == -1)
	{
		int err = WSAGetLastError();
		if (err == WSAEWOULDBLOCK)
		return msg; // Thats ok, there just isn't any message on the queue
		else OutputDebugStringA((string("Fuck, error: ") + to_string(err)).c_str());
	}
	else if (byte_count == 0)
	{
		OutputDebugStringA("Zero bytes, wtf ??");
	}
	else
	{
		
		DWORD plain_msg               = *(DWORD*)msg;
		DWORD decypehered_message     = *(DWORD*)TowDecrypt((PBYTE)msg, byte_count);
		DWORD leg_decypehered_message = *(DWORD*)TowLegDecrypt((PBYTE)msg, byte_count);
		if (plain_msg == 0xfffffffe || decypehered_message == 0xfffffffe || leg_decypehered_message == 0xfffffffe)
			//OutputDebugStringA("========================================================");
		//OutputDebugStringA((to_string(plain_msg) + " " + to_string(decypehered_message) + " " + to_string(leg_decypehered_message)).c_str());
		
		if (*(WORD*)decypehered_message +2 == (WORD)9902)
		{ 
			OutputDebugStringA("msg");
		
			char* m = msg;
			m += 12;
			OutputDebugStringA(msg);
		}
	}
	return msg;
}

int WINAPI tow_recv_hook(SOCKET s, char* buff, int len, int flags)
{
	static UINT call = 0;
	FilterMssg(s);
	int err = TowHooks.m_recv(s, buff, len, flags);
	return err;
		
	if (err == 8 && call>10)
	{ 
		if (flags & MSG_PEEK) TowHooks.m_recv(s, buff, len, 0);
		err  = TowHooks.m_recv(s, buff, len, flags);
		OutputDebugStringA((string("filtering") + " " + to_string(err) + " " + to_string(WSAGetLastError())).c_str());
	}
	
	if (err > 0)
	{	
		call += 1;
		DWORD type = *(DWORD*) buff;
		DWORD size = *(DWORD*) buff+4;
		OutputDebugStringA((to_string(call) + ": " + to_string(err) + " " + to_string(len) + " " + to_string(type) + " " + to_string(size)).c_str());
		char* decrypted = (char*)TowDecrypt((BYTE*)buff, len);
	    type = *(DWORD*)decrypted;
	    size = *(DWORD*)decrypted + 4;
		//OutputDebugStringA((to_string(call) + ": "+ to_string(err) + " " + to_string(len) + " " + to_string(WSAGetLastError()) + " " + to_string(type)
			//+ " " + to_string(size)).c_str());
	} //else OutputDebugStringA(to_string(err).c_str());
	return err;
}

extern "C" __declspec(dllexport) void __stdcall InitTowHooks()
{
	#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	TowHooks.Init();
}

typedef struct {
	UINT message_type;
	UINT message_size;
	char message[];     //The size of this array is message_size
} packet_format;

extern "C" __declspec(dllexport) BYTE* TowPacket(UINT id, char* message, UINT* size)
{
    #pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	static std::vector<BYTE> packet;
	UINT message_len = strlen(message) + 1;
	*size = 2 * sizeof(UINT) + message_len;
	packet.resize(2 * sizeof(UINT) + message_len);
	packet_format * p = (packet_format*)&packet[0];
	p->message_type = id;
	p->message_size = message_len;
	memcpy(&p->message, message, message_len);
	return &packet[0];
}

static  int TowKeys[] = { 66, 44, 22, 11, 88, 53, 76, 33, 98, 90, 62, 12, 34, 43, 66, 21 };// key length = 16
extern "C" __declspec(dllexport) void TowEncrypt(PBYTE data, int len)
{
	#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	for (int i = 0; i < len; i++)
	{
		data[i] = (BYTE)(data[i] ^ TowKeys[i % 16]);
	}
}

extern "C" __declspec(dllexport) BYTE* TowLegDecrypt(PBYTE data, int len)
{
	#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	static std::vector<BYTE> DecriptedBuffer;
	DecriptedBuffer.resize(len);
	memcpy(&DecriptedBuffer[0], data, len);
	CLegacyCipher().Decrypt(&DecriptedBuffer[0], len);
	return &DecriptedBuffer[0];
}

extern "C" __declspec(dllexport) BYTE * TowDecrypt(PBYTE data, int len)
{
	#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	static std::vector<BYTE> DecriptedBuffer;
	DecriptedBuffer.resize(len);
	for (int i = 0; i < len; i++)
	{
		DecriptedBuffer[i] = (BYTE)(TowKeys[i % 16] ^ data[i]);
	}
	return &DecriptedBuffer[0];
}