// A rect Shader
Shader "Tuto/Unlit/5_Rect"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Width("Width", Float) = 1
        _Height("Height", Float) = 1
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
        }
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
            float _Width;
            float _Height;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                const float minXValToDisplay = 0.5 - _Width / 2;
                const float maxXValToDisplay = 0.5 + _Width / 2;

                const float minYValToDisplay = 0.5 - _Height / 2;
                const float maxYValToDisplay = 0.5 + _Height / 2;

                const bool display =
                    i.uv.x > minXValToDisplay &&
                    i.uv.x < maxXValToDisplay &&
                    i.uv.y > minYValToDisplay &&
                    i.uv.y < maxYValToDisplay;

                return display ? 1 : 0;
            }
            ENDCG
        }
    }
}