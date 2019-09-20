//UNITY_SHADER_NO_UPGRADE
#ifndef TERRAINSURFHLSLINCLUDE_INCLUDED
#define TERRAINSURFHLSLINCLUDE_INCLUDED

// vertexColor stores splat map
float4 GetTerrainColor(float4 vertexColor, float3 worldPos, float4 terrain, int index, Texture2DArray terrainTex, SamplerState ss)
{
	float4 c = SAMPLE_TEXTURE2D_ARRAY(terrainTex, ss, worldPos.xz * 0.02, terrain[index]);
	return c * vertexColor[index];
}

void Surf_float(float4 vertexColor, float3 worldPos, float4 terrain, Texture2DArray terrainTex, SamplerState ss, out float4 OutColor)
{
	float4 c = GetTerrainColor(vertexColor, worldPos, terrain, 0, terrainTex, ss) +
		GetTerrainColor(vertexColor, worldPos, terrain, 1, terrainTex, ss) +
		GetTerrainColor(vertexColor, worldPos, terrain, 2, terrainTex, ss);

	OutColor = c;
}

#endif