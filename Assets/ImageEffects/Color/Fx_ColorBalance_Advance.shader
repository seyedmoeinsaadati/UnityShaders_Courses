Shader "Moein/ImageEffect/ColorBalance_Advance"
{
    Properties
    {
        [HideInInspector]
        _MainTex ("Texture", 2D) = "white" {}

        _Brightness("Brightness", Range(0, 2)) = 1
        [Space(5)]
        [Toggle] _ColorToggle("Color", Float) = 0
        [KeywordEnum(Off, Add, Multiply)] _ColorMode("Mode", Float) = 1        
        _ROffset("Red", Range(0, 1)) = 0
        _GOffset("Green", Range(0, 1)) = 0
        _BOffset("Blue", Range(0, 1)) = 0
        [Space(5)]
        [Toggle] _GrayScaleToggle("Grayscale", Float) = 0
        _Grayscale_Red("Grayscale Red", Range(0.001, 1)) = .299
        _Grayscale_Green("Grayscale Green", Range(0.001, 1)) = .587
        _Grayscale_Blue("Grayscale Blue", Range(0.001, 1)) = .114
        [Space(5)]
        [Toggle] _ContrastToggle("Contrast", Float) = 0
        _RedMinContrast("Red - Min", Range(0, 1)) = 0
        _RedMaxContrast("Red - Max", Range(0, 1)) = 1
        _GreenMinContrast("Green - Min", Range(0, 1)) = 0
        _GreenMaxContrast("Green - Max", Range(0, 1)) = 1
        _BlueMinContrast("Blue - Min", Range(0, 1)) = 0
        _BlueMaxContrast("Blue - Max", Range(0, 1)) = 1
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
            #pragma multi_compile _COLORMODE_OFF _COLORMODE_ADD _COLORMODE_MULTIPLY
            #pragma multi_compile __ _COLORTOGGLE_ON
            #pragma multi_compile __ _CONTRASTTOGGLE_ON
            #pragma multi_compile __ _GRAYSCALETOGGLE_ON
            
            #include "UnityCG.cginc"

            float3 invLerp(float3 a, float3 b, float3 value){
                return (value - a) / (b-a);
            }

            struct appdata
            {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
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

            // color
            float _ROffset;
            float _GOffset;
            float _BOffset;

            // grayscale
            float _Grayscale_Red;
            float _Grayscale_Green;
            float _Grayscale_Blue;

            // contrast
            float _RedMinContrast;
            float _RedMaxContrast;
            float _GreenMinContrast;
            float _GreenMaxContrast;
            float _BlueMinContrast;
            float _BlueMaxContrast;

            float _Brightness;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

#if _COLORTOGGLE_ON && (_COLORMODE_ADD || _COLORMODE_MULTIPLY)
#if _COLORMODE_ADD
                col.r *= 1 + _ROffset;
                col.g *= 1 + _GOffset;
                col.b *= 1 + _BOffset;
#else
                col.r *= _ROffset;
                col.g *= _GOffset;
                col.b *= _BOffset;
#endif
#endif

#if _GRAYSCALETOGGLE_ON
                float grayscale = (col.r * _Grayscale_Red + col.g * _Grayscale_Green + col.b * _Grayscale_Blue) / (_Grayscale_Red + _Grayscale_Green + _Grayscale_Blue);
                col = grayscale;
#endif

#if _CONTRASTTOGGLE_ON
                col.rgb = invLerp(float3(_RedMinContrast,_GreenMinContrast,_BlueMinContrast), float3(_RedMaxContrast,_GreenMaxContrast,_BlueMaxContrast), col.rgb);
#endif

                col *= _Brightness;
                return col;
            }
            ENDCG
        }
    }
}
