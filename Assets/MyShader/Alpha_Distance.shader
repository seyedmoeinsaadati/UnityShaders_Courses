Shader "Moein/Unlit/Alpha_Disitance"
{
    Properties
    {
        _MainTex("Main Text", 2D) = "black"{}
        _CameraOffset("Cmaera Offset", Float) = 1

        [Enum(ON, 1, OFF, 0)]
        _ZWrite("Z Write", Float)  = 1
        [KeywordEnum(Less, Less, Greater,Greater,LEqual,LEqual,GEqual,GEqual,Equal,Equal,NotEqual,NotEqual,Always,Always)]
        _ZTest("Z Test", Int)  = 1
        [Header(Blending)]
        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp("Blending Operation", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend("Soruce Factor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend("Destination Factor", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue"= "Transparent"}


        ZWrite [_ZWrite]
        ZTest [_ZTest]
        Blend [_SrcBlend] [_DstBlend]
        BlendOp [_BlendOp]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float depth : DEPTH;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _CameraOffset;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.depth = length(UnityObjectToViewPos(v.vertex));
                return o;
            }
            
            fixed4 frag (v2f i) : SV_TARGET
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a = 1-lerp(0, 1, i.depth / _CameraOffset);
                return col;
            }
            ENDCG
        }
    }
}
