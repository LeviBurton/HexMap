//UNITY_SHADER_NO_UPGRADE
#ifndef TERRAINSURFHLSLINCLUDE_INCLUDED
#define TERRAINSURFHLSLINCLUDE_INCLUDED

#include "Assets/Materials/Shaders/HLSL/HexCellData.hlsl"

// vertexColor stores splat map
float4 GetTerrainColor_float(float4 vertexColor, float3 worldPos, float3 terrain, int index, Texture2DArray terrainTex, SamplerState ss)
{
	float4 c = SAMPLE_TEXTURE2D_ARRAY(terrainTex, ss, worldPos.xz * 0.02, terrain[index]);
	return c * vertexColor[index];
}

void Surf_float(float4 vertexColor, float3 worldPos, float3 terrain, Texture2DArray terrainTex, SamplerState ss, Texture2D gridTex, float4 color, float gridOn, SamplerState ss2, float3 uv, out float4 OutColor)
{
	float4 cell0 = GetCellData(uv, 0, ss2);
	float4 cell1 = GetCellData(uv, 1, ss2);
	float4 cell2 = GetCellData(uv, 2, ss2);

	terrain.x = cell0.w;
	terrain.y = cell1.w;
	terrain.z = cell2.w;

	float4 c = GetTerrainColor_float(vertexColor, worldPos, terrain, 0, terrainTex, ss) +
		GetTerrainColor_float(vertexColor, worldPos, terrain, 1, terrainTex, ss) +
		GetTerrainColor_float(vertexColor, worldPos, terrain, 2, terrainTex, ss);

	float4 grid = 1;

	if (gridOn != 0)
	{
		float2 gridUV = worldPos.xz;
		gridUV.x *= 1 / (4 * 8.66025404);
		gridUV.y *= 1 / (2 * 15.0);

		grid = SAMPLE_TEXTURE2D(gridTex, ss, gridUV);
	}

	OutColor = c * grid * color;
}

#endif