;REMOTE SCRIPT START
g_.Spline :=
(
"
sampler s0 : register(s0);
float4 Spline(float2 tex : TEXCOORD0) : COLOR0
{
	// adapted from:
	// https://gist.github.com/TheRealMJP/c83b8c0f46b63f3a88a5986f4fa982b1
	
	// We're going to sample a a 4x4 grid of texels surrounding the target UV coordinate. We'll do this by rounding
    // down the sample location to get the exact center of our starting texel. The starting texel will be at
	// location [1, 1] in the grid, where [0, 0] is the top left corner.
	// Note: to realy sample the 4x4 grid, texture filtering must be enabled, otherwise we really only sample
	// one texel
	
	float2 texSize   = float2(ww., hh.);	
    float2 samplePos = tex * texSize;
    float2 texPos1   = floor(samplePos - 0.5f) + 0.5f;
	
	// Compute the fractional offset from our starting texel to our original sample location, which we'll
	// feed into the Catmull-Rom spline function to get our filter weights.
	float2 f         = samplePos - texPos1;
		
    float2 w0 = f * (-0.5f + f * (1.0f - 0.5f * f));
    float2 w1 = 1.0f + f * f * (-2.5f + 1.5f * f);
    float2 w2 = f * (0.5f + f * (2.0f - 1.5f * f));
    float2 w3 = f * f * (-0.5f + 0.5f * f);

    float2 w12 = w1 + w2;
    float2 offset12 = w2 / (w1 + w2);

    float2 texPos0 = texPos1 - 1;
    float2 texPos3 = texPos1 + 2;
    float2 texPos12 = texPos1 + offset12;

    texPos0 /= texSize;
    texPos3 /= texSize;
    texPos12 /= texSize;	
				
    float4 result = float4(0., 0., 0., 0.);
	result += tex2D(s0, float2(texPos0.x, texPos0.y)) * w0.x * w0.y;
    result += tex2D(s0, float2(texPos12.x, texPos0.y)) * w12.x * w0.y;
    result += tex2D(s0, float2(texPos3.x, texPos0.y)) * w3.x * w0.y;

    result += tex2D(s0, float2(texPos0.x, texPos12.y)) * w0.x * w12.y;
    result += tex2D(s0, float2(texPos12.x, texPos12.y)) * w12.x * w12.y;
    result += tex2D(s0, float2(texPos3.x, texPos12.y)) * w3.x * w12.y;

    result += tex2D(s0, float2(texPos0.x, texPos3.y)) * w0.x * w3.y;
    result += tex2D(s0, float2(texPos12.x, texPos3.y)) * w12.x * w3.y;
    result += tex2D(s0, float2(texPos3.x, texPos3.y)) * w3.x * w3.y;
	
	float3 black    = float3(0., 0., 0.);
	if ( all(result.rgb == black) )
		discard;
    return result;
}
"
)

g_.shogo_shader_code :=
(
"
sampler s0 : register(s0);
float4 main(float2 tex : TEXCOORD0, float4 diff : COLOR0) : COLOR
{
	float3 black    = float3(0.,0.,0.);
	float4 c0       = tex2D(s0, tex);
	if ( all(c0.rgb == black) )
		discard;	
	return c0*diff;			
}
"
)
;dllcall("UxTheme.dll\SetThemeAppProperties", uint, 0)
;Process, Priority, ,H

if (g_.cfg.shogo_filter)
D3DHOOKS_DATA.BltPrimary  := RegisterCallback("RenderTarget4_blt", "F")
;logerr(IDirectDrawSurface4.Hook("EnumAttachedSurfaces"))

/*
IDirectDrawSurface4_EnumAttachedSurfaces(p1, p2, p3)
{
	if ( GetSurfaceCaps4(p1) & DDSCAPS_PRIMARYSURFACE )
	{
		flip ? dllcall(IDirectDrawSurface4.Release, uint, flip)
		flip := ""
		(desc:= struct(DDSURFACEDESC2)).dwSize  :=  DDSURFACEDESC2.size()
		dllcall(IDirectDraw4.GetDisplayMode, uint, g_.pIDirectDraw4, uint, desc[])
		(g_.cfg.32bit) ? SetPixelFormat(desc, "X8RGB")
		desc.dwFlags        := DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT 
		desc.ddsCaps.dwCaps := GetPixelFormat(desc) = "PAL8" ? DDSCAPS_VIDEOMEMORY : DDSCAPS_VIDEOMEMORY | DDSCAPS_3DDEVICE
			
		VarSetCapacity(s, 4)	
		r := IDirectDraw4_CreateSurface(g_.pIDirectDraw4, desc[], &s, 0)
		VarSetCapacity(f, 4)
		if ! IDirectDraw4_CreateSurface(g_.pIDirectDraw4, desc[], &f, 0)
		{
			flip := numget(&f+0, "ptr")
			dllcall(IDirectDrawSurface4.AddAttachedSurface, uint, numget(&s+0, "ptr"), uint, numget(&f+0, "ptr"))	
			dllcall(IDirectDrawSurface4.release, uint, numget(&f+0, "ptr"))		
		}
		dllcall(IDirectDrawSurface4.GetSurfaceDesc, uint, numget(&s+0, "ptr"), uint, DDSURFACEDESC2[])
		dllcall(p3, uint, numget(&s+0, "ptr"), uint, DDSURFACEDESC2[], uint, p2)
		return r
	}
	return dllcall(IDirectDrawSurface4.EnumAttachedSurfaces, uint, p1, uint, p2, uint, p3)
}
*/
	
__Alt_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown)
{
	D    := struct(DDSURFACEDESC2)
	D[]  := pSurfaceDesc
	caps := D.ddsCaps.dwCaps
	; Without this the game fails to create the surface used for FMV playback
    ;(DDSURFACEDESC2.ddsCaps.dwCaps & DDSCAPS_TEXTURE) ?: DDSURFACEDESC2.ddsCaps.dwCaps &= ~ DDSCAPS_SYSTEMMEMORY
		
    r := IDirectDraw4_CreateSurface(pIDirectDraw4, pSurfaceDesc, ppSurface, pIUnknown)	
    if (caps & DDSCAPS_PRIMARYSURFACE) 
	{
		ww := D3DHOOKS_DATA.w
		hh := D3DHOOKS_DATA.h
		code := g_.shogo_shader_code
		;stringreplace, code, code, ww, %ww%, 1
		;stringreplace, code, code, hh, %hh%, 1
		g_.proxies.shader := D3DDDI_CreatePixelShader(code, "main")
				
		if (g_.cfg.shogo_filter) {
			g_HD.DDBLTFX.dwFillColor                           := 0
			g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceLowValue  := 0 
			g_HD.DDBLTFX.ddckSrcColorkey.dwColorSpaceHighValue := 0	
		}		
	}	
	return r
}

RenderTarget4_blt(p1, p2, p3, p4, p5, p6)
{
	if (GetSurfaceCaps4(p1) & DDSCAPS_3DDEVICE)
	{
		dllcall(IDirectDrawSurface4.blt, uint, g_.proxies.dev.Surface4, uint, p2, uint, p3, uint, p4, uint, p5, uint, p6, uint)		
		dllcall(g_.p.Scale, uint, p2, uint, g_HD.Sclr[]) 		
		;(p5 & DDBLT_KEYSRC) ? D3DDDI_SetShaderOverride(g_.proxies.shader)
		DEVICE3_RECT.Device3 :=  g_.proxies.D3D.Device3
		DEVICE3_RECT.Texture :=  g_.proxies.dev.Texture	
		dllcall(IDirect3DDevice3.GetTextureStageState, uint, DEVICE3_RECT.Device3, uint, 0, uint, 16, "uint*", filter)
		dllcall(IDirect3DDevice3.SetTextureStageState, uint, DEVICE3_RECT.Device3, uint, 0, uint, 16, uint, 3)	
		dllcall(g_.p.Dev3_DrawRect, uint, DEVICE3_RECT[], uint, g_HD.Sclr.dst, uint, g_HD.Sclr.src, uint)
		dllcall(IDirect3DDevice3.SetTextureStageState, uint, DEVICE3_RECT.Device3, uint, 0, uint, 16, uint, filter)	
		D3DDDI_RestoreShader()		
		dllcall(IDirectdrawSurface4.blt, uint, g_.rtrgt, uint, g_HD.Sclr.dst, uint, g_.proxies.D3D.surface4, uint, g_HD.Sclr.dst
										     , uint, (p5 & DDBLT_KEYSRC) ? DDBLT_KEYSRCOVERRIDE : DDBLT_NOCOLORKEY , uint, g_HD.DDBLTFX[], uint)	
		dllcall(IDirectdrawSurface4.blt, uint, g_.proxies.dev.Surface4, uint, g_HD.Sclr.src, uint, 0, uint, 0
										     , uint, DDBLT_COLORFILL, uint, g_HD.DDBLTFX[], uint)
		return					
	}	
	return Surface1Blt(p1, p2, p3, p4, p5, p6)	
}