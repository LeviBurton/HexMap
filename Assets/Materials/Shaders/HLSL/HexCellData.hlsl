//UNITY_SHADER_NO_UPGRADE

void GetCellData_float(float3 inUV, int index, Texture2D hexCellData, float2 texelSize, SamplerState ss, out float4 data)
{
	float2 uv;
	uv.x = (inUV[index] + 0.5) * texelSize.x;
	float row = floor(uv.x);
	uv.x -= row;
	uv.y = (row + 0.5) * texelSize.y;
	data = SAMPLE_TEXTURE2D_LOD(hexCellData, ss, float4(uv, 0, 0), 0);
	data.w *= 255;
}
