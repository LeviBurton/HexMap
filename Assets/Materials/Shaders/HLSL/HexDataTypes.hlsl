//UNITY_SHADER_NO_UPGRADE
#ifndef TERRAINHLSLINCLUDE_INCLUDED
#define TERRAINHLSLINCLUDE_INCLUDED

float4 GetTerrainColor(GraphVertexOutput IN, int index)
{
	float4 c = SAMPLE_TEXTURE2D_ARRAY(Texture2DArray_75DA1393, samplerTexture2DArray_75DA1393, IN.WorldSpacePosition.xz * 0.02, IN.terrain[index]);
	return c * (IN.VertexColor[index] * IN.visibility[index]);
}

#endif