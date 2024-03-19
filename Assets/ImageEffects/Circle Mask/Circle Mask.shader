Shader "Moein/Image Effect/Circle Mask" {
	Properties {
		_MainTex ("Base", 2D) = "white" {}

		_Color ("Color", COLOR) = (1,1,1,1)
		_Intensity("Intensity", Range(0, .5)) = 1
		_Smoothness("Smoothness", Range(0, 1)) = 1
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		float2 uv2 : TEXCOORD1;
	};
	
	sampler2D _MainTex;
	float4 _MainTex_TexelSize;

	// sampler2D _VignetteTex;
	
	fixed4 _Color;
	half _Intensity, _Smoothness;

	v2f vert( appdata_img v ) {
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		o.uv2 = v.texcoord.xy;

		#if UNITY_UV_STARTS_AT_TOP
		if (_MainTex_TexelSize.y < 0)
			 o.uv2.y = 1.0 - o.uv2.y;
		#endif

		return o;
	} 
	
	float circle(float2 p, float center, float radius, float smoothIn, float smoothOut)
	{
		float c = length(p - center) - radius;
		return smoothstep(c - smoothOut, c + smoothIn, radius);
	}

	half4 frag(v2f i) : SV_Target {
		
		half4 screen = tex2D (_MainTex, i.uv);
		half mask = circle(i.uv, 0.5, _Intensity, _Smoothness, 0);

		fixed4 screeMask = screen * mask;

		return lerp(screen, screeMask, mask);
	}

	ENDCG 
	
Subshader {
 Pass {
	  ZTest Always Cull Off ZWrite Off

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      ENDCG
  }
}

Fallback off	
} 
