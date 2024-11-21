sampler   s {Filter = MIN_MAG_MIP_POINT;};
texture2D t; 
	
struct VxOut {
	float4 pos  : SV_POSITION;
	float2 crds : TEXCOORD0;
};	
	
cbuffer Params : register(b0)
{
	float x0;
	float y0;
	float x1;
	float y1;
	float4 cc;
};		
		
float4 VMirrorBltPx(VxOut input) : SV_TARGET
{
	return t.Sample(s, float2(input.crds.x, 1-input.crds.y));		
}	
		
float4 BltPx(VxOut input) : SV_TARGET
{
	return t.Sample(s, float2(input.crds.x, input.crds.y));		
}

float4 SSAAx2(float4 screenSpace : SV_Position, VxOut input) : SV_TARGET
{
	int3 location  = screenSpace.xyz * int3(2, 2, 0);
	float4 px0     = t.Load(location);
	px0           += t.Load(location + int3(1, 1, 0));
	px0           += t.Load(location + int3(0, 1, 0));
	px0           += t.Load(location + int3(2, 0, 0));
	return px0/4.f;	
}

float4 SSAAx9(float4 screenSpace : SV_Position, VxOut input) : SV_TARGET
{
	int3 location  = screenSpace.xyz * int3(3, 3, 0);
	float4 px0     = t.Load(location);
	px0           += t.Load(location + int3(0, 1, 0));
	px0           += t.Load(location + int3(0, 2, 0));
	px0           += t.Load(location + int3(1, 0, 0));
	px0           += t.Load(location + int3(1, 1, 0));
	px0           += t.Load(location + int3(1, 2, 0));
	px0           += t.Load(location + int3(2, 0, 0));
	px0           += t.Load(location + int3(2, 1, 0));
	px0           += t.Load(location + int3(2, 2, 0));
	return px0/9.f;	
}
				
VxOut BltVx(uint VertexID: SV_VertexID) 
{
	VxOut OutPut;
								
	float2 v[6] = {x0, y0,  x1, y1,  x0, y1,  x0, y0,  x1, y0,  x1, y1};
	float2 c[6] = {0., 0.,  1., 1.,  0., 1.,  0., 0.,  1., 0.,  1., 1.};
		
	OutPut.pos  = float4(v[VertexID].x, -v[VertexID].y, 0., 1.);		
	OutPut.crds = float2(c[VertexID].x, c[VertexID].y);
	return OutPut;
}   