Shader "Unlit/sample_clamp"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Xvalue ("X", Range(0, 1)) = 0
        _Avalue ("A", Range(0, 1)) = 0
        _Bvalue ("B", Range(0, 1)) = 0
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
            float _Xvalue;
            float _Avalue;
            float _Bvalue;
           
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float darkness = clamp(_Xvalue, _Avalue, _Bvalue);
                // we assign the new values for the texture
                fixed4 col = tex2D(_MainTex, i.uv) * darkness;


                return col;
            }
            ENDCG
        }
    }
}
