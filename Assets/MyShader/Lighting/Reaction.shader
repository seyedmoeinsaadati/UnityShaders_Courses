Shader "Unlit/Reaction"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _EmissionTex ("Emission", 2D) = "white" {}

        _Radius ("Radius", Range(0.0, 0.5)) = 0.3
        _Center ("Center", Range(0, 1)) = 0.5
        _Smooth ("Smooth", Range(0.0, 0.5)) = 0.01
        
    }
    SubShader
    {
        Tags {"RenderType"="Opaque"}
        
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            sampler2D _EmissionTex;
            float4 _EmissionTex_ST;

            float _Smooth;
            float _Radius;
            float _Center;

            float circle (float2 p, float center, float radius, float smooth)
            {
                float c = length(p - center) - radius;
                return smoothstep(c - smooth, c + smooth, radius);
            }

                       
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float c = circle(i.uv, _Center, _Radius, _Smooth);
                
                i.uv *= _EmissionTex_ST.xy;
                i.uv += _EmissionTex_ST.xy;
                col += tex2D(_EmissionTex, frac(i.uv)) * c * abs(sin(_Time.y));
                
                return col;
            }
            ENDCG
        }
    }
}
