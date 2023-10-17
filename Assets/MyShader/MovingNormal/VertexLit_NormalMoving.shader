Shader "Moein/VertexLit/Annihilation"
{
    Properties
    {
        _Color("Tint Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}

        _Ambient("Ambient Intensity", Range(0, 1)) = 1
        _LightInt ("Light Intensity", Range(0, 1)) = 1

        [Space(10)]
        _Offset("Offset", Float) = 10
        _Weight("Weight", Range(0, 1)) = 1
        _Direction("Addictive Direction", Vector) = (0,0,0,0)
        [HDR]_SecondColor("Second Color", Color) = (1,1,1,1)

        _Radius("Radius", Float) = 0
        _Anchor("Anchor", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom
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

            struct v2g
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 vertex : TEXCOORD1;
                float3 color : TEXCOORD2;
                float affectedWeight : BLENDWEIGHT;
            };

            struct g2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 color : TEXCOORD1;
            };
            
            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Ambient;
            float _LightInt;

			float _Offset, _Weight, _Radius;
            float4 _Direction, _Anchor;
            float4 _SecondColor;

            v2g vert (appdata v)
            {
                v2g o;

                float3 worldVertexPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 worldVector = worldVertexPos - _Anchor.xyz;

                float len = length(worldVector);
                o.affectedWeight = 1 - smoothstep(_Radius, _Radius * 2, len);

                v.vertex.xyz += v.normal * (_Offset * o.affectedWeight * _Weight);
                // v.vertex.xyz += v.normal * _Offset * _Weight;

                v.vertex.xyz += _Direction.xyz * _Weight;
                o.vertex = v.vertex;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                // lighing
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.color.rgb = UNITY_LIGHTMODEL_AMBIENT * _Ambient;

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half3 diffuse = lambert_shading(_LightColor0.rgb, _LightInt, worldNormal, lightDir);
                o.color.rgb += diffuse;
    
                return o;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> tristream)
            {
                g2f o;
               
                float3 center = ((IN[0].vertex + IN[1].vertex + IN[2].vertex) / 3);
                for (int i = 0; i < 3; i++)
                {
                    float3 pos = IN[i].vertex.xyz * (1 - _Weight * IN[i].affectedWeight) + (center.xyz * _Weight * IN[i].affectedWeight);
                    //float3 pos = IN[i].vertex.xyz * (1 - _Weight) + (center.xyz * _Weight);
                    
                    IN[i].vertex = pos;
                    o.pos = UnityObjectToClipPos(IN[i].vertex);
                    o.color = IN[i].color;
                    o.uv = IN[i].uv;
                    tristream.Append(o);
                }
            }

            half4 frag(g2f i) : COLOR
            {
                float4 col = tex2D(_MainTex, i.uv) * _Color;
                col.rgb *= i.color;
                col.rgb += (_Weight * _SecondColor);
                return col;
            }

            ENDCG
        }
    }
}