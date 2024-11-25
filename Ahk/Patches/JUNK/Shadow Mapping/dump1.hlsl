sampler s0 : register(s0);
sampler s1 : register(s1);
float4 main(float4 tex : TEXCOORD0, float4 diff : COLOR0, float4 spec : COLOR1) : COLOR
{     
   float4x4 mat = {1., 0., 0., 0.,
                   1., 0., 0., 0.,
                   0., 0., 1./float(1<<24)-1, 0.,
                   0., 0., 0., 1.};
   float4 crrds = mul(tex, mat);
   float4 c0 = tex2D(s0, crrds.xy);		
  	return c0*(diff+spec);   
}
