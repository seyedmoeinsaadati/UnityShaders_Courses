Shader "Moein/ImageEffect/DistorationNoise"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TextureIntensity("Texture Intensity", Float) = 0
        _Tiling ("Tiling (Scale: XY, Offset: ZW)", Vector) = (1,1,0,0)
        _MatrixValue ("Matrix", Vector) = (1,1,0,0)

        _Rotate("Rotation", Range(0, 360)) = 0

        _Color("Color", Color) = (1,1,1,1)

        _Value1("_Value1", Float) = 0
        _Value2("_Value2", Float) = 0
        _Value3("_Value3", Float) = 0
        _Value4("_Value4", Float) = 0
        _Value5("_Value5", Float) = 0
        
        // _GradientColorTop("Color Top", Color) = (0,0,0,0)
        // _GradientColorBottom("Color Bottom", Color) = (0,0,0,0)
        // _GradientColorRight("Color Right", Color) = (0,0,0,0)
        // _GradientColorLeft("Color Left", Color) = (0,0,0,0)
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            half4 _Tiling;
            float _Rotate, _TextureIntensity;
            float4 _MatrixValue;

            // float4 _GradientColorTop;
            // float4 _GradientColorBottom;
            // float4 _GradientColorRight;
            // float4 _GradientColorLeft;
            float4 _Color;

            float _Value1;
            float _Value2;
            float _Value3;
            float _Value4;
            float _Value5;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color =  tex2D(_MainTex, frac(i.uv)) * _TextureIntensity;

                float2 rotatedUv;
                rotate(i.uv, float2(.5,.5), _Rotate, rotatedUv);
                fixed4 tintColor = _Color; // lerp(_GradientColorBottom, _GradientColorTop, rotatedUv.x);
                // tintColor += lerp(_GradientColorLeft, _GradientColorRight, rotatedUv.y);

                i.uv *= _Tiling.xy;
                i.uv += _Tiling.zw;
                
                // Tile the space
                float2 n, q;
                float2 st = frac(i.uv);
                float2x2 m = _MatrixValue;
                float2 u = st - .5;
                float d = dot(u,u), s = _Value1, t = _Time.y, o;
                for	(float j = 0.0; j < 4.0; j++){
                    u = mul(m, u);
                    n = mul(m, n);
                    q = u * s + t * 4.0 + sin(t * 2.0 - d * 6.0) * 10.0 + j + n;
                    o += dot(cos(q) / s, float2(2,2));
                    n -= sin(q);
                    s *= .576;
                }
                color = o * tintColor;
                return color;
            }
             
            ENDCG
        }
    }
}
