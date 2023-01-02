// A Transparent Shader ( Tags Queue is Transparent , ZWrite set to off and Blend SrcAlpha OneMinusSrcAlpha = use alpha blending
Shader "Tuto/Unlit/4_TransparentGrid"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_Frequency("Frequency", Float) = 1
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }
		LOD 100

		Pass
		{
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
			
			float4 _Color;
			float _Frequency;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv; 
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float valA = abs(cos(i.uv.xxxx * 3.1415926535897932384626433832795 * 2.0 * _Frequency));
				float valB = abs(cos(i.uv.yyyy * 3.1415926535897932384626433832795 * 2.0 * _Frequency));
				
				return ((valA.xxxx + valB.xxxx)/2) * _Color; 
			}
			ENDCG
		}
	}
}