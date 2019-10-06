Shader "Unlit/HighlightShader"
{
	Properties
	{
		[NoScaleOffset] Texture2D_1DC49A74("_MainTex", 2D) = "white" {}
[NoScaleOffset] Texture2D_1009D103("_MaskTex", 2D) = "white" {}
[NoScaleOffset] Texture2D_CFD6E88F("_NormalTex", 2D) = "bump" {}

	}
		SubShader
	{
		Tags{ "RenderPipeline" = "LightweightPipeline"}
		Tags
		{
			"RenderPipeline" = "LightweightPipeline"
			"RenderType" = "Transparent"
			"IgnoreProjector"="True"
			"Queue" = "Transparent+10"
		}

		Cull Off
		ZWrite Off
		ZTest Always

		Pass
		{
			Name "Sprite Lit"
			Tags { "LightMode" = "Lightweight2D" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha

			HLSLPROGRAM
		// Required to compile gles 2.0 with standard srp library
		#pragma prefer_hlslcc gles
		#pragma exclude_renderers d3d11_9x
		#pragma target 2.0

		#pragma vertex vert
		#pragma fragment frag

		#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
		#pragma multi_compile USE_SHAPE_LIGHT_TYPE_0 __
		#pragma multi_compile USE_SHAPE_LIGHT_TYPE_1 __
		#pragma multi_compile USE_SHAPE_LIGHT_TYPE_2 __
		#pragma multi_compile USE_SHAPE_LIGHT_TYPE_3 __



		#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
		#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
		#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
		#include "Packages/com.unity.render-pipelines.lightweight/Shaders/2D/Include/LightingUtility.hlsl"

	#if ETC1_EXTERNAL_ALPHA
		TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
		float _EnableAlphaTexture;
	#endif

		#if USE_SHAPE_LIGHT_TYPE_0
		SHAPE_LIGHT(0)
		#endif

		#if USE_SHAPE_LIGHT_TYPE_1
		SHAPE_LIGHT(1)
		#endif

		#if USE_SHAPE_LIGHT_TYPE_2
		SHAPE_LIGHT(2)
		#endif

		#if USE_SHAPE_LIGHT_TYPE_3
		SHAPE_LIGHT(3)
		#endif

		#include "Packages/com.unity.render-pipelines.lightweight/Shaders/2D/Include/CombinedShapeLightShared.hlsl"

		CBUFFER_START(UnityPerMaterial)
		CBUFFER_END

		TEXTURE2D(Texture2D_1DC49A74); SAMPLER(samplerTexture2D_1DC49A74); float4 Texture2D_1DC49A74_TexelSize;
		TEXTURE2D(Texture2D_1009D103); SAMPLER(samplerTexture2D_1009D103); float4 Texture2D_1009D103_TexelSize;
		TEXTURE2D(Texture2D_CFD6E88F); SAMPLER(samplerTexture2D_CFD6E88F); float4 Texture2D_CFD6E88F_TexelSize;
		SAMPLER(_SampleTexture2D_9FD08744_Sampler_3_Linear_Repeat);
		SAMPLER(_SampleTexture2D_D594E07D_Sampler_3_Linear_Repeat);
		struct VertexDescriptionInputs
		{
			float3 ObjectSpacePosition;
		};

		struct SurfaceDescriptionInputs
		{
			half4 uv0;
		};


		struct VertexDescription
		{
			float3 Position;
		};

		VertexDescription PopulateVertexData(VertexDescriptionInputs IN)
		{
			VertexDescription description = (VertexDescription)0;
			description.Position = IN.ObjectSpacePosition;
			return description;
		}

		struct SurfaceDescription
		{
			float4 Color;
			float4 Mask;
		};

		SurfaceDescription PopulateSurfaceData(SurfaceDescriptionInputs IN)
		{
			SurfaceDescription surface = (SurfaceDescription)0;
			float4 _SampleTexture2D_9FD08744_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_1DC49A74, samplerTexture2D_1DC49A74, IN.uv0.xy);
			float _SampleTexture2D_9FD08744_R_4 = _SampleTexture2D_9FD08744_RGBA_0.r;
			float _SampleTexture2D_9FD08744_G_5 = _SampleTexture2D_9FD08744_RGBA_0.g;
			float _SampleTexture2D_9FD08744_B_6 = _SampleTexture2D_9FD08744_RGBA_0.b;
			float _SampleTexture2D_9FD08744_A_7 = _SampleTexture2D_9FD08744_RGBA_0.a;
			float4 _SampleTexture2D_D594E07D_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_1009D103, samplerTexture2D_1009D103, IN.uv0.xy);
			float _SampleTexture2D_D594E07D_R_4 = _SampleTexture2D_D594E07D_RGBA_0.r;
			float _SampleTexture2D_D594E07D_G_5 = _SampleTexture2D_D594E07D_RGBA_0.g;
			float _SampleTexture2D_D594E07D_B_6 = _SampleTexture2D_D594E07D_RGBA_0.b;
			float _SampleTexture2D_D594E07D_A_7 = _SampleTexture2D_D594E07D_RGBA_0.a;
			surface.Color = _SampleTexture2D_9FD08744_RGBA_0;
			surface.Mask = _SampleTexture2D_D594E07D_RGBA_0;
			return surface;
		}

		struct GraphVertexInput
		{
			float4 vertex : POSITION;
			float4 color : COLOR;
			float4 texcoord0 : TEXCOORD0;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};


		struct GraphVertexOutput
		{
			float4 positionCS : POSITION;
			half2  lightingUV : TEXCOORD0;
			float4 VertexColor : COLOR;
			half4 uv0 : TEXCOORD3;

		};

		GraphVertexOutput vert(GraphVertexInput v)
		{
			GraphVertexOutput o = (GraphVertexOutput)0;
			float3 WorldSpacePosition = mul(UNITY_MATRIX_M,v.vertex).xyz;
			float4 VertexColor = v.color;
			float4 uv0 = v.texcoord0;
			float3 ObjectSpacePosition = mul(UNITY_MATRIX_I_M,float4(WorldSpacePosition,1.0)).xyz;

			VertexDescriptionInputs vdi = (VertexDescriptionInputs)0;
			vdi.ObjectSpacePosition = ObjectSpacePosition;

			VertexDescription vd = PopulateVertexData(vdi);

			v.vertex.xyz = vd.Position;
			VertexColor = v.color;

			o.positionCS = TransformObjectToHClip(v.vertex.xyz);
			float4 clipVertex = o.positionCS / o.positionCS.w;
			o.lightingUV = ComputeScreenPos(clipVertex).xy;

			#if UNITY_UV_STARTS_AT_TOP
			o.lightingUV.y = 1.0 - o.lightingUV.y;
			#endif

			o.VertexColor = VertexColor;
			o.uv0 = uv0;

			return o;
		}

		half4 frag(GraphVertexOutput IN) : SV_Target
		{
			float4 VertexColor = IN.VertexColor;
			float4 uv0 = IN.uv0;

			SurfaceDescriptionInputs surfaceInput = (SurfaceDescriptionInputs)0;
			surfaceInput.uv0 = uv0;

			SurfaceDescription surf = PopulateSurfaceData(surfaceInput);

	#if ETC1_EXTERNAL_ALPHA
			float4 alpha = SAMPLE_TEXTURE2D(_AlphaTex, sampler_AlphaTex, IN.uv0.xy);
			surf.Color.a = lerp(surf.Color.a, alpha.r, _EnableAlphaTexture);
	#endif
			surf.Color *= IN.VertexColor;

			return CombinedShapeLightShared(surf.Color, surf.Mask, IN.lightingUV);
		}

		ENDHLSL
	}
	Pass
	{
		Name "Sprite Normal"
		Tags { "LightMode" = "NormalsRendering" }


		Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha

		Cull Off

		ZWrite Off

		HLSLPROGRAM
			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 2.0

			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA


			#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.lightweight/Shaders/2D/Include/NormalsRenderingShared.hlsl"

		#if ETC1_EXTERNAL_ALPHA
			TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
			float _EnableAlphaTexture;
		#endif

			CBUFFER_START(UnityPerMaterial)
			CBUFFER_END

			TEXTURE2D(Texture2D_1DC49A74); SAMPLER(samplerTexture2D_1DC49A74); float4 Texture2D_1DC49A74_TexelSize;
			TEXTURE2D(Texture2D_1009D103); SAMPLER(samplerTexture2D_1009D103); float4 Texture2D_1009D103_TexelSize;
			TEXTURE2D(Texture2D_CFD6E88F); SAMPLER(samplerTexture2D_CFD6E88F); float4 Texture2D_CFD6E88F_TexelSize;
			SAMPLER(_SampleTexture2D_9FD08744_Sampler_3_Linear_Repeat);
			SAMPLER(_SampleTexture2D_CDEC509C_Sampler_3_Linear_Repeat);
			struct VertexDescriptionInputs
			{
				float3 ObjectSpacePosition;
			};

			struct SurfaceDescriptionInputs
			{
				half4 uv0;
			};


			struct VertexDescription
			{
				float3 Position;
			};

			VertexDescription PopulateVertexData(VertexDescriptionInputs IN)
			{
				VertexDescription description = (VertexDescription)0;
				description.Position = IN.ObjectSpacePosition;
				return description;
			}

			struct SurfaceDescription
			{
				float4 Color;
				float3 Normal;
			};

			SurfaceDescription PopulateSurfaceData(SurfaceDescriptionInputs IN)
			{
				SurfaceDescription surface = (SurfaceDescription)0;
				float4 _SampleTexture2D_9FD08744_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_1DC49A74, samplerTexture2D_1DC49A74, IN.uv0.xy);
				float _SampleTexture2D_9FD08744_R_4 = _SampleTexture2D_9FD08744_RGBA_0.r;
				float _SampleTexture2D_9FD08744_G_5 = _SampleTexture2D_9FD08744_RGBA_0.g;
				float _SampleTexture2D_9FD08744_B_6 = _SampleTexture2D_9FD08744_RGBA_0.b;
				float _SampleTexture2D_9FD08744_A_7 = _SampleTexture2D_9FD08744_RGBA_0.a;
				float4 _SampleTexture2D_CDEC509C_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_CFD6E88F, samplerTexture2D_CFD6E88F, IN.uv0.xy);
				float _SampleTexture2D_CDEC509C_R_4 = _SampleTexture2D_CDEC509C_RGBA_0.r;
				float _SampleTexture2D_CDEC509C_G_5 = _SampleTexture2D_CDEC509C_RGBA_0.g;
				float _SampleTexture2D_CDEC509C_B_6 = _SampleTexture2D_CDEC509C_RGBA_0.b;
				float _SampleTexture2D_CDEC509C_A_7 = _SampleTexture2D_CDEC509C_RGBA_0.a;
				surface.Color = _SampleTexture2D_9FD08744_RGBA_0 * 0.1f;
				surface.Normal = (_SampleTexture2D_CDEC509C_RGBA_0.xyz);
				return surface;
			}

			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 texcoord0 : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};


			struct GraphVertexOutput
			{
				float4	position		: POSITION;
				float3  normalWS		: TEXCOORD0;
				float3  tangentWS		: TEXCOORD1;
				float3  bitangentWS		: TEXCOORD2;
				float4 VertexColor : COLOR;
				half4 uv0 : TEXCOORD3;

			};

			GraphVertexOutput vert(GraphVertexInput v)
			{
				GraphVertexOutput o = (GraphVertexOutput)0;
				float3 WorldSpacePosition = mul(UNITY_MATRIX_M,v.vertex).xyz;
				float4 VertexColor = v.color;
				float4 uv0 = v.texcoord0;
				float3 ObjectSpacePosition = mul(UNITY_MATRIX_I_M,float4(WorldSpacePosition,1.0)).xyz;

				VertexDescriptionInputs vdi = (VertexDescriptionInputs)0;
				vdi.ObjectSpacePosition = ObjectSpacePosition;

				VertexDescription vd = PopulateVertexData(vdi);

				v.vertex.xyz = vd.Position;
				o.position = TransformObjectToHClip(v.vertex.xyz);
				#if UNITY_UV_STARTS_AT_TOP
					o.position.y = -o.position.y;
				#endif
				o.normalWS = TransformObjectToWorldDir(float3(0, 0, 1));
				o.tangentWS = TransformObjectToWorldDir(float3(1, 0, 0));
				o.bitangentWS = TransformObjectToWorldDir(float3(0, 1, 0));
				o.VertexColor = VertexColor;
				o.uv0 = uv0;

				return o;
			}

			half4 frag(GraphVertexOutput IN) : SV_Target
			{
				float4 VertexColor = IN.VertexColor;
				float4 uv0 = IN.uv0;

				SurfaceDescriptionInputs surfaceInput = (SurfaceDescriptionInputs)0;
				surfaceInput.uv0 = uv0;

				SurfaceDescription surf = PopulateSurfaceData(surfaceInput);

				return NormalsRenderingShared(surf.Color, surf.Normal, IN.tangentWS.xyz, IN.bitangentWS.xyz, -IN.normalWS.xyz);;
			}

			ENDHLSL
		}

		Pass
		{
			Name "Sprite Forward"
			Tags{"LightMode" = "LightweightForward"}


			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha

			Cull Off

			ZWrite OFf

			HLSLPROGRAM
				// Required to compile gles 2.0 with standard srp library
				#pragma prefer_hlslcc gles
				#pragma exclude_renderers d3d11_9x
				#pragma target 2.0

				#pragma vertex vert
				#pragma fragment frag

				#pragma multi_compile _ ETC1_EXTERNAL_ALPHA


				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
				#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
				float _EnableAlphaTexture;
			#endif
				float4 _RendererColor;

				CBUFFER_START(UnityPerMaterial)
				CBUFFER_END

				TEXTURE2D(Texture2D_1DC49A74); SAMPLER(samplerTexture2D_1DC49A74); float4 Texture2D_1DC49A74_TexelSize;
				TEXTURE2D(Texture2D_1009D103); SAMPLER(samplerTexture2D_1009D103); float4 Texture2D_1009D103_TexelSize;
				TEXTURE2D(Texture2D_CFD6E88F); SAMPLER(samplerTexture2D_CFD6E88F); float4 Texture2D_CFD6E88F_TexelSize;
				SAMPLER(_SampleTexture2D_9FD08744_Sampler_3_Linear_Repeat);
				SAMPLER(_SampleTexture2D_CDEC509C_Sampler_3_Linear_Repeat);
				struct VertexDescriptionInputs
				{
					float3 ObjectSpacePosition;
				};

				struct SurfaceDescriptionInputs
				{
					half4 uv0;
				};


				struct VertexDescription
				{
					float3 Position;
				};

				VertexDescription PopulateVertexData(VertexDescriptionInputs IN)
				{
					VertexDescription description = (VertexDescription)0;
					description.Position = IN.ObjectSpacePosition;
					return description;
				}

				struct SurfaceDescription
				{
					float4 Color;
					float3 Normal;
				};

				SurfaceDescription PopulateSurfaceData(SurfaceDescriptionInputs IN)
				{
					SurfaceDescription surface = (SurfaceDescription)0;
					float4 _SampleTexture2D_9FD08744_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_1DC49A74, samplerTexture2D_1DC49A74, IN.uv0.xy);
					float _SampleTexture2D_9FD08744_R_4 = _SampleTexture2D_9FD08744_RGBA_0.r;
					float _SampleTexture2D_9FD08744_G_5 = _SampleTexture2D_9FD08744_RGBA_0.g;
					float _SampleTexture2D_9FD08744_B_6 = _SampleTexture2D_9FD08744_RGBA_0.b;
					float _SampleTexture2D_9FD08744_A_7 = _SampleTexture2D_9FD08744_RGBA_0.a;
					float4 _SampleTexture2D_CDEC509C_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_CFD6E88F, samplerTexture2D_CFD6E88F, IN.uv0.xy);
					float _SampleTexture2D_CDEC509C_R_4 = _SampleTexture2D_CDEC509C_RGBA_0.r;
					float _SampleTexture2D_CDEC509C_G_5 = _SampleTexture2D_CDEC509C_RGBA_0.g;
					float _SampleTexture2D_CDEC509C_B_6 = _SampleTexture2D_CDEC509C_RGBA_0.b;
					float _SampleTexture2D_CDEC509C_A_7 = _SampleTexture2D_CDEC509C_RGBA_0.a;
					surface.Color = _SampleTexture2D_9FD08744_RGBA_0;
					surface.Normal = (_SampleTexture2D_CDEC509C_RGBA_0.xyz);
					return surface;
				}

				struct GraphVertexInput
				{
					float4 vertex : POSITION;
					float4 color : COLOR;
					float4 texcoord0 : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};


				struct GraphVertexOutput
				{
					float4 position : POSITION;
					float4 VertexColor : COLOR;
					half4 uv0 : TEXCOORD3;

				};

				GraphVertexOutput vert(GraphVertexInput v)
				{
					GraphVertexOutput o = (GraphVertexOutput)0;
					float3 WorldSpacePosition = mul(UNITY_MATRIX_M,v.vertex).xyz;
					float4 VertexColor = v.color;
					float4 uv0 = v.texcoord0;
					float3 ObjectSpacePosition = mul(UNITY_MATRIX_I_M,float4(WorldSpacePosition,1.0)).xyz;

					VertexDescriptionInputs vdi = (VertexDescriptionInputs)0;
					vdi.ObjectSpacePosition = ObjectSpacePosition;

					VertexDescription vd = PopulateVertexData(vdi);

					v.vertex.xyz = vd.Position;
					VertexColor = v.color;
					o.position = TransformObjectToHClip(v.vertex.xyz);

					o.VertexColor = VertexColor;
					o.uv0 = uv0;

					return o;
				}

				half4 frag(GraphVertexOutput IN) : SV_Target
				{
					float4 VertexColor = IN.VertexColor;
					float4 uv0 = IN.uv0;

					SurfaceDescriptionInputs surfaceInput = (SurfaceDescriptionInputs)0;
					surfaceInput.uv0 = uv0;

					SurfaceDescription surf = PopulateSurfaceData(surfaceInput);

			#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D(_AlphaTex, sampler_AlphaTex, IN.uv0.xy);
					surf.Color.a = lerp(surf.Color.a, alpha.r, _EnableAlphaTexture);
			#endif

					surf.Color *= IN.VertexColor;
					return surf.Color;
				}

				ENDHLSL
			}
	}
		FallBack "Hidden/InternalErrorShader"
}
