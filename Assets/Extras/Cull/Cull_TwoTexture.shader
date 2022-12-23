Shader "TutorialShaders/CullTwoTexture"
{
    Properties
    {
        _BackTex("Back Texture", 2D) = "white"{}
        _FrontTex("Front Texture", 2D) = "white"{}

        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull("Cull", Float) = 0
    }
    SubShader
    {
        Tags { }
        Cull [_Cull]

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
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _FrontTex;
            float4 _FrontTex_ST;
            sampler2D _BackTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _FrontTex);
                return o;
            }

            fixed4 frag (v2f i, bool face : SV_IsFrontFace) : SV_Target
            {
                fixed4 colFront = tex2D(_FrontTex, i.uv);
                fixed4 colBack = tex2D(_BackTex, i.uv);
                return face ? colFront : colBack;
            }
            ENDCG
        }
    }
}
