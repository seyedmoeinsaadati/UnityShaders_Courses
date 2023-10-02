Shader "Moein/VertexLit/TwoSkin"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        [Space(10)]
        _SkinColor("Skin Tint Color", Color) = (1,1,1,1)
        _SkinTex("SKin Texture", 2D) = "white" {}

        _Ambient("Ambient Intensity", Range(0, 1)) = 1
        _LightInt ("Light Intensity", Range(0, 1)) = 1

        [Space(10)]
        _Offset("Offset", Float) = 10
        _Weight("Weight", Range(0.0, 1)) = 1
        _Direction("Addictive Direction", Vector) = (0,0,0,0)
        [HDR]_SecondColor("Second Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
        
        Pass
        {
            Name "Skin"
            
            Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}

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
            };

            struct g2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 color : TEXCOORD1;
            };
            
            float4 _SkinColor;
            sampler2D _SkinTex;
            float4 _SkinTex_ST;

            float _Ambient;
            float _LightInt;

			float _Offset, _Weight;
            float4 _Direction;
            float4 _SecondColor;

            v2g vert (appdata v)
            {
                v2g o;

                v.vertex.xyz += v.normal * _Offset * _Weight;
                v.vertex.xyz += _Direction.xyz * _Weight;
                o.vertex = v.vertex;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _SkinTex);

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
               
                float3 center = (IN[0].vertex + IN[1].vertex + IN[2].vertex) / 3;
                for (int i = 0; i < 3; i++)
                {
                    float3 pos = IN[i].vertex.xyz * ( 1 -_Weight) + (center.xyz * _Weight);
                    IN[i].vertex = pos;
                    o.pos = UnityObjectToClipPos(IN[i].vertex);
                    o.color = IN[i].color;
                    o.uv = IN[i].uv;
                    tristream.Append(o);
                }
            }

            half4 frag(g2f i) : COLOR
            {
                float4 col = tex2D(_SkinTex, i.uv) * _SkinColor;
                col.rgb *= i.color;
                col.rgb += (_Weight * _SecondColor);
                return col;
            }

            ENDCG
        }

       
    }

    Fallback "Diffuse"
}