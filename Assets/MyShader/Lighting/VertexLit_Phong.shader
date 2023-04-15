Shader "Moein/VertexLit/Phong"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}

        [Toggle] _EmissionToggle("Emission", Float) = 0
        [HDR] _EmissionColor("Emission Color", Color) = (1,1,1,1)
        _EmissionTex ("Texture", 2D) = "white" {}

        _Ambient("Ambient Intensity", Range(0, 1)) = 1
        _LightInt ("Light Intensity", Range(0, 1)) = 1
        [HDR]
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        [PowerSlider(2.0)]_SpecularPow("Specular Power", Range(0.0, 1024.0)) = 64
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile __ _EMISSIONTOGGLE_ON

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR0;
                float3 specularColor : COLOR1;
            };

            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

#if _EMISSIONTOGGLE_ON
            float4 _EmissionColor;
            sampler2D _EmissionTex;
            float4 _EmissionTex_ST;
#endif
        
            float _Ambient;
            float _LightInt;
            float4 _SpecularColor;
            float _SpecularPow;


            float3 lambert_shading(float3 colorRefl, float lightInt, float3 normal, float3 lightDir)
            {
                return colorRefl * lightInt * max(0, dot(normal, lightDir));
            }

            float3 specular_shading(float3 colorRefl, float specularInt, float3 normal, float3 lightDir, float3 viewDir, float specularPow)
            {
                float3 h = normalize(lightDir + viewDir);
                return colorRefl * specularInt * pow(max (0 , dot(normal, h)), specularPow);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
            
                o.color.rgb = UNITY_LIGHTMODEL_AMBIENT * _Ambient;;

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half3 diffuse = lambert_shading(_LightColor0.rgb, _LightInt, worldNormal, lightDir);
                o.color.rgb += diffuse;
                
                float3 viewDir = normalize(WorldSpaceViewDir(v.vertex)).xyz;
                fixed3 specCol = _SpecularColor * _LightColor0.rgb;
                half3 specular = specular_shading(specCol, _SpecularColor.a, worldNormal, lightDir, viewDir, _SpecularPow);
                o.specularColor = specular;
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                col.rgb *= i.color.rgb + i.specularColor;

#if _EMISSIONTOGGLE_ON
                col.rgb += tex2D(_EmissionTex, i.uv) * _EmissionColor;
#endif

                return col;
            }
            ENDCG
        }
    }
}