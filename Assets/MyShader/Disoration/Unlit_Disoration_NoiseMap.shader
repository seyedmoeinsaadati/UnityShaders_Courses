// NOTE: it's campatiable with OpenGL and dont' use with DirectX
Shader "Moein/Disoration/NoiseMap"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
	{
        _Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}

        [Space(10)]
        [Header(Noise Fields)]
        _NoiseMap ("Noise Map", 2D) = "bump" {}
        _ScaleU ("Scale U", Float) = 1
        _ScaleV ("Scale V", Float) = 1
        _SpeedU ("Speed U", Float) = 1
        _SpeedV ("Speed V", Float) = 1

        [Space(10)]
        [Header(Blending)]
        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp("Blending Operation", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend("Soruce Factor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend("Destination Factor", Float) = 1

        [Space(10)]
        [Header(Stencil)]
        [Enum(ON, 1, OFF, 0)]
        _ZWrite("Z Write", Float)  = 1
        _ColorMask("ColorMask", Int)  = 15

        _StencilRef ("Stencil ID", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)]
        _StencilComp ("Stencil Comparison", Float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)]
		_StencilOp ("Stencil Operation", Float) = 0

	}
	SubShader
    {
        // Draw after all opaque geometry
        Tags { "Queue" = "Transparent" }
        ZWrite [_ZWrite]
        ColorMask [_ColorMask]
        Blend [_SrcBlend] [_DstBlend]
        BlendOp [_BlendOp]

        Stencil {
            Ref [_StencilRef]
            Comp [_StencilComp]
            Pass [_StencilOp]
        }

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
                float2 uvNoise : TEXCOORD2;
				float4 vertex : SV_POSITION;
			};

			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			sampler2D _MainTex;
			float4 _MainTex_ST;
            sampler2D _NoiseMap;
			float4 _NoiseMap_ST;
            float4 _Color;
            float _ScaleU, _ScaleV, _SpeedU, _SpeedV;

            v2f vert(appdata v) {
				 
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvGrab = ComputeGrabScreenPos(o.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvNoise = TRANSFORM_TEX(v.uv, _NoiseMap);
                o.uvNoise.x += _Time.x * _SpeedU;
                o.uvNoise.y += _Time.x * _SpeedV;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
				half2 noise = UnpackNormal(tex2D(_NoiseMap, i.uvNoise)).rg;
                noise.x *= _ScaleU;
                noise.y *= _ScaleV;
				float2 offset = noise * _GrabTexture_TexelSize.xy;
				i.uvGrab.xy = offset * i.uvGrab.z + i.uvGrab.xy;

                fixed4 col = tex2Dproj(_GrabTexture, i.uvGrab);
				fixed4 tint = tex2D(_MainTex, i.uv) * _Color;
				col *= tint;
                return col;
            }
            ENDCG
        }

    }
}
