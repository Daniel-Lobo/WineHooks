sampler s0 : register(s0);
sampler s1 : register(s1);
float4 main(float4 tex : TEXCOORD0, float4 diff : COLOR0, float4 spec : COLOR1) : COLOR
{     
    float z = tex.z/256.;
  	float4 c0 = tex2D(s0, float2(tex.x, tex.y));		
  	//return c0*(diff+spec); 
    return float4(1., 0., 0., 1.) ;    
}

