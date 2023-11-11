Shader "Moein/VertexLit/Surface_Sin"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
        _Color ("Color", Color) = (1,1,1,1)

        [Space]
        _VertexThreshold("Surface Thereshold (Y-Axis)", Float) = .0
        _SurfaceOffset("Surface Offset", Float) = .0

        _Power("Power (Vertex Amplitude)", float) = 1
        _Amplitude("Wave Amplitude", Float) = 1
        _Frequence("Wave Frequence", Float) = 1

        [KeywordEnum(X, Y, Z)] _Axis("Moving Axis", Float) = 1  
        _MovingSpeed("Moving Speed", Float) = 0

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
            #pragma multi_compile _AXIS_X _AXIS_Y _AXIS_Z
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
            float _Power, _Amplitude, _Frequence;
            float _MovingSpeed;

            v2g vert (appdata v)
            {
                v2g o;

	            float t = _MovingSpeed * _Time.y;
                float4 worldVertexPos = mul(unity_ObjectToWorld, v.vertex);
                float vertexrandpos = random(worldVertexPos.xz + worldVertexPos.yx);

#if _AXIS_X
                float waveHeight = sin(t + worldVertexPos.x * _Frequence) * _Amplitude;
				waveHeight += cos(2*t + worldVertexPos.x * _Frequence) * _Amplitude;
#elif _AXIS_Y
                float waveHeight = sin(t + worldVertexPos.y * _Frequence) * _Amplitude;
				waveHeight += cos(2*t + worldVertexPos.y * _Frequence) * _Amplitude;
#elif _AXIS_Z
                float waveHeight = sin(t + worldVertexPos.z * _Frequence) * _Amplitude;
				waveHeight += cos(2*t + worldVertexPos.z * _Frequence) * _Amplitude;
#endif

#if _NORMAL_ON
                v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
                v.vertex.xyz += v.normal * (waveHeight);
 				v.vertex.y += v.normal.y * (waveHeight * _Power);
                v.vertex.x += v.normal.x * (waveHeight * _Power);
                v.vertex.z += v.normal.z * (waveHeight * _Power);
 #else
				v.vertex.y += v.vertex.y > _VertexThreshold ? _SurfaceOffset + waveHeight + vertexrandpos * _Power : v.vertex.y;
                v.vertex.x += vertexrandpos * _SinTime.z / 10;
                v.vertex.z += vertexrandpos * _SinTime.x / 10;

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
