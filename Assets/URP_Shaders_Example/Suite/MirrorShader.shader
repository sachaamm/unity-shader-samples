Shader "Custom/MirrorShader" {
    Properties {
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Cube ("Environment Cubemap", Cube) = "" {}
    }
    SubShader {
        Tags {"Queue"="Transparent" "RenderType"="Opaque"}
        LOD 100

        CGPROGRAM
        #pragma surface surf Standard

        // add any functions and variables you need here

        struct Input {
            float3 worldPos;
            float3 worldNormal;
            float2 uv;
            INTERNAL_DATA
        };
        
        float _Metallic;
        float _Glossiness;
        sampler2D _BumpMap;
        samplerCUBE _Cube;
       
        // add the surface function here
        // this function will determine the appearance of the mirror
        // based on the surface properties and lighting

// surface shader function
        void surf (Input IN, inout SurfaceOutputStandard o) {
            float3 reflection = reflect(normalize(IN.worldPos - _WorldSpaceCameraPos), IN.worldNormal);
            o.Albedo = texCUBE(_Cube, reflection).rgb;
            // o.Albedo = reflection;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv));
        }

        ENDCG
    }
    FallBack "Diffuse"
}