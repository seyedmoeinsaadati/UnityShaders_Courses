Shader "TutorialShaders/Simple_Phong"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}

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

            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
        
            float _Ambient;
            float _LightInt;
            float4 _SpecularColor;
            float _SpecularPow;


            float3 LambertShading(float3 colorRefl, float lightInt, float3 normal, float3 lightDir)
            {
                return colorRefl * lightInt * max(0, dot(normal, lightDir));
            }

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
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;

                float3 ambinent_color = UNITY_LIGHTMODEL_AMBIENT * _Ambient;
                col.rgb += ambinent_color;

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half3 diffuse = LambertShading(_LightColor0.rgb, _LightInt, i.worldNormal, lightDir);
                col.rgb *= diffuse;

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldVertex);
                fixed3 specCol = _SpecularColor * _LightColor0.rgb;
                half3 specular = SpecularShading(specCol, _SpecularColor.a, i.worldNormal, viewDir, lightDir, _SpecularPow);
                col.rgb += specular;
                
                return col;
            }
            ENDCG
        }
    }
}
