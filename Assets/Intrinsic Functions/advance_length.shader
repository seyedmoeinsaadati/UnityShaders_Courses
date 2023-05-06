Shader "Unlit/advance_length"
{
    Properties
    {
        _Texture1 ("Texture 1", 2D) = "white" {}
        _Texture2 ("Texture 2", 2D) = "white" {}
        
        _OffsetX ("Offset X", Range(0, 1)) = 0.5
        _OffsetY ("Offset Y", Range(0, 1)) = 0.5

        _ScaleX ("Scale X", Range(0, 10)) = 0.5
        _ScaleY ("Scale Y", Range(0, 10)) = 0.5

        _Radius ("Radius", Range(0.0, 2)) = 0.3
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

            sampler2D _Texture1, _Texture2;
            float4 _Texture1_ST, _Texture2_ST;
            float _Smooth;
            float _Radius;
            float _OffsetX, _OffsetY;
            float _ScaleX, _ScaleY;

            float circle (float2 p, float2 center, float radius, float smooth)
            {
                float c = length(p - center) - radius;
                return smoothstep(c - smooth, c + smooth, radius);
            }
                       
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 col1 = tex2D(_Texture1, i.uv);
                half4 col2 = tex2D(_Texture2, i.uv);
                float t = circle(i.uv * float2(_ScaleX, _ScaleY), float2(_OffsetX, _OffsetY), _Radius, _Smooth);
                fixed4 col = lerp(col1, col2, t);
                return fixed4(col.rgb, 1);
            }
            ENDCG
        }
    }
}
