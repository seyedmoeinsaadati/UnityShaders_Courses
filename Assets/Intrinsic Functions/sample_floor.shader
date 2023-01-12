Shader "Unlit/sample_floor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Gamma ("Gamma", Range(0, 1)) = 0
        [IntRange] _Sections ("Sections", Range(2, 10)) = 5

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
            float _Sections;
            float _Gamma;
                       
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float fv = floor(i.uv.y * _Sections) * (_Sections/100); 
                
                return float4(fv.xxx, 1) + _Gamma;
            }
            ENDCG
        }
    }
}
