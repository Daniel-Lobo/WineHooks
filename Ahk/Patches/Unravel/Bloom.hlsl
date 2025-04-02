//ps_4_0@
cbuffer cbuff0: register (b0) 
{
	float4 cb0[6];
};
sampler s0;
texture2D t0;
texture2D t1;

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
	r0.xyzw = (t0.SampleLevel(s0, (input.v1.xyxx).xy, float1(0.000000))).xyzw;	//  sample_l r0.xyzw, v1.xyxx, t0.xyzw, s0, l(0.000000)
	r1.xyzw = cb0[3].zwzw*cb0[5].xyxy;	//  mul r1.xyzw, cb0[3].zwzw, cb0[5].xyxy
	r2.xyzw = (mad(-r1.zwxy, float4(3.230769, 3.230769, 1.384615, 1.384615), input.v1.xyxy)).xyzw;	//  mad r2.xyzw, -r1.zwxy, l(3.230769, 3.230769, 1.384615, 1.384615), v1.xyxy
	r1.xyzw = (mad(r1.xyzw, float4(1.384615, 1.384615, 3.230769, 3.230769), input.v1.xyxy)).xyzw;	//  mad r1.xyzw, r1.xyzw, l(1.384615, 1.384615, 3.230769, 3.230769), v1.xyxy
	r3.xyzw = (t0.SampleLevel(s0, (r2.xyxx).xy, float1(0.000000))).xyzw;	//  sample_l r3.xyzw, r2.xyxx, t0.xyzw, s0, l(0.000000)
	r2.xyzw = (t0.SampleLevel(s0, (r2.zwzz).xy, float1(0.000000))).xyzw;	//  sample_l r2.xyzw, r2.zwzz, t0.xyzw, s0, l(0.000000)
	r3.xyz = (r3.xyzx*float4(0.070270, 0.070270, 0.070270, 0.000000)).xyz;	//  mul r3.xyz, r3.xyzx, l(0.070270, 0.070270, 0.070270, 0.000000)
	r0.xyz = (mad(r0.xyzx, float4(0.227027, 0.227027, 0.227027, 0.000000), r3.xyzx)).xyz;	//  mad r0.xyz, r0.xyzx, l(0.227027, 0.227027, 0.227027, 0.000000), r3.xyzx
	r0.xyz = (mad(r2.xyzx, float4(0.316216, 0.316216, 0.316216, 0.000000), r0.xyzx)).xyz;	//  mad r0.xyz, r2.xyzx, l(0.316216, 0.316216, 0.316216, 0.000000), r0.xyzx
	r2.xyzw = (t0.SampleLevel(s0, (r1.xyxx).xy, float1(0.000000))).xyzw;	//  sample_l r2.xyzw, r1.xyxx, t0.xyzw, s0, l(0.000000)
	r1.xyzw = (t0.SampleLevel(s0, (r1.zwzz).xy, float1(0.000000))).xyzw;	//  sample_l r1.xyzw, r1.zwzz, t0.xyzw, s0, l(0.000000)
	r0.xyz = (mad(r2.xyzx, float4(0.316216, 0.316216, 0.316216, 0.000000), r0.xyzx)).xyz;	//  mad r0.xyz, r2.xyzx, l(0.316216, 0.316216, 0.316216, 0.000000), r0.xyzx
	r0.xyz = (mad(r1.xyzx, float4(0.070270, 0.070270, 0.070270, 0.000000), r0.xyzx)).xyz;	//  mad r0.xyz, r1.xyzx, l(0.070270, 0.070270, 0.070270, 0.000000), r0.xyzx
	r1.xyzw = (t1.SampleLevel(s0, (input.v1.xyxx).xy, float1(0.000000))).xyzw;	//  sample_l r1.xyzw, v1.xyxx, t1.xyzw, s0, l(0.000000)
	OutPut.o0.xyz = (r0.xyzx+r1.xyzx).xyz;	//  add o0.xyz, r0.xyzx, r1.xyzx 
    OutPut.o0.xyz = r0.xyz;	//  add o0.xyz, r0.xyzx, r1.xyzx      
	return OutPut;        
};
