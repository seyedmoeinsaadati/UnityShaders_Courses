Shader "TutorialShaders/First_Rim"
{
    Properties
    {
        _RimInt("Rim Intensity", Range(0, 1)) = 1
        _RimPow("Rim Power", Range(1,5)) = 1
        _RimColor("Rim Color", Color) = (1,1,1,1)
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
                float4 rimColor : COLOR;
            };

            float _RimInt;
            float _RimPow;
            float4 _RimColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                float3 worldNormal = UnityObjectToWorldNormal(v.vertex);
                float3 viewDir = normalize(WorldSpaceViewDir(v.vertex));
                o.rimColor = pow(1- max(0, dot(viewDir, worldNormal)), _RimPow);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return  _RimColor * i.rimColor * _RimInt;
            }
            ENDCG
        }
    }
}
