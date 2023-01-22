Shader "Moein/Unlit/Alpha_Disitance"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1)
        _MainTex("Main Text", 2D) = "black"{}
        _CameraOffset("Camera Min", Float) = 200
        _Smoothness("Smooth", Range(0, 1)) = 1

        [Enum(ON, 1, OFF, 0)]
        _ZWrite("Z Write", Float)  = 0
        [KeywordEnum(Less, Less, Greater,Greater,LEqual,LEqual,GEqual,GEqual,Equal,Equal,NotEqual,NotEqual,Always,Always)]
        _ZTest("Z Test", Int)  = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue"= "Transparent"}

        ZWrite [_ZWrite]
        ZTest [_ZTest]
        Blend SrcAlpha OneMinusSrcAlpha

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
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _CameraOffset;
            float _Smoothness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_TARGET
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                float depth = (i.vertex.z / i.vertex.w) * _CameraOffset;
                col.a *= smoothstep(0, _Smoothness, 1-depth);

                return col;
            }
            ENDCG
        }
    }
}
