Shader "Moein/Unlit/Eyeball/Eyeball"
{
    Properties
    {
        [Header(Section A)]
        [Space(5)]
        _AColor("Color", Color) = (1,1,1)
        _MainTex("Texture", 2D) = "white"{}

        [Space(5)]
        [Header(B)]
        [Space(5)]
        _BInColor("Tint Color", Color) = (1,1,1)
        _BTintColor("Shadow Color In", Color) = (1,1,1)
        _BOutColor("Shadow Color Out", Color) = (1,1,1)
        _BInSmooth("Smoothness In", Range(0, 0.5))= 1
        _BOutSmooth("Smoothness Out", Range(0, 0.5))= 1
        _BRadius("Radius", Range(0,.2))= 1
        _BScale("Scale", Range(0, 10))= 1

        // smoothstep(-2,3, cos(a*_NNumber))*_NNarrow+_Radius;
        [Space(5)]
        [Toggle] _NoiseToggle("Cluster Noise", Float) = 0
        _NColor("Color", Color) = (1,1,1)
        _NRadius("Radius", Range(0,.2))= 1
        _NNumber("Number", Float) = 20
        _NNarrow("Narrow", Float) = 20 
        _NSmooth("Smoothness", Range(0, 0.5))= 1
        

        [Space(5)]
        [Header(C)]
        [Space(5)]
        _CColor("Color", Color) = (0,0,0)
        _CRadius("Radius", Range(0, .2))= .5
        _CSmooth("Smoothness", Range(0, .2))= .05
        _CScale("Scale", Range(0, 10))= 1

        [Space(5)]
        [Toggle] _RimToggle("Rim", Float) = 0
        [HDR] _RimColor("Rim Color", Color) = (1,1,1,1)
        _RimPower("Rim Power", Range(0,20)) = 1

    }
    SubShader
    {
        Tags { "RenderType" = "Opaque"}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile __ _RIMTOGGLE_ON
            #pragma multi_compile __ _NOISETOGGLE_ON
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
#if _RIMTOGGLE_ON
                float3 normal: NORMAL;
#endif
            };

            struct v2f
            {
                float4 vertex : POSITION;
                float2 uvA : TEXCOORD0;
                float2 uvB : TEXCOORD1;
                float2 uvC : TEXCOORD2;
#if _NOISETOGGLE_ON
                float2 uvD : TEXCOORD3;
#endif

#if _RIMTOGGLE_ON
                float4 rimColor : COLOR;
#endif

            };

            float circle(float2 p, float center, float radius, float smooth)
            {
                float c = length(p - center) - radius;
                return smoothstep(c - smooth, c + smooth, radius);
            }

            float inCircle(float2 p, float center, float radius, float smooth)
            {
                float c = length(p - center) - radius;
                return smoothstep(c, c + smooth, radius);
            }

            float outCircle(float2 p, float center, float radius, float smooth)
            {
                float c = length(p - center) - radius;
                return smoothstep(c - smooth, c, radius);
            }

            // A Section
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _AColor;

            // B Section
            float4 _BTintColor ,_BInColor, _BOutColor;
            float _BRadius, _BScale, _BInSmooth, _BOutSmooth;

#if _NOISETOGGLE_ON
            float4 _NColor;
            float _NNumber, _NRadius, _NSmooth, _NNarrow;
#endif

            // C Section
            float _CRadius, _CSmooth, _CScale;
            float4 _CColor;

#if _RIMTOGGLE_ON
            float _RimPower;
            float4 _RimColor;
#endif
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvA = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvB = v.uv;
                o.uvC = v.uv;

#if _NOISETOGGLE_ON
                o.uvD = v.uv;
#endif

#if _RIMTOGGLE_ON
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 viewDir = normalize(WorldSpaceViewDir(v.vertex));
                o.rimColor = pow(1- dot(viewDir, worldNormal), _RimPower);
#endif

                return o;
            }
            
            fixed4 frag (v2f i) : SV_TARGET
            {
                fixed4 col = _AColor * tex2D(_MainTex, i.uvA);
                
                i.uvB.x *= _BScale;
                i.uvB.x += _BScale * -.25 + .5;

                float bCircle = outCircle(i.uvB, .5, _BRadius, _BOutSmooth);
                col = lerp(col, _BOutColor, bCircle);
                bCircle = circle(i.uvB, .5, _BRadius, 0);
                col = lerp(col, _BTintColor, bCircle);
bCircle = inCircle(i.uvB, .5, _BRadius, _BInSmooth);
                col = lerp(col, _BInColor, bCircle);
                
#if _NOISETOGGLE_ON
                i.uvD -= float2(.5,.5);
                i.uvD.x += .25;
                i.uvD.x *= 2;
                float r = length(i.uvD) * 2;
                float a = atan(i.uvD.y / i.uvD.x);
                float f = smoothstep(-2,3, cos(a*_NNumber))*_NNarrow+_NRadius;
                float result = smoothstep(f,f+_NSmooth,r);
                 col = lerp(col, _NColor, 1-result);
#endif

                

               

                
                i.uvC.x *= _CScale;
                i.uvC.x += _CScale * -.25 + .5;
                float cCircle = circle(i.uvC, .5, _CRadius, _CSmooth);
                col = lerp(col, _CColor, cCircle);

#if _RIMTOGGLE_ON
                col = lerp(col, _RimColor, i.rimColor);
#endif

                return col;
            }
            ENDCG
        }
    }
}
