Shader "Moein/ImageEffect/Color"
{
    Properties
    {
        [HideInInspector]
        _MainTex ("Texture", 2D) = "white" {}

        [KeywordEnum(Off, Add, Multiply)]
        _Mode("Mode", Float) = 1

        _ROffset("Red", Range(0, 255)) = 0
        _GOffset("Green", Range(0, 255)) = 0
        _BOffset("Blue", Range(0, 255)) = 0
        _Brightness("Brightness", Range(0, 2)) = 1
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
            #pragma multi_compile _MODE_OFF _MODE_ADD _MODE_MULTIPLY

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

            float _ROffset, _GOffset, _BOffset;
            float _Brightness;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                
#if _MODE_ADD || _MODE_MULTIPLY
#if _MODE_ADD
                col.r *= 1 + _ROffset/255;
                col.g *= 1 + _GOffset/255;
                col.b *= 1 + _BOffset/255;
#else
                col.r *= _ROffset/255;
                col.g *= _GOffset/255;
                col.b *= _BOffset/255;
#endif
#endif
                
                col *= _Brightness;
                return col;
            }
            ENDCG
        }
    }
}
