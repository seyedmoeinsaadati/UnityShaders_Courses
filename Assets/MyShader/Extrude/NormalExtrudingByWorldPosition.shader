Shader "Holistic/NormalExtrudingByWorldPosition"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Amount ("Extrude", Float) = 0
        _Radius ("Radius", Float) = 0
        _Anchor ("Anchor position", Vector) = (0,0,0,0)
	}
	SubShader
    {
        Cull Off
		CGPROGRAM
			#pragma surface surf Lambert vertex:vert

			struct Input{
				float2 uv_MainTex;
			};

			struct appdata {
				float4 vertex: POSITION;
				float3 normal: NORMAL;
				float4 texcoord: TEXCOOD0;
			};

			float _Amount, _Radius;
            float4 _Anchor;

			void vert (inout appdata v){

                float4 worldVertexPos = mul(unity_ObjectToWorld, v.vertex);
            
                float3 worldVector = worldVertexPos - _Anchor.xyz;
                float len = length(worldVector);

                float weight = 1 - smoothstep(_Radius, _Radius * 2, len);
                v.vertex.xyz += v.normal * weight * _Amount;

                // float playerToVertexDist = 1 - saturate(length(worldVertexPos - _Anchor.xyz));
                // v.vertex.xyz += playerToVertexDist * weight;
                // v.vertex.xyz += v.normal * weight;
			}

			sampler2D _MainTex;
			void surf(Input IN, inout SurfaceOutput o){
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			}
		ENDCG
    }
	Fallback "Diffuse"
}