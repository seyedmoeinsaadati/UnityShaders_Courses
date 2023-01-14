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
            float _Amplitude;

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _WavePower;
            float _MovingSpeedX;
            float _MovingSpeedZ;
            float _Smooth;
            float _Radius;

            float3 _CustomLightColor;
            float4 _CustomLightDir;

            v2g vert (appdata v)
            {
                v2g o;
                v.uv.x += _MovingSpeedX * _Time.x;
                v.uv.y += _MovingSpeedZ * _Time.x;
                float vertexrandpos = random(v.vertex.xz);
                float waveWeight = circle(frac(v.uv), .5 , _Radius, _Smooth) * _WavePower;
                v.vertex.y = waveWeight + vertexrandpos * _Amplitude;
                v.vertex.x += vertexrandpos * _SinTime.z / 10;
                v.vertex.z += vertexrandpos * _SinTime.z / 10;
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
