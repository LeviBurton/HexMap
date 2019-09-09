//UNITY_SHADER_NO_UPGRADE
#ifndef WATERSHOREHLSLINCLUDE_INCLUDED
#define WATERSHOREHLSLINCLUDE_INCLUDED

void Surf_float(float2 uv, float4 Color, Texture2D noiseTex, float3 worldPos, SamplerState ss, float time, out float4 Out)
{
	float shore = uv.y;
	shore = sqrt(shore);

	float2 noiseUV = worldPos.xz + time * 0.25;
	float4 noise = SAMPLE_TEXTURE2D(noiseTex, ss, noiseUV * 0.015);

	float distortion1 = noise.x * (1 - shore);
	float foam1 = sin((shore + distortion1) * 10 - time);
	foam1 *= foam1;

	float distortion2 = noise.y * (1 - shore);
	float foam2 = sin((shore + distortion2) * 10 + time);
	foam2 *= foam2 * 0.7;

	float foam = max(foam1, foam2) * shore;

	Out = saturate(Color + foam);
}

#endif