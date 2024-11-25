//ps_4_0@
// Whatever the automatic translation dit wrong here, removes the blur
cbuffer cbuff0: register (c0) 
{
	float4 cb0[4];
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
	r0.xyzw = (t2.SampleLevel(s0, (input.v1.xyxx).xy, float1(0.000000))).xyzw;	//  sample_l r0.xyzw, v1.xyxx, t2.xyzw, s0, l(0.000000)
	r0.x = mad(r0.x, cb1[18].y, -cb0[3].z);	//  mad r0.x, r0.x, cb1[18].y, -cb0[3].z
	r0.x = saturate(r0.x/cb0[3].w);	//  div_sat r0.x, r0.x, cb0[3].w
	r1.xyzw = (t1.SampleLevel(s1, (input.v1.xyxx).xy, float1(0.000000))).xyzw;	//  sample_l r1.xyzw, v1.xyxx, t1.xyzw, s1, l(0.000000)
	r0.x = r0.x*r1.w;	//  mul r0.x, r0.x, r1.w
	r2.xyzw = (t0.SampleLevel(s0, (input.v1.xyxx).xy, float1(0.000000))).xyzw;	//  sample_l r2.xyzw, v1.xyxx, t0.xyzw, s0, l(0.000000)
	r1.xyzw = r1.xyzw+-r2.xyzw;	//  add r1.xyzw, r1.xyzw, -r2.xyzw
	OutPut.o0.xyzw = (mad(r0.xxxx, r1.xyzw, r2.xyzw)).xyzw;	//  mad o0.xyzw, r0.xxxx, r1.xyzw, r2.xyzw
	return OutPut;
};
