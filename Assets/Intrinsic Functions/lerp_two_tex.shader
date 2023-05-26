Shader "Unlit/sample_lerp"
{
    Properties
    {
        _Skin01 ("Skin 01", 2D) = "white" {}
        _Skin02 ("Skin 02", 2D) = "white" {}
        _Lerp ("Lerp", Range(-1, 1)) = 0
        _Smoothness ("Smoothness", Range(0, .2)) = 0

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
                float4 vertex : POSITION0;
                float4 vertex_pos : POSITION1;
                float2 uv_s01 : TEXCOORD0;
                float2 uv_s02 : TEXCOORD1;
            };

            sampler2D _Skin01;
            float4 _Skin01_ST;
            sampler2D _Skin02;
            float4 _Skin02_ST;
            float _Lerp, _Smoothness;
        
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex_pos = v.vertex;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv_s02 = TRANSFORM_TEX(v.uv, _Skin02);
                o.uv_s01 = TRANSFORM_TEX(v.uv, _Skin01);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 skin01 = tex2D(_Skin01, i.uv_s01);
                fixed4 skin02 = tex2D(_Skin02, i.uv_s02);
                
                float t = smoothstep( i.vertex_pos.x - _Smoothness, i.vertex_pos.x + _Smoothness, _Lerp);

                fixed4 col = lerp(skin01, skin02, t);
                return col;
            }
            ENDCG
        }
    }
}
