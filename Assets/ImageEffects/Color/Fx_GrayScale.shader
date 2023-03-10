Shader "Moein/ImageEffect/Grayscale"
{
    Properties
    {
        [HideInInspector]
        _MainTex ("Texture", 2D) = "white" {}

        _RPower("Red power", Range(0.001, 1)) = .299
        _GPower("Green power", Range(0.001, 1)) = .587
        _BPower("Blue power", Range(0.001, 1)) = .114
        _Brightness("Brightness", Range(0, 2)) = 1

        [Toggle]
        _AddColor ("Add Color", Float) = 1
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
              #pragma multi_compile __ _ADDCOLOR_ON

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

            float _RPower, _GPower, _BPower;
            float _Brightness;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float grayscale = (col.r * _RPower + col.g * _GPower + col.b * _BPower) / (_RPower + _GPower + _BPower);

#if _ADDCOLOR_ON
                fixed4 tempCol = grayscale;
                tempCol.r += _RPower * col.r;
                tempCol.g += _GPower * col.g;
                tempCol.b += _BPower * col.b;
                col = tempCol;
#else 
                col = grayscale;
#endif

                col *= _Brightness;
                return col;
            }
            ENDCG
        }
    }
}
