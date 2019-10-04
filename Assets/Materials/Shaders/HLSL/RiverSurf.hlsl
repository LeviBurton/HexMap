//UNITY_SHADER_NO_UPGRADE
#ifndef RIVERSURFHLSLINCLUDE_INCLUDED
#define RIVERSURFHLSLINCLUDE_INCLUDED

#include "Assets/Materials/Shaders/HLSL/Water.hlsl"

void Surf_float(float2 riverUV, float4 Color, Texture2D noiseTex, SamplerState ss, float time, out float4 Out)
{
	float river = River(riverUV, noiseTex, ss);
	Out = saturate(Color + river);
}

#endif