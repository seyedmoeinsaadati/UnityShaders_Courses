Shader "Moine/Image Effects/MaskFrost"
{
	Properties {
		[HideInInspector] _MainTex("Base (RGB)", 2D) = "white" {}
		_DiffuseTex("Diffuse (RGBA)", 2D) = "white" {}
		_BumpTex("Normal (RGB)", 2D) = "bump" {}
		_CoverageTex("Coverage (R)", 2D) = "white" {}
		
		_Transparency("Transparency", Range(0.0, 1.0)) = 0.0
		_Refraction("Refraction", Range(0.0, 2.0)) = 0.0
		_Coverage("Coverage", Range(0.0, 1.0)) = 0.0
		_Smooth("Refraction Smoothness", Range(0.0, 1.0)) = 1.0
		
		_Color("Color", Color) = (1, 1, 1, 1)
		// _Speed("UV Speed", Float) = 1

		[Space]
		[Toggle] _MaskToggle("Circle Mask", Float) = 0
		_MaskIntensity("Mask Intensity", Range(0, .5)) = 1
		_MaskSmoothness("Mask Smoothness", Range(0, 1)) = 1
	}
	
	SubShader {
		Pass {
			
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile __ _MASKTOGGLE_ON

			#include "UnityCG.cginc"

			sampler2D	_MainTex;
			float4		_MainTex_TexelSize;
			sampler2D	_DiffuseTex;
			sampler2D	_BumpTex;
			sampler2D	_CoverageTex;
			
			fixed _Transparency, _Refraction, _Coverage, _Smooth;
			fixed4 _Color;

			half _MaskIntensity, _MaskSmoothness;

			
			struct appdata
			{
				float4	vertex : POSITION;
				half2	texcoord : TEXCOORD0;
			};
				
			struct v2f
			{
				float4	pos : SV_POSITION;
				half2	uv[2] : TEXCOORD0;
			};

			float circle(float2 p, float center, float radius, float smoothIn, float smoothOut)
			{
				float c = length(p - center) - radius;
				return smoothstep(c - smoothOut, c + smoothIn, radius);
			}

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				half2 uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);

				o.uv[0] = uv;
				#if UNITY_UV_STARTS_AT_TOP
					if (_MainTex_TexelSize.y < 0)
					{ uv.y = 1 - uv.y; }
				#endif
				o.uv[1] = uv;
				return o;
			} 
			
			fixed4	frag(v2f i) : COLOR
			{
				half2 normal = UnpackNormal(tex2D(_BumpTex, i.uv[1])).xy;
				half4 diffuse = tex2D(_DiffuseTex, i.uv[1]);
				diffuse.rgb *= _Color.rgb;
				half transparency = lerp(1, 0, diffuse.a * _Transparency);

				//Coverage
				half coverage = tex2D(_CoverageTex, i.uv[1]).r;
				coverage -= lerp(1, -1, _Coverage);
				coverage = saturate(coverage / _Smooth);
				
				//Refraction
				half3 screenPure = tex2D(_MainTex, i.uv[0]).rgb;
				half3 screen = tex2D(_MainTex, i.uv[0] + normal * _Refraction * coverage).rgb;
				
				// Screen Blend Mode
				half3 blendScreen = (1.0 - ((1.0 - screen) * (1.0 - diffuse.rgb)));
				blendScreen = lerp(blendScreen, diffuse.rgb, _Color.a);
				
				fixed4 color = fixed4(1, 1, 1, 1);
				color.rgb = lerp(screen, blendScreen, coverage * transparency);
				
#if _MASKTOGGLE_ON
				half mask = 1-circle(i.uv[0], 0.5, _MaskIntensity, _MaskSmoothness, 0);
				color.rgb = lerp(screenPure, color.rgb * mask, mask);
#endif

				return color;
			}
			
			ENDCG
		}
	} 
	FallBack off
}
