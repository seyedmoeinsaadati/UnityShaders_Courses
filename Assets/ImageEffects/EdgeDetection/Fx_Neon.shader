Shader "Moein/ImageEffect/BoxBlurMultipass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags 
		{ 
			"RenderType" = "Opaque"
		}

        Pass
        {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float2 _MainTex_TexelSize;

			/*	This function uses two Sobel filters to calculate image
				gradients in the x- and y-directions:

						*----*----*----*				*----*----*----*
						| -1 |  0 |  1 |				|  1 |  2 |  1 |
						*----*----*----*				*----*----*----*
				S_x =	| -2 |  0 |  2 |		S_y =	|  0 |  0 |  0 |
						*----*----*----*				*----*----*----*
						| -1 |  0 |  1 |				| -1 | -2 | -1 |
						*----*----*----*				*----*----*----*

				Then, simple trigonometry is used to calculate the overall
				magnitude of the gradient.
			*/
			float3 sobel(float2 uv)
			{
				float x = 0;
				float y = 0;

				float2 texelSize = _MainTex_TexelSize;

				// Values are hardcoded for simplicity. Kernel values with
				// zeroes are missed out for efficiency.
				x += tex2D(_MainTex, uv + float2(-texelSize.x, -texelSize.y)) * -1.0;
				x += tex2D(_MainTex, uv + float2(-texelSize.x,            0)) * -2.0;
				x += tex2D(_MainTex, uv + float2(-texelSize.x,  texelSize.y)) * -1.0;

				x += tex2D(_MainTex, uv + float2( texelSize.x, -texelSize.y)) *  1.0;
				x += tex2D(_MainTex, uv + float2( texelSize.x,            0)) *  2.0;
				x += tex2D(_MainTex, uv + float2( texelSize.x,  texelSize.y)) *  1.0;

				y += tex2D(_MainTex, uv + float2(-texelSize.x, -texelSize.y)) * -1.0;
				y += tex2D(_MainTex, uv + float2(           0, -texelSize.y)) * -2.0;
				y += tex2D(_MainTex, uv + float2( texelSize.x, -texelSize.y)) * -1.0;

				y += tex2D(_MainTex, uv + float2(-texelSize.x,  texelSize.y)) *  1.0;
				y += tex2D(_MainTex, uv + float2(           0,  texelSize.y)) *  2.0;
				y += tex2D(_MainTex, uv + float2( texelSize.x,  texelSize.y)) *  1.0;

				return sqrt(x * x + y * y);
			}

			float3 rgb2hsv(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = c.g < c.b ? float4(c.bg, K.wz) : float4(c.gb, K.xy);
				float4 q = c.r < p.x ? float4(p.xyw, c.r) : float4(c.r, p.yzx);

				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			float3 hsv2rgb(float3 c)
			{
				float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
				float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
				return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
			}

			fixed4 frag(v2f_img i) : SV_Target
			{
				float3 s = sobel(i.uv);
				float3 tex = tex2D(_MainTex, i.uv);
				// return float4(tex * s, 1.0);

				float3 hsvTex = rgb2hsv(tex);
				hsvTex.y = 1.0;		// Modify saturation.
				hsvTex.z = 1.0;		// Modify lightness/value.
				float3 col = hsv2rgb(hsvTex);

				return float4(col * s, 1.0);
			}
			ENDCG
        }
    }
}