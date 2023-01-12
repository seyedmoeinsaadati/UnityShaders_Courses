Shader "Unlit/Sample_ABS"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Zoom ("Zoom", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        

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
            float _Zoom;
           
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // let's ceil the UV coordinate
                float u = ceil(i.uv.x) *.5;
                float v = ceil(i.uv.y) *.5;

                float uLerp = lerp(u, i.uv.x, 1-_Zoom);
                float vLerp = lerp(v, i.uv.y, 1-_Zoom);
                // we assign the new values for the texture
                fixed4 col = tex2D(_MainTex, float2(uLerp , vLerp));


                return col;
            }
            ENDCG
        }
    }
}
