Shader "Custom/DistanceToCameraShader" {
    Properties {
        _DistanceMultiplier("Distance Multiplier", Range(0, 1)) = 1
        _CamPos("_CamPos", Vector) = (0,0,0,0) 
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            float4 _CamPos;
            float _DistanceMultiplier;
            
            struct appdata {
                float4 vertex : POSITION;
            };
            
            struct v2f {
                float4 vertex : SV_POSITION;
                float4 worldPos : TEXCOORD0;
            };
            
            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target {
                float dd = distance(i.worldPos, _CamPos);
                return _CamPos;
                // return float4(dd * _DistanceMultiplier, 0, 0, 1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
