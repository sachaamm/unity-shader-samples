// A Shader using SinePower in order to form a ray light centered
Shader "Tuto/Unlit/9_RayOpaque"
{
	Properties
	{
		_Factor ("Factor", Range(0,1000)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Cull Off
			
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
			fixed _Factor;
			
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float val = abs(sin(i.uv.x * 3.1415926535897932384626433832795));
				return pow(val, _Factor);
			}
			ENDCG
		}
	}
}