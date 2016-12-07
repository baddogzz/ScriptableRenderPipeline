Shader "Hidden/VFX_8"
{
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Pass
		{
			Blend SrcAlpha One
			ZTest LEqual
			ZWrite Off
			Cull Off
			
			CGPROGRAM
			#pragma target 5.0
			
			#pragma vertex vert
			#pragma fragment frag
			
			#define VFX_LOCAL_SPACE
			
			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "HLSLSupport.cginc"
			#include "../VFXCommon.cginc"
			
			CBUFFER_START(outputUniforms)
				float3 outputUniform0;
			CBUFFER_END
			
			struct OutputData
			{
				float3 position;
				uint _PADDING_0;
			};
			
			StructuredBuffer<OutputData> outputBuffer;
			
			struct ps_input
			{
				/*linear noperspective centroid*/ float4 pos : SV_POSITION;
				nointerpolation float4 col : COLOR0;
			};
			
			void VFXBlockSetColorConstant( inout float3 color,float3 Color)
			{
				color = Color;
			}
			
			ps_input vert (uint id : SV_VertexID, uint instanceID : SV_InstanceID)
			{
				ps_input o;
				uint index = id;
				OutputData outputData = outputBuffer[index];
				
				float3 local_color = (float3)0;
				
				VFXBlockSetColorConstant( local_color,outputUniform0);
				
				float3 worldPos = outputData.position;
				o.pos = mul(UNITY_MATRIX_MVP, float4(worldPos,1.0f));
				o.col = float4(local_color.xyz,0.5);
				return o;
			}
			
			struct ps_output
			{
				float4 col : SV_Target0;
			};
			
			ps_output frag (ps_input i)
			{
				ps_output o = (ps_output)0;
				
				float4 color = i.col;
				
				o.col = color;
				return o;
			}
			
			ENDCG
		}
	}
	FallBack Off
}
