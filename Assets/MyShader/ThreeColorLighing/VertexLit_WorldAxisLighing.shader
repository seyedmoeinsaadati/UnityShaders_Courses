Shader "Moein/VertexLit/WorldAxisLighing"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1)
        _MainTex("Main Text", 2D) = "white"{}

        _LightInt("Lighting Intensity", Range(0, 1)) = 1
        [HDR]_LightColorX("Light Color X", Color) = (1,1,1,1)
        [HDR]_LightColorY("Light Color Y", Color) = (1,1,1,1)
        [HDR]_LightColorZ("Light Color Z", Color) = (1,1,1,1)

        [Toggle]
        _Ambient ("Global Ambient", Float) = 0
        _AmbientInt("Ambient Intensity", Range(0, 1)) = 1

    }
    SubShader
    {
        Tags { "RenderType" = "Opaque"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile __ _AMBIENT_ON
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
            };
            

            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _LightInt;
            float4 _LightColorX;
            float4 _LightColorY;
            float4 _LightColorZ;

#if _AMBIENT_ON
            float _AmbientInt;
#endif

            float3 lambert_shading(float4 lightColor, float3 normal, float3 lightDir)
            {
                return lightColor.rgb * lightColor.a * saturate(dot(normal, lightDir));
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // o.worldNormal = normalize(mul(unity_ObjectToWorld, v.normal)).xyz;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }
            
            fixed4 frag (v2f i) : SV_TARGET
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;

                // x-axis lighintg
                float3 diffuse = lambert_shading(_LightColorX, i.worldNormal, float3(1,0,0));
                diffuse += lambert_shading(_LightColorX, i.worldNormal, float3(-1,0,0));
                // y-axis lighintg
                diffuse += lambert_shading(_LightColorY, i.worldNormal, float3(0,1,0));
                diffuse += lambert_shading(_LightColorY, i.worldNormal, float3(0,-1,0));
                // z-axis lighintg
                diffuse += lambert_shading(_LightColorZ, i.worldNormal, float3(0,0,1));
                diffuse += lambert_shading(_LightColorZ, i.worldNormal, float3(0,0,-1));
                
#if _AMBIENT_ON
                col.rgb += UNITY_LIGHTMODEL_AMBIENT * _AmbientInt;
#endif

                col.rgb *= diffuse;
                return col;
            }
            ENDCG
        }
    }
}
