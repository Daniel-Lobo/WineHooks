// Whatever i translated wrong here disables the blur on 
// objects near the camera

sampler s0 : register(s0);
sampler s1 : register(s1);
float4 c0  : register(c0);
float4 c1  : register(c1);
float4 c2  : register(c2);
float4 main(float2 t0 : TEXCOORD0, float2 t1 : TEXCOORD0) : COLOR0
{
      float4 c3 = float4(1, -1, 0, 0);        
      float4 r2 = tex2D(s0, t0) ;      
      float4 r0;
      float4 r1;
      r0.xy     = t0 * c3.xy + c3.zx;  
      if (c2.y == 0.0) {
           r0.xy = r0.xy;   
      }  else {
           r0.xy = t0 ;
      }
      r0   = tex2D(s1, r0.xy);  
      r1.x = r0.x * c0.x + c0.y;
      r1.x = 1.0f/r1.x;
      r0.x = c1.w - c1.z;
      r0.x = r1.x - r0.x;
      if (r0.x == 0.0) {
           r0.x = -r0.x;
      } else {
           r0.xy = c3.z;
      }
      r2.w = saturate( r0.x * c1.x);    
      return r2;      
}