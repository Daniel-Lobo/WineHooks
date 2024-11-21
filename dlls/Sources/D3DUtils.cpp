#include <windows.h>
#include <ddraw.h>
//#include <d3d.h>
#include <string>
#include <memory.h>
#include <ddraw.h>
#include "D3DHooks.h"
#include "dllmain.h"
#include "DirectDraw.h"
#include "Dbug.h"
#include "Input.h"

#include "D3D12Hooks.h"
#include "EZString.h"
#include "DDSurface.h"
#include "xbrz.h"
#include <math.h>

using std::string;
using std::wstring;
using std::to_wstring;
using std::to_string;

unique_ptr<EZInterface> DDInterfaceFromSurface(IUnknown* t1)
{
	IDirectDraw         * dd      = nullptr;
	IUnknown            * Unknown = nullptr;
	IDirectDrawSurface2 * s2      = nullptr;

	if (S_OK != t1->QueryInterface(IID_IDirectDrawSurface2, (void**)&s2))
	return 0;

	s2->Release();
	if (S_OK != s2->GetDDInterface((void**)&Unknown))
	return nullptr;

	Unknown->Release();
	if (S_OK != Unknown->QueryInterface(IID_IDirectDraw, (void**)&dd))
	return nullptr;

	auto ez = unique_ptr<EZInterface>(new EZInterface(IID_IDirectDraw, dd));
	dd->Release();
	return ez;
}

unique_ptr<string>DDrawCreateSurfacefromSurface(DirectDrawSurface* srfc, IUnknown** newsrfc, DWORD caps, char* fmt)
{
	auto isrfc = (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, srfc->GetImp()).I();
	if (isrfc == nullptr)
	{
		return unique_ptr<string>(new string("no surface"));
	}
	auto ezdd = DDInterfaceFromSurface(isrfc);
	if (ezdd == nullptr)
	{
		return unique_ptr<string>(new string("DDInterfaceFromSurface FAILED"));
	}
	auto dd = (IDirectDraw*)EZInterface(IID_IDirectDraw, (IUnknown*)ezdd.get()->I()).I();
	if (dd == nullptr)
	{
		return unique_ptr<string>(new string("No DirectDraw"));
	}
	auto desc                  = srfc->GetDesc();
	desc.get()->dwSize         = sizeof(DDSURFACEDESC);
	desc.get()->dwFlags        = DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH | DDSD_PIXELFORMAT;
	desc.get()->ddsCaps.dwCaps = caps;
	if (*(DWORD*)fmt != *(DWORD*)"SAME") {
		SetDDSurfacePixelFormat(&desc.get()->ddpfPixelFormat, (char*)fmt);
	}
	if (S_OK != dd->CreateSurface((DDSURFACEDESC*)desc.get(), (IDirectDrawSurface**)newsrfc, nullptr))
	{
		return unique_ptr<string>(new string("::CreateSurface FAILED"));
	}
	return unique_ptr<string>(new string("S_OK"));
}

unique_ptr<string>DDrawLoadSurface(DirectDrawSurface* srfc, IUnknown** newsrfc, const char* file)
{
	char                           fmt[20];
	HANDLE                           hFile;
	DWORD                magic, read, w, h;
	BOOL                                 b;
	DDS_HEADER                  DDS_Header;	
	DWORD                  bytes_per_pixel;	
	IDirectDrawSurface* nextlvl  = nullptr;
	IDirectDrawSurface* currlvl  = nullptr;
	IDirectDrawSurface* sys      = nullptr;
	IDirectDrawSurface* snextlvl = nullptr;
	IDirectDrawSurface* scurrlvl = nullptr;

	auto isrfc = (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, srfc->GetImp()).I();
	if (isrfc == nullptr)
	{
		return unique_ptr<string>(new string("no surface"));
	}
	auto ezdd = DDInterfaceFromSurface(isrfc);
	if (ezdd == nullptr)
	{
		return unique_ptr<string>(new string("DDInterfaceFromSurface FAILED"));
	}
	auto dd4 = (IDirectDraw*)EZInterface(IID_IDirectDraw, (IUnknown*)ezdd.get()->I()).I();
	if (dd4 == nullptr)
	{
		return unique_ptr<string>(new string("No DirectDraw 4"));
	}

	hFile = CreateFileA(file, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
			OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE)
	{		
		hFile = CreateFileA(g_.m_FallBackTextureReplacement.c_str(), GENERIC_READ,
			FILE_SHARE_READ | FILE_SHARE_WRITE,
			NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
		if (hFile == INVALID_HANDLE_VALUE) 
			return unique_ptr<string>(new string("Can't open file"));
	}

	b = ReadFile(hFile, &magic, 4, &read, NULL);
	if ((!b) || (magic != 0x20534444))
	{
		CloseHandle(hFile);
		return unique_ptr<string>(new string("Not a DDS File")); 
	}
	b = ReadFile(hFile, &DDS_Header, sizeof(DDS_HEADER), &read, NULL);
	if ((!b) || (magic != 0x20534444))
	{
		CloseHandle(hFile);
		return unique_ptr<string>(new string("Failed to read file header")); 
	}
	GetDDSFileFormat(&DDS_Header, fmt);	
	if (std::string(fmt) == "Unsupported format") return unique_ptr<string>(new string("Unsupported format"));

	DDSURFACEDESC desc  = {};
	desc.dwSize          = sizeof(DDSURFACEDESC);
	desc.dwFlags         = DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH | DDSD_PIXELFORMAT;
	desc.dwWidth         = DDS_Header.dwWidth;
	desc.dwHeight        = DDS_Header.dwHeight;
	desc.ddsCaps         = {DDSCAPS_TEXTURE| DDSCAPS_VIDEOMEMORY};
	if (DDS_Header.dwFlags & DDSD_MIPMAPCOUNT)
	{
		//desc.dwFlags		|= DDSD_MIPMAPCOUNT;
		desc.ddsCaps.dwCaps |= DDSCAPS_COMPLEX | DDSCAPS_MIPMAP;
		//desc.dwMipMapCount   = DDS_Header.dwMipMapCount;
	}
	SetDDSurfacePixelFormat(&desc.ddpfPixelFormat, fmt);
	if (S_OK != dd4->CreateSurface(&desc, (IDirectDrawSurface**)newsrfc, nullptr))
	{
		desc.ddsCaps = {DDSCAPS_TEXTURE | DDSCAPS_VIDEOMEMORY};
		DDS_Header.dwFlags &= ~DDSD_MIPMAPCOUNT;
		if (S_OK != dd4->CreateSurface(&desc, (IDirectDrawSurface**)newsrfc, nullptr))
		return unique_ptr<string>(new string("CreateSurface failed"));
	}
	desc.dwSize          = sizeof(DDSURFACEDESC);
	desc.dwFlags         = DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH | DDSD_PIXELFORMAT;
	desc.dwWidth         = DDS_Header.dwWidth;
	desc.dwHeight        = DDS_Header.dwHeight;
	desc.ddsCaps         = {DDSCAPS_TEXTURE|DDSCAPS_SYSTEMMEMORY};
	if (DDS_Header.dwFlags & DDSD_MIPMAPCOUNT)
	{
		//desc.dwFlags        |= DDSD_MIPMAPCOUNT;
		desc.ddsCaps.dwCaps |= DDSCAPS_COMPLEX | DDSCAPS_MIPMAP;
		//desc.dwMipMapCount   = DDS_Header.dwMipMapCount;
	}
	SetDDSurfacePixelFormat(&desc.ddpfPixelFormat, fmt);
	if (S_OK != dd4->CreateSurface(&desc, &sys, nullptr))
	{
		(*newsrfc)->Release();
		*newsrfc = nullptr;
		return unique_ptr<string>(new string("CreateSurface [system] failed"));
	}

	w = DDS_Header.dwWidth;
	if (*(BYTE*)fmt == *(BYTE*)"D")
	{
		bytes_per_pixel = *(DWORD*)fmt == *(DWORD*)"DXT1" ? 2 : 4;
		h               = (DDS_Header.dwHeight + 3) / 4;
	}
	else {
		bytes_per_pixel = DDS_Header.ddspf.dwRGBBitCount / 8;
		h               = DDS_Header.dwHeight;
	}
	DDSURFACEDESC dsc2 = {sizeof(DDSURFACEDESC)};
	if (S_OK != sys->Lock(nullptr, &dsc2, DDLOCK_SURFACEMEMORYPTR|DDLOCK_WAIT, nullptr))
	{
		sys->Release();
		(*newsrfc)->Release();
		*newsrfc = nullptr;
		CloseHandle(hFile);
		return unique_ptr<string>(new string("::Lock FAILED"));
	}
	if (*(BYTE*)fmt == *(BYTE*)"D") {
		if (0 == ReadFile(hFile, dsc2.lpSurface, dsc2.dwLinearSize, &read, NULL)) {DBUG_WARN("ReadFile FAILED")};
	} else LoadData2Surface(dsc2.lpSurface, (UINT)hFile, (UINT)dsc2.lPitch, w, h, bytes_per_pixel);
	sys->Unlock(nullptr);

	DDBLTFX fx = {};
	fx.dwSize   = sizeof(DDBLTFX);
	((IDirectDrawSurface*)(*newsrfc))->Blt(nullptr, sys, nullptr, DDBLT_WAIT, &fx);

    currlvl                  = (IDirectDrawSurface *)*newsrfc;
	scurrlvl                 = sys;
	DDSCAPS attachment_caps = {DDSCAPS_MIPMAP};
	currlvl->AddRef();
	scurrlvl->AddRef();;
	while ((S_OK ==  currlvl->GetAttachedSurface(&attachment_caps,  &nextlvl))  && 
		   (S_OK == scurrlvl->GetAttachedSurface(&attachment_caps, &snextlvl)))
	{
		w /= 2;
		h /= 2;
		if (S_OK != snextlvl->Lock(nullptr, &dsc2, DDLOCK_SURFACEMEMORYPTR|DDLOCK_WAIT, nullptr))
		{
			return unique_ptr<string>(new string("::Lock on sublevel FAILED"));
		}
		if (*(BYTE*)fmt == *(BYTE*)"D") {
			if (0 == ReadFile(hFile, dsc2.lpSurface, dsc2.dwLinearSize, &read, NULL)) {DBUG_WARN("ReadFile FAILED")};
		} else LoadData2Surface(dsc2.lpSurface, (UINT)hFile, (UINT)dsc2.lPitch, w, h, bytes_per_pixel);

		snextlvl->Unlock(nullptr);
		nextlvl->Blt(nullptr, snextlvl, nullptr, DDBLT_WAIT, &fx);
		
		scurrlvl->Release();
		scurrlvl = snextlvl;
		
		currlvl->Release();
		currlvl  = nextlvl;
	}
	currlvl->Release();
	scurrlvl->Release();
	sys->Release();
	CloseHandle(hFile);
	return unique_ptr<string>(new string("S_OK"));
}

unique_ptr<wstring> DDWriteOnSurface(IDirectDrawSurface* srfc, DWORD srfc_width, DWORD text_area_L, wchar_t* text) {
	auto err = unique_ptr<wstring>(new wstring(L"Success"));
	if (srfc == nullptr) {
		*err.get() = L"nullptr";
		return err;
	}
	auto ezdd = DDInterfaceFromSurface(srfc);
	if (nullptr == ezdd) {
		*err.get() = L"DDFromTexture FAILED";
		return err;
	}
	auto dd = (IDirectDraw*)ezdd.get()->I();		
	auto ez = EZInterface(IID_IDirectDraw4, dd);
	if (ez.I() == nullptr) {
		*err.get() = L"QueryInterface(IID_IDirectDraw4...) FAILED";
		return err;
	}

	UINT offset = srfc_width / 2 - text_area_L;
	RECT rect   = {offset, 0, offset + text_area_L, text_area_L };
	DWORD ww    = rect.right  - rect.left;
	DWORD hh    = rect.bottom - rect.top;

	DDSURFACEDESC2 desc = {};
	desc.dwSize   = sizeof(DDSURFACEDESC2);
	desc.dwFlags  = DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH | DDSD_PIXELFORMAT;;
	desc.dwWidth  = ww;
	desc.dwHeight = hh;
	desc.ddsCaps  = { DDSCAPS_VIDEOMEMORY };
	SetDDSurfacePixelFormat(&desc.ddpfPixelFormat, "X8RGB");
	IDirectDrawSurface4* s4 = nullptr;
	if (S_OK != ((IDirectDraw4*)ez.I())->CreateSurface(&desc, &s4, nullptr)) {
		*err.get() = L"CreateSurface FAILED";
		return err;
	}
	
	DDBLTFX fx = {};
	fx.dwSize = sizeof(DDBLTFX);
	((IDirectDrawSurface*)s4)->Blt(nullptr, nullptr, nullptr, DDBLT_COLORFILL, &fx);

	HDC hDC = nullptr;
	if (S_OK != s4->GetDC(&hDC)) {
		s4->Release();
		*err.get() = L"CreateSurface FAILED";
		return err;
	}
	HBITMAP hBmp = CreateCompatibleBitmap(hDC, ww, hh);
	if (nullptr == hBmp){
		s4->Release();
		*err.get() = L"CreateCompatibleBitmap FAILED";
		return err;
	}
	RECT txt_rect = {0, 0, ww, hh};
	SelectObject(hDC, hBmp);
	SetBkMode(hDC, OPAQUE);
	SetBkColor(hDC, 0x00010101);
	SetTextColor(hDC, 0x00ffffff);
	DPtoLP(hDC, (LPPOINT)&rect, 2);
	DrawTextW(hDC, text, -1, &txt_rect, DT_NOCLIP|DT_WORDBREAK);
	s4->ReleaseDC(hDC);
	DeleteObject(hBmp);
	
	if (S_OK  != srfc->Blt(&rect, (IDirectDrawSurface*)s4, nullptr, DDBLT_WAIT|DDBLT_KEYSRCOVERRIDE, &fx)) {
		s4->Release();
		*err.get() = L"Blt FAILED";
		return err;
	}
	s4->Release();
	*err.get() = L"OK";
	return err;
}

HRESULT blt(IDirectDrawSurface* dst, DirectDrawSurface* src, DWORD src_width, DWORD size)
{
	IDirectDrawSurface* i_src = (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, src->GetImp()).I();
	UINT offset = src_width / 2;
	RECT rect   = {offset, 0, offset + size, size};

	DDBLTFX fx = {};
	fx.dwSize  = sizeof(DDBLTFX);

	auto src_desc = src->GetDesc();
	if (src_desc.get()->ddsCaps.dwCaps & DDSCAPS_VIDEOMEMORY)
	return dst->Blt(&rect, i_src, nullptr, 0, &fx);
	
	auto ezdd = DDInterfaceFromSurface(i_src);
	if (nullptr == ezdd) {
		return 3;
	}
	auto dd = (IDirectDraw*)ezdd.get()->I();	
	auto ez = EZInterface(IID_IDirectDraw4, dd);
	if (ez.I() == nullptr) {			
		return 2;
	}
		
	DDSURFACEDESC2 desc = {};
	desc.dwSize         = sizeof(DDSURFACEDESC2);
	desc.dwFlags        = DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH | DDSD_PIXELFORMAT;;
	desc.dwWidth        = src_desc.get()->dwWidth;
	desc.dwHeight       = src_desc.get()->dwHeight;
	desc.ddsCaps        = {DDSCAPS_VIDEOMEMORY};
	SetDDSurfacePixelFormat(&desc.ddpfPixelFormat, "X8RGB");
	IDirectDrawSurface4* s4 = nullptr;
	if (S_OK != ((IDirectDraw4*)ez.I())->CreateSurface(&desc, &s4, nullptr)) return 3;
	s4->Blt(nullptr, (IDirectDrawSurface4*)i_src, nullptr, DDBLT_WAIT, &fx);
	HRESULT blt = dst->Blt(&rect, (IDirectDrawSurface*)s4, nullptr, 0, &fx);
	s4->Release();
	return blt;
}

unique_ptr<wstring> DescribeDDSrfcPixelFormat(DDPIXELFORMAT * fmt)
{
	auto fmt_string   = unique_ptr<wstring>(new wstring());
	*fmt_string.get() = L"?????";
	if (fmt->dwFlags & DDPF_FOURCC)
	{
		if      (fmt->dwFourCC == MAKEFOURCC('D', 'X', 'T', '1')) *fmt_string.get() = L"DXT1";
		else if (fmt->dwFourCC == MAKEFOURCC('D', 'X', 'T', '2')) *fmt_string.get() = L"DXT2";
		else if (fmt->dwFourCC == MAKEFOURCC('D', 'X', 'T', '3')) *fmt_string.get() = L"DXT3";
		else if (fmt->dwFourCC == MAKEFOURCC('D', 'X', 'T', '4')) *fmt_string.get() = L"DXT4";
		else if (fmt->dwFourCC == MAKEFOURCC('D', 'X', 'T', '5')) *fmt_string.get() = L"DXT5";
	}
	else if (fmt->dwRGBBitCount == 32)
	{
		if (fmt->dwFlags & DDPF_RGB)
		{   
			if      (fmt->dwRBitMask == 0x00FF0000)	*fmt_string.get() = fmt->dwFlags & DDPF_ALPHAPIXELS ? L"A8RGB" : L"X8RGB";
			else if (fmt->dwRBitMask == 0x000000FF)	*fmt_string.get() = fmt->dwFlags & DDPF_ALPHAPIXELS ? L"A8BGR" : L"X8BGR";
		}
		else if (fmt->dwFlags & DDPF_BUMPDUDV)
			*fmt_string.get() = fmt->dwFlags & DDPF_BUMPLUMINANCE ? L"L6V5U5" : L"V8U8";
	}
	else if (fmt->dwRGBBitCount == 16)
	{
		if (fmt->dwFlags & DDPF_RGB)
		{
			if      (fmt->dwRBitMask == 0xF800)     *fmt_string.get() = L"RG6B";
			else if (fmt->dwRBitMask == 0xf00)      *fmt_string.get() = L"A4RGB";
			else if (fmt->dwRBitMask == 0x00007C00)	*fmt_string.get() = fmt->dwFlags & DDPF_ALPHAPIXELS ? L"A1RGB" : L"X1RGB";
		}
	}
	else if (fmt->dwRGBBitCount == 8)
	{
		*fmt_string.get() = fmt->dwFlags & (DDPF_RGB | DDPF_PALETTEINDEXED8) ? L"PAL8" : fmt->dwFlags & DDPF_ALPHA ? L"_A8_" : L"?????";
	}
	return fmt_string;
}

unique_ptr<string> DescribeDDSrfcPixelFormatA(DDPIXELFORMAT* fmt) {
	return unique_ptr<string>(new string(ASCii((wchar_t*)DescribeDDSrfcPixelFormat(fmt).get()->c_str()).ASCii_string.c_str()));
}

unique_ptr<wstring>DumpDirectDrawSurface(DirectDrawSurface * srfc) {		
	IDirectDrawSurface * isfc = (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, srfc->GetImp()).I();
	DDSURFACEDESC desc = {sizeof(DDSURFACEDESC)};
	auto err           = new wstring();
	if (S_OK != isfc->Lock(nullptr, &desc, DDLOCK_WAIT|DDLOCK_READONLY, nullptr)) {		
		*err = L"IDirectDrawSuraceLock FAILED";
		return unique_ptr<wstring>(err);
	} 
	if (nullptr != g_.m_Dumps->Find(desc.dwWidth, desc.dwHeight, desc.lPitch, 
		(char*)DescribeDDSrfcPixelFormatA(&desc.ddpfPixelFormat).get()->c_str(), (BYTE*)desc.lpSurface))
	{
		isfc->Unlock(nullptr);
		*err = L"Dump exists";
		return unique_ptr<wstring>(err);
	}
	auto pxformat = DescribeDDSrfcPixelFormatA(&desc.ddpfPixelFormat);
	if      (*(DWORD*)pxformat.get()->c_str() == *(DWORD*)"DXT1")  desc.lPitch = desc.dwWidth * 2;
	else if (*(char*)pxformat.get()->c_str()  == *(char*)"D")      desc.lPitch = desc.dwWidth * 4;
		
	auto dump = (wchar_t*)g_.NextDmp();
	DumpDDS(dump, (char*)pxformat.get()->c_str(), desc.dwWidth, desc.dwHeight, desc.lpSurface, desc.lPitch);
	isfc->Unlock(nullptr);
	g_.m_Dumps->AppendDump((char*)ASCii((wchar_t*)dump).ASCii_string.c_str());
	err->append( dump );
	return unique_ptr<wstring>(err);
}

unique_ptr<wstring>DumpLockedDirectDrawSurface(DirectDrawSurface* srfc, LPVOID lpSurface, DWORD lPitch) {	
	return unique_ptr<wstring>(new wstring(L"NO IMP"));
	IDirectDrawSurface* isfc = (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, srfc->GetImp()).I();
	auto desc                = srfc->GetDesc();
	auto err                 = new wstring();

	auto pxformat = DescribeDDSrfcPixelFormatA(&desc.get()->ddpfPixelFormat);	
	if (*pxformat.get() == "?????") {
		*err = L"BAD FORMAT";
		return unique_ptr<wstring>(err);
	}

	if (nullptr != g_.m_Dumps->Find(desc.get()->dwWidth, desc.get()->dwHeight, lPitch, (char*)pxformat.get()->c_str(), (BYTE*)lpSurface))
	{		
		*err = L"Dump exists";
		return unique_ptr<wstring>(err);
	}
			
	if      (*(DWORD*)pxformat.get()->c_str() == *(DWORD*)"DXT1")  lPitch = desc.get()->dwWidth * 2;
	else if (*(char*)pxformat.get()->c_str()  == *(char*)"D")      lPitch = desc.get()->dwWidth * 4;
	
	auto dump = (wchar_t*)g_.NextDmp();
	DumpDDS(dump, (char*)pxformat.get()->c_str(), desc.get()->dwWidth, desc.get()->dwHeight, lpSurface, lPitch);
	isfc->Unlock(nullptr);
	g_.m_Dumps->AppendDump((char*)ASCii((wchar_t*)dump).ASCii_string.c_str());
	err->append(dump);
	return unique_ptr<wstring>(err);
}

wchar_t * __stdcall DDCPUDeinterlace(IDirectDrawSurface* iInterlaced)
{
	static std::wstring err = L"S_OK";
	#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	if (iInterlaced == nullptr) {
		err =  L"nullptr";	
		return (wchar_t*)err.c_str();
	}
	DirectDrawSurface * Interlaced = GetDirectDrawSurface((COMPtr*)iInterlaced);	
	if (Interlaced == nullptr)  {
		err =  L"nullptr";	
		return (wchar_t*)err.c_str();
	}
	IDirectDrawSurface * InterlacedImp = (IDirectDrawSurface *) EZInterface(IID_IDirectDrawSurface, Interlaced->GetImp()).I();	
	if (InterlacedImp == nullptr) {
		err =  L"nullptr";	
		return (wchar_t*)err.c_str();
	}

	DDSURFACEDESC desc  = {};
	desc.dwSize         = sizeof(DDSURFACEDESC);		

	auto fmt = DescribeDDSrfcPixelFormat(&Interlaced->GetDesc().get()->ddpfPixelFormat);
	if (*fmt.get() != L"X8RGB"){
		err =  L"bad format";	
		return (wchar_t*)err.c_str();
	}
	
	if (InterlacedImp->Lock(nullptr, &desc, DDLOCK_WAIT, nullptr) != DD_OK){
		err = L"::Lock(InterlacedImp) FAILED";
		return (wchar_t*)err.c_str();
	}		
	unsigned char * even_line_pixel = nullptr;		
	unsigned char * odd_line_pixel  = nullptr;
	for (int line = 0; line < desc.dwHeight/2-1; line++){
		even_line_pixel = (unsigned char*)desc.lpSurface + line*2     * desc.lPitch;
		odd_line_pixel  = (unsigned char*)desc.lpSurface + (line*2+1) * desc.lPitch;
		for (int i = 0; i < desc.dwWidth; i++){
			*(odd_line_pixel+0) = *(even_line_pixel+0);  //red
			*(odd_line_pixel+1) = *(even_line_pixel+1);  //red
			*(odd_line_pixel+2) = *(even_line_pixel+2);  //green
			*(odd_line_pixel+3) = *(even_line_pixel+3);  //alpha
			even_line_pixel += 4;
			odd_line_pixel  += 4;
		}
	}	
	InterlacedImp->Unlock(nullptr);
	return (wchar_t*)err.c_str();
}

wchar_t * __stdcall DDMaskSurface(IDirectDrawSurface* iNexPixels, IDirectDrawSurface* iUnmasked)
{
	static std::wstring err = L"S_OK";
	#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	if (iNexPixels == nullptr || iUnmasked == nullptr) {
		err =  L"nullptr";	
		return (wchar_t*)err.c_str();
	}
	DirectDrawSurface * NexPixels = GetDirectDrawSurface((COMPtr*)iNexPixels);
	DirectDrawSurface * Unmasked  = GetDirectDrawSurface((COMPtr*)iUnmasked);
	if (NexPixels == nullptr || Unmasked == nullptr)  {
		err =  L"nullptr";	
		return (wchar_t*)err.c_str();
	}
	IDirectDrawSurface * NexPixelsImp = (IDirectDrawSurface *) EZInterface(IID_IDirectDrawSurface, NexPixels->GetImp()).I();
	IDirectDrawSurface * UnmaskedImp  = (IDirectDrawSurface *) EZInterface(IID_IDirectDrawSurface, Unmasked->GetImp()).I();
	if (NexPixelsImp == nullptr || UnmaskedImp == nullptr) {
		err =  L"nullptr";	
		return (wchar_t*)err.c_str();
	}

	DDSURFACEDESC NexPixels_desc  = {};
	NexPixels_desc.dwSize         = sizeof(DDSURFACEDESC);	
	DDSURFACEDESC Unmasked_desc   = {};
	Unmasked_desc.dwSize          = sizeof(DDSURFACEDESC);

	auto fmt = DescribeDDSrfcPixelFormat(&NexPixels->GetDesc().get()->ddpfPixelFormat);
	if (*fmt.get() == L"X8RGB")
	{
		DWORD magenta = 0x00FF00FF;
		if (NexPixelsImp->Lock(nullptr, &NexPixels_desc, DDLOCK_WAIT, nullptr) != DD_OK){
			err = L"::Lock(NexPixelsImp) FAILED";
			return (wchar_t*)err.c_str();
		}
		if (UnmaskedImp->Lock(nullptr, &Unmasked_desc, DDLOCK_WAIT, nullptr) != DD_OK){
			err = L"::Lock(UnmaskedImp) FAILED";
			NexPixelsImp->Unlock(NexPixels_desc.lpSurface);
			return (wchar_t*)err.c_str();
		}
		byte * NewPixel      = nullptr;
		byte * UnmaskedPixel = nullptr;
		for (int line = 0; line < NexPixels_desc.dwHeight; line++){
			NewPixel      = (byte*)NexPixels_desc.lpSurface + line * NexPixels_desc.lPitch;
			UnmaskedPixel = (byte*)Unmasked_desc.lpSurface + line * Unmasked_desc.lPitch;
			for (int pixel = 0; pixel < NexPixels_desc.dwWidth; pixel++){
				NewPixel      += pixel * sizeof(DWORD);
				UnmaskedPixel += pixel * sizeof(DWORD);
				if ((DWORD)(DWORD*)*NewPixel == (DWORD)(DWORD*)*UnmaskedPixel){
					*(DWORD*)*NewPixel = magenta;
				}
			}
		}
		NexPixelsImp->Unlock(nullptr);
		UnmaskedImp->Unlock(nullptr);
	} else if (*fmt.get() == L"R6GB") {	
		WORD magenta = 0xF81f;
		if (NexPixelsImp->Lock(nullptr, &NexPixels_desc, DDLOCK_WAIT, nullptr) != DD_OK){
			err = L"::Lock(NexPixelsImp) FAILED";
			return (wchar_t*)err.c_str();
		}
		if (UnmaskedImp->Lock(nullptr, &Unmasked_desc, DDLOCK_WAIT, nullptr) != DD_OK){
			err = L"::Lock(UnmaskedImp) FAILED";
			NexPixelsImp->Unlock(NexPixels_desc.lpSurface);
			return (wchar_t*)err.c_str();
		}
		byte * NewPixel      = nullptr;
		byte * UnmaskedPixel = nullptr;
		for (int line = 0; line < NexPixels_desc.dwHeight; line++){
			NewPixel      = (byte*)NexPixels_desc.lpSurface + line * NexPixels_desc.lPitch;
			UnmaskedPixel = (byte*)Unmasked_desc.lpSurface + line * Unmasked_desc.lPitch;
			for (int pixel = 0; pixel < NexPixels_desc.dwWidth; pixel++){
				NewPixel      += pixel * sizeof(WORD);
				UnmaskedPixel += pixel * sizeof(WORD);
				if ((WORD)(WORD*)*NewPixel == (WORD)(WORD*)*UnmaskedPixel){
					*(WORD*)*NewPixel = magenta;
				}
			}
		}
		NexPixelsImp->Unlock(nullptr);
		UnmaskedImp->Unlock(nullptr);
	}
	return (wchar_t*)err.c_str();
}

wchar_t * __stdcall DDxBRzScale(IDirectDrawSurface* iSrc, IDirectDrawSurface* iDst, RECT * r)
{
	#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	static std::wstring err = L"S_OK";
	DDBLTFX fx              = {};
	fx.dwSize               = sizeof(DDBLTFX);
	DDSURFACEDESC src_desc  = {};
	src_desc.dwSize         = sizeof(DDSURFACEDESC);	
	DDSURFACEDESC dst_desc  = {};
	dst_desc.dwSize         = sizeof(DDSURFACEDESC);

	size_t scl              = ceil(D3DHooksData->scale_delta); 
	IDirectDraw * dd        = nullptr;

	DirectDrawSurface * src =  GetDirectDrawSurface((COMPtr*)iSrc);
	DirectDrawSurface * dst =  GetDirectDrawSurface((COMPtr*)iDst);
	if (src == nullptr || dst == nullptr){
		err = L"nullptr";
		return (wchar_t*) err.c_str();
	}
	auto s_desc         = src->GetDesc();

	IDirectDrawSurface * sys_src = (IDirectDrawSurface *) EZInterface(IID_IDirectDrawSurface, src->GetImp()).I();
	IDirectDrawSurface * vid_dst = (IDirectDrawSurface *) EZInterface(IID_IDirectDrawSurface, dst->GetImp()).I();
	if (sys_src ==  nullptr ||vid_dst == nullptr){
		err = L"EZInterface(IID_IDirectDrawSurface, ...) FAILED";	
		return (wchar_t*) err.c_str();
	}	
		
	IDirectDrawSurface * sys_dst = nullptr;		
	auto ezdd = DDInterfaceFromSurface(sys_src);
	if (ezdd == nullptr)	{
		err = L"DDInterfaceFromSurface(...) FAILED";
		goto DDxBRzScale_cleanup;
	}
	dd = (IDirectDraw*)EZInterface(IID_IDirectDraw, (IUnknown*)ezdd.get()->I()).I();
	if (dd == nullptr)	{
		err = L"QueryInterface(IID_IDirectDraw) FAILED";
		goto DDxBRzScale_cleanup;
	}
		
	if (scl > 6)    scl = 6;
	DDSURFACEDESC desc;
	desc.dwSize         = sizeof(DDSURFACEDESC);
	desc.dwFlags        = DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH | DDSD_PIXELFORMAT;
	desc.dwHeight       = s_desc.get()->dwHeight * scl;
	desc.dwWidth        = s_desc.get()->dwWidth  * scl;
	desc.ddsCaps.dwCaps = DDSCAPS_SYSTEMMEMORY;	
	SetDDSurfacePixelFormat(&desc.ddpfPixelFormat, "X8RGB");	
	if (S_OK != dd->CreateSurface(&desc, (IDirectDrawSurface**)&sys_dst, nullptr)){
		err = L"CreateSurface(sys_dst) FAILED";
		goto DDxBRzScale_cleanup;
	}
		
	if (sys_dst->Lock(nullptr, &dst_desc, DDLOCK_WAIT | DDLOCK_SURFACEMEMORYPTR, nullptr) != DD_OK) {
		err = L"sys_dst->Lock() failed";
		goto DDxBRzScale_cleanup;
	}
	if (sys_src->Lock(nullptr, &src_desc, DDLOCK_WAIT | DDLOCK_SURFACEMEMORYPTR, nullptr) != DD_OK) {
		sys_dst->Unlock(nullptr);
		err = L"sys_src->Lock() failed";
		goto DDxBRzScale_cleanup;
	}	
	xbrz::nearestNeighborScale(
		(uint32_t*)src_desc.lpSurface, (int)src_desc.dwWidth,  (int)src_desc.dwHeight, 
		(uint32_t*)dst_desc.lpSurface, (int)dst_desc.dwWidth,  (int)dst_desc.dwHeight
		);
	//xbrz::scale(scl, (uint32_t*)src_desc.lpSurface, (uint32_t*)dst_desc.lpSurface, (int)src_desc.dwWidth, (int)src_desc.dwHeight, xbrz::ColorFormat::ARGB);

	sys_src->Unlock(src_desc.lpSurface);
	sys_dst->Unlock(dst_desc.lpSurface);
	if (vid_dst->Blt(r, sys_dst, nullptr, DDBLT_WAIT, &fx) != DD_OK) {
		err = L"vid_dst->Blt() failed";
		goto DDxBRzScale_cleanup;
	}
	DDxBRzScale_cleanup:	
	if (sys_dst != nullptr) sys_dst->Release();
	return (wchar_t*) err.c_str();
}

wchar_t * __stdcall DDrawBrowseTextures(COMPtr* p) {
	#pragma comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
	static BOOL sleep_flag        = 0;
	static std::wstring msg       = L"not searching";
	D3DHooksData->current_texture = 0;  //current_texture should be voif but its DWORD

	if (sleep_flag) {
		Sleep(2000);
		sleep_flag = FALSE;
	}
	
	if (GetEvent(g_d3d.TEXTURE_SWAP_TOGGLE_SEARCH) == 1) {
		D3DHooksData->search_enabled = D3DHooksData->search_enabled == FALSE ? TRUE : FALSE;			
	}

	if (D3DHooksData->search_enabled == FALSE) {
		return (wchar_t*)msg.c_str();
	};
	
	BOOL quick = FALSE;
	if (g_d3d.TEXTURE_SWAP_QUICK) {
		if (GetKeyState(g_d3d.TEXTURE_SWAP_QUICK) & 0x8000) {
			quick = TRUE;
		}
	}
	if (FALSE == quick)
	{
		if      (GetEvent(g_d3d.TEXTURE_SWAP_NEXT) == 1) {D3DGlobals.Next();}		
		else if (GetEvent(g_d3d.TEXTURE_SWAP_PREV) == 1) {D3DGlobals.Prev();}
	} else {
		if      (GetKeyState(g_d3d.TEXTURE_SWAP_NEXT) & 0x8000) { D3DGlobals.Next(); }
		else if (GetKeyState(g_d3d.TEXTURE_SWAP_PREV) & 0x8000) { D3DGlobals.Prev(); }
	}
		
	if (nullptr == p) {
		msg = L"nullsrfc";
		return (wchar_t*)msg.c_str();
	}

	auto curr_srfc                = D3DGlobals.GetCurrentSurface();
	D3DHooksData->current_texture = (DWORD)curr_srfc;
	msg                           = L"Layer objects : "  + std::to_wstring(g_.layer_objects_count->Get());	
	msg                          += L"\nSurface : " + to_wstring(D3DGlobals.GetIndex()+1) + L"\\" + to_wstring(D3DGlobals.GetCount()) + L"\n";
	DirectDrawSurface  * srfc     = GetDirectDrawSurface((COMPtr*)p);
	IDirectDrawSurface * isfc     = (IDirectDrawSurface*)EZInterface(IID_IDirectDrawSurface, srfc->GetImp()).I();
	auto s_dsc                    = srfc->GetDesc();

	if (nullptr != curr_srfc)
	{
		msg += curr_srfc->Describe().get()->c_str();
		msg += L"Blit: " + HEXString((DWORD)blt(isfc, curr_srfc, s_dsc.get()->dwWidth, 256)).s.str() + L"\n ";
		if (GetEvent(g_d3d.TEXTURE_SWAP_DUMP) == 1) {
			msg       += *DumpDirectDrawSurface(curr_srfc).get();
			//sleep_flag = TRUE;
		}
	}
	else msg += L"NO SURFACE";
	auto writen = DDWriteOnSurface(isfc, s_dsc.get()->dwWidth, 256, (wchar_t*)msg.c_str());
	if (*writen.get() == L"OK") DBUG_WARN("DDrawBrowseTextures Failed");
	msg += *writen.get();
	return (wchar_t*)msg.c_str();
}

/*	class DirectDrawOnD3D12Surface {
public:
	GetSys(){
		if (m_Sys != nullptr) nullptr m_Sys;

		CreateSys();
		if      (nullptr != m_HD) this.VidToSys();
		else if (IsHDValid())     this.HDToSys();
		return m_Sys;
	}
	SwitchToSyss(){
		GetSys();
		DelelteVid();
		InvalidateHD();
	}

private:
	BOOL IsHDValid(){
		return ((nullptr != m_HD) && (nullptr == m_Cpy)) ? TRUE : FALSE;
	}
	InvalidateHD(){
		if IsHDValid(){
			HDToCpy();
		}
	};
	IDirect3DSurface9 * m_Sys = nullptr;
	IDirect3DSurface9 * m_Vid = nullptr;
	IDirect3DSurface9 * m_HD  = nullptr;
	IDirect3DSurface9 * m_Cpy = nullptr;
}
*/