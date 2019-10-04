//UNITY_SHADER_NO_UPGRADE
#ifndef WATERSHOREHLSLINCLUDE_INCLUDED
#define WATERSHOREHLSLINCLUDE_INCLUDED

#include "Assets/Materials/Shaders/HLSL/Water.hlsl"

void Surf_float(float2 uv, float4 Color, Texture2D noiseTex, float3 worldPos, SamplerState ss, float time, out float4 Out)
{
	float shore = uv.y;
	float foam = Foam_float(shore, worldPos.xz, noiseTex, ss);
	float waves = Waves_float(worldPos.xz, noiseTex, ss);
	waves *= 1 - shore;
	Out = saturate(Color + max(foam, waves));
}

#endif