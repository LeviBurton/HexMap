//UNITY_SHADER_NO_UPGRADE
#ifndef HEXCELLDATAHLSLINCLUDE_INCLUDED
#define HEXCELLDATAHLSLINCLUDE_INCLUDED

float4 GetCellData(float3 inUV, int index, SamplerState ss) 
{
	float2 uv;
	uv.x = (inUV[index] + 0.5) * _TexelSize.x;
	float row = floor(uv.x);
	uv.x -= row;
	uv.y = (row + 0.5) * _TexelSize.y;
	float4 data = SAMPLE_TEXTURE2D_LOD(_HexCellData, ss, float4(uv, 0, 0), 0);
	data.w *= 255;
	return data;
}


#endif