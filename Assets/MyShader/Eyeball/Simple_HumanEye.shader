Shader "Moein/Unlit/Eyeball/Human"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1)
        _MainTex("Main Text", 2D) = "white"{}

        // Rim
        // Color 1, 2, 3 
        // Texture 1, 2, 3 
        // size 1, 2
        // smoothness

    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue"= "Opaque"}
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
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_TARGET
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color; 

                return col;
            }
            ENDCG
        }
    }
}
