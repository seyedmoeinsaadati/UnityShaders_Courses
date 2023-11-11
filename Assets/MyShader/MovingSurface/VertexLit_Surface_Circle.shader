Shader "Moein/VertexLit/Surface_Circle"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
        _Color ("Color", Color) = (1,1,1,1)

        [Space]
        _VertexThreshold("Vertex Thereshold", Float) = .0
        _SurfaceOffset("Surface Offset", Float) = .0

        _Power("Power (Vertex Amplitude)", float) = 1
        _Amplitude("Wave Amplitude", Float) = 1

        _Smooth ("Smoothness", Float) = 0.01
        _Radius ("Radius", Float) = 0.3
        _MovingSpeedX("Moving Speed X", Float) = 0
        _MovingSpeedZ("Moving Spedd Y", Float) = 0
        _CircleX("Circle X", Float) = 1
        _CircleY("Circle Y", Float) = 1

        [Toggle] _Normal("Along Normal Axis", Float) = 0
        
                
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
            #pragma multi_compile __ _NORMAL_ON

            struct appdata
            {
                float4 vertex : POSITION;
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

            float _VertexThreshold, _SurfaceOffset;
            float _Power, _Amplitude, _Radius, _Smooth;
            float _MovingSpeedX, _MovingSpeedZ;
            float _CircleX, _CircleY;

            v2g vert (appdata v)
            {
                v2g o;
                v.uv.x += _MovingSpeedX * _Time.x;
                v.uv.y += _MovingSpeedZ * _Time.x;
                float vertexrandpos = random(v.vertex.xz);
                float waveHeight = circle(frac(v.uv), float2(.5,.5),_CircleX,_CircleY, _Radius, _Smooth) * _Power;

 #if _NORMAL_ON
                // v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
                v.vertex.xyz += v.normal * (waveHeight);
 				v.vertex.y += v.vertex.y > _VertexThreshold ? v.normal.y * (waveHeight * _Power) : v.vertex.y;
                v.vertex.x += v.vertex.y > _VertexThreshold ? v.normal.x * (waveHeight * _Power) : v.vertex.x;
                v.vertex.z += v.vertex.y > _VertexThreshold ? v.normal.z * (waveHeight * _Power) : v.vertex.z;
 #else
				v.vertex.y = v.vertex.y > _VertexThreshold ? _SurfaceOffset + waveHeight + vertexrandpos * _Amplitude : v.vertex.y;
                v.vertex.x += vertexrandpos * _SinTime.z / 10;
                v.vertex.z += vertexrandpos * _SinTime.z / 10;
 #endif

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
