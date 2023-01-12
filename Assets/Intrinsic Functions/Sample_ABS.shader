Shader "Unlit/sample_ABS"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // let's add a property to rotate the UV
        // _Rotation ("Rotation", Range(0, 360)) = 0

        _UVOffset("UV Offset", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        

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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half4 _UVOffset;
            // float _Rotation;
            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // let's calculate the absolute value of UV
                float u = abs(i.uv.x - _UVOffset.x);
                float v = abs(i.uv.y - _UVOffset.y);
                

                fixed col = tex2D(_MainTex, float2(u, v));

                return col;
            }
            ENDCG
        }
    }
}
