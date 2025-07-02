;REMOTE SCRIPT START

AltIDirectDrawSurface_flip(p1, p2, p3)
{
    static last := 0
    now         := dllcall(g_.p.GetTicks, "double")
    while (now - last < 6.944444444444444)
    {
        now  := dllcall(g_.p.GetTicks, "double")
    }
    last := now
    r := IDirectDrawSurface_flip(p1, p2, p3)
    ;fix shadow bug when ssaa is enabled
    ;dllcall(IDirect3DDevice3.SetTextureStageState, ptr, g_.Device3, uint, 0, uint, D3DTSS_ADDRESS:=12, uint, D3DTADDRESS_CLAMP:=3)
    dllcall(IDirect3DDevice3.SetRenderState, ptr, g_.Device3, uint, D3DRENDERSTATE_TEXTUREADDRESS:=3, uint, D3DTADDRESS_CLAMP:=3)
    return r
}