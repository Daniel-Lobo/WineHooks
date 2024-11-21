cbuffer cb : register(b0)
{
    float4 Bltconsts;
	uint4  FSRConst0, FSRConst1, FSRConst2, FSRConst3, FSRSample;  
    uint4  RCASConst0, RCASConst1, RCASConst2, RCASConst3, RCASSample;   
};

Texture2D InputTexture            : register(t0);
RWTexture2D<float4> OutputTexture : register(u0);

[numthreads(16, 16, 1)]
void CSBlt(uint3 ThreadID : SV_DispatchThreadID)
{
	OutputTexture[ThreadID.xy] = InputTexture.Load(uint3(ThreadID.x/Bltconsts.x, ThreadID.y/Bltconsts.x, 0));
}
[numthreads(16, 16, 1)]
void DownScaleBlt(uint3 ThreadID : SV_DispatchThreadID)
{
	OutputTexture[ThreadID.xy] = InputTexture.Load(uint3(ThreadID.x * Bltconsts.y, ThreadID.y * Bltconsts.y, 0));
}
[numthreads(16, 16, 1)]
void TXAAFIX(uint3 ThreadID : SV_DispatchThreadID)
{
	float x = ThreadID.x * 2.f;
	float y = ThreadID.y * 2.f;
	float4 color = InputTexture.Load(uint3(x, y, 0));	
	OutputTexture[ThreadID.xy] = color;
}
[numthreads(16, 16, 1)]
void SSAA(uint3 ThreadID : SV_DispatchThreadID)
{
	float x = ThreadID.x * 2.f;
	float y = ThreadID.y * 2.f;
	float4 color = InputTexture.Load(uint3(x, y, 0));
	color += InputTexture.Load(uint3(x-1, y, 0));
	color += InputTexture.Load(uint3(x-1, y-1, 0));
	color += InputTexture.Load(uint3(x,   y-1, 0));
	OutputTexture[ThreadID.xy] = color / 4.f;
}

[numthreads(16, 16, 1)]
void SSAAHQ(uint3 ThreadID : SV_DispatchThreadID)
{
	float x = ThreadID.x * 3.f;
	float y = ThreadID.y * 3.f;
	float4 color = 
		     InputTexture.Load(uint3(x  , y, 0));
	color += InputTexture.Load(uint3(x-1, y, 0));
	color += InputTexture.Load(uint3(x-2, y, 0));
	color += InputTexture.Load(uint3(x  , y-1, 0));
	color += InputTexture.Load(uint3(x-1, y-1, 0));
	color += InputTexture.Load(uint3(x-2, y-1, 0));	
	color += InputTexture.Load(uint3(x,   y-2, 0));
	color += InputTexture.Load(uint3(x-1, y-2, 0));
	color += InputTexture.Load(uint3(x-2, y-2, 0));
	OutputTexture[ThreadID.xy] = color / 9.f;
}

#if AMDFSR
#define A_GPU 1
#define A_HLSL 1
    
SamplerState		samLinearClamp : register(s0);

#if SAMPLE_SLOW_FALLBACK
	#include "FSR_1_0/ffx_a.h"     	
	#if SAMPLE_EASU
		#define FSR_EASU_F 1
		AF4 FsrEasuRF(AF2 p) { AF4 res = InputTexture.GatherRed(samLinearClamp, p, int2(0, 0)); return res; }
		AF4 FsrEasuGF(AF2 p) { AF4 res = InputTexture.GatherGreen(samLinearClamp, p, int2(0, 0)); return res; }
		AF4 FsrEasuBF(AF2 p) { AF4 res = InputTexture.GatherBlue(samLinearClamp, p, int2(0, 0)); return res; }
	#endif
	#if SAMPLE_RCAS
		#define FSR_RCAS_F
		AF4 FsrRcasLoadF(ASU2 p) { return InputTexture.Load(int3(ASU2(p), 0)); }
		void FsrRcasInputF(inout AF1 r, inout AF1 g, inout AF1 b) {}
	#endif
#else
	#define A_HALF
	#include "FSR_1_0/ffx_a.h"  	
	#if SAMPLE_EASU
		#define FSR_EASU_H 1
		AH4 FsrEasuRH(AF2 p) { AH4 res = InputTexture.GatherRed(samLinearClamp, p, int2(0, 0)); return res; }
		AH4 FsrEasuGH(AF2 p) { AH4 res = InputTexture.GatherGreen(samLinearClamp, p, int2(0, 0)); return res; }
		AH4 FsrEasuBH(AF2 p) { AH4 res = InputTexture.GatherBlue(samLinearClamp, p, int2(0, 0)); return res; }	
	#endif
	#if SAMPLE_RCAS
		#define FSR_RCAS_H
		AH4 FsrRcasLoadH(ASW2 p) { return InputTexture.Load(ASW3(ASW2(p), 0)); }
		void FsrRcasInputH(inout AH1 r,inout AH1 g,inout AH1 b){}
	#endif
#endif

#include "FSR_1_0/ffx_fsr1.h"

void CurrFilter(int2 pos)
{      
#if SAMPLE_BILINEAR
	AF2 pp = (AF2(pos) * AF2_AU2(FSRConst0.xy) + AF2_AU2(FSRConst0.zw)) * AF2_AU2(FSRConst1.xy) + AF2(0.5, -0.5) * AF2_AU2(FSRConst1.zw);
	OutputTexture[pos] = InputTexture.SampleLevel(samLinearClamp, pp, 0.0);
#endif
#if SAMPLE_EASU
	#if SAMPLE_SLOW_FALLBACK
		AF3 c;
		FsrEasuF(c, pos, FSRConst0, FSRConst1, FSRConst2, FSRConst3);
		if (FSRSample.x == 1)
			c *= c;
		OutputTexture[pos] = float4(c, 1);
	#else
		AH3 c;
		FsrEasuH(c, pos, FSRConst0, FSRConst1, FSRConst2, FSRConst3);
		if (FSRSample.x == 1)
			c *= c;
		OutputTexture[pos] = AH4(c, 1);
	#endif
#endif
#if SAMPLE_RCAS
	#if SAMPLE_SLOW_FALLBACK
		AF3 c;
		FsrRcasF(c.r, c.g, c.b, pos, RCASConst0);
		if (FSRSample.x == 1)
			c *= c;
		OutputTexture[pos] = float4(c, 1);
	#else
		AH3 c;
		FsrRcasH(c.r, c.g, c.b, pos, RCASConst0);
		if(FSRSample.x == 1 )
			c *= c;
		OutputTexture[pos] = AH4(c, 1);
	#endif
#endif
}

[numthreads(64, 1, 1)]
void FSR(uint3 LocalThreadId : SV_GroupThreadID, uint3 WorkGroupId : SV_GroupID, uint3 Dtid : SV_DispatchThreadID)
{
	// Do remapping of local xy in workgroup for a more PS-like swizzle pattern.
	AU2 gxy = ARmp8x8(LocalThreadId.x) + AU2(WorkGroupId.x << 4u, WorkGroupId.y << 4u);
	CurrFilter(gxy);
	gxy.x += 8u;
	CurrFilter(gxy);
	gxy.y += 8u;
	CurrFilter(gxy);
	gxy.x -= 8u;
	CurrFilter(gxy);
}
#endif //AMDFSR