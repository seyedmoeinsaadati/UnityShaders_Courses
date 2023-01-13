Shader "Moein/Unlit/Surface_Wave"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)

        _Amplitude("Amplitude", Float) = 1

        _WaveTex("Wave Texture", 2D) = "white"{}

        [Header(Wave Fields)]
        [Space]
        _WavePower("Wave Power", Range(0, 2)) = 1
        _Center ("Center", Range(0, 1)) = 0.5
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

            sampler2D _WaveTex;
            float4 _WaveTex_ST;
            float _WavePower;
            float _MovingSpeedX;
            float _MovingSpeedZ;
            float _Smooth;
            float _Radius;
            float _Center;

            v2f vert (appdata v)
            {
               v2f o;
               v.uv.x += _MovingSpeedX;
               v.uv.y += _MovingSpeedZ;

               float c = circle(abs(v.uv), _Center, _Radius, _Smooth) * _WavePower;
               // float vertexRandPos = random(v.vertex.xz);
               // v.vertex.y = (c /** _CosTime.z*/) + clamp(vertexRandPos * abs(_SinTime.x), 0, 1) * _Amplitude;
               // v.vertex.x += vertexRandPos * _SinTime.z / 10;
               // v.vertex.z += vertexRandPos * _SinTime.z / 10;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _WaveTex);

               
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_WaveTex, i.uv) * _Color;
                //return col;

                float c = circle(i.uv, _Center, _Radius, _Smooth);
                return fixed4(c.xxx, 1);
            }
            ENDCG
        }
    }
}
