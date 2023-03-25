Shader "Unlit/sample_sincos2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Rotation Speed", Range(0, 3)) = 1

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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Speed;
            
            void Unity_Rotate_Degrees_float (float2 UV, float2 Center, float Rotation,out float2 Out)
            {
                Rotation = Rotation * (UNITY_PI/180.0f);
                UV -= Center;
                float s = sin(Rotation);
                float c = cos(Rotation);
                float2x2 rMatrix = float2x2(c, -s, s, c);
                rMatrix *= 0.5;
                rMatrix += 0.5;
                rMatrix = rMatrix * 2 - 1;
                UV.xy = mul(UV.yx, rMatrix);
                UV += Center;
                Out = UV;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                i.uv.x -= .5;
                i.uv.y -= .5;
                float r = length(i.uv) * 2;
                float a = atan(i.uv.y / i.uv.x);
                
                float f = abs(cos(a*30));
                fixed4 col = smoothstep(f,f+0.1,r);

                return col;
            }
            ENDCG
        }
    }
}
