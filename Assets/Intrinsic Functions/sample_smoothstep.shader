Shader "Unlit/sample_smoothstep"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Offset("Smooth offset", Range(0 , 1)) = 0
        _Edge("Edge", Float) = 0


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
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Offset;
            float _Edge;
                       
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 sstep = 0;
                sstep = smoothstep((i.uv.y - _Offset), (i.uv.y + _Offset), _Edge);
                return fixed4(sstep, 1);
            }
            ENDCG
        }
    }
}
