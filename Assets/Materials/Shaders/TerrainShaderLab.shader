Shader "Custom/TerrainShaderLab"
{
	Properties
	{
		[NoScaleOffset] Texture2DArray_75DA1393("MainTex", 2DArray) = "white" {}
		Color_D339FB6D("Color", Color) = (1,1,1,1)
		[NoScaleOffset] Texture2D_FCA8815F("GridTex", 2D) = "white" {}
	}

	HLSLINCLUDE
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Packing.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/EntityLighting.hlsl"
	#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariables.hlsl"
	#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
	#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
#define SHADERGRAPH_PREVIEW 1

	CBUFFER_START(UnityPerMaterial)
	float4 Color_D339FB6D;
	CBUFFER_END

	TEXTURE2D_ARRAY(Texture2DArray_75DA1393); SAMPLER(samplerTexture2DArray_75DA1393);
	TEXTURE2D(Texture2D_FCA8815F); SAMPLER(samplerTexture2D_FCA8815F); float4 Texture2D_FCA8815F_TexelSize;
	float _GridOn;
	TEXTURE2D(_HexCellData); SAMPLER(sampler_HexCellData); float4 _HexCellData_TexelSize;
	float4 _TexelSize;
	SAMPLER(SamplerState_Linear_Repeat);
	SAMPLER(SamplerState_Point_Clamp);
	
	struct SurfaceDescriptionInputs
	{
		float3 WorldSpacePosition;
		float4 VertexColor;
		half4 uv1;
		half4 uv2;
	};

	// 824766974a655cd60476c0c364369d36
	#include "Assets/Materials/Shaders/TerrainSurf.hlsl"

	struct SurfaceDescription
	{
		float4 OutColor_3;
	};

	SurfaceDescription PopulateSurfaceData(SurfaceDescriptionInputs IN)
	{
		SurfaceDescription surface = (SurfaceDescription)0;
		float4 _UV_37BAB8BC_Out_0 = IN.uv2;
		float4 _Property_F61B2A5D_Out_0 = Color_D339FB6D;
		float _Property_DB3EAA58_Out_0 = _GridOn;
		float4 _UV_EDFE5441_Out_0 = IN.uv1;
		float4 _CustomFunction_397D6778_OutColor_3;
		Surf_float(IN.VertexColor, IN.WorldSpacePosition, (_UV_37BAB8BC_Out_0.xyz), Texture2DArray_75DA1393, SamplerState_Linear_Repeat, Texture2D_FCA8815F, _Property_F61B2A5D_Out_0, _Property_DB3EAA58_Out_0, SamplerState_Point_Clamp, (_UV_EDFE5441_Out_0.xyz), _CustomFunction_397D6778_OutColor_3);
		surface.OutColor_3 = _CustomFunction_397D6778_OutColor_3;
		return surface;
	}

	struct GraphVertexInput
	{
		float4 vertex : POSITION;
		float4 color : COLOR;
		float4 texcoord1 : TEXCOORD1;
		float4 texcoord2 : TEXCOORD2;
		float3 terrain : TEXCOORD3;
		UNITY_VERTEX_INPUT_INSTANCE_ID
	};

	GraphVertexInput PopulateVertexData(GraphVertexInput v)
	{
		return v;
	}

	ENDHLSL

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct GraphVertexOutput
			{
				float4 position : POSITION;
				float3 WorldSpacePosition : TEXCOORD0;
				float4 VertexColor : COLOR;
				half4 uv1 : TEXCOORD1;
				half4 uv2 : TEXCOORD2;
				float3 terrain : TEXCOORD3;

			};

			float4 GetCellData_New(GraphVertexInput v, int index) {

				float2 uv;
				uv.x = (v.texcoord2[index] + 0.5) * _HexCellData_TexelSize.x;
				float row = floor(uv.x);
				uv.x -= row;
				uv.y = (row + 0.5) * _HexCellData_TexelSize.y;
				float4 data = SAMPLE_TEXTURE2D_LOD(_HexCellData, sampler_HexCellData, float4(uv, 0, 0), 0);
				data.w *= 255;
				return data;
			}

			GraphVertexOutput vert(GraphVertexInput v)
			{
				v = PopulateVertexData(v);

				GraphVertexOutput o;
				float3 positionWS = TransformObjectToWorld(v.vertex);
				o.position = TransformWorldToHClip(positionWS);
				float3 WorldSpacePosition = mul(UNITY_MATRIX_M,v.vertex).xyz;
				float4 VertexColor = v.color;
				float4 uv1 = v.texcoord1;
				float4 uv2 = v.texcoord2;
				o.WorldSpacePosition = WorldSpacePosition;
				o.VertexColor = VertexColor;
				o.uv1 = uv1;
				o.uv2 = uv2;
		
				/// do terrain stuff  here.

				float4 cell0 = GetCellData_New(v, 0);
				float4 cell1 = GetCellData_New(v, 1);
				float4 cell2 = GetCellData_New(v, 2);
				o.terrain.x = cell0.w;
				o.terrain.y = cell1.w;
				o.terrain.z = cell2.w;

				return o;
			}

			float4 GetTerrainColor(float4 vertexColor, float3 worldPos, float3 terrain, int index, Texture2DArray terrainTex)
			{
				float4 c = SAMPLE_TEXTURE2D_ARRAY(terrainTex, samplerTexture2DArray_75DA1393, worldPos.xz * 0.02, terrain[index]);
				return c * vertexColor[index];
			}

			float4 frag(GraphVertexOutput IN) : SV_Target
			{
				float3 WorldSpacePosition = IN.WorldSpacePosition;
				float4 VertexColor = IN.VertexColor;
				float4 uv1 = IN.uv1;
				float4 uv2 = IN.uv2;

				SurfaceDescriptionInputs surfaceInput = (SurfaceDescriptionInputs)0;
				surfaceInput.WorldSpacePosition = WorldSpacePosition;
				surfaceInput.VertexColor = VertexColor;
				surfaceInput.uv1 = uv1;
				surfaceInput.uv2 = uv2;

				/// do terrain stuff  here.
				float4 c =
					GetTerrainColor(VertexColor, WorldSpacePosition, IN.terrain, 0, Texture2DArray_75DA1393) +
					GetTerrainColor(VertexColor, WorldSpacePosition, IN.terrain, 1, Texture2DArray_75DA1393) +
					GetTerrainColor(VertexColor, WorldSpacePosition, IN.terrain, 2, Texture2DArray_75DA1393);

				float4 grid = 1;

				if (_GridOn != 0)
				{
					float2 gridUV = WorldSpacePosition.xz;
					gridUV.x *= 1 / (4 * 8.66025404);
					gridUV.y *= 1 / (2 * 15.0);

					grid = SAMPLE_TEXTURE2D(Texture2D_FCA8815F, samplerTexture2D_FCA8815F, gridUV);
				}

				SurfaceDescription surf = PopulateSurfaceData(surfaceInput);
				surf.OutColor_3 = c * grid;

				return all(isfinite(surf.OutColor_3)) ? half4(surf.OutColor_3.x, surf.OutColor_3.y, surf.OutColor_3.z, 1.0) : float4(1.0f, 0.0f, 1.0f, 1.0f);

			}
			ENDHLSL
		}
	}
}
