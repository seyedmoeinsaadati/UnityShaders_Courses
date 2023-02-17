Shader "Holistic/Simple_Outline"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OutlineColor ("Outline Color", COLOR) = (1,1,1,1)
		_Outline("Outline Width", Range(.002, .1)) = .005
	}
	SubShader
    {

		ZWrite off
		CGPROGRAM
			#pragma surface surf Lambert vertex:vert

			struct Input{
				float2 uv_MainTex;
			};

			float _Outline;
			float4 _OutlineColor;
			void vert (inout appdata_full v){
				v.vertex.xyz += v.normal * _Outline;
			}

			sampler2D _MainTex;
			void surf(Input IN, inout SurfaceOutput o){
				o.Emission = _OutlineColor.rgb;
			}
		ENDCG

		ZWrite on
		CGPROGRAM
			#pragma surface surf Lambert

			struct Input{
				float2 uv_MainTex;
			};

			sampler2D _MainTex;
			void surf(Input IN, inout SurfaceOutput o){
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
			}
		ENDCG

    }
	Fallback "Diffuse"
}