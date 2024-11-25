//ps_4_0@
// Whatever the automatic translation dit wrong here, removes the blur
cbuffer cbuff0: register (c0) 
{
	float4 cb0[13];
};
cbuffer cbuff1: register (c1) 
{
	float4 cb1[19];
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
	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.xyzw = (t1.SampleLevel(s1, (input.v1.xyxx).xy, float1(0.000000))).xyzw;	//  sample_l r0.xyzw, v1.xyxx, t1.xyzw, s1, l(0.000000)
	r0.x = mad(r0.x, cb1[18].y, -cb0[11].x);	//  mad r0.x, r0.x, cb1[18].y, -cb0[11].x
	r0.y = -r0.x+-cb0[11].w;	//  add r0.y, -r0.x, -cb0[11].w
	r0.y = max(r0.y, float1(0.000000));	//  max r0.y, r0.y, l(0.000000)
	r0.x = r0.x+-cb0[12].x;	//  add r0.x, r0.x, -cb0[12].x
	r0.x = max(r0.x, float1(0.000000));	//  max r0.x, r0.x, l(0.000000)
	r0.xy = saturate((r0.xyxx/cb0[11].zyzz).xy);	//  div_sat r0.xy, r0.xyxx, cb0[11].zyzz
	r0.z = r0.x < r0.y ?  1.0 : 0.;
	r0.x = r0.z == 0.0 ? r0.z : -r0.y;
	r0.x = r0.x+float1(-0.010000);	//  add r0.x, r0.x, l(-0.010000)
	r0.x = max(r0.x, float1(0.000000));	//  max r0.x, r0.x, l(0.000000)
	r1.xyzw = (t0.Sample(s1, (input.v1.xyxx).xy, int2(0,0))).xyzw;	//  sample_aoffimmi(0,0,0) r1.xyzw, v1.xyxx, t0.xyzw, s1
	r2.xyzw = (t3.Sample(s1, (input.v1.xyxx).xy, int2(0,0))).xyzw;	//  sample_aoffimmi(0,0,0) r2.xyzw, v1.xyxx, t3.xyzw, s1
	r0.y = r2.w == float1(0.000000) ?  1.0 : 0.;
	r0.z = r0.x == float1(0.000000) ?  1.0 : 0.;
	r0.y = r0.z&&r0.y;	//  and r0.y, r0.z, r0.y
	if (r0.y == 0.)
	{
		OutPut.o0.xyz = (r1.xyzx).xyz;	//    mov o0.xyz, r1.xyzx
		return OutPut;
	};
	r3.xyzw = (t4.Sample(s0, (input.v1.xyxx).xy, int2(0,0))).xyzw;	//  sample_aoffimmi(0,0,0) r3.xyzw, v1.xyxx, t4.xyzw, s0
	r4.xyzw = (t2.Sample(s1, (input.v1.xyxx).xy, int2(0,0))).xyzw;	//  sample_aoffimmi(0,0,0) r4.xyzw, v1.xyxx, t2.xyzw, s1
	r0.y = r0.x*float1(100.000000);	//  mul r0.y, r0.x, l(100.000000)
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
