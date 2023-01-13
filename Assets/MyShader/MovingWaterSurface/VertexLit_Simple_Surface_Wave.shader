Shader "Moein/VertexLit/Simple_Surface_Wave"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
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
        Tags {"RenderType"="Opaque" "LightMode"="ForwardBase"}

        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc" 
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
                fixed4 diff : COLOR0; 
            };

            float4 _Color;
            float _Amplitude;

            sampler2D _MainTex;
            float4 _MainTex_ST;
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
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                // lighting
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                return col * i.diff;
            }
            ENDCG
        }
    }
}
