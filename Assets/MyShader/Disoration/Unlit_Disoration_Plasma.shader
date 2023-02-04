// NOTE: it's campatiable with OpenGL and dont' use with DirectX
Shader "Moein/Disoration/Plasma"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
	{
        _Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}

        _ScaleX("Scale X", Range(0, 100)) = 10
        _ScaleY("Scale Y", Range(0, 100)) = 10

        [Space(20)]
        [Header(Plasma Fields)]
        [Space(10)]
        _Speed("Speed", Float) = 10
		_Scale1("Vertical Scale", Float) = 2
		_Scale2("Horizontal Scale", Float) = 2
		_Scale3("Diagonal Scale", Float) = 2
		_Scale4("Circular Scale", Float) = 2

        [Space(10)]
        [Header(Blending)]
        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp("Blending Operation", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend("Soruce Factor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend("Destination Factor", Float) = 1

	}
	SubShader
    {
        // Draw after all opaque geometry
        Tags { "Queue" = "Transparent" }
        Blend [_SrcBlend] [_DstBlend]
        BlendOp [_BlendOp]

        // Grab the screen behind the object
        GrabPass{}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Assets/MyShader/utils.cginc"

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
            float4 _Color;

            float _Speed, _ScaleX, _ScaleY;
			float _Scale1,_Scale2,_Scale3,_Scale4;

            v2f vert(appdata v) {
				 
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvGrab = ComputeGrabScreenPos(o.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvNoise = v.uv;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float plasmaValue = plasma(i.uvNoise, _Time.x * _Speed, _Scale1, _Scale2, _Scale3, _Scale4);
				float2 offset = plasmaValue * _GrabTexture_TexelSize.xy;
                offset.x *= _ScaleX;
                offset.y *= _ScaleY;
				i.uvGrab.xy = offset * i.uvGrab.z + i.uvGrab.xy;

                fixed4 col = tex2Dproj(_GrabTexture, i.uvGrab);
				fixed4 tint = tex2D(_MainTex, i.uv) * _Color;

                // debug mode: render plasma color
                // tint = plasmaValue * _Color;
                
				col *= tint;
                return col;
            }
            ENDCG
        }

    }
}
