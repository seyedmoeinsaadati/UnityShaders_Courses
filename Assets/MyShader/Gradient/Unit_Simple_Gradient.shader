
Shader "Moein/Unlit/Simple_Gradient"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
    {
        _Color1 ("Color 1", Color) = (1, 1, 1,1)
        _Color2 ("Color 2", Color) = (.5, .5 , .5, 1)
        _Color3 ("Color 3", Color) = (0, 0 , 0, 1)
        
        [Header (Borders)]
        [Space(10)]
        _Smoothness1("Smoothness 1", Range(0 , 1)) = 0
        _Offset1("Offset 1", Range(0 , 1)) = 0
        _Amp1("Amp 1", Float) = 0
        _Freq1("Freq 1", Float) = 0
        [Space(10)]
        _Smoothness2("Smoothness 2", Range(0 , 1)) = 0
        _Offset2("Offset 2", Range(0 , 1)) = 0
        _Amp2("Amp 2", Float) = 0
        _Freq2("Freq 2", Float) = 0
        
        [Space(10)]
        _SpeedU("Speed U", Float) = 0
        _SpeedV("Speed V", Float) = 0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            fixed4 _Color1, _Color2, _Color3;

            float _Smoothness1, _Offset1;
            float  _Amp1, _Freq1;
            
            float _Smoothness2, _Offset2;
            float  _Amp2, _Freq2;

            float _SpeedU, _SpeedV;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                o.uv.x += _SpeedU * _Time.y;
                o.uv.y += _SpeedV * _Time.y;

                return o;
            }

            // float random (float2 uv)
            // {
            //     return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
            // }

            float randomSin(float x, float freq, float amp){
                float result = sin(x * freq) * amp;
                result += sin(x * freq/2) * amp/2;
                result += sin(x * freq/3) * amp/3;
                result += sin(x * freq/4) * amp/4;
                result += sin(x * freq/5) * amp/5;
                return result;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float uValue = frac(i.uv.y);
                
                float threshold1 = smoothstep(uValue - _Smoothness1, uValue + _Smoothness1, _Offset1 + randomSin(i.uv.x, _Freq1, _Amp1));
                float threshold2 = smoothstep(uValue - _Smoothness2, uValue + _Smoothness2, _Offset2 + randomSin(i.uv.x, _Freq2, _Amp2));

                return _Color1 * threshold1 + (1 - (threshold2 - threshold1)) * _Color2 + (1 - threshold2) * _Color3;
            }
            ENDCG
        }
    }
}
