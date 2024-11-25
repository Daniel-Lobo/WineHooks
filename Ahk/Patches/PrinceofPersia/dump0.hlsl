sampler s0 : register(s0);
float4 main(float2 tex : TEXCOORD0, float4 diff : COLOR0) : COLOR0
{
	return tex2D(s0, tex) * diff;
}  