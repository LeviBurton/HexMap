//UNITY_SHADER_NO_UPGRADE
#ifndef TERRAINHLSLINCLUDE_INCLUDED
#define TERRAINHLSLINCLUDE_INCLUDED

void GetTerrainColor_float(float4 vertexColor, float3 worldPos, float3 terrain, float3 visibility, int index, Texture2DArray terrainTex, SamplerState ss, out float4 color)
{
	float4 c = SAMPLE_TEXTURE2D_ARRAY(terrainTex, ss, worldPos.xz * 0.02, terrain[index]);
	color = c * (vertexColor[index] * visibility[index]);
}

#endif