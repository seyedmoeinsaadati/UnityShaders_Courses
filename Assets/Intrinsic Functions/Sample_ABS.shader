Shader "Unlit/sample_abs"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _UVOffset("UV Offset", Vector) = (0, 0, 0 ,0)

        // let's add a property to rotate the UV
        _Rotation ("Rotation", Range(0, 360)) = 0

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
            float4 _UVOffset;
            float _Rotation;

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
                // let's calculate the absolute value of UV
                float u = abs(i.uv.x - _UVOffset.x);
                float v = abs(i.uv.y - _UVOffset.y);

                // let's generate new UV coordinates for the texture
                float2 uv = 0;
                Unity_Rotate_Degrees_float(float2(u,v), _UVOffset.z, _Rotation, uv);
                fixed4 col = tex2D(_MainTex, uv);

                return col;
            }
            ENDCG
        }
    }
}
