sampler s0 : register(s0); 
     
float4 main(float2 tex: TEXCOORD0) : COLOR0 
{
    float4 c0 = tex2D(s0, tex);      
   // if ( c0.r != c0.g )
        discard;
    //return float4(1,0,1,1);  
    return float4(0,0,0,1)  ;    
}