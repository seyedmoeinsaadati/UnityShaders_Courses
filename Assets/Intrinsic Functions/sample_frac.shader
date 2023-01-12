Shader "Unlit/sample_frac"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size("Size", Range(0 , .5)) = .3
        
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
            float _Size;
                       
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 fuv = frac(i.uv);
                // generate the circle
                float circle = length(fuv - 0.5);
                // flip the colors and return an integer value
                float wCircle = floor(_Size / circle);

                fixed4 col = tex2D(_MainTex, fuv) * wCircle;
                return col;
            }
            ENDCG
        }
    }
}
