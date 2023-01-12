Shader "Moein/Unlit/Surface_Wave"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)

        _Amplitude("Amplitude", Float) = 1
        _NormalFactor("Normal Factor", Range(0, 1)) = 0
        _Speed("Speed", Float) = 0
        
    }
    SubShader
    {
        Tags {"RenderType"="Opaque"}
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float3 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            float _Amplitude;
            float _NormalFactor;
            float _Speed;
                       
            float random (float2 uv)
            {
                return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
            }

            v2f vert (appdata v)
            {
                v2f o;

                float vertexRandPos = random(v.vertex.xz);
                v.vertex.y = clamp(vertexRandPos * _CosTime.x, 0, _Amplitude);
                v.vertex.x += vertexRandPos * _SinTime.z * _Speed /10;
                v.vertex.z += vertexRandPos * _SinTime.z * _Speed /10;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);


                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv) * _Color;
            }
            ENDCG
        }
    }
}
