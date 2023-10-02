Shader "Unlit/SqurePattern"
{
    Properties
    {
        _Scale("Scale", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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

            float _Scale;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.uv-= float2(0.5,0.5);
                
                float2 scaled_uv = i.uv * _Scale;
                float2 tile = frac(scaled_uv);
                float tile_dist = min(min(tile.x, 1.0 - tile.x), min(tile.y, 1.0 - tile.y));
                float square_dist = length(floor(scaled_uv));
                
                float edge = sin(_Time.z - square_dist * 20.0);
                edge = (edge * edge) % (edge / edge);
                
                float value = lerp(tile_dist, 1.0-tile_dist, step(1.0, edge));
                edge = pow(abs(1.0-edge), 2.2) * 1.0; // gradient_cube
                
                value = smoothstep(edge - 1.0, edge, 0.2 * value);
                value += square_dist * .01; // radial_intense
                
                // float4 color = float4(pow(value, 1.0), pow(value, 1.0), pow(value, 1.0), pow(value, 1.0)); 
                float4 color = float4(value, value, value,1); 

                return color;
            }
            ENDCG
        }
    }
}
