Shader "Holistic/Glass"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_ScaleUV ("Scale", Range(1 , 20)) = 1
	}
	SubShader
    {
        // Draw after all opaque geometry
        Tags { "Queue" = "Transparent" }

        // Grab the screen behind the object
        GrabPass{}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 uvGrab : TEXCOORD1;
				float2 uvBump : TEXCOORD2;
				float4 vertex : SV_POSITION;
			};

			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _ScaleUV;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvGrab = ComputeGrabScreenPos(o.vertex);
				o.uv = TRANSFORM_TEX(v.uv,_MainTex);
				o.uvBump = TRANSFORM_TEX(v.uv,_BumpMap);

				// o.uvGrab.y = sin( _SinTime.z);

				o.uvGrab.xy = _ScaleUV * o.uvGrab.z + o.uvGrab.xy;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
				// half2 bump = UnpackNormal(tex2D(_BumpMap, i.uvBump)).rg;
				// float2 offset = bump * _ScaleUV * _GrabTexture_TexelSize.xy;
				// i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;

                fixed4 col = tex2Dproj(_GrabTexture, i.uvGrab);
				fixed4 tint = tex2D(_MainTex, i.uv);
				col *= tint;
                return col;
            }
            ENDCG
        }

    }
}
