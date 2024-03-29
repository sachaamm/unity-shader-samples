﻿// WIP
Shader "Tuto/Unlit/10_ThunderTest"
{
   Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_XOffset ("XOffset", Range(0,1)) = 1
		_FrequencyX ("FrequencyX", Range(0,1000)) = 10
		_FrequencyY ("FrequencyY", Range(0,1000)) = 10
		_FrequencyC ("FrequencyC", Range(0,10)) = 10
		_FrequencyD ("FrequencyD", Range(-10,10)) = 0
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }
		LOD 100

		Pass
		{
			Cull Off
			
			ZWrite Off // don't write to depth buffer 
            // in order not to occlude other objects

			Blend SrcAlpha OneMinusSrcAlpha // use alpha blending
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				// UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};
			
			fixed4 _Color;
			fixed4 _Color2;
			fixed _XOffset;
			fixed _FrequencyX, _FrequencyY, _FrequencyC, _FrequencyD;
			
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			float Remap (float value, float from1, float to1, float from2, float to2) {
				return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
			}
   
			
			fixed4 frag (v2f i) : SV_Target
			{
				float frequencyB = sin(i.uv.y * _FrequencyY * 3.14);

				float offset = _Time.w;
				float t = cos( (i.uv.x + offset) * 3.14 * _FrequencyX ) * 0.5 + 0.5;

				fixed4 val = _Color * frac(i.uv.x * _FrequencyX + i.uv.y * _FrequencyY + i.uv.x * _FrequencyC + offset);
				
				return clamp(min(val, frac(t + frequencyB)),0,1);
			}
			ENDCG
		}
		}
}