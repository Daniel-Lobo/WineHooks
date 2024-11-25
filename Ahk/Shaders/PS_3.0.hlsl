sampler s0 : register(s0);
sampler s1 : register(s1);
float4 txl : register(c223);  
   
float4 Clear(float2 tex : TEXCOORD0) : COLOR
{
     return float4(1., 0., 1., 1.) ;
} 

float2 Nearest(float2 tex) 
{   
    // compute texel array coordinates
    int x = tex.x / txl.x;
    int y = tex.y / txl.y;
    
    // round to values, such that they're multiples of txl.x and txl.y
    // and add a half pixel offset
    float2 ret;
    ret.x = (x * txl.x) + txl.x/2.;
    ret.y = (y * txl.y) + txl.y/2.;	
    return ret;
}

float4 ckey (float2 tex : TEXCOORD0) : COLOR
{
    float4 tx_clr =  tex2D(s0, tex); 
    if (all(tx_clr == float4(1., 0., 1., 1.) ))
    discard ;
    return   tx_clr;
}

float4 LineDoubling(float2 tex : TEXCOORD0) : COLOR
{    
    float2 tx = Nearest(tex);
    float4 c0 = tex2D(s0, tx);		  	
    float4 c1 = tex2D(s0, tx - txl.x);
    float4 c2 = tex2D(s0, tx + txl.y);
    c0 = (c0 * 2 + c1 + c2) / 2;
    return c0;   
}  

float4 _8BitLookUp(float2 tex : TEXCOORD0) : COLOR
{
    float idx     = tex2D(s0, tex).a;             
    float4 sample = tex1D(s1, idx) ; 
    float4 ret = float4(sample.b, sample.g, sample.r, 1.) ; 
    return ret;      
}  

float4 Linear(float2 tex : TEXCOORD0) : COLOR
{   
    float2 tx = floor(tex/txl.xy) * txl.xy;
    float4 tl = tex2D(s0, tx);
    float4 tr = tex2D(s0, tx + float2(txl.x, 0.0));
    float4 bl = tex2D(s0, tx + float2(0.0, txl.y));
    float4 br = tex2D(s0, tx + float2(txl.x, txl.y));  
    //float2 f  = frac( tex * txl.ba );  
    float2 f  = frac( tex - txl.xy );  
    float4 tA = lerp( tl, tr, f.x );
    float4 tB = lerp( bl, br, f.x );
    return lerp( tA, tB, f.y ); 
}

float4 MaskIfEqual(float2 tex : TEXCOORD0) : COLOR
{     
     float2 tx  =  Nearest(tex);  
     float4 tx0 =  tex2D(s0, tx); 
     float4 tx1 =  tex2D(s1, tx);  
     if (all(tx0 == tx1))
     return float4(1., 0., 1., 1.) ;
     return tx0; tex2D(s0, tex);     
}

float4 DiscardIfEqual(float2 tex : TEXCOORD0) : COLOR
{     
     float2 tx  =  Nearest(tex);  
     float4 tx0 =  tex2D(s0, tx); 
     float4 tx1 =  tex2D(s1, tx);  
     if (all(tx0 == tx1))
     discard ;
     return tx0; tex2D(s0, tex);     
};;