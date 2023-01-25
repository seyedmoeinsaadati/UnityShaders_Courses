Shader "Moein/Unlit/Simple_Disoration"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
    {
        [Enum(ON, 1, OFF, 0)]
        _ZWrite("Z Write", Float) = 1
        
        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp("Blending Operation", Float) = 1

        [Header(Blending)]
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend("Soruce Factor", Float) = 1

        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend("Destination Factor", Float) = 1
    }
    SubShader
    {
        Tags {"RenderType"="Transparent" "Queue" = "Transparent"}
        ZWrite [_ZWrite]
        Blend [_SrcBlend] [_DstBlend]
        BlendOp [_BlendOp]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "Assets/MyShader/utils.cginc"

            struct appdata
            {
                float3 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 tangent : TANGENT;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float3 vNormalWs : TEXCOORD2;
                float3 vTangentUWs : TEXCOORD3;
                float3 vTangentVWs : TEXCOORD4;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);  
                o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return (1,1,1,1);
            }
            ENDCG
        }
    }
}
