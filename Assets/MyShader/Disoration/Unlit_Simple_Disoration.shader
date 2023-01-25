Shader "Moein/Unlit/Simple_Disoration"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
    {
    }
    SubShader
    {
        Tags {"RenderType"="Transparent"}
        
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
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
