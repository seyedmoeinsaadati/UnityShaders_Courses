Shader "Moein/ImageEffect/Scale"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tiling ("Tilling", Vector) = (1,1,0,0)
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
            float4 _Tiling;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float2 random(float2 p ) {
                return frac(sin(float2(dot(p,float2(127.1,311.7)),dot(p,float2(269.5,183.3))))*43758.5453);
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = 0;// tex2D(_MainTex, frac(i.uv));

                float2 st = i.uv;
                // st.x *= u_resolution.x/u_resolution.y;

                // Scale
                st *= 20.8;

                // Tile the space
                float2 i_st = floor(st);
                float2 f_st = frac(st);

                float m_dist = 1.;  // minimum distance

                for (int y= -1; y <= 1; y++) {
                    for (int x= -1; x <= 1; x++) {
                        // Neighbor place in the grid
                        float2 neighbor = float2(x,y);

                        // Random position from current + neighbor place in the grid
                        float2 p = random(i_st + neighbor);

                        // Animate the point
                        p = 0.5 + 0.5*sin(_Time.x + 6.747*p);

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
                color += 1.-step(.02, m_dist);

                return color;
            }
             
            ENDCG
        }
    }
}
