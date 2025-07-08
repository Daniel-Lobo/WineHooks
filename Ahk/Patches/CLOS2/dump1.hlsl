// HLSL translation of the provided assembly shader

// Shader parameters
float4 g_avSampleOffsets[25];
float4 g_avSampleWeights[25];
sampler2D s0;

// Pixel shader
float4 main(float2 texCoord : TEXCOORD) : COLOR
{
    float4 result = 0;

    // Perform weighted sampling using offsets and weights
    for (int i = 0; i < 25; i++)
    {
        float2 offset = g_avSampleOffsets[i].xy * float2(2.0, 2.0);
        float4 sample = tex2D(s0, texCoord + offset);
        result += sample * g_avSampleWeights[i];
    }

    return 0;
}