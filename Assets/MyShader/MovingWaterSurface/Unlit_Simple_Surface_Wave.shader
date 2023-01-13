Shader "Moein/Unlit/Simple_Surface_Wave"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Amplitude("Amplitude", Float) = 1

        [Header(Wave Fields)]
        [Space]
        _WavePower("Wave Power", Range(0, 2)) = 1
        _Smooth ("Smooth", Range(0.0, 0.5)) = 0.01
        _Radius ("Radius", Range(0.0, 0.5)) = 0.3
        _MovingSpeedX("Moving Speed X", Float) = 0
        _MovingSpeedZ("Moving Spedd Y", Float) = 0
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
            #include "Assets/MyShader/utils.cginc"

            struct appdata
            {
                float3 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _Color;
            float _Amplitude;

            float _WavePower;
            float _MovingSpeedX;
            float _MovingSpeedZ;
            float _Smooth;
            float _Radius;

            v2f vert (appdata v)
            {
                v2f o;
                v.uv.x += _MovingSpeedX * _Time.x;
                v.uv.y += _MovingSpeedZ * _Time.x;
                float vertexrandpos = random(v.vertex.xz);
                float waveWeight = circle(frac(v.uv), .5 , _Radius, _Smooth) * _WavePower;
                v.vertex.y = waveWeight + vertexrandpos * _Amplitude;
                v.vertex.x += vertexrandpos * _SinTime.z / 10;
                v.vertex.z += vertexrandpos * _SinTime.z / 10;

                o.vertex = UnityObjectToClipPos(v.vertex);  
                o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // debug mode: return noise map
                //float c = circle(frac(i.uv), .5, _Radius, _Smooth);
                //return fixed4(c.xxx, 1) + _Color;

                return _Color;
            }
            ENDCG
        }
    }
}
