Shader "TutorialShaders/First_Specular"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _SpecularTex("Specular Texture", 2D) = "black" {}
        _SpecularInt("Specular Intensity", Range(0, 1)) = 1
        _SpecularPow("Specular Power", Range(1, 128)) = 64
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
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
                float3 worldNormal : TEXCOORD1;
                float3 worldVertex : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _SpecularTex;
            float4 _SpecularTex_ST;
            float _SpecularInt;
            float _SpecularPow;

            float3 SpecularShading(float3 colorRefl, float specularInt, float3 normal, float3 lightDir, float3 viewDir, float specularPow)
            {
                float3 h = normalize(lightDir + viewDir);
                return colorRefl * specularInt * pow(max (0 , dot(normal, h)), specularPow);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldVertex = normalize(mul(unity_ObjectToWorld, v.vertex)).xyz;
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldVertex);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 specCol = tex2D(_SpecularTex, i.uv) * _LightColor0.rgb;
                half3 specular = SpecularShading(specCol, _SpecularInt, i.worldNormal, lightDir, viewDir, _SpecularPow);
                col.rgb += specular;
                return col ;
            }
            ENDCG
        }
    }
}
