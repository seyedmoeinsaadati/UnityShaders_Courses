Shader "Moein/ImageEffect/Silhouette"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _NearColour ("Near Clip Colour", Color) = (0.75, 0.35, 0, 1)
        _FarColour  ("Far Clip Colour", Color)  = (1, 1, 1, 1)
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

            fixed4 _NearColour;
            fixed4 _FarColour;

            sampler2D _CameraDepthTexture;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
                depth = pow(Linear01Depth(depth), 0.75);

                return lerp(_NearColour, _FarColour, depth);
            }
            ENDCG
        }
    }
}
