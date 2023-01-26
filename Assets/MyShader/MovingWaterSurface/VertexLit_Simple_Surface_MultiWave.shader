Shader "Moein/VertexLit/Simple_Surface_Wave"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
        _Color ("Color", Color) = (1,1,1,1)

        [Header(Wave Fields 1)]
        [Space]
        _Amplitude1("Amplitude 1", Float) = 1
        _WavePower1("Wave Power 1", Range(0, 10)) = 1
        _Smooth1 ("Smooth 1", Range(0.0, 0.5)) = 0.01
        _Radius1 ("Radius 1", Range(0.0, 0.5)) = 0.3
        _MovingSpeedX1("Moving Speed X 1", Float) = 0
        _MovingSpeedZ1("Moving Spedd Y 1", Float) = 0

        [Header(Wave Fields 2)]
        [Space]
        _Amplitude2("Amplitude 2", Float) = 1
        _WavePower2("Wave Power 2", Range(0, 10)) = 1
        _Smooth2 ("Smooth 2", Range(0.0, 0.5)) = 0.01
        _Radius2 ("Radius 2", Range(0.0, 0.5)) = 0.3
        _MovingSpeedX2("Moving Speed X 2", Float) = 0
        _MovingSpeedZ2("Moving Spedd Y 2", Float) = 0

        [Header(Wave Fields 3)]
        [Space]
        _Amplitude3("Amplitude 3", Float) = 1
        _WavePower3("Wave Power 3", Range(0, 10)) = 1
        _Smooth3 ("Smooth 3", Range(0.0, 0.5)) = 0.01
        _Radius3 ("Radius 3", Range(0.0, 0.5)) = 0.3
        _MovingSpeedX3("Moving Speed X 3", Float) = 0
        _MovingSpeedZ3("Moving Spedd Y 3", Float) = 0

        //[Header(Lighting)]
        //_CustomLightColor ("Lighting Color", Color) = (1,1,1)
        //_CustomLightDir("Lighting Direction", Vector) = (1,1,1)
        
    }
    SubShader
    {
        Tags {"RenderType"="Opaque" "LightMode"="ForwardBase"}

        Pass
        {
            CGPROGRAM
            
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc" 
            #include "Assets/MyShader/utils.cginc"

            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            struct appdata
            {
                float3 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2g
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 vertex : TEXCOORD1;
            };

            struct g2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 light : TEXCOORD1;
            };

            float4 _Color;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Amplitude1;
            float _WavePower1;
            float _MovingSpeedX1;
            float _MovingSpeedZ1;
            float _Smooth1;
            float _Radius1;

            float _Amplitude2;
            float _WavePower2;
            float _MovingSpeedX2;
            float _MovingSpeedZ2;
            float _Smooth2;
            float _Radius2;

            float _Amplitude3;
            float _WavePower3;
            float _MovingSpeedX3;
            float _MovingSpeedZ3;
            float _Smooth3;
            float _Radius3;

            float3 _CustomLightColor;
            float4 _CustomLightDir;

            v2g vert (appdata v)
            {
                v2g o;
                v.uv.x += _MovingSpeedX1 * _Time.x;
                v.uv.y += _MovingSpeedZ1 * _Time.x;
                float vertexrandpos = random(v.vertex.xz);
                float waveWeight = circle(frac(v.uv), .5 , _Radius1, _Smooth1) * _WavePower1;
                v.vertex.y = waveWeight + vertexrandpos * _Amplitude1;

                v.uv.x += _MovingSpeedX2 * _Time.x;
                v.uv.y += _MovingSpeedZ2 * _Time.x;
                waveWeight = circle(frac(v.uv), .5 , _Radius2, _Smooth2) * _WavePower2;
                v.vertex.y += waveWeight + vertexrandpos * _Amplitude2;

                v.uv.x += _MovingSpeedX3 * _Time.x;
                v.uv.y += _MovingSpeedZ3 * _Time.x;
                waveWeight = circle(frac(v.uv), .5 , _Radius3, _Smooth3) * _WavePower3;
                v.vertex.y += waveWeight + vertexrandpos * _Amplitude3;
                v.vertex.x += vertexrandpos * _SinTime.z / 10;
                v.vertex.z += vertexrandpos * _SinTime.x / 10;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.vertex = v.vertex;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
            {
                g2f o;

                // Compute the normal
                float3 vecA = IN[1].vertex - IN[0].vertex;
                float3 vecB = IN[2].vertex - IN[0].vertex;
                float3 normal = cross(vecA, vecB);
                normal = normalize(mul(normal, (float3x3) unity_WorldToObject));

                // Compute diffuse light
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                o.light = _LightColor0 * max(0., dot(normal, lightDir));

                // custom lighting ????
                o.light += max(0., dot(normal, (0,0,.1)));

                // Compute barycentric uv
                o.uv = (IN[0].uv + IN[1].uv + IN[2].uv) / 3;

                for(int i = 0; i < 3; i++)
                {
                    o.pos = IN[i].pos;
                    triStream.Append(o);
                }
            }

             half4 frag(g2f i) : COLOR
            {
                float4 col = tex2D(_MainTex, i.uv);
                col.rgb *= i.light * _Color;
                return col;
            }

            ENDCG
        }
    }
}
