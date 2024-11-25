//ps_4_0@
cbuffer cbuff0: register (c0) 
{
	float4 cb0[14];
};
cbuffer cbuff1: register (c1) 
{
	float4 cb1[26];
};
sampler s0;
sampler s1;
texture2D t0;
texture2D t1;
texture2D t2;
texture2D t3;
texture2D t4;

struct PxInput 
{
	float4 v0 : SV_POSITION0;
	linear float4 v1 : TEXCOORD0;
};

struct PxOutPut 
{
	float4 o0 : SV_TARGET0;
};

PxOutPut main(PxInput input)
{
    PxOutPut OutPut;
    OutPut.o0.xyz = (t1.SampleLevel(s1, (input.v1.xyxx).xy, float1(0.000000))).xyzw;	//  sample_l r0.xyzw, v1.xyxx, t1.xyzw, s1, l(0.000000)
    return OutPut;
}

PxOutPut AutoTranslation(PxInput input)
{
	PxOutPut OutPut;
	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.xyzw = (t1.SampleLevel(s1, (input.v1.xyxx).xy, float1(0.000000))).xyzw;	//  sample_l r0.xyzw, v1.xyxx, t1.xyzw, s1, l(0.000000)
	r0.y = cb0[13].w == float1(0.000000) ?  1.0 : 0.;
	r0.z = r0.x*cb1[25].w;	//  mul r0.z, r0.x, cb1[25].w
	r0.x = mad(r0.x, cb1[25].w, -cb0[11].x);	//  mad r0.x, r0.x, cb1[25].w, -cb0[11].x
	r0.w = -r0.x+-cb0[11].w;	//  add r0.w, -r0.x, -cb0[11].w
	r0.w = max(r0.w, float1(0.000000));	//  max r0.w, r0.w, l(0.000000)
	r0.w = r0.w/cb0[11].y;	//  div r0.w, r0.w, cb0[11].y
	r0.w = min(r0.w, cb0[12].y);	//  min r0.w, r0.w, cb0[12].y
	r1.x = r0.x+-cb0[12].x;	//  add r1.x, r0.x, -cb0[12].x
	r1.x = max(r1.x, float1(0.000000));	//  max r1.x, r1.x, l(0.000000)
	r1.x = r1.x/cb0[11].z;	//  div r1.x, r1.x, cb0[11].z
	r1.x = min(r1.x, cb0[12].y);	//  min r1.x, r1.x, cb0[12].y
	r1.y = r1.x < r0.w ?  1.0 : 0.;
	r0.w = r1.y == 0.0 ? r1.y : -r0.w;
	r0.x = abs(r0.x)/r0.z;	//  div r0.x, |r0.x|, r0.z
	r0.z = cb0[13].x*cb0[13].x;	//  mul r0.z, cb0[13].x, cb0[13].x
	r0.x = r0.x*r0.z;	//  mul r0.x, r0.x, r0.z
	r0.z = cb0[11].x+-cb0[13].x;	//  add r0.z, cb0[11].x, -cb0[13].x
	r0.z = r0.z*cb0[13].z;	//  mul r0.z, r0.z, cb0[13].z
	r0.x = r0.x/r0.z;	//  div r0.x, r0.x, r0.z
	r0.x = r0.x/cb0[13].y;	//  div r0.x, r0.x, cb0[13].y
	r0.x = r0.x*float1(24.000000);	//  mul r0.x, r0.x, l(24.000000)
	r0.x = max(r0.x, -cb0[12].y);	//  max r0.x, r0.x, -cb0[12].y
	r0.x = min(r0.x, cb0[12].y);	//  min r0.x, r0.x, cb0[12].y
	r0.x = r0.y == 0.0 ? r0.y : r0.w;
	r0.y = saturate(abs(r0.x)+float1(-0.030000));	//  add_sat r0.y, |r0.x|, l(-0.030000)
	r1.xyzw = (t0.Sample(s1, (input.v1.xyxx).xy, int2(0,0))).xyzw;	//  sample_aoffimmi(0,0,0) r1.xyzw, v1.xyxx, t0.xyzw, s1
	r2.xyzw = (t3.Sample(s1, (input.v1.xyxx).xy, int2(0,0))).xyzw;	//  sample_aoffimmi(0,0,0) r2.xyzw, v1.xyxx, t3.xyzw, s1
	r0.z = r2.w == float1(0.000000) ?  1.0 : 0.;
	r0.w = r0.y == float1(0.000000) ?  1.0 : 0.;
	r0.z = r0.w&&r0.z;	//  and r0.z, r0.w, r0.z
	if (r0.z == 0.)
	{
		OutPut.o0.xyz = (r1.xyzx).xyz;	//    mov o0.xyz, r1.xyzx
		return OutPut;
	};
	r3.xyzw = (t4.Sample(s0, (input.v1.xyxx).xy, int2(0,0))).xyzw;	//  sample_aoffimmi(0,0,0) r3.xyzw, v1.xyxx, t4.xyzw, s0
	r4.xyzw = (t2.Sample(s1, (input.v1.xyxx).xy, int2(0,0))).xyzw;	//  sample_aoffimmi(0,0,0) r4.xyzw, v1.xyxx, t2.xyzw, s1
	r0.y = r0.y*float1(10.000000);	//  mul r0.y, r0.y, l(10.000000)
	r0.y = min(r0.y, float1(1.000000));	//  min r0.y, r0.y, l(1.000000)
	r4.xyz = (-r1.xyzx+r4.xyzx).xyz;	//  add r4.xyz, -r1.xyzx, r4.xyzx
	r0.yzw = (mad(r0.yyyy, r4.xxyz, r1.xxyz)).yzw;	//  mad r0.yzw, r0.yyyy, r4.xxyz, r1.xxyz
	r0.x = r0.x+float1(-0.100000);	//  add r0.x, r0.x, l(-0.100000)
	r0.x = saturate(r0.x*float1(10.000000));	//  mul_sat r0.x, r0.x, l(10.000000)
	r1.xyz = (-r0.yzwy+r3.xyzx).xyz;	//  add r1.xyz, -r0.yzwy, r3.xyzx
	r0.xyz = (mad(r0.xxxx, r1.xyzx, r0.yzwy)).xyz;	//  mad r0.xyz, r0.xxxx, r1.xyzx, r0.yzwy
	r0.w = saturate(r2.w+r2.w);	//  add_sat r0.w, r2.w, r2.w
	r1.xyz = (-r0.xyzx+r2.xyzx).xyz;	//  add r1.xyz, -r0.xyzx, r2.xyzx
	OutPut.o0.xyz = (mad(r0.wwww, r1.xyzx, r0.xyzx)).xyz;	//  mad o0.xyz, r0.wwww, r1.xyzx, r0.xyzx
	return OutPut;
};
