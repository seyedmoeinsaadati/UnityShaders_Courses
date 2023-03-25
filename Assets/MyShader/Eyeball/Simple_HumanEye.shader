Shader "Moein/Unlit/Eyeball/Human"
{
    Properties
    {

        [Header(Section A)]
        [Space(5)]
        _AColor("Color", Color) = (1,1,1)
        _MainTex("Texture", 2D) = "white"{}

        [Space(5)]
        [Header(B)]
        _BColor("Color", Color) = (1,1,1)
        _BRadius("Radius", Range(0, 1))= 1
        _BSmooth("Smoothness", Range(0, 0.5))= 1
        _BScale("Scale", Range(0, 10))= 1


        [Space(5)]
        [Header(C)]
        _CColor("Color", Color) = (0,0,0)
        _CRadius("Radius", Range(0, 1))= .5
        _CSmooth("Smoothness", Range(0, .2))= .05
        _CScale("Scale", Range(0, 10))= 1

    }
    SubShader
    {
        Tags { "RenderType" = "Opaque"}
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
                float4 vertex : POSITION;
                float2 uvA : TEXCOORD0;
                float2 uvB : TEXCOORD1;
                float2 uvC : TEXCOORD2;
            };

            // A Section
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _AColor;

            // B Section
            float _BRadius, _BSmooth, _BScale;
            float4 _BColor;

            // C Section
            float _CRadius, _CSmooth, _CScale;
            float4 _CColor;

            float circle (float2 p, float center, float radius, float smooth)
            {
                float c = length(p - center) - radius;
                return smoothstep(c - smooth, c + smooth, radius);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvA = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvB = v.uv;
                o.uvC = v.uv;
                return o;
            }
            
            fixed4 frag (v2f i) : SV_TARGET
            {
                
                fixed4 col = _AColor * tex2D(_MainTex, i.uvA);
                
                i.uvB.x *= _BScale;
                i.uvB.x += _BScale * -.25 + .5;
                float bCircle = circle(i.uvB, .5, _BRadius, _BSmooth);

                col = lerp(col, _BColor, bCircle);

                i.uvC.x *= _CScale;
                i.uvC.x += _CScale * -.25 + .5;
                float cCircle = circle(i.uvC, .5, _CRadius, _CSmooth);

                return lerp(col, _CColor, cCircle);
            }
            ENDCG
        }
    }
}
