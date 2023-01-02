// WIP
Shader "Tuto/Unlit/10_ThunderTest"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Factor ("Factor", Range(0,1000)) = 1
        _FrequencyX ("FrequencyX", Range(0,1000)) = 10
        _FrequencyY ("FrequencyY", Range(0,1000)) = 10
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
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
            fixed _FrequencyX, _FrequencyY;


            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // float valA = abs(cos(i.uv.xxxx * 3.1415926535897932384626433832795 * 2.0 * _Frequency));
                // float valB = 1 - pow(valA.xxxx,_Factor);

                // float sine = sin(i.uv.x * _FrequencyX * 3.14) / sin(i.uv.x * _FrequencyY * 3.14);
                float sine = sin(i.uv.x * _FrequencyX * 3.14) * sin(i.uv.y * _FrequencyY * 3.14);
                return clamp(sine, 0, 1);
            }
            ENDCG
        }
    }
}