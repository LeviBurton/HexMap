//UNITY_SHADER_NO_UPGRADE
#ifndef WATERHLSLINCLUDE_INCLUDED
#define WATERHLSLINCLUDE_INCLUDED

float River(float2 riverUV, Texture2D noiseTex, SamplerState ss, float time)
{
	float2 uv = riverUV;
	uv.x = uv.x * 0.0625 + time * 0.005;
	uv.y -= time * 0.25;
	float4 noise = SAMPLE_TEXTURE2D(noiseTex, ss, uv);

	float2 uv2 = riverUV;
	uv2.x = uv2.x * 0.0625 - time * 0.0052;
	uv2.y -= time * 0.23;
	float4 noise2 = SAMPLE_TEXTURE2D(noiseTex, ss, uv2);

	return noise.x * noise2.w;
}

float Foam_float(float shore, float2 worldXZ, Texture2D noiseTex, SamplerState ss) {
	//	float shore = IN.uv_MainTex.y;
	shore = sqrt(shore) * 0.9;

	float2 noiseUV = worldXZ + _Time.y * 0.25;
	float4 noise = SAMPLE_TEXTURE2D(noiseTex, ss, noiseUV * 0.015);

	float distortion1 = noise.x * (1 - shore);
	float foam1 = sin((shore + distortion1) * 10 - _Time.y);
	foam1 *= foam1;

	float distortion2 = noise.y * (1 - shore);
	float foam2 = sin((shore + distortion2) * 10 + _Time.y + 2);
	foam2 *= foam2 * 0.7;

	return max(foam1, foam2) * shore;
}

float Waves_float(float2 worldXZ, Texture2D noiseTex, SamplerState ss) {
	float2 uv1 = worldXZ;
	uv1.y += _Time.y;
	float4 noise1 = SAMPLE_TEXTURE2D(noiseTex, ss, uv1 * 0.025);

	float2 uv2 = worldXZ;
	uv2.x += _Time.y;
	float4 noise2 = SAMPLE_TEXTURE2D(noiseTex, ss, uv2 * 0.025);

	float blendWave = sin(
		(worldXZ.x + worldXZ.y) * 0.1 +
		(noise1.y + noise2.z) + _Time.y
	);
	blendWave *= blendWave;

	float waves =
		lerp(noise1.z, noise1.w, blendWave) +
		lerp(noise2.x, noise2.y, blendWave);

	return smoothstep(0.75, 2, waves);
}


#endif