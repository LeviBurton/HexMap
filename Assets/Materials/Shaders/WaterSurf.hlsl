//UNITY_SHADER_NO_UPGRADE
#ifndef WATERSURFHLSLINCLUDE_INCLUDED
#define WATERSURFHLSLINCLUDE_INCLUDED

#include "Assets/Materials/Shaders/Water.hlsl"

void Surf_float(float2 worldXZ, float time, Texture2D noiseTex, float4 mainColor, SamplerState ss, out float4 Out)
{
	float waves = Waves_float(worldXZ, noiseTex, ss);
	Out = saturate(mainColor + waves);
}

#endif