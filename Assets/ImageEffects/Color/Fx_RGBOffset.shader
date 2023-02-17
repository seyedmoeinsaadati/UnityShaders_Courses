Shader "Moein/ImageEffect/RGB_Offset"
{
    Properties
    {
        [HideInInspector]
        _MainTex ("Texture", 2D) = "white" {}

        [KeywordEnum(Off, Add, Multiply)]
        _Mode("Mode", Float) = 1

        _Offset("Offset", Range(-1, 1)) = 0
        _Power("Power", Range(0, 10)) =1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _MODE_OFF _MODE_ADD _MODE_MULTIPLY

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            float _Offset, _Power;
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float offset = _Offset * _Power;
                
#if _MODE_ADD || _MODE_MULTIPLY
#if _MODE_ADD
                col.r += tex2D(_MainTex, float2(i.uv.x - offset, i.uv.y + offset)).g;
                col.g += tex2D(_MainTex, float2(i.uv.x + offset, i.uv.y - offset)).b;
                col.b += tex2D(_MainTex, float2(i.uv.x - offset, i.uv.y + offset)).r;
#else
                col.r *= tex2D(_MainTex, float2(i.uv.x - offset, i.uv.y + offset)).r;
                col.g *= tex2D(_MainTex, float2(i.uv.x + offset, i.uv.y - offset)).b;
                col.b *= tex2D(_MainTex, float2(i.uv.x - offset, i.uv.y + offset)).g;
#endif
#endif          
            
                return col;
            }
            ENDCG
        }
    }
}
