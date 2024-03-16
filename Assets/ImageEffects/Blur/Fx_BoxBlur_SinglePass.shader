Shader "Moein/ImageEffect/BoxBlur_SinglePass"
{
    Properties
    {
         _MainTex ("Texture", 2D) = "white" {}
         _KernelSize("Kernel Size (N)", Int) = 3
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

            float2 _MainTex_TexelSize;
            int _KernelSize;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 col = fixed3(0.0, 0.0, 0.0);

                int upper = ((_KernelSize - 1) / 2);
                int lower = -upper;

				// Sum over all pixel colours in the kernel.
				for (int x = lower; x <= upper; ++x)
				{
					for (int y = lower; y <= upper; ++y)
					{
						fixed2 offset = fixed2(_MainTex_TexelSize.x * x, _MainTex_TexelSize.y * y);
						col += tex2D(_MainTex, i.uv + offset);
					}
				}

				// Divide through to get an unweighted average pixel colour.
				col /= (_KernelSize * _KernelSize);
				return fixed4(col, 1.0);
            }
            ENDCG
        }
    }
}
