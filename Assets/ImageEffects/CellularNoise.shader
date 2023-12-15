Shader "Moein/ImageEffect/CellularNoise"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TextureIntensity("Texture Intensity", Float) = 0
        _Tiling ("Tiling (Scale: XY, Offset: ZW)", Vector) = (1,1,0,0)

        _Chaos("Chaos", Float) = 10
        _Speed("Speed", Float) = 10
        _Smoothness("Smoothness", Range(0, 2)) = 1
        _Rotate("Rotation", Range(0, 360)) = 0

        _GradientColorTop("Color Top", Color) = (0,0,0,0)
        _GradientColorBottom("Color Bottom", Color) = (0,0,0,0)
        _GradientColorRight("Color Right", Color) = (0,0,0,0)
        _GradientColorLeft("Color Left", Color) = (0,0,0,0)
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
            float _Chaos, _Speed, _Smoothness, _Rotate, _TextureIntensity;

            float4 _GradientColorTop;
            float4 _GradientColorBottom;
            float4 _GradientColorRight;
            float4 _GradientColorLeft;

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
                fixed4 tintColor = lerp(_GradientColorBottom, _GradientColorTop, rotatedUv.x);
                tintColor += lerp(_GradientColorLeft, _GradientColorRight, rotatedUv.y);

                i.uv *= _Tiling.xy;
                i.uv += _Tiling.zw;
                
                // Tile the space
                float2 i_st = floor(i.uv);
                float2 f_st = frac(i.uv);

                float m_dist = 1.;  // minimum distance

                for (int y= -1; y <= 1; y++) {
                    for (int x= -1; x <= 1; x++) {
                        // Neighbor place in the grid
                        float2 neighbor = float2(x,y);

                        // Random position from current + neighbor place in the grid
                        float2 p = random(i_st + neighbor);

                        // Animate the point
                        p = 0.5 + 0.5*sin(_Speed * _Time.x + _Chaos*p);

                        // Vector between the pixel and the point
                        float2 diff = neighbor + p - f_st;

                        // Distance to the point
                        float dist = length(diff);

                        // Keep the closer distance
                        m_dist = min(m_dist, dist);
                    }
                }

                // Draw the min distance (distance field)
                color += m_dist;

                // Draw cell center
                color += _Smoothness-step(.0, m_dist);
                color *= tintColor;

                // Draw grid
                // color.r += step(.98, f_st.x) + step(.98, f_st.y);

                // Show isolines
                // color -= step(.7,abs(sin(27.0*m_dist)))*.5;
                return color;
            }
             
            ENDCG
        }
    }
}
