Shader "Moein/Unlit/ShowDepth"
{
    Properties
    {
        [Toggle]
        _Reverse ("Reverse Z", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _REVERSE_OFF _REVERSE_ON
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float depth : DEPTH;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.depth = length(UnityObjectToViewPos(v.vertex));
                return o;
            }
            
            fixed4 frag (v2f i) : SV_TARGET
            {
                #if _REVERSE_OFF
                return lerp(0, 1, i.depth / (_ProjectionParams.z - _ProjectionParams.y));
                #elif _REVERSE_ON
                return 1-lerp(0, 1, i.depth / (_ProjectionParams.z - _ProjectionParams.y));
                #endif
            }
            ENDCG
        }
    }
}
