// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

Shader "Custom/SemiTransparent" {
    Properties {
        
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _AbsorptionColor ("Absorption Color", Color) = (1,1,1,1)
    }
    SubShader {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

       // Semi-transparent shader with light absorption
        // By [Your Name Here]

        #include "UnityCG.cginc"

        struct appdata {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
        };

        struct v2f {
            float4 vertex : SV_POSITION;
            float3 normal : NORMAL;
            float4 uv : TEXCOORD0;
        };
    
        struct Input {
            float3 worldPos;
            float3 worldNormal;
            float2 uv;
            INTERNAL_DATA
        };

    sampler2D _MainTex;
    float4 _MainTex_ST;
    float4 _Color;
    float4 _AbsorptionColor;


        void surf (Input IN, inout SurfaceOutputStandard o) {
            half4 tex = tex2D(_MainTex, IN.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw);
            half4 col = tex * _Color;
            half d = length(IN.worldPos.xyz) * 0.1;
            float3 absorption = 1 - exp(-_AbsorptionColor.rgb * d);
            o.Albedo = col * absorption;
            o.Albedo = (0,0,0,0);
            // o.Albedo = reflection;
            
        }

        ENDCG
    }
    FallBack "Diffuse"
}