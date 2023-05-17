Shader "Custom/SimpleDirectionalBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _UvOffset("UvOffset", Vector) = (0.001,0.001,0,0) 
        _Points("Points", int) = 346
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            sampler2D _MainTex;
            float4 _UvOffset;
            int _Points;

        fixed4 frag (v2f i) : SV_Target
        {
                fixed4 col = (0,0,0,0);
                
                float timeRatio = cos(_Time.w);
                
                for(int k = 0; k < _Points; k++){
                    col += tex2D(_MainTex, i.uv + _UvOffset * k * timeRatio);
                }
               
                return (col)/_Points;
            }
            
            ENDCG
        }
    }
}