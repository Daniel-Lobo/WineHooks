;REMOTE SCRIPT START
g_pswap9.override_code := 
(
"
sampler s0 : register(s0);
float4 main(float2 tex : TEXCOORD0, float4 diff : COLOR0) : COLOR0
{
	return tex2D(s0, tex) * diff;
}
"
)
/* The launcher will edit this everytime the game starts,
 * so we either edit again or set it to read only
 */

 
SOTInit()
SOTInit()
{
	if fileexist("Hardware.ini")
	{
		f=Hardware.ini
		IniWrite, 1, %f%, CAPS, ForceVSFog
		IniWrite, 0, %f%, CAPS, InvertFogRange
		IniWrite, 0, %f%, CAPS, ZEnableFix
	}
	res := Desk()
	w   := res.w
	h   := res.h
	if fileexist("POP.ini")
	{
		f=POP.ini
		IniWrite, %w%, %f%, MAIN, Width 
		IniWrite, %h%, %f%, MAIN, Height 
	}	
}	