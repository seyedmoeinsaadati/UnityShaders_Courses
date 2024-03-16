Shader "Moein/ImageEffect/SepiaTone"
{
    Properties
    {
         _MainTex ("Texture", 2D) = "white" {}
         _RedVector("Red", Vector) = (0.393, 0.349, 0.272,0)
         _GreenVector("Red", Vector) = (0.769, 0.686, 0.534,0)
         _BlueVector("Red", Vector) = (0.189, 0.168, 0.131, 0)
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
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
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

            half3 _RedVector, _GreenVector, _BlueVector;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                half3x3 sepiaVals = half3x3
                (
                    _RedVector.rgb,
                    _GreenVector.rgb,
                    _BlueVector.rgb
                );

                fixed3 sepiaResult = mul(col.rgb, sepiaVals);

                return fixed4(sepiaResult,1.0);
            }
            ENDCG
        }
    }
}
