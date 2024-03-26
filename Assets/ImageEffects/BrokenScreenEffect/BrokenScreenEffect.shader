Shader "Moine/Image Effects/Broken Screen"
{
	Properties {
		[HideInInspector] _MainTex("Base (RGB)", 2D) = "white" {}
		_DirectionMap("Direction (RG)", 2D) = "bump" {}
		_DiffuseTex("Diffuse Texture", 2D) = "white" {}
		
		_Refraction("Refraction", Range(0.0, 1.0)) = 0.0
	}
	
	SubShader {
		Pass {
			
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			sampler2D	_MainTex;
			float4		_MainTex_TexelSize;
			sampler2D	_DirectionMap;
			sampler2D 	_DiffuseTex;
			
			fixed _Refraction, _Broken;
			
			struct appdata
			{
				float4	vertex : POSITION;
				half2	texcoord : TEXCOORD0;
			};
				
			struct v2f
			{
				float4	pos : SV_POSITION;
				half2	uv : TEXCOORD0;
			};


			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				half2 uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);

				o.uv = uv;
				return o;
			} 
			
			fixed3	frag(v2f i) : COLOR
			{
				half2 directionColor = UnpackNormal(tex2D(_DirectionMap, i.uv )).xy;
				directionColor *= -1;

				half3 screen = tex2D(_MainTex, i.uv + directionColor * _Refraction).rgb;

				// diffuse
				half3 diffuseColor = tex2D(_DiffuseTex, i.uv);
				fixed4 color = fixed4(lerp(screen, screen + diffuseColor, _Refraction), 1);

				return  color;
			}
			
			ENDCG
		}
		
	} 
	FallBack off
}
