Shader "Moein/ImageEffect/ColorBalance"
{
    Properties
    {
        [HideInInspector]
        _MainTex ("Texture", 2D) = "white" {}

        _Brightness("Brightness", Range(0, 2)) = 1
        [Space(10)]
        _GreyscaleIntensity("Grayscale", Range(0, 1)) = 0
        [Space(10)]
        _ColorModifier("Color Modifier (*)", Range(0, 1)) = 0  
        [Space(5)]
        _RModifier("Red", Range(0, 1)) = 0
        _GModifier("Green", Range(0, 1)) = 0
        _BModifier("Blue", Range(0, 1)) = 0
        [Space(10)]
        _ColorOffset("Color Offset (+)", Range(0, 1)) = 0 
        [Space(5)]
        _ROffset("Red", Range(0, 1)) = 0
        _GOffset("Green", Range(0, 1)) = 0
        _BOffset("Blue", Range(0, 1)) = 0
        [Space(10)]
        _ContrastIntensity("Contrast", Range(0, 1)) = 0
        [Space(5)]
        _RedMinContrast("Red - Min", Range(0, 1)) = 0
        _RedMaxContrast("Red - Max", Range(0, 1)) = 1
        _GreenMinContrast("Green - Min", Range(0, 1)) = 0
        _GreenMaxContrast("Green - Max", Range(0, 1)) = 1
        _BlueMinContrast("Blue - Min", Range(0, 1)) = 0
        _BlueMaxContrast("Blue - Max", Range(0, 1)) = 1
        _ColorInvert("Invert", Range(0, 1)) = 0
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

            // Color Modifer
            half _ColorModifier;
            half _RModifier;
            half _GModifier;
            half _BModifier;

            // Color Offset
            half _ColorOffset;
            half _ROffset;
            half _GOffset;
            half _BOffset;

            half _GreyscaleIntensity;

            // contrast
            half _ContrastIntensity;
            half _RedMinContrast;
            half _RedMaxContrast;
            half _GreenMinContrast;
            half _GreenMaxContrast;
            half _BlueMinContrast;
            half _BlueMaxContrast;

            half _Brightness, _ColorInvert;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float3 tempColor = float3(1 + _ROffset, 1 + _GOffset, 1 + _BOffset) * col.rgb;
                col.rgb = lerp(col, tempColor, _ColorOffset);

                tempColor = float3(_RModifier,_GModifier, _BModifier) * col.rgb;
                col.rgb = lerp(col, tempColor, _ColorModifier);

                tempColor = col.r * .299 + col.g * .587 + col.b * .114;
                col.rgb = lerp(col, tempColor, _GreyscaleIntensity);

                tempColor = invLerp(float3(_RedMinContrast,_GreenMinContrast,_BlueMinContrast), float3(_RedMaxContrast,_GreenMaxContrast,_BlueMaxContrast), col.rgb);
                col.rgb = lerp(col.rgb, tempColor, _ContrastIntensity);
                
                col.rgb = lerp(col, 1- col, _ColorInvert); 

                col *= _Brightness;
                return col;
            }
            ENDCG
        }
    }
}
